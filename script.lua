-- Triggerbot
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local RightClickHeld = false

Mouse.KeyDown:Connect(function(key)
    if key:lower() == "t" then
        Enabled = not Enabled
        print("Triggerbot:", Enabled and "ON" or "OFF")
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
        if Mouse.Target and Mouse.Target.Parent then
            local model = Mouse.Target.Parent
            if model:FindFirstChildOfClass("Humanoid") then
                mouse1click()
            end
        end
    end
end)

print("Triggerbot loaded! Press T to toggle, hold right click to shoot.")
