--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, Rotation = ...

local RL = RLib
local Utils = RL.Utils



local category = Settings.RegisterVerticalLayoutCategory(addonName)
Settings.RegisterAddOnCategory(category)



if RLib_AssistedCombat_SavedVar == nil then
    RLib_AssistedCombat_SavedVar = {}
end
