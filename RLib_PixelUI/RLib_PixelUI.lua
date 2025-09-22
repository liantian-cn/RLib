--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, PixelUI = ...
local RL = RLib
local Utils = RL.Utils

PixelUI.delay_time = GetTime()
PixelUI.MainRotation = nil
PixelUI.MainRotationName = nil

PixelUI.keyColorMap = {}
local keyColorMap = PixelUI.keyColorMap
keyColorMap[1] = { ["key"] = "CTRL-F1", ["r"] = 130, ["g"] = 115, ["b"] = 124 }
keyColorMap[2] = { ["key"] = "CTRL-F2", ["r"] = 102, ["g"] = 253, ["b"] = 136 }
keyColorMap[3] = { ["key"] = "CTRL-F3", ["r"] = 66, ["g"] = 134, ["b"] = 253 }
keyColorMap[4] = { ["key"] = "CTRL-F5", ["r"] = 123, ["g"] = 195, ["b"] = 3 }
keyColorMap[5] = { ["key"] = "CTRL-F6", ["r"] = 241, ["g"] = 208, ["b"] = 124 }
keyColorMap[6] = { ["key"] = "CTRL-F7", ["r"] = 1, ["g"] = 142, ["b"] = 135 }
keyColorMap[7] = { ["key"] = "CTRL-F8", ["r"] = 128, ["g"] = 18, ["b"] = 30 }
keyColorMap[8] = { ["key"] = "CTRL-F9", ["r"] = 136, ["g"] = 5, ["b"] = 190 }
keyColorMap[9] = { ["key"] = "CTRL-F10", ["r"] = 246, ["g"] = 14, ["b"] = 129 }
keyColorMap[10] = { ["key"] = "CTRL-F11", ["r"] = 244, ["g"] = 124, ["b"] = 235 }
keyColorMap[11] = { ["key"] = "SHIFT-F1", ["r"] = 229, ["g"] = 132, ["b"] = 1 }
keyColorMap[12] = { ["key"] = "SHIFT-F2", ["r"] = 35, ["g"] = 117, ["b"] = 19 }
keyColorMap[13] = { ["key"] = "SHIFT-F3", ["r"] = 30, ["g"] = 27, ["b"] = 153 }
keyColorMap[14] = { ["key"] = "SHIFT-F5", ["r"] = 129, ["g"] = 245, ["b"] = 241 }
keyColorMap[15] = { ["key"] = "SHIFT-F6", ["r"] = 1, ["g"] = 241, ["b"] = 142 }
keyColorMap[16] = { ["key"] = "SHIFT-F7", ["r"] = 246, ["g"] = 109, ["b"] = 114 }
keyColorMap[17] = { ["key"] = "SHIFT-F8", ["r"] = 147, ["g"] = 91, ["b"] = 243 }
keyColorMap[18] = { ["key"] = "SHIFT-F9", ["r"] = 184, ["g"] = 251, ["b"] = 58 }
keyColorMap[19] = { ["key"] = "SHIFT-F10", ["r"] = 187, ["g"] = 191, ["b"] = 194 }
keyColorMap[20] = { ["key"] = "SHIFT-F11", ["r"] = 46, ["g"] = 40, ["b"] = 61 }
keyColorMap[21] = { ["key"] = "SHIFT-,", ["r"] = 50, ["g"] = 189, ["b"] = 190 }
keyColorMap[22] = { ["key"] = "SHIFT-.", ["r"] = 74, ["g"] = 41, ["b"] = 251 }
keyColorMap[23] = { ["key"] = "SHIFT-/", ["r"] = 185, ["g"] = 82, ["b"] = 53 }
keyColorMap[24] = { ["key"] = "SHIFT-;", ["r"] = 69, ["g"] = 213, ["b"] = 65 }
keyColorMap[25] = { ["key"] = "SHIFT-'", ["r"] = 66, ["g"] = 100, ["b"] = 177 }
keyColorMap[26] = { ["key"] = "SHIFT-[", ["r"] = 191, ["g"] = 165, ["b"] = 67 }
keyColorMap[27] = { ["key"] = "SHIFT-]", ["r"] = 145, ["g"] = 36, ["b"] = 107 }
keyColorMap[28] = { ["key"] = "SHIFT-=", ["r"] = 115, ["g"] = 114, ["b"] = 41 }
keyColorMap[29] = { ["key"] = "CTRL-,", ["r"] = 191, ["g"] = 104, ["b"] = 181 }
keyColorMap[30] = { ["key"] = "CTRL-.", ["r"] = 135, ["g"] = 170, ["b"] = 245 }
keyColorMap[31] = { ["key"] = "CTRL-/", ["r"] = 211, ["g"] = 0, ["b"] = 194 }
keyColorMap[32] = { ["key"] = "CTRL-;", ["r"] = 60, ["g"] = 143, ["b"] = 85 }
keyColorMap[33] = { ["key"] = "CTRL-'", ["r"] = 147, ["g"] = 201, ["b"] = 113 }
keyColorMap[34] = { ["key"] = "CTRL-[", ["r"] = 1, ["g"] = 104, ["b"] = 242 }
keyColorMap[35] = { ["key"] = "CTRL-]", ["r"] = 4, ["g"] = 182, ["b"] = 60 }
keyColorMap[36] = { ["key"] = "CTRL-=", ["r"] = 4, ["g"] = 186, ["b"] = 245 }
keyColorMap[37] = { ["key"] = "CTRL-NUMPAD1", ["r"] = 250, ["g"] = 200, ["b"] = 41 }
keyColorMap[38] = { ["key"] = "CTRL-NUMPAD2", ["r"] = 252, ["g"] = 211, ["b"] = 191 }
keyColorMap[39] = { ["key"] = "CTRL-NUMPAD3", ["r"] = 193, ["g"] = 249, ["b"] = 160 }
keyColorMap[40] = { ["key"] = "CTRL-NUMPAD4", ["r"] = 149, ["g"] = 23, ["b"] = 253 }
keyColorMap[41] = { ["key"] = "CTRL-NUMPAD5", ["r"] = 13, ["g"] = 95, ["b"] = 90 }
keyColorMap[42] = { ["key"] = "CTRL-NUMPAD6", ["r"] = 211, ["g"] = 203, ["b"] = 254 }
keyColorMap[43] = { ["key"] = "CTRL-NUMPAD7", ["r"] = 95, ["g"] = 7, ["b"] = 139 }
keyColorMap[44] = { ["key"] = "CTRL-NUMPAD8", ["r"] = 230, ["g"] = 155, ["b"] = 161 }
keyColorMap[45] = { ["key"] = "CTRL-NUMPAD9", ["r"] = 62, ["g"] = 252, ["b"] = 192 }
keyColorMap[46] = { ["key"] = "CTRL-NUMPAD0", ["r"] = 67, ["g"] = 191, ["b"] = 127 }
keyColorMap[47] = { ["key"] = "SHIFT-NUMPAD1", ["r"] = 247, ["g"] = 68, ["b"] = 48 }
keyColorMap[48] = { ["key"] = "SHIFT-NUMPAD2", ["r"] = 2, ["g"] = 87, ["b"] = 181 }
keyColorMap[49] = { ["key"] = "SHIFT-NUMPAD3", ["r"] = 80, ["g"] = 251, ["b"] = 16 }
keyColorMap[50] = { ["key"] = "SHIFT-NUMPAD4", ["r"] = 123, ["g"] = 202, ["b"] = 171 }
keyColorMap[51] = { ["key"] = "SHIFT-NUMPAD5", ["r"] = 180, ["g"] = 49, ["b"] = 1 }
keyColorMap[52] = { ["key"] = "SHIFT-NUMPAD6", ["r"] = 240, ["g"] = 6, ["b"] = 59 }
keyColorMap[53] = { ["key"] = "SHIFT-NUMPAD7", ["r"] = 5, ["g"] = 3, ["b"] = 103 }
keyColorMap[54] = { ["key"] = "SHIFT-NUMPAD8", ["r"] = 236, ["g"] = 64, ["b"] = 180 }
keyColorMap[55] = { ["key"] = "SHIFT-NUMPAD9", ["r"] = 17, ["g"] = 243, ["b"] = 66 }
keyColorMap[56] = { ["key"] = "SHIFT-NUMPAD0", ["r"] = 106, ["g"] = 63, ["b"] = 202 }
keyColorMap[57] = { ["key"] = "CTRL-SHIFT-NUMPAD1", ["r"] = 155, ["g"] = 59, ["b"] = 161 }
keyColorMap[58] = { ["key"] = "CTRL-SHIFT-NUMPAD2", ["r"] = 179, ["g"] = 212, ["b"] = 8 }
keyColorMap[59] = { ["key"] = "CTRL-SHIFT-NUMPAD3", ["r"] = 67, ["g"] = 79, ["b"] = 104 }
keyColorMap[60] = { ["key"] = "CTRL-SHIFT-NUMPAD4", ["r"] = 179, ["g"] = 88, ["b"] = 110 }
keyColorMap[61] = { ["key"] = "CTRL-SHIFT-NUMPAD5", ["r"] = 135, ["g"] = 167, ["b"] = 54 }
keyColorMap[62] = { ["key"] = "CTRL-SHIFT-NUMPAD6", ["r"] = 175, ["g"] = 114, ["b"] = 7 }
keyColorMap[63] = { ["key"] = "CTRL-SHIFT-NUMPAD7", ["r"] = 73, ["g"] = 17, ["b"] = 200 }
keyColorMap[64] = { ["key"] = "CTRL-SHIFT-NUMPAD8", ["r"] = 96, ["g"] = 147, ["b"] = 184 }
keyColorMap[65] = { ["key"] = "CTRL-SHIFT-NUMPAD9", ["r"] = 244, ["g"] = 147, ["b"] = 71 }
keyColorMap[66] = { ["key"] = "CTRL-SHIFT-NUMPAD0", ["r"] = 61, ["g"] = 184, ["b"] = 19 }
keyColorMap[67] = { ["key"] = "CTRL-SHIFT-F2", ["r"] = 91, ["g"] = 19, ["b"] = 84 }
keyColorMap[68] = { ["key"] = "CTRL-SHIFT-F3", ["r"] = 30, ["g"] = 49, ["b"] = 211 }
keyColorMap[69] = { ["key"] = "CTRL-SHIFT-F5", ["r"] = 201, ["g"] = 250, ["b"] = 214 }
keyColorMap[70] = { ["key"] = "CTRL-SHIFT-F6", ["r"] = 84, ["g"] = 217, ["b"] = 252 }
keyColorMap[71] = { ["key"] = "CTRL-SHIFT-F7", ["r"] = 50, ["g"] = 253, ["b"] = 121 }
keyColorMap[72] = { ["key"] = "CTRL-SHIFT-F8", ["r"] = 100, ["g"] = 60, ["b"] = 145 }
keyColorMap[73] = { ["key"] = "CTRL-SHIFT-F9", ["r"] = 11, ["g"] = 162, ["b"] = 3 }
keyColorMap[74] = { ["key"] = "CTRL-SHIFT-F10", ["r"] = 142, ["g"] = 250, ["b"] = 3 }
keyColorMap[75] = { ["key"] = "CTRL-SHIFT-F11", ["r"] = 193, ["g"] = 141, ["b"] = 219 }
keyColorMap[76] = { ["key"] = "ALT-NUMPAD1", ["r"] = 32, ["g"] = 42, ["b"] = 3 }
keyColorMap[77] = { ["key"] = "ALT-NUMPAD2", ["r"] = 119, ["g"] = 80, ["b"] = 81 }
keyColorMap[78] = { ["key"] = "ALT-NUMPAD3", ["r"] = 200, ["g"] = 28, ["b"] = 85 }
keyColorMap[79] = { ["key"] = "ALT-NUMPAD4", ["r"] = 247, ["g"] = 239, ["b"] = 76 }
keyColorMap[80] = { ["key"] = "ALT-NUMPAD5", ["r"] = 172, ["g"] = 157, ["b"] = 126 }
keyColorMap[81] = { ["key"] = "ALT-NUMPAD6", ["r"] = 107, ["g"] = 239, ["b"] = 87 }
keyColorMap[82] = { ["key"] = "ALT-NUMPAD7", ["r"] = 3, ["g"] = 79, ["b"] = 26 }
keyColorMap[83] = { ["key"] = "ALT-NUMPAD8", ["r"] = 162, ["g"] = 126, ["b"] = 82 }
keyColorMap[84] = { ["key"] = "ALT-NUMPAD9", ["r"] = 148, ["g"] = 127, ["b"] = 170 }
keyColorMap[85] = { ["key"] = "ALT-NUMPAD0", ["r"] = 218, ["g"] = 63, ["b"] = 134 }
keyColorMap[86] = { ["key"] = "ALT-F1", ["r"] = 182, ["g"] = 163, ["b"] = 3 }
keyColorMap[87] = { ["key"] = "ALT-F2", ["r"] = 188, ["g"] = 34, ["b"] = 225 }
keyColorMap[88] = { ["key"] = "ALT-F3", ["r"] = 49, ["g"] = 144, ["b"] = 145 }
keyColorMap[89] = { ["key"] = "ALT-F5", ["r"] = 157, ["g"] = 248, ["b"] = 107 }
keyColorMap[90] = { ["key"] = "ALT-F6", ["r"] = 85, ["g"] = 90, ["b"] = 248 }
keyColorMap[91] = { ["key"] = "ALT-F7", ["r"] = 195, ["g"] = 94, ["b"] = 246 }
keyColorMap[92] = { ["key"] = "ALT-F8", ["r"] = 96, ["g"] = 193, ["b"] = 212 }
keyColorMap[93] = { ["key"] = "ALT-F9", ["r"] = 24, ["g"] = 87, ["b"] = 136 }
keyColorMap[94] = { ["key"] = "ALT-F10", ["r"] = 200, ["g"] = 11, ["b"] = 142 }
keyColorMap[95] = { ["key"] = "ALT-F11", ["r"] = 70, ["g"] = 61, ["b"] = 25 }
keyColorMap[96] = { ["key"] = "CTRL-F12", ["r"] = 37, ["g"] = 122, ["b"] = 217 }
keyColorMap[97] = { ["key"] = "SHIFT-F4", ["r"] = 141, ["g"] = 82, ["b"] = 1 }
keyColorMap[98] = { ["key"] = "CTRL-F4", ["r"] = 14, ["g"] = 159, ["b"] = 192 }
keyColorMap[99] = { ["key"] = "CTRL-SHIFT-F4", ["r"] = 146, ["g"] = 212, ["b"] = 47 }
keyColorMap[100] = { ["key"] = "CTRL-SHIFT-F1", ["r"] = 19, ["g"] = 245, ["b"] = 209 }
keyColorMap[101] = { ["key"] = "ALT-,", ["r"] = 243, ["g"] = 252, ["b"] = 139 }
keyColorMap[102] = { ["key"] = "ALT-.", ["r"] = 109, ["g"] = 137, ["b"] = 1 }
keyColorMap[103] = { ["key"] = "ALT-/", ["r"] = 243, ["g"] = 51, ["b"] = 97 }
keyColorMap[104] = { ["key"] = "ALT-;", ["r"] = 200, ["g"] = 201, ["b"] = 94 }
keyColorMap[105] = { ["key"] = "ALT-'", ["r"] = 227, ["g"] = 110, ["b"] = 50 }
keyColorMap[106] = { ["key"] = "ALT-[", ["r"] = 169, ["g"] = 2, ["b"] = 42 }
keyColorMap[107] = { ["key"] = "ALT-]", ["r"] = 222, ["g"] = 35, ["b"] = 29 }
keyColorMap[108] = { ["key"] = "ALT-=", ["r"] = 106, ["g"] = 241, ["b"] = 190 }
keyColorMap[109] = { ["key"] = "ALT-SHIFT-NUMPAD1", ["r"] = 38, ["g"] = 79, ["b"] = 249 }
keyColorMap[110] = { ["key"] = "ALT-SHIFT-NUMPAD2", ["r"] = 211, ["g"] = 146, ["b"] = 106 }
keyColorMap[111] = { ["key"] = "ALT-SHIFT-NUMPAD3", ["r"] = 111, ["g"] = 174, ["b"] = 109 }
keyColorMap[112] = { ["key"] = "ALT-SHIFT-NUMPAD4", ["r"] = 37, ["g"] = 221, ["b"] = 161 }
keyColorMap[113] = { ["key"] = "ALT-SHIFT-NUMPAD5", ["r"] = 19, ["g"] = 205, ["b"] = 14 }
keyColorMap[114] = { ["key"] = "ALT-SHIFT-NUMPAD6", ["r"] = 99, ["g"] = 5, ["b"] = 241 }
keyColorMap[115] = { ["key"] = "ALT-SHIFT-NUMPAD7", ["r"] = 232, ["g"] = 43, ["b"] = 224 }
keyColorMap[116] = { ["key"] = "ALT-SHIFT-NUMPAD8", ["r"] = 220, ["g"] = 230, ["b"] = 11 }
keyColorMap[117] = { ["key"] = "ALT-SHIFT-NUMPAD9", ["r"] = 9, ["g"] = 45, ["b"] = 85 }
keyColorMap[118] = { ["key"] = "ALT-SHIFT-NUMPAD0", ["r"] = 42, ["g"] = 227, ["b"] = 243 }
keyColorMap[119] = { ["key"] = "ALT-SHIFT-F1", ["r"] = 87, ["g"] = 4, ["b"] = 38 }
keyColorMap[120] = { ["key"] = "ALT-SHIFT-F2", ["r"] = 237, ["g"] = 108, ["b"] = 179 }
keyColorMap[121] = { ["key"] = "ALT-SHIFT-F3", ["r"] = 182, ["g"] = 206, ["b"] = 153 }
keyColorMap[122] = { ["key"] = "ALT-SHIFT-F4", ["r"] = 41, ["g"] = 85, ["b"] = 58 }
keyColorMap[123] = { ["key"] = "ALT-SHIFT-F5", ["r"] = 134, ["g"] = 164, ["b"] = 197 }
keyColorMap[124] = { ["key"] = "ALT-SHIFT-F6", ["r"] = 32, ["g"] = 30, ["b"] = 254 }
keyColorMap[125] = { ["key"] = "ALT-SHIFT-F7", ["r"] = 255, ["g"] = 166, ["b"] = 234 }
keyColorMap[126] = { ["key"] = "ALT-SHIFT-F8", ["r"] = 201, ["g"] = 238, ["b"] = 119 }
keyColorMap[127] = { ["key"] = "ALT-SHIFT-F9", ["r"] = 85, ["g"] = 174, ["b"] = 255 }
keyColorMap[128] = { ["key"] = "ALT-SHIFT-F10", ["r"] = 81, ["g"] = 207, ["b"] = 164 }
keyColorMap[129] = { ["key"] = "ALT-SHIFT-F11", ["r"] = 16, ["g"] = 144, ["b"] = 94 }
keyColorMap[130] = { ["key"] = "CTRL-SHIFT-,", ["r"] = 252, ["g"] = 183, ["b"] = 3 }
keyColorMap[131] = { ["key"] = "CTRL-SHIFT-.", ["r"] = 243, ["g"] = 72, ["b"] = 7 }
keyColorMap[132] = { ["key"] = "CTRL-SHIFT-/", ["r"] = 231, ["g"] = 84, ["b"] = 219 }
keyColorMap[133] = { ["key"] = "CTRL-SHIFT-;", ["r"] = 39, ["g"] = 251, ["b"] = 32 }
keyColorMap[134] = { ["key"] = "CTRL-SHIFT-'", ["r"] = 225, ["g"] = 161, ["b"] = 30 }
keyColorMap[135] = { ["key"] = "CTRL-SHIFT-[", ["r"] = 194, ["g"] = 52, ["b"] = 172 }
keyColorMap[136] = { ["key"] = "CTRL-SHIFT-]", ["r"] = 8, ["g"] = 179, ["b"] = 151 }
keyColorMap[137] = { ["key"] = "CTRL-SHIFT-=", ["r"] = 53, ["g"] = 181, ["b"] = 230 }
keyColorMap[138] = { ["key"] = "ALT-SHIFT-,", ["r"] = 144, ["g"] = 154, ["b"] = 15 }
keyColorMap[139] = { ["key"] = "ALT-SHIFT-.", ["r"] = 140, ["g"] = 131, ["b"] = 234 }
keyColorMap[140] = { ["key"] = "ALT-SHIFT-/", ["r"] = 135, ["g"] = 88, ["b"] = 188 }
keyColorMap[141] = { ["key"] = "ALT-SHIFT-;", ["r"] = 187, ["g"] = 169, ["b"] = 248 }
keyColorMap[142] = { ["key"] = "ALT-SHIFT-'", ["r"] = 8, ["g"] = 15, ["b"] = 214 }
keyColorMap[143] = { ["key"] = "ALT-SHIFT-[", ["r"] = 81, ["g"] = 88, ["b"] = 61 }
keyColorMap[144] = { ["key"] = "ALT-SHIFT-]", ["r"] = 252, ["g"] = 163, ["b"] = 107 }
keyColorMap[145] = { ["key"] = "ALT-SHIFT-=", ["r"] = 207, ["g"] = 105, ["b"] = 133 }


