--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, Rotation = ...

local RL = RLib

Rotation.Macros = {}
local macro = Rotation.Macros;


macro[1] = { ["title"] = "正义盾击", ["macrotext"] = "/cast 正义盾击" }
macro[2] = { ["title"] = "奉献", ["macrotext"] = "/cast 奉献" }
macro[3] = { ["title"] = "荣耀圣令", ["macrotext"] = "/castsequence reset=0.5 荣耀圣令,魔法点心\n/cast 正义盾击" }
macro[4] = { ["title"] = "工程护腕", ["macrotext"] = "/use 9" }
macro[5] = { ["title"] = "复仇者之盾focus", ["macrotext"] = "/cast [@focus] 复仇者之盾\n/cast 正义盾击" }
macro[6] = { ["title"] = "复仇者之盾target", ["macrotext"] = "/cast 复仇者之盾\n/cast 正义盾击" }
macro[7] = { ["title"] = "责难target", ["macrotext"] = "/cast 责难" }
macro[8] = { ["title"] = "责难focus", ["macrotext"] = "/cast [@focus] 责难" }
macro[9] = { ["title"] = "鼠标指向清毒术", ["macrotext"] = "/cast [@mouseover,help] 清毒术" }
macro[10] = { ["title"] = "盾击和复仇者之盾", ["macrotext"] = "/cast 复仇者之盾\n/cast 正义盾击" }
macro[11] = { ["title"] = "盾击和愤怒之锤", ["macrotext"] = "/cast 愤怒之锤\n/cast 正义盾击" }
macro[12] = { ["title"] = "愤怒之锤", ["macrotext"] = "/cast 愤怒之锤\n/cast 正义盾击" }
macro[13] = { ["title"] = "盾击和审判", ["macrotext"] = "/cast 审判\n/cast 正义盾击" }
macro[14] = { ["title"] = "审判target", ["macrotext"] = "/cast 审判\n/cast 正义盾击" }
macro[15] = { ["title"] = "圣洁武器", ["macrotext"] = "/castsequence reset=1.5 神圣壁垒," }
macro[16] = { ["title"] = "复仇之怒", ["macrotext"] = "/cast [known:31884]  复仇之怒; [known:389539] 戒卫" }
macro[17] = { ["title"] = "光荣时刻", ["macrotext"] = "/cast 光荣时刻" }
macro[18] = { ["title"] = "神圣壁垒", ["macrotext"] = "/castsequence reset=1.5 神圣壁垒," }
macro[19] = { ["title"] = "无敌", ["macrotext"] = "/cast 圣盾术" }
macro[20] = { ["title"] = "圣光壁垒", ["macrotext"] = "/cast 圣光壁垒" }
macro[21] = { ["title"] = "圣言祭礼", ["macrotext"] = "/cast 圣言祭礼\n/use 16" }
macro[22] = { ["title"] = "祝福之锤", ["macrotext"] = "/cast 祝福之锤" }
macro[23] = { ["title"] = "圣洁鸣钟", ["macrotext"] = "/cast 圣洁鸣钟" }
macro[24] = { ["title"] = "player清毒术", ["macrotext"] = "/cast [@player] 清毒术" }
macro[25] = { ["title"] = "party1清毒术", ["macrotext"] = "/cast [@party1] 清毒术" }
macro[26] = { ["title"] = "party2清毒术", ["macrotext"] = "/cast [@party2] 清毒术" }
macro[27] = { ["title"] = "party3清毒术", ["macrotext"] = "/cast [@party3] 清毒术" }
macro[28] = { ["title"] = "party4清毒术", ["macrotext"] = "/cast [@party4] 清毒术" }
macro[29] = { ["title"] = "party1牺牲祝福", ["macrotext"] = "/cast [@party1] 牺牲祝福" }
macro[30] = { ["title"] = "party2牺牲祝福", ["macrotext"] = "/cast [@party2] 牺牲祝福" }
macro[31] = { ["title"] = "party3牺牲祝福", ["macrotext"] = "/cast [@party3] 牺牲祝福" }
macro[32] = { ["title"] = "party4牺牲祝福", ["macrotext"] = "/cast [@party4] 牺牲祝福" }
macro[33] = { ["title"] = "提尔之眼", ["macrotext"] = "/cast 提尔之眼\n/cast 正义盾击" }
macro[34] = { ["title"] = "炽热防御者", ["macrotext"] = "/cast 炽热防御者\n/cast 正义盾击\n/cast 祝福之锤" }
macro[35] = { ["title"] = "戒卫", ["macrotext"] = "/cast 戒卫\n/cast 正义盾击\n/cast 祝福之锤" }
macro[36] = { ["title"] = "复仇者之盾mouseover", ["macrotext"] = "/cast [@mouseover] 复仇者之盾" }
macro[37] = { ["title"] = "责难mouseover", ["macrotext"] = "/cast [@mouseover] 责难" }
macro[38] = { ["title"] = "审判focus", ["macrotext"] = "/cast [@focus] 审判\n/cast 正义盾击" }
