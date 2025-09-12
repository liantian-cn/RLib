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
    local variable = "fps"
    local defaultValue = 15
    local minValue = 1
    local maxValue = 60
    local step = 1
    local function GetValue()
        return RLib_SavedVar.fps
    end

    local function SetValue(value)
        RLib_SavedVar.fps = value
    end

    if not RLib_SavedVar.fps then
        RLib_SavedVar.fps = 15
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    -- setting:SetValueChangedCallback(OnSettingChanged)

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
    if not RLib_SavedVar.enablePixelUI then
        RLib_SavedVar.enablePixelUI = false
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

    if not RLib_SavedVar.latencyToleranceWindow then
        RLib_SavedVar.latencyToleranceWindow = SpellQueueWindow * 1.5
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
    if not RLib_SavedVar.enableEstimatedFrame then
        RLib_SavedVar.enableEstimatedFrame = false
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end





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


do
    local variable = "INTERRUPT_CAST"
    local name = "打断延迟"
    local tooltip = "在读条多少后打断，当为0时秒断"
    local defaultValue = 30
    local minValue = 0
    local maxValue = 70
    local step = 5
    local function GetValue()
        return RLib_SavedVar.INTERRUPT_CAST
    end

    local function SetValue(value)
        RLib_SavedVar.INTERRUPT_CAST = value
    end

    if not RLib_SavedVar.INTERRUPT_CAST then
        RLib_SavedVar.INTERRUPT_CAST = defaultValue
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local variable = "INTERRUPT_CHANNEL"
    local name = "打断延迟(通道法术)"
    local tooltip = "在读条多少后打断，当为0时秒断"
    local defaultValue = 10
    local minValue = 0
    local maxValue = 70
    local step = 5
    local function GetValue()
        return RLib_SavedVar.INTERRUPT_CHANNEL
    end

    local function SetValue(value)
        RLib_SavedVar.INTERRUPT_CHANNEL = value
    end

    if not RLib_SavedVar.INTERRUPT_CHANNEL then
        RLib_SavedVar.INTERRUPT_CHANNEL = defaultValue
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end
