local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function getChar()
    if not player.Character then player.CharacterAdded:Wait() end
    return player.Character
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChild("Humanoid")
end

local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- INFINITE JUMP
-- ============================================================
local infJumpEnabled = false
local infJumpMode = "manual"
local jumpHeld = false
local lastJumpBoostTime = 0
local JUMP_BOOST_INTERVAL = 0.05
local infJumpThread = nil
local holdInfJumpConn = nil
local autoInfJumpConn = nil

userInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if infJumpEnabled and infJumpMode == "manual" and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        jumpHeld = true
    end
end)

userInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        jumpHeld = false
    end
end)

userInputService.JumpRequest:Connect(function()
    if infJumpEnabled and infJumpMode == "manual" then
        jumpHeld = true
        task.wait(0.05)
        jumpHeld = false
    end
end)

function startManualInfJump()
    if infJumpThread then return end
    infJumpThread = runService.Stepped:Connect(function()
        if not infJumpEnabled or infJumpMode ~= "manual" then return end
        if not jumpHeld then return end
        local now = tick()
        if now - lastJumpBoostTime < JUMP_BOOST_INTERVAL then return end
        lastJumpBoostTime = now
        local char = getChar()
        if not char then return end
        local hum = getHumanoid()
        local root = getHRP()
        if not hum or not root or hum.Health <= 0 then return end
        local vel = root.AssemblyLinearVelocity
        if vel.Y < 55 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 65, vel.Z)
        end
    end)
end

function stopManualInfJump()
    if infJumpThread then
        infJumpThread:Disconnect()
        infJumpThread = nil
    end
    jumpHeld = false
    lastJumpBoostTime = 0
end

function startHoldInfJump()
    if holdInfJumpConn then return end
    holdInfJumpConn = runService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode ~= "hold" then return end
        local char = getChar()
        if not char then return end
        local root = getHRP()
        local hum = getHumanoid()
        if not root or not hum then return end
        local isJumpHeld = userInputService:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < 35 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
        if root.Velocity.Y < -120 then
            root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
        end
    end)
end

function stopHoldInfJump()
    if holdInfJumpConn then
        holdInfJumpConn:Disconnect()
        holdInfJumpConn = nil
    end
end

function startAutoInfJump()
    if autoInfJumpConn then return end
    autoInfJumpConn = runService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode ~= "auto" then return end
        local char = getChar()
        if not char then return end
        local root = getHRP()
        local hum = getHumanoid()
        if not root or not hum then return end
        if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 60, root.AssemblyLinearVelocity.Z)
        end
    end)
end

function stopAutoInfJump()
    if autoInfJumpConn then
        autoInfJumpConn:Disconnect()
        autoInfJumpConn = nil
    end
end

function toggleInfJump()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        if infJumpMode == "manual" then startManualInfJump()
        elseif infJumpMode == "hold" then startHoldInfJump()
        elseif infJumpMode == "auto" then startAutoInfJump() end
    else
        stopManualInfJump(); stopHoldInfJump(); stopAutoInfJump()
    end
    return infJumpEnabled
end

function setInfJumpMode(mode)
    if mode ~= "manual" and mode ~= "hold" and mode ~= "auto" then return end
    local wasEnabled = infJumpEnabled
    if wasEnabled then
        stopManualInfJump(); stopHoldInfJump(); stopAutoInfJump()
    end
    infJumpMode = mode
    if wasEnabled then
        if mode == "manual" then startManualInfJump()
        elseif mode == "hold" then startHoldInfJump()
        elseif mode == "auto" then startAutoInfJump() end
    end
end

-- ============================================================
-- TP DOWN
-- ============================================================
function tpDownFast()
    local root = getHRP()
    if root then
        local targetY = root.Position.Y - (30 * 4.5)
        root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
    end
end

-- ============================================================
-- AUTO STEAL
-- ============================================================
local autoStealActive = false
local autoStealThread = nil
local stealRadius = 60
local stealDuration = 1.4

local function findStealPrompt()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name:lower():find("steal") then
            return obj
        end
    end
    return nil
end

local function fireProximityPrompt(prompt, duration)
    if prompt then
        prompt.HoldDuration = duration
        prompt:InputHoldBegin()
        task.wait(duration)
        prompt:InputHoldEnd()
    end
end

