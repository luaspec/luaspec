

-- Megalodon Finder V1 — Laced UI + our backend
-- GUI style: Laced Notifier  |  Data: Megalodon feed  |  Keys: self-hosted

local HttpService    = game:GetService("HttpService")
local CoreGui        = game:GetService("CoreGui")
local TweenService   = game:GetService("TweenService")
local Players        = game:GetService("Players")
local TeleportService= game:GetService("TeleportService")
local SoundService   = game:GetService("SoundService")
local UserInputService=game:GetService("UserInputService")

-- ── Cleanup previous instance ─────────────────────────
local UI_NAME = "MegalodonFinder_GUI"
if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end
if SoundService:FindFirstChild("MFNotifSound") then SoundService.MFNotifSound:Destroy() end
_G.MegalodonRunning = true

local lp = Players.LocalPlayer

-- ════════════════════════════════════════════════════
--   BACKEND CONFIG
-- ════════════════════════════════════════════════════
local function _d(t) local s="" for _,c in ipairs(t) do s=s..string.char(c) end return s end
local HTTP_URL   = _d({104,116,116,112,115,58,47,47,119,115,46,118,97,110,105,115,104,110,111,116,105,102,105,101,114,46,111,114,103,47,114,101,99,101,110,116})
local BOTS_URL   = _d({104,116,116,112,115,58,47,47,119,115,46,118,97,110,105,115,104,110,111,116,105,102,105,101,114,46,111,114,103,47,98,111,116,115})
local BOTS_REFRESH_S     = 20
local JOB_ID_MAX_DELTA_S = 120
local POLL_INTERVAL      = 0.25
local PLACE_ID           = 109983668079237
local BASE = "https://7102fbfa-e1aa-4a7f-b2e2-62108d851ff2-00-172yv0dbelobp.janeway.replit.dev"
local AJ_REGISTER_URL    = BASE .. "/__aj/register"
local AJ_LIST_URL        = BASE .. "/__aj/list"
local AJ_REFRESH_S       = 15
local CW_HEARTBEAT_URL   = BASE .. "/__cw/heartbeat"
local CW_PRESENCE_REFRESH_S = 10
local KEY_VERIFY_URL     = BASE .. "/key/verify"
local KEY_FILE           = "MegalodonKey.txt"
local LOADSTRING_URL     = BASE .. "/download.lua"
local CONFIG_FILE        = "MegalodonFinder_Config.json"

-- ════════════════════════════════════════════════════
--   TIER OVERRIDES (mirrors the website)
-- ════════════════════════════════════════════════════
local TIER_OVERRIDES = {
    ["cash or card"]                  = "highlights",
    ["quesadillo vampiro"]            = "lowlights",
    ["noo my eggs"]                   = "lowlights",
    ["los bunitos"]                   = "lowlights",
    ["los nooo my hotspotsitos"]      = "lowlights",
    ["cigno fulgoro"]                 = "lowlights",
    ["chicleteirina bicicleteirina"]  = "lowlights",
    ["pot hotspot"]                   = "lowlights",
    ["serafinna medusella"]           = "lowlights",
    ["eid eid eid sahur"]             = "lowlights",
    ["los chicleteiras"]              = "lowlights",
    ["granny"]                        = "lowlights",
    ["money money puggy"]             = "lowlights",
    ["burrito bandito"]               = "lowlights",
    ["spaghetti tualetti"]            = "lowlights",
    ["esok sekolah"]                  = "lowlights",
    ["spinny hammy"]                  = "lowlights",
    ["no my eggs"]                    = "lowlights",
}
local TIER_OVERRIDES_CONTAINS = {
    {"garama",       "highlights"},
    {"ketchuru",     "midlights"},
    {"cash or card", "highlights"},
    {"gold",         "lowlights"},
}
local function routedTier(apiTier, name)
    local lower = tostring(name or ""):lower():gsub("^%s+",""):gsub("%s+$","")
    if TIER_OVERRIDES[lower] then return TIER_OVERRIDES[lower] end
    for _, pair in ipairs(TIER_OVERRIDES_CONTAINS) do
        if lower:find(pair[1], 1, true) then return pair[2] end
    end
    return tostring(apiTier or "midlights"):lower()
end

-- ════════════════════════════════════════════════════
--   BRAINROT LIST (for whitelist page)
-- ════════════════════════════════════════════════════
local allBrainrots = {
    "Los Nooo My Hotspotsitos","Serafinna Medusella","La Grande Combinassion","La Easter Grande","Rang Ring Bus","Guest 666",
    "Los Mi Gatitos","Los Chicleteiras","Noo My Eggs","67","Donkeyturbo Express","Mariachi Corazoni","Los Burritos",
    "Los 25","Tacorillo Crocodillo","Swag Soda","Noo my Heart","Chimnino","Los Combinasionas","Chicleteira Noelteira",
    "Fishino Clownino","Baskito","Tacorita Bicicleta","Los Sweethearts","Spinny Hammy","Nuclearo Dinosauro","Las Sis",
    "DJ Panda","Chicleteira Cupideira","La Karkerkar Combinasion","Chillin Chili","Chipso and Queso","Money Money Reindeer",
    "Money Money Puggy","Churrito Bunnito","Celularcini Viciosini","Los Planitos","Los Mobilis","Los 67",
    "Mieteteira Bicicleteira","Tuff Toucan","La Spooky Grande","Los Spooky Combinasionas","Cigno Fulgoro","Los Candies",
    "Los Hotspositos","Los Jolly Combinasionas","Los Cupids","Los Puggies","W or L","Tralalalaledon",
    "La Extinct Grande Combinasion","Tralaledon","La Jolly Grande","Los Primos","Bacuru and Egguru","Eviledon",
    "Los Tacoritas","Lovin Rose","Tang Tang Kelentang","Ketupat Kepat","Los Bros","Tictac Sahur","La Romantic Grande",
    "Gingerat Gerat","Orcaledon","La Lucky Grande","Ketchuru and Masturu","Jolly Jolly Sahur","Garama and Madundung",
    "Rosetti Tualetti","Nacho Spyder","Hopilikalika Hopilikalako","Festive 67","Sammyni Fattini","Love Love Bear",
    "La Ginger Sekolah","Spooky and Pumpky","Boppin Bunny","Lavadorito Spinito","La Food Combinasion","Los Spaghettis",
    "La Casa Boo","Fragrama and Chocrama","Los Sekolahs","Foxini Lanternini","La Secret Combinasion","Los Amigos",
    "Reinito Sleighito","Ketupat Bros","Burguro and Fryuro","Cooki and Milki","Capitano Moby","Rosey and Teddy",
    "Popcuru and Fizzuru","Hydra Bunny","Celestial Pegasus","Cerberus","La Supreme Combinasion","Dragon Cannelloni",
    "Dragon Gingerini","Headless Horseman","Hydra Dragon Cannelloni","Griffin","Skibidi Toilet","Meowl",
    "Strawberry Elephant","La Vacca Saturno Saturnita","Pandanini Frostini","Bisonte Giuppitere","Blackhole Goat",
    "Jackorilla","Agarrini Ia Palini","Chachechi","Karkerkar Kurkur","Los Tortus","Los Matteos","Sammyni Spyderini",
    "Trenostruzzo Turbo 4000","Chimpanzini Spiderini","Boatito Auratito","Fragola La La La","Dul Dul Dul",
    "La Vacca Prese Presente","Frankentteo","Los Trios","Karker Sahur","Zombie Tralala","La Cucaracha",
    "Vulturino Skeletono","Guerriro Digitale","Extinct Tralalero","Yess My Examine","Extinct Matteo",
    "Las Tralaleritas","Rocco Disco","Reindeer Tralala","Las Vaquitas Saturnitas","Pumpkin Spyderini",
    "Job Job Job Sahur","Los Karkeritos","Graipuss Medussi","Santteo","Fishboard","Buntteo",
    "La Vacca Jacko Linterino","Triplito Tralaleritos","Trickolino","Paradiso Axolottino","GOAT",
    "Giftini Spyderini","Los Spyderinis","Love Love Love Sahur","Perrito Burrito","1x1x1x1","Los Cucarachas",
    "Easter Easter Sahur","Please My Present","Los Jobcitos","Nooo My Hotspot","Noo My Examine","Telemorte",
    "La Sahur Combinasion","Pirulitoita Bicicletaire","25","Santa Hotspot","Horegini Boom","Quesadilla Crocodila",
    "Pot Pumpkin","Naughty Naughty","Cupid Cupid Sahur","Ho Ho Ho Sahur","Mi Gatito","Chicleteira Bicicleteira",
    "Eid Eid Eid Sahur","Cupid Hotspot","Quesadillo Vampiro","Brunito Marsito","Chill Puppy","Burrito Bandito",
    "Chicleteirina Bicicleteirina","Granny","Los Bunitos","Los Quesadillas","Bunito Bunito Spinito","Noo My Candy",
    "Esok Sekolah","Spinny Hammy","No My Eggs","Cash or Card","Spaghetti Tualetti","Money Money Puggy",
}

-- ════════════════════════════════════════════════════
--   USER SETTINGS
-- ════════════════════════════════════════════════════
local userSettings = {
    Peaklights = true,
    Highlights = true,
    Midlights  = true,
    Lowlights  = true,
    Steals     = true,
    MinValue         = 0,       -- minimum $/s to show; 0 = show all
    AutoJoin         = false,
    AutoJoinRetries  = 3,
    PlaySound        = true,
    ToggleKey        = "RightShift",
    UseWhitelist     = false,
    Whitelist        = {},
}

pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(saved) == "table" then
            for k, v in pairs(saved) do
                if k == "Whitelist" and type(v) == "table" then
                    for wk, wv in pairs(v) do userSettings.Whitelist[wk] = wv end
                else userSettings[k] = v end
            end
        end
    end
end)

task.spawn(function()
    local lastSave = HttpService:JSONEncode(userSettings)
    while _G.MegalodonRunning do
        task.wait(3)
        pcall(function()
            local cur = HttpService:JSONEncode(userSettings)
            if cur ~= lastSave then
                if writefile then writefile(CONFIG_FILE, cur) end
                lastSave = cur
            end
        end)
    end
end)

-- ════════════════════════════════════════════════════
--   HTTP HELPERS
-- ════════════════════════════════════════════════════
local function httpGet(url)
    local ok, res = pcall(function()
        if syn and syn.request   then return syn.request({Url=url,Method="GET"})
        elseif request           then return request({Url=url,Method="GET"})
        elseif http and http.request then return http.request({Url=url,Method="GET"})
        else return {Body=game:GetService("HttpService"):GetAsync(url)} end
    end)
    if ok and res then return res.Body end
    return nil
end

local function decodeJson(s)
    local ok, t = pcall(function() return HttpService:JSONDecode(s) end)
    return ok and t or nil
end

local function fmtValue(v)
    v = tonumber(v) or 0
    if v >= 1e6 then return string.format("%.1fM", v/1e6)
    elseif v >= 1000 then return math.floor(v/1000).."K"
    else return tostring(v) end
end

-- ════════════════════════════════════════════════════
--   BOTS ROSTER
-- ════════════════════════════════════════════════════
local bots, botsLastFetch = {}, 0
local function refreshBots(force)
    local now = os.time()
    if not force and (now - botsLastFetch) < BOTS_REFRESH_S then return end
    local body = httpGet(BOTS_URL)
    if not body then return end
    local data = decodeJson(body)
    if not (data and data.bots) then return end
    bots = data.bots; botsLastFetch = now
end
local function pickJobId(ts)
    if type(ts)~="number" or #bots==0 then return "" end
    local best, bestD = nil, math.huge
    for _, b in ipairs(bots) do
        local d = math.abs((tonumber(b.last_seen) or 0) - ts)
        if d < bestD then bestD, best = d, b end
    end
    if not best or bestD > JOB_ID_MAX_DELTA_S then return "" end
    return tostring(best.job_id or "")
end

-- ════════════════════════════════════════════════════
--   NOTIFICATION SOUND
-- ════════════════════════════════════════════════════
local NotifSound = Instance.new("Sound")
NotifSound.Name = "MFNotifSound"
NotifSound.SoundId = "rbxassetid://4590662766"
NotifSound.Volume = 1
NotifSound.Parent = SoundService
local function playNotifSound() if userSettings.PlaySound then NotifSound:Play() end end

-- ════════════════════════════════════════════════════
--   TIER COLOUR HELPERS
-- ════════════════════════════════════════════════════
local T = {
    BgDark      = Color3.fromRGB(8, 12, 21),
    BgMid       = Color3.fromRGB(12, 18, 32),
    BgCard      = Color3.fromRGB(16, 24, 42),
    BgCardHover = Color3.fromRGB(22, 32, 56),
    Sidebar     = Color3.fromRGB(6, 10, 18),
    Accent1     = Color3.fromRGB(60, 130, 246),
    Accent2     = Color3.fromRGB(99, 179, 255),
    White       = Color3.fromRGB(240, 245, 255),
    TextDim     = Color3.fromRGB(120, 140, 175),
    Off         = Color3.fromRGB(30, 36, 52),
    Green       = Color3.fromRGB(45, 210, 110),
    GreenDim    = Color3.fromRGB(25, 60, 40),
    Red         = Color3.fromRGB(220, 60, 70),
    Purple      = Color3.fromRGB(168, 85, 247),
    Gold        = Color3.fromRGB(245, 158, 11),
    MidBlue     = Color3.fromRGB(80, 175, 255),
    SlateGray   = Color3.fromRGB(100, 116, 139),
}

local ESP_BLUE = Color3.fromRGB(60, 130, 246)  -- fixed accent for ESP + logo button

local function tierColor(tier)
    local lt = tostring(tier or ""):lower()
    if lt == "peaklights" then return T.Purple
    elseif lt == "highlights" then return T.Gold
    elseif lt == "midlights"  then return T.MidBlue
    elseif lt == "lowlights"  then return T.SlateGray
    elseif lt == "steals"     then return T.Red
    else return T.MidBlue end
end

local function tierLabel(tier)
    local lt = tostring(tier or ""):lower()
    if lt == "peaklights" then return "Peaklights"
    elseif lt == "highlights" then return "Highlights"
    elseif lt == "midlights"  then return "Midlights"
    elseif lt == "lowlights"  then return "Lowlights"
    elseif lt == "steals"     then return "Steal"
    else return tier end
end

-- ════════════════════════════════════════════════════
--   MAIN GUI FRAME (Laced style with slide-in anim)
-- ════════════════════════════════════════════════════
local Gui = Instance.new("ScreenGui")
Gui.Name = UI_NAME
Gui.Parent = CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OPEN_POS = UDim2.new(0.5, -290, 0.5, -190)
local HIDE_POS = UDim2.new(0.5, -290, 1.5, 0)
local guiVisible = true

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = HIDE_POS
Main.BackgroundColor3 = T.BgDark
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = T.Accent1
MainStroke.Transparency = 0.1
MainStroke.Parent = Main

local BorderGrad = Instance.new("UIGradient")
BorderGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, T.Accent1),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 210, 255)),
    ColorSequenceKeypoint.new(1, T.Accent1),
}
BorderGrad.Parent = MainStroke

task.delay(0.1, function()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = OPEN_POS}):Play()
end)

-- ── Sidebar ───────────────────────────────────────────
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, 0)
Sidebar.BackgroundColor3 = T.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SFix = Instance.new("Frame")
SFix.Size = UDim2.new(0, 12, 1, 0)
SFix.Position = UDim2.new(1, -12, 0, 0)
SFix.BackgroundColor3 = T.Sidebar
SFix.BorderSizePixel = 0
SFix.Parent = Sidebar

local SepLine = Instance.new("Frame")
SepLine.Size = UDim2.new(0, 1, 1, -20)
SepLine.Position = UDim2.new(1, 0, 0, 10)
SepLine.BackgroundColor3 = T.Off
SepLine.BorderSizePixel = 0
SepLine.Parent = Sidebar

-- Logo
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 30)
Logo.Position = UDim2.new(0, 0, 0, 8)
Logo.BackgroundTransparency = 1
Logo.Text = "MEGALODON"
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 16
Logo.TextColor3 = T.Accent2
Logo.Parent = Sidebar

local LogoSub = Instance.new("TextLabel")
LogoSub.Size = UDim2.new(1, 0, 0, 14)
LogoSub.Position = UDim2.new(0, 0, 0, 37)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "F I N D E R"
LogoSub.Font = Enum.Font.Gotham
LogoSub.TextSize = 9
LogoSub.TextColor3 = T.TextDim
LogoSub.Parent = Sidebar

local VerBadge = Instance.new("TextLabel")
VerBadge.Size = UDim2.new(0.5, 0, 0, 18)
VerBadge.Position = UDim2.new(0.25, 0, 0, 56)
VerBadge.BackgroundColor3 = T.BgCard
VerBadge.Text = "v1"
VerBadge.Font = Enum.Font.GothamBold
VerBadge.TextSize = 10
VerBadge.TextColor3 = T.Accent2
VerBadge.Parent = Sidebar
Instance.new("UICorner", VerBadge).CornerRadius = UDim.new(0, 8)

-- Close / Minimize buttons
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -40, 0, 14)
CloseBtn.BackgroundColor3 = T.BgCardHover
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 12
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 90, 90)
CloseStroke.Transparency = 0.7
CloseStroke.Parent = CloseBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -76, 0, 14)
MinBtn.BackgroundColor3 = T.BgCardHover
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.fromRGB(255, 190, 80)
MinBtn.TextSize = 12
MinBtn.Parent = Main
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(255, 190, 80)
MinStroke.Transparency = 0.7
MinStroke.Parent = MinBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Transparency=0}):Play()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(200,50,50),TextColor3=T.White}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Transparency=0.7}):Play()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3=T.BgCardHover,TextColor3=Color3.fromRGB(255,90,90)}):Play()
end)
MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Transparency=0}):Play()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(200,150,40),TextColor3=T.White}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Transparency=0.7}):Play()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3=T.BgCardHover,TextColor3=Color3.fromRGB(255,190,80)}):Play()
end)

local pulseToggleBtn  -- forward-declared; assigned after the logo button is built

local function toggleGUI()
    guiVisible = not guiVisible
    if guiVisible then
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=OPEN_POS}):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position=HIDE_POS})
        tw:Play()
        tw.Completed:Connect(function() if not guiVisible then Main.Visible = false end end)
    end
    if pulseToggleBtn then pulseToggleBtn(guiVisible) end
end

CloseBtn.MouseButton1Click:Connect(function()
    _G.MegalodonRunning = false
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position=HIDE_POS}):Play()
    task.delay(0.4, function()
        Gui:Destroy()
        if SoundService:FindFirstChild("MFNotifSound") then SoundService.MFNotifSound:Destroy() end
    end)
