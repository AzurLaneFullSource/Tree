local var0 = class("Challenge2Fleet", import(".Fleet"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id

	arg0:updateShips(arg1.ships)

	arg0.commanderList = {}

	for iter0, iter1 in ipairs(arg1.commanders or {}) do
		arg0.commanderList[iter1.pos] = Commander.New(iter1.commanderinfo)
	end

	arg0.skills = {}

	arg0:updateCommanderSkills()
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

function var0.getTeamByName(arg0, arg1)
	local var0 = arg0[arg1]
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var1, iter1.id)
	end

	return var1
end

function var0.getFleetType(arg0)
	for iter0, iter1 in pairs(arg0.ships) do
		if iter1:getTeamType() == TeamType.Submarine then
			return FleetType.Submarine
		end
	end

	return FleetType.Normal
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
	end

	return var0
end

function var0.updateShips(arg0, arg1)
	arg0[TeamType.Vanguard] = {}
	arg0[TeamType.Main] = {}
	arg0[TeamType.Submarine] = {}
	arg0.ships = {}

	_.each(arg1 or {}, function(arg0)
		local var0 = Ship.New(arg0.ship_info)

		var0.hpRant = arg0.hp_rant
		arg0.ships[var0.id] = var0

		table.insert(arg0[var0:getTeamType()], var0)
	end)
end

function var0.updateShipsHP(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if var0 then
		var0.hpRant = arg2

		return true
	else
		return false
	end
end

function var0.getCommanders(arg0)
	return arg0.commanderList
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

	if var3 == var5 and var4 ~= var6 then
		arg0[var3][var4], arg0[var5][var6] = arg0[var5][var6], arg0[var3][var4]
	end
end

function var0.buildBattleBuffList(arg0)
	local var0 = {}
	local var1, var2 = FleetSkill.triggerMirrorSkill(arg0, FleetSkill.TypeBattleBuff)

	if var1 and #var1 > 0 then
		local var3 = {}

		for iter0, iter1 in ipairs(var1) do
			local var4 = var2[iter0]
			local var5 = arg0:findCommanderBySkillId(var4.id)

			var3[var5] = var3[var5] or {}

			table.insert(var3[var5], iter1)
		end

		for iter2, iter3 in pairs(var3) do
			table.insert(var0, {
				iter2,
				iter3
			})
		end
	end

	local var6 = arg0:getCommanders()

	for iter4, iter5 in pairs(var6) do
		local var7 = iter5:getTalents()

		for iter6, iter7 in ipairs(var7) do
			local var8 = iter7:getBuffsAddition()

			if #var8 > 0 then
				local var9

				for iter8, iter9 in ipairs(var0) do
					if iter9[1] == iter5 then
						var9 = iter9[2]

						break
					end
				end

				if not var9 then
					var9 = {}

					table.insert(var0, {
						iter5,
						var9
					})
				end

				for iter10, iter11 in ipairs(var8) do
					table.insert(var9, iter11)
				end
			end
		end
	end

	return var0
end

return var0
