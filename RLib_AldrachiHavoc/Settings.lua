--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, Rotation = ...


local category = Settings.RegisterVerticalLayoutCategory(addonName)
Settings.RegisterAddOnCategory(category)


if RLib_AldrachiHavoc_SavedVar == nil then
    RLib_AldrachiHavoc_SavedVar = {}
end

do
    local name = "收割者战刃"
    local variable = "HavocReaverGlaiveHP"
    local tooltip = "使用收割者战刃的目标最低生命值百分比，低于这个百分比留刀"
    local defaultValue = 10
    local minValue = 10
    local maxValue = 100
    local step = 5
    local function GetValue()
        return RLib_AldrachiHavoc_SavedVar.HavocReaverGlaiveHP or defaultValue
    end
    local function SetValue(value)
        RLib_AldrachiHavoc_SavedVar.HavocReaverGlaiveHP = value
    end
    if RLib_AldrachiHavoc_SavedVar.HavocReaverGlaiveHP == nil then
        RLib_AldrachiHavoc_SavedVar.HavocReaverGlaiveHP = 10
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)

    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end

do
    local name = "爆发时间"
    local variable = "HavocBurstTime"
    local tooltip = "使用收割者战刃的目标最低生命值百分比，低于这个百分比留刀"
    local defaultValue = 20
    local minValue = 10
    local maxValue = 100
    local step = 5
    local function GetValue()
        return RLib_AldrachiHavoc_SavedVar.HavocBurstTime or defaultValue
    end
    local function SetValue(value)
        RLib_AldrachiHavoc_SavedVar.HavocBurstTime = value
    end
    if RLib_AldrachiHavoc_SavedVar.HavocBurstTime == nil then
        RLib_AldrachiHavoc_SavedVar.HavocBurstTime = 20
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)

    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end
