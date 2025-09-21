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
    print("[|cFFFF6600RLib|r]", ...)
end

-- cf. http://lua-users.org/wiki/StringRecipes
-- Determines whether a string begins with the characters of a specified string.
function Utils.StartsWith(String, StartString)
    return String:sub(1, #StartString) == StartString
end

-- Determines whether a string ends with the characters of a specified string.
function Utils.EndsWith(String, EndString)
    return EndString == "" or String:sub(- #EndString) == EndString
end

-- Uppercase the first letter in a string
function Utils.UpperCaseFirst(ThisString)
    return (ThisString:gsub("^%l", string.upper))
end
