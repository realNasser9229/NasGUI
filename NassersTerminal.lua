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

-- ============================================
--  ANTI-CHEAT DETECTOR + CONDITIONAL LOADSTRING
-- ============================================

local Players = game:GetService("Players")
local AC_Service = game:GetService("ReplicatedStorage")
local AC_SS = game:GetService("ServerScriptService")

local function isStrongAntiCheat()
    -- STRONG SERVER-SIDE AC CHECKS
    local severe = {
        "AC", "AntiCheat", "ServerAC", "Detection",
        "SecureHandler", "ServerSecurity", "SAC"
    }

    -- Check ServerScriptService for strong server scripts
    for _, obj in ipairs(AC_SS:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("ModuleScript") then
            for _, word in ipairs(severe) do
                if string.find(obj.Name:lower(), word:lower()) then
                    return true
                end
            end
        end
    end

    -- Check ReplicatedStorage for exposed server AC remotes
    for _, obj in ipairs(AC_Service:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            for _, word in ipairs(severe) do
                if string.find(obj.Name:lower(), word:lower()) then
                    return true
                end
            end
        end
    end

    return false
end

-- ============================================
--  CONDITIONAL SAFE LOADSTRING
-- ============================================

local function runAdonisBypassIfSafe()
    if isStrongAntiCheat() then
        warn("[Terminal] Strong anti-cheat detected. Cancelling the bypass.")
        return false
    end

    -- SAFE TO RUN CLIENT-SIDE LOCAL BYPASS
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-adonis-admin-bypass-19375"))()

    warn("[Terminal] Weak AC detected, bypassing the remaining anti-cheat...")
    return true
end

-- ============================================
--  RUN SAFETY CHECK BEFORE LOADING TERMINAL GUI
-- ============================================

runAdonisBypassIfSafe()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- mainGui = the main terminal UI frame
-- Replace 'mainGui' with whatever your variable is called
local TerminalUI = mainGui  

-- === Create red X Minimize button ===
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = TerminalUI
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.ZIndex = 999

-- Create a ScreenGui to hold the restore button (safe parent)
local restoreGui = Instance.new("ScreenGui")
restoreGui.Name = "TerminalRestoreGui"
restoreGui.ResetOnSpawn = false

-- Try CoreGui first (executor-friendly), fallback to PlayerGui
if not pcall(function()
    restoreGui.Parent = game:GetService("CoreGui")
end) then
    restoreGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Create the draggable circle restore button inside the ScreenGui
local restoreBtn = Instance.new("TextButton")
restoreBtn.Name = "TerminalRestoreButton"
restoreBtn.Size = UDim2.new(0, 60, 0, 60)
restoreBtn.Position = UDim2.new(0.2, 0, 0.4, 0)
restoreBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
restoreBtn.Text = "</>"
restoreBtn.TextScaled = true
restoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreBtn.Visible = false
restoreBtn.Active = true
restoreBtn.ClipsDescendants = true
restoreBtn.Parent = restoreGui
restoreBtn.ZIndex = 9999

-- Rounded circle shape
local ui = Instance.new("UICorner")
ui.CornerRadius = UDim.new(1, 0)
ui.Parent = restoreBtn

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
local activeOrbits = {}


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
TitleLabel.Text = "Nasser's Terminal FE </>"
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
---------------------------
-- TRUE TFLING ENGINE
---------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local hiddenfling = false
local movel = 0.1
local flingPower = 9990000000000000 -- your preferred extreme power

local function getHRP()
	local char = lp.Character or lp.CharacterAdded:Wait()
	return char:FindFirstChild("HumanoidRootPart")
end

-- Permanent fling loop (disabled until commands toggle it)
task.spawn(function()
	while true do
		RunService.Heartbeat:Wait()
		if hiddenfling then
			local HRP = getHRP()
			if HRP then
				local vel = HRP.Velocity
				HRP.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
				
				RunService.RenderStepped:Wait()
				if HRP then HRP.Velocity = vel end
				
				RunService.Stepped:Wait()
				if HRP then
					HRP.Velocity = vel + Vector3.new(0, movel, 0)
					movel = -movel
				end
			end
		end
	end
end)

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

commands.fpsunlock = function(args)
    if #args < 1 then
        return false, "Usage: fpsunlock {number}"
    end

    local cap = tonumber(args[1])
    if not cap then
        return false, "FPS cap must be a number."
    end

    -- Roblox internal variable (client only)
    setfpscap(cap)

    return true, "FPS cap set to "..cap
end

commands.tfling = function()
    hiddenfling = true
    return true, "Tfling enabled."
end

commands.untfling = function()
    hiddenfling = false
    return true, "Tfling disabled."
end

local activeOrbits = {}
-- Orbit a player
commands.orbit = function(args)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    if #args < 2 then
        return false, "Usage: orbit {player} {speed}"
    end

    local targetName, speedArg = args[1], tonumber(args[2])
    if not speedArg then return false, "Speed must be a number." end

    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return false, "Target player not found or missing HRP."
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return false, "Your character not ready."
    end

    local hrp = char.HumanoidRootPart
    local angle = 0

    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect()
            return
        end
        angle = angle + dt * speedArg
        local radius = 10
        local offset = Vector3.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)
        hrp.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + offset, target.Character.HumanoidRootPart.Position)
    end)

    return true, "Orbiting "..targetName.." at speed "..speedArg
