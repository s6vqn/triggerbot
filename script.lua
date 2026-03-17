-- Settings
local Hotkey = "t"
local HotkeyToggle = true
local HoldClick = false -- true = hold mouse1, false = single click

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local RightClickHeld = false
local CurrentlyPressed = false

local function IsEnemyPlayerCharacter(character)
    local plr = Players:GetPlayerFromCharacter(character)
    if not plr then
        -- Not a player (NPC/dummy) -> ignore
        return false
    end

    -- If either has no team, or teams match, treat as not enemy
    if not plr.Team or not LocalPlayer.Team then
        return false
    end

    -- Enemy if on different team
    return plr.Team ~= LocalPlayer.Team
end

Mouse.KeyDown:Connect(function(key)
    key = key:lower()

    if key == Hotkey:lower() then
        if HotkeyToggle then
            Enabled = not Enabled
            print("Autotrigger:", Enabled and "ON" or "OFF")
        else
            Enabled = true
        end
    end
end)

Mouse.KeyUp:Connect(function(key)
    key = key:lower()

    if not HotkeyToggle and key == Hotkey:lower() then
        Enabled = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightClickHeld = false

        if HoldClick and CurrentlyPressed then
            CurrentlyPressed = false
            mouse1release()
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Enabled and RightClickHeld then
        local target = Mouse.Target
        if target and target.Parent then
            local character = target.Parent
            local humanoid = character:FindFirstChild("Humanoid")

            if humanoid and IsEnemyPlayerCharacter(character) then
                if HoldClick then
                    if not CurrentlyPressed then
                        CurrentlyPressed = true
                        mouse1press()
                    end
                else
                    mouse1click()
                end
            else
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
    else
        if HoldClick and CurrentlyPressed then
            CurrentlyPressed = false
            mouse1release()
        end
    end
end)
