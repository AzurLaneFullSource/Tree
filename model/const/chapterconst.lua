local var0 = class("ChapterConst")

var0.ExitFromChapter = 0
var0.ExitFromMap = 1
var0.TypeLagacy = 1
var0.TypeRange = 2
var0.TypeTransport = 3
var0.TypeMainSub = 4
var0.TypeExtra = 5
var0.TypeSpHunt = 7
var0.TypeSpBomb = 8
var0.TypeDefence = 10
var0.TypeDOALink = 11
var0.TypeMultiStageBoss = 12
var0.SubjectPlayer = 1
var0.SubjectChampion = 2
var0.MaxRow = 10
var0.MaxColumn = 20
var0.MaxStep = 10000
var0.AttachNone = 0
var0.AttachBorn = 1
var0.AttachBox = 2
var0.AttachSupply = 3
var0.AttachElite = 4
var0.AttachAmbush = 5
var0.AttachEnemy = 6
var0.AttachTorpedo_Enemy = 7
var0.AttachBoss = 8
var0.AttachStory = 9
var0.AttachAreaBoss = 11
var0.AttachChampion = 12
var0.AttachTorpedo_Fleet = 14
var0.AttachChampionPatrol = 15
var0.AttachBorn_Sub = 16
var0.AttachTransport = 17
var0.AttachTransport_Target = 18
var0.AttachChampionSub = 19
var0.AttachOni = 20
var0.AttachOni_Target = 21
var0.AttachBomb_Enemy = 24
var0.AttachBarrier = 25
var0.AttachHugeSupply = 26
var0.AttachLandbase = 100
var0.AttachEnemyTypes = {
	var0.AttachEnemy,
	var0.AttachAmbush,
	var0.AttachElite,
	var0.AttachBoss,
	var0.AttachAreaBoss,
	var0.AttachBomb_Enemy,
	var0.AttachChampion
}

function var0.IsEnemyAttach(arg0)
	return table.contains(var0.AttachEnemyTypes, arg0)
end

function var0.IsBossCell(arg0)
	if arg0.attachment == var0.AttachBoss then
		return true
	end

	if not var0.IsEnemyAttach(arg0.attachment) then
		return false
	end

	local var0 = pg.expedition_data_template[arg0.attachmentId]

	if not var0 then
		return
	end

	return var0.type == var0.ExpeditionTypeBoss or var0.type == var0.ExpeditionTypeMulBoss
end

function var0.GetDestroyFX(arg0)
	local var0 = pg.expedition_data_template[arg0.attachmentId]

	if not var0 or var0.SLG_destroy_FX == "" then
		return "huoqiubaozha"
	else
		return var0.SLG_destroy_FX
	end
end

var0.Story = 1
var0.StoryObstacle = 2
var0.StoryTrigger = 3
var0.EventTeleport = 4
var0.CellFlagActive = 0
var0.CellFlagDisabled = 1
var0.CellFlagAmbush = 2
var0.CellFlagTriggerActive = 3
var0.CellFlagTriggerDisabled = 4
var0.CellFlagDiving = 5
var0.EvtType_Poison = 1
var0.EvtType_AdditionalFloor = 2
var0.FlagBanaiAirStrike = 4
var0.FlagPoison = 5
var0.FlagLava = 10
var0.FlagNightmare = 9
var0.FlagMissleAiming = 12
var0.FlagWeatherNight = 101
var0.FlagWeatherFog = 102
var0.ActType_Poison = 1
var0.ActType_SubmarineHunting = 2
var0.ActType_TargetDown = 3
var0.ActType_Expel = 4
var0.BoxBarrier = 0
var0.BoxDrop = 1
var0.BoxStrategy = 2
var0.BoxAirStrike = 4
var0.BoxEnemy = 5
var0.BoxSupply = 6
var0.BoxTorpedo = 7
var0.BoxBanaiDamage = 8
var0.BoxLavaDamage = 9
var0.LBIdle = 0
var0.LBCoastalGun = 1
var0.LBHarbor = 2
var0.LBDock = 3
var0.LBAntiAir = 4
var0.LBIDAirport = 13
var0.RoundPlayer = 0
var0.RoundEnemy = 1
var0.AIEasy = 1
var0.AIStayAround = 2
var0.AIPatrol = 3
var0.AIProtect = 4
var0.AIDog = 5
var0.StgTypeForm = 1
var0.StgTypeConsume = 2
var0.StgTypeConst = 3
var0.StgTypePassive = 4
var0.StgTypeBindChapter = 5
var0.StgTypeBindFleetPassive = 6
var0.StgTypeBindSupportConsume = 7
var0.StgTypeStatus = 10
var0.StrategyAmmoRich = 10001
var0.StrategyAmmoPoor = 10002
var0.StrategyHuntingRange = -1
var0.StrategySubAutoAttack = -2
var0.StrategyFormSignleLine = 1
var0.StrategyFormDoubleLine = 2
var0.StrategyFormCircular = 3
var0.StrategyRepair = 4
var0.StrategyExchange = 9
var0.StrategyCallSubOutofRange = 10
var0.StrategySubTeleport = 11
var0.StrategySonarDetect = 12
var0.StrategyMissileStrike = 18
var0.StrategyAirSupport = 1000
var0.StrategyExpel = 1001
var0.StrategyAirSupportFoe = 94
var0.StrategyAirSupportFriendly = 95
var0.StrategyIntelligenceRecorded = 96
var0.StrategyBuffTypeNormal = 0
var0.StrategyBuffTypeOnlyBoss = 1
var0.StrategyForms = {
	var0.StrategyFormSignleLine,
	var0.StrategyFormDoubleLine,
	var0.StrategyFormCircular
}
var0.StrategyPresents = {
	var0.StrategyRepair
}
var0.QuadStateFrozen = 1
var0.QuadStateNormal = 2
var0.QuadStateBarrierSetting = 3
var0.QuadStateTeleportSub = 4
var0.QuadStateMissileStrike = 5
var0.QuadStateAirSuport = 6
var0.QuadStateExpel = 7
var0.PlaneName = "plane"
var0.LineCross = 2
var0.CellEaseOutAlpha = 0.01
var0.CellNormalColor = Color.white
var0.CellTargetColor = Color.green
var0.ChildItem = "item"
var0.ChildAttachment = "attachment"
var0.TraitNone = 0
var0.TraitLurk = 1
var0.TraitVirgin = 2

