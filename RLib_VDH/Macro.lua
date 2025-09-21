--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...

Rotation.Macros = {}
local macro = Rotation.Macros;


macro[1] = { ["title"] = "幽魂炸弹", ["macrotext"] = "/cast 幽魂炸弹\n/cast 恶魔尖刺" }
macro[2] = { ["title"] = "怨念咒符脚下", ["macrotext"] = "/cast [@player] 怨念咒符" }
macro[3] = { ["title"] = "恶魔尖刺", ["macrotext"] = "/cast 恶魔尖刺" }
macro[4] = { ["title"] = "投掷利刃", ["macrotext"] = "/cast 投掷利刃" }
macro[5] = { ["title"] = "排气臂铠护腕", ["macrotext"] = "/use 9" }
macro[6] = { ["title"] = "收割者战刃", ["macrotext"] = "/cast 收割者战刃\n/cast 恶魔尖刺" }
macro[7] = { ["title"] = "灵魂裂劈", ["macrotext"] = "/cast 灵魂裂劈\n/cast 恶魔尖刺" }
macro[8] = { ["title"] = "就近灵魂裂劈", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 灵魂裂劈\n/targetlasttarget\n/cast 恶魔尖刺" }
macro[9] = { ["title"] = "烈火烙印", ["macrotext"] = "/cast 烈火烙印" }
macro[10] = { ["title"] = "烈焰咒符脚下", ["macrotext"] = "/use [@player] 烈焰咒符" }
macro[11] = { ["title"] = "献祭光环", ["macrotext"] = "/cast 献祭光环\n/cast 恶魔尖刺" }
macro[12] = { ["title"] = "瓦解焦点", ["macrotext"] = "/cast [@focus] 瓦解" }
macro[13] = { ["title"] = "瓦解目标", ["macrotext"] = "/cast 瓦解" }
macro[14] = { ["title"] = "破裂", ["macrotext"] = "/cast 破裂\n/cast 恶魔尖刺" }
macro[15] = { ["title"] = "就近破裂", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 破裂\n/targetlasttarget\n/cast 恶魔尖刺" }
macro[16] = { ["title"] = "邪能之刃", ["macrotext"] = "/cast 邪能之刃" }
macro[17] = { ["title"] = "就近邪能之刃", ["macrotext"] = "/cleartarget\n/targetenemy\n/cast 邪能之刃\n/targetlasttarget\n/cast 恶魔尖刺" }
macro[18] = { ["title"] = "邪能毁灭", ["macrotext"] = "/cast 邪能毁灭" }
macro[19] = { ["title"] = "圣光虔敬魔典", ["macrotext"] = "/use 13" }
macro[20] = { ["title"] = "13号饰品", ["macrotext"] = "/use 13" }
macro[21] = { ["title"] = "14号饰品", ["macrotext"] = "/use 14" }
macro[22] = { ["title"] = "恶魔变形", ["macrotext"] = "/cast 恶魔变形" }
macro[23] = { ["title"] = "灵魂切削", ["macrotext"] = "/cast 灵魂切削" }
macro[24] = { ["title"] = "瓦解鼠标", ["macrotext"] = "/cast [@mouseover] 瓦解" }
