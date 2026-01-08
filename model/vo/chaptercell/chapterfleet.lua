local var0_0 = class("ChapterFleet", import(".LevelCellData"))

var0_0.DUTY_CLEANPATH = 1
var0_0.DUTY_KILLBOSS = 2
var0_0.DUTY_KILLALL = 3
var0_0.DUTY_IDLE = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:updateNpcShipList(arg2_1)

	arg0_1.id = arg1_1.id
	arg0_1.name = nil
	arg0_1.fleetId = arg1_1.fleet_id
	arg0_1.fleetType = arg1_1.fleetType

	if arg1_1.fleet_id then
		local var0_1 = getProxy(FleetProxy):getFleetById(arg1_1.fleet_id)

		arg0_1.name = var0_1 and var0_1:GetName() or Fleet.DEFAULT_NAME[arg1_1.fleet_id]
	end

	arg0_1.name = arg0_1.name or Fleet.DEFAULT_NAME[arg0_1.id]

	local var1_1 = {}
	local var2_1 = {}
	local var3_1 = {}

	_.each(arg1_1.box_strategy_list, function(arg0_2)
		var1_1[arg0_2.id] = arg0_2.count
	end)
	_.each(arg1_1.ship_strategy_list, function(arg0_3)
		var2_1[arg0_3.id] = arg0_3.count
	end)
	_.each(arg1_1.strategy_ids, function(arg0_4)
		if pg.strategy_data_template[arg0_4] then
			table.insert(var3_1, arg0_4)
		end
	end)

	if not _.detect(var3_1, function(arg0_5)
		return pg.strategy_data_template[arg0_5].type == ChapterConst.StgTypeForm
	end) then
		table.insert(var3_1, arg0_1:getFormationStg())
	end

	arg0_1.stgPicked = var1_1
	arg0_1.stgUsed = var2_1
	arg0_1.stgIds = var3_1
	arg0_1.line = {
		row = arg1_1.pos.row,
		column = arg1_1.pos.column
	}
	arg0_1.step = arg1_1.step_count
	arg0_1.restAmmo = arg1_1.bullet
	arg0_1.startPos = {
		row = arg1_1.start_pos.row,
		column = arg1_1.start_pos.column
	}

	arg0_1:prepareShips(arg1_1.ship_list)
	arg0_1:updateShips(arg1_1.ship_list)

	arg0_1.baseSpeed = arg0_1:calcBaseSpeed()
	arg0_1.rotation = Quaternion.identity
	arg0_1.slowSpeedFactor = arg1_1.move_step_down
	arg0_1.defeatEnemies = arg1_1.kill_count or 0
	arg0_1.visibleLevel = arg1_1.vision_lv or 0

	arg0_1:updateCommanders(arg1_1.commander_list)

	arg0_1.skills = {}

	arg0_1:updateCommanderSkills()
end

function var0_0.setup(arg0_6, arg1_6)
	arg0_6.chapter = arg1_6

	arg0_6:UpdateVisible()
end

function var0_0.UpdateVisible(arg0_7)
	if arg0_7:getFleetType() == FleetType.Normal then
		arg0_7.chapter:UpdateCellsVisible(arg0_7)
	end
end

function var0_0.GetFogVisibleLV(arg0_8)
	local var0_8 = #pg.chapter_model_fog.all

	return arg0_8.visibleLevel, pg.chapter_model_fog[math.min(arg0_8.visibleLevel, var0_8)]
end

function var0_0.GetVisibleRange(arg0_9, arg1_9)
	arg1_9 = arg1_9 or arg0_9.line

	local var0_9, var1_9 = arg0_9:GetFogVisibleLV()

	return underscore.map(var1_9.vision_range, function(arg0_10)
		local var0_10, var1_10 = unpack(arg0_10)

		return {
			row = arg1_9.row + var0_10,
			column = arg1_9.column + var1_10
		}
	end)
end

