--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...

if RLib_SavedVar == nil then
    RLib_SavedVar = {}
end




local function OnSettingChanged(setting, value)
    -- This callback will be invoked whenever a setting is modified.
    print("Setting changed:", setting:GetVariable(), value)
end


local category = Settings.RegisterVerticalLayoutCategory("RLib")
Settings.RegisterAddOnCategory(category)


do
    local name = "刷新率"
    local variable = "fps"
    local defaultValue = 15
    local minValue = 1
    local maxValue = 60
    local step = 1
    local function GetValue()
        return RLib_SavedVar.fps or defaultValue
    end

    local function SetValue(value)
        RLib_SavedVar.fps = value
    end

    if RLib_SavedVar.fps == nil then
        RLib_SavedVar.fps = defaultValue
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local tooltip = "设置RLib的每秒刷新速度，这将影响CPU占用，默认15"
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local variable = "enablePixelUI"
    local name = "启动Pixel UI"
    local tooltip = "启动pixel UI，需要reload后生效"
    local defaultValue = false
    local function GetValue()
        return RLib_SavedVar.enablePixelUI
    end
    local function SetValue(value)
        RLib_SavedVar.enablePixelUI = value
        C_UI.Reload()
    end
    if RLib_SavedVar.enablePixelUI == nil then
        RLib_SavedVar.enablePixelUI = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end


do
    local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow")) or 200;
    local name = "延迟窗口"
    local variable = "latencyToleranceWindow"
    local tooltip = "设置延迟窗口，属性用于检测技能CD等的满足情况。单位ms"
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
    local variable = "enableEstimatedFrame"
    local name = "剩余战斗时间计时器"
    local tooltip = "一个可拖动的计时器，显示剩余时间"
    local defaultValue = false
    local function GetValue()
        return RLib_SavedVar.enableEstimatedFrame
    end
    local function SetValue(value)
        RLib_SavedVar.enableEstimatedFrame = value
        C_UI.Reload()
    end
    if RLib_SavedVar.enableEstimatedFrame == nil then
        RLib_SavedVar.enableEstimatedFrame = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end


do
    local variable = "INTERRUPT_DELAY"
    local name = "打断延迟"
    local tooltip = "设置为0的时候秒断，单位毫秒。"
    local defaultValue = 300
    local minValue = 0
    local maxValue = 600
    local step = 1
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
    local variable = "INTERRUPT_ANY"
    local name = "任意打断"
    local tooltip = "无所谓白名单，打断任何法术"
    local defaultValue = false

    local function GetValue()
        return RLib_SavedVar.INTERRUPT_ANY
    end

    local function SetValue(value)
        RLib_SavedVar.INTERRUPT_ANY = value
    end
    if RLib_SavedVar.INTERRUPT_ANY == nil then
        RLib_SavedVar.INTERRUPT_ANY = defaultValue
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end

-- do
--     -- RegisterAddOnSetting example. This will read/write the setting directly
--     -- to `RLib_SavedVar.toggle`.

--     local name = "Test Checkbox"
--     local variable = "MyAddOn_Toggle"
--     local variableKey = "toggle"
--     local variableTbl = RLib_SavedVar
--     local defaultValue = false

--     local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
--     setting:SetValueChangedCallback(OnSettingChanged)

--     local tooltip = "This is a tooltip for the checkbox."
--     Settings.CreateCheckbox(category, setting, tooltip)
-- end

-- do
--     local variable = "selection"
--     local defaultValue = 2 -- Corresponds to "Option 2" below.
--     local name = "Test Dropdown"
--     local tooltip = "This is a tooltip for the dropdown."
--     local variableKey = "dropdown"
--     local function GetOptions()
--         local container = Settings.CreateControlTextContainer()
--         container:Add(1, "Option 1")
--         container:Add(2, "Option 2")
--         container:Add(3, "Option 3")
--         return container:GetData()
--     end

--     local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, RLib_SavedVar, type(defaultValue), name, defaultValue)
--     Settings.CreateDropdown(category, setting, GetOptions, tooltip)
-- end


-- do
--     local name = "Test Slider"
--     local variable = "MyAddOn_Slider"
--     local variableKey = "slider"
--     local defaultValue = 180
--     local minValue = 90
--     local maxValue = 360
--     local step = 10
--     local function GetValue()
--         return RLib_SavedVar.slider or defaultValue
--     end

--     local function SetValue(value)
--         RLib_SavedVar.slider = value
--     end

--     local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
--     setting:SetValueChangedCallback(OnSettingChanged)

--     local tooltip = "This is a tooltip for the slider."
--     local options = Settings.CreateSliderOptions(minValue, maxValue, step)
--     options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
--     Settings.CreateSlider(category, setting, options, tooltip)
-- end
