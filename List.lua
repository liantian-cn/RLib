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

-- interruptList[325701] = true; -- 赎罪大厅 > 堕落的搜集者 > [生命虹吸]
-- interruptList["生命虹吸"] = true; -- 赎罪大厅 > 堕落的搜集者
interruptList[326450] = true; -- 赎罪大厅 > 堕落的驯犬者 > [忠心的野兽]
interruptList["忠心的野兽"] = true; -- 赎罪大厅 > 堕落的驯犬者
interruptList[328322] = true; -- 赎罪大厅 > 不死石精 > [罪邪箭]
interruptList["罪邪箭"] = true; -- 赎罪大厅 > 不死石精
interruptList[323538] = true; -- 赎罪大厅 > 高阶裁决官阿丽兹 > [心能箭矢]
interruptList["心能箭矢"] = true; -- 赎罪大厅 > 高阶裁决官阿丽兹
-- interruptList["邪恶箭矢"] = true; -- 赎罪大厅 > 堕落的歼灭者
-- interruptList[338003] = true; -- 赎罪大厅 > 堕落的歼灭者
-- interruptList[326829] = true; -- 赎罪大厅 > 堕落的歼灭者

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
-- interruptList["凌光箭"] = true; -- 财团智囊
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
-- interruptList[431309] = true; -- 破晨号 > 夜幕影法师 > [诱捕暗影]
-- interruptList["诱捕暗影"] = true; -- 破晨号 > 夜幕影法师
interruptList[449734] = true; -- 破晨号 > 拉夏南 > [酸蚀喷发]
interruptList["酸蚀喷发"] = true; -- 破晨号 > 拉夏南
interruptList[432520] = true; -- 破晨号 > 夜幕暗法师 > [暗影屏障]
interruptList["暗影屏障"] = true; -- 破晨号 > 夜幕暗法师
interruptList[451113] = true; -- 破晨号
interruptList[428086] = true; -- 破晨号
interruptList[431333] = true; -- 破晨号
interruptList[431303] = true; -- 破晨号


-- 修道院
interruptList[427356] = true; -- 修道院 > 虔诚的牧师 > [强效治疗术]
interruptList["强效治疗术"] = true; -- 修道院 > 虔诚的牧师
interruptList[424419] = true; -- 修道院 > 戴尔克莱上尉 > [战斗狂啸]
interruptList["战斗狂啸"] = true; -- 修道院 > 戴尔克莱上尉
interruptList[444743] = true; -- 修道院 > 亡灵法师 > [连珠火球]
interruptList["连珠火球"] = true; -- 修道院 > 亡灵法师
interruptList[423051] = true; -- 修道院 > 亡灵法师



-- 水闸
interruptList[462771] = true; -- 水闸 > 风险投资公司勘探员 > [勘测光束]
interruptList["勘测光束"] = true; -- 水闸 > 风险投资公司勘探员
interruptList[468631] = true; -- 水闸 > 风险管理公司潜水员 > [鱼叉]
interruptList["鱼叉"] = true; -- 水闸 > 风险管理公司潜水员
interruptList[471733] = true; -- 水闸 > 被惊扰的海藻 > [回春水藻]
interruptList["回春水藻"] = true; -- 水闸 > 被惊扰的海藻
interruptList[1214468] = true; -- 水闸 > 无人机狙击手 > [特技射击]
interruptList["特技射击"] = true; -- 水闸 > 无人机狙击手
interruptList[1214780] = true; -- 水闸 > 暗索无人机 > [终极失真]
interruptList["终极失真"] = true; -- 水闸 > 暗索无人机
interruptList[465595] = true; -- 水闸 > 风险投资公司电工 > [闪电箭]
-- interruptList["闪电箭"] = true; -- 水闸 > 风险投资公司电工





-- 回响

