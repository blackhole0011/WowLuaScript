-- Рома Чит 228 · Alpha · самостоятельная клиентская версия.
-- Запускается целиком в клиентской Lua-среде (executor); установка в Studio не нужна.
-- Ключ: ??? · меню: RightShift · подъём: H · Phase: G · телефон: круг.
-- WallHack: прозрачность карты; ESP: отдельная подсветка. FullBright и Fly.
-- Скорость/телепорт/Fly зависят от игры. Подъём не обеспечивает бессмертие.
-- Поддержка Real/Delta определяется доступными API; живой запуск не проверялся.
-- Не загружает внешний код и не вызывает игровые RemoteEvent/RemoteFunction.

local Capabilities = {
  readfile = type(readfile) == "function" and readfile or nil,
  writefile = type(writefile) == "function" and writefile or nil,
  isfile = type(isfile) == "function" and isfile or nil,
  makefolder = type(makefolder) == "function" and makefolder or nil,
  isfolder = type(isfolder) == "function" and isfolder or nil,
  delfile = type(delfile) == "function" and delfile or nil,
  setclipboard = type(setclipboard) == "function" and setclipboard or
    (type(toclipboard) == "function" and toclipboard or nil),
}
if not Capabilities.setclipboard and type(clipboard) == "table" and type(clipboard.set) == "function" then
  Capabilities.setclipboard = function(text) return clipboard.set(text) end
end

local Config = (function()
-- Standalone client menu display settings.
-- The local key screen is a convenience gate, not secure access control.
local Config = {
	DefaultLanguage = "ru",
	DefaultTheme = "blackviolet",
	DefaultHotkey = "RightShift",
	DefaultLiftHotkey = "H",
	DefaultPhaseHotkey = "G",
	DiscordUrl = "https://dsc.gg/nobs",
	ThemeOrder = { "blackviolet", "violet", "midnight", "rose", "ocean", "emerald", "amber", "custom" },
	ColorPalette = {
		{ id = "violet", color = Color3.fromRGB(150, 80, 255) },
		{ id = "red", color = Color3.fromRGB(255, 70, 82) },
		{ id = "pink", color = Color3.fromRGB(255, 139, 190) },
		{ id = "orange", color = Color3.fromRGB(255, 153, 54) },
		{ id = "yellow", color = Color3.fromRGB(255, 220, 73) },
		{ id = "green", color = Color3.fromRGB(84, 221, 135) },
		{ id = "cyan", color = Color3.fromRGB(72, 218, 235) },
		{ id = "blue", color = Color3.fromRGB(81, 145, 255) },
		{ id = "white", color = Color3.fromRGB(245, 245, 250) },
		{ id = "gray", color = Color3.fromRGB(125, 125, 140) },
		{ id = "black", color = Color3.fromRGB(8, 7, 12) },
		{ id = "magenta", color = Color3.fromRGB(227, 72, 244) },
	},
	Languages = {
		{ id = "ru", name = "Русский" },
		{ id = "en", name = "English" },
		{ id = "es", name = "Español" },
	},
	Themes = {
		blackviolet = {
			name = "Black Violet",
			bg = Color3.fromRGB(8, 7, 12),
			surface = Color3.fromRGB(15, 12, 24),
			raised = Color3.fromRGB(26, 20, 40),
			accent = Color3.fromRGB(150, 80, 255),
			accent2 = Color3.fromRGB(93, 42, 185),
			text = Color3.fromRGB(244, 239, 255),
			muted = Color3.fromRGB(159, 147, 181),
			stroke = Color3.fromRGB(52, 37, 75),
		},
		violet = {
			name = "Violet",
			bg = Color3.fromRGB(17, 12, 30),
			surface = Color3.fromRGB(26, 19, 43),
			raised = Color3.fromRGB(38, 28, 60),
			accent = Color3.fromRGB(166, 109, 255),
			accent2 = Color3.fromRGB(109, 67, 226),
			text = Color3.fromRGB(245, 240, 255),
			muted = Color3.fromRGB(176, 161, 202),
			stroke = Color3.fromRGB(69, 49, 97),
		},
		midnight = {
			name = "Midnight",
			bg = Color3.fromRGB(10, 16, 29),
			surface = Color3.fromRGB(18, 27, 45),
			raised = Color3.fromRGB(27, 39, 61),
			accent = Color3.fromRGB(124, 151, 255),
			accent2 = Color3.fromRGB(66, 88, 200),
			text = Color3.fromRGB(238, 244, 255),
			muted = Color3.fromRGB(153, 171, 202),
			stroke = Color3.fromRGB(45, 63, 94),
		},
		rose = {
			name = "Rose",
			bg = Color3.fromRGB(28, 13, 26),
			surface = Color3.fromRGB(43, 21, 38),
			raised = Color3.fromRGB(60, 30, 52),
			accent = Color3.fromRGB(255, 135, 194),
			accent2 = Color3.fromRGB(190, 72, 150),
			text = Color3.fromRGB(255, 240, 247),
			muted = Color3.fromRGB(209, 162, 189),
			stroke = Color3.fromRGB(99, 46, 78),
		},
		ocean = {
			name = "Ocean",
			bg = Color3.fromRGB(10, 24, 31),
			surface = Color3.fromRGB(16, 36, 46),
			raised = Color3.fromRGB(22, 50, 61),
			accent = Color3.fromRGB(87, 221, 230),
			accent2 = Color3.fromRGB(42, 137, 184),
			text = Color3.fromRGB(232, 253, 255),
			muted = Color3.fromRGB(146, 190, 202),
			stroke = Color3.fromRGB(34, 77, 91),
		},
		emerald = {
			name = "Emerald",
			bg = Color3.fromRGB(7, 18, 15),
			surface = Color3.fromRGB(12, 29, 24),
			raised = Color3.fromRGB(20, 43, 35),
			accent = Color3.fromRGB(81, 224, 160),
			accent2 = Color3.fromRGB(35, 142, 114),
			text = Color3.fromRGB(235, 255, 246),
			muted = Color3.fromRGB(145, 186, 167),
			stroke = Color3.fromRGB(37, 77, 61),
		},
		amber = {
			name = "Amber",
			bg = Color3.fromRGB(22, 15, 7),
			surface = Color3.fromRGB(35, 25, 13),
			raised = Color3.fromRGB(50, 36, 20),
			accent = Color3.fromRGB(255, 188, 75),
			accent2 = Color3.fromRGB(202, 115, 37),
			text = Color3.fromRGB(255, 247, 229),
			muted = Color3.fromRGB(194, 169, 129),
			stroke = Color3.fromRGB(88, 61, 31),
		},
		custom = {
			name = "Custom",
			bg = Color3.fromRGB(8, 7, 12),
			surface = Color3.fromRGB(15, 12, 24),
			raised = Color3.fromRGB(26, 20, 40),
			accent = Color3.fromRGB(150, 80, 255),
			accent2 = Color3.fromRGB(93, 42, 185),
			text = Color3.fromRGB(244, 239, 255),
			muted = Color3.fromRGB(159, 147, 181),
			stroke = Color3.fromRGB(52, 37, 75),
		},
	},
	Translations = {
		ru = {
			accessTitle = "ДОСТУП К МЕНЮ",
			accessBody = "Введи ключ. Проверка локальная, без защиты от обхода.",
			keyPlaceholder = "Ключ доступа",
			unlock = "Открыть меню",
			wrongKey = "Неверный ключ. Попробуй ещё раз.",
			notAuthorized = "Доступ к панели не открыт.",
			serverUnavailable = "Среда выполнения недоступна.",
			loading = "Подключение…",
			ready = "ГОТОВО К РАБОТЕ",
			titleSubtitle = "ALPHA • КЛИЕНТСКОЕ МЕНЮ",
			visuals = "Визуал",
			movement = "Персонаж",
			players = "Игроки",
			settings = "Настройки",
			wallhack = "Видеть сквозь стены",
			wallhackHint = "Делает детали карты прозрачными локально, отдельно от ESP. Terrain не поддерживается.",
			wallTransparency = "Прозрачность стен",
			fullbright = "Полное освещение",
			fullbrightHint = "Осветляет мир на клиенте. Настройки возвращаются при отключении.",
			esp = "Подсветка игроков",
			espHint = "Цветные силуэты других игроков, видимые сквозь стены.",
			fillOpacity = "Непрозрачность заливки",
			outlineOpacity = "Непрозрачность контура",
			espColor = "Цвет подсветки",
			speed = "Своя скорость",
			speedHint = "Меняет WalkSpeed на клиенте. Сервер может вернуть свою скорость.",
			speedValue = "Скорость, студ/с",
			fly = "Полёт",
			flyHint = "ПК: удерживай Space/E — вверх, Ctrl/Q — вниз. Кнопки «Вверх/Вниз»: нажми для старта, ещё раз — стоп.",
			flySpeed = "Скорость полёта",
			flyUp = "Вверх",
			flyDown = "Вниз",
			lift = "Подъём персонажа",
			liftHint = "Меняет HipHeight на клиенте. Не даёт бессмертия и не отделяет хитбокс от тела.",
			liftHeight = "Высота подъёма, студы",
			liftHotkey = "Клавиша подъёма",
			liftHotkeyHint = "Включает и выключает подъём, когда ты не вводишь текст.",
			changeLiftHotkey = "Изменить клавишу подъёма",
			resetLiftHotkey = "Сбросить на H",
			noclip = "Ноуклип",
			noclipHint = "Отключает столкновения на клиенте, включая пол. Сервер может исправлять положение.",
			god = "Подъём +4 студа",
			godHint = "Только HipHeight +4. Не даёт бессмертия и не поднимает хитбокс отдельно от тела.",
			thirdPerson = "Вид от третьего лица",
			thirdPersonHint = "Фиксирует расстояние камеры; угол обзора настраивается отдельно.",
			cameraDistance = "Расстояние камеры",
			fieldOfView = "Угол обзора",
			teleport = "Телепортация",
			teleportHint = "Перемещает к выбранному игроку на этом сервере.",
			refresh = "Обновить список",
			noPlayers = "Других игроков пока нет.",
			selectPlayer = "Выбери игрока",
			teleportTo = "Телепортироваться",
			theme = "Тема оформления",
			statusPanel = "Окно состояния",
			statusPanelHint = "Всегда видна при включении; можно двигать и закреплять. Кнопки и ползунки связаны с основным меню.",
			statusTitle = "АКТИВНЫЕ ФУНКЦИИ",
			customTheme = "Своя тема",
			customThemeHint = "Любой цвет: редактируй фон и градиент через HSV или HEX.",
			customBackground = "Цвет фона",
			customAccent = "Первый цвет градиента",
			customAccent2 = "Второй цвет градиента",
			saveCustomTheme = "Применить свою тему",
			customSaved = "Своя тема применена.",
			themePreview = "Предпросмотр темы",
			colorPalette = "Палитра цветов",
			language = "Язык",
			device = "Тип меню",
			desktop = "ПК",
			mobile = "Мобильный",
			mobileFooter = "Круг: открыть / закрыть",
			hotkey = "Клавиша меню",
			changeHotkey = "Изменить клавишу",
			pressKey = "Нажми клавишу… Esc — отмена",
			hotkeyHint = "Работает в режиме ПК, когда ты не вводишь текст.",
			resetHotkey = "Сбросить на Right Shift",
			resetAll = "Сбросить всё",
			resetDone = "Настройки сброшены.",
			discord = "Наш Discord",
			copyLink = "Скопировать ссылку на Discord",
			copyHint = "Ссылка выделена. На ПК нажми Ctrl+C; на телефоне удерживай текст и выбери «Копировать».",
			clipboardCopied = "Ссылка скопирована.",
			close = "Закрыть",
			back = "Назад",
			on = "ВКЛ",
			off = "ВЫКЛ",
			apply = "Применить",
			invalidNumber = "Введи число в указанном диапазоне.",
			teleportFailed = "Не удалось телепортироваться.",
			characterMissing = "Персонаж ещё не готов. Повтори после появления.",
			rateLimited = "Слишком много запросов. Подожди немного.",
			actionFailed = "Не удалось выполнить локальное действие.",
			success = "Изменения применены.",
			keyAccepted = "Доступ открыт.",
			playerLeft = "Игрок уже покинул сервер.",
			defaultTheme = "Сделать темой по умолчанию",
			themeSaved = "Тема по умолчанию сохранена в локальном файле.",
			themeSavedSession = "Тема выбрана на эту сессию. Среда не поддерживает сохранение в файл.",
			preferenceSaveFailed = "Не удалось записать локальный файл настроек.",
			modeHint = "Мобильный режим показывает круглую кнопку; в режиме ПК используется горячая клавиша.",
			unload = "Выгрузить скрипт",
			unloadHint = "Отключает функции и удаляет окна. Для возврата запусти скрипт снова.",
			resetTheme = "Вернуть чёрно-фиолетовую тему",
			linkTitle = "ССЫЛКА НА DISCORD",
			languageHint = "По умолчанию — русский. Изменения действуют в этой сессии.",
			blockedKey = "Эту клавишу нельзя назначить. Выбери другую.",
			hotkeysConflict = "Клавиша уже назначена другой функции или меню.",
			permissionHint = "Клиентская версия. Работа функций зависит от игры и среды запуска.",
			anyColor = "Любой цвет",
			colorHue = "Тон",
			colorSaturation = "Насыщенность",
			colorValue = "Яркость",
			colorHex = "HEX-цвет",
			colorInvalid = "Введи HEX-цвет: #RGB или #RRGGBB.",
			editColor = "Изменить цвет",
			phase = "Прохождение сквозь стены",
			phaseHint = "Медленно двигает вперёд с автоматическим ноуклипом. Несовместимо с полётом; сервер может вернуть позицию.",
			phaseSpeed = "Скорость прохождения",
			phaseHotkey = "Клавиша прохождения",
			quickAccess = "Быстрый доступ",
			quickAccessHint = "Нажми «В быстрый доступ» под нужной функцией. Окно можно двигать и закреплять.",
			showQuickControl = "В быстрый доступ",
			featureHotkey = "Горячая клавиша функции",
			changeFeatureHotkey = "Назначить клавишу",
			clearFeatureHotkey = "Убрать клавишу",
			hudPin = "Закрепить",
			hudUnpin = "Открепить",
			hudSettings = "Настройки панели",
			hudOnlyBound = "Только с горячей клавишей",
			hudSettingsHint = "Выбери элементы панели. При назначении клавиши функции: Backspace — убрать, Esc — отмена.",
			configurations = "Конфигурации",
			configName = "Название конфигурации",
			createConfig = "Создать конфигурацию",
			loadConfig = "Загрузить конфигурацию",
			overwriteConfig = "Перезаписать конфигурацию",
			deleteConfig = "Удалить конфигурацию",
			configCreated = "Конфигурация создана.",
			configLoaded = "Конфигурация загружена.",
			configUpdated = "Конфигурация перезаписана.",
			configDeleted = "Конфигурация удалена.",
			configSelect = "Выбери конфигурацию.",
			configInvalidName = "Недопустимое название конфигурации.",
			configExists = "Конфигурация с таким названием уже есть.",
			configMissing = "Конфигурация не найдена.",
			configStorageUnavailable = "Среда запуска не поддерживает нужные операции с файлами.",
			configReadFailed = "Не удалось прочитать файл конфигурации.",
			configWriteFailed = "Не удалось записать конфигурацию.",
			configDeleteFailed = "Не удалось удалить конфигурацию.",
			configCorrupt = "Конфигурация повреждена или превышает лимиты.",
			configLimit = "Можно сохранить не больше 50 конфигураций.",
			configNameHint = "От 1 до 48 символов; без слешей, управляющих символов и <>:\"|?*.",
			configApplyFailed = "Не удалось применить конфигурацию.",
			quickFlyVertical = "Полёт: вверх / вниз",
			showFlyVertical = "Показывать кнопки полёта",
		},
		en = {
			accessTitle = "MENU ACCESS",
			accessBody = "Enter your key. This local check can be bypassed.",
			keyPlaceholder = "Access key",
			unlock = "Open menu",
			wrongKey = "Incorrect key. Try again.",
			notAuthorized = "Panel access has not been unlocked.",
			serverUnavailable = "The runtime environment is unavailable.",
			loading = "Connecting…",
			ready = "READY TO USE",
			titleSubtitle = "ALPHA • CLIENT MENU",
			visuals = "Visuals",
			movement = "Character",
			players = "Players",
			settings = "Settings",
			wallhack = "See through walls",
			wallhackHint = "Makes map parts locally transparent, separate from ESP. Terrain is not supported.",
			wallTransparency = "Wall transparency",
			fullbright = "Fullbright",
			fullbrightHint = "Brightens the world on the client. Disabling restores lighting settings.",
			esp = "Player highlights",
			espHint = "Colored silhouettes of other players, visible through walls.",
			fillOpacity = "Fill opacity",
			outlineOpacity = "Outline opacity",
			espColor = "Highlight color",
			speed = "Custom speed",
			speedHint = "Changes WalkSpeed on the client. The server may restore its own speed.",
			speedValue = "Speed, studs/s",
			fly = "Fly",
			flyHint = "PC: hold Space/E up or Ctrl/Q down. Tap Up/Down to start; tap again to stop.",
			flySpeed = "Flight speed",
			flyUp = "Up",
			flyDown = "Down",
			lift = "Character lift",
			liftHint = "Changes HipHeight on the client. Does not grant invulnerability or separate the hitbox from the body.",
			liftHeight = "Lift height, studs",
			liftHotkey = "Lift key",
			liftHotkeyHint = "Toggles character lift while you are not typing.",
			changeLiftHotkey = "Change lift key",
			resetLiftHotkey = "Reset to H",
			noclip = "Noclip",
			noclipHint = "Disables client collisions, including the floor. The server may correct your position.",
			god = "Lift +4 studs",
			godHint = "HipHeight +4 only. Does not grant invulnerability or raise the hitbox separately from the body.",
			thirdPerson = "Third-person view",
			thirdPersonHint = "Locks the camera distance; field of view is adjusted separately.",
			cameraDistance = "Camera distance",
			fieldOfView = "Field of view",
			teleport = "Teleport",
			teleportHint = "Moves you next to a selected player on this server.",
			refresh = "Refresh list",
			noPlayers = "No other players yet.",
			selectPlayer = "Select a player",
			teleportTo = "Teleport",
			theme = "Appearance theme",
			statusPanel = "Status window",
			statusPanelHint = "Always visible when enabled. Drag or pin it; its buttons and sliders stay synced with the main menu.",
			statusTitle = "ACTIVE FEATURES",
			customTheme = "Custom theme",
			customThemeHint = "Any color: edit the background and gradient using HSV or HEX.",
			customBackground = "Background color",
			customAccent = "First gradient color",
			customAccent2 = "Second gradient color",
			saveCustomTheme = "Apply custom theme",
			customSaved = "Custom theme applied.",
			themePreview = "Theme preview",
			colorPalette = "Color palette",
			language = "Language",
			device = "Menu type",
			desktop = "Desktop",
			mobile = "Mobile",
			mobileFooter = "Circle: open / close",
			hotkey = "Menu key",
			changeHotkey = "Change key",
			pressKey = "Press a key… Esc to cancel",
			hotkeyHint = "Works in desktop mode while you are not typing.",
			resetHotkey = "Reset to Right Shift",
			resetAll = "Reset everything",
			resetDone = "Settings reset.",
			discord = "Our Discord",
			copyLink = "Copy Discord link",
			copyHint = "The link is selected. Press Ctrl+C on desktop; on mobile, hold the text and choose Copy.",
			clipboardCopied = "Link copied.",
			close = "Close",
			back = "Back",
			on = "ON",
			off = "OFF",
			apply = "Apply",
			invalidNumber = "Enter a number within the shown range.",
			teleportFailed = "Could not teleport.",
			characterMissing = "Your character is not ready. Try again after spawning.",
			rateLimited = "Too many requests. Wait a moment.",
			actionFailed = "Could not complete the local action.",
			success = "Changes applied.",
			keyAccepted = "Access granted.",
			playerLeft = "The player has left the server.",
			defaultTheme = "Set as default theme",
			themeSaved = "Default theme saved to a local file.",
			themeSavedSession = "Theme set for this session. This environment does not support saving files.",
			preferenceSaveFailed = "Could not write the local settings file.",
			modeHint = "Mobile mode shows a round button; desktop mode uses a keyboard shortcut.",
			unload = "UnLoad Script",
			unloadHint = "Disables features and removes the windows. Run the script again to return.",
			resetTheme = "Restore Black Violet",
			linkTitle = "DISCORD LINK",
			languageHint = "Russian is the default. Changes apply to this session.",
			blockedKey = "That key cannot be assigned. Choose another.",
			hotkeysConflict = "This key is already assigned to another feature or the menu.",
			permissionHint = "Client version. Feature support depends on the game and runtime environment.",
			anyColor = "Any color",
			colorHue = "Hue",
			colorSaturation = "Saturation",
			colorValue = "Brightness",
			colorHex = "HEX color",
			colorInvalid = "Enter a HEX color: #RGB or #RRGGBB.",
			editColor = "Edit color",
			phase = "Phase through walls",
			phaseHint = "Moves slowly forward with automatic noclip. Mutually exclusive with Fly; the server may correct your position.",
			phaseSpeed = "Phase speed",
			phaseHotkey = "Phase key",
			quickAccess = "Quick access",
			quickAccessHint = "Use Show quick control below each feature. Drag or pin this window.",
			showQuickControl = "Show quick control",
			featureHotkey = "Feature hotkey",
			changeFeatureHotkey = "Assign key",
			clearFeatureHotkey = "Clear key",
			hudPin = "Pin",
			hudUnpin = "Unpin",
			hudSettings = "Panel settings",
			hudOnlyBound = "Only with a hotkey",
			hudSettingsHint = "Choose panel controls. While assigning a feature key: Backspace clears it; Esc cancels.",
			configurations = "Configurations",
			configName = "Configuration name",
			createConfig = "Create Config",
			loadConfig = "Load Config",
			overwriteConfig = "Overwrite Config",
			deleteConfig = "Delete Config",
			configCreated = "Configuration created.",
			configLoaded = "Configuration loaded.",
			configUpdated = "Configuration overwritten.",
			configDeleted = "Configuration deleted.",
			configSelect = "Select a configuration.",
			configInvalidName = "Invalid configuration name.",
			configExists = "A configuration with this name already exists.",
			configMissing = "Configuration not found.",
			configStorageUnavailable = "This runtime does not support the required file operations.",
			configReadFailed = "Could not read the configuration file.",
			configWriteFailed = "Could not write the configuration.",
			configDeleteFailed = "Could not delete the configuration.",
			configCorrupt = "The configuration is corrupt or exceeds its limits.",
			configLimit = "You can save up to 50 configurations.",
			configNameHint = "1–48 characters; no slashes, control characters, or <>:\"|?*.",
			configApplyFailed = "Could not apply the configuration.",
			quickFlyVertical = "Fly: up / down",
			showFlyVertical = "Show flight buttons",
		},
		es = {
			accessTitle = "ACCESO AL MENÚ",
			accessBody = "Introduce tu clave. Esta comprobación local se puede omitir.",
			keyPlaceholder = "Clave de acceso",
			unlock = "Abrir menú",
			wrongKey = "Clave incorrecta. Inténtalo de nuevo.",
			notAuthorized = "El acceso al panel no está desbloqueado.",
			serverUnavailable = "El entorno de ejecución no está disponible.",
			loading = "Conectando…",
			ready = "LISTO PARA USAR",
			titleSubtitle = "ALPHA • MENÚ CLIENTE",
			visuals = "Visuales",
			movement = "Personaje",
			players = "Jugadores",
			settings = "Ajustes",
			wallhack = "Ver a través de paredes",
			wallhackHint = "Hace transparentes las piezas del mapa en el cliente, aparte de ESP. No admite Terrain.",
			wallTransparency = "Transparencia de paredes",
			fullbright = "Iluminación total",
			fullbrightHint = "Ilumina el mundo en el cliente. Al desactivarlo, restaura la iluminación.",
			esp = "Resaltado de jugadores",
			espHint = "Siluetas de color de otros jugadores, visibles a través de paredes.",
			fillOpacity = "Opacidad del relleno",
			outlineOpacity = "Opacidad del contorno",
			espColor = "Color del resaltado",
			speed = "Velocidad personalizada",
			speedHint = "Cambia WalkSpeed en el cliente. El servidor puede restablecer su propia velocidad.",
			speedValue = "Velocidad, studs/s",
			fly = "Vuelo",
			flyHint = "PC: mantén Espacio/E para subir o Ctrl/Q para bajar. Toca Subir/Bajar para empezar; otra vez para parar.",
			flySpeed = "Velocidad de vuelo",
			flyUp = "Subir",
			flyDown = "Bajar",
			lift = "Elevación del personaje",
			liftHint = "Cambia HipHeight en el cliente. No da invulnerabilidad ni separa la hitbox del cuerpo.",
			liftHeight = "Altura de elevación, studs",
			liftHotkey = "Tecla de elevación",
			liftHotkeyHint = "Activa y desactiva la elevación mientras no escribes texto.",
			changeLiftHotkey = "Cambiar tecla de elevación",
			resetLiftHotkey = "Restablecer a H",
			noclip = "Noclip",
			noclipHint = "Desactiva las colisiones del cliente, incluido el suelo. El servidor puede corregir tu posición.",
			god = "Elevación +4 studs",
			godHint = "Solo HipHeight +4. No da invulnerabilidad ni eleva la hitbox por separado del cuerpo.",
			thirdPerson = "Vista en tercera persona",
			thirdPersonHint = "Fija la distancia de la cámara; el campo de visión se ajusta por separado.",
			cameraDistance = "Distancia de la cámara",
			fieldOfView = "Campo de visión",
			teleport = "Teletransporte",
			teleportHint = "Te mueve junto a un jugador de este servidor.",
			refresh = "Actualizar lista",
			noPlayers = "Todavía no hay otros jugadores.",
			selectPlayer = "Selecciona un jugador",
			teleportTo = "Teletransportarse",
			theme = "Tema de apariencia",
			statusPanel = "Ventana de estado",
			statusPanelHint = "Siempre visible al activarlo. Arrástralo o fíjalo; sus botones y deslizadores se sincronizan con el menú.",
			statusTitle = "FUNCIONES ACTIVAS",
			customTheme = "Tema personalizado",
			customThemeHint = "Cualquier color: edita el fondo y el degradado con HSV o HEX.",
			customBackground = "Color de fondo",
			customAccent = "Primer color del degradado",
			customAccent2 = "Segundo color del degradado",
			saveCustomTheme = "Aplicar tema personalizado",
			customSaved = "Tema personalizado aplicado.",
			themePreview = "Vista previa del tema",
			colorPalette = "Paleta de colores",
			language = "Idioma",
			device = "Tipo de menú",
			desktop = "PC",
			mobile = "Móvil",
			mobileFooter = "Círculo: abrir / cerrar",
			hotkey = "Tecla del menú",
			changeHotkey = "Cambiar tecla",
			pressKey = "Pulsa una tecla… Esc para cancelar",
			hotkeyHint = "Funciona en modo PC mientras no escribes texto.",
			resetHotkey = "Restablecer a Right Shift",
			resetAll = "Restablecer todo",
			resetDone = "Ajustes restablecidos.",
			discord = "Nuestro Discord",
			copyLink = "Copiar enlace de Discord",
			copyHint = "El enlace está seleccionado. Pulsa Ctrl+C en PC; en el móvil, mantén pulsado el texto y elige Copiar.",
			clipboardCopied = "Enlace copiado.",
			close = "Cerrar",
			back = "Volver",
			on = "SÍ",
			off = "NO",
			apply = "Aplicar",
			invalidNumber = "Introduce un número dentro del intervalo indicado.",
			teleportFailed = "No se pudo completar el teletransporte.",
			characterMissing = "Tu personaje aún no está listo. Inténtalo después de aparecer.",
			rateLimited = "Demasiadas solicitudes. Espera un momento.",
			actionFailed = "No se pudo completar la acción local.",
			success = "Cambios aplicados.",
			keyAccepted = "Acceso concedido.",
			playerLeft = "El jugador ha salido del servidor.",
			defaultTheme = "Establecer como tema predeterminado",
			themeSaved = "Tema predeterminado guardado en un archivo local.",
			themeSavedSession = "Tema elegido para esta sesión. El entorno no permite guardar archivos.",
			preferenceSaveFailed = "No se pudo escribir el archivo local de ajustes.",
			modeHint = "El modo móvil muestra un botón circular; el modo PC usa un atajo de teclado.",
			unload = "Desactivar script",
			unloadHint = "Desactiva las funciones y elimina las ventanas. Ejecuta el script de nuevo para volver.",
			resetTheme = "Restaurar Black Violet",
			linkTitle = "ENLACE DE DISCORD",
			languageHint = "El ruso es el idioma predeterminado. Los cambios se aplican a esta sesión.",
			blockedKey = "No se puede asignar esa tecla. Elige otra.",
			hotkeysConflict = "Esta tecla ya está asignada a otra función o al menú.",
			permissionHint = "Versión cliente. Las funciones dependen del juego y del entorno de ejecución.",
			anyColor = "Cualquier color",
			colorHue = "Tono",
			colorSaturation = "Saturación",
			colorValue = "Brillo",
			colorHex = "Color HEX",
			colorInvalid = "Introduce un color HEX: #RGB o #RRGGBB.",
			editColor = "Editar color",
			phase = "Atravesar paredes",
			phaseHint = "Avanza despacio con noclip automático. No puede usarse con Vuelo; el servidor puede corregir tu posición.",
			phaseSpeed = "Velocidad al atravesar",
			phaseHotkey = "Tecla para atravesar",
			quickAccess = "Acceso rápido",
			quickAccessHint = "Usa Mostrar control rápido bajo cada función. Puedes arrastrar o fijar esta ventana.",
			showQuickControl = "Mostrar control rápido",
			featureHotkey = "Atajo de la función",
			changeFeatureHotkey = "Asignar tecla",
			clearFeatureHotkey = "Quitar tecla",
			hudPin = "Fijar",
			hudUnpin = "Desfijar",
			hudSettings = "Ajustes del panel",
			hudOnlyBound = "Solo con un atajo",
			hudSettingsHint = "Elige los controles. Al asignar un atajo de función: Retroceso lo borra; Esc cancela.",
			configurations = "Configuraciones",
			configName = "Nombre de configuración",
			createConfig = "Crear configuración",
			loadConfig = "Cargar configuración",
			overwriteConfig = "Sobrescribir configuración",
			deleteConfig = "Eliminar configuración",
			configCreated = "Configuración creada.",
			configLoaded = "Configuración cargada.",
			configUpdated = "Configuración sobrescrita.",
			configDeleted = "Configuración eliminada.",
			configSelect = "Selecciona una configuración.",
			configInvalidName = "Nombre de configuración no válido.",
			configExists = "Ya existe una configuración con ese nombre.",
			configMissing = "No se encontró la configuración.",
			configStorageUnavailable = "Este entorno no admite las operaciones de archivos necesarias.",
			configReadFailed = "No se pudo leer el archivo de configuración.",
			configWriteFailed = "No se pudo guardar la configuración.",
			configDeleteFailed = "No se pudo eliminar la configuración.",
			configCorrupt = "La configuración está dañada o supera los límites.",
			configLimit = "Puedes guardar hasta 50 configuraciones.",
			configNameHint = "De 1 a 48 caracteres; sin barras, caracteres de control ni <>:\"|?*.",
			configApplyFailed = "No se pudo aplicar la configuración.",
			quickFlyVertical = "Vuelo: subir / bajar",
			showFlyVertical = "Mostrar botones de vuelo",
		},
	},
}

function Config.t(language, key)
	local dictionary = Config.Translations[language] or Config.Translations[Config.DefaultLanguage]
	return dictionary[key] or Config.Translations.en[key] or key
end

return Config

end)()

