--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- 获取插件名称和全局表
local addonName, RL = ...


RL.List = {}

-- 打断技能列表
local interruptList = {}
RL.List.interruptList = interruptList

-- 不打断技能列表
local interruptBlacklist = {}
RL.List.interruptBlacklist = interruptBlacklist

--- 怪物打断玩家的技能俩表
local EnemyInterruptsCastsList = {}
RL.List.EnemyInterruptsCastsList = EnemyInterruptsCastsList

-- 中等debuff列表
local MidDamageDebuffList = {}
RL.List.MidDamageDebuffList = MidDamageDebuffList

-- 高伤害Debuff列表
local HighDamageDebuffList = {}
RL.List.HighDamageDebuffList = HighDamageDebuffList

--- AOE技能列表
local AoeSpellList = {}
RL.List.AoeSpellList = AoeSpellList


-- 手动驱散技能
local ManualDispelDebuffList = {}
RL.List.ManualDispelDebuffList = ManualDispelDebuffList


-- [赎罪大厅]


interruptList[326450] = true; -- 赎罪大厅 > 堕落的驯犬者 > [忠心的野兽]
interruptList[323538] = true; -- 赎罪大厅 > 高阶裁决官阿丽兹 > [心能箭矢]


MidDamageDebuffList[323414] = true; -- 赎罪大厅 4号 哀伤仪式
MidDamageDebuffList["哀伤仪式"] = true; -- 赎罪大厅 4号 哀伤仪式
HighDamageDebuffList[1236514] = true; -- 赎罪大厅 3号 [不稳定的心能]
HighDamageDebuffList["不稳定的心能"] = true; -- 赎罪大厅 3号 [不稳定的心能]

AoeSpellList["耀武扬威"] = { start = 1.7, duration = 15 }; -- 赎罪大厅 中怪 耀武扬威
AoeSpellList[1236614] = { start = 1.7, duration = 15 }; -- 赎罪大厅 中怪 耀武扬威

EnemyInterruptsCastsList["瓦解尖叫"] = true; -- 赎罪大厅 石裔切割者
EnemyInterruptsCastsList[1235326] = true; -- 赎罪大厅 石裔切割者


-- [奥尔达尼生态圆顶]

interruptList[1229474] = true; -- 生态圆顶 门口爬爬 [啃噬]
interruptList["啃噬"] = true; -- 生态圆顶 门口爬爬
interruptList[1229510] = true; -- 生态圆顶
interruptList["弧光震击"] = true; -- 生态圆顶
-- interruptList[1222815] = true; -- 生态圆顶 废土遗民祭师



HighDamageDebuffList[1226444] = true; -- 生态圆顶 尾王 重伤的命运
HighDamageDebuffList["重伤的命运"] = true; -- 生态圆顶 尾王

HighDamageDebuffList[1219704] = true; -- 生态圆顶 尾王 束缚的标枪
HighDamageDebuffList["束缚的标枪"] = true; -- 生态圆顶 老2


-- [天街]

interruptList[355934] = true; -- 支援警官  [强光屏障]
interruptList["强光屏障"] = true; -- 支援警官
interruptList["上古恐慌"] = true; -- 上古熔火恶犬
interruptList[356407] = true; -- 上古熔火恶犬
interruptList[356537] = true; -- 传送门操控师佐·霍恩
interruptList["强化约束雕文"] = true; -- 传送门操控师佐·霍恩
interruptList[355642] = true; -- 老练的火花法师
interruptList["凌光齐射"] = true; -- 老练的火花法师
interruptList[355642] = true; -- 老练的火花法师
interruptList["凌光齐射"] = true; -- 老练的火花法师
interruptList[357029] = true; -- 财团走私者
interruptList["凌光炸弹"] = true; -- 财团走私者
interruptList[357196] = true; -- 财团智囊
interruptList[350922] = true; -- 绿洲保安
interruptList["威吓怒吼"] = true; -- 绿洲保安
interruptList[347775] = true; -- 过载的邮件元素
interruptList["垃圾信息过滤"] = true; -- 过载的邮件元素
interruptList[1245669] = true; -- 索·阿兹密
interruptList["双重秘术"] = true; -- 索·阿兹密
interruptList[350922] = true; -- 佐·格伦
interruptList["威吓怒吼"] = true; -- 佐·格伦
interruptList[1241032] = true; -- 佐·格伦
interruptList["最终警告"] = true; -- 佐·格伦


-- [宏图]

interruptList[355057] = true; -- 浊盐碎壳者
interruptList["鱼人战吼"] = true; -- 浊盐碎壳者

interruptList[356843] = true; -- 时沙号海潮贤者
interruptList["盐渍飞弹"] = true; -- 时沙号海潮贤者

interruptList[357260] = true; -- 专心的祭师
interruptList["不稳定的裂隙"] = true; -- 专心的祭师

interruptList[1241032] = true; -- 佐·格伦
interruptList["最终警告"] = true; -- 佐·格伦


-- 破晨
interruptList[449734] = true; -- 破晨号 > 拉夏南 > [酸蚀喷发]
interruptList[432520] = true; -- 破晨号 > 夜幕暗法师 > [暗影屏障]
interruptList[451113] = true; -- 破晨号
interruptList[428086] = true; -- 破晨号
interruptList[431333] = true; -- 破晨号
interruptList[431303] = true; -- 破晨号


-- 修道院
interruptList[427356] = true; -- 修道院 > 虔诚的牧师 > [强效治疗术]
interruptList[424419] = true; -- 修道院 > 戴尔克莱上尉 > [战斗狂啸]
interruptList[444743] = true; -- 修道院 > 亡灵法师 > [连珠火球]




