-- Settings
local Hotkey = "t"

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local Enabled = false
local RightClickHeld = false
local CurrentlyPressed = false

-- Hotkey Toggle
Mouse.KeyDown:Connect(function(key)
    if key:lower() == Hotkey:lower() then
        Enabled = not Enabled
        print("Autotrigger:", Enabled and "ON" or "OFF")
    end
end)

-- Right Click Detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = false
        if CurrentlyPressed then
            CurrentlyPressed = false
            mouse1release()
        end
    end
end)

-- Get Character Model
local function getCharacterModel(target)
    if not target then return nil end
    local model = target.Parent
    for i = 1, 10 do
        if model and model:FindFirstChildOfClass("Humanoid") then
            return model
        end
        if model then
            model = model.Parent
        end
    end
    return nil
end

-- Check if Enemy
local function isEnemy(model)
    if not model then return false, nil end
    
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false, nil end
    
    local player = Players:GetPlayerFromCharacter(model)
    if player then
        if player.Team == LocalPlayer.Team then return false, nil end
    end
    
    return true, model
end

-- Wall Check
local function hasLineOfSight(targetPosition)
    local origin = Camera.CFrame.Position
    local direction = (targetPosition - origin).Unit * 500
    local ray = Ray.new(origin, direction)
    local hit, position = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character}, false, true)
    
    if hit then
        local hitModel = hit.Parent
        for i = 1, 10 do
            if hitModel and hitModel:FindFirstChildOfClass("Humanoid") then
                return true
            end
            if hitModel then
                hitModel = hitModel.Parent
            end
        end
    end
    
    return false
end

-- Check if Aimed at Enemy
local function isAimedAtEnemy()
    local target = Mouse.Target
    if not target then return false end
    
    local model = getCharacterModel(target)
    if not model then return false end
    
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local player = Players:GetPlayerFromCharacter(model)
    if player and player.Team == LocalPlayer.Team then return false end
    
    local torso = model:FindFirstChild("Torso") or model:FindFirstChild("HumanoidRootPart")
    if not torso then return false end
    
    local screenPos = Camera:WorldToViewportPoint(torso.Position)
    local center = Camera.ViewportSize / 2
    
    local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
    
    return distance < 50
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    if Enabled and RightClickHeld then
        local target = Mouse.Target
        if target then
            local model = getCharacterModel(target)
            local enemy, enemyModel = isEnemy(model)
            
            if enemy and enemyModel then
                local torso = enemyModel:FindFirstChild("Torso") or enemyModel:FindFirstChild("HumanoidRootPart")
                if torso then
                    if hasLineOfSight(torso.Position) and isAimedAtEnemy() then
                        if HoldClick then
                            if not CurrentlyPressed then
                                CurrentlyPressed = true
                                mouse1press()
                            end
                        else
                            mouse1click()
                        end
                    end
                end
            end
        end
        
        if not (target and getCharacterModel(target) and isAimedAtEnemy()) then
            if HoldClick and CurrentlyPressed then
                CurrentlyPressed = false
                mouse1release()
            end
        end
    else
        if HoldClick and CurrentlyPressed then
            CurrentlyPressed = false
            mouse1release()
        end
    end
end)

print("Autotrigger loaded! Press T to toggle, hold right click to shoot.")
