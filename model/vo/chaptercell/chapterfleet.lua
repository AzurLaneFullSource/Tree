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
		for iter0_29, iter1_29 in pairs(arg0_29.ships) do
			table.insert(var0_29, iter1_29)
		end
	end

	return var0_29
end

function var0_0.getShipsByTeam(arg0_33, arg1_33, arg2_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in ipairs(arg0_33[arg1_33]) do
		if iter1_33.hpRant > 0 then
			var0_33[#var0_33 + 1] = iter1_33
		end
	end

	if arg2_33 then
		for iter2_33, iter3_33 in ipairs(arg0_33[arg1_33]) do
			if iter3_33.hpRant <= 0 then
				var0_33[#var0_33 + 1] = iter3_33
			end
		end
	end

	return var0_33
end

function var0_0.containsShip(arg0_34, arg1_34)
	return arg0_34.ships[arg1_34] and true or false
end

function var0_0.replaceShip(arg0_35, arg1_35, arg2_35)
	errorMsg("ChapterFleet replaceShip function used")

	if arg0_35.ships[arg1_35] and not arg0_35.ships[arg2_35.id] then
		local var0_35 = arg0_35.ships[arg1_35]
		local var1_35 = arg0_35:fetchShipVO(arg2_35.id)

		if var1_35 then
			if var1_35:getTeamType() == var0_35:getTeamType() then
				if not var0_35:isSameKind(var1_35) and arg0_35:containsSameKind(var1_35) then
					arg0_35:removeShip(arg1_35)
				else
					var1_35.hpRant = arg2_35.hp_rant
					arg0_35.ships[arg1_35] = nil
					arg0_35.ships[var1_35.id] = var1_35

					local var2_35 = arg0_35[var1_35:getTeamType()]

					for iter0_35 = 1, #var2_35 do
						if var2_35[iter0_35].id == arg1_35 then
							var2_35[iter0_35] = var1_35

							break
						end
					end
				end
			else
				arg0_35:removeShip(arg1_35)
			end
		end
	end
end

function var0_0.addShip(arg0_36, arg1_36)
	errorMsg("ChapterFleet addShip function used")

	if not arg0_36.ships[arg1_36.id] then
		local var0_36 = arg0_36:fetchShipVO(arg1_36.id)

		if var0_36 then
			var0_36.hpRant = arg1_36.hp_rant

			local var1_36 = arg0_36[var0_36:getTeamType()]

			if #var1_36 < 3 then
				table.insert(var1_36, var0_36)

				arg0_36.ships[var0_36.id] = var0_36

				arg0_36:ResortShips()
			end
		end
	end
end

function var0_0.removeShip(arg0_37, arg1_37)
	errorMsg("ChapterFleet removeShip function used")

	arg0_37.ships[arg1_37] = nil

	local var0_37 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	for iter0_37 = 1, #var0_37 do
		local var1_37 = arg0_37[var0_37[iter0_37]]

		for iter1_37 = #var1_37, 1, -1 do
			if var1_37[iter1_37].id == arg1_37 then
				table.remove(var1_37, iter1_37)
			end
		end
	end
end

function var0_0.switchShip(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = arg0_38:getShipsByTeam(arg1_38, false)
	local var1_38 = var0_38[arg2_38].id
	local var2_38 = var0_38[arg3_38].id
	local var3_38
	local var4_38
	local var5_38
	local var6_38

	for iter0_38, iter1_38 in pairs(arg0_38.ships) do
		if iter0_38 == var1_38 then
			var3_38 = iter1_38:getTeamType()
			var4_38 = table.indexof(arg0_38[var3_38], iter1_38)
		end

		if iter0_38 == var2_38 then
			var5_38 = iter1_38:getTeamType()
			var6_38 = table.indexof(arg0_38[var5_38], iter1_38)
		end
	end

	assert(var4_38 and var6_38)

	if var3_38 == var5_38 and var4_38 ~= var6_38 then
		arg0_38[var3_38][var4_38], arg0_38[var5_38][var6_38] = arg0_38[var5_38][var6_38], arg0_38[var3_38][var4_38]
	end
end

function var0_0.synchronousShipIndex(arg0_39, arg1_39)
	local var0_39 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	for iter0_39, iter1_39 in ipairs(var0_39) do
		for iter2_39 = 1, 3 do
			if arg1_39[iter1_39][iter2_39] then
				local var1_39 = arg1_39[iter1_39][iter2_39].id

				arg0_39[iter1_39][iter2_39] = arg0_39.ships[var1_39]
			else
				arg0_39[iter1_39][iter2_39] = nil
			end
		end
	end
end

function var0_0.isValid(arg0_40)
	local var0_40 = arg0_40:getFleetType()

	if var0_40 == FleetType.Normal then
		return _.any(arg0_40[TeamType.Vanguard], function(arg0_41)
			return arg0_41.hpRant > 0
		end) and _.any(arg0_40[TeamType.Main], function(arg0_42)
			return arg0_42.hpRant > 0
		end)
	elseif var0_40 == FleetType.Submarine then
		return _.any(arg0_40[TeamType.Submarine], function(arg0_43)
			return arg0_43.hpRant > 0
		end)
	elseif var0_40 == FleetType.Support then
		return true
	end

	return false
end

function var0_0.getCost(arg0_44)
	local var0_44 = {
		gold = 0,
		oil = 0
	}
	local var1_44 = {
		gold = 0,
		oil = 0
	}
	local var2_44 = arg0_44:getShips(false)

	_.each(var2_44, function(arg0_45)
		var0_44.oil = var0_44.oil + arg0_45:getStartBattleExpend()
		var1_44.oil = var1_44.oil + arg0_45:getEndBattleExpend()
	end)

	return var0_44, var1_44
end

function var0_0.getInvestSums(arg0_46, arg1_46)
	local function var0_46(arg0_47, arg1_47)
		local var0_47 = arg1_47:getProperties(arg0_46:getCommanders())

		return arg0_47 + var0_47[AttributeType.Air] + var0_47[AttributeType.Dodge]
	end

	local var1_46 = _.reduce(arg0_46:getShips(arg1_46), 0, var0_46)

	return math.pow(var1_46, 0.666666666666667)
end

function var0_0.getDodgeSums(arg0_48)
	local function var0_48(arg0_49, arg1_49)
		return arg0_49 + arg1_49:getProperties(arg0_48:getCommanders())[AttributeType.Dodge]
	end

	local var1_48 = _.reduce(arg0_48:getShips(false), 0, var0_48)

	return math.pow(var1_48, 0.666666666666667)
end

function var0_0.getAntiAircraftSums(arg0_50)
	local function var0_50(arg0_51, arg1_51)
		return arg0_51 + arg1_51:getProperties(arg0_50:getCommanders())[AttributeType.AntiAircraft]
	end

	return (_.reduce(arg0_50:getShips(false), 0, var0_50))
end

function var0_0.getShipAmmo(arg0_52)
	local var0_52 = 0

	if arg0_52:getFleetType() == FleetType.Normal then
		for iter0_52, iter1_52 in pairs(arg0_52.ships) do
			var0_52 = math.max(var0_52, iter1_52:getShipAmmo())
		end
	elseif arg0_52:getFleetType() == FleetType.Submarine then
		for iter2_52, iter3_52 in pairs(arg0_52.ships) do
			var0_52 = var0_52 + iter3_52:getShipAmmo()
		end
	elseif arg0_52:getFleetType() == FleetType.Support then
		var0_52 = 0
	end

	return var0_52
end

function var0_0.clearShipHpChange(arg0_53)
	for iter0_53, iter1_53 in pairs(arg0_53.ships) do
		arg0_53.ships[iter1_53.id].hpChange = 0
	end
end

function var0_0.getEquipAmbushRateReduce(arg0_54)
	local var0_54 = 0

	for iter0_54, iter1_54 in pairs(arg0_54.ships) do
		for iter2_54, iter3_54 in pairs(iter1_54:getActiveEquipments()) do
			if iter3_54 then
				var0_54 = math.max(var0_54, iter3_54:getConfig("equip_parameters").ambush_extra or 0)
			end
		end
	end

	return var0_54 / 10000
end

function var0_0.getEquipDodgeRateUp(arg0_55)
	local var0_55 = 0

	for iter0_55, iter1_55 in pairs(arg0_55.ships) do
		for iter2_55, iter3_55 in pairs(iter1_55:getActiveEquipments()) do
			if iter3_55 then
				var0_55 = math.max(var0_55, iter3_55:getConfig("equip_parameters").avoid_extra or 0)
			end
		end
	end

	return var0_55 / 10000
end

function var0_0.isFormationDiffWith(arg0_56, arg1_56)
	local var0_56 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	for iter0_56, iter1_56 in ipairs(var0_56) do
		local var1_56 = arg0_56[iter1_56]
		local var2_56 = arg1_56[iter1_56]

		for iter2_56 = 1, math.max(#var1_56, #var2_56) do
			if var1_56[iter2_56] ~= var2_56[iter2_56] and (var1_56[iter2_56] == nil or var2_56[iter2_56] == nil or var1_56[iter2_56].id ~= var2_56[iter2_56].id) then
				return true
			end
		end
	end

	return false
end

function var0_0.getShipIds(arg0_57)
	local var0_57 = {}
	local var1_57 = arg0_57:getFleetType()

	if var1_57 == FleetType.Normal then
		_.each(arg0_57[TeamType.Main], function(arg0_58)
			table.insert(var0_57, arg0_58.id)
		end)
		_.each(arg0_57[TeamType.Vanguard], function(arg0_59)
			table.insert(var0_57, arg0_59.id)
		end)
	elseif var1_57 == FleetType.Submarine then
		_.each(arg0_57[TeamType.Submarine], function(arg0_60)
			table.insert(var0_57, arg0_60.id)
		end)
	elseif var1_57 == FleetType.Support then
		for iter0_57, iter1_57 in pairs(arg0_57.ships) do
			table.insert(var0_57, iter1_57.id)
		end
	end

	return var0_57
end

function var0_0.containsSameKind(arg0_61, arg1_61)
	return arg1_61 and _.any(_.values(arg0_61.ships), function(arg0_62)
		return arg1_61:isSameKind(arg0_62)
	end)
end

function var0_0.increaseSlowSpeedFactor(arg0_63)
	arg0_63.slowSpeedFactor = arg0_63.slowSpeedFactor + 1
end

function var0_0.getSpeed(arg0_64)
	local var0_64 = arg0_64:triggerSkill(FleetSkill.TypeMoveSpeed) or 0

	return math.max(arg0_64.baseSpeed + var0_64 - arg0_64.slowSpeedFactor, 1)
end

function var0_0.calcBaseSpeed(arg0_65)
	local var0_65 = arg0_65:getShips(true)
	local var1_65 = _.reduce(var0_65, 0, function(arg0_66, arg1_66)
		return arg0_66 + arg1_66:getProperties()[AttributeType.Speed]
	end) / #var0_65 * (1 - 0.02 * (#var0_65 - 1))
	local var2_65
	local var3_65
	local var4_65 = arg0_65:getFleetType()

	if var4_65 == FleetType.Normal then
		var2_65 = pg.gameset.chapter_move_speed_1.key_value
		var3_65 = pg.gameset.chapter_move_speed_2.key_value
	elseif var4_65 == FleetType.Submarine then
		var2_65 = pg.gameset.submarine_move_speed_1.key_value
		var3_65 = pg.gameset.submarine_move_speed_2.key_value
	elseif var4_65 == FleetType.Support then
		var2_65 = pg.gameset.chapter_move_speed_1.key_value
		var3_65 = pg.gameset.chapter_move_speed_2.key_value
	end

	if var1_65 <= var2_65 then
		return 2
	elseif var3_65 < var1_65 then
		return 4
	else
		return 3
	end
end

function var0_0.getDefeatCount(arg0_67)
	return arg0_67.defeatEnemies
end

function var0_0.getStrategies(arg0_68)
	local var0_68 = arg0_68:getOwnStrategies()

	for iter0_68, iter1_68 in pairs(arg0_68.stgPicked) do
		var0_68[iter0_68] = (var0_68[iter0_68] or 0) + iter1_68
	end

	for iter2_68, iter3_68 in pairs(arg0_68.stgUsed) do
		if var0_68[iter2_68] then
			var0_68[iter2_68] = math.max(0, var0_68[iter2_68] - iter3_68)
		end
	end

	for iter4_68, iter5_68 in pairs(ChapterConst.StrategyPresents) do
		var0_68[iter5_68] = var0_68[iter5_68] or 0
	end

	local var1_68 = {}

	for iter6_68, iter7_68 in pairs(var0_68) do
		table.insert(var1_68, {
			id = iter6_68,
			count = iter7_68
		})
	end

	return _.sort(var1_68, function(arg0_69, arg1_69)
		return arg0_69.id < arg1_69.id
	end)
end

function var0_0.getOwnStrategies(arg0_70)
	local var0_70 = {}
	local var1_70 = arg0_70:getShips(true)

	_.each(var1_70, function(arg0_71)
		local var0_71 = arg0_71:getConfig("strategy_list")

		_.each(var0_71, function(arg0_72)
			var0_70[arg0_72[1]] = (var0_70[arg0_72[1]] or 0) + arg0_72[2]
		end)
	end)

	local var2_70 = arg0_70:triggerSkill(FleetSkill.TypeStrategy)

	if var2_70 then
		_.each(var2_70, function(arg0_73)
			var0_70[arg0_73[1]] = (var0_70[arg0_73[1]] or 0) + arg0_73[2]
		end)
	end

	return var0_70
end

function var0_0.achievedStrategy(arg0_74, arg1_74, arg2_74)
	arg0_74.stgPicked[arg1_74] = (arg0_74.stgPicked[arg1_74] or 0) + arg2_74
end

function var0_0.consumeOneStrategy(arg0_75, arg1_75)
	local var0_75 = arg0_75:getOwnStrategies()

	if var0_75[arg1_75] and var0_75[arg1_75] > 0 then
		local var1_75 = arg0_75.stgUsed

		var1_75[arg1_75] = (var1_75[arg1_75] or 0) + 1
	else
		local var2_75 = arg0_75.stgPicked

		if var2_75[arg1_75] then
			var2_75[arg1_75] = math.max(0, var2_75[arg1_75] - 1)
		end
	end
end

function var0_0.GetStrategyCount(arg0_76, arg1_76)
	local var0_76 = arg0_76:getStrategies()
	local var1_76 = _.detect(var0_76, function(arg0_77)
		return arg0_77.id == arg1_76
	end)

	return var1_76 and var1_76.count or 0
end

function var0_0.getFormationStg(arg0_78)
	return PlayerPrefs.GetInt("team_formation_" .. arg0_78.id, 1)
end

function var0_0.canUseStrategy(arg0_79, arg1_79)
	local var0_79 = pg.strategy_data_template[arg1_79.id]

	if var0_79.type == ChapterConst.StgTypeForm then
		if arg0_79:getFormationStg() == var0_79.id then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_formation_active_already"))

			return false
		end
	elseif var0_79.type == ChapterConst.StgTypeConsume or var0_79.type == ChapterConst.StgTypeBindSupportConsume then
		if arg1_79.count <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_not_enough"))

			return false
		end

		if var0_79.id == ChapterConst.StrategyRepair and _.all(arg0_79:getShips(true), function(arg0_80)
			return arg0_80.hpRant == 0 or arg0_80.hpRant == 10000
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_full_hp"))

			return false
		end
	end

	return true
end

function var0_0.getNextStgUser(arg0_81, arg1_81)
	return arg0_81.id
end

function var0_0.GetStatusStrategy(arg0_82)
	return arg0_82.stgIds
end

function var0_0.getFleetType(arg0_83)
	local var0_83 = 0

	for iter0_83, iter1_83 in pairs(arg0_83.ships) do
		local var1_83 = iter1_83:getTeamType()

		if var1_83 == TeamType.Submarine then
			return FleetType.Submarine
		elseif var1_83 == TeamType.Vanguard then
			var0_83 = var0_83 + 1
		end
	end

	if var0_83 == 0 then
		return FleetType.Support
	else
		return FleetType.Normal
	end
end

function var0_0.canClearTorpedo(arg0_84)
	local var0_84 = arg0_84:getShipsByTeam(TeamType.Vanguard, true)

	return _.any(var0_84, function(arg0_85)
		return ShipType.IsTypeQuZhu(arg0_85:getShipType())
	end)
end

function var0_0.getHuntingRange(arg0_86, arg1_86)
	if arg0_86:getFleetType() ~= FleetType.Submarine then
		assert(false)

		return {}
	end

	local var0_86 = arg1_86 or arg0_86.startPos
	local var1_86 = arg0_86:getShipsByTeam(TeamType.Submarine, true)[1]
	local var2_86 = arg0_86:triggerSkill(FleetSkill.TypeHuntingLv) or 0
	local var3_86 = var1_86:getHuntingRange(var1_86:getHuntingLv() + var2_86)

	return (_.map(var3_86, function(arg0_87)
		return {
			row = var0_86.row + arg0_87[1],
			column = var0_86.column + arg0_87[2]
		}
	end))
end

function var0_0.inHuntingRange(arg0_88, arg1_88, arg2_88)
	return _.any(arg0_88:getHuntingRange(), function(arg0_89)
		return arg0_89.row == arg1_88 and arg0_89.column == arg2_88
	end)
end

function var0_0.getSummonCost(arg0_90)
	local var0_90 = arg0_90:getShips(false)

	return _.reduce(var0_90, 0, function(arg0_91, arg1_91)
		return arg0_91 + arg1_91:getEndBattleExpend()
	end)
end

function var0_0.getMapAura(arg0_92)
	local var0_92 = {}

	for iter0_92, iter1_92 in pairs(arg0_92.ships) do
		local var1_92 = iter1_92:getMapAuras()

		for iter2_92, iter3_92 in ipairs(var1_92) do
			table.insert(var0_92, iter3_92)
		end
	end

	return var0_92
end

function var0_0.getMapAid(arg0_93)
	local var0_93 = {}

	for iter0_93, iter1_93 in pairs(arg0_93.ships) do
		local var1_93 = iter1_93:getMapAids()

		for iter2_93, iter3_93 in ipairs(var1_93) do
			local var2_93 = var0_93[iter1_93] or {}

			table.insert(var2_93, iter3_93)

			var0_93[iter1_93] = var2_93
		end
	end

	return var0_93
end

function var0_0.updateCommanderSkills(arg0_94)
	local var0_94 = arg0_94:getCommanders()

	for iter0_94, iter1_94 in pairs(var0_94) do
		_.each(iter1_94:getSkills(), function(arg0_95)
			_.each(arg0_95:getTacticSkill(), function(arg0_96)
				table.insert(arg0_94.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, arg0_96))
			end)
		end)
	end
end

function var0_0.getSkills(arg0_97)
	return arg0_97.skills
end

function var0_0.getSkill(arg0_98, arg1_98)
	return _.detect(arg0_98:getSkills(), function(arg0_99)
		return arg0_99.id == arg1_98
	end)
end

function var0_0.findSkills(arg0_100, arg1_100)
	return _.filter(arg0_100:getSkills(), function(arg0_101)
		return arg0_101:GetType() == arg1_100
	end)
end

function var0_0.triggerSkill(arg0_102, arg1_102)
	return arg0_102.chapter:triggerSkill(arg0_102, arg1_102)
end

function var0_0.findCommanderBySkillId(arg0_103, arg1_103)
	local var0_103 = arg0_103:getCommanders()

	for iter0_103, iter1_103 in pairs(var0_103) do
		if _.any(iter1_103:getSkills(), function(arg0_104)
			return _.any(arg0_104:getTacticSkill(), function(arg0_105)
				return arg0_105 == arg1_103
			end)
		end) then
			return iter1_103
		end
	end
end

function var0_0.getFleetAirDominanceValue(arg0_106)
	local var0_106 = 0

	for iter0_106, iter1_106 in ipairs(arg0_106:getShips(false)) do
		var0_106 = var0_106 + calcAirDominanceValue(iter1_106, arg0_106:getCommanders())
	end

	return var0_106
end

function var0_0.StaticTransformChapterFleet2Fleet(arg0_107, arg1_107)
	local var0_107 = _.pluck(arg0_107:getShipsByTeam(TeamType.Vanguard, arg1_107), "id")

	table.insertto(var0_107, _.pluck(arg0_107:getShipsByTeam(TeamType.Main, arg1_107), "id"))

	local var1_107 = {}

	for iter0_107, iter1_107 in pairs(arg0_107.commanders) do
		table.insert(var1_107, {
			pos = iter0_107,
			id = iter1_107 and iter1_107.id
		})
	end

	return TypedFleet.New({
		fleetType = FleetType.Normal,
		ship_list = var0_107,
		commanders = var1_107
	})
end

return var0_0
