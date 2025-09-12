--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...
local LibRangeCheck = LibStub:GetLibrary("LibRangeCheck-3.0", true)


--- ======= GLOBALIZE =======

local Unit = RL.Class.Unit
local List = RL.List



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

    self:getCastingInfo()


    local minRange, maxRange = LibRangeCheck:GetRange(self._unitID)
    if minRange then
        self._minRange = minRange
    end
    if maxRange then
        self._maxRange = maxRange
    end
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
    if obj.use_cache then
        obj:refreshStatus()
        obj:refreshAura()
    end
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


RL.Unit = NewUnit;
RL.Player = NewUnit("player", true)
RL.Pet = NewUnit("pet", true)
RL.Target = NewUnit("target", true)
RL.Focus = NewUnit("focus", true)
RL.MouseOver = NewUnit("mouseover", true)
