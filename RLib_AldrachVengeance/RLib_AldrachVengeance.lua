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

macro[1] = { ["title"] = "幽魂炸弹", ["macrotext"] = "/cast 幽魂炸弹\n/cast 恶魔尖刺" }
macro[2] = { ["title"] = "怨念咒符脚下", ["macrotext"] = "/cast [@player] 怨念咒符" }
macro[3] = { ["title"] = "恶魔尖刺", ["macrotext"] = "/cast 恶魔尖刺" }
macro[4] = { ["title"] = "投掷利刃", ["macrotext"] = "/cast 投掷利刃" }
macro[5] = { ["title"] = "排气臂铠护腕", ["macrotext"] = "/use 9" }
macro[6] = { ["title"] = "收割者战刃", ["macrotext"] = "/cast 收割者战刃\n/cast 恶魔尖刺" }
macro[7] = { ["title"] = "灵魂裂劈", ["macrotext"] = "/cast 灵魂裂劈\n/cast 恶魔尖刺" }
macro[8] = { ["title"] = "就近灵魂裂劈", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 灵魂裂劈\n/targetlasttarget\n/cast 恶魔尖刺" }
macro[9] = { ["title"] = "烈火烙印", ["macrotext"] = "/cast 烈火烙印" }
macro[10] = { ["title"] = "烈焰咒符脚下", ["macrotext"] = "/use [@player] 烈焰咒符" }
macro[11] = { ["title"] = "献祭光环", ["macrotext"] = "/cast 献祭光环\n/cast 恶魔尖刺" }
macro[12] = { ["title"] = "瓦解焦点", ["macrotext"] = "/cast [@focus] 瓦解" }
macro[13] = { ["title"] = "瓦解目标", ["macrotext"] = "/cast 瓦解" }
macro[14] = { ["title"] = "破裂", ["macrotext"] = "/cast 破裂\n/cast 恶魔尖刺" }
macro[15] = { ["title"] = "就近破裂", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 破裂\n/targetlasttarget\n/cast 恶魔尖刺" }
macro[16] = { ["title"] = "邪能之刃", ["macrotext"] = "/cast 邪能之刃" }
macro[17] = { ["title"] = "就近邪能之刃", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 邪能之刃\n/targetlasttarget\n/cast 恶魔尖刺" }
macro[18] = { ["title"] = "邪能毁灭", ["macrotext"] = "/cast 邪能毁灭" }
macro[19] = { ["title"] = "圣光虔敬魔典", ["macrotext"] = "/use 13" }
macro[20] = { ["title"] = "13号饰品", ["macrotext"] = "/use 13" }
macro[21] = { ["title"] = "14号饰品", ["macrotext"] = "/use 14" }
macro[22] = { ["title"] = "恶魔变形", ["macrotext"] = "/cast 恶魔变形" }
macro[23] = { ["title"] = "灵魂切削", ["macrotext"] = "/cast 灵魂切削" }
macro[24] = { ["title"] = "瓦解鼠标", ["macrotext"] = "/cast [@mouseover] 瓦解" }


function Rotation:Check()
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()
    if (classFilename == "DEMONHUNTER") and (currentSpec == 2) then
        return true, 1
    end
    return false, 1
end

function Rotation:Init()
    Utils.Print(addonName .. " Inited")
end

-- 排气臂铠可用
local function checkVentingVambracesReady()
    local itemId = GetInventoryItemID("player", 9)
    if itemId ~= 221806 then
        return false
    end
    local _, duration, enable = C_Container.GetItemCooldown(221806)
    return (enable == 1) and (duration == 0)
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


local function getSoulFragmentsNum()
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(203981)
    if aura then
        return aura.applications
    else
        return 0
    end
end

function Rotation.Main()
    local settings = RLib_AldrachVengeance_SavedVar

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




    local soulNum = getSoulFragmentsNum() -- 获取灵魂碎片数量

    -- 皮甲工程护腕
    if (Player:HealthPercentage() < 50) and checkVentingVambracesReady() then
        return "cast", "排气臂铠护腕"
    end

    -- 检查玩家是否正在施法
    if Player:IsCasting() then
        return "idle", "玩家在施法读条"
    end

    -- 有两层恶魔尖刺，则用，不浪费
    if Spell("恶魔尖刺"):Charges() == 2 then
        return "cast", "恶魔尖刺"
    end

    if Spell("瓦解"):CooldownUp() then
        if MouseOver:Exists() and MouseOver:ShouldInterrupt() and MouseOver:AffectingCombat() and MouseOver:InRange(5) and MouseOver:CanAttack(Player) then
            return "cast", "瓦解鼠标"
        end
        if Focus:Exists() and Focus:ShouldInterrupt() and Focus:AffectingCombat() and Focus:InRange(5) and Focus:CanAttack(Player) then
            return "cast", "瓦解焦点"
        end
        if Target:Exists() and Target:ShouldInterrupt() and Target:AffectingCombat() and Target:InRange(5) and Target:CanAttack(Player) then
            return "cast", "瓦解目标"
        end
    end

    -- [圣光虔敬魔典]
    if checkTomeOfLightDevotion() then
        return "cast", "圣光虔敬魔典"
    end

    -- 始终将[破裂]作为[收割者战刃]的第一个增强技能施放

    if (Spell("破裂"):Charges() >= 1) and Player:BuffExists("撕裂猛击") then
        if Target:InRange(5) then
            return "cast", "破裂"
        end
        if Plater:NumOfEnemyInRange(5, 1) > 0 then
            return "cast", "就近破裂"
        end
    end

    -- 始终将[灵魂裂劈]作为[收割者战刃]的第二个增强技能施放
    if (Player:Fury() >= 30) and Player:BuffExists("战刃乱舞") then
        if Target:InRange(5) then
            return "cast", "灵魂裂劈"
        end
        if Plater:NumOfEnemyInRange(5, 1) > 0 then
            return "cast", "就近灵魂裂劈"
        end
    end

    -- 不要浪费破裂
    if Spell("破裂"):Charges() >= 2 then
        if Target:InRange(5) then
            return "cast", "破裂"
        end
        if Plater:NumOfEnemyInRange(5, 1) > 0 then
            return "cast", "就近破裂"
        end
    end

    -- 冷却结束时施放[收割者战刃]
    --- 注意酣战热血有2个，一个伤害，一个极速，这里的id是伤害的。
    if Spell("收割者战刃"):IsKnown()
        and Target:InRange(30)
        and (not Player:BuffExists("撕裂猛击"))
        and (not Player:BuffExists("战刃乱舞"))
        and (Player:BuffRemaining(1227062) < 2)
        and (Target:HealthPercentage() > settings.ReaverGlaiveTargetHp or 0) then
        return "cast", "收割者战刃"
    end

    -- [灵魂切削]
    if Spell("灵魂切削"):IsKnown() and Spell("灵魂切削"):CooldownUp() then
        return "cast", "灵魂切削"
    end

    -- 施放[献祭光环]
    if Spell("献祭光环"):CooldownUp() then
        return "cast", "献祭光环"
    end


    -- 施放[烈火烙印]以触发[天赋:炽烈灭亡]的伤害
    if Spell("烈火烙印"):CooldownUp() and Target:InRange(30) then
        if Combat:TimeLessThan(settings.BurstTime) then
            return "cast", "烈火烙印"
        end
    end

    -- 施放[烈焰咒符]
    if (Target:DebuffRemaining("烈焰咒符") == 0) and (Spell("烈焰咒符"):Charges() >= 1) and (Player:FuryDeficit() > 30) and Target:InRange(5) then
        return "cast", "烈焰咒符脚下"
    end

    if (Spell("烈焰咒符"):Charges() >= 2) and Target:InRange(30) then
        return "cast", "烈焰咒符脚下"
    end

    -- 如果携带[怨念咒符]天赋则施放
    if Combat:TimeLessThan(settings.BurstTime) and (not Player:IsMoving()) then
        if Spell("怨念咒符"):CooldownUp() then
            return "cast", "怨念咒符脚下"
        end
    end

    -- 施放[邪能毁灭]
    if Combat:TimeLessThan(settings.BurstTime) and (not Player:IsMoving()) and settings.USE_FEL_DEVASTATION then
        if (Player:Fury() >= 50) and Spell("邪能毁灭"):CooldownUp() then
            return "cast", "邪能毁灭"
        end
    end

    -- 在灵魂碎片达到4-5时优先用于[幽魂炸弹]
    if Spell("幽魂炸弹"):IsKnown() and (soulNum >= 4) and (Player:Fury() >= 50) then
        return "cast", "幽魂炸弹"
    end


    if (Player:Fury() >= 30) then
        if Target:InRange(5) then
            return "cast", "灵魂裂劈"
        end
        if Plater:NumOfEnemyInRange(5, 1) > 0 then
            return "cast", "就近灵魂裂劈"
        end
    end

    if Spell("破裂"):Charges() >= 1 then
        if Target:InRange(5) then
            return "cast", "破裂"
        end
        if Plater:NumOfEnemyInRange(5, 1) > 0 then
            return "cast", "就近破裂"
        end
    end

    -- 如果不会怒气溢出，施放[邪能之刃]
    if (Player:FuryDeficit() > 40) and Spell("邪能之刃"):CooldownUp() then
        if Target:InRange(5) then
            return "cast", "邪能之刃"
        end
        if Plater:NumOfEnemyInRange(5, 1) > 0 then
            return "cast", "就近邪能之刃"
        end
    end

    if settings.THROW_GLAIVE and (not Spell("收割者战刃"):IsKnown()) and (Spell("投掷利刃"):Charges() >= 1) and Target:InRange(30) then
        return "cast", "投掷利刃"
    end

    return "idle", "无事可做"
end
