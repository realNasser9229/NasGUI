--[[
    Nasser's Terminal </>
    Legacy Theme GUI with Command Logging
    
    Instructions:
    1. Copy this code into a LocalScript in StarterPlayerScripts 
       OR paste into your executor.
    2. Press F9 to see internal errors if it doesn't load.
    
    Commands included for testing:
    - ws [number]   (Sets WalkSpeed)
    - jp [number]   (Sets JumpPower)
    - print [text]  (Prints text to console)
    - clear         (Clears the log)
    - exit          (Destroys the GUI)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Check for existing GUI to prevent duplicates
if game.CoreGui:FindFirstChild("NassersTerminal") then
    game.CoreGui.NassersTerminal:Destroy()
elseif LocalPlayer.PlayerGui:FindFirstChild("NassersTerminal") then
    LocalPlayer.PlayerGui.NassersTerminal:Destroy()
end

-- State variables to manage toggles (like Noclip/Fly)
local states = {
    noclipConnection = nil,
    flyBodyVelocity = nil,
    flyBodyGyro = nil
}
-- State management for fly loops
local flyState = {
    connection = nil,
    bv = nil,
    bg = nil
}


-- Helper: Find a player by partial name (e.g. "nas" -> "Nasser")
local function getPlayer(partialName)
    if not partialName then return nil end
    partialName = partialName:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #partialName) == partialName or 
           (plr.DisplayName and plr.DisplayName:lower():sub(1, #partialName) == partialName) then
            return plr
        end
    end
    return nil
end

-- 1. UI CONSTRUCTION
-- We create the instances manually so you don't need a file model.

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NassersTerminal"
ScreenGui.ResetOnSpawn = false
-- Try parenting to CoreGui for executors, fallback to PlayerGui
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Legacy Black/Gray
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true -- Important for input handling

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Font = Enum.Font.Code
TitleLabel.Text = "Nasser's Terminal </>"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Name = "LogScroll"
LogScroll.Parent = MainFrame
LogScroll.Active = true
LogScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LogScroll.BorderColor3 = Color3.fromRGB(60, 60, 60)
LogScroll.Position = UDim2.new(0, 10, 0, 40)
LogScroll.Size = UDim2.new(1, -20, 1, -80)
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto-scales
LogScroll.ScrollBarThickness = 6
LogScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = LogScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

local InputBox = Instance.new("TextBox")
InputBox.Parent = MainFrame
InputBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
InputBox.BorderColor3 = Color3.fromRGB(80, 80, 80)
InputBox.Position = UDim2.new(0, 10, 1, -35)
InputBox.Size = UDim2.new(1, -20, 0, 25)
InputBox.Font = Enum.Font.Code
InputBox.PlaceholderText = "Enter command..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextSize = 14
InputBox.TextXAlignment = Enum.TextXAlignment.Left

-- 2. DRAGGING LOGIC
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 3. LOGGING SYSTEM
local function addLog(text, color)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, 0, 0, 18) -- Fixed height per line
    label.TextWrapped = true
    label.Parent = LogScroll
    
    -- Auto-scroll to bottom
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    LogScroll.CanvasPosition = Vector2.new(0, 99999)
end

-- 4. COMMAND LOGIC

local commands = {}

-- Helper to safely get character
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Command: WalkSpeed
commands.ws = function(args)
    if #args < 1 then
        return false, "Usage: ws [number]"
    end
    local speed = tonumber(args[1])
    if not speed then
        return false, "Error: Argument must be a number."
    end
    
    local char = getChar()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
        return true, "WalkSpeed set to " .. speed
    else
        return false, "Error: Humanoid not found."
    end
end

-- Command: JumpPower
commands.jp = function(args)
    if #args < 1 then
        return false, "Usage: jp [number]"
    end
    local power = tonumber(args[1])
    if not power then
        return false, "Error: Argument must be a number."
    end
    
    local char = getChar()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.UseJumpPower = true
        char.Humanoid.JumpPower = power
        return true, "JumpPower set to " .. power
    else
        return false, "Error: Humanoid not found."
    end
end


-- 1. GOTO (Teleport to a player)
-- Usage: goto [playername]
commands.goto = function(args)
    if #args < 1 then return false, "Usage: goto [player_name]" end
    
    local target = getPlayer(args[1])
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            return true, "Teleported to " .. target.Name
        end
    end
    return false, "Error: Player not found or character missing."
end

-- 2. NOCLIP (Walk through walls)
-- Usage: noclip
commands.noclip = function(args)
    if states.noclipConnection then return false, "Noclip is already active." end
    
    states.noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    return true, "Noclip ENABLED (Type 'clip' to disable)"
end

-- 3. CLIP (Disable Noclip)
-- Usage: clip
commands.clip = function(args)
    if states.noclipConnection then
        states.noclipConnection:Disconnect()
        states.noclipConnection = nil
        return true, "Noclip DISABLED"
    end
    return false, "Noclip is not active."
end

-- COMMAND: FLY (Mobile & PC Friendly)
-- Usage: fly [speed] (optional number, default 50)
commands.fly = function(args)
    -- 1. Reset if already flying
    if flyState.connection then commands.unfly({}) end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return false, "Character missing." end

    -- 2. Setup Speed
    local speed = 50
    if args[1] and tonumber(args[1]) then
        speed = tonumber(args[1])
    end

    -- 3. Enable PlatformStand (Stops animations/gravity physics)
    hum.PlatformStand = true

    -- 4. Create Physics Movers
    local bv = Instance.new("BodyVelocity", root)
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    local bg = Instance.new("BodyGyro", root)
    bg.P = 9000
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.CFrame = root.CFrame

    flyState.bv = bv
    flyState.bg = bg

    -- 5. Start Loop (Heartbeat is better for physics)
    flyState.connection = RunService.Heartbeat:Connect(function()
        if not char.Parent or not root.Parent then
            commands.unfly({}) -- Safety cutoff
            return 
        end
        
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        local inputFound = false

        -- [[ PC CONTROLS ]]
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector inputFound = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector inputFound = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector inputFound = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector inputFound = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) inputFound = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) inputFound = true end

        -- [[ MOBILE CONTROLS ]]
        -- If no keyboard keys pressed, check Mobile Thumbstick (MoveDirection)
        if not inputFound and hum.MoveDirection.Magnitude > 0 then
            -- On mobile, if they push the stick, fly in the direction the CAMERA is facing
            moveDir = cam.CFrame.LookVector
            inputFound = true
        end

        -- Update Physics
        bg.CFrame = cam.CFrame -- Character always looks at camera direction
        bv.Velocity = moveDir * speed
    end)

    return true, "Fly ENABLED (Speed: "..speed..")"
end

-- COMMAND: UNFLY
-- Usage: unfly
commands.unfly = function(args)
    -- 1. Disconnect Loop
    if flyState.connection then
        flyState.connection:Disconnect()
        flyState.connection = nil
    end

    -- 2. Destroy Physics Objects
    if flyState.bv then flyState.bv:Destroy() flyState.bv = nil end
    if flyState.bg then flyState.bg:Destroy() flyState.bg = nil end

    -- 3. Disable PlatformStand (Resume normal walking)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
    
    return true, "Fly DISABLED"
end

-- 6. BTOOLS (Give Building Tools)
-- Usage: btools
commands.btools = function(args)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        local hammer = Instance.new("HopperBin")
        hammer.Name = "Hammer"
        hammer.BinType = Enum.BinType.Hammer
        hammer.Parent = backpack

        local clone = Instance.new("HopperBin")
        clone.Name = "Clone"
        clone.BinType = Enum.BinType.Clone
        clone.Parent = backpack
        
        local grab = Instance.new("HopperBin")
        grab.Name = "Grab"
        grab.BinType = Enum.BinType.Grab
        grab.Parent = backpack
        
        return true, "BTools added to Backpack."
    end
    return false, "Error: Backpack not found."
end

-- 10. REJOIN
-- Usage: rj
commands.rj = function(args)
    if #Players:GetPlayers() <= 1 then
        LocalPlayer:Kick("\nRejoining...")
        task.wait()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
    return true, "Rejoining server..."
end


-- Command: Clear Log
commands.clear = function(args)
    for _, child in pairs(LogScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    return true, "Console cleared."
end

-- Command: Exit
commands.destroy = function(args)
    ScreenGui:Destroy()
    return true, "Goodbye."
end

-- Command: Heal
commands.heal = function(args)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then
        return false, "Error: Humanoid not found."
    end

    char.Humanoid.Health = char.Humanoid.MaxHealth
    return true, "Health restored."
end

-- 7. FULLBRIGHT (See in the dark)
-- Usage: fb
commands.fb = function(args)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    return true, "Fullbright ENABLED"
end

-------------------------------------------------------------------
-- PLAYER HEALTH COMMANDS
-------------------------------------------------------------------

commands.health = function(args)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then
        return false, "Error: Humanoid not found."
    end
    if not tonumber(args[1]) then return false, "Usage: health [number]" end
    char.Humanoid.Health = tonumber(args[1])
    return true, "Health set to " .. args[1]
end

commands.maxhealth = function(args)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then
        return false, "Error: Humanoid not found."
    end
    if not tonumber(args[1]) then return false, "Usage: maxhealth [number]" end
    char.Humanoid.MaxHealth = tonumber(args[1])
    return true, "MaxHealth set to " .. args[1]
end

commands.reset = function(args)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
        return true, "Character reset."
    end
    return false, "Reset failed."
end

commands.refresh = function(args)
    LocalPlayer:LoadCharacter()
    return true, "Character refreshed."
end

-------------------------------------------------------------------
-- MOVEMENT + FUN COMMANDS
-------------------------------------------------------------------

commands.spin = function(args)
    local speed = tonumber(args[1]) or 5
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "Error: HRP not found." end

    _G.NasSpin = true
    task.spawn(function()
        while _G.NasSpin do
            hrp.CFrame *= CFrame.Angles(0, math.rad(speed), 0)
            task.wait()
        end
    end)
    return true, "Spin enabled."
end

commands.unspin = function(args)
    _G.NasSpin = false
    return true, "Spin disabled."
end

commands.jump = function(args)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.Jump = true return true, "Jumped." end
    return false, "No Humanoid."
end

-------------------------------------------------------------------
-- CAMERA / VIEW COMMANDS
-------------------------------------------------------------------

commands.fov = function(args)
    local cam = workspace.CurrentCamera
    if not tonumber(args[1]) then return false, "Usage: fov [number]" end
    cam.FieldOfView = tonumber(args[1])
    return true, "FOV set."
end

commands.view = function(args)
    if not args[1] then return false, "Usage: view [player]" end
    local target
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #args[1]:lower()) == args[1]:lower() then
            target = p
            break
        end
    end
    if not target or not target.Character then return false, "Player not found." end
    workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
    return true, "Viewing " .. target.Name
end

commands.unview = function(args)
    workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    return true, "Camera reset."
end

-------------------------------------------------------------------
-- COSMETIC / VISUAL COMMANDS
-------------------------------------------------------------------

commands.invisible = function(args)
    local char = LocalPlayer.Character
    if not char then return false, "Character not found." end
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") then v.Transparency = 1 end
    end
    return true, "Invisible."
end

commands.visible = function(args)
    local char = LocalPlayer.Character
    if not char then return false, "Character not found." end
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") then v.Transparency = 0 end
    end
    return true, "Visible again."
end

commands.headless = function(args)
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if head then head.Transparency = 1 return true, "Head hidden." end
    return false, "No head found."
end

commands.charcolor = function(args)
    if #args < 3 then return false, "Usage: charcolor r g b" end
    local r, g, b = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if not (r and g and b) then return false, "Invalid RGB." end
    
    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
        if p:IsA("BasePart") then
            p.Color = Color3.new(r/255, g/255, b/255)
        end
    end
    return true, "Character recolored."
end

-------------------------------------------------------------------
-- UTILITY COMMANDS
-------------------------------------------------------------------

commands.time = function(args)
    if not tonumber(args[1]) then return false, "Usage: time [number]" end
    game.Lighting.ClockTime = tonumber(args[1])
    return true, "Time set."
end

commands.notify = function(args)
    local msg = table.concat(args, " ")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Terminal";
        Text = msg ~= "" and msg or "No message";
        Duration = 3;
    })
    return true, "Notification sent."
