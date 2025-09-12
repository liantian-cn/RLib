--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...



--- ======= GLOBALIZE =======

local Unit = RL.Class.Unit
local List = RL.List
--- ============================ CONTENT ============================

--- 刷新单位的光环信息
--- @return nil 无返回值
function Unit:refreshAura()
    -- 清空现有的Buffs和Debuffs表
    wipe(self.Buffs)
    wipe(self.Debuffs)

    -- 获取所有增益效果(Helpful)
    local i = 1
    while true do
        local aura = C_UnitAuras.GetAuraDataByIndex(self:ID(), i, "HELPFUL")
        if not aura then break end

        -- 将光环信息添加到Buffs表中
        table.insert(self.Buffs, aura)
        i = i + 1
    end

    -- 获取所有减益效果(Harmful)
    i = 1
    while true do
        local aura = C_UnitAuras.GetAuraDataByIndex(self:ID(), i, "HARMFUL")
        if not aura then break end

        -- 将光环信息添加到Debuffs表中
        table.insert(self.Debuffs, aura)
        i = i + 1
    end
end

--- 内部辅助函数：查找光环
--- @param auras table 光环表(Buffs或Debuffs)
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家
--- @return table|nil 找到的光环信息，未找到返回nil
local function findAura(auras, spellIdentifier, fromPlayer)
    for i = 1, #auras do
        local auraInfo = auras[i]
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
    if not self.use_cache then
        self:refreshAura()
    end

    return findAura(self.Buffs, spellIdentifier, fromPlayer) ~= nil
end

--- 检查当前单位是否拥有指定减益效果
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为true
--- @return boolean 如果目标拥有该减益效果则返回true，否则返回false
function Unit:DebuffExists(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or true
    if not self.use_cache then
        self:refreshAura()
    end

    return findAura(self.Debuffs, spellIdentifier, fromPlayer) ~= nil
end

--- 获取当前单位增益效果的剩余时间
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param fromPlayer boolean 是否来自玩家，默认值为false
--- @return number 增益效果剩余时间(秒)，如果不存在则返回0
function Unit:BuffRemaining(spellIdentifier, fromPlayer)
    fromPlayer = fromPlayer or false
    if not self.use_cache then
        self:refreshAura()
    end

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
    if not self.use_cache then
        self:refreshAura()
    end

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
    if not self.use_cache then
        self:refreshAura()
    end

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
    if not self.use_cache then
        self:refreshAura()
    end

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
    if not self.use_cache then
        self:refreshAura()
    end

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
    if not self.use_cache then
        self:refreshAura()
    end

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
