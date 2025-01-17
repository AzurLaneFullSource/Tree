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

	arg0_1:updateCommanders(arg1_1.commander_list)

	arg0_1.skills = {}

	arg0_1:updateCommanderSkills()
end

function var0_0.setup(arg0_6, arg1_6)
	arg0_6.chapter = arg1_6
end

function var0_0.fetchShipVO(arg0_7, arg1_7)
	local var0_7

	if arg0_7.npcShipList[arg1_7] then
		var0_7 = Clone(arg0_7.npcShipList[arg1_7])
	else
		var0_7 = getProxy(BayProxy):getShipById(arg1_7)
	end

	if arg0_7.staticsReady then
		var0_7.triggers.TeamNumbers = arg0_7.statics[var0_7:getTeamType()].count
	end

	return var0_7
end

function var0_0.updateNpcShipList(arg0_8, arg1_8)
	arg0_8.npcShipList = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		arg0_8.npcShipList[iter1_8.id] = iter1_8
	end
end

function var0_0.GetLine(arg0_9)
	return arg0_9.line
end

function var0_0.SetLine(arg0_10, arg1_10)
	arg0_10.line = {
		row = arg1_10.row,
		column = arg1_10.column
	}
end

function var0_0.updateCommanders(arg0_11, arg1_11)
	arg0_11.commanders = {}

	local var0_11 = getProxy(CommanderProxy)

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		local var1_11 = iter1_11.id
		local var2_11 = var0_11:getCommanderById(var1_11)

		if var2_11 then
			arg0_11.commanders[iter1_11.pos] = var2_11
		end
	end
end

function var0_0.getCommanders(arg0_12)
	return arg0_12.commanders or {}
end

function var0_0.prepareShips(arg0_13, arg1_13)
	arg0_13.statics = {}
	arg0_13.statics[TeamType.Vanguard] = {
		count = 0
	}
	arg0_13.statics[TeamType.Main] = {
		count = 0
	}
	arg0_13.statics[TeamType.Submarine] = {
		count = 0
	}

	_.each(arg1_13 or {}, function(arg0_14)
		local var0_14 = arg0_13:fetchShipVO(arg0_14.id)

		if var0_14 then
			local var1_14 = arg0_13.statics[var0_14:getTeamType()]

			var1_14.count = var1_14.count + 1
		end
	end)

	arg0_13.staticsReady = true
end

function var0_0.updateShips(arg0_15, arg1_15)
	arg0_15[TeamType.Vanguard] = {}
	arg0_15[TeamType.Main] = {}
	arg0_15[TeamType.Submarine] = {}
	arg0_15.ships = {}

	_.each(arg1_15 or {}, function(arg0_16)
		local var0_16 = arg0_15:fetchShipVO(arg0_16.id)

		if var0_16 then
			var0_16.hpRant = arg0_16.hp_rant
			arg0_15.ships[var0_16.id] = var0_16

			table.insert(arg0_15[var0_16:getTeamType()], var0_16)
		end
	end)
	arg0_15:ResortShips()
end

function var0_0.ResortShips(arg0_17)
	local var0_17 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	_.each(var0_17, function(arg0_18)
		local var0_18 = arg0_17[arg0_18]
		local var1_18 = {}

		table.Ipairs(var0_18, function(arg0_19, arg1_19)
			var1_18[arg1_19] = arg0_19
		end)
		table.sort(var0_18, CompareFuncs({
			function(arg0_20)
				return arg0_20.hpRant > 0 and 0 or 1
			end,
			function(arg0_21)
				return var1_18[arg0_21]
			end
		}))
	end)
end

function var0_0.getTeamByName(arg0_22, arg1_22)
	local var0_22 = {}
	local var1_22 = arg0_22[arg1_22]

	for iter0_22, iter1_22 in ipairs(var1_22) do
		table.insert(var0_22, iter1_22.id)
	end

	return var0_22
end

