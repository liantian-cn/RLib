# Unit 模块

Unit模块提供了对游戏单位（玩家、目标、焦点等）的封装，使开发者可以更方便地获取单位信息和状态。

## 简介

Unit模块封装了WoW API中与单位相关的函数，提供了更直观的面向对象接口。通过Unit模块，你可以轻松地获取单位的各种属性和状态信息。

## 使用方法

### 创建Unit对象

```lua
local Unit = RLib.Unit

-- 创建一个单位对象
local target = Unit("target")
local player = Unit("player")
```

### 使用预定义的单位对象

```lua
-- RLib提供了常用的预定义单位对象
local player = RLib.Player    -- 玩家
local target = RLib.Target    -- 当前目标
local focus = RLib.Focus     -- 焦点目标
local pet = RLib.Pet         -- 宠物
local mouseover = RLib.MouseOver  -- 鼠标悬停目标
```

## API参考

### 构造函数

#### Unit(unitId, use_cache)
创建一个新的Unit对象

- `unitId` (string): 单位标识符，如"player"、"target"、"focus"等
- `use_cache` (boolean, 可选): 是否使用缓存，默认为false

```lua
-- 示例
local target = RLib.Unit("target")
local player = RLib.Unit("player", true)  -- 使用缓存
```

### 基础信息

#### :ID()
获取单位标识符

```lua
local unitId = target:ID()  -- 返回 "target"
```

#### :Name()
获取单位名称

```lua
local name = target:Name()
```

#### :GUID()
获取单位的全局唯一标识符(GUID)

```lua
local guid = target:GUID()
```

#### :NPCID()
获取单位的NPC ID

```lua
local npcId = target:NPCID()
```

#### :Level()
获取单位等级

```lua
local level = target:Level()
```

#### :Class()
获取单位职业

```lua
local class = target:Class()
```

#### :Classification()
获取单位分类（普通、精英、Boss等）

```lua
local classification = target:Classification()
```

### 存在性和状态

#### :Exists()
检查单位是否存在且可见

```lua
if target:Exists() then
    -- 目标存在
end
```

#### :IsAlive()
检查单位是否存活

```lua
if target:IsAlive() then
    -- 目标存活
end
```

#### :IsDeadOrGhost()
检查单位是否死亡或处于灵魂状态

```lua
if target:IsDeadOrGhost() then
    -- 目标已死亡或为灵魂状态
end
```

#### :AffectingCombat()
检查单位是否处于战斗状态

```lua
if target:AffectingCombat() then
    -- 目标正在战斗中
end
```

#### :IsMoving()
检查单位是否正在移动

```lua
if target:IsMoving() then
    -- 目标正在移动
end
```

### 生命值信息

#### :Health()
获取单位当前生命值

```lua
local health = target:Health()
```

#### :MaxHealth()
获取单位最大生命值

```lua
local maxHealth = target:MaxHealth()
```

#### :HealthPercentage()
获取单位生命值百分比(0-100)

```lua
local healthPercent = target:HealthPercentage()
```

### 距离和范围

#### :MaxRange()
获取当前目标可攻击的最大距离

```lua
local maxRange = target:MaxRange()
```

#### :MinRange()
获取当前目标可攻击的最小距离

```lua
local minRange = target:MinRange()
```

#### :InMeleeRange()
检查当前目标是否在近战范围内(5码内)

```lua
if target:InMeleeRange() then
    -- 目标在近战范围内
end
```

### 攻击和敌对关系

#### :CanAttack(otherUnit)
检查是否可以攻击目标单位

- `otherUnit` (Unit): 另一个Unit对象

```lua
if player:CanAttack(target) then
    -- 玩家可以攻击目标
end
```

#### :CanBeAttackedByPlayer()
检查单位是否可以被玩家攻击

```lua
if target:CanBeAttackedByPlayer() then
    -- 目标可以被玩家攻击
end
```

#### :IsPlayer()
检查单位是否为玩家

```lua
if target:IsPlayer() then
    -- 目标是玩家
end
```

#### :IsUnit(otherUnit)
检查两个单位是否相同

- `otherUnit` (Unit): 另一个Unit对象

```lua
if target:IsUnit(focus) then
    -- target和focus是同一单位
end
```

### 威胁值（仇恨）

#### :IsTanking(otherUnit, threatThreshold)
检查单位是否正在当前目标

- `otherUnit` (Unit): 目标单位对象
- `threatThreshold` (number, 可选): 威胁等级阈值，默认为2

威胁等级说明:
- 0: 威胁值低于100%
- 1: 威胁值高于100%，但不是主要目标
- 2: 是主要目标，但其他单位有更高威胁值
- 3: 是主要目标，且没有其他单位有更高威胁值

```lua
-- 检查玩家是否正在坦克目标
if player:IsTanking(target) then
    -- 玩家是目标的主要目标
end

-- 使用自定义威胁阈值
if player:IsTanking(target, 3) then
    -- 玩家是目标的主要目标，且没有其他单位有更高威胁值
end
```

### 施法和打断

#### :IsCasting()
检查单位是否正在施法或引导

```lua
if target:IsCasting() then
    -- 目标正在施法
end
```

#### :CanInterrupt()
检查单位的法术是否可以被打断（返回1表示可以打断，2表示应该打断，-1表示不能打断）

```lua
if target:CanInterrupt() > 0 then
    -- 法术可以被打断
end
```

#### :ShouldInterrupt()
检查单位的法术是否应该被打断

```lua
if target:ShouldInterrupt() then
    -- 应该打断此法术
end
```

## 缓存机制

Unit模块支持缓存机制，当创建Unit对象时传入`use_cache = true`参数，将会缓存单位的状态信息。在需要频繁查询单位状态的场景下，使用缓存可以提高性能。

```lua
-- 启用缓存
local target = RLib.Unit("target", true)

-- 后续查询将使用缓存的数据
local health = target:Health()
local isCasting = target:IsCasting()
```

注意：缓存的数据不会自动更新，需要调用`:refresh()`方法手动刷新或创建新的对象来获取最新数据。

## 示例

### 基础用法
```lua
local Unit = RLib.Unit
local player = RLib.Player
local target = RLib.Target

-- 检查目标是否存在且存活
if target:Exists() and target:IsAlive() then
    print("目标名称: " .. target:Name())
    print("目标生命值: " .. target:HealthPercentage() .. "%")
    
    -- 检查目标是否在近战范围内
    if target:InMeleeRange() then
        print("目标在近战范围内")
    end
    
    -- 检查目标是否正在施法
    if target:IsCasting() then
        if target:ShouldInterrupt() then
            print("应该打断目标施法!")
        end
    end
end
```

### 使用控制台命令测试
```lua
-- 在游戏内控制台中测试
/dump RLib.Target:Exists()
/dump RLib.Target:HealthPercentage()
/dump RLib.Target:IsCasting()
/dump RLib.Target:CanInterrupt()
```