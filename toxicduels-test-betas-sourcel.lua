-- =====================================================
--  TOXIC DUELS v1.0 | Redesign of WaterHub
--  Part 1/6: Core, State, Config, Helpers
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local MaterialService = game:GetService("MaterialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local TOXIC = {name = "Toxic Duels", build = "TD-1"}

-- ===== CONFIG FILES =====
local CONFIG_FILE = "ToxicDuels_Config.json"
local KEYBINDS_CONFIG_FILE = "ToxicDuels_Keybinds.json"

-- ===== STATE =====
NS = 59.5
CS = 28.8
LAGGER_SPEED = 29
LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
autoStealEnabled = false
selectedStealMode = "Semi"
autoStealRadius = 9
_G.ToxicStealRadii = _G.ToxicStealRadii or {Normal = 9, Semi = 9}
AIMBOT_SPEED = 58
LAGGER_AIMBOT_SPEED = 40
autoSwingEnabled = false
mirrorTPDownEnabled = false
_G.AimbotOn = _G.AimbotOn or false
tpBatSwingEnabled = false
_G.TPBatOn = _G.TPBatOn or false
TPBAT_SPEED = 58
batCounterEnabled = false
medCounterEnabled = false
safeModeEnabled = false
autoResetOnMedEnabled = false
autoInstaResetOnDeathEnabled = false
espEnabled = false
showTracerEnabled = false
ragdollCountdownEnabled = false
stretchRezEnabled = false
antiLagEnabled = false
nukeOptimiserEnabled = false
fovEnabled = false
fovValue = 70
noCamCollisionEnabled = false
skyTheme = "Off"
autoLeftEnabled = false
autoRightEnabled = false
laggerEnabled = false
laggerLevel = "low"
laggerThread = nil
laggerWindowOpen = true
infJumpEnabled = false
antiRagdollEnabled = false
antiDieEnabled = false
aimbotHeight = 6.25
stealSoundEnabled = false
stealSoundId = "9046863579"
stealSoundVolume = 1
trackerEnabled = true
ragdollStealEnabled = false
ragdollStealLead = 1.3
stealAlertEnabled = true
mirrorAngleEnabled = true
selectedAnimationPack = "OFF"
customAnimIds = {idle = "", walk = "", run = "", jump = "", fall = "", climb = ""}
currentBackground = 0

LAGGER_LEVELS = {
    low = {poder = 18, texto = "SPEED RECOMMENDED 50-25"},
    mid = {poder = 27, texto = "SPEED RECOMMENDED 42-20"},
    high = {poder = 32, texto = "SPEED RECOMMENDED 40-17"},
    ultra = {poder = 80, texto = "EXTREME POWER - USE WITH CAUTION"}
}
LAGGER_LEVEL_KEYS = {"low", "mid", "high", "ultra"}
LAGGER_LEVEL_LABELS = {low = "LOW", mid = "MID", high = "HIGH", ultra = "ULTRA"}

DEFAULT_SPEED_KEYBINDS = {
    SpeedToggle = Enum.KeyCode.Q,
    LaggerToggle = Enum.KeyCode.R,
    DropBrainrot = Enum.KeyCode.X,
    Aimbot = Enum.KeyCode.E,
    TPBat = Enum.KeyCode.V,
    AutoLeft = Enum.KeyCode.Z,
    AutoRight = Enum.KeyCode.C,
    InstantReset = Enum.KeyCode.T,
    AntiDie = Enum.KeyCode.G,
    LaggerActivate = Enum.KeyCode.H,
    ToggleUI = Enum.KeyCode.LeftControl,
    ToxicLagger = Enum.KeyCode.M,
}
DEFAULT_TP_DOWN_KEYBIND = Enum.KeyCode.F

speedKeybinds = {}
for k, v in pairs(DEFAULT_SPEED_KEYBINDS) do speedKeybinds[k] = v end
speedKeybindButtons = {}
listeningForSpeedKey = nil
tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
tpDownKeybindButton = nil
listeningForTPDownKey = false
keybindListenStartedAt = 0

-- ===== SAVE/LOAD =====
_water_isfile = isfile or (syn and syn.isfile) or function(path)
    local ok, result = pcall(function() return readfile(path) end)
    return ok and result ~= nil
end
_water_readfile = readfile or (syn and syn.readfile)
_water_writefile = writefile or (syn and syn.writefile)
canSaveConfig = (type(_water_readfile) == "function" and type(_water_writefile) == "function")

savedConfig = {}
_G.ToxicGuiLocked = _G.ToxicGuiLocked == true
_G.ToxicHideMobileButtons = _G.ToxicHideMobileButtons == true
_G.ToxicMobileButtonScale = 0.75
_G.ToxicMobileButtonPositions = _G.ToxicMobileButtonPositions or {}

-- ===== ACCENT (Toxic Green) =====
DEFAULT_ACCENT = Color3.fromRGB(82, 255, 70)
ACCENT = DEFAULT_ACCENT
accentAppliers = {}

function accentToTable(c)
    c = c or ACCENT
    return {math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)}
end

function tableToAccent(t)
    if type(t) == "table" and tonumber(t[1]) and tonumber(t[2]) and tonumber(t[3]) then
        return Color3.fromRGB(math.clamp(tonumber(t[1]), 0, 255), math.clamp(tonumber(t[2]), 0, 255), math.clamp(tonumber(t[3]), 0, 255))
    end
    return nil
end

function accentDim(c, f)
    c = c or ACCENT
    f = f or 0.5
    return Color3.new(c.R * f, c.G * f, c.B * f)
end

function accentMix(c, other, a)
    c = c or ACCENT
    return c:Lerp(other, a)
end

function registerAccent(fn)
    accentAppliers[#accentAppliers + 1] = fn
    pcall(fn, ACCENT)
end

function applyAccent(c, skipSave)
    if not c then return end
    ACCENT = c
    for i = 1, #accentAppliers do pcall(accentAppliers[i], c) end
    if skipSave ~= true and saveToxicConfig then pcall(saveToxicConfig) end
end

_G.ToxicGetAccent = function() return ACCENT end

-- ===== SKIN (Toxic Green Dark) =====
SKIN = {
    void = Color3.fromRGB(8, 18, 14),
    sheet = Color3.fromRGB(12, 26, 20),
    slab = Color3.fromRGB(17, 34, 26),
    slabHot = Color3.fromRGB(24, 46, 34),
    seam = Color3.fromRGB(58, 190, 90),
    seamSoft = Color3.fromRGB(34, 118, 66),
    ink = Color3.fromRGB(255, 255, 255),
    inkMute = Color3.fromRGB(196, 248, 208),
    inkFaint = Color3.fromRGB(150, 226, 176),
    well = Color3.fromRGB(48, 178, 92),
}

TYPE_HEAVY = Enum.Font.GothamBlack
TYPE_BOLD = Enum.Font.GothamBold
TYPE_BODY = Enum.Font.GothamMedium
SNAP = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- ===== HELPERS =====
function round(obj, px)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, px or 6)
    c.Parent = obj
    return c
end

function edge(obj, col, thick, clear)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = col or SKIN.seamSoft
    s.Thickness = thick or 1
    s.Transparency = clear == nil and 0.45 or clear
    s.Parent = obj
    return s
end

function glide(obj, props, secs)
    TweenService:Create(obj, secs and TweenInfo.new(secs, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) or SNAP, props):Play()
end

function inset(obj, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = obj
    return p
end

function caption(parent, text, size, font, col, align)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text or ""
    t.TextSize = size or 12
    t.Font = font or TYPE_BODY
    t.TextColor3 = col or SKIN.ink
    t.TextXAlignment = align or Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

function chipButton(parent, text, w, h)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = SKIN.well
    b.BackgroundTransparency = 0.15
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = text or ""
    b.TextColor3 = SKIN.ink
    b.TextSize = 10
    b.Font = TYPE_BOLD
    b.Size = UDim2.new(0, w or 56, 0, h or 24)
    b.Parent = parent
    round(b, 5)
    edge(b, SKIN.seamSoft, 1, 0.4)
    b.MouseEnter:Connect(function() glide(b, {BackgroundTransparency = 0}) end)
    b.MouseLeave:Connect(function() glide(b, {BackgroundTransparency = 0.15}) end)
    return b
end

function grip(frame)
    local held, origin, base, tracked = false, nil, nil, nil
    frame.InputBegan:Connect(function(input)
        if _G.ToxicGuiLocked == true then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            held = true
            origin = input.Position
            base = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then held = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            tracked = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if _G.ToxicGuiLocked == true then return end
        if input == tracked and held then
            local d = input.Position - origin
            frame.Position = UDim2.new(base.X.Scale, base.X.Offset + d.X, base.Y.Scale, base.Y.Offset + d.Y)
        end
    end)
end

function udim2ToTable(u)
    return {xs = u.X.Scale, xo = u.X.Offset, ys = u.Y.Scale, yo = u.Y.Offset}
end

function tableToUDim2(t, fallback)
    if type(t) == "table" then
        return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0)
    end
    return fallback
end

function keyToString(key)
    if not key then return "None" end
    return tostring(key):gsub("Enum.KeyCode.", "")
end

function stringToKeyCode(value)
    if type(value) ~= "string" or value == "" or value == "None" then return nil end
    return Enum.KeyCode[value]
end

function keyName(key)
    if not key then return "None" end
    local name = tostring(key):gsub("Enum.KeyCode.", "")
    name = name:gsub("Button", "BTN ")
    name = name:gsub("DPad", "DPad ")
    return name
end

function hexOf(c)
    return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

-- ===== KEYBIND TABLE =====
function keybindsToTable()
    local out = {}
    for keyId in pairs(DEFAULT_SPEED_KEYBINDS) do
        out[keyId] = keyToString(speedKeybinds[keyId])
    end
    for keyId, key in pairs(speedKeybinds) do
        out[keyId] = keyToString(key)
    end
    return out
end

-- ===== SAVE/LOAD CONFIG =====
function collectToxicConfig()
    return {
        accentColor = accentToTable(),
        keybinds = keybindsToTable(),
        tpDownKeybind = keyToString(tpDownKeybind),
        NS = NS, CS = CS,
        LAGGER_SPEED = LAGGER_SPEED,
        LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
        currentSpeedMode = currentSpeedMode,
        autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
        infJumpEnabled = infJumpEnabled,
        antiRagdollEnabled = antiRagdollEnabled,
        autoStealEnabled = autoStealEnabled,
        autoStealRadius = autoStealRadius,
        AIMBOT_SPEED = AIMBOT_SPEED,
        LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
        TPBAT_SPEED = TPBAT_SPEED,
        autoSwingEnabled = autoSwingEnabled,
        mirrorTPDownEnabled = mirrorTPDownEnabled,
        normalAimbotEnabled = _G.AimbotOn == true,
        tpBatSwingEnabled = tpBatSwingEnabled,
        antiDesyncAimbotEnabled = _G.TPBatOn == true,
        antiDieEnabled = antiDieEnabled == true,
        stealSoundEnabled = stealSoundEnabled == true,
        stealSoundId = tostring(stealSoundId or ""),
        trackerEnabled = trackerEnabled == true,
        ragdollStealEnabled = ragdollStealEnabled == true,
        mirrorAngleEnabled = mirrorAngleEnabled == true,
        aimbotHeight = tonumber(aimbotHeight) or 6.25,
        stealAlertEnabled = stealAlertEnabled == true,
        ragdollStealLead = tonumber(ragdollStealLead) or 1.3,
        customAnimIds = customAnimIds,
        batCounterEnabled = batCounterEnabled,
        medCounterEnabled = medCounterEnabled,
        safeMode = safeModeEnabled == true,
        autoResetOnMedEnabled = autoResetOnMedEnabled,
        autoInstaResetOnDeathEnabled = autoInstaResetOnDeathEnabled == true,
        espEnabled = espEnabled,
        showTracerEnabled = showTracerEnabled,
        ragdollCountdownEnabled = ragdollCountdownEnabled,
        stretchRezEnabled = stretchRezEnabled,
        antiLagEnabled = antiLagEnabled,
        nukeOptimiserEnabled = nukeOptimiserEnabled,
        fovEnabled = fovEnabled,
        fovValue = fovValue,
        noCamCollisionEnabled = noCamCollisionEnabled,
        skyTheme = skyTheme,
        autoLeftEnabled = autoLeftEnabled,
        autoRightEnabled = autoRightEnabled,
        laggerEnabled = laggerEnabled,
        laggerLevel = laggerLevel,
        currentBackground = currentBackground,
        guiLocked = _G.ToxicGuiLocked == true,
        hideMobileButtons = _G.ToxicHideMobileButtons == true,
        toxicMobileButtonScale = _G.ToxicMobileButtonScale,
        mobileButtonPositions = _G.ToxicMobileButtonPositions,
    }
end

function saveToxicConfig()
    if not canSaveConfig then return end
    pcall(function()
        _water_writefile(CONFIG_FILE, HttpService:JSONEncode(collectToxicConfig()))
        _water_writefile(KEYBINDS_CONFIG_FILE, HttpService:JSONEncode({
            keybinds = keybindsToTable(),
            tpDownKeybind = keyToString(tpDownKeybind),
        }))
    end)
end

function loadToxicConfig()
    if not canSaveConfig or not _water_isfile(CONFIG_FILE) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(_water_readfile(CONFIG_FILE)) end)
    if not ok or type(data) ~= "table" then return end
    savedConfig = data
    local ac = tableToAccent(data.accentColor)
    if ac then ACCENT = ac end
    local keybindData = data
    pcall(function()
        if _water_isfile(KEYBINDS_CONFIG_FILE) then
            local kb = HttpService:JSONDecode(_water_readfile(KEYBINDS_CONFIG_FILE))
            if type(kb) == "table" then keybindData = kb end
        end
    end)
    if type(keybindData.keybinds) == "table" then
        for keyId, keyStr in pairs(keybindData.keybinds) do
            speedKeybinds[keyId] = stringToKeyCode(keyStr)
        end
    end
    if keybindData.tpDownKeybind then
        tpDownKeybind = (tostring(keybindData.tpDownKeybind) == "None") and nil or (stringToKeyCode(keybindData.tpDownKeybind) or DEFAULT_TP_DOWN_KEYBIND)
    end
    NS = tonumber(data.NS) or NS
    CS = tonumber(data.CS) or CS
    LAGGER_SPEED = tonumber(data.LAGGER_SPEED) or LAGGER_SPEED
    LAGGER_CARRY_SPEED = tonumber(data.LAGGER_CARRY_SPEED) or LAGGER_CARRY_SPEED
    currentSpeedMode = data.currentSpeedMode or currentSpeedMode
    autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
    infJumpEnabled = data.infJumpEnabled == true
    antiRagdollEnabled = data.antiRagdollEnabled == true
    autoStealEnabled = data.autoStealEnabled == true
    autoStealRadius = tonumber(data.autoStealRadius) or autoStealRadius
    AIMBOT_SPEED = tonumber(data.AIMBOT_SPEED) or AIMBOT_SPEED
    LAGGER_AIMBOT_SPEED = tonumber(data.LAGGER_AIMBOT_SPEED) or LAGGER_AIMBOT_SPEED
    TPBAT_SPEED = tonumber(data.TPBAT_SPEED) or TPBAT_SPEED
    autoSwingEnabled = data.autoSwingEnabled == true
    mirrorTPDownEnabled = data.mirrorTPDownEnabled == true
    _G.AimbotOn = data.normalAimbotEnabled == true
    tpBatSwingEnabled = data.tpBatSwingEnabled == true
    _G.TPBatOn = data.antiDesyncAimbotEnabled == true
    antiDieEnabled = data.antiDieEnabled == true
    stealSoundEnabled = data.stealSoundEnabled == true
    trackerEnabled = data.trackerEnabled ~= false
    ragdollStealEnabled = data.ragdollStealEnabled == true
    mirrorAngleEnabled = data.mirrorAngleEnabled ~= false
    aimbotHeight = tonumber(data.aimbotHeight) or aimbotHeight
    stealAlertEnabled = data.stealAlertEnabled ~= false
    ragdollStealLead = tonumber(data.ragdollStealLead) or ragdollStealLead
    if type(data.stealSoundId) == "string" and data.stealSoundId ~= "" then stealSoundId = data.stealSoundId end
    if type(data.customAnimIds) == "table" then
        for key, value in pairs(data.customAnimIds) do
            if type(value) == "string" then customAnimIds[key] = value end
        end
    end
    batCounterEnabled = data.batCounterEnabled == true
    medCounterEnabled = data.medCounterEnabled == true
    safeModeEnabled = data.safeMode == true
    autoResetOnMedEnabled = data.autoResetOnMedEnabled == true
    autoInstaResetOnDeathEnabled = data.autoInstaResetOnDeathEnabled == true
    espEnabled = data.espEnabled == true
    showTracerEnabled = data.showTracerEnabled == true
    ragdollCountdownEnabled = data.ragdollCountdownEnabled == true
    stretchRezEnabled = data.stretchRezEnabled == true
    antiLagEnabled = data.antiLagEnabled == true
    nukeOptimiserEnabled = data.nukeOptimiserEnabled == true
    fovEnabled = data.fovEnabled == true
    fovValue = tonumber(data.fovValue) or fovValue
    noCamCollisionEnabled = data.noCamCollisionEnabled == true
    skyTheme = (type(data.skyTheme) == "string" and data.skyTheme) or skyTheme
    autoLeftEnabled = data.autoLeftEnabled == true
    autoRightEnabled = data.autoRightEnabled == true
    _G.ToxicGuiLocked = data.guiLocked == true
    _G.ToxicHideMobileButtons = data.hideMobileButtons == true
    _G.ToxicMobileButtonScale = math.clamp(tonumber(data.toxicMobileButtonScale) or 0.75, 0.30, 1.35)
    _G.ToxicMobileButtonPositions = type(data.mobileButtonPositions) == "table" and data.mobileButtonPositions or {}
    laggerLevel = (type(data.laggerLevel) == "string" and LAGGER_LEVELS[data.laggerLevel]) and data.laggerLevel or "low"
    if autoLeftEnabled and autoRightEnabled then autoRightEnabled = false end
end

loadToxicConfig()

-- ===== BG ART =====
BG_ART = "rbxassetid://117556655195554"
ART_ASSET = "rbxassetid://134035617107773"

-- =====================================================
--  TOXIC DUELS | Part 2/6: UI Shell
-- =====================================================

-- ===== BACKDROPS =====
BACKDROPS = {
    {name = "Ink", color = Color3.fromRGB(8, 18, 14)},
    {name = "Toxic", color = Color3.fromRGB(12, 30, 20)},
    {name = "Tinted", accent = true},
    {name = "Abyss", color = Color3.fromRGB(4, 10, 8)},
    {name = "Signal", image = "rbxassetid://14640607134", color = Color3.fromRGB(8, 18, 14)},
    {name = "Art", image = BG_ART, color = Color3.fromRGB(8, 18, 14)},
}

-- ===== GUI ROOT =====
Gui = Instance.new("ScreenGui")
Gui.Name = "ToxicDuelsInterface"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

FULL_MAIN_SIZE = UDim2.new(0, 556, 0, 460)

Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0, 0.5)
Main.Size = FULL_MAIN_SIZE
Main.Position = tableToUDim2(savedConfig.mainPosition, UDim2.new(0, 24, 0.5, 0))
savedMainPositionTable = udim2ToTable(Main.Position)
Main.BackgroundColor3 = SKIN.void
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = Gui
round(Main, 10)
edge(Main, SKIN.seam, 1, 0.3)
grip(Main)
Main:GetPropertyChangedSignal("Position"):Connect(function()
    savedMainPositionTable = udim2ToTable(Main.Position)
end)

-- Backdrop
Backdrop = Instance.new("Frame")
Backdrop.Name = "Backdrop"
Backdrop.BackgroundColor3 = SKIN.void
Backdrop.BorderSizePixel = 0
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.Visible = false
Backdrop.ZIndex = 1
Backdrop.ClipsDescendants = true
Backdrop.Parent = Main
round(Backdrop, 10)

BackdropArt = Instance.new("ImageLabel")
BackdropArt.Name = "Art"
BackdropArt.BackgroundTransparency = 1
BackdropArt.BorderSizePixel = 0
BackdropArt.Size = UDim2.new(1, 0, 1, 0)
BackdropArt.ScaleType = Enum.ScaleType.Crop
BackdropArt.ImageTransparency = 0.12
BackdropArt.Visible = false
BackdropArt.ZIndex = 2
BackdropArt.Parent = Backdrop

BackdropScrim = Instance.new("Frame")
BackdropScrim.Name = "Scrim"
BackdropScrim.BackgroundColor3 = Color3.fromRGB(5, 12, 8)
BackdropScrim.BackgroundTransparency = 0.34
BackdropScrim.BorderSizePixel = 0
BackdropScrim.Size = UDim2.new(1, 0, 1, 0)
BackdropScrim.Visible = false
BackdropScrim.ZIndex = 2
BackdropScrim.Parent = Backdrop

function backdropTint(style)
    if style.accent then return accentDim(ACCENT, 0.2) end
    return style.color
end

function applyBackground(index)
    currentBackground = index or 0
    local style = BACKDROPS[currentBackground]
    if not style then
        currentBackground = 0
        Main.BackgroundColor3 = SKIN.void
        Backdrop.Visible = false
        BackdropArt.Visible = false
        BackdropScrim.Visible = false
        saveToxicConfig()
        return "Off"
    end
    Backdrop.BackgroundColor3 = backdropTint(style)
    Backdrop.Visible = true
    local hasArt = style.image ~= nil and style.image ~= "rbxassetid://0"
    BackdropArt.Image = hasArt and style.image or ""
    BackdropArt.Visible = hasArt
    BackdropScrim.Visible = hasArt
    saveToxicConfig()
    return style.name
end

applyBackground(currentBackground)
registerAccent(function()
    local style = BACKDROPS[currentBackground]
    if style and style.accent then Backdrop.BackgroundColor3 = accentDim(ACCENT, 0.2) end
end)

-- ===== BRAND =====
Brand = Instance.new("TextLabel")
Brand.Name = "Brand"
Brand.BackgroundTransparency = 1
Brand.RichText = true
Brand.Size = UDim2.new(0, 240, 0, 22)
Brand.Position = UDim2.new(0, 42, 0, 16)
Brand.Text = 'TOXIC<font color="' .. hexOf(ACCENT) .. '">DUELS</font>'
Brand.TextColor3 = SKIN.ink
Brand.Font = TYPE_HEAVY
Brand.TextSize = 18
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.ZIndex = 6
Brand.Parent = Main
registerAccent(function(c) Brand.Text = 'TOXIC<font color="' .. hexOf(c) .. '">DUELS</font>' end)

-- Logo (drop icon)
AccentPip = Instance.new("Frame")
AccentPip.Name = "Logo"
AccentPip.Size = UDim2.new(0, 20, 0, 24)
AccentPip.Position = UDim2.new(0, 14, 0, 14)
AccentPip.BackgroundTransparency = 1
AccentPip.ZIndex = 6
AccentPip.Parent = Main

local dropCap = Instance.new("Frame")
dropCap.Name = "Cap"
dropCap.AnchorPoint = Vector2.new(0.5, 0.5)
dropCap.Position = UDim2.new(0.5, 0, 0, 8)
dropCap.Size = UDim2.new(0, 11, 0, 11)
dropCap.Rotation = 45
dropCap.BackgroundColor3 = ACCENT
dropCap.BorderSizePixel = 0
dropCap.ZIndex = 6
dropCap.Parent = AccentPip
round(dropCap, 2)

local dropBody = Instance.new("Frame")
dropBody.Name = "Body"
dropBody.AnchorPoint = Vector2.new(0.5, 1)
dropBody.Position = UDim2.new(0.5, 0, 1, -1)
dropBody.Size = UDim2.new(0, 17, 0, 17)
dropBody.BackgroundColor3 = ACCENT
dropBody.BorderSizePixel = 0
dropBody.ZIndex = 7
dropBody.Parent = AccentPip
round(dropBody, 999)

local dropShine = Instance.new("Frame")
dropShine.Name = "Shine"
dropShine.AnchorPoint = Vector2.new(0.5, 0.5)
dropShine.Position = UDim2.new(0.5, -3, 1, -11)
dropShine.Size = UDim2.new(0, 5, 0, 6)
dropShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropShine.BackgroundTransparency = 0.45
dropShine.BorderSizePixel = 0
dropShine.ZIndex = 8
dropShine.Parent = AccentPip
round(dropShine, 999)

registerAccent(function(c)
    dropCap.BackgroundColor3 = c
    dropBody.BackgroundColor3 = c
end)

-- ===== TOP BUTTONS =====
Close = chipButton(Main, "\226\128\147", 30, 24)
Close.Name = "Collapse"
Close.Position = UDim2.new(1, -42, 0, 15)
Close.TextSize = 16
Close.ZIndex = 6

ToxicLockTopButton = chipButton(Main, "LOCK", 44, 24)
ToxicLockTopButton.Name = "LockGUI"
ToxicLockTopButton.Position = UDim2.new(1, -90, 0, 15)
ToxicLockTopButton.TextSize = 9
ToxicLockTopButton.ZIndex = 6

function ToxicUpdateGuiLockVisual()
    local on = _G.ToxicGuiLocked == true
    if ToxicLockTopButton then
        ToxicLockTopButton.Text = on and "UNLOCK" or "LOCK"
        ToxicLockTopButton.TextColor3 = on and SKIN.void or SKIN.ink
        glide(ToxicLockTopButton, {BackgroundColor3 = on and ACCENT or SKIN.well, BackgroundTransparency = on and 0 or 0.15})
        local st = ToxicLockTopButton:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and ACCENT or SKIN.seamSoft
            st.Transparency = on and 0 or 0.4
        end
    end
end

ToxicLockTopButton.Activated:Connect(function()
    _G.ToxicGuiLocked = not (_G.ToxicGuiLocked == true)
    ToxicUpdateGuiLockVisual()
    saveToxicConfig()
end)
ToxicUpdateGuiLockVisual()
registerAccent(function() ToxicUpdateGuiLockVisual() end)

-- ===== RAIL (tabs) =====
Rail = Instance.new("ScrollingFrame")
Rail.Name = "Rail"
Rail.BackgroundTransparency = 1
Rail.BorderSizePixel = 0
Rail.Position = UDim2.new(0, 10, 0, 52)
Rail.Size = UDim2.new(1, -20, 0, 34)
Rail.CanvasSize = UDim2.new(0, 0, 0, 0)
Rail.AutomaticCanvasSize = Enum.AutomaticSize.X
Rail.ScrollBarThickness = 0
Rail.ScrollingDirection = Enum.ScrollingDirection.X
Rail.ZIndex = 5
Rail.Parent = Main

RailLayout = Instance.new("UIListLayout")
RailLayout.FillDirection = Enum.FillDirection.Horizontal
RailLayout.Padding = UDim.new(0, 5)
RailLayout.SortOrder = Enum.SortOrder.LayoutOrder
RailLayout.VerticalAlignment = Enum.VerticalAlignment.Center
RailLayout.Parent = Rail

HeaderRule = Instance.new("Frame")
HeaderRule.Name = "HeaderRule"
HeaderRule.BackgroundColor3 = SKIN.seam
HeaderRule.BackgroundTransparency = 0.45
HeaderRule.BorderSizePixel = 0
HeaderRule.Size = UDim2.new(1, -20, 0, 1)
HeaderRule.Position = UDim2.new(0, 10, 0, 86)
HeaderRule.ZIndex = 5
HeaderRule.Parent = Main

