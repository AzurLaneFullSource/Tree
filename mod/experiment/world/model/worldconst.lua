local var0 = class("WorldConst")

var0.Debug = false

function var0.Print(...)
	if var0.Debug then
		warning(...)
	end
end

function var0.DebugPrintAttachmentCell(arg0, arg1)
	if not var0.Debug then
		return
	end

	warning(arg0)

	for iter0, iter1 in pairs(arg1) do
		warning(iter0, #iter1.attachmentList)

		for iter2, iter3 in ipairs(iter1.attachmentList) do
			warning(iter3:DebugPrint())
		end
	end
end

var0.DefaultAtlas = 1

function var0.GetProgressAtlas(arg0)
	return var0.DefaultAtlas
end

var0.MaxRow = 30
var0.MaxColumn = 30
var0.LineCross = 2
var0.ActionIdle = "normal"
var0.ActionMove = "move"
var0.ActionDrag = "tuozhuai"
var0.ActionYun = "yun"
var0.ActionVanish = "vanish"
var0.ActionAppear = "appear"
var0.AutoFightLoopCountLimit = 25
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
	[99] = 99
}
var0.ResourceID = 3002
var0.SwitchPlainingItemId = 120
var0.ReqName = {
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

for iter0, iter1 in pairs(var0.ReqName) do
	var0[iter1] = iter0
end

var0.OpActionFleetMove = -100
var0.OpActionAttachmentMove = -101
var0.OpActionAttachmentAnim = -102
var0.OpActionNextRound = -103
var0.OpActionEventOp = -104
var0.OpActionMoveStep = -105
var0.OpActionUpdate = -106
var0.OpActionFleetAnim = -107
var0.OpActionEventEffect = -108
var0.OpActionTaskGoto = -109
var0.OpActionCameraMove = -110
var0.OpActionTrapGravityAnim = -111
var0.RoundPlayer = 0
var0.RoundElse = 1
var0.DirNone = 0
var0.DirUp = 1
var0.DirRight = 2
var0.DirDown = 3
var0.DirLeft = 4

function var0.DirToLine(arg0)
	if arg0 == var0.DirNone then
		return {
			row = 0,
			column = 0
		}
	elseif arg0 == var0.DirUp then
		return {
			row = -1,
			column = 0
		}
	elseif arg0 == var0.DirRight then
		return {
			row = 0,
			column = 1
		}
	elseif arg0 == var0.DirDown then
		return {
			row = 1,
			column = 0
		}
	elseif arg0 == var0.DirLeft then
		return {
			row = 0,
			column = -1
		}
	else
		assert(false, "without this dir " .. arg0)
	end
end

var0.DefaultMapOffset = Vector3(0, -1000, -1000)

function var0.InFOVRange(arg0, arg1, arg2, arg3, arg4)
	arg4 = arg4 or var0.GetFOVRadius()

	return (arg0 - arg2) * (arg0 - arg2) + (arg1 - arg3) * (arg1 - arg3) <= arg4 * arg4
end

function var0.GetFOVRadius()
	return pg.gameset.world_move_initial_view.key_value
end

function var0.IsRookieMap(arg0)
	return _.any(pg.gameset.world_guide_map_list.description, function(arg0)
		return arg0 == arg0
	end)
end

function var0.GetRealmRookieId(arg0)
	assert(arg0 and arg0 > 0)

	return unpack(pg.gameset.world_default_entrance.description[arg0])
end

function var0.ParseConfigDir(arg0, arg1)
	if arg0 == -1 then
		return WorldConst.DirUp
	elseif arg0 == 1 then
		return WorldConst.DirDown
	elseif arg1 == -1 then
		return WorldConst.DirLeft
	elseif arg1 == 1 then
		return WorldConst.DirRight
	end

	assert(false)
end

function var0.Pos2FogRes(arg0, arg1)
	arg0 = arg0 % 3
	arg1 = arg1 % 3

	return "miwu0" .. arg0 * 3 + arg1 + 1
end

var0.TerrainStreamRes = {
	"yangliu_shang",
	"yangliu_you",
	"yangliu_xia",
	"yangliu_zuo"
}
var0.TerrainWindRes = {
	"longjuanfeng_shang",
	"longjuanfeng_you",
	"longjuanfeng_xia",
	"longjuanfeng_zuo"
}
var0.TerrainPoisonRes = {
	"poison01",
	"poison02"
}

function var0.GetTerrainEffectRes(arg0, arg1, arg2)
	if arg0 == WorldMapCell.TerrainStream then
		local var0 = var0.TerrainStreamRes[arg1]

		return "world/object/" .. var0, var0
	elseif arg0 == WorldMapCell.TerrainWind then
		local var1 = var0.TerrainWindRes[arg1]

		return "world/object/" .. var1, var1
	elseif arg0 == WorldMapCell.TerrainIce then
		return "world/object/ice", "ice"
	elseif arg0 == WorldMapCell.TerrainPoison then
		local var2 = var0.TerrainPoisonRes[arg2]

		return "world/object/" .. var2, var2
	end

	assert(false)
end

function var0.GetWindEffect()
	return "world/object/longjuanfeng", "longjuanfeng"
end

function var0.GetBuffEffect(arg0)
	return "ui/" .. arg0, arg0
end

var0.PoisonEffect = "san_low"

function var0.ArrayEffectOrder(arg0, arg1)
	local var0 = {}
	local var1 = arg0:GetComponentsInChildren(typeof(Renderer), true)

	for iter0 = 0, var1.Length - 1 do
		table.insert(var0, var1[iter0])
	end

	local var2 = arg0:GetComponentsInChildren(typeof(Canvas), true)

	for iter1 = 0, var2.Length - 1 do
		table.insert(var0, var2[iter1])
	end

	for iter2, iter3 in ipairs(var0) do
		iter3.sortingOrder = iter3.sortingOrder + arg1
	end
end

var0.Flag16Max = 65535
var0.LOEffectA = 1
var0.LOQuad = 1000
var0.LOEffectB = 1001
var0.LOItem = 2000
var0.LOEffectC = 2001
var0.LOCell = 3000
var0.LOFleet = 3001
var0.LOTop = 4000
var0.WindScale = {
	0.5,
	0.5,
	0.75,
	0.75,
	1
}

function var0.GetWindScale(arg0)
	local var0 = arg0 and var0.WindScale[arg0] or 1

	return Vector3(var0, var0, var0)
end

var0.BaseMoveDuration = 0.35

function var0.GetTerrainMoveStepDuration(arg0)
	var0.MoveStepDuration = var0.MoveStepDuration or {
		[WorldMapCell.TerrainNone] = var0.BaseMoveDuration,
		[WorldMapCell.TerrainWind] = var0.BaseMoveDuration / 2,
		[WorldMapCell.TerrainStream] = var0.BaseMoveDuration / 2,
		[WorldMapCell.TerrainIce] = var0.BaseMoveDuration / 2,
		[WorldMapCell.TerrainFog] = var0.BaseMoveDuration,
		[WorldMapCell.TerrainFire] = var0.BaseMoveDuration,
		[WorldMapCell.TerrainPoison] = var0.BaseMoveDuration
	}

	return var0.MoveStepDuration[arg0]
end

var0.UIEaseDuration = 0.5
var0.UIEaseFasterDuration = 0.3
var0.ModelSpine = 1
var0.ModelPrefab = 2
var0.ResBoxPrefab = "boxprefab/"
var0.ResChapterPrefab = "chapter/"
var0.DirType1 = 1
var0.DirType2 = 2
var0.DirType4 = 4

function var0.CalcModelPosition(arg0, arg1)
	return Vector3((arg0.config.area_pos[1] - arg1.x / 2) / PIXEL_PER_UNIT, 0, (arg0.config.area_pos[2] - arg1.y / 2) / PIXEL_PER_UNIT)
end

var0.BrokenBuffId = pg.gameset.world_death_buff.key_value
var0.MoveLimitBuffId = pg.gameset.world_move_buff_desc.key_value
var0.DamageBuffList = pg.gameset.world_buff_morale.description

function var0.ExtendPropertiesRatesFromBuffList(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		assert(iter1.class == WorldBuff)

		if iter1:IsValid() then
			for iter2, iter3 in ipairs(iter1.config.buff_attr) do
				assert(iter1.config.percent[iter2] == 1)

				arg0[iter3] = defaultValue(arg0[iter3], 1) * (10000 + iter1.config.buff_effect[iter2] * iter1:GetFloor()) / 10000
			end
		end
	end
end

function var0.AppendPropertiesFromBuffList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		assert(iter1.class == WorldBuff)

		if iter1:IsValid() then
			for iter2, iter3 in ipairs(iter1.config.buff_attr) do
				if iter1.config.percent[iter2] == 1 then
					arg1[iter3] = defaultValue(arg1[iter3], 0) + iter1.config.buff_effect[iter2] * iter1:GetFloor()
				else
					arg0[iter3] = defaultValue(arg0[iter3], 0) + iter1.config.buff_effect[iter2] * iter1:GetFloor()
				end
			end
		end
	end

	for iter4, iter5 in pairs(arg1) do
		arg1[iter4] = 1 + iter5 / 10000
	end
end

var0.TaskTypeSubmitItem = 2
var0.TaskTypeArrivePort = 6
var0.TaskTypeFleetExpansion = 7
var0.TaskTypePressingMap = 12
var0.FleetRedeploy = 1
var0.FleetExpansion = 2
var0.QuadBlinkDuration = 1
var0.QuadSpriteWhite = "cell_white"
var0.TransportDisplayNormal = 0
var0.TransportDisplayGuideEnable = 1
var0.TransportDisplayGuideDanger = 2
var0.TransportDisplayGuideForbid = 3

function var0.CalcRelativeRectPos(arg0, arg1, arg2, arg3)
	local var0 = arg2.x + arg1.width / 2
	local var1 = arg2.x + arg2.width - arg1.width / 2
	local var2 = arg2.y + arg1.height / 2
	local var3 = arg2.y + arg2.height - arg1.height / 2

	local function var4(arg0)
		return arg0.x >= var0 and arg0.x <= var1 and arg0.y >= var2 and arg0.y <= var3
	end

	local var5 = 10
	local var6 = Quaternion.Euler(0, 0, var5)

	for iter0 = arg3, 0, -50 do
		local var7 = Vector3(iter0, 0, 0)

		for iter1 = 360 / var5, 1, -1 do
			var7 = var6 * var7

			if var4(arg0 + var7) then
				return arg0 + var7
			end
		end
	end

	return _.min({
		Vector2(var0, var2),
		Vector2(var0, var3),
		Vector2(var1, var3),
		Vector2(var1, var2)
	}, function(arg0)
		return Vector2.Distance(arg0, arg0)
	end)
end

function var0.GetMapIconState(arg0)
	if arg0 == 1 then
		return "normal"
	elseif arg0 == 2 then
		return "danger"
	elseif arg0 == 3 then
		return "danger"
	else
		assert(false, "config error:" .. arg0)
	end
end

function var0.HasDangerConfirm(arg0)
	if arg0 == 1 then
		return false
	elseif arg0 == 2 then
		return false
	elseif arg0 == 3 then
		return true
	else
		assert(false, "config error:" .. arg0)
	end
end

var0.SystemCompass = 1
var0.SystemMemo = 2
var0.SystemInventory = 3
var0.SystemWorldBoss = 4
var0.SystemCollection = 5
var0.SystemSubmarine = 6
var0.SystemFleetDetail = 7
var0.SystemWorldInfo = 8
var0.SystemRedeploy = 9
var0.SystemScanner = 10
var0.SystemResource = 11
var0.SystemOutMap = 12
var0.SystemOrderRedeploy = var0.SystemRedeploy
var0.SystemOrderMaintenance = 13
var0.SystemOrderFOV = 15
var0.SystemOrderSubmarine = var0.SystemSubmarine
var0.SystemResetCountDown = 16
var0.SystemResetExchange = 17
var0.SystemResetShop = 18
var0.SystemAutoFight_1 = 19
var0.SystemAutoFight_2 = 20
var0.SystemAutoSwitch = 21
var0.SystemDailyTask = 22

function var0.BuildHelpTips(arg0)
	local var0 = i18n("world_stage_help")
	local var1 = pg.gameset.world_stage_help.description
	local var2 = 1

	for iter0, iter1 in ipairs(var1) do
		if arg0 >= iter1[1] then
			table.insert(var0, var2, {
				icon = {
					path = "",
					atlas = iter1[2]
				}
			})

			var2 = var2 + 1
		end
	end

	return var0
end

var0.AnimRadar = "RadarEffectUI"

function var0.FindStageTemplates(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.world_stage_template.all) do
		local var1 = pg.world_stage_template[iter1]

		if var1.stage_key == arg0 then
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.GetRookieBattleLoseStory()
	return pg.gameset.world_story_special_2.description[1]
end

var0.FOVMapSight = 1
var0.FOVEventEffect = 2
var0.GuideEnemyEnd = false

function var0.IsWorldGuideEnemyId(arg0)
	if var0.GuideEnemyEnd then
		return false
	end

	local var0 = pg.gameset.world_guide_enemy_id.description

	return table.contains(var0, arg0)
end

function var0.WorldLevelCorrect(arg0, arg1)
	for iter0, iter1 in ipairs(pg.gameset.world_expedition_level.description) do
		for iter2, iter3 in ipairs(iter1[1]) do
			if arg1 == iter3 then
				arg0 = arg0 + iter1[2]
			end
		end
	end

	return math.max(arg0, 1)
end

function var0.GetAreaFocusPos(arg0)
	local var0 = pg.world_regions_data[arg0].regions_pos

	return Vector2(var0[1], var0[2])
end

function var0.GetTransportBlockEvent()
	if not var0.blockEventDic then
		var0.blockEventDic = {}

		for iter0, iter1 in ipairs(pg.gameset.world_movelimit_event.description) do
			var0.blockEventDic[iter1] = true
		end
	end

	return var0.blockEventDic
end

function var0.GetTransportStoryEvent()
	if not var0.blockStoryDic then
		var0.blockStoryDic = {}

		for iter0, iter1 in ipairs(pg.gameset.world_transfer_eventlist.description) do
			var0.blockStoryDic[iter1] = true
		end
	end

	return var0.blockStoryDic
end

function var0.IsWorldHelpNew(arg0, arg1)
	if arg1 then
		PlayerPrefs.SetInt("world_help_progress", arg0)
		PlayerPrefs.Save()

		return false
	else
		local var0 = PlayerPrefs.HasKey("world_help_progress") and PlayerPrefs.GetInt("world_help_progress") or 0

		if var0 < arg0 then
			for iter0, iter1 in ipairs(pg.world_help_data.all) do
				local var1 = pg.world_help_data[iter1]

				if arg0 >= var1.stage then
					if var0 < var1.stage then
						return true
					else
						for iter2, iter3 in ipairs(var1.stage_help) do
							if var0 < iter3[1] and arg0 >= iter3[1] then
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

function var0.ParsingBuffs(arg0)
	local var0 = {}

	_.each(arg0, function(arg0)
		local var0 = WorldBuff.New()

		var0:Setup({
			id = arg0.id,
			floor = arg0.stack,
			round = arg0.round,
			step = arg0.step
		})

		var0[var0.id] = var0
	end)

	return var0
end

function var0.CompareBuffs(arg0, arg1)
	local var0 = _.extend({}, arg0)
	local var1 = {}
	local var2 = _.extend({}, arg1)

	for iter0, iter1 in pairs(var0) do
		if var2[iter0] then
			var1[iter0] = var0[iter0]
			var0[iter0] = nil
			var2[iter0] = nil
		end
	end

	return {
		remove = var0,
		continue = var1,
		add = var2
	}
end

function var0.FetchWorldShip(arg0)
	local var0 = nowWorld():GetShip(arg0)

	assert(var0, "world ship not exist: " .. arg0)

	return var0
end

function var0.FetchShipVO(arg0)
	local var0 = getProxy(BayProxy):getShipById(arg0)

	assert(var0, "ship not exist: " .. arg0)

	return var0
end

function var0.FetchRawShipVO(arg0)
	local var0 = getProxy(BayProxy):getRawData()[arg0]

	assert(var0, "ship not exist: " .. arg0)

	return var0
end

function var0.ReqWorldCheck(arg0)
	local var0 = {}

	if nowWorld().type == World.TypeBase then
		table.insert(var0, function(arg0)
			pg.ConnectionMgr.GetInstance():Send(33000, {
				type = 0
			}, 33001, function(arg0)
				local var0 = getProxy(WorldProxy)

				var0:BuildWorld(World.TypeFull)
				var0:NetFullUpdate(arg0)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg0)
end

function var0.ReqWorldForServer()
	pg.ConnectionMgr.GetInstance():Send(33000, {
		type = 1
	}, 33001, function(arg0)
		return
	end)
end

var0.ObstacleConfig = {
	[0] = 2,
	3,
	7,
	0,
	6,
	1,
	4,
	5
}
var0.ObstacleType = {
	"leave",
	"arrive",
	"pass"
}

function var0.GetObstacleKey(arg0)
	return bit.lshift(1, #var0.ObstacleType - table.indexof(var0.ObstacleType, arg0))
end

function var0.GetObstacleConfig(arg0, arg1)
	local var0 = var0.GetObstacleKey(arg1)

	return bit.band(var0.ObstacleConfig[arg0], var0) > 0
end

function var0.RangeCheck(arg0, arg1, arg2)
	for iter0 = arg0.row - arg1, arg0.row + arg1 do
		for iter1 = arg0.column - arg1, arg0.column + arg1 do
			if var0.InFOVRange(arg0.row, arg0.column, iter0, iter1, arg1) then
				arg2(iter0, iter1)
			end
		end
	end
end

function var0.CheckWorldStorySkip(arg0)
	return table.contains(pg.gameset.world_quickmode_skiplua.description, arg0) and getProxy(SettingsProxy):GetWorldFlag("story_tips") and pg.NewStoryMgr.GetInstance():IsPlayed(arg0)
end

function var0.GetNShopTimeStamp()
	if not var0.nShopTimestamp then
		local var0 = {}

		var0.year, var0.month, var0.day = unpack(getGameset("world_newshop_date")[2])
		var0.hour, var0.min, var0.sec = 0, 0, 0
		var0.nShopTimestamp = pg.TimeMgr.GetInstance():Table2ServerTime(var0)
	end

	return var0.nShopTimestamp
end

return var0
