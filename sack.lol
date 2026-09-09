local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

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

local function setWalkSpeed(speed)
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = speed end
end

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

local function getNearestPlayer()
    local nearest, dist = nil, math.huge
    local root = getHRP()
    if not root then return nil end
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                nearest = plr
            end
        end
    end
    return nearest
end

local function tpDownFast()
    local root = getHRP()
    if root then
        local targetY = root.Position.Y - (30 * 4.5)
        root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
    end
end

-- UI Creation
local UI = { UI = Instance.new("ScreenGui") }
UI.UI.Parent = player:WaitForChild("PlayerGui")
UI.UI.Name = "UI"
UI.UI.ResetOnSpawn = true

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 392, 0, 354)
panel.Position = UDim2.new(0.3, 0, 0.19, 0)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BackgroundTransparency = 0
panel.Parent = UI.UI
panel.Active = true
panel.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = panel

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Image = "rbxassetid://104661376291937"
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 165, 0, 52)
title.Position = UDim2.new(0.06, 0, 0.016, 0)
title.BackgroundTransparency = 1
title.Text = "Cosmic Duels"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.Unknown
title.Parent = bgImage

-- Tabs
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(0, 334, 0, 53)
tabs.Position = UDim2.new(0.066, 0, 0.812, 0)
tabs.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
tabs.BackgroundTransparency = 0.6
tabs.Parent = bgImage

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 15)
tabCorner.Parent = tabs

local function createTab(name, x)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 87, 0, 42)
    btn.Position = UDim2.new(x, 0, 0.094, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.8
    btn.Text = name
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Unknown
    btn.Parent = tabs
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 15)
    c.Parent = btn
    return btn
end

local mainTabBtn = createTab("Main", 0.036)
local miscTabBtn = createTab("Misc", 0.377)
local otherTabBtn = createTab("Other", 0.706)

-- Main Tab
local mainTab = Instance.new("Frame")
mainTab.Size = UDim2.new(0, 334, 0, 210)
mainTab.Position = UDim2.new(0.064, 0, 0.165, 0)
mainTab.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
mainTab.BackgroundTransparency = 0.6
mainTab.Parent = bgImage
local mtCorner = Instance.new("UICorner")
mtCorner.CornerRadius = UDim.new(0, 15)
mtCorner.Parent = mainTab

local function createLabel(parent, text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 150, 0, 37)
    lbl.Position = UDim2.new(0.038, 0, y, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextScaled = true
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Unknown
    lbl.Parent = parent
    return lbl
end

local function createTextBox(parent, default, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 52, 0, 37)
    box.Position = UDim2.new(0.709, 0, y, 0)
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BackgroundTransparency = 0.6
    box.Text = default
    box.TextScaled = true
    box.Font = Enum.Font.Oswald
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.ClearTextOnFocus = false
    box.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 15)
    c.Parent = box
    return box
end

createLabel(mainTab, "Normal Speed:", 0.057)
createLabel(mainTab, "Steal Speed:", 0.295)
createLabel(mainTab, "Lagger Normal:", 0.528)
createLabel(mainTab, "Lagger Carry:", 0.747)

local normalspeed = createTextBox(mainTab, "56", 0.057)
local stealspeed = createTextBox(mainTab, "27", 0.295)
local laggernormal = createTextBox(mainTab, "40", 0.528)
local laggercarry = createTextBox(mainTab, "20", 0.747)

-- Misc Tab
local miscTab = Instance.new("Frame")
miscTab.Size = UDim2.new(0, 334, 0, 210)
miscTab.Position = UDim2.new(0.064, 0, 0.165, 0)
miscTab.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
miscTab.BackgroundTransparency = 0.6
miscTab.Visible = false
miscTab.Parent = bgImage
local miscCorner = Instance.new("UICorner")
miscCorner.CornerRadius = UDim.new(0, 15)
miscCorner.Parent = miscTab

createLabel(miscTab, "Infinite Jump:", 0.057)
createLabel(miscTab, "Auto Steal:", 0.295)
createLabel(miscTab, "Anti Ragdoll:", 0.528)
createLabel(miscTab, "Mobile Buttons:", 0.747)

local function createToggleButton(parent, text, x, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 49, 0, 37)
    btn.Position = UDim2.new(x, 0, y, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.7
    btn.Text = "OFF"
    btn.TextScaled = true
    btn.Font = Enum.Font.Oswald
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 15)
    c.Parent = btn
    return btn
end

local infjumpButton = createToggleButton(miscTab, "Inf Jump", 0.766, 0.057)
local autostealButton = createToggleButton(miscTab, "Auto Steal", 0.766, 0.295)
local antiragdollButton = createToggleButton(miscTab, "Anti Ragdoll", 0.766, 0.528)
local mobButtonsButton = createToggleButton(miscTab, "Mobile", 0.766, 0.747)

-- Other Tab
local otherTab = Instance.new("Frame")
otherTab.Size = UDim2.new(0, 334, 0, 210)
otherTab.Position = UDim2.new(0.064, 0, 0.165, 0)
otherTab.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
otherTab.BackgroundTransparency = 0.6
otherTab.Visible = false
otherTab.Parent = bgImage
local otherCorner = Instance.new("UICorner")
otherCorner.CornerRadius = UDim.new(0, 15)
otherCorner.Parent = otherTab

