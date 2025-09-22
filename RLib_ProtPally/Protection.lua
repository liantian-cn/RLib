--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...
local RL = RLib
local Player = RL.Player;
local Target = RL.Target;
local MouseOver = RL.MouseOver;
local Focus = RL.Focus;
local Action = RL.Action
local Spell = RL.Spell
local Party = RL.Party
local Plater = RL.Plater
local Combat = RL.Combat
local Utils = RL.Utils


local BLESS_DEBUFF = {} -- 牺牲祝福的debuff
BLESS_DEBUFF["动能胶质炸药"] = true; -- 动能胶质炸药
BLESS_DEBUFF["超力震击"] = true;
BLESS_DEBUFF["穿刺"] = true; -- 修道院 > 阿拉希骑士 >  穿刺
BLESS_DEBUFF["冥河之种"] = true; -- 破晨号 > 夜幕祭师
BLESS_DEBUFF["深渊轰击"] = true; -- 破晨号 > 坚不可摧的伊克斯雷腾

function Rotation.Main()
    local settings = RLib_ProtPally_SavedVar

    local temp_unit = nil;

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

    -- 检查是否拥有圣言祭礼buff
    if not Player:BuffExists("圣言祭礼") then
        return "cast", "圣言祭礼"
    end

    -- 检查玩家是否在战斗中
    if not Player:AffectingCombat() then
        return "idle", "玩家不在战斗"
    end

    -- 自动使用圣盾术的逻辑：当玩家血量低于设定阈值且没有金色瓦格里的礼物buff时使用
    local DS_HEALTH = settings.DS_HEALTH;
    if (Player:HealthPercentage() < DS_HEALTH) then
        if not Player:BuffExists("金色瓦格里的礼物") then
            if Spell("圣盾术"):CooldownUp() then
                return "cast", "圣盾术"
            end
        end
    end

    -- 保持正义盾击buff：当正义盾击剩余时间少于3秒且拥有3点或以上神圣能量时施放
    if (Player:BuffRemaining("正义盾击") < 3) and (Player:HolyPower() >= 3) then
        return "cast", "正义盾击"
    end

    -- 保持奉献：当奉献图腾不存在或奉献buff消失时施放（需玩家未移动）
    if (GetTotemTimeLeft(1) < 1) or (not Player:BuffExists("奉献")) then
        if Spell("奉献"):CooldownUp() and (not Player:IsMoving()) then
            return "cast", "奉献"
        end
    end

    -- 荣耀圣令治疗逻辑：根据不同的血量阈值和闪耀之光层数施放
    -- 有两个buff都叫闪耀之光，这里用ID 327510
    local WOD_HEALTH_1 = settings.WOD_HEALTH_1;
    local WOD_HEALTH_2 = settings.WOD_HEALTH_2;
    if (Player:HealthPercentage() <= WOD_HEALTH_1) and (Player:BuffStacks(327510) >= 1) and (Player:Mana() > 250000) then
        return "cast", "荣耀圣令"
    end

    if (Player:HealthPercentage() <= WOD_HEALTH_2) and (Player:BuffStacks(327510) >= 2) and (Player:Mana() > 250000) then
        return "cast", "荣耀圣令"
    end

    -- 复仇者之盾打断逻辑：优先打断鼠标悬停、焦点和当前目标的可打断法术
    -- print("MouseOver:CanInterrupt()" .. tostring(MouseOver:CanInterrupt()))
    -- print("Focus:CanInterrupt()" .. tostring(Focus:CanInterrupt()))
    -- print("Target:CanInterrupt()" .. tostring(Target:CanInterrupt()))
    if Spell("复仇者之盾"):CooldownUp() then
        if MouseOver:Exists() and MouseOver:CanInterrupt() and MouseOver:AffectingCombat() and MouseOver:InRange(30) and MouseOver:CanAttack(Player) then
            return "cast", "复仇者之盾mouseover";
        end
        if Focus:Exists() and Focus:CanInterrupt() and Focus:AffectingCombat() and Focus:InRange(30) and Focus:CanAttack(Player) then
            return "cast", "复仇者之盾focus";
        end
        if Target:Exists() and Target:CanInterrupt() and Target:AffectingCombat() and Target:InRange(30) and Target:CanAttack(Player) then
            return "cast", "复仇者之盾target";
        end
    end


    -- 责难打断逻辑：优先打断鼠标悬停、焦点和当前目标的应打断法术
    if Spell("责难"):CooldownUp() then
        if MouseOver:Exists() and MouseOver:ShouldInterrupt() and MouseOver:AffectingCombat() and MouseOver:InRange(5) and MouseOver:CanAttack(Player) then
            return "cast", "责难mouseover";
        end
        if Focus:Exists() and Focus:ShouldInterrupt() and Focus:AffectingCombat() and Focus:InRange(5) and Focus:CanAttack(Player) then
            return "cast", "责难focus";
        end
        if Target:Exists() and Target:ShouldInterrupt() and Target:AffectingCombat() and Target:InRange(5) and Target:CanAttack(Player) then
            return "cast", "责难target";
        end
    end

    -- 自动驱散：根据设置自动驱散队友的疾病和毒素
    local AUTO_DISPEL = settings.AUTO_DISPEL;
    local AUTO_DISPEL_COUNT = settings.AUTO_DISPEL_COUNT;
    if AUTO_DISPEL and Spell("清毒术"):CooldownUp() then
        temp_unit = Party:FindMemberWithMostDebuffsByType("Disease|Poison", AUTO_DISPEL_COUNT)
        if temp_unit then
            -- Utils.Print("驱散疾病和毒素: " .. temp_unit:Name())
            return "cast", temp_unit:ID() .. "清毒术"
        end
    end
    temp_unit = nil

    -- 自动牺牲祝福：根据设置自动给受到特定debuff的队友施放牺牲祝福
    local AUTO_BLESS = settings.AUTO_BLESS;
    local AUTO_BLESS_HP = settings.AUTO_BLESS_HP;
    if AUTO_BLESS and Spell("牺牲祝福"):IsKnown() and Spell("牺牲祝福"):CooldownUp() then
        temp_unit = Party:FindMemberWithMostDebuffsByTable(BLESS_DEBUFF)
        if temp_unit and (not temp_unit:IsUnit(Player)) and (temp_unit:RelativeHealthPercentage() <= AUTO_BLESS_HP) then
            return "cast", temp_unit:ID() .. "牺牲祝福"
        end
    end
    temp_unit = nil

    -- 自动圣洁鸣钟：根据设置在有足够敌人可打断时施放
    local AUTO_DIVINE = settings.AUTO_DIVINE;
    local AUTO_DIVINE_COUNT = settings.AUTO_DIVINE_COUNT;
    -- print("Plater:NumOfInterruptableInRange(20)" .. tostring(Plater:NumOfInterruptableInRange(20)))
    if AUTO_DIVINE and Spell("圣洁鸣钟"):IsKnown() and Spell("圣洁鸣钟"):CooldownUp() then
        if Plater:NumOfInterruptableInRange(20) >= AUTO_DIVINE_COUNT then
            return "cast", "圣洁鸣钟"
        end
    end

    -- 圣光壁垒：在复仇之怒即将冷却完成时施放圣光壁垒
    if Spell("圣光壁垒"):IsKnown() and Spell("圣光壁垒"):CooldownUp() then
        if (not Player:BuffExists("复仇之怒")) and (not Spell("复仇之怒"):CooldownUp()) then
            return "cast", "圣光壁垒"
        end
    end

    -- 愤怒之锤：当可用且在射程内时施放
    if Spell("愤怒之锤"):Usable() and Spell("愤怒之锤"):CooldownUp() and Target:InRange(30) then
        return "cast", "愤怒之锤"
    end

    -- 审判：当拥有2层或以上充能时优先施放
    if (Spell("审判"):Charges() >= 2) and Spell("审判"):CooldownUp() then
        if Target:Exists() and Target:InRange(30) then
            return "cast", "审判target"
        end
        if Focus:Exists() and Focus:InRange(30) then
            return "cast", "审判focus"
        end
    end

    -- 祝福之锤：当拥有3层或以上充能时施放
    if (Spell("祝福之锤"):Charges() >= 3) and Spell("祝福之锤"):CooldownUp() then
        return "cast", "祝福之锤";
    end

    -- 复仇者之盾：在没有信仰壁垒buff时施放
    if Spell("复仇者之盾"):CooldownUp() and (Player:BuffRemaining("信仰壁垒") < 1) then
        if Target:Exists() and Target:InRange(30) then
            return "cast", "复仇者之盾target"
        end
        if Focus:Exists() and Focus:InRange(30) then
            return "cast", "复仇者之盾focus"
        end
    end

    -- 四件套套装效果：当拥有5层大师杰作buff且预计战斗时间超过25秒时使用大技能
    local USE_SET4 = settings.USE_SET4;
    if USE_SET4 and (Player:BuffStacks("大师杰作") == 5) and (Combat:EstimatedTimeToKill() > 25) then
        if Spell("复仇之怒"):CooldownUp() then
            return "cast", "复仇之怒"
        end

        if (Spell("圣洁武器"):Charges() >= 1) or (Spell("神圣壁垒"):Charges() >= 1) then
            return "cast", "神圣壁垒"
        end
    end

    -- 审判：当拥有1层或以上充能时施放
    if (Spell("审判"):Charges() >= 1) and Spell("审判"):CooldownUp() then
        if Target:Exists() and Target:InRange(30) then
            return "cast", "审判target"
        end
        if Focus:Exists() and Focus:InRange(30) then
            return "cast", "审判focus"
        end
    end

    -- 祝福之锤：当拥有1层或以上充能时施放
    if (Spell("祝福之锤"):Charges() >= 1) and Spell("祝福之锤"):CooldownUp() then
        return "cast", "祝福之锤";
    end

    -- 正义盾击：当神圣能量达到4点时施放
    if Player:HolyPower() >= 4 then
        return "cast", "正义盾击";
    end

    return "idle", "无事可做"
end
