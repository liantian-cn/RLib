--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...
local UnitObj = RL.Class.Unit

RL.Unit = {}

local Unit = RL.Unit


Unit.Player = UnitObj:new("player")
Unit.Pet = UnitObj:new("pet")
Unit.Target = UnitObj:new("target")
Unit.Focus = UnitObj:new("focus")
Unit.MouseOver = UnitObj:new("mouseover")
Unit.Vehicle = UnitObj:new("vehicle")
-- 全局便利性
RL.Player = Unit.Player
RL.Pet = Unit.Pet
RL.Target = Unit.Target
RL.Focus = Unit.Focus
RL.MouseOver = Unit.MouseOver
RL.Vehicle = Unit.Vehicle

Unit.Arena = {}
Unit.Boss = {}
Unit.Nameplate = {}
Unit.Party = {}
Unit.Raid = {}

local function refreshParty()
    wipe(Unit.Party)
    local numGroupMembers = GetNumGroupMembers()
    table.insert(Unit.Party, Unit.Player)
    for i = 1, numGroupMembers do
        local UnitKey = string.format("%s%d", "party", i)
        local unit = UnitObj:new(UnitKey)
        unit:refreshStatus()
        table.insert(Unit.Party, unit)
    end

    table.sort(Unit.Party, function(UnitA, UnitB)
        -- 主要根据健康分数排序（由低到高）
        return UnitA:RelativeHealthPercentage() < UnitB:RelativeHealthPercentage()
    end)
end


local function refreshRaid()
    wipe(Unit.Raid)
    if not RLib_SavedVar["enableRAID"] then
        return
    end
    for i = 1, 40 do
        local UnitKey = string.format("%s%d", "raid", i)
        local unit = UnitObj:new(UnitKey)
        unit:refreshStatus()
        if unit:Exists() then
            table.insert(Unit.Raid, unit)
        end
    end
end


local function refreshNameplate()
    wipe(Unit.Nameplate)
    local namePlates = C_NamePlate.GetNamePlates()
    for i = 1, #namePlates do
        local plate = namePlates[i]
        local UnitKey = plate.namePlateUnitToken
        local unit = UnitObj:new(UnitKey)
        unit:refreshStatus()
        if unit:Exists() and unit:CanBeAttackedByPlayer() then
            table.insert(Unit.Nameplate, unit)
        end
    end
end

local function refreshArena()
    wipe(Unit.Arena)
    if not RLib_SavedVar["enableArena"] then
        return
    end
    for i = 1, 5 do
        local UnitKey = string.format("%s%d", "arena", i)
        local unit = UnitObj:new(UnitKey)
        unit:refreshStatus()
        if not unit:Exists() then
            break
        end
        table.insert(Unit.Arena, unit)
    end
end

local function refreshBoss()
    wipe(Unit.Boss)
    if not RLib_SavedVar["enableBoss"] then
        return
    end
    for i = 1, 5 do
        local UnitKey = string.format("%s%d", "boss", i)
        local unit = UnitObj:new(UnitKey)
        unit:refreshStatus()
        if unit:Exists() then
            table.insert(Unit.Boss, unit)
        end
    end
end





function RL.refreshUnit()
    Unit.Player:refreshStatus();
    Unit.Pet:refreshStatus();
    Unit.Target:refreshStatus();
    Unit.Focus:refreshStatus();
    Unit.MouseOver:refreshStatus();
    Unit.Vehicle:refreshStatus();
    refreshParty();
    refreshRaid();
    refreshNameplate();
    refreshArena();
    refreshBoss();
    -- for _, UnitID in pairs(UnitIDs) do
    --     local UnitType = UnitID[1]
    --     local UnitCount = UnitID[2]
    --     for i = 1, UnitCount do
    --         local UnitKey = string.format("%s%d", UnitType, i)
    --         Unit[UnitType][UnitKey:lower()]:refreshStatus();
    --     end
    -- end
end
