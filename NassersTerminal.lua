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
local LocalPlayer = Players.LocalPlayer

-- Check for existing GUI to prevent duplicates
if game.CoreGui:FindFirstChild("NassersTerminal") then
    game.CoreGui.NassersTerminal:Destroy()
elseif LocalPlayer.PlayerGui:FindFirstChild("NassersTerminal") then
    LocalPlayer.PlayerGui.NassersTerminal:Destroy()
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

-- Command: Print
commands.print = function(args)
    local msg = table.concat(args, " ")
    print(msg) -- Prints to real F9 console too
    return true, "Output: " .. msg
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
commands.exit = function(args)
    ScreenGui:Destroy()
    return true, "Goodbye."
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