function var0.NeedMarkAsLurk(arg0)
	if arg0.flag ~= ChapterConst.CellFlagActive then
		return false
	end

	if arg0.attachment == var0.AttachBox then
		local var0 = pg.box_data_template[arg0.attachmentId]

		assert(var0, "box_data_template not exist: " .. arg0.attachmentId)

		if var0.type == var0.BoxStrategy and pg.strategy_data_template[var0.effect_id].type == ChapterConst.StgTypeBindFleetPassive then
			return nil
		end

		return var0.type == var0.BoxDrop or var0.type == var0.BoxStrategy or var0.type == var0.BoxSupply or var0.type == var0.BoxEnemy
	elseif var0.IsBossCell(arg0) then
		return true
	elseif arg0.attachment == var0.AttachAmbush then
		return false
	elseif var0.IsEnemyAttach(arg0.attachment) then
		return true
	end
end

function var0.NeedEasePathCell(arg0)
	if arg0.attachment == var0.AttachNone then
		return true
	elseif arg0.attachment == var0.AttachAmbush then
		if arg0.flag ~= ChapterConst.CellFlagActive then
			return true
		end
	elseif arg0.attachment == var0.AttachEnemy or arg0.attachment == var0.AttachElite then
		if arg0.flag == ChapterConst.CellFlagDisabled then
			return true
		end
	elseif arg0.attachment == var0.AttachSupply and arg0.attachmentId <= 0 then
		return true
	elseif arg0.attachment == var0.AttachBox then
		local var0 = pg.box_data_template[arg0.attachmentId]

		assert(var0, "box_data_template not exist: " .. arg0.attachmentId)

		if var0.type == var0.BoxAirStrike or var0.type == var0.BoxTorpedo then
			return true
		elseif (var0.type == var0.BoxDrop or var0.type == var0.BoxStrategy or var0.type == var0.BoxEnemy or var0.type == var0.BoxSupply) and arg0.flag == ChapterConst.CellFlagDisabled then
			return true
		end
	elseif arg0.attachment == var0.AttachStory then
		if arg0.flag ~= ChapterConst.CellFlagActive and (arg0.flag ~= ChapterConst.CellFlagTriggerActive or arg0.data ~= var0.StoryObstacle) then
			return true
		end
	elseif arg0.attachment == var0.AttachBarrier then
		return true
	end

	return false
end

function var0.NeedClearStep(arg0)
	if arg0.attachment == var0.AttachAmbush and arg0.flag == ChapterConst.CellFlagAmbush then
		return true
	end

	if arg0.attachment == var0.AttachBox then
		local var0 = pg.box_data_template[arg0.attachmentId]

		assert(var0, "box_data_template not exist: " .. arg0.attachmentId)

		if var0.type == var0.BoxAirStrike then
			return true
		end
	end

	return false
end

var0.AchieveType1 = 1
var0.AchieveType2 = 2
var0.AchieveType3 = 3
var0.AchieveType4 = 4
var0.AchieveType5 = 5
var0.AchieveType6 = 6

