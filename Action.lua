--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...


RL.Action = {}

function RL.Action:Cast(text)
    return "cast", text
end

function RL.Action:Idle(text)
    return "idle", text
end
