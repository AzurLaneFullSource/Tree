local var0 = class("WorldMapAttachment", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	dataop = "number",
	buffList = "table",
	type = "number",
	column = "number",
	data = "number",
	effects = "table",
	hp = "number",
	row = "number",
	finishMark = "number",
	triggered = "boolean",
	id = "number",
	flag = "number",
	lurk = "boolean"
}
var0.EventUpdateFlag = "WorldMapAttachment.EventUpdateFlag"
var0.EventUpdateData = "WorldMapAttachment.EventUpdateData"
var0.EventUpdateLurk = "WorldMapAttachment.EventUpdateLurk"
var0.TypeBox = 2
var0.TypeEnemy = 6
var0.TypeBoss = 8
var0.TypeArtifact = 10
var0.TypeEnemyAI = 12
var0.TypeFleet = 13
var0.TypeTransportFleet = 17
var0.TypeEvent = 22
var0.TypeTrap = 23
var0.TypePort = -1
var0.SortOrder = {
	[var0.TypeArtifact] = -99,
	[var0.TypeTrap] = -1,
	[var0.TypePort] = 0,
	[var0.TypeEvent] = 1,
	[var0.TypeBox] = 2,
	[var0.TypeEnemy] = 3,
	[var0.TypeEnemyAI] = 4,
	[var0.TypeBoss] = 5,
	[var0.TypeTransportFleet] = 6
}

function var0.IsEnemyType(arg0)
	return arg0 == var0.TypeEnemy or arg0 == var0.TypeEnemyAI or arg0 == var0.TypeBoss
end

function var0.IsHPEnemyType(arg0)
	return arg0 == var0.TypeEnemyAI or arg0 == var0.TypeBoss
end

function var0.IsFakeType(arg0)
	return arg0 == var0.TypePort
end

function var0.IsInteractiveType(arg0)
	return var0.IsEnemyType(arg0) or arg0 == var0.TypeEvent or arg0 == var0.TypeBox
end

function var0.MakeFakePort(arg0, arg1, arg2)
	local var0 = WPool:Get(WorldMapAttachment)

	var0:Setup({
		item_data = 0,
		item_flag = 0,
		pos = {
			row = arg0,
			column = arg1
		},
		item_type = var0.TypePort,
		item_id = arg2,
		buff_list = {},
		effect_list = {}
	})

	return var0
end

function var0.IsClientType(arg0)
	return arg0 > 1000
end

var0.EffectEventStory = 2
var0.EffectEventTeleport = 3
var0.EffectEventDrop = 7
var0.EffectEventShipBuff = 8
var0.EffectEventGuide = 13
var0.EffectEventDropTreasure = 14
var0.EffectEventBlink1 = 16
var0.EffectEventBlink2 = 17
var0.EffectEventAchieveCarry = 18
var0.EffectEventConsumeCarry = 19
var0.EffectEventTeleportEvent = 20
var0.EffectEventConsumeItem = 24
var0.EffectEventStoryOption = 27
var0.EffectEventFleetShipHP = 30
var0.EffectEventProgress = 32
var0.EffectEventTeleportBack = 37
var0.EffectEventDeleteTask = 40
var0.EffectEventGlobalBuff = 44
var0.EffectEventMapClearFlag = 45
var0.EffectEventBrokenClean = 48
var0.EffectEventCatSalvage = 49
var0.EffectEventAddWorldBossFreeCount = 50
var0.EffectEventFOV = 1001
var0.EffectEventCameraMove = 1002
var0.EffectEventShakePlane = 1003
var0.EffectEventFlash = 1004
var0.EffectEventHelp = 1005
var0.EffectEventShowMapMark = 1006
var0.EffectEventReturn2World = 1007
var0.EffectEventStoryOptionClient = 1009
var0.EffectEventShowPort = 1010
var0.EffectEventSound = 1011
var0.EffectEventHelpLayer = 1012
var0.EffectEventMsgbox = 1013
var0.EffectEventStoryBattle = 1014
var0.CompassTypeNone = 0
var0.CompassTypeBattle = 1
var0.CompassTypeExploration = 2
var0.CompassTypeTask = 3
var0.CompassTypeBoss = 4
var0.CompassTypeGuidePost = 5
var0.CompassTypeTaskTrack = 6
var0.CompassTypePort = 7
var0.CompassTypeSalvage = 8
var0.CompassTypeFile = 9
var0.SpEventHaibao = 1
var0.SpEventFufen = 2
var0.SpEventEnemy = 3
var0.SpEventConsumeItem = 4