function var0.IsAchieved(arg0)
	local var0 = false

	if arg0.type == var0.AchieveType4 or arg0.type == var0.AchieveType5 then
		var0 = arg0.count >= 1
	else
		var0 = arg0.count >= arg0.config
	end

	return var0
end

function var0.GetAchieveDesc(arg0, arg1)
	local var0 = false
	local var1 = _.detect(arg1.achieves, function(arg0)
		return arg0.type == arg0
	end)

	if var1.type == var0.AchieveType1 then
		return "Defeat flagship"
	elseif var1.type == var0.AchieveType2 then
		return string.format("Defeat escort fleet（%d/%d）", math.min(var1.count, var1.config), var1.config)
	elseif var1.type == var0.AchieveType3 then
		return "Defeat all enemies"
	elseif var1.type == var0.AchieveType4 then
		return string.format("Deployed ships≤ %d", var1.config)
	elseif var1.type == var0.AchieveType5 then
		return string.format("XX not deployed", ShipType.Type2Name(var1.config))
	elseif var1.type == var0.AchieveType6 then
		return "Clear with a Full Combo"
	end

	return var0
end

var0.OpRetreat = 0
var0.OpMove = 1
var0.OpBox = 2
var0.OpAmbush = 4
var0.OpStrategy = 5
var0.OpRepair = 6
var0.OpSupply = 7
var0.OpEnemyRound = 8
var0.OpSubState = 9
var0.OpStory = 10
var0.OpBarrier = 16
var0.OpSubTeleport = 19
var0.OpPreClear = 30
var0.OpRequest = 49
var0.OpSwitch = 98
var0.OpSkipBattle = 99
var0.DirtyAchieve = 1
var0.DirtyFleet = 2
var0.DirtyAttachment = 4
var0.DirtyStrategy = 8
var0.DirtyChampion = 16
var0.DirtyAutoAction = 32
var0.DirtyCellFlag = 64
var0.DirtyBase = 128
var0.DirtyChampionPosition = 256
var0.DirtyFloatItems = 512
var0.DirtyMapItems = 1024
var0.KizunaJammingEngage = 1
var0.KizunaJammingDodge = 2
var0.StatusDay = 3
var0.StatusNight = 4
var0.StatusAirportOutControl = 5
var0.StatusAirportUnderControl = 6
var0.StatusSunrise = 7
var0.StatusSunset = 8
var0.StatusMaze1 = 9
var0.StatusMaze2 = 10
var0.StatusMaze3 = 11
var0.StatusDPM_KASTHA_FOE = 12
var0.StatusDPM_KASTHA_FRIEND = 13
var0.StatusDPM_PANYIA_FOE = 14
var0.StatusDPM_PANYIA_FRIEND = 15
var0.StatusDPM_MRD_FOE = 16
var0.StatusDPM_MRD_FRIEND = 17
var0.StatusDPM_VITA_FOE = 18
var0.StatusDPM_VITA_FRIEND = 19
var0.StatusLIGHTHOUSEACTIVE = 20
var0.StatusSSSSSyberSquadSupportIdle = 21
var0.StatusSSSSSyberSquadSupportActive = 22
var0.StatusSSSSKaijuSupportIdle = 23
var0.StatusSSSSKaijuSupportActive = 24
var0.StatusMissile1 = 30
var0.StatusMissile2 = 31
var0.StatusMissile3 = 32
var0.StatusMissileInit = 33
var0.StatusMissile1B = 34
var0.StatusMissile2B = 35
var0.StatusMissile3B = 36
var0.StatusMissileInitB = 37
var0.StatusMaoxiv3 = 38
var0.StatusGonghai = 39
var0.StatusGonghai = 40
var0.StatusGonghai = 41
var0.StatusMusashiGame1 = 42
var0.StatusMusashiGame2 = 43
var0.StatusMusashiGame3 = 44
var0.StatusMusashiGame4 = 45
var0.StatusMusashiGame5 = 46
var0.StatusMusashiGame6 = 47
var0.StatusMusashiGame7 = 48
var0.StatusMusashiGame8 = 49
var0.StatusDefaultList = {
	0
}
var0.Status2Stg = setmetatable({}, {
	__index = function(arg0, arg1)
		local var0 = pg.chapter_status_effect[arg1]
		local var1 = var0 and var0.strategy or 0

		return var1 ~= 0 and var1 or nil
	end
})
var0.Buff2Stg = {}

local function var1(arg0, arg1)
	if arg1.buff_id == 0 then
		return
	end

	var0.Buff2Stg[arg1.buff_id] = arg0
end

