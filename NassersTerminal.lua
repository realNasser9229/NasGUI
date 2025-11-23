-- Nasser's Terminal (MOBILE VERSION)
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
-- SMALLER TOGGLE (BOTTOM-RIGHT)
----------------------------------------------------------------------

local toggleFrame = Instance.new("Frame", gui)
toggleFrame.Size = UDim2.new(0, 135, 0, 35)
toggleFrame.Position = UDim2.new(1, -255, 1, -45)
toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleFrame.BorderSizePixel = 1

local toggleBtn = Instance.new("TextButton", toggleFrame)
toggleBtn.Size = UDim2.new(0, 250, 1, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "Nasser's Terminal v1.0"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 16

----------------------------------------------------------------------
-- SMALL MOBILE PANEL (SHORTER + THINNER)
----------------------------------------------------------------------

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 260, 0, 180)
panel.Position = UDim2.new(1, -10, 1, 200) -- hidden down
panel.AnchorPoint = Vector2.new(1,1)
panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
panel.BorderSizePixel = 1

-- Textbox </>
local box = Instance.new("TextBox", panel)
box.Size = UDim2.new(1, -20, 0, 30)
box.Position = UDim2.new(0, 10, 0, 10)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.new(1,1,1)
box.PlaceholderText = "</>"
box.Font = Enum.Font.Code
box.TextSize = 16

-- Compact scrolling list
local list = Instance.new("ScrollingFrame", panel)
list.Size = UDim2.new(1, -20, 1, -55)
list.Position = UDim2.new(0, 10, 0, 50)
list.BackgroundColor3 = Color3.fromRGB(25,25,25)
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", list)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,4)

----------------------------------------------------------------------
-- COMMANDS AS TEXTLABELS
----------------------------------------------------------------------