function toggleAutoSteal()
    autoStealActive = not autoStealActive
    if autoStealActive then
        if autoStealThread then task.cancel(autoStealThread) end
        autoStealThread = task.spawn(function()
            while autoStealActive do
                local prompt = findStealPrompt()
                if prompt then fireProximityPrompt(prompt, stealDuration) end
                task.wait(0.5)
            end
        end)
    else
        if autoStealThread then
            task.cancel(autoStealThread)
            autoStealThread = nil
        end
    end
    return autoStealActive
end

function setStealRadius(radius) stealRadius = radius end
function setStealDuration(duration) stealDuration = duration end

-- ============================================================
-- UI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OrvynTools"
screenGui.ResetOnSpawn = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 180, 220)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "⚡ ORVYN TOOLS ⚡"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -45)
scroll.Position = UDim2.new(0, 0, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = scroll

local function createDivider()
    local div = Instance.new("Frame")
    div.Size = UDim2.new(0.9, 0, 0, 1)
    div.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    div.BorderSizePixel = 0
    div.Parent = scroll
    return div
end

local function createToggle(text, getState, setState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = scroll

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 50, 0, 26)
    bg.Position = UDim2.new(1, -60, 0.5, -13)
    bg.BackgroundColor3 = getState() and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(35, 35, 55)
    bg.BorderSizePixel = 0
    bg.Parent = frame
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = getState() and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    local function update()
        local on = getState()
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = on and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(35, 35, 55)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = on and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)}):Play()
    end

    btn.MouseButton1Click:Connect(function()
        setState(not getState())
        update()
    end)

    return frame, update
end

local function createButton(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = scroll

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 1, -8)
    btn.Position = UDim2.new(0, 10, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 220)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(10, 10, 20)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return frame
end

local function createLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.95, 0, 0, 26)
    lbl.Position = UDim2.new(0.025, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 180, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = scroll
    return lbl
end

-- ============================================================
-- UI CONSTRUCTION
-- ============================================================
createLabel("=== INFINITE JUMP ===")
local infState = false
local _, updateInf = createToggle("Infinite Jump", function() return infJumpEnabled end, function(v)
    infJumpEnabled = v
    if infJumpEnabled then
        if infJumpMode == "manual" then startManualInfJump()
        elseif infJumpMode == "hold" then startHoldInfJump()
        elseif infJumpMode == "auto" then startAutoInfJump() end
    else
        stopManualInfJump(); stopHoldInfJump(); stopAutoInfJump()
    end
end)

createLabel("Jump Mode:")
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(0.95, 0, 0, 34)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = scroll

local modes = {"manual", "hold", "auto"}
local modeLabels = {"Manual", "Hold", "Auto"}
local modeIdx = 1
for i, m in ipairs(modes) do if m == infJumpMode then modeIdx = i end end

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.5, -10, 1, -6)
modeBtn.Position = UDim2.new(0.25, 0, 0, 3)
modeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
modeBtn.BorderSizePixel = 0
modeBtn.Text = modeLabels[modeIdx]
modeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
modeBtn.Font = Enum.Font.GothamBold
modeBtn.TextSize = 13
modeBtn.Parent = modeFrame
local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 8)
modeCorner.Parent = modeBtn

modeBtn.MouseButton1Click:Connect(function()
    modeIdx = modeIdx % #modes + 1
    modeBtn.Text = modeLabels[modeIdx]
    setInfJumpMode(modes[modeIdx])
end)

createDivider()

createLabel("=== TELEPORT ===")
createButton("⚡ TP DOWN ⚡", tpDownFast)
createDivider()

createLabel("=== AUTO STEAL ===")
local stealState = false
local _, updateSteal = createToggle("Auto Steal", function() return autoStealActive end, function(v)
    toggleAutoSteal()
end)
createButton("🔍 Find Steal Prompt", function()
    local p = findStealPrompt()
    if p then
        print("✅ Found prompt:", p.Parent and p.Parent.Name or "unknown")
        warn("📢 Prompt found! Auto Steal готов к работе")
    else
        warn("❌ Prompt NOT found! Убедись, что ты рядом с животным")
    end
end)

createDivider()
createLabel("⚙️ ORVYN TOOLS v1.0")
createLabel("💡 Перетащи окно за заголовок")

-- ============================================================
-- INIT
-- ============================================================
print("===== ORVYN TOOLS LOADED =====")
print("✅ Бесконечный прыжок (Toggle)")
print("✅ TP Down (кнопка)")
print("✅ Auto Steal (Toggle)")
print("===============================")
