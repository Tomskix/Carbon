local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local connection
local bodyVelocity
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")


local CESPSettings = { ---- table for esp settings 
    textsize = 12,
    colour = 255,255,255,
    IsNameESP = false,
    Font = "Arial"
}

local gui = Instance.new("BillboardGui")
local esp = Instance.new("TextLabel",gui) ---- new instances to make the billboard gui and the textlabel



gui.Name = "Cracked esp"; ---- properties of the esp
gui.ResetOnSpawn = false
gui.AlwaysOnTop = true;
gui.LightInfluence = 0;
gui.Size = UDim2.new(1.75, 0, 1.75, 0);
esp.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
esp.Text = ""
esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001);
esp.BorderSizePixel = 4;
esp.BorderColor3 = Color3.new(CESPSettings.colour)
esp.BorderSizePixel = 0
esp.Font = "Arial"
esp.TextSize = CESPSettings.textsize
esp.TextColor3 = Color3.fromRGB(CESPSettings.colour) -- text colour

local UIS = game:GetService("UserInputService")

function GetDistance(player)
    local PlayerPart = player.Character:FindFirstChild("HumanoidRootPart").Position
    local LocalPlayerPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
    return math.round((PlayerPart - LocalPlayerPart).Magnitude)
end
local IsESPEnabled = true

game:GetService("RunService").RenderStepped:Connect(function() ---- loops faster than a while loop :)
    for i,v in pairs (game:GetService("Players"):GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character.Head:FindFirstChild("Cracked esp")==nil and v.TeamColor ~= game:GetService("Players").LocalPlayer.TeamColor and CESPSettings.IsNameESP then -- craeting checks for team check, local player etc
            gui:Clone().Parent = v.Character.Head
            esp.Text = "{"..GetDistance(v).." Studs Away}"
            v.Character.Head:FindFirstChild("Cracked esp"):FindFirstChild("TextLabel").TextColor = v.TeamColor
            
        else 
            if v ~= game:GetService("Players").LocalPlayer and v.Character.Head:FindFirstChild("Cracked esp")~=nil and v.TeamColor ~= game:GetService("Players").LocalPlayer.TeamColor and CESPSettings.IsNameESP then
                v.Character.Head:FindFirstChild("Cracked esp"):FindFirstChild("TextLabel").TextColor = BrickColor.new(CESPSettings.colour)
                v.Character.Head:FindFirstChild("Cracked esp"):FindFirstChild("TextLabel").TextSize = CESPSettings.textsize
                v.Character.Head:FindFirstChild("Cracked esp"):FindFirstChild("TextLabel").Text = v.DisplayName.." "..GetDistance(v).." Studs Away"
                v.Character.Head:FindFirstChild("Cracked esp"):FindFirstChild("TextLabel").Font = CESPSettings.Font
            else
                if v ~= game:GetService("Players").LocalPlayer and v.Character.Head:FindFirstChild("Cracked esp")~=nil and v.TeamColor == game:GetService("Players").LocalPlayer.TeamColor and CESPSettings.IsNameESP then
                    v.Character.Head:FindFirstChild("Cracked esp"):Destroy()
                end
            end
        if not CESPSettings.IsNameESP then 
            for i,v in game.Players:GetPlayers() do
                if v.Character.Head:FindFirstChild("Cracked esp")~= nil then 
                    v.Character.Head:FindFirstChild("Cracked esp"):Destroy()
                end
            end
        end
    end
end
end)


local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", -- Middle or Bottom if FollowMouse is on this won't matter...
    Tracer_FollowMouse = false,
    Tracers = true
}
local Team_Check = {
    TeamCheck = false, -- if TeamColor is on this won't matter...
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}
local TeamColor = true

local ESP_Toggle = false -- Flag for toggling ESP

local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Visibility(state, lib)
    for _, x in pairs(lib) do
        x.Visible = state
    end
end

local function ToColor3(col) --Function to convert, just because c;
    local r = col.r --Red value
    local g = col.g --Green value
    local b = col.b --Blue value
    return Color3.new(r,g,b); --Color3 datatype, made of the RGB inputs
end

local black = Color3.fromRGB(0, 0 ,0)