local commands = {

    {"unsuspendvc", function()
        local tcs = game:GetService("TextChatService")
        local players = game:GetService("Players")
        local lp = players.LocalPlayer
        
        local succ, err = pcall(function()
            for _, con in ipairs(getconnections(tcs.ChatInputBarConfiguration.TargetTextChannel.ReceivedMessage)) do
                if con.Function then
                    con.Function("voiceEnabled", lp)
                end
            end
        end)
        
        if succ then
            print("[Terminal] Voice chat unsuspend attempted.")
        else
            warn("[Terminal] VC unsuspend failed:", err)
        end
    end},

    {"fly", function()
        if getgenv().NAS_FLYING then return end
        getgenv().NAS_FLYING = true

        local plr = game:GetService("Players").LocalPlayer
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char.HumanoidRootPart
        
        local SPEED = 5
        local CTRL = {F = 0, B = 0, L = 0, R = 0}

        local BV = Instance.new("BodyVelocity", hrp)
        BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BV.Velocity = Vector3.zero

        local BG = Instance.new("BodyGyro", hrp)
        BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)

        local UIS = game:GetService("UserInputService")
      
        UIS.InputBegan:Connect(function(i, g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.W then CTRL.F = 1 end
            if i.KeyCode == Enum.KeyCode.S then CTRL.B = 1 end
            if i.KeyCode == Enum.KeyCode.A then CTRL.L = 1 end
            if i.KeyCode == Enum.KeyCode.D then CTRL.R = 1 end
        end)
        
        UIS.InputEnded:Connect(function(i, g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.W then CTRL.F = 0 end
            if i.KeyCode == Enum.KeyCode.S then CTRL.B = 0 end
            if i.KeyCode == Enum.KeyCode.A then CTRL.L = 0 end
            if i.KeyCode == Enum.KeyCode.D then CTRL.R = 0 end
        end)

        task.spawn(function()
            while getgenv().NAS_FLYING and hum and hum.Parent do
                BG.CFrame = workspace.CurrentCamera.CFrame
                BV.Velocity = (
                    workspace.CurrentCamera.CFrame.LookVector * (CTRL.F - CTRL.B)
                    + workspace.CurrentCamera.CFrame.RightVector * (CTRL.R - CTRL.L)
                ) * SPEED
                task.wait()
            end
        end)

        print("[Terminal] Fly enabled.")
    end},

    {"unfly", function()
        getgenv().NAS_FLYING = false
        local char = game:GetService("Players").LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in ipairs(char.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                    v:Destroy()
                end
            end
        end
        print("[Terminal] Fly disabled.")
    end},

    {"spam", function(args)
        local msg = args[1]
        local delay = tonumber(args[2]) or 0.5
        
        if not msg then return warn("Usage: spam {text} {delay}") end
        if getgenv().NAS_SPAMMING then return warn("[Terminal] Spam already running.") end

        getgenv().NAS_SPAMMING = true
        local tcs = game:GetService("TextChatService")
        local channel = tcs.ChatInputBarConfiguration.TargetTextChannel

        task.spawn(function()
            while getgenv().NAS_SPAMMING do
                channel:SendAsync(msg)
                task.wait(delay)
            end
        end)
        
        print("[Terminal] Spamming started.")
    end},

    {"unspam", function()
        getgenv().NAS_SPAMMING = false
        print("[Terminal] Spamming stopped.")
    end},

    {"esp", function()
    -- Highlights all players
    local Players = game:GetService("Players")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp:FindFirstChild("ESP_Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,0,0)
                highlight.Adornee = plr.Character
                highlight.Parent = workspace
            end
        end
    end
    print("[Terminal] ESP enabled for all players.")
end},

{"unesp", function()
    -- Removes all highlights
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Highlight") and obj.Name == "ESP_Highlight" then
            obj:Destroy()
        end
    end
    print("[Terminal] ESP removed.")
end},

{"playercount", function()
    -- Counts players in the server
    local Players = game:GetService("Players")
    print("[Terminal] Players in server:", #Players:GetPlayers())
end},

{"serverinfo", function()
    -- Prints basic server info
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    print("[Terminal] Server info:")
    print("Players:", #Players:GetPlayers())
    print("Workspace Children:", #Workspace:GetChildren())
end},

{"removetools", function()
    -- Removes tools from all players safely (not client-manipulation)
    local Players = game:GetService("Players")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            for _, item in ipairs(plr.Character:GetChildren()) do
                if item:IsA("Tool") then
                    item:Destroy()
                end
            end
        end
    end
    print("[Terminal] All player tools removed.")
end},

{"noclip", function()
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    print("[Terminal] Noclip enabled.")
end},

{"clip", function()
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    print("[Terminal] Noclip disabled.")
end},

{"spawn", function()
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local Workspace = game:GetService("Workspace")
    
    -- Create a temporary spawn point at your position
    local spawn = Instance.new("SpawnLocation")
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.Size = Vector3.new(6,1,6)
    spawn.CFrame = char.HumanoidRootPart.CFrame
    spawn.Transparency = 1
    spawn.BrickColor = BrickColor.new("Bright green")
    spawn.Parent = Workspace

    print("[Terminal] Spawn set at your current position.")
end},

{"playercount", function()
    local Players = game:GetService("Players")
    print("[Terminal] Players in server:", #Players:GetPlayers())
end},

{"fullbright", function()
    local Lighting = game:GetService("Lighting")
    -- Store original settings so we can restore later
    if not getgenv().NAS_OriginalLighting then
        getgenv().NAS_OriginalLighting = {
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows,
            Ambient = Lighting.Ambient
        }
    end

    Lighting.Brightness = 3       -- increase brightness a bit
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(200,200,200) -- optional subtle ambient boost

    print("[Terminal] Fullbright enabled.")
end},

{"unfullbright", function()
    local Lighting = game:GetService("Lighting")
    local orig = getgenv().NAS_OriginalLighting
    if orig then
        Lighting.Brightness = orig.Brightness
        Lighting.GlobalShadows = orig.GlobalShadows
        Lighting.Ambient = orig.Ambient
        print("[Terminal] Fullbright reset to original server settings.")
    else
        print("[Terminal] No previous lighting saved.")
    end
end},

{"firetouchinterests", function(args)
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    local char = plr.Character
    local targetName = args[1]

    local targetPart
    if targetName then
        targetPart = Workspace:FindFirstChild(targetName, true)
    else
        if char and char:FindFirstChild("HumanoidRootPart") then
            targetPart = char:FindFirstChild("HumanoidRootPart")
        end
    end

    if targetPart and targetPart:IsA("BasePart") then
        for _, obj in ipairs(targetPart:GetTouchingParts()) do
            firetouchinterest(obj, targetPart, 0)
            firetouchinterest(obj, targetPart, 1)
        end
        print("[Terminal] Fired TouchInterests on "..(targetName or "local player"))
    else
        warn("[Terminal] Part not found:", targetName or "HumanoidRootPart")
    end
end},

{"fireclickdetectors", function(args)
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    local char = plr.Character
    local targetName = args[1]

    local obj
    if targetName then
        obj = Workspace:FindFirstChild(targetName, true)
    else
        obj = char
    end

    if obj then
        for _, click in ipairs(obj:GetDescendants()) do
            if click:IsA("ClickDetector") then
                fireclickdetector(click)
            end
        end
        print("[Terminal] Fired ClickDetectors on "..(targetName or "local player"))
    else
        warn("[Terminal] Object not found:", targetName or "local player")
    end
end},

{"fespoof", function()
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    if getgenv().NAS_FESPOOFED then
        print("[Terminal] FE already spoofed.")
        return
    end

    getgenv().NAS_FESPOOFED = true

    -- Hook __index to always return false for FilteringEnabled
    local mt = getrawmetatable(Workspace)
    if not mt then return warn("[Terminal] Failed to get metatable.") end
    setreadonly(mt, false)
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(t, k)
        if k == "FilteringEnabled" then
            return false
        end
        return oldIndex(t, k)
    end)

    -- Keep filtering spoofed continuously
    getgenv().NAS_FESPOOF_HEART = RunService.Heartbeat:Connect(function()
        pcall(function()
            Workspace.FilteringEnabled = false
        end)
    end)

    print("[Terminal] FilteringEnabled spoofed OFF (FE bypass active).")
end},

{"unfespoof", function()
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    if not getgenv().NAS_FESPOOFED then
        print("[Terminal] FE spoof not active.")
        return
    end

    -- Disconnect Heartbeat
    if getgenv().NAS_FESPOOF_HEART then
        getgenv().NAS_FESPOOF_HEART:Disconnect()
        getgenv().NAS_FESPOOF_HEART = nil
    end

    -- Restore metatable
    local mt = getrawmetatable(Workspace)
    if mt then
        setreadonly(mt, false)
        local oldIndex = mt.__index
        mt.__index = function(t, k)
            if k == "FilteringEnabled" then
                return true
            end
            return oldIndex(t, k)
        end
    end

    getgenv().NAS_FESPOOFED = false
    print("[Terminal] FilteringEnabled spoof removed (FE back ON).")
end},

{"infyield", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)

    if success then
        print("[Terminal] Infinite Yield executed.")
    else
        warn("[Terminal] Failed to execute Infinite Yield:", err)
    end
end},

{"saveinstance", function(args)
    local folderName = args[1] or "SavedInstances"
    local fileName = args[2] or ("Place_" .. tostring(math.random(1000,9999)) .. ".rbxlx")

    -- Ensure Synapse function exists
    if not syn or not syn.save_instance then
        return warn("[Terminal] saveinstance not supported by this executor.")
    end

    -- Create folder if it doesn't exist
    pcall(function()
        if not isfolder(folderName) then
            makefolder(folderName)
        end
    end)

    -- Full path
    local path = folderName .. "/" .. fileName

    -- Save
    local success, err = pcall(function()
        syn.save_instance(game, path)
    end)

    if success then
        print("[Terminal] Game saved to: " .. path)
    else
        warn("[Terminal] Failed to save instance:", err)
    end
end},

{"nasgui", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realNasser9229/NasGUI/refs/heads/main/source.lua", true))()
    end)

    if success then
        print("[Terminal] NasGUI executed successfully.")
    else
        warn("[Terminal] Failed to execute NasGUI:", err)
    end
end},

{"logcat", function()
    if getgenv().NAS_LOGCAT then
        print("[Terminal] LogCat already running.")
        return
    end

    getgenv().NAS_LOGCAT = true

    getgenv().NAS_LOGCAT_CONN = game:GetService("LogService").MessageOut:Connect(function(message, type)
        if not getgenv().NAS_LOGCAT then return end
        if type == Enum.MessageType.MessageOutput or type == Enum.MessageType.MessageError or type == Enum.MessageType.MessageWarning then
            print("[LogCat] ["..type.Name.."]: "..message)
        end
    end)

    print("[Terminal] LogCat started.")
end},

{"unlogcat", function()
    if not getgenv().NAS_LOGCAT then
        print("[Terminal] LogCat is not running.")
        return
    end

    if getgenv().NAS_LOGCAT_CONN then
        getgenv().NAS_LOGCAT_CONN:Disconnect()
        getgenv().NAS_LOGCAT_CONN = nil
    end

    getgenv().NAS_LOGCAT = false
    print("[Terminal] LogCat stopped.")
end},

{"combatpack", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/AC2u9ynU/raw"))()
    end)

    if success then
        print("[Terminal] CombatPack executed successfully.")
    else
        warn("[Terminal] Failed to execute CombatPack:", err)
    end
end},

{"bang", function(args)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local plr = Players.LocalPlayer
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local targetName = args[1]
    local speed = tonumber(args[2]) or 5 -- default speed
    if not targetName then return warn("[Terminal] Usage: bang {player} {speed}") end

    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return warn("[Terminal] Target player not found or missing HumanoidRootPart.")
    end

    local hrp = char.HumanoidRootPart
    local targetHRP = target.Character.HumanoidRootPart
    local direction = 1
    local distance = 3 -- distance behind the target

    print("[Terminal] Bang started on "..targetName.." with speed "..speed)

    -- Stop previous bang if active
    if getgenv().NAS_BANG_CONN then getgenv().NAS_BANG_CONN:Disconnect() end

    getgenv().NAS_BANG_CONN = RunService.Heartbeat:Connect(function(dt)
        if not hrp or not targetHRP then getgenv().NAS_BANG_CONN:Disconnect() return end
        hrp.CFrame = targetHRP.CFrame * CFrame.new(0,0,-distance * direction)
        direction = direction * -1
    end)
end},

{"unbang", function()
    if getgenv().NAS_BANG_CONN then
        getgenv().NAS_BANG_CONN:Disconnect()
        getgenv().NAS_BANG_CONN = nil
        print("[Terminal] Bang stopped.")
    else
        print("[Terminal] No active bang to stop.")
    end
end},

{"tfling", function(args)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local targetName = args[1]
    local flingPower = tonumber(args[2]) or 999999
    local movel = 0.1

    if not targetName then return warn("[Terminal] Usage: tfling {player} {power}") end
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return warn("[Terminal] Target player not found or missing HRP.")
    end

    if getgenv().NAS_TFLING_CONN then getgenv().NAS_TFLING_CONN:Disconnect() end
    getgenv().NAS_TFLING_CONN = RunService.Heartbeat:Connect(function()
        if not hrp or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().NAS_TFLING_CONN:Disconnect()
            return
        end

        local vel = hrp.Velocity
        -- Burst fling + subtle oscillation
        hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
        hrp.Velocity = vel + Vector3.new(0, movel, 0)
        movel = -movel
    end)

    print("[Terminal] T-Fling started on "..targetName.." with power "..flingPower)
end},

{"untfling", function()
    if getgenv().NAS_TFLING_CONN then
        getgenv().NAS_TFLING_CONN:Disconnect()
        getgenv().NAS_TFLING_CONN = nil
        print("[Terminal] T-Fling stopped.")
    else
        print("[Terminal] No active T-Fling.")
    end
end},

{"fling", function(args)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local targetName = args[1]
    local flingPower = tonumber(args[2]) or 999999
    local duration = 5 -- seconds overlapping
    if not targetName then return warn("[Terminal] Usage: fling {player} {power}") end

    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return warn("[Terminal] Target player not found or missing HRP.")
    end

    local targetHRP = target.Character.HumanoidRootPart
    local originalCFrame = hrp.CFrame
    local movel = 0.1

    print("[Terminal] Flinging "..targetName.." for "..duration.." seconds.")

    -- Stop existing T-Fling
    if getgenv().NAS_TFLING_CONN then
        getgenv().NAS_TFLING_CONN:Disconnect()
        getgenv().NAS_TFLING_CONN = nil
    end

    local flingConn
    flingConn = RunService.Heartbeat:Connect(function()
        if not hrp or not targetHRP then flingConn:Disconnect() return end
        hrp.CFrame = targetHRP.CFrame -- overlap exactly
        local vel = hrp.Velocity
        hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
        hrp.Velocity = vel + Vector3.new(0, movel, 0)
        movel = -movel
    end)

    task.delay(duration, function()
        flingConn:Disconnect()
        hrp.CFrame = originalCFrame
        print("[Terminal] Fling finished, returned to original position.")
    end)
end},

{"flingnpcs", function()
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local movel = 0.1
    local flingPower = 999999

    -- Stop previous NPC fling if exists
    if getgenv().NAS_FLINGNPC_CONN then
        getgenv().NAS_FLINGNPC_CONN:Disconnect()
        getgenv().NAS_FLINGNPC_CONN = nil
    end

    -- Find NPCs (non-players with Humanoid + HumanoidRootPart)
    local npcs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if not Players:FindFirstChild(obj.Name) then
                table.insert(npcs, obj)
            end
        end
    end

    if #npcs == 0 then
        print("[Terminal] No NPCs found to fling.")
        return
    end

    print("[Terminal] Flinging "..#npcs.." NPCs.")

    -- Start Heartbeat fling
    getgenv().NAS_FLINGNPC_CONN = RunService.Heartbeat:Connect(function()
        for _, npc in ipairs(npcs) do
            local npcHRP = npc:FindFirstChild("HumanoidRootPart")
            if npcHRP then
                -- Take network ownership
                pcall(function() 
                    if npcHRP:CanSetNetworkOwnership() then
                        npcHRP:SetNetworkOwner(plr)
                    end
                end)
                -- Apply velocity fling
                local vel = npcHRP.Velocity
                npcHRP.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                npcHRP.Velocity = vel + Vector3.new(0, movel, 0)
            end
        end
        movel = -movel
    end)
end},

{"discord", function()
    local success, err = pcall(function()
        setclipboard("Join NasGUI: https://discord.gg/kEFtwwrsw")
    end)

    if success then
        print("[Terminal] Discord invite copied to clipboard.")
    else
        warn("[Terminal] Failed to copy to clipboard:", err)
    end
end},

{"creatorid", function()
    local success, err = pcall(function()
        local creator = game.Creator
        local info = string.format(
            "Creator Info:\nName: %s\nUserId: %d\nAccount Age: %d years\nGender: %s",
            creator.Name or "Unknown",
            creator.Id or 0,
            creator.AccountAge or 0,
            (creator.Gender and tostring(creator.Gender) or "Unknown")
        )
        setclipboard(info)
        print("[Terminal] Creator info copied to clipboard.")
    end)

    if not success then
        warn("[Terminal] Failed to grab creator info:", err)
    end
end},

{"jobid", function()
    local success, err = pcall(function()
        local jobId = game.JobId
        setclipboard(jobId)
        print("[Terminal] JobId copied to clipboard: "..jobId)
    end)

    if not success then
        warn("[Terminal] Failed to copy JobId:", err)
    end
end},

{"cfly", function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    if getgenv().NAS_CFLY_CONN then
        return print("[Terminal] CFly already active.")
    end

    local speed = 50
    local velocity = Vector3.zero
    local direction = Vector3.zero
    local keys = {W=false, A=false, S=false, D=false, Space=false, LeftShift=false}

    local function updateDirection()
        direction = Vector3.zero
        if keys.W then direction = direction + hrp.CFrame.LookVector end
        if keys.S then direction = direction - hrp.CFrame.LookVector end
        if keys.A then direction = direction - hrp.CFrame.RightVector end
        if keys.D then direction = direction + hrp.CFrame.RightVector end
        if keys.Space then direction = direction + Vector3.new(0,1,0) end
        if keys.LeftShift then direction = direction - Vector3.new(0,1,0) end
        direction = direction.Unit * speed
    end

    local inputConn
    inputConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then keys.W=true elseif input.KeyCode == Enum.KeyCode.A then keys.A=true
        elseif input.KeyCode == Enum.KeyCode.S then keys.S=true elseif input.KeyCode == Enum.KeyCode.D then keys.D=true
        elseif input.KeyCode == Enum.KeyCode.Space then keys.Space=true elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift=true end
        updateDirection()
    end)

    local inputConn2
    inputConn2 = UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then keys.W=false elseif input.KeyCode == Enum.KeyCode.A then keys.A=false
        elseif input.KeyCode == Enum.KeyCode.S then keys.S=false elseif input.KeyCode == Enum.KeyCode.D then keys.D=false
        elseif input.KeyCode == Enum.KeyCode.Space then keys.Space=false elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift=false end
        updateDirection()
    end)

    hum.PlatformStand = true
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if hrp then
            hrp.CFrame = hrp.CFrame + (direction * dt)
        end
    end)

    getgenv().NAS_CFLY_CONN = conn
    getgenv().NAS_CFLY_INPUTS = {inputConn, inputConn2}
    print("[Terminal] CFly enabled.")
end},

{"uncfly", function()
    if getgenv().NAS_CFLY_CONN then
        getgenv().NAS_CFLY_CONN:Disconnect()
        for _, ic in pairs(getgenv().NAS_CFLY_INPUTS) do
            ic:Disconnect()
        end
        getgenv().NAS_CFLY_CONN = nil
        getgenv().NAS_CFLY_INPUTS = nil
        local plr = game:GetService("Players").LocalPlayer
        local char = plr.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
        print("[Terminal] CFly disabled.")
    else
        print("[Terminal] CFly is not active.")
    end
end},

{"naked", function()
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()

    local shirt = char:FindFirstChildOfClass("Shirt")
    if shirt then shirt.ShirtTemplate = "rbxassetid://0" end

    local pants = char:FindFirstChildOfClass("Pants")
    if pants then pants.PantsTemplate = "rbxassetid://0" end

    local shirtG = char:FindFirstChildOfClass("ShirtGraphic")
    if shirtG then shirtG.Graphic = "rbxassetid://0" end

    print("[Terminal] Naked applied to local player.")
end},

{"skybox", function(args)
    if not args[1] then return warn("[Terminal] Usage: skybox {imageID}") end
    local id = args[1]
    local lighting = game:GetService("Lighting")

    -- Store original sky for reset
    if not getgenv().NAS_OLD_SKY then
        getgenv().NAS_OLD_SKY = lighting:FindFirstChildOfClass("Sky")
    end

    local sky = Instance.new("Sky")
    sky.Name = "NAS_Skybox"
    sky.SkyboxBk = "rbxassetid://"..id
    sky.SkyboxDn = "rbxassetid://"..id
    sky.SkyboxFt = "rbxassetid://"..id
    sky.SkyboxLf = "rbxassetid://"..id
    sky.SkyboxRt = "rbxassetid://"..id
    sky.SkyboxUp = "rbxassetid://"..id
    sky.Parent = lighting

    print("[Terminal] Skybox applied with ID:", id)
end},

{"unskybox", function()
    local lighting = game:GetService("Lighting")
    local oldSky = getgenv().NAS_OLD_SKY
    local currentSky = lighting:FindFirstChild("NAS_Skybox")
    if currentSky then currentSky:Destroy() end
    if oldSky then oldSky.Parent = lighting end
    print("[Terminal] Skybox reset.")
end},

{"skeletonskybox", function()
    local success, err = pcall(function()
        getgenv().NAS_SKELETON_SKYBOX = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Skeleton-skybox-53658"))()
    end)

    if success then
        print("[Terminal] Skeleton Skybox executed.")
    else
        warn("[Terminal] Failed to execute Skeleton Skybox:", err)
    end
end},

{"unskeletonskybox", function()
    if getgenv().NAS_SKELETON_SKYBOX then
        -- Try to clean up if the script exposes a cleanup function
        if type(getgenv().NAS_SKELETON_SKYBOX) == "function" then
            pcall(getgenv().NAS_SKELETON_SKYBOX) -- might attempt to reverse effects
        end
        getgenv().NAS_SKELETON_SKYBOX = nil
        print("[Terminal] Attempted to unexecute Skeleton Skybox.")
    else
        print("[Terminal] Skeleton Skybox not active.")
    end
end},

{"r6onr15", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-R6-Animations-on-R15-16865"))()
    end)

    if success then
        print("[Terminal] R6 animations are loaded.")
    else
        warn("[Terminal] Failed to execute R6 on R15 rig:", err)
    end
end},

{"korblox", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Korblox-R6-28939"))()
    end)

    if success then
        print("[Terminal] Korblox executed.")
    else
        warn("[Terminal] Failed to wear the Korblox:", err)
    end
end},