end

commands.playsound = function(args)
    if not tonumber(args[1]) then return false, "Usage: playsound [id]" end
    local s = Instance.new("Sound", workspace)
    s.SoundId = "rbxassetid://" .. args[1]
    s.Volume = 1
    s:Play()
    game:GetService("Debris"):AddItem(s, 5)
    return true, "Playing sound ID " .. args[1]
end

commands.cmds = function(args)
    -- Collect all command names
    local names = {}
    for k,_ in pairs(commands) do
        table.insert(names, k)
    end
    table.sort(names)

    -- Log them in the terminal
    addLog("Available Commands:", Color3.fromRGB(150,150,255))
    for _, name in ipairs(names) do
        addLog(" - "..name, Color3.fromRGB(200,200,200))
    end

    return true, "Listed "..#names.." commands."
end

-------------------------------------------------------------------
-- EXTRA SAFETY / ANTI VOID
-------------------------------------------------------------------

commands.antivoid = function(args)
    _G.NasAntiVoid = true
    task.spawn(function()
        while _G.NasAntiVoid do
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -10 then
                hrp.CFrame = CFrame.new(hrp.Position.X, 5, hrp.Position.Z)
            end
            task.wait(0.2)
        end
    end)
    return true, "Anti-void enabled."
end

commands.unantivoid = function(args)
    _G.NasAntiVoid = false
    return true, "Anti-void disabled."