createLabel(otherTab, "Unwalk:", 0.057)
createLabel(otherTab, "TP Down:", 0.295)
createLabel(otherTab, "Do Nothing:", 0.528)

local unwalkbutt = createToggleButton(otherTab, "Unwalk", 0.766, 0.057)
local tpdownbutt = createToggleButton(otherTab, "TP Down", 0.766, 0.295)
local do_nothing = createToggleButton(otherTab, "Nothing", 0.766, 0.528)

-- Mobile Panel
local mobile = Instance.new("Frame")
mobile.Size = UDim2.new(0, 194, 0, 168)
mobile.Position = UDim2.new(0.713, 0, 0.191, 0)
mobile.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mobile.Parent = UI.UI
mobile.Active = true
mobile.Draggable = true

local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 15)
mobileCorner.Parent = mobile

local mobileBg = Instance.new("ImageLabel")
mobileBg.Size = UDim2.new(1, 0, 1, 0)
mobileBg.Image = "rbxassetid://104661376291937"
mobileBg.ScaleType = Enum.ScaleType.Stretch
mobileBg.Parent = mobile

local mobileTitle = Instance.new("TextLabel")
mobileTitle.Size = UDim2.new(0, 165, 0, 41)
mobileTitle.Position = UDim2.new(0.057, 0, -0.003, 0)
mobileTitle.BackgroundTransparency = 1
mobileTitle.Text = "V3"
mobileTitle.TextScaled = true
mobileTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileTitle.Font = Enum.Font.Unknown
mobileTitle.Parent = mobileBg

local function createMobileButton(parent, text, x, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 66, 0, 50)
    btn.Position = UDim2.new(x, 0, y, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.7
    btn.Text = text
    btn.TextScaled = true
    btn.Font = Enum.Font.Oswald
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 15)
    c.Parent = btn
    return btn
end

local tpdown = createMobileButton(mobileBg, "TP Down", 0.523, 0.246)
local aimbot = createMobileButton(mobileBg, "Aimbot", 0.107, 0.247)
local cary = createMobileButton(mobileBg, "Carry", 0.107, 0.621)
local lage = createMobileButton(mobileBg, "Lagger", 0.523, 0.621)

-- Variables
local NS = 56
local CS = 27
local LAGGER_SPEED = 40
local LAGGER_CARRY_SPEED = 20
local carrySpeedActive = false
local laggerModeEnabled = false
local lastMoveDir = Vector3.new(0, 0, 0)
local speedConn = nil
local antiRagdollEnabled = false
local antiRagResetCooldown = 0
local antiRagConn = nil
local infJumpActive = false
local infJumpConnection = nil
local autoStealActive = false
local autoStealThread = nil
local unwalkActive = false
local tpdownToggle = false
local mobileVisible = true
local autoBatEnabled = false
local aimbotConn = nil
local aimbotSpeed = 58

local MOVE_KEYS = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Right] = true
}

-- Functions
local function getActiveMoveSpeed()
    if laggerModeEnabled and carrySpeedActive then return LAGGER_CARRY_SPEED end
    if laggerModeEnabled then return LAGGER_SPEED end
    if carrySpeedActive then return CS end
    return NS
end

local function startSpeedLoop()
    if speedConn then return end
    speedConn = runService.RenderStepped:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = getHumanoid()
        local root = getHRP()
        if not hum or not root then return end
        
        local md = hum.MoveDirection
        local spd = getActiveMoveSpeed()
        if md.Magnitude > 0 then
            lastMoveDir = md
            root.Velocity = Vector3.new(md.X * spd, root.Velocity.Y, md.Z * spd)
        elseif lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if userInputService:IsKeyDown(key) then
                    anyHeld = true
                    break
                end
            end
            if anyHeld then
                root.Velocity = Vector3.new(lastMoveDir.X * spd, root.Velocity.Y, lastMoveDir.Z * spd)
            end
        end
    end)
end

local function stopSpeedLoop()
    if speedConn then
        speedConn:Disconnect()
        speedConn = nil
    end
end

local function toggleCarryMode()
    carrySpeedActive = not carrySpeedActive
    return carrySpeedActive
end

local function toggleLaggerMode()
    laggerModeEnabled = not laggerModeEnabled
    return laggerModeEnabled
end

local function startAntiRagdoll()
    if antiRagConn then return end
    antiRagConn = runService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = getChar()
        if not char then return end
        local hum = getHumanoid()
        local root = getHRP()
        if not hum or not root or hum.Health <= 0 then return end
        
        local state = hum:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            if now - antiRagResetCooldown > 0.15 then
                antiRagResetCooldown = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") or obj:IsA("Constraint") then
                            obj.Enabled = true
                        end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdoll()
    if antiRagConn then
        antiRagConn:Disconnect()
        antiRagConn = nil
    end
    antiRagResetCooldown = 0
end