function LPrint(...)
    print("[|cFFFFBB66RLib PixelUI|r]", ...)
end

local function initFrame()
    local uiScale = WorldFrame:GetEffectiveScale()
    local pixelFrame = CreateFrame("Frame", "PixelUIFrame", WorldFrame);

    pixelFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0);
    -- 设置框架大小为24x24像素
    local screenHeight = select(2, GetPhysicalScreenSize())
    local pixelSize = 24 * (768 / screenHeight) / uiScale
    pixelFrame:SetSize(pixelSize, pixelSize);

    -- 为框架创建一个纹理对象
    local pixelTexture = pixelFrame:CreateTexture();
    -- 让纹理覆盖整个框架区域
    pixelTexture:SetAllPoints();
    -- 设置纹理颜色为白色不透明（RGBA: 1,1,1,1）
    pixelTexture:SetColorTexture(1, 1, 1, 1)

    -- 创建文本显示区域，在pixelFrame右侧
    -- 设置文本相对于pixelFrame的位置，位于其右侧，偏移量为(0, 0)
    -- 设置文本区域大小为208x16像素
    local pixelText = pixelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    local textWidth = 300 * (768 / screenHeight) / uiScale
    local textHeight = 24 * (768 / screenHeight) / uiScale
    pixelText:SetPoint("LEFT", pixelFrame, "RIGHT", 0, 0);
    pixelText:SetSize(textWidth, textHeight);
    pixelText:SetText("PixelUI 标题");
    pixelText:SetJustifyH("CENTER");
    pixelText:SetJustifyV("MIDDLE");
    local fontFile, _, _ = GameFontNormal:GetFont()
    pixelText:SetFont(fontFile, 12, "")
    pixelText:SetTextColor(0, 0, 0, 1);

    -- 为pixelText添加黑色背景
    local textBackground = pixelFrame:CreateTexture(nil, "BACKGROUND");
    textBackground:SetAllPoints(pixelText);
    textBackground:SetColorTexture(1, 1, 1, 1);

    -- 将创建的pixelFrame保存到PixelUI.pixelFrame变量中
    PixelUI.pixelFrame = pixelFrame;
    PixelUI.pixelTexture = pixelTexture;
    PixelUI.pixelText = pixelText;