end

-- Set a player display name locally
commands.setname = function(args)
    local Players = game:GetService("Players")
    if #args < 2 then return false, "Usage: setname {player} {text}" end

    local targetName, newName = args[1], table.concat({select(2, table.unpack(args))}, " ")
    local target = Players:FindFirstChild(targetName)
    if not target then return false, "Player not found." end

    if target:FindFirstChild("PlayerGui") then
        target.DisplayName = newName -- Local only change
        return true, targetName.." display name changed to "..newName.." (client-sided)"
    else
        return false, "Target player character not loaded."
    end
end

-- r6 animations on r15
commands.r6onr15 = function(args)
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-R6-Animations-on-R15-16865"))()
end

-- korblox
commands.korblox = function(args)
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Korblox-R6-28939"))()
end

-- spiderman (walk on walls)
commands.spiderman = function(args)
    loadstring(game:HttpGet("https://rawscripts.net/raw/FE-walk-on-walls_206"))()
end

-- FE Disabled SaveInstance bypass (client-side)
commands.fedisabledsaveinstance = function(args)
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FilteringDisable-For-SaveInstance-27147"))()
end

-- stop orbit
commands.stoporbit = function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    if activeOrbits[lp] then
        activeOrbits[lp]:Disconnect()
        activeOrbits[lp] = nil
    end
end

commands.droptool = function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local char = lp.Character
    if not char then
        return false, "Character not found."
    end

    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then
        return false, "You are not holding a tool."
    end

    if tool.CanBeDropped == false then
        return false, "This tool cannot be dropped."
    end

    tool.Parent = workspace

    return true, "Dropped tool."
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

-- ======================================================
--   CLIENT INTERNAL DIAGNOSTICS COMMANDS (SAFE)
-- ======================================================

local lastHeartbeat = 0
local fps = 60

RunService.Heartbeat:Connect(function(dt)
    fps = math.floor(1 / dt)
end)

-- 1) fps — show Frames Per Second
commands.fps = function(args)
    return true, "FPS: " .. tostring(fps)
end

-- 2) ping — network ping from stats
commands.ping = function(args)
    local net = Stats.Network
    local ping = net.ServerStatsItem["Data Ping"]:GetValue()
    return true, "Ping: " .. math.floor(ping) .. " ms"
end

commands.credits = function()
    local lines = {
        "=== CREDITS ===",
        "OWNER:       Nasser9229 / nas9229alt",
        "INSPIRATION: Janny / 1602sasa",
        "TESTER:      Fotis / fotis19902",
        "================"
    }

    for _, msg in ipairs(lines) do
        addToTerminal(msg)
    end

    return true, "They contributed a LOT for this script..."
end

-- 3) mem — memory categories
commands.mem = function(args)
    local categories = Stats:GetChildren()
    local out = {}
    for _, cat in ipairs(categories) do
        if cat:GetValue() > 0 then
            table.insert(out, cat.Name .. " = " .. math.floor(cat:GetValue()/1024/1024) .. " MB")
        end
    end
    return true, "Memory Categories:\n" .. table.concat(out, "\n")
end

-- 4) gc — garbage collector usage
commands.gc = function(args)
    local kb = collectgarbage("count")
    return true, "Lua Garbage Collector: " .. math.floor(kb) .. " KB"
end

