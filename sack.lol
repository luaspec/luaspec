local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

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
-- INFINITE JUMP (3 режима: manual, hold, auto)
-- ============================================================
local infJumpEnabled = false
local infJumpMode = "manual"  -- "manual" | "hold" | "auto"
local jumpHeld = false
local lastJumpBoostTime = 0
local JUMP_BOOST_INTERVAL = 0.05
local infJumpThread = nil
local holdInfJumpConn = nil
local autoInfJumpConn = nil

-- Manual: прыжок при удержании пробела
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
        if infJumpMode == "manual" then
            startManualInfJump()
        elseif infJumpMode == "hold" then
            startHoldInfJump()
        elseif infJumpMode == "auto" then
            startAutoInfJump()
        end
    else
        stopManualInfJump()
        stopHoldInfJump()
        stopAutoInfJump()
    end
    return infJumpEnabled
end

function setInfJumpMode(mode)
    if mode ~= "manual" and mode ~= "hold" and mode ~= "auto" then return end
    local wasEnabled = infJumpEnabled
    if wasEnabled then
        stopManualInfJump()
        stopHoldInfJump()
        stopAutoInfJump()
    end
    infJumpMode = mode
    if wasEnabled then
        if mode == "manual" then
            startManualInfJump()
        elseif mode == "hold" then
            startHoldInfJump()
        elseif mode == "auto" then
            startAutoInfJump()
        end
    end
end

-- ============================================================
-- TP DOWN (телепорт вниз)
-- ============================================================
function tpDownFast()
    local root = getHRP()
    if root then
        local targetY = root.Position.Y - (30 * 4.5)
        root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
    end
end

-- ============================================================
-- AUTO STEAL (работает с ProximityPrompt)
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
                if prompt then
                    fireProximityPrompt(prompt, stealDuration)
                end
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

function setStealRadius(radius)
    stealRadius = radius
end

function setStealDuration(duration)
    stealDuration = duration
end

-- ============================================================
-- ТЕСТОВЫЕ КОМАНДЫ ДЛЯ КОНСОЛИ
-- ============================================================
print("===== ORVYN FUNCTIONS LOADED =====")
print("Команды:")
print("  toggleInfJump()          - вкл/выкл бесконечный прыжок")
print("  setInfJumpMode('manual') - manual | hold | auto")
print("  tpDownFast()             - телепорт вниз")
print("  toggleAutoSteal()        - вкл/выкл авто стил")
print("  setStealRadius(60)       - радиус стила")
print("  setStealDuration(1.4)    - длительность стила")
print("==================================")
