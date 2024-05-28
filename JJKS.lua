local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
 
local Window = Library.CreateLib("Carbon - Jujutsu Shenanigans", "DarkTheme")
local UIS = game:GetService("UserInputService")
local CombatTab = Window:NewTab("Combat")
local BalantTab = Window:NewTab("Balant")
 
local PVPSection = CombatTab:NewSection("PVP")
local BalantSec = BalantTab:NewSection("Balant")

local PVPSettings = {
    AvoidDomains = false,
}

local MovementSettings = {
    TargetWS = 16,
    InfJumpEnabled = false,
    DisableStun = false,
    Noclip = false,
}

BalantSec:NewSlider("WalkSpeed", "Increase Walkspeed", 150, 16, function(ws)
    MovementSettings.TargetWS = ws
end)

BalantSec:NewToggle("Infinite Jump", "Enable Infinite Jump", function(bool)
    MovementSettings.InfJumpEnabled = bool
end)
BalantSec:NewToggle("Enable Noclip", "Enables Noclip", function(bool)
    MovementSettings.Noclip = not MovementSettings.Noclip
end)

PVPSection:NewToggle("No Stun", "Disable Stun", function(bool)
    MovementSettings.DisableStun = bool
end)

PVPSection:NewToggle("Domain Escape", "Escapes Domains", function(bool)
    PVPSettings.AvoidDomains = bool
end)

game:GetService("RunService").RenderStepped:Connect(function()
    for i,v in game.Players.LocalPlayer.Character:GetDescendants() do
        if v:IsA("Part") then
            v.Anchored = false
        end
    end
    if MovementSettings.Noclip == true then
        print("SIGMA")
         for i,v in game.Players.LocalPlayer.Character:GetDescendants() do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end

    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = MovementSettings.TargetWS
end)

UIS.JumpRequest:Connect(function()
    if MovementSettings.InfJumpEnabled == true then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)


workspace.DescendantAdded:Connect(function(dec)
    if dec.Parent.Name == "Info" and dec.Parent.Parent == game.Players.LocalPlayer.Character and MovementSettings.DisableStun == true then
        print(dec.Name)
        if dec.Value then dec.Value = false end
        dec:Destroy()
    end
    if dec.Parent.Name == "Domains" then
        if PVPSettings.AvoidDomains == true then
            local Dist = (dec.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Dist < 15 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X + 15, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
            end
        end
    end
end)