-- 5) connections {instance} — list getconnections of object
commands.connections = function(args)
    if #args < 1 then
        return false, "Usage: connections {InstanceName}"
    end

    local obj = game:GetService("Players").LocalPlayer:FindFirstChild(args[1], true)
        or workspace:FindFirstChild(args[1], true)

    if not obj then
        return false, "Instance not found."
    end

    local list = getconnections(obj)
    local text = {}
    for i,v in ipairs(list) do
        table.insert(text, "["..i.."] " .. tostring(v.Function))
    end

    return true, "Connections for "..obj.Name..":\n" .. table.concat(text, "\n")
end

-- 6) camstate — camera diagnostic dump
commands.camstate = function(args)
    local cam = workspace.CurrentCamera
    local info = {
        "Camera Type: " .. tostring(cam.CameraType),
        "Field of View: " .. tostring(cam.FieldOfView),
        "CFrame: " .. tostring(cam.CFrame.Position),
        "Focus: " .. tostring(cam.Focus.Position)
    }
    return true, table.concat(info, "\n")
end

-- 7) netowner {part} — shows network ownership of a part
commands.netowner = function(args)
    if #args < 1 then return false, "Usage: netowner {PartName}" end

    local part = workspace:FindFirstChild(args[1], true)
    if not part or not part:IsA("BasePart") then
        return false, "Part not found or not a BasePart."
    end
    
    local owner = part:GetNetworkOwner()
    return true, "Network Owner: " .. (owner and owner.Name or "Server")
end

-- 8) region — shows replication focus / area of interest
commands.region = function()
    local focus = LocalPlayer.ReplicationFocus
    return true, "Replication Focus: " .. (focus and focus:GetFullName() or "None")
end

-- 9) perf — Roblox PerformanceStats breakdown
commands.perf = function()
    local perf = Stats.PerformanceStats
    local out = {}
    for _, stat in ipairs(perf:GetChildren()) do
        table.insert(out, stat.Name .. ": " .. tostring(stat:GetValue()))
    end
    return true, "Performance Stats:\n" .. table.concat(out, "\n")
end

-- 10) events — list signals on RunService & input services
commands.events = function()
    local out = {
        "RenderStepped connected: " .. #getconnections(RunService.RenderStepped),
        "Heartbeat connected: " .. #getconnections(RunService.Heartbeat),
        "Stepped connected: " .. #getconnections(RunService.Stepped),
        "InputBegan: " .. #getconnections(game:GetService('UserInputService').InputBegan),
        "InputEnded: " .. #getconnections(game:GetService('UserInputService').InputEnded),
    }
    return true, "Signal Connection Counters:\n" .. table.concat(out, "\n")
end

-- 11) camdelta — frame delta times
commands.camdelta = function()
    return true, "Last frame delta: " .. tostring(RunService.RenderStepped:Wait())
end

-- 12) physstats — physics throttling info
commands.physstats = function()
    local ps = Stats.PhysicsStats
    local out = {}
    for _, child in ipairs(ps:GetChildren()) do
        table.insert(out, child.Name .. ": " .. tostring(child:GetValue()))
    end
    return true, "PhysicsStats:\n" .. table.concat(out, "\n")
end

-- 13) trace <function> — debug.info introspection (safe)
commands.trace = function(args)
    if #args < 1 then return false, "Usage: trace {functionNameIngetfenv}" end
    
    local fn = getfenv()[args[1]]
    if typeof(fn) ~= "function" then return false, "Not a function" end

    local out = {
        "Source: " .. tostring(debug.info(fn, "s")),
        "Line Defined: " .. tostring(debug.info(fn, "l")),
        "What: " .. tostring(debug.info(fn, "t")),
        "Name: " .. tostring(debug.info(fn, "n")),
    }
    return true, "Function Trace:\n" .. table.concat(out, "\n")
end

commands.say = function(args)
    local message = table.concat(args, " ")
    if message == "" then
        return false, "Usage: say {text}"
    end

    local TextChatService = game:GetService("TextChatService")

    -- Uses Roblox's official chat API
    TextChatService.TextChannels.RBXGeneral:SendAsync(message)

    return true, "Sent: " .. message
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

commands.devconsole = function(args)
    local StarterGui = game:GetService("StarterGui")

    -- Try to open console
    local ok = pcall(function()
        StarterGui:SetCore("DevConsoleVisible", true)
    end)

    if ok then
        addLog("Opened Developer Console.", Color3.fromRGB(200,200,255))
        return true, "Console opened."
    else
        addLog("Failed to open Developer Console.", Color3.fromRGB(255,100,100))
        return false, "Failed to open console."
    end
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

