--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...

local Plater = RL.Plater
local Player = RL.Player

RL.Combat = {}
local Combat = RL.Combat

Combat.EstimatedFrame = nil
Combat.EstimatedText = nil;

Combat.InCombat = false;
Combat.EntryCombatTime = nil;

function Combat:CombatTime()
    if not Player:AffectingCombat() then
        return 0;
    end
    if not Combat.EntryCombatTime then
        return 0;
    end
    return GetTime() - Combat.EntryCombatTime;
end

function Combat:TimeLessThan(time)
    if not Player:AffectingCombat() then
        return false
    end
    return self:CombatTime() < time;
end

function Combat:TimeMoreThan(time)
    if not Player:AffectingCombat() then
        return false
    end
    return self:CombatTime() > time;
end

function Combat:TickUpdate()
    if self.InCombat and (not Player:AffectingCombat()) then
        self.InCombat = false;
        self.EntryCombatTime = nil;
    end

    -- 检查是否从非战斗状态转为战斗状态
    if (not self.InCombat) and Player:AffectingCombat() then
        self.InCombat = true;
        self.EntryCombatTime = GetTime();
    end
end

--- 预估剩余战斗时间
--- @return number 预估的剩余战斗时间（秒），如果不在战斗中则返回0
function Combat:EstimatedTimeToKill()
    -- 如果不在战斗中，返回0
    if not Player:AffectingCombat() then
        return 0
    end

    local combatTime = self:CombatTime()

    -- 如果战斗时间小于等于0，返回0
    if combatTime <= 0 then
        return 0
    end
    local totalDamage = Plater:TotalMaxHealthOfEnemiesInCombat() - Plater:TotalHealthOfEnemiesInCombat()
    local remainingHealth = Plater:TotalHealthOfEnemiesInCombat()

    if totalDamage > 0 and remainingHealth > 0 then
        local estimatedTime = remainingHealth / (totalDamage / combatTime)
        return estimatedTime
    end

    -- 如果无法计算，返回0
    return 0
end

function Combat:InitEstimatedFrame()
    if Combat.EstimatedFrame then
        return
    end
    Combat.EstimatedFrame = CreateFrame("Frame", nil, UIParent)
    Combat.EstimatedFrame:SetSize(64, 24)
    Combat.EstimatedFrame:SetPoint("CENTER", UIParent, "CENTER", UIParent:GetWidth() / 4, 0)
    Combat.EstimatedFrame:EnableMouse(true)
    Combat.EstimatedFrame:SetMovable(true)
    Combat.EstimatedFrame:RegisterForDrag("LeftButton")
    local tex = Combat.EstimatedFrame:CreateTexture()
    tex:SetAllPoints()
    tex:SetColorTexture(0, 0, 0, 1)
    Combat.EstimatedText = Combat.EstimatedFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Combat.EstimatedText:SetSize(64, 24)
    Combat.EstimatedText:SetPoint("LEFT", Combat.EstimatedFrame, "LEFT", 0, 0)
    Combat.EstimatedText:SetFont("Fonts\\ARIALN.TTF", 14, nil)
    Combat.EstimatedText:SetTextColor(1, 1, 1)
    Combat.EstimatedText:SetJustifyH("CENTER")
    Combat.EstimatedText:SetJustifyV("MIDDLE")
    Combat.EstimatedText:SetText("0")
    -- 处理框架拖动开始事件
    Combat.EstimatedFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    -- 处理框架拖动结束事件
    Combat.EstimatedFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
end

function Combat:UpdateEstimatedText()
    if RLib_SavedVar["ShowCombatEstimated"] and (Combat.EstimatedFrame == nil) then
        RL.Combat:InitEstimatedFrame()
    end

    if not Combat.EstimatedFrame then
        return
    end
    local estimatedTime = Combat:EstimatedTimeToKill()
    Combat.EstimatedText:SetText(string.format("%.1f", estimatedTime))
end
