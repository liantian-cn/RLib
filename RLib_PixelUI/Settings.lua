--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, PixelUI = ...



local category = Settings.RegisterVerticalLayoutCategory(addonName)
Settings.RegisterAddOnCategory(category)



if RLib_PixelUI_SavedVar == nil then
    RLib_PixelUI_SavedVar = {}
end


do
    local name = "刷新率"
    local tooltip = "设置PixelUI的每秒刷新速度，是否占用过多CPU，取决于脚本内容"
    local variable = "PixelUIFPS"
    local defaultValue = 20
    local minValue = 10
    local maxValue = 30
    local step = 5
    local function GetValue()
        return RLib_PixelUI_SavedVar.PixelUIFPS or defaultValue
    end

    local function SetValue(value)
        RLib_PixelUI_SavedVar.PixelUIFPS = value
    end

    if RLib_PixelUI_SavedVar.PixelUIFPS == nil then
        RLib_PixelUI_SavedVar.PixelUIFPS = defaultValue
    end

    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end
