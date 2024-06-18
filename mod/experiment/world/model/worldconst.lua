local var0_0 = class("WorldConst")

var0_0.Debug = false

function var0_0.Print(...)
	if var0_0.Debug then
		warning(...)
	end
end

function var0_0.DebugPrintAttachmentCell(arg0_2, arg1_2)
	if not var0_0.Debug then
		return
	end

	warning(arg0_2)

	for iter0_2, iter1_2 in pairs(arg1_2) do
		warning(iter0_2, #iter1_2.attachmentList)

		for iter2_2, iter3_2 in ipairs(iter1_2.attachmentList) do
			warning(iter3_2:DebugPrint())
		end
	end
end

var0_0.DefaultAtlas = 1

function var0_0.GetProgressAtlas(arg0_3)
	return var0_0.DefaultAtlas
end

var0_0.MaxRow = 30
var0_0.MaxColumn = 30
var0_0.LineCross = 2
var0_0.ActionIdle = "normal"
var0_0.ActionMove = "move"
var0_0.ActionDrag = "tuozhuai"
var0_0.ActionYun = "yun"
var0_0.ActionVanish = "vanish"
var0_0.ActionAppear = "appear"
var0_0.AutoFightLoopCountLimit = 25
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
	[99] = 99
}
var0_0.ResourceID = 3002
var0_0.SwitchPlainingItemId = 120
var0_0.ReqName = {
	"OpReqMoveFleet",
	"OpReqBox",
	nil,
	nil,
	nil,
	nil,
	nil,
	"OpReqRound",
	"OpReqSub",
	"OpReqEvent",
	nil,
	"OpReqDiscover",
	"OpReqTransport",
	"OpReqRetreat",
	nil,
	nil,
	nil,
	"OpReqTask",
	nil,
	"OpReqMaintenance",
	"OpReqVision",
	nil,
	"OpReqRedeploy",
	nil,
	"OpReqPressingMap",
	"OpReqJumpOut",
	"OpReqEnterPort",
	"OpReqCatSalvage",
	"OpReqSwitchFleet",
	[99] = "OpReqSkipBattle"
}

for iter0_0, iter1_0 in pairs(var0_0.ReqName) do
	var0_0[iter1_0] = iter0_0
end

var0_0.OpActionFleetMove = -100
var0_0.OpActionAttachmentMove = -101
var0_0.OpActionAttachmentAnim = -102
var0_0.OpActionNextRound = -103
var0_0.OpActionEventOp = -104
var0_0.OpActionMoveStep = -105
var0_0.OpActionUpdate = -106
var0_0.OpActionFleetAnim = -107
var0_0.OpActionEventEffect = -108
var0_0.OpActionTaskGoto = -109
var0_0.OpActionCameraMove = -110
var0_0.OpActionTrapGravityAnim = -111
var0_0.RoundPlayer = 0
var0_0.RoundElse = 1
var0_0.DirNone = 0
var0_0.DirUp = 1
var0_0.DirRight = 2
var0_0.DirDown = 3
var0_0.DirLeft = 4

function var0_0.DirToLine(arg0_4)
	if arg0_4 == var0_0.DirNone then
		return {
			row = 0,
			column = 0
		}
	elseif arg0_4 == var0_0.DirUp then
		return {
			row = -1,
			column = 0
		}
	elseif arg0_4 == var0_0.DirRight then
		return {
			row = 0,
			column = 1
		}
	elseif arg0_4 == var0_0.DirDown then
		return {
			row = 1,
			column = 0
		}
	elseif arg0_4 == var0_0.DirLeft then
		return {
			row = 0,
			column = -1
		}
	else
		assert(false, "without this dir " .. arg0_4)
	end
end

var0_0.DefaultMapOffset = Vector3(0, -1000, -1000)

