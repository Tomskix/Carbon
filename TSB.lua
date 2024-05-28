
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Carbon - The Strongest Battlegrounds", "DarkTheme")

local CombatTab = Window:NewTab("Combat")
local BalantTab = Window:NewTab("Balant")

local PVPSection = CombatTab:NewSection("PVP")
local BalantSec = BalantTab:NewSection("Balant")

-- TOGGLES

local CombatSettings = {
    IsStunEnabled = false,
    TargetWS = 16,
    TargetJP = 50,
    HighlightDC = false,
    Distance = 3,
}
local PlayerList = {}

for i,v in game.Players:GetPlayers() do
    table.insert(PlayerList, v.DisplayName)
end



PVPSection:NewSlider("WalkSpeed", "Speed for Walking?", 15, 1, function(ws)
    CombatSettings.TargetWS = ws
end)

PVPSection:NewSlider("JumpPower", "JumpPower for Jumping?", 500, 50, function(jp)
    CombatSettings.TargetJP = jp
end)

BalantSec:NewToggle("No Stun", "Disable Stun", function(bool)
    CombatSettings.IsStunEnabled = bool
end)

PVPSection:NewToggle("Show Death Counter", "Highlights Death Counter", function(bool)
    CombatSettings.HighlightDC = bool
end)

PVPSection:NewButton("Pick up Trashcan", "Gets Trashcan", function(bool)
    local HCF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Trash.Trashcan.Trashcan.CFrame
    repeat
        if game.Players.LocalPlayer.Character:FindFirstChild("Trash Can")== nil then
            mouse1click()
        end
        task.wait(0.1)
    until game.Players.LocalPlayer.Character:FindFirstChild("Trash Can")~= nil
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = HCF
end)

local PlayerListDown = BalantSec:NewDropdown("Kill Player","Kills Player?", PlayerList, function(display)
    local targetplayer
    for i,v in game.Players:GetPlayers() do
        if v.DisplayName == display then
            targetplayer = v
        end
    end

    local TargetPlayer = targetplayer
    local TargetPart = TargetPlayer.Character.HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local Float = Instance.new('Part')
    Float.Name = "floater"
    Float.Parent = game.Players.LocalPlayer.Character
    Float.Transparency = 1
    Float.Size = Vector3.new(2,0.2,1.5)
    Float.Anchored = true
    local FloatValue = -3.1
    game:GetService("RunService").RenderStepped:Connect(function()
    if TargetPart.Parent.Humanoid and TargetPart.Parent.Humanoid.Health > 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(TargetPart.CFrame.X, TargetPart.CFrame.Y - CombatSettings.Distance, TargetPart.CFrame.Z)
        Float.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,FloatValue,0)
    end
    end)
end)

local DistanceSlider = BalantSec:NewSlider("Kill Distance", "Distance? Idk", 10, 2, function(d)
    CombatSettings.Distance = d
end)

game.Players.LocalPlayer.Character.DescendantAdded:Connect(function(dec)
    print(dec.ClassName)

    if dec.Name == "RagdollSim" and CombatSettings.IsStunEnabled == true then
        game.Players.LocalPlayer.Character:FindFirstChild("Torso").Anchored = true
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("RagdollSim")==nil
        repeat
            game.Players.LocalPlayer.Character:FindFirstChild("Torso").Anchored = false
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("Torso").Anchored == false
    end

    if dec.Name == "Freeze"or dec.Name == "NoRotate" or dec:IsA("BodyVelocity") or dec.Name == "RagdollSim" or dec.Name == "BeingGrabbed" and dec.Name == "Freeze" or dec.Name == "NoJump" or dec.Name == "NoBlock" or dec.Name == "M1ing" or dec.Name == "UsedDash" and CombatSettings.IsStunEnabled == true then
        SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        SetStateEnabled(Enum.HumanoidStateType.Running, true)
        dec:Destroy()
    end
end)

workspace.Live.DescendantAdded:Connect(function(dec)

    if dec.Name == "Counter" and CombatSettings.HighlightDC == true then
        local dparent = dec.Parent
        local a = Instance.new("Highlight", dec.Parent)
        wait(15)
        a:Destroy()
    end
end)


game:GetService("RunService").RenderStepped:Connect(function()
    game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = CombatSettings.TargetJP
end)

game.Players.PlayerAdded:Connect(function(plr)
    table.insert(PlayerList, plr.DisplayName)
    PlayerListDown:Refresh(PlayerList)
end)
game.Players.PlayerRemoving:Connect(function(plr)
    for i,v in PlayerList do
        if v == plr.DisplayName then
            table.remove(PlayerList, i)
        end
    end
    PlayerListDown:Refresh(PlayerList)
end)

function onchar()
    game:GetService("RunService").Heartbeat:Connect(function()
        chr = game.Players.LocalPlayer.Character
        hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        hb = game:GetService("RunService").Heartbeat
        local delta = hb:wait()
        if hum.MoveDirection.Magnitude > 0 then
            chr:TranslateBy(hum.MoveDirection * CombatSettings.TargetWS * delta * 10)
        else
            chr:TranslateBy(hum.MoveDirection * delta * 10)
        end
    end)
end



onchar()
