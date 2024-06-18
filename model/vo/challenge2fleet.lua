local var0_0 = class("Challenge2Fleet", import(".Fleet"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id

	arg0_1:updateShips(arg1_1.ships)

	arg0_1.commanderList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.commanders or {}) do
		arg0_1.commanderList[iter1_1.pos] = Commander.New(iter1_1.commanderinfo)
	end

	arg0_1.skills = {}

	arg0_1:updateCommanderSkills()
end

function var0_0.getShipsByTeam(arg0_2, arg1_2, arg2_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2[arg1_2]) do
		if iter1_2.hpRant > 0 then
			var0_2[#var0_2 + 1] = iter1_2
		end
	end

	if arg2_2 then
		for iter2_2, iter3_2 in ipairs(arg0_2[arg1_2]) do
			if iter3_2.hpRant <= 0 then
				var0_2[#var0_2 + 1] = iter3_2
			end
		end
	end

	return var0_2
end

function var0_0.getTeamByName(arg0_3, arg1_3)
	local var0_3 = arg0_3[arg1_3]
	local var1_3 = {}

	for iter0_3, iter1_3 in pairs(var0_3) do
		table.insert(var1_3, iter1_3.id)
	end

	return var1_3
end

function var0_0.getFleetType(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.ships) do
		if iter1_4:getTeamType() == TeamType.Submarine then
			return FleetType.Submarine
		end
	end

	return FleetType.Normal
end

function var0_0.getShips(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = arg0_5:getFleetType()

	if var1_5 == FleetType.Normal then
		_.each(arg0_5:getShipsByTeam(TeamType.Main, arg1_5), function(arg0_6)
			table.insert(var0_5, arg0_6)
		end)
		_.each(arg0_5:getShipsByTeam(TeamType.Vanguard, arg1_5), function(arg0_7)
			table.insert(var0_5, arg0_7)
		end)
	elseif var1_5 == FleetType.Submarine then
		_.each(arg0_5:getShipsByTeam(TeamType.Submarine, arg1_5), function(arg0_8)
			table.insert(var0_5, arg0_8)
		end)
	end

	return var0_5
end

function var0_0.updateShips(arg0_9, arg1_9)
	arg0_9[TeamType.Vanguard] = {}
	arg0_9[TeamType.Main] = {}
	arg0_9[TeamType.Submarine] = {}
	arg0_9.ships = {}

	_.each(arg1_9 or {}, function(arg0_10)
		local var0_10 = Ship.New(arg0_10.ship_info)

		var0_10.hpRant = arg0_10.hp_rant
		arg0_9.ships[var0_10.id] = var0_10

		table.insert(arg0_9[var0_10:getTeamType()], var0_10)
	end)
end

function var0_0.updateShipsHP(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.ships[arg1_11]

	if var0_11 then
		var0_11.hpRant = arg2_11

		return true
	else
		return false
	end
end

function var0_0.getCommanders(arg0_12)
	return arg0_12.commanderList
end

function var0_0.switchShip(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg0_13:getShipsByTeam(arg1_13, false)
	local var1_13 = var0_13[arg2_13].id
	local var2_13 = var0_13[arg3_13].id
	local var3_13
	local var4_13
	local var5_13
	local var6_13

	for iter0_13, iter1_13 in pairs(arg0_13.ships) do
		if iter0_13 == var1_13 then
			var3_13 = iter1_13:getTeamType()
			var4_13 = table.indexof(arg0_13[var3_13], iter1_13)
		end

		if iter0_13 == var2_13 then
			var5_13 = iter1_13:getTeamType()
			var6_13 = table.indexof(arg0_13[var5_13], iter1_13)
		end
	end

	if var3_13 == var5_13 and var4_13 ~= var6_13 then
		arg0_13[var3_13][var4_13], arg0_13[var5_13][var6_13] = arg0_13[var5_13][var6_13], arg0_13[var3_13][var4_13]
	end
end

function var0_0.buildBattleBuffList(arg0_14)
	local var0_14 = {}
	local var1_14, var2_14 = FleetSkill.triggerMirrorSkill(arg0_14, FleetSkill.TypeBattleBuff)

	if var1_14 and #var1_14 > 0 then
		local var3_14 = {}

		for iter0_14, iter1_14 in ipairs(var1_14) do
			local var4_14 = var2_14[iter0_14]
			local var5_14 = arg0_14:findCommanderBySkillId(var4_14.id)

			var3_14[var5_14] = var3_14[var5_14] or {}

			table.insert(var3_14[var5_14], iter1_14)
		end

		for iter2_14, iter3_14 in pairs(var3_14) do
			table.insert(var0_14, {
				iter2_14,
				iter3_14
			})
		end
	end

	local var6_14 = arg0_14:getCommanders()

	for iter4_14, iter5_14 in pairs(var6_14) do
		local var7_14 = iter5_14:getTalents()

		for iter6_14, iter7_14 in ipairs(var7_14) do
			local var8_14 = iter7_14:getBuffsAddition()

			if #var8_14 > 0 then
				local var9_14

				for iter8_14, iter9_14 in ipairs(var0_14) do
					if iter9_14[1] == iter5_14 then
						var9_14 = iter9_14[2]

						break
					end
				end

				if not var9_14 then
					var9_14 = {}

					table.insert(var0_14, {
						iter5_14,
						var9_14
					})
				end

				for iter10_14, iter11_14 in ipairs(var8_14) do
					table.insert(var9_14, iter11_14)
				end
			end
		end
	end

	return var0_14
end

return var0_0