end)
MinBtn.MouseButton1Click:Connect(toggleGUI)

-- ── Persistent logo toggle button (top-right, always visible) ────────
local MobileToggle = Instance.new("Frame")
MobileToggle.Name = "MFToggleBtn"
MobileToggle.Size = UDim2.new(0, 58, 0, 58)
MobileToggle.Position = UDim2.new(1, -72, 0, 10)
MobileToggle.BackgroundTransparency = 1
MobileToggle.Parent = Gui

-- Outer glow ring
local glowRing = Instance.new("Frame")
glowRing.Size = UDim2.new(1, 12, 1, 12)
glowRing.Position = UDim2.new(0, -6, 0, -6)
glowRing.BackgroundTransparency = 1
glowRing.Parent = MobileToggle
Instance.new("UICorner", glowRing).CornerRadius = UDim.new(1, 0)
local mtStroke = Instance.new("UIStroke")
mtStroke.Thickness = 2.5
mtStroke.Color = ESP_BLUE
mtStroke.Transparency = 0.2
mtStroke.Parent = glowRing

-- Main clickable circle
local mtBtn = Instance.new("TextButton")
mtBtn.Name = "ToggleInner"
mtBtn.Size = UDim2.new(1, 0, 1, 0)
mtBtn.BackgroundColor3 = Color3.fromRGB(7, 14, 30)
mtBtn.BorderSizePixel = 0
mtBtn.Text = ""
mtBtn.Active = true
mtBtn.Draggable = true
mtBtn.Parent = MobileToggle
Instance.new("UICorner", mtBtn).CornerRadius = UDim.new(1, 0)
local mtInnerStroke = Instance.new("UIStroke")
mtInnerStroke.Thickness = 1.5
mtInnerStroke.Color = ESP_BLUE
mtInnerStroke.Transparency = 0.5
mtInnerStroke.Parent = mtBtn

-- Shark emoji (top half of button)
local sharkLbl = Instance.new("TextLabel")
sharkLbl.Size = UDim2.new(1, 0, 0.58, 0)
sharkLbl.Position = UDim2.new(0, 0, 0, 1)
sharkLbl.BackgroundTransparency = 1
sharkLbl.Text = "🦈"
sharkLbl.Font = Enum.Font.GothamBlack
sharkLbl.TextSize = 22
sharkLbl.TextColor3 = Color3.new(1, 1, 1)
sharkLbl.Parent = mtBtn

-- "MF" label (bottom half of button)
local mfLbl = Instance.new("TextLabel")
mfLbl.Size = UDim2.new(1, 0, 0.38, 0)
mfLbl.Position = UDim2.new(0, 0, 0.6, 0)
mfLbl.BackgroundTransparency = 1
mfLbl.Text = "MF"
mfLbl.Font = Enum.Font.GothamBlack
mfLbl.TextSize = 11
mfLbl.TextColor3 = ESP_BLUE
mfLbl.Parent = mtBtn

mtBtn.MouseButton1Click:Connect(toggleGUI)

-- Assign the pulse function now that the button elements exist
pulseToggleBtn = function(on)
    TweenService:Create(mtStroke, TweenInfo.new(0.3),
        {Transparency = on and 0.55 or 0.15, Color = ESP_BLUE}):Play()
    TweenService:Create(mtInnerStroke, TweenInfo.new(0.3),
        {Transparency = on and 0.6 or 0.25}):Play()
    TweenService:Create(mtBtn, TweenInfo.new(0.3),
        {BackgroundColor3 = on and Color3.fromRGB(7, 14, 30) or Color3.fromRGB(14, 28, 58)}):Play()
end

-- Breathing glow when minimised (draws attention to the button)
task.spawn(function()
    local t = 0
    while _G.MegalodonRunning do
        t = t + 0.04
        if not guiVisible then
            local pulse = (math.sin(t * 2.2) + 1) / 2
            mtStroke.Transparency = 0.1 + pulse * 0.55
        end
        task.wait(0.04)
    end
end)

-- Forward-declare so the InputBegan callback (below) can reference it even though
-- the full definition lives in the TopBar section further down the file.
local updateAJVisuals

-- Keyboard toggle
local KeyHint = Instance.new("TextLabel")
KeyHint.Size = UDim2.new(1, 0, 0, 34)
KeyHint.Position = UDim2.new(0, 0, 1, -38)
KeyHint.BackgroundTransparency = 1
KeyHint.Text = userSettings.ToggleKey .. " = Toggle\nM = Toggle  •  N = AutoJoin"
KeyHint.Font = Enum.Font.Gotham
KeyHint.TextSize = 9
KeyHint.TextColor3 = T.Off
KeyHint.TextWrapped = true
KeyHint.Parent = Sidebar

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode.Name
    -- Configurable toggle key (set in Settings)
    if key == userSettings.ToggleKey then toggleGUI() end
    -- Hardcoded shortcuts
    if key == "M" then toggleGUI() end
    if key == "N" then
        userSettings.AutoJoin = not userSettings.AutoJoin
        updateAJVisuals(userSettings.AutoJoin)
    end
end)

-- ════════════════════════════════════════════════════
--   PAGES
-- ════════════════════════════════════════════════════
local LogsPage = Instance.new("Frame")
LogsPage.Size = UDim2.new(1, -155, 1, -2)
LogsPage.Position = UDim2.new(0, 155, 0, 2)
LogsPage.BackgroundTransparency = 1
LogsPage.Parent = Main

local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, -155, 1, -2)
SettingsPage.Position = UDim2.new(0, 155, 0, 2)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = Main

local WhitelistPage = Instance.new("Frame")
WhitelistPage.Size = UDim2.new(1, -155, 1, -2)
WhitelistPage.Position = UDim2.new(0, 155, 0, 2)
WhitelistPage.BackgroundTransparency = 1
WhitelistPage.Visible = false
WhitelistPage.Parent = Main

-- ── Tab buttons ───────────────────────────────────────
local curTab = "logs"
local tabButtons = {}

local function makeTabBtn(icon, text, yPos, key)
    local btn2 = Instance.new("TextButton")
    btn2.Size = UDim2.new(1, -20, 0, 36)
    btn2.Position = UDim2.new(0, 10, 0, yPos)
    btn2.BackgroundColor3 = T.BgCard
    btn2.BackgroundTransparency = key == "logs" and 0 or 1
    btn2.BorderSizePixel = 0
    btn2.Text = ""
    btn2.AutoButtonColor = false
    btn2.Parent = Sidebar
    Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 6)
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 3, 0.6, 0)
    ind.Position = UDim2.new(0, 0, 0.2, 0)
    ind.BackgroundColor3 = T.Accent1
    ind.BackgroundTransparency = key == "logs" and 0 or 1
    ind.Parent = btn2
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -15, 1, 0)
    lbl2.Position = UDim2.new(0, 15, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = icon .. "  " .. text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 12
    lbl2.TextColor3 = key == "logs" and T.White or T.TextDim
    lbl2.Parent = btn2
    tabButtons[key] = {btn=btn2, ind=ind, lbl=lbl2}
    return btn2
end

local tLogs     = makeTabBtn("📋", "Logs",      90,  "logs")
local tSettings = makeTabBtn("⚙️", "Settings",  132, "settings")
local tWhitelist= makeTabBtn("🛡️", "Whitelist", 174, "whitelist")

local function switchTab(toKey)
    curTab = toKey
    LogsPage.Visible      = toKey == "logs"
    SettingsPage.Visible  = toKey == "settings"
    WhitelistPage.Visible = toKey == "whitelist"
    for k, v in pairs(tabButtons) do
        local act = k == toKey
        TweenService:Create(v.btn, TweenInfo.new(0.2), {BackgroundTransparency = act and 0 or 1}):Play()
        TweenService:Create(v.ind, TweenInfo.new(0.2), {BackgroundTransparency = act and 0 or 1}):Play()
        v.lbl.TextColor3 = act and T.White or T.TextDim
    end
end

tLogs.MouseButton1Click:Connect(function() switchTab("logs") end)
tSettings.MouseButton1Click:Connect(function() switchTab("settings") end)
tWhitelist.MouseButton1Click:Connect(function() switchTab("whitelist") end)

-- ════════════════════════════════════════════════════
--   SETTINGS PAGE
-- ════════════════════════════════════════════════════
local SScroll = Instance.new("ScrollingFrame")
SScroll.Size = UDim2.new(1, 0, 1, 0)
SScroll.BackgroundTransparency = 1
SScroll.BorderSizePixel = 0
SScroll.ScrollBarThickness = 2
SScroll.ScrollBarImageColor3 = T.Off
SScroll.Parent = SettingsPage
local SLayout = Instance.new("UIListLayout")
SLayout.Parent = SScroll
SLayout.Padding = UDim.new(0, 8)
SLayout.SortOrder = Enum.SortOrder.LayoutOrder
local SPad = Instance.new("UIPadding")
SPad.PaddingTop = UDim.new(0, 15)
SPad.PaddingLeft = UDim.new(0, 18)
SPad.PaddingRight = UDim.new(0, 18)
SPad.Parent = SScroll
SLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SScroll.CanvasSize = UDim2.new(0, 0, 0, SLayout.AbsoluteContentSize.Y + 20)
end)

local function makeHeader(text, parent)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 20)
    h.BackgroundTransparency = 1
    h.Text = text
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Font = Enum.Font.GothamBold
    h.TextSize = 11
    h.TextColor3 = T.Accent2
    h.Parent = parent