interruptList[434793] = true; -- 回响之城 > 颤声侍从 > [共振弹幕]
interruptList["共振弹幕"] = true; -- 回响之城 > 颤声侍从
interruptList[434802] = true; -- 回响之城 > 伊克辛 > [惊惧尖鸣]
interruptList["惊惧尖鸣"] = true; -- 回响之城 > 伊克辛
interruptList[448248] = true; -- 回响之城 > 沾血的网法师 > [恶臭齐射]
interruptList["恶臭齐射"] = true; -- 回响之城 > 沾血的网法师
interruptList[442210] = true; -- 回响之城 > 沾血的网法师 > [流丝束缚]
interruptList["流丝束缚"] = true; -- 回响之城 > 沾血的网法师
interruptList[433841] = true; -- 回响之城 > 鲜血监督者 > [毒液箭雨]
interruptList["毒液箭雨"] = true; -- 回响之城 > 鲜血监督者
interruptBlacklist["抓握之血"] = true; -- 回响之城 > 抓握之血
interruptBlacklist[432031] = true; -- 回响之城



-- ExplodeDispelMagicDebuffList[294929] = true; -- 烈焰撕咬，麦卡贡行动
-- ManualDispelMagicDebuffList[429493] = true; -- 不稳定的腐蚀，驭雷栖巢尾王驱散
ManualDispelDebuffList[473690] = true; -- 动能胶质炸药， 水闸行动
ManualDispelDebuffList[473713] = true; -- 动能胶质炸药， 水闸行动
ManualDispelDebuffList["动能胶质炸药"] = true; -- 动能胶质炸药， 水闸行动
-- HighDamageDebuffList[322795] = true; -- 伤逝剧场，肉钩
-- HighDamageDebuffList[424737] = true; -- 驭雷栖巢，混沌腐蚀
HighDamageDebuffList[446403] = true; -- 圣焰隐修院，牺牲烈焰
HighDamageDebuffList[447270] = true; -- 圣焰隐修院，掷矛
HighDamageDebuffList[447272] = true; -- 圣焰隐修院，掷矛
HighDamageDebuffList[448787] = true; -- 圣焰隐修院，纯净
HighDamageDebuffList[468631] = true; -- 水闸行动，鱼叉
-- HighDamageDebuffList[1214523] = true; -- 驭雷栖巢，饕餮虚空

MidDamageDebuffList[320069] = true;  -- 致死打击，T only
MidDamageDebuffList[330532] = true;  -- 锯齿箭
MidDamageDebuffList[424414] = true;  -- 贯穿护甲，T only
MidDamageDebuffList[424797] = true;  -- 驭雷栖巢，混沌脆弱，受到混沌腐蚀的伤害提高300%，持续10秒。此效果可叠加。
MidDamageDebuffList[429493] = true;  -- 驭雷栖巢，不稳定的腐蚀
MidDamageDebuffList[473690] = true;  -- 动能胶质炸药
MidDamageDebuffList[1217821] = true; -- 麦卡贡，灼热巨颚
MidDamageDebuffList[1223803] = true; -- 剧场，黑暗之井
MidDamageDebuffList[1223804] = true; -- 剧场，黑暗之井




-- HighDamageDebuffList["燧火创伤"] = true; --酒庄
-- HighDamageDebuffList["灼热之陨"] = true; --剧场
HighDamageDebuffList["鱼叉"] = true; --水闸
-- HighDamageDebuffList["饕餮虚空"] = true; --鸟巢
-- HighDamageDebuffList["混沌腐蚀"] = true; --鸟巢
-- HighDamageDebuffList["混沌脆弱"] = true; --鸟巢


-- AoeSpellList[258622] = { start = 5, duration = 6 }; -- 暴富矿区 地震回荡 5秒 施法时间 艾泽洛克与力量产生共鸣并引发一次地震，对所有玩家造成1768543点自然伤害，并使他们的移动速度降低30%，持续6秒。同时使地怒者获得地震回荡。
-- AoeSpellList[262347] = { start = 2.5, duration = 8 }; -- 暴富矿区 静电脉冲 2.5秒 施法时间 释放一次电子脉冲，造成2652815点初始自然伤害和每2秒442136点额外自然伤害，持续8秒，并将敌人击退。
-- AoeSpellList[263628] = { start = 2, duration = 8 }; -- 暴富矿区 充能护盾 2秒 施法时间 用电化盾牌打击主要目标，电流会轰击目标，造成5895145点自然伤害，并使他们的移动速度降低60%，持续8秒。后续攻击会产生闪电链，对最多5个目标造成1473786点自然伤害。
-- AoeSpellList[269429] = { start = 2, duration = 3 }; -- 暴富矿区 充能射击 2秒 施法时间 向施法者的当前威胁目标发射艾泽里特能量冲击，造成736893点奥术伤害。

