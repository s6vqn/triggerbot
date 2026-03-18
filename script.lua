-- Settings
local Hotkey = "t"
local HotkeyToggle = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local RightClickHeld = false

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

RunService.RenderStepped:Connect(function()
    if Enabled and RightClickHeld then
        local target = Mouse.Target
        if target then
            local model = target.Parent
            if model and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 then
                local player = Players:GetPlayerFromCharacter(model)
                if not player or player.Team ~= LocalPlayer.Team then
                    mouse1click()
                end
            end
        end
    end
end)

print("Script loaded! Press T to toggle, hold right click to shoot.")