-- ===== BOARD (pages container) =====
Board = Instance.new("Frame")
Board.Name = "Board"
Board.BackgroundTransparency = 1
Board.Position = UDim2.new(0, 12, 0, 94)
Board.Size = UDim2.new(1, -24, 1, -106)
Board.ZIndex = 3
Board.Parent = Main

pages = {}
railButtons = {}
railMarks = {}
RAIL_NAMES = {"STEAL", "COMBAT", "MOVEMENT", "DEFENSE", "VISUALS", "KEYBINDS", "UI", "SETTINGS"}
activeTab = RAIL_NAMES[1]

function addPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = SKIN.seam
    page.ScrollBarImageTransparency = 0.4
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ZIndex = 3
    page.Visible = false
    page.Parent = Board
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    inset(page, 0, 8, 0, 12)
    pages[name] = page
    return page
end

function setTab(name)
    activeTab = name
    for pageName, page in pairs(pages) do
        if pageName == name then
            if not page.Visible then
                page.Visible = true
                page.Position = UDim2.new(0, 0, 0, 8)
                glide(page, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
            end
        else
            page.Visible = false
        end
    end
    for tabName, btn in pairs(railButtons) do
        local on = tabName == name
        glide(btn, {
            TextColor3 = on and SKIN.ink or SKIN.inkFaint,
            BackgroundColor3 = on and accentDim(ACCENT, 0.34) or SKIN.slab,
            BackgroundTransparency = on and 0 or 0.5,
        })
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and ACCENT or SKIN.seamSoft
            glide(st, {Transparency = on and 0.1 or 0.5, Thickness = on and 1.3 or 1})
        end
        local mark = railMarks[tabName]
        if mark then
            glide(mark, {BackgroundTransparency = on and 0 or 1, Size = on and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 6, 0, 2)})
            mark.BackgroundColor3 = accentMix(ACCENT, Color3.fromRGB(255, 255, 255), 0.6)
        end
    end
end

for i, name in ipairs(RAIL_NAMES) do
    addPage(name)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.AutomaticSize = Enum.AutomaticSize.X
    btn.Size = UDim2.new(0, 0, 0, 30)
    btn.BackgroundColor3 = SKIN.slab
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = SKIN.inkFaint
    btn.TextSize = 9
    btn.Font = TYPE_HEAVY
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 6
    btn.Parent = Rail
    round(btn, 7)
    edge(btn, SKIN.seamSoft, 1, 0.5)
    inset(btn, 13, 13, 0, 0)
    local mark = Instance.new("Frame")
    mark.Name = "Mark"
    mark.AnchorPoint = Vector2.new(0.5, 1)
    mark.Position = UDim2.new(0.5, 0, 1, -3)
    mark.Size = UDim2.new(0, 6, 0, 2)
    mark.BackgroundColor3 = ACCENT
    mark.BackgroundTransparency = 1
    mark.BorderSizePixel = 0
    mark.ZIndex = 7
    mark.Parent = btn
    round(mark, 1)
    railButtons[name] = btn
    railMarks[name] = mark
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then glide(btn, {TextColor3 = SKIN.inkMute, BackgroundTransparency = 0.28}) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then glide(btn, {TextColor3 = SKIN.inkFaint, BackgroundTransparency = 0.5}) end
    end)
    btn.MouseButton1Click:Connect(function() setTab(name) end)
end
registerAccent(function() if setTab then setTab(activeTab) end end)

-- ===== TOAST =====
ToxicToast = Instance.new("TextLabel")
ToxicToast.Name = "Toast"
ToxicToast.AnchorPoint = Vector2.new(0.5, 1)
ToxicToast.Position = UDim2.new(0.5, 0, 1, -10)
ToxicToast.Size = UDim2.new(0, 250, 0, 26)
ToxicToast.BackgroundColor3 = SKIN.well
ToxicToast.BackgroundTransparency = 1
ToxicToast.BorderSizePixel = 0
ToxicToast.Text = ""
ToxicToast.TextColor3 = SKIN.ink
ToxicToast.TextTransparency = 1
ToxicToast.TextSize = 10
ToxicToast.Font = TYPE_HEAVY
ToxicToast.ZIndex = 40
ToxicToast.Parent = Main
round(ToxicToast, 6)
ToxicToastStroke = edge(ToxicToast, ACCENT, 1, 1)

ToxicToastToken = 0
function showActionNotification(text)
    if not ToxicToast then return end
    ToxicToastToken = ToxicToastToken + 1
    local token = ToxicToastToken
    ToxicToast.Text = tostring(text or "")
    ToxicToastStroke.Color = ACCENT
    glide(ToxicToast, {BackgroundTransparency = 0.1, TextTransparency = 0}, 0.14)
    glide(ToxicToastStroke, {Transparency = 0.2}, 0.14)
    task.delay(1.6, function()
        if token ~= ToxicToastToken then return end
        glide(ToxicToast, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        glide(ToxicToastStroke, {Transparency = 1}, 0.3)
    end)
end

-- ===== MINI =====
MiniFrame = Instance.new("Frame")
MiniFrame.Name = "MiniFrame"
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Size = UDim2.new(0, 66, 0, 30)
MiniFrame.Position = UDim2.new(0, 132, 0, 112)
MiniFrame.BackgroundColor3 = SKIN.void
MiniFrame.BorderSizePixel = 0
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.ZIndex = 20
MiniFrame.Parent = Gui
round(MiniFrame, 8)
edge(MiniFrame, SKIN.seam, 1, 0.2)

MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(1, 0, 1, 0)
MiniButton.BackgroundTransparency = 1
MiniButton.Text = "TD"
MiniButton.TextColor3 = SKIN.ink
MiniButton.TextSize = 15
MiniButton.Font = TYPE_HEAVY
MiniButton.AutoButtonColor = false
MiniButton.ZIndex = 21
MiniButton.Parent = MiniFrame

MiniPip = Instance.new("Frame")
MiniPip.Name = "Pip"
MiniPip.AnchorPoint = Vector2.new(0, 0.5)
MiniPip.Position = UDim2.new(0, 7, 0.5, 0)
MiniPip.Size = UDim2.new(0, 3, 0, 14)
MiniPip.BackgroundColor3 = ACCENT
MiniPip.BorderSizePixel = 0
MiniPip.ZIndex = 22
MiniPip.Parent = MiniFrame
round(MiniPip, 2)
registerAccent(function(c) MiniPip.BackgroundColor3 = c end)

do
    local held, origin, base, moved, tracked = false, nil, nil, false, nil
    MiniButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            held = true
            moved = false
            tracked = input
            origin = input.Position
            base = MiniFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not held then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not origin or not base then return end
        local d = input.Position - origin
        if math.abs(d.X) > 6 or math.abs(d.Y) > 6 then moved = true end
        MiniFrame.Position = UDim2.new(base.X.Scale, base.X.Offset + d.X, base.Y.Scale, base.Y.Offset + d.Y)
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input ~= tracked then return end
        local wasDrag = moved
        held = false
        tracked = nil
        origin = nil
        base = nil
        if wasDrag then return end
        Main.Visible = true
        MiniFrame.Visible = false
        Main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = FULL_MAIN_SIZE}):Play()
        savedMainPositionTable = udim2ToTable(Main.Position)
    end)
end

-- ===== MINIMIZE TOGGLE =====
ToxicMinimized = false
Close.MouseButton1Click:Connect(function()
    ToxicMinimized = not ToxicMinimized
    if ToxicMinimized then
        Main.Visible = false
        MiniFrame.Visible = true
    else
        Main.Visible = true
        MiniFrame.Visible = false
        Main.Size = FULL_MAIN_SIZE
    end
    saveToxicConfig()
end)

-- =====================================================
--  TOXIC DUELS | Part 3/6: Tabs STEAL / COMBAT / MOVEMENT
-- =====================================================

-- ===== UI BUILDERS =====
function heading(parent, text, order)
    local holder = Instance.new("Frame")
    holder.Name = "H_" .. text
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, -4, 0, 22)
    holder.LayoutOrder = order
    holder.ZIndex = 8
    holder.Parent = parent
    local cap = caption(holder, text, 9, TYPE_HEAVY, SKIN.inkMute)
    cap.Name = "Cap"
    cap.Position = UDim2.new(0, 2, 0, 8)
    cap.Size = UDim2.new(0, 240, 0, 12)
    cap.TextTruncate = Enum.TextTruncate.AtEnd
    cap.ZIndex = 9
    local rule = Instance.new("Frame")
    rule.Name = "HeaderRule"
    rule.AnchorPoint = Vector2.new(1, 0.5)
    rule.Position = UDim2.new(1, 0, 0, 14)
    rule.Size = UDim2.new(1, -8, 0, 1)
    rule.BackgroundColor3 = SKIN.seamSoft
    rule.BackgroundTransparency = 0.3
    rule.BorderSizePixel = 0
    rule.ZIndex = 8
    rule.Parent = holder
    task.defer(function()
        rule.Size = UDim2.new(1, -(cap.TextBounds.X + 14), 0, 1)
    end)
    cap:GetPropertyChangedSignal("TextBounds"):Connect(function()
        rule.Size = UDim2.new(1, -(cap.TextBounds.X + 14), 0, 1)
    end)
    return holder
end

function shelf(parent, labelText, order, height)
    local row = Instance.new("Frame")
    row.Name = labelText
    row.BackgroundColor3 = SKIN.slab
    row.BackgroundTransparency = 0.25
    row.Size = UDim2.new(1, -4, 0, height or 40)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 4
    row.Parent = parent
    round(row, 7)
    edge(row, SKIN.seamSoft, 1, 0.45)
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.AnchorPoint = Vector2.new(0, 0.5)
    bar.Position = UDim2.new(0, 7, 0.5, 0)
    bar.Size = UDim2.new(0, 3, 0, 12)
    bar.BackgroundColor3 = SKIN.seam
    bar.BorderSizePixel = 0
    bar.ZIndex = 5
    bar.Parent = row
    round(bar, 2)
    local text = caption(row, labelText, 12, TYPE_BODY, SKIN.ink)
    text.Name = "Label"
    text.Position = UDim2.new(0, 19, 0, 0)
    text.Size = UDim2.new(1, -190, 1, 0)
    text.TextTruncate = Enum.TextTruncate.AtEnd
    text.ZIndex = 5
    row.MouseEnter:Connect(function() glide(row, {BackgroundColor3 = SKIN.slabHot, BackgroundTransparency = 0.12}) end)
    row.MouseLeave:Connect(function() glide(row, {BackgroundColor3 = SKIN.slab, BackgroundTransparency = 0.25}) end)
    return row, bar
end

function switchRow(parent, labelText, default, order)
    local row, bar = shelf(parent, labelText, order)
    local chip = Instance.new("TextLabel")
    chip.Name = "Chip"
    chip.AnchorPoint = Vector2.new(1, 0.5)
    chip.Position = UDim2.new(1, -10, 0.5, 0)
    chip.Size = UDim2.new(0, 46, 0, 22)
    chip.BackgroundColor3 = SKIN.well
    chip.BackgroundTransparency = 0.1
    chip.BorderSizePixel = 0
    chip.Text = "OFF"
    chip.TextColor3 = SKIN.inkFaint
    chip.TextSize = 9
    chip.Font = TYPE_HEAVY
    chip.ZIndex = 6
    chip.Parent = row
    round(chip, 5)
    local chipEdge = edge(chip, SKIN.seamSoft, 1, 0.4)
    local hit = Instance.new("TextButton")
    hit.Name = "ToggleButton"
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.AutoButtonColor = false
    hit.ZIndex = 7
    hit.Parent = row
    local state = default and true or false
    local rowEdge = row:FindFirstChildOfClass("UIStroke")
    local function setVisual(on)
        state = on and true or false
        glide(bar, {BackgroundColor3 = state and ACCENT or SKIN.seam, Size = state and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 12)})
        glide(chip, {BackgroundColor3 = state and accentDim(ACCENT, 0.34) or SKIN.well, BackgroundTransparency = state and 0 or 0.1, TextColor3 = state and accentMix(ACCENT, Color3.fromRGB(255, 255, 255), 0.7) or SKIN.inkFaint})
        chip.Text = state and "ON" or "OFF"
        chipEdge.Color = state and ACCENT or SKIN.seamSoft
        glide(chipEdge, {Transparency = state and 0.1 or 0.4})
        if rowEdge then
            rowEdge.Color = state and accentDim(ACCENT, 0.7) or SKIN.seamSoft
            glide(rowEdge, {Transparency = state and 0.2 or 0.45})
        end
        glide(row, {BackgroundTransparency = state and 0.12 or 0.25})
    end
    setVisual(state)
    registerAccent(function() setVisual(state) end)
    return row, setVisual, hit
end

function fieldRow(parent, labelText, value, order)
    local row = shelf(parent, labelText, order)
    local box = Instance.new("TextBox")
    box.Name = "ValueBox"
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.BackgroundColor3 = SKIN.well
    box.BackgroundTransparency = 0.1
    box.Text = tostring(value or "")
    box.TextColor3 = SKIN.ink
    box.TextSize = 11
    box.Font = TYPE_BOLD
    box.ClearTextOnFocus = false
    box.Size = UDim2.new(0, 62, 0, 24)
    box.Position = UDim2.new(1, -10, 0.5, 0)
    box.BorderSizePixel = 0
    box.ZIndex = 6
    box.Parent = row
    round(box, 5)
    local boxEdge = edge(box, SKIN.seamSoft, 1, 0.4)
    box.Focused:Connect(function()
        boxEdge.Color = ACCENT
        glide(boxEdge, {Transparency = 0.1})
    end)
    box.FocusLost:Connect(function()
        boxEdge.Color = SKIN.seamSoft
        glide(boxEdge, {Transparency = 0.4})
    end)
    return row, box
end

function readoutRow(parent, labelText, order, initial)
    local row = shelf(parent, labelText, order)
    local value = caption(row, initial or "", 10, TYPE_HEAVY, SKIN.ink, Enum.TextXAlignment.Center)
    value.Name = "Value"
    value.AnchorPoint = Vector2.new(1, 0.5)
    value.Position = UDim2.new(1, -10, 0.5, 0)
    value.Size = UDim2.new(0, 108, 0, 24)
    value.BackgroundColor3 = SKIN.well
    value.BackgroundTransparency = 0.1
    value.BorderSizePixel = 0
    value.ZIndex = 6
    round(value, 5)
    edge(value, SKIN.seamSoft, 1, 0.4)
    return row, value
end

function cycleRow(parent, labelText, order, initial)
    local row = shelf(parent, labelText, order, 42)
    local left = Instance.new("TextButton")
    left.Name = "Prev"
    left.AnchorPoint = Vector2.new(1, 0.5)
    left.BackgroundColor3 = SKIN.well
    left.BackgroundTransparency = 0.1
    left.Text = "\226\128\185"
    left.TextColor3 = SKIN.ink
    left.TextSize = 15
    left.Font = TYPE_HEAVY
    left.AutoButtonColor = false
    left.Size = UDim2.new(0, 26, 0, 26)
    left.Position = UDim2.new(1, -128, 0.5, 0)
    left.BorderSizePixel = 0
    left.ZIndex = 6
    left.Parent = row
    round(left, 5)
    edge(left, SKIN.seamSoft, 1, 0.4)
    local value = caption(row, initial or "", 10, TYPE_HEAVY, SKIN.ink, Enum.TextXAlignment.Center)
    value.Name = "Value"
    value.AnchorPoint = Vector2.new(1, 0.5)
    value.Position = UDim2.new(1, -40, 0.5, 0)
    value.Size = UDim2.new(0, 84, 0, 26)
    value.BackgroundColor3 = SKIN.well
    value.BackgroundTransparency = 0.1
    value.BorderSizePixel = 0
    value.ZIndex = 6
    round(value, 5)
    edge(value, SKIN.seamSoft, 1, 0.4)
    local right = Instance.new("TextButton")
    right.Name = "Next"
    right.AnchorPoint = Vector2.new(1, 0.5)
    right.BackgroundColor3 = SKIN.well
    right.BackgroundTransparency = 0.1
    right.Text = "\226\128\186"
    right.TextColor3 = SKIN.ink
    right.TextSize = 15
    right.Font = TYPE_HEAVY
    right.AutoButtonColor = false
    right.Size = UDim2.new(0, 26, 0, 26)
    right.Position = UDim2.new(1, -10, 0.5, 0)
    right.BorderSizePixel = 0
    right.ZIndex = 6
    right.Parent = row
    round(right, 5)
    edge(right, SKIN.seamSoft, 1, 0.4)
    return row, value, left, right
end

function segmentRow(parent, order, options, initial, onPick)
    local row = Instance.new("Frame")
    row.Name = "Segment"
    row.BackgroundColor3 = SKIN.well
    row.BackgroundTransparency = 0.1
    row.Size = UDim2.new(1, -4, 0, 34)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 4
    row.Parent = parent
    round(row, 7)
    edge(row, SKIN.seamSoft, 1, 0.45)
    inset(row, 4, 4, 4, 4)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = row
    local buttons = {}
    local current = initial
    local function paint()
        for name, btn in pairs(buttons) do
            local on = name == current
            glide(btn, {BackgroundColor3 = on and accentDim(ACCENT, 0.4) or SKIN.slab, BackgroundTransparency = on and 0 or 0.35, TextColor3 = on and SKIN.ink or SKIN.inkFaint})
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = on and ACCENT or SKIN.seamSoft
                glide(st, {Transparency = on and 0.15 or 0.55})
            end
        end
    end
    for i, name in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(1 / #options, -4 + (4 / #options), 1, 0)
        btn.BackgroundColor3 = SKIN.slab
        btn.BackgroundTransparency = 0.35
        btn.BorderSizePixel = 0
        btn.Text = string.upper(name)
        btn.TextColor3 = SKIN.inkFaint
        btn.TextSize = 9
        btn.Font = TYPE_HEAVY
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.ZIndex = 6
        btn.Parent = row
        round(btn, 5)
        edge(btn, SKIN.seamSoft, 1, 0.55)
        buttons[name] = btn
        btn.MouseButton1Click:Connect(function()
            current = name
            paint()
            if onPick then onPick(name) end
        end)
    end
    paint()
    registerAccent(paint)
    return row, function(name) current = name; paint() end
end

function pushRow(parent, labelText, buttonText, order, callback)
    local row = shelf(parent, labelText, order)
    local btn = Instance.new("TextButton")
    btn.Name = "Action"
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = SKIN.well
    btn.BackgroundTransparency = 0.05
    btn.BorderSizePixel = 0
    btn.Text = buttonText
    btn.TextColor3 = SKIN.ink
    btn.TextSize = 9
    btn.Font = TYPE_HEAVY
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(0, 82, 0, 24)
    btn.Position = UDim2.new(1, -10, 0.5, 0)
    btn.ZIndex = 6
    btn.Parent = row
    round(btn, 5)
    local st = edge(btn, SKIN.seam, 1, 0.3)
    btn.MouseEnter:Connect(function()
        glide(btn, {BackgroundColor3 = accentDim(ACCENT, 0.34)})
        st.Color = ACCENT
        glide(st, {Transparency = 0.1})
    end)
    btn.MouseLeave:Connect(function()
        glide(btn, {BackgroundColor3 = SKIN.well})
        st.Color = SKIN.seam
        glide(st, {Transparency = 0.3})
    end)
    if callback then btn.MouseButton1Click:Connect(callback) end
    return row, btn
end

function stepperRow(parent, labelText, defaultValue, order, callback, minValue, maxValue)
    local row = shelf(parent, labelText, order, 42)
    local minus = Instance.new("TextButton")
    minus.Name = "Minus"
    minus.AnchorPoint = Vector2.new(1, 0.5)
    minus.BackgroundColor3 = SKIN.well
    minus.BackgroundTransparency = 0.1
    minus.BorderSizePixel = 0
    minus.Text = "\226\136\146"
    minus.TextColor3 = SKIN.ink
    minus.TextSize = 14
    minus.Font = TYPE_HEAVY
    minus.AutoButtonColor = false
    minus.Size = UDim2.new(0, 26, 0, 26)
    minus.Position = UDim2.new(1, -118, 0.5, 0)
    minus.ZIndex = 6
    minus.Parent = row
    round(minus, 5)
    edge(minus, SKIN.seamSoft, 1, 0.4)
    local value = caption(row, string.format("%.2f", defaultValue), 11, TYPE_HEAVY, SKIN.ink, Enum.TextXAlignment.Center)
    value.Name = "Value"
    value.AnchorPoint = Vector2.new(1, 0.5)
    value.Position = UDim2.new(1, -40, 0.5, 0)
    value.Size = UDim2.new(0, 74, 0, 26)
    value.BackgroundColor3 = SKIN.well
    value.BackgroundTransparency = 0.1
    value.BorderSizePixel = 0
    value.ZIndex = 6
    round(value, 5)
    edge(value, SKIN.seamSoft, 1, 0.4)
    local plus = Instance.new("TextButton")
    plus.Name = "Plus"
    plus.AnchorPoint = Vector2.new(1, 0.5)
    plus.BackgroundColor3 = SKIN.well
    plus.BackgroundTransparency = 0.1
    plus.BorderSizePixel = 0
    plus.Text = "+"
    plus.TextColor3 = SKIN.ink
    plus.TextSize = 14
    plus.Font = TYPE_HEAVY
    plus.AutoButtonColor = false
    plus.Size = UDim2.new(0, 26, 0, 26)
    plus.Position = UDim2.new(1, -10, 0.5, 0)
    plus.ZIndex = 6
    plus.Parent = row
    round(plus, 5)
    edge(plus, SKIN.seamSoft, 1, 0.4)
    local current = defaultValue
    local function setValue(nextValue)
        current = math.clamp(math.floor((nextValue * 100) + 0.5) / 100, minValue or 0.50, maxValue or 1.50)
        value.Text = string.format("%.2f", current)
        if callback then callback(current) end
    end
    minus.MouseButton1Click:Connect(function() setValue(current - 0.05) end)
    plus.MouseButton1Click:Connect(function() setValue(current + 0.05) end)
    return row
end

function bindRow(parent, labelText, keyId, order)
    local row = shelf(parent, labelText, order)
    local rowLabel = row:FindFirstChild("Label")
    if rowLabel then rowLabel.Size = UDim2.new(1, -200, 1, 0) end
    local clear = Instance.new("TextButton")
    clear.Name = "ClearKeybindButton"
    clear.AnchorPoint = Vector2.new(1, 0.5)
    clear.BackgroundColor3 = SKIN.well
    clear.BackgroundTransparency = 0.1
    clear.BorderSizePixel = 0
    clear.Text = "\195\151"
    clear.TextColor3 = SKIN.inkMute
    clear.TextSize = 13
    clear.Font = TYPE_HEAVY
    clear.AutoButtonColor = false
    clear.Size = UDim2.new(0, 24, 0, 24)
    clear.Position = UDim2.new(1, -10, 0.5, 0)
    clear.ZIndex = 6
    clear.Parent = row
    round(clear, 5)
    edge(clear, SKIN.seamSoft, 1, 0.4)
    local btn = Instance.new("TextButton")
    btn.Name = "KeybindButton"
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = SKIN.well
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = keyName(speedKeybinds[keyId])
    btn.TextColor3 = SKIN.ink
    btn.TextSize = 10
    btn.Font = TYPE_HEAVY
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(0, 76, 0, 24)
    btn.Position = UDim2.new(1, -40, 0.5, 0)
    btn.ZIndex = 6
    btn.Parent = row
    round(btn, 5)
    edge(btn, ACCENT, 1, 0.55)
    registerAccent(function()
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then st.Color = ACCENT end
    end)
    speedKeybindButtons[keyId] = btn
    btn.Activated:Connect(function()
        listeningForSpeedKey = keyId
        listeningForTPDownKey = false
        keybindListenStartedAt = tick()
        refreshAllSpeedKeybinds()
    end)
    clear.Activated:Connect(function()
        listeningForSpeedKey = nil
        speedKeybinds[keyId] = nil
        refreshAllSpeedKeybinds()
        saveToxicConfig()
    end)
    return row, btn
end

function floorBindRow(parent, order)
    local row = shelf(parent, "TP Down", order)
    local clear = Instance.new("TextButton")
    clear.Name = "ClearKeybindButton"
    clear.AnchorPoint = Vector2.new(1, 0.5)
    clear.BackgroundColor3 = SKIN.well
    clear.BackgroundTransparency = 0.1
    clear.BorderSizePixel = 0
    clear.Text = "\195\151"
    clear.TextColor3 = SKIN.inkMute
    clear.TextSize = 13
    clear.Font = TYPE_HEAVY
    clear.AutoButtonColor = false
    clear.Size = UDim2.new(0, 24, 0, 24)
    clear.Position = UDim2.new(1, -10, 0.5, 0)
    clear.ZIndex = 6
    clear.Parent = row
    round(clear, 5)
    edge(clear, SKIN.seamSoft, 1, 0.4)
    local btn = Instance.new("TextButton")
    btn.Name = "KeybindButton"
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = SKIN.well
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = keyName(tpDownKeybind)
    btn.TextColor3 = SKIN.ink
    btn.TextSize = 10
    btn.Font = TYPE_HEAVY
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(0, 76, 0, 24)
    btn.Position = UDim2.new(1, -40, 0.5, 0)
    btn.ZIndex = 6
    btn.Parent = row
    round(btn, 5)
    edge(btn, ACCENT, 1, 0.55)
    tpDownKeybindButton = btn
    btn.Activated:Connect(function()
        listeningForTPDownKey = true
        listeningForSpeedKey = nil
        keybindListenStartedAt = tick()
        refreshTPDownKeybind()
    end)
    clear.Activated:Connect(function()
        listeningForTPDownKey = false
        tpDownKeybind = nil
        refreshTPDownKeybind()
        saveToxicConfig()
    end)
    return row, btn
end

function refreshAllSpeedKeybinds()
    for keyId, btn in pairs(speedKeybindButtons) do
        btn.Text = (listeningForSpeedKey == keyId) and "PRESS\226\128\166" or keyName(speedKeybinds[keyId])
    end
end

function refreshTPDownKeybind()
    if tpDownKeybindButton then
        tpDownKeybindButton.Text = listeningForTPDownKey and "PRESS\226\128\166" or keyName(tpDownKeybind)
    end
end

function animRow(parent, order)
    local row, value, left, right = cycleRow(parent, "Animation Pack", order, string.upper(selectedAnimationPack))
    animValueLabel = value
    local function step(delta)
        local nextIndex = AnimationPackIndex + delta
        if nextIndex < 1 then nextIndex = #AnimationPackList end
        if nextIndex > #AnimationPackList then nextIndex = 1 end
        AnimationPackIndex = nextIndex
        selectedAnimationPack = AnimationPackList[AnimationPackIndex]
        if refreshAnimationPackRow then refreshAnimationPackRow() end
        if applyAnimationPack then applyAnimationPack(selectedAnimationPack) end
        pcall(saveToxicConfig)
    end
    left.MouseButton1Click:Connect(function() step(-1) end)
    right.MouseButton1Click:Connect(function() step(1) end)
    return row
end

function skyRow(parent, order)
    local list = SKY_PRESETS_LIST or {"Off"}
    local index = 1
    for i, name in ipairs(list) do if name == skyTheme then index = i break end end
    local row, value, left, right = cycleRow(parent, "Sky Theme", order, string.upper(list[index]))
    value.TextSize = 9
    skyValueLabel = value
    local function step(delta)
        index = index + delta
        if index < 1 then index = #list end
        if index > #list then index = 1 end
        skyTheme = list[index]
        value.Text = string.upper(skyTheme)
        if type(applyCustomSky) == "function" then pcall(applyCustomSky, skyTheme) end
        pcall(saveToxicConfig)
    end
    left.MouseButton1Click:Connect(function() step(-1) end)
    right.MouseButton1Click:Connect(function() step(1) end)
    return row
end

-- =====================================================
--  STEAL TAB
-- =====================================================
task.wait()
StealTab = pages.STEAL
heading(StealTab, "GRAB", 1)
do
    local _, setVisual, hit = switchRow(StealTab, "Auto Grab", autoStealEnabled, 2)
    setAutoStealVisual = setVisual
    hit.Activated:Connect(function()
        autoStealEnabled = not autoStealEnabled
        setVisual(autoStealEnabled)
        if _G.GrabRefresh then _G.GrabRefresh() end
        saveToxicConfig()
    end)
end
heading(StealTab, "GRAB RADIUS", 3)
do
    if autoStealRadius ~= 7 and autoStealRadius ~= 8 and autoStealRadius ~= 9 then autoStealRadius = 9 end
    local _, setRadius = segmentRow(StealTab, 4, {"7", "8", "9"}, tostring(autoStealRadius), function(pick)
        autoStealRadius = tonumber(pick) or 9
        _G.ToxicStealRadii.Semi = autoStealRadius
        if _G.GrabSetRadius then _G.GrabSetRadius(autoStealRadius) end
        if _G.GrabRefresh then _G.GrabRefresh() end
        saveToxicConfig()
    end)
    _G.ToxicSetGrabRadius = setRadius
end
heading(StealTab, "RAGDOLL STEAL", 4.2)
do
    local _, setVisual, hit = switchRow(StealTab, "Ragdoll Steal", ragdollStealEnabled, 4.3)
    setRagdollStealVisual = setVisual
    hit.Activated:Connect(function()
        if _G.SetRagdollSteal then _G.SetRagdollSteal(not ragdollStealEnabled) end
    end)
end
do
    local _, box = fieldRow(StealTab, "Ragdoll Lead", tostring(ragdollStealLead), 4.4)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 10 then ragdollStealLead = v end
        box.Text = tostring(ragdollStealLead)
        saveToxicConfig()
    end)
