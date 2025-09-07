# Rotation Lib

自用的一些封装后的更高可读API，使得脚本开发更容易

## 其他说明文件

[Unit.md](doc/Unit.md)

[Spell.md](doc/Spell.md)

## 性能



### 例1: 饰品检测

``` lua
-- 控制台：
-- /dump RLib.Slot(13):Usable()
-- /dump RLib.Slot(14):Usable()

-- 插件写法
local Slot = RLib.Slot;
local Utils = RLib.Utils;

if Slot(13):Usable() then
    Utils.Print("13槽饰品可用");
end

```

### 例2: buff检测

* Player、Pet、Target、Focus、MouseOver 是默认的Unit对象

``` lua
-- 控制台：
-- /dump RLib.Unit("player"):BuffExists("圣言祭礼")
-- /dump RLib.Unit("player"):BuffRemaining("圣言祭礼")
-- /dump RLib.Player:BuffExists("圣言祭礼")
-- /dump RLib.Player:BuffRemaining("圣言祭礼")
-- /dump RLib.Player:DispelDebuffCount("Disease|Poison")

-- 插件写法
local Unit = RLib.Unit;
local Player = RLib.Player;
local Utils = RLib.Utils;

if Player:BuffExists("圣言祭礼") then
    Utils.Print("圣言祭礼buff存在");
end

if Unit("player"):BuffExists("圣言祭礼") then
    Utils.Print("圣言祭礼buff存在");
end

```

### 例3：技能检测

- 同时支持文本或技能id。

``` lua
local Spell = RLib.Spell;

--- 技能冷却
Spell("圣盾术"):CooldownUp()

--- 技能充能
Spell("烈焰咒符"):Charges()


--- 技能覆盖
Spell("投掷利刃"):IsOverride()
Spell(204157):IsOriginal()

```


### 缓存设计

Aura和Plater相关部分使用缓存设计，通过设置菜单设置fps。单个脚本多次调用，不产生额外的cpu消耗。


### DEBUG

```lua
/dump RLib.Party:FindMemberWithMostDebuffs("Disease|Poison")
/dump RLib.Spell("圣洁武器"):Charges()
/dump RLib.Spell("圣洁武器"):Usable()

/dump RLib.Spell("神圣壁垒"):Charges()
/dump RLib.Spell("神圣壁垒"):Usable()
```


## Rotation设计说明

1. 每个职业的rotation，应该成为RLib.Rotation的一个键。
比如

```lua
local addonName, Rotation = ...

local Lib = RLib
local Utils = Lib.Utils
Lib.Rotation.PALADIN = Rotation
```

2. 每个rotation包含一个Init()函数，和一个Run函数。
Run函数返回一个字符串值，表示当前rotation的输出。