commands.firstp = function(args)
    local cam = workspace.CurrentCamera
    local lp = game:GetService("Players").LocalPlayer

    -- Optional FOV argument (default 70)
    local fov = tonumber(args[1]) or 70

    cam.FieldOfView = fov

    -- Puts camera inside the head without locking camera mode
    lp.CameraMode = Enum.CameraMode.Classic  
    cam.CameraType = Enum.CameraType.Custom

    cam.CFrame = lp.Character.Head.CFrame

    addLog("First person view enabled (FOV "..fov..")", Color3.fromRGB(200,200,255))
    return true, "firstp executed."
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

-- 7. SPIN FLING (Chaos mode)
-- Usage: sfling
commands.sfling = function(args)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false, "Character missing." end
    
    commands.noclip({}) -- Auto noclip so you don't get stuck
    
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "FlingVelocity"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(10000, 10000, 10000) -- EXTREME SPIN
    bav.Parent = root
    
    return true, "SPIN FLING MODE ACTIVATED (Touch people to fling them)"
end

-- 8. UNFLING
-- Usage: unfling
commands.unsfling = function(args)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("FlingVelocity") then
        root.FlingVelocity:Destroy()
        -- Stop physics rotation
        root.RotVelocity = Vector3.zero
        commands.clip({}) -- Turn collision back on
        return true, "Spin Fling stopped."
    end
    return false, "You aren't flinging."
end

-- 9. HIPHEIGHT (Long Legs)
-- Usage: hheight [number] (Default is usually 0 or 2)
commands.hheight = function(args)
    if #args < 1 then return false, "Usage: hh [number]" end
    local height = tonumber(args[1])
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.HipHeight = height
        return true, "HipHeight set to " .. height
    end
    return false, "Humanoid not found."
end

-- 2. TIME
-- Usage: time [hour] (0-24)
commands.time = function(args)
    if #args < 1 then return false, "Usage: time [hour] (0-24)" end
    local hour = tonumber(args[1])
    
    if hour == nil or hour < 0 or hour > 24 then return false, "Error: Hour must be a number between 0 and 24." end
    
    -- This sets the time ONLY for the local player (client-side)
    Lighting.ClockTime = hour
    return true, "Time set to " .. string.format("%.1f", hour)
end

-- 3. INFINITE JUMP
-- Usage: ij
commands.infjump = function(args)
    if ijConnection then return false, "Infinite Jump is already active." end
    
    ijConnection = UserInputService.JumpRequest:Connect(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    return true, "Infinite Jump ENABLED (Press jump repeatedly)"
end

-- 4. UNINFINITE JUMP
-- Usage: unij
commands.uninfjump = function(args)
    if ijConnection then
        ijConnection:Disconnect()
        ijConnection = nil
        return true, "Infinite Jump DISABLED."
    end
    return false, "Infinite Jump is not active."
end

-- 5. SIZE
-- Usage: size [scale]
commands.size = function(args)
    if #args < 1 then return false, "Usage: size [scale] (e.g., 5 for giant, 0.5 for small)" end
    local scale = tonumber(args[1])
    
    if scale == nil or scale <= 0 then return false, "Error: Scale must be a positive number." end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:Resize(scale) -- Attempts to resize the character components
            return true, "Character size set to scale " .. scale
        end
    end
    return false, "Character or Humanoid not found."
end

-- 6. FORCEFIELD (Makes you immune to fall damage/knockback visually)
-- Usage: ff
commands.ff = function(args)
    local char = LocalPlayer.Character
    if char then
        if char:FindFirstChild("ForceField") then
            return false, "ForceField is already active."
        end
        local ff = Instance.new("ForceField")
        ff.Parent = char
        return true, "ForceField ENABLED."
    end
    return false, "Character not found."
end

-- 7. UNFORCEFIELD
-- Usage: unff
commands.unff = function(args)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("ForceField") then
        char.ForceField:Destroy()
        return true, "ForceField DISABLED."
    end
    return false, "ForceField is not active."
end

local currentSpamConnection = nil
local currentAuraPart = nil
local ctpConnection = nil -- Click Teleport state

-- 1. GOD MODE (Infinite Health)
-- Usage: god
commands.god = function(args)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return false, "Character missing." end

    -- Set max health high and constantly heal
    hum.MaxHealth = math.huge
    hum.Health = math.huge

    local healthConnection = hum.HealthChanged:Connect(function(newHealth)
        if newHealth < hum.MaxHealth then
            hum.Health = hum.MaxHealth -- Auto-heal on damage
        end
    end)

    -- Save the connection so we can reverse it if needed (though not strictly necessary for god mode)
    if not char:FindFirstChild("GodModeConnection") then
        local stringValue = Instance.new("StringValue")
        stringValue.Name = "GodModeConnection"
        stringValue.Value = tostring(healthConnection) -- Store connection handle (hacky, but works)
        stringValue.Parent = char
    end
    
    return true, "God Mode ENABLED (Health: ∞)"
end

commands.script = function(args)
    if #args == 0 then
        return false, "Usage: script {lua code}"
    end

    -- Merge all arguments into one Lua code string
    local code = table.concat(args, " ")

    -- Try to compile
    local fn, err = loadstring(code)
    if not fn then
        return false, "Compile error: " .. tostring(err)
    end

    -- Execute safely
    local ok, runtimeErr = pcall(fn)
    if not ok then
        return false, "Runtime error: " .. tostring(runtimeErr)
    end

    return true, "Script executed."
end

-- 4. CLICK TELEPORT (Teleport where the mouse clicks)
-- Usage: ctp
commands.ctp = function(args)
    if ctpConnection then return false, "Click Teleport is already active." end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false, "Character missing." end

    ctpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
        
        local mouse = LocalPlayer:GetMouse()
        local targetPos = mouse.Hit.p
        
        if targetPos then
            -- Teleport 3 studs above the click position to avoid getting stuck
            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        end
    end)
    return true, "Click Teleport ENABLED (Right-click to move)"