local function ESP(plr)
    local library = {
        --//Tracer and Black Tracer(black border)
        blacktracer = NewLine(Settings.Tracer_Thickness*2, black),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        --//Box and Black Box(black border)
        black = NewQuad(Settings.Box_Thickness*2, black),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        --//Bar and Green Health Bar (part that moves up/down)
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, black)
    }

    local function Colorize(color)
        for _, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if ESP_Toggle and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
                local HumPos, OnScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                    end
                    Size(library.box)
                    Size(library.black)

                    --//Tracer 
                    if Settings.Tracers then
                        if Settings.Tracer_Origin == "Middle" then
                            library.tracer.From = Camera.ViewportSize*0.5
                            library.blacktracer.From = Camera.ViewportSize*0.5
                        elseif Settings.Tracer_Origin == "Bottom" then
                            library.tracer.From = Vector2.new(Camera.ViewportSize.X*0.5, Camera.ViewportSize.Y) 
                            library.blacktracer.From = Vector2.new(Camera.ViewportSize.X*0.5, Camera.ViewportSize.Y)
                        end
                        if Settings.Tracer_FollowMouse then
                            library.tracer.From = Vector2.new(Mouse.X, Mouse.Y+36)
                            library.blacktracer.From = Vector2.new(Mouse.X, Mouse.Y+36)
                        end
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 0)
                    end

                    --// Health Bar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                    local healthoffset = plr.NRPBS.Health.Value/100 * d

                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)

                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                    local green = Color3.fromRGB(0, 255, 0)
                    local red = Color3.fromRGB(255, 0, 0)

                    library.greenhealth.Color = red:lerp(green, plr.NRPBS.Health.Value/100);

                    if Team_Check.TeamCheck then
                        if plr.TeamColor == LocalPlayer.TeamColor then
                            Colorize(Team_Check.Green)
                        else 
                            Colorize(Team_Check.Red)
                        end
                    else 
                        library.tracer.Color = Settings.Tracer_Color
                        library.box.Color = Settings.Box_Color
                    end
                    if TeamColor then
                        Colorize(plr.TeamColor.Color)
                    end
                    Visibility(true, library)
                else 
                    Visibility(false, library)
                end
            else 
                Visibility(false, library)
                if not Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for _, v in pairs(Players:GetPlayers()) do
    if v.Name ~= LocalPlayer.Name then
        coroutine.wrap(ESP)(v)
    end
end

Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= LocalPlayer.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)

UserInputService.InputBegan:Connect(function(input, agmeproc)
    if input.KeyCode == Enum.KeyCode.Q then
        ESP_Toggle = not ESP_Toggle
    end
end)

local Window = Library.CreateLib("Carbon - Arsenal", "DarkTheme")


local CombatTab = Window:NewTab("Combat")
local VisualTab = Window:NewTab("Visuals")
local MovementTab = Window:NewTab("Movement")
local ModsTab = Window:NewTab("Gun Mods")
local SettingsTab = Window:NewTab("Settings")

local Settingoptions = {
    HeadShotPercent = 100
}

local GunModSettings = {
    IAmmo = false,
}

local ModsSec = ModsTab:NewSection("Gun Mods")

ModsSec:NewToggle("Infinite Ammo", "Enable Infinite Ammo", function(bool)
    GunModSettings.IAmmo = bool
end)
ModsSec:NewButton("No Recoil", "Enable No Ammo", function(callback)
    for i, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        if v.Name == "RecoilControl" then
             v.Value = 0
        end
    end
end)

ModsSec:NewButton("No FireRate", "Enable No FireRate", function(callback)
    for i, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "FireRate" then
                v.Value = 0.05
            end
    end
end)

ModsSec:NewButton("No Reload Time", "Enable No Reload", function(callback)
    for i, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "ReloadTime" then
                    v.Value = 0.1
            end
     end
end)


game:GetService('RunService').PreRender:connect(function()
    if GunModSettings.IAmmo == true then
        game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999    
        game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
    end
end)


local EspSection = VisualTab:NewSection("ESP Settings")
local distsec = VisualTab:NewSection("Distance Settings")
local aimbotsec = CombatTab:NewSection("Aimbot Settings")
local triggersec = CombatTab:NewSection("Triggerbot Settings")
local movementsec = MovementTab:NewSection("Movement Settings")
local speedsec = MovementTab:NewSection("Speed Settings")
local flysec = MovementTab:NewSection("Flight Settings")
local spinsec = MovementTab:NewSection("Spinbot")
local optionsec = SettingsTab:NewSection("Settings")

-- Initialize variables
local spinning = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = game.Workspace.CurrentCamera
local followBlock
local spin
local spinspeed = 5

-- Function to create a new part
local function createFollowBlock()
    local followBlock = Instance.new("Part")
    followBlock.Name = "FollowBlock"
    followBlock.Size = Vector3.new(2, 2, 2)
    followBlock.Anchored = true
    followBlock.CanCollide = false
    followBlock.Transparency = 1
    followBlock.Parent = workspace
    return followBlock
end

-- Function to update the block's position
local function updateBlockPosition()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local newPosition = humanoidRootPart.Position + Vector3.new(-2, 6, 0)
    followBlock.CFrame = CFrame.new(newPosition)
    camera.CameraSubject = followBlock
