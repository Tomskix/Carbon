local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera


TriggerSettings = {
    TeamCheck = false,
    TriggerOn = false,
}
local ESPSettings = {
    WallCheck = true,
    TeamCheck = false,
    NoWallColor = Color3.fromRGB(0, 239, 255),
    WithWallColor = Color3.fromRGB(255, 255, 0),
    IsESPEnabled = false, 

}

local AimbotSettings = {
    FOV = 80,
    Targetpart = "Head",
    UseTeamCheck = false,
}
local target

local LocalPlayer = game.Players.LocalPlayer
local IsTracersOn = false

local localplayer = game:GetService("Players").LocalPlayer
local Mouse = localplayer:GetMouse()

local IsAimbotEnabled = false


local function closestPlayer()
    local closestDist = math.huge
    local closestPlayer = nil
    local mousePos = Vector2.new(Mouse.X, Mouse.Y) -- Get mouse position

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localplayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local head = character and character:FindFirstChild("Head")
            
            if head and humanoid and humanoid.Health > 0 then
                if player.Team ~= localplayer.Team or not AimbotSettings.UseTeamCheck then
                    local headPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                    if onScreen then -- Check if player's head is on the screen
                        local playerPos = Vector2.new(headPos.X, headPos.Y)
                        local dist = (playerPos - mousePos).Magnitude
                        
                        if dist < closestDist and dist <= AimbotSettings.FOV then
                            closestDist = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end





local aiming = false
local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = true
        target = closestPlayer()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false
    end
end)




local function CreateTracers()
    local tracerLines = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and IsTracersOn == true then
            local tracerLine = Drawing.new("Line")
            tracerLine.Visible = IsTracersOn
            tracerLine.Color = ESPSettings.WithWallColor
            tracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            
            tracerLines[player] = tracerLine

            RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    local position, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                    if onScreen then
                        tracerLine.To = Vector2.new(position.X, position.Y)
                    else
                        tracerLine.Visible = false
                    end
                else
                    tracerLine.Visible = false
                end

                -- Hide tracer line if tracers are turned off or if player is on the same team (if team check is enabled)
                if not IsTracersOn or (ESPSettings.TeamCheck and player.Team == LocalPlayer.Team) then
                    tracerLine.Visible = false
                else
                    tracerLine.Visible = IsTracersOn
                end
            end)

            Players.PlayerRemoving:Connect(function(removedPlayer)
                if removedPlayer == player then
                    tracerLine:Destroy()
                    tracerLines[player] = nil
                end
            end)
        end
    end

    -- Clear tracer lines for players who have left the game
    Players.PlayerRemoving:Connect(function(removedPlayer)
        if tracerLines[removedPlayer] then
            tracerLines[removedPlayer]:Destroy()
            tracerLines[removedPlayer] = nil
        end
    end)
    Players.PlayerAdded:Connect(function(player)
        if player ~= Players.LocalPlayer and IsTracersOn == true then
            local tracerLine = Drawing.new("Line")
            tracerLine.Visible = IsTracersOn
            tracerLine.Color = ESPSettings.WithWallColor
            tracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            
            tracerLines[player] = tracerLine

            RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    local position, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                    if onScreen then
                        tracerLine.To = Vector2.new(position.X, position.Y)
                    else
                        tracerLine.Visible = false
                    end
                else
                    tracerLine.Visible = false
                end

                -- Hide tracer line if tracers are turned off or if player is on the same team (if team check is enabled)
                if not IsTracersOn or (ESPSettings.TeamCheck and player.Team == LocalPlayer.Team) then
                    tracerLine.Visible = false
                else
                    tracerLine.Visible = IsTracersOn
                end
            end)
        end
    end)
end




-- Function to check if there is a wall between two parts
local function CheckIfWall(part1, part2)
    local character1 = part1.Parent
    local character2 = part2.Parent

    local origin = part1.Position
    local direction = (part2.Position - part1.Position).Unit
    local distance = (part2.Position - part1.Position).Magnitude

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character1, character2}
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.Parent ~= character1 and hitPart.Parent ~= character2 then
            return true
        else
            return false
        end
    else
        return false
    end
end

