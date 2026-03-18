-- Simple Debug
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 400, 0, 300)
label.Position = UDim2.new(0.5, -200, 0.5, -150)
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Code
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Text = "Waiting..."
label.Parent = gui

RunService.RenderStepped:Connect(function()
    local target = Mouse.Target
    local txt = "Mouse Target: " .. (target and target.Name or "nil") .. "\n"
    txt = txt .. "Target Parent: " .. (target and target.Parent and target.Parent.Name or "nil") .. "\n"
    txt = txt .. "Target Class: " .. (target and target.ClassName or "nil") .. "\n\n"
    
    if target then
        txt = txt .. "Checking parents...\n"
        local obj = target
        for i = 1, 15 do
            if obj then
                txt = txt .. i .. ". " .. obj.Name .. " (" .. obj.ClassName .. ")"
                if obj:FindFirstChildOfClass("Humanoid") then
                    txt = txt .. " [HAS HUMANOID]"
                end
                if obj:FindFirstChildOfClass("BodyColors") then
                    txt = txt .. " [HAS BODYCOLORS]"
                end
                txt = txt .. "\n"
                obj = obj.Parent
            end
        end
    end
    
    label.Text = txt
end)