-- 水闸
interruptList[462771] = true;  -- 水闸 > 风险投资公司勘探员 > [勘测光束]
interruptList[468631] = true;  -- 水闸 > 风险管理公司潜水员 > [鱼叉]
interruptList[471733] = true;  -- 水闸 > 被惊扰的海藻 > [回春水藻]
interruptList[1214468] = true; -- 水闸 > 无人机狙击手 > [特技射击]
interruptList[1214780] = true; -- 水闸 > 暗索无人机 > [终极失真]
interruptList[465595] = true;  -- 水闸 > 风险投资公司电工 > [闪电箭]



-- 回响

interruptList[434793] = true; -- 回响之城 > 颤声侍从 > [共振弹幕]
interruptList[434802] = true; -- 回响之城 > 伊克辛 > [惊惧尖鸣]
interruptList[448248] = true; -- 回响之城 > 沾血的网法师 > [恶臭齐射]
interruptList[442210] = true; -- 回响之城 > 沾血的网法师 > [流丝束缚]
interruptList[433841] = true; -- 回响之城 > 鲜血监督者 > [毒液箭雨]
interruptBlacklist["抓握之血"] = true; -- 回响之城 > 抓握之血
interruptBlacklist[432031] = true; -- 回响之城




ManualDispelDebuffList[473690] = true; -- 动能胶质炸药， 水闸行动
ManualDispelDebuffList[473713] = true; -- 动能胶质炸药， 水闸行动
HighDamageDebuffList[446403] = true;   -- 圣焰隐修院，牺牲烈焰
HighDamageDebuffList[447270] = true;   -- 圣焰隐修院，掷矛
HighDamageDebuffList[447272] = true;   -- 圣焰隐修院，掷矛
HighDamageDebuffList[448787] = true;   -- 圣焰隐修院，纯净
HighDamageDebuffList[468631] = true;   -- 水闸行动，鱼叉
MidDamageDebuffList[320069] = true;    -- 致死打击，T only
MidDamageDebuffList[330532] = true;    -- 锯齿箭
MidDamageDebuffList[424414] = true;    -- 贯穿护甲，T only
MidDamageDebuffList[424797] = true;    -- 驭雷栖巢，混沌脆弱，受到混沌腐蚀的伤害提高300%，持续10秒。此效果可叠加。
MidDamageDebuffList[429493] = true;    -- 驭雷栖巢，不稳定的腐蚀
MidDamageDebuffList[473690] = true;    -- 动能胶质炸药
MidDamageDebuffList[1217821] = true;   -- 麦卡贡，灼热巨颚
MidDamageDebuffList[1223803] = true;   -- 剧场，黑暗之井
MidDamageDebuffList[1223804] = true;   -- 剧场，黑暗之井


HighDamageDebuffList["鱼叉"] = true; --水闸

AoeSpellList[424431] = { start = 2, duration = 8 }; -- 圣焰隐修院 圣光烁辉 2秒 施法时间 艾蕾娜·安博兰兹引导圣光之怒，每1秒对所有玩家造成589514点神圣伤害，持续8秒。
AoeSpellList[428169] = { start = 4, duration = 1 }; -- 圣焰隐修院 盲目之光 4秒 施法时间 穆普雷释放出耀眼的光芒，对所有玩家造成1473786点神圣伤害。面向穆普雷的玩家额外受到147379点神圣伤害，并被盲目之光迷惑，持续4秒。
--AoeSpellList[446368] = { start = 5, duration = 1 }; -- 圣焰隐修院 献祭葬火 5秒 施法时间 布朗派克摆出一个燃烧的葬火柴堆，具有3层效果并持续30秒。每当玩家接触葬火柴堆，都会消耗一层效果，使玩家受到牺牲烈焰影响，并使葬火堆爆发出神圣能量，对所有玩家造成736893点伤害。
AoeSpellList[448492] = { start = 1, duration = 3 }; -- 圣焰隐修院 雷霆一击 1秒 施法时间 对50码范围内的敌人造成2063301点自然伤害并使其移动速度降低50%，持续6秒。
AoeSpellList[448791] = { start = 2.5, duration = 1 }; -- 圣焰隐修院 神圣鸣罪 2.5秒 施法时间	对50码内的所有玩家造成2063301点神圣伤害。
AoeSpellList[460156] = { start = 1.5, duration = 12 }; -- 水闸行动 快速启动 1.5秒 施法时间 所有暗索无人机都被击败后，老大娘会尝试快速补充枯竭的电池。该程序使其受到的伤害提高200%，并且每1.5秒释放能量脉冲，持续12秒。每一股能量都会对所有玩家造成1061126点自然伤害。
AoeSpellList[465463] = { start = 4, duration = 10 }; -- 水闸行动 涡轮增压 4秒 施法时间 吉泽尔将发电机的能量吸收到电池组中，每1秒获得10点电能，并对所有玩家造成663204点自然伤害，持续10秒。
AoeSpellList[465827] = { start = 2.5, duration = 6 }; -- 水闸行动 扭曲精华 2.5秒 施法时间 施法者扭曲60码内所有玩家的精华，每1秒造成442136点暗影伤害并吸收受到的442136点治疗量，持续6秒。
AoeSpellList[469721] = { start = 3, duration = 6 }; -- 水闸行动 逆流 3秒 施法时间 泡泡向玩家喷射海量唾沫，造成4点冰霜伤害，并且每1秒额外造成2点冰霜伤害，持续6秒。


-- 地下堡
interruptList[434740] = true;
interruptList[470592] = true;
interruptList[470593] = true;
interruptList[1243656] = true;
interruptList[1236354] = true;
interruptList[1242469] = true;
interruptList[448399] = true;
