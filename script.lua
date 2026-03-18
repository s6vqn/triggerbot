-- Settings
local Hotkey = "t"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

local function getCharacterFromPart(part)
    if not part then return nil end
    local model = part.Parent
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

RunService.RenderStepped:Connect(function()
    if Enabled and RightClickHeld then
        local ray = Camera:ViewportPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        
        if result then
            local model = getCharacterFromPart(result.Instance)
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local player = Players:GetPlayerFromCharacter(model)
                    if not player or player.Team ~= LocalPlayer.Team then
                        mouse1click()
                    end
                end
            end
        end
    end
end)

print("Script loaded! Press T to toggle, hold right click to shoot.")