function var0_0.flushShips(arg0_23)
	local var0_23 = getProxy(FleetProxy):getFleetById(arg0_23.fleetId)

	arg0_23.name = var0_23 and var0_23.name ~= "" and var0_23.name or Fleet.DEFAULT_NAME[arg0_23.fleetId] or Fleet.DEFAULT_NAME[arg0_23.id]

	local var1_23 = _.keys(arg0_23.ships)

	for iter0_23, iter1_23 in ipairs(var1_23) do
		local var2_23 = arg0_23:fetchShipVO(iter1_23)

		if var2_23 then
			var2_23.hpRant = arg0_23.ships[iter1_23].hpRant
		end

		arg0_23.ships[iter1_23] = var2_23
	end

	local var3_23 = {}

	_.each(arg0_23[TeamType.Vanguard], function(arg0_24)
		if arg0_23.ships[arg0_24.id] then
			table.insert(var3_23, arg0_23.ships[arg0_24.id])
		end
	end)

	arg0_23[TeamType.Vanguard] = var3_23

	local var4_23 = {}

	_.each(arg0_23[TeamType.Main], function(arg0_25)
		if arg0_23.ships[arg0_25.id] then
			table.insert(var4_23, arg0_23.ships[arg0_25.id])
		end
	end)

	arg0_23[TeamType.Main] = var4_23

	local var5_23 = {}

	_.each(arg0_23[TeamType.Submarine], function(arg0_26)
		if arg0_23.ships[arg0_26.id] then
			table.insert(var5_23, arg0_23.ships[arg0_26.id])
		end
	end)

	arg0_23[TeamType.Submarine] = var5_23
end