local function findBatForAimbot()
    local char = getChar()
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

local function getClosestTargetAimbot()
    local root = getHRP()
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
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
    return closest
end

local function swingCurrentBatAimbot(char)
    local bat = findBatForAimbot()
    if bat and bat.Parent == char then
        pcall(function() bat:Activate() end)
    end
end

local function startBatAimbot()
    if aimbotConn then
        aimbotConn:Disconnect()
    end
    autoBatEnabled = true
    local hum0 = getHumanoid()
    if hum0 then hum0.AutoRotate = false end
    
    aimbotConn = runService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = getChar()
        if not char then return end
        local root = getHRP()
        local hum = getHumanoid()
        if not root or not hum then return end
        
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatForAimbot()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end
        
        local target = getClosestTargetAimbot()
        if not target then
            swingCurrentBatAimbot(char)
            return
        end
        
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        local chaseSpeed = aimbotSpeed
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end
        
        swingCurrentBatAimbot(char)
    end)
end

local function stopBatAimbot()
    if aimbotConn then
        aimbotConn:Disconnect()
        aimbotConn = nil
    end
    autoBatEnabled = false
    local root = getHRP()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum2 = getHumanoid()
    if hum2 then hum2.AutoRotate = true end
end

-- Event Connections
mainTabBtn.MouseButton1Click:Connect(function()
    mainTab.Visible = true
    miscTab.Visible = false
    otherTab.Visible = false
end)

miscTabBtn.MouseButton1Click:Connect(function()
    mainTab.Visible = false
    miscTab.Visible = true
    otherTab.Visible = false
end)

otherTabBtn.MouseButton1Click:Connect(function()
    mainTab.Visible = false
    miscTab.Visible = false
    otherTab.Visible = true
end)

normalspeed:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(normalspeed.Text)
    if val then
        NS = val
        setWalkSpeed(val)
    end
end)

stealspeed:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(stealspeed.Text)
    if val then CS = val end
end)

laggernormal:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(laggernormal.Text)
    if val then LAGGER_SPEED = val end
end)

laggercarry:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(laggercarry.Text)
    if val then LAGGER_CARRY_SPEED = val end
end)

infjumpButton.MouseButton1Click:Connect(function()
    infJumpActive = not infJumpActive
    infjumpButton.Text = infJumpActive and "ON" or "OFF"
    if infJumpActive then
        if infJumpConnection then infJumpConnection:Disconnect() end
        infJumpConnection = runService.Heartbeat:Connect(function()
            if infJumpActive then
                local hum = getHumanoid()
                local root = getHRP()
                if hum and root then
                    if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall then
                        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 60, root.AssemblyLinearVelocity.Z)
                    end
                end
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end)

autostealButton.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    autostealButton.Text = autoStealActive and "ON" or "OFF"
    if autoStealActive then
        if autoStealThread then task.cancel(autoStealThread) end
        autoStealThread = task.spawn(function()
            while autoStealActive do
                local prompt = findStealPrompt()
                if prompt then fireProximityPrompt(prompt, 1.4) end
                task.wait(0.5)
            end
        end)
    else
        if autoStealThread then
            task.cancel(autoStealThread)
            autoStealThread = nil
        end
    end
end)

antiragdollButton.MouseButton1Click:Connect(function()
    antiRagdollEnabled = not antiRagdollEnabled
    antiragdollButton.Text = antiRagdollEnabled and "ON" or "OFF"
    if antiRagdollEnabled then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end)

aimbot.MouseButton1Click:Connect(function()
    if not autoBatEnabled then
        startBatAimbot()
    else
        stopBatAimbot()
    end
end)

cary.MouseButton1Click:Connect(function()
    toggleCarryMode()
end)

lage.MouseButton1Click:Connect(function()
    toggleLaggerMode()
end)

mobButtonsButton.MouseButton1Click:Connect(function()
    mobileVisible = not mobileVisible
    mobButtonsButton.Text = mobileVisible and "ON" or "OFF"
    mobile.Visible = mobileVisible
end)

unwalkbutt.MouseButton1Click:Connect(function()
    unwalkActive = not unwalkActive
    unwalkbutt.Text = unwalkActive and "ON" or "OFF"
    local c = getChar()
    local anim = c and c:FindFirstChild("Animator")
    if unwalkActive then
        if anim then anim.Parent = workspace end
    else
        if anim and anim.Parent == workspace then anim.Parent = c end
    end
end)

tpdownbutt.MouseButton1Click:Connect(function()
    tpdownToggle = not tpdownToggle
    tpdownbutt.Text = tpdownToggle and "ON" or "OFF"
    if tpdownToggle then
        task.spawn(function()
            while tpdownToggle do
                tpDownFast()
                task.wait(0.1)
            end
        end)
    end
end)

tpdown.MouseButton1Click:Connect(function()
    tpDownFast()
end)

do_nothing.MouseButton1Click:Connect(function()
    print("Сделал ничего! 🤡")
end)

-- Start
task.wait(0.5)
setWalkSpeed(56)
startSpeedLoop()
print("Cosmic Duels UI загружен! (Почищенная версия) ❤️")
