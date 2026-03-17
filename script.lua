local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Helper: climb from any part to the character model (has a Humanoid)
local function getCharacterFromPart(part)
    local current = part
    while current and current ~= workspace do
        if current:FindFirstChildOfClass("Humanoid") then
            return current
        end
        current = current.Parent
    end
    return nil
end

-- Inspect the character: print parts and colors
local function inspectCharacter(character)
    print("===== INSPECT CHARACTER =====")
    print("Model name:", character.Name)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        print("Humanoid health:", humanoid.Health, "/", humanoid.MaxHealth)
    end

    local player = Players:GetPlayerFromCharacter(character)
    if player then
        print("Owner player:", player.Name)
    else
        print("Owner player: NONE (probably a dummy/NPC)")
    end

    print("---- Parts ----")
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            local colorName = obj.BrickColor and obj.BrickColor.Name or tostring(obj.Color)
            print(obj:GetFullName(), " | Name:", obj.Name, " | BrickColor:", colorName)
        end
    end
    print("===== END INSPECT =====")
end

-- Press a key (e.g. "K") to inspect whatever you are pointing at
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "k" then
        local target = Mouse.Target
        print("Key K pressed. Mouse.Target =", target, target and target.Name)

        if not target then
            print("No target under mouse.")
            return
        end

        local character = getCharacterFromPart(target)
        if not character then
            print("No character (Humanoid) found from this part.")
            return
        end

        inspectCharacter(character)
    end
end)
