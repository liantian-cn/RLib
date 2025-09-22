
# Spell 模块

Spell模块提供了对游戏法术技能的封装，使开发者可以更方便地检查技能的冷却状态、充能数量等信息。

## 简介

Spell模块封装了WoW API中与法术技能相关的函数，提供了更直观的面向对象接口。通过Spell模块，你可以轻松地获取技能的各种状态信息，如冷却时间、充能数量等。

## 使用方法

### 创建Spell对象

```lua
local Spell = RLib.Spell

-- 创建一个法术技能对象
local fireball = Spell("火球术")
local frostbolt = Spell(116) -- 使用技能ID
```

### 检查技能状态

```lua
-- 检查技能是否冷却完毕
if Spell("火球术"):CooldownUp() then
    print("火球术可用")
end

-- 获取技能充能数
local charges = Spell("炎爆术"):Charges()
print("炎爆术当前有 " .. charges .. " 个充能")
```

## API参考

### 构造函数

#### Spell(spellIdentifier)
创建一个新的Spell对象

- `spellIdentifier` (string|number): 法术标识符，可以是法术名称或法术ID

```lua
-- 示例
local fireball = RLib.Spell("火球术")
local frostbolt = RLib.Spell(116)  -- 116是寒冰箭的ID
```

### 技能检查

#### :IsOriginal()
判断当前技能是否为原始技能（未被其他技能覆盖）

- 返回 `boolean`: 如果技能未被覆盖则返回true，否则返回false

```lua
-- 示例
if Spell("火球术"):IsOriginal() then
    print("火球术未被覆盖")
end
```

#### :IsOverride()
判断技能是否被覆盖

- 返回 `boolean`: 如果技能被覆盖则返回true，否则返回false

```lua
-- 示例
if Spell("火球术"):IsOverride() then
    print("火球术已被覆盖")
end
```

#### :CooldownUp()
检查技能是否处于冷却状态（是否可用）

此方法会考虑延迟容忍窗口设置来判断技能是否可用。

- 返回 `boolean`: 如果技能冷却完毕则返回true，否则返回false

```lua
-- 示例
if Spell("火球术"):CooldownUp() then
    print("火球术可以使用")
end
```

#### :Charges()
获取技能当前可用充能数

此方法会考虑延迟容忍窗口设置来判断下一个充能是否即将可用。

- 返回 `number`: 当前可用充能数

```lua
-- 示例
local charges = Spell("炎爆术"):Charges()
if charges > 0 then
    print("炎爆术当前有 " .. charges .. " 个充能")
end
```
```

这份文档遵循了项目中其他文档的格式，提供了Spell模块的简介、使用方法和API参考，方便开发者了解和使用Spell对象。