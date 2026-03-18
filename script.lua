local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

Mouse.Move:Connect(function()
    if Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") then
        local model = Mouse.Target.Parent
        local player = Players:GetPlayerFromCharacter(model)
        if player then
            print("Player:", player.Name)
            print("My Team:", LocalPlayer.Team, "His Team:", player.Team)
            print("My TeamColor:", LocalPlayer.TeamColor, "His TeamColor:", player.TeamColor)
        end
    end
end)
