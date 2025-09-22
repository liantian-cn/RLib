--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...

local Unit = RL.Unit;

RL.Plater = {}
local Plater = RL.Plater
--- ============================ CONTENT ==========================


--- 获取范围内可打断的敌对目标数量
--- @param mobRange number 检查范围，默认10码
--- @return number 返回范围内可打断的敌对目标数量
function Plater:NumOfInterruptableInRange(mobRange)
    mobRange = mobRange or 10
    local inRange = 0
    for i = 1, #Unit.Nameplate do
        local unit = Unit.Nameplate[i]
        -- 检查是否在范围内且正在施法/引导且可打断
        if (unit:MaxRange() <= mobRange) and unit:IsCasting() and unit:CanInterrupt() then
            inRange = inRange + 1
        end
    end

    return inRange
end

--- /dump RLib.Plater:NumOfEnemyInRange(10, 0)
--- 返回在指定范围内且生命值高于指定值的敌对目标数量
--- @param mobRange number 检查范围，默认10码
--- @param mobHealth number 目标最低生命值要求，默认0
--- @return number 返回在指定范围内且生命值高于指定值的敌对目标数量
function Plater:NumOfEnemyInRange(mobRange, mobHealth)
    mobRange = mobRange or 10
    mobHealth = mobHealth or 0
    local inRange = 0

    for i = 1, #Unit.Nameplate do
        local unit = Unit.Nameplate[i]
        -- 检查是否在范围内且生命值高于要求
        if (unit:MaxRange() <= mobRange) and (unit:Health() > mobHealth) then
            inRange = inRange + 1
        end
    end

    return inRange
end

--- 存在在指定范围内且生命值高于指定值的敌对目标
--- @param mobRange number 检查范围，默认10码
--- @param mobHealth number 目标最低生命值要求，默认0
--- @return boolean 存在在指定范围内且生命值高于指定值的敌对目标返回true，否则返回false
function Plater:AnyEnemyInRange(mobRange, mobHealth)
    mobRange = mobRange or 5
    mobHealth = mobHealth or 0
    for i = 1, #Unit.Nameplate do
        local unit = Unit.Nameplate[i]
        -- 检查是否在范围内且生命值高于要求
        if (unit:MaxRange() <= mobRange) and (unit:Health() > mobHealth) then
            return true
        end
    end

    return false
end

--- 近战范围有敌人
--- @param mobHealth number 目标最低生命值要求，默认0
--- @return boolean 近战范围有敌人返回true，否则返回false
function Plater:AnyEnemyInMelee(mobHealth)
    mobHealth = mobHealth or 0
    return self:AnyEnemyInRange(5, mobHealth)
end

--- 获取所有敌对、存在且在战斗中目标的最大生命值总和
--- @return number 所有符合条件目标的最大生命值总和
function Plater:TotalMaxHealthOfEnemiesInCombat()
    local totalMaxHealth = 0
    for i = 1, #Unit.Nameplate do
        local unit = Unit.Nameplate[i]
        if unit:CanBeAttackedByPlayer() and unit:Exists() and unit:AffectingCombat() then
            totalMaxHealth = totalMaxHealth + unit:MaxHealth()
        end
    end
    return totalMaxHealth
end

--- 获取所有敌对、存在且在战斗中目标的当前生命值总和
--- @return number 所有符合条件目标的当前生命值总和
function Plater:TotalHealthOfEnemiesInCombat()
    local totalHealth = 0
    for i = 1, #Unit.Nameplate do
        local unit = Unit.Nameplate[i]
        if unit:CanBeAttackedByPlayer() and unit:Exists() and unit:AffectingCombat() then
            totalHealth = totalHealth + unit:Health()
        end
    end
    return totalHealth
end
