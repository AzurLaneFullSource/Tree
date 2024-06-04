local var0 = class("ChapterFleet", import(".LevelCellData"))

var0.DUTY_CLEANPATH = 1
var0.DUTY_KILLBOSS = 2
var0.DUTY_KILLALL = 3
var0.DUTY_IDLE = 4

function var0.Ctor(arg0, arg1, arg2)
	arg0:updateNpcShipList(arg2)

	arg0.id = arg1.id
	arg0.name = nil
	arg0.fleetId = arg1.fleet_id

	if arg1.fleet_id then
		local var0 = getProxy(FleetProxy):getFleetById(arg1.fleet_id)

		arg0.name = var0 and var0:GetName() or Fleet.DEFAULT_NAME[arg1.fleet_id]
	end

	arg0.name = arg0.name or Fleet.DEFAULT_NAME[arg0.id]

	local var1 = {}
	local var2 = {}
	local var3 = {}

	_.each(arg1.box_strategy_list, function(arg0)
		var1[arg0.id] = arg0.count
	end)
	_.each(arg1.ship_strategy_list, function(arg0)
		var2[arg0.id] = arg0.count
	end)
	_.each(arg1.strategy_ids, function(arg0)
		if pg.strategy_data_template[arg0] then
			table.insert(var3, arg0)
		end
	end)

	if not _.detect(var3, function(arg0)
		return pg.strategy_data_template[arg0].type == ChapterConst.StgTypeForm
	end) then
		table.insert(var3, arg0:getFormationStg())
	end

	arg0.stgPicked = var1
	arg0.stgUsed = var2
	arg0.stgIds = var3
	arg0.line = {
		row = arg1.pos.row,
		column = arg1.pos.column
	}
	arg0.step = arg1.step_count
	arg0.restAmmo = arg1.bullet
	arg0.startPos = {
		row = arg1.start_pos.row,
		column = arg1.start_pos.column
	}

	arg0:prepareShips(arg1.ship_list)
	arg0:updateShips(arg1.ship_list)

	arg0.baseSpeed = arg0:calcBaseSpeed()
	arg0.rotation = Quaternion.identity
	arg0.slowSpeedFactor = arg1.move_step_down
	arg0.defeatEnemies = arg1.kill_count or 0

	arg0:updateCommanders(arg1.commander_list)

	arg0.skills = {}

	arg0:updateCommanderSkills()
end

function var0.setup(arg0, arg1)
	arg0.chapter = arg1
end

function var0.fetchShipVO(arg0, arg1)
	local var0

	if arg0.npcShipList[arg1] then
		var0 = Clone(arg0.npcShipList[arg1])
	else
		var0 = getProxy(BayProxy):getShipById(arg1)
	end

	if arg0.staticsReady then
		var0.triggers.TeamNumbers = arg0.statics[var0:getTeamType()].count
	end

	return var0
end

function var0.updateNpcShipList(arg0, arg1)
	arg0.npcShipList = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.npcShipList[iter1.id] = iter1
	end
end

function var0.GetLine(arg0)
	return arg0.line
end

function var0.SetLine(arg0, arg1)
	arg0.line = {
		row = arg1.row,
		column = arg1.column
	}
end

function var0.updateCommanders(arg0, arg1)
	arg0.commanders = {}

	local var0 = getProxy(CommanderProxy)

	for iter0, iter1 in ipairs(arg1) do
		local var1 = iter1.id
		local var2 = var0:getCommanderById(var1)

		if var2 then
			arg0.commanders[iter1.pos] = var2
		end
	end
end

function var0.getCommanders(arg0)
	return arg0.commanders or {}
end

function var0.prepareShips(arg0, arg1)
	arg0.statics = {}
	arg0.statics[TeamType.Vanguard] = {
		count = 0
	}
	arg0.statics[TeamType.Main] = {
		count = 0
	}
	arg0.statics[TeamType.Submarine] = {
		count = 0
	}

	_.each(arg1 or {}, function(arg0)
		local var0 = arg0:fetchShipVO(arg0.id)

		if var0 then
			local var1 = arg0.statics[var0:getTeamType()]

			var1.count = var1.count + 1
		end
	end)

	arg0.staticsReady = true