end

-- 5. UNCLICK TELEPORT
-- Usage: unctp
commands.unctp = function(args)
    if ctpConnection then
        ctpConnection:Disconnect()
        ctpConnection = nil
        return true, "Click Teleport DISABLED."
    end
    return false, "Click Teleport is not active."
end

commands.leave = function(args)
    addLog("Leaving game...", Color3.fromRGB(255,150,150))

    -- Fake support if someone tries to use Shutdown()
    if game.Shutdown then
        pcall(function()
            game:Shutdown()
        end)
    end
    return true, "Bye!"
end

commands.disablememorycategorycounters = function(args)
    local CoreGui = game:GetService("CoreGui")
    local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")

    if not devConsole then
        return false, "DevConsole not loaded"
    end

    local success = false

    pcall(function()
        for _, module in ipairs(devConsole:GetDescendants()) do
            if module:IsA("ModuleScript") and module.Name:lower():find("memory") then
                local env = getsenv(module)
                for k,v in pairs(env) do
                    if typeof(v) == "boolean" and k:lower():find("enabled") then
                        env[k] = false
                        success = true
                    end
                end
            end
        end
    end)

    if success then
        return true, "Memory category counters disabled."
    else
        return false, "Unable to disable memory counters."
    end
end

commands.enablefpsgraph = function(args)
    local CoreGui = game:GetService("CoreGui")
    local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")

    if not devConsole then
        return false, "DevConsole not loaded"
    end

    local success = false

    pcall(function()
        for _, module in ipairs(devConsole:GetDescendants()) do
            if module:IsA("ModuleScript") and module.Name:lower():find("fps") then
                local env = getsenv(module)
                for k,v in pairs(env) do
                    if typeof(v) == "boolean" and k:lower():find("enabled") then
                        env[k] = true
                        success = true
                    end
                end
            end
        end
    end)

    if success then
        return true, "FPS Graph enabled."
    else
        return false, "Unable to enable FPS graph."
    end
end

commands.enablepacketcounters = function(args)
    local CoreGui = game:GetService("CoreGui")
    local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")

    if not devConsole then
        return false, "DevConsole not loaded"
    end

    local success = false

    pcall(function()
        for _, module in ipairs(devConsole:GetDescendants()) do
            if module:IsA("ModuleScript") and module.Name:lower():find("network") then
                local env = getsenv(module)
                for k,v in pairs(env) do
                    if typeof(v) == "boolean" and k:lower():find("enabled") then
                        env[k] = true
                        success = true
                    end
                end
            end
        end
    end)

    if success then
        return true, "Packet counters enabled."
    else
        return false, "Unable to enable packet counters."
    end
end

commands.showhiddenconsoletabs = function(args)
    local CoreGui = game:GetService("CoreGui")
    local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")

    if not devConsole then
        return false, "DevConsole not loaded"
    end

    local success = false

    pcall(function()
        for _, module in ipairs(devConsole:GetDescendants()) do
            if module:IsA("ModuleScript") and module.Name:lower():find("tabs") then
                local env = getsenv(module)
                for k,v in pairs(env) do
                    if typeof(v) == "boolean" and k:lower():find("hidden") then
                        env[k] = false
                        success = true
                    end
                end
            end
        end
    end)

    if success then
        return true, "Hidden DevConsole tabs are now visible."
    else
        return false, "Unable to show hidden tabs."
    end