end

local function makeToggle(parent, text, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -65, 1, 0)
    lbl2.Position = UDim2.new(0, 14, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 13
    lbl2.TextColor3 = T.White
    lbl2.Parent = f
    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0, 42, 0, 22)
    track.Position = UDim2.new(1, -56, 0.5, -11)
    track.BackgroundColor3 = userSettings[key] and T.Accent1 or T.Off
    track.Text = ""
    track.Parent = f
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = userSettings[key] and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)
    dot.BackgroundColor3 = T.White
    dot.Parent = track
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    track.MouseButton1Click:Connect(function()
        userSettings[key] = not userSettings[key]
        local on = userSettings[key]
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Quad),
            {Position = on and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)}):Play()
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    end)
end

local function makeInput(parent, text, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -65, 1, 0)
    lbl2.Position = UDim2.new(0, 14, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 13
    lbl2.TextColor3 = T.White
    lbl2.Parent = f
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 34, 0, 26)
    box.Position = UDim2.new(1, -50, 0.5, -13)
    box.BackgroundColor3 = T.Off
    box.Text = tostring(userSettings[key])
    box.Font = Enum.Font.GothamBold
    box.TextSize = 13
    box.TextColor3 = T.White
    box.ClearTextOnFocus = false
    box.Parent = f
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 then userSettings[key] = math.floor(v)
        else box.Text = tostring(userSettings[key]) end
    end)
end

-- Parses "500k" / "1.5m" / "2b" / plain numbers
local function parseShortValue(s)
    s = tostring(s or ""):lower():gsub("%s+","")
    local n, suf = s:match("^([%d%.]+)([kmb]?)$")
    n = tonumber(n)
    if not n then return nil end
    if suf == "k" then return math.floor(n * 1e3)
    elseif suf == "m" then return math.floor(n * 1e6)
    elseif suf == "b" then return math.floor(n * 1e9)
    else return math.floor(n) end
end

local function fmtShortLua(v)
    if v == 0 then return "0" end
    if v >= 1e9 then return string.format("%.1fB", v/1e9)
    elseif v >= 1e6 then return string.format("%.1fM", v/1e6)
    elseif v >= 1e3 then return string.format("%.1fk", v/1e3)
    else return tostring(math.floor(v)) end
end

local function makeValueInput(parent, text, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = T.BgCard
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -115, 0, 20)
    lbl2.Position = UDim2.new(0, 14, 0, 7)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 13
    lbl2.TextColor3 = T.White
    lbl2.Parent = f

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -115, 0, 14)
    hint.Position = UDim2.new(0, 14, 0, 28)
    hint.BackgroundTransparency = 1
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Text = "0 = show all  •  e.g. 500k, 1.5m"
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 10
    hint.TextColor3 = T.Off
    hint.Parent = f

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 90, 0, 28)
    box.Position = UDim2.new(1, -106, 0.5, -14)
    box.BackgroundColor3 = T.Off
    box.Text = fmtShortLua(userSettings[key] or 0)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 13
    box.TextColor3 = T.White
    box.ClearTextOnFocus = false
    box.Parent = f
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)

    box.FocusLost:Connect(function()
        local v = parseShortValue(box.Text)
        if v ~= nil and v >= 0 then
            userSettings[key] = v
            box.Text = fmtShortLua(v)
        else
            box.Text = fmtShortLua(userSettings[key] or 0)
        end
    end)
end

local function makeKeybindSetting(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -95, 1, 0)
    lbl2.Position = UDim2.new(0, 14, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 13
    lbl2.TextColor3 = T.White
    lbl2.Parent = f
    local kbtn = Instance.new("TextButton")
    kbtn.Size = UDim2.new(0, 80, 0, 26)
    kbtn.Position = UDim2.new(1, -96, 0.5, -13)
    kbtn.BackgroundColor3 = T.Off
    kbtn.Text = tostring(userSettings.ToggleKey)
    kbtn.Font = Enum.Font.GothamBold
    kbtn.TextSize = 11
    kbtn.TextColor3 = T.Accent2
    kbtn.Parent = f
    Instance.new("UICorner", kbtn).CornerRadius = UDim.new(0, 5)
    local conn
    kbtn.MouseButton1Click:Connect(function()
        kbtn.Text = "..."
        if conn then conn:Disconnect() end
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                userSettings.ToggleKey = input.KeyCode.Name
                kbtn.Text = input.KeyCode.Name
                KeyHint.Text = input.KeyCode.Name .. " = Toggle"
                conn:Disconnect(); conn = nil
            end
        end)
    end)
end

local function makeActionBtn(parent, text, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCardHover
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local abtn = Instance.new("TextButton")
    abtn.Size = UDim2.new(1, 0, 1, 0)
    abtn.BackgroundTransparency = 1
    abtn.Text = text
    abtn.Font = Enum.Font.GothamBold
    abtn.TextSize = 13
    abtn.TextColor3 = T.White
    abtn.Parent = f
    abtn.MouseButton1Click:Connect(function() callback(abtn) end)
end

local function spacer(parent)
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, 0, 0, 4)
    s.BackgroundTransparency = 1
end

makeHeader("── UI SETTINGS", SScroll)
makeKeybindSetting(SScroll, "Toggle GUI Keybind")
spacer(SScroll)
makeHeader("── FILTERS", SScroll)
makeToggle(SScroll, "Receive Peaklights", "Peaklights")
makeToggle(SScroll, "Receive Highlights", "Highlights")
makeToggle(SScroll, "Receive Midlights",  "Midlights")
makeToggle(SScroll, "Receive Lowlights",  "Lowlights")
makeToggle(SScroll, "Receive Steals",     "Steals")
makeValueInput(SScroll, "Minimum Value ($/s)", "MinValue")
spacer(SScroll)
makeHeader("── NOTIFICATIONS", SScroll)
makeToggle(SScroll, "Play Sound on New Log", "PlaySound")
spacer(SScroll)
makeHeader("── JOIN SETTINGS", SScroll)
makeInput(SScroll, "Join Spam Retries", "AutoJoinRetries")
spacer(SScroll)
makeHeader("── DATA", SScroll)
makeActionBtn(SScroll, "Save All Settings", function(b)
    local orig = b.Text; b.Text = "Saving..."
    pcall(function() if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(userSettings)) end end)
    task.delay(0.5, function() b.Text = "Saved!" task.delay(1, function() b.Text = orig end) end)
end)

-- ════════════════════════════════════════════════════
--   LOGS PAGE
-- ════════════════════════════════════════════════════
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundTransparency = 1
TopBar.Parent = LogsPage

-- AutoJoin panel
local ajPanel = Instance.new("Frame")
ajPanel.Size = UDim2.new(1, -95, 0, 36)
ajPanel.Position = UDim2.new(0, 15, 0, 10)
ajPanel.BackgroundColor3 = T.BgCard
ajPanel.Parent = TopBar
Instance.new("UICorner", ajPanel).CornerRadius = UDim.new(0, 8)
local ajStroke = Instance.new("UIStroke")
ajStroke.Color = T.Off
ajStroke.Thickness = 1
ajStroke.Parent = ajPanel
local ajPulse = Instance.new("Frame")
ajPulse.Size = UDim2.new(0, 8, 0, 8)
ajPulse.Position = UDim2.new(0, 12, 0.5, -4)
ajPulse.BackgroundColor3 = T.Off
ajPulse.Parent = ajPanel
Instance.new("UICorner", ajPulse).CornerRadius = UDim.new(1, 0)
local ajLbl = Instance.new("TextLabel")
ajLbl.Size = UDim2.new(0, 110, 1, 0)
ajLbl.Position = UDim2.new(0, 28, 0, 0)
ajLbl.BackgroundTransparency = 1
ajLbl.Text = "Auto-Join"
ajLbl.Font = Enum.Font.GothamBold
ajLbl.TextXAlignment = Enum.TextXAlignment.Left
ajLbl.TextSize = 13
ajLbl.TextColor3 = T.White
ajLbl.Parent = ajPanel
local ajStatus = Instance.new("TextLabel")
ajStatus.Size = UDim2.new(0, 120, 1, 0)
ajStatus.Position = UDim2.new(0, 140, 0, 0)
ajStatus.BackgroundTransparency = 1
ajStatus.Text = ""
ajStatus.Font = Enum.Font.GothamBold
ajStatus.TextXAlignment = Enum.TextXAlignment.Left
ajStatus.TextSize = 12
ajStatus.TextColor3 = T.Green
ajStatus.Parent = ajPanel
local ajTrack = Instance.new("TextButton")
ajTrack.Size = UDim2.new(0, 42, 0, 22)
ajTrack.Position = UDim2.new(1, -56, 0.5, -11)
ajTrack.BackgroundColor3 = userSettings.AutoJoin and T.Accent1 or T.Off
ajTrack.Text = ""
ajTrack.Parent = ajPanel
Instance.new("UICorner", ajTrack).CornerRadius = UDim.new(1, 0)
local ajDot = Instance.new("Frame")
ajDot.Size = UDim2.new(0, 16, 0, 16)
ajDot.Position = userSettings.AutoJoin and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)
ajDot.BackgroundColor3 = T.White
ajDot.Parent = ajTrack
Instance.new("UICorner", ajDot).CornerRadius = UDim.new(1, 0)

