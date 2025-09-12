--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...
local Unit = RL.Class.Unit
local Utils = RL.Utils

RL.MainFrame = CreateFrame("Frame", "RLib_MainFrame", UIParent)

local MainFrame = RL.MainFrame
-- local AssistedCombat = RL.AssistedCombat


--- ============================ HANDLE ============================


RL.Handers = {}
RL.Rotation = {}
RL.Rotation.MainRotation = nil
RL.Rotation.MainRotationName = nil

function MainFrame:ADDON_LOADED(addOnName, containsBindings)
    return
end

function MainFrame:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    local className, classFilename, _ = UnitClass("player")


    for rotationAddonName, customRotation in pairs(RL.Rotation) do
        if rotationAddonName ~= "RLib_AssistedCombat" then
            local check = customRotation:Check()
            if check then
                RL.Rotation.MainRotation = customRotation
                RL.Rotation.MainRotationName = rotationAddonName
                Utils.Print("Rotation Use: " .. rotationAddonName)
                break
            end
        end
    end

    if RL.Rotation.MainRotation == nil then
        Utils.Print("Custom Rotation Not Found")
        if RL.Rotation["RLib_AssistedCombat"] ~= nil then
            local customRotation = RL.Rotation["RLib_AssistedCombat"]
            local check = customRotation:Check()
            if check then
                RL.Rotation.MainRotation = customRotation
                RL.Rotation.MainRotationName = RLib_AssistedCombat
                Utils.Print("Rotation Use: RLib_AssistedCombat")
            end
        end
    end

    if RL.Rotation.MainRotation ~= nil then
        RL.Rotation.MainRotation:Init()
    end

    if RLib_SavedVar.enableEstimatedFrame then
        RL.Combat:InitEstimatedFrame()
    end

    if RLib_SavedVar.enablePixelUI then
        RL.PixelUI:Init()
    end
end

function MainFrame:PLAYER_LOGIN()
    -- AssistedCombat.updateBind()
end

function MainFrame:ACTIONBAR_SLOT_CHANGED(slot)
    -- AssistedCombat.updateBind()
end

--- ============================ REFRESH ============================
--- /dump RLib.Player
--- /dump RLib.Player.Buffs
--- /dump RLib.Player:BuffExists("恶魔尖刺")
--- /dump RLib.Unit("player"):BuffRemaining("恶魔尖刺")
--- /dump RLib.Pet
--- /dump RLib.Target
--- /dump RLib.Focus
--- /dump RLib.Mouseover
--- /dump RLib.Plater.Plates
--- /dump RLib.Plater.Plates[1].UnitID
--- /run RLib.Plater:refresh()
---
---
function Unit:refreshAll()
    self:refreshStatus()
    self:refreshAura()
end

function RL.refreshAll()
    RL.Player:refreshAll();
    RL.Pet:refreshAll();
    RL.Target:refreshAll();
    RL.Focus:refreshAll();
    RL.MouseOver:refreshAll();
    RL.Plater:refresh();
    RL.updateGcdRemaining()
    RL.refreshParty()
    RL.Combat:TickUpdate();
    RL.Combat:UpdateEstimatedText()
end

local tickTimer = GetTime()
function RL.TickUpdate()
    local targetFps = RLib_SavedVar["fps"];
    local tickOffset = 1.0 / targetFps;
    if GetTime() > tickTimer then
        tickTimer = GetTime() + tickOffset
        RL.refreshAll()

        local action1, action2 = nil, nil
        if (RL.Rotation.MainRotation ~= nil) and RLib_SavedVar.enablePixelUI then
            action1, action2 = RL.Rotation.MainRotation.Main()
            RL.PixelUI:HandleAction(action1, action2)
        end
    end
end

MainFrame:SetScript("OnUpdate", RL.TickUpdate)


MainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MainFrame:RegisterEvent("ADDON_LOADED")
MainFrame:RegisterEvent("PLAYER_LOGIN")
MainFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
MainFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, event, ...)
end)