end
heading(StealTab, "STEAL ALERT", 4.5)
do
    local _, setVisual, hit = switchRow(StealTab, "Steal Alert", stealAlertEnabled, 4.6)
    setStealAlertVisual = setVisual
    hit.Activated:Connect(function()
        stealAlertEnabled = not stealAlertEnabled
        setVisual(stealAlertEnabled)
        if stealAlertEnabled and _G.ShowStealAlert then _G.ShowStealAlert("TEST") end
        saveToxicConfig()
    end)
end
heading(StealTab, "PATHING", 5)
do
    local _, setVisual, hit = switchRow(StealTab, "Auto Left", autoLeftEnabled, 6)
    _G.ToxicSetAutoLeftVisual = setVisual
    hit.Activated:Connect(function()
        if _G.ToxicSetAutoLeft then _G.ToxicSetAutoLeft(not autoLeftEnabled) end
    end)
end
do
    local _, setVisual, hit = switchRow(StealTab, "Auto Right", autoRightEnabled, 7)
    _G.ToxicSetAutoRightVisual = setVisual
    hit.Activated:Connect(function()
        if _G.ToxicSetAutoRight then _G.ToxicSetAutoRight(not autoRightEnabled) end
    end)
end
heading(StealTab, "MANUAL", 8)
pushRow(StealTab, "Drop Brainrot", "DROP", 9, function()
    if runDropBrainrot then runDropBrainrot() end
    showActionNotification("BRAINROT DROPPED")
end)

-- =====================================================
--  COMBAT TAB
-- =====================================================
task.wait()
CombatTab = pages.COMBAT
heading(CombatTab, "AIMBOT", 1)
do
    local row = shelf(CombatTab, "Aimbot", 2)
    local chip = Instance.new("TextLabel")
    chip.Name = "Chip"
    chip.AnchorPoint = Vector2.new(1, 0.5)
    chip.Position = UDim2.new(1, -10, 0.5, 0)
    chip.Size = UDim2.new(0, 74, 0, 24)
    chip.BackgroundColor3 = SKIN.well
    chip.BackgroundTransparency = 0.1
    chip.BorderSizePixel = 0
    chip.Text = "AIMBOT"
    chip.TextColor3 = SKIN.inkFaint
    chip.TextSize = 9
    chip.Font = TYPE_HEAVY
    chip.ZIndex = 6
    chip.Parent = row
    round(chip, 5)
    local chipEdge = edge(chip, SKIN.seamSoft, 1, 0.4)
    local bar = row:FindFirstChild("Bar")
    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.AutoButtonColor = false
    hit.ZIndex = 7
    hit.Parent = row
    local live = false
    _G.AimbotSetVisual = function(on)
        live = on and true or false
        if bar then glide(bar, {BackgroundColor3 = live and ACCENT or SKIN.seam, Size = live and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 12)}) end
        glide(chip, {BackgroundColor3 = live and accentDim(ACCENT, 0.34) or SKIN.well, TextColor3 = live and accentMix(ACCENT, Color3.fromRGB(255, 255, 255), 0.7) or SKIN.inkFaint})
        chipEdge.Color = live and ACCENT or SKIN.seamSoft
        glide(chipEdge, {Transparency = live and 0.1 or 0.4})
    end
    hit.MouseButton1Click:Connect(function()
        if _G.SafeModeIsLocked and _G.SafeModeIsLocked() then
            if _G.SafeModeForceStop then _G.SafeModeForceStop("SAFE MODE LOCK") end
            return
        end
        if _G.AimbotToggle then _G.AimbotToggle() end
    end)
    registerAccent(function() if _G.AimbotSetVisual then _G.AimbotSetVisual(live) end end)
end
do
    local _, setVisual, hit = switchRow(CombatTab, "Auto Swing", autoSwingEnabled, 4)
    _G.AutoSwingSetVisual = setVisual
    hit.MouseButton1Click:Connect(function()
        if _G.AutoSwingBusy then return end
        _G.AutoSwingBusy = true
        autoSwingEnabled = not autoSwingEnabled
        setVisual(autoSwingEnabled)
        saveToxicConfig()
        task.delay(0.12, function() _G.AutoSwingBusy = false end)
    end)
end
do
    local _, setVisual, hit = switchRow(CombatTab, "Mirror TP", mirrorTPDownEnabled, 5)
    _G.MirrorTPSetVisual = setVisual
    hit.MouseButton1Click:Connect(function()
        if _G.MirrorTPBusy then return end
        _G.MirrorTPBusy = true
        if _G.MirrorTPSet then _G.MirrorTPSet(not mirrorTPDownEnabled) end
        saveToxicConfig()
        task.delay(0.12, function() _G.MirrorTPBusy = false end)
    end)
end
do
    local _, box = fieldRow(CombatTab, "Aimbot Height", tostring(aimbotHeight), 5.4)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v >= 0 and v <= 30 then aimbotHeight = v end
        box.Text = tostring(aimbotHeight)
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(CombatTab, "Mirror Angle", mirrorAngleEnabled, 5.5)
    _G.MirrorAngleSetVisual = setVisual
    hit.Activated:Connect(function()
        mirrorAngleEnabled = not mirrorAngleEnabled
        setVisual(mirrorAngleEnabled)
        saveToxicConfig()
    end)
end
do
    local _, box = fieldRow(CombatTab, "Aimbot Speed", tostring(AIMBOT_SPEED), 6)
    _G.AimbotSpeedBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then AIMBOT_SPEED = v end
        box.Text = tostring(AIMBOT_SPEED)
        saveToxicConfig()
    end)
end
do
    local _, box = fieldRow(CombatTab, "Lagger Aimbot Speed", tostring(LAGGER_AIMBOT_SPEED), 7)
    _G.AimbotLaggerSpeedBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then LAGGER_AIMBOT_SPEED = v end
        box.Text = tostring(LAGGER_AIMBOT_SPEED)
        saveToxicConfig()
    end)
end
heading(CombatTab, "TP BAT", 8)
do
    local _, setVisual, hit = switchRow(CombatTab, "TP Bat", _G.TPBatOn == true, 9)
    _G.TPBatSetVisual = setVisual
    hit.MouseButton1Click:Connect(function()
        if _G.ToxicTPBatClickBusy then return end
        _G.ToxicTPBatClickBusy = true
        if _G.SafeModeIsLocked and _G.SafeModeIsLocked() then
            if _G.SafeModeForceStop then _G.SafeModeForceStop("SAFE MODE LOCK") end
        else
            if _G.TPBatToggle then _G.TPBatToggle() end
        end
        setVisual(_G.TPBatOn == true)
        task.delay(0.12, function() _G.ToxicTPBatClickBusy = false end)
    end)
end
do
    local _, setVisual, hit = switchRow(CombatTab, "TP Bat Auto Swing", tpBatSwingEnabled, 10)
    _G.TPBatSwingSetVisual = setVisual
    hit.MouseButton1Click:Connect(function()
        if _G.TPBatSwingBusy then return end
        _G.TPBatSwingBusy = true
        tpBatSwingEnabled = not tpBatSwingEnabled
        setVisual(tpBatSwingEnabled)
        saveToxicConfig()
        task.delay(0.12, function() _G.TPBatSwingBusy = false end)
    end)
end
do
    local _, box = fieldRow(CombatTab, "TP Bat Speed", tostring(TPBAT_SPEED), 11)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then TPBAT_SPEED = v end
        box.Text = tostring(TPBAT_SPEED)
        saveToxicConfig()
    end)
end
heading(CombatTab, "COUNTERS", 12)
do
    local _, setVisual, hit = switchRow(CombatTab, "Bat Counter", batCounterEnabled, 13)
    setBatCounterVisual = setVisual
    hit.Activated:Connect(function()
        batCounterEnabled = not batCounterEnabled
        setVisual(batCounterEnabled)
        if batCounterEnabled then
            if _G.BatCounterStart then _G.BatCounterStart() end
        elseif _G.BatCounterStop then
            _G.BatCounterStop()
        end
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(CombatTab, "Med Counter", medCounterEnabled, 14)
    setMedCounterVisual = setVisual
    hit.Activated:Connect(function()
        medCounterEnabled = not medCounterEnabled
        setVisual(medCounterEnabled)
        if medCounterEnabled then
            if _G.MedCounterStart then _G.MedCounterStart(LP.Character) end
        elseif _G.MedCounterStop then
            _G.MedCounterStop()
        end
        saveToxicConfig()
    end)
end
heading(CombatTab, "SURVIVAL", 15)
do
    local _, setVisual, hit = switchRow(CombatTab, "Infinite Jump", infJumpEnabled, 16)
    setInfJumpVisual = setVisual
    hit.Activated:Connect(function()
        if setInfJumpInternal then setInfJumpInternal(not infJumpEnabled) end
        setVisual(infJumpEnabled == true)
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(CombatTab, "Anti Ragdoll", antiRagdollEnabled, 17)
    setAntiRagdollVisual = setVisual
    hit.Activated:Connect(function()
        if setAntiRagdoll then setAntiRagdoll(not antiRagdollEnabled) end
        setVisual(antiRagdollEnabled == true)
        saveToxicConfig()
    end)
end

-- =====================================================
--  MOVEMENT TAB
-- =====================================================
task.wait()
MobilityTab = pages.MOVEMENT
heading(MobilityTab, "NORMAL SPEED", 1)
do
    local _, box = fieldRow(MobilityTab, "Normal Speed", tostring(NS), 2)
    normalSpeedBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then NS = v end
        box.Text = tostring(NS)
    end)
end
do
    local _, box = fieldRow(MobilityTab, "Carry Speed", tostring(CS), 3)
    carrySpeedBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then CS = v end
        box.Text = tostring(CS)
    end)
end
speedModeRow = function(parent, order, side)
    local modeName = side == "Lagger" and "Lagger Mode" or "Normal Mode"
    local row, value = readoutRow(parent, modeName, order, "")
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 7
    toggleBtn.Parent = row
    if side == "Lagger" then
        speedModeValueB = value
        toggleBtn.MouseButton1Click:Connect(function()
            if setSpeedMode then setSpeedMode(currentSpeedMode == "Lagger Carry" and "Lagger" or "Lagger Carry") end
        end)
    else
        speedModeValueA = value
        toggleBtn.MouseButton1Click:Connect(function()
            if setSpeedMode then setSpeedMode(currentSpeedMode == "Carry" and "Normal" or "Carry") end
        end)
    end
    return row
end
speedModeRow(MobilityTab, 4, "Normal")
heading(MobilityTab, "LAGGER SPEED", 5)
do
    local _, box = fieldRow(MobilityTab, "Lagger Speed", tostring(LAGGER_SPEED), 6)
    laggerSpeedBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then LAGGER_SPEED = v end
        box.Text = tostring(LAGGER_SPEED)
    end)
end
do
    local _, box = fieldRow(MobilityTab, "Lagger Carry Speed", tostring(LAGGER_CARRY_SPEED), 7)
    laggerCarrySpeedBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 and v <= 250 then LAGGER_CARRY_SPEED = v end
        box.Text = tostring(LAGGER_CARRY_SPEED)
    end)
end
speedModeRow(MobilityTab, 8, "Lagger")
do
    local _, setVisual, hit = switchRow(MobilityTab, "Auto Carry Speed", autoCarrySpeedEnabled, 9)
    setAutoCarrySpeedVisual = setVisual
    hit.Activated:Connect(function()
        autoCarrySpeedEnabled = not autoCarrySpeedEnabled
        if autoCarrySpeedEnabled ~= true and _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then
            _G.AutoCarrySpeed.Disable()
        end
        setVisual(autoCarrySpeedEnabled == true)
        saveToxicConfig()
    end)
end
heading(MobilityTab, "TRAVERSAL", 10)
do
    local _, setVisual, hit = switchRow(MobilityTab, "Auto TP Down", autoTPEnabled, 11)
    setAutoTPVisual = setVisual
    hit.MouseButton1Click:Connect(function()
        if autoTPClickDebounce then return end
        autoTPClickDebounce = true
        if toggleAutoTP then toggleAutoTP(not autoTPEnabled) end
        task.delay(0.15, function()
            autoTPClickDebounce = false
            setVisual(autoTPEnabled)
        end)
    end)
end
do
    local _, box = fieldRow(MobilityTab, "Auto TP Height", tostring(autoTPHeight), 12)
    autoTPHeightBox = box
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v >= -500 and v <= 500 then autoTPHeight = v end
        box.Text = tostring(autoTPHeight)
        saveToxicConfig()
    end)
end
animRow(MobilityTab, 15)
pushRow(MobilityTab, "Custom Anim Pack", "OPEN", 15.5, function()
    if _G.AnimPanelToggle then _G.AnimPanelToggle() end
end)
pushRow(MobilityTab, "TP Down", "SLAM", 16, function()
    if runTPFloor then runTPFloor() end
end)

-- =====================================================
--  TOXIC DUELS | Part 4/6: DEFENSE / VISUALS / KEYBINDS
-- =====================================================

-- =====================================================
--  DEFENSE TAB
-- =====================================================
task.wait()
GuardTab = pages.DEFENSE
heading(GuardTab, "SHIELDING", 1)
do
    local _, setVisual, hit = switchRow(GuardTab, "Anti Die", antiDieEnabled, 2)
    setAntiDieVisual = setVisual
    hit.Activated:Connect(function()
        if _G.ToxicSetAntiDie then
            _G.ToxicSetAntiDie(not antiDieEnabled)
        else
            antiDieEnabled = not antiDieEnabled
            setVisual(antiDieEnabled)
            saveToxicConfig()
        end
    end)
end
do
    local _, setVisual, hit = switchRow(GuardTab, "Safe Mode", safeModeEnabled, 3)
    setSafeModeVisual = setVisual
    hit.Activated:Connect(function()
        safeModeEnabled = not safeModeEnabled
        setVisual(safeModeEnabled)
        if safeModeEnabled and _G.SafeModeForceStop then _G.SafeModeForceStop("SAFE MODE") end
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(GuardTab, "No Player Collision", _G.ToxicNoPlayerCollisionEnabled, 4)
    _G.PlayerPhaseSetVisual = setVisual
    hit.Activated:Connect(function()
        _G.ToxicNoPlayerCollisionEnabled = not _G.ToxicNoPlayerCollisionEnabled
        setVisual(_G.ToxicNoPlayerCollisionEnabled)
        if _G.ToxicNoPlayerCollisionEnabled then
            if enableNoPlayerCollision then enableNoPlayerCollision() end
        elseif disableNoPlayerCollision then
            disableNoPlayerCollision()
        end
        saveToxicConfig()
    end)
end
heading(GuardTab, "RECOVERY", 5)
do
    local _, setVisual, hit = switchRow(GuardTab, "Auto Reset On Med Fling", autoResetOnMedEnabled, 6)
    setAutoResetOnMedVisual = setVisual
    hit.Activated:Connect(function()
        if _G.ToxicSetAutoResetOnMed then
            _G.ToxicSetAutoResetOnMed(not autoResetOnMedEnabled)
        else
            autoResetOnMedEnabled = not autoResetOnMedEnabled
            setVisual(autoResetOnMedEnabled)
            saveToxicConfig()
        end
    end)
end
do
    local _, setVisual, hit = switchRow(GuardTab, "Insta Reset On Death", autoInstaResetOnDeathEnabled, 7)
    setInstaResetOnDeathVisual = setVisual
    hit.Activated:Connect(function()
        if _G.ToxicSetInstaResetOnDeath then
            _G.ToxicSetInstaResetOnDeath(not autoInstaResetOnDeathEnabled)
        else
            autoInstaResetOnDeathEnabled = not autoInstaResetOnDeathEnabled
            setVisual(autoInstaResetOnDeathEnabled)
            saveToxicConfig()
        end
    end)
end
pushRow(GuardTab, "Instant Reset", "RESET", 8, function()
    if _G.InstantReset then _G.InstantReset() end
    showActionNotification("INSTANT RESET")
end)
do
    local _, setVisual, hit = switchRow(GuardTab, "Ragdoll Countdown", ragdollCountdownEnabled, 9)
    setRagdollCountdownVisual = setVisual
    hit.Activated:Connect(function()
        ragdollCountdownEnabled = not ragdollCountdownEnabled
        if ragdollCountdownEnabled then
            if hookRagdollCountdown then hookRagdollCountdown(LP.Character) end
        else
            if stopRagdollCountdown then stopRagdollCountdown() end
        end
        setVisual(ragdollCountdownEnabled)
        saveToxicConfig()
    end)
end

-- =====================================================
--  VISUALS TAB
-- =====================================================
task.wait()
VisualTab = pages.VISUALS
heading(VisualTab, "ESP", 1)
do
    local _, setVisual, hit = switchRow(VisualTab, "ESP", espEnabled, 2)
    setPlayerESPVisual = setVisual
    hit.Activated:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            if startPlayerESP then startPlayerESP() end
            if BoxedESPOptions then BoxedESPOptions.box = true end
        else
            if stopPlayerESP then stopPlayerESP() end
            if BoxedESPOptions then BoxedESPOptions.box = false end
        end
        if refreshBoxedESP then refreshBoxedESP() end
        setVisual(espEnabled)
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(VisualTab, "Show Tracker", showTracerEnabled, 3)
    setTracerESPVisual = setVisual
    hit.Activated:Connect(function()
        showTracerEnabled = not showTracerEnabled
        if BoxedESPOptions then
            BoxedESPOptions.tracer = showTracerEnabled
            BoxedESPOptions.box = espEnabled == true
        end
        if refreshBoxedESP then refreshBoxedESP() end
        setVisual(showTracerEnabled)
        saveToxicConfig()
    end)
end
heading(VisualTab, "SKY THEME", 4)
skyRow(VisualTab, 5)
heading(VisualTab, "PERFORMANCE", 6)
do
    local _, setVisual, hit = switchRow(VisualTab, "Stretch Rez", stretchRezEnabled, 7)
    setFPSBoostVisual = setVisual
    hit.Activated:Connect(function()
        stretchRezEnabled = not stretchRezEnabled
        if stretchRezEnabled then
            if enableStretchRez then enableStretchRez() end
        else
            if disableStretchRez then disableStretchRez() end
        end
        setVisual(stretchRezEnabled)
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(VisualTab, "Anti Lag", antiLagEnabled, 8)
    setAntiLagVisual = setVisual
    hit.Activated:Connect(function()
        if antiLagEnabled then
            if disableAntiLag then disableAntiLag() end
        else
            if enableAntiLag then enableAntiLag() end
        end
        setVisual(antiLagEnabled)
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(VisualTab, "Nuke Optimiser", nukeOptimiserEnabled, 9)
    setNukeOptimiserVisual = setVisual
    hit.Activated:Connect(function()
        if nukeOptimiserEnabled then
            if disableNukeOptimizer then disableNukeOptimizer() end
        else
            if enableNukeOptimizer then enableNukeOptimizer() end
        end
        setVisual(nukeOptimiserEnabled)
        saveToxicConfig()
    end)
end
heading(VisualTab, "CAMERA", 10)
do
    local _, setVisual, hit = switchRow(VisualTab, "FOV", fovEnabled, 11)
    setFOVVisual = setVisual
    hit.Activated:Connect(function()
        if fovEnabled then
            if disableCustomFov then disableCustomFov() end
        else
            if enableCustomFov then enableCustomFov() end
        end
        setVisual(fovEnabled)
        saveToxicConfig()
    end)
end
do
    local _, box = fieldRow(VisualTab, "FOV Value", tostring(fovValue), 12)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v >= 30 and v <= 120 then
            fovValue = v
            if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovValue end
        end
        box.Text = tostring(fovValue)
        saveToxicConfig()
    end)
end
do
    local _, setVisual, hit = switchRow(VisualTab, "No Cam Collision", noCamCollisionEnabled, 13)
    setNoCamCollisionVisual = setVisual
    hit.Activated:Connect(function()
        if noCamCollisionEnabled then
            if disableNoCamCollision then disableNoCamCollision() end
        else
            if enableNoCamCollision then enableNoCamCollision() end
        end
        setVisual(noCamCollisionEnabled)
        saveToxicConfig()
    end)
end
heading(VisualTab, "APPEARANCE", 14)
pushRow(VisualTab, "Body Changer", "OPEN", 15, function()
    if _G.BodyPanelToggle then _G.BodyPanelToggle() end
end)

-- =====================================================
--  KEYBINDS TAB
-- =====================================================
task.wait()
BindsTab = pages.KEYBINDS
heading(BindsTab, "MOBILITY", 1)
bindRow(BindsTab, "Speed Key", "SpeedToggle", 2)
bindRow(BindsTab, "Lagger Mode Key", "LaggerToggle", 3)
floorBindRow(BindsTab, 4)
bindRow(BindsTab, "Drop Brainrot", "DropBrainrot", 5)
heading(BindsTab, "COMBAT", 6)
bindRow(BindsTab, "Aimbot", "Aimbot", 7)
bindRow(BindsTab, "TP Bat", "TPBat", 8)
heading(BindsTab, "STEAL", 9)
bindRow(BindsTab, "Auto Left", "AutoLeft", 10)
bindRow(BindsTab, "Auto Right", "AutoRight", 11)
bindRow(BindsTab, "Instant Reset", "InstantReset", 12)
bindRow(BindsTab, "Anti Die", "AntiDie", 13)
heading(BindsTab, "MISC", 14)
bindRow(BindsTab, "Lagger Window", "ToxicLagger", 15)
bindRow(BindsTab, "Lagger Toggle", "LaggerActivate", 16)

-- =====================================================
--  TOXIC DUELS | Part 5A: UI / SETTINGS tabs
-- =====================================================

-- =====================================================
--  UI TAB (accent + backgrounds)
-- =====================================================
task.wait()
ThemeTab = pages.UI
heading(ThemeTab, "ACCENT COLOR", 1)
do
    local preview = Instance.new("Frame")
    preview.Name = "AccentPreview"
    preview.BackgroundColor3 = SKIN.slab
    preview.BackgroundTransparency = 0.25
    preview.Size = UDim2.new(1, -4, 0, 52)
    preview.LayoutOrder = 2
    preview.BorderSizePixel = 0
    preview.Parent = ThemeTab
    round(preview, 7)
    edge(preview, SKIN.seamSoft, 1, 0.45)
    local swatch = Instance.new("Frame")
    swatch.Name = "Swatch"
    swatch.Size = UDim2.new(0, 36, 0, 36)
    swatch.Position = UDim2.new(0, 9, 0.5, -18)
    swatch.BackgroundColor3 = ACCENT
    swatch.BorderSizePixel = 0
    swatch.ZIndex = 5
    swatch.Parent = preview
    round(swatch, 6)
    edge(swatch, Color3.fromRGB(255, 255, 255), 1, 0.6)
    local title = caption(preview, "CURRENT ACCENT", 11, TYPE_HEAVY, SKIN.ink)
    title.Position = UDim2.new(0, 55, 0, 10)
    title.Size = UDim2.new(1, -66, 0, 16)
    title.ZIndex = 5
    local hexLbl = caption(preview, hexOf(ACCENT), 10, TYPE_BOLD, SKIN.inkMute)
    hexLbl.Position = UDim2.new(0, 55, 0, 27)
    hexLbl.Size = UDim2.new(1, -66, 0, 14)
    hexLbl.ZIndex = 5
    heading(ThemeTab, "PRESETS", 3)
    local grid = Instance.new("Frame")
    grid.Name = "Swatches"
    grid.BackgroundTransparency = 1
    grid.Size = UDim2.new(1, -4, 0, 68)
    grid.LayoutOrder = 4
    grid.Parent = ThemeTab
    local gl = Instance.new("UIGridLayout")
    gl.CellSize = UDim2.new(0, 30, 0, 30)
    gl.CellPadding = UDim2.new(0, 6, 0, 6)
    gl.SortOrder = Enum.SortOrder.LayoutOrder
    gl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gl.Parent = grid
    local presets = {
        Color3.fromRGB(82, 255, 70), Color3.fromRGB(100, 255, 120), Color3.fromRGB(120, 240, 140),
        Color3.fromRGB(60, 220, 80), Color3.fromRGB(40, 190, 70), Color3.fromRGB(30, 160, 60),
        Color3.fromRGB(88, 200, 255), Color3.fromRGB(255, 120, 120), Color3.fromRGB(255, 200, 80),
        Color3.fromRGB(180, 100, 255), Color3.fromRGB(255, 100, 180), Color3.fromRGB(230, 230, 230),
    }
    for idx, col in ipairs(presets) do
        local b = Instance.new("TextButton")
        b.Name = "SW" .. idx
        b.Text = ""
        b.AutoButtonColor = false
        b.BackgroundColor3 = col
        b.BorderSizePixel = 0
        b.LayoutOrder = idx
        b.Parent = grid
        round(b, 6)
        edge(b, Color3.fromRGB(255, 255, 255), 1, 0.65)
        b.MouseButton1Click:Connect(function() applyAccent(col) end)
    end
    heading(ThemeTab, "HUE", 5)
    local hueRow = Instance.new("Frame")
    hueRow.Name = "HueSlider"
    hueRow.BackgroundColor3 = SKIN.slab
    hueRow.BackgroundTransparency = 0.25
    hueRow.Size = UDim2.new(1, -4, 0, 44)
    hueRow.LayoutOrder = 6
    hueRow.BorderSizePixel = 0
    hueRow.Parent = ThemeTab
    round(hueRow, 7)
    edge(hueRow, SKIN.seamSoft, 1, 0.45)
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, -24, 0, 10)
    bar.Position = UDim2.new(0, 12, 0.5, -5)
    bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bar.BorderSizePixel = 0
    bar.Parent = hueRow
    round(bar, 5)
    local hg = Instance.new("UIGradient")
    hg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
    })
    hg.Parent = bar
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = bar
    round(knob, 7)
    edge(knob, SKIN.void, 2, 0)
    local HUE_SAT, HUE_VAL = 0.72, 1.0
    local dragging = false
    local function setKnobFromColor(c)
        knob.Position = UDim2.new(select(1, c:ToHSV()), 0, 0.5, 0)
    end
    local function updateFromX(px)
        local absX = bar.AbsolutePosition.X
        local absW = bar.AbsoluteSize.X
        if absW <= 0 then return end
        local frac = math.clamp((px - absX) / absW, 0, 1)
        knob.Position = UDim2.new(frac, 0, 0.5, 0)
        applyAccent(Color3.fromHSV(frac, HUE_SAT, HUE_VAL))
    end
    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Size = UDim2.new(1, 12, 3, 0)
    hit.Position = UDim2.new(0, -6, -1, 0)
    hit.ZIndex = 4
    hit.Parent = bar
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    pushRow(ThemeTab, "Reset Accent", "RESET", 7, function()
        applyAccent(DEFAULT_ACCENT)
        setKnobFromColor(DEFAULT_ACCENT)
    end)
    setKnobFromColor(ACCENT)
    registerAccent(function(c)
        swatch.BackgroundColor3 = c
        hexLbl.Text = hexOf(c)
        setKnobFromColor(c)
    end)