end


local function toggleSpinningAndFollowing()
    spinning = not spinning

    if spinning then
        spin = Instance.new("BodyAngularVelocity")
        spin.Name = "Spinning"
        spin.Parent = character:WaitForChild("HumanoidRootPart")
        spin.MaxTorque = Vector3.new(0, math.huge, 0)
        spin.AngularVelocity = Vector3.new(0, spinspeed, 0)


        followBlock = createFollowBlock()

        game:GetService("RunService").RenderStepped:Connect(updateBlockPosition)
    else
        if spin then
            spin:Destroy()
            spin = nil
        end

        if followBlock then
            followBlock:Destroy()
            followBlock = nil
        end

        camera.CameraSubject = character:WaitForChild("Humanoid")
    end
end




spinsec:NewToggle("Enable Spinbot", "Enables Spinbot", function()
        toggleSpinningAndFollowing()
end)

spinsec:NewSlider("Spinbot Speed", "Are you fr?", 50, 5, function(speed)
    spinspeed = speed
end)

optionsec:NewSlider("Headshot %", "Less obvious", 100, 1, function(heads)
    Settingoptions.HeadShotPercent = heads
end)


local speedsettings = {
    Speed = 5,
    FlightSpeed = 5,
}

local bv2 = Instance.new("BodyVelocity")
bv2.Velocity = Vector3.new(0, 0, 0)
bv2.MaxForce = Vector3.new(10000, 10000, 10000)  -- Allow movement in all directions
bv2.Parent = workspace

local keysPressed = {}
local movementEnabled = false


-- Function to update BodyVelocity based on MoveDirection and Camera Y-axis
local function updateVelocity()
    if not movementEnabled then
        humanoid.PlatformStand = false
        bv2.Velocity = Vector3.new(0, 0, 0)
        bv2.Parent = workspace
        return
    end

    humanoid.PlatformStand = true
    bv2.Parent = rootPart 
    local moveDirection = humanoid.MoveDirection * speedsettings.FlightSpeed
    local cameraY = 0

    -- Check if W, A, S, or D keys are held
    if keysPressed[Enum.KeyCode.W] or keysPressed[Enum.KeyCode.A] or keysPressed[Enum.KeyCode.D] then
        cameraY = Camera.CFrame.LookVector.Y * (speedsettings.FlightSpeed * 2)
    else
        if keysPressed[Enum.KeyCode.S] then
            cameraY = Camera.CFrame.LookVector.Y * (speedsettings.FlightSpeed * -2)
        end
    end

    bv2.Velocity = Vector3.new(moveDirection.X, cameraY, moveDirection.Z)
end

