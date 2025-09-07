--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...

local LibRangeCheck = LibStub:GetLibrary("LibRangeCheck-3.0", true)

local Utils = RL.Utils;
local List = RL.List;

--- ============================ CONTENT ============================

local Unit = {}

Unit.__index = Unit


local function getCastingInfo(targetUnit)
    local isCasting = false
    local isChanneling = false
    local notInterruptible = true
    local spellID = nil
    local spellName = nil
    local spellStartTime = nil
    local spellEndTime = nil

    -- 检查单位是否正在施法
    local castName, _, _, castStartTimeMS, castEndTimeMS, _, _, castNotInterruptible, castSpellId = UnitCastingInfo(targetUnit)

    if castName then
        isCasting = true;
        notInterruptible = castNotInterruptible;
        spellID = castSpellId;
        spellName = castName;
        spellStartTime = castStartTimeMS;
        spellEndTime = castEndTimeMS;
    else
        -- 检查单位是否正在引导法术
        local channelName, _, _, channelStartTimeMS, channelEndTimeMS, _, channelNotInterruptible, channelSpellId, _, _ = UnitChannelInfo(targetUnit)
        if channelName then
            isChanneling = true;
            notInterruptible = channelNotInterruptible;
            spellID = channelSpellId;
            spellName = channelName;
            spellStartTime = channelStartTimeMS;
            spellEndTime = channelEndTimeMS;
        end
    end
    return isCasting, isChanneling, notInterruptible, spellID, spellName, spellStartTime, spellEndTime;
end


--- 根据技能列表判断是否可以打断
--- @param spellID number 技能ID
--- @param spellName string 技能名称
--- @param notInterruptible boolean 是否为不可打断技能
--- @return number 打断判断，小于0则不可打断，1则可打断，2则需要打断
local function checkInterruptible(spellID, spellName, notInterruptible)
    if notInterruptible then
        return -1
    end
    if List.interruptBlacklist[spellID] or List.interruptBlacklist[spellName] then
        return -1
    end
    if List.interruptList[spellID] or List.interruptList[spellName] then
        return 2
    end
    return 1
end


--- 判断是否应该打断当前施法
--- @param spellID number 技能ID
--- @param spellName string 技能名称
--- @param notInterruptible boolean 是否为不可打断技能
--- @return boolean 如果应该打断返回true，否则返回false
local function shouldInterrupt(spellID, spellName, notInterruptible)
    return checkInterruptible(spellID, spellName, notInterruptible) == 2
end


--- 判断是否可以打断当前施法
--- @param spellID number 技能ID
--- @param spellName string 技能名称
--- @param notInterruptible boolean 是否为不可打断技能
--- @return boolean 如果可以打断返回true，否则返回false
local function canInterrupt(spellID, spellName, notInterruptible)
    return checkInterruptible(spellID, spellName, notInterruptible) > 0
end


function Unit:init()
    self._unitAlive             = false;
    self._unitGUID              = nil;
    self._unitName              = nil;
    self._canBeAttackedByPlayer = false;
    self._minRange              = 0;
    self._maxRange              = 100;
    self._isCasting             = 0;
    self._isChanneling          = 0;
    self._spellInterruptible    = 0;
    self._canInterrupt          = 0;
    self._shouldInterrupt       = 0;
    self._spellID               = nil;
    self._spellName             = nil;
    self._spellStartTime        = nil;
    self._spellEndTime          = nil;
    self._health                = 0;
    self._healthMax             = 1;
    self._absorbs               = 0;
    self._healAbsorbs           = 0;
    self._role                  = "NONE";
    self._inComingHeal          = 0;
    self._in_combat             = false;
    -- 初始化 Buffs 和 Debuffs 表
    self.Buffs                  = {};
    self.Debuffs                = {};
end

--- 创建一个新的 Unit 对象
--- @param UnitID UnitToken 目标单位标识符
--- @param use_cache boolean 是否使用缓存，默认false
--- @return table 返回一个新的 Unit 对象
function Unit:new(UnitID, use_cache)
    local obj = {}          -- 创建一个新的空表作为对象
    setmetatable(obj, self) -- 设置元表，使对象继承类的方法
    self.__index = self     -- 设置索引元方法
    if type(UnitID) ~= "string" then error("Invalid UnitID.") end
    obj.use_cache = use_cache or false
    obj._unitID = UnitID
    obj._unitExists = false
    obj:init()
    return obj
end