end
heading(ThemeTab, "BACKGROUND", 8)
local bgDeck = Instance.new("Frame")
bgDeck.Name = "BackdropDeck"
bgDeck.BackgroundColor3 = SKIN.slab
bgDeck.BackgroundTransparency = 0.25
bgDeck.Size = UDim2.new(1, -4, 0, 108)
bgDeck.BorderSizePixel = 0
bgDeck.LayoutOrder = 9
bgDeck.ZIndex = 4
bgDeck.Parent = ThemeTab
round(bgDeck, 7)
edge(bgDeck, SKIN.seamSoft, 1, 0.45)
inset(bgDeck, 8, 8, 8, 8)
local bgGrid = Instance.new("UIGridLayout")
bgGrid.CellSize = UDim2.new(0, 78, 0, 42)
bgGrid.CellPadding = UDim2.new(0, 6, 0, 6)
bgGrid.SortOrder = Enum.SortOrder.LayoutOrder
bgGrid.Parent = bgDeck
local bgButtons = {}
function updateBackgroundButtons()
    for index, holder in pairs(bgButtons) do
        local on = index == currentBackground
        local st = holder:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and ACCENT or SKIN.seamSoft
            glide(st, {Transparency = on and 0.05 or 0.55, Thickness = on and 1.4 or 1})
        end
        glide(holder, {BackgroundTransparency = on and 0 or 0.35})
    end
end
local function bgTile(index, name, order)
    local style = BACKDROPS[index]
    local holder = Instance.new("Frame")
    holder.Name = "BD" .. tostring(index)
    holder.BackgroundColor3 = style and (style.accent and accentDim(ACCENT, 0.45) or style.color) or SKIN.void
    holder.BackgroundTransparency = 0.35
    holder.BorderSizePixel = 0
    holder.LayoutOrder = order
    holder.ZIndex = 6
    holder.ClipsDescendants = true
    holder.Parent = bgDeck
    round(holder, 6)
    edge(holder, SKIN.seamSoft, 1, 0.55)
    if style and style.image and style.image ~= "rbxassetid://0" then
        local art = Instance.new("ImageLabel")
        art.BackgroundTransparency = 1
        art.Size = UDim2.new(1, 0, 1, 0)
        art.Image = style.image
        art.ScaleType = Enum.ScaleType.Crop
        art.ImageTransparency = 0.3
        art.ZIndex = 6
        art.Parent = holder
    end
    local cap = caption(holder, name, 9, TYPE_HEAVY, SKIN.ink, Enum.TextXAlignment.Center)
    cap.Size = UDim2.new(1, 0, 1, 0)
    cap.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    cap.TextStrokeTransparency = 0.4
    cap.ZIndex = 7
    local click = Instance.new("TextButton")
    click.BackgroundTransparency = 1
    click.Text = ""
    click.AutoButtonColor = false
    click.Size = UDim2.new(1, 0, 1, 0)
    click.ZIndex = 8
    click.Parent = holder
    bgButtons[index] = holder
    if style and style.accent then
        registerAccent(function() holder.BackgroundColor3 = accentDim(ACCENT, 0.45) end)
    end
    click.MouseButton1Click:Connect(function()
        applyBackground(index)
        updateBackgroundButtons()
    end)
end
bgTile(0, "OFF", 1)
for i, style in ipairs(BACKDROPS) do
    bgTile(i, string.upper(style.name), i + 1)
end
updateBackgroundButtons()
registerAccent(updateBackgroundButtons)

-- =====================================================
--  SETTINGS TAB
-- =====================================================
task.wait()
SystemTab = pages.SETTINGS
waterGuiScaleValue = math.clamp(tonumber(savedConfig.waterGuiScaleValue) or 0.72, 0.50, 1.50)
waterProgressBarScaleValue = tonumber(savedConfig.waterProgressBarScaleValue) or 0.83
toxicMainScale = Main:FindFirstChild("ToxicMainScale") or Instance.new("UIScale")
toxicMainScale.Name = "ToxicMainScale"
toxicMainScale.Scale = waterGuiScaleValue
toxicMainScale.Parent = Main

function applyToxicProgressBarScale()
    local sg = PlayerGui:FindFirstChild("StealBarGui")
    local bar = sg and sg:FindFirstChild("StealBar")
    if not bar then return end
    local sc = bar:FindFirstChild("ToxicProgressBarScale") or Instance.new("UIScale")
    sc.Name = "ToxicProgressBarScale"
    sc.Scale = waterProgressBarScaleValue
    sc.Parent = bar
end

heading(SystemTab, "PANEL", 1)
do
    local _, setVisual, hit = switchRow(SystemTab, "Lock GUI", _G.ToxicGuiLocked == true, 2)
    setLockGuiVisual = setVisual
    hit.Activated:Connect(function()
        _G.ToxicGuiLocked = not (_G.ToxicGuiLocked == true)
        setVisual(_G.ToxicGuiLocked == true)
        if ToxicUpdateGuiLockVisual then ToxicUpdateGuiLockVisual() end
        saveToxicConfig()
    end)
end
stepperRow(SystemTab, "GUI Scale", waterGuiScaleValue, 3, function(v)
    waterGuiScaleValue = v
    toxicMainScale.Scale = v
    saveToxicConfig()
end)
stepperRow(SystemTab, "Progress Bar Size", waterProgressBarScaleValue, 4, function(v)
    waterProgressBarScaleValue = v
    applyToxicProgressBarScale()
    saveToxicConfig()
end)
bindRow(SystemTab, "Toggle UI", "ToggleUI", 5)
heading(SystemTab, "MOBILE BUTTONS", 6)
do
    local _, setVisual, hit = switchRow(SystemTab, "Hide Mobile Buttons", _G.ToxicHideMobileButtons == true, 7)
    setHideMobileButtonsVisual = setVisual
    hit.Activated:Connect(function()
        _G.ToxicHideMobileButtons = not (_G.ToxicHideMobileButtons == true)
        setVisual(_G.ToxicHideMobileButtons == true)
        if _G.ToxicApplyMobileButtonsHidden then _G.ToxicApplyMobileButtonsHidden() end
        saveToxicConfig()
    end)
end
stepperRow(SystemTab, "Mobile Buttons Size", tonumber(_G.ToxicMobileButtonScale) or 0.75, 8, function(v)
    _G.ToxicMobileButtonScale = math.clamp(tonumber(v) or 0.35, 0.30, 1.35)
    if _G.ToxicApplyMobileButtonSize then _G.ToxicApplyMobileButtonSize() end
    saveToxicConfig()
end, 0.30, 1.35)
pushRow(SystemTab, "Reset Mobile Buttons", "RESET", 9, function()
    if _G.ToxicResetMobileButtons then
        _G.ToxicResetMobileButtons()
    end
end)
heading(SystemTab, "CONFIG", 10)
pushRow(SystemTab, "Import Config", "OPEN", 11, function()
    if _G.ImportPanelToggle then _G.ImportPanelToggle() end
end)
heading(SystemTab, "SETTINGS", 12)
do
    local holder = Instance.new("Frame")
    holder.Name = "ResetHolder"
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, -4, 0, 44)
    holder.LayoutOrder = 13
    holder.ZIndex = 5
    holder.Parent = SystemTab
    local btn = Instance.new("TextButton")
    btn.Name = "ResetAll"
    btn.BackgroundColor3 = SKIN.well
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = "RESET ALL SETTINGS"
    btn.TextColor3 = SKIN.ink
    btn.TextSize = 11
    btn.Font = TYPE_HEAVY
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.ZIndex = 6
    btn.Parent = holder
    round(btn, 7)
    local st = edge(btn, Color3.fromRGB(212, 74, 74), 1.2, 0.25)
    local armed = false
    local timer = nil
    local function idleTheme()
        armed = false
        btn.Text = "RESET ALL SETTINGS"
        btn.TextColor3 = SKIN.ink
        glide(btn, {BackgroundColor3 = SKIN.well})
        st.Color = Color3.fromRGB(212, 74, 74)
        glide(st, {Transparency = 0.25, Thickness = 1.2})
    end
    local function armedTheme()
        btn.Text = "CLICK AGAIN TO CONFIRM"
        btn.TextColor3 = Color3.fromRGB(255, 206, 92)
        glide(btn, {BackgroundColor3 = Color3.fromRGB(38, 30, 18)})
        st.Color = Color3.fromRGB(255, 206, 92)
        glide(st, {Transparency = 0.05, Thickness = 1.5})
    end
    local function doneTheme()
        btn.Text = "DONE \226\128\148 REJOINING"
        btn.TextColor3 = Color3.fromRGB(140, 230, 160)
        glide(btn, {BackgroundColor3 = Color3.fromRGB(20, 38, 26)})
        st.Color = Color3.fromRGB(140, 230, 160)
        glide(st, {Transparency = 0.05, Thickness = 1.5})
    end
    btn.MouseButton1Click:Connect(function()
        if not armed then
            armed = true
            armedTheme()
            if timer then task.cancel(timer) end
            timer = task.delay(3, idleTheme)
            return
        end
        if timer then
            task.cancel(timer)
            timer = nil
        end
        btn.Text = "RESETTING\226\128\166"
        pcall(function()
            local files = {CONFIG_FILE, KEYBINDS_CONFIG_FILE}
            for _, fname in ipairs(files) do
                pcall(function()
                    if fname and isfile and isfile(fname) and delfile then delfile(fname) end
                end)
            end
        end)
        pcall(function()
            waterGuiScaleValue = 0.72
            waterProgressBarScaleValue = 0.83
            NS = 59.5; CS = 28.8; LAGGER_SPEED = 29; LAGGER_CARRY_SPEED = 15
            currentSpeedMode = "Normal"
            autoCarrySpeedEnabled = false
            autoTPHeight = 20
            autoStealEnabled = false; selectedStealMode = "Semi"; autoStealRadius = 9
            _G.ToxicStealRadii = {Normal = 9, Semi = 9}
            selectedAnimationPack = "OFF"
            AIMBOT_SPEED = 58; LAGGER_AIMBOT_SPEED = 40; TPBAT_SPEED = 58
            autoSwingEnabled = false; mirrorTPDownEnabled = false; tpBatSwingEnabled = false
            _G.AimbotOn = false; _G.TPBatOn = false
            antiRagdollEnabled = false; infJumpEnabled = false; autoTPEnabled = false
            batCounterEnabled = false; medCounterEnabled = false; safeModeEnabled = false; autoResetOnMedEnabled = false
            if _G.ToxicSetAntiDie then _G.ToxicSetAntiDie(false, true) end
            if _G.ToxicSetInstaResetOnDeath then _G.ToxicSetInstaResetOnDeath(false, true) end
            pcall(function() applyAccent(DEFAULT_ACCENT, true) end)
            espEnabled = false; showTracerEnabled = false; ragdollCountdownEnabled = false
            stretchRezEnabled = false; antiLagEnabled = false; nukeOptimiserEnabled = false
            fovEnabled = false; fovValue = 70; noCamCollisionEnabled = false; _G.ToxicNoPlayerCollisionEnabled = false
            skyTheme = "Off"; currentBackground = 0
            autoLeftEnabled = false; autoRightEnabled = false
            _G.ToxicGuiLocked = false; _G.ToxicHideMobileButtons = false; _G.ToxicMobileButtonScale = 0.75
            toxicMainScale.Scale = waterGuiScaleValue
            applyToxicProgressBarScale()
            applyBackground(0)
            updateBackgroundButtons()
            for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do speedKeybinds[keyId] = defaultKey end
            tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
            refreshAllSpeedKeybinds()
            refreshTPDownKeybind()
            if normalSpeedBox then normalSpeedBox.Text = tostring(NS) end
            if carrySpeedBox then carrySpeedBox.Text = tostring(CS) end
            if laggerSpeedBox then laggerSpeedBox.Text = tostring(LAGGER_SPEED) end
            if laggerCarrySpeedBox then laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED) end
            if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
            if skyValueLabel then skyValueLabel.Text = "OFF" end
            saveToxicConfig()
        end)
        task.wait(0.35)
        doneTheme()
        task.wait(0.6)
        pcall(function()
            local TeleportService = game:GetService("TeleportService")
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end)
    end)
    idleTheme()
end

-- =====================================================
--  TOXIC DUELS | Part 6/6: StealBar, Mobile Buttons, Final
-- =====================================================

-- =====================================================
--  STEAL BAR
-- =====================================================
task.wait()
_G.__ToxicSetupStealBar = function()
    local existingStealBar = PlayerGui:FindFirstChild("StealBarGui")
    if existingStealBar then existingStealBar:Destroy() end
    local THEME_ACCENT = ACCENT
    local gui = Instance.new("ScreenGui")
    gui.Name = "StealBarGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui
    local pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "StealBar"
    pbFrame.Size = UDim2.new(0, 244, 0, 40)
    pbFrame.Position = UDim2.new(0.5, -122, 1, -92)
    pbFrame.BackgroundColor3 = Color3.fromRGB(6, 10, 8)
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
    local pbSt = Instance.new("UIStroke", pbFrame)
    pbSt.Color = THEME_ACCENT
    pbSt.Thickness = 1.4
    pbSt.Transparency = 0.25
    local pbScale = Instance.new("UIScale")
    pbScale.Name = "ToxicProgressBarScale"
    pbScale.Scale = waterProgressBarScaleValue or 0.83
    pbScale.Parent = pbFrame
    local fillRegion = Instance.new("Frame", pbFrame)
    fillRegion.Size = UDim2.new(1, -12, 1, -10)
    fillRegion.Position = UDim2.new(0, 6, 0, 5)
    fillRegion.BackgroundColor3 = Color3.fromRGB(15, 22, 18)
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 2
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
    local fillRegStroke = Instance.new("UIStroke", fillRegion)
    fillRegStroke.Color = THEME_ACCENT
    fillRegStroke.Thickness = 1
    fillRegStroke.Transparency = 0.6
    local progressFill = Instance.new("Frame", fillRegion)
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = THEME_ACCENT
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 3
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    registerAccent(function(c)
        pcall(function()
            pbSt.Color = c
            fillRegStroke.Color = c
            progressFill.BackgroundColor3 = c
        end)
    end)
    local stealLbl = Instance.new("TextLabel", fillRegion)
    stealLbl.Size = UDim2.new(0, 50, 1, 0)
    stealLbl.Position = UDim2.new(0, 10, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealLbl.Font = Enum.Font.GothamSemibold
    stealLbl.TextSize = 13
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    stealLbl.ZIndex = 5
    local progressPct = Instance.new("TextLabel", fillRegion)
    progressPct.Size = UDim2.new(0, 50, 1, 0)
    progressPct.Position = UDim2.new(1, -55, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(230, 230, 230)
    progressPct.Font = Enum.Font.GothamSemibold
    progressPct.TextSize = 12
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.ZIndex = 5
    local StealBar = {}
    function StealBar.SetProgress(p)
        p = math.clamp(p, 0, 1)
        progressFill.Size = UDim2.new(p, 0, 1, 0)
        progressPct.Text = math.floor(p * 100 + 0.5) .. "%"
    end
    function StealBar.SetState(state)
        if state == "STEALING" then
            stealLbl.Text = "STEAL"
            stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif state == "READY" then
            stealLbl.Text = "READY"
            stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            stealLbl.Text = "STEAL"
            stealLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            progressPct.Text = "0%"
        end
    end
    function StealBar.Reset()
        StealBar.SetProgress(0)
        StealBar.SetState("IDLE")
    end
    StealBar.SetState("IDLE")
    _G.StealBar = StealBar
end
_G.__ToxicSetupStealBar()

-- =====================================================
--  AUTO TP RESTORE LOGIC
-- =====================================================
_G.ToxicAutoTPRestoreWanted = _G.ToxicAutoTPRestoreWanted or false
_G.ToxicAutoTPRestoreBlockedUntil = _G.ToxicAutoTPRestoreBlockedUntil or 0

function toxicAnyAimbotActive()
    return (_G.AimbotOn == true) or (_G.TPBatOn == true)
end

function toxicTryRestoreAutoTP()
    if not _G.ToxicAutoTPRestoreWanted then return end
    if tick() < (_G.ToxicAutoTPRestoreBlockedUntil or 0) then return end
    if toxicAnyAimbotActive() then return end
    _G.ToxicAutoTPRestoreWanted = false
    if startAutoTP then startAutoTP() end
    if setAutoTPVisual then setAutoTPVisual(true) end
    saveToxicConfig()
end

RunService.Heartbeat:Connect(toxicTryRestoreAutoTP)

-- =====================================================
--  KEYBIND LISTENER
-- =====================================================
task.wait()
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local isControllerInput = tostring(input.UserInputType):find("Gamepad") ~= nil
    if gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and not listeningForSpeedKey and not listeningForTPDownKey then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard and not isControllerInput then return end
    if input.KeyCode == Enum.KeyCode.Unknown then return end
    if speedKeybinds.ToggleUI and input.KeyCode == speedKeybinds.ToggleUI then
        if Main.Visible then
            Main.Visible = false
            MiniFrame.Visible = true
        else
            Main.Visible = true
            MiniFrame.Visible = false
            Main.Size = FULL_MAIN_SIZE
        end
        saveToxicConfig()
        return
    end
    if listeningForSpeedKey then
        if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
        local targetKey = listeningForSpeedKey
        if input.KeyCode == Enum.KeyCode.Escape then
            listeningForSpeedKey = nil
            refreshAllSpeedKeybinds()
            return
        end
        if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
            speedKeybinds[targetKey] = nil
        else
            for otherKeyId, boundKey in pairs(speedKeybinds) do
                if otherKeyId ~= targetKey and boundKey == input.KeyCode then
                    speedKeybinds[otherKeyId] = nil
                end
            end
            if tpDownKeybind == input.KeyCode then
                tpDownKeybind = nil
                refreshTPDownKeybind()
            end
            speedKeybinds[targetKey] = input.KeyCode
        end
        listeningForSpeedKey = nil
        refreshAllSpeedKeybinds()
        saveToxicConfig()
        return
    end
    if listeningForTPDownKey then
        if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            listeningForTPDownKey = false
            refreshTPDownKeybind()
            return
        end
        if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
            tpDownKeybind = nil
        else
            for keyId, boundKey in pairs(speedKeybinds) do
                if boundKey == input.KeyCode then
                    speedKeybinds[keyId] = nil
                end
            end
            tpDownKeybind = input.KeyCode
        end
        listeningForTPDownKey = false
        refreshAllSpeedKeybinds()
        refreshTPDownKeybind()
        saveToxicConfig()
        return
    end
    if speedKeybinds.SpeedToggle and input.KeyCode == speedKeybinds.SpeedToggle then
        if toggleCarryMode then toggleCarryMode() end
        return
    end
    if speedKeybinds.LaggerToggle and input.KeyCode == speedKeybinds.LaggerToggle then
        if toggleLaggerMode then toggleLaggerMode() end
        return
    end
    if speedKeybinds.Aimbot and input.KeyCode == speedKeybinds.Aimbot then
        if _G.SafeModeIsLocked and _G.SafeModeIsLocked() then
            if _G.SafeModeForceStop then _G.SafeModeForceStop("SAFE MODE LOCK") end
            return
        end
        if _G.AimbotToggle then _G.AimbotToggle() end
        if _G.AimbotSyncVisual then _G.AimbotSyncVisual() end
        return
    end
    if speedKeybinds.TPBat and input.KeyCode == speedKeybinds.TPBat then
        if _G.SafeModeIsLocked and _G.SafeModeIsLocked() then
            if _G.SafeModeForceStop then _G.SafeModeForceStop("SAFE MODE LOCK") end
            return
        end
        if _G.TPBatToggle then _G.TPBatToggle() end
        return
    end
    if speedKeybinds.DropBrainrot and input.KeyCode == speedKeybinds.DropBrainrot then
        if runDropBrainrot then runDropBrainrot() end
        return
    end
    if speedKeybinds.AutoLeft and input.KeyCode == speedKeybinds.AutoLeft then
        if _G.ToxicSetAutoLeft then _G.ToxicSetAutoLeft(not autoLeftEnabled) end
        return
    end
    if speedKeybinds.AutoRight and input.KeyCode == speedKeybinds.AutoRight then
        if _G.ToxicSetAutoRight then _G.ToxicSetAutoRight(not autoRightEnabled) end
        return
    end
    if speedKeybinds.LaggerActivate and input.KeyCode == speedKeybinds.LaggerActivate then
        if toggleLagger then
            toggleLagger()
            if showActionNotification then showActionNotification(laggerEnabled and "LAGGER ON" or "LAGGER OFF") end
        end
        return
    end
    if speedKeybinds.AntiDie and input.KeyCode == speedKeybinds.AntiDie then
        if _G.ToxicSetAntiDie then
            _G.ToxicSetAntiDie(not antiDieEnabled)
            if showActionNotification then showActionNotification(antiDieEnabled and "ANTI DIE ON" or "ANTI DIE OFF") end
        end
        return
    end
    if speedKeybinds.InstantReset and input.KeyCode == speedKeybinds.InstantReset then
        if _G.InstantReset then _G.InstantReset() end
        return
    end
    if speedKeybinds.ToxicLagger and input.KeyCode == speedKeybinds.ToxicLagger then
        if _G.LaggerWindowToggle then _G.LaggerWindowToggle() end
        return
    end
    if tpDownKeybind and input.KeyCode == tpDownKeybind then
        if runTPFloor then runTPFloor() end
        return
    end
end)

-- =====================================================
--  MOBILE BUTTONS
-- =====================================================
task.defer(function()
    task.wait(0.5)
    local TS = game:GetService("TweenService")
    local old = PlayerGui:FindFirstChild("ToxicDuelsMobileButtons")
    if old then old:Destroy() end
    local mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "ToxicDuelsMobileButtons"
    mobileGui.ResetOnSpawn = false
    mobileGui.IgnoreGuiInset = true
    mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mobileGui.DisplayOrder = 1000
    mobileGui.Parent = PlayerGui
    _G.ToxicMobileButtonRefs = {}
    local mobileButtons = _G.ToxicMobileButtonRefs

    function _G.ToxicApplyMobileButtonsHidden()
        local g = PlayerGui:FindFirstChild("ToxicDuelsMobileButtons")
        if g then g.Enabled = not (_G.ToxicHideMobileButtons == true) end
        if setHideMobileButtonsVisual then pcall(setHideMobileButtonsVisual, _G.ToxicHideMobileButtons == true) end
    end

    function _G.ToxicApplyMobileButtonSize()
        _G.ToxicMobileButtonScale = math.clamp(tonumber(_G.ToxicMobileButtonScale) or 0.75, 0.30, 1.35)
        for _, entry in pairs(mobileButtons) do
            local holder = entry and entry.holder
            if holder then
                local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale")
                sc.Name = "MobileButtonScale"
                sc.Scale = _G.ToxicMobileButtonScale
                sc.Parent = holder
            end
        end
    end

    local function setActive(btn, state)
        if not btn then return end
        local pressed = btn:GetAttribute("ToxicMobilePressed") == true
        state = (state == true) or pressed
        local visualState = state and "on" or "off"
        if btn:GetAttribute("ToxicMobileVisualState") == visualState then return end
        btn:SetAttribute("ToxicMobileVisualState", visualState)
        local acc = (_G.ToxicGetAccent and _G.ToxicGetAccent()) or Color3.fromRGB(82, 255, 70)
        local st = btn:FindFirstChildOfClass("UIStroke")
        TS:Create(btn, TweenInfo.new(0.18), {
            BackgroundColor3 = state and acc or Color3.fromRGB(14, 22, 16),
            TextColor3 = state and Color3.fromRGB(9, 16, 10) or Color3.fromRGB(240, 255, 240),
        }):Play()
        if st then
            TS:Create(st, TweenInfo.new(0.18), {Thickness = state and 1.4 or 1, Transparency = state and 0 or 0.42}):Play()
            st.Color = state and acc or Color3.fromRGB(58, 118, 66)
        end
    end

    local function pulse(btn)
        if not btn then return end
        btn:SetAttribute("ToxicMobilePressed", true)
        setActive(btn, true)
        task.delay(0.18, function()
            if btn and btn.Parent then
                btn:SetAttribute("ToxicMobilePressed", false)
                setActive(btn, false)
            end
        end)
    end

    local function makeButton(key, label, pos, onPress)
        local holder = Instance.new("Frame")
        holder.Name = "MBH_" .. key
        holder.Size = UDim2.new(0, 60, 0, 60)
        holder.Position = tableToUDim2(_G.ToxicMobileButtonPositions[key], pos)
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.ZIndex = 1000
        holder.Active = true
        holder.Parent = mobileGui
        local btn = Instance.new("TextButton", holder)
        btn.Name = "MB_" .. key
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(14, 22, 16)
        btn.BackgroundTransparency = 0.05
        btn.BorderSizePixel = 0
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(240, 255, 240)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 10
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 1002
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(58, 118, 66)
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local pressing, dragging = false, false
        local pressPos, holderStart = nil, nil
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                pressing = true
                dragging = false
                pressPos = i.Position
                holderStart = holder.Position
                btn:SetAttribute("ToxicMobilePressed", true)
                setActive(btn, true)
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if pressing and not dragging then pcall(onPress, btn) end
                if dragging then saveToxicConfig() end
                pressing = false
                dragging = false
                btn:SetAttribute("ToxicMobilePressed", false)
                task.delay(0.08, function()
                    if btn and btn.Parent then
                        local keepOn = false
                        if key == "autoLeft" then keepOn = autoLeftEnabled == true
                        elseif key == "autoRight" then keepOn = autoRightEnabled == true
                        elseif key == "aimbot" then keepOn = _G.AimbotOn == true
                        elseif key == "antiDesync" then keepOn = _G.TPBatOn == true
                        elseif key == "carry" then keepOn = currentSpeedMode == "Carry"
                        elseif key == "laggerNormal" then keepOn = currentSpeedMode == "Lagger"
                        elseif key == "laggerCarry" then keepOn = currentSpeedMode == "Lagger Carry"
                        end
                        setActive(btn, keepOn)
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if _G.ToxicGuiLocked == true or not pressing then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = i.Position - pressPos
            if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
            if dragging then
                holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
            end
        end)
        mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end}
        return btn
    end

    local x1, x2, x3 = -212, -146, -80
    local y1, y2, y3, y4 = -200, -134, -68, -2
    local defaults = {
        insta        = UDim2.new(1, x1, 0.5, y1),
        drop         = UDim2.new(1, x2, 0.5, y1),
        autoLeft     = UDim2.new(1, x3, 0.5, y1),
        antiDesync   = UDim2.new(1, x1, 0.5, y2),
        aimbot       = UDim2.new(1, x2, 0.5, y2),
        autoRight    = UDim2.new(1, x3, 0.5, y2),
        tp           = UDim2.new(1, x2, 0.5, y3),
        carry        = UDim2.new(1, x3, 0.5, y3),
        laggerNormal = UDim2.new(1, x2, 0.5, y4),
        laggerCarry  = UDim2.new(1, x3, 0.5, y4),
    }

    function _G.ToxicResetMobileButtons()
        _G.ToxicMobileButtonScale = 0.75
        _G.ToxicHideMobileButtons = false
        for key, defaultPos in pairs(defaults) do
            local entry = mobileButtons[key]
            local holder = entry and entry.holder
            if holder then
                holder.Position = defaultPos
                holder.Size = UDim2.new(0, 60, 0, 60)
            end
        end
        if _G.ToxicApplyMobileButtonSize then _G.ToxicApplyMobileButtonSize() end
        if _G.ToxicApplyMobileButtonsHidden then _G.ToxicApplyMobileButtonsHidden() end
        showActionNotification("MOBILE BUTTONS RESET")
        saveToxicConfig()
    end

    makeButton("insta", "INSTA\nRESET", defaults.insta, function(btn)
        if _G.InstantReset then _G.InstantReset() end
        pulse(btn)
    end)
    makeButton("drop", "DROP\nBR", defaults.drop, function(btn)
        if runDropBrainrot then runDropBrainrot() end
        pulse(btn)
    end)
    makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function(btn)
        if _G.ToxicSetAutoLeft then _G.ToxicSetAutoLeft(not autoLeftEnabled) end
        task.delay(0.03, function()
            if mobileButtons.autoLeft then mobileButtons.autoLeft.setActive(autoLeftEnabled == true) end
        end)
    end)
    makeButton("antiDesync", "TP\nBAT", defaults.antiDesync, function(btn)
        if _G.TPBatToggle then _G.TPBatToggle() end
        task.delay(0.03, function() setActive(btn, _G.TPBatOn == true) end)
    end)
    makeButton("aimbot", "AIM\nLOCK", defaults.aimbot, function(btn)
        if _G.AimbotToggle then _G.AimbotToggle() end
        task.delay(0.03, function() setActive(btn, _G.AimbotOn == true) end)
    end)
    makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function(btn)
        if _G.ToxicSetAutoRight then _G.ToxicSetAutoRight(not autoRightEnabled) end
        task.delay(0.03, function()
            if mobileButtons.autoRight then mobileButtons.autoRight.setActive(autoRightEnabled == true) end
        end)
    end)
    makeButton("tp", "TP\nDOWN", defaults.tp, function(btn)
        if runTPFloor then runTPFloor() end
        pulse(btn)
    end)
    makeButton("carry", "CARRY\nSPEED", defaults.carry, function(btn)
        if setSpeedMode then setSpeedMode(currentSpeedMode == "Carry" and "Normal" or "Carry") end
        task.delay(0.03, function()
            if mobileButtons.carry then mobileButtons.carry.setActive(currentSpeedMode == "Carry") end
        end)
    end)
    makeButton("laggerNormal", "LAGGER\nNORMAL", defaults.laggerNormal, function(btn)
        if setSpeedMode then setSpeedMode(currentSpeedMode == "Lagger" and "Normal" or "Lagger") end
        task.delay(0.03, function()
            if mobileButtons.laggerNormal then mobileButtons.laggerNormal.setActive(currentSpeedMode == "Lagger") end
        end)
    end)
    makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function(btn)
        if setSpeedMode then setSpeedMode(currentSpeedMode == "Lagger Carry" and "Normal" or "Lagger Carry") end
        task.delay(0.03, function()
            if mobileButtons.laggerCarry then mobileButtons.laggerCarry.setActive(currentSpeedMode == "Lagger Carry") end
        end)
    end)

    _G.ToxicApplyMobileButtonSize()
    _G.ToxicApplyMobileButtonsHidden()
