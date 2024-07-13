local var0_0 = class("ChapterConst")

var0_0.ExitFromChapter = 0
var0_0.ExitFromMap = 1
var0_0.TypeLagacy = 1
var0_0.TypeRange = 2
var0_0.TypeTransport = 3
var0_0.TypeMainSub = 4
var0_0.TypeExtra = 5
var0_0.TypeSpHunt = 7
var0_0.TypeSpBomb = 8
var0_0.TypeDefence = 10
var0_0.TypeDOALink = 11
var0_0.TypeMultiStageBoss = 12
var0_0.SubjectPlayer = 1
var0_0.SubjectChampion = 2
var0_0.MaxRow = 10
var0_0.MaxColumn = 20
var0_0.MaxStep = 10000
var0_0.AttachNone = 0
var0_0.AttachBorn = 1
var0_0.AttachBox = 2
var0_0.AttachSupply = 3
var0_0.AttachElite = 4
var0_0.AttachAmbush = 5
var0_0.AttachEnemy = 6
var0_0.AttachTorpedo_Enemy = 7
var0_0.AttachBoss = 8
var0_0.AttachStory = 9
var0_0.AttachAreaBoss = 11
var0_0.AttachChampion = 12
var0_0.AttachTorpedo_Fleet = 14
var0_0.AttachChampionPatrol = 15
var0_0.AttachBorn_Sub = 16
var0_0.AttachTransport = 17
var0_0.AttachTransport_Target = 18
var0_0.AttachChampionSub = 19
var0_0.AttachOni = 20
var0_0.AttachOni_Target = 21
var0_0.AttachBomb_Enemy = 24
var0_0.AttachBarrier = 25
var0_0.AttachHugeSupply = 26
var0_0.AttachLandbase = 100
var0_0.AttachEnemyTypes = {
	var0_0.AttachEnemy,
	var0_0.AttachAmbush,
	var0_0.AttachElite,
	var0_0.AttachBoss,
	var0_0.AttachAreaBoss,
	var0_0.AttachBomb_Enemy,
	var0_0.AttachChampion
}

function var0_0.IsEnemyAttach(arg0_1)
	return table.contains(var0_0.AttachEnemyTypes, arg0_1)
end

function var0_0.IsBossCell(arg0_2)
	if arg0_2.attachment == var0_0.AttachBoss then
		return true
	end

	if not var0_0.IsEnemyAttach(arg0_2.attachment) then
		return false
	end

	local var0_2 = pg.expedition_data_template[arg0_2.attachmentId]

	if not var0_2 then
		return
	end

	return var0_2.type == var0_0.ExpeditionTypeBoss or var0_2.type == var0_0.ExpeditionTypeMulBoss
end

function var0_0.GetDestroyFX(arg0_3)
	local var0_3 = pg.expedition_data_template[arg0_3.attachmentId]

	if not var0_3 or var0_3.SLG_destroy_FX == "" then
		return "huoqiubaozha"
	else
		return var0_3.SLG_destroy_FX
	end
end