updateAJVisuals = function(on)
    TweenService:Create(ajDot, TweenInfo.new(0.15, Enum.EasingStyle.Quad),
        {Position = on and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)}):Play()
    TweenService:Create(ajTrack, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    TweenService:Create(ajPulse, TweenInfo.new(0.2), {BackgroundColor3 = on and T.Green or T.Off}):Play()
    TweenService:Create(ajStroke, TweenInfo.new(0.2), {Color = on and T.Accent1 or T.Off}):Play()
    ajStatus.Text = on and "Waiting for logs..." or ""
    ajStatus.TextColor3 = T.TextDim
end
ajTrack.MouseButton1Click:Connect(function()
    userSettings.AutoJoin = not userSettings.AutoJoin
    updateAJVisuals(userSettings.AutoJoin)
end)

-- Feed status pill (top-right of TopBar)
local feedPill = Instance.new("Frame")
feedPill.Size = UDim2.new(0, 76, 0, 26)
feedPill.Position = UDim2.new(1, -88, 0.5, -13)
feedPill.BackgroundColor3 = T.BgCard
feedPill.Parent = TopBar
Instance.new("UICorner", feedPill).CornerRadius = UDim.new(0, 13)
local feedDot = Instance.new("Frame")
feedDot.Size = UDim2.new(0, 7, 0, 7)
feedDot.Position = UDim2.new(0, 8, 0.5, -3.5)
feedDot.BackgroundColor3 = T.Off
feedDot.Parent = feedPill
Instance.new("UICorner", feedDot).CornerRadius = UDim.new(1, 0)
local feedLbl = Instance.new("TextLabel")
feedLbl.Size = UDim2.new(1, -22, 1, 0)
feedLbl.Position = UDim2.new(0, 20, 0, 0)
feedLbl.BackgroundTransparency = 1
feedLbl.Text = "Live"
feedLbl.Font = Enum.Font.GothamBold
feedLbl.TextSize = 10
feedLbl.TextColor3 = T.Off
feedLbl.TextXAlignment = Enum.TextXAlignment.Left
feedLbl.Parent = feedPill

local feedShownTotal = 0  -- incremented in handleFindings for each displayed item
local function flashFeed(newThisPoll)
    if newThisPoll > 0 then
        feedDot.BackgroundColor3 = T.Green
        feedLbl.TextColor3 = T.Green
        feedLbl.Text = feedShownTotal .. " new"
        task.delay(2, function()
            feedDot.BackgroundColor3 = T.Off
            feedLbl.TextColor3 = T.Off
            feedLbl.Text = "Live"
        end)
    else
        -- pulse blue just to show the feed is connected and polling
        feedDot.BackgroundColor3 = ESP_BLUE
        task.delay(0.25, function() feedDot.BackgroundColor3 = T.Off end)
    end
end

-- Logs scroll area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, 0, 1, -55)
Content.Position = UDim2.new(0, 0, 0, 52)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = T.Off
Content.Parent = LogsPage
local CLayout = Instance.new("UIListLayout")
CLayout.Parent = Content
CLayout.Padding = UDim.new(0, 6)
CLayout.SortOrder = Enum.SortOrder.LayoutOrder
local CPad = Instance.new("UIPadding")
CPad.PaddingLeft = UDim.new(0, 15)
CPad.PaddingRight = UDim.new(0, 15)
CPad.PaddingTop = UDim.new(0, 4)
CPad.Parent = Content
CLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, CLayout.AbsoluteContentSize.Y + 10)
end)

-- ════════════════════════════════════════════════════
--   WHITELIST PAGE
-- ════════════════════════════════════════════════════
local WLTop = Instance.new("Frame")
WLTop.Size = UDim2.new(1, 0, 0, 55)
WLTop.BackgroundTransparency = 1
WLTop.Parent = WhitelistPage
local wlPanel = Instance.new("Frame")
wlPanel.Size = UDim2.new(1, -95, 0, 36)
wlPanel.Position = UDim2.new(0, 15, 0, 10)
wlPanel.BackgroundColor3 = T.BgCard
wlPanel.Parent = WLTop
Instance.new("UICorner", wlPanel).CornerRadius = UDim.new(0, 8)
local wlStroke = Instance.new("UIStroke")
wlStroke.Color = T.Off
wlStroke.Thickness = 1
wlStroke.Parent = wlPanel
local wlLbl = Instance.new("TextLabel")
wlLbl.Size = UDim2.new(0, 90, 1, 0)
wlLbl.Position = UDim2.new(0, 14, 0, 0)
wlLbl.BackgroundTransparency = 1
wlLbl.Text = "Use Whitelist"
wlLbl.Font = Enum.Font.GothamBold
wlLbl.TextXAlignment = Enum.TextXAlignment.Left
wlLbl.TextSize = 12
wlLbl.TextColor3 = T.White
wlLbl.Parent = wlPanel
local wlTrack = Instance.new("TextButton")
wlTrack.Size = UDim2.new(0, 32, 0, 18)
wlTrack.Position = UDim2.new(0, 106, 0.5, -9)
wlTrack.BackgroundColor3 = userSettings.UseWhitelist and T.Accent1 or T.Off
wlTrack.Text = ""
wlTrack.Parent = wlPanel
Instance.new("UICorner", wlTrack).CornerRadius = UDim.new(1, 0)
local wlDot = Instance.new("Frame")
wlDot.Size = UDim2.new(0, 12, 0, 12)
wlDot.Position = userSettings.UseWhitelist and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)
wlDot.BackgroundColor3 = T.White
wlDot.Parent = wlTrack
Instance.new("UICorner", wlDot).CornerRadius = UDim.new(1, 0)
wlTrack.MouseButton1Click:Connect(function()
    userSettings.UseWhitelist = not userSettings.UseWhitelist
    local on = userSettings.UseWhitelist
    TweenService:Create(wlDot, TweenInfo.new(0.15, Enum.EasingStyle.Quad),
        {Position = on and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)}):Play()
    TweenService:Create(wlTrack, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    TweenService:Create(wlStroke, TweenInfo.new(0.2), {Color = on and T.Accent1 or T.Off}):Play()
end)
local WLAll = Instance.new("TextButton")
WLAll.Size = UDim2.new(0, 30, 0, 20)
WLAll.Position = UDim2.new(0, 146, 0.5, -10)
WLAll.BackgroundColor3 = T.GreenDim
WLAll.Text = "All"
WLAll.Font = Enum.Font.GothamBold
WLAll.TextSize = 10
WLAll.TextColor3 = T.Green
WLAll.Parent = wlPanel
Instance.new("UICorner", WLAll).CornerRadius = UDim.new(0, 4)
local WLNone = Instance.new("TextButton")
WLNone.Size = UDim2.new(0, 40, 0, 20)
WLNone.Position = UDim2.new(0, 180, 0.5, -10)
WLNone.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
WLNone.Text = "None"
WLNone.Font = Enum.Font.GothamBold
WLNone.TextSize = 10
WLNone.TextColor3 = T.Red
WLNone.Parent = wlPanel
Instance.new("UICorner", WLNone).CornerRadius = UDim.new(0, 4)
local WLSearch = Instance.new("TextBox")
WLSearch.Size = UDim2.new(0, 95, 0, 24)
WLSearch.Position = UDim2.new(1, -105, 0.5, -12)
WLSearch.BackgroundColor3 = T.BgDark
WLSearch.Text = ""
WLSearch.PlaceholderText = "Search..."
WLSearch.Font = Enum.Font.Gotham
WLSearch.TextSize = 11
WLSearch.TextColor3 = T.White
WLSearch.Parent = wlPanel
Instance.new("UICorner", WLSearch).CornerRadius = UDim.new(0, 5)
local WLContent = Instance.new("ScrollingFrame")
WLContent.Size = UDim2.new(1, 0, 1, -55)
WLContent.Position = UDim2.new(0, 0, 0, 52)
WLContent.BackgroundTransparency = 1
WLContent.BorderSizePixel = 0
WLContent.ScrollBarThickness = 2
WLContent.ScrollBarImageColor3 = T.Off
WLContent.Parent = WhitelistPage
local WLLayout = Instance.new("UIListLayout")
WLLayout.Parent = WLContent
WLLayout.Padding = UDim.new(0, 5)
local WLPad = Instance.new("UIPadding")
WLPad.PaddingLeft = UDim.new(0, 15)
WLPad.PaddingRight = UDim.new(0, 15)
WLPad.PaddingTop = UDim.new(0, 4)
WLPad.Parent = WLContent
WLLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    WLContent.CanvasSize = UDim2.new(0, 0, 0, WLLayout.AbsoluteContentSize.Y + 10)
end)
local wlItems = {}
local function createWLEntry(name)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = T.BgCard
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -60, 1, 0)
    lbl2.Position = UDim2.new(0, 12, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = name
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 12
    lbl2.TextColor3 = T.White
    lbl2.Parent = f
    local wtrack = Instance.new("TextButton")
    wtrack.Size = UDim2.new(0, 32, 0, 18)
    wtrack.Position = UDim2.new(1, -44, 0.5, -9)
    wtrack.BackgroundColor3 = userSettings.Whitelist[name] and T.Accent1 or T.Off
    wtrack.Text = ""
    wtrack.Parent = f
    Instance.new("UICorner", wtrack).CornerRadius = UDim.new(1, 0)
    local wdot = Instance.new("Frame")
    wdot.Size = UDim2.new(0, 12, 0, 12)
    wdot.Position = userSettings.Whitelist[name] and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)
    wdot.BackgroundColor3 = T.White
    wdot.Parent = wtrack
    Instance.new("UICorner", wdot).CornerRadius = UDim.new(1, 0)
    local function setVisuals(on, anim)
        if anim then
            TweenService:Create(wdot, TweenInfo.new(0.15), {Position=on and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)}):Play()
            TweenService:Create(wtrack, TweenInfo.new(0.15), {BackgroundColor3=on and T.Accent1 or T.Off}):Play()
        else
            wdot.Position = on and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)
            wtrack.BackgroundColor3 = on and T.Accent1 or T.Off
        end
    end
    wtrack.MouseButton1Click:Connect(function()
        userSettings.Whitelist[name] = not userSettings.Whitelist[name]
        setVisuals(userSettings.Whitelist[name], true)
    end)
    f.Parent = WLContent
    return {frame=f, name=string.lower(name), rawName=name, update=setVisuals}