{"inflb", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-LeaderBoard-inf-local-HilalWare-Lua-60932"))()
    end)

    if success then
        print("[Terminal] Set leaderboard values to infinite.")
    else
        warn("[Terminal] Failed to set leaderboard values:", err)
    end
end},

{"roast", function(args)
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer

    local targetName = args[1]
    if not targetName then return warn("[Terminal] Usage: roast {player}") end

    local target = Players:FindFirstChild(targetName)
    if not target then return warn("[Terminal] Player not found.") end

    local roasts = {
        target.DisplayName.." is acting like a total nga, smh.",
        "Classic "..target.DisplayName..", thinking they’re smart, what a fuhhin move.",
        target.DisplayName.."’s skills are pure syht, honestly.",
        "Everyone run, "..target.DisplayName.." is about to do some mfing plays.",
        target.DisplayName.." couldn’t hit a barn with ahh aim.",
        "If laziness was an olympic sport, "..target.DisplayName.." would take mfing gold.",
        target.DisplayName.."’s brain must be on vacation, dih.",
        "Stop trying, "..target.DisplayName..", you’re giving bih vibes.",
        target.DisplayName.." always pulling fuhhin stunts in every game.",
        "Look at "..target.DisplayName..", the king of mfing mistakes."
    }

    local message = roasts[math.random(1, #roasts)]

    print("[Terminal] Roast for "..target.DisplayName..": "..message)
end},

{"fakeiplog", function(args)
    local Players = game:GetService("Players")
    local TextChatService = game:GetService("TextChatService")
    local lp = Players.LocalPlayer

    local function chat(msg)
        -- TextChatService safe message
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end

    local targetName = args[1]
    if not targetName then
        return warn("[Terminal] Usage: fakeiplog {player}")
    end

    local target = Players:FindFirstChild(targetName)
    if not target then
        return warn("[Terminal] Player not found")
    end

    -- Generates a random fake IPv4
    local function randomIP()
        return math.random(10,250).."."..
               math.random(1,255).."."..
               math.random(1,255).."."..
               math.random(1,255)
    end

    local fakeIP = randomIP()

    -- Chat sequence
    task.spawn(function()
        chat("Grabbing "..target.DisplayName.."'s Roblox cookie...")
        task.wait(1.5)
        chat("Logging "..target.DisplayName.."'s IP addy...")
        task.wait(1.5)
        chat("IP logging executed! Grabbed IP addy: "..fakeIP)
    end)
end},

{"fakecoords", function(args)
    local targetName = args[1]
    if not targetName then return end

    local Players = game:GetService("Players")
    local TextChatService = game:GetService("TextChatService")

    local target = Players:FindFirstChild(targetName)
    if not target then return end

    -- Generate fake but realistic coordinates
    local function randomCoord()
        local whole = math.random(-89, 89)
        local decimal = math.random()
        local full = whole + decimal
        return string.format("%.6f", full)
    end

    local lat = randomCoord()
    local lon = randomCoord()

    local msg1 = "Scanning " .. target.DisplayName .. "'s real‑time location..."
    local msg2 = "GPS lock complete."
    local msg3 = "Coordinates locked: " .. lat .. ", " .. lon .. ". See you soon."

    local general = TextChatService.TextChannels.RBXGeneral
    general:SendAsync(msg1)
    task.wait(1.5)
    general:SendAsync(msg2)
    task.wait(1)
    general:SendAsync(msg3)
end},

{"accountage", function(args)
    local targetName = args[1]
    if not targetName then return end

    local Players = game:GetService("Players")
    local target = Players:FindFirstChild(targetName)
    if not target then return end

    local days = target.AccountAge
    local years = math.floor(days / 365)
    local remainingDays = days % 365

    print(string.format(
        "[Terminal] %s's account age: %d years and %d days old (%d days total)",
        target.DisplayName, years, remainingDays, days
    ))
end},

{"oldestplayer", function()
    local Players = game:GetService("Players")
    local oldest = nil
    local maxAge = -1

    for _, plr in pairs(Players:GetPlayers()) do
        if plr.AccountAge > maxAge then
            maxAge = plr.AccountAge
            oldest = plr
        end
    end

    if oldest then
        local years = math.floor(maxAge / 365)
        local days = maxAge % 365
        print(string.format("[Terminal] Oldest player: %s (%d years, %d days old)", oldest.DisplayName, years, days))
    else
        print("[Terminal] No players found.")
    end
end},

{"youngestplayer", function()
    local Players = game:GetService("Players")
    local youngest = nil
    local minAge = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr.AccountAge < minAge then
            minAge = plr.AccountAge
            youngest = plr
        end
    end

    if youngest then
        local years = math.floor(minAge / 365)
        local days = minAge % 365
        print(string.format("[Terminal] Youngest player: %s (%d years, %d days old)", youngest.DisplayName, years, days))
    else
        print("[Terminal] No players found.")
    end
end},

{"enablecoregui", function()
    local StarterGui = game:GetService("StarterGui")

    for _, enum in pairs(Enum.CoreGuiType:GetEnumItems()) do
        pcall(function()
            StarterGui:SetCoreGuiEnabled(enum, true)
        end)
    end

    print("[Terminal] All CoreGui elements enabled.")
end},

{"feelings", function()
    local Players = game:GetService("Players")
    local TextChatService = game:GetService("TextChatService")
    local RunService = game:GetService("RunService")

    local lp = Players.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Track previous health
    local prevHealth = hum.Health

    -- Connections storage
    getgenv().NAS_FEELINGS_CONNECTIONS = getgenv().NAS_FEELINGS_CONNECTIONS or {}

    -- Get default channel safely
    local channel
    pcall(function()
        channel = TextChatService:GetTextChannels()[1] -- first available channel
    end)
    if not channel then warn("[Terminal] No TextChat channel found!") return end

    -- Chat helper
    local function chat(msg)
        pcall(function()
            channel:SendAsync(msg)
        end)
    end

    -- Damage/Heal/Death detection
    local healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        local delta = hum.Health - prevHealth
        if delta < 0 then
            if hum.Health <= 0 then
                chat("GRULGH!")
            elseif delta / hum.MaxHealth < -0.5 then
                chat("ARGGH!!")
            else
                local msgs = {"OW!", "OUCH!", "AGH!"}
                chat(msgs[math.random(1, #msgs)])
            end
        elseif delta > 0 then
            chat("Ah yes...")
        end
        prevHealth = hum.Health
    end)
    table.insert(getgenv().NAS_FEELINGS_CONNECTIONS, healthConn)

    -- Fling detection (HRP velocity spike)
    local flingConn = RunService.Heartbeat:Connect(function()
        if hrp.Velocity.Magnitude > 100 then
            chat("AAAAAAAAAAA!!!")
        end
    end)
    table.insert(getgenv().NAS_FEELINGS_CONNECTIONS, flingConn)

    -- Nearby chat insults
    local chatConn
    chatConn = TextChatService.OnIncomingMessage:Connect(function(msgObj)
        local senderId = msgObj.TextSource and msgObj.TextSource.UserId
        local content = msgObj.Text
        if not senderId or senderId == lp.UserId then return end

        local insults = {"u suck","shut up","stfu","syfm","sybau"}
        for _, insult in pairs(insults) do
            if string.find(string.lower(content), insult) then
                local player = Players:GetPlayerByUserId(senderId)
                if player and (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
                    local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 10 then
                        local responses = {":(", "Rude.", "Aw man.", "..."}
                        chat(responses[math.random(1,#responses)])
                        break
                    end
                end
            end
        end
    end)
    table.insert(getgenv().NAS_FEELINGS_CONNECTIONS, chatConn)

    print("[Terminal] Feelings activated.")
end},

{"unfeelings", function()
    if getgenv().NAS_FEELINGS_CONNECTIONS then
        for _, conn in pairs(getgenv().NAS_FEELINGS_CONNECTIONS) do
            pcall(function() conn:Disconnect() end)
        end
        getgenv().NAS_FEELINGS_CONNECTIONS = nil
        print("[Terminal] Feelings deactivated.")
    else
        print("[Terminal] Feelings were not active.")
    end
end},

{"fireallremotes", function()
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local function fireRemote(remote)
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer()
            end)
        elseif remote:IsA("RemoteFunction") then
            pcall(function()
                remote:InvokeServer()
            end)
        end
    end

    local function scanAndFire(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                fireRemote(obj)
            end
        end
    end

    scanAndFire(Workspace)
    scanAndFire(game:GetService("ReplicatedStorage"))
    scanAndFire(game:GetService("Players").LocalPlayer.PlayerGui)

    print("[Terminal] Attempted to fire all RemoteEvents and RemoteFunctions.")
end},

{"setfpscap", function(args)
    if not setfpscap then
        warn("[Terminal] setfpscap() not supported in this executor.")
        return
    end

    local cap = tonumber(args[1])
    if not cap then
        warn("[Terminal] Usage: setfpscap {number}")
        return
    end

    setfpscap(cap)
    print("[Terminal] FPS capped to " .. cap)
end},

-- leave
{"leave", function()
    game:Shutdown()
end},

-- clientantikick  (simple hook-based)
{"clientantikick", function()
    if getrawmetatable then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if tostring(method) == "Kick" or tostring(method) == "kick" then
                return nil
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end},

-- unclientantikick (restores metatable)
{"unclientantikick", function()
    if getrawmetatable then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__namecall = nil
        setreadonly(mt, true)
    end
end},

-- adonisbypass
{"adonisbypass", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-adonis-admin-bypass-19375"))()
end},

-- joinplace {placeid}
{"joinplace", function(args)
    local id = tonumber(args[1])
    if id then
        game:GetService("TeleportService"):Teleport(id)
    end
end},

-- freeze (local only)
{"freeze", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = true
    end
end},

-- unfreeze
{"unfreeze", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = false
    end
end},

-- hitbox {player} {size}
{"hitbox", function(args)
    local name = args[1]
    local size = tonumber(args[2]) or 5

    local plr = game.Players:FindFirstChild(name)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hb = Instance.new("Part")
        hb.Name = "Nas_Hitbox"
        hb.Size = Vector3.new(2, size, 2)
        hb.Transparency = 1
        hb.CanCollide = false
        hb.Anchored = false
        hb.Parent = plr.Character
        hb.CFrame = plr.Character.HumanoidRootPart.CFrame

        local weld = Instance.new("WeldConstraint", hb)
        weld.Part0 = hb
        weld.Part1 = plr.Character.HumanoidRootPart
    end
end},

-- unhitbox
{"unhitbox", function()
    local lp = game.Players.LocalPlayer
    if lp.Character then
        local hb = lp.Character:FindFirstChild("Nas_Hitbox")
        if hb then hb:Destroy() end
    end
end},

-- stun (PlatformStand loop)
{"stun", function()
    local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.PlatformStand = true
    end
end},

-- unstun
{"unstun", function()
    local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.PlatformStand = false
    end
end}

}

local function refreshCommands()
    for _, obj in ipairs(list:GetChildren()) do
        if obj:IsA("TextLabel") then obj:Destroy() end
    end

    for _, data in ipairs(commands) do
        local lbl = Instance.new("TextLabel", list)
        lbl.Size = UDim2.new(1, -4, 0, 24)
        lbl.BackgroundColor3 = Color3.fromRGB(40,40,40)
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 14
        lbl.Text = "> " .. data[1]
        lbl.BorderSizePixel = 0
    end

    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

refreshCommands()

----------------------------------------------------------------------
-- SLIDING (UP/DOWN) ANIMATIONS
----------------------------------------------------------------------

local slideUp = TweenService:Create(panel, TweenInfo.new(.3, Enum.EasingStyle.Quad),
    {Position = UDim2.new(1,-10,1,-10)})

local slideDown = TweenService:Create(panel, TweenInfo.new(.3, Enum.EasingStyle.Quad),
    {Position = UDim2.new(1,-10,1,200)})

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
-- AUTO-HIDE (5s)
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

local function resetTimer()
    if open then inactive = 0 end
end

panel.InputBegan:Connect(resetTimer)
box.Focused:Connect(resetTimer)
list.InputBegan:Connect(resetTimer)

----------------------------------------------------------------------
-- EXECUTE COMMAND ON ENTER
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