var0_0.Story = 1
var0_0.StoryObstacle = 2
var0_0.StoryTrigger = 3
var0_0.EventTeleport = 4
var0_0.CellFlagActive = 0
var0_0.CellFlagDisabled = 1
var0_0.CellFlagAmbush = 2
var0_0.CellFlagTriggerActive = 3
var0_0.CellFlagTriggerDisabled = 4
var0_0.CellFlagDiving = 5
var0_0.EvtType_Poison = 1
var0_0.EvtType_AdditionalFloor = 2
var0_0.FlagBanaiAirStrike = 4
var0_0.FlagPoison = 5
var0_0.FlagLava = 10
var0_0.FlagNightmare = 9
var0_0.FlagMissleAiming = 12
var0_0.FlagWeatherNight = 101
var0_0.FlagWeatherFog = 102
var0_0.ActType_Poison = 1
var0_0.ActType_SubmarineHunting = 2
var0_0.ActType_TargetDown = 3
var0_0.ActType_Expel = 4
var0_0.BoxBarrier = 0
var0_0.BoxDrop = 1
var0_0.BoxStrategy = 2
var0_0.BoxAirStrike = 4
var0_0.BoxEnemy = 5
var0_0.BoxSupply = 6
var0_0.BoxTorpedo = 7
var0_0.BoxBanaiDamage = 8
var0_0.BoxLavaDamage = 9
var0_0.LBIdle = 0
var0_0.LBCoastalGun = 1
var0_0.LBHarbor = 2
var0_0.LBDock = 3
var0_0.LBAntiAir = 4
var0_0.LBIDAirport = 13
var0_0.RoundPlayer = 0
var0_0.RoundEnemy = 1
var0_0.AIEasy = 1
var0_0.AIStayAround = 2
var0_0.AIPatrol = 3
var0_0.AIProtect = 4
var0_0.AIDog = 5
var0_0.StgTypeForm = 1
var0_0.StgTypeConsume = 2
var0_0.StgTypeConst = 3
var0_0.StgTypePassive = 4
var0_0.StgTypeBindChapter = 5
var0_0.StgTypeBindFleetPassive = 6
var0_0.StgTypeBindSupportConsume = 7
var0_0.StgTypeStatus = 10
var0_0.StrategyAmmoRich = 10001
var0_0.StrategyAmmoPoor = 10002
var0_0.StrategyHuntingRange = -1
var0_0.StrategySubAutoAttack = -2
var0_0.StrategyFormSignleLine = 1
var0_0.StrategyFormDoubleLine = 2
var0_0.StrategyFormCircular = 3
var0_0.StrategyRepair = 4
var0_0.StrategyExchange = 9
var0_0.StrategyCallSubOutofRange = 10
var0_0.StrategySubTeleport = 11
var0_0.StrategySonarDetect = 12
var0_0.StrategyMissileStrike = 18
var0_0.StrategyAirSupport = 1000
var0_0.StrategyExpel = 1001
var0_0.StrategyAirSupportFoe = 94
var0_0.StrategyAirSupportFriendly = 95
var0_0.StrategyIntelligenceRecorded = 96
var0_0.StrategyBuffTypeNormal = 0
var0_0.StrategyBuffTypeOnlyBoss = 1
var0_0.StrategyForms = {
	var0_0.StrategyFormSignleLine,
	var0_0.StrategyFormDoubleLine,
	var0_0.StrategyFormCircular
}
var0_0.StrategyPresents = {
	var0_0.StrategyRepair
}
var0_0.QuadStateFrozen = 1
var0_0.QuadStateNormal = 2
var0_0.QuadStateBarrierSetting = 3
var0_0.QuadStateTeleportSub = 4
var0_0.QuadStateMissileStrike = 5
var0_0.QuadStateAirSuport = 6
var0_0.QuadStateExpel = 7
var0_0.PlaneName = "plane"
var0_0.LineCross = 2
var0_0.CellEaseOutAlpha = 0.01
var0_0.CellNormalColor = Color.white
var0_0.CellTargetColor = Color.green
var0_0.ChildItem = "item"
var0_0.ChildAttachment = "attachment"
var0_0.TraitNone = 0
var0_0.TraitLurk = 1
var0_0.TraitVirgin = 2

function var0_0.NeedMarkAsLurk(arg0_4)
	if arg0_4.flag ~= ChapterConst.CellFlagActive then
		return false
	end

	if arg0_4.attachment == var0_0.AttachBox then
		local var0_4 = pg.box_data_template[arg0_4.attachmentId]

		assert(var0_4, "box_data_template not exist: " .. arg0_4.attachmentId)

		if var0_4.type == var0_0.BoxStrategy and pg.strategy_data_template[var0_4.effect_id].type == ChapterConst.StgTypeBindFleetPassive then
			return nil
		end

		return var0_4.type == var0_0.BoxDrop or var0_4.type == var0_0.BoxStrategy or var0_4.type == var0_0.BoxSupply or var0_4.type == var0_0.BoxEnemy
	elseif var0_0.IsBossCell(arg0_4) then
		return true
	elseif arg0_4.attachment == var0_0.AttachAmbush then
		return false
	elseif var0_0.IsEnemyAttach(arg0_4.attachment) then
		return true
	end