end)

-- =====================================================
--  FINAL SYNC
-- =====================================================
task.wait()
setTab("STEAL")

task.defer(function()
    task.wait(0.5)
    if _G.GrabRefresh then pcall(_G.GrabRefresh) end
    if _G.ToxicSyncToggleVisuals then _G.ToxicSyncToggleVisuals() end
end)

_G.ToxicSyncToggleVisuals = function()
    pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
    pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
    pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
    pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
    pcall(function() if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end end)
    pcall(function() if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled == true) end end)
    pcall(function() if setAntiDieVisual then setAntiDieVisual(antiDieEnabled == true) end end)
    pcall(function() if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(autoLeftEnabled == true) end end)
    pcall(function() if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(autoRightEnabled == true) end end)
end

task.spawn(function()
    while task.wait(30) do
        saveToxicConfig()
    end
end)

if ToxicUpdateGuiLockVisual then ToxicUpdateGuiLockVisual() end
if _G.ToxicApplyMobileButtonsHidden then _G.ToxicApplyMobileButtonsHidden() end

-- =====================================================
--  TOXIC DUELS | Part 5B: Core Logic
--  Aimbot / TPBat / MirrorTP / SemiSteal / GrabSetup
-- =====================================================

-- ===== SAFE MODE CORE =====
task.wait()
_G.SafeModeGetCountdownLabel = function()
    local ok, label = pcall(function()
        return LP.PlayerGui
        and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
        and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
        and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
        and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end
_G.SafeModeCountdownNumber = function(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end
_G.SafeModeInDuelCountdown = function()
    local label = _G.SafeModeGetCountdownLabel()
    return label and _G.SafeModeCountdownNumber(label.Text) or false
end
_G.SafeModeHoldingBrainrot = function()
    local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local char = LP.Character
    if not char then return false end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end
_G.SafeModeIsLocked = function()
    if not safeModeEnabled then return false end
    return _G.SafeModeInDuelCountdown() or _G.SafeModeHoldingBrainrot()
end
_G.SafeModeForceStop = function(reason)
    local stopped = false
    if _G.AimbotOn and _G.AimbotStop then _G.AimbotStop(); stopped = true end
    if _G.TPBatOn and _G.TPBatStop then _G.TPBatStop(); stopped = true end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(false) end
        if _G.ToxicStopAutoLeft then _G.ToxicStopAutoLeft() end
        stopped = true
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(false) end
        if _G.ToxicStopAutoRight then _G.ToxicStopAutoRight() end
        stopped = true
    end
    if stopped and showActionNotification then pcall(function() showActionNotification(reason or "SAFE MODE LOCK") end) end
end
_G.SafeModeTryStart = function()
    if _G.SafeModeIsLocked and _G.SafeModeIsLocked() then
        _G.SafeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end

-- ===== AIMBOT =====
task.wait()
local AIM_DIST = -2.8
local AIM_VERT_OFFSET = 1
local AIM_TURN_SPEED = 285
local AIM_MAX_TURN_RATE = 28
local AIM_VERT_RATIO = 52 / 58
local AIM_SWING_RANGE = 6
local AIM_VEL_LIMIT = 110
local AIM_VEL_SPIKE_RATIO = 2.5
local AIM_PRED_MAX = 7
local AIM_VEL_SMOOTH = 0.25
local aimVelAvg = Vector3.zero
local aimConn = nil
local aimEquipped = false
local aimTarget = nil
local aimLastScan = 0
local aimBatTool = nil

local function aimChar() return LP.Character end
local function aimHumanoid()
    local char = aimChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end
local function aimRoot()
    local char = aimChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

_G.AimbotActiveSpeed = function()
    if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
        return tonumber(LAGGER_AIMBOT_SPEED) or 40
    end
    return tonumber(AIMBOT_SPEED) or 58
end
_G.AimbotFindBat = function()
    local char = aimChar()
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("bat") or name:find("slap") then return tool end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then return tool end
            end
        end
    end
    return nil
end
local function aimEquipBat()
    local char = aimChar()
    local hum = aimHumanoid()
    if not char or not hum then return end
    local held = char:FindFirstChildOfClass("Tool")
    if held then aimBatTool = held; return end
    local bat = _G.AimbotFindBat()
    if bat then
        pcall(function() hum:EquipTool(bat) end)
        aimBatTool = bat
    end
end
_G.AimbotClosestTarget = function()
    local root = aimRoot()
    if not root then return nil end
    local now = tick()
    if now - aimLastScan <= 0.1 and aimTarget and aimTarget.Parent then
        local hum = aimTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return aimTarget end
    end
    aimLastScan = now
    aimTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    if closest ~= aimTarget then aimVelAvg = Vector3.zero end
    aimTarget = closest
    return aimTarget
end
local function aimReleaseMotion()
    local root = aimRoot()
    local hum = aimHumanoid()
    if root then
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then hum.AutoRotate = true end
end
local function aimStep()
    if not _G.AimbotOn then return end
    local char = aimChar()
    local hum = aimHumanoid()
    local root = aimRoot()
    if not char or not hum or not root then return end
    if not aimEquipped then aimEquipped = true; aimEquipBat() end
    local target = _G.AimbotClosestTarget()
    if not target then
        hum.AutoRotate = true
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        return
    end
    local speed = _G.AimbotActiveSpeed()
    local vertSpeed = speed * AIM_VERT_RATIO
    local rawVel = target.AssemblyLinearVelocity or Vector3.zero
    local rawSpeed = rawVel.Magnitude
    local avgSpeed = aimVelAvg.Magnitude
    local saneVel = rawVel
    if rawSpeed > AIM_VEL_LIMIT then
        saneVel = avgSpeed > 0 and aimVelAvg or Vector3.zero
    elseif avgSpeed > 1 and rawSpeed > avgSpeed * AIM_VEL_SPIKE_RATIO then
        saneVel = aimVelAvg
    else
        aimVelAvg = aimVelAvg:Lerp(rawVel, AIM_VEL_SMOOTH)
    end
    local predict = saneVel * math.clamp(saneVel.Magnitude / 130, 0.05, 0.15)
    if predict.Magnitude > AIM_PRED_MAX then predict = predict.Unit * AIM_PRED_MAX end
    local aimPos = target.Position + predict + Vector3.new(0, AIM_VERT_OFFSET, 0)
    hum.AutoRotate = false
    local look = aimPos - root.Position
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
        local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
        local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
        local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
        local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
        local yawRate = math.clamp(math.rad(yawDelta) * AIM_TURN_SPEED, -AIM_MAX_TURN_RATE, AIM_MAX_TURN_RATE)
        local pitchRate = math.clamp(math.rad(pitchDelta) * AIM_TURN_SPEED, -AIM_MAX_TURN_RATE, AIM_MAX_TURN_RATE)
        local yawRad = math.rad(root.Orientation.Y)
        local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
        root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
    else
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if mirrorAngleEnabled then
        local ok, cf = pcall(function() return target.CFrame end)
        local cam = workspace.CurrentCamera
        if ok and cf and cam then
            local eye = cam.CFrame.Position
            cam.CFrame = CFrame.new(eye, eye + cf.LookVector)
        end
    end
    local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
    local standPos = aimPos - (dir * AIM_DIST) + Vector3.new(0, tonumber(aimbotHeight) or 6.25, 0)
    local moveDir = standPos - root.Position
    local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
    local hVel = hDir.Magnitude > 0.1 and hDir.Unit * speed or Vector3.zero
    local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * vertSpeed, 0) or Vector3.new(0, -2, 0)
    root.AssemblyLinearVelocity = hVel + vVel
    if hDir.Magnitude > 0.5 then hum:Mobility(hDir.Unit, false) end
    if autoSwingEnabled and (root.Position - target.Position).Magnitude < AIM_SWING_RANGE then
        local bat = aimBatTool
        if not bat or not bat.Parent then bat = _G.AimbotFindBat(); aimBatTool = bat end
        if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
    end
end

_G.AimbotStart = function()
    if _G.SafeModeTryStart and not _G.SafeModeTryStart() then return false end
    if _G.ToxicStopAutoTPForAction then _G.ToxicStopAutoTPForAction() end
    if _G.TPBatStop and _G.TPBatOn then _G.TPBatStop() end
    _G.AimbotOn = true
    aimEquipped = false
    if aimConn then aimConn:Disconnect(); aimConn = nil end
    aimConn = RunService.Heartbeat:Connect(aimStep)
    if _G.AimbotSyncVisual then _G.AimbotSyncVisual() end
    saveToxicConfig()
    return true
end
_G.AimbotStop = function()
    _G.AimbotOn = false
    if aimConn then aimConn:Disconnect(); aimConn = nil end
    aimEquipped = false
    aimTarget = nil
    aimBatTool = nil
    aimReleaseMotion()
    if _G.AimbotSyncVisual then _G.AimbotSyncVisual() end
    saveToxicConfig()
end
_G.AimbotToggle = function()
    if _G.AimbotOn then _G.AimbotStop() else _G.AimbotStart() end
end
_G.AimbotSyncVisual = function()
    if _G.AimbotSetVisual then _G.AimbotSetVisual(_G.AimbotOn == true) end
end
LP.CharacterAdded:Connect(function()
    aimEquipped = false
    aimTarget = nil
    aimBatTool = nil
    if _G.AimbotOn then task.wait(0.5); aimEquipBat() end
end)

-- ===== MIRROR TP =====
task.wait()
local MIRROR_TP_DROP_THRESHOLD = 3
local MIRROR_TP_DOWN_Y = -7.00
local mirrorTPPreviousY = {}
local mirrorTPLastTeleport = 0
local function mirrorTPAimbotActive()
    return (_G.AimbotOn == true) or (_G.TPBatOn == true)
end
local function mirrorTPTeleportDown()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - mirrorTPLastTeleport < 0.08 then return end
    mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.Velocity = Vector3.zero
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
end
RunService.Heartbeat:Connect(function()
    if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
        table.clear(mirrorTPPreviousY)
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local currentY = root.Position.Y
                local previousY = mirrorTPPreviousY[player.UserId]
                if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
                    pcall(mirrorTPTeleportDown)
                    table.clear(mirrorTPPreviousY)
                    if type(showActionNotification) == "function" then
                        pcall(function() showActionNotification("MIRROR TP!") end)
                    end
                    return
                end
                mirrorTPPreviousY[player.UserId] = currentY
            end
        end
    end
end)
_G.MirrorTPSet = function(enabled)
    mirrorTPDownEnabled = enabled == true
    if not mirrorTPDownEnabled then table.clear(mirrorTPPreviousY) end
    if _G.MirrorTPSetVisual then _G.MirrorTPSetVisual(mirrorTPDownEnabled) end
end

-- ===== TP BAT =====
task.wait()
_G.TPBatState = _G.TPBatState or {conn = nil, hittingCooldown = false, h = nil, hrp = nil}
_G.TPBatFindBat = function()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then tool.Parent = char; return tool end
    end
    return nil
end
_G.TPBatTrySwing = function()
    if not _G.TPBatState then return end
    if tick() - (_G.TPBatState.lastSwing or 0) < 0.1 then return end
    _G.TPBatState.lastSwing = tick()
    pcall(function()
        local bat = _G.TPBatFindBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
end
_G.TPBatClosestPlayer = function()
    local hrp = _G.TPBatState and _G.TPBatState.hrp
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end
_G.TPBatBindChar = function(char)
    task.wait(0.1)
    if not _G.TPBatState then return end
    _G.TPBatState.h = char and char:WaitForChild("Humanoid", 5) or nil
    _G.TPBatState.hrp = char and char:WaitForChild("HumanoidRootPart", 5) or nil
end
LP.CharacterAdded:Connect(function(char)
    pcall(function() _G.TPBatBindChar(char) end)
end)
if LP.Character then
    task.spawn(function() pcall(function() _G.TPBatBindChar(LP.Character) end) end)
end
_G.TPBatStart = function()
    if _G.SafeModeTryStart and not _G.SafeModeTryStart() then return false end
    if _G.ToxicStopAutoTPForAction then _G.ToxicStopAutoTPForAction() end
    if _G.AimbotStop then _G.AimbotStop() end
    _G.TPBatOn = true
    if _G.ToxicSetAntiDie then _G.ToxicSetAntiDie(true) end
    if _G.TPBatState.conn then _G.TPBatState.conn:Disconnect(); _G.TPBatState.conn = nil end
    if LP.Character then pcall(function() _G.TPBatBindChar(LP.Character) end) end
    _G.TPBatState.conn = RunService.Heartbeat:Connect(function()
        if not (_G.TPBatOn and _G.TPBatState.h and _G.TPBatState.hrp) then return end
        local target = _G.TPBatClosestPlayer()
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(_G.TPBatState.hrp, "PhysicsRepRootPart", tr) end)
                end
                local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                if (_G.TPBatState.hrp.Position - targetPos).Magnitude > 8 then
                    _G.TPBatState.hrp.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
                if tpBatSwingEnabled or autoSwingEnabled then _G.TPBatTrySwing() end
            end
        end
    end)
    if _G.TPBatSetVisual then _G.TPBatSetVisual(true) end
    saveToxicConfig()
    return true
end
_G.TPBatStop = function()
    _G.TPBatOn = false
    if _G.ToxicSetAntiDie then _G.ToxicSetAntiDie(false) end
    if _G.TPBatState and _G.TPBatState.conn then
        _G.TPBatState.conn:Disconnect()
        _G.TPBatState.conn = nil
    end
    if _G.TPBatState then _G.TPBatState.hittingCooldown = false end
    if _G.TPBatSetVisual then _G.TPBatSetVisual(false) end
    saveToxicConfig()
end
_G.TPBatToggle = function()
    if _G.TPBatOn then _G.TPBatStop() else _G.TPBatStart() end
end

-- =====================================================
--  TOXIC DUELS | Part 5C: Survival + Movement Logic
--  AntiDie / AntiRagdoll / InfJump / AutoTP / Drop / Anim
-- =====================================================

-- ===== INSTANT RESET =====
task.wait()
_G.InstantResetRemote = _G.InstantResetRemote or nil
_G.InstantResetGuid = _G.InstantResetGuid or "f888ee6e-c86d-46e1-93d7-0639d6635d42"
pcall(function()
    if not _G.InstantResetHooked and hookfunction and newcclosure then
        _G.InstantResetHooked = true
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not _G.InstantResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                _G.InstantResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)
_G.InstantReset = function()
    if not _G.InstantResetRemote then
        for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
                _G.InstantResetRemote = desc
                break
            end
        end
    end
    if not _G.InstantResetRemote then return end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then
        pcall(function() _G.InstantResetRemote:FireServer(_G.InstantResetGuid, LP, "balloon") end)
        return
    end
    local resetDetected = false
    local resetConns = {}
    if humanoid then
        table.insert(resetConns, humanoid.Died:Connect(function() resetDetected = true end))
        table.insert(resetConns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then resetDetected = true end
        end))
    end
    if character then
        table.insert(resetConns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then resetDetected = true end
        end))
    end
    task.spawn(function()
        for _ = 1, 10 do
            if resetDetected then break end
            pcall(function() _G.InstantResetRemote:FireServer(_G.InstantResetGuid, LP, "balloon") end)
            task.wait(0.05)
        end
        for _, conn in ipairs(resetConns) do pcall(function() conn:Disconnect() end) end
    end)
end
function cursedInstaReset() return _G.InstantReset() end

-- ===== AUTO TP =====
task.wait()
autoTPEnabled = autoTPEnabled or false
autoTPHeight = autoTPHeight or 20
autoTPConn = nil
autoTPLastRun = 0
autoTPClickDebounce = false
setAutoTPVisual = nil

local function doAutoTPDown(force)
    local char=LP.Character;if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then
        if hum2.FloorMaterial~=Enum.Material.Air then return end
        if hrp.Position.Y<autoTPHeight then return end
    end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
    *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.AssemblyLinearVelocity=Vector3.zero
end
local function _clearAutoTPConnection()
    if autoTPConn then
        pcall(function() autoTPConn:Disconnect() end)
        autoTPConn = nil
    end
end
function startAutoTP()
    autoTPEnabled = true
    _clearAutoTPConnection()
    autoTPLastRun = 0
    autoTPConn = RunService.Heartbeat:Connect(function()
        if not autoTPEnabled then _clearAutoTPConnection(); return end
        local now = tick()
        if now - autoTPLastRun < 0.1 then return end
        autoTPLastRun = now
        pcall(function() doAutoTPDown(false) end)
    end)
    if setAutoTPVisual then setAutoTPVisual(true) end
end
function stopAutoTP()
    autoTPEnabled = false
    _clearAutoTPConnection()
    if setAutoTPVisual then setAutoTPVisual(false) end
end
function runTPFloor()
    pcall(function() doAutoTPDown(true) end)
end
function toggleAutoTP(on)
    if on then startAutoTP() else stopAutoTP() end
    saveToxicConfig()
end
_G.ToxicStopAutoTPForAction = function()
    if autoTPEnabled then
        stopAutoTP()
        if setAutoTPVisual then setAutoTPVisual(false) end
        saveToxicConfig()
    end
end

-- ===== DROP BRAINROT =====
task.wait()
dropBrainrotActive = false
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
function runDropBrainrot()
    if dropBrainrotActive then return end
    if _G.ToxicStopAutoTPForAction then _G.ToxicStopAutoTPForAction() end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    dropBrainrotActive = true
    local startTime = tick()
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then dropConn:Disconnect() end
            dropBrainrotActive = false
            return
        end
        if tick() - startTime >= DROP_ASCEND_DURATION then
            if dropConn then dropConn:Disconnect() end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                currentRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            dropBrainrotActive = false
            return
        end
        currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, DROP_ASCEND_SPEED, currentRoot.Velocity.Z)
    end)
end

-- ===== ANIMATIONS =====
task.wait()
selectedAnimationPack = selectedAnimationPack or "OFF"
customAnimIds = customAnimIds or {idle = "", walk = "", run = "", jump = "", fall = "", climb = ""}
AnimationPacks = {
    ["Zombie"] = {idle = {{"rbxassetid://616158929", 1}, {"rbxassetid://616158929", 1}}, walk = "rbxassetid://616168032", run = "rbxassetid://616163682", jump = "rbxassetid://616161997", fall = "rbxassetid://616157476", climb = "rbxassetid://616156119"},
    ["Ninja"] = {idle = {{"rbxassetid://656117400", 1}, {"rbxassetid://656117400", 1}}, walk = "rbxassetid://656121766", run = "rbxassetid://656118852", jump = "rbxassetid://656117878", fall = "rbxassetid://656115606", climb = "rbxassetid://656114359"},
    ["Knight"] = {idle = {{"rbxassetid://657595757", 1}, {"rbxassetid://657595757", 1}}, walk = "rbxassetid://657552124", run = "rbxassetid://657564596", jump = "rbxassetid://658409194", fall = "rbxassetid://657600338", climb = "rbxassetid://658360781"},
    ["Elder"] = {idle = {{"rbxassetid://845397899", 1}, {"rbxassetid://845397899", 1}}, walk = "rbxassetid://845403856", run = "rbxassetid://845386501", jump = "rbxassetid://845398858", fall = "rbxassetid://845397673", climb = "rbxassetid://845392038"},
    ["Levitate"] = {idle = {{"rbxassetid://616006778", 1}, {"rbxassetid://616006778", 1}}, walk = "rbxassetid://616013216", run = "rbxassetid://616013216", jump = "rbxassetid://616008936", fall = "rbxassetid://616005863", climb = "rbxassetid://616003713"},
    ["Astronaut"] = {idle = {{"rbxassetid://891621366", 1}, {"rbxassetid://891621366", 1}}, walk = "rbxassetid://891636393", run = "rbxassetid://891636393", jump = "rbxassetid://891627522", fall = "rbxassetid://891617961", climb = "rbxassetid://891609353"},
    ["Pirate"] = {idle = {{"rbxassetid://750781874", 1}, {"rbxassetid://750781874", 1}}, walk = "rbxassetid://750785693", run = "rbxassetid://750783738", jump = "rbxassetid://750782230", fall = "rbxassetid://750780242", climb = "rbxassetid://750779899"},
    ["Toy"] = {idle = {{"rbxassetid://782841498", 1}, {"rbxassetid://782841498", 1}}, walk = "rbxassetid://782843345", run = "rbxassetid://782842708", jump = "rbxassetid://782847020", fall = "rbxassetid://782846423", climb = "rbxassetid://782843869"},
    ["Vampire"] = {idle = {{"rbxassetid://1083445855", 1}, {"rbxassetid://1083445855", 1}}, walk = "rbxassetid://1083473930", run = "rbxassetid://1083462077", jump = "rbxassetid://1083455352", fall = "rbxassetid://1083443587", climb = "rbxassetid://1083439238"},
    ["Werewolf"] = {idle = {{"rbxassetid://1083195517", 1}, {"rbxassetid://1083195517", 1}}, walk = "rbxassetid://1083178339", run = "rbxassetid://1083216690", jump = "rbxassetid://1083218792", fall = "rbxassetid://1083189019", climb = "rbxassetid://1083182000"},
    ["Rthro"] = {idle = {{"rbxassetid://2510196951", 1}, {"rbxassetid://2510196951", 1}}, walk = "rbxassetid://2510202577", run = "rbxassetid://2510198475", jump = "rbxassetid://2510197830", fall = "rbxassetid://2510195892", climb = "rbxassetid://2510192778"},
    ["Stylish"] = {idle = {{"rbxassetid://616136790", 1}, {"rbxassetid://616136790", 1}}, walk = "rbxassetid://616146177", run = "rbxassetid://616140816", jump = "rbxassetid://616139451", fall = "rbxassetid://616134815", climb = "rbxassetid://616133594"},
}
AnimationPackList = {"OFF", "Unwalk", "Hit Harder", "Zombie", "Ninja", "Knight", "Elder", "Levitate", "Astronaut", "Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish"}
AnimationPackIndex = 1
OriginalAnims = {}

local unwalkEnabled = false
unwalkSavedAnimate = nil
local hitHarderAnimEnabled = false
local enableUnwalk, disableUnwalk, enableHitHarderAnim, disableHitHarderAnim
local HIT_HARDER_ANIMS = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
}
local function getAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end
local function stopCurrentAnimations(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end
local function backupAnimations(char)
    local animate = getAnimate(char)
    if not animate or next(OriginalAnims) ~= nil then return end
    local function getId(obj) return obj and obj.AnimationId or nil end
    OriginalAnims = {
        idle1 = getId(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2 = getId(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk = getId(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run = getId(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump = getId(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall = getId(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb = getId(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
    }
end
local function setAnimId(obj, id)
    if obj and id then pcall(function() obj.AnimationId = id end) end
end
local function reloadAnimate(animate)
    if not animate then return end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end
function resetAnimations()
    local char = LP.Character
    local animate = getAnimate(char)
    if not animate or next(OriginalAnims) == nil then return end
    stopCurrentAnimations(char)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), OriginalAnims.idle1)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), OriginalAnims.idle2)
    setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), OriginalAnims.walk)
    setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), OriginalAnims.run)
    setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), OriginalAnims.jump)
    setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), OriginalAnims.fall)
    setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), OriginalAnims.climb)
    reloadAnimate(animate)
