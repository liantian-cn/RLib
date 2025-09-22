--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, Rotation = ...

local RL = RLib
local Utils = RL.Utils



local category = Settings.RegisterVerticalLayoutCategory(addonName)
Settings.RegisterAddOnCategory(category)


function Rotation.InitSettings()
    if RLib_ProtPally_SavedVar == nil then
        RLib_ProtPally_SavedVar = {}
    end
    if not RLib_ProtPally_SavedVar.fps then
        RLib_ProtPally_SavedVar.DS_HEALTH = 10
    end
    if not RLib_ProtPally_SavedVar.WOD_HEALTH_1 then
        RLib_ProtPally_SavedVar.WOD_HEALTH_1 = 50
    end
    if not RLib_ProtPally_SavedVar.WOD_HEALTH_2 then
        RLib_ProtPally_SavedVar.WOD_HEALTH_2 = 70
    end
    if RLib_ProtPally_SavedVar.AUTO_DISPEL == nil then
        RLib_ProtPally_SavedVar.AUTO_DISPEL = true
    end
    if not RLib_ProtPally_SavedVar.AUTO_DISPEL_COUNT then
        RLib_ProtPally_SavedVar.AUTO_DISPEL_COUNT = 1
    end
    if RLib_ProtPally_SavedVar.AUTO_BLESS == nil then
        RLib_ProtPally_SavedVar.AUTO_BLESS = true
    end
    if not RLib_ProtPally_SavedVar.AUTO_BLESS_HP then
        RLib_ProtPally_SavedVar.AUTO_BLESS_HP = 70
    end
    if RLib_ProtPally_SavedVar.AUTO_DIVINE == nil then
        RLib_ProtPally_SavedVar.AUTO_DIVINE = true
    end
    if not RLib_ProtPally_SavedVar.AUTO_DIVINE_COUNT then
        RLib_ProtPally_SavedVar.AUTO_DIVINE_COUNT = 3
    end
    if RLib_ProtPally_SavedVar.USE_SET4 == nil then
        RLib_ProtPally_SavedVar.USE_SET4 = true
    end
end

do
    local name = "圣盾术阈值"
    local variable = "DS_HEALTH"
    local defaultValue = 10
    local minValue = 0
    local maxValue = 30
    local step = 1
    local function GetValue()
        return RLib_ProtPally_SavedVar.DS_HEALTH
    end
    local function SetValue(value)
        Utils.Print("圣盾术阈值:" .. tostring(value))
        RLib_ProtPally_SavedVar.DS_HEALTH = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local tooltip = "设置自动使用圣盾术的血量"
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end


do
    local name = "荣耀圣令阈值1"
    local variable = "WOD_HEALTH_1"
    local defaultValue = 50
    local minValue = 30
    local maxValue = 70
    local step = 1
    local function GetValue()
        return RLib_ProtPally_SavedVar.WOD_HEALTH_1
    end
    local function SetValue(value)
        Utils.Print("荣耀圣令阈值1:" .. tostring(value))
        RLib_ProtPally_SavedVar.WOD_HEALTH_1 = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local tooltip = "使用荣耀圣令的低血量"
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end


do
    local name = "荣耀圣令阈值2"
    local variable = "WOD_HEALTH_2"
    local defaultValue = 70
    local minValue = 50
    local maxValue = 90
    local step = 1
    local function GetValue()
        return RLib_ProtPally_SavedVar.WOD_HEALTH_2
    end
    local function SetValue(value)
        Utils.Print("荣耀圣令阈值2:" .. tostring(value))
        RLib_ProtPally_SavedVar.WOD_HEALTH_2 = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local tooltip = "使用荣耀圣令的高血量"
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end


do
    local variable = "AUTO_DISPEL"
    local name = "自动驱散"
    local tooltip = "自动对队友使用驱散技能"
    local defaultValue = true
    local function GetValue()
        return RLib_ProtPally_SavedVar.AUTO_DISPEL
    end
    local function SetValue(value)
        Utils.Print("自动对队友使用驱散技能" .. tostring(value))
        RLib_ProtPally_SavedVar.AUTO_DISPEL = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end


do
    local variable = "AUTO_DISPEL_COUNT"
    local name = "驱散层数"
    local tooltip = "驱散目标的debuff层数，默认一层就驱散。当蓝压力大，可以设置更高"
    local defaultValue = 1
    local minValue = 1
    local maxValue = 3
    local step = 1
    local function GetValue()
        return RLib_ProtPally_SavedVar.AUTO_DISPEL_COUNT or defaultValue
    end

    local function SetValue(value)
        Utils.Print("驱散层数" .. tostring(value))
        RLib_ProtPally_SavedVar.AUTO_DISPEL_COUNT = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end


do
    local variable = "AUTO_BLESS"
    local name = "牺牲祝福"
    local tooltip = "为拥有特定debuff的队友释放释放牺牲祝福"
    local defaultValue = true
    local function GetValue()
        return RLib_ProtPally_SavedVar.AUTO_BLESS
    end
    local function SetValue(value)
        Utils.Print("为拥有特定debuff的队友释放释放牺牲祝福" .. tostring(value))
        RLib_ProtPally_SavedVar.AUTO_BLESS = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end


do
    local variable = "AUTO_BLESS_HP"
    local name = "牺牲祝福血量"
    local tooltip = "有特殊debuff的队友的血量阈值，低于这个值时释放"
    local defaultValue = 70
    local minValue = 0
    local maxValue = 99
    local step = 1
    local function GetValue()
        return RLib_ProtPally_SavedVar.AUTO_BLESS_HP
    end
    local function SetValue(value)
        Utils.Print("牺牲祝福血量:" .. tostring(value))
        RLib_ProtPally_SavedVar.AUTO_BLESS_HP = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end



do
    local variable = "AUTO_DIVINE"
    local name = "圣洁鸣钟"
    local tooltip = "自动敲钟打断施法"
    local defaultValue = true
    local function GetValue()
        return RLib_ProtPally_SavedVar.AUTO_DIVINE
    end
    local function SetValue(value)
        Utils.Print("自动敲钟打断施法:" .. tostring(value))
        RLib_ProtPally_SavedVar.AUTO_DIVINE = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end




do
    local variable = "AUTO_DIVINE_COUNT"
    local name = "圣洁鸣钟打断目标数"
    local tooltip = "仅当范围内存在大于等于该数子可打断目标时才释放圣洁鸣钟"
    local defaultValue = 3
    local minValue = 2
    local maxValue = 10
    local step = 1
    local function GetValue()
        return RLib_ProtPally_SavedVar.AUTO_DIVINE_COUNT
    end

    local function SetValue(value)
        Utils.Print("圣洁鸣钟打断目标数:" .. tostring(value))
        RLib_ProtPally_SavedVar.AUTO_DIVINE_COUNT = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, tooltip)
end




do
    local variable = "USE_SET4"
    local name = "套装四件套"
    local tooltip = "根据当前赛季（地心之战S3）的套装效果，使用技能。"
    local defaultValue = true
    local function GetValue()
        return RLib_ProtPally_SavedVar.USE_SET4
    end
    local function SetValue(value)
        Utils.Print("套装四件套:" .. tostring(value))
        RLib_ProtPally_SavedVar.USE_SET4 = value
    end
    local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
    Settings.CreateCheckbox(category, setting, tooltip)
end