end

-------------------------------------------------------------------
-- PLAYER CONTROL / FUN
-------------------------------------------------------------------

commands.dance = function(args)
    local speed = tonumber(args[1]) or 1.6
    local char = LocalPlayer.Character
    if not char then return false, "Character not found." end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false, "Humanoid not found." end

    if hum.RigType == Enum.HumanoidRigType.R6 then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://140290021376754"
        _G.NasDanceTrack = hum:LoadAnimation(anim)
        _G.NasDanceTrack:Play()
        _G.NasDanceTrack:AdjustSpeed(speed)
        return true, "Dance started (R6) at speed " .. speed
    else
        return false, "Dance only works on R6."
    end
end

commands.undance = function(args)
    local char = LocalPlayer.Character
    if not char then return false, "Character not found." end
    local hum = char:FindFirstChild("Humanoid")
    if hum and _G.NasDanceTrack then
        _G.NasDanceTrack:Stop()
        _G.NasDanceTrack = nil
        return true, "Dance stopped."
    end
    return false, "No dance active."
end

commands.sittoggle = function(args)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return false, "Humanoid not found." end
    hum.Sit = not hum.Sit
    return true, hum.Sit and "You are now sitting." or "You are now standing."
end

commands.floatpad = function(args)
    local char = LocalPlayer.Character
    if not char then return false, "Character not found." end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "HRP not found." end
    local pad = Instance.new("Part")
    pad.Size = Vector3.new(6,1,6)
    pad.Transparency = 0.5
    pad.Anchored = true
    pad.CanCollide = true
    pad.CFrame = hrp.CFrame - Vector3.new(0,3,0)
    pad.Name = "NasFloatPad"
    pad.Parent = workspace
    hrp.CFrame = hrp.CFrame + Vector3.new(0,3,0)
    return true, "Float pad created."