function var0_0.fetchShipVO(arg0_11, arg1_11)
	local var0_11

	if arg0_11.npcShipList[arg1_11] then
		var0_11 = Clone(arg0_11.npcShipList[arg1_11])
	else
		var0_11 = getProxy(BayProxy):getShipById(arg1_11)
	end

	if arg0_11.staticsReady then
		var0_11.triggers.TeamNumbers = arg0_11.statics[var0_11:getTeamType()].count
	end

	return var0_11
end

function var0_0.updateNpcShipList(arg0_12, arg1_12)
	arg0_12.npcShipList = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		arg0_12.npcShipList[iter1_12.id] = iter1_12
	end
end

function var0_0.GetLine(arg0_13)
	return arg0_13.line
end

function var0_0.SetLine(arg0_14, arg1_14)
	arg0_14.line = {
		row = arg1_14.row,
		column = arg1_14.column
	}

	arg0_14:UpdateVisible()
end

function var0_0.updateCommanders(arg0_15, arg1_15)
	arg0_15.commanders = {}

	local var0_15 = getProxy(CommanderProxy)

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		local var1_15 = iter1_15.id
		local var2_15 = var0_15:getCommanderById(var1_15)

		if var2_15 then
			arg0_15.commanders[iter1_15.pos] = var2_15
		end
	end
end

function var0_0.getCommanders(arg0_16)
	return arg0_16.commanders or {}
end

function var0_0.prepareShips(arg0_17, arg1_17)
	arg0_17.statics = {}
	arg0_17.statics[TeamType.Vanguard] = {
		count = 0
	}
	arg0_17.statics[TeamType.Main] = {
		count = 0
	}
	arg0_17.statics[TeamType.Submarine] = {
		count = 0
	}

	_.each(arg1_17 or {}, function(arg0_18)
		local var0_18 = arg0_17:fetchShipVO(arg0_18.id)

		if var0_18 then
			local var1_18 = arg0_17.statics[var0_18:getTeamType()]

			var1_18.count = var1_18.count + 1
		end
	end)

	arg0_17.staticsReady = true
end

function var0_0.updateShips(arg0_19, arg1_19)
	arg0_19[TeamType.Vanguard] = {}
	arg0_19[TeamType.Main] = {}
	arg0_19[TeamType.Submarine] = {}
	arg0_19.ships = {}

	_.each(arg1_19 or {}, function(arg0_20)
		local var0_20 = arg0_19:fetchShipVO(arg0_20.id)

		if var0_20 then
			var0_20.hpRant = arg0_20.hp_rant
			arg0_19.ships[var0_20.id] = var0_20

			table.insert(arg0_19[var0_20:getTeamType()], var0_20)
		end
	end)
	arg0_19:ResortShips()
end

function var0_0.ResortShips(arg0_21)
	local var0_21 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	_.each(var0_21, function(arg0_22)
		local var0_22 = arg0_21[arg0_22]
		local var1_22 = {}

		table.Ipairs(var0_22, function(arg0_23, arg1_23)
			var1_22[arg1_23] = arg0_23
		end)
		table.sort(var0_22, CompareFuncs({
			function(arg0_24)
				return arg0_24.hpRant > 0 and 0 or 1
			end,
			function(arg0_25)
				return var1_22[arg0_25]
			end
		}))
	end)
end

function var0_0.getTeamByName(arg0_26, arg1_26)
	local var0_26 = {}
	local var1_26 = arg0_26[arg1_26]

	for iter0_26, iter1_26 in ipairs(var1_26) do
		table.insert(var0_26, iter1_26.id)
	end

	return var0_26
end