function var0_0.updateShipHp(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.ships[arg1_27]

	if var0_27 then
		var0_27.hpChange = arg2_27 - var0_27.hpRant
		var0_27.hpRant = arg2_27

		arg0_27:ResortShips()
	end
end

function var0_0.getShip(arg0_28, arg1_28)
	return arg0_28.ships[arg1_28]
end

function var0_0.getShips(arg0_29, arg1_29)
	local var0_29 = {}
	local var1_29 = arg0_29:getFleetType()

	if var1_29 == FleetType.Normal then
		_.each(arg0_29:getShipsByTeam(TeamType.Main, arg1_29), function(arg0_30)
			table.insert(var0_29, arg0_30)
		end)
		_.each(arg0_29:getShipsByTeam(TeamType.Vanguard, arg1_29), function(arg0_31)
			table.insert(var0_29, arg0_31)
		end)
	elseif var1_29 == FleetType.Submarine then
		_.each(arg0_29:getShipsByTeam(TeamType.Submarine, arg1_29), function(arg0_32)
			table.insert(var0_29, arg0_32)
		end)
	elseif var1_29 == FleetType.Support then
		_.each(arg0_29:getShipsByTeam(TeamType.Main, arg1_29), function(arg0_33)
			table.insert(var0_29, arg0_33)
		end)
	end

	return var0_29
end

function var0_0.getShipsByTeam(arg0_34, arg1_34, arg2_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in ipairs(arg0_34[arg1_34]) do
		if iter1_34.hpRant > 0 then
			var0_34[#var0_34 + 1] = iter1_34
		end
	end

	if arg2_34 then
		for iter2_34, iter3_34 in ipairs(arg0_34[arg1_34]) do
			if iter3_34.hpRant <= 0 then
				var0_34[#var0_34 + 1] = iter3_34
			end
		end
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

function var0_0.getShipAmmo(arg0_53)
	local var0_53 = 0

	if arg0_53:getFleetType() == FleetType.Normal then
		for iter0_53, iter1_53 in pairs(arg0_53.ships) do
			var0_53 = math.max(var0_53, iter1_53:getShipAmmo())
		end
	elseif arg0_53:getFleetType() == FleetType.Submarine then
		for iter2_53, iter3_53 in pairs(arg0_53.ships) do
			var0_53 = var0_53 + iter3_53:getShipAmmo()
		end
	elseif arg0_53:getFleetType() == FleetType.Support then
		var0_53 = 0
	end

	return var0_53
end

function var0_0.clearShipHpChange(arg0_54)
	for iter0_54, iter1_54 in pairs(arg0_54.ships) do
		arg0_54.ships[iter1_54.id].hpChange = 0
	end
end

function var0_0.getEquipAmbushRateReduce(arg0_55)
	local var0_55 = 0

	for iter0_55, iter1_55 in pairs(arg0_55.ships) do
		for iter2_55, iter3_55 in pairs(iter1_55:getActiveEquipments()) do
			if iter3_55 then
				var0_55 = math.max(var0_55, iter3_55:getConfig("equip_parameters").ambush_extra or 0)
			end
		end
	end

	return var0_55 / 10000
end

function var0_0.getEquipDodgeRateUp(arg0_56)
	local var0_56 = 0

	for iter0_56, iter1_56 in pairs(arg0_56.ships) do
		for iter2_56, iter3_56 in pairs(iter1_56:getActiveEquipments()) do
			if iter3_56 then
				var0_56 = math.max(var0_56, iter3_56:getConfig("equip_parameters").avoid_extra or 0)
			end
		end
	end

	return var0_56 / 10000
end

function var0_0.isFormationDiffWith(arg0_57, arg1_57)
	local var0_57 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	for iter0_57, iter1_57 in ipairs(var0_57) do
		local var1_57 = arg0_57[iter1_57]
		local var2_57 = arg1_57[iter1_57]

		for iter2_57 = 1, math.max(#var1_57, #var2_57) do
			if var1_57[iter2_57] ~= var2_57[iter2_57] and (var1_57[iter2_57] == nil or var2_57[iter2_57] == nil or var1_57[iter2_57].id ~= var2_57[iter2_57].id) then
				return true
			end
		end
	end

	return false
end

function var0_0.getShipIds(arg0_58)
	local var0_58 = {}
	local var1_58 = arg0_58:getFleetType()

	if var1_58 == FleetType.Normal then
		_.each(arg0_58[TeamType.Main], function(arg0_59)
			table.insert(var0_58, arg0_59.id)
		end)
		_.each(arg0_58[TeamType.Vanguard], function(arg0_60)
			table.insert(var0_58, arg0_60.id)
		end)
	elseif var1_58 == FleetType.Submarine then
		_.each(arg0_58[TeamType.Submarine], function(arg0_61)
			table.insert(var0_58, arg0_61.id)
		end)
	elseif var1_58 == FleetType.Support then
		for iter0_58, iter1_58 in pairs(arg0_58.ships) do
			table.insert(var0_58, iter1_58.id)
		end
	end

	return var0_58
end

function var0_0.containsSameKind(arg0_62, arg1_62)
	return arg1_62 and _.any(_.values(arg0_62.ships), function(arg0_63)
		return arg1_62:isSameKind(arg0_63)
	end)
end

function var0_0.increaseSlowSpeedFactor(arg0_64)
	arg0_64.slowSpeedFactor = arg0_64.slowSpeedFactor + 1
end

function var0_0.getSpeed(arg0_65)
	local var0_65 = arg0_65:triggerSkill(FleetSkill.TypeMoveSpeed) or 0

	return math.max(arg0_65.baseSpeed + var0_65 - arg0_65.slowSpeedFactor, 1)
end

function var0_0.calcBaseSpeed(arg0_66)
	local var0_66 = arg0_66:getShips(true)
	local var1_66 = _.reduce(var0_66, 0, function(arg0_67, arg1_67)
		return arg0_67 + arg1_67:getProperties()[AttributeType.Speed]
	end) / #var0_66 * (1 - 0.02 * (#var0_66 - 1))
	local var2_66
	local var3_66
	local var4_66 = arg0_66:getFleetType()

	if var4_66 == FleetType.Normal then
		var2_66 = pg.gameset.chapter_move_speed_1.key_value
		var3_66 = pg.gameset.chapter_move_speed_2.key_value
	elseif var4_66 == FleetType.Submarine then
		var2_66 = pg.gameset.submarine_move_speed_1.key_value
		var3_66 = pg.gameset.submarine_move_speed_2.key_value
	elseif var4_66 == FleetType.Support then
		var2_66 = pg.gameset.chapter_move_speed_1.key_value
		var3_66 = pg.gameset.chapter_move_speed_2.key_value
	end

	if var1_66 <= var2_66 then
		return 2
	elseif var3_66 < var1_66 then
		return 4
	else
		return 3
	end
end

function var0_0.getDefeatCount(arg0_68)
	return arg0_68.defeatEnemies
end

function var0_0.getStrategies(arg0_69)
	local var0_69 = arg0_69:getOwnStrategies()

	for iter0_69, iter1_69 in pairs(arg0_69.stgPicked) do
		var0_69[iter0_69] = (var0_69[iter0_69] or 0) + iter1_69
	end

	for iter2_69, iter3_69 in pairs(arg0_69.stgUsed) do
		if var0_69[iter2_69] then
			var0_69[iter2_69] = math.max(0, var0_69[iter2_69] - iter3_69)
		end
	end

	for iter4_69, iter5_69 in pairs(ChapterConst.StrategyPresents) do
		var0_69[iter5_69] = var0_69[iter5_69] or 0
	end

	local var1_69 = {}

	for iter6_69, iter7_69 in pairs(var0_69) do
		table.insert(var1_69, {
			id = iter6_69,
			count = iter7_69
		})
	end

	return _.sort(var1_69, function(arg0_70, arg1_70)
		return arg0_70.id < arg1_70.id
	end)
end

function var0_0.getOwnStrategies(arg0_71)
	local var0_71 = {}
	local var1_71 = arg0_71:getShips(true)

	_.each(var1_71, function(arg0_72)
		local var0_72 = arg0_72:getConfig("strategy_list")

		_.each(var0_72, function(arg0_73)
			var0_71[arg0_73[1]] = (var0_71[arg0_73[1]] or 0) + arg0_73[2]
		end)
	end)

	local var2_71 = arg0_71:triggerSkill(FleetSkill.TypeStrategy)

	if var2_71 then
		_.each(var2_71, function(arg0_74)
			var0_71[arg0_74[1]] = (var0_71[arg0_74[1]] or 0) + arg0_74[2]
		end)
	end

	return var0_71
end

function var0_0.achievedStrategy(arg0_75, arg1_75, arg2_75)
	arg0_75.stgPicked[arg1_75] = (arg0_75.stgPicked[arg1_75] or 0) + arg2_75
end

function var0_0.consumeOneStrategy(arg0_76, arg1_76)
	local var0_76 = arg0_76:getOwnStrategies()

	if var0_76[arg1_76] and var0_76[arg1_76] > 0 then
		local var1_76 = arg0_76.stgUsed

		var1_76[arg1_76] = (var1_76[arg1_76] or 0) + 1
	else
		local var2_76 = arg0_76.stgPicked

		if var2_76[arg1_76] then
			var2_76[arg1_76] = math.max(0, var2_76[arg1_76] - 1)
		end
	end
end

function var0_0.GetStrategyCount(arg0_77, arg1_77)
	local var0_77 = arg0_77:getStrategies()
	local var1_77 = _.detect(var0_77, function(arg0_78)
		return arg0_78.id == arg1_77
	end)

	return var1_77 and var1_77.count or 0
end

function var0_0.getFormationStg(arg0_79)
	return PlayerPrefs.GetInt("team_formation_" .. arg0_79.id, 1)
end

function var0_0.canUseStrategy(arg0_80, arg1_80)
	local var0_80 = pg.strategy_data_template[arg1_80.id]

	if var0_80.type == ChapterConst.StgTypeForm then
		if arg0_80:getFormationStg() == var0_80.id then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_formation_active_already"))

			return false
		end
	elseif var0_80.type == ChapterConst.StgTypeConsume or var0_80.type == ChapterConst.StgTypeBindSupportConsume then
		if arg1_80.count <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_not_enough"))

			return false
		end

		if var0_80.id == ChapterConst.StrategyRepair and _.all(arg0_80:getShips(true), function(arg0_81)
			return arg0_81.hpRant == 0 or arg0_81.hpRant == 10000
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_full_hp"))

			return false
		end
	end

	return true
end

function var0_0.getNextStgUser(arg0_82, arg1_82)
	return arg0_82.id
end

function var0_0.GetStatusStrategy(arg0_83)
	return arg0_83.stgIds
end

function var0_0.getFleetType(arg0_84)
	local var0_84 = 0

	for iter0_84, iter1_84 in pairs(arg0_84.ships) do
		local var1_84 = iter1_84:getTeamType()

		if var1_84 == TeamType.Submarine then
			return FleetType.Submarine
		elseif var1_84 == TeamType.Vanguard then
			var0_84 = var0_84 + 1
		end
	end

	if var0_84 == 0 then
		return FleetType.Support
	else
		return FleetType.Normal
	end
end

function var0_0.canClearTorpedo(arg0_85)
	local var0_85 = arg0_85:getShipsByTeam(TeamType.Vanguard, true)

	return _.any(var0_85, function(arg0_86)
		return ShipType.IsTypeQuZhu(arg0_86:getShipType())
	end)
end

function var0_0.getHuntingRange(arg0_87, arg1_87)
	if arg0_87:getFleetType() ~= FleetType.Submarine then
		assert(false)

		return {}
	end

	local var0_87 = arg1_87 or arg0_87.startPos
	local var1_87 = arg0_87:getShipsByTeam(TeamType.Submarine, true)[1]
	local var2_87 = arg0_87:triggerSkill(FleetSkill.TypeHuntingLv) or 0
	local var3_87 = var1_87:getHuntingRange(var1_87:getHuntingLv() + var2_87)

	return (_.map(var3_87, function(arg0_88)
		return {
			row = var0_87.row + arg0_88[1],
			column = var0_87.column + arg0_88[2]
		}
	end))
end

function var0_0.inHuntingRange(arg0_89, arg1_89, arg2_89)
	return _.any(arg0_89:getHuntingRange(), function(arg0_90)
		return arg0_90.row == arg1_89 and arg0_90.column == arg2_89
	end)
end

function var0_0.getSummonCost(arg0_91)
	local var0_91 = arg0_91:getShips(false)

	return _.reduce(var0_91, 0, function(arg0_92, arg1_92)
		return arg0_92 + arg1_92:getEndBattleExpend()
	end)
end

function var0_0.getMapAura(arg0_93)
	local var0_93 = {}

	for iter0_93, iter1_93 in pairs(arg0_93.ships) do
		local var1_93 = iter1_93:getMapAuras()

		for iter2_93, iter3_93 in ipairs(var1_93) do
			table.insert(var0_93, iter3_93)
		end
	end

	return var0_93
end

function var0_0.getMapAid(arg0_94)
	local var0_94 = {}

	for iter0_94, iter1_94 in pairs(arg0_94.ships) do
		local var1_94 = iter1_94:getMapAids()

		for iter2_94, iter3_94 in ipairs(var1_94) do
			local var2_94 = var0_94[iter1_94] or {}

			table.insert(var2_94, iter3_94)

			var0_94[iter1_94] = var2_94
		end
	end

	return var0_94
end

function var0_0.updateCommanderSkills(arg0_95)
	local var0_95 = arg0_95:getCommanders()

	for iter0_95, iter1_95 in pairs(var0_95) do
		_.each(iter1_95:getSkills(), function(arg0_96)
			_.each(arg0_96:getTacticSkill(), function(arg0_97)
				table.insert(arg0_95.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, arg0_97))
			end)
		end)
	end
end

function var0_0.getSkills(arg0_98)
	return arg0_98.skills
end

function var0_0.getSkill(arg0_99, arg1_99)
	return _.detect(arg0_99:getSkills(), function(arg0_100)
		return arg0_100.id == arg1_99
	end)
end

function var0_0.findSkills(arg0_101, arg1_101)
	return _.filter(arg0_101:getSkills(), function(arg0_102)
		return arg0_102:GetType() == arg1_101
	end)
end

function var0_0.triggerSkill(arg0_103, arg1_103)
	return arg0_103.chapter:triggerSkill(arg0_103, arg1_103)
end

function var0_0.findCommanderBySkillId(arg0_104, arg1_104)
	local var0_104 = arg0_104:getCommanders()

	for iter0_104, iter1_104 in pairs(var0_104) do
		if _.any(iter1_104:getSkills(), function(arg0_105)
			return _.any(arg0_105:getTacticSkill(), function(arg0_106)
				return arg0_106 == arg1_104
			end)
		end) then
			return iter1_104
		end
	end
end

function var0_0.getFleetAirDominanceValue(arg0_107)
	local var0_107 = 0

	for iter0_107, iter1_107 in ipairs(arg0_107:getShips(false)) do
		var0_107 = var0_107 + calcAirDominanceValue(iter1_107, arg0_107:getCommanders())
	end

	return var0_107
end

function var0_0.StaticTransformChapterFleet2Fleet(arg0_108, arg1_108)
	local var0_108 = _.pluck(arg0_108:getShipsByTeam(TeamType.Vanguard, arg1_108), "id")

	table.insertto(var0_108, _.pluck(arg0_108:getShipsByTeam(TeamType.Main, arg1_108), "id"))

	local var1_108 = {}

	for iter0_108, iter1_108 in pairs(arg0_108.commanders) do
		table.insert(var1_108, {
			pos = iter0_108,
			id = iter1_108 and iter1_108.id
		})
	end

	return TypedFleet.New({
		fleetType = FleetType.Normal,
		ship_list = var0_108,
		commanders = var1_108
	})
end

return var0_0