--- 创建一个新的 Unit 对象
--- @param UnitID UnitToken 目标单位标识符
--- @param use_cache boolean|nil 是否使用缓存，默认false
--- @return table 返回一个新的 Unit 对象
local function NewUnit(UnitID, use_cache)
    use_cache = use_cache or false
    return Unit:new(UnitID, use_cache)
end

RL.Class.Unit = Unit;
RL.Unit = NewUnit;
RL.Player = NewUnit("player", true)
RL.Pet = NewUnit("pet", true)
RL.Target = NewUnit("target", true)
RL.Focus = NewUnit("focus", true)
RL.MouseOver = NewUnit("mouseover", true)

--- 获取单位标识符
--- @return string 单位标识符
function Unit:ID()
    return self._unitID
end

--- 获取单位的全局唯一标识符(GUID)
--- @return string GUID字符串
function Unit:GUID()
    return UnitGUID(self._unitID) or ""
end

--- 检查单位是否存在且可见
--- @return boolean 单位存在且可见返回true，否则返回false
function Unit:Exists()
    if self.use_cache then
        return self._unitExists
    end
    return UnitExists(self._unitID) and UnitIsVisible(self._unitID)
end

--- 获取单位的NPC ID
--- @return number NPCID，如果无法获取则返回-1或-2
function Unit:NPCID()
    local GUID = self:GUID()
    if not GUID then return -1 end

    local Type, _, _, _, _, NPCIDFromGUID = strsplit('-', GUID)
    local NPCID
    if Type == "Creature" or Type == "Pet" or Type == "Vehicle" then
        NPCID = tonumber(NPCIDFromGUID) or -2
    else
        NPCID = -2
    end

    return NPCID
end

--- 获取单位等级
--- @return number 单位等级
function Unit:Level()
    return UnitLevel(self._unitID)
end

--- 获取单位职业
--- @return string 单位职业名称
function Unit:Class()
    local className, classFilename, classId = UnitClass(self._unitID)
    return classFilename
end

--- 检查是否可以攻击目标单位
--- @param Other table 另一个Unit对象
--- @return boolean 可以攻击返回true，否则返回false
function Unit:CanAttack(Other)
    local UnitID = self:ID()
    return UnitCanAttack(UnitID, Other:ID())
end

--- 检查单位是否可以被玩家攻击
--- @return boolean 可以被玩家攻击返回true，否则返回false
function Unit:CanBeAttackedByPlayer()
    if self.use_cache then
        return self._canBeAttackedByPlayer
    end
    return UnitCanAttack("player", self:ID())
end

--- 检查单位是否可以攻击玩家
--- @return boolean 可以攻击玩家返回true，否则返回false
function Unit:CanAttackPlayer()
    return self:CanBeAttackedByPlayer()
end

--- 检查单位是否为玩家
--- @return boolean 是玩家返回true，否则返回false
function Unit:IsAPlayer()
    return UnitIsPlayer(self._unitID)
end

--- 获取单位当前生命值
--- @return number 当前生命值，如果无法获取则返回-1
function Unit:Health()
    if self.use_cache then
        return self._health
    end
    return UnitHealth(self._unitID) or 0
end

--- 获取单位最大生命值
--- @return number 最大生命值，如果无法获取则返回-1
function Unit:MaxHealth()
    if self.use_cache then
        return self._healthMax
    end
    return UnitHealthMax(self._unitID) or 1
end

--- 获取单位生命值百分比
--- @return number 生命值百分比(0-100)
function Unit:HealthPercentage()
    if self:MaxHealth() == 0 then
        return 0
    end
    return self:Health() / self:MaxHealth() * 100
end

--- 获取单位当前护盾值
--- @return number 护盾值，如果无法获取则返回0
function Unit:Absorbs()
    if self.use_cache then
        return self._absorbs
    end
    return UnitGetTotalAbsorbs(self._unitID) or 0;
end

--- 获取单位当前治疗吸收值
--- @return number 治疗吸收值，如果无法获取则返回0
function Unit:HealAbsorbs()
    if self.use_cache then
        return self._healAbsorbs
    end
    return UnitGetTotalHealAbsorbs(self._unitID) or 0;
end

--- 获取单位需要的治疗量缺口（满血所需治疗量）
--- @return number 需要的治疗量，如果无法获取则返回0
function Unit:HealDeficit()
    return self:MaxHealth() - self:Health() + self:HealAbsorbs()
end

--- 获取单位需要的治疗量百分比（满血所需治疗量百分比）
--- @return number 需要的治疗量百分比(0-100)
function Unit:HealDeficitPercentage()
    if self:MaxHealth() == 0 then
        return 0
    end
    return self:HealDeficit() / self:MaxHealth() * 100