-- AoeSpellList[297128] = { start = 2, duration = 3 }; -- 麦卡贡行动 短路 2秒 施法时间 每0.5秒对所有的玩家造成552670点自然伤害，持续3秒。
-- AoeSpellList[1215409] = { start = 2.5, duration = 5 }; -- 麦卡贡行动 超级电钻 2.5秒 施法时间 在5秒内钻取地面，每1秒对所有玩家造成4点自然伤害。

-- AoeSpellList[330716] = { start = 2.5, duration = 8 }; -- 伤逝剧场 灵魂风暴 2.5秒 施法时间 每2秒对所有玩家造成1326408点暗影伤害，持续8秒。
-- AoeSpellList[1215741] = { start = 4, duration = 3 }; -- 伤逝剧场 强力碾压 4秒 施法时间 能量达到100点时，德茜雅释放一次强力粉碎，对所有玩家造成2358058点自然伤害并降低其移动速度30%，持续10秒。
-- AoeSpellList[1215850] = { start = 1, duration = 3 }; -- 伤逝剧场 碾地猛击 1秒 施法时间 对所有玩家造成15点物理伤害，并使周围的地面喷发，对冲击点周围4码内的玩家造成30点自然伤害。

AoeSpellList[424431] = { start = 2, duration = 8 };   -- 圣焰隐修院 圣光烁辉 2秒 施法时间 艾蕾娜·安博兰兹引导圣光之怒，每1秒对所有玩家造成589514点神圣伤害，持续8秒。
AoeSpellList[428169] = { start = 4, duration = 1 };   -- 圣焰隐修院 盲目之光 4秒 施法时间 穆普雷释放出耀眼的光芒，对所有玩家造成1473786点神圣伤害。面向穆普雷的玩家额外受到147379点神圣伤害，并被盲目之光迷惑，持续4秒。
--AoeSpellList[446368] = { start = 5, duration = 1 }; -- 圣焰隐修院 献祭葬火 5秒 施法时间 布朗派克摆出一个燃烧的葬火柴堆，具有3层效果并持续30秒。每当玩家接触葬火柴堆，都会消耗一层效果，使玩家受到牺牲烈焰影响，并使葬火堆爆发出神圣能量，对所有玩家造成736893点伤害。
AoeSpellList[448492] = { start = 1, duration = 3 };   -- 圣焰隐修院 雷霆一击 1秒 施法时间 对50码范围内的敌人造成2063301点自然伤害并使其移动速度降低50%，持续6秒。
AoeSpellList[448791] = { start = 2.5, duration = 1 }; -- 圣焰隐修院 神圣鸣罪 2.5秒 施法时间	对50码内的所有玩家造成2063301点神圣伤害。

-- AoeSpellList[424958] = { start = 2, duration = 3 }; -- 驭雷栖巢 粉碎现实 2秒 施法时间 雷卫戈伦为战锤注入虚空能量，随后跃向一名玩家的位置，对所有玩家造成2210679点暗影伤害。
-- AoeSpellList[427404] = { start = 2, duration = 5 }; -- 驭雷栖巢 局部风暴 2秒 施法时间 引导风暴，每1秒对周围50码范围内的玩家造成663204点自然伤害，持续5秒。
-- AoeSpellList[430812] = { start = 1.5, duration = 6 }; -- 驭雷栖巢 诱集暗影 1.5秒 施法时间 施法者将所有玩家拉近，每1秒造成442136点暗影伤害，持续6秒，并在施法结束时对7码范围内的玩家造成4421358点暗影伤害。
-- AoeSpellList[427404] = { start = 2, duration = 5 }; -- 驭雷栖巢 局部风暴 2秒 施法时间 引导风暴，每1秒对周围50码范围内的玩家造成663204点自然伤害，持续5秒。