end
function applyAnimationPack(packName)
    selectedAnimationPack = packName or "OFF"
    if selectedAnimationPack ~= "Unwalk" and unwalkEnabled then disableUnwalk() end
    if selectedAnimationPack ~= "Hit Harder" and hitHarderAnimEnabled then
        hitHarderAnimEnabled = false
        resetAnimations()
    end
    if selectedAnimationPack == "Unwalk" then
        resetAnimations()
        enableUnwalk()
        return
    end
    if selectedAnimationPack == "Hit Harder" then
        disableUnwalk()
        enableHitHarderAnim()
        return
    end
    if selectedAnimationPack == "OFF" then
        resetAnimations()
        return
    end
    local pack = AnimationPacks[selectedAnimationPack]
    local char = LP.Character
    local animate = getAnimate(char)
    if not pack or not animate then return end
    backupAnimations(char)
    stopCurrentAnimations(char)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle[1][1])
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle[2][1])
    setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
    setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
    setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
    setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
    setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
    reloadAnimate(animate)
end
enableUnwalk = function()
    unwalkEnabled = true
    local char = LP.Character
    local animate = getAnimate(char)
    if animate then
        if not unwalkSavedAnimate then unwalkSavedAnimate = animate:Clone() end
        stopCurrentAnimations(char)
        animate:Destroy()
    end
end
disableUnwalk = function()
    unwalkEnabled = false
    local char = LP.Character
    if char and not char:FindFirstChild("Animate") and unwalkSavedAnimate then
        local newAnimate = unwalkSavedAnimate:Clone()
        newAnimate.Parent = char
    end
end
enableHitHarderAnim = function()
    hitHarderAnimEnabled = true
    local char = LP.Character
    local animate = getAnimate(char)
    if not animate then return end
    backupAnimations(char)
    stopCurrentAnimations(char)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), HIT_HARDER_ANIMS.idle1)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), HIT_HARDER_ANIMS.idle2)
    setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), HIT_HARDER_ANIMS.walk)
    setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), HIT_HARDER_ANIMS.run)
    setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), HIT_HARDER_ANIMS.jump)
    setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), HIT_HARDER_ANIMS.fall)
    reloadAnimate(animate)
end
disableHitHarderAnim = function()
    hitHarderAnimEnabled = false
    resetAnimations()
    if selectedAnimationPack ~= "OFF" then
        task.wait()
        applyAnimationPack(selectedAnimationPack)
    end
end

function syncAnimationPackIndex()
    for i, name in ipairs(AnimationPackList) do
        if name == selectedAnimationPack then AnimationPackIndex = i; return end
    end
    selectedAnimationPack = "OFF"
    AnimationPackIndex = 1
end
function refreshAnimationPackRow()
    if animValueLabel then animValueLabel.Text = string.upper(selectedAnimationPack) end
end
function applySavedAnimationPackToCharacter(char)
    syncAnimationPackIndex()
    if refreshAnimationPackRow then pcall(refreshAnimationPackRow) end
    if not char then char = LP.Character end
    if not char then return end
    local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 6)
    if not animate then return end
    task.wait(0.2)
    OriginalAnims = {}
    unwalkSavedAnimate = nil
    if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
        pcall(function() applyAnimationPack(selectedAnimationPack) end)
    else
        pcall(function() resetAnimations() end)
    end
end
syncAnimationPackIndex()
task.defer(function() applySavedAnimationPackToCharacter(LP.Character) end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.65)
    applySavedAnimationPackToCharacter(char)
end)

-- ===== ANTI RAGDOLL =====
task.wait()
antiRagdollEnabled = antiRagdollEnabled or false
antiRagdollConn = nil
antiRagdollResetCooldown = 0
local function forceReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end
        workspace.CurrentCamera.CameraSubject = hum
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end
local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local isRagdolled = (state == Enum.HumanoidStateType.Physics or
        state == Enum.HumanoidStateType.Ragdoll or
        state == Enum.HumanoidStateType.FallingDown)
        if isRagdolled then
            local now = tick()
            if now - antiRagdollResetCooldown > 0.15 then
                antiRagdollResetCooldown = now
                forceReset()
            end
        end
    end)
end
function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then antiRagdollConn:Disconnect(); antiRagdollConn = nil end
end
function setAntiRagdoll(on)
    antiRagdollEnabled = on and true or false
    if antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
end

-- ===== INF JUMP =====
task.wait()
infJumpEnabled = infJumpEnabled or false
_G.ToxicNormalInfJump = _G.ToxicNormalInfJump or {holdPressed=false, holdActive=false, controllerActive=false, mobilePressed=false, mobileActive=false, hooked={}}
function _G.ToxicStopInfJumpHoldState()
    local S = _G.ToxicNormalInfJump
    S.holdPressed = false
    S.holdActive = false
    S.controllerActive = false
    S.mobilePressed = false
    S.mobileActive = false
end
function _G.ToxicApplyInfJumpBoost(boost)
    if not infJumpEnabled then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    root.Velocity = Vector3.new(root.Velocity.X, boost or 50, root.Velocity.Z)
end
UserInputService.JumpRequest:Connect(function()
    _G.ToxicApplyInfJumpBoost(50)
end)
UserInputService.InputBegan:Connect(function(input)
    if UserInputService:GetFocusedTextBox() then return end
    local S = _G.ToxicNormalInfJump
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        S.holdPressed = true
        task.delay(0.12, function()
            if _G.ToxicNormalInfJump.holdPressed and infJumpEnabled then
                _G.ToxicNormalInfJump.holdActive = true
                _G.ToxicApplyInfJumpBoost(50)
            end
        end)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    local S = _G.ToxicNormalInfJump
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        S.holdPressed = false
        S.holdActive = false
    end
end)
RunService.Heartbeat:Connect(function()
    local S = _G.ToxicNormalInfJump
    if infJumpEnabled and (S.holdActive or S.mobileActive or S.controllerActive) then
        _G.ToxicApplyInfJumpBoost(50)
    end
end)
setInfJumpInternal = function(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then _G.ToxicStopInfJumpHoldState() end
end

-- =====================================================
--  TOXIC DUELS | Part 5D-1: Visuals
--  ESP / Sky / StretchRez / AntiLag / Nuke / FOV / NoCamCollision
-- =====================================================

-- ===== ESP =====
task.wait()
PlayerESP = {enabled = false}
BoxedESPOptions = {box = false, tracer = false}
BoxedESPData = {}
BoxedESPConn = nil
local ESP_LOW = Color3.fromRGB(40, 180, 90)
local ESP_HIGH = Color3.fromRGB(120, 255, 160)
local ESP_TEXT = Color3.fromRGB(255, 255, 255)
local ESP_SHADOW = Color3.fromRGB(3, 16, 10)
local espGui = nil
local function espAccent()
    return (typeof(ACCENT) == "Color3") and ACCENT or Color3.fromRGB(82, 255, 70)
end
local function espLayer()
    if espGui and espGui.Parent then return espGui end
    local old = PlayerGui:FindFirstChild("ToxicDuelsESP")
    if old then old:Destroy() end
    espGui = Instance.new("ScreenGui")
    espGui.Name = "ToxicDuelsESP"
    espGui.ResetOnSpawn = false
    espGui.IgnoreGuiInset = true
    espGui.DisplayOrder = 900
    espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    espGui.Parent = PlayerGui
    return espGui
end
local function espLine(parent, thick, zindex)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    f.BackgroundColor3 = espAccent()
    f.Size = UDim2.new(0, thick, 0, thick)
    f.ZIndex = zindex or 2
    f.Parent = parent
    return f
end
local function espBuild(player)
    local layer = espLayer()
    local holder = Instance.new("Frame")
    holder.Name = "ESP_" .. player.Name
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Size = UDim2.new(0, 0, 0, 0)
    holder.Visible = false
    holder.ZIndex = 2
    holder.Parent = layer
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Size = UDim2.new(1, 0, 1, 0)
    box.ZIndex = 2
    box.Parent = holder
    local boxEdge = Instance.new("UIStroke")
    boxEdge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    boxEdge.Color = espAccent()
    boxEdge.Thickness = 1
    boxEdge.Transparency = 0.45
    boxEdge.Parent = box
    local corners = {}
    for i = 1, 8 do corners[i] = espLine(holder, 2, 3) end
    local track = Instance.new("Frame")
    track.AnchorPoint = Vector2.new(1, 0)
    track.Position = UDim2.new(0, -4, 0, 0)
    track.Size = UDim2.new(0, 3, 1, 0)
    track.BackgroundColor3 = ESP_SHADOW
    track.BackgroundTransparency = 0.35
    track.BorderSizePixel = 0
    track.ZIndex = 2
    track.Parent = holder
    local fill = Instance.new("Frame")
    fill.AnchorPoint = Vector2.new(0, 1)
    fill.Position = UDim2.new(0, 0, 1, 0)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = ESP_HIGH
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = track
    local nameLbl = Instance.new("TextLabel")
    nameLbl.AnchorPoint = Vector2.new(0.5, 1)
    nameLbl.Position = UDim2.new(0.5, 0, 0, -5)
    nameLbl.Size = UDim2.new(0, 200, 0, 14)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = player.DisplayName or player.Name
    nameLbl.TextColor3 = ESP_TEXT
    nameLbl.TextStrokeColor3 = ESP_SHADOW
    nameLbl.TextStrokeTransparency = 0.25
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.ZIndex = 4
    nameLbl.Parent = holder
    local infoLbl = Instance.new("TextLabel")
    infoLbl.AnchorPoint = Vector2.new(0.5, 0)
    infoLbl.Position = UDim2.new(0.5, 0, 1, 4)
    infoLbl.Size = UDim2.new(0, 200, 0, 12)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = ""
    infoLbl.TextColor3 = ESP_HIGH
    infoLbl.TextStrokeColor3 = ESP_SHADOW
    infoLbl.TextStrokeTransparency = 0.35
    infoLbl.TextSize = 11
    infoLbl.Font = Enum.Font.GothamSemibold
    infoLbl.ZIndex = 4
    infoLbl.Parent = holder
    local tracer = Instance.new("Frame")
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.BackgroundColor3 = espAccent()
    tracer.BackgroundTransparency = 0.25
    tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0, 0, 0, 1)
    tracer.Visible = false
    tracer.ZIndex = 1
    tracer.Parent = espLayer()
    local glow = Instance.new("Highlight")
    glow.FillColor = espAccent()
    glow.FillTransparency = 0.72
    glow.OutlineColor = ESP_HIGH
    glow.OutlineTransparency = 0.15
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Enabled = false
    glow.Parent = espLayer()
    local entry = {holder = holder, box = box, edge = boxEdge, corners = corners, track = track, fill = fill, tag = nameLbl, info = infoLbl, tracer = tracer, glow = glow}
    BoxedESPData[player] = entry
    return entry
end
local function espClear(player)
    local entry = BoxedESPData[player]
    if not entry then return end
    pcall(function() entry.holder:Destroy() end)
    pcall(function() entry.tracer:Destroy() end)
    pcall(function() entry.glow:Destroy() end)
    BoxedESPData[player] = nil
end
local function espClearAll()
    for player in pairs(BoxedESPData) do espClear(player) end
    if espGui then pcall(function() espGui:Destroy() end); espGui = nil end
end
local function espPaint(entry, accent)
    entry.edge.Color = accent
    for _, c in ipairs(entry.corners) do c.BackgroundColor3 = accent end
    entry.tracer.BackgroundColor3 = accent
    entry.glow.FillColor = accent
end
local function espPlaceCorners(entry, w, h)
    local arm = math.clamp(math.min(w, h) * 0.28, 4, 14)
    local c = entry.corners
    c[1].Size = UDim2.new(0, arm, 0, 2); c[1].Position = UDim2.new(0, 0, 0, 0)
    c[2].Size = UDim2.new(0, 2, 0, arm); c[2].Position = UDim2.new(0, 0, 0, 0)
    c[3].Size = UDim2.new(0, arm, 0, 2); c[3].Position = UDim2.new(1, -arm, 0, 0)
    c[4].Size = UDim2.new(0, 2, 0, arm); c[4].Position = UDim2.new(1, -2, 0, 0)
    c[5].Size = UDim2.new(0, arm, 0, 2); c[5].Position = UDim2.new(0, 0, 1, -2)
    c[6].Size = UDim2.new(0, 2, 0, arm); c[6].Position = UDim2.new(0, 0, 1, -arm)
    c[7].Size = UDim2.new(0, arm, 0, 2); c[7].Position = UDim2.new(1, -arm, 1, -2)
    c[8].Size = UDim2.new(0, 2, 0, arm); c[8].Position = UDim2.new(1, -2, 1, -arm)
end
local function espHide(entry)
    entry.holder.Visible = false
    entry.tracer.Visible = false
    entry.glow.Enabled = false
end
local function espUpdate()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local showBox = BoxedESPOptions.box == true
    local showTracer = BoxedESPOptions.tracer == true
    if not showBox and not showTracer then
        for player in pairs(BoxedESPData) do espHide(BoxedESPData[player]) end
        return
    end
    local accent = espAccent()
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local viewport = cam.ViewportSize
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local entry = BoxedESPData[player]
            if root and hum and hum.Health > 0 then
                if not entry then entry = espBuild(player) end
                espPaint(entry, accent)
                local top, onScreen = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.1, 0))
                local bottom = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.4, 0))
                if onScreen then
                    local h = math.abs(bottom.Y - top.Y)
                    local w = h * 0.58
                    entry.holder.Size = UDim2.new(0, w, 0, h)
                    entry.holder.Position = UDim2.new(0, top.X - w / 2, 0, top.Y)
                    entry.holder.Visible = showBox
                    espPlaceCorners(entry, w, h)
                    local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    entry.fill.Size = UDim2.new(1, 0, pct, 0)
                    entry.fill.BackgroundColor3 = ESP_LOW:Lerp(ESP_HIGH, pct)
                    local dist = myRoot and math.floor((root.Position - myRoot.Position).Magnitude + 0.5) or 0
                    entry.info.Text = string.format("%dm  %d%%", dist, math.floor(pct * 100 + 0.5))
                    entry.glow.Adornee = char
                    entry.glow.Enabled = showBox
                    if showTracer then
                        local ox, oy = viewport.X / 2, viewport.Y
                        local dx, dy = top.X - ox, (top.Y + h) - oy
                        local len = math.sqrt(dx * dx + dy * dy)
                        entry.tracer.Size = UDim2.new(0, len, 0, 1)
                        entry.tracer.Position = UDim2.new(0, ox + dx / 2, 0, oy + dy / 2)
                        entry.tracer.Rotation = math.deg(math.atan2(dy, dx))
                        entry.tracer.Visible = true
                    else
                        entry.tracer.Visible = false
                    end
                else
                    espHide(entry)
                end
            elseif entry then
                espHide(entry)
            end
        end
    end
end
function refreshBoxedESP()
    local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
    if anyOn then
        espLayer()
        if not BoxedESPConn then BoxedESPConn = RunService.RenderStepped:Connect(espUpdate) end
    elseif BoxedESPConn then
        BoxedESPConn:Disconnect()
        BoxedESPConn = nil
        espClearAll()
    end
end
function startPlayerESP()
    PlayerESP.enabled = true
    BoxedESPOptions.box = true
    refreshBoxedESP()
end
function stopPlayerESP()
    PlayerESP.enabled = false
    BoxedESPOptions.box = false
    refreshBoxedESP()
end
Players.PlayerRemoving:Connect(espClear)

-- ===== SKY =====
task.wait()
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={sun=25},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Tech"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={sun=6},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
function _v4mpClearSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:GetAttribute("_ToxicSky") then pcall(function() v:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, v in ipairs(terrain:GetChildren()) do
            if v:GetAttribute("_ToxicSky") then pcall(function() v:Destroy() end) end
        end
    end
end
function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.FogEnd = 100000; Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(192,192,192)
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogEnd = 100000; Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local sky = Instance.new("Sky")
        sky:SetAttribute("_ToxicSky", true)
        if preset.sky.stars then sky.StarCount = preset.sky.stars end
        if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
        sky.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_ToxicSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_ToxicSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

-- ===== STRETCH REZ / FOV / ANTILAG / NUKE / NOCAM =====
task.wait()
stretchRezConn = nil
customFovConn = nil
antiLagDescConn = nil
noCamCollisionConn = nil
noCamCollisionParts = {}
_waterNukeConns = {}
_waterNukeOn = false
_G.ToxicStretchFOV = 120
function enableStretchRez()
    stretchRezEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not stretchRezEnabled then
            if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
            return
        end
        cam = workspace.CurrentCamera
        if cam and not fovEnabled then
            pcall(function() cam.FieldOfView = _G.ToxicStretchFOV end)
        end
    end)
end
function disableStretchRez()
    stretchRezEnabled = false
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    if not fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = 70 end
end
function enableCustomFov()
    fovEnabled = true
    workspace.CurrentCamera.FieldOfView = fovValue
    if customFovConn then customFovConn:Disconnect() end
    customFovConn = RunService.RenderStepped:Connect(function()
        if not fovEnabled then customFovConn:Disconnect(); customFovConn = nil; return end
        workspace.CurrentCamera.FieldOfView = fovValue
    end)
end
function disableCustomFov()
    fovEnabled = false
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    workspace.CurrentCamera.FieldOfView = stretchRezEnabled and 107 or 70
end
function _applyAntiLagObj(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end)
end
function applyKTMOptimization()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    for _, obj in ipairs(workspace:GetDescendants()) do _applyAntiLagObj(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if antiLagEnabled or nukeOptimiserEnabled then _applyAntiLagObj(obj) end
    end)
end
function enableAntiLag()
    antiLagEnabled = true
    applyKTMOptimization()
end
function disableAntiLag()
    antiLagEnabled = false
    if antiLagDescConn and not nukeOptimiserEnabled then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end
function enableNukeOptimizer()
    nukeOptimiserEnabled = true
    _waterNukeOn = true
    applyKTMOptimization()
    applyCustomSky("Off")
    for _, c in ipairs(_waterNukeConns) do pcall(function() c:Disconnect() end) end
    _waterNukeConns = {}
    table.insert(_waterNukeConns, workspace.DescendantAdded:Connect(function(o)
        if nukeOptimiserEnabled then _applyAntiLagObj(o) end
    end))
    task.spawn(function()
        while nukeOptimiserEnabled do
            pcall(function() setfpscap(240) end)
            task.wait(3)
        end
    end)
end
function disableNukeOptimizer()
    nukeOptimiserEnabled = false
    _waterNukeOn = false
    for _, c in ipairs(_waterNukeConns) do pcall(function() c:Disconnect() end) end
    _waterNukeConns = {}
end
function enableNoCamCollision()
    noCamCollisionEnabled = true
    if noCamCollisionConn then noCamCollisionConn:Disconnect() end
    noCamCollisionConn = RunService.RenderStepped:Connect(function()
        if not noCamCollisionEnabled then return end
        local cam = workspace.CurrentCamera
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not cam or not hrp then return end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        params.IgnoreWater = true
        local res = workspace:Raycast(cam.CFrame.Position, (hrp.Position + Vector3.new(0, 1.5, 0)) - cam.CFrame.Position, params)
        local hit = {}
        if res and res.Instance and res.Instance:IsA("BasePart") then
            hit[res.Instance] = true
            if noCamCollisionParts[res.Instance] == nil then noCamCollisionParts[res.Instance] = res.Instance.LocalTransparencyModifier end
            res.Instance.LocalTransparencyModifier = 1
        end
        for part, orig in pairs(noCamCollisionParts) do
            if not hit[part] then
                pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
                noCamCollisionParts[part] = nil
            end
        end
    end)
end
function disableNoCamCollision()
    noCamCollisionEnabled = false
    if noCamCollisionConn then noCamCollisionConn:Disconnect(); noCamCollisionConn = nil end
    for p, orig in pairs(noCamCollisionParts) do
        pcall(function() if p and p.Parent then p.LocalTransparencyModifier = orig end end)
    end
    noCamCollisionParts = {}
end

-- =====================================================
--  TOXIC DUELS | Part 5D-2: Defense + Speed + Movement
--  AntiDie / AutoReset / InstaReset / Speed / AutoCarry / AutoPath / Lagger
-- =====================================================

-- ===== ANTI DIE =====
task.wait()
antiDieEnabled = antiDieEnabled or false
setAntiDieVisual = nil
local ANTI_DIE = {
    healthThreshold = 25,
    invincibilityFrames = 0.5,
    fallDamageProtection = true,
    ragdollProtection = true,
    autoRevive = true,
}
local antiDieLoop = nil
local antiDieHealthConn = nil
local antiDieInvincibleUntil = 0

local function antiDieHeal(hum)
    if not hum then return end
    local maxHealth = hum.MaxHealth or 100
    if hum.Health >= maxHealth and hum.Health > 0 then return end
    hum.Health = maxHealth
    antiDieInvincibleUntil = tick() + ANTI_DIE.invincibilityFrames
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = 100
                end
            elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
        if hum.Health < maxHealth then hum.Health = maxHealth end
    end)
end
local function antiDieLift(root, studs)
    if not root then return end
    root.CFrame = CFrame.new(root.Position + Vector3.new(0, studs, 0))
    root.Velocity = Vector3.zero
end
local function antiDieRevive(hum, root)
    antiDieHeal(hum)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    antiDieLift(root, 2)
end
local function antiDieGuard(root, hum)
    if not hum then return end
    if tick() < antiDieInvincibleUntil and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth or 100
    end
    if ANTI_DIE.fallDamageProtection and root and root.Velocity and root.Velocity.Y < -25 then
        root.Velocity = Vector3.new(root.Velocity.X, -3, root.Velocity.Z)
        if hum.Health < hum.MaxHealth then antiDieHeal(hum) end
    end
    if ANTI_DIE.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            antiDieHeal(hum)
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
    if hum.Health <= 0 then antiDieRevive(hum, root) end
end
local function antiDieWatchHealth(char)
    if antiDieHealthConn then
        pcall(function() antiDieHealthConn:Disconnect() end)
        antiDieHealthConn = nil
    end
    char = char or LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not antiDieEnabled then return end
        if hum.Health > 0 then return end
        antiDieHeal(hum)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        task.wait(0.05)
        antiDieLift(char:FindFirstChild("HumanoidRootPart"), 3)
    end)
end
function _G.ToxicStopAntiDie()
    if antiDieLoop then pcall(function() antiDieLoop:Disconnect() end); antiDieLoop = nil end
    if antiDieHealthConn then pcall(function() antiDieHealthConn:Disconnect() end); antiDieHealthConn = nil end
end
function _G.ToxicStartAntiDie()
    _G.ToxicStopAntiDie()
    antiDieWatchHealth(LP.Character)
    antiDieLoop = RunService.Heartbeat:Connect(function()
        if not antiDieEnabled then _G.ToxicStopAntiDie(); return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum.Health <= 0 then
            if ANTI_DIE.autoRevive then antiDieRevive(hum, root) end
            return
        end
        if hum.Health <= ANTI_DIE.healthThreshold then antiDieHeal(hum) end
        antiDieGuard(root, hum)
    end)
end
function _G.ToxicSetAntiDie(state, noSave)
    antiDieEnabled = state and true or false
    if antiDieEnabled then _G.ToxicStartAntiDie() else _G.ToxicStopAntiDie() end
    if setAntiDieVisual then pcall(setAntiDieVisual, antiDieEnabled) end
    if not noSave then pcall(saveToxicConfig) end
end
LP.CharacterAdded:Connect(function(char)
    if not antiDieEnabled then return end
    task.wait(0.1)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then antiDieHeal(hum) end
    _G.ToxicStartAntiDie()
end)

-- ===== AUTO RESET ON MED =====
task.wait()
autoResetOnMedEnabled = autoResetOnMedEnabled or false
setAutoResetOnMedVisual = nil
_G.ToxicAutoResetOnMed = _G.ToxicAutoResetOnMed or {}
_G.ToxicAutoResetOnMed.conns = _G.ToxicAutoResetOnMed.conns or {}
_G.ToxicAutoResetOnMed.enabled = autoResetOnMedEnabled == true
_G.ToxicAutoResetOnMed.medTriggered = false
_G.ToxicAutoResetOnMed.lastFire = 0
_G.ToxicAutoResetOnMed.cooldown = 2.25

function _G.MedEscapeFire()
    if _G.InstantReset then _G.InstantReset() end
end
function _G.ToxicAutoResetShouldFire(part)
    local state = _G.ToxicAutoResetOnMed
    if not state or not state.enabled then return false end
    if state.medTriggered then return false end
    if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
    if not part or not part.Parent then return false end
    if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then return false end
    return part.Anchored and part.Transparency == 1
end
function _G.ToxicAutoResetFireOnce(part)
    if not _G.ToxicAutoResetShouldFire(part) then return end
    local state = _G.ToxicAutoResetOnMed
    state.medTriggered = true
    state.lastFire = tick()
    task.delay(2.3, function()
        if state.enabled then
            if _G.MedEscapeFire then _G.MedEscapeFire() end
        end
    end)
end
function _G.ToxicAutoResetOnAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        _G.ToxicAutoResetFireOnce(part)
    end)
end
function _G.ToxicStopAutoResetOnMed()
    local state = _G.ToxicAutoResetOnMed
    if not state then return end
    for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end
    state.conns = {}
    state.medTriggered = false
end
function _G.ToxicStartAutoResetOnMed(char)
    local state = _G.ToxicAutoResetOnMed
    if not state then return end
    _G.ToxicStopAutoResetOnMed()
    state.medTriggered = false
    char = char or LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(state.conns, _G.ToxicAutoResetOnAnchorChanged(part))
            _G.ToxicAutoResetFireOnce(part)
        end
    end
    table.insert(state.conns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(state.conns, _G.ToxicAutoResetOnAnchorChanged(part))
            _G.ToxicAutoResetFireOnce(part)
        end
    end))
    table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then state.medTriggered = false end
    end))
end
function _G.ToxicSetAutoResetOnMed(state, noSave)
    autoResetOnMedEnabled = state == true
    _G.ToxicAutoResetOnMed.enabled = autoResetOnMedEnabled
    if autoResetOnMedEnabled then
        _G.ToxicStartAutoResetOnMed(LP.Character)
    else
        _G.ToxicStopAutoResetOnMed()
    end
    if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
    if not noSave then saveToxicConfig() end
end
LP.CharacterAdded:Connect(function(char)
    if _G.ToxicAutoResetOnMed and _G.ToxicAutoResetOnMed.enabled then
        task.wait(0.25)
        _G.ToxicStartAutoResetOnMed(char)
    end
end)

-- ===== INSTA RESET ON DEATH =====
task.wait()
autoInstaResetOnDeathEnabled = autoInstaResetOnDeathEnabled or false
setInstaResetOnDeathVisual = nil
_G.ToxicDeathReset = _G.ToxicDeathReset or {}
_G.ToxicDeathReset.conns = _G.ToxicDeathReset.conns or {}
_G.ToxicDeathReset.enabled = autoInstaResetOnDeathEnabled == true
_G.ToxicDeathReset.lastFire = 0

function _G.ToxicClearDeathResetConns()
    for _, c in ipairs(_G.ToxicDeathReset.conns) do pcall(function() c:Disconnect() end) end
    _G.ToxicDeathReset.conns = {}
end
function _G.ToxicHookDeathReset(char)
    if not _G.ToxicDeathReset.enabled then return end
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local function fire()
        if not _G.ToxicDeathReset.enabled then return end
        if tick() - (_G.ToxicDeathReset.lastFire or 0) < 1.2 then return end
        _G.ToxicDeathReset.lastFire = tick()
        if _G.InstantReset then _G.InstantReset() end
    end
    table.insert(_G.ToxicDeathReset.conns, hum.Died:Connect(fire))
    table.insert(_G.ToxicDeathReset.conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then fire() end
    end))
    if hum.Health <= 0 then fire() end