-- Function to update ESP highlights
local function UpdateESP()
    if not ESPSettings.IsESPEnabled then
        -- Remove highlights if ESP is disabled
        for i, player in ipairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("esphigh") then
                player.Character.esphigh:Destroy()
            end
        end
        return
    end

    -- Function to create or update highlights for a player
    local function CreateOrUpdateHighlight(player)
        if player ~= LocalPlayer and (player.Team ~= LocalPlayer.Team or ESPSettings.TeamCheck == false) then
            if not player.Character:FindFirstChild("esphigh") then
                local h = Instance.new("Highlight", player.Character)
                h.Name = "esphigh"
            end
            local esphigh = player.Character:FindFirstChild("esphigh")
            if CheckIfWall(LocalPlayer.Character.HumanoidRootPart, player.Character.HumanoidRootPart) then
                esphigh.FillColor = ESPSettings.WithWallColor
            else
                esphigh.FillColor = ESPSettings.NoWallColor
            end
        end
    end

    -- Add highlights if ESP is enabled and continuously update them
    while ESPSettings.IsESPEnabled do
        -- Update or create highlights for each player
        for i, player in ipairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CreateOrUpdateHighlight(player)
            end
        end
        wait(0.1)
    end
end

-- Toggle function for ESP
local function ToggleESP()
    ESPSettings.IsESPEnabled = not ESPSettings.IsESPEnabled
    UpdateESP()
end

local Window = Library.CreateLib("Carbon - 1.0.1", "DarkTheme")

local VisualTab = Window:NewTab("Visuals")
local CombatTab = Window:NewTab("Combat")

local aimbotsec = CombatTab:NewSection("Aimbot")

local AimbotCircle = Drawing.new("Circle")
AimbotCircle.Visible = IsAimbotEnabled
AimbotCircle.Radius = 80
AimbotCircle.Color = Color3.fromRGB(255,120,0)
AimbotCircle.Thickness = 1
AimbotCircle.Filled = false
AimbotCircle.Transparency = 1
AimbotCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)


aimbotsec:NewToggle("Aimbot", "Aimbot, Lockon", function (bool)
    IsAimbotEnabled = bool
    AimbotCircle.Visible = IsAimbotEnabled
end)


aimbotsec:NewToggle("Team Check", "Use TeamCheck", function (bool)
    AimbotSettings.UseTeamCheck = bool
end)

aimbotsec:NewSlider("FOV", "Aimbot FOV", 1000, 80, function(s)
    AimbotSettings.FOV = s
    AimbotCircle.Radius = s
end)

aimbotsec:NewDropdown("Aimbot Part", "Hitpart", {"Head", "Torso", "HumanoidRootPart"}, function(currentOption)
    AimbotSettings.Targetpart = currentOption
end)

aimbotsec:NewColorPicker("Circle Color", "Aimbot Color?", Color3.fromRGB(255,125,0), function(color)
    AimbotCircle.Color = color
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if aiming then
        print(target)
        print(IsAimbotEnabled)
        if target == nil then
            while target == nil do
                target = closestPlayer()
                wait()
            end
        end
        
        if target and IsAimbotEnabled then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character:FindFirstChild(AimbotSettings.Targetpart).Position)
        end
    end
end)


local EspSection = VisualTab:NewSection("ESP")
local esptoggle = EspSection:NewToggle("Enable ESP", "Enable Extra Sensory Perception", function()
    ToggleESP()
end)

local teamchecktoggle = EspSection:NewToggle("Team Check", "Use Team Check", function(bool)
    ESPSettings.TeamCheck = bool
end)

local wallchecktoggle = EspSection:NewToggle("Wallcheck", "Use Wall Check", function(bool)
    ESPSettings.WallCheck = bool
end)

EspSection:NewColorPicker("Wall ESP Color", "If player is behind a wall", Color3.fromRGB(255, 255, 0), function(color)
    ESPSettings.WithWallColor = color
end)

EspSection:NewColorPicker("Normal ESP Color", "If player is infront of you", Color3.fromRGB(0, 239, 255), function(color)
    ESPSettings.NoWallColor = color
end)

local wallchecktoggle = EspSection:NewToggle("Enable Tracers", "Enable Tracers", function(bool)
    IsTracersOn = bool
    CreateTracers()
end)


while wait() do
    local sc,er = pcall(function()
        UpdateESP()
    end)
end