end

--- 获取单位当前受到的治疗量
--- @return number
function Unit:InComingHeal()
    if self.use_cache then
        return self._inComingHeal
    end
    return UnitGetIncomingHeals(self._unitID, "player") or 0;
end

--- 相对生命值百分比
--- 获取单位当前生命值百分比，考虑了治疗吸收和受到的治疗。
--- @return number 生命值百分比(0-100)
function Unit:RelativeHealthPercentage()
    if self:MaxHealth() == 0 then
        return 0
    end
    return (self:Health() - self:HealAbsorbs() + self:InComingHeal()) / self:MaxHealth()
end

--- 检查单位是否死亡或处于灵魂状态
--- @return boolean 死亡或灵魂状态返回true，否则返回false
function Unit:IsDeadOrGhost()
    if self.use_cache then
        return not self._unitAlive
    end
    return UnitIsDeadOrGhost(self._unitID)
end

--- 检查单位是否存活
--- @return boolean 死亡或灵魂状态返回false，否则返回true
function Unit:IsAlive()
    if self.use_cache then
        return self._unitAlive
    end
    return not self:IsDeadOrGhost()
end

--- 检查单位是否处于战斗状态
--- @return boolean 处于战斗状态返回true，否则返回false
function Unit:AffectingCombat()
    if self.use_cache then
        return self._in_combat
    end
    return UnitAffectingCombat(self._unitID)
end

--- 检查两个单位是否相同
--- @param Other table 另一个Unit对象
--- @return boolean 相同单位返回true，否则返回false
function Unit:IsUnit(Other)
    return UnitIsUnit(self._unitID, Other._unitID)
end

--- 获取单位分类（普通、精英、Boss等）
--- @return string 单位分类，无法获取则返回空字符串
function Unit:Classification()
    return UnitClassification(self._unitID) or ""
end

--- 获取单位职责
--- @return string 单位分类，无法获取则返回"NONE"
function Unit:Role()
    if self.use_cache then
        return self._role
    end
    return UnitGroupRolesAssigned(self._unitID) or "NONE"
end

--- 检查单位是否正在移动
--- @return boolean 正在移动返回true，否则返回false
function Unit:IsMoving()
    return GetUnitSpeed(self._unitID) ~= 0
end

--- 检查单位是否正在当前目标
--- 0  (unitID 对 mobUnit 的威胁值低于100%)
--- 1  (unitID 对 mobUnit 的威胁值高于100%，但不是 mobUnit 的主要目标)
--- 2  (unitID 是 mobUnit 的主要目标，但另一个单位有更高的威胁值)
--- 3  (unitID 是 mobUnit 的主要目标，且没有其他单位有更高的威胁值)
--- @param Other table 目标单位对象
--- @param ThreatThreshold number 威胁等级阈值，默认为2，数值越高要求越严格
--- @return boolean 威胁等级达到阈值返回true，否则返回false
function Unit:IsTanking(Other, ThreatThreshold)
    local ThreatSituation = UnitThreatSituation(self:ID(), Other:ID())

    return (ThreatSituation and ThreatSituation >= (ThreatThreshold or 2)) or false
end

--- 检查单位是否正在施法
--- @return boolean 正在施法返回true，否则返回false
function Unit:IsCasting()
    if self.use_cache then
        return Utils.IntToBool(self._isCasting or self._isChanneling)
    end
    local isCasting, isChanneling, notInterruptible, spellID, spellName, spellStartTime, spellEndTime = getCastingInfo(self:ID())
    return isCasting or isChanneling
end

--- 检查单位是否可以打断当前施法
--- @return boolean 如果正在施法且可以被打断返回true，否则返回false
function Unit:CanInterrupt()
    if self.use_cache then
        return Utils.IntToBool(self._canInterrupt)
    end
    local isCasting, isChanneling, notInterruptible, spellID, spellName, spellStartTime, spellEndTime = getCastingInfo(self._unitID)
    if (isCasting or isChanneling) and spellID and spellName then
        return canInterrupt(spellID, spellName, notInterruptible)
    end
    return false
end

--- 检查单位是否应该打断当前施法
--- @return boolean 如果正在施法且应该被打断返回true，否则返回false
function Unit:ShouldInterrupt()
    if self.use_cache then
        return Utils.IntToBool(self._shouldInterrupt)
    end
    local isCasting, isChanneling, notInterruptible, spellID, spellName, spellStartTime, spellEndTime = getCastingInfo(self._unitID)
    if (isCasting or isChanneling) and spellID and spellName then
        return shouldInterrupt(spellID, spellName, notInterruptible)
    end
    return false