end

function var0_0.NeedEasePathCell(arg0_5)
	if arg0_5.attachment == var0_0.AttachNone then
		return true
	elseif arg0_5.attachment == var0_0.AttachAmbush then
		if arg0_5.flag ~= ChapterConst.CellFlagActive then
			return true
		end
	elseif arg0_5.attachment == var0_0.AttachEnemy or arg0_5.attachment == var0_0.AttachElite then
		if arg0_5.flag == ChapterConst.CellFlagDisabled then
			return true
		end
	elseif arg0_5.attachment == var0_0.AttachSupply and arg0_5.attachmentId <= 0 then
		return true
	elseif arg0_5.attachment == var0_0.AttachBox then
		local var0_5 = pg.box_data_template[arg0_5.attachmentId]

		assert(var0_5, "box_data_template not exist: " .. arg0_5.attachmentId)

		if var0_5.type == var0_0.BoxAirStrike or var0_5.type == var0_0.BoxTorpedo then
			return true
		elseif (var0_5.type == var0_0.BoxDrop or var0_5.type == var0_0.BoxStrategy or var0_5.type == var0_0.BoxEnemy or var0_5.type == var0_0.BoxSupply) and arg0_5.flag == ChapterConst.CellFlagDisabled then
			return true
		end
	elseif arg0_5.attachment == var0_0.AttachStory then
		if arg0_5.flag ~= ChapterConst.CellFlagActive and (arg0_5.flag ~= ChapterConst.CellFlagTriggerActive or arg0_5.data ~= var0_0.StoryObstacle) then
			return true
		end
	elseif arg0_5.attachment == var0_0.AttachBarrier then
		return true
	end

	return false
end

function var0_0.NeedClearStep(arg0_6)
	if arg0_6.attachment == var0_0.AttachAmbush and arg0_6.flag == ChapterConst.CellFlagAmbush then
		return true
	end

	if arg0_6.attachment == var0_0.AttachBox then
		local var0_6 = pg.box_data_template[arg0_6.attachmentId]

		assert(var0_6, "box_data_template not exist: " .. arg0_6.attachmentId)

		if var0_6.type == var0_0.BoxAirStrike then
			return true
		end
	end

	return false
end

var0_0.AchieveType1 = 1
var0_0.AchieveType2 = 2
var0_0.AchieveType3 = 3
var0_0.AchieveType4 = 4
var0_0.AchieveType5 = 5
var0_0.AchieveType6 = 6

function var0_0.IsAchieved(arg0_7)
	local var0_7 = false

	if arg0_7.type == var0_0.AchieveType4 or arg0_7.type == var0_0.AchieveType5 then
		var0_7 = arg0_7.count >= 1
	else
		var0_7 = arg0_7.count >= arg0_7.config
	end

	return var0_7
end

function var0_0.GetAchieveDesc(arg0_8, arg1_8)
	local var0_8 = false
	local var1_8 = _.detect(arg1_8.achieves, function(arg0_9)
		return arg0_9.type == arg0_8
	end)

	if var1_8.type == var0_0.AchieveType1 then
		return "Defeat flagship"
	elseif var1_8.type == var0_0.AchieveType2 then
		return string.format("Defeat escort fleet（%d/%d）", math.min(var1_8.count, var1_8.config), var1_8.config)
	elseif var1_8.type == var0_0.AchieveType3 then
		return "Defeat all enemies"
	elseif var1_8.type == var0_0.AchieveType4 then
		return string.format("Deployed ships≤ %d", var1_8.config)
	elseif var1_8.type == var0_0.AchieveType5 then
		return string.format("XX not deployed", ShipType.Type2Name(var1_8.config))
	elseif var1_8.type == var0_0.AchieveType6 then
		return "Clear with a Full Combo"
	end

	return var0_8
