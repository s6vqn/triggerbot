-- Debug: Find team detection
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 500, 0, 400)
label.Position = UDim2.new(0.5, -250, 0.5, -200)
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.BackgroundTransparency = 0.3
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Code
label.TextSize = 12
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Text = "Aim at teammate first, then enemy..."
label.Parent = gui

RunService.RenderStepped:Connect(function()
    local target = Mouse.Target
    if target then
        local model = target.Parent
        for i = 1, 10 do
            if model and model:FindFirstChild("Humanoid") then
                local player = Players:GetPlayerFromCharacter(model)
                
                local txt = "=== CHARACTER CHECK ===\n"
                txt = txt .. "Name: " .. model.Name .. "\n"
                txt = txt .. "Player: " .. (player and player.Name or "nil") .. "\n"
                
                local bodyColors = model:FindFirstChildOfClass("BodyColors")
                if bodyColors then
                    txt = txt .. "HeadColor: " .. tostring(bodyColors.HeadColor) .. "\n"
                    txt = txt .. "TorsoColor: " .. tostring(bodyColors.TorsoColor) .. "\n"
                else
                    txt = txt .. "No BodyColors\n"
                end
                
                local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
                if torso then
                    txt = txt .. "Torso BrickColor: " .. tostring(torso.BrickColor) .. "\n"
                    txt = txt .. "Torso Color: " .. tostring(torso.Color) .. "\n"
                end
                
                if player then
                    txt = txt .. "Player.Team: " .. tostring(player.Team) .. "\n"
                    txt = txt .. "Player.TeamColor: " .. tostring(player.TeamColor) .. "\n"
                    txt = txt .. "LocalPlayer.Team: " .. tostring(LocalPlayer.Team) .. "\n"
                    txt = txt .. "LocalPlayer.TeamColor: " .. tostring(LocalPlayer.TeamColor) .. "\n"
                end
                
                txt = txt .. "\n=== CHECKING FOR TAGS/FOLDERS ===\n"
                for _, child in pairs(model:GetChildren()) do
                    if child:IsA("NumberValue") or child:IsA("StringValue") or child:IsA("BoolValue") then
                        txt = txt .. child.Name .. ": " .. tostring(child.Value) .. "\n"
                    end
                    if child:IsA("Folder") then
                        txt = txt .. "Folder: " .. child.Name .. "\n"
                    end
                end
                
                label.Text = txt
                return
            end
            if model then model = model.Parent end
        end
        label.Text = "No character found"
    else
        label.Text = "No target"
    end
end)