local CreateBackend = (function()
-- Local backend for RomaMenu. No server script, remotes, or external code.
-- Optional file APIs access only the menu's fixed settings paths and own folder.
return function(player, Config, caps)
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	local UserInputService = game:GetService("UserInputService")
	local LEGACY_SETTINGS_FILE = "RomaMenu228.settings.json"
	local SETTINGS_FOLDER = "RomaMenu228"
	local FOLDER_SETTINGS_FILE = "RomaMenu228/settings.json"
	local ACCESS_KEY = "joinobozurdsc"
	caps = type(caps) == "table" and caps or {}
	local settingsFile = LEGACY_SETTINGS_FILE
	local settingsPathChecked = false

	local alive = true
	local generation = 0
	local state = {
		unlocked = false,
		speedEnabled = false,
		speed = 16,
		speedApplied = false,
		noclip = false,
		phaseEnabled = false,
		phaseSpeed = 2,
		god = false,
		godApplied = false,
		liftHeight = 4,
		fullBright = false,
		fullBrightElapsed = 0,
		atmospheres = {},
		flyEnabled = false,
		flySpeed = 48,
		flyVertical = 0,
		wallEnabled = false,
		wallAlpha = 0.7,
		wallParts = {},
		wallCharacters = setmetatable({}, { __mode = "k" }),
		wallConnections = {},
		wallPlayerConnections = {},
		wallCameraConnections = {},
		wallEpoch = 0,
		wallRestoring = false,
		collisions = {},
		defaultTheme = Config.DefaultTheme or "violet",
		preferencesLoaded = false,
		lastPreferenceSave = -math.huge,
		lastTeleport = -math.huge,
	}

	local function failure(message)
		return { ok = false, message = message }
	end

	local function finite(value)
		return type(value) == "number" and value == value and value > -math.huge and value < math.huge
	end

	local function customColors(value)
		if type(value) ~= "table" then
			return nil
		end
		local result = {}
		for _, field in ipairs({ "bg", "accent", "accent2" }) do
			local color = value[field]
			if type(color) ~= "table" then
				return nil
			end
			local channels = { color[1] or color.r, color[2] or color.g, color[3] or color.b }
			for index = 1, 3 do
				local channel = channels[index]
				if not finite(channel) or channel < 0 or channel > 255 then
					return nil
				end
				channels[index] = math.floor(channel + 0.5)
			end
			result[field] = channels
		end
		return result
	end

	local function validTheme(value, customTheme)
		return type(value) == "string" and (Config.Themes[value] ~= nil or (value == "custom" and (customTheme or state.customTheme) ~= nil))
	end

	local function selectSettingsFile()
		if settingsPathChecked then return settingsFile end
		settingsPathChecked = true
		if type(caps.makefolder) == "function" and type(caps.isfolder) == "function" then
			local checked, exists = pcall(caps.isfolder, SETTINGS_FOLDER)
			if checked and exists ~= true then
				local created = pcall(caps.makefolder, SETTINGS_FOLDER)
				if created then checked, exists = pcall(caps.isfolder, SETTINGS_FOLDER) end
			end
			if checked and exists == true then settingsFile = FOLDER_SETTINGS_FILE end
		end
		return settingsFile
	end

	local function readPreferencesFile(path)
		if type(caps.isfile) == "function" then
			local checked, exists = pcall(caps.isfile, path)
			if not checked or exists ~= true then return nil end
		end
		local read, content = pcall(caps.readfile, path)
		if not read or type(content) ~= "string" or #content > 4096 then return nil end
		local decoded, data = pcall(function() return HttpService:JSONDecode(content) end)
		if not decoded or type(data) ~= "table" then return nil end
		local colors = customColors(data.customTheme)
		local theme = validTheme(data.defaultTheme, colors) and data.defaultTheme or nil
		if not colors and not theme then return nil end
		return { defaultTheme = theme, customTheme = colors }
	end

	local function loadPreferences()
		if state.preferencesLoaded then
			return
		end
		state.preferencesLoaded = true
		if type(caps.readfile) ~= "function" then
			return
		end
		local path = selectSettingsFile()
		local data = readPreferencesFile(path)
		local migrate = false
		if not data and path ~= LEGACY_SETTINGS_FILE then
			data = readPreferencesFile(LEGACY_SETTINGS_FILE)
			migrate = data ~= nil
		end
		if data then
			state.customTheme = data.customTheme
			state.defaultTheme = data.defaultTheme or state.defaultTheme
			if migrate and type(caps.writefile) == "function" then
				pcall(function()
					caps.writefile(path, HttpService:JSONEncode({ defaultTheme = state.defaultTheme, customTheme = state.customTheme }))
				end)
			end
		end
	end

	local function savePreferences(defaultTheme, colors)
		local now = os.clock()
		if now - state.lastPreferenceSave < 5 then
			return failure("rateLimited")
		end
		state.lastPreferenceSave = now
		local persistent = false
		if type(caps.writefile) == "function" and type(caps.readfile) == "function" then
			local saved = pcall(function()
				local content = HttpService:JSONEncode({ defaultTheme = defaultTheme, customTheme = colors })
				caps.writefile(selectSettingsFile(), content)
			end)
			if not saved then
				return failure("preferenceSaveFailed")
			end
			persistent = true
		end
		state.defaultTheme = defaultTheme
		state.customTheme = colors
		return { ok = true, persistent = persistent, defaultTheme = defaultTheme, customTheme = colors }
	end

	local BRIGHT_PROPERTIES = {
		Brightness = 3, ClockTime = 14, GlobalShadows = false,
		Ambient = Color3.new(1, 1, 1), OutdoorAmbient = Color3.new(1, 1, 1),
		FogStart = 0, FogEnd = 1000000,
	}

	local function restoreAtmosphere(object)
		local original = state.atmospheres[object]
		if original then
			object.Density = original.Density
			object.Haze = original.Haze
			state.atmospheres[object] = nil
		end
	end

	local function brightenAtmosphere(object)
		if object:IsA("Atmosphere") then
			if not state.atmospheres[object] then
				state.atmospheres[object] = { Density = object.Density, Haze = object.Haze }
			end
			object.Density = 0
			object.Haze = 0
		end
	end

	local function applyFullBright()
		if state.fullBright then
			if not state.originalLighting then
				state.fullBrightElapsed = 0
				state.originalLighting = {}
				for property, value in pairs(BRIGHT_PROPERTIES) do
					state.originalLighting[property] = Lighting[property]
					Lighting[property] = value
				end
				state.lightingAdded = Lighting.DescendantAdded:Connect(brightenAtmosphere)
				state.lightingRemoving = Lighting.DescendantRemoving:Connect(restoreAtmosphere)
			end
			for _, object in ipairs(Lighting:GetDescendants()) do
				brightenAtmosphere(object)
			end
		else
			state.fullBrightElapsed = 0
			if state.lightingAdded then state.lightingAdded:Disconnect(); state.lightingAdded = nil end
			if state.lightingRemoving then state.lightingRemoving:Disconnect(); state.lightingRemoving = nil end
			if state.originalLighting then
				for property, value in pairs(state.originalLighting) do Lighting[property] = value end
				state.originalLighting = nil
			end
			for object in pairs(state.atmospheres) do restoreAtmosphere(object) end
		end
	end

	local function updateFullBright(delta)
		if not alive or not state.fullBright or not state.originalLighting then return end
		state.fullBrightElapsed = state.fullBrightElapsed + (finite(delta) and math.max(0, delta) or 0)
		if state.fullBrightElapsed < 0.25 then return end
		state.fullBrightElapsed = 0
		for property, value in pairs(BRIGHT_PROPERTIES) do Lighting[property] = value end
		for object in pairs(state.atmospheres) do
			if object:IsDescendantOf(Lighting) then
				object.Density = 0
				object.Haze = 0
			else
				restoreAtmosphere(object)
			end
		end
	end

	local function restoreWallPart(object)
		local original = state.wallParts[object]
		if original ~= nil then
			object.LocalTransparencyModifier = original
			state.wallParts[object] = nil
		end
	end

	local function excludedFromWall(object)
		if object:IsA("Terrain") then return true end
		local ancestor = object
		while ancestor and ancestor ~= Workspace do
			if state.wallCharacters[ancestor] or ancestor:IsA("Camera") then return true end
			if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then return true end
			ancestor = ancestor.Parent
		end
		return false
	end

	local function applyWallPart(object)
		if not state.wallEnabled or not object:IsA("BasePart") then return end
		if not object:IsDescendantOf(Workspace) or excludedFromWall(object) then
			restoreWallPart(object)
			return
		end
		if state.wallParts[object] == nil then
			state.wallParts[object] = object.LocalTransparencyModifier
		end
		object.LocalTransparencyModifier = math.max(state.wallParts[object], state.wallAlpha)
	end

	local function forgetWallCamera(camera)
		local connections = state.wallCameraConnections[camera]
		if connections then
			for _, connection in ipairs(connections) do connection:Disconnect() end
			state.wallCameraConnections[camera] = nil
		end
	end

	local function watchWallCamera(camera)
		if state.wallCameraConnections[camera] then return end
		for _, object in ipairs(camera:GetDescendants()) do restoreWallPart(object) end
		state.wallCameraConnections[camera] = {
			camera.DescendantAdded:Connect(restoreWallPart),
			camera.DescendantRemoving:Connect(function(object)
				task.defer(function()
					if alive and state.wallEnabled and object.Parent then applyWallPart(object) end
				end)
			end),
		}
	end

	local function wallObjectAdded(object)
		if object:IsA("Camera") then watchWallCamera(object) else applyWallPart(object) end
	end

	local function wallObjectRemoving(object)
		if object:IsA("Camera") then forgetWallCamera(object) end
		restoreWallPart(object)
	end

	local function forgetWallPlayer(other)
		local entry = state.wallPlayerConnections[other]
		if entry then
			for _, connection in pairs(entry.connections) do connection:Disconnect() end
			if entry.descendant then entry.descendant:Disconnect() end
			if entry.removingDescendant then entry.removingDescendant:Disconnect() end
			state.wallPlayerConnections[other] = nil
		end
	end

	local function watchWallPlayer(other)
		if state.wallPlayerConnections[other] then return end
		local entry = { connections = {} }
		state.wallPlayerConnections[other] = entry
		local function characterAdded(character)
			if entry.descendant then entry.descendant:Disconnect() end
			if entry.removingDescendant then entry.removingDescendant:Disconnect() end
			entry.character = character
			state.wallCharacters[character] = true
			for _, object in ipairs(character:GetDescendants()) do restoreWallPart(object) end
			entry.descendant = character.DescendantAdded:Connect(restoreWallPart)
			entry.removingDescendant = character.DescendantRemoving:Connect(function(object)
				task.defer(function()
					if alive and state.wallEnabled and object.Parent then applyWallPart(object) end
				end)
			end)
		end
		entry.connections.added = other.CharacterAdded:Connect(characterAdded)
		entry.connections.removing = other.CharacterRemoving:Connect(function(character)
			if entry.character == character then
				if entry.descendant then entry.descendant:Disconnect(); entry.descendant = nil end
				if entry.removingDescendant then entry.removingDescendant:Disconnect(); entry.removingDescendant = nil end
				entry.character = nil
			end
		end)
		if other.Character then characterAdded(other.Character) end
	end

	local function scanWalls()
		state.wallEpoch = state.wallEpoch + 1
		local identity = state.wallEpoch
		task.spawn(function()
			local queue, index, batch = { Workspace }, 1, 0
			while index <= #queue do
				if not alive or not state.wallEnabled or identity ~= state.wallEpoch then return end
				local object = queue[index]
				index = index + 1
				if object == Workspace or object:IsDescendantOf(Workspace) then
					wallObjectAdded(object)
					if not object:IsA("Camera") and not state.wallCharacters[object] then
						for _, child in ipairs(object:GetChildren()) do
							queue[#queue + 1] = child
							batch = batch + 1
							if batch >= 250 then
								batch = 0
								task.wait()
								if not alive or not state.wallEnabled or identity ~= state.wallEpoch then return end
							end
						end
					end
				end
				batch = batch + 1
				if batch >= 250 then batch = 0; task.wait() end
			end
		end)
	end

	local function applyWallhack()
		if state.wallEnabled then
			if #state.wallConnections == 0 then
				for _, other in ipairs(Players:GetPlayers()) do watchWallPlayer(other) end
				state.wallConnections = {
					Workspace.DescendantAdded:Connect(wallObjectAdded),
					Workspace.DescendantRemoving:Connect(wallObjectRemoving),
					Players.PlayerAdded:Connect(watchWallPlayer),
					Players.PlayerRemoving:Connect(forgetWallPlayer),
				}
			end
			scanWalls()
		else
			while state.wallRestoring do task.wait() end
			state.wallRestoring = true
			state.wallEpoch = state.wallEpoch + 1
			for _, connection in ipairs(state.wallConnections) do connection:Disconnect() end
			table.clear(state.wallConnections)
			for other in pairs(state.wallPlayerConnections) do forgetWallPlayer(other) end
			for camera in pairs(state.wallCameraConnections) do forgetWallCamera(camera) end
			local batch = 0
			for object in pairs(state.wallParts) do
				restoreWallPart(object)
				batch = batch + 1
				if batch >= 250 then batch = 0; task.wait() end
			end
			state.wallRestoring = false
		end
	end

	local function restoreCollisions()
		for part, original in pairs(state.collisions) do
			part.CanCollide = original
		end
		table.clear(state.collisions)
	end

	local function trackPart(object)
		if object:IsA("BasePart") and state.collisions[object] == nil then
			state.collisions[object] = object.CanCollide
			object.CanCollide = false
		end
	end

	local function applyNoclip()
		if (state.noclip or state.phaseEnabled) and state.character then
			for _, object in ipairs(state.character:GetDescendants()) do
				trackPart(object)
			end
		else
			restoreCollisions()
		end
	end

	local function applySpeed()
		local humanoid = state.humanoid
		if not humanoid or not humanoid.Parent then
			return
		end
		if state.speedEnabled or state.phaseEnabled then
			if not state.speedApplied then
				state.originalSpeed = humanoid.WalkSpeed
				state.speedApplied = true
			end
			humanoid.WalkSpeed = state.phaseEnabled and state.phaseSpeed or state.speed
		elseif state.speedApplied then
			humanoid.WalkSpeed = state.originalSpeed
			state.speedApplied = false
			state.originalSpeed = nil
		end
	end

	local function applyLift()
		local humanoid = state.humanoid
		if not humanoid or not humanoid.Parent then
			return
		end
		if state.god then
			if not state.godApplied then
				state.originalHipHeight = humanoid.HipHeight
				state.godApplied = true
			end
			humanoid.HipHeight = state.originalHipHeight + state.liftHeight
		elseif state.godApplied then
			humanoid.HipHeight = state.originalHipHeight
			state.godApplied = false
			state.originalHipHeight = nil
		end
	end

	local function stopFly()
		for _, field in ipairs({ "flyVelocity", "flyOrientation", "flyAttachment" }) do
			if state[field] then state[field]:Destroy(); state[field] = nil end
		end
		local humanoid = state.flyHumanoid
		if humanoid and humanoid.Parent then
			humanoid.AutoRotate = state.originalAutoRotate
			humanoid.PlatformStand = state.originalPlatformStand
		end
		if state.flyRoot and state.flyRoot.Parent then
			state.flyRoot.AssemblyLinearVelocity = Vector3.zero
			state.flyRoot.AssemblyAngularVelocity = Vector3.zero
		end
		state.flyHumanoid = nil
		state.flyRoot = nil
		state.originalAutoRotate = nil
		state.originalPlatformStand = nil
		state.flyVertical = 0
	end

	local function ensureFly()
		local humanoid = state.humanoid
		local root = state.character and state.character:FindFirstChild("HumanoidRootPart")
		if not state.flyEnabled or not humanoid or not humanoid.Parent or humanoid.Health <= 0 or not root or not root:IsA("BasePart") then
			if state.flyHumanoid then stopFly() end
			return false
		end
		if state.flyRoot == root and state.flyVelocity and state.flyVelocity.Parent == root and state.flyOrientation and state.flyOrientation.Parent == root then
			return true
		end
		stopFly()
		state.flyRoot = root
		state.flyHumanoid = humanoid
		state.originalAutoRotate = humanoid.AutoRotate
		state.originalPlatformStand = humanoid.PlatformStand
		local created = pcall(function()
			local attachment = Instance.new("Attachment")
			state.flyAttachment = attachment
			attachment.Name = "RomaMenuFlyAttachment"
			attachment.Parent = root
			local velocity = Instance.new("LinearVelocity")
			state.flyVelocity = velocity
			velocity.Name = "RomaMenuFlyVelocity"
			velocity.Attachment0 = attachment
			velocity.RelativeTo = Enum.ActuatorRelativeTo.World
			velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
			velocity.ForceLimitsEnabled = false
			velocity.VectorVelocity = Vector3.zero
			velocity.Parent = root
			local orientation = Instance.new("AlignOrientation")
			state.flyOrientation = orientation
			orientation.Name = "RomaMenuFlyOrientation"
			orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
			orientation.Attachment0 = attachment
			orientation.MaxTorque = 100000000
			orientation.Responsiveness = 25
			orientation.CFrame = root.CFrame
			orientation.Parent = root
			humanoid.AutoRotate = false
			humanoid.PlatformStand = true
		end)
		if not created then stopFly() end
		return created
	end

	local function updateFly()
		if not alive or not state.flyEnabled or not ensureFly() then return end
		local move = state.humanoid.MoveDirection
		local horizontal = Vector3.new(move.X, 0, move.Z)
		local vertical = state.flyVertical
		if not UserInputService:GetFocusedTextBox() then
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then vertical = vertical + 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then vertical = vertical - 1 end
		end
		vertical = math.max(-1, math.min(1, vertical))
		local direction = horizontal + Vector3.new(0, vertical, 0)
		if direction.Magnitude > 1 then direction = direction.Unit end
		state.flyVelocity.VectorVelocity = direction * state.flySpeed
		local camera = Workspace.CurrentCamera
		local look = camera and camera.CFrame.LookVector or state.flyRoot.CFrame.LookVector
		local facing = Vector3.new(look.X, 0, look.Z)
		if facing.Magnitude > 0.001 then
			state.flyOrientation.CFrame = CFrame.lookAt(Vector3.zero, facing)
		end
	end

	local function updatePhase(delta)
		if not alive or not state.phaseEnabled or not finite(delta) or delta <= 0 then return end
		local character, humanoid = state.character, state.humanoid
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not character or not humanoid or not humanoid.Parent or humanoid.Health <= 0 or not root or not root:IsA("BasePart") then return end
		local look = root.CFrame.LookVector
		local forward = Vector3.new(look.X, 0, look.Z)
		if forward.Magnitude < 0.001 then return end
		local offset = forward.Unit * state.phaseSpeed * delta
		-- Local motion only. A server may reject or correct the resulting position.
		pcall(function() character:PivotTo(character:GetPivot() + offset) end)
	end

	local function detachCharacter()
		generation = generation + 1
		stopFly()
		if state.diedConnection then state.diedConnection:Disconnect(); state.diedConnection = nil end
		if state.descendantConnection then
			state.descendantConnection:Disconnect()
			state.descendantConnection = nil
		end
		if state.descendantRemovingConnection then
			state.descendantRemovingConnection:Disconnect()
			state.descendantRemovingConnection = nil
		end
		restoreCollisions()
		if state.humanoid and state.humanoid.Parent then
			if state.speedApplied then
				state.humanoid.WalkSpeed = state.originalSpeed
			end
			if state.godApplied then
				state.humanoid.HipHeight = state.originalHipHeight
			end
		end
		state.speedApplied = false
		state.godApplied = false
		state.originalSpeed = nil
		state.originalHipHeight = nil
		state.humanoid = nil
		state.character = nil
	end

	local function bindCharacter(character)
		detachCharacter()
		if not alive then
			return
		end
		state.character = character
		local identity = generation
		state.descendantConnection = character.DescendantAdded:Connect(function(object)
			if alive and state.character == character and (state.noclip or state.phaseEnabled) then
				trackPart(object)
			end
		end)
		state.descendantRemovingConnection = character.DescendantRemoving:Connect(function(object)
			local original = state.collisions[object]
			if original ~= nil then
				object.CanCollide = original
				state.collisions[object] = nil
			end
		end)
		applyNoclip()
		task.spawn(function()
			local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10)
			if not alive or generation ~= identity or state.character ~= character or not humanoid or not humanoid:IsA("Humanoid") then
				return
			end
			state.humanoid = humanoid
			state.diedConnection = humanoid.Died:Connect(stopFly)
			applySpeed()
			applyLift()
			if state.flyEnabled then ensureFly() end
		end)
	end

	local characterConnection = player.CharacterAdded:Connect(bindCharacter)
	local removingConnection = player.CharacterRemoving:Connect(function(character)
		if state.character == character then
			detachCharacter()
		end
	end)
	local steppedConnection = RunService.Stepped:Connect(function()
		if alive and (state.noclip or state.phaseEnabled) then
			for part, original in pairs(state.collisions) do
				if state.character and part:IsDescendantOf(state.character) then
					part.CanCollide = false
				else
					part.CanCollide = original
					state.collisions[part] = nil
				end
			end
		end
	end)
	local heartbeatConnection = RunService.Heartbeat:Connect(function(delta)
		updateFly()
		updatePhase(delta)
		updateFullBright(delta)
	end)
	if player.Character then
		bindCharacter(player.Character)
	end

	local backend = {}

	function backend:Request(action, payload)
		if not alive or type(action) ~= "string" or (payload ~= nil and type(payload) ~= "table") then
			return failure("actionFailed")
		end
		payload = payload or {}
		if action == "Status" then
			return {
				ok = true, authorized = true, unlocked = state.unlocked, defaultTheme = state.defaultTheme, customTheme = state.customTheme,
				phaseEnabled = state.phaseEnabled, flyEnabled = state.flyEnabled, phaseValue = state.phaseSpeed, flyValue = state.flySpeed,
			}
		end
		if action == "Unlock" then
			if type(payload.key) ~= "string" or payload.key ~= ACCESS_KEY then
				return failure("wrongKey")
			end
			loadPreferences()
			state.unlocked = true
			return { ok = true, unlocked = true, defaultTheme = state.defaultTheme, customTheme = state.customTheme, preferencesAvailable = true }
		end
		if not state.unlocked then
			return failure("actionFailed")
		end

		if action == "SaveDefaultTheme" then
			local colors = state.customTheme
			if payload.customTheme ~= nil then
				colors = customColors(payload.customTheme)
				if not colors then return failure("actionFailed") end
			end
			if not validTheme(payload.theme, colors) then
				return failure("actionFailed")
			end
			return savePreferences(payload.theme, colors)
		elseif action == "SaveCustomTheme" then
			local colors = customColors(payload.colors)
			if not colors then return failure("actionFailed") end
			return savePreferences(state.defaultTheme, colors)
		elseif action == "SetWallhack" then
			if type(payload.enabled) ~= "boolean" or (payload.alpha ~= nil and (not finite(payload.alpha) or payload.alpha < 0 or payload.alpha > 1)) then
				return failure("actionFailed")
			end
			if state.wallRestoring then return failure("rateLimited") end
			state.wallEnabled = payload.enabled
			if payload.alpha ~= nil then state.wallAlpha = payload.alpha end
			applyWallhack()
			return { ok = true, enabled = state.wallEnabled, alpha = state.wallAlpha }
		elseif action == "SetFullBright" then
			if type(payload.enabled) ~= "boolean" then return failure("actionFailed") end
			state.fullBright = payload.enabled
			applyFullBright()
			return { ok = true, enabled = state.fullBright }
		elseif action == "SetFly" then
			if type(payload.enabled) ~= "boolean" or (payload.value ~= nil and (not finite(payload.value) or payload.value < 10 or payload.value > 150)) then
				return failure("actionFailed")
			end
			state.flyEnabled = payload.enabled
			if payload.value ~= nil then state.flySpeed = payload.value end
			if state.flyEnabled then
				state.phaseEnabled = false
				applySpeed()
				applyNoclip()
				ensureFly()
			else
				stopFly()
			end
			return { ok = true, enabled = state.flyEnabled, value = state.flySpeed, flyEnabled = state.flyEnabled, phaseEnabled = state.phaseEnabled }
		elseif action == "SetPhase" then
			if type(payload.enabled) ~= "boolean" or (payload.value ~= nil and (not finite(payload.value) or payload.value < 0.5 or payload.value > 12)) then
				return failure("actionFailed")
			end
			state.phaseEnabled = payload.enabled
			if payload.value ~= nil then state.phaseSpeed = payload.value end
			if state.phaseEnabled then
				state.flyEnabled = false
				stopFly()
			end
			applySpeed()
			applyNoclip()
			return { ok = true, enabled = state.phaseEnabled, value = state.phaseSpeed, phaseEnabled = state.phaseEnabled, flyEnabled = state.flyEnabled }
		elseif action == "SetFlyInput" then
			if payload.vertical ~= -1 and payload.vertical ~= 0 and payload.vertical ~= 1 then return failure("actionFailed") end
			state.flyVertical = payload.vertical
			return { ok = true, vertical = state.flyVertical }
		elseif action == "SetSpeed" then
			if type(payload.enabled) ~= "boolean" or (payload.value ~= nil and (not finite(payload.value) or payload.value < 8 or payload.value > 100)) then
				return failure("actionFailed")
			end
			if payload.enabled and payload.value == nil then
				return failure("actionFailed")
			end
			state.speedEnabled = payload.enabled
			if payload.value ~= nil then
				state.speed = payload.value
			end
			applySpeed()
			return { ok = true, enabled = state.speedEnabled, value = state.speed }
		elseif action == "SetNoclip" then
			if type(payload.enabled) ~= "boolean" then
				return failure("actionFailed")
			end
			state.noclip = payload.enabled
			applyNoclip()
			return { ok = true, enabled = state.noclip }
		elseif action == "SetLift" or action == "SetGod" then
			local value = payload.value
			if value == nil then value = action == "SetGod" and 4 or state.liftHeight end
			if type(payload.enabled) ~= "boolean" or not finite(value) or value < 0 or value > 50 then
				return failure("actionFailed")
			end
			-- SetGod is a compatibility alias for adjustable avatar lift.
			-- No health, forcefield, hitbox, or damage-authority changes occur.
			state.god = payload.enabled
			state.liftHeight = value
			applyLift()
			return { ok = true, enabled = state.god, value = state.liftHeight }
		elseif action == "Teleport" then
			if not finite(payload.userId) or payload.userId % 1 ~= 0 or math.abs(payload.userId) > 9007199254740991 then
				return failure("actionFailed")
			end
			local target = Players:GetPlayerByUserId(payload.userId)
			local targetCharacter = target and target.Character
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not character or not root or not root:IsA("BasePart") or not humanoid or humanoid.Health <= 0 then
				return failure("characterMissing")
			end
			if target == player or not targetRoot or not targetRoot:IsA("BasePart") then
				return failure("teleportFailed")
			end
			local now = os.clock()
			if now - state.lastTeleport < 0.8 then
				return failure("rateLimited")
			end
			state.lastTeleport = now
			local moved = pcall(function()
				humanoid.Sit = false
				character:PivotTo(targetRoot.CFrame * CFrame.new(3, 1, 3))
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end)
			return moved and { ok = true } or failure("teleportFailed")
		elseif action == "Reset" then
			state.speedEnabled = false
			state.speed = 16
			state.noclip = false
			state.phaseEnabled = false
			state.phaseSpeed = 2
			state.god = false
			state.liftHeight = 4
			state.flyEnabled = false
			state.flySpeed = 48
			state.fullBright = false
			state.wallEnabled = false
			state.wallAlpha = 0.7
			applySpeed()
			applyNoclip()
			applyLift()
			stopFly()
			applyFullBright()
			applyWallhack()
			return { ok = true }
		end
		return failure("actionFailed")
	end

	function backend:Destroy()
		if not alive then
			return
		end
		alive = false
		characterConnection:Disconnect()
		removingConnection:Disconnect()
		steppedConnection:Disconnect()
		heartbeatConnection:Disconnect()
		state.fullBright = false
		state.wallEnabled = false
		applyFullBright()
		applyWallhack()
		detachCharacter()
	end

	return backend
end

end)()

