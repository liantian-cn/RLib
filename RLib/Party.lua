--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...
local Unit = RL.Unit

RL.Party = {}
local Party = RL.Party

--- /dump RLib.Party:FindMemberWithMostDebuffsByType("Disease|Poison", 1)

--- 查找小队中拥有特定类型debuff最多的成员
--- @param dispelTypes string 指定的debuff类型，用"|"分隔，如"Disease|Poison"
--- @param minCount number 最少需要的debuff数量，默认为1
--- @return table|nil 返回拥有最多指定类型debuff的成员Unit对象，如果没有人满足条件则返回nil
function Party:FindMemberWithMostDebuffsByType(dispelTypes, minCount)
    minCount = minCount or 1
    local targetMember = nil
    local maxDebuffCount = minCount - 1 -- 调整初始值，使其更符合逻辑
    local lowestHealthPercentage = 1.0

    -- 遍历所有小队成员
    for i = 1, #Unit.Party do
        local member = Unit.Party[i]
        if member:IsAlive() then
            -- 获取该成员的指定类型debuff数量
            local debuffCount = member:DispelDebuffCount(dispelTypes)
            -- print(member:ID(), debuffCount)
            -- print("debuffCount: " .. debuffCount .. "member: " .. member:ID())
            -- 如果该成员的debuff数量大于等于要求的最小数量，并且比当前最大值更大
            if debuffCount >= minCount then
                local memberHealthPercentage = member:RelativeHealthPercentage()
                if debuffCount > maxDebuffCount or
                    (debuffCount == maxDebuffCount and memberHealthPercentage < lowestHealthPercentage) then
                    maxDebuffCount = debuffCount
                    lowestHealthPercentage = memberHealthPercentage
                    targetMember = member
                end
            end
        end
    end

    return targetMember -- 直接返回，让调用者判断是否为nil
end

--- 查找小队中受指定debuff影响最严重的成员
--- @param debuffTable table 包含技能名称和ID的表，格式为: {["技能名称"] = true, [技能ID] = true}
--- @return table|nil 返回受指定debuff影响最严重的成员Unit对象，如果没有人受影响则返回nil
function Party:FindMemberWithMostDebuffsByTable(debuffTable)
    local targetMember = nil
    local maxDebuffCount = 0
    local lowestHealthPercentage = 1.0

    -- 遍历所有小队成员
    for i = 1, #Unit.Party do
        local member = Unit.Party[i]
        if member:IsAlive() then
            -- 获取该成员的指定debuff数量
            local debuffCount = member:CountDebuffs(debuffTable)

            -- 如果该成员有指定的debuff
            if debuffCount > 0 then
                -- 如果debuff数量更多，或者debuff数量相同但健康度更低
                if debuffCount > maxDebuffCount or
                    (debuffCount == maxDebuffCount and member:RelativeHealthPercentage() < lowestHealthPercentage) then
                    maxDebuffCount = debuffCount
                    lowestHealthPercentage = member:RelativeHealthPercentage()
                    targetMember = member
                end
            end
        end
    end

    return targetMember
end
