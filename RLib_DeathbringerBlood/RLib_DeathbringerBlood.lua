--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...
local RL = RLib
local Utils = RL.Utils
local Player = RL.Player;
local Target = RL.Target;
local MouseOver = RL.MouseOver;
local Focus = RL.Focus;
local Spell = RL.Spell
local Party = RL.Party
local Plater = RL.Plater
local Combat = RL.Combat

RL.Rotations[addonName] = Rotation

Rotation.Macros = {}
local macro = Rotation.Macros;

macro[1] = { ["title"] = "灵界打击", ["macrotext"] = "/cast 灵界打击" }
macro[2] = { ["title"] = "灵界打击（就近）", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 灵界打击\n/targetlasttarget" }
macro[3] = { ["title"] = "血液沸腾", ["macrotext"] = "/cast 血液沸腾" }
macro[4] = { ["title"] = "精髓分裂", ["macrotext"] = "/cast 精髓分裂" }
macro[5] = { ["title"] = "死神的抚摩", ["macrotext"] = "/cast 死神的抚摩" }
macro[6] = { ["title"] = "心灵冰冻焦点", ["macrotext"] = "/cast [@focus] 心灵冰冻" }
macro[7] = { ["title"] = "心灵冰冻目标", ["macrotext"] = "/cast 心灵冰冻" }
macro[8] = { ["title"] = "心灵冰冻鼠标", ["macrotext"] = "/cast [@mouseover] 心灵冰冻" }
macro[9] = { ["title"] = "枯萎凋零", ["macrotext"] = "/cast [@player]  枯萎凋零" }
macro[10] = { ["title"] = "枯萎凋零鼠标", ["macrotext"] = "/cast [@cursor]  枯萎凋零" }
macro[11] = { ["title"] = "心脏打击", ["macrotext"] = "/cast 心脏打击" }
macro[12] = { ["title"] = "心脏打击（就近）", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 心脏打击\n/targetlasttarget" }
macro[13] = { ["title"] = "白骨风暴", ["macrotext"] = "/cast 白骨风暴" }
macro[14] = { ["title"] = "死神印记", ["macrotext"] = "/cast 死神印记" }
macro[15] = { ["title"] = "吞噬", ["macrotext"] = "/cast 吞噬" }
macro[16] = { ["title"] = "墓石", ["macrotext"] = "/cast 墓石" }
macro[17] = { ["title"] = "亡者复生", ["macrotext"] = "/cast 亡者复生" }
macro[18] = { ["title"] = "灵魂收割", ["macrotext"] = "/cast 灵魂收割" }



function Rotation:Check()
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()
    if (classFilename == "DEATHKNIGHT") and (currentSpec == 1) then
        return true, 1
    end
    return false, 1
end

function Rotation:Init()
    Utils.Print(addonName .. " Inited")
end

-- [圣光虔敬魔典]
local function checkTomeOfLightDevotion()
    -- 判断标准
    -- 栏位13必须是[圣光虔敬魔典]
    local itemId = GetInventoryItemID("player", 13)
    if itemId ~= 219309 then
        return false
    end
    -- 必须是[圣光虔敬魔典]的CD
    local _, duration, enable = C_Container.GetItemCooldown(219309)
    if (enable ~= 1) or (duration ~= 0) then
        return false
    end
    -- 必须有[450706的]的buff
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(450706)
    if aura then
        return true
    else
        return false
    end
end


local function getRunicNum()
    local spellCooldownInfo = C_Spell.GetSpellCooldown(61304)
    local gcd_remaining
    if spellCooldownInfo.duration == 0 then
        gcd_remaining = 0
    else
        gcd_remaining = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()
    end

    local amount = 0
    for i = 1, 6 do
        local start, duration, runeReady = GetRuneCooldown(i)
        if runeReady then
            amount = amount + 1
        else
            -- 如果符文冷却小于GCD，也算
            if (start + duration - GetTime()) < gcd_remaining then
                amount = amount + 1
            end
        end
    end
    return amount
end

function Rotation.Main()
    local settings = RLib_DeathbringerBlood_SavedVar

    -- 检查是否有抓握之血debuff，如果有则不进行操作
    if Player:DebuffExists(432031) or Player:DebuffExists("抓握之血") then
        return "idle", "存在抓握之血"
    end

    -- 检查是否在坐骑上
    if IsMounted() then
        return "idle", "载具中"
    end

    -- 检查是否在载具中
    if Player:InVehicle() then
        return "idle", "载具中"
    end

    -- 检查聊天框是否激活
    if ChatFrame1EditBox:IsVisible() then
        return "idle", "聊天框激活"
    end

    -- 检查玩家是否死亡或处于灵魂状态
    if Player:IsDeadOrGhost() then
        return "idle", "玩家已死亡"
    end

    -- 检查目标是否为玩家（PVP情况）
    if Target:IsPlayer() then
        return "idle", "目标是玩家"
    end

    -- 检查是否有目标
    if not Target:Exists() then
        return "idle", "目标为空"
    end

    -- 检查玩家是否在战斗中
    if not Player:AffectingCombat() then
        return "idle", "玩家不在战斗"
    end

    -- 检查玩家是否正在施法
    if Player:IsCasting() then
        return "idle", "玩家在施法读条"
    end


    local RunicPower = Player:RunicPower()
    local RunicNum = getRunicNum()


    if (Player:HealthPercentage() < 50) and (RunicPower >= 40) then
        return "cast", "灵界打击"
    end

    -- 有两层恶魔尖刺，则用，不浪费
    if Spell("恶魔尖刺"):Charges() == 2 then
        return "cast", "恶魔尖刺"
    end

    if Spell("心灵冰冻"):CooldownUp() then
        if MouseOver:Exists() and MouseOver:ShouldInterrupt() and MouseOver:AffectingCombat() and MouseOver:InRange(5) and MouseOver:CanAttack(Player) then
            return "cast", "心灵冰冻鼠标"
        end
        if Focus:Exists() and Focus:ShouldInterrupt() and Focus:AffectingCombat() and Focus:InRange(5) and Focus:CanAttack(Player) then
            return "cast", "心灵冰冻焦点"
        end
        if Target:Exists() and Target:ShouldInterrupt() and Target:AffectingCombat() and Target:InRange(5) and Target:CanAttack(Player) then
            return "cast", "心灵冰冻目标"
        end
    end

    -- [圣光虔敬魔典]
    if checkTomeOfLightDevotion() then
        return "cast", "圣光虔敬魔典"
    end



    if (Player:BuffStacks("白骨之盾") < 5) or Player:BuffRemaining("白骨之盾") < 6 then
        if Spell("死神印记"):CooldownUp() and (not Player:BuffExists("破灭")) then
            return "cast", "死神印记"
        end

        if Spell("死神的抚摩"):CooldownUp() and Target:InRange(30) then
            return "cast", "死神的抚摩"
        end

        if Spell("死神的抚摩"):CooldownUp() and Focus:InRange(30) then
            return "cast", "死神的抚摩焦点"
        end

        if Player:BuffExists("破灭") and Target:InRange(5) and Target:HealthPercentage() > 10 then
            return "cast", "精髓分裂"
        end

        if Target:InRange(5) then
            return "cast", "精髓分裂"
        end
    end

    if Spell("亡者复生"):CooldownUp() then
        return "cast", "亡者复生"
    end

    if not Player:BuffExists("枯萎凋零") then
        if Player:BuffExists("赤色天灾") then
            return "cast", "枯萎凋零"
        end

        if Spell("枯萎凋零"):Charges() >= 2 then
            return "cast", "枯萎凋零"
        end

        if not Player:IsMoving() then
            return "cast", "枯萎凋零"
        end
    end


    if Spell("死神印记"):CooldownUp() and (not Player:BuffExists("破灭")) then
        return "cast", "死神印记"
    end


    if Spell("灵魂收割"):IsKnown() and Spell("灵魂收割"):CooldownUp() and (Target:HealthPercentage() < 35) then
        return "cast", "灵魂收割"
    end


    if Player:BuffExists("枯萎凋零") and (Player:BuffStacks("白骨之盾") >= 5) and (Spell("符文刃舞"):Cooldown() >= 25) and (RunicPower < 90) and Spell("墓石"):CooldownUp() then
        return "cast", "墓石"
    end

    if Player:BuffExists("枯萎凋零") and (Player:BuffStacks("白骨之盾") >= 5) and (Spell("符文刃舞"):Cooldown() >= 25) and (RunicPower < 90) and Spell("白骨风暴"):CooldownUp() then
        return "cast", "白骨风暴"
    end

    if RunicPower >= 100 then
        return "cast", "灵界打击"
    end

    if (Player:BuffRemaining("凝血") <= 2) and (RunicPower >= 80) then
        return "cast", "灵界打击"
    end

    if Player:BuffExists("吸血鬼之血") and (Target:DebuffRemaining("血之疫病") >= 6) and Spell("吞噬"):CooldownUp() then
        return "cast", "吞噬"
    end

    if (Spell("吸血鬼之血"):Cooldown() >= 30) and (Target:DebuffRemaining("血之疫病") >= 6) and Spell("吞噬"):CooldownUp() then
        return "cast", "吞噬"
    end

    if (Spell("血液沸腾"):Charges() >= 1) and Plater:AnyEnemyInMelee() then
        return "cast", "血液沸腾"
    end

    if (Player:BuffStacks("白骨之盾") <= 8) then
        if Spell("死神的抚摩"):CooldownUp() and Target:InRange(30) then
            return "cast", "死神的抚摩"
        end
        if Target:InRange(5) then
            return "cast", "精髓分裂"
        end
    end

    if RunicNum >= 1 then
        return "cast", "心脏打击"
    end


    return "idle", "无事可做"
end