for iter0, iter1 in ipairs(pg.strategy_data_template.all) do
	var1(iter1, pg.strategy_data_template[iter1])
end

var0.HpGreen = 3000

function var0.GetAmbushDisplay(arg0)
	local var0
	local var1

	if not arg0 then
		var0 = pg.gametip.ambush_display_0.tip
		var1 = Color.New(0.96078431372549, 0.376470588235294, 0.282352941176471)
	elseif arg0 <= 0 then
		var0 = pg.gametip.ambush_display_1.tip
		var1 = Color.New(0.662745098039216, 0.96078431372549, 0.282352941176471)
	elseif arg0 < 0.1 then
		var0 = pg.gametip.ambush_display_2.tip
		var1 = Color.New(0.662745098039216, 0.96078431372549, 0.282352941176471)
	elseif arg0 < 0.2 then
		var0 = pg.gametip.ambush_display_3.tip
		var1 = Color.New(0.662745098039216, 0.96078431372549, 0.282352941176471)
	elseif arg0 < 0.33 then
		var0 = pg.gametip.ambush_display_4.tip
		var1 = Color.New(0.984313725490196, 0.788235294117647, 0.215686274509804)
	elseif arg0 < 0.5 then
		var0 = pg.gametip.ambush_display_5.tip
		var1 = Color.New(0.96078431372549, 0.376470588235294, 0.282352941176471)
	else
		var0 = pg.gametip.ambush_display_6.tip
		var1 = Color.New(0.96078431372549, 0.376470588235294, 0.282352941176471)
	end

	return var0, var1
end

var0.ShipMoveAction = "move"
var0.ShipIdleAction = "normal"
var0.ShipSwimAction = "swim"
var0.ShipStepDuration = 0.5
var0.ShipStepQuickPlayScale = 0.5
var0.ShipMoveTailLength = 2

function var0.GetRepairParams()
	return 1, 3, 100
end

function var0.GetShamRepairParams()
	return 1, 3, 100
end

var0.AmmoRich = 4
var0.AmmoPoor = 0
var0.ExpeditionAILair = 6
var0.ExpeditionTypeMulBoss = 94
var0.ExpeditionTypeUnTouchable = 97
var0.ExpeditionTypeBoss = 99
var0.EnemySize = {
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
var0.EnemyPreference = {
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
var0.ShamMoneyItem = 59900
var0.MarkHuntingRange = 1
var0.MarkBomb = 2
var0.MarkCoastalGun = 3
var0.MarkEscapeGrid = 4
var0.MarkBanaiAirStrike = 5
var0.MarkMovePathArrow = 6
var0.MarkLava = 7
var0.MarkHideNight = 8
var0.MarkNightMare = 9
var0.ReasonVictory = 1
var0.ReasonDefeat = 2
var0.ReasonVictoryOni = 3
var0.ReasonDefeatOni = 4
var0.ReasonDefeatBomb = 5
var0.ReasonOutTime = 8
var0.ReasonActivityOutTime = 9
var0.ReasonDefeatDefense = 10
var0.ForbiddenNone = 0
var0.ForbiddenRight = 1
var0.ForbiddenLeft = 2
var0.ForbiddenDown = 4
var0.ForbiddenUp = 8
var0.ForbiddenRow = 3
var0.ForbiddenColumn = 12
var0.ForbiddenAll = 15
var0.PriorityPerRow = 100
var0.PriorityMin = -10000
var0.CellPriorityNone = 0 + var0.PriorityMin
var0.CellPriorityAttachment = 1 + var0.PriorityMin
var0.CellPriorityLittle = 2 + var0.PriorityMin
var0.CellPriorityEnemy = 3 + var0.PriorityMin
var0.CellPriorityFleet = 3 + var0.PriorityMin
var0.CellPriorityUpperEffect = 5 + var0.PriorityMin
var0.CellPriorityTopMark = 6 + var0.PriorityMin
var0.PriorityMax = 10000 + var0.PriorityMin
var0.LayerWeightMap = -999
var0.LayerWeightMapAnimation = var0.LayerWeightMap + 1
var0.TemplateChampion = "tpl_champion"
var0.TemplateEnemy = "tpl_enemy"
var0.TemplateOni = "tpl_oni"
var0.TemplateFleet = "tpl_ship"
var0.TemplateSub = "tpl_sub"
var0.TemplateTransport = "tpl_transport"
var0.AirDominanceStrategyBuffType = 1001
var0.AirDominance = {
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

function var0.IsAtelierMap(arg0)
	return arg0:getConfig("on_activity") == ActivityConst.RYZA_MAP_ACT_ID
end

var0.AUTOFIGHT_STOP_REASON = {
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

return var0