end
for _, v in ipairs(allBrainrots) do
    table.insert(wlItems, createWLEntry(v))
end
WLSearch.Changed:Connect(function(prop)
    if prop == "Text" then
        local q = string.lower(WLSearch.Text)
        for _, itm in ipairs(wlItems) do
            itm.frame.Visible = (q == "" or string.find(itm.name, q, 1, true))
        end
    end
end)
WLAll.MouseButton1Click:Connect(function()
    for _, itm in ipairs(wlItems) do
        if itm.frame.Visible then userSettings.Whitelist[itm.rawName]=true; itm.update(true,true) end
    end
end)
WLNone.MouseButton1Click:Connect(function()
    for _, itm in ipairs(wlItems) do
        if itm.frame.Visible then userSettings.Whitelist[itm.rawName]=false; itm.update(false,true) end
    end
end)

-- ════════════════════════════════════════════════════
--   JOIN / SPAM LOGIC
-- ════════════════════════════════════════════════════
local currentlyJoining = false
local function performJoinSpam(jobId)
    if currentlyJoining then return end
    currentlyJoining = true
    ajStatus.Text = "Joining..."; ajStatus.TextColor3 = T.Green
    task.spawn(function()
        local dots = {"Joining.","Joining..","Joining..."}; local i = 1
        while currentlyJoining and _G.MegalodonRunning do
            ajStatus.Text = dots[i]; i = i%3+1; task.wait(0.4)
        end
    end)
    task.spawn(function()
        local attempts = tonumber(userSettings.AutoJoinRetries) or 3
        for j = 1, attempts do
            if not _G.MegalodonRunning then break end
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, lp) end)
            task.wait(3)
        end
        currentlyJoining = false
        if userSettings.AutoJoin then ajStatus.Text="Waiting for logs..."; ajStatus.TextColor3=T.TextDim
        else ajStatus.Text="" end
    end)
end

-- ════════════════════════════════════════════════════
--   LOG CARDS
-- ════════════════════════════════════════════════════
local tierOrder = {peaklights=-300000, steals=-250000, highlights=-200000, midlights=-100000, lowlights=0}
local tierCount = {peaklights=0, steals=0, highlights=0, midlights=0, lowlights=0}
local activeLogs = {}
local MAX_LOGS = 150

local function addLogEntry(data)
    local tier = tostring(data.tier or "midlights"):lower()
    local col  = tierColor(tier)
    tierCount[tier] = (tierCount[tier] or 0) + 1
    local baseOrder = tierOrder[tier] or -100000
    local order = baseOrder - tierCount[tier]

    if #activeLogs > MAX_LOGS then
        local oldest = table.remove(activeLogs, 1)
        if oldest and oldest.card and oldest.card.Parent then oldest.card:Destroy() end
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 52)
    card.BackgroundColor3 = T.BgCard
    card.LayoutOrder = order
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local tierBar = Instance.new("Frame")
    tierBar.Size = UDim2.new(0, 3, 0.65, 0)
    tierBar.Position = UDim2.new(0, 0, 0.175, 0)
    tierBar.BackgroundColor3 = col
    tierBar.Parent = card
    Instance.new("UICorner", tierBar).CornerRadius = UDim.new(1, 0)

    if tier == "peaklights" or tier == "highlights" or tier == "steals" then
        local hlGlow = Instance.new("UIStroke")
        hlGlow.Thickness = 1
        hlGlow.Color = col
        hlGlow.Transparency = 0.55
        hlGlow.Parent = card
    end

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -130, 0, 18)
    nameL.Position = UDim2.new(0, 12, 0, 7)
    nameL.BackgroundTransparency = 1
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.TextTruncate = Enum.TextTruncate.AtEnd
    nameL.Text = data.name or "Unknown"
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 13
    nameL.TextColor3 = T.White
    nameL.Parent = card

    local baseStr = fmtValue(data.value or 0) .. "  ·  " .. tierLabel(tier)
    local valL = Instance.new("TextLabel")
    valL.Size = UDim2.new(1, -130, 0, 14)
    valL.Position = UDim2.new(0, 12, 0, 28)
    valL.BackgroundTransparency = 1
    valL.TextXAlignment = Enum.TextXAlignment.Left
    valL.Text = baseStr .. "  •  0s ago"
    valL.Font = Enum.Font.Gotham
    valL.TextSize = 11
    valL.TextColor3 = col
    valL.Parent = card

    table.insert(activeLogs, {label=valL, baseStr=baseStr, ts=data.timestamp or math.floor(os.time()), card=card})

    -- JOIN button
    local jBtn = Instance.new("TextButton")
    jBtn.Size = UDim2.new(0, 48, 0, 26)
    jBtn.Position = UDim2.new(1, -110, 0.5, -13)
    jBtn.BackgroundColor3 = T.Green
    jBtn.Text = "JOIN"
    jBtn.Font = Enum.Font.GothamBold
    jBtn.TextSize = 10
    jBtn.TextColor3 = T.White
    jBtn.Parent = card
    Instance.new("UICorner", jBtn).CornerRadius = UDim.new(0, 5)

    -- SPAM button
    local sBtn = Instance.new("TextButton")
    sBtn.Size = UDim2.new(0, 48, 0, 26)
    sBtn.Position = UDim2.new(1, -58, 0.5, -13)
    sBtn.BackgroundColor3 = T.Red
    sBtn.Text = "SPAM"
    sBtn.Font = Enum.Font.GothamBold
    sBtn.TextSize = 10
    sBtn.TextColor3 = T.White
    sBtn.Parent = card
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 5)

    card.Parent = Content

    jBtn.MouseButton1Click:Connect(function()
        if data.jobId and data.jobId ~= "" then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, data.jobId, lp) end)
            jBtn.Text = "..."; jBtn.BackgroundColor3 = T.Accent1
            task.delay(1.5, function() jBtn.Text="JOIN"; jBtn.BackgroundColor3=T.Green end)
        end
    end)
    sBtn.MouseButton1Click:Connect(function()
        if data.jobId and data.jobId ~= "" then performJoinSpam(data.jobId) end
    end)
end

-- ════════════════════════════════════════════════════
--   NOTIFICATIONS (pop-up toasts)
-- ════════════════════════════════════════════════════
local NC = Instance.new("Frame")
NC.Name = "NotifContainer"
NC.Size = UDim2.new(0, 260, 1, -40)
NC.Position = UDim2.new(1, -280, 0, 20)
NC.BackgroundTransparency = 1
NC.Parent = Gui
local NLayout = Instance.new("UIListLayout")
NLayout.Parent = NC
NLayout.SortOrder = Enum.SortOrder.LayoutOrder
NLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NLayout.Padding = UDim.new(0, 8)

