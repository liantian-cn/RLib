SetCVar("scriptErrors", 1);
SetCVar("doNotFlashLowHealthWarning", 1);
SetCVar("cameraIndirectVisibility", 1);
SetCVar("cameraIndirectOffset", 10);
SetCVar("SpellQueueWindow", 150);
SetCVar("targetNearestDistance", 5)
SetCVar("cameraDistanceMaxZoomFactor", 2.6)
SetCVar("CameraReduceUnexpectedMovement", 1)
SetCVar("synchronizeSettings", 1)
SetCVar("synchronizeConfig", 1)
SetCVar("synchronizeBindings", 1)
SetCVar("synchronizeMacros", 1)

--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, RL = ...

RL.MainFrame = CreateFrame("Frame", "RLib_MainFrame", UIParent)
local MainFrame = RL.MainFrame




local tickTimer = GetTime()
function RL.TickUpdate()
    local targetFps = RLib_SavedVar["FPS"];
    local tickOffset = 1.0 / targetFps;
    if GetTime() > tickTimer then
        tickTimer = GetTime() + tickOffset
        RL.refreshUnit();
        RL.updateGcdRemaining();
        RL.Combat:TickUpdate();
        RL.Combat:UpdateEstimatedText()
    end
end

MainFrame:SetScript("OnUpdate", RL.TickUpdate)