local CreateConfigStore = (function()
-- Named client configurations. This factory only touches its fixed folder.
-- No listfiles, dynamic paths, remote requests, or local module dependencies.
return function(caps)
	local HttpService = game:GetService("HttpService")
	caps = type(caps) == "table" and caps or {}
	local ROOT = "RomaMenu228"
	local FOLDER = ROOT .. "/configs"
	local INDEX = FOLDER .. "/index.json"
	local MAX_NAMES, MAX_CONFIG_BYTES, MAX_INDEX_BYTES = 50, 128 * 1024, 16 * 1024
	local MAX_DEPTH, MAX_NODES = 16, 12000
	local store = {}

	local function fail(message)
		return { ok = false, message = message }
	end

	local function available()
		return type(caps.readfile) == "function" and type(caps.writefile) == "function" and type(caps.isfile) == "function"
	end

	local function whitespace(codepoint)
		return (codepoint >= 9 and codepoint <= 13) or codepoint == 32 or codepoint == 0x85 or codepoint == 0xA0
			or codepoint == 0x1680 or (codepoint >= 0x2000 and codepoint <= 0x200A)
			or codepoint == 0x2028 or codepoint == 0x2029 or codepoint == 0x202F or codepoint == 0x205F or codepoint == 0x3000
	end

	local function normalizeName(value)
		if type(value) ~= "string" or #value > 1024 then return nil end
		local ok, count = pcall(utf8.len, value)
		if not ok or not count then return nil end
		local points = {}
		for _, codepoint in utf8.codes(value) do
			if codepoint >= 0xD800 and codepoint <= 0xDFFF then return nil end
			table.insert(points, codepoint)
		end
		local first, last = 1, #points
		while first <= last and whitespace(points[first]) do first = first + 1 end
		while last >= first and whitespace(points[last]) do last = last - 1 end
		if last - first + 1 < 1 or last - first + 1 > 48 then return nil end
		local characters = {}
		for index = first, last do
			local codepoint = points[index]
			if codepoint < 32 or (codepoint >= 0x7F and codepoint <= 0x9F)
				or codepoint == 0x2028 or codepoint == 0x2029 then return nil end
			table.insert(characters, utf8.char(codepoint))
		end
		local name = table.concat(characters)
		if name:find('[<>:"/\\|?*]') then return nil end
		return name
	end

	local function idFor(name)
		local bytes = {}
		for index = 1, #name do bytes[index] = string.format("%02x", string.byte(name, index)) end
		return "cfg_" .. table.concat(bytes)
	end

	local function pathFor(name)
		return FOLDER .. "/" .. idFor(name) .. ".json"
	end

	local function exists(path)
		local ok, value = pcall(caps.isfile, path)
		if not ok or type(value) ~= "boolean" then return nil end
		return value
	end

	-- Clone only bounded JSON values, rejecting cycles, metatables and engine objects.
	local function cloneJSON(value)
		local nodes, bytes, active = 0, 0, {}
		local function copy(item, depth)
			nodes = nodes + 1
			bytes = bytes + 8
			if nodes > MAX_NODES or depth > MAX_DEPTH or bytes > MAX_CONFIG_BYTES then error("JSON bounds", 0) end
			local kind = type(item)
			if kind == "boolean" then return item end
			if kind == "number" then
				if item ~= item or item <= -math.huge or item >= math.huge then error("Invalid number", 0) end
				return item
			end
			if kind == "string" then
				if #item > MAX_CONFIG_BYTES or not utf8.len(item) then error("Invalid string", 0) end
				bytes = bytes + #item
				if bytes > MAX_CONFIG_BYTES then error("JSON bounds", 0) end
				return item
			end
			if kind ~= "table" or getmetatable(item) ~= nil or active[item] then error("Invalid JSON value", 0) end
			active[item] = true
			local result, count, largest, numeric, textual = {}, 0, 0, false, false
			for key in pairs(item) do
				count = count + 1
				if count > MAX_NODES then error("JSON bounds", 0) end
				if type(key) == "number" and key >= 1 and key <= MAX_NODES and key % 1 == 0 then
					numeric = true; largest = math.max(largest, key)
				elseif type(key) == "string" and #key <= MAX_CONFIG_BYTES and utf8.len(key) then
					textual = true
					bytes = bytes + #key
					if bytes > MAX_CONFIG_BYTES then error("JSON bounds", 0) end
				else error("Invalid JSON key", 0) end
			end
			if (numeric and textual) or (numeric and largest ~= count) then error("Sparse or mixed JSON table", 0) end
			for key, child in pairs(item) do result[key] = copy(child, depth + 1) end
			active[item] = nil
			return result
		end
		if type(value) ~= "table" then return nil end
		local ok, result = pcall(copy, value, 0)
		return ok and result or nil
	end

	local function encode(value, limit)
		local ok, raw = pcall(function() return HttpService:JSONEncode(value) end)
		if not ok or type(raw) ~= "string" or #raw > limit then return nil end
		return raw
	end

	local function readRaw(path, limit)
		local present = exists(path)
		if present == nil then return nil, "configReadFailed" end
		if not present then return nil, "configMissing" end
		local ok, raw = pcall(caps.readfile, path)
		if not ok or type(raw) ~= "string" then return nil, "configReadFailed" end
		if #raw > limit then return nil, "configCorrupt" end
		return raw
	end

	local function readIndex()
		local present = exists(INDEX)
		if present == nil then return nil, nil, "configReadFailed" end
		if not present then return {}, nil end
		local raw, reason = readRaw(INDEX, MAX_INDEX_BYTES)
		if not raw then return nil, nil, reason end
		local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if not ok or type(data) ~= "table" or data.version ~= 1 or type(data.names) ~= "table" then
			return nil, nil, "configCorrupt"
		end
		local count, largest = 0, 0
		for key in pairs(data.names) do
			if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then return nil, nil, "configCorrupt" end
			count = count + 1; largest = math.max(largest, key)
		end
		if count > MAX_NAMES or largest ~= count then return nil, nil, "configCorrupt" end
		local names, seen = {}, {}
		for index = 1, count do
			local name = normalizeName(data.names[index])
			if not name or name ~= data.names[index] or seen[name] then return nil, nil, "configCorrupt" end
			seen[name] = true; names[index] = name
		end
		return names, raw
	end

	local function findName(names, name)
		for index, candidate in ipairs(names) do if candidate == name then return index end end
		return nil
	end

	local function ensureFolders(indexExisted)
		if indexExisted then return true end
		for _, folder in ipairs({ ROOT, FOLDER }) do
			local known = false
			if type(caps.isfolder) == "function" then
				local ok, present = pcall(caps.isfolder, folder)
				if not ok or type(present) ~= "boolean" then return false, "configWriteFailed" end
				known = present
			end
			if not known then
				if type(caps.makefolder) ~= "function" then
					if type(caps.isfolder) == "function" then return false, "configStorageUnavailable" end
					-- With no folder APIs, an existing folder may still accept a verified write.
				else
					local ok = pcall(caps.makefolder, folder)
					if not ok and type(caps.isfolder) == "function" then
						local checked, present = pcall(caps.isfolder, folder)
						if not checked or not present then return false, "configWriteFailed" end
					end
				end
			end
		end
		return true
	end

	local function writeVerified(path, raw)
		local wrote = pcall(caps.writefile, path, raw)
		if not wrote then return false end
		local read, saved = pcall(caps.readfile, path)
		return read and saved == raw
	end

	local function writeIndex(names)
		local raw = encode({ version = 1, names = names }, MAX_INDEX_BYTES)
		return raw ~= nil and writeVerified(INDEX, raw)
	end

	local function restoreIndex(raw)
		return writeVerified(INDEX, raw or encode({ version = 1, names = {} }, MAX_INDEX_BYTES))
	end

	local function encodeConfig(name, data)
		local snapshot = cloneJSON(data)
		if not snapshot then return nil end
		return encode({ version = 1, name = name, data = snapshot }, MAX_CONFIG_BYTES)
	end

	local function decodeConfig(name, raw)
		local ok, record = pcall(function() return HttpService:JSONDecode(raw) end)
		if not ok or type(record) ~= "table" or record.version ~= 1 or record.name ~= name then return nil end
		return cloneJSON(record.data)
	end

	function store:List()
		if not available() then return fail("configStorageUnavailable") end
		local names, _, reason = readIndex()
		if not names then return fail(reason) end
		local configs = {}
		for _, name in ipairs(names) do table.insert(configs, { name = name, id = idFor(name) }) end
		return { ok = true, configs = configs }
	end

	function store:Create(value, data)
		local name = normalizeName(value)
		if not name then return fail("configInvalidName") end
		if not available() then return fail("configStorageUnavailable") end
		local names, oldIndex, reason = readIndex()
		if not names then return fail(reason) end
		if findName(names, name) then return fail("configExists") end
		if #names >= MAX_NAMES then return fail("configLimit") end
		local raw = encodeConfig(name, data)
		if not raw then return fail("configCorrupt") end
		local ready, folderReason = ensureFolders(oldIndex ~= nil)
		if not ready then return fail(folderReason) end
		local path = pathFor(name)
		local present = exists(path)
		if present == nil then return fail("configReadFailed") end
		if present then return fail("configExists") end
		if not writeVerified(path, raw) then return fail("configWriteFailed") end
		table.insert(names, name)
		if not writeIndex(names) then
			restoreIndex(oldIndex)
			if type(caps.delfile) == "function" then pcall(caps.delfile, path) end
			return fail("configWriteFailed")
		end
		return { ok = true, name = name }
	end

	function store:Load(value)
		local name = normalizeName(value)
		if not name then return fail("configInvalidName") end
		if not available() then return fail("configStorageUnavailable") end
		local names, _, reason = readIndex()
		if not names then return fail(reason) end
		if not findName(names, name) then return fail("configMissing") end
		local raw, readReason = readRaw(pathFor(name), MAX_CONFIG_BYTES)
		if not raw then return fail(readReason) end
		local data = decodeConfig(name, raw)
		if not data then return fail("configCorrupt") end
		return { ok = true, name = name, data = data }
	end

	function store:Overwrite(value, data)
		local name = normalizeName(value)
		if not name then return fail("configInvalidName") end
		if not available() then return fail("configStorageUnavailable") end
		local names, _, reason = readIndex()
		if not names then return fail(reason) end
		if not findName(names, name) then return fail("configMissing") end
		local raw = encodeConfig(name, data)
		if not raw then return fail("configCorrupt") end
		local path = pathFor(name)
		local backup, readReason = readRaw(path, MAX_CONFIG_BYTES)
		if not backup then return fail(readReason) end
		if not writeVerified(path, raw) then
			writeVerified(path, backup)
			return fail("configWriteFailed")
		end
		return { ok = true, name = name }
	end

	function store:Delete(value)
		local name = normalizeName(value)
		if not name then return fail("configInvalidName") end
		if not available() or type(caps.delfile) ~= "function" then return fail("configStorageUnavailable") end
		local names, oldIndex, reason = readIndex()
		if not names then return fail(reason) end
		local index = findName(names, name)
		if not index then return fail("configMissing") end
		local path = pathFor(name)
		local backup, readReason = readRaw(path, MAX_CONFIG_BYTES)
		if not backup then return fail(readReason) end
		local removed = pcall(caps.delfile, path)
		local present = exists(path)
		if not removed or present ~= false then
			if present == false then writeVerified(path, backup) end
			return fail("configDeleteFailed")
		end
		table.remove(names, index)
		if not writeIndex(names) then
			writeVerified(path, backup)
			restoreIndex(oldIndex)
			return fail("configWriteFailed")
		end
		return { ok = true, name = name }
	end

	return store
end

end)()