local function pushNotification(data)
    playNotifSound()
    local col = tierColor(tostring(data.tier or ""):lower())
    local f = Instance.new("TextButton")
    f.Size = UDim2.new(1, 0, 0, 52)
    f.BackgroundColor3 = T.BgMid
    f.BackgroundTransparency = 1
    f.Text = ""
    f.AutoButtonColor = false
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local nStroke = Instance.new("UIStroke")
    nStroke.Thickness = 1; nStroke.Color = col; nStroke.Transparency = 1; nStroke.Parent = f
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0.65, 0)
    bar.Position = UDim2.new(0, 6, 0.175, 0)
    bar.BackgroundColor3 = col; bar.BackgroundTransparency = 1; bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1, -85, 0, 16); nt.Position = UDim2.new(0, 16, 0, 8)
    nt.BackgroundTransparency = 1; nt.TextXAlignment = Enum.TextXAlignment.Left
    nt.TextTruncate = Enum.TextTruncate.AtEnd
    nt.Text = data.name or "Unknown"; nt.Font = Enum.Font.GothamBold
    nt.TextSize = 12; nt.TextColor3 = T.White; nt.TextTransparency = 1
    nt.Parent = f; nt.ZIndex = 2
    local diff = math.max(0, math.floor(os.time()) - (data.timestamp or math.floor(os.time())))
    local tStr = diff < 60 and diff.."s ago" or math.floor(diff/60).."m ago"
    local nv = Instance.new("TextLabel")
    nv.Size = UDim2.new(1, -85, 0, 14); nv.Position = UDim2.new(0, 16, 0, 27)
    nv.BackgroundTransparency = 1; nv.TextXAlignment = Enum.TextXAlignment.Left
    nv.Text = fmtValue(data.value or 0) .. "  ·  " .. tierLabel(tostring(data.tier or ""):lower()) .. "  •  " .. tStr
    nv.Font = Enum.Font.Gotham; nv.TextSize = 10; nv.TextColor3 = T.TextDim; nv.TextTransparency = 1
    nv.Parent = f; nv.ZIndex = 2
    local jn = Instance.new("TextButton")
    jn.Size = UDim2.new(0, 44, 0, 22); jn.Position = UDim2.new(1, -54, 0.5, -11)
    jn.BackgroundColor3 = T.Accent1; jn.BackgroundTransparency = 1; jn.Text = "JOIN"
    jn.Font = Enum.Font.GothamBold; jn.TextSize = 10; jn.TextColor3 = T.Accent2; jn.TextTransparency = 1
    jn.AutoButtonColor = false; jn.Parent = f; jn.ZIndex = 2
    Instance.new("UICorner", jn).CornerRadius = UDim.new(0, 5)
    f.Parent = NC
    local function doJoin()
        if data.jobId and data.jobId ~= "" then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, data.jobId, lp) end)
            jn.Text = "..."
        end
    end
    f.MouseButton1Click:Connect(doJoin)
    jn.MouseButton1Click:Connect(doJoin)
    TweenService:Create(f, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {BackgroundTransparency=0.05}):Play()
    TweenService:Create(nStroke, TweenInfo.new(0.35), {Transparency=0.6}):Play()
    TweenService:Create(bar, TweenInfo.new(0.35), {BackgroundTransparency=0}):Play()
    TweenService:Create(nt, TweenInfo.new(0.35), {TextTransparency=0}):Play()
    TweenService:Create(nv, TweenInfo.new(0.35), {TextTransparency=0}):Play()
    TweenService:Create(jn, TweenInfo.new(0.35), {TextTransparency=0,BackgroundTransparency=0.15}):Play()
    task.delay(4.5, function()
        if f and f.Parent then
            TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
            TweenService:Create(nStroke, TweenInfo.new(0.3), {Transparency=1}):Play()
            TweenService:Create(bar, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
            TweenService:Create(nt, TweenInfo.new(0.3), {TextTransparency=1}):Play()
            TweenService:Create(nv, TweenInfo.new(0.3), {TextTransparency=1}):Play()
            local fo = TweenService:Create(jn, TweenInfo.new(0.3), {TextTransparency=1,BackgroundTransparency=1})
            fo:Play(); fo.Completed:Connect(function() f:Destroy() end)
        end
    end)
end

-- ════════════════════════════════════════════════════
--   ESP  (Megalodon User badge — self = blue, others = blue)
-- ════════════════════════════════════════════════════
local espStrokes = {} -- kept for compatibility

local function attachESP(char, labelText)
    task.spawn(function()
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild("MF_USER_ESP") then head.MF_USER_ESP:Destroy() end
        local bg = Instance.new("BillboardGui")
        bg.Name = "MF_USER_ESP"
        bg.Size = UDim2.new(0, 160, 0, 30)
        bg.StudsOffset = Vector3.new(0, 2.8, 0)
        bg.AlwaysOnTop = true
        bg.Parent = head
        local badge = Instance.new("Frame")
        badge.Size = UDim2.new(1, 0, 1, 0)
        badge.BackgroundColor3 = Color3.fromRGB(8, 12, 21)
        badge.BackgroundTransparency = 0.25
        badge.Parent = bg
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
        local bStroke = Instance.new("UIStroke")
        bStroke.Thickness = 1.5
        bStroke.Color = ESP_BLUE
        bStroke.Parent = badge
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = labelText or "Megalodon User"
        txt.Font = Enum.Font.GothamBlack
        txt.TextSize = 12
        txt.TextColor3 = ESP_BLUE
        txt.Parent = badge
    end)
end

if lp.Character then attachESP(lp.Character, "Megalodon User") end
lp.CharacterAdded:Connect(function(c) attachESP(c, "Megalodon User") end)

-- Poll AJ list → ESP any co-users in the same Roblox server
task.spawn(function()
    while _G.MegalodonRunning do
        pcall(function()
            local body = httpGet(AJ_LIST_URL)
            if not body then return end
            local data = decodeJson(body)
            if not (data and data.users) then return end
            local activeSet = {}
            for _, uname in ipairs(data.users) do
                activeSet[tostring(uname):lower()] = true
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and activeSet[p.Name:lower()] then
                    local char = p.Character
                    if char then
                        local head = char:FindFirstChild("Head")
                        if head and not head:FindFirstChild("MF_USER_ESP") then
                            attachESP(char, "Megalodon User")
                        end
                    end
                end
            end
        end)
        task.wait(AJ_REFRESH_S)
    end
end)

-- ════════════════════════════════════════════════════
--   AUTO-REJOIN ON TELEPORT
-- ════════════════════════════════════════════════════
do
    local code = string.format('loadstring(game:HttpGet(%q))()', LOADSTRING_URL)
    if queue_on_teleport then pcall(function() queue_on_teleport(code) end)
    elseif syn and syn.queue_on_teleport then pcall(function() syn.queue_on_teleport(code) end) end
end

-- ════════════════════════════════════════════════════
--   KEY GATE  (self-hosted)
-- ════════════════════════════════════════════════════
local function verifyKey(key)
    if type(key) ~= "string" or #key < 4 then return false end
    local url = KEY_VERIFY_URL .. "?key=" .. HttpService:UrlEncode(key)
              .. "&user=" .. HttpService:UrlEncode(lp.Name)
    local body = httpGet(url)
    if not body then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    return ok and type(data) == "table" and data.valid == true
end
local function loadSavedKey()
    local ok, data = pcall(function()
        if isfile and isfile(KEY_FILE) then return readfile(KEY_FILE) end
    end)
    if ok and type(data) == "string" and #data >= 4 then return data:gsub("%s+","") end
    return nil
end
local function saveKey(key) pcall(function() writefile(KEY_FILE, key) end) end

local keyValid = false
do
    local saved = loadSavedKey()
    if saved then
        local checking = true
        task.spawn(function() keyValid = verifyKey(saved); checking = false end)
        local deadline = os.clock() + 7
        while checking and os.clock() < deadline do task.wait(0.05) end
    end
    if not keyValid then
        -- Key gate UI in Megalodon style
        local KG = Instance.new("ScreenGui")
        KG.Name = "MF_KeyGate"
        KG.ResetOnSpawn = false
        KG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        KG.Parent = CoreGui
        if syn and syn.protect_gui then syn.protect_gui(KG) end

        local KMain = Instance.new("Frame")
        KMain.Size = UDim2.new(0, 400, 0, 230)
        KMain.Position = UDim2.new(0.5, -200, 0.5, -115)
        KMain.BackgroundColor3 = T.BgDark
        KMain.BorderSizePixel = 0
        KMain.ClipsDescendants = true
        KMain.Parent = KG
        Instance.new("UICorner", KMain).CornerRadius = UDim.new(0, 12)
        local kStroke = Instance.new("UIStroke")
        kStroke.Thickness = 2; kStroke.Color = T.Accent1; kStroke.Transparency = 0.2; kStroke.Parent = KMain

        local kHdr = Instance.new("Frame")
        kHdr.Size = UDim2.new(1, 0, 0, 50)
        kHdr.BackgroundColor3 = T.Sidebar
        kHdr.BorderSizePixel = 0
        kHdr.Parent = KMain
        Instance.new("UICorner", kHdr).CornerRadius = UDim.new(0, 12)
        local kHdrFix = Instance.new("Frame")
        kHdrFix.Size = UDim2.new(1, 0, 0.5, 0)
        kHdrFix.Position = UDim2.new(0, 0, 0.5, 0)
        kHdrFix.BackgroundColor3 = T.Sidebar; kHdrFix.BorderSizePixel = 0; kHdrFix.Parent = kHdr

        local kTitle = Instance.new("TextLabel")
        kTitle.Size = UDim2.new(1, -20, 1, 0); kTitle.Position = UDim2.new(0, 18, 0, 0)
        kTitle.BackgroundTransparency = 1; kTitle.TextXAlignment = Enum.TextXAlignment.Left
        kTitle.Text = "🔑  Megalodon Finder — Key Required"
        kTitle.Font = Enum.Font.GothamBold; kTitle.TextSize = 14; kTitle.TextColor3 = T.White; kTitle.Parent = kHdr

        local kSub = Instance.new("TextLabel")
        kSub.Size = UDim2.new(1, -36, 0, 18); kSub.Position = UDim2.new(0, 18, 0, 58)
        kSub.BackgroundTransparency = 1; kSub.TextXAlignment = Enum.TextXAlignment.Left
        kSub.Text = "Enter your Megalodon key to unlock Join & Spam."
        kSub.Font = Enum.Font.Gotham; kSub.TextSize = 12; kSub.TextColor3 = T.TextDim; kSub.Parent = KMain

        local kBox = Instance.new("TextBox")
        kBox.Size = UDim2.new(1, -36, 0, 36); kBox.Position = UDim2.new(0, 18, 0, 84)
        kBox.BackgroundColor3 = T.BgMid; kBox.Text = ""
        kBox.PlaceholderText = "Paste your key here…"
        kBox.Font = Enum.Font.Gotham; kBox.TextSize = 13; kBox.TextColor3 = T.White
        kBox.ClearTextOnFocus = false; kBox.BorderSizePixel = 0; kBox.Parent = KMain
        Instance.new("UICorner", kBox).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", kBox).Color = T.Off
        local kBoxPad = Instance.new("UIPadding", kBox)
        kBoxPad.PaddingLeft = UDim.new(0, 10); kBoxPad.PaddingRight = UDim.new(0, 10)

        local kStatus = Instance.new("TextLabel")
        kStatus.Size = UDim2.new(1, -36, 0, 16); kStatus.Position = UDim2.new(0, 18, 0, 128)
        kStatus.BackgroundTransparency = 1; kStatus.TextXAlignment = Enum.TextXAlignment.Left
        kStatus.Text = ""; kStatus.Font = Enum.Font.Gotham; kStatus.TextSize = 11; kStatus.TextColor3 = T.Red; kStatus.Parent = KMain

        local kConfirm = Instance.new("TextButton")
        kConfirm.Size = UDim2.new(0, 150, 0, 36); kConfirm.Position = UDim2.new(0, 18, 0, 152)
        kConfirm.BackgroundColor3 = T.Accent1; kConfirm.Text = "Verify Key"
        kConfirm.Font = Enum.Font.GothamBold; kConfirm.TextSize = 13; kConfirm.TextColor3 = T.White
        kConfirm.BorderSizePixel = 0; kConfirm.Parent = KMain
        Instance.new("UICorner", kConfirm).CornerRadius = UDim.new(0, 8)

        local kDisc = Instance.new("TextButton")
        kDisc.Size = UDim2.new(0, 150, 0, 36); kDisc.Position = UDim2.new(0, 178, 0, 152)
        kDisc.BackgroundColor3 = T.BgCardHover; kDisc.Text = "Get Key →"
        kDisc.Font = Enum.Font.GothamBold; kDisc.TextSize = 13; kDisc.TextColor3 = T.Accent2
        kDisc.BorderSizePixel = 0; kDisc.Parent = KMain
        Instance.new("UICorner", kDisc).CornerRadius = UDim.new(0, 8)
        kDisc.MouseButton1Click:Connect(function()
            local clip = setclipboard or (syn and syn.write_clipboard) or toclipboard
            if clip then pcall(clip, "discord.gg/clearwaterjoiner") end
            kStatus.Text = "discord.gg/clearwaterjoiner → copied!"; kStatus.TextColor3 = T.Accent2
        end)

        local kClose = Instance.new("TextButton")
        kClose.Size = UDim2.new(0, 30, 0, 30); kClose.Position = UDim2.new(1, -42, 0, 10)
        kClose.BackgroundColor3 = T.BgCardHover; kClose.Text = "×"
        kClose.Font = Enum.Font.GothamBold; kClose.TextSize = 18; kClose.TextColor3 = T.Red
        kClose.BorderSizePixel = 0; kClose.Parent = KMain
        Instance.new("UICorner", kClose).CornerRadius = UDim.new(0, 8)
        kClose.MouseButton1Click:Connect(function() KG:Destroy() end)

        local checking = false
        local function doVerify()
            if checking then return end
            local key = kBox.Text:gsub("%s+","")
            if #key < 4 then kStatus.Text="Key is too short."; kStatus.TextColor3=T.Red; return end
            checking = true; kConfirm.Text = "Checking…"; kConfirm.Active = false; kStatus.Text = ""
            task.spawn(function()
                local ok = verifyKey(key)
                checking = false; kConfirm.Text = "Verify Key"; kConfirm.Active = true
                if ok then
                    keyValid = true; saveKey(key)
                    kStatus.Text = "✓ Key accepted!"; kStatus.TextColor3 = T.Green
                    task.wait(0.5); KG:Destroy()
                else
                    kStatus.Text = "✗ Invalid or expired key."; kStatus.TextColor3 = T.Red
                end
            end)
        end
        kConfirm.MouseButton1Click:Connect(doVerify)
        kBox.FocusLost:Connect(function(enter) if enter then doVerify() end end)
        while KG.Parent ~= nil and not keyValid do task.wait(0.1) end
    end
end

-- ════════════════════════════════════════════════════
--   AJ USERS REGISTRATION
-- ════════════════════════════════════════════════════
task.spawn(function()
    local who = HttpService:UrlEncode(lp.Name)
    while _G.MegalodonRunning do
        pcall(function() httpGet(AJ_REGISTER_URL .. "?u=" .. who) end)
        task.wait(300)
    end
end)

-- ════════════════════════════════════════════════════
--   CW PRESENCE HEARTBEAT
-- ════════════════════════════════════════════════════
task.spawn(function()
    while _G.MegalodonRunning do
        pcall(function() httpGet(CW_HEARTBEAT_URL .. "?u=" .. HttpService:UrlEncode(lp.Name)) end)
        task.wait(CW_PRESENCE_REFRESH_S)
    end
end)

-- ════════════════════════════════════════════════════
--   CHROMA BORDER LOOP
-- ════════════════════════════════════════════════════
task.spawn(function()
    while _G.MegalodonRunning do
        local tk = tick()
        local phase = (math.sin(tk * 0.8) + 1) / 2
        local r = math.floor(40  + phase * 100)
        local g = math.floor(100 + phase * 120)
        local b = math.floor(200 + phase * 55)
        local color = Color3.fromRGB(r, g, b)
        BorderGrad.Rotation = (tk * 60) % 360
        BorderGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 230, 255)),
            ColorSequenceKeypoint.new(1, color),
        }
        Logo.TextColor3 = color
        for k, v in pairs(tabButtons) do
            if k == curTab then v.ind.BackgroundColor3 = color end
        end
        if userSettings.AutoJoin then ajPulse.BackgroundColor3 = color end
        task.wait(0.04)
    end
