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

-- File Locals
local Utils         = {}

--- ======= GLOBALIZE =======
-- Addon
RL.Utils            = Utils


--- ============================ CONTENT ============================
function Utils.BoolToInt(Value)
    return Value and 1 or 0
end

function Utils.IntToBool(Value)
    return Value ~= 0
end

function Utils.Print(...)
    print("[|cFFFF6600Rotation Lib|r]", ...)
end