-- UI source for the standalone client bundle. Config/CreateBackend/Capabilities
-- are embedded by build-client.cjs; this file is not the complete entry point.
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then warn("RomaMenu must run on a Roblox client."); return end
local playerGui = player:WaitForChild("PlayerGui")
local existing = playerGui:FindFirstChild("RomaMenu228Client")
if existing then
	if existing:GetAttribute("RomaBuild") == "Alpha.3" then
		local control = existing:FindFirstChild("RomaMenuControl")
		if control and control:IsA("BindableEvent") then control:Fire("Open") end
		return
	end
	-- Replacing an older build fires its cleanup before this one starts.
	existing:Destroy()
end
local backend = CreateBackend(player, Config, Capabilities)
local configStore = CreateConfigStore(Capabilities)
local featureOrder = {"wallhack", "esp", "fullbright", "speed", "noclip", "lift", "fly", "phase", "thirdPerson"}
local pageIds = {"visuals", "movement", "players", "configs", "settings"}
local state = {
	language = Config.DefaultLanguage,
	theme = Config.DefaultTheme,
	defaultTheme = Config.DefaultTheme,
	mode = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "mobile" or "desktop",
	hotkey = Enum.KeyCode[Config.DefaultHotkey],
	liftHotkey = Enum.KeyCode[Config.DefaultLiftHotkey or "H"],
	wallhack = false, wallAlpha = 0.7, esp = false, fill = 0.25, outline = 1,
	color = Color3.fromRGB(181, 125, 255),
	speed = false, speedValue = 24, noclip = false, lift = false, liftHeight = 4,
	fullbright = false, fly = false, flySpeed = 48, statusPanel = false,
	phase = false, phaseSpeed = 2,
	quick = {}, bindings = {lift = Enum.KeyCode.H, phase = Enum.KeyCode.G},
	hudPinned = false, hudOnlyBound = false, hudPosition = nil, showFlyVertical = false,
	flyVertical = 0,
	thirdPerson = false, distance = 12, fov = 70,
}
local alive, unlocked, opened, capturing = true, false, true, nil
local connections, pageConnections, modalConnections, hudConnections = {}, {}, {}, {}
local paints, gradients, highlights, playerConnections = {}, {}, {}, {}
local currentPage = "visuals"
local rebuild, buildPage, updateLayout, updateChrome, setOpen, cleanup, updateStatus
local setFeature, setValue, featureOptions, showColorPicker
local captureField, selectedConfig
local flightButtons = {}
local sliderDrag
local flyPointers = {}
local customColors = {bg = {8, 6, 14}, accent = {155, 85, 255}, accent2 = {94, 43, 184}}