function var0_0.flushShips(arg0_27)
	local var0_27 = getProxy(FleetProxy):getFleetById(arg0_27.fleetId)

	arg0_27.name = var0_27 and var0_27.name ~= "" and var0_27.name or Fleet.DEFAULT_NAME[arg0_27.fleetId] or Fleet.DEFAULT_NAME[arg0_27.id]

	local var1_27 = _.keys(arg0_27.ships)

	for iter0_27, iter1_27 in ipairs(var1_27) do
		local var2_27 = arg0_27:fetchShipVO(iter1_27)

		if var2_27 then
			var2_27.hpRant = arg0_27.ships[iter1_27].hpRant
		end

		arg0_27.ships[iter1_27] = var2_27
	end

	local var3_27 = {}

	_.each(arg0_27[TeamType.Vanguard], function(arg0_28)
		if arg0_27.ships[arg0_28.id] then
			table.insert(var3_27, arg0_27.ships[arg0_28.id])
		end
	end)

	arg0_27[TeamType.Vanguard] = var3_27

	local var4_27 = {}

	_.each(arg0_27[TeamType.Main], function(arg0_29)
		if arg0_27.ships[arg0_29.id] then
			table.insert(var4_27, arg0_27.ships[arg0_29.id])
		end
	end)

	arg0_27[TeamType.Main] = var4_27

	local var5_27 = {}

	_.each(arg0_27[TeamType.Submarine], function(arg0_30)
		if arg0_27.ships[arg0_30.id] then
			table.insert(var5_27, arg0_27.ships[arg0_30.id])
		end
	end)

	arg0_27[TeamType.Submarine] = var5_27
end

