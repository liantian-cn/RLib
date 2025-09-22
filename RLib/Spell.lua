--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...
-- 获取施法队列窗口时间设置
-- local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"));

-- 获取距离检查库
-- local LibRangeCheck = LibStub:GetLibrary("LibRangeCheck-3.0", true)

-- 引入工具类和列表类
-- local Utils = RL.Utils;
-- local List = RL.List;


-- 全局冷却剩余时间
local gcd_remaining = 0
local gcd_id = 61304;

--- 更新全局冷却剩余时间
function RL.updateGcdRemaining()
    local spellCooldownInfo = C_Spell.GetSpellCooldown(gcd_id)
    if spellCooldownInfo.duration == 0 then
        gcd_remaining = 0;
    else
        gcd_remaining = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime();
    end
end

-- Spell类定义
local Spell = {}

Spell.__index = Spell

--- 创建一个新的 Spell 对象
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @return table 返回一个新的Spell对象
function Spell:new(spellIdentifier)
    local obj = {}          -- 创建一个新的空表作为对象
    setmetatable(obj, self) -- 设置元表，使对象继承类的方法
    self.__index = self     -- 设置索引元方法
    self.spellIdentifier = spellIdentifier;
    return obj
end

--- 创建一个新的 Spell 对象的便捷函数
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @return table 返回一个新的Spell对象
local function NewSpell(spellIdentifier)
    return Spell:new(spellIdentifier)
end
RL.Spell = NewSpell;

--- 判断当前技能是否被覆盖
--- 判断逻辑:
--- 如果spellIdentifier是数字：先使用C_Spell.GetSpellName()获取法术的名称，再使用C_Spell.GetSpellIDForSpellIdentifier()获得ID，如果ID和spellIdentifier一致，则返回true；否则返回false。
--- 如果spellIdentifier是字符串：使用C_Spell.GetSpellName()获取法术名称，与spellIdentifier比较，一致则返回true，否则返回false。
--- @return boolean 技能是否被覆盖
function Spell:IsOriginal()
    if type(self.spellIdentifier) == "number" then
        local spellName = C_Spell.GetSpellName(self.spellIdentifier);
        if not spellName then
            return false;
        end
        local spellID = C_Spell.GetSpellIDForSpellIdentifier(spellName);
        if not spellID then
            return false;
        end
        return spellID == self.spellIdentifier;
    elseif type(self.spellIdentifier) == "string" then
        local spellName = C_Spell.GetSpellName(self.spellIdentifier);
        if not spellName then
            return false;
        end
        return self.spellIdentifier == spellName;
    end
    return false
end

--- 判断技能是否为原始技能（未被覆盖）
--- @return boolean 技能是否为原始技能
function Spell:IsOverride()
    return not self:IsOriginal()
end

--- 技能冷却时间
--- @param do_not_use_gcd boolean 是否不使用全局冷却时间
--- @return number 技能冷却时间，单位是秒
function Spell:Cooldown(do_not_use_gcd)
    if do_not_use_gcd == nil then
        do_not_use_gcd = false;
    end
    local spellCooldownInfo = C_Spell.GetSpellCooldown(self.spellIdentifier);
    local latencyToleranceWindowS = RLib_SavedVar.latencyToleranceWindow / 1000;
    if not spellCooldownInfo then
        return 65535; -- 技能不存在时，返回一个大值。
    end

    if spellCooldownInfo.duration == 0 then
        return 0;
    end

    local remaining = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime();
    if do_not_use_gcd then
        local cd = remaining - latencyToleranceWindowS;
        return math.max(cd, 0);
    else
        local cd = remaining - gcd_remaining;
        return math.max(cd, 0);
    end
end

--- 检查技能是否处于冷却状态
--- @param do_not_use_gcd boolean 是否不使用全局冷却时间
--- @return boolean 技能是否可用（冷却完毕）
function Spell:CooldownUp(do_not_use_gcd)
    if do_not_use_gcd == nil then
        do_not_use_gcd = false;
    end
    return self:Cooldown(do_not_use_gcd) <= 0
end

--- 获取技能当前可用充能数
--- @return number 当前可用充能数
function Spell:Charges()
    local chargeInfo = C_Spell.GetSpellCharges(self.spellIdentifier)
    if not chargeInfo then
        return 0
    end

    if chargeInfo.currentCharges == chargeInfo.maxCharges then
        return chargeInfo.currentCharges
    else
        local latencyToleranceWindowS = RLib_SavedVar.latencyToleranceWindow / 1000;

        local cooldown = chargeInfo.cooldownStartTime + chargeInfo.cooldownDuration - GetTime()
        if (cooldown > latencyToleranceWindowS) then
            return chargeInfo.currentCharges
        else
            return chargeInfo.currentCharges + 1
        end
    end
end

--- 检查技能是否可用（未被覆盖、有足够的资源施放）
--- @return boolean 技能是否可用
function Spell:Usable()
    if self:IsOverride() then
        return false
    end
    local isUsable, insufficientPower = C_Spell.IsSpellUsable(self.spellIdentifier)
    return isUsable and not insufficientPower
end

--- 检查角色是否已学会该技能
--- @return boolean 技能是否已学会
function Spell:IsKnown()
    if type(self.spellIdentifier) == "number" then
        return C_SpellBook.IsSpellInSpellBook(self.spellIdentifier, 0, false)
    end

    if type(self.spellIdentifier) == "string" then
        local spellInfo = C_Spell.GetSpellInfo(self.spellIdentifier)
        if spellInfo then
            return spellInfo.name == self.spellIdentifier
        end
    end
    return false
end

--- 检查目标是否在技能施法距离内
--- @param targetUnit table 目标单位对象
--- @return boolean 目标是否在技能范围内
function Spell:InRange(targetUnit)
    if not UnitExists(targetUnit:ID()) then
        return false
    end
    return C_Spell.IsSpellInRange(self.spellIdentifier, targetUnit:ID()) or false
end