local function t(key)
	local language = Config.Translations[state.language] or Config.Translations.en
	return language[key] or Config.Translations.en[key] or key
end
local function listen(signal, callback, list)
	local connection = signal:Connect(callback)
	table.insert(list or connections, connection)
	return connection
end
local function disconnect(list)
	for _, connection in ipairs(list) do connection:Disconnect() end
	table.clear(list)
end
local function new(className, properties, parent)
	local object = Instance.new(className)
	for key, value in pairs(properties or {}) do object[key] = value end
	object.Parent = parent
	return object
end
local function paint(object, property, token)
	object[property] = Config.Themes[state.theme][token]
	table.insert(paints, {object, property, token})
	return object
end
local function round(object, radius)
	local corner = object:FindFirstChildOfClass("UICorner") or new("UICorner", {}, object)
	corner.CornerRadius = UDim.new(0, radius or 12)
end
local function stroke(object)
	local border = new("UIStroke", {Thickness = 1, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, object)
	paint(border, "Color", "stroke")
end
local function accentInk()
	local theme = Config.Themes[state.theme]
	local color = theme.accent:Lerp(theme.accent2, 0.5)
	return (color.R * 0.2126 + color.G * 0.7152 + color.B * 0.0722) > 0.55
		and Color3.fromRGB(16, 12, 24) or Color3.new(1, 1, 1)
end
local function gradient(object)
	local effect = new("UIGradient", {Rotation = 25}, object)
	local theme = Config.Themes[state.theme]
	effect.Color = ColorSequence.new(theme.accent, theme.accent2)
	table.insert(gradients, effect)
end
local function prunePaints()
	local valid = {}
	for _, binding in ipairs(paints) do
		if binding[1]:IsDescendantOf(playerGui) then table.insert(valid, binding) end
	end
	paints = valid
	local validGradients = {}
	for _, effect in ipairs(gradients) do
		if effect:IsDescendantOf(playerGui) then table.insert(validGradients, effect) end
	end
	gradients = validGradients
end
local function applyTheme()
	prunePaints()
	local theme = Config.Themes[state.theme]
	for _, binding in ipairs(paints) do binding[1][binding[2]] = theme[binding[3]] end
	for _, effect in ipairs(gradients) do
		effect.Color = ColorSequence.new(theme.accent, theme.accent2)
		if effect.Parent:IsA("TextButton") then effect.Parent.TextColor3 = accentInk() end
	end
end
local function label(parent, text, size, bold)
	return paint(new("TextLabel", {
		BackgroundTransparency = 1, Text = text, TextSize = size or 14,
		Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 24),
	}, parent), "TextColor3", "text")
end
local function button(parent, text, accent)
	local object = new("TextButton", {
		Text = text, TextSize = 13, TextWrapped = true,
		Font = Enum.Font.GothamBold, AutoButtonColor = true,
		Size = UDim2.new(1, 0, 0, 36), BorderSizePixel = 0,
	}, parent)
	paint(object, "BackgroundColor3", accent and "accent" or "raised")
	if accent then
		object.TextColor3 = accentInk()
		gradient(object)
	else paint(object, "TextColor3", "text") end
	round(object, 10)
	return object
end
local function stack(parent, gap)
	new("UIListLayout", {Padding = UDim.new(0, gap or 10), SortOrder = Enum.SortOrder.LayoutOrder}, parent)
end
local function padding(parent, amount)
	new("UIPadding", {PaddingTop = UDim.new(0, amount), PaddingBottom = UDim.new(0, amount),
		PaddingLeft = UDim.new(0, amount), PaddingRight = UDim.new(0, amount)}, parent)
end
local function scroll(parent)
	local frame = paint(new("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = UDim2.fromScale(1, 1), ClipsDescendants = true,
	}, parent), "ScrollBarImageColor3", "accent")
	padding(frame, 4)
	stack(frame, 10)
	return frame
end
local function card(parent, titleKey, hintKey)
	local frame = paint(new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0}, parent), "BackgroundColor3", "surface")
	round(frame, 12)
	stroke(frame)
	padding(frame, 10)
	stack(frame, 6)
	label(frame, t(titleKey), 14, true).Name = "CardTitle"
	if hintKey then
		local hint = label(frame, t(hintKey), 11)
		hint.AutomaticSize = Enum.AutomaticSize.Y
		hint.Size = UDim2.new(1, 0, 0, 0)
		paint(hint, "TextColor3", "muted")
	end
	return frame
end

local gui = new("ScreenGui", {Name = "RomaMenu228Client", ResetOnSpawn = false,
	IgnoreGuiInset = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 80}, playerGui)
gui:SetAttribute("RomaBuild", "Alpha.3")
local controlEvent = new("BindableEvent", {Name = "RomaMenuControl"}, gui)
local highlightFolder = new("Folder", {Name = "RomaMenuClientHighlights_" .. player.UserId}, workspace)
local root = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, gui)
local window = paint(new("Frame", {Name = "Menu", Size = UDim2.fromOffset(680, 500),
	Position = UDim2.fromOffset(40, 40), BorderSizePixel = 0, ClipsDescendants = true}, root), "BackgroundColor3", "bg")
round(window, 14)
stroke(window)
local topAccent = new("Frame", {Size = UDim2.new(1, 0, 0, 4), BorderSizePixel = 0,
	BackgroundColor3 = Color3.new(1, 1, 1)}, window)
gradient(topAccent)
local header = new("Frame", {Name = "DragHandle", BackgroundTransparency = 1,
	Position = UDim2.fromOffset(14, 9), Size = UDim2.new(1, -70, 0, 44), Active = true}, window)
local title = label(header, "Рома Чит 228  ·  Alpha", 18, true)
local subtitle = paint(label(header, "", 11), "TextColor3", "muted")
subtitle.Position = UDim2.fromOffset(0, 23)
local closeButton = button(window, "×")
closeButton.Position = UDim2.new(1, -46, 0, 12)
closeButton.Size = UDim2.fromOffset(32, 32)
closeButton.TextSize = 24
local navigation = new("Frame", {BackgroundTransparency = 1}, window)
local content = new("Frame", {BackgroundTransparency = 1}, window)
local footer = paint(label(window, "", 11), "TextColor3", "muted")
footer.Position = UDim2.new(0, 18, 1, -28)
footer.Size = UDim2.new(1, -36, 0, 20)
local orb = button(root, "Р", true)
orb.Name = "MobileToggle"
orb.Size = UDim2.fromOffset(46, 46)
orb.Position = UDim2.fromOffset(16, 120)
orb.TextSize = 21
local orbDot = new("Frame", {Size = UDim2.fromOffset(6, 6), Position = UDim2.new(1, -10, 1, -10),
	BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(177, 128, 255)}, orb)
round(orbDot, 4)
round(orb, 100)
stroke(orb)
local toastLabel = paint(label(root, "", 13, true), "BackgroundColor3", "raised")
toastLabel.Name = "Notification"
toastLabel.BackgroundTransparency = 0.04
toastLabel.AnchorPoint = Vector2.new(0.5, 1)
toastLabel.Position = UDim2.new(0.5, 0, 1, -20)
toastLabel.Size = UDim2.new(0.9, 0, 0, 64)
toastLabel.TextXAlignment = Enum.TextXAlignment.Center
toastLabel.ZIndex = 20
toastLabel.Visible = false
round(toastLabel)
padding(toastLabel, 8)
local toastId = 0
local function toast(key)
	if not alive then return end
	toastId = toastId + 1
	local id = toastId
	toastLabel.Text = t(key)
	toastLabel.Visible = true
	task.delay(4, function()
		if alive and toastId == id then toastLabel.Visible = false end
	end)
end
local errorMap = {invalidRequest = "actionFailed", locked = "wrongKey",
	targetUnavailable = "teleportFailed", characterUnavailable = "characterMissing"}
local actionBusy = false
local function request(action, payload)
	if actionBusy then return {ok = false, message = "rateLimited"} end
	actionBusy = true
	local ok, result = pcall(function() return backend:Request(action, payload or {}) end)
	actionBusy = false
	if not ok then warn("RomaMenu local action failed: " .. tostring(result)) end
	return ok and type(result) == "table" and result or {ok = false, message = "actionFailed"}
end
local function report(result)
	if not result.ok then toast(errorMap[result.message] or result.message or "actionFailed") end
	return result.ok
end
local function releaseFlyControls()
	table.clear(flyPointers)
	state.flyVertical = 0
	if alive then request("SetFlyInput", {vertical = 0}) end
end

local statusHUD = paint(new("Frame", {Name = "ToggleStatus", BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0, 0), Position = UDim2.fromOffset(700, 70),
	Size = UDim2.fromOffset(214, 320), Visible = false, ZIndex = 8}, root), "BackgroundColor3", "bg")
round(statusHUD, 10); stroke(statusHUD)
padding(statusHUD, 9)
local statusHeading = label(statusHUD, "Alpha", 13, true)
statusHeading.Name = "HUDDragHandle"
statusHeading.Active = true
statusHeading.Size = UDim2.new(1, -38, 0, 24)
statusHeading.ZIndex = 9
local pinButton = button(statusHUD, "◇")
pinButton.Name = "HUDPin"; pinButton.Position = UDim2.new(1, -30, 0, 0)
pinButton.Size = UDim2.fromOffset(28, 24); pinButton.ZIndex = 10
local statusBody = scroll(statusHUD)
statusBody.Position = UDim2.fromOffset(0, 29)
statusBody.Size = UDim2.new(1, 0, 1, -29)
statusBody.ZIndex = 9
updateStatus = function()
	statusHUD.Visible = unlocked and state.statusPanel
	statusHeading.Text = "Alpha · " .. t("quickAccess")
	pinButton.Text = state.hudPinned and "◆" or "◇"
end
listen(pinButton.Activated, function() state.hudPinned = not state.hudPinned; updateStatus() end)

-- ESP is independent. WallHack changes map transparency in the local backend.
local function updateHighlight(other)
	local highlight = highlights[other]
	local character = other.Character
	if not unlocked or not state.esp or not character then
		if highlight then highlight:Destroy(); highlights[other] = nil end
		return
	end
	if not highlight then
		highlight = new("Highlight", {Name = "RomaMenuHighlight"}, highlightFolder)
		highlights[other] = highlight
	end
	highlight.Adornee = character
	highlight.Enabled = true
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = state.color
	highlight.OutlineColor = state.color
	highlight.FillTransparency = 1 - state.fill
	highlight.OutlineTransparency = 1 - state.outline
end
local function updateHighlights()
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then updateHighlight(other) end
	end
end
local function watchPlayer(other)
	if other == player or playerConnections[other] then return end
	playerConnections[other] = {
		other.CharacterAdded:Connect(function() task.defer(function() if alive then updateHighlight(other) end end) end),
		other.CharacterRemoving:Connect(function()
			if highlights[other] then highlights[other]:Destroy(); highlights[other] = nil end
		end),
	}
	updateHighlight(other)
end

local cameraSnapshot
local function restoreCamera()
	if not cameraSnapshot then return end
	-- Open the zoom interval before restoring both bounds.
	player.CameraMinZoomDistance = 0.5
	player.CameraMaxZoomDistance = math.max(cameraSnapshot.max, cameraSnapshot.min, 0.5)
	player.CameraMinZoomDistance = cameraSnapshot.min
	player.CameraMode = cameraSnapshot.mode
	for camera, value in pairs(cameraSnapshot.fovs) do
		if camera.Parent then camera.FieldOfView = value end
	end
	cameraSnapshot = nil
end
local function applyCamera()
	if not state.thirdPerson then restoreCamera(); return end
	if not cameraSnapshot then
		cameraSnapshot = {mode = player.CameraMode, min = player.CameraMinZoomDistance,
			max = player.CameraMaxZoomDistance, fovs = {}}
	end
	player.CameraMode = Enum.CameraMode.Classic
	player.CameraMinZoomDistance = 0.5
	player.CameraMaxZoomDistance = state.distance
	player.CameraMinZoomDistance = state.distance
	local camera = workspace.CurrentCamera
	if camera then
		if cameraSnapshot.fovs[camera] == nil then cameraSnapshot.fovs[camera] = camera.FieldOfView end
		camera.FieldOfView = state.fov
	end
end
listen(workspace:GetPropertyChangedSignal("CurrentCamera"), applyCamera)
listen(player.CharacterAdded, function()
	task.delay(0.3, function() if alive and state.thirdPerson then applyCamera() end end)
end)