end

commands.clientstats = function(args)
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")

    local fps = 1/RunService.RenderStepped:Wait()
    local mem = Stats:GetMemoryUsageMb()
    local ping = Stats:GetStats().DataPing -- approximate

    addLog(string.format("FPS (approx): %.2f", fps*60), Color3.fromRGB(150,255,150))
    addLog(string.format("Memory Usage: %.2f MB", mem), Color3.fromRGB(150,255,150))
    addLog(string.format("Ping: %d ms", ping), Color3.fromRGB(150,255,150))

    return true, "Stats snapshot complete."
end

commands.fflaginspector = function(args)
    local settings = settings()
    if #args == 0 then
        return false, "Usage: fflag get {flagname} | list"
    end

    local action = args[1]:lower()
    if action == "get" then
        local flag = args[2]
        if not flag then return false, "Specify a flag name." end
        local value = pcall(function() return settings():GetFFlag(flag) end)
        return true, string.format("%s = %s", flag, tostring(value))
    elseif action == "list" then
        return false, "FFlag listing requires executor access; try 'fflag get {name}'."
    else
        return false, "Unknown fflag action: "..action
    end
end

commands.vrstatus = function(args)
    local VRService = game:GetService("VRService")
    addLog("VR Supported: "..tostring(VRService.VREnabled), Color3.fromRGB(150,255,255))
    addLog("Headset Position: "..tostring(VRService:GetUserCFrame(Enum.UserCFrame.Head)), Color3.fromRGB(150,255,255))
    addLog("Left Controller: "..tostring(VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)), Color3.fromRGB(150,255,255))
    addLog("Right Controller: "..tostring(VRService:GetUserCFrame(Enum.UserCFrame.RightHand)), Color3.fromRGB(150,255,255))
    return true, "VR status snapshot complete."
end

commands.inputdebug = function(args)
    local UIS = game:GetService("UserInputService")
    local count = 0
    local maxLogs = 10

    local conn
    conn = UIS.InputBegan:Connect(function(input, gp)
        if count >= maxLogs then conn:Disconnect() return end
        addLog(string.format("Input: %s | KeyCode: %s | UserInputType: %s", input.UserInputType, input.KeyCode, input.UserInputType), Color3.fromRGB(255,200,150))
        count = count + 1
    end)

    return true, "Listening to input events for 10 presses..."
end

commands.renderinfo = function(args)
    local cam = workspace.CurrentCamera
    addLog("Camera FOV: "..tostring(cam.FieldOfView), Color3.fromRGB(150,200,255))
    addLog("Camera CFrame: "..tostring(cam.CFrame), Color3.fromRGB(150,200,255))
    addLog("Lighting TimeOfDay: "..game:GetService("Lighting").TimeOfDay, Color3.fromRGB(150,200,255))
    addLog("Fog End: "..tostring(game:GetService("Lighting").FogEnd), Color3.fromRGB(150,200,255))
    addLog("Ambient: "..tostring(game:GetService("Lighting").Ambient), Color3.fromRGB(150,200,255))
    return true, "Render info snapshot complete."
end

commands.pathdebug = function(args)
    local target = workspace:FindFirstChild(args[1])
    if not target then return false, "Specify a valid target in workspace." end

    local PathfindingService = game:GetService("PathfindingService")
    local playerChar = game.Players.LocalPlayer.Character
    if not playerChar or not playerChar:FindFirstChild("HumanoidRootPart") then
        return false, "Character not loaded or missing HumanoidRootPart."
    end

    local path = PathfindingService:CreatePath()
    path:ComputeAsync(playerChar.HumanoidRootPart.Position, target.Position)
    local waypoints = path:GetWaypoints()
    for _, wp in ipairs(waypoints) do
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Size = Vector3.new(1,1,1)
        part.Position = wp.Position + Vector3.new(0,1,0)
        part.Color = Color3.fromRGB(255,0,0)
        part.Parent = workspace
        task.delay(3, function() part:Destroy() end) -- remove after 3 sec
    end

    return true, "Path visualized for 3 seconds."
end

