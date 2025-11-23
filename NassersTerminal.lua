-- Nasser's Terminal (FINAL FIX)
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

if CoreGui:FindFirstChild("NassersTerminal") then
    CoreGui.NassersTerminal:Destroy()
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NassersTerminal"
gui.ResetOnSpawn = false

----------------------------------------------------------------------
-- TOGGLE BUTTON FRAME (bottom-right)
----------------------------------------------------------------------

local toggleFrame = Instance.new("Frame", gui)
toggleFrame.Size = UDim2.new(0, 180, 0, 40)
toggleFrame.Position = UDim2.new(1, -190, 1, -50)
toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleFrame.BorderSizePixel = 1

local toggleBtn = Instance.new("TextButton", toggleFrame)
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "Nasser's Terminal FE v1.0.0"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 18

----------------------------------------------------------------------
-- MAIN PANEL (starts hidden downwards)
----------------------------------------------------------------------

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 350, 0, 300)
panel.Position = UDim2.new(1, -10, 1, 310) -- HIDDEN BELOW SCREEN
panel.AnchorPoint = Vector2.new(1,1)
panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
panel.BorderSizePixel = 1

-- textbox </>
local box = Instance.new("TextBox", panel)
box.Size = UDim2.new(1, -20, 0, 35)
box.Position = UDim2.new(0, 10, 0, 10)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.new(1,1,1)
box.PlaceholderText = "</>"
box.Font = Enum.Font.Code
box.TextSize = 17

-- scrolling commands list
local list = Instance.new("ScrollingFrame", panel)
list.Size = UDim2.new(1, -20, 1, -60)
list.Position = UDim2.new(0, 10, 0, 55)
list.BackgroundColor3 = Color3.fromRGB(25,25,25)
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", list)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

----------------------------------------------------------------------
-- COMMANDS SYSTEM (TEXTLABELS ONLY)
----------------------------------------------------------------------

local commands = {
    {"command1", function() print("cmd1") end},
    {"command2", function() print("cmd2") end},
}

local function refreshCommands()
    for _, obj in ipairs(list:GetChildren()) do
        if obj:IsA("TextLabel") then obj:Destroy() end
    end

    for _, data in ipairs(commands) do
        local lbl = Instance.new("TextLabel", list)
        lbl.Size = UDim2.new(1, -5, 0, 28)
        lbl.BackgroundColor3 = Color3.fromRGB(40,40,40)
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 16
        lbl.Text = "> " .. data[1]
        lbl.BorderSizePixel = 0
    end

    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

refreshCommands()

----------------------------------------------------------------------
-- SLIDE ANIMATIONS
----------------------------------------------------------------------

local slideUp   = TweenService:Create(panel, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Position = UDim2.new(1,-10,1,-10)})
local slideDown = TweenService:Create(panel, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Position = UDim2.new(1,-10,1,310)})

local open = false
local inactive = 0

local function openPanel()
    open = true
    inactive = 0
    slideUp:Play()
end

local function closePanel()
    open = false
    slideDown:Play()
end

toggleBtn.MouseButton1Click:Connect(function()
    if open then closePanel() else openPanel() end
end)

----------------------------------------------------------------------
-- AUTO-HIDE AFTER 5 SEC OF NO INTERACTION
----------------------------------------------------------------------

task.spawn(function()
    while true do
        task.wait(1)
        if open then
            inactive = inactive + 1
            if inactive >= 5 then
                closePanel()
            end
        end
    end
end)

local function reset()
    if open then inactive = 0 end
end

panel.InputBegan:Connect(reset)
list.InputBegan:Connect(reset)
box.Focused:Connect(reset)

----------------------------------------------------------------------
-- EXECUTE COMMAND WHEN TYPING NAME + ENTER
----------------------------------------------------------------------

box.FocusLost:Connect(function(enter)
    if not enter then return end

    local input = box.Text:lower()
    box.Text = ""

    for _, data in ipairs(commands) do
        if data[1]:lower() == input then
            data[2]()
            return
        end
    end

    warn("Unknown command:", input)
end)
