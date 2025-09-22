--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...

if RLib_SavedVar == nil then
    RLib_SavedVar = {}
end

local category = Settings.RegisterVerticalLayoutCategory("RLib")
Settings.RegisterAddOnCategory(category)


do
    local name = "刷新率"
    local tooltip = "设置RLib的每秒刷新速度，这将影响CPU占用，默认10"
    local variable = "FPS"
    local defaultValue = 10
    local minValue = 1
    local maxValue = 30
    local step = 1
    local function GetValue()
        return RLib_SavedVar.FPS or defaultValue
    end

    local function SetValue(value)
        RLib_SavedVar.FPS = value
    end

    if RLib_SavedVar.FPS == nil then
        RLib_SavedVar.FPS = defaultValue
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow")) or 200;
    local name = "延迟窗口"
    local tooltip = "设置延迟窗口，属性用于检测技能CD等的满足情况。单位ms"
    local variable = "latencyToleranceWindow"
    local defaultValue = SpellQueueWindow * 1.5
    local minValue = SpellQueueWindow
    local maxValue = SpellQueueWindow * 2
    local step = 5
    local function GetValue()
        return RLib_SavedVar.latencyToleranceWindow
    end

    local function SetValue(value)
        RLib_SavedVar.latencyToleranceWindow = value
    end

    if RLib_SavedVar.latencyToleranceWindow == nil then
        RLib_SavedVar.latencyToleranceWindow = defaultValue
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)


    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local variable = "INTERRUPT_DELAY"
    local name = "打断延迟"
    local tooltip = "设置为0的时候秒断，单位毫秒。"
    local defaultValue = 300
    local minValue = 0
    local maxValue = 600
    local step = 50
    local function GetValue()
        return RLib_SavedVar.INTERRUPT_DELAY or defaultValue
    end

    local function SetValue(value)
        RLib_SavedVar.INTERRUPT_DELAY = value
    end

    if RLib_SavedVar.INTERRUPT_DELAY == nil then
        RLib_SavedVar.INTERRUPT_DELAY = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end



do
    local variable = "enableRAID"
    local name = "刷新团队信息"
    local tooltip = "刷新团队成员的信息，会增加CPU消耗，非治疗玩家可关闭。"
    local defaultValue = false
    local function GetValue()
        return RLib_SavedVar.enableRAID
    end
    local function SetValue(value)
        RLib_SavedVar.enableRAID = value
        C_UI.Reload()
    end
    if RLib_SavedVar.enableRAID == nil then
        RLib_SavedVar.enableRAID = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end


do
    local variable = "enableArena"
    local name = "刷新竞技场信息"
    local tooltip = "刷新竞技场的信息，会增加CPU消耗，可关闭。"
    local defaultValue = false
    local function GetValue()
        return RLib_SavedVar.enableArena
    end
    local function SetValue(value)
        RLib_SavedVar.enableArena = value
        C_UI.Reload()
    end
    if RLib_SavedVar.enableArena == nil then
        RLib_SavedVar.enableArena = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end



do
    local variable = "enableBoss"
    local name = "刷新Boss信息"
    local tooltip = "仅针对那些有面板的boss，会增加CPU消耗，可关闭。"
    local defaultValue = false
    local function GetValue()
        return RLib_SavedVar.enableBoss
    end
    local function SetValue(value)
        RLib_SavedVar.enableBoss = value
        C_UI.Reload()
    end
    if RLib_SavedVar.enableBoss == nil then
        RLib_SavedVar.enableBoss = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end


do
    local variable = "ShowCombatEstimated"
    local name = "剩余战斗时间计时器"
    local tooltip = "一个可拖动的计时器，显示剩余时间"
    local defaultValue = false
    local function GetValue()
        return RLib_SavedVar.ShowCombatEstimated
    end
    local function SetValue(value)
        RLib_SavedVar.ShowCombatEstimated = value
        C_UI.Reload()
    end
    if RLib_SavedVar.ShowCombatEstimated == nil then
        RLib_SavedVar.ShowCombatEstimated = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end