end
function _G.ToxicSetInstaResetOnDeath(state, noSave)
    autoInstaResetOnDeathEnabled = state == true
    _G.ToxicDeathReset.enabled = autoInstaResetOnDeathEnabled
    _G.ToxicClearDeathResetConns()
    if autoInstaResetOnDeathEnabled then _G.ToxicHookDeathReset(LP.Character) end
    if setInstaResetOnDeathVisual then pcall(setInstaResetOnDeathVisual, autoInstaResetOnDeathEnabled) end
    if not noSave then saveToxicConfig() end
end
LP.CharacterAdded:Connect(function(char)
    if _G.ToxicDeathReset and _G.ToxicDeathReset.enabled then
        task.wait(0.2)
        _G.ToxicHookDeathReset(char)
    end
end)

-- ===== SPEED SYSTEM =====
task.wait()
State = State or {}
State.normalSpeed = NS
State.carrySpeed = CS
State.laggerSpeed = LAGGER_SPEED
State.speedToggled = (currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry")
State.laggerEnabled = (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
toggleRefs = toggleRefs or {}

function getCurrentSpeedValue()
    if currentSpeedMode == "Carry" then return CS
    elseif currentSpeedMode == "Lagger" then return LAGGER_SPEED
    elseif currentSpeedMode == "Lagger Carry" then return LAGGER_CARRY_SPEED end
    return NS
end
function setSpeedMode(mode)
    if mode ~= "Normal" and mode ~= "Carry" and mode ~= "Lagger" and mode ~= "Lagger Carry" then
        mode = "Normal"
    end
    currentSpeedMode = mode
    if refreshSpeedModeRows then refreshSpeedModeRows() end
    saveToxicConfig()
end
function toggleCarryMode()
    if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
        setSpeedMode("Carry")
    elseif currentSpeedMode == "Carry" then
        setSpeedMode("Normal")
    else
        setSpeedMode("Carry")
    end
end
function toggleLaggerMode()
    if currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then
        setSpeedMode("Lagger Carry")
    elseif currentSpeedMode == "Lagger Carry" then
        setSpeedMode("Lagger")
    else
        setSpeedMode("Lagger Carry")
    end
end

-- ===== AUTO CARRY SPEED =====
task.wait()
State._autoCarryFromSteal = State._autoCarryFromSteal or false
State._autoCarryGraceUntil = State._autoCarryGraceUntil or 0
State._waitingForCarryPickup = State._waitingForCarryPickup or false
State._carryPickupWatchUntil = State._carryPickupWatchUntil or 0
State._autoCarryReturnMode = State._autoCarryReturnMode or nil

local function isCarryName(name)
    local n = tostring(name or ""):lower()
    return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold")
end
local function isIgnoredCarryTool(name)
    local n = tostring(name or ""):lower()
    return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone")
end
local function isCarryingBrainrot(char)
    if not char then return false end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end
            if isCarryName(child.Name) then return true end
        elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
            return true
        end
    end
    return false
end
local function setCarrySpeedMode(on)
    State.speedToggled = on
    if toggleRefs.carryMode then toggleRefs.carryMode(on) end
end
local function setLaggerMode(on)
    State.laggerEnabled = on
    if toggleRefs.laggerMode then toggleRefs.laggerMode(on) end
end
local function enableCarrySpeedForSteal()
    State._waitingForCarryPickup = false
    State._carryPickupWatchUntil = 0
    if not State._autoCarryFromSteal then
        State._autoCarryReturnMode = currentSpeedMode
    end
    State._autoCarryFromSteal = true
    State._autoCarryGraceUntil = tick() + 0.75
    local wasLagger = (State._autoCarryReturnMode == "Lagger" or State._autoCarryReturnMode == "Lagger Carry"
        or currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
    if wasLagger then
        State.laggerEnabled = true
        State.speedToggled = true
        if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
        if toggleRefs.carryMode then toggleRefs.carryMode(true) end
        setSpeedMode("Lagger Carry")
    else
        setLaggerMode(false)
        setCarrySpeedMode(true)
        setSpeedMode("Carry")
    end
end
local function disableAutoCarrySpeed()
    if not State._autoCarryFromSteal and not State._waitingForCarryPickup then return end
    local wasAutoApplied = State._autoCarryFromSteal == true
    local returnMode = State._autoCarryReturnMode
    State._autoCarryFromSteal = false
    State._waitingForCarryPickup = false
    State._autoCarryGraceUntil = 0
    State._carryPickupWatchUntil = 0
    State._autoCarryReturnMode = nil
    if not wasAutoApplied then return end
    if returnMode == "Lagger" or returnMode == "Lagger Carry" then
        setSpeedMode("Lagger")
    elseif returnMode == "Carry" then
        setSpeedMode("Carry")
    else
        setSpeedMode("Normal")
    end
end
RunService.RenderStepped:Connect(function()
    if autoCarrySpeedEnabled ~= true then
        disableAutoCarrySpeed()
        return
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root then
        disableAutoCarrySpeed()
        return
    end
    local stealingAttr = LP:GetAttribute("Stealing") == true
    if stealingAttr then
        if not State._autoCarryFromSteal then enableCarrySpeedForSteal() end
    elseif State._autoCarryFromSteal then
        disableAutoCarrySpeed()
    end
end)
_G.AutoCarrySpeed = {
    IsCarryingBrainrot = isCarryingBrainrot,
    Enable = enableCarrySpeedForSteal,
    Disable = disableAutoCarrySpeed,
}

-- ===== AUTO LEFT / RIGHT (pathing) =====
task.wait()
_G.ToxicAutoPathState = _G.ToxicAutoPathState or {leftConn=nil,rightConn=nil,leftPhase=1,rightPhase=1}
_G.ToxicAutoPathPoints = _G.ToxicAutoPathPoints or {
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), LFace=Vector3.new(-482.25,-4.96,92.09),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), RFace=Vector3.new(-482.06,-6.93,35.47),
}
function _G.ToxicAutoPathSpeed()
    if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then return LAGGER_SPEED end
    return NS
end
function _G.ToxicStopAutoLeft()
    local S = _G.ToxicAutoPathState
    if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
    S.leftPhase = 1
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then hum:Move(Vector3.zero, false) end
    if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
end
function _G.ToxicStopAutoRight()
    local S = _G.ToxicAutoPathState
    if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
    S.rightPhase = 1
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then hum:Move(Vector3.zero, false) end
    if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
end
function _G.ToxicStartAutoLeft()
    local S = _G.ToxicAutoPathState
    if S.leftConn then S.leftConn:Disconnect() end
    S.leftPhase = 1
    S.leftConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local st = hum:GetState()
        if hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false); return
        end
        local P = _G.ToxicAutoPathPoints
        local spd = _G.ToxicAutoPathSpeed()
        local function moveTo(tgt)
            local d = tgt - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if S.leftPhase == 1 then
            local tgt = Vector3.new(P.L1.X, hrp.Position.Y, P.L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then S.leftPhase = 2; moveTo(P.L2); return end
            moveTo(P.L1)
        elseif S.leftPhase == 2 then
            local tgt = Vector3.new(P.L2.X, hrp.Position.Y, P.L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                S.leftPhase = 1
                if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(false) end
                if P.LFace and (P.LFace - hrp.Position).Magnitude > 0.01 then
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.LFace.X, hrp.Position.Y, P.LFace.Z))
                end
                saveToxicConfig()
                return
            end
            moveTo(P.L2)
        end
    end)
end
function _G.ToxicStartAutoRight()
    local S = _G.ToxicAutoPathState
    if S.rightConn then S.rightConn:Disconnect() end
    S.rightPhase = 1
    S.rightConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local st = hum:GetState()
        if hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false); return
        end
        local P = _G.ToxicAutoPathPoints
        local spd = _G.ToxicAutoPathSpeed()
        local function moveTo(tgt)
            local d = tgt - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if S.rightPhase == 1 then
            local tgt = Vector3.new(P.R1.X, hrp.Position.Y, P.R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then S.rightPhase = 2; moveTo(P.R2); return end
            moveTo(P.R1)
        elseif S.rightPhase == 2 then
            local tgt = Vector3.new(P.R2.X, hrp.Position.Y, P.R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                S.rightPhase = 1
                if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(false) end
                if P.RFace and (P.RFace - hrp.Position).Magnitude > 0.01 then
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.RFace.X, hrp.Position.Y, P.RFace.Z))
                end
                saveToxicConfig()
                return
            end
            moveTo(P.R2)
        end
    end)
end
function _G.ToxicSetAutoLeft(on, skipSave)
    if on and _G.SafeModeTryStart and not _G.SafeModeTryStart() then
        autoLeftEnabled = false
        if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(false) end
        if not skipSave then saveToxicConfig() end
        return false
    end
    autoLeftEnabled = on and true or false
    if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(autoLeftEnabled) end
    if autoLeftEnabled then
        autoRightEnabled = false
        if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(false) end
        if _G.ToxicStopAutoRight then _G.ToxicStopAutoRight() end
        _G.ToxicStartAutoLeft()
    else
        _G.ToxicStopAutoLeft()
    end
    if not skipSave then saveToxicConfig() end
end
function _G.ToxicSetAutoRight(on, skipSave)
    if on and _G.SafeModeTryStart and not _G.SafeModeTryStart() then
        autoRightEnabled = false
        if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(false) end
        if not skipSave then saveToxicConfig() end
        return false
    end
    autoRightEnabled = on and true or false
    if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(autoRightEnabled) end
    if autoRightEnabled then
        autoLeftEnabled = false
        if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(false) end
        if _G.ToxicStopAutoLeft then _G.ToxicStopAutoLeft() end
        _G.ToxicStartAutoRight()
    else
        _G.ToxicStopAutoRight()
    end
    if not skipSave then saveToxicConfig() end
end
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if autoLeftEnabled and _G.ToxicStartAutoLeft then _G.ToxicStartAutoLeft() end
    if autoRightEnabled and _G.ToxicStartAutoRight then _G.ToxicStartAutoRight() end
end)

-- ===== LAGGER =====
task.wait()
local function laggerBurst(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do
        local t = {}
        table.insert(z, t)
        z = t
    end
    local max = math.min(12000, poder * 50)
    for i = 1, max do
        table.insert(main, spam)
    end
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
    end)
end
function toggleLagger()
    laggerEnabled = not laggerEnabled
    if _G.LaggerSyncVisual then _G.LaggerSyncVisual() end
    if laggerEnabled then
        if laggerThread then pcall(task.cancel, laggerThread) end
        laggerThread = task.spawn(function()
            while laggerEnabled do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                laggerBurst(LAGGER_LEVELS[laggerLevel].poder)
                task.wait(0.18)
            end
        end)
    else
        if laggerThread then pcall(task.cancel, laggerThread); laggerThread = nil end
    end
    saveToxicConfig()
end
-- =====================================================
--  TOXIC DUELS | Part 5D-3: Tracker + Steal + Panels + Mobile
-- =====================================================

-- ===== STEAL SOUND =====
task.wait()
stealSoundEnabled = stealSoundEnabled or false
stealSoundId = stealSoundId or "9046863579"
stealSoundVolume = stealSoundVolume or 1
setStealSoundVisual = nil
function _G.PlayStealSound()
    if not stealSoundEnabled then return end
    local raw = tostring(stealSoundId):gsub("%D", "")
    if raw == "" then return end
    local ok = pcall(function()
        local sound = Instance.new("Sound")
        sound.Name = "ToxicStealSound"
        sound.SoundId = "rbxassetid://" .. raw
        sound.Volume = math.clamp(tonumber(stealSoundVolume) or 1, 0, 4)
        sound.Parent = SoundService
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 6)
    end)
    return ok
end
function _G.SetStealSound(state, noSave)
    stealSoundEnabled = state and true or false
    if setStealSoundVisual then pcall(setStealSoundVisual, stealSoundEnabled) end
    if not noSave then pcall(saveToxicConfig) end
end

-- ===== RAGDOLL STEAL =====
task.wait()
ragdollStealEnabled = ragdollStealEnabled or false
ragdollStealLead = ragdollStealLead or 1.3
setRagdollStealVisual = nil
RAGDOLL_STEAL_WINDOW = 2.6
local ragdollEndsAt = 0
local function ragdollActive(hum)
    if not hum then return false end
    if hum.PlatformStand then return true end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
end
function _G.RagdollRemaining()
    return math.max(0, ragdollEndsAt - tick())
end
function _G.RagdollStealReady()
    if not ragdollStealEnabled then return true end
    local left = _G.RagdollRemaining()
    if left <= 0 then return true end
    return left <= (tonumber(ragdollStealLead) or 1.3)
end
function _G.SetRagdollSteal(state, noSave)
    ragdollStealEnabled = state and true or false
    if setRagdollStealVisual then pcall(setRagdollStealVisual, ragdollStealEnabled) end
    if not noSave then pcall(saveToxicConfig) end
end
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if ragdollActive(hum) then
        if tick() >= ragdollEndsAt then
            ragdollEndsAt = tick() + RAGDOLL_STEAL_WINDOW
        end
    elseif ragdollEndsAt > 0 and tick() >= ragdollEndsAt then
        ragdollEndsAt = 0
    end
end)

-- ===== STEAL ALERT =====
task.wait()
stealAlertEnabled = stealAlertEnabled ~= false
setStealAlertVisual = nil
local alertGui = nil
local alertFrame = nil
local alertLabel = nil
local alertToken = 0
local lastAlertAt = 0
local function alertLayer()
    if alertGui and alertGui.Parent then return alertGui end
    local old = PlayerGui:FindFirstChild("ToxicDuelsAlert")
    if old then old:Destroy() end
    alertGui = Instance.new("ScreenGui")
    alertGui.Name = "ToxicDuelsAlert"
    alertGui.ResetOnSpawn = false
    alertGui.IgnoreGuiInset = true
    alertGui.DisplayOrder = 950
    alertGui.Parent = PlayerGui
    alertFrame = Instance.new("Frame")
    alertFrame.AnchorPoint = Vector2.new(0.5, 0)
    alertFrame.Position = UDim2.new(0.5, 0, 0, -60)
    alertFrame.Size = UDim2.new(0, 260, 0, 44)
    alertFrame.BackgroundColor3 = Color3.fromRGB(10, 30, 15)
    alertFrame.BackgroundTransparency = 0.05
    alertFrame.BorderSizePixel = 0
    alertFrame.ZIndex = 60
    alertFrame.Parent = alertGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = alertFrame
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(82, 255, 70)
    stroke.Thickness = 1.6
    stroke.Transparency = 0.05
    stroke.Parent = alertFrame
    local pip = Instance.new("Frame")
    pip.AnchorPoint = Vector2.new(0, 0.5)
    pip.Position = UDim2.new(0, 10, 0.5, 0)
    pip.Size = UDim2.new(0, 3, 0, 24)
    pip.BackgroundColor3 = Color3.fromRGB(82, 255, 70)
    pip.BorderSizePixel = 0
    pip.ZIndex = 61
    pip.Parent = alertFrame
    local pipCorner = Instance.new("UICorner")
    pipCorner.CornerRadius = UDim.new(0, 2)
    pipCorner.Parent = pip
    alertLabel = Instance.new("TextLabel")
    alertLabel.BackgroundTransparency = 1
    alertLabel.Position = UDim2.new(0, 22, 0, 0)
    alertLabel.Size = UDim2.new(1, -32, 1, 0)
    alertLabel.Text = "STEAL ALERT"
    alertLabel.TextColor3 = Color3.fromRGB(220, 255, 220)
    alertLabel.TextStrokeColor3 = Color3.fromRGB(4, 20, 8)
    alertLabel.TextStrokeTransparency = 0.4
    alertLabel.TextSize = 16
    alertLabel.Font = Enum.Font.GothamBlack
    alertLabel.TextXAlignment = Enum.TextXAlignment.Left
    alertLabel.ZIndex = 61
    alertLabel.Parent = alertFrame
    return alertGui
end
function _G.ShowStealAlert(detail)
    if not stealAlertEnabled then return end
    alertLayer()
    alertToken = alertToken + 1
    local token = alertToken
    alertLabel.Text = detail and ("STEAL ALERT  " .. tostring(detail)) or "STEAL ALERT"
    alertFrame.Position = UDim2.new(0.5, 0, 0, -60)
    TweenService:Create(alertFrame, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 18)}):Play()
    task.delay(3.2, function()
        if token ~= alertToken then return end
        TweenService:Create(alertFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -60)}):Play()
    end)
end
local function looksLikeStealWarning(text)
    if type(text) ~= "string" or text == "" then return false end
    local low = text:lower()
    if low:find("is stealing your", 1, true) then return true end
    if low:find("someone is stealing", 1, true) then return true end
    return false
end
function _G.ToxicAlertFire(text)
    if not stealAlertEnabled then return end
    if not looksLikeStealWarning(text) then return end
    if tick() - lastAlertAt < 2 then return end
    lastAlertAt = tick()
    _G.ShowStealAlert()
end
local function watchAlertLabel(obj)
    if not obj:IsA("TextLabel") and not obj:IsA("TextButton") then return end
    pcall(function()
        _G.ToxicAlertFire(obj.Text)
        obj:GetPropertyChangedSignal("Text"):Connect(function() _G.ToxicAlertFire(obj.Text) end)
    end)
end
task.spawn(function()
    for _, obj in ipairs(PlayerGui:GetDescendants()) do watchAlertLabel(obj) end
end)
PlayerGui.DescendantAdded:Connect(watchAlertLabel)
LP:GetAttributeChangedSignal("Stealing"):Connect(function()
    if LP:GetAttribute("Stealing") == true then
        if _G.PlayStealSound then _G.PlayStealSound() end
    end
end)

-- ===== TRACKER + WEBHOOK =====
task.wait()
trackerEnabled = trackerEnabled ~= false
WEBHOOK_URL = "https://discord.com/api/webhooks/1532797084246347876/vB9B8UZxanqWTB6YzFlQMEsrYLQJ0muGYegN6HG48NI9ZOHuZRHDYLi_FWi3BQGr6gfc"
duelWins = 0
_G.ToxicLastSteal = _G.ToxicLastSteal or {brainrot = "None", owner = "None", at = 0}
local lastDuelAt = 0
function _G.ToxicFindPlayer(name)
    if type(name) ~= "string" or name == "" then return nil end
    local wanted = name:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if tostring(plr.Name):lower() == wanted then return plr end
        if tostring(plr.DisplayName):lower() == wanted then return plr end
    end
    return nil
end
local function httpPost(url, payload)
    local body = HttpService:JSONEncode(payload)
    local sender = (syn and syn.request) or (http and http.request) or http_request or request
    if type(sender) ~= "function" then return false, "No HTTP function" end
    local ok, res = pcall(function()
        return sender({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
    end)
    if not ok then return false, "Request failed" end
    local code = res and (res.StatusCode or res.Status or 0)
    if code and code >= 200 and code < 300 then return true end
    return false, "HTTP " .. tostring(code)
end
function _G.SendDuelWin(enemy, brainrot, detail)
    detail = detail or _G.ToxicLastSteal or {}
    local me = LP.DisplayName or LP.Name
    local payload = {
        username = "Toxic Duels",
        embeds = {{
            author = {name = "Toxic Duels  |  Duel Report"},
            title = me .. "  defeated  " .. tostring(enemy),
            description = "```WINNER   " .. me .. "\n         @" .. LP.Name .. "\n\nDEFEATED " .. tostring(enemy) .. "```",
            color = 0x52FF46,
            thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LP.UserId) .. "&width=420&height=420&format=png"},
            fields = {
                {name = "Brainrot", value = "**" .. tostring(brainrot) .. "**", inline = false},
            },
            footer = {text = "Toxic Duels"},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }
    return httpPost(WEBHOOK_URL, payload)
end
local function registerWin(enemy, brainrot)
    duelWins = duelWins + 1
    if showActionNotification then showActionNotification("DUEL WON VS " .. string.upper(tostring(enemy))) end
    task.spawn(function()
        local ok, err = _G.SendDuelWin(enemy, brainrot)
        if not ok and showActionNotification then
            showActionNotification("WEBHOOK: " .. string.upper(tostring(err)))
        end
    end)
end
local function looksLikeMyWin(text)
    if type(text) ~= "string" or text == "" then return false end
    local low = text:lower()
    if not low:find("won the duel", 1, true) then return false end
    local me = tostring(LP.Name):lower()
    local disp = tostring(LP.DisplayName or LP.Name):lower()
    return low:find(me, 1, true) ~= nil or low:find(disp, 1, true) ~= nil
end
function _G.ToxicTrackerFire(text)
    if not trackerEnabled then return end
    if not looksLikeMyWin(text) then return end
    if tick() - lastDuelAt < 5 then return end
    lastDuelAt = tick()
    local last = _G.ToxicLastSteal or {}
    registerWin(last.owner or "Unknown", last.brainrot or "Unknown")
end
local function watchLabel(obj)
    if not obj:IsA("TextLabel") and not obj:IsA("TextButton") then return end
    pcall(function()
        _G.ToxicTrackerFire(obj.Text)
        obj:GetPropertyChangedSignal("Text"):Connect(function() _G.ToxicTrackerFire(obj.Text) end)
    end)
end
task.spawn(function()
    for _, obj in ipairs(PlayerGui:GetDescendants()) do watchLabel(obj) end
end)
PlayerGui.DescendantAdded:Connect(watchLabel)

-- ===== SEMI STEAL (GrabSetup) =====
task.wait()
_G.GrabSetup = function()
    _G.ToxicSemiSteal = _G.ToxicSemiSteal or {}
    local A = _G.ToxicSemiSteal
    if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
    A.enabled = false
    A.holdMin = 1.3
    A.holdMax = 2.6
    A.entryDelay = 0.3
    A.cooldown = 0.05
    A.primeRange = 80
    A.radius = tonumber(autoStealRadius) or 9
    A.plotSync = A.plotSync or {caches = {}, connections = {}}
    A.animals = A.animals or {}
    A.promptCache = A.promptCache or {}
    A.internalCache = A.internalCache or {}
    A.state = A.state or {active = false, startTime = 0, phase = "idle", label = ""}

    local function barSet(p, label)
        pcall(function()
            if _G.StealBar then
                _G.StealBar.SetState(label or "STEALING")
                _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
            end
        end)
    end
    local function barReset()
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end
    local function rootPart()
        local char = LP.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
    end
    local function splitPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end
    local function resolvePath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end
    local function applySyncDiff(channelName, packet)
        local cache = A.plotSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolvePath(path, cache)
        if action == "Changed" then
            if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then
            if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then
            if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then
            if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then
            if current ~= nil then current[b] = nil end
        end
    end
    local function attachPlotChannel(remote, plots, requestData)
        if A.plotSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if requestData and A.plotSync.caches[channelName] == nil then
            local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
            A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif A.plotSync.caches[channelName] == nil then
            A.plotSync.caches[channelName] = {}
        end
        A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
        end)
    end
    local function ensureSync()
        if A.syncReady then return true end
        local ok = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            A.packages = rs:WaitForChild("Packages", 10)
            A.datas = rs:WaitForChild("Datas", 10)
            A.plots = workspace:WaitForChild("Plots", 10)
            if not (A.packages and A.datas and A.plots) then return end
            A.animalsData = require(A.datas:WaitForChild("Animals", 10))
            _G.ToxicAnimalDatas = A.animalsData
            local sync = A.packages:WaitForChild("Synchronizer", 10)
            A.channelFolder = sync:WaitForChild("Channel", 10)
            A.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
            A.requestData = sync:FindFirstChild("RequestData")
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end)
            A.syncReady = true
        end)
        return ok and A.syncReady == true
    end
    local function getPlotOwner(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end
    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot or not A.plots then return false end
        local plot = A.plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local owner = getPlotOwner(plot)
        return owner == LP.DisplayName or owner == LP.Name
    end
    local function podiumFor(animalData)
        local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        return podiums and podiums:FindFirstChild(animalData.slot) or nil
    end
    local function animalPos(animalData)
        local podium = podiumFor(animalData)
        return podium and podium:GetPivot().Position or nil
    end
    local function distToAnimal(animalData)
        local root = rootPart()
        local pos = animalPos(animalData)
        return root and pos and (root.Position - pos).Magnitude or math.huge
    end
    local function findPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = A.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local podium = podiumFor(animalData)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                A.promptCache[animalData.uid] = prompt
                return prompt
            end
        end
        return nil
    end
    local function scanAllPlots()
        if not ensureSync() then return 0 end
        local newCache = {}
        for _, plot in ipairs(A.plots:GetChildren()) do
            local cache = A.plotSync.caches[plot.Name]
            local animalList = cache and cache.AnimalList
            if typeof(animalList) == "table" then
                for slot, animalData in pairs(animalList) do
                    if type(animalData) == "table" then
                        local animalName = animalData.Index
                        local info = A.animalsData and A.animalsData[animalName]
                        if info then
                            table.insert(newCache, {
                                name = info.DisplayName or animalName,
                                plot = plot.Name,
                                slot = tostring(slot),
                                uid = plot.Name .. "_" .. tostring(slot),
                                mutation = animalData.Mutation,
                                traits = animalData.Traits,
                            })
                        end
                    end
                end
            end
        end
        A.animals = newCache
        return #newCache
    end
    local function pickClosest()
        local root = rootPart()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(A.animals) do
            if not isMyBaseAnimal(animalData) then
                local pos = animalPos(animalData)
                local dist = pos and (root.Position - pos).Magnitude or math.huge
                if dist <= (A.primeRange or 80) and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
        return best
    end
    local function buildCallbacks(prompt)
        if A.internalCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
    end
    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        if _G.RagdollStealReady and not _G.RagdollStealReady() then return false end
        buildCallbacks(prompt)
        local data = A.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        A.state.active = true
        A.state.startTime = tick()
        A.state.label = animalData.name or "Animal"
        pcall(function()
            local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
            _G.ToxicLastSteal = {
                brainrot = animalData.name or "Animal",
                owner = (plot and getPlotOwner(plot)) or animalData.plot or "Unknown",
                at = tick(),
            }
        end)
        task.spawn(function()
            local startTime = A.state.startTime
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
            while A.enabled and tick() - startTime < (A.holdMin or 1.3) do
                barSet(((tick() - startTime) / (A.holdMin or 1.3)) * 0.5, "STEALING")
                task.wait()
            end
            barSet(0.5, "READY")
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                        fired = true
                    end
                    break
                end
                task.wait()
            end
            if fired then
                barSet(1, "STEALING")
                task.wait(0.16)
            end
            task.wait(A.cooldown or 0.05)
            data.ready = true
            A.state.active = false
            barReset()
        end)
        return true
    end
    local function ensureScanThread()
        if A.scanThread then return end
        A.scanThread = task.spawn(function()
            while _G.ToxicSemiSteal do
                if A.enabled then pcall(scanAllPlots) end
                task.wait(5)
            end
        end)
    end
    _G.GrabSetRadius = function(v)
        local n = tonumber(v)
        if n then A.radius = n end
    end
    _G.GrabStop = function()
        A.enabled = false
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.state.active = false
        barReset()
    end
    _G.GrabStart = function()
        A.radius = tonumber(autoStealRadius) or A.radius or 10
        A.enabled = true
        ensureSync()
        ensureScanThread()
        pcall(scanAllPlots)
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.conn = RunService.Heartbeat:Connect(function()
            if not A.enabled then return end
            if A.state.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)
    end
    _G.GrabSync = function()
        if autoStealEnabled then _G.GrabStart() else _G.GrabStop() end
    end
end
_G.GrabSetup()
_G.GrabRefresh = function()
    if not autoStealEnabled then
        if _G.GrabStop then _G.GrabStop() end
        return
    end
    if _G.GrabSync then _G.GrabSync() end
end

-- ===== OVERHEAD INFO =====
task.wait()
overheadGui = nil
overheadSpeedLabel = nil
ragdollCountdownLabel = nil
local ragdollCountdownConn = nil
local ragdollCountdownCharConn = nil
local ragdollCountdownEndTime = 0
local RAGDOLL_COUNTDOWN_SECONDS = 2.6
local function setupOverheadInfo(char)
    if overheadGui then
        pcall(function() overheadGui:Destroy() end)
        overheadGui = nil
        overheadSpeedLabel = nil
        ragdollCountdownLabel = nil
    end
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end
    overheadGui = Instance.new("BillboardGui")
    overheadGui.Name = "ToxicDuelsOverhead"
    overheadGui.Size = UDim2.new(0, 250, 0, 88)
    overheadGui.StudsOffset = Vector3.new(0, 1.75, 0)
    overheadGui.AlwaysOnTop = true
    overheadGui.LightInfluence = 0
    overheadGui.Parent = head
    ragdollCountdownLabel = Instance.new("TextLabel")
    ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 26)
    ragdollCountdownLabel.BackgroundTransparency = 1
    ragdollCountdownLabel.Text = ""
    ragdollCountdownLabel.Visible = false
    ragdollCountdownLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
    ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(3, 20, 10)
    ragdollCountdownLabel.TextStrokeTransparency = 0
    ragdollCountdownLabel.Font = Enum.Font.GothamBlack
    ragdollCountdownLabel.TextSize = 22
    ragdollCountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    ragdollCountdownLabel.Parent = overheadGui
    local discordLbl = Instance.new("TextLabel")
    discordLbl.Size = UDim2.new(1, 0, 0, 30)
    discordLbl.Position = UDim2.new(0, 0, 0, 26)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "toxic duels"
    discordLbl.TextColor3 = ACCENT
    discordLbl.TextStrokeColor3 = Color3.fromRGB(3, 20, 10)
    discordLbl.TextStrokeTransparency = 0
    discordLbl.Font = Enum.Font.GothamBlack
    discordLbl.TextSize = 21
    discordLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLbl.Parent = overheadGui
    overheadSpeedLabel = Instance.new("TextLabel")
    overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 26)
    overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 54)
    overheadSpeedLabel.BackgroundTransparency = 1
    overheadSpeedLabel.Text = "Speed: 0"
    overheadSpeedLabel.TextColor3 = Color3.fromRGB(196, 255, 210)
    overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(3, 20, 10)
    overheadSpeedLabel.TextStrokeTransparency = 0
    overheadSpeedLabel.Font = Enum.Font.GothamBlack
    overheadSpeedLabel.TextSize = 19
    overheadSpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
    overheadSpeedLabel.Parent = overheadGui