end

function var0.updateShips(arg0, arg1)
	arg0[TeamType.Vanguard] = {}
	arg0[TeamType.Main] = {}
	arg0[TeamType.Submarine] = {}
	arg0.ships = {}

	_.each(arg1 or {}, function(arg0)
		local var0 = arg0:fetchShipVO(arg0.id)

		if var0 then
			var0.hpRant = arg0.hp_rant
			arg0.ships[var0.id] = var0

			table.insert(arg0[var0:getTeamType()], var0)
		end
	end)
	arg0:ResortShips()
end

function var0.ResortShips(arg0)
	local var0 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	_.each(var0, function(arg0)
		local var0 = arg0[arg0]
		local var1 = {}

		table.Ipairs(var0, function(arg0, arg1)
			var1[arg1] = arg0
		end)
		table.sort(var0, CompareFuncs({
			function(arg0)
				return arg0.hpRant > 0 and 0 or 1
			end,
			function(arg0)
				return var1[arg0]
			end
		}))
	end)
end

function var0.getTeamByName(arg0, arg1)
	local var0 = {}
	local var1 = arg0[arg1]

	for iter0, iter1 in ipairs(var1) do
		table.insert(var0, iter1.id)
	end

	return var0
end

function var0.flushShips(arg0)
	local var0 = getProxy(FleetProxy):getFleetById(arg0.fleetId)

	arg0.name = var0 and var0.name ~= "" and var0.name or Fleet.DEFAULT_NAME[arg0.fleetId] or Fleet.DEFAULT_NAME[arg0.id]

	local var1 = _.keys(arg0.ships)

	for iter0, iter1 in ipairs(var1) do
		local var2 = arg0:fetchShipVO(iter1)

		if var2 then
			var2.hpRant = arg0.ships[iter1].hpRant
		end

		arg0.ships[iter1] = var2
	end

	local var3 = {}

	_.each(arg0[TeamType.Vanguard], function(arg0)
		if arg0.ships[arg0.id] then
			table.insert(var3, arg0.ships[arg0.id])
		end
	end)

	arg0[TeamType.Vanguard] = var3

	local var4 = {}

	_.each(arg0[TeamType.Main], function(arg0)
		if arg0.ships[arg0.id] then
			table.insert(var4, arg0.ships[arg0.id])
		end
	end)

	arg0[TeamType.Main] = var4

	local var5 = {}

	_.each(arg0[TeamType.Submarine], function(arg0)
		if arg0.ships[arg0.id] then
			table.insert(var5, arg0.ships[arg0.id])
		end
	end)

	arg0[TeamType.Submarine] = var5
end

