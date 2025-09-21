--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, Rotation = ...

local RL = RLib
local Utils = RL.Utils



local category = Settings.RegisterVerticalLayoutCategory("RLib_AssistedCombat")
Settings.RegisterAddOnCategory(category)



if RLib_AssistedCombat_SavedVar == nil then
    RLib_AssistedCombat_SavedVar = {}
end