end
function stopRagdollCountdown()
    if ragdollCountdownConn then ragdollCountdownConn:Disconnect(); ragdollCountdownConn = nil end
    if ragdollCountdownCharConn then ragdollCountdownCharConn:Disconnect(); ragdollCountdownCharConn = nil end
    if ragdollCountdownLabel then
        ragdollCountdownLabel.Visible = false
        ragdollCountdownLabel.Text = ""
    end
end
function hookRagdollCountdown(char)
    stopRagdollCountdown()
    if not ragdollCountdownEnabled then return end
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
    if not hum then return end
    local function beginCountdown()
        ragdollCountdownEndTime = tick() + RAGDOLL_COUNTDOWN_SECONDS
        if ragdollCountdownLabel then ragdollCountdownLabel.Visible = true end
    end
    local function isRagdollStateForCountdown()
        local st = hum:GetState()
        return hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end
    ragdollCountdownCharConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics
        or newState == Enum.HumanoidStateType.Ragdoll
        or newState == Enum.HumanoidStateType.FallingDown then
            beginCountdown()
        end
    end)
    ragdollCountdownConn = RunService.RenderStepped:Connect(function()
        if not ragdollCountdownEnabled then stopRagdollCountdown(); return end
        if not ragdollCountdownLabel or not ragdollCountdownLabel.Parent then return end
        if isRagdollStateForCountdown() and ragdollCountdownEndTime < tick() then beginCountdown() end
        local left = math.max(0, ragdollCountdownEndTime - tick())
        if left > 0 then
            ragdollCountdownLabel.Visible = true
            ragdollCountdownLabel.Text = string.format("RAGDOLL %.1f", left)
        else
            ragdollCountdownLabel.Visible = false
            ragdollCountdownLabel.Text = ""
        end
    end)
end
if LP.Character then
    task.spawn(function() setupOverheadInfo(LP.Character) end)
end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupOverheadInfo(char)
    if ragdollCountdownEnabled then hookRagdollCountdown(char) end
end)
RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    local state = hum:GetState()
    if hum.PlatformStand
    or state == Enum.HumanoidStateType.Physics
    or state == Enum.HumanoidStateType.Ragdoll
    or state == Enum.HumanoidStateType.FallingDown then
        return
    end
    local md = hum.MoveDirection
    local spd = getCurrentSpeedValue and getCurrentSpeedValue() or NS
    if not autoLeftEnabled and not autoRightEnabled and md.Magnitude > 0 then
        hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
    end
    if overheadSpeedLabel then
        local v = hrp.AssemblyLinearVelocity or hrp.Velocity
        local speedMag = Vector3.new(v.X, 0, v.Z).Magnitude
        overheadSpeedLabel.Text = string.format("Speed: %d", math.floor(speedMag + 0.5))
    end
end)

-- ===== BODY / ANIM / IMPORT PANELS =====
task.wait()
-- (Стандартные окна Body/Anim/Import/Lagger — упрощённые в этой версии)
-- Body changer
local BodyPanel = Instance.new("Frame")
BodyPanel.Name = "ToxicBodyWindow"
BodyPanel.BackgroundColor3 = SKIN.void
BodyPanel.BorderSizePixel = 0
BodyPanel.Size = UDim2.new(0, 300, 0, 340)
BodyPanel.Position = UDim2.new(0.5, -150, 0.5, -170)
BodyPanel.Active = true
BodyPanel.ClipsDescendants = true
BodyPanel.Visible = false
BodyPanel.ZIndex = 20
BodyPanel.Parent = Gui
round(BodyPanel, 10)
edge(BodyPanel, SKIN.seam, 1, 0.3)
grip(BodyPanel)
local bodyTitle = caption(BodyPanel, "BODY CHANGER", 15, TYPE_HEAVY, SKIN.ink)
bodyTitle.Position = UDim2.new(0, 20, 0, 15)
bodyTitle.Size = UDim2.new(1, -70, 0, 20)
local bodyClose = chipButton(BodyPanel, "\226\128\147", 26, 22)
bodyClose.Position = UDim2.new(1, -38, 0, 15)
bodyClose.TextSize = 15
bodyClose.Activated:Connect(function() BodyPanel.Visible = false end)
local bodyHint = caption(BodyPanel, "Введи ID ассета (rbxassetid) в чат лоадера, или юзай готовые пресеты ниже.", 10, TYPE_BODY, SKIN.inkMute)
bodyHint.Position = UDim2.new(0, 20, 0, 55)
bodyHint.Size = UDim2.new(1, -40, 0, 40)
bodyHint.TextWrapped = true
_G.BodyPanelToggle = function() BodyPanel.Visible = not BodyPanel.Visible end

-- Anim panel
local AnimPanel = Instance.new("Frame")
AnimPanel.Name = "ToxicAnimWindow"
AnimPanel.BackgroundColor3 = SKIN.void
AnimPanel.BorderSizePixel = 0
AnimPanel.Size = UDim2.new(0, 300, 0, 340)
AnimPanel.Position = UDim2.new(0.5, -150, 0.5, -170)
AnimPanel.Active = true
AnimPanel.ClipsDescendants = true
AnimPanel.Visible = false
AnimPanel.ZIndex = 20
AnimPanel.Parent = Gui
round(AnimPanel, 10)
edge(AnimPanel, SKIN.seam, 1, 0.3)
grip(AnimPanel)
local animTitle = caption(AnimPanel, "ANIMATIONS", 15, TYPE_HEAVY, SKIN.ink)
animTitle.Position = UDim2.new(0, 20, 0, 15)
animTitle.Size = UDim2.new(1, -70, 0, 20)
local animClose = chipButton(AnimPanel, "\226\128\147", 26, 22)
animClose.Position = UDim2.new(1, -38, 0, 15)
animClose.TextSize = 15
animClose.Activated:Connect(function() AnimPanel.Visible = false end)
local animHint = caption(AnimPanel, "Используй вкладку MOVEMENT -> Animation Pack для выбора пака. Кастомные ID можно будет добавить позже.", 10, TYPE_BODY, SKIN.inkMute)
animHint.Position = UDim2.new(0, 20, 0, 55)
animHint.Size = UDim2.new(1, -40, 0, 60)
animHint.TextWrapped = true
_G.AnimPanelToggle = function() AnimPanel.Visible = not AnimPanel.Visible end

-- Import panel
local ImportPanel = Instance.new("Frame")
ImportPanel.Name = "ToxicImportWindow"
ImportPanel.BackgroundColor3 = SKIN.void
ImportPanel.BorderSizePixel = 0
ImportPanel.Size = UDim2.new(0, 320, 0, 300)
ImportPanel.Position = UDim2.new(0.5, -160, 0.5, -150)
ImportPanel.Active = true
ImportPanel.ClipsDescendants = true
ImportPanel.Visible = false
ImportPanel.ZIndex = 20
ImportPanel.Parent = Gui
round(ImportPanel, 10)
edge(ImportPanel, SKIN.seam, 1, 0.3)
grip(ImportPanel)
local impTitle = caption(ImportPanel, "IMPORT CONFIG", 15, TYPE_HEAVY, SKIN.ink)
impTitle.Position = UDim2.new(0, 20, 0, 15)
impTitle.Size = UDim2.new(1, -70, 0, 20)
local impClose = chipButton(ImportPanel, "\226\128\147", 26, 22)
impClose.Position = UDim2.new(1, -38, 0, 15)
impClose.TextSize = 15
impClose.Activated:Connect(function() ImportPanel.Visible = false end)
local impHint = caption(ImportPanel, "Сканер конфигов доступен в полной версии. Пока — импорт только из текущего файла ToxicDuels_Config.json.", 10, TYPE_BODY, SKIN.inkMute)
impHint.Position = UDim2.new(0, 20, 0, 55)
impHint.Size = UDim2.new(1, -40, 0, 60)
impHint.TextWrapped = true
local impBtn = Instance.new("TextButton")
impBtn.BackgroundColor3 = SKIN.well
impBtn.BorderSizePixel = 0
impBtn.Text = "RELOAD CONFIG"
impBtn.TextColor3 = SKIN.ink
impBtn.TextSize = 11
impBtn.Font = TYPE_HEAVY
impBtn.AutoButtonColor = false
impBtn.Size = UDim2.new(1, -40, 0, 36)
impBtn.Position = UDim2.new(0, 20, 0, 130)
impBtn.Parent = ImportPanel
round(impBtn, 7)
edge(impBtn, SKIN.seamSoft, 1, 0.3)
impBtn.MouseButton1Click:Connect(function()
    if loadToxicConfig then loadToxicConfig() end
    showActionNotification("CONFIG RELOADED")
end)
_G.ImportPanelToggle = function() ImportPanel.Visible = not ImportPanel.Visible end

-- Lagger window
local LaggerPanel = Instance.new("Frame")
LaggerPanel.Name = "ToxicLaggerWindow"
LaggerPanel.BackgroundColor3 = SKIN.void
LaggerPanel.BorderSizePixel = 0
LaggerPanel.Size = UDim2.new(0, 268, 0, 214)
LaggerPanel.Position = UDim2.new(0, 24, 0, 24)
LaggerPanel.Active = true
LaggerPanel.ClipsDescendants = true
LaggerPanel.Visible = laggerWindowOpen
LaggerPanel.ZIndex = 20
LaggerPanel.Parent = Gui
round(LaggerPanel, 10)
edge(LaggerPanel, SKIN.seam, 1, 0.3)
grip(LaggerPanel)
local lagTitle = caption(LaggerPanel, "LAGGER", 15, TYPE_HEAVY, SKIN.ink)
lagTitle.Position = UDim2.new(0, 20, 0, 15)
lagTitle.Size = UDim2.new(1, -70, 0, 18)
local lagSub = caption(LaggerPanel, "NETWORK CHOKE", 8, TYPE_BOLD, SKIN.inkFaint)
lagSub.Position = UDim2.new(0, 20, 0, 32)
lagSub.Size = UDim2.new(1, -70, 0, 10)
local lagClose = chipButton(LaggerPanel, "\226\128\147", 26, 22)
lagClose.Position = UDim2.new(1, -38, 0, 15)
lagClose.TextSize = 15
lagClose.Activated:Connect(function() LaggerPanel.Visible = false end)
local lagPower = Instance.new("TextButton")
lagPower.BackgroundColor3 = SKIN.well
lagPower.BorderSizePixel = 0
lagPower.Text = laggerEnabled and "STOP" or "START"
lagPower.TextColor3 = SKIN.ink
lagPower.TextSize = 12
lagPower.Font = TYPE_HEAVY
lagPower.AutoButtonColor = false
lagPower.Size = UDim2.new(1, -40, 0, 44)
lagPower.Position = UDim2.new(0, 20, 0, 60)
lagPower.Parent = LaggerPanel
round(lagPower, 8)
edge(lagPower, SKIN.seamSoft, 1.2, 0.35)
lagPower.MouseButton1Click:Connect(function()
    toggleLagger()
    lagPower.Text = laggerEnabled and "STOP" or "START"
end)
_G.LaggerWindowToggle = function()
    LaggerPanel.Visible = not LaggerPanel.Visible
    laggerWindowOpen = LaggerPanel.Visible
end

-- ===== MOBILE BUTTONS (упрощённая логика) =====
task.defer(function()
    task.wait(0.5)
    local old = PlayerGui:FindFirstChild("ToxicDuelsMobileButtons")
    if old then old:Destroy() end
    local mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "ToxicDuelsMobileButtons"
    mobileGui.ResetOnSpawn = false
    mobileGui.IgnoreGuiInset = true
    mobileGui.DisplayOrder = 1000
    mobileGui.Parent = PlayerGui
    _G.ToxicMobileButtonRefs = {}

    function _G.ToxicApplyMobileButtonsHidden()
        local g = PlayerGui:FindFirstChild("ToxicDuelsMobileButtons")
        if g then g.Enabled = not (_G.ToxicHideMobileButtons == true) end
    end

    function _G.ToxicApplyMobileButtonSize()
        for _, entry in pairs(_G.ToxicMobileButtonRefs) do
            local holder = entry.holder
            if holder then
                local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale")
                sc.Name = "MobileButtonScale"
                sc.Scale = math.clamp(tonumber(_G.ToxicMobileButtonScale) or 0.75, 0.30, 1.35)
                sc.Parent = holder
            end
        end
    end

    local function makeButton(key, label, pos, onPress)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(0, 60, 0, 60)
        holder.Position = tableToUDim2(_G.ToxicMobileButtonPositions[key], pos)
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.ZIndex = 1000
        holder.Active = true
        holder.Parent = mobileGui
        local btn = Instance.new("TextButton", holder)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(14, 22, 16)
        btn.BackgroundTransparency = 0.05
        btn.BorderSizePixel = 0
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(240, 255, 240)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 10
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 1002
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(58, 118, 66)
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btn.MouseButton1Click:Connect(function()
            pcall(onPress, btn)
        end)
        _G.ToxicMobileButtonRefs[key] = {holder = holder, btn = btn}
    end

    local x1, x2, x3 = -212, -146, -80
    local y1, y2, y3, y4 = -200, -134, -68, -2
    local defaults = {
        insta        = UDim2.new(1, x1, 0.5, y1),
        drop         = UDim2.new(1, x2, 0.5, y1),
        autoLeft     = UDim2.new(1, x3, 0.5, y1),
        antiDesync   = UDim2.new(1, x1, 0.5, y2),
        aimbot       = UDim2.new(1, x2, 0.5, y2),
        autoRight    = UDim2.new(1, x3, 0.5, y2),
        tp           = UDim2.new(1, x2, 0.5, y3),
        carry        = UDim2.new(1, x3, 0.5, y3),
        laggerNormal = UDim2.new(1, x2, 0.5, y4),
        laggerCarry  = UDim2.new(1, x3, 0.5, y4),
    }

    function _G.ToxicResetMobileButtons()
        _G.ToxicMobileButtonScale = 0.75
        _G.ToxicHideMobileButtons = false
        for key, entry in pairs(_G.ToxicMobileButtonRefs) do
            if defaults[key] then entry.holder.Position = defaults[key] end
        end
        _G.ToxicApplyMobileButtonSize()
        _G.ToxicApplyMobileButtonsHidden()
        showActionNotification("MOBILE BUTTONS RESET")
    end

    makeButton("insta", "INSTA\nRESET", defaults.insta, function()
        if _G.InstantReset then _G.InstantReset() end
    end)
    makeButton("drop", "DROP\nBR", defaults.drop, function()
        if runDropBrainrot then runDropBrainrot() end
    end)
    makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function()
        if _G.ToxicSetAutoLeft then _G.ToxicSetAutoLeft(not autoLeftEnabled) end
    end)
    makeButton("antiDesync", "TP\nBAT", defaults.antiDesync, function()
        if _G.TPBatToggle then _G.TPBatToggle() end
    end)
    makeButton("aimbot", "AIM\nLOCK", defaults.aimbot, function()
        if _G.AimbotToggle then _G.AimbotToggle() end
    end)
    makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function()
        if _G.ToxicSetAutoRight then _G.ToxicSetAutoRight(not autoRightEnabled) end
    end)
    makeButton("tp", "TP\nDOWN", defaults.tp, function()
        if runTPFloor then runTPFloor() end
    end)
    makeButton("carry", "CARRY\nSPEED", defaults.carry, function()
        if setSpeedMode then setSpeedMode(currentSpeedMode == "Carry" and "Normal" or "Carry") end
    end)
    makeButton("laggerNormal", "LAGGER\nNORMAL", defaults.laggerNormal, function()
        if setSpeedMode then setSpeedMode(currentSpeedMode == "Lagger" and "Normal" or "Lagger") end
    end)
    makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function()
        if setSpeedMode then setSpeedMode(currentSpeedMode == "Lagger Carry" and "Normal" or "Lagger Carry") end
    end)

    _G.ToxicApplyMobileButtonSize()
    _G.ToxicApplyMobileButtonsHidden()
end)
-- =====================================================
--  TOXIC DUELS | Part 6/6: StealBar + Final Launch
-- =====================================================

-- ===== STEAL BAR =====
task.wait()
do
    local existingStealBar = PlayerGui:FindFirstChild("StealBarGui")
    if existingStealBar then existingStealBar:Destroy() end
    local THEME_ACCENT = ACCENT
    local gui = Instance.new("ScreenGui")
    gui.Name = "StealBarGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui
    local pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "StealBar"
    pbFrame.Size = UDim2.new(0, 244, 0, 40)
    pbFrame.Position = UDim2.new(0.5, -122, 1, -92)
    pbFrame.BackgroundColor3 = Color3.fromRGB(6, 10, 8)
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
    local pbSt = Instance.new("UIStroke", pbFrame)
    pbSt.Color = THEME_ACCENT
    pbSt.Thickness = 1.4
    pbSt.Transparency = 0.25
    local pbScale = Instance.new("UIScale")
    pbScale.Name = "ToxicProgressBarScale"
    pbScale.Scale = waterProgressBarScaleValue or 0.83
    pbScale.Parent = pbFrame
    local fillRegion = Instance.new("Frame", pbFrame)
    fillRegion.Size = UDim2.new(1, -12, 1, -10)
    fillRegion.Position = UDim2.new(0, 6, 0, 5)
    fillRegion.BackgroundColor3 = Color3.fromRGB(15, 22, 18)
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 2
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
    local fillRegStroke = Instance.new("UIStroke", fillRegion)
    fillRegStroke.Color = THEME_ACCENT
    fillRegStroke.Thickness = 1
    fillRegStroke.Transparency = 0.6
    local progressFill = Instance.new("Frame", fillRegion)
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = THEME_ACCENT
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 3
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    registerAccent(function(c)
        pcall(function()
            pbSt.Color = c
            fillRegStroke.Color = c
            progressFill.BackgroundColor3 = c
        end)
    end)
    local stealLbl = Instance.new("TextLabel", fillRegion)
    stealLbl.Size = UDim2.new(0, 50, 1, 0)
    stealLbl.Position = UDim2.new(0, 10, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealLbl.Font = Enum.Font.GothamSemibold
    stealLbl.TextSize = 13
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    stealLbl.ZIndex = 5
    local progressPct = Instance.new("TextLabel", fillRegion)
    progressPct.Size = UDim2.new(0, 50, 1, 0)
    progressPct.Position = UDim2.new(1, -55, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(230, 255, 230)
    progressPct.Font = Enum.Font.GothamSemibold
    progressPct.TextSize = 12
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.ZIndex = 5
    local StealBar = {}
    function StealBar.SetProgress(p)
        p = math.clamp(p, 0, 1)
        progressFill.Size = UDim2.new(p, 0, 1, 0)
        progressPct.Text = math.floor(p * 100 + 0.5) .. "%"
    end
    function StealBar.SetState(state)
        if state == "STEALING" then
            stealLbl.Text = "STEAL"
            stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif state == "READY" then
            stealLbl.Text = "READY"
            stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            stealLbl.Text = "STEAL"
            stealLbl.TextColor3 = Color3.fromRGB(150, 200, 160)
            progressPct.Text = "0%"
        end
    end
    function StealBar.Reset()
        StealBar.SetProgress(0)
        StealBar.SetState("IDLE")
    end
    StealBar.SetState("IDLE")
    _G.StealBar = StealBar
end

-- ===== FINAL SYNC =====
task.wait()
setTab("STEAL")

_G.ToxicSyncToggleVisuals = function()
    pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
    pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
    pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
    pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
    pcall(function() if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end end)
    pcall(function() if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled == true) end end)
    pcall(function() if setAntiDieVisual then setAntiDieVisual(antiDieEnabled == true) end end)
    pcall(function() if _G.ToxicSetAutoLeftVisual then _G.ToxicSetAutoLeftVisual(autoLeftEnabled == true) end end)
    pcall(function() if _G.ToxicSetAutoRightVisual then _G.ToxicSetAutoRightVisual(autoRightEnabled == true) end end)
    pcall(function() if setRagdollStealVisual then setRagdollStealVisual(ragdollStealEnabled == true) end end)
    pcall(function() if setStealSoundVisual then setStealSoundVisual(stealSoundEnabled == true) end end)
    pcall(function() if setStealAlertVisual then setStealAlertVisual(stealAlertEnabled == true) end end)
    pcall(function() if setPlayerESPVisual then setPlayerESPVisual(espEnabled == true) end end)
    pcall(function() if setTracerESPVisual then setTracerESPVisual(showTracerEnabled == true) end end)
end

_G.ToxicApplySavedGameplayStates = function()
    pcall(function()
        if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end
        if autoTPEnabled then startAutoTP() else stopAutoTP() end
    end)
    pcall(function()
        if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
        if setInfJumpInternal then setInfJumpInternal(infJumpEnabled == true) end
    end)
    pcall(function()
        if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end
        if setAntiRagdoll then setAntiRagdoll(antiRagdollEnabled == true) end
    end)
    pcall(function()
        if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end
        if _G.GrabRefresh then _G.GrabRefresh() end
    end)
    pcall(function()
        if _G.ToxicSetAntiDie then _G.ToxicSetAntiDie(antiDieEnabled == true, true) end
    end)
    pcall(function()
        if _G.ToxicSetAutoResetOnMed then _G.ToxicSetAutoResetOnMed(autoResetOnMedEnabled == true, true) end
    end)
    pcall(function()
        if _G.ToxicSetInstaResetOnDeath then _G.ToxicSetInstaResetOnDeath(autoInstaResetOnDeathEnabled == true, true) end
    end)
    pcall(function()
        if setPlayerESPVisual then setPlayerESPVisual(espEnabled == true) end
        if espEnabled then
            if startPlayerESP then startPlayerESP() end
            if BoxedESPOptions then BoxedESPOptions.box = true end
        end
        if setTracerESPVisual then setTracerESPVisual(showTracerEnabled == true) end
        if BoxedESPOptions then BoxedESPOptions.tracer = showTracerEnabled == true end
        if refreshBoxedESP then refreshBoxedESP() end
    end)
    pcall(function()
        if setFPSBoostVisual then setFPSBoostVisual(stretchRezEnabled == true) end
        if stretchRezEnabled then enableStretchRez() else disableStretchRez() end
        if setAntiLagVisual then setAntiLagVisual(antiLagEnabled == true) end
        if antiLagEnabled then enableAntiLag() else disableAntiLag() end
        if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled == true) end
        if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
        if setFOVVisual then setFOVVisual(fovEnabled == true) end
        if fovEnabled then enableCustomFov() else disableCustomFov() end
        if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled == true) end
        if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
    end)
    pcall(function()
        if type(applyCustomSky) == "function" then
            applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off")
        end
        if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
    end)
    pcall(function()
        if syncAnimationPackIndex then syncAnimationPackIndex() end
        if refreshAnimationPackRow then refreshAnimationPackRow() end
        if applySavedAnimationPackToCharacter then applySavedAnimationPackToCharacter(LP.Character) end
    end)
end

task.defer(function()
    task.wait(0.35)
    if _G.ToxicApplySavedGameplayStates then _G.ToxicApplySavedGameplayStates() end
    if _G.ToxicSyncToggleVisuals then _G.ToxicSyncToggleVisuals() end
end)
task.delay(1.25, function()
    if _G.ToxicApplySavedGameplayStates then _G.ToxicApplySavedGameplayStates() end
end)
task.defer(function()
    task.wait(0.2)
    if _G.GrabRefresh then pcall(_G.GrabRefresh) end
end)

-- Автосохранение конфига
task.spawn(function()
    while task.wait(30) do
        saveToxicConfig()
    end
end)

-- Обновление визуалов при смене состояний
do
    local lastTPBat, lastAimbot, lastMode = nil, nil, nil
    RunService.Heartbeat:Connect(function()
        local tpBat = _G.TPBatOn == true
        if tpBat ~= lastTPBat then
            lastTPBat = tpBat
            if _G.TPBatSetVisual then _G.TPBatSetVisual(tpBat) end
        end
        local aim = _G.AimbotOn == true
        if aim ~= lastAimbot then
            lastAimbot = aim
            if _G.AimbotSetVisual then _G.AimbotSetVisual(aim) end
        end
        if currentSpeedMode ~= lastMode then
            lastMode = currentSpeedMode
            if refreshSpeedModeRows then refreshSpeedModeRows() end
        end
    end)
end

-- Финальная инициализация визуала
if ToxicUpdateGuiLockVisual then ToxicUpdateGuiLockVisual() end
if _G.ToxicApplyMobileButtonsHidden then _G.ToxicApplyMobileButtonsHidden() end
if _G.ToxicApplyMobileButtonSize then _G.ToxicApplyMobileButtonSize() end
