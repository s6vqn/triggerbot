-- Debug on Screen
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local RightClickHeld = false

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 300, 0, 200)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.BackgroundTransparency = 0.5
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.Font = Enum.Font.Code
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Text = "Press T to enable"
label.Parent = gui

Mouse.KeyDown:Connect(function(key)
    if key:lower() == "t" then
        Enabled = not Enabled
        label.Text = Enabled and "ENABLED - Aim at target" or "DISABLED"
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
            if model and model:FindFirstChild("Humanoid") then
                local humanoid = model.Humanoid
                local player = Players:GetPlayerFromCharacter(model)
                
                local txt = "TARGET: " .. model.Name .. "\n"
                txt = txt .. "Health: " .. humanoid.Health .. "\n"
                txt = txt .. "Is Player: " .. (player ~= nil) .. "\n"
                if player then
                    txt = txt .. "Team: " .. tostring(player.Team) .. "\n"
                    txt = txt .. "Same Team: " .. (player.Team == LocalPlayer.Team) .. "\n"
                end
                
                if humanoid.Health > 0 and (not player or player.Team ~= LocalPlayer.Team) then
                    txt = txt .. "\n>>> SHOOTING!"
                    mouse1click()
                else
                    txt = txt .. "\n>>> NOT SHOOTING"
                end
                
                label.Text = txt
            else
                label.Text = "No Humanoid target"
            end
        else
            label.Text = "No target"
        end
    end
end)

print("Debug script loaded!")
