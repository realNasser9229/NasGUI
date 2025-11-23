-- Nasser's Terminal (fixed sliding)
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

-- Clean up old gui if present
if CoreGui:FindFirstChild("NassersTerminal") then
    CoreGui.NassersTerminal:Destroy()
end

local terminal = Instance.new("ScreenGui", CoreGui)
terminal.Name = "NassersTerminal"
terminal.ResetOnSpawn = false

-- Toggle (clickable) bottom-right
local toggleBtn = Instance.new("TextButton", terminal)
toggleBtn.Size = UDim2.new(0, 180, 0, 40)
toggleBtn.Position = UDim2.new(1, -190, 1, -50)
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.BorderSizePixel = 1
toggleBtn.Text = "Nasser's Terminal"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 18
toggleBtn.AutoButtonColor = true
toggleBtn.Name = "ToggleButton"

-- Main Panel
local panel = Instance.new("Frame", terminal)
panel.Name = "TerminalPanel"
panel.Size = UDim2.new(0, 350, 0, 300)
-- use AnchorPoint = (1,1) so we can set "hidden" and "visible" offsets easily
panel.AnchorPoint = Vector2.new(1, 1)
-- Hidden below the screen initially (300 px below bottom)
panel.Position = UDim2.new(1, -10, 1, 310)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BorderSizePixel = 1

-- Top bar inside panel (for aesthetics & clickable area)
local topBar = Instance.new("Frame", panel)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Nasser's Terminal"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- Textbox labeled "</>"
local codeBox = Instance.new("TextBox", panel)
codeBox.Size = UDim2.new(1, -20, 0, 34)
codeBox.Position = UDim2.new(0, 10, 0, 46)
codeBox.PlaceholderText = "</>"
codeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
codeBox.TextColor3 = Color3.fromRGB(255,255,255)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 16
codeBox.Text = ""

-- ScrollingFrame for commands
local list = Instance.new("ScrollingFrame", panel)
list.Size = UDim2.new(1, -20, 1, -100)
list.Position = UDim2.new(0, 10, 0, 86)
list.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Commands table
local commands = {
    {"command1", function() print("[NassersTerminal] command1 executed") end},
    {"command2", function() print("[NassersTerminal] command2 executed") end},
}

-- Create buttons for commands
local function refreshCommands()
    -- remove old buttons (only TextButtons)
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for i, data in ipairs(commands) do
        local cmdName = data[1] or ("cmd"..i)
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.BorderSizePixel = 0
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Code
        btn.TextSize = 15
        btn.Text = "> " .. tostring(cmdName)
        btn.AutoButtonColor = true

        btn.MouseButton1Click:Connect(function()
            -- call the function safely
            local ok, err = pcall(function() data[2]() end)
            if not ok then
                warn("[NassersTerminal] command error:", err)
            end
        end)
    end

    -- update canvas size (AutomaticCanvasSize used, but set min)
    list.CanvasSize = UDim2.new(0, 0, 0, math.max(0, layout.AbsoluteContentSize.Y + 10))
end

refreshCommands()

-- Tweens (hidden -> visible)
local upTween = TweenService:Create(panel, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -10, 1, -10)})
local downTween = TweenService:Create(panel, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -10, 1, 310)})

local open = false
local inactivityTime = 0

local function slideUp()
    if open then return end
    open = true
    inactivityTime = 0
    print("[NassersTerminal] sliding up")
    upTween:Play()
end

local function slideDown()
    if not open then return end
    open = false
    print("[NassersTerminal] sliding down")
    downTween:Play()
end

-- Toggle button click (reliable)
toggleBtn.MouseButton1Click:Connect(function()
    if open then
        slideDown()
    else
        slideUp()
    end
end)

-- Auto-hide after 5 seconds of inactivity
task.spawn(function()
    while true do
        task.wait(1)
        if open then
            inactivityTime = inactivityTime + 1
            if inactivityTime >= 5 then
                slideDown()
            end
        end
    end
end)

-- Reset inactivity when interacting
local function resetTimer()
    if open then inactivityTime = 0 end
end

panel.InputBegan:Connect(resetTimer)
panel.InputChanged:Connect(resetTimer)
list.InputBegan:Connect(resetTimer)
codeBox.Focused:Connect(resetTimer)
codeBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = tostring(codeBox.Text or ""):gsub("^%s*(.-)%s*$", "%1"):lower()
        codeBox.Text = ""
        if text ~= "" then
            local found = false
            for _, data in ipairs(commands) do
                if tostring(data[1]):lower() == text then
                    found = true
                    local ok, err = pcall(function() data[2]() end)
                    if not ok then warn("[NassersTerminal] cmd error:", err) end
                    break
                end
            end
            if not found then
                warn("[NassersTerminal] Unknown command:", text)
            end
        end
    end
end)

-- OPTIONAL: allow adding commands programmatically later
-- example: table.insert(commands, {"hello", function() print("hi") end}); refreshCommands()

print("[NassersTerminal] loaded - click the button bottom-right to open")