end)

-- ════════════════════════════════════════════════════
--   TIME TICKER  (updates "Xs ago" on log cards)
-- ════════════════════════════════════════════════════
task.spawn(function()
    while _G.MegalodonRunning do
        local now = math.floor(os.time())
        for i = #activeLogs, 1, -1 do
            local ld = activeLogs[i]
            if not ld.label or not ld.label.Parent then
                table.remove(activeLogs, i)
            else
                local diff = math.max(0, now - ld.ts)
                local tStr = diff < 60 and diff.."s ago"
                    or diff < 3600 and math.floor(diff/60).."m ago"
                    or math.floor(diff/3600).."h ago"
                ld.label.Text = ld.baseStr .. "  •  " .. tStr
            end
        end
        task.wait(1)
    end
end)

-- ════════════════════════════════════════════════════
--   MAIN FEED POLL
-- ════════════════════════════════════════════════════
local seen    = {}
local isFirst = true

-- Build a stable dedup key even when the API item has no id field
local function itemKey(item)
    local id = item.id or item.Id
    if id ~= nil then return tostring(id) end
    -- fallback: name + approximate timestamp bucket (5-second window)
    local ts = tonumber(item.timestamp or item.ts or 0) or 0
    return tostring(item.name or "?") .. "_" .. tostring(math.floor(ts / 5))
end

local function handleFindings(findings)
    local newItems = {}
    for _, item in ipairs(findings) do
        local key = itemKey(item)
        if not seen[key] then
            -- NOTE: do NOT mark seen here; only mark seen after the item is actually displayed.
            -- This lets filter changes (e.g. enabling Lowlights) retroactively show items that
            -- arrived while the filter was off, preventing the "silent drain" bug.
            table.insert(newItems, item)
        end
    end
    -- sort oldest → newest so logs appear in order
    table.sort(newItems, function(a, b)
        local ta = tonumber(a.timestamp or a.ts or 0) or 0
        local tb = tonumber(b.timestamp or b.ts or 0) or 0
        return ta < tb
    end)

    local firstRun = isFirst
    if isFirst then isFirst = false end

    for _, item in ipairs(newItems) do
        local jid = tostring(item.jobId or item.job_id or "")
        if jid == "" then
            jid = pickJobId(tonumber(item.timestamp or item.ts) or 0)
        end
        local tier = routedTier(item.tier or "midlights", item.name or "")
        local tierKey = tier:sub(1,1):upper() .. tier:sub(2)
        local passFilter = userSettings[tierKey] ~= false

        -- Minimum value filter
        local minVal = tonumber(userSettings.MinValue) or 0
        if minVal > 0 and (tonumber(item.value) or 0) < minVal then
            passFilter = false
        end

        if userSettings.UseWhitelist then
            local wname = tostring(item.name or item.base_name or "")
            if not userSettings.Whitelist[wname] then passFilter = false end
        end

        if passFilter then
            seen[itemKey(item)] = true   -- mark seen only when actually displayed
            feedShownTotal = feedShownTotal + 1
            local entry = {
                name      = item.name or "Unknown",
                value     = tonumber(item.value or 0) or 0,
                tier      = tier,
                jobId     = jid,
                timestamp = tonumber(item.timestamp or item.ts) or math.floor(os.time()),
            }
            addLogEntry(entry)
            -- On the first batch: populate the log list silently (no sound/notification/autojoin)
            if not firstRun then
                pushNotification(entry)
                if userSettings.AutoJoin and jid ~= "" then
                    performJoinSpam(jid)
                end
            end
        end
    end
end

task.spawn(function()
    refreshBots(true)
    while _G.MegalodonRunning do
        refreshBots(false)
        local prevShown = feedShownTotal
        pcall(function()
            local body = httpGet(HTTP_URL .. "?t=" .. tostring(tick()))
            if not body then return end
            local data = decodeJson(body)
            if not data then return end
            local findings = data.findings or data.recent or (type(data) == "table" and data) or {}
            if type(findings) == "table" then handleFindings(findings) end
        end)
        pcall(flashFeed, feedShownTotal - prevShown)
        task.wait(POLL_INTERVAL)
    end
end)