function var0.DebugPrint(arg0)
	if arg0.type == var0.TypeEvent then
		local var0 = {}
		local var1 = pg.world_event_data[arg0.id].effect
		local var2 = ""

		if #arg0.effects > #var1 then
			var2 = setColorStr("effect error !!!: " .. table.concat(arg0.effects, ", "), COLOR_RED)
		else
			local var3 = {}

			for iter0 = #var1, 1, -1 do
				local var4 = arg0.effects[#arg0.effects - #var1 + iter0]
				local var5 = var1[iter0]

				if not var4 then
					table.insert(var3, 1, setColorStr(var5, COLOR_GREEN))
				elseif var4 ~= var5 then
					local var6 = pg.world_effect_data[var5].effect_type

					if var6 == 27 or var6 == 35 or var6 == 36 then
						table.insert(var3, 1, setColorStr(var4, COLOR_BLUE))
					else
						table.insert(var3, 1, setColorStr(var4, COLOR_RED))
					end
				else
					table.insert(var3, 1, var4)
				end
			end

			var2 = var2 .. table.concat(var3, ", ")
		end

		for iter1, iter2 in ipairs(arg0.config.event_op) do
			if iter1 <= #arg0.config.event_op - arg0.dataop then
				table.insert(var0, setColorStr(iter2, COLOR_GREEN))
			else
				table.insert(var0, iter2)
			end
		end

		return string.format("事件  [id: %d]  [%s]  [位置: %d, %d]  [flag: %s]  [data: %d]  [感染值：%s]  [自动优先级：%s] \n     [effect: %s] \n     [effect_op: %s] \n     [buff: %s]", arg0.id, arg0.config.name, arg0.row, arg0.column, arg0.flag, arg0.data, setColorStr(arg0.config.infection_value, COLOR_RED), setColorStr(arg0.config.auto_pri, COLOR_YELLOW), var2, table.concat(var0, ", "), table.concat(arg0.buffList, ", "))
	elseif var0.IsEnemyType(arg0.type) then
		return string.format("敌人  [id: %s]  [%s]  [类型 %s]  [位置: %s, %s]  [flag: %s]  [data: %s]  [buff: %s]", arg0.id, arg0.config.name, arg0.type, arg0.row, arg0.column, tostring(arg0.flag), tostring(arg0.data), table.concat(arg0.buffList, ", "))
	elseif arg0.type == var0.TypeTrap then
		return string.format("陷阱  [id: %s]  [%s]  [位置: %s, %s]  [flag: %s]  [data: %s]", arg0.id, arg0.config.name, arg0.row, arg0.column, tostring(arg0.flag), tostring(arg0.data))
	elseif arg0.type == var0.TypeFleet then
		return string.format("舰队  [id: %s]  [%s]  [位置: %s, %s]  [flag: %s]  [data: %s]", arg0.id, "我方舰队", arg0.row, arg0.column, tostring(arg0.flag), tostring(arg0.data))
	elseif arg0.type == var0.TypeArtifact then
		return string.format("场景物件  [id: %s]  [位置: %s, %s]  [flag: %s]  [data: %s]  [buff: %s]", arg0.id, arg0.row, arg0.column, tostring(arg0.flag), tostring(arg0.data), table.concat(arg0.buffList, ", "))
	end
end

function var0.Setup(arg0, arg1)
	arg0.row = arg1.pos.row
	arg0.column = arg1.pos.column
	arg0.type = arg1.item_type
	arg0.id = arg1.item_id
	arg0.flag = arg1.item_flag
	arg0.data = arg1.item_data
	arg0.effects = underscore.rest(arg1.effect_list, 1)
	arg0.buffList = underscore.rest(arg1.buff_list, 1)
	arg0.hp = arg1.boss_hp

	arg0:InitConfig()
	arg0:InitData()
end

function var0.InitConfig(arg0)
	if arg0.type == var0.TypeBox then
		arg0.config = pg.box_data_template[arg0.id]

		assert(arg0.config, "box_data_template not exist: " .. arg0.id)
	elseif var0.IsEnemyType(arg0.type) then
		arg0.config = pg.expedition_data_template[arg0.id]

		assert(arg0.config, "expedition_data_template not exist: " .. arg0.id)
	elseif arg0.type == var0.TypeEvent then
		arg0.config = pg.world_event_data[arg0.id]

		assert(arg0.config, "world_event_data not exist: " .. arg0.id)
	elseif arg0.type == var0.TypePort then
		arg0.config = pg.world_port_data[arg0.id]

		assert(arg0.config, "world_port_data not exist: " .. arg0.id)
	elseif arg0.type == var0.TypeTransportFleet then
		arg0.config = pg.friendly_data_template[arg0.id]

		assert(arg0.config, "friendly_data_template not exist: " .. arg0.id)
	elseif arg0.type == var0.TypeTrap then
		arg0.config = pg.world_trap_data[arg0.id]

		assert(arg0.config, "world_trap_data not exist: " .. arg0.id)
	elseif arg0.type == var0.TypeArtifact then
		arg0.config = pg.world_event_data[arg0.id]

		assert(arg0.config, "with out this atrifact: " .. arg0.id)
	end
end

function var0.InitData(arg0)
	if arg0.type == var0.TypeEvent then
		arg0.dataop = #arg0.config.event_op
	end
end

function var0.IsAlive(arg0)
	if arg0.type == var0.TypeEvent then
		return true
	elseif var0.IsEnemyType(arg0.type) then
		return arg0.flag ~= 1 and arg0.data ~= 0
	elseif arg0.type == var0.TypeTransportFleet then
		return arg0:GetHP() > 0
	elseif arg0.type == var0.TypeArtifact then
		return false
	end

	return arg0.flag ~= 1
end

function var0.IsVisible(arg0)
	local var0 = not arg0.lurk

	if arg0.type == var0.TypeEvent then
		var0 = var0 and arg0.config.discover_type == 2
	elseif var0.IsEnemyType(arg0.type) then
		var0 = var0 and arg0:IsAlive()
	end

	return var0
end

function var0.IsFloating(arg0)
	return arg0.type == var0.TypeEvent and arg0.config.icontype == 1 or arg0.type == var0.TypeBox
end

function var0.UpdateFlag(arg0, arg1)
	if arg0.flag ~= arg1 then
		arg0.flag = arg1

		arg0:DispatchEvent(var0.EventUpdateFlag)
	end
end

function var0.UpdateData(arg0, arg1, arg2)
	arg0.data = arg1

	if arg0.type == var0.TypeEvent then
		arg0.effects = underscore.rest(arg2, 1)
	end

	arg0:DispatchEvent(var0.EventUpdateData)
end

function var0.UpdateLurk(arg0, arg1)
	if arg0.lurk ~= arg1 then
		arg0.lurk = arg1

		arg0:DispatchEvent(var0.EventUpdateLurk)
	end
end

function var0.UpdateDataOp(arg0, arg1)
	arg0.dataop = arg1
end

function var0.GetEventEffect(arg0)
	assert(arg0.type == var0.TypeEvent, string.format("type error:%d", arg0.type))

	local var0 = arg0.effects[1]

	return var0 and pg.world_effect_data[var0]
end

function var0.GetEventEffects(arg0)
	assert(arg0.type == var0.TypeEvent, string.format("type error:%d", arg0.type))

	return _.map(arg0.effects, function(arg0)
		return pg.world_effect_data[arg0]
	end)
end

function var0.RemainOpEffect(arg0)
	return arg0.dataop > 0
end

function var0.GetOpEffect(arg0)
	local var0 = arg0.config.event_op
	local var1 = var0[#var0 - arg0.dataop + 1]

	assert(pg.world_effect_data[var1], "world_effect_data not exist: " .. var1)

	return pg.world_effect_data[var1]
end

function var0.GetBattleStageId(arg0)
	assert(var0.IsEnemyType(arg0.type))

	return arg0.id
end

function var0.GetLimitDamageLevel(arg0)
	return pg.world_expedition_data[arg0:GetBattleStageId()].morale_limit
end

function var0.ShouldMarkAsLurk(arg0)
	return arg0.type == var0.TypeEvent and arg0.config.visuality == 1 and arg0.config.discover_type == 2
end

function var0.CanLeave(arg0)
	if var0.IsEnemyType(arg0.type) then
		return false
	elseif arg0.type == var0.TypeEvent or arg0.type == var0.TypeTrap then
		return WorldConst.GetObstacleConfig(arg0.config.obstacle, "leave")
	else
		return true
	end
end

function var0.CanArrive(arg0)
	if arg0.type == var0.TypeEvent or arg0.type == var0.TypeTrap then
		return WorldConst.GetObstacleConfig(arg0.config.obstacle, "arrive")
	else
		return true
	end
end

function var0.CanPass(arg0)
	if var0.IsEnemyType(arg0.type) then
		return false
	elseif arg0.type == var0.TypeEvent or arg0.type == var0.TypeTrap then
		return WorldConst.GetObstacleConfig(arg0.config.obstacle, "pass")
	else
		return true
	end
end

function var0.IsAvatar(arg0)
	if arg0.type == var0.TypeEvent then
		if arg0:GetReplaceDisplayEnemyConfig() then
			return false
		end

		return math.floor(arg0.config.enemyicon / 2) == 1
	elseif var0.IsEnemyType(arg0.type) then
		return arg0.config.icon_type == 2
	end

	return false
end

function var0.IsSign(arg0)
	if arg0.type == var0.TypeEvent then
		return arg0.config.is_guide == 1
	end

	return false
end

function var0.IsBoss(arg0)
	return var0.IsEnemyType(arg0.type) and WorldConst.EnemySize[arg0.config.type] == 99
end

function var0.GetBuffList(arg0)
	return underscore.map(arg0.buffList, function(arg0)
		local var0 = WorldBuff.New()

		var0:Setup({
			floor = 1,
			id = arg0
		})

		return var0
	end)
end

function var0.UpdateBuffList(arg0, arg1)
	local var0 = arg0:GetWeaknessBuffId()

	arg0.buffList = arg1

	if var0 ~= arg0:GetWeaknessBuffId() then
		return var0 and {
			anim = "WorldWeaknessUpgradeWindow",
			hp = arg0:GetMaxHP()
		} or {
			anim = "WorldWeaknessDiscoverWindow",
			hp = arg0:GetMaxHP()
		}
	end
end

function var0.GetWeaknessBuffId(arg0)
	if not var0.IsEnemyType(arg0.type) then
		return
	end

	local var0 = {}

	underscore.each(underscore.flatten(pg.world_expedition_data[arg0:GetBattleStageId()].weak_list), function(arg0)
		var0[arg0] = true
	end)

	for iter0, iter1 in ipairs(arg0.buffList) do
		if var0[iter1] then
			return iter1
		end
	end
end

function var0.GetBattleLuaBuffs(arg0)
	local var0 = {}

	underscore.each(arg0:GetBuffList(), function(arg0)
		if arg0.config.lua_id > 0 then
			table.insert(var0, arg0.config.lua_id)
		end
	end)

	return var0
end

function var0.GetCompassType(arg0)
	if arg0.type == var0.TypeEvent then
		return arg0.config.compass_index
	elseif var0.IsEnemyType(arg0.type) then
		if arg0:IsBoss() then
			return var0.CompassTypeBoss
		else
			return var0.CompassTypeBattle
		end
	elseif arg0.type == var0.TypeBox then
		return var0.CompassTypeExploration
	elseif arg0.type == var0.TypePort then
		return var0.CompassTypePort
	end
end

function var0.GetSpEventType(arg0)
	if arg0.type == var0.TypeEvent then
		return arg0.config.special_enemy
	end
end

function var0.GetDeviation(arg0)
	if arg0.type == var0.TypeEvent or arg0.type == var0.TypeArtifact then
		local var0 = arg0.config

		return Vector2(var0.deviation[1], var0.deviation[2])
	end

	return Vector2.zero
end

function var0.GetScale(arg0, arg1)
	local var0 = 1

	if arg0.type == var0.TypeEvent then
		if arg0.config.scale == 0 then
			return Vector3.one
		else
			var0 = arg0.config.scale / 100
		end
	elseif var0.IsEnemyType(arg0.type) then
		var0 = 0.4 * arg0.config.scale / 100
	elseif arg0.type == var0.TypeTrap and arg0.id == 200 then
		arg1 = arg1 or arg0.data
		var0 = var0 * (arg1 + arg1 - 1)
	end

	return Vector3(var0, var0, var0)
end

function var0.GetModelOrder(arg0)
	if arg0.type == var0.TypeTrap then
		return WorldConst.LOEffectC
	end

	return WorldConst.LOCell
end

function var0.GetMillor(arg0)
	if arg0.type == var0.TypeEvent then
		return arg0.config.enemyicon % 2 == 1
	elseif var0.IsEnemyType(arg0.type) then
		return true
	end

	return false
end

function var0.GetDirType(arg0)
	if arg0:GetSpEventType() == var0.SpEventFufen then
		return WorldConst.DirType4
	else
		return WorldConst.DirType2
	end
end

function var0.GetReplaceDisplayEnemyConfig(arg0)
	assert(arg0.type == var0.TypeEvent)

	return pg.expedition_data_template[arg0.config.expedition_icon]
end

function var0.GetDebugName(arg0)
	if arg0.type == var0.TypeEvent then
		return "event_" .. arg0.id
	elseif arg0.type == var0.TypeBox then
		return "box_" .. arg0.id
	elseif var0.IsEnemyType(arg0.type) then
		return "enemy_" .. arg0.id
	elseif arg0.type == var0.TypeTransportFleet then
		return "transport_" .. arg0.id
	elseif arg0.type == var0.TypeTrap then
		return "trap_" .. arg0.id
	elseif arg0.type == var0.TypePort then
		return "port_" .. arg0.id
	end
end

function var0.IsTriggered(arg0)
	return arg0.triggered
end

function var0.IsScannerAttachment(arg0)
	return var0.IsEnemyType(arg0.type) and 4 or arg0.type == var0.TypeTrap and 3 or arg0.type == var0.TypeEvent and arg0.config.is_scanevent > 0 and 2 or arg0.type == var0.TypePort and 1
end

function var0.SetHP(arg0, arg1)
	if var0.IsHPEnemyType(arg0.type) then
		local var0 = arg0.hp

		if arg0:IsPeriodEnemy() then
			local var1 = nowWorld()

			var0 = math.min(var0, var1:GetHistoryLowestHP(arg0.id))

			var1:SetHistoryLowestHP(arg0.id, arg1)
		end

		local var2 = {}

		for iter0, iter1 in ipairs(pg.world_expedition_data[arg0:GetBattleStageId()].phase_story) do
			if var0 > iter1[1] and arg1 <= iter1[1] then
				table.insert(var2, {
					hp = iter1[1],
					story = iter1[2]
				})
			end
		end

		arg0.hp = arg1

		return var2
	else
		return {}
	end
end

function var0.GetHP(arg0)
	if arg0.type == var0.TypeTransportFleet then
		return arg0.data
	elseif var0.IsHPEnemyType(arg0.type) then
		return arg0.hp
	end
end

function var0.GetMaxHP(arg0)
	if arg0.type == var0.TypeTransportFleet then
		return arg0.config.hp
	elseif var0.IsHPEnemyType(arg0.type) then
		return 10000
	end
end

function var0.GetArtifaceInfo(arg0)
	local var0 = arg0.config

	assert(arg0.type == var0.TypeArtifact, "type error from id: " .. arg0.id)
	assert(math.floor(var0.enemyicon / 2) == 2, "enemyicon error from id: " .. arg0.id)

	return {
		arg0.row,
		arg0.column,
		var0.icon
	}
end

function var0.GetVisionRadius(arg0)
	if arg0.type == var0.TypeEvent then
		return arg0.config.event_sight
	else
		return -1
	end
end

function var0.GetRadiationBuffs(arg0)
	if arg0.type == var0.TypeEvent then
		return arg0.config.map_buff
	else
		return {}
	end
end

function var0.IsAttachmentFinish(arg0)
	return arg0.finishMark == arg0.data
end

function var0.GetEventAutoPri(arg0)
	assert(arg0.type == var0.TypeEvent, "type error from id: " .. arg0.id)

	return arg0.config.auto_pri
end

function var0.IsPeriodEnemy(arg0)
	assert(var0.IsHPEnemyType(arg0.type), string.format("enemy %d type %d error", arg0.id, arg0.type))

	local var0 = pg.world_expedition_data[arg0.id]

	return var0 and var0.phase_limit == 1
end

return var0
