--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...

local List = RL.List;

--- ============================ CONTENT ============================

local Unit = RL.Class.Unit

--- 内部辅助函数：查找光环
--- @param auras table 光环表(Buffs或Debuffs)
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家
--- @return table|nil 找到的光环信息，未找到返回nil
local function findAura(auras, spellIdentifier, fromPlayer)
    if not auras then return nil end
    for i = 1, #auras do
        local auraInfo = auras[i]
        -- print(auraInfo.name)
        if (auraInfo.spellId == spellIdentifier) or (auraInfo.name == spellIdentifier) then
            if fromPlayer then
                if auraInfo.isFromPlayerOrPlayerPet then
                    return auraInfo
                end
            else
                return auraInfo
            end
        end
    end
    return nil
end

--- 检查当前单位是否拥有指定增益效果
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为false
--- @return boolean 如果目标拥有该增益效果则返回true，否则返回false
function Unit:BuffExists(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or false
    return findAura(self.Buffs, spellIdentifier, fromPlayer) ~= nil
end

--- 检查当前单位是否拥有指定减益效果
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为true
--- @return boolean 如果目标拥有该减益效果则返回true，否则返回false
function Unit:DebuffExists(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or true
    -- print(spellIdentifier)
    -- print(self.Debuffs)
    return findAura(self.Debuffs, spellIdentifier, fromPlayer) ~= nil
end

--- 获取当前单位增益效果的剩余时间
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为false
--- @return number 增益效果剩余时间(秒)，如果不存在则返回0
function Unit:BuffRemaining(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or false
    local auraInfo = findAura(self.Buffs, spellIdentifier, fromPlayer)
    if auraInfo then
        local remaining = auraInfo.expirationTime - GetTime()
        return math.max(remaining, 0)
    end
    return 0
end

--- 获取当前单位减益效果的剩余时间
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为true
--- @return number 减益效果剩余时间(秒)，如果不存在则返回0
function Unit:DebuffRemaining(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or true
    local auraInfo = findAura(self.Debuffs, spellIdentifier, fromPlayer)
    if auraInfo then
        local remaining = auraInfo.expirationTime - GetTime()
        return math.max(remaining, 0)
    end
    return 0
end

--- 获取当前单位增益效果的层数
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为false
--- @return number 增益效果层数，如果不存在则返回0
function Unit:BuffStacks(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or false
    local auraInfo = findAura(self.Buffs, spellIdentifier, fromPlayer)
    if auraInfo then
        return auraInfo.applications
    end
    return 0
end

--- 获取当前单位减益效果的层数
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为true
--- @return number 减益效果层数，如果不存在则返回0
function Unit:DebuffStacks(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or true
    local auraInfo = findAura(self.Debuffs, spellIdentifier, fromPlayer)
    if auraInfo then
        return auraInfo.applications
    end
    return 0
end

-- 查找特定类型的debuff数量
-- 如果存在黑名单，则返回0
--- @param dispelTypes string 指定的debuff类型，用"|"分隔，如"Disease|Poison"
--- @return number 匹配的debuff数量
function Unit:DispelDebuffCount(dispelTypes)
    -- 将输入的字符串分割成类型表
    local types = {}
    for type in string.gmatch(dispelTypes, "([^|]+)") do
        types[type] = true
    end

    local count = 0
    -- 遍历所有debuff
    for i = 1, #self.Debuffs do
        local debuff = self.Debuffs[i]
        -- 检查debuff是否有dispelName并且是否匹配指定类型之一
        if debuff.dispelName then
            if List.ManualDispelDebuffList[debuff.name] or List.ManualDispelDebuffList[debuff.spellId] then
                return 0
            elseif types[debuff.dispelName] then
                count = count + debuff.applications
            end
        end
    end

    return count
end

--- 计算单位身上指定debuff的数量
--- @param debuffTable table 包含技能名称和ID的表，格式为: {["技能名称"] = true, [技能ID] = true}
--- @return number 匹配的debuff数量
function Unit:CountDebuffs(debuffTable)
    local count = 0
    -- 遍历所有debuff
    for i = 1, #self.Debuffs do
        local debuff = self.Debuffs[i]
        -- 检查debuff的名称或ID是否在传入的表中
        if debuffTable[debuff.name] or debuffTable[debuff.spellId] then
            count = count + 1
        end
    end

    return count
end