end

initFrame()



local titleColorMap = {}



local function registerMacro(macros)
    for i = 1, #macros do
        local title = macros[i]["title"]
        local macrotext = macros[i]["macrotext"]
        local key = keyColorMap[i]["key"]
        local color_r = keyColorMap[i]["r"]
        local color_g = keyColorMap[i]["g"]
        local color_b = keyColorMap[i]["b"]
        titleColorMap[title] = {
            ["r"] = color_r,
            ["g"] = color_g,
            ["b"] = color_b,
        }
        local buttonName = string.format("RotationPixelButton_%s", i)
        local frame = CreateFrame("Button", buttonName, UIParent, "SecureActionButtonTemplate")
        frame:SetAttribute("type", "macro")
        frame:SetAttribute("macrotext", macrotext)
        frame:RegisterForClicks("AnyDown", "AnyUp")
        SetOverrideBindingClick(frame, true, key, buttonName)
        -- LPrint(string.format("已绑定宏 %s 到 %s", title, key))
    end
    LPrint("已绑定宏，数量：" .. tostring(#macros))
end


function PixelUI:SetColor(r, g, b)
    PixelUI.pixelTexture:SetColorTexture(r / 255, g / 255, b / 255, 1)
end

function PixelUI:SetText(text)
    PixelUI.pixelText:SetText(text)
end

function PixelUI:Delay(time)
    time = tonumber(time)
    PixelUI.delay_time = GetTime() + time
    self:SetColor(255, 255, 255)
    self:SetText("Delay:" .. tostring(time))
end

SLASH_PHRASE1 = "/delay";
SlashCmdList["PHRASE"] = function(msg)
    PixelUI:Delay(msg)
end



local tickTimer = GetTime()
local function TickUpdate()
    -- print("TickUpdate")
    if GetTime() < PixelUI.delay_time then
        return
    end

    local targetFps = RLib_PixelUI_SavedVar["PixelUIFPS"] or 20;
    local tickOffset = 1.0 / targetFps;
    if GetTime() > tickTimer then
        tickTimer = GetTime() + tickOffset


        if (PixelUI.MainRotation ~= nil) then
            local action1, action2 = PixelUI.MainRotation.Main()
            if action1 == "idle" then
                PixelUI:SetColor(255, 255, 255)
                PixelUI:SetText(action2)
            elseif action1 == "cast" then
                local color = titleColorMap[action2]
                if color == nil then
                    LPrint("未找到宏：" .. action2)
                else
                    local r = color["r"]
                    local g = color["g"]
                    local b = color["b"]
                    PixelUI:SetColor(r, g, b)
                    PixelUI:SetText(action2)
                end
            else
                LPrint("未知状态：" .. action1)
            end
        end
    end
end


function PixelUI.pixelFrame:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    local className, classFilename, _ = UnitClass("player")

    local bestPriority = math.huge

    for rotationName, rotation in pairs(RL.Rotations) do
        if type(rotation) == "table" and rotation.Check then
            local isAvailable, priority = rotation:Check()
            LPrint(string.format("Checking %s , Available %s , Priority %s", rotationName, tostring(isAvailable), tostring(priority)))
            if isAvailable then
                if priority < bestPriority then
                    bestPriority = priority
                    PixelUI.MainRotation = rotation
                    PixelUI.MainRotationName = rotationName
                end
            end
        end
    end


    if PixelUI.MainRotation ~= nil then
        LPrint("Rotation Use: " .. PixelUI.MainRotationName)
        PixelUI.MainRotation:Init()
        registerMacro(PixelUI.MainRotation.Macros)
    else
        LPrint("Rotation Not Found")
    end
end

PixelUI.pixelFrame:SetScript("OnUpdate", TickUpdate)
PixelUI.pixelFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

PixelUI.pixelFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, event, ...)
end)
