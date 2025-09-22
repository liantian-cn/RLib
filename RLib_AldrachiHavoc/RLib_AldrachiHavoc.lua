--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...
local RL = RLib
local Player = RL.Player;
local Target = RL.Target;
local MouseOver = RL.MouseOver;
local Focus = RL.Focus;
local Spell = RL.Spell
local Party = RL.Party
local Plater = RL.Plater
local Combat = RL.Combat
local Utils = RL.Utils



RL.Rotations[addonName] = Rotation




function Rotation:Check()
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()
    if (classFilename == "DEMONHUNTER") and (currentSpec == 1) then
        return true, 1
    end
    return false, 1
end

function Rotation:Init()
    Utils.Print(addonName .. " Inited")
end

Rotation.Macros = {}
local macro = Rotation.Macros;


macro[1] = { ["title"] = "刃舞", ["macrotext"] = "/cast 刃舞" }
macro[2] = { ["title"] = "怨念咒符脚下", ["macrotext"] = "/cast [@player] 怨念咒符" }
macro[3] = { ["title"] = "恶魔变身原地", ["macrotext"] = "/cast [@player] 恶魔变形" }
macro[4] = { ["title"] = "投掷利刃", ["macrotext"] = "/cast 投掷利刃" }
macro[5] = { ["title"] = "排气臂铠护腕", ["macrotext"] = "/use 9" }
macro[6] = { ["title"] = "收割者战刃", ["macrotext"] = "/cast 收割者战刃" }
macro[7] = { ["title"] = "眼棱", ["macrotext"] = "/cast 眼棱" }
macro[8] = { ["title"] = "死亡横扫", ["macrotext"] = "/cast 刃舞" }
macro[9] = { ["title"] = "毁灭", ["macrotext"] = "/cast 混乱打击" }
macro[10] = { ["title"] = "混乱打击", ["macrotext"] = "/cast 混乱打击" }
macro[11] = { ["title"] = "烈焰咒符脚下", ["macrotext"] = "/use [@player] 烈焰咒符" }
macro[12] = { ["title"] = "献祭光环", ["macrotext"] = "/cast 献祭光环" }
macro[13] = { ["title"] = "瓦解焦点", ["macrotext"] = "/cast [@focus] 瓦解" }
macro[14] = { ["title"] = "瓦解目标", ["macrotext"] = "/cast 瓦解" }
macro[15] = { ["title"] = "邪能之刃", ["macrotext"] = "/cast 邪能之刃" }
macro[16] = { ["title"] = "精华破碎", ["macrotext"] = "/cast 精华破碎" }
macro[17] = { ["title"] = "恶魔追击", ["macrotext"] = "/cast 恶魔追击" }
macro[18] = { ["title"] = "13号饰品", ["macrotext"] = "/use 13" }
macro[19] = { ["title"] = "14号饰品", ["macrotext"] = "/use 14" }


function Rotation.Main()
    local settings = RLib_AldrachiHavoc_SavedVar

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

    -- if Plater:NumOfEnemyInRange(20, 1) == 0 then
    --     return "idle", "20码内没有敌人"
    -- end

    -- 检查玩家是否正在施法
    if Player:IsCasting() then
        return "idle", "玩家在施法读条"
    end

    if Spell("瓦解"):CooldownUp() then
        if Focus:Exists() and Focus:CanInterrupt() and Focus:AffectingCombat() and Focus:InRange(5) and Focus:CanAttack(Player) then
            return "cast", "瓦解焦点"
        end
        if Target:Exists() and Target:CanInterrupt() and Target:AffectingCombat() and Target:InRange(5) and Target:CanAttack(Player) then
            return "cast", "瓦解目标"
        end
    end

    -- 精华破碎
    -- 在变身中，精华破碎可以用，则优先用。
    -- 在目标有精华破碎的buff时，优先打刃舞和混乱打击
    if Player:BuffExists("恶魔变形") and Spell("精华破碎"):CooldownUp() and Target:InRange(5) then
        return "cast", "精华破碎"
    end

    if Target:DebuffExists("精华破碎") then
        if (not Player:BuffExists("撕裂猛击")) and Spell("刃舞"):CooldownUp() and Target:InRange(5) then
            return "cast", "刃舞"
        end
        if (Player:Fury() >= 40) and Target:InRange(5) then
            return "cast", "混乱打击"
        end
    end


    --- 奥达奇战刃
    if Spell("收割者战刃"):IsKnown()
        and Target:InRange(30)
        and (not Player:BuffExists("撕裂猛击"))
        and (not Player:BuffExists("战刃乱舞"))
        and (Player:BuffRemaining(442688) < 2)
        and (Target:HealthPercentage() > settings.HavocReaverGlaiveHP) then
        return "cast", "收割者战刃"
    end

    --- 收割者战刃之后及时打混乱打击
    if Player:BuffExists("撕裂猛击") and (Player:Fury() >= 40) and Target:InRange(5) then
        return "cast", "混乱打击"
    end

    --- 眼棱
    --- 眼棱一定要打一个刃舞出去。所以： 刃舞的CD小于4秒，眼棱CD好用眼棱。
    --- /dump RLib.Spell("眼棱"):Cooldown()
    if Spell("眼棱"):CooldownUp() and (Spell("刃舞"):Cooldown() <= 4) and Target:InRange(5) then
        return "cast", "眼棱"
    end


    --- 变身过程中，优先打毁灭和死亡横扫
    ---  [死亡横扫] = [恶魔变身]后的[刃舞]
    ---  [毁灭] = [恶魔变身]后的[混乱打击]

    if Spell("死亡横扫"):IsKnown() and (not Player:BuffExists("撕裂猛击")) and Spell("死亡横扫"):CooldownUp() and Target:InRange(5) then
        return "cast", "死亡横扫"
    end

    if Spell("毁灭"):IsKnown() and (Player:Fury() >= 40) and Target:InRange(5) then
        return "cast", "毁灭"
    end


    -- 有撕裂猛击不要打
    -- 眼棱CD小于4秒不要打。
    if Spell("刃舞"):CooldownUp() and (not Player:BuffExists("撕裂猛击")) and (Spell("眼棱"):Cooldown() > 3) and Target:InRange(5) then
        return "cast", "刃舞"
    end


    -- 施放[献祭光环]
    if (Spell("献祭光环"):Charges() >= 1) and Target:InRange(15) then
        return "cast", "献祭光环"
    end


    if (Player:FuryDeficit() > 40) and Spell("烈焰咒符"):CooldownUp() and Target:InRange(5) and (not Player:IsMoving()) then
        return "cast", "烈焰咒符脚下"
    end

    if Spell("怨念咒符"):CooldownUp() and Target:InRange(5) and (not Player:IsMoving()) then
        return "cast", "怨念咒符脚下"
    end

    -- 如果不会怒气溢出，施放[邪能之刃]
    if (Player:FuryDeficit() > 40) and Spell("邪能之刃"):CooldownUp() then
        if Target:InRange(5) then
            return "cast", "邪能之刃"
        end
    end

    if (Player:Fury() >= 45) and Target:InRange(5) then
        return "cast", "混乱打击"
    end

    return "idle", "无事可做"
end