commands.eventspy = function(args)
    local MessageBus = game:GetService("MessageBusService")
    local count = 0
    local maxLogs = 10
    local conn
    conn = MessageBus.OnMessageReceived:Connect(function(msg)
        if count >= maxLogs then conn:Disconnect() return end
        addLog("Event: "..msg.Name.." | Data: "..tostring(msg.Data), Color3.fromRGB(255,255,150))
        count = count + 1
    end)

    return true, "Listening to 10 MessageBus events..."
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



commands.rccspy = function(args)
    local RCCService = game:GetService("RCCService")
    if not RCCService then return false, "RCCService not found." end

    -- Check if the GUI already exists
    if game.CoreGui:FindFirstChild("RCCSpyGui") then
        game.CoreGui.RCCSpyGui:Destroy()
    end

    -- Create main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RCCSpyGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainFrame.BorderColor3 = Color3.fromRGB(80,80,80)
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Title Bar
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,25)
    Title.BackgroundTransparency = 1
    Title.Text = "RCCService Spy"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.Code
    Title.TextSize = 16
    Title.Parent = MainFrame

    -- Close button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Position = UDim2.new(1,-25,0,0)
    Close.BackgroundColor3 = Color3.fromRGB(180,50,50)
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255,255,255)
    Close.Parent = MainFrame
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Scrollable frame for messages
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Position = UDim2.new(0,5,0,30)
    Scroll.Size = UDim2.new(1,-10,1,-35)
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
    Scroll.BackgroundColor3 = Color3.fromRGB(15,15,15)
    Scroll.BorderSizePixel = 1
    Scroll.ScrollBarThickness = 6
    Scroll.Parent = MainFrame

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Scroll
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0,2)

    -- Helper function to log messages in GUI
    local function logMessage(msg)
        local label = Instance.new("TextLabel")
        label.Text = msg
        label.Size = UDim2.new(1,0,0,18)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(200,200,255)
        label.Font = Enum.Font.Code
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = Scroll
        Scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y)
        Scroll.CanvasPosition = Vector2.new(0,99999)
    end

    -- Connect RCCService messages
    local conn
    conn = RCCService.OnClientEvent:Connect(function(msg)
        logMessage(tostring(msg))
    end)

    return true, "RCCService spy GUI loaded. Listening for messages..."
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

-- Start Chat Logger
commands.chatlogger = function(args)
    local TextChatService = game:GetService("TextChatService")
    if not TextChatService then return false, "TextChatService not found." end

    -- Only hook once
    if _G._chatLoggerConnected then return true, "ChatLogger already active." end

    _G._chatLoggerConnection = TextChatService.OnIncomingMessage:Connect(function(msgObj)
        local speaker = msgObj.TextSource.Name
        local content = msgObj.Text
        local filtered = msgObj.Text ~= content and "(Filtered)" or ""
        addLog(string.format("[%s] %s %s", speaker, content, filtered), Color3.fromRGB(200,200,255))
    end)

    _G._chatLoggerConnected = true
    addLog("ChatLogger activated. Listening for all player messages...", Color3.fromRGB(150,255,255))
    return true, "ChatLogger is running."
end

-- Stop Chat Logger
commands.stopchatlogger = function(args)
    if _G._chatLoggerConnection then
        _G._chatLoggerConnection:Disconnect()
        _G._chatLoggerConnection = nil
        _G._chatLoggerConnected = false
        return true, "ChatLogger stopped."
    else
        return false, "ChatLogger was not running."
    end
end

commands.spoofdevice = function(args)
    local UIS = game:GetService("UserInputService")
    local VRService = game:GetService("VRService")
    if #args < 1 then return false, "Usage: spoofdevice {mobile, desktop, vr, console}" end
    
    local mode = args[1]:lower()
    
    if mode == "mobile" then
        pcall(function()
            UIS.TouchEnabled = true
            UIS.KeyboardEnabled = false
            UIS.GamepadEnabled = false
            VRService.VREnabled = false
        end)
        return true, "Device spoofed to Mobile."
        
    elseif mode == "desktop" then
        pcall(function()
            UIS.TouchEnabled = false
            UIS.KeyboardEnabled = true
            UIS.GamepadEnabled = false
            VRService.VREnabled = false
        end)
        return true, "Device spoofed to Desktop."
        
    elseif mode == "vr" then
        pcall(function()
            UIS.TouchEnabled = false
            UIS.KeyboardEnabled = false
            UIS.GamepadEnabled = true
            VRService.VREnabled = true
        end)
        return true, "Device spoofed to VR."
        
    elseif mode == "console" then
        pcall(function()
            UIS.TouchEnabled = false
            UIS.KeyboardEnabled = false
            UIS.GamepadEnabled = true
            VRService.VREnabled = false
        end)
        return true, "Device spoofed to Console."
        
    else
        return false, "Unknown device type: "..mode
    end