function var0_0.InFOVRange(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg4_5 = arg4_5 or var0_0.GetFOVRadius()

	return (arg0_5 - arg2_5) * (arg0_5 - arg2_5) + (arg1_5 - arg3_5) * (arg1_5 - arg3_5) <= arg4_5 * arg4_5
end

function var0_0.GetFOVRadius()
	return pg.gameset.world_move_initial_view.key_value
end

function var0_0.IsRookieMap(arg0_7)
	return _.any(pg.gameset.world_guide_map_list.description, function(arg0_8)
		return arg0_7 == arg0_8
	end)
end

function var0_0.GetRealmRookieId(arg0_9)
	assert(arg0_9 and arg0_9 > 0)

	return unpack(pg.gameset.world_default_entrance.description[arg0_9])
end

function var0_0.ParseConfigDir(arg0_10, arg1_10)
	if arg0_10 == -1 then
		return WorldConst.DirUp
	elseif arg0_10 == 1 then
		return WorldConst.DirDown
	elseif arg1_10 == -1 then
		return WorldConst.DirLeft
	elseif arg1_10 == 1 then
		return WorldConst.DirRight
	end

	assert(false)
end

function var0_0.Pos2FogRes(arg0_11, arg1_11)
	arg0_11 = arg0_11 % 3
	arg1_11 = arg1_11 % 3

	return "miwu0" .. arg0_11 * 3 + arg1_11 + 1
end

var0_0.TerrainStreamRes = {
	"yangliu_shang",
	"yangliu_you",
	"yangliu_xia",
	"yangliu_zuo"
}
var0_0.TerrainWindRes = {
	"longjuanfeng_shang",
	"longjuanfeng_you",
	"longjuanfeng_xia",
	"longjuanfeng_zuo"
}
var0_0.TerrainPoisonRes = {
	"poison01",
	"poison02"
}

function var0_0.GetTerrainEffectRes(arg0_12, arg1_12, arg2_12)
	if arg0_12 == WorldMapCell.TerrainStream then
		local var0_12 = var0_0.TerrainStreamRes[arg1_12]

		return "world/object/" .. var0_12, var0_12
	elseif arg0_12 == WorldMapCell.TerrainWind then
		local var1_12 = var0_0.TerrainWindRes[arg1_12]

		return "world/object/" .. var1_12, var1_12
	elseif arg0_12 == WorldMapCell.TerrainIce then
		return "world/object/ice", "ice"
	elseif arg0_12 == WorldMapCell.TerrainPoison then
		local var2_12 = var0_0.TerrainPoisonRes[arg2_12]

		return "world/object/" .. var2_12, var2_12
	end

	assert(false)
end

function var0_0.GetWindEffect()
	return "world/object/longjuanfeng", "longjuanfeng"
end

function var0_0.GetBuffEffect(arg0_14)
	return "ui/" .. arg0_14, arg0_14
end

var0_0.PoisonEffect = "san_low"

function var0_0.ArrayEffectOrder(arg0_15, arg1_15)
	local var0_15 = {}
	local var1_15 = arg0_15:GetComponentsInChildren(typeof(Renderer), true)

	for iter0_15 = 0, var1_15.Length - 1 do
		table.insert(var0_15, var1_15[iter0_15])
	end

	local var2_15 = arg0_15:GetComponentsInChildren(typeof(Canvas), true)

	for iter1_15 = 0, var2_15.Length - 1 do
		table.insert(var0_15, var2_15[iter1_15])
	end

	for iter2_15, iter3_15 in ipairs(var0_15) do
		iter3_15.sortingOrder = iter3_15.sortingOrder + arg1_15
	end
end

var0_0.Flag16Max = 65535
var0_0.LOEffectA = 1
var0_0.LOQuad = 1000
var0_0.LOEffectB = 1001
var0_0.LOItem = 2000
var0_0.LOEffectC = 2001
var0_0.LOCell = 3000
var0_0.LOFleet = 3001
var0_0.LOTop = 4000
var0_0.WindScale = {
	0.5,
	0.5,
	0.75,
	0.75,
	1
}

function var0_0.GetWindScale(arg0_16)
	local var0_16 = arg0_16 and var0_0.WindScale[arg0_16] or 1

	return Vector3(var0_16, var0_16, var0_16)
end

var0_0.BaseMoveDuration = 0.35

function var0_0.GetTerrainMoveStepDuration(arg0_17)
	var0_0.MoveStepDuration = var0_0.MoveStepDuration or {
		[WorldMapCell.TerrainNone] = var0_0.BaseMoveDuration,
		[WorldMapCell.TerrainWind] = var0_0.BaseMoveDuration / 2,
		[WorldMapCell.TerrainStream] = var0_0.BaseMoveDuration / 2,
		[WorldMapCell.TerrainIce] = var0_0.BaseMoveDuration / 2,
		[WorldMapCell.TerrainFog] = var0_0.BaseMoveDuration,
		[WorldMapCell.TerrainFire] = var0_0.BaseMoveDuration,
		[WorldMapCell.TerrainPoison] = var0_0.BaseMoveDuration
	}

	return var0_0.MoveStepDuration[arg0_17]
end

var0_0.UIEaseDuration = 0.5
var0_0.UIEaseFasterDuration = 0.3
var0_0.ModelSpine = 1
var0_0.ModelPrefab = 2
var0_0.ResBoxPrefab = "boxprefab/"
var0_0.ResChapterPrefab = "chapter/"
var0_0.DirType1 = 1
var0_0.DirType2 = 2
var0_0.DirType4 = 4

function var0_0.CalcModelPosition(arg0_18, arg1_18)
	return Vector3((arg0_18.config.area_pos[1] - arg1_18.x / 2) / PIXEL_PER_UNIT, 0, (arg0_18.config.area_pos[2] - arg1_18.y / 2) / PIXEL_PER_UNIT)
end

var0_0.BrokenBuffId = pg.gameset.world_death_buff.key_value
var0_0.MoveLimitBuffId = pg.gameset.world_move_buff_desc.key_value
var0_0.DamageBuffList = pg.gameset.world_buff_morale.description

function var0_0.ExtendPropertiesRatesFromBuffList(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg1_19) do
		assert(iter1_19.class == WorldBuff)

		if iter1_19:IsValid() then
			for iter2_19, iter3_19 in ipairs(iter1_19.config.buff_attr) do
				assert(iter1_19.config.percent[iter2_19] == 1)

				arg0_19[iter3_19] = defaultValue(arg0_19[iter3_19], 1) * (10000 + iter1_19.config.buff_effect[iter2_19] * iter1_19:GetFloor()) / 10000
			end
		end
	end
end

function var0_0.AppendPropertiesFromBuffList(arg0_20, arg1_20, arg2_20)
	for iter0_20, iter1_20 in ipairs(arg2_20) do
		assert(iter1_20.class == WorldBuff)

		if iter1_20:IsValid() then
			for iter2_20, iter3_20 in ipairs(iter1_20.config.buff_attr) do
				if iter1_20.config.percent[iter2_20] == 1 then
					arg1_20[iter3_20] = defaultValue(arg1_20[iter3_20], 0) + iter1_20.config.buff_effect[iter2_20] * iter1_20:GetFloor()
				else
					arg0_20[iter3_20] = defaultValue(arg0_20[iter3_20], 0) + iter1_20.config.buff_effect[iter2_20] * iter1_20:GetFloor()
				end
			end
		end
	end

	for iter4_20, iter5_20 in pairs(arg1_20) do
		arg1_20[iter4_20] = 1 + iter5_20 / 10000
	end
end

var0_0.TaskTypeSubmitItem = 2
var0_0.TaskTypeArrivePort = 6
var0_0.TaskTypeFleetExpansion = 7
var0_0.TaskTypePressingMap = 12
var0_0.FleetRedeploy = 1
var0_0.FleetExpansion = 2
var0_0.QuadBlinkDuration = 1
var0_0.QuadSpriteWhite = "cell_white"
var0_0.TransportDisplayNormal = 0
var0_0.TransportDisplayGuideEnable = 1
var0_0.TransportDisplayGuideDanger = 2
var0_0.TransportDisplayGuideForbid = 3

function var0_0.CalcRelativeRectPos(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg2_21.x + arg1_21.width / 2
	local var1_21 = arg2_21.x + arg2_21.width - arg1_21.width / 2
	local var2_21 = arg2_21.y + arg1_21.height / 2
	local var3_21 = arg2_21.y + arg2_21.height - arg1_21.height / 2

	local function var4_21(arg0_22)
		return arg0_22.x >= var0_21 and arg0_22.x <= var1_21 and arg0_22.y >= var2_21 and arg0_22.y <= var3_21
	end

	local var5_21 = 10
	local var6_21 = Quaternion.Euler(0, 0, var5_21)

	for iter0_21 = arg3_21, 0, -50 do
		local var7_21 = Vector3(iter0_21, 0, 0)

		for iter1_21 = 360 / var5_21, 1, -1 do
			var7_21 = var6_21 * var7_21

			if var4_21(arg0_21 + var7_21) then
				return arg0_21 + var7_21
			end
		end
	end

	return _.min({
		Vector2(var0_21, var2_21),
		Vector2(var0_21, var3_21),
		Vector2(var1_21, var3_21),
		Vector2(var1_21, var2_21)
	}, function(arg0_23)
		return Vector2.Distance(arg0_23, arg0_21)
	end)
end

function var0_0.GetMapIconState(arg0_24)
	if arg0_24 == 1 then
		return "normal"
	elseif arg0_24 == 2 then
		return "danger"
	elseif arg0_24 == 3 then
		return "danger"
	else
		assert(false, "config error:" .. arg0_24)
	end
end

function var0_0.HasDangerConfirm(arg0_25)
	if arg0_25 == 1 then
		return false
	elseif arg0_25 == 2 then
		return false
	elseif arg0_25 == 3 then
		return true
	else
		assert(false, "config error:" .. arg0_25)
	end
end

var0_0.SystemCompass = 1
var0_0.SystemMemo = 2
var0_0.SystemInventory = 3
var0_0.SystemWorldBoss = 4
var0_0.SystemCollection = 5
var0_0.SystemSubmarine = 6
var0_0.SystemFleetDetail = 7
var0_0.SystemWorldInfo = 8
var0_0.SystemRedeploy = 9
var0_0.SystemScanner = 10
var0_0.SystemResource = 11
var0_0.SystemOutMap = 12
var0_0.SystemOrderRedeploy = var0_0.SystemRedeploy
var0_0.SystemOrderMaintenance = 13
var0_0.SystemOrderFOV = 15
var0_0.SystemOrderSubmarine = var0_0.SystemSubmarine
var0_0.SystemResetCountDown = 16
var0_0.SystemResetExchange = 17
var0_0.SystemResetShop = 18
var0_0.SystemAutoFight_1 = 19
var0_0.SystemAutoFight_2 = 20
var0_0.SystemAutoSwitch = 21
var0_0.SystemDailyTask = 22

function var0_0.BuildHelpTips(arg0_26)
	local var0_26 = i18n("world_stage_help")
	local var1_26 = pg.gameset.world_stage_help.description
	local var2_26 = 1

	for iter0_26, iter1_26 in ipairs(var1_26) do
		if arg0_26 >= iter1_26[1] then
			table.insert(var0_26, var2_26, {
				icon = {
					path = "",
					atlas = iter1_26[2]
				}
			})

			var2_26 = var2_26 + 1
		end
	end

	return var0_26
end

var0_0.AnimRadar = "RadarEffectUI"

function var0_0.FindStageTemplates(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(pg.world_stage_template.all) do
		local var1_27 = pg.world_stage_template[iter1_27]

		if var1_27.stage_key == arg0_27 then
			table.insert(var0_27, var1_27)
		end
	end

	return var0_27
end

function var0_0.GetRookieBattleLoseStory()
	return pg.gameset.world_story_special_2.description[1]
end

var0_0.FOVMapSight = 1
var0_0.FOVEventEffect = 2
var0_0.GuideEnemyEnd = false

function var0_0.IsWorldGuideEnemyId(arg0_29)
	if var0_0.GuideEnemyEnd then
		return false
	end

	local var0_29 = pg.gameset.world_guide_enemy_id.description

	return table.contains(var0_29, arg0_29)
end

function var0_0.WorldLevelCorrect(arg0_30, arg1_30)
	for iter0_30, iter1_30 in ipairs(pg.gameset.world_expedition_level.description) do
		for iter2_30, iter3_30 in ipairs(iter1_30[1]) do
			if arg1_30 == iter3_30 then
				arg0_30 = arg0_30 + iter1_30[2]
			end
		end
	end

	return math.max(arg0_30, 1)
end

function var0_0.GetAreaFocusPos(arg0_31)
	local var0_31 = pg.world_regions_data[arg0_31].regions_pos

	return Vector2(var0_31[1], var0_31[2])
end

function var0_0.GetTransportBlockEvent()
	if not var0_0.blockEventDic then
		var0_0.blockEventDic = {}

		for iter0_32, iter1_32 in ipairs(pg.gameset.world_movelimit_event.description) do
			var0_0.blockEventDic[iter1_32] = true
		end
	end

	return var0_0.blockEventDic
end

function var0_0.GetTransportStoryEvent()
	if not var0_0.blockStoryDic then
		var0_0.blockStoryDic = {}

		for iter0_33, iter1_33 in ipairs(pg.gameset.world_transfer_eventlist.description) do
			var0_0.blockStoryDic[iter1_33] = true
		end
	end

	return var0_0.blockStoryDic
end

function var0_0.IsWorldHelpNew(arg0_34, arg1_34)
	if arg1_34 then
		PlayerPrefs.SetInt("world_help_progress", arg0_34)
		PlayerPrefs.Save()

		return false
	else
		local var0_34 = PlayerPrefs.HasKey("world_help_progress") and PlayerPrefs.GetInt("world_help_progress") or 0

		if var0_34 < arg0_34 then
			for iter0_34, iter1_34 in ipairs(pg.world_help_data.all) do
				local var1_34 = pg.world_help_data[iter1_34]

				if arg0_34 >= var1_34.stage then
					if var0_34 < var1_34.stage then
						return true
					else
						for iter2_34, iter3_34 in ipairs(var1_34.stage_help) do
							if var0_34 < iter3_34[1] and arg0_34 >= iter3_34[1] then
								return true
							end
						end
					end
				end
			end
		end

		return false
	end
end

function var0_0.ParsingBuffs(arg0_35)
	local var0_35 = {}

	_.each(arg0_35, function(arg0_36)
		local var0_36 = WorldBuff.New()

		var0_36:Setup({
			id = arg0_36.id,
			floor = arg0_36.stack,
			round = arg0_36.round,
			step = arg0_36.step
		})

		var0_35[var0_36.id] = var0_36
	end)

	return var0_35
end

function var0_0.CompareBuffs(arg0_37, arg1_37)
	local var0_37 = _.extend({}, arg0_37)
	local var1_37 = {}
	local var2_37 = _.extend({}, arg1_37)

	for iter0_37, iter1_37 in pairs(var0_37) do
		if var2_37[iter0_37] then
			var1_37[iter0_37] = var0_37[iter0_37]
			var0_37[iter0_37] = nil
			var2_37[iter0_37] = nil
		end
	end

	return {
		remove = var0_37,
		continue = var1_37,
		add = var2_37
	}
end

function var0_0.FetchWorldShip(arg0_38)
	local var0_38 = nowWorld():GetShip(arg0_38)

	assert(var0_38, "world ship not exist: " .. arg0_38)

	return var0_38
end

function var0_0.FetchShipVO(arg0_39)
	local var0_39 = getProxy(BayProxy):getShipById(arg0_39)

	assert(var0_39, "ship not exist: " .. arg0_39)

	return var0_39
end

function var0_0.FetchRawShipVO(arg0_40)
	local var0_40 = getProxy(BayProxy):getRawData()[arg0_40]

	assert(var0_40, "ship not exist: " .. arg0_40)

	return var0_40
end

function var0_0.ReqWorldCheck(arg0_41)
	local var0_41 = {}

	if nowWorld().type == World.TypeBase then
		table.insert(var0_41, function(arg0_42)
			pg.ConnectionMgr.GetInstance():Send(33000, {
				type = 0
			}, 33001, function(arg0_43)
				local var0_43 = getProxy(WorldProxy)

				var0_43:BuildWorld(World.TypeFull)
				var0_43:NetFullUpdate(arg0_43)
				arg0_42()
			end)
		end)
	end

	seriesAsync(var0_41, arg0_41)
end

function var0_0.ReqWorldForServer()
	pg.ConnectionMgr.GetInstance():Send(33000, {
		type = 1
	}, 33001, function(arg0_45)
		return
	end)
end

var0_0.ObstacleConfig = {
	[0] = 2,
	3,
	7,
	0,
	6,
	1,
	4,
	5
}
var0_0.ObstacleType = {
	"leave",
	"arrive",
	"pass"
}

function var0_0.GetObstacleKey(arg0_46)
	return bit.lshift(1, #var0_0.ObstacleType - table.indexof(var0_0.ObstacleType, arg0_46))
end

function var0_0.GetObstacleConfig(arg0_47, arg1_47)
	local var0_47 = var0_0.GetObstacleKey(arg1_47)

	return bit.band(var0_0.ObstacleConfig[arg0_47], var0_47) > 0
end

function var0_0.RangeCheck(arg0_48, arg1_48, arg2_48)
	for iter0_48 = arg0_48.row - arg1_48, arg0_48.row + arg1_48 do
		for iter1_48 = arg0_48.column - arg1_48, arg0_48.column + arg1_48 do
			if var0_0.InFOVRange(arg0_48.row, arg0_48.column, iter0_48, iter1_48, arg1_48) then
				arg2_48(iter0_48, iter1_48)
			end
		end
	end
end

function var0_0.CheckWorldStorySkip(arg0_49)
	return table.contains(pg.gameset.world_quickmode_skiplua.description, arg0_49) and getProxy(SettingsProxy):GetWorldFlag("story_tips") and pg.NewStoryMgr.GetInstance():IsPlayed(arg0_49)
end

function var0_0.GetNShopTimeStamp()
	if not var0_0.nShopTimestamp then
		local var0_50 = {}

		var0_50.year, var0_50.month, var0_50.day = unpack(getGameset("world_newshop_date")[2])
		var0_50.hour, var0_50.min, var0_50.sec = 0, 0, 0
		var0_0.nShopTimestamp = pg.TimeMgr.GetInstance():Table2ServerTime(var0_50)
	end

	return var0_0.nShopTimestamp
end

return var0_0