function var0.updateShipHp(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if var0 then
		var0.hpChange = arg2 - var0.hpRant
		var0.hpRant = arg2

		arg0:ResortShips()
	end
end

function var0.getShip(arg0, arg1)
	return arg0.ships[arg1]
end

function var0.getShips(arg0, arg1)
	local var0 = {}
	local var1 = arg0:getFleetType()

	if var1 == FleetType.Normal then
		_.each(arg0:getShipsByTeam(TeamType.Main, arg1), function(arg0)
			table.insert(var0, arg0)
		end)
		_.each(arg0:getShipsByTeam(TeamType.Vanguard, arg1), function(arg0)
			table.insert(var0, arg0)
		end)
	elseif var1 == FleetType.Submarine then
		_.each(arg0:getShipsByTeam(TeamType.Submarine, arg1), function(arg0)
			table.insert(var0, arg0)
		end)
	elseif var1 == FleetType.Support then
		for iter0, iter1 in pairs(arg0.ships) do
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getShipsByTeam(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0[arg1]) do
		if iter1.hpRant > 0 then
			var0[#var0 + 1] = iter1
		end
	end

	if arg2 then
		for iter2, iter3 in ipairs(arg0[arg1]) do
			if iter3.hpRant <= 0 then
				var0[#var0 + 1] = iter3
			end
		end
	end

	return var0
end

function var0.containsShip(arg0, arg1)
	return arg0.ships[arg1] and true or false
end

function var0.replaceShip(arg0, arg1, arg2)
	errorMsg("ChapterFleet replaceShip function used")

	if arg0.ships[arg1] and not arg0.ships[arg2.id] then
		local var0 = arg0.ships[arg1]
		local var1 = arg0:fetchShipVO(arg2.id)

		if var1 then
			if var1:getTeamType() == var0:getTeamType() then
				if not var0:isSameKind(var1) and arg0:containsSameKind(var1) then
					arg0:removeShip(arg1)
				else
					var1.hpRant = arg2.hp_rant
					arg0.ships[arg1] = nil
					arg0.ships[var1.id] = var1

					local var2 = arg0[var1:getTeamType()]

					for iter0 = 1, #var2 do
						if var2[iter0].id == arg1 then
							var2[iter0] = var1

							break
						end
					end
				end
			else
				arg0:removeShip(arg1)
			end
		end
	end
end

function var0.addShip(arg0, arg1)
	errorMsg("ChapterFleet addShip function used")

	if not arg0.ships[arg1.id] then
		local var0 = arg0:fetchShipVO(arg1.id)

		if var0 then
			var0.hpRant = arg1.hp_rant

			local var1 = arg0[var0:getTeamType()]

			if #var1 < 3 then
				table.insert(var1, var0)

				arg0.ships[var0.id] = var0

				arg0:ResortShips()
			end
		end
	end
end

function var0.removeShip(arg0, arg1)
	errorMsg("ChapterFleet removeShip function used")

	arg0.ships[arg1] = nil

	local var0 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	for iter0 = 1, #var0 do
		local var1 = arg0[var0[iter0]]

		for iter1 = #var1, 1, -1 do
			if var1[iter1].id == arg1 then
				table.remove(var1, iter1)
			end
		end
	end
end

function var0.switchShip(arg0, arg1, arg2, arg3)
	local var0 = arg0:getShipsByTeam(arg1, false)
	local var1 = var0[arg2].id
	local var2 = var0[arg3].id
	local var3
	local var4
	local var5
	local var6

	for iter0, iter1 in pairs(arg0.ships) do
		if iter0 == var1 then
			var3 = iter1:getTeamType()
			var4 = table.indexof(arg0[var3], iter1)
		end

		if iter0 == var2 then
			var5 = iter1:getTeamType()
			var6 = table.indexof(arg0[var5], iter1)
		end
	end

	assert(var4 and var6)

	if var3 == var5 and var4 ~= var6 then
		arg0[var3][var4], arg0[var5][var6] = arg0[var5][var6], arg0[var3][var4]
	end
end

function var0.synchronousShipIndex(arg0, arg1)
	local var0 = {
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}

	for iter0, iter1 in ipairs(var0) do
		for iter2 = 1, 3 do
			if arg1[iter1][iter2] then
				local var1 = arg1[iter1][iter2].id

				arg0[iter1][iter2] = arg0.ships[var1]
			else
				arg0[iter1][iter2] = nil
			end
		end
	end
end

function var0.isValid(arg0)
	local var0 = arg0:getFleetType()

	if var0 == FleetType.Normal then
		return _.any(arg0[TeamType.Vanguard], function(arg0)
			return arg0.hpRant > 0
		end) and _.any(arg0[TeamType.Main], function(arg0)
			return arg0.hpRant > 0
		end)
	elseif var0 == FleetType.Submarine then
		return _.any(arg0[TeamType.Submarine], function(arg0)
			return arg0.hpRant > 0
		end)
	elseif var0 == FleetType.Support then
		return true
	end

	return false
end

function var0.getCost(arg0)
	local var0 = {
		gold = 0,
		oil = 0
	}
	local var1 = {
		gold = 0,
		oil = 0
	}
	local var2 = arg0:getShips(false)

	_.each(var2, function(arg0)
		var0.oil = var0.oil + arg0:getStartBattleExpend()
		var1.oil = var1.oil + arg0:getEndBattleExpend()
	end)

	return var0, var1
end

function var0.getInvestSums(arg0, arg1)
	local function var0(arg0, arg1)
		local var0 = arg1:getProperties(arg0:getCommanders())

		return arg0 + var0[AttributeType.Air] + var0[AttributeType.Dodge]
	end

	local var1 = _.reduce(arg0:getShips(arg1), 0, var0)

	return math.pow(var1, 0.666666666666667)
end

function var0.getDodgeSums(arg0)
	local function var0(arg0, arg1)
		return arg0 + arg1:getProperties(arg0:getCommanders())[AttributeType.Dodge]
	end

	local var1 = _.reduce(arg0:getShips(false), 0, var0)

	return math.pow(var1, 0.666666666666667)
end

function var0.getAntiAircraftSums(arg0)
	local function var0(arg0, arg1)
		return arg0 + arg1:getProperties(arg0:getCommanders())[AttributeType.AntiAircraft]
	end

	return (_.reduce(arg0:getShips(false), 0, var0))
end

function var0.getShipAmmo(arg0)
	local var0 = 0

	if arg0:getFleetType() == FleetType.Normal then
		for iter0, iter1 in pairs(arg0.ships) do
			var0 = math.max(var0, iter1:getShipAmmo())
		end
	elseif arg0:getFleetType() == FleetType.Submarine then
		for iter2, iter3 in pairs(arg0.ships) do
			var0 = var0 + iter3:getShipAmmo()
		end
	elseif arg0:getFleetType() == FleetType.Support then
		var0 = 0
	end

	return var0
end

function var0.clearShipHpChange(arg0)
	for iter0, iter1 in pairs(arg0.ships) do
		arg0.ships[iter1.id].hpChange = 0
	end
end

function var0.getEquipAmbushRateReduce(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.ships) do
		for iter2, iter3 in pairs(iter1:getActiveEquipments()) do
			if iter3 then
				var0 = math.max(var0, iter3:getConfig("equip_parameters").ambush_extra or 0)
			end
		end
	end

	return var0 / 10000
end

function var0.getEquipDodgeRateUp(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.ships) do
		for iter2, iter3 in pairs(iter1:getActiveEquipments()) do
			if iter3 then
				var0 = math.max(var0, iter3:getConfig("equip_parameters").avoid_extra or 0)
			end
		end
	end

	return var0 / 10000
end

function var0.isFormationDiffWith(arg0, arg1)
	local var0 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0[iter1]
		local var2 = arg1[iter1]

		for iter2 = 1, math.max(#var1, #var2) do
			if var1[iter2] ~= var2[iter2] and (var1[iter2] == nil or var2[iter2] == nil or var1[iter2].id ~= var2[iter2].id) then
				return true
			end
		end
	end

	return false
end

function var0.getShipIds(arg0)
	local var0 = {}
	local var1 = arg0:getFleetType()

	if var1 == FleetType.Normal then
		_.each(arg0[TeamType.Main], function(arg0)
			table.insert(var0, arg0.id)
		end)
		_.each(arg0[TeamType.Vanguard], function(arg0)
			table.insert(var0, arg0.id)
		end)
	elseif var1 == FleetType.Submarine then
		_.each(arg0[TeamType.Submarine], function(arg0)
			table.insert(var0, arg0.id)
		end)
	elseif var1 == FleetType.Support then
		for iter0, iter1 in pairs(arg0.ships) do
			table.insert(var0, iter1.id)
		end
	end

	return var0
end

function var0.containsSameKind(arg0, arg1)
	return arg1 and _.any(_.values(arg0.ships), function(arg0)
		return arg1:isSameKind(arg0)
	end)
end

function var0.increaseSlowSpeedFactor(arg0)
	arg0.slowSpeedFactor = arg0.slowSpeedFactor + 1
end

function var0.getSpeed(arg0)
	local var0 = arg0:triggerSkill(FleetSkill.TypeMoveSpeed) or 0

	return math.max(arg0.baseSpeed + var0 - arg0.slowSpeedFactor, 1)
end

function var0.calcBaseSpeed(arg0)
	local var0 = arg0:getShips(true)
	local var1 = _.reduce(var0, 0, function(arg0, arg1)
		return arg0 + arg1:getProperties()[AttributeType.Speed]
	end) / #var0 * (1 - 0.02 * (#var0 - 1))
	local var2
	local var3
	local var4 = arg0:getFleetType()

	if var4 == FleetType.Normal then
		var2 = pg.gameset.chapter_move_speed_1.key_value
		var3 = pg.gameset.chapter_move_speed_2.key_value
	elseif var4 == FleetType.Submarine then
		var2 = pg.gameset.submarine_move_speed_1.key_value
		var3 = pg.gameset.submarine_move_speed_2.key_value
	elseif var4 == FleetType.Support then
		var2 = pg.gameset.chapter_move_speed_1.key_value
		var3 = pg.gameset.chapter_move_speed_2.key_value
	end

	if var1 <= var2 then
		return 2
	elseif var3 < var1 then
		return 4
	else
		return 3
	end
end

function var0.getDefeatCount(arg0)
	return arg0.defeatEnemies
end

function var0.getStrategies(arg0)
	local var0 = arg0:getOwnStrategies()

	for iter0, iter1 in pairs(arg0.stgPicked) do
		var0[iter0] = (var0[iter0] or 0) + iter1
	end

	for iter2, iter3 in pairs(arg0.stgUsed) do
		if var0[iter2] then
			var0[iter2] = math.max(0, var0[iter2] - iter3)
		end
	end

	for iter4, iter5 in pairs(ChapterConst.StrategyPresents) do
		var0[iter5] = var0[iter5] or 0
	end

	local var1 = {}

	for iter6, iter7 in pairs(var0) do
		table.insert(var1, {
			id = iter6,
			count = iter7
		})
	end

	return _.sort(var1, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
end

function var0.getOwnStrategies(arg0)
	local var0 = {}
	local var1 = arg0:getShips(true)

	_.each(var1, function(arg0)
		local var0 = arg0:getConfig("strategy_list")

		_.each(var0, function(arg0)
			var0[arg0[1]] = (var0[arg0[1]] or 0) + arg0[2]
		end)
	end)

	local var2 = arg0:triggerSkill(FleetSkill.TypeStrategy)

	if var2 then
		_.each(var2, function(arg0)
			var0[arg0[1]] = (var0[arg0[1]] or 0) + arg0[2]
		end)
	end

	return var0
end

function var0.achievedStrategy(arg0, arg1, arg2)
	arg0.stgPicked[arg1] = (arg0.stgPicked[arg1] or 0) + arg2
end

function var0.consumeOneStrategy(arg0, arg1)
	local var0 = arg0:getOwnStrategies()

	if var0[arg1] and var0[arg1] > 0 then
		local var1 = arg0.stgUsed

		var1[arg1] = (var1[arg1] or 0) + 1
	else
		local var2 = arg0.stgPicked

		if var2[arg1] then
			var2[arg1] = math.max(0, var2[arg1] - 1)
		end
	end
end

function var0.GetStrategyCount(arg0, arg1)
	local var0 = arg0:getStrategies()
	local var1 = _.detect(var0, function(arg0)
		return arg0.id == arg1
	end)

	return var1 and var1.count or 0
end

function var0.getFormationStg(arg0)
	return PlayerPrefs.GetInt("team_formation_" .. arg0.id, 1)
end

function var0.canUseStrategy(arg0, arg1)
	local var0 = pg.strategy_data_template[arg1.id]

	if var0.type == ChapterConst.StgTypeForm then
		if arg0:getFormationStg() == var0.id then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_formation_active_already"))

			return false
		end
	elseif var0.type == ChapterConst.StgTypeConsume or var0.type == ChapterConst.StgTypeBindSupportConsume then
		if arg1.count <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_not_enough"))

			return false
		end

		if var0.id == ChapterConst.StrategyRepair and _.all(arg0:getShips(true), function(arg0)
			return arg0.hpRant == 0 or arg0.hpRant == 10000
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_scene_full_hp"))

			return false
		end
	end

	return true
end

function var0.getNextStgUser(arg0, arg1)
	return arg0.id
end

function var0.GetStatusStrategy(arg0)
	return arg0.stgIds
end

function var0.getFleetType(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.ships) do
		local var1 = iter1:getTeamType()

		if var1 == TeamType.Submarine then
			return FleetType.Submarine
		elseif var1 == TeamType.Vanguard then
			var0 = var0 + 1
		end
	end

	if var0 == 0 then
		return FleetType.Support
	else
		return FleetType.Normal
	end
end

function var0.canClearTorpedo(arg0)
	local var0 = arg0:getShipsByTeam(TeamType.Vanguard, true)

	return _.any(var0, function(arg0)
		return ShipType.IsTypeQuZhu(arg0:getShipType())
	end)
end

function var0.getHuntingRange(arg0, arg1)
	if arg0:getFleetType() ~= FleetType.Submarine then
		assert(false)

		return {}
	end

	local var0 = arg1 or arg0.startPos
	local var1 = arg0:getShipsByTeam(TeamType.Submarine, true)[1]
	local var2 = arg0:triggerSkill(FleetSkill.TypeHuntingLv) or 0
	local var3 = var1:getHuntingRange(var1:getHuntingLv() + var2)

	return (_.map(var3, function(arg0)
		return {
			row = var0.row + arg0[1],
			column = var0.column + arg0[2]
		}
	end))
end

function var0.inHuntingRange(arg0, arg1, arg2)
	return _.any(arg0:getHuntingRange(), function(arg0)
		return arg0.row == arg1 and arg0.column == arg2
	end)
end

function var0.getSummonCost(arg0)
	local var0 = arg0:getShips(false)

	return _.reduce(var0, 0, function(arg0, arg1)
		return arg0 + arg1:getEndBattleExpend()
	end)
end

function var0.getMapAura(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.ships) do
		local var1 = iter1:getMapAuras()

		for iter2, iter3 in ipairs(var1) do
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.getMapAid(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.ships) do
		local var1 = iter1:getMapAids()

		for iter2, iter3 in ipairs(var1) do
			local var2 = var0[iter1] or {}

			table.insert(var2, iter3)

			var0[iter1] = var2
		end
	end

	return var0
end

function var0.updateCommanderSkills(arg0)
	local var0 = arg0:getCommanders()

	for iter0, iter1 in pairs(var0) do
		_.each(iter1:getSkills(), function(arg0)
			_.each(arg0:getTacticSkill(), function(arg0)
				table.insert(arg0.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, arg0))
			end)
		end)
	end
end

function var0.getSkills(arg0)
	return arg0.skills
end

function var0.getSkill(arg0, arg1)
	return _.detect(arg0:getSkills(), function(arg0)
		return arg0.id == arg1
	end)
end

function var0.findSkills(arg0, arg1)
	return _.filter(arg0:getSkills(), function(arg0)
		return arg0:GetType() == arg1
	end)
end

function var0.triggerSkill(arg0, arg1)
	return arg0.chapter:triggerSkill(arg0, arg1)
end

function var0.findCommanderBySkillId(arg0, arg1)
	local var0 = arg0:getCommanders()

	for iter0, iter1 in pairs(var0) do
		if _.any(iter1:getSkills(), function(arg0)
			return _.any(arg0:getTacticSkill(), function(arg0)
				return arg0 == arg1
			end)
		end) then
			return iter1
		end
	end
end

function var0.getFleetAirDominanceValue(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0:getShips(false)) do
		var0 = var0 + calcAirDominanceValue(iter1, arg0:getCommanders())
	end

	return var0
end

function var0.StaticTransformChapterFleet2Fleet(arg0, arg1)
	local var0 = _.pluck(arg0:getShipsByTeam(TeamType.Vanguard, arg1), "id")

	table.insertto(var0, _.pluck(arg0:getShipsByTeam(TeamType.Main, arg1), "id"))

	local var1 = {}

	for iter0, iter1 in pairs(arg0.commanders) do
		table.insert(var1, {
			pos = iter0,
			id = iter1 and iter1.id
		})
	end

	return TypedFleet.New({
		fleetType = FleetType.Normal,
		ship_list = var0,
		commanders = var1
	})
end

return var0
