local var0_0 = class("WorldMapAttachment", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.EventUpdateFlag = "WorldMapAttachment.EventUpdateFlag"
var0_0.EventUpdateData = "WorldMapAttachment.EventUpdateData"
var0_0.EventUpdateLurk = "WorldMapAttachment.EventUpdateLurk"
var0_0.TypeBox = 2
var0_0.TypeEnemy = 6
var0_0.TypeBoss = 8
var0_0.TypeArtifact = 10
var0_0.TypeEnemyAI = 12
var0_0.TypeFleet = 13
var0_0.TypeTransportFleet = 17
var0_0.TypeEvent = 22
var0_0.TypeTrap = 23
var0_0.TypePort = -1
var0_0.SortOrder = {
	[var0_0.TypeArtifact] = -99,
	[var0_0.TypeTrap] = -1,
	[var0_0.TypePort] = 0,
	[var0_0.TypeEvent] = 1,
	[var0_0.TypeBox] = 2,
	[var0_0.TypeEnemy] = 3,
	[var0_0.TypeEnemyAI] = 4,
	[var0_0.TypeBoss] = 5,
	[var0_0.TypeTransportFleet] = 6
}

function var0_0.IsEnemyType(arg0_1)
	return arg0_1 == var0_0.TypeEnemy or arg0_1 == var0_0.TypeEnemyAI or arg0_1 == var0_0.TypeBoss
end

function var0_0.IsHPEnemyType(arg0_2)
	return arg0_2 == var0_0.TypeEnemyAI or arg0_2 == var0_0.TypeBoss
end

function var0_0.IsFakeType(arg0_3)
	return arg0_3 == var0_0.TypePort
end

function var0_0.IsInteractiveType(arg0_4)
	return var0_0.IsEnemyType(arg0_4) or arg0_4 == var0_0.TypeEvent or arg0_4 == var0_0.TypeBox
end

function var0_0.MakeFakePort(arg0_5, arg1_5, arg2_5)
	local var0_5 = WPool:Get(WorldMapAttachment)

	var0_5:Setup({
		item_data = 0,
		item_flag = 0,
		pos = {
			row = arg0_5,
			column = arg1_5
		},
		item_type = var0_0.TypePort,
		item_id = arg2_5,
		buff_list = {},
		effect_list = {}
	})

	return var0_5
end

function var0_0.IsClientType(arg0_6)
	return arg0_6 > 1000
end

var0_0.EffectEventStory = 2
var0_0.EffectEventTeleport = 3
var0_0.EffectEventDrop = 7
var0_0.EffectEventShipBuff = 8
var0_0.EffectEventGuide = 13
var0_0.EffectEventDropTreasure = 14
var0_0.EffectEventBlink1 = 16
var0_0.EffectEventBlink2 = 17
var0_0.EffectEventAchieveCarry = 18
var0_0.EffectEventConsumeCarry = 19
var0_0.EffectEventTeleportEvent = 20
var0_0.EffectEventConsumeItem = 24
var0_0.EffectEventStoryOption = 27
var0_0.EffectEventFleetShipHP = 30
var0_0.EffectEventProgress = 32
var0_0.EffectEventTeleportBack = 37
var0_0.EffectEventDeleteTask = 40
var0_0.EffectEventGlobalBuff = 44
var0_0.EffectEventMapClearFlag = 45
var0_0.EffectEventBrokenClean = 48
var0_0.EffectEventCatSalvage = 49
var0_0.EffectEventAddWorldBossFreeCount = 50
var0_0.EffectEventFOV = 1001
var0_0.EffectEventCameraMove = 1002
var0_0.EffectEventShakePlane = 1003
var0_0.EffectEventFlash = 1004
var0_0.EffectEventHelp = 1005
var0_0.EffectEventShowMapMark = 1006
var0_0.EffectEventReturn2World = 1007
var0_0.EffectEventStoryOptionClient = 1009
var0_0.EffectEventShowPort = 1010
var0_0.EffectEventSound = 1011
var0_0.EffectEventHelpLayer = 1012
var0_0.EffectEventMsgbox = 1013
var0_0.EffectEventStoryBattle = 1014
var0_0.CompassTypeNone = 0
var0_0.CompassTypeBattle = 1
var0_0.CompassTypeExploration = 2
var0_0.CompassTypeTask = 3
var0_0.CompassTypeBoss = 4
var0_0.CompassTypeGuidePost = 5
var0_0.CompassTypeTaskTrack = 6
var0_0.CompassTypePort = 7
var0_0.CompassTypeSalvage = 8
var0_0.CompassTypeFile = 9
var0_0.SpEventHaibao = 1
var0_0.SpEventFufen = 2
var0_0.SpEventEnemy = 3
var0_0.SpEventConsumeItem = 4

function var0_0.DebugPrint(arg0_7)
	if arg0_7.type == var0_0.TypeEvent then
		local var0_7 = {}
		local var1_7 = pg.world_event_data[arg0_7.id].effect
		local var2_7 = ""

		if #arg0_7.effects > #var1_7 then
			var2_7 = setColorStr("effect error !!!: " .. table.concat(arg0_7.effects, ", "), COLOR_RED)
		else
			local var3_7 = {}

			for iter0_7 = #var1_7, 1, -1 do
				local var4_7 = arg0_7.effects[#arg0_7.effects - #var1_7 + iter0_7]
				local var5_7 = var1_7[iter0_7]

				if not var4_7 then
					table.insert(var3_7, 1, setColorStr(var5_7, COLOR_GREEN))
				elseif var4_7 ~= var5_7 then
					local var6_7 = pg.world_effect_data[var5_7].effect_type

					if var6_7 == 27 or var6_7 == 35 or var6_7 == 36 then
						table.insert(var3_7, 1, setColorStr(var4_7, COLOR_BLUE))
					else
						table.insert(var3_7, 1, setColorStr(var4_7, COLOR_RED))
					end
				else
					table.insert(var3_7, 1, var4_7)
				end
			end

			var2_7 = var2_7 .. table.concat(var3_7, ", ")
		end

		for iter1_7, iter2_7 in ipairs(arg0_7.config.event_op) do
			if iter1_7 <= #arg0_7.config.event_op - arg0_7.dataop then
				table.insert(var0_7, setColorStr(iter2_7, COLOR_GREEN))
			else
				table.insert(var0_7, iter2_7)
			end
		end

		return string.format("事件  [id: %d]  [%s]  [位置: %d, %d]  [flag: %s]  [data: %d]  [感染值：%s]  [自动优先级：%s] \n     [effect: %s] \n     [effect_op: %s] \n     [buff: %s]", arg0_7.id, arg0_7.config.name, arg0_7.row, arg0_7.column, arg0_7.flag, arg0_7.data, setColorStr(arg0_7.config.infection_value, COLOR_RED), setColorStr(arg0_7.config.auto_pri, COLOR_YELLOW), var2_7, table.concat(var0_7, ", "), table.concat(arg0_7.buffList, ", "))
	elseif var0_0.IsEnemyType(arg0_7.type) then
		return string.format("敌人  [id: %s]  [%s]  [类型 %s]  [位置: %s, %s]  [flag: %s]  [data: %s]  [buff: %s]", arg0_7.id, arg0_7.config.name, arg0_7.type, arg0_7.row, arg0_7.column, tostring(arg0_7.flag), tostring(arg0_7.data), table.concat(arg0_7.buffList, ", "))
	elseif arg0_7.type == var0_0.TypeTrap then
		return string.format("陷阱  [id: %s]  [%s]  [位置: %s, %s]  [flag: %s]  [data: %s]", arg0_7.id, arg0_7.config.name, arg0_7.row, arg0_7.column, tostring(arg0_7.flag), tostring(arg0_7.data))
	elseif arg0_7.type == var0_0.TypeFleet then
		return string.format("舰队  [id: %s]  [%s]  [位置: %s, %s]  [flag: %s]  [data: %s]", arg0_7.id, "我方舰队", arg0_7.row, arg0_7.column, tostring(arg0_7.flag), tostring(arg0_7.data))
	elseif arg0_7.type == var0_0.TypeArtifact then
		return string.format("场景物件  [id: %s]  [位置: %s, %s]  [flag: %s]  [data: %s]  [buff: %s]", arg0_7.id, arg0_7.row, arg0_7.column, tostring(arg0_7.flag), tostring(arg0_7.data), table.concat(arg0_7.buffList, ", "))
	end
end

function var0_0.Setup(arg0_8, arg1_8)
	arg0_8.row = arg1_8.pos.row
	arg0_8.column = arg1_8.pos.column
	arg0_8.type = arg1_8.item_type
	arg0_8.id = arg1_8.item_id
	arg0_8.flag = arg1_8.item_flag
	arg0_8.data = arg1_8.item_data
	arg0_8.effects = underscore.rest(arg1_8.effect_list, 1)
	arg0_8.buffList = underscore.rest(arg1_8.buff_list, 1)
	arg0_8.hp = arg1_8.boss_hp

	arg0_8:InitConfig()
	arg0_8:InitData()
end

function var0_0.InitConfig(arg0_9)
	if arg0_9.type == var0_0.TypeBox then
		arg0_9.config = pg.box_data_template[arg0_9.id]

		assert(arg0_9.config, "box_data_template not exist: " .. arg0_9.id)
	elseif var0_0.IsEnemyType(arg0_9.type) then
		arg0_9.config = pg.expedition_data_template[arg0_9.id]

		assert(arg0_9.config, "expedition_data_template not exist: " .. arg0_9.id)
	elseif arg0_9.type == var0_0.TypeEvent then
		arg0_9.config = pg.world_event_data[arg0_9.id]

		assert(arg0_9.config, "world_event_data not exist: " .. arg0_9.id)
	elseif arg0_9.type == var0_0.TypePort then
		arg0_9.config = pg.world_port_data[arg0_9.id]

		assert(arg0_9.config, "world_port_data not exist: " .. arg0_9.id)
	elseif arg0_9.type == var0_0.TypeTransportFleet then
		arg0_9.config = pg.friendly_data_template[arg0_9.id]

		assert(arg0_9.config, "friendly_data_template not exist: " .. arg0_9.id)
	elseif arg0_9.type == var0_0.TypeTrap then
		arg0_9.config = pg.world_trap_data[arg0_9.id]

		assert(arg0_9.config, "world_trap_data not exist: " .. arg0_9.id)
	elseif arg0_9.type == var0_0.TypeArtifact then
		arg0_9.config = pg.world_event_data[arg0_9.id]

		assert(arg0_9.config, "with out this atrifact: " .. arg0_9.id)
	end
end

function var0_0.InitData(arg0_10)
	if arg0_10.type == var0_0.TypeEvent then
		arg0_10.dataop = #arg0_10.config.event_op
	end
end

function var0_0.IsAlive(arg0_11)
	if arg0_11.type == var0_0.TypeEvent then
		return true
	elseif var0_0.IsEnemyType(arg0_11.type) then
		return arg0_11.flag ~= 1 and arg0_11.data ~= 0
	elseif arg0_11.type == var0_0.TypeTransportFleet then
		return arg0_11:GetHP() > 0
	elseif arg0_11.type == var0_0.TypeArtifact then
		return false
	end

	return arg0_11.flag ~= 1
end

function var0_0.IsVisible(arg0_12)
	local var0_12 = not arg0_12.lurk

	if arg0_12.type == var0_0.TypeEvent then
		var0_12 = var0_12 and arg0_12.config.discover_type == 2
	elseif var0_0.IsEnemyType(arg0_12.type) then
		var0_12 = var0_12 and arg0_12:IsAlive()
	end

	return var0_12
end

function var0_0.IsFloating(arg0_13)
	return arg0_13.type == var0_0.TypeEvent and arg0_13.config.icontype == 1 or arg0_13.type == var0_0.TypeBox
end

function var0_0.UpdateFlag(arg0_14, arg1_14)
	if arg0_14.flag ~= arg1_14 then
		arg0_14.flag = arg1_14

		arg0_14:DispatchEvent(var0_0.EventUpdateFlag)
	end
end

function var0_0.UpdateData(arg0_15, arg1_15, arg2_15)
	arg0_15.data = arg1_15

	if arg0_15.type == var0_0.TypeEvent then
		arg0_15.effects = underscore.rest(arg2_15, 1)
	end

	arg0_15:DispatchEvent(var0_0.EventUpdateData)
end

function var0_0.UpdateLurk(arg0_16, arg1_16)
	if arg0_16.lurk ~= arg1_16 then
		arg0_16.lurk = arg1_16

		arg0_16:DispatchEvent(var0_0.EventUpdateLurk)
	end
end

function var0_0.UpdateDataOp(arg0_17, arg1_17)
	arg0_17.dataop = arg1_17
end

function var0_0.GetEventEffect(arg0_18)
	assert(arg0_18.type == var0_0.TypeEvent, string.format("type error:%d", arg0_18.type))

	local var0_18 = arg0_18.effects[1]

	return var0_18 and pg.world_effect_data[var0_18]
end

function var0_0.GetEventEffects(arg0_19)
	assert(arg0_19.type == var0_0.TypeEvent, string.format("type error:%d", arg0_19.type))

	return _.map(arg0_19.effects, function(arg0_20)
		return pg.world_effect_data[arg0_20]
	end)
end

function var0_0.RemainOpEffect(arg0_21)
	return arg0_21.dataop > 0
end

function var0_0.GetOpEffect(arg0_22)
	local var0_22 = arg0_22.config.event_op
	local var1_22 = var0_22[#var0_22 - arg0_22.dataop + 1]

	assert(pg.world_effect_data[var1_22], "world_effect_data not exist: " .. var1_22)

	return pg.world_effect_data[var1_22]
end

function var0_0.GetBattleStageId(arg0_23)
	assert(var0_0.IsEnemyType(arg0_23.type))

	return arg0_23.id
end

function var0_0.GetLimitDamageLevel(arg0_24)
	return pg.world_expedition_data[arg0_24:GetBattleStageId()].morale_limit
end

function var0_0.ShouldMarkAsLurk(arg0_25)
	return arg0_25.type == var0_0.TypeEvent and arg0_25.config.visuality == 1 and arg0_25.config.discover_type == 2
end

function var0_0.CanLeave(arg0_26)
	if var0_0.IsEnemyType(arg0_26.type) then
		return false
	elseif arg0_26.type == var0_0.TypeEvent or arg0_26.type == var0_0.TypeTrap then
		return WorldConst.GetObstacleConfig(arg0_26.config.obstacle, "leave")
	else
		return true
	end
end

function var0_0.CanArrive(arg0_27)
	if arg0_27.type == var0_0.TypeEvent or arg0_27.type == var0_0.TypeTrap then
		return WorldConst.GetObstacleConfig(arg0_27.config.obstacle, "arrive")
	else
		return true
	end
end

function var0_0.CanPass(arg0_28)
	if var0_0.IsEnemyType(arg0_28.type) then
		return false
	elseif arg0_28.type == var0_0.TypeEvent or arg0_28.type == var0_0.TypeTrap then
		return WorldConst.GetObstacleConfig(arg0_28.config.obstacle, "pass")
	else
		return true
	end
end

function var0_0.IsAvatar(arg0_29)
	if arg0_29.type == var0_0.TypeEvent then
		if arg0_29:GetReplaceDisplayEnemyConfig() then
			return false
		end

		return math.floor(arg0_29.config.enemyicon / 2) == 1
	elseif var0_0.IsEnemyType(arg0_29.type) then
		return arg0_29.config.icon_type == 2
	end

	return false
end

function var0_0.IsSign(arg0_30)
	if arg0_30.type == var0_0.TypeEvent then
		return arg0_30.config.is_guide == 1
	end

	return false
end

function var0_0.IsBoss(arg0_31)
	return var0_0.IsEnemyType(arg0_31.type) and WorldConst.EnemySize[arg0_31.config.type] == 99
end

function var0_0.GetBuffList(arg0_32)
	return underscore.map(arg0_32.buffList, function(arg0_33)
		local var0_33 = WorldBuff.New()

		var0_33:Setup({
			floor = 1,
			id = arg0_33
		})

		return var0_33
	end)
end

function var0_0.UpdateBuffList(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetWeaknessBuffId()

	arg0_34.buffList = arg1_34

	if var0_34 ~= arg0_34:GetWeaknessBuffId() then
		return var0_34 and {
			anim = "WorldWeaknessUpgradeWindow",
			hp = arg0_34:GetMaxHP()
		} or {
			anim = "WorldWeaknessDiscoverWindow",
			hp = arg0_34:GetMaxHP()
		}
	end
end

function var0_0.GetWeaknessBuffId(arg0_35)
	if not var0_0.IsEnemyType(arg0_35.type) then
		return
	end

	local var0_35 = {}

	underscore.each(underscore.flatten(pg.world_expedition_data[arg0_35:GetBattleStageId()].weak_list), function(arg0_36)
		var0_35[arg0_36] = true
	end)

	for iter0_35, iter1_35 in ipairs(arg0_35.buffList) do
		if var0_35[iter1_35] then
			return iter1_35
		end
	end
end

function var0_0.GetBattleLuaBuffs(arg0_37)
	local var0_37 = {}

	underscore.each(arg0_37:GetBuffList(), function(arg0_38)
		if arg0_38.config.lua_id > 0 then
			table.insert(var0_37, arg0_38.config.lua_id)
		end
	end)

	return var0_37
end

function var0_0.GetCompassType(arg0_39)
	if arg0_39.type == var0_0.TypeEvent then
		return arg0_39.config.compass_index
	elseif var0_0.IsEnemyType(arg0_39.type) then
		if arg0_39:IsBoss() then
			return var0_0.CompassTypeBoss
		else
			return var0_0.CompassTypeBattle
		end
	elseif arg0_39.type == var0_0.TypeBox then
		return var0_0.CompassTypeExploration
	elseif arg0_39.type == var0_0.TypePort then
		return var0_0.CompassTypePort
	end
end

function var0_0.GetSpEventType(arg0_40)
	if arg0_40.type == var0_0.TypeEvent then
		return arg0_40.config.special_enemy
	end
end

function var0_0.GetDeviation(arg0_41)
	if arg0_41.type == var0_0.TypeEvent or arg0_41.type == var0_0.TypeArtifact then
		local var0_41 = arg0_41.config

		return Vector2(var0_41.deviation[1], var0_41.deviation[2])
	end

	return Vector2.zero
end

function var0_0.GetScale(arg0_42, arg1_42)
	local var0_42 = 1

	if arg0_42.type == var0_0.TypeEvent then
		if arg0_42.config.scale == 0 then
			return Vector3.one
		else
			var0_42 = arg0_42.config.scale / 100
		end
	elseif var0_0.IsEnemyType(arg0_42.type) then
		var0_42 = 0.4 * arg0_42.config.scale / 100
	elseif arg0_42.type == var0_0.TypeTrap and arg0_42.id == 200 then
		arg1_42 = arg1_42 or arg0_42.data
		var0_42 = var0_42 * (arg1_42 + arg1_42 - 1)
	end

	return Vector3(var0_42, var0_42, var0_42)
end

function var0_0.GetModelOrder(arg0_43)
	if arg0_43.type == var0_0.TypeTrap then
		return WorldConst.LOEffectC
	end

	return WorldConst.LOCell
end

function var0_0.GetMillor(arg0_44)
	if arg0_44.type == var0_0.TypeEvent then
		return arg0_44.config.enemyicon % 2 == 1
	elseif var0_0.IsEnemyType(arg0_44.type) then
		return true
	end

	return false
end

function var0_0.GetDirType(arg0_45)
	if arg0_45:GetSpEventType() == var0_0.SpEventFufen then
		return WorldConst.DirType4
	else
		return WorldConst.DirType2
	end
end

function var0_0.GetReplaceDisplayEnemyConfig(arg0_46)
	assert(arg0_46.type == var0_0.TypeEvent)

	return pg.expedition_data_template[arg0_46.config.expedition_icon]
end

function var0_0.GetDebugName(arg0_47)
	if arg0_47.type == var0_0.TypeEvent then
		return "event_" .. arg0_47.id
	elseif arg0_47.type == var0_0.TypeBox then
		return "box_" .. arg0_47.id
	elseif var0_0.IsEnemyType(arg0_47.type) then
		return "enemy_" .. arg0_47.id
	elseif arg0_47.type == var0_0.TypeTransportFleet then
		return "transport_" .. arg0_47.id
	elseif arg0_47.type == var0_0.TypeTrap then
		return "trap_" .. arg0_47.id
	elseif arg0_47.type == var0_0.TypePort then
		return "port_" .. arg0_47.id
	end
end

function var0_0.IsTriggered(arg0_48)
	return arg0_48.triggered
end

function var0_0.IsScannerAttachment(arg0_49)
	return var0_0.IsEnemyType(arg0_49.type) and 4 or arg0_49.type == var0_0.TypeTrap and 3 or arg0_49.type == var0_0.TypeEvent and arg0_49.config.is_scanevent > 0 and 2 or arg0_49.type == var0_0.TypePort and 1
end

function var0_0.SetHP(arg0_50, arg1_50)
	if var0_0.IsHPEnemyType(arg0_50.type) then
		local var0_50 = arg0_50.hp

		if arg0_50:IsPeriodEnemy() then
			local var1_50 = nowWorld()

			var0_50 = math.min(var0_50, var1_50:GetHistoryLowestHP(arg0_50.id))

			var1_50:SetHistoryLowestHP(arg0_50.id, arg1_50)
		end

		local var2_50 = {}

		for iter0_50, iter1_50 in ipairs(pg.world_expedition_data[arg0_50:GetBattleStageId()].phase_story) do
			if var0_50 > iter1_50[1] and arg1_50 <= iter1_50[1] then
				table.insert(var2_50, {
					hp = iter1_50[1],
					story = iter1_50[2]
				})
			end
		end

		arg0_50.hp = arg1_50

		return var2_50
	else
		return {}
	end
end

function var0_0.GetHP(arg0_51)
	if arg0_51.type == var0_0.TypeTransportFleet then
		return arg0_51.data
	elseif var0_0.IsHPEnemyType(arg0_51.type) then
		return arg0_51.hp
	end
end

function var0_0.GetMaxHP(arg0_52)
	if arg0_52.type == var0_0.TypeTransportFleet then
		return arg0_52.config.hp
	elseif var0_0.IsHPEnemyType(arg0_52.type) then
		return 10000
	end
end

function var0_0.GetArtifaceInfo(arg0_53)
	local var0_53 = arg0_53.config

	assert(arg0_53.type == var0_0.TypeArtifact, "type error from id: " .. arg0_53.id)
	assert(math.floor(var0_53.enemyicon / 2) == 2, "enemyicon error from id: " .. arg0_53.id)

	return {
		arg0_53.row,
		arg0_53.column,
		var0_53.icon
	}
end

function var0_0.GetVisionRadius(arg0_54)
	if arg0_54.type == var0_0.TypeEvent then
		return arg0_54.config.event_sight
	else
		return -1
	end
end

function var0_0.GetRadiationBuffs(arg0_55)
	if arg0_55.type == var0_0.TypeEvent then
		return arg0_55.config.map_buff
	else
		return {}
	end
end

function var0_0.IsAttachmentFinish(arg0_56)
	return arg0_56.finishMark == arg0_56.data
end

function var0_0.GetEventAutoPri(arg0_57)
	assert(arg0_57.type == var0_0.TypeEvent, "type error from id: " .. arg0_57.id)

	return arg0_57.config.auto_pri
end

function var0_0.IsPeriodEnemy(arg0_58)
	assert(var0_0.IsHPEnemyType(arg0_58.type), string.format("enemy %d type %d error", arg0_58.id, arg0_58.type))

	local var0_58 = pg.world_expedition_data[arg0_58.id]

	return var0_58 and var0_58.phase_limit == 1
end

return var0_0
