-- Settings
local Hotkey = "t"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local RightClickHeld = false

local EnemyColor = BrickColor.new("Bright red")

Mouse.KeyDown:Connect(function(key)
    if key:lower() == Hotkey:lower() then
        Enabled = not Enabled
        print("Autotrigger:", Enabled and "ON" or "OFF")
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = false
    end
end)

local function getCharacterModel(target)
    if not target then return nil end
    local model = target.Parent
    for i = 1, 10 do
        if model and model:FindFirstChild("Humanoid") then
            return model
        end
        if model then
            model = model.Parent
        end
    end
    return nil
end

local function getBodyColor(model)
    local bodyColors = model:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        return bodyColors.TorsoColor
    end
    local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
    if torso then
        return torso.BrickColor
    end
    return nil
end

local function isEnemy(model)
    if not model then return false end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local player = Players:GetPlayerFromCharacter(model)
    if player then return false end
    
    local bodyColor = getBodyColor(model)
    if bodyColor == EnemyColor then
        return true
    end
    
    return false
end

RunService.RenderStepped:Connect(function()
    if Enabled and RightClickHeld then
        local target = Mouse.Target
        local model = getCharacterModel(target)
        
        if isEnemy(model) then
            mouse1click()
        end
    end
end)

print("Script loaded! Press T to toggle, hold right click to shoot.")