-- Function to handle key press
local function onKeyPress(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        keysPressed[input.KeyCode] = true
    end
end

-- Function to handle key release
local function onKeyRelease(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        keysPressed[input.KeyCode] = nil
        
    end
end

-- Toggle movement function
local function toggleMovement()
    movementEnabled = not movementEnabled
end


local function toggleVelocityUpdate()
    if connection then
        -- Stop the velocity update
        connection:Disconnect()
        connection = nil
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    else
        -- Start the velocity update
        local character = player.Character
        if character then
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")

            -- Create BodyVelocity object
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Parent = humanoidRootPart
            bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000) -- Customize this based on the required force

            -- Connect the RenderStepped event to update the velocity
            connection = RunService.RenderStepped:Connect(function()
                if character and humanoid and humanoidRootPart then
                    local moveDirection = humanoid.MoveDirection
                    bodyVelocity.Velocity = moveDirection * speedsettings.Speed -- Multiply by 2 for double speed
                end
            end)
        end
    end
end

flysec:NewToggle("Enable Flight", "Enables Flight", function()
    toggleMovement()
end)

flysec:NewSlider("Flight Speed", "Adjust Flight Speed", 150, 5, function(Speed)
    speedsettings.FlightSpeed = Speed
end)

UserInputService.InputBegan:Connect(onKeyPress)
UserInputService.InputEnded:Connect(onKeyRelease)

-- Connect the function to the Heartbeat event for continuous update
RunService.Heartbeat:Connect(updateVelocity)

speedsec:NewToggle("Enable Speed", "Enables Speed", function()
    toggleVelocityUpdate()
end)

speedsec:NewSlider("Speed", "Adjust Speed", 150, 5, function(Speed)
    speedsettings.Speed = Speed
end)

local MovementSettings = {
    BHop = false,
    IsInfiniteJumpEnabled = false,
}

movementsec:NewToggle("Bunny Hop", "Enables Bhop", function()
    MovementSettings.BHop = not MovementSettings.BHop
end)

movementsec:NewToggle("Infinite Jump", "Enables Infinite Jump", function()
    MovementSettings.IsInfiniteJumpEnabled = not MovementSettings.IsInfiniteJumpEnabled
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if MovementSettings.IsInfiniteJumpEnabled == true then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)



local espToggle = EspSection:NewToggle("Enable ESP", "Enable Extra Sensory Perception", function()
    ESP_Toggle = not ESP_Toggle
end)

local tracerToggle = EspSection:NewToggle("Show Boxes", "Shows Boxes", function(bool)
    if bool == false then
        Settings.Box_Thickness = 0
    else
        Settings.Box_Thickness = 1
    end
end)

local thicknessslider = EspSection:NewSlider("Box Thickness", "BoxesThickness", 5, 1, function(t)
    Settings.Box_Thickness = t
end)

local tracerToggle = EspSection:NewToggle("Tracers", "Enable Tracers", function(bool)
    Settings.Tracers = bool
end)


local blockteam = EspSection:NewToggle("Hide Team", "Hides Teammates", function(bool)
    Team_Check.TeamCheck = bool
end)

local tracerToggle = distsec:NewToggle("Show Distance", "Shows Distance", function(bool)
    CESPSettings.IsNameESP = not CESPSettings.IsNameESP
end)

local textsizeslider = distsec:NewSlider("Text Size", "Adjust TextSize",25, 6, function(size)
    CESPSettings.textsize = size
end)
distsec:NewDropdown("Font", "Pick a font!", {"Arial", "Source Sans Pro", "Roboto", "Luckiest Guy"}, function(f)
    if f == "Arial" then
        CESPSettings.Font = Enum.Font.Arial
    else
        if f == "Source Sans Pro" then
            CESPSettings.Font = Enum.Font.SourceSansPro
        else
            if f == "Roboto" then
                CESPSettings.Font = Enum.Font.Roboto
            else 
                if f == "Luckiest Guy" then
                    CESPSettings.Font = Enum.Font.LuckiestGuy
                end
            end
        end
    end
end)


distsec:NewColorPicker("Text Color", "Distance Color?", Color3.fromRGB(255,125,0), function(color)
    CESPSettings .colour  = color
end)

local AimbotSettings = {
    FOV = 80,
    Targetpart = "Head",
    UseTeamCheck = false,
}
local target

local LocalPlayer = game.Players.LocalPlayer
local IsAimbotEnabled = false
local Mouse = LocalPlayer:GetMouse()
local aiming = false
local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera

local function closestPlayer()
    local closestDist = math.huge
    local closestPlayer = nil
    local mousePos = Vector2.new(Mouse.X, Mouse.Y) -- Get mouse position

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local head = character and character:FindFirstChild("Head")
            
            if head and humanoid and humanoid.Health > 0 then
                if player.Team ~= LocalPlayer.Team or not AimbotSettings.UseTeamCheck then
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

game:GetService("RunService").RenderStepped:Connect(function()
    if aiming then
        if target == nil then
            target = closestPlayer()
            wait() -- Wait for the next frame to ensure the target is updated
        end
        
        if target and IsAimbotEnabled and target.NRPBS.Health.Value > 0 then
            local r = math.random(1,100)
            if r < Settingoptions.HeadShotPercent then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character:FindFirstChild(AimbotSettings.Targetpart).Position)
            else 
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character:FindFirstChild("HumanoidRootPart").Position)
            end
        end
    end
end)


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

local TriggerBotSettings = {
    TriggerEnabled = false,
    Teamcheck = false,
}

triggersec:NewToggle("Enable Triggerbot", "Enables Triggerbot?", function()
    TriggerBotSettings.TriggerEnabled = not TriggerBotSettings.TriggerEnabled
end)

triggersec:NewToggle("Enable TeamCheck", "Enables TeamCheck?", function()
    TriggerBotSettings.Teamcheck = not TriggerBotSettings.Teamcheck
end)

RunService.RenderStepped:Connect(function()
    local MouseTarget = Mouse.Target
    if MouseTarget.Parent and MouseTarget.Parent:FindFirstChild("Head") and TriggerBotSettings.TriggerEnabled == true then
        if Players:FindFirstChild(MouseTarget.Parent.Name) and Players:FindFirstChild(MouseTarget.Parent.Name).Team ~= LocalPlayer.Team and TriggerBotSettings.Teamcheck == true then
            mouse1click()
        else
            if TriggerBotSettings.Teamcheck == false and TriggerBotSettings.TriggerEnabled == true then
                mouse1click()
            end
        end
    end
    if MovementSettings.BHop == true then
        if LocalPlayer.Character.Humanoid.Jump == false then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end
end)