end

commands.slide = function(args)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "HRP not found." end
    hrp.Velocity = hrp.CFrame.LookVector * 500
    return true, "Sliding forward."
end

-------------------------------------------------------------------
-- PLAYER APPEARANCE / VISUALS
-------------------------------------------------------------------

commands.hat = function(args)
    local id = tonumber(args[1])
    if not id then return false, "Usage: hat [assetid]" end
    local hat = Instance.new("Accessory")
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://"..id
    mesh.Parent = hat
    hat.Parent = LocalPlayer.Character
    return true, "Hat added."
end

commands.removehats = function(args)
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Accessory") then v:Destroy() end
    end
    return true, "All hats removed."
end

commands.trail = function(args)
    local color = args[1] or "Bright red"
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "HRP not found." end
    local trail = Instance.new("Trail", hrp)
    trail.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
    trail.Lifetime = 1
    return true, "Trail created."
end

commands.lights = function(args)
    local color = Color3.fromRGB(tonumber(args[1]) or 255, tonumber(args[2]) or 255, tonumber(args[3]) or 255)
    local light = Instance.new("PointLight", LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso"))
    light.Color = color
    light.Brightness = 2
    light.Range = 15
    return true, "Light added to character."
end

commands.glow = function(args)
    local color = Color3.fromRGB(tonumber(args[1]) or 255, tonumber(args[2]) or 255, tonumber(args[3]) or 255)
    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
        if p:IsA("BasePart") then
            local box = Instance.new("SelectionBox", p)
            box.Adornee = p
            box.Color3 = color
        end
    end
    return true, "Glow effect applied."
end

commands.smoke = function(args)
    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
        if p:IsA("BasePart") then
            local s = Instance.new("Smoke", p)
            s.RiseVelocity = 2
            s.Size = 5
        end
    end
    return true, "Smoke added to character."
end

commands.fire = function(args)
    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
        if p:IsA("BasePart") then
            local f = Instance.new("Fire", p)
            f.Heat = 5
            f.Size = 5
        end
    end
    return true, "Fire added to character."
end

commands.sparkles = function(args)
    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
        if p:IsA("BasePart") then
            Instance.new("Sparkles", p)
        end
    end
    return true, "Sparkles added to character."
end

-------------------------------------------------------------------
-- ENVIRONMENT / WORLD
-------------------------------------------------------------------

commands.gravityup = function(args)
    local n = tonumber(args[1]) or 196.2
    workspace.Gravity = n
    return true, "Gravity set to "..n
end

commands.gravitydown = function(args)
    local n = tonumber(args[1]) or 50
    workspace.Gravity = n
    return true, "Gravity set to "..n
end

commands.day = function(args)
    game.Lighting.ClockTime = 14
    return true, "Time set to day."
end

commands.night = function(args)
    game.Lighting.ClockTime = 2
    return true, "Time set to night."
end

commands.fog = function(args)
    local startFog = tonumber(args[1]) or 0
    local endFog = tonumber(args[2]) or 100
    game.Lighting.FogStart = startFog
    game.Lighting.FogEnd = endFog
    return true, "Fog applied."
end

commands.clearfog = function(args)
    game.Lighting.FogEnd = 100000
    game.Lighting.FogStart = 0
    return true, "Fog cleared."
end

commands.lighting = function(args)
    local preset = args[1] or "bright"
    if preset == "bright" then
        game.Lighting.Brightness = 2
        game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
    elseif preset == "dark" then
        game.Lighting.Brightness = 0.3
        game.Lighting.OutdoorAmbient = Color3.new(0.1,0.1,0.1)
    elseif preset == "cool" then
        game.Lighting.Brightness = 1
        game.Lighting.OutdoorAmbient = Color3.new(0,0.5,1)
    elseif preset == "warm" then
        game.Lighting.Brightness = 1
        game.Lighting.OutdoorAmbient = Color3.new(1,0.5,0)
    end
    return true, "Lighting preset applied: "..preset
end

-------------------------------------------------------------------
-- PLAYER INTERACTION / UTILITY
-------------------------------------------------------------------

commands.tp = function(args)
    if not args[1] then return false, "Usage: tp [player]" end
    local target
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1,#args[1]:lower()) == args[1]:lower() then
            target = p
            break
        end
    end
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return false, "Player not found." end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "HRP not found." end
    hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    return true, "Teleported to "..target.Name
end

commands.bring = function(args)
    if not args[1] then return false, "Usage: bring [player]" end
    local target
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1,#args[1]:lower()) == args[1]:lower() then
            target = p
            break
        end
    end
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return false, "Player not found." end
    local hrp = target.Character.HumanoidRootPart
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false, "Your HRP not found." end
    hrp.CFrame = myHRP.CFrame + Vector3.new(0,3,0)
    return true, "Brought "..target.Name.." near you."
end

commands.track = function(args)
    if not args[1] then return false, "Usage: track [player]" end
    local target
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1,#args[1]:lower()) == args[1]:lower() then
            target = p
            break
        end
    end
    if not target or not target.Character then return false, "Player not found." end
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Size = Vector3.new(1,1,1)
    part.Material = Enum.Material.Neon
    part.Color = Color3.new(1,0,0)
    part.Name = "NasTrack_"..target.Name
    part.Parent = workspace
    task.spawn(function()
        while part.Parent do
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                part.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
            task.wait(0.1)
        end
    end)
    return true, "Tracking "..target.Name
end

commands.untrack = function(args)
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:match("NasTrack_") then v:Destroy() end
    end
    return true, "All tracking removed."
end

commands.closest = function(args)
    local closest = nil
    local dist = math.huge
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false, "HRP not found." end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
            if d < dist then dist = d; closest = p end
        end
    end
    if closest then return true, "Closest player: "..closest.Name.." ("..math.floor(dist).." studs)" end
    return false, "No players found."
end

commands.distance = function(args)
    if not args[1] then return false, "Usage: distance [player]" end
    local target
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false, "HRP not found." end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1,#args[1]:lower()) == args[1]:lower() then target = p break end
    end
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return false, "Player not found." end
    local d = (target.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
    return true, "Distance to "..target.Name..": "..math.floor(d).." studs"
end

-------------------------------------------------------------------
-- AUDIO / FUN
-------------------------------------------------------------------

commands.music = function(args)
    if not tonumber(args[1]) then return false, "Usage: music [id]" end
    local s = Instance.new("Sound", workspace)
    s.SoundId = "rbxassetid://"..args[1]
    s.Looped = true
    s.Volume = 1
    s.Name = "NasMusic"
    s:Play()
    return true, "Music started (ID: "..args[1]..")"
end

commands.stopmusic = function(args)
    for _, s in pairs(workspace:GetChildren()) do
        if s:IsA("Sound") and s.Name == "NasMusic" then s:Stop(); s:Destroy() end
    end
    return true, "Music stopped."
end

-------------------------------------------------------------------
-- CAMERA / SCREEN EFFECTS
-------------------------------------------------------------------

commands.follow = function(args)
    if not args[1] then return false, "Usage: follow [player]" end
    local target
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1,#args[1]:lower()) == args[1]:lower() then target = p break end
    end
    if not target or not target.Character or not target.Character:FindFirstChild("Humanoid") then return false, "Player not found." end
    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    return true, "Camera following "..target.Name
end

commands.unfollow = function(args)
    workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    return true, "Camera reset to self."
end



-- 5. EXECUTION HANDLER

InputBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    
    local inputText = InputBox.Text
    if inputText == "" then return end
    
    InputBox.Text = "" -- Clear input
    
    -- 1. Log the user input (White)
    addLog("> " .. inputText, Color3.fromRGB(255, 255, 255))
    
    -- Parse command
    local args = inputText:split(" ")
    local cmdName = table.remove(args, 1):lower() -- Remove first word (command name)
    
    local cmdFunc = commands[cmdName]
    
    if cmdFunc then
        -- 2. Log "Running..." (Green)
        addLog(" Running command...", Color3.fromRGB(0, 255, 0))
        
        -- Artificial delay for "Terminal feel" (optional, remove wait if wanted instant)
        task.wait(0.2) 
        
        -- Execute
        local success, msg = cmdFunc(args)
        
        if success then
            -- Success message (Green or Light Gray)
            addLog(" " .. msg, Color3.fromRGB(150, 255, 150))
        else
            -- Usage Error (Red)
            addLog(" " .. msg, Color3.fromRGB(255, 80, 80))
        end
    else
        -- Command not found Error (Red)
        addLog(" Error: Command '"..cmdName.."' not found.", Color3.fromRGB(255, 80, 80))
    end
end)

-- Initial Welcome Message
addLog("Welcome to Nasser's Terminal v1.0", Color3.fromRGB(100, 100, 255))
addLog("Type 'ws 100' or 'jp 50' to test.", Color3.fromRGB(150, 150, 150))