end

var0_0.OpRetreat = 0
var0_0.OpMove = 1
var0_0.OpBox = 2
var0_0.OpAmbush = 4
var0_0.OpStrategy = 5
var0_0.OpRepair = 6
var0_0.OpSupply = 7
var0_0.OpEnemyRound = 8
var0_0.OpSubState = 9
var0_0.OpStory = 10
var0_0.OpBarrier = 16
var0_0.OpSubTeleport = 19
var0_0.OpPreClear = 30
var0_0.OpRequest = 49
var0_0.OpSwitch = 98
var0_0.OpSkipBattle = 99
var0_0.DirtyAchieve = 1
var0_0.DirtyFleet = 2
var0_0.DirtyAttachment = 4
var0_0.DirtyStrategy = 8
var0_0.DirtyChampion = 16
var0_0.DirtyAutoAction = 32
var0_0.DirtyCellFlag = 64
var0_0.DirtyBase = 128
var0_0.DirtyChampionPosition = 256
var0_0.DirtyFloatItems = 512
var0_0.DirtyMapItems = 1024
var0_0.KizunaJammingEngage = 1
var0_0.KizunaJammingDodge = 2
var0_0.StatusDay = 3
var0_0.StatusNight = 4
var0_0.StatusAirportOutControl = 5
var0_0.StatusAirportUnderControl = 6
var0_0.StatusSunrise = 7
var0_0.StatusSunset = 8
var0_0.StatusMaze1 = 9
var0_0.StatusMaze2 = 10
var0_0.StatusMaze3 = 11
var0_0.StatusDPM_KASTHA_FOE = 12
var0_0.StatusDPM_KASTHA_FRIEND = 13
var0_0.StatusDPM_PANYIA_FOE = 14
var0_0.StatusDPM_PANYIA_FRIEND = 15
var0_0.StatusDPM_MRD_FOE = 16
var0_0.StatusDPM_MRD_FRIEND = 17
var0_0.StatusDPM_VITA_FOE = 18
var0_0.StatusDPM_VITA_FRIEND = 19
var0_0.StatusLIGHTHOUSEACTIVE = 20
var0_0.StatusSSSSSyberSquadSupportIdle = 21
var0_0.StatusSSSSSyberSquadSupportActive = 22
var0_0.StatusSSSSKaijuSupportIdle = 23
var0_0.StatusSSSSKaijuSupportActive = 24
var0_0.StatusMissile1 = 30
var0_0.StatusMissile2 = 31
var0_0.StatusMissile3 = 32
var0_0.StatusMissileInit = 33
var0_0.StatusMissile1B = 34
var0_0.StatusMissile2B = 35
var0_0.StatusMissile3B = 36
var0_0.StatusMissileInitB = 37
var0_0.StatusMaoxiv3 = 38
var0_0.StatusGonghai = 39
var0_0.StatusGonghai = 40
var0_0.StatusGonghai = 41
var0_0.StatusMusashiGame1 = 42
var0_0.StatusMusashiGame2 = 43
var0_0.StatusMusashiGame3 = 44
var0_0.StatusMusashiGame4 = 45
var0_0.StatusMusashiGame5 = 46
var0_0.StatusMusashiGame6 = 47
var0_0.StatusMusashiGame7 = 48
var0_0.StatusMusashiGame8 = 49
var0_0.StatusDefaultList = {
	0
}
var0_0.Status2Stg = setmetatable({}, {
	__index = function(arg0_10, arg1_10)
		local var0_10 = pg.chapter_status_effect[arg1_10]
		local var1_10 = var0_10 and var0_10.strategy or 0

		return var1_10 ~= 0 and var1_10 or nil
	end
})
var0_0.Buff2Stg = {}

local function var1_0(arg0_11, arg1_11)
	if arg1_11.buff_id == 0 then
		return
	end

	var0_0.Buff2Stg[arg1_11.buff_id] = arg0_11
