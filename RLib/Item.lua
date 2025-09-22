--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...


--- ======= SLOT =======
--- 装备位置
local SlotClass = {}
SlotClass.__index = SlotClass

--- 创建一个新的 Slot 对象
--- @param SlotID number 装备槽位ID
--- @return table 返回一个新的 Slot 对象
function SlotClass:new(SlotID)
    local obj = {}          -- 创建一个新的空表作为对象
    setmetatable(obj, self) -- 设置元表，使对象继承类的方法
    self.__index = self     -- 设置索引元方法
    if type(SlotID) ~= "number" then error("Invalid SlotID.") end
    obj.SlotID = SlotID
    return obj
end

--- 获取装备槽位上的物品ID
--- @return number|nil 物品ID，如果槽位为空则返回nil
function SlotClass:ItemID()
    local itemId, _ = GetInventoryItemID("player", self.SlotID)
    return itemId
end

--- 检查槽位上的物品是否可以使用
--- 检查内容包括：物品是否可用、是否有足够法力值、物品是否在冷却中
--- @return boolean 如果物品可以使用返回true，否则返回false
function SlotClass:Usable()
    local itemId = self:ItemID()
    if not itemId then
        return false
    end

    local usable, noMana = C_Item.IsUsableItem(itemId)
    if (not usable) or noMana then
        return false
    end

    local _, duration, enable = C_Container.GetItemCooldown(itemId)
    if (enable ~= 1) or (duration > 0) then
        return false
    end

    return true
end

--- 创建一个Slot对象的便捷函数
--- @param SlotID number 装备槽位ID
--- @return table Slot对象
function Slot(SlotID)
    return SlotClass:new(SlotID)
end

-- 使用方式
-- /dump RLib.Slot(13):Usable()
-- /dump RLib.Slot(14):Usable()
RL.Slot = Slot