function var0_0.updateShipHp(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.ships[arg1_31]

	if var0_31 then
		var0_31.hpChange = arg2_31 - var0_31.hpRant
		var0_31.hpRant = arg2_31

		arg0_31:ResortShips()
	end
end

function var0_0.getShip(arg0_32, arg1_32)
	return arg0_32.ships[arg1_32]
end

function var0_0.getShips(arg0_33, arg1_33)
	local var0_33 = {}
	local var1_33 = arg0_33:getFleetType()

	if var1_33 == FleetType.Normal then
		table.insertto(var0_33, arg0_33:getShipsByTeam(TeamType.Main, arg1_33))
		table.insertto(var0_33, arg0_33:getShipsByTeam(TeamType.Vanguard, arg1_33))
	elseif var1_33 == FleetType.Submarine then
		table.insertto(var0_33, arg0_33:getShipsByTeam(TeamType.Submarine, arg1_33))
	elseif var1_33 == FleetType.Support then
		for iter0_33, iter1_33 in ipairs({
			TeamType.Main,
			TeamType.Vanguard,
			TeamType.Submarine
		}) do
			table.insertto(var0_33, arg0_33:getShipsByTeam(iter1_33, arg1_33))
		end
	end

	return var0_33
end

function var0_0.getShipsByTeam(arg0_34, arg1_34, arg2_34)
	local var0_34 = {}
	local var1_34 = {}

	for iter0_34, iter1_34 in ipairs(arg0_34[arg1_34]) do
		if iter1_34.hpRant > 0 then
			table.insert(var0_34, iter1_34)
		else
			table.insert(var1_34, iter1_34)
		end
	end

	if arg2_34 then
		table.insertto(var0_34, var1_34)
	end

	return var0_34
end

function var0_0.containsShip(arg0_35, arg1_35)
	return arg0_35.ships[arg1_35] and true or false
end

function var0_0.replaceShip(arg0_36, arg1_36, arg2_36)
	errorMsg("ChapterFleet replaceShip function used")

	if arg0_36.ships[arg1_36] and not arg0_36.ships[arg2_36.id] then
		local var0_36 = arg0_36.ships[arg1_36]
		local var1_36 = arg0_36:fetchShipVO(arg2_36.id)

		if var1_36 then
			if var1_36:getTeamType() == var0_36:getTeamType() then
				if not var0_36:isSameKind(var1_36) and arg0_36:containsSameKind(var1_36) then
					arg0_36:removeShip(arg1_36)
				else
					var1_36.hpRant = arg2_36.hp_rant
					arg0_36.ships[arg1_36] = nil
					arg0_36.ships[var1_36.id] = var1_36

					local var2_36 = arg0_36[var1_36:getTeamType()]

					for iter0_36 = 1, #var2_36 do
						if var2_36[iter0_36].id == arg1_36 then
							var2_36[iter0_36] = var1_36

							break
						end
					end
				end
			else
				arg0_36:removeShip(arg1_36)
			end
		end
	end
end

function var0_0.addShip(arg0_37, arg1_37)
	errorMsg("ChapterFleet addShip function used")

	if not arg0_37.ships[arg1_37.id] then
		local var0_37 = arg0_37:fetchShipVO(arg1_37.id)

		if var0_37 then
			var0_37.hpRant = arg1_37.hp_rant

			local var1_37 = arg0_37[var0_37:getTeamType()]

			if #var1_37 < 3 then
				table.insert(var1_37, var0_37)

				arg0_37.ships[var0_37.id] = var0_37

				arg0_37:ResortShips()
			end
		end
	end
end

function var0_0.removeShip(arg0_38, arg1_38)
	errorMsg("ChapterFleet removeShip function used")

	arg0_38.ships[arg1_38] = nil

	local var0_38 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	for iter0_38 = 1, #var0_38 do
		local var1_38 = arg0_38[var0_38[iter0_38]]

		for iter1_38 = #var1_38, 1, -1 do
			if var1_38[iter1_38].id == arg1_38 then
				table.remove(var1_38, iter1_38)
			end
		end
	end
end

function var0_0.switchShip(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = arg0_39:getShipsByTeam(arg1_39, false)
	local var1_39 = var0_39[arg2_39].id
	local var2_39 = var0_39[arg3_39].id
	local var3_39
	local var4_39
	local var5_39
	local var6_39

	for iter0_39, iter1_39 in pairs(arg0_39.ships) do
		if iter0_39 == var1_39 then
			var3_39 = iter1_39:getTeamType()
			var4_39 = table.indexof(arg0_39[var3_39], iter1_39)
		end

		if iter0_39 == var2_39 then
			var5_39 = iter1_39:getTeamType()
			var6_39 = table.indexof(arg0_39[var5_39], iter1_39)
		end
	end

	assert(var4_39 and var6_39)

	if var3_39 == var5_39 and var4_39 ~= var6_39 then
		arg0_39[var3_39][var4_39], arg0_39[var5_39][var6_39] = arg0_39[var5_39][var6_39], arg0_39[var3_39][var4_39]
	end
end

function var0_0.synchronousShipIndex(arg0_40, arg1_40)
	local var0_40 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	for iter0_40, iter1_40 in ipairs(var0_40) do
		for iter2_40 = 1, 3 do
			if arg1_40[iter1_40][iter2_40] then
				local var1_40 = arg1_40[iter1_40][iter2_40].id

				arg0_40[iter1_40][iter2_40] = arg0_40.ships[var1_40]
			else
				arg0_40[iter1_40][iter2_40] = nil
			end
		end
	end
end

function var0_0.isValid(arg0_41)
	local var0_41 = arg0_41:getFleetType()

	if var0_41 == FleetType.Normal then
		return _.any(arg0_41[TeamType.Vanguard], function(arg0_42)
			return arg0_42.hpRant > 0
		end) and _.any(arg0_41[TeamType.Main], function(arg0_43)
			return arg0_43.hpRant > 0
		end)
	elseif var0_41 == FleetType.Submarine then
		return _.any(arg0_41[TeamType.Submarine], function(arg0_44)
			return arg0_44.hpRant > 0
		end)
	elseif var0_41 == FleetType.Support then
		return true
	end

	return false
end

function var0_0.getCost(arg0_45)
	local var0_45 = {
		gold = 0,
		oil = 0
	}
	local var1_45 = {
		gold = 0,
		oil = 0
	}
	local var2_45 = arg0_45:getShips(false)

	_.each(var2_45, function(arg0_46)
		var0_45.oil = var0_45.oil + arg0_46:getStartBattleExpend()
		var1_45.oil = var1_45.oil + arg0_46:getEndBattleExpend()
	end)

	return var0_45, var1_45
end

function var0_0.getInvestSums(arg0_47, arg1_47)
	local function var0_47(arg0_48, arg1_48)
		local var0_48 = arg1_48:getProperties(arg0_47:getCommanders())

		return arg0_48 + var0_48[AttributeType.Air] + var0_48[AttributeType.Dodge]
	end

	local var1_47 = _.reduce(arg0_47:getShips(arg1_47), 0, var0_47)

	return math.pow(var1_47, 0.666666666666667)
end

function var0_0.getDodgeSums(arg0_49)
	local function var0_49(arg0_50, arg1_50)
		return arg0_50 + arg1_50:getProperties(arg0_49:getCommanders())[AttributeType.Dodge]
	end

	local var1_49 = _.reduce(arg0_49:getShips(false), 0, var0_49)

	return math.pow(var1_49, 0.666666666666667)
end

function var0_0.getAntiAircraftSums(arg0_51)
	local function var0_51(arg0_52, arg1_52)
		return arg0_52 + arg1_52:getProperties(arg0_51:getCommanders())[AttributeType.AntiAircraft]
	end

	return (_.reduce(arg0_51:getShips(false), 0, var0_51))
end

function var0_0.getAirSums(arg0_53, arg1_53)
	local function var0_53(arg0_54, arg1_54)
		return arg0_54 + arg1_54:getProperties(arg0_53:getCommanders())[AttributeType.Air]
	end

	return (_.reduce(arg0_53:getShips(arg1_53), 0, var0_53))
end

function var0_0.getShipAmmo(arg0_55)
	local var0_55 = 0

	if arg0_55:getFleetType() == FleetType.Normal then
		for iter0_55, iter1_55 in pairs(arg0_55.ships) do
			var0_55 = math.max(var0_55, iter1_55:getShipAmmo())
		end
	elseif arg0_55:getFleetType() == FleetType.Submarine then
		for iter2_55, iter3_55 in pairs(arg0_55.ships) do
			var0_55 = var0_55 + iter3_55:getShipAmmo()
		end
	elseif arg0_55:getFleetType() == FleetType.Support then
		var0_55 = 0
	end

	return var0_55
end

function var0_0.clearShipHpChange(arg0_56)
	for iter0_56, iter1_56 in pairs(arg0_56.ships) do
		arg0_56.ships[iter1_56.id].hpChange = 0
	end
end

function var0_0.getEquipAmbushRateReduce(arg0_57)
	local var0_57 = 0

	for iter0_57, iter1_57 in pairs(arg0_57.ships) do
		for iter2_57, iter3_57 in pairs(iter1_57:getActiveEquipments()) do
			if iter3_57 then
				var0_57 = math.max(var0_57, iter3_57:getConfig("equip_parameters").ambush_extra or 0)
			end
		end
	end

	return var0_57 / 10000
end

function var0_0.getEquipDodgeRateUp(arg0_58)
	local var0_58 = 0

	for iter0_58, iter1_58 in pairs(arg0_58.ships) do
		for iter2_58, iter3_58 in pairs(iter1_58:getActiveEquipments()) do
			if iter3_58 then
				var0_58 = math.max(var0_58, iter3_58:getConfig("equip_parameters").avoid_extra or 0)
			end
		end
	end

	return var0_58 / 10000
end

function var0_0.isFormationDiffWith(arg0_59, arg1_59)
	local var0_59 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	for iter0_59, iter1_59 in ipairs(var0_59) do
		local var1_59 = arg0_59[iter1_59]
		local var2_59 = arg1_59[iter1_59]

		for iter2_59 = 1, math.max(#var1_59, #var2_59) do
			if var1_59[iter2_59] ~= var2_59[iter2_59] and (var1_59[iter2_59] == nil or var2_59[iter2_59] == nil or var1_59[iter2_59].id ~= var2_59[iter2_59].id) then
				return true
			end
		end
	end

	return false
end

function var0_0.getShipIds(arg0_60)
	local var0_60 = {}
	local var1_60 = arg0_60:getFleetType()

	if var1_60 == FleetType.Normal then
		_.each(arg0_60[TeamType.Main], function(arg0_61)
			table.insert(var0_60, arg0_61.id)
		end)
		_.each(arg0_60[TeamType.Vanguard], function(arg0_62)
			table.insert(var0_60, arg0_62.id)
		end)
	elseif var1_60 == FleetType.Submarine then
		_.each(arg0_60[TeamType.Submarine], function(arg0_63)
			table.insert(var0_60, arg0_63.id)
		end)
	elseif var1_60 == FleetType.Support then
		for iter0_60, iter1_60 in pairs(arg0_60.ships) do
			table.insert(var0_60, iter1_60.id)
		end
	end

	return var0_60
end

function var0_0.containsSameKind(arg0_64, arg1_64)
	return arg1_64 and _.any(_.values(arg0_64.ships), function(arg0_65)
		return arg1_64:isSameKind(arg0_65)
	end)
end

function var0_0.increaseSlowSpeedFactor(arg0_66)
	arg0_66.slowSpeedFactor = arg0_66.slowSpeedFactor + 1
end

function var0_0.getSpeed(arg0_67)
	local var0_67 = arg0_67:triggerSkill(FleetSkill.TypeMoveSpeed) or 0

	return math.max(arg0_67.baseSpeed + var0_67 - arg0_67.slowSpeedFactor, 1)
end

function var0_0.calcBaseSpeed(arg0_68)
	local var0_68 = arg0_68:getShips(true)
	local var1_68 = _.reduce(var0_68, 0, function(arg0_69, arg1_69)
		return arg0_69 + arg1_69:getProperties()[AttributeType.Speed]
	end) / #var0_68 * (1 - 0.02 * (#var0_68 - 1))
	local var2_68
	local var3_68
	local var4_68 = arg0_68:getFleetType()

	if var4_68 == FleetType.Normal then
		var2_68 = pg.gameset.chapter_move_speed_1.key_value
		var3_68 = pg.gameset.chapter_move_speed_2.key_value
	elseif var4_68 == FleetType.Submarine then
		var2_68 = pg.gameset.submarine_move_speed_1.key_value
		var3_68 = pg.gameset.submarine_move_speed_2.key_value
	elseif var4_68 == FleetType.Support then
		var2_68 = pg.gameset.chapter_move_speed_1.key_value
		var3_68 = pg.gameset.chapter_move_speed_2.key_value
	end

	if var1_68 <= var2_68 then
		return 2
	elseif var3_68 < var1_68 then
		return 4
	else
		return 3
	end
end

function var0_0.getDefeatCount(arg0_70)
	return arg0_70.defeatEnemies
end

function var0_0.getStrategies(arg0_71)
	local var0_71 = arg0_71:getOwnStrategies()

	for iter0_71, iter1_71 in pairs(arg0_71.stgPicked) do
		var0_71[iter0_71] = (var0_71[iter0_71] or 0) + iter1_71
	end

	for iter2_71, iter3_71 in pairs(arg0_71.stgUsed) do
		if var0_71[iter2_71] then
			var0_71[iter2_71] = math.max(0, var0_71[iter2_71] - iter3_71)
		end
	end

	for iter4_71, iter5_71 in pairs(ChapterConst.StrategyPresents) do
		var0_71[iter5_71] = var0_71[iter5_71] or 0
	end

	local var1_71 = {}

	for iter6_71, iter7_71 in pairs(var0_71) do
		table.insert(var1_71, {
			id = iter6_71,
			count = iter7_71
		})
	end

	return _.sort(var1_71, function(arg0_72, arg1_72)
		return arg0_72.id < arg1_72.id
	end)
end

function var0_0.getOwnStrategies(arg0_73)
	local var0_73 = {}
	local var1_73 = arg0_73:getShips(true)

	_.each(var1_73, function(arg0_74)
		local var0_74 = arg0_74:getConfig("strategy_list")

		_.each(var0_74, function(arg0_75)
			var0_73[arg0_75[1]] = (var0_73[arg0_75[1]] or 0) + arg0_75[2]
		end)
	end)

	local var2_73 = arg0_73:triggerSkill(FleetSkill.TypeStrategy)

	if var2_73 then
		_.each(var2_73, function(arg0_76)
			var0_73[arg0_76[1]] = (var0_73[arg0_76[1]] or 0) + arg0_76[2]
		end)
	end

	return var0_73
end

function var0_0.achievedStrategy(arg0_77, arg1_77, arg2_77)
	arg0_77.stgPicked[arg1_77] = (arg0_77.stgPicked[arg1_77] or 0) + arg2_77
end

function var0_0.consumeOneStrategy(arg0_78, arg1_78)
	local var0_78 = arg0_78:getOwnStrategies()

	if var0_78[arg1_78] and var0_78[arg1_78] > 0 then
		local var1_78 = arg0_78.stgUsed

		var1_78[arg1_78] = (var1_78[arg1_78] or 0) + 1
	else
		local var2_78 = arg0_78.stgPicked

		if var2_78[arg1_78] then
			var2_78[arg1_78] = math.max(0, var2_78[arg1_78] - 1)
		end
	end
end

function var0_0.GetStrategyCount(arg0_79, arg1_79)
	local var0_79 = arg0_79:getStrategies()
	local var1_79 = _.detect(var0_79, function(arg0_80)
		return arg0_80.id == arg1_79
	end)

	return var1_79 and var1_79.count or 0
end

function var0_0.getFormationStg(arg0_81)
	return PlayerPrefs.GetInt("team_formation_" .. arg0_81.id, 1)
end

function var0_0.canUseStrategy(arg0_82, arg1_82)
	local var0_82 = pg.strategy_data_template[arg1_82.id]

	if var0_82.type == ChapterConst.StgTypeForm then
		if arg0_82:getFormationStg() == var0_82.id then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_formation_active_already"))

			return false
		end
	elseif var0_82.type == ChapterConst.StgTypeConsume or var0_82.type == ChapterConst.StgTypeBindSupportConsume then
		if arg1_82.count <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_not_enough"))

			return false
		end

		if var0_82.id == ChapterConst.StrategyRepair and _.all(arg0_82:getShips(true), function(arg0_83)
			return arg0_83.hpRant == 0 or arg0_83.hpRant == 10000
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_full_hp"))

			return false
		end
	end

	return true
end

function var0_0.getNextStgUser(arg0_84, arg1_84)
	return arg0_84.id
end

function var0_0.GetStatusStrategy(arg0_85)
	return arg0_85.stgIds
end

function var0_0.getFleetType(arg0_86)
	assert(arg0_86.fleetType)

	return arg0_86.fleetType
end

function var0_0.canClearTorpedo(arg0_87)
	local var0_87 = arg0_87:getShipsByTeam(TeamType.Vanguard, true)

	return _.any(var0_87, function(arg0_88)
		return ShipType.IsTypeQuZhu(arg0_88:getShipType())
	end)
end

function var0_0.getHuntingRange(arg0_89, arg1_89)
	if arg0_89:getFleetType() ~= FleetType.Submarine then
		assert(false)

		return {}
	end

	local var0_89 = arg1_89 or arg0_89.startPos
	local var1_89 = arg0_89:getShipsByTeam(TeamType.Submarine, true)[1]
	local var2_89 = arg0_89:triggerSkill(FleetSkill.TypeHuntingLv) or 0
	local var3_89 = var1_89:getHuntingRange(var1_89:getHuntingLv() + var2_89)

	return (_.map(var3_89, function(arg0_90)
		return {
			row = var0_89.row + arg0_90[1],
			column = var0_89.column + arg0_90[2]
		}
	end))
end

function var0_0.inHuntingRange(arg0_91, arg1_91, arg2_91)
	return _.any(arg0_91:getHuntingRange(), function(arg0_92)
		return arg0_92.row == arg1_91 and arg0_92.column == arg2_91
	end)
end

function var0_0.getSummonCost(arg0_93)
	local var0_93 = arg0_93:getShips(false)

	return _.reduce(var0_93, 0, function(arg0_94, arg1_94)
		return arg0_94 + arg1_94:getEndBattleExpend()
	end)
end

function var0_0.getMapAura(arg0_95)
	local var0_95 = {}

	for iter0_95, iter1_95 in pairs(arg0_95.ships) do
		local var1_95 = iter1_95:getMapAuras()

		for iter2_95, iter3_95 in ipairs(var1_95) do
			table.insert(var0_95, iter3_95)
		end
	end

	return var0_95
end

function var0_0.getMapAid(arg0_96)
	local var0_96 = {}

	for iter0_96, iter1_96 in pairs(arg0_96.ships) do
		local var1_96 = iter1_96:getMapAids()

		for iter2_96, iter3_96 in ipairs(var1_96) do
			local var2_96 = var0_96[iter1_96] or {}

			table.insert(var2_96, iter3_96)

			var0_96[iter1_96] = var2_96
		end
	end

	return var0_96
end

function var0_0.updateCommanderSkills(arg0_97)
	local var0_97 = arg0_97:getCommanders()

	for iter0_97, iter1_97 in pairs(var0_97) do
		_.each(iter1_97:getSkills(), function(arg0_98)
			_.each(arg0_98:getTacticSkill(), function(arg0_99)
				table.insert(arg0_97.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, arg0_99))
			end)
		end)
	end
end

function var0_0.getSkills(arg0_100)
	return arg0_100.skills
end

function var0_0.getSkill(arg0_101, arg1_101)
	return _.detect(arg0_101:getSkills(), function(arg0_102)
		return arg0_102.id == arg1_101
	end)
end

function var0_0.findSkills(arg0_103, arg1_103)
	return _.filter(arg0_103:getSkills(), function(arg0_104)
		return arg0_104:GetType() == arg1_103
	end)
end

function var0_0.triggerSkill(arg0_105, arg1_105)
	return arg0_105.chapter:triggerSkill(arg0_105, arg1_105)
end

function var0_0.findCommanderBySkillId(arg0_106, arg1_106)
	local var0_106 = arg0_106:getCommanders()

	for iter0_106, iter1_106 in pairs(var0_106) do
		if _.any(iter1_106:getSkills(), function(arg0_107)
			return _.any(arg0_107:getTacticSkill(), function(arg0_108)
				return arg0_108 == arg1_106
			end)
		end) then
			return iter1_106
		end
	end
end

function var0_0.getFleetAirDominanceValue(arg0_109)
	local var0_109 = 0

	for iter0_109, iter1_109 in ipairs(arg0_109:getShips(false)) do
		var0_109 = var0_109 + calcAirDominanceValue(iter1_109, arg0_109:getCommanders())
	end

	return var0_109
end

function var0_0.StaticTransformChapterFleet2Fleet(arg0_110, arg1_110)
	local var0_110 = _.pluck(arg0_110:getShipsByTeam(TeamType.Vanguard, arg1_110), "id")

	table.insertto(var0_110, _.pluck(arg0_110:getShipsByTeam(TeamType.Main, arg1_110), "id"))

	local var1_110 = {}

	for iter0_110, iter1_110 in pairs(arg0_110.commanders) do
		table.insert(var1_110, {
			pos = iter0_110,
			id = iter1_110 and iter1_110.id
		})
	end

	return TypedFleet.New({
		fleetType = FleetType.Normal,
		ship_list = var0_110,
		commanders = var1_110
	})
end

return var0_0
