--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...

local RL = RLib
local Action = RL.Action
local Utils = RL.Utils
local Player = RL.Player;
local Target = RL.Target;

if RLib_AssistedCombat_SavedVar == nil then
    RLib_AssistedCombat_SavedVar = {}
end

if RLib_AssistedCombat_SavedVar.SpellDict == nil then
    RLib_AssistedCombat_SavedVar.SpellDict = {}
end

RL.Rotations[addonName] = Rotation
Rotation.Macros = {}



function Rotation:Check()
    local isAvailable, failureReason = C_AssistedCombat.IsAvailable()
    if isAvailable then
        return true, 99
    end
    Utils.Print(addonName .. ": " .. failureReason)
    return false, 99
end

function Rotation:InitMacro()
    local macro = Rotation.Macros;
    local SpellDict = RLib_AssistedCombat_SavedVar.SpellDict

    -- 确保SpellDict不为nil
    if SpellDict == nil then
        SpellDict = {}
        RLib_AssistedCombat_SavedVar.SpellDict = SpellDict
    end

    do
        local spellIDs = C_AssistedCombat.GetRotationSpells()
        for i = 1, #spellIDs do
            local spellID = spellIDs[i]
            local spellName = C_Spell.GetSpellName(spellID)
            local baseSpellID = C_Spell.GetBaseSpell(spellID)
            local baseSpellName = C_Spell.GetSpellName(baseSpellID)
            -- Utils.Print("SpellID:" .. spellID .. " BaseSpellID:" .. baseSpellID .. " SpellName:" .. spellName .. " BaseSpellName:" .. baseSpellName)
            SpellDict[spellID] = spellName
            SpellDict[baseSpellID] = baseSpellName
        end
    end
    do
        for spellID, spellName in pairs(SpellDict) do
            Utils.Print("SpellID:" .. spellID .. " spellName:" .. spellName)
            local macro_text = "/cast " .. spellName
            table.insert(macro, { ["title"] = spellName, ["macrotext"] = macro_text })
        end
        local ass_name = C_Spell.GetSpellName(C_AssistedCombat.GetActionSpell())
        local acc_macro_text = "/cast " .. ass_name
        table.insert(macro, { ["title"] = "AssistedCombat", ["macrotext"] = acc_macro_text })
    end
    RLib_AssistedCombat_SavedVar.SpellDict = SpellDict
end

function Rotation:Init()
    self:InitMacro()
    Utils.Print(addonName .. " Inited")
end

local function IdleState()
    if Player:DebuffExists(432031) or Player:DebuffExists("抓握之血") then
        return "存在抓握之血"
    end

    -- 检查是否在坐骑上
    if IsMounted() then
        return "载具中"
    end

    -- 检查是否在载具中
    if Player:InVehicle() then
        return "载具中"
    end

    -- 检查聊天框是否激活
    if ChatFrame1EditBox:IsVisible() then
        return "聊天框激活"
    end

    -- 检查玩家是否死亡或处于灵魂状态
    if Player:IsDeadOrGhost() then
        return "玩家已死亡"
    end

    -- 检查目标是否为玩家（PVP情况）
    if Target:IsPlayer() then
        return "目标是玩家"
    end

    -- 检查是否有目标
    if not Target:Exists() then
        return "目标为空"
    end

    -- 检查玩家是否在战斗中
    if not Player:AffectingCombat() then
        return "玩家不在战斗"
    end

    -- 检查玩家是否正在施法
    if Player:IsCasting() then
        return "玩家在施法读条"
    end
    return nil
end

function Rotation:Main()
    local SpellDict = RLib_AssistedCombat_SavedVar.SpellDict
    local spellID = C_AssistedCombat.GetNextCastSpell(false)

    local idleState = IdleState()
    if idleState then
        return "idle", idleState
    end

    if spellID == 0 then
        return "cast", "AssistedCombat"
    end
    if SpellDict[spellID] then
        local spellName = SpellDict[spellID]
        return "cast", spellName
    else
        local spellName = C_Spell.GetSpellName(spellID)
        if spellName == nil then
            Utils.Print("SpellID:" .. spellID .. " 无法获取法术名称，请使用/reload修复")
            return "cast", "AssistedCombat"
        else
            Utils.Print("SpellID:" .. spellID .. "spellName" .. spellName .. "，未出现在初始化宏中，请使用/reload修复")
            if (spellName ~= nil) and (spellID ~= nil) then
                RLib_AssistedCombat_SavedVar.SpellDict[spellID] = spellName -- 修复拼写错误 SpellDictt -> SpellDict
            end
            return "cast", spellName
        end
    end
end