local valueSpecs = {
	wallAlpha = {feature = "wallhack", key = "wallTransparency", min = 0, max = 100, step = 1, factor = 100},
	fill = {feature = "esp", key = "fillOpacity", min = 0, max = 100, step = 1, factor = 100},
	outline = {feature = "esp", key = "outlineOpacity", min = 0, max = 100, step = 1, factor = 100},
	speedValue = {feature = "speed", key = "speedValue", min = 8, max = 100, step = 1},
	liftHeight = {feature = "lift", key = "liftHeight", min = 0, max = 50, step = 1},
	flySpeed = {feature = "fly", key = "flySpeed", min = 10, max = 150, step = 1},
	phaseSpeed = {feature = "phase", key = "phaseSpeed", min = 0.5, max = 12, step = 0.5},
	distance = {feature = "thirdPerson", key = "cameraDistance", min = 4, max = 40, step = 1},
	fov = {feature = "thirdPerson", key = "fieldOfView", min = 40, max = 100, step = 1},
}
local primaryValues = {wallhack = "wallAlpha", speed = "speedValue", lift = "liftHeight", fly = "flySpeed", phase = "phaseSpeed", thirdPerson = "distance"}
local function refreshPanels()
	if opened and unlocked then buildPage(true) else updateStatus() end
end
setFeature = function(field, enabled, deferRefresh)
	if not unlocked or type(enabled) ~= "boolean" then return false end
	local action, payload
	if field == "wallhack" then action, payload = "SetWallhack", {enabled = enabled, alpha = state.wallAlpha}
	elseif field == "fullbright" then action, payload = "SetFullBright", {enabled = enabled}
	elseif field == "speed" then action, payload = "SetSpeed", {enabled = enabled, value = state.speedValue}
	elseif field == "noclip" then action, payload = "SetNoclip", {enabled = enabled}
	elseif field == "lift" then action, payload = "SetLift", {enabled = enabled, value = state.liftHeight}
	elseif field == "fly" then action, payload = "SetFly", {enabled = enabled, value = state.flySpeed}
	elseif field == "phase" then action, payload = "SetPhase", {enabled = enabled, value = state.phaseSpeed}
	elseif field ~= "esp" and field ~= "thirdPerson" then return false end
	if action then
		local result = request(action, payload)
		if not report(result) then return false end
		if enabled and field == "fly" then state.phase = false end
		if enabled and field == "phase" then state.fly = false; releaseFlyControls() end
	end
	state[field] = enabled
	if field == "esp" then updateHighlights() end
	if field == "thirdPerson" then applyCamera() end
	if field == "fly" and not enabled then releaseFlyControls() end
	if not deferRefresh then refreshPanels() end
	return true
end
setValue = function(field, value, deferRefresh)
	local spec = valueSpecs[field]
	if not spec or type(value) ~= "number" or value ~= value or math.abs(value) == math.huge then return false end
	local factor = spec.factor or 1
	value = math.clamp(math.round(value * factor / spec.step) * spec.step, spec.min, spec.max) / factor
	local original = state[field]
	state[field] = value
	if state[spec.feature] and not setFeature(spec.feature, true, true) then state[field] = original; return false end
	if field == "fill" or field == "outline" then updateHighlights() end
	if field == "distance" or field == "fov" then applyCamera() end
	if not deferRefresh then refreshPanels() end
	return true
end

local function toggle(parent, key, field, callback, hint)
	local frame = card(parent, key, hint)
	local heading = frame:FindFirstChild("CardTitle")
	heading.Size = UDim2.new(1, -64, 0, 28)
	local control = button(heading, "")
	control.Name = "Toggle_" .. field
	control.Position = UDim2.new(1, 8, 0, 0)
	control.Size = UDim2.fromOffset(56, 28)
	local busy = false
	local function refresh()
		control.Text = t(state[field] and "on" or "off")
		control.BackgroundColor3 = Config.Themes[state.theme][state[field] and "accent" or "raised"]
	end
	refresh()
	listen(control.Activated, function()
		if busy then return end
		busy = true
		control.Text = "…"
		local nextValue = not state[field]
		if not callback or callback(nextValue) ~= false then state[field] = nextValue end
		updateStatus()
		if control.Parent then refresh()
		elseif alive and unlocked then buildPage() end
		busy = false
		if (field == "fly" or field == "phase") and alive and opened then buildPage(true) end
	end, pageConnections)
	return frame
end
local function numberControl(parent, titleKey, value, minValue, maxValue, step, changed, connectionList)
	local list = connectionList or pageConnections
	local frame = new("Frame", {Name = "Slider_" .. titleKey, BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 55)}, parent)
	local heading = label(frame, t(titleKey), 11)
	heading.Size = UDim2.new(1, -58, 0, 21)
	local readout = paint(label(frame, "", 12, true), "TextColor3", "accent")
	readout.Position = UDim2.new(1, -56, 0, 0); readout.Size = UDim2.fromOffset(56, 21)
	readout.TextXAlignment = Enum.TextXAlignment.Right
	local hit = new("TextButton", {Name = "SliderTrack", Text = "", BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 23), Size = UDim2.new(1, 0, 0, 30), AutoButtonColor = false}, frame)
	local track = paint(new("Frame", {BorderSizePixel = 0, Position = UDim2.fromOffset(8, 11),
		Size = UDim2.new(1, -16, 0, 6)}, hit), "BackgroundColor3", "raised")
	round(track, 6)
	local fill = paint(new("Frame", {BorderSizePixel = 0, Size = UDim2.fromScale(0, 1)}, track), "BackgroundColor3", "accent")
	round(fill, 6)
	local knob = new("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(14, 14), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1)}, track)
	round(knob, 8)
	local preview = value
	local function draw(nextValue)
		preview = math.clamp(math.round(nextValue / step) * step, minValue, maxValue)
		local alpha = (preview - minValue) / (maxValue - minValue)
		fill.Size = UDim2.fromScale(alpha, 1); knob.Position = UDim2.fromScale(alpha, 0.5)
		readout.Text = tostring(preview)
	end
	local function fromX(x)
		if track.AbsoluteSize.X > 0 then
			draw(minValue + math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (maxValue - minValue))
		end
	end
	listen(hit.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if sliderDrag then sliderDrag.finish(true) end
		local scrolling = frame:FindFirstAncestorWhichIsA("ScrollingFrame")
		local oldScrolling = scrolling and scrolling.ScrollingEnabled
		if scrolling then scrolling.ScrollingEnabled = false end
		local finished = false
		local descriptor
		descriptor = {input = input, touch = input.UserInputType == Enum.UserInputType.Touch, change = fromX,
			owner = list == hudConnections and "hud" or "page"}
		descriptor.finish = function(cancelled)
			if finished then return end
			finished = true
			if sliderDrag == descriptor then sliderDrag = nil end
			if scrolling and scrolling.Parent then scrolling.ScrollingEnabled = oldScrolling end
			if not cancelled and preview ~= value and changed(preview) ~= false then value = preview end
			if frame.Parent then draw(value) end
		end
		sliderDrag = descriptor
		fromX(input.Position.X)
	end, list)
	listen(hit.InputBegan, function(input)
		if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then
			local nextValue = math.clamp(value + (input.KeyCode == Enum.KeyCode.Right and step or -step), minValue, maxValue)
			if changed(nextValue) ~= false then value = nextValue; if frame.Parent then draw(value) end end
		end
	end, list)
	draw(value)
	return frame, function(nextValue) value = nextValue; draw(value) end
end
local function valueControl(parent, field, fromHUD, list)
	local spec = valueSpecs[field]
	return numberControl(parent, spec.key, state[field] * (spec.factor or 1), spec.min, spec.max, spec.step, function(value)
		if not setValue(field, value / (spec.factor or 1), true) then return false end
		if fromHUD and opened then buildPage(true) else updateStatus() end
		return true
	end, list)
end
local function flightControl(parent, key, direction, list)
	local control = button(parent, "")
	control.Name = "Flight_" .. key
	local function draw()
		control.Text = (state.flyVertical == direction and "● " or "○ ") .. t(key)
	end
	draw()
	table.insert(flightButtons, {control = control, key = key, direction = direction})
	listen(control.Activated, function()
		if not state.fly then return end
		local value = state.flyVertical == direction and 0 or direction
		if report(request("SetFlyInput", {vertical = value})) then state.flyVertical = value; updateStatus() end
	end, list or pageConnections)
	return control
end
updateStatus = function()
	if sliderDrag and sliderDrag.owner == "hud" then sliderDrag.finish(true) end
	disconnect(hudConnections)
	statusBody:ClearAllChildren(); padding(statusBody, 1); stack(statusBody, 6)
	prunePaints()
	statusHUD.Visible = unlocked and state.statusPanel
	statusHeading.Text = "Alpha · " .. t("quickAccess")
	pinButton.Text = state.hudPinned and "◆" or "◇"
	local count = 0
	for _, field in ipairs(featureOrder) do
		if state.quick[field] and (not state.hudOnlyBound or state.bindings[field]) then
			count = count + 1
			local hasValue = primaryValues[field] ~= nil
			local row = new("Frame", {Name = "HUDRow_" .. field, BackgroundTransparency = 1,
				Size = UDim2.new(1, -2, 0, hasValue and 88 or 31), ZIndex = 9}, statusBody)
			local key = label(row, state.bindings[field] and state.bindings[field].Name or "—", 9, true)
			key.Size = UDim2.fromOffset(30, 30); key.TextXAlignment = Enum.TextXAlignment.Center
			local control = button(row, t(field) .. " · " .. t(state[field] and "on" or "off"), state[field])
			control.Name = "HUDToggle_" .. field
			control.Position = UDim2.fromOffset(34, 0); control.Size = UDim2.new(1, -34, 0, 30); control.TextSize = 10
			listen(control.Activated, function() setFeature(field, not state[field]) end, hudConnections)
			if hasValue then
				local number = valueControl(row, primaryValues[field], true, hudConnections)
				number.Position = UDim2.fromOffset(0, 33)
			end
			if field == "fly" and state.showFlyVertical then
				row.Size = UDim2.new(1, -2, 0, 124)
				local up = flightControl(row, "flyUp", 1, hudConnections)
				up.Position = UDim2.new(0, 0, 0, 90); up.Size = UDim2.new(0.5, -3, 0, 30)
				local down = flightControl(row, "flyDown", -1, hudConnections)
				down.Position = UDim2.new(0.5, 3, 0, 90); down.Size = UDim2.new(0.5, -3, 0, 30)
			end
		end
	end
	if count == 0 then
		local empty = label(statusBody, t("quickAccessHint"), 11)
		empty.Size = UDim2.new(1, -2, 0, 64)
	end
	for _, object in ipairs(statusBody:GetDescendants()) do if object:IsA("GuiObject") then object.ZIndex = 10 end end
	local valid = {}
	for _, entry in ipairs(flightButtons) do
		if entry.control.Parent then
			entry.control.Text = (state.flyVertical == entry.direction and "● " or "○ ") .. t(entry.key)
			table.insert(valid, entry)
		end
	end
	flightButtons = valid
end
featureOptions = function(parent, field)
	local row = new("Frame", {Name = "Options_" .. field, BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 28)}, parent)
	local quick = button(row, "")
	quick.Name = "Quick_" .. field; quick.TextSize = 10
	quick.Size = UDim2.new(state.mode == "desktop" and 0.58 or 1, -3, 1, 0)
	local function refresh()
		quick.Text = (state.quick[field] and "● " or "○ ") .. t("showQuickControl")
	end
	refresh()
	listen(quick.Activated, function()
		state.quick[field] = not state.quick[field]
		if state.quick[field] then state.statusPanel = true end
		refresh(); updateStatus(); updateLayout()
	end, pageConnections)
	if state.mode == "desktop" then
		local binding = button(row, state.bindings[field] and state.bindings[field].Name or t("featureHotkey"))
		binding.Name = "Bind_" .. field; binding.TextSize = 10
		binding.Position = UDim2.fromScale(0.59, 0); binding.Size = UDim2.new(0.41, 0, 1, 0)
		listen(binding.Activated, function() capturing = "feature"; captureField = field; binding.Text = t("pressKey") end, pageConnections)
	end
end
local function choice(parent, titleKey, options, selected, callback)
	local frame = card(parent, titleKey)
	local columns = #options <= 3 and #options or 2
	local container = new("Frame", {BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, math.ceil(#options / columns) * 40 - 6)}, frame)
	new("UIGridLayout", {CellSize = UDim2.new(1 / columns, -4, 0, 34), CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder, FillDirectionMaxCells = columns}, container)
	for _, option in ipairs(options) do
		local text = (option.id == selected and "●  " or "○  ") .. option.name
		local control = button(container, text, option.id == selected)
		control.TextSize = 11
		listen(control.Activated, function() callback(option.id) end, pageConnections)
	end
	return frame
end

local modal
local function closeModal()
	if sliderDrag then sliderDrag.finish(true) end
	disconnect(modalConnections)
	if modal then modal:Destroy(); modal = nil end
	prunePaints()
end
local function showLink()
	closeModal()
	modal = new("Frame", {Name = "DiscordLink", Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.25, Active = true, ZIndex = 30}, root)
	local panel = paint(new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0.9, 0, 0, 260), BorderSizePixel = 0, ZIndex = 31}, modal), "BackgroundColor3", "bg")
	new("UISizeConstraint", {MaxSize = Vector2.new(440, 260)}, panel)
	round(panel, 16)
	padding(panel, 18)
	stack(panel, 10)
	label(panel, t("linkTitle"), 17, true).ZIndex = 32
	local box = paint(new("TextBox", {Text = Config.DiscordUrl, ClearTextOnFocus = false,
		TextEditable = true, Font = Enum.Font.Gotham, TextSize = 15,
		Size = UDim2.new(1, 0, 0, 44), BorderSizePixel = 0, ZIndex = 32}, panel), "BackgroundColor3", "raised")
	paint(box, "TextColor3", "text")
	round(box, 8)
	local hint = paint(label(panel, t("copyHint"), 12), "TextColor3", "muted")
	hint.Size = UDim2.new(1, 0, 0, 70)
	hint.ZIndex = 32
	local back = button(panel, t("close"), true)
	back.ZIndex = 32
	listen(back.Activated, closeModal, modalConnections)
	listen(box.Focused, function()
		box.Text = Config.DiscordUrl
		box.CursorPosition = #box.Text + 1
		box.SelectionStart = 1
	end, modalConnections)
	if UserInputService.KeyboardEnabled then
		box:CaptureFocus()
		box.CursorPosition = #box.Text + 1
		box.SelectionStart = 1
	end
end

local function copyDiscord()
	if type(Capabilities.setclipboard) == "function" then
		local ok, result = pcall(Capabilities.setclipboard, Config.DiscordUrl)
		if ok and result ~= false then toast("clipboardCopied"); return end
	end
	showLink()
end

local function installCustomTheme(colors)
	if type(colors) ~= "table" then return end
	for _, key in ipairs({"bg", "accent", "accent2"}) do
		local rgb = colors[key]
		if type(rgb) ~= "table" or #rgb ~= 3 then return end
		for _, component in ipairs(rgb) do
			if type(component) ~= "number" or component ~= component or component < 0 or component > 255 then return end
		end
	end
	customColors = colors
	local bg = Color3.fromRGB(colors.bg[1], colors.bg[2], colors.bg[3])
	local light = (bg.R * 0.2126 + bg.G * 0.7152 + bg.B * 0.0722) > 0.55
	local text = light and Color3.fromRGB(22, 19, 31) or Color3.fromRGB(246, 242, 255)
	local mix = light and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	Config.Themes.custom = {
		name = Config.Themes.custom.name, bg = bg, surface = bg:Lerp(mix, 0.055), raised = bg:Lerp(mix, 0.12),
		accent = Color3.fromRGB(colors.accent[1], colors.accent[2], colors.accent[3]),
		accent2 = Color3.fromRGB(colors.accent2[1], colors.accent2[2], colors.accent2[3]),
		text = text, muted = bg:Lerp(text, 0.64), stroke = bg:Lerp(text, 0.25),
	}
end
local function colorHex(color)
	return string.format("#%02X%02X%02X", math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255))
