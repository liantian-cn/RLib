--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, Rotation = ...


local category = Settings.RegisterVerticalLayoutCategory(addonName)
Settings.RegisterAddOnCategory(category)


if RLib_DeathbringerBlood_SavedVar == nil then
    RLib_DeathbringerBlood_SavedVar = {}
end