-- AoeSpellList[425394] = { start = 3, duration = 3 }; -- 暗焰裂口 吹灭之息 3秒 施法时间 布雷炙孔召唤强风，对所有玩家造成2947572点自然伤害，并熄灭所有蜡烛。
-- AoeSpellList[428066] = { start = 3, duration = 3 }; -- 暗焰裂口 压制咆哮 3秒 施法时间 施法者发出霸气的咆哮，对50码内能直接听清的所有玩家造成1768543点伤害，并使50码内能直接听清的所有盟友的伤害和急速提高10。
-- AoeSpellList[428266] = { start = 3, duration = 4 }; -- 暗焰裂口 永恒黑暗 3秒 施法时间 黑暗之主每1秒释放一股纯粹的暗影波，持续4秒。每股暗影波对所有玩家造成1179029点暗影伤害，并降低烛光的热量。
-- AoeSpellList[430171] = { start = 2.7, duration = 1 }; -- 暗焰裂口 镇火冲击 2.7秒 施法时间 施法者释放出凶猛的烛焰，对60码内的敌人造成1768543点火焰伤害。

-- AoeSpellList[435622] = { start = 4.5, duration = 5 }; -- 燧酿酒庄 遮天蔽日！ 4.5秒 施法时间 能量达到100点时，戈尔迪·底爵向空中胡乱射击，引爆剩余的所有燧酿炸弹，并且每1秒对所有玩家造成589514点火焰伤害，持续5秒。
-- AoeSpellList[439365] = { start = 2, duration = 8 }; -- 燧酿酒庄 喷涌佳酿 2秒 施法时间 艾帕喷涌出蜜酒，每2秒对所有玩家造成1179029点火焰伤害，持续8秒。蜜酒液滴向外飞溅，对3码内的敌人造成4421359点火焰伤害。
-- AoeSpellList[439524] = { start = 1.5, duration = 2 }; -- 燧酿酒庄 振翼之风 1.5秒 施法时间 本克·鸣蜂命令辛迪凶猛地拍动翅膀，在周围召唤一股强风将玩家推离，并且每0.5秒对所有玩家造成589514点自然伤害，持续2秒。
-- AoeSpellList[442995] = { start = 3, duration = 1 }; -- 燧酿酒庄 蜂拥惊喜 3秒 施法时间 对周围的敌人造成1768543点物理伤害，受影响玩家受到蜂拥惊喜的伤害提高10%，持续30秒。

AoeSpellList[460156] = { start = 1.5, duration = 12 }; -- 水闸行动 快速启动 1.5秒 施法时间 所有暗索无人机都被击败后，老大娘会尝试快速补充枯竭的电池。该程序使其受到的伤害提高200%，并且每1.5秒释放能量脉冲，持续12秒。每一股能量都会对所有玩家造成1061126点自然伤害。
AoeSpellList[465463] = { start = 4, duration = 10 };   -- 水闸行动 涡轮增压 4秒 施法时间 吉泽尔将发电机的能量吸收到电池组中，每1秒获得10点电能，并对所有玩家造成663204点自然伤害，持续10秒。
AoeSpellList[465827] = { start = 2.5, duration = 6 };  -- 水闸行动 扭曲精华 2.5秒 施法时间 施法者扭曲60码内所有玩家的精华，每1秒造成442136点暗影伤害并吸收受到的442136点治疗量，持续6秒。
AoeSpellList[469721] = { start = 3, duration = 6 };    -- 水闸行动 逆流 3秒 施法时间 泡泡向玩家喷射海量唾沫，造成4点冰霜伤害，并且每1秒额外造成2点冰霜伤害，持续6秒。


-- 地下堡
interruptList[434740] = true;  -- [暗影屏障]
interruptList[470592] = true;  -- [暗影屏障]
interruptList[470593] = true;  -- [暗影屏障]
interruptList[1243656] = true; -- [暗影屏障]
interruptList[1236354] = true; -- [暗影屏障]
interruptList[1242469] = true; -- [暗影屏障]
interruptList[448399] = true;  -- [暗影屏障]
