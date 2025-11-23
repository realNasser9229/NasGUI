--// Nasser's Terminal
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local terminal = Instance.new("ScreenGui", CoreGui)
terminal.Name = "NassersTerminal"

--// SLIDE BUTTON (BOTTOM-RIGHT)
local toggleBtn = Instance.new("Frame", terminal)
toggleBtn.Size = UDim2.new(0, 180, 0, 40)
toggleBtn.Position = UDim2.new(1, -190, 1, -50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.BorderSizePixel = 2

local toggleLabel = Instance.new("TextLabel", toggleBtn)
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Nasser's Terminal"
toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleLabel.Font = Enum.Font.Code
toggleLabel.TextSize = 18

--// MAIN PANEL (HIDDEN AT START)
local panel = Instance.new("Frame", terminal)
panel.Size = UDim2.new(0, 350, 0, 300)
panel.Position = UDim2.new(1, -360, 1, 300)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BorderSizePixel = 2

--// TEXTBOX
local codeBox = Instance.new("TextBox", panel)
codeBox.Size = UDim2.new(1, -20, 0, 35)
codeBox.Position = UDim2.new(0, 10, 0, 10)
codeBox.PlaceholderText = "</>"
codeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
codeBox.TextColor3 = Color3.new(1, 1, 1)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 18

--// COMMAND LIST
local list = Instance.new("ScrollingFrame", panel)
list.Size = UDim2.new(1, -20, 1, -60)
list.Position = UDim2.new(0, 10, 0, 55)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 4
list.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

---------------------------------------------------------------------
-- COMMANDS SYSTEM
---------------------------------------------------------------------

local commands = {
    {"command1", function() print("command1 executed") end},
    {"command2", function() print("command2 executed") end},
}

-- Generate buttons for commands
local function refreshCommands()
    for _, v in ipairs(list:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _, data in ipairs(commands) do
        local cmdName = data[1]

        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Code
        btn.TextSize = 16
        btn.Text = "> " .. cmdName

        btn.MouseButton1Click:Connect(function()
            data[2]()
        end)
    end

    list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

refreshCommands()

---------------------------------------------------------------------
-- SLIDE ANIMATIONS
---------------------------------------------------------------------

local upTween =
    TweenService:Create(panel, TweenInfo.new(.4, Enum.EasingStyle.Quad),
    {Position = UDim2.new(1, -360, 1, -310)})

local downTween =
    TweenService:Create(panel, TweenInfo.new(.4, Enum.EasingStyle.Quad),
    {Position = UDim2.new(1, -360, 1, 300)})

local open = false
local inactivityTime = 0

local function slideUp()
    open = true
    inactivityTime = 0
    upTween:Play()
end

local function slideDown()
    open = false
    downTween:Play()
end

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        slideUp()
    end
end)

---------------------------------------------------------------------
-- AUTO-HIDE AFTER 5 SECONDS
---------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1)
        if open then
            inactivityTime += 1
            if inactivityTime >= 5 then
                slideDown()
            end
        end
    end
end)

-- Reset inactivity when interacting
local function resetTimer()
    if open then
        inactivityTime = 0
    end
end

panel.InputBegan:Connect(resetTimer)
codeBox.Focused:Connect(resetTimer)
list.InputBegan:Connect(resetTimer)

---------------------------------------------------------------------
-- EXECUTE COMMAND BY TYPING + ENTER
---------------------------------------------------------------------

codeBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = codeBox.Text:lower()
        codeBox.Text = ""

        for _, data in ipairs(commands) do
            if data[1]:lower() == text then
                data[2]()
                return
            end
        end

        print("Unknown command: " .. text)
    end
end)
