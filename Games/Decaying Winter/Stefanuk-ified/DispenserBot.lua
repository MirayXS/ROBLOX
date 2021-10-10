-- // Information
--[[
    Original Thread: https://v3rmillion.net/showthread.php?tid=1140457
]]

-- // Dependencies
local CommandHandler, CommandClass = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Commands/Module.lua"))()

-- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Vars
local LocalPlayer = Players.LocalPlayer

local dropAmmo = Workspace.ServerStuff.dropAmmo
local SayMessageRequest = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest

-- // Chat a message to everyone
local function ChatMessage(Message)
    SayMessageRequest:FireServer(Message, "All")
end

-- // Teleports to player, performes callback, teleports back
local function GoToCallback(Player, Callback)
    -- // Vars
    local Character = LocalPlayer.Character
    local PlayerCharacter = Player.Character

    -- // Make sure isn't dead
    if (not Character) then
        return ChatMessage("I am currently dead")
    end
    if (not PlayerCharacter) then
        return ChatMessage("You are dead")
    end

    -- // Vars
    local HumanoidRootPart = Character.HumanoidRootPart
    local SavedCFrame = HumanoidRootPart.CFrame

    -- // Teleport
    HumanoidRootPart.CFrame = PlayerCharacter.HumanoidRootPart.CFrame
    wait(0.25)

    -- // Callback
    Callback()
    wait(0.25)

    -- // Teleport back
    HumanoidRootPart.CFrame = SavedCFrame
end

-- //
local Handler = CommandHandler.new()

-- // Help command
local AllCommands = {"!mre -- Gives you an mre lunchbox (mom packed a gogurt)", "!water -- Gives you a water bottle (Its not dasani)", "!scrap -- Gives you 500 scrap", "!ammo -- Gives you lots of ammo (Case sensitve, e.g. to get light ammo would be !ammo Light)", "Item spawning soon!"}
CommandClass.new({
    Name = {"help", "cmds"},
    Handler = Handler,
    Callback = function()
        -- // Loop through each help message
        for _, Command in ipairs(AllCommands) do
            -- // Chat it, delay
            ChatMessage(Command)
            wait(0.5)
        end
    end
})

-- // MRE command
CommandClass.new({
    Name = {"mre", "lunchbox"},
    Handler = Handler,
    Callback = function(ExecutePlayer)
        GoToCallback(ExecutePlayer, function()
            dropAmmo:FireServer("rations", "MRE")
        end)
    end
})

-- // Water command
CommandClass.new({
    Name = {"water", "bottle", "thirsty", "aquafill"},
    Handler = Handler,
    Callback = function(ExecutePlayer)
        GoToCallback(ExecutePlayer, function()
            dropAmmo:FireServer("rations", "Bottle")
        end)
    end
})

-- // Scrap command
CommandClass.new({
    Name = {"scrap"},
    Handler = Handler,
    Callback = function(ExecutePlayer)
        GoToCallback(ExecutePlayer, function()
            dropAmmo:FireServer("scrap", 500)
        end)
    end
})

-- // Ammo command
local AmmoTypes = {"light", "short", "small", "medium", "heavy", "long", "shells"}
CommandClass.new({
    Name = {"scrap"},
    ArgParse = {"string"},
    Handler = Handler,
    Callback = function(ExecutePlayer, Arguments)
        -- // Validate ammo
        local AmmoType = Arguments[1]
        if not (table.find(AmmoTypes, Arguments[1]:lower())) then
            return
        end

        -- // Make first character uppercase
        AmmoType = AmmoType:gsub("^%l", string.upper)

        -- //
        GoToCallback(ExecutePlayer, function()
            dropAmmo:FireServer(AmmoType, 500)
        end)
    end
})

-- // Start
Handler:StartChatListen()