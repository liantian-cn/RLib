# Warning

1. 因为Wow12.0的API更新，RLib已经不再适用。
2. 库为个人使用目的开发，不保证代码的稳定性和兼容性
3. 使用本库可能会违反游戏服务条款，请在使用前确认相关规定
4. 作者不对因使用此库而产生的任何后果负责

# RLib

自用的一些封装后的更高可读API，使得脚本开发更容易


## 使用

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

## 其他说明文件

[Unit.md](doc/Unit.md)

[Spell.md](doc/Spell.md)




## 性能

- 可在设置菜单修改刷新速度。10就足以日常使用。
- 会刷新所有单位、姓名板的buff，但同时每逻辑帧也只会请求一次。目前试下来，主流处理器，性能没问题。



## DEBUG

```lua
/dump RLib.Party:FindMemberWithMostDebuffs("Disease|Poison")
/dump RLib.Spell("圣洁武器"):Charges()
/dump RLib.Spell("圣洁武器"):Usable()

/dump RLib.Spell("神圣壁垒"):Charges()
/dump RLib.Spell("神圣壁垒"):Usable()
```



## 其他组件

- `RLib_PixelUI`:一个简单的PixelBot插件
- `RLib_PixelRunner`:PixelBot的python运行时。
- `RLib_AssistedCombat`:自动绑定技能，利用系统自带的api的战斗模块，适合全dps专精。
- `RLib_ProtPally`:自用的防骑模块。
- `RLib_VDH`:自用的复仇DH模块。

## Warning

- 本库为个人使用目的开发，不保证代码的稳定性和兼容性
- 使用本库可能会违反游戏服务条款，请在使用前确认相关规定
- 由于游戏版本更新频繁，部分功能可能无法正常工作
- 请勿在正式服务器上未经充分测试就使用自动化功能
- 作者不对因使用此库而产生的任何后果负责
- 建议在测试环境中先行验证后再部署到生产环境