end

for iter0_0, iter1_0 in ipairs(pg.strategy_data_template.all) do
	var1_0(iter1_0, pg.strategy_data_template[iter1_0])
end

var0_0.HpGreen = 3000

function var0_0.GetAmbushDisplay(arg0_12)
	local var0_12
	local var1_12

	if not arg0_12 then
		var0_12 = pg.gametip.ambush_display_0.tip
		var1_12 = Color.New(0.96078431372549, 0.376470588235294, 0.282352941176471)
	elseif arg0_12 <= 0 then
		var0_12 = pg.gametip.ambush_display_1.tip
		var1_12 = Color.New(0.662745098039216, 0.96078431372549, 0.282352941176471)
	elseif arg0_12 < 0.1 then
		var0_12 = pg.gametip.ambush_display_2.tip
		var1_12 = Color.New(0.662745098039216, 0.96078431372549, 0.282352941176471)
	elseif arg0_12 < 0.2 then
		var0_12 = pg.gametip.ambush_display_3.tip
		var1_12 = Color.New(0.662745098039216, 0.96078431372549, 0.282352941176471)
	elseif arg0_12 < 0.33 then
		var0_12 = pg.gametip.ambush_display_4.tip
		var1_12 = Color.New(0.984313725490196, 0.788235294117647, 0.215686274509804)
	elseif arg0_12 < 0.5 then
		var0_12 = pg.gametip.ambush_display_5.tip
		var1_12 = Color.New(0.96078431372549, 0.376470588235294, 0.282352941176471)
	else
		var0_12 = pg.gametip.ambush_display_6.tip
		var1_12 = Color.New(0.96078431372549, 0.376470588235294, 0.282352941176471)
	end

	return var0_12, var1_12
end

var0_0.ShipMoveAction = "move"
var0_0.ShipIdleAction = "normal"
var0_0.ShipSwimAction = "swim"
var0_0.ShipStepDuration = 0.5
var0_0.ShipStepQuickPlayScale = 0.5
var0_0.ShipMoveTailLength = 2

function var0_0.GetRepairParams()
	return 1, 3, 100
end

function var0_0.GetShamRepairParams()
	return 1, 3, 100
end

