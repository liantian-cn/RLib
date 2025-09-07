--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...
local Unit = RL.Class.Unit
local Utils = RL.Utils

RL.MainFrame = CreateFrame("Frame", "RLib_MainFrame", UIParent)

local MainFrame = RL.MainFrame
local AssistedCombat = RL.AssistedCombat


--- ============================ HANDLE ============================


RL.Handers = {}
RL.Rotation = {}


function MainFrame:ADDON_LOADED(addOnName, containsBindings)
    return
end

function MainFrame:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    local className, classFilename, _ = UnitClass("player")
    if RL.Rotation[classFilename] == nil then
        print("没有为 " .. className .. " 设计的Rotation，会使用默认Rotation")
    else
        RL.Rotation.MainRotation = RL.Rotation[classFilename]
        RL.Rotation.MainRotation:Init()
    end

    if RLib_SavedVar.enablePixelUI then
        RL.PixelUI:Init()
    end
end

function MainFrame:PLAYER_LOGIN()
    AssistedCombat.updateBind()
end

function MainFrame:ACTIONBAR_SLOT_CHANGED(slot)
    AssistedCombat.updateBind()
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
end

local tickTimer = GetTime()
function RL.TickUpdate()
    local targetFps = RLib_SavedVar["fps"];
    local tickOffset = 1.0 / targetFps;
    if GetTime() > tickTimer then
        tickTimer = GetTime() + tickOffset
        RL.refreshAll()


        local action1, action2 = nil, nil
        -- print(GetTime())
        if (RL.Rotation.MainRotation ~= nil) and (RL.Rotation.MainRotation.Main ~= nil) then
            action1, action2 = RL.Rotation.MainRotation.Main()

            if RLib_SavedVar.enablePixelUI then
                RL.PixelUI:HandleAction(action1, action2)
            end
        else -- 当没有加载到可用Rotation时
            if RLib_SavedVar.enablePixelUI then
                action1 = "AssistedCombat"
                action2 = AssistedCombat.getAssistedCombatBind()
                RL.PixelUI:HandleAction(action1, action2)
            end
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
