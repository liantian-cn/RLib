--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...

local RL = RLib
local Utils = RL.Utils


RL.Rotations[addonName] = Rotation


function Rotation:Check()
    local className, classFilename, classId = UnitClass("player")
    local currentSpec = GetSpecialization()
    if (classFilename == "DEMONHUNTER") and (currentSpec == 2) then
        return true, 1
    end
    return false, 1
end

function Rotation:Init()
    Utils.Print(addonName .. " Inited")
end