end

--- 获取当前目标可攻击的最大距离
--- @return number 最大距离
function Unit:MaxRange()
    if self.use_cache then
        return self._maxRange
    end
    local _, maxRange = LibRangeCheck:GetRange(self:ID())
    return maxRange or 100
end

--- 获取当前目标可攻击的最小距离
--- @return number 最小距离
function Unit:MinRange()
    if self.use_cache then
        return self._minRange
    end
    local minRange, _ = LibRangeCheck:GetRange(self:ID())
    return minRange or 100
end

--- 单位在指定距离内
--- @param range number 距离
--- @return boolean
function Unit:InRange(range)
    return self:MaxRange() <= range
end

--- 检查当前目标是否在近战范围内
--- @return boolean 如果当前目标在近战范围内且可攻击则返回true，否则返回nil
function Unit:InMeleeRange()
    if self.use_cache then
        return self._maxRange <= 5
    end
    if self:MaxRange() <= 5 then
        return true
    end
    return false
end

--- 获取单位名称
--- @return string 单位名称
function Unit:Name()
    if self.use_cache then
        return self._unitName
    end
    local name, realm = UnitName(self:ID())
    return name
end

--- 获取单位是否在载具中
--- @return boolean 单位是否在载具中
function Unit:InVehicle()
    return UnitInVehicle(self:ID())
end

--- 获取单位当前法力值
--- @return number 当前法力值
function Unit:Mana()
    return UnitPower(self:ID(), Enum.PowerType.Mana)
end

--- 获取单位最大法力值
--- @return number 最大法力值
function Unit:ManaMax()
    return UnitPowerMax(self:ID(), Enum.PowerType.Mana)
end

--- 获取单位法力值百分比
--- @return number 法力值百分比(0-100)
function Unit:ManaPercent()
    if self:ManaMax() == 0 then
        return 0
    end
    return self:Mana() / self:ManaMax() * 100;
end

--- 获取单位当前神圣能量值
--- @return number 当前神圣能量值
function Unit:HolyPower()
    return UnitPower(self:ID(), Enum.PowerType.HolyPower)
end

--- 刷新单位状态信息
--- 更新单位的所有缓存信息，包括生命值、施法状态、距离等
function Unit:refreshStatus()
    self._unitExists = UnitExists(self._unitID) and UnitIsVisible(self._unitID);
    if not self._unitExists then
        self:init()
        return
    end
    self._unitAlive = not UnitIsDeadOrGhost(self._unitID);
    local name, _ = UnitName(self:ID())
    self._unitName = name or "";

    if self._unitAlive then
        self._health      = UnitHealth(self._unitID) or 0;
        self._healthMax   = UnitHealthMax(self._unitID) or 1;
        self._absorbs     = UnitGetTotalAbsorbs(self._unitID) or 0;
        self._healAbsorbs = UnitGetTotalHealAbsorbs(self._unitID) or 0;
    end

    self._role = UnitGroupRolesAssigned(self._unitID) or "NONE";
    self._inComingHeal = UnitGetIncomingHeals(self._unitID, "player") or 0;

    self._canBeAttackedByPlayer = UnitCanAttack(self._unitID, "player")
    self._in_combat = UnitAffectingCombat(self._unitID)

    local isCasting, isChanneling, notInterruptible, spellID, spellName, spellStartTime, spellEndTime = getCastingInfo(self._unitID)

    self._isCasting = Utils.BoolToInt(isCasting)
    self._isChanneling = Utils.BoolToInt(isChanneling)
    self._spellInterruptible = Utils.BoolToInt(not notInterruptible)
    self._spellID = spellID;
    self._spellName = spellName;
    self._spellStartTime = spellStartTime;
    self._spellEndTime = spellEndTime;


    if not notInterruptible then
        self._canInterrupt = Utils.BoolToInt(canInterrupt(self._spellID, self._spellName, notInterruptible))
        self._shouldInterrupt = Utils.BoolToInt(shouldInterrupt(self._spellID, self._spellName, notInterruptible))
    else
        self._canInterrupt = 0
        self._shouldInterrupt = 0
    end

    local minRange, maxRange = LibRangeCheck:GetRange(self._unitID)
    if minRange then
        self._minRange = minRange
    end
    if maxRange then
        self._maxRange = maxRange
    end
end