end
showColorPicker = function(initial, callback, titleKey)
	closeModal(); releaseFlyControls()
	modal = new("Frame", {Name = "ColorPicker", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.25, Active = true, ZIndex = 30}, root)
	local panel = paint(new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(math.min(390, root.AbsoluteSize.X - 24), math.min(440, root.AbsoluteSize.Y - 24)),
		BorderSizePixel = 0, ZIndex = 31}, modal), "BackgroundColor3", "bg")
	local h, s, v = initial:ToHSV()
	local drawBody
	drawBody = function()
		disconnect(modalConnections)
		panel:ClearAllChildren(); round(panel, 12)
		local body = scroll(panel)
		padding(body, 12)
		label(body, t(titleKey) .. " · " .. t("anyColor"), 15, true)
		local preview = new("Frame", {Size = UDim2.new(1, -3, 0, 32), BackgroundColor3 = Color3.fromHSV(h, s, v), BorderSizePixel = 0}, body)
		round(preview, 7)
		local hex = paint(new("TextBox", {Name = "ColorHex", Text = colorHex(Color3.fromHSV(h, s, v)),
			ClearTextOnFocus = false, Size = UDim2.new(1, -3, 0, 32), Font = Enum.Font.Gotham,
			TextSize = 14, BorderSizePixel = 0}, body), "BackgroundColor3", "raised")
		paint(hex, "TextColor3", "text"); round(hex, 6)
		local function redraw()
			local color = Color3.fromHSV(h, s, v)
			preview.BackgroundColor3 = color; hex.Text = colorHex(color)
		end
		local _, setH = numberControl(body, "colorHue", h * 360, 0, 360, 1, function(value) h = value / 360; redraw() end, modalConnections)
		local _, setS = numberControl(body, "colorSaturation", s * 100, 0, 100, 1, function(value) s = value / 100; redraw() end, modalConnections)
		local _, setV = numberControl(body, "colorValue", v * 100, 0, 100, 1, function(value) v = value / 100; redraw() end, modalConnections)
		local function setColor(color)
			h, s, v = color:ToHSV(); setH(h * 360); setS(s * 100); setV(v * 100); redraw()
		end
		listen(hex.FocusLost, function()
			local value = hex.Text:gsub("#", ""):gsub("%s", "")
			if (#value ~= 6 and #value ~= 3) or value:find("[^%x]") then toast("colorInvalid"); redraw(); return end
			local ok, color = pcall(Color3.fromHex, value)
			if not ok then toast("colorInvalid"); redraw(); return end
			setColor(color)
		end, modalConnections)
		local grid = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -3, 0, 56)}, body)
		new("UIGridLayout", {CellSize = UDim2.new(1 / 6, -5, 0, 24), CellPadding = UDim2.fromOffset(6, 6), FillDirectionMaxCells = 6}, grid)
		for _, option in ipairs(Config.ColorPalette) do
			local color = option.color
			local swatch = new("TextButton", {Name = "Color_" .. option.id, BackgroundColor3 = color, Text = "", BorderSizePixel = 0}, grid)
			round(swatch, 5)
			listen(swatch.Activated, function() setColor(color) end, modalConnections)
		end
		local apply = button(body, t("apply"), true); apply.Name = "ColorApply"
		listen(apply.Activated, function()
			local color = Color3.fromHSV(h, s, v)
			closeModal(); callback(color)
		end, modalConnections)
		local cancel = button(body, t("close")); cancel.Name = "ColorCancel"
		listen(cancel.Activated, closeModal, modalConnections)
		for _, object in ipairs(panel:GetDescendants()) do if object:IsA("GuiObject") then object.ZIndex = 32 end end
		prunePaints()
	end
	drawBody()
end
local function palette(parent, titleKey, selected, callback)
	local container = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34)}, parent)
	local name = label(container, t(titleKey), 11)
	name.Size = UDim2.new(1, -116, 1, 0)
	local edit = new("TextButton", {Name = "ColorEdit_" .. titleKey, Position = UDim2.new(1, -110, 0, 0),
		Size = UDim2.fromOffset(110, 32), BackgroundColor3 = selected, BorderSizePixel = 0,
		Text = colorHex(selected), Font = Enum.Font.GothamBold, TextSize = 11,
		TextColor3 = selected.R + selected.G + selected.B > 1.7 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)}, container)
	round(edit, 7)
	listen(edit.Activated, function() showColorPicker(selected, callback, titleKey) end, pageConnections)
	return container
end

local navButtons = {}
local hotkeyButton, liftKeyButton
local selectedUserId
local function settingsPage(parent)
	choice(parent, "device", {{id = "desktop", name = t("desktop")}, {id = "mobile", name = t("mobile")}}, state.mode, function(id)
		state.mode = id; rebuild()
	end)
	if state.mode == "desktop" then
		local frame = card(parent, "hotkey", "hotkeyHint")
		hotkeyButton = button(frame, t("changeHotkey") .. ": " .. state.hotkey.Name)
		listen(hotkeyButton.Activated, function()
			capturing = "menu"; hotkeyButton.Text = t("pressKey")
		end, pageConnections)
		local reset = button(frame, t("resetHotkey"))
		listen(reset.Activated, function()
			capturing = nil; state.hotkey = Enum.KeyCode[Config.DefaultHotkey]
			for field, key in pairs(state.bindings) do if key == state.hotkey then state.bindings[field] = nil end end
			state.liftHotkey = state.bindings.lift or Enum.KeyCode.Unknown
			updateChrome(); buildPage(true)
		end, pageConnections)
		local liftKeyCard = card(parent, "liftHotkey", "liftHotkeyHint")
		liftKeyButton = button(liftKeyCard, t("changeLiftHotkey") .. ": " .. state.liftHotkey.Name)
		listen(liftKeyButton.Activated, function()
			capturing = "lift"; liftKeyButton.Text = t("pressKey")
		end, pageConnections)
		local resetLift = button(liftKeyCard, t("resetLiftHotkey"))
		listen(resetLift.Activated, function()
			state.liftHotkey = Enum.KeyCode[Config.DefaultLiftHotkey]
			if state.hotkey == state.liftHotkey then state.hotkey = Enum.KeyCode[Config.DefaultHotkey] end
			for field, key in pairs(state.bindings) do
				if key == state.hotkey or key == state.liftHotkey then state.bindings[field] = nil end
			end
			state.bindings.lift = state.liftHotkey
			capturing = nil; updateChrome(); buildPage(true)
		end, pageConnections)
	end
	toggle(parent, "statusPanel", "statusPanel", function(value)
		state.statusPanel = value; updateStatus(); updateLayout()
	end, "statusPanelHint")
	local hud = card(parent, "hudSettings", "hudSettingsHint")
	local pin = button(hud, t(state.hudPinned and "hudUnpin" or "hudPin"))
	listen(pin.Activated, function() state.hudPinned = not state.hudPinned; buildPage(true) end, pageConnections)
	local bound = button(hud, (state.hudOnlyBound and "● " or "○ ") .. t("hudOnlyBound"))
	listen(bound.Activated, function() state.hudOnlyBound = not state.hudOnlyBound; buildPage(true) end, pageConnections)
	local choices = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 174)}, hud)
	new("UIGridLayout", {CellSize = UDim2.new(0.5, -3, 0, 30), CellPadding = UDim2.fromOffset(6, 6), FillDirectionMaxCells = 2}, choices)
	for _, field in ipairs(featureOrder) do
		local select = button(choices, (state.quick[field] and "● " or "○ ") .. t(field))
		select.Name = "HUDSelect_" .. field; select.TextSize = 10
		listen(select.Activated, function()
			state.quick[field] = not state.quick[field]
			if state.quick[field] then state.statusPanel = true end
			buildPage(true); updateLayout()
		end, pageConnections)
	end
	choice(parent, "language", Config.Languages, state.language, function(id)
		state.language = id; rebuild()
	end)
	local themeOptions = {}
	for _, id in ipairs(Config.ThemeOrder) do
		table.insert(themeOptions, {id = id, name = Config.Themes[id].name})
	end
	local themeCard = choice(parent, "theme", themeOptions, state.theme, function(id)
		state.theme = id; applyTheme(); buildPage(true); updateStatus()
	end)
	local saveTheme = button(themeCard, t("defaultTheme"))
	local savingTheme = false
	listen(saveTheme.Activated, function()
		if savingTheme then return end
		savingTheme = true
		local selectedTheme = state.theme
		local result = request("SaveDefaultTheme", {theme = selectedTheme, customTheme = customColors})
		if report(result) then
			state.defaultTheme = selectedTheme
			toast(result.persistent and "themeSaved" or "themeSavedSession")
		end
		savingTheme = false
	end, pageConnections)
	local resetTheme = button(themeCard, t("resetTheme"))
	listen(resetTheme.Activated, function() state.theme = Config.DefaultTheme; applyTheme(); buildPage() end, pageConnections)
	local custom = card(parent, "customTheme", "customThemeHint")
	for _, entry in ipairs({{"bg", "customBackground"}, {"accent", "customAccent"}, {"accent2", "customAccent2"}}) do
		local key = entry[1]
		local rgb = customColors[key]
		palette(custom, entry[2], Color3.fromRGB(rgb[1], rgb[2], rgb[3]), function(color)
			customColors[key] = {math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255)}
			installCustomTheme(customColors); state.theme = "custom"; applyTheme(); buildPage(true); updateStatus()
		end)
	end
	local saveCustom = button(custom, t("saveCustomTheme"))
	listen(saveCustom.Activated, function()
		local result = request("SaveCustomTheme", {colors = customColors})
		if report(result) then toast(result.persistent and "customSaved" or "themeSavedSession") end
	end, pageConnections)
	local discordCard = card(parent, "discord")
	local copy = button(discordCard, t("copyLink"), true)
	listen(copy.Activated, copyDiscord, pageConnections)
	local reset = button(parent, t("resetAll"))
	listen(reset.Activated, function()
		if not report(request("Reset")) then return end
		releaseFlyControls()
		state.speed, state.noclip, state.lift = false, false, false
		state.fly, state.fullbright, state.statusPanel = false, false, false
		state.phase, state.phaseSpeed = false, 2
		state.quick, state.bindings = {}, {lift = Enum.KeyCode.H, phase = Enum.KeyCode.G}
		state.hudPinned, state.hudOnlyBound, state.hudPosition, state.showFlyVertical = false, false, nil, false
		state.esp, state.wallhack, state.thirdPerson = false, false, false
		state.speedValue, state.distance, state.fov = 24, 12, 70
		state.liftHeight, state.flySpeed, state.wallAlpha = 4, 48, 0.7
		state.fill, state.outline = 0.25, 1
		state.color = Color3.fromRGB(181, 125, 255)
		state.hotkey = Enum.KeyCode[Config.DefaultHotkey]
		state.liftHotkey = Enum.KeyCode[Config.DefaultLiftHotkey]
		state.theme = state.defaultTheme
		state.language = Config.DefaultLanguage
		state.mode = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "mobile" or "desktop"
		selectedUserId = nil
		capturing = nil; applyCamera(); updateHighlights(); applyTheme(); rebuild(); updateStatus(); toast("resetDone")
	end, pageConnections)
	local unload = button(parent, t("unload"))
	listen(unload.Activated, function()
		if report(request("Reset")) then cleanup() end
	end, pageConnections)
end
local function playersPage(parent)
	local frame = card(parent, "teleport", "teleportHint")
	local refresh = button(frame, t("refresh"))
	listen(refresh.Activated, buildPage, pageConnections)
	local others = {}
	for _, other in ipairs(Players:GetPlayers()) do if other ~= player then table.insert(others, other) end end
	table.sort(others, function(a, b) return a.Name:lower() < b.Name:lower() end)
	if #others == 0 then label(frame, t("noPlayers"), 13); return end
	for _, other in ipairs(others) do
		local target = other
		local control = button(frame, (target.UserId == selectedUserId and "● " or "") .. target.DisplayName .. " (@" .. target.Name .. ")", target.UserId == selectedUserId)
		control.Size = UDim2.new(1, 0, 0, 48)
		listen(control.Activated, function() selectedUserId = target.UserId; buildPage() end, pageConnections)
	end
	local teleport = button(frame, t("teleportTo"), true)
	local busy = false
	listen(teleport.Activated, function()
		if busy then return end
		if not selectedUserId then toast("selectPlayer"); return end
		busy = true
		if report(request("Teleport", {userId = selectedUserId})) then toast("success") end
		busy = false
	end, pageConnections)
end
local function visualsPage(parent)
	local wallCard = toggle(parent, "wallhack", "wallhack", function(value)
		return setFeature("wallhack", value, true)
	end, "wallhackHint")
	valueControl(wallCard, "wallAlpha"); featureOptions(wallCard, "wallhack")
	local brightCard = toggle(parent, "fullbright", "fullbright", function(value)
		return setFeature("fullbright", value, true)
	end, "fullbrightHint")
	featureOptions(brightCard, "fullbright")
	local espCard = toggle(parent, "esp", "esp", function(value)
		return setFeature("esp", value, true)
	end, "espHint")
	valueControl(espCard, "fill"); valueControl(espCard, "outline")
	palette(espCard, "espColor", state.color, function(color)
		state.color = color; updateHighlights(); buildPage(true)
	end)
	featureOptions(espCard, "esp")
end
local function movementPage(parent)
	local speedCard = toggle(parent, "speed", "speed", function(value)
		return setFeature("speed", value, true)
	end, "speedHint")
	valueControl(speedCard, "speedValue"); featureOptions(speedCard, "speed")
	local noclipCard = toggle(parent, "noclip", "noclip", function(value) return setFeature("noclip", value, true) end, "noclipHint")
	featureOptions(noclipCard, "noclip")
	local liftCard = toggle(parent, "lift", "lift", function(value)
		return setFeature("lift", value, true)
	end, "liftHint")
	valueControl(liftCard, "liftHeight"); featureOptions(liftCard, "lift")
	local flyCard = toggle(parent, "fly", "fly", function(value)
		return setFeature("fly", value, true)
	end, "flyHint")
	valueControl(flyCard, "flySpeed")
	local flightControls = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34)}, flyCard)
	local up = flightControl(flightControls, "flyUp", 1); up.Size = UDim2.new(0.5, -3, 1, 0)
	local down = flightControl(flightControls, "flyDown", -1); down.Position = UDim2.fromScale(0.5, 0); down.Size = UDim2.new(0.5, -3, 1, 0)
	featureOptions(flyCard, "fly")
	local vertical = button(flyCard, (state.showFlyVertical and "● " or "○ ") .. t("showFlyVertical"))
	vertical.Name = "QuickFlyVertical"
	listen(vertical.Activated, function()
		state.showFlyVertical = not state.showFlyVertical
		if state.showFlyVertical then state.quick.fly = true; state.statusPanel = true end
		buildPage(true); updateLayout()
	end, pageConnections)
	local phaseCard = toggle(parent, "phase", "phase", function(value) return setFeature("phase", value, true) end, "phaseHint")
	valueControl(phaseCard, "phaseSpeed"); featureOptions(phaseCard, "phase")
	local cameraCard = toggle(parent, "thirdPerson", "thirdPerson", function(value)
		return setFeature("thirdPerson", value, true)
	end, "thirdPersonHint")
	valueControl(cameraCard, "distance"); valueControl(cameraCard, "fov"); featureOptions(cameraCard, "thirdPerson")
end
local function storeCall(method, ...)
	local arguments = table.pack(...)
	local ok, result = pcall(function() return configStore[method](configStore, table.unpack(arguments, 1, arguments.n)) end)
	return ok and type(result) == "table" and result or {ok = false, message = "configWriteFailed"}
end
local function normalizedPosition(object)
	local area = root.AbsoluteSize
	return {x = math.clamp(object.Position.X.Offset / math.max(1, area.X - object.AbsoluteSize.X), 0, 1),
		y = math.clamp(object.Position.Y.Offset / math.max(1, area.Y - object.AbsoluteSize.Y), 0, 1)}
end
local function snapshot()
	local result = {version = 1, preferences = {}, values = {}, toggles = {}}
	local preferences = result.preferences
	for _, key in ipairs({"language", "mode", "theme", "defaultTheme", "statusPanel", "hudPinned", "hudOnlyBound", "showFlyVertical"}) do preferences[key] = state[key] end
	preferences.hotkey = state.hotkey.Name
	preferences.customColors = customColors
	preferences.quick, preferences.bindings = {}, {}
	preferences.hudPosition = normalizedPosition(statusHUD)
	preferences.orbPosition = normalizedPosition(orb)
	for _, field in ipairs(featureOrder) do
		result.toggles[field] = state[field]
		preferences.quick[field] = state.quick[field] == true
		preferences.bindings[field] = state.bindings[field] and state.bindings[field].Name or false
	end
	for key in pairs(valueSpecs) do result.values[key] = state[key] end
	result.values.color = {math.round(state.color.R * 255), math.round(state.color.G * 255), math.round(state.color.B * 255)}
	return result
end
local function finiteIn(value, low, high)
	return type(value) == "number" and value == value and value >= low and value <= high
end
local function validRGB(rgb)
	return type(rgb) == "table" and #rgb == 3 and finiteIn(rgb[1], 0, 255) and finiteIn(rgb[2], 0, 255) and finiteIn(rgb[3], 0, 255)
end
local function validPosition(position)
	return type(position) == "table" and finiteIn(position.x, 0, 1) and finiteIn(position.y, 0, 1)
end
local function keyFromName(name)
	if type(name) ~= "string" or #name > 40 or not name:match("^[A-Za-z][A-Za-z0-9]*$") then return nil end
	local ok, key = pcall(function() return Enum.KeyCode[name] end)
	if not ok or not key or key == Enum.KeyCode.Unknown or key == Enum.KeyCode.Escape or key == Enum.KeyCode.Return or key == Enum.KeyCode.Tab then return nil end
	return key
end
local function validateSnapshot(data)
	if type(data) ~= "table" or data.version ~= 1 or type(data.preferences) ~= "table" or type(data.values) ~= "table" or type(data.toggles) ~= "table" then return nil end
	local prefs, values, toggles = data.preferences, data.values, data.toggles
	if not Config.Translations[prefs.language] or (prefs.mode ~= "desktop" and prefs.mode ~= "mobile") or
		not Config.Themes[prefs.theme] or not Config.Themes[prefs.defaultTheme] then return nil end
	if type(prefs.customColors) ~= "table" then return nil end
	for _, field in ipairs({"bg", "accent", "accent2"}) do if not validRGB(prefs.customColors[field]) then return nil end end
	for _, field in ipairs({"statusPanel", "hudPinned", "hudOnlyBound", "showFlyVertical"}) do if type(prefs[field]) ~= "boolean" then return nil end end
	if not validPosition(prefs.hudPosition) or not validPosition(prefs.orbPosition) then return nil end
	if type(prefs.quick) ~= "table" or type(prefs.bindings) ~= "table" or not validRGB(values.color) then return nil end
	local hotkey = keyFromName(prefs.hotkey)
	if not hotkey then return nil end
	local bindings, used = {}, {[hotkey] = true}
	for _, field in ipairs(featureOrder) do
		if type(toggles[field]) ~= "boolean" or type(prefs.quick[field]) ~= "boolean" then return nil end
		local name = prefs.bindings[field]
		if name ~= false then
			local key = keyFromName(name)
			if not key or used[key] then return nil end
			bindings[field] = key; used[key] = true
		end
	end
	if toggles.fly and toggles.phase then return nil end
	for field, spec in pairs(valueSpecs) do
		if not finiteIn(values[field], spec.min / (spec.factor or 1), spec.max / (spec.factor or 1)) then return nil end
	end
	return {data = data, hotkey = hotkey, bindings = bindings}