var0_0.AmmoRich = 4
var0_0.AmmoPoor = 0
var0_0.ExpeditionAILair = 6
var0_0.ExpeditionTypeMulBoss = 94
var0_0.ExpeditionTypeUnTouchable = 97
var0_0.ExpeditionTypeBoss = 99
var0_0.EnemySize = {
	1,
	2,
	3,
	1,
	2,
	3,
	1,
	2,
	3,
	1,
	2,
	3,
	3,
	[96] = 100,
	[98] = 100,
	[97] = 100,
	[95] = 98,
	[99] = 99,
	[94] = 99
}
var0_0.EnemyPreference = {
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	[96] = 1,
	[98] = 9,
	[97] = 100,
	[95] = 8,
	[99] = 99,
	[94] = 99
}
var0_0.ShamMoneyItem = 59900
var0_0.MarkHuntingRange = 1
var0_0.MarkBomb = 2
var0_0.MarkCoastalGun = 3
var0_0.MarkEscapeGrid = 4
var0_0.MarkBanaiAirStrike = 5
var0_0.MarkMovePathArrow = 6
var0_0.MarkLava = 7
var0_0.MarkHideNight = 8
var0_0.MarkNightMare = 9
var0_0.ReasonVictory = 1
var0_0.ReasonDefeat = 2
var0_0.ReasonVictoryOni = 3
var0_0.ReasonDefeatOni = 4
var0_0.ReasonDefeatBomb = 5
var0_0.ReasonOutTime = 8
var0_0.ReasonActivityOutTime = 9
var0_0.ReasonDefeatDefense = 10
var0_0.ForbiddenNone = 0
var0_0.ForbiddenRight = 1
var0_0.ForbiddenLeft = 2
var0_0.ForbiddenDown = 4
var0_0.ForbiddenUp = 8
var0_0.ForbiddenRow = 3
var0_0.ForbiddenColumn = 12
var0_0.ForbiddenAll = 15
var0_0.PriorityPerRow = 100
var0_0.PriorityMin = -10000
var0_0.CellPriorityNone = 0 + var0_0.PriorityMin
var0_0.CellPriorityAttachment = 1 + var0_0.PriorityMin
var0_0.CellPriorityLittle = 2 + var0_0.PriorityMin
var0_0.CellPriorityEnemy = 3 + var0_0.PriorityMin
var0_0.CellPriorityFleet = 3 + var0_0.PriorityMin
var0_0.CellPriorityUpperEffect = 5 + var0_0.PriorityMin
var0_0.CellPriorityTopMark = 6 + var0_0.PriorityMin
var0_0.PriorityMax = 10000 + var0_0.PriorityMin
var0_0.LayerWeightMap = -999
var0_0.LayerWeightMapAnimation = var0_0.LayerWeightMap + 1
var0_0.TemplateChampion = "tpl_champion"
var0_0.TemplateEnemy = "tpl_enemy"
var0_0.TemplateOni = "tpl_oni"
var0_0.TemplateFleet = "tpl_ship"
var0_0.TemplateSub = "tpl_sub"
var0_0.TemplateTransport = "tpl_transport"
var0_0.AirDominanceStrategyBuffType = 1001
var0_0.AirDominance = {
	[0] = {
		name = pg.gametip.no_airspace_competition.tip,
		color = Color.New(1, 1, 1)
	},
	{
		name = pg.strategy_data_template[pg.gameset.air_dominance_level_5.key_value].name,
		StgId = pg.gameset.air_dominance_level_5.key_value,
		color = Color.New(0.992156862745098, 0.4, 0.392156862745098)
	},
	{
		name = pg.strategy_data_template[pg.gameset.air_dominance_level_4.key_value].name,
		StgId = pg.gameset.air_dominance_level_4.key_value,
		color = Color.New(0.956862745098039, 0.564705882352941, 0.349019607843137)
	},
	{
		name = pg.strategy_data_template[pg.gameset.air_dominance_level_3.key_value].name,
		StgId = pg.gameset.air_dominance_level_3.key_value,
		color = Color.New(0.956862745098039, 0.847058823529412, 0.23921568627451)
	},
	{
		name = pg.strategy_data_template[pg.gameset.air_dominance_level_2.key_value].name,
		StgId = pg.gameset.air_dominance_level_2.key_value,
		color = Color.New(0.733333333333333, 0.772549019607843, 0.2)
	},
	{
		name = pg.strategy_data_template[pg.gameset.air_dominance_level_1.key_value].name,
		StgId = pg.gameset.air_dominance_level_1.key_value,
		color = Color.New(0.615686274509804, 0.92156862745098, 0.149019607843137)
	}
}

function var0_0.IsAtelierMap(arg0_15)
	return arg0_15:getConfig("on_activity") == ActivityConst.RYZA_MAP_ACT_ID
end

var0_0.AUTOFIGHT_STOP_REASON = {
	DOCK_OVERLOADED = 2,
	SETTLEMENT = 7,
	SHIP_ENERGY_LOW = 6,
	MANUAL = 1,
	GOLD_MAX = 4,
	BATTLE_FAILED = 5,
	UNKNOWN = 0,
	OIL_LACK = 3
}
chapter_skip_battle = PlayerPrefs.GetInt("chapter_skip_battle") or 0

function switch_chapter_skip_battle()
	chapter_skip_battle = 1 - chapter_skip_battle

	PlayerPrefs.SetInt("chapter_skip_battle", chapter_skip_battle)
	PlayerPrefs.Save()
	pg.TipsMgr.GetInstance():ShowTips(chapter_skip_battle == 1 and "已开启战斗跳略" or "已关闭战斗跳略")
end

return var0_0
