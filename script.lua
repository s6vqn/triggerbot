local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

Mouse.KeyDown:Connect(function(key)
    if key:lower() == "k" then -- press K while aiming at the enemy
        local part = Mouse.Target
        print("---- DEBUG ----")
        print("Target part:", part, part and part.Name)
        if part then
            local char = part.Parent
            while char and char ~= workspace and not char:FindFirstChildOfClass("Humanoid") do
                char = char.Parent
            end
            print("Character model:", char, char and char.Name)

            if char then
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then
                        print(p.Name, "BrickColor =", p.BrickColor.Name)
                    end
                end
            end
        end
        print("--------------")
    end
end)