end
local function applySnapshot(data)
	local checked = validateSnapshot(data)
	if not checked then toast("configCorrupt"); return false end
	closeModal(); releaseFlyControls()
	if sliderDrag then sliderDrag.finish(true) end
	if not report(request("Reset")) then return false end
	for _, field in ipairs(featureOrder) do state[field] = false end
	applyCamera(); updateHighlights()
	local prefs = data.preferences
	for _, field in ipairs({"language", "mode", "theme", "defaultTheme", "statusPanel", "hudPinned", "hudOnlyBound", "showFlyVertical", "hudPosition", "quick"}) do state[field] = prefs[field] end
	state.hotkey, state.bindings = checked.hotkey, checked.bindings
	state.liftHotkey = state.bindings.lift or Enum.KeyCode.Unknown
	installCustomTheme(prefs.customColors)
	for field in pairs(valueSpecs) do state[field] = data.values[field] end
	state.color = Color3.fromRGB(data.values.color[1], data.values.color[2], data.values.color[3])
	local area = root.AbsoluteSize
	orb.Position = UDim2.fromOffset(prefs.orbPosition.x * math.max(0, area.X - 46), prefs.orbPosition.y * math.max(0, area.Y - 46))
	local success = true
	for _, field in ipairs(featureOrder) do
		if data.toggles[field] and not setFeature(field, true, true) then success = false end
	end
	capturing = nil; applyTheme(); rebuild()
	if not success then toast("configApplyFailed") end
	return success
end
local function configsPage(parent)
	local frame = card(parent, "configurations", "configNameHint")
	local name = paint(new("TextBox", {Name = "ConfigName", Text = "", PlaceholderText = t("configName"),
		ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 13, Size = UDim2.new(1, 0, 0, 34), BorderSizePixel = 0}, frame), "BackgroundColor3", "raised")
	paint(name, "TextColor3", "text"); paint(name, "PlaceholderColor3", "muted"); round(name, 7)
	local create = button(frame, t("createConfig"), true); create.Name = "ConfigCreate"
	listen(create.Activated, function()
		local result = storeCall("Create", name.Text, snapshot())
		if report(result) then selectedConfig = result.name; buildPage(true); toast("configCreated") end
	end, pageConnections)
	local result = storeCall("List")
	if not result.ok then
		label(frame, t(result.message or "configStorageUnavailable"), 11).Size = UDim2.new(1, 0, 0, 48)
	else
		for _, config in ipairs(result.configs or {}) do
			local configName = config.name
			local select = button(frame, (selectedConfig == configName and "● " or "○ ") .. configName, selectedConfig == configName)
			select.Name = "ConfigSelect_" .. configName
			listen(select.Activated, function() selectedConfig = configName; buildPage(true) end, pageConnections)
		end
	end
	for _, action in ipairs({{method = "Load", key = "loadConfig", name = "ConfigLoad"},
		{method = "Overwrite", key = "overwriteConfig", name = "ConfigOverwrite"}, {method = "Delete", key = "deleteConfig", name = "ConfigDelete"}}) do
		local method, messageKey = action.method, action.key
		local control = button(frame, t(messageKey)); control.Name = action.name
		listen(control.Activated, function()
			if not selectedConfig then toast("configSelect"); return end
			local response = storeCall(method, selectedConfig, method == "Overwrite" and snapshot() or nil)
			if not report(response) then return end
			if method == "Load" then if applySnapshot(response.data) then toast("configLoaded") end
			elseif method == "Delete" then selectedConfig = nil; buildPage(true); toast("configDeleted")
			else buildPage(true); toast("configUpdated") end
		end, pageConnections)
	end
end
buildPage = function(keepScroll)
	local previous = content:FindFirstChildOfClass("ScrollingFrame")
	local scrollY = keepScroll == true and previous and previous.CanvasPosition.Y or 0
	if sliderDrag then sliderDrag.finish(true) end
	disconnect(pageConnections)
	capturing, hotkeyButton, liftKeyButton = nil, nil, nil
	content:ClearAllChildren()
	prunePaints()
	local page = scroll(content)
	if currentPage == "visuals" then visualsPage(page)
	elseif currentPage == "movement" then movementPage(page)
	elseif currentPage == "players" then playersPage(page)
	elseif currentPage == "configs" then configsPage(page)
	else settingsPage(page) end
	if scrollY > 0 then
		task.delay(0.05, function()
			if alive and page.Parent then page.CanvasPosition = Vector2.new(0, math.min(scrollY, math.max(0, page.AbsoluteCanvasSize.Y - page.AbsoluteSize.Y))) end
		end)
	end
	for id, control in pairs(navButtons) do
		control.BackgroundColor3 = Config.Themes[state.theme][id == currentPage and "accent" or "raised"]
	end
	updateStatus()
end

local function buildAccess()
	disconnect(pageConnections)
	content:ClearAllChildren()
	prunePaints()
	local page = scroll(content)
	local frame = card(page, "accessTitle", "accessBody")
	local keyBox = paint(new("TextBox", {Name = "KeyInput", Size = UDim2.new(1, 0, 0, 46), Text = "",
		PlaceholderText = t("keyPlaceholder"), ClearTextOnFocus = false,
		TextSize = 15, Font = Enum.Font.Gotham, BorderSizePixel = 0}, frame), "BackgroundColor3", "raised")
	paint(keyBox, "TextColor3", "text")
	paint(keyBox, "PlaceholderColor3", "muted")
	round(keyBox, 8)
	local unlockButton = button(frame, t("unlock"), true)
	unlockButton.Name = "Unlock"
	local busy = false
	local function submit()
		if busy then return end
		busy = true; unlockButton.Text = t("loading")
		local key = keyBox.Text:match("^%s*(.-)%s*$")
		local result = request("Unlock", {key = key})
		keyBox.Text = ""
		if report(result) then
			-- Start disabled, then apply the locally saved default theme.
			if report(request("Reset")) then
				installCustomTheme(result.customTheme)
				if Config.Themes[result.defaultTheme] then
					state.defaultTheme = result.defaultTheme
					state.theme = result.defaultTheme
					applyTheme()
				end
				unlocked = true; rebuild(); toast("keyAccepted")
			end
		end
		if unlockButton.Parent then unlockButton.Text = t("unlock") end
		busy = false
	end
	listen(unlockButton.Activated, submit, pageConnections)
	listen(keyBox.FocusLost, function(enter) if enter then submit() end end, pageConnections)
	choice(page, "device", {{id = "desktop", name = t("desktop")}, {id = "mobile", name = t("mobile")}}, state.mode, function(id)
		state.mode = id; rebuild()
	end)
	choice(page, "language", Config.Languages, state.language, function(id)
		state.language = id; rebuild()
	end)
end

local manuallyPositioned = false
updateChrome = function()
	subtitle.Text = t("titleSubtitle")
	footer.Text = state.mode == "desktop" and UserInputService.KeyboardEnabled
		and (state.hotkey.Name .. "  ·  " .. t("ready")) or t("mobileFooter")
	-- Keep a way back into the menu on touch-only devices even in PC mode.
	orb.Visible = state.mode == "mobile" or not UserInputService.KeyboardEnabled
	closeButton.Visible = true
end
updateLayout = function()
	local area = root.AbsoluteSize
	if area.X < 1 or area.Y < 1 then return end
	local usableWidth = area.X - (unlocked and state.statusPanel and area.X >= 900 and 234 or 0)
	local width = math.max(1, math.min(680, usableWidth - 24))
	local height = math.max(1, math.min(500, area.Y - 24))
	title.TextSize = width < 350 and 16 or 18
	window.Size = UDim2.fromOffset(width, height)
	if not manuallyPositioned then
		window.Position = UDim2.fromOffset((usableWidth - width) / 2, (area.Y - height) / 2)
	else
		window.Position = UDim2.fromOffset(math.clamp(window.Position.X.Offset, 0, math.max(0, area.X - width)),
			math.clamp(window.Position.Y.Offset, 0, math.max(0, area.Y - height)))
	end
	local compact = state.mode == "mobile" or width < 570
	if not unlocked then
		navigation.Visible = false
		content.Position = UDim2.fromOffset(12, 62)
		content.Size = UDim2.new(1, -24, 1, -96)
	elseif compact then
		navigation.Visible = true
		navigation.Position = UDim2.fromOffset(12, 62)
		navigation.Size = UDim2.new(1, -24, 0, 36)
		content.Position = UDim2.fromOffset(12, 106)
		content.Size = UDim2.new(1, -24, 1, -140)
	else
		navigation.Visible = true
		navigation.Position = UDim2.fromOffset(12, 64)
		navigation.Size = UDim2.new(0, 118, 1, -100)
		content.Position = UDim2.fromOffset(142, 64)
		content.Size = UDim2.new(1, -154, 1, -98)
	end
	for index, id in ipairs(pageIds) do
		local control = navButtons[id]
		if control then
			control.Position = compact and UDim2.new((index - 1) / #pageIds, 2, 0, 0) or UDim2.fromOffset(0, (index - 1) * 44)
			control.Size = compact and UDim2.new(1 / #pageIds, -4, 0, 36) or UDim2.new(1, 0, 0, 36)
			control.TextSize = compact and 10 or 12
		end
	end
	orb.Position = UDim2.fromOffset(math.clamp(orb.Position.X.Offset, 0, math.max(0, area.X - 46)),
		math.clamp(orb.Position.Y.Offset, 0, math.max(0, area.Y - 46)))
	local hudWidth, hudHeight = math.min(214, area.X - 20), math.max(100, math.min(360, area.Y - 30))
	statusHUD.Size = UDim2.fromOffset(hudWidth, hudHeight)
	local position = state.hudPosition
	statusHUD.Position = UDim2.fromOffset(position and position.x * math.max(0, area.X - hudWidth) or math.max(0, area.X - hudWidth - 10),
		position and position.y * math.max(0, area.Y - hudHeight) or math.min(70, math.max(0, area.Y - hudHeight)))
	updateStatus()
end
rebuild = function()
	closeModal()
	navigation:ClearAllChildren()
	navButtons = {}
	if unlocked then
		for _, id in ipairs(pageIds) do
			local pageId = id
			local control = button(navigation, t(id == "configs" and "configurations" or id))
			control.Name = id
			navButtons[id] = control
			-- Destroying buttons disconnects these short-lived navigation listeners.
			control.Activated:Connect(function() currentPage = pageId; buildPage() end)
		end
		buildPage()
	else buildAccess() end
	updateChrome(); updateLayout()
end
setOpen = function(value)
	opened = value
	capturing = nil
	if not value then closeModal(); releaseFlyControls() end
	window.Visible = value
	if value then
		window.BackgroundTransparency = 0.15
		TweenService:Create(window, TweenInfo.new(0.16), {BackgroundTransparency = 0}):Play()
	end
	if hotkeyButton and hotkeyButton.Parent then hotkeyButton.Text = t("changeHotkey") .. ": " .. state.hotkey.Name end
	if liftKeyButton and liftKeyButton.Parent then liftKeyButton.Text = t("changeLiftHotkey") .. ": " .. state.liftHotkey.Name end
	updateStatus()
end
listen(closeButton.Activated, function() setOpen(false) end)

-- Dragging uses one shared input tracker. Movement beyond 8 px suppresses orb taps.
local drag
local function draggable(handle, object, isOrb)
	listen(handle.InputBegan, function(input)
		local kind = input.UserInputType
		if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
		if object == statusHUD and state.hudPinned then return end
		if drag then return end
		drag = {input = input, object = object, start = Vector2.new(input.Position.X, input.Position.Y),
			position = object.Position, isOrb = isOrb, moved = false, touch = kind == Enum.UserInputType.Touch}
	end)
end
draggable(header, window, false)
draggable(orb, orb, true)
draggable(statusHeading, statusHUD, false)
listen(UserInputService.InputChanged, function(input)
	if sliderDrag and ((sliderDrag.touch and input == sliderDrag.input) or
		(not sliderDrag.touch and input.UserInputType == Enum.UserInputType.MouseMovement)) then
		sliderDrag.change(input.Position.X); return
	end
	if not drag then return end
	if drag.object == statusHUD and state.hudPinned then drag = nil; return end
	if drag.touch and input ~= drag.input then return end
	if not drag.touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	local delta = Vector2.new(input.Position.X, input.Position.Y) - drag.start
	if delta.Magnitude > 8 then drag.moved = true end
	if not drag.moved then return end
	local size = drag.object.AbsoluteSize
	local area = root.AbsoluteSize
	drag.object.Position = UDim2.fromOffset(
		math.clamp(drag.position.X.Offset + delta.X, 0, math.max(0, area.X - size.X)),
		math.clamp(drag.position.Y.Offset + delta.Y, 0, math.max(0, area.Y - size.Y)))
	if drag.object == window then manuallyPositioned = true end
	if drag.object == statusHUD then state.hudPosition = normalizedPosition(statusHUD) end
end)
listen(UserInputService.InputEnded, function(input)
	if flyPointers[input] then
		flyPointers[input] = nil
		local sum = 0; for _, held in pairs(flyPointers) do sum = sum + held end
		request("SetFlyInput", {vertical = math.clamp(sum, -1, 1)})
	end
	if sliderDrag and ((sliderDrag.touch and input == sliderDrag.input) or
		(not sliderDrag.touch and input.UserInputType == Enum.UserInputType.MouseButton1)) then
		sliderDrag.finish(false)
	end
	if not drag then return end
	if drag.touch and input ~= drag.input then return end
	if not drag.touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local wasDrag = drag
	drag = nil
	if wasDrag.isOrb and not wasDrag.moved then setOpen(not opened) end
end)
listen(UserInputService.WindowFocusReleased, function()
	drag = nil; releaseFlyControls()
	if sliderDrag then sliderDrag.finish(true) end
	updateStatus()
end)
listen(UserInputService.InputBegan, function(input, processed)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local key = input.KeyCode
	if capturing and opened and state.mode == "desktop" then
		if key == Enum.KeyCode.Escape then capturing = nil; buildPage(true); return end
		if processed or UserInputService:GetFocusedTextBox() then return end
		local target = capturing == "lift" and "lift" or captureField
		if capturing ~= "menu" and key == Enum.KeyCode.Backspace then
			state.bindings[target] = nil
			state.liftHotkey = state.bindings.lift or Enum.KeyCode.Unknown
			capturing, captureField = nil, nil; buildPage(true); return
		end
		if key == Enum.KeyCode.Unknown or key == Enum.KeyCode.Return or key == Enum.KeyCode.Tab then toast("blockedKey"); return end
		if capturing ~= "menu" and key == state.hotkey then toast("hotkeysConflict"); return end
		for field, boundKey in pairs(state.bindings) do
			if boundKey == key and (capturing == "menu" or field ~= target) then toast("hotkeysConflict"); return end
		end
		if capturing == "menu" then state.hotkey = key else state.bindings[target] = key end
		state.liftHotkey = state.bindings.lift or Enum.KeyCode.Unknown
		capturing, captureField = nil, nil; updateChrome(); buildPage(true); return
	end
	if not processed and not UserInputService:GetFocusedTextBox() and state.mode == "desktop" then
		if key == state.hotkey then setOpen(not opened)
		elseif unlocked then
			for _, field in ipairs(featureOrder) do
				if state.bindings[field] == key then setFeature(field, not state[field]); break end
			end
		end
	end
end)
listen(root:GetPropertyChangedSignal("AbsoluteSize"), updateLayout)
listen(Players.PlayerAdded, function(other)
	watchPlayer(other)
	if unlocked and currentPage == "players" then buildPage() end
end)
listen(Players.PlayerRemoving, function(other)
	if highlights[other] then highlights[other]:Destroy(); highlights[other] = nil end
	if playerConnections[other] then disconnect(playerConnections[other]); playerConnections[other] = nil end
	if selectedUserId == other.UserId then selectedUserId = nil end
	if unlocked and currentPage == "players" then task.defer(function() if alive then buildPage() end end) end
end)
cleanup = function()
	if not alive then return end
	if sliderDrag then sliderDrag.finish(true) end
	table.clear(flyPointers)
	alive = false
	backend:Destroy()
	restoreCamera()
	disconnect(connections); disconnect(pageConnections); disconnect(modalConnections); disconnect(hudConnections)
	for _, list in pairs(playerConnections) do disconnect(list) end
	for _, highlight in pairs(highlights) do highlight:Destroy() end
	highlightFolder:Destroy()
	gui:Destroy()
end
listen(gui.Destroying, function()
	if alive then
		cleanup()
	end
end)
listen(controlEvent.Event, function(action)
	if action == "Open" then setOpen(true) end
end)
for _, other in ipairs(Players:GetPlayers()) do watchPlayer(other) end
rebuild()