end

-- Delete Humanoid
commands.deletehumanoid = function(args)
    local char = game.Players.LocalPlayer.Character
    if not char then return false, "Character not found." end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:Destroy()
        return true, "Humanoid deleted."
    else
        return false, "No Humanoid found."
    end
end

-- Restore Humanoid
commands.restorehumanoid = function(args)
    local char = game.Players.LocalPlayer.Character
    if not char then return false, "Character not found." end
    if char:FindFirstChildOfClass("Humanoid") then
        return false, "Humanoid already exists."
    end

    local hum = Instance.new("Humanoid")
    hum.Name = "Humanoid"
    hum.Parent = char

    -- Restore basic R6/R15 properties
    hum.Health = 100
    hum.MaxHealth = 100
    hum.WalkSpeed = 16
    hum.JumpPower = 50
    hum.UseJumpPower = true

    return true, "Humanoid restored."
end

commands.fireremote = function(args)
    if #args < 1 then
        return false, "Usage: fireremote {RemoteName} {arg1, arg2, ...}"
    end

    local remoteName = args[1]
    local remoteArgs = {}
    for i = 2, #args do
        table.insert(remoteArgs, loadstring("return " .. args[i])()) -- converts "true", "5", etc.
    end

    -- Search in ReplicatedStorage and Workspace
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName) 
        or workspace:FindFirstChild(remoteName)

    if not remote then
        return false, "Remote '"..remoteName.."' not found."
    end

    if remote:IsA("RemoteEvent") then
        remote:FireServer(unpack(remoteArgs))
        return true, "RemoteEvent '"..remoteName.."' fired."
    elseif remote:IsA("RemoteFunction") then
        local success, result = pcall(function()
            return remote:InvokeServer(unpack(remoteArgs))
        end)
        if success then
            return true, "RemoteFunction '"..remoteName.."' invoked. Result: "..tostring(result)
        else
            return false, "RemoteFunction '"..remoteName.."' error: "..tostring(result)
        end
    else
        return false, "Object '"..remoteName.."' is not a RemoteEvent/RemoteFunction."
    end
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

-- ============================================
-- PLUGIN SYSTEM FOR TERMINAL (EXECUTOR LOCAL FOLDER)
-- ============================================

-- Assumes 'commands' table exists above
-- Must be placed AFTER 'commands = {}' but BEFORE InputBox execution

-- Check if executor supports makefolder
local folderName = "NassersTerminalPlugins"
if not isfolder then
    warn("[Terminal] Executor does not support makefolder(). Plugins will not work.")
else
    -- Create folder if missing
    if not isfolder(folderName) then
        makefolder(folderName)
        print("[Terminal] Created local plugin folder: " .. folderName)
    end
end

-- Load all .terminal files in the folder
if isfile and listfiles then
    for _, file in ipairs(listfiles(folderName)) do
        if file:match("%.terminal$") then
            local ok, pluginCommands = pcall(function()
                return loadfile(file)() -- Each plugin must return a table of commands
            end)

            if ok and type(pluginCommands) == "table" then
                for cmdName, cmdFunc in pairs(pluginCommands) do
                    commands[cmdName] = cmdFunc
                end
                print("[Terminal] Loaded plugin: " .. file:match("[^/\\]+$"))
            else
                warn("[Terminal] Failed to load plugin: " .. file:match("[^/\\]+$"))
            end
        end
    end
end

-- Optional reload command
commands.reloadplugins = function(args)
    if not isfolder or not listfiles then
        return false, "Executor does not support plugin reloading."
    end
    for _, file in ipairs(listfiles(folderName)) do
        if file:match("%.terminal$") then
            local ok, pluginCommands = pcall(function()
                return loadfile(file)()
            end)
            if ok and type(pluginCommands) == "table" then
                for cmdName, cmdFunc in pairs(pluginCommands) do
                    commands[cmdName] = cmdFunc
                end
            end
        end
    end
    return true, "Plugins reloaded."
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
addLog("Welcome to Nasser's Terminal v2.5", Color3.fromRGB(100, 100, 255))
addLog("Type 'ws 100' or 'jp 50' to test.", Color3.fromRGB(150, 150, 150))
