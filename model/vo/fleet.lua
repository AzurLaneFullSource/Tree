local var0 = class("Fleet", import(".BaseVO"))

var0.C_TEAM_NAME = {
	vanguard = i18n("word_vanguard_fleet"),
	main = i18n("word_main_fleet"),
	submarine = i18n("word_sub_fleet")
}
var0.DEFAULT_NAME = {
	i18n("ship_formationUI_fleetName1"),
	i18n("ship_formationUI_fleetName2"),
	i18n("ship_formationUI_fleetName3"),
	i18n("ship_formationUI_fleetName4"),
	i18n("ship_formationUI_fleetName5"),
	i18n("ship_formationUI_fleetName6"),
	[11] = i18n("ship_formationUI_fleetName11"),
	[12] = i18n("ship_formationUI_fleetName12"),
	[101] = i18n("ship_formationUI_exercise_fleetName"),
	[102] = i18n("ship_formationUI_fleetName_challenge"),
	[103] = i18n("ship_formationUI_fleetName_challenge_sub")
}
var0.DEFAULT_NAME_FOR_DOCKYARD = {
	i18n("ship_formationUI_fleetName1"),
	i18n("ship_formationUI_fleetName2"),
	i18n("ship_formationUI_fleetName3"),
	i18n("ship_formationUI_fleetName4"),
	i18n("ship_formationUI_fleetName5"),
	i18n("ship_formationUI_fleetName6"),
	[11] = i18n("ship_formationUI_fleetName1"),
	[12] = i18n("ship_formationUI_fleetName2"),
	[101] = i18n("ship_formationUI_exercise_fleetName"),
	[102] = i18n("ship_formationUI_fleetName_challenge"),
	[103] = i18n("ship_formationUI_fleetName_challenge_sub")
}
var0.DEFAULT_NAME_BOSS_ACT = {
	i18n("ship_formationUI_fleetName_easy"),
	i18n("ship_formationUI_fleetName_normal"),
	i18n("ship_formationUI_fleetName_hard"),
	i18n("ship_formationUI_fleetName_extra"),
	i18n("ship_formationUI_fleetName_sp"),
	[11] = i18n("ship_formationUI_fleetName_easy_ss"),
	[12] = i18n("ship_formationUI_fleetName_normal_ss"),
	[13] = i18n("ship_formationUI_fleetName_hard_ss"),
	[14] = i18n("ship_formationUI_fleetName_extra_ss"),
	[15] = i18n("ship_formationUI_fleetName_sp_ss")
}
var0.DEFAULT_NAME_BOSS_SINGLE_ACT = {
	i18n("ship_formationUI_fleetName_easy"),
	i18n("ship_formationUI_fleetName_normal"),
	i18n("ship_formationUI_fleetName_hard"),
	i18n("ship_formationUI_fleetName_sp"),
	i18n("ship_formationUI_fleetName_extra"),
	[11] = i18n("ship_formationUI_fleetName_easy_ss"),
	[12] = i18n("ship_formationUI_fleetName_normal_ss"),
	[13] = i18n("ship_formationUI_fleetName_hard_ss"),
	[14] = i18n("ship_formationUI_fleetName_sp_ss"),
	[15] = i18n("ship_formationUI_fleetName_extra_ss")
}
var0.REGULAR_FLEET_ID = 1
var0.REGULAR_FLEET_NUMS = 6
var0.SUBMARINE_FLEET_ID = 11
var0.SUBMARINE_FLEET_NUMS = 4

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.name = arg1.name or ""
	arg0.defaultName = var0.DEFAULT_NAME[arg0.id]

	arg0:updateShips(arg1.ship_list)

	arg0.commanderIds = {}

	for iter0, iter1 in ipairs(arg1.commanders or {}) do
		arg0.commanderIds[iter1.pos] = iter1.id
	end

	arg0.skills = {}

	arg0:updateCommanderSkills()
end

function var0.isUnlock(arg0)
	local var0 = {
		nil,
		nil,
		404,
		504,
		604,
		704
	}
	local var1 = getProxy(ChapterProxy)
	local var2 = var0[arg0.id]

	if var2 then
		local var3 = var1:getChapterById(var2)

		return var3 and var3:isClear(), i18n("formation_chapter_lock", string.sub(tostring(var2), 1, 1), arg0.id)
	end

	return true
end

function var0.containShip(arg0, arg1)
	return table.contains(arg0.ships, arg1.id)
end

function var0.isFirstFleet(arg0)
	return arg0.id == var0.REGULAR_FLEET_ID
end

function var0.outputCommanders(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.commanderIds) do
		assert(iter1, "id is nil")
		table.insert(var0, {
			pos = iter0,
			id = iter1
		})
	end

	return var0
end

function var0.getCommanders(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.commanderIds) do
		var0[iter0] = getProxy(CommanderProxy):getCommanderById(iter1)
	end

	return var0
end

function var0.getCommanderByPos(arg0, arg1)
	return arg0:getCommanders()[arg1]
end

function var0.updateCommanderByPos(arg0, arg1, arg2)
	if arg2 then
		arg0.commanderIds[arg1] = arg2.id
	else
		arg0.commanderIds[arg1] = nil
	end

	arg0:updateCommanderSkills()
end

function var0.getCommandersAddition(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(CommanderConst.PROPERTIES) do
		local var1 = 0

		for iter2, iter3 in pairs(arg0:getCommanders()) do
			var1 = var1 + iter3:getAbilitysAddition()[iter1]
		end

		if var1 > 0 then
			table.insert(var0, {
				attrName = iter1,
				value = var1
			})
		end
	end

	return var0
end

function var0.getCommandersTalentDesc(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:getCommanders()) do
		local var1 = iter1:getTalentsDesc()

		for iter2, iter3 in pairs(var1) do
			if var0[iter2] then
				var0[iter2].value = var0[iter2].value + iter3.value
			else
				var0[iter2] = {
					name = iter2,
					value = iter3.value,
					type = iter3.type
				}
			end
		end
	end

	return var0
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

function var0.updateCommanderSkills(arg0)
	local var0 = #arg0.skills

	while var0 > 0 do
		local var1 = arg0.skills[var0]

		if not arg0:findCommanderBySkillId(var1.id) and var1:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0.skills, var0)
		end

		var0 = var0 - 1
	end

	local var2 = arg0:getCommanders()

	for iter0, iter1 in pairs(var2) do
		for iter2, iter3 in ipairs(iter1:getSkills()) do
			for iter4, iter5 in ipairs(iter3:getTacticSkill()) do
				table.insert(arg0.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5))
			end
		end
	end
end

function var0.buildBattleBuffList(arg0)
	local var0 = {}
	local var1, var2 = FleetSkill.triggerSkill(arg0, FleetSkill.TypeBattleBuff)

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

function var0.getSkills(arg0)
	return arg0.skills
end

function var0.getShipIds(arg0)
	local var0 = {}
	local var1 = {
		arg0.mainShips,
		arg0.vanguardShips,
		arg0.subShips
	}

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.GetRawShipIds(arg0)
	return arg0.ships
end

function var0.GetRawCommanderIds(arg0)
	return arg0.commanderIds
end

function var0.findSkills(arg0, arg1)
	return _.filter(arg0:getSkills(), function(arg0)
		return arg0:GetType() == arg1
	end)
end

function var0.updateShips(arg0, arg1)
	arg0.ships = {}
	arg0.vanguardShips = {}
	arg0.mainShips = {}
	arg0.subShips = {}

	local var0 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg1) do
		local var1 = var0:getShipById(iter1)

		if var1 then
			arg0:insertShip(var1, nil, var1:getTeamType())
		end
	end
end

function var0.switchShip(arg0, arg1, arg2, arg3)
	local var0 = arg0:getTeamByName(arg1)

	var0[arg2], var0[arg3] = var0[arg3], var0[arg2]
end

function var0.getShipPos(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = arg1:getTeamType()
	local var1 = arg0:getTeamByName(var0)

	return table.indexof(var1, arg1.id) or -1, var0
end

function var0.getTeamByName(arg0, arg1)
	if arg1 == TeamType.Vanguard then
		return arg0.vanguardShips
	elseif arg1 == TeamType.Main then
		return arg0.mainShips
	elseif arg1 == TeamType.Submarine then
		return arg0.subShips
	end
end

function var0.CanInsertShip(arg0, arg1, arg2)
	if arg0:isFull() or arg0:containShip(arg1) or not arg1:isAvaiable() or #arg0:getTeamByName(arg2) >= TeamType.GetTeamShipMax(arg2) then
		return false
	end

	return true
end

function var0.insertShip(arg0, arg1, arg2, arg3)
	if not arg0:CanInsertShip(arg1, arg3) then
		errorMsg("fleet insert error")
		pg.TipsMgr.GetInstance():ShowTips("fleet insert error")
	else
		local var0 = arg0:getTeamByName(arg3)

		arg2 = arg2 or #var0 + 1

		local var1 = arg3 == TeamType.Main and #arg0.vanguardShips or 0

		table.insert(var0, arg2, arg1.id)
		table.insert(arg0.ships, var1 + arg2, arg1.id)
	end
end

function var0.canRemove(arg0, arg1)
	local var0, var1 = arg0:getShipPos(arg1)

	if var0 > 0 and #(arg0:getTeamByName(var1) or {}) == 1 and arg0:isFirstFleet() then
		return false
	else
		return true
	end
end

function var0.isRegularFleet(arg0)
	return arg0.id >= var0.SUBMARINE_FLEET_ID and arg0.id < var0.SUBMARINE_FLEET_ID + var0.SUBMARINE_FLEET_NUMS or arg0.id >= var0.REGULAR_FLEET_ID and arg0.id < var0.REGULAR_FLEET_ID + var0.REGULAR_FLEET_NUMS
end

function var0.isSubmarineFleet(arg0)
	return arg0.id >= var0.SUBMARINE_FLEET_ID and arg0.id < var0.SUBMARINE_FLEET_ID + var0.SUBMARINE_FLEET_NUMS
end

function var0.isPVPFleet(arg0)
	return arg0.id == FleetProxy.PVP_FLEET_ID
end

function var0.getFleetType(arg0)
	if arg0.id and arg0.id >= var0.SUBMARINE_FLEET_ID and arg0.id < var0.SUBMARINE_FLEET_ID + var0.SUBMARINE_FLEET_NUMS then
		return FleetType.Submarine
	end

	return FleetType.Normal
end

function var0.removeShip(arg0, arg1)
	assert(arg0:containShip(arg1), "ship are not in fleet")

	local var0 = arg1.id

	for iter0, iter1 in ipairs(arg0.ships) do
		if iter1 == var0 then
			table.remove(arg0.ships, iter0)

			break
		end
	end

	for iter2, iter3 in ipairs(arg0.vanguardShips) do
		if iter3 == var0 then
			return table.remove(arg0.vanguardShips, iter2), TeamType.Vanguard
		end
	end

	for iter4, iter5 in ipairs(arg0.mainShips) do
		if iter5 == var0 then
			return table.remove(arg0.mainShips, iter4), TeamType.Main
		end
	end

	for iter6, iter7 in ipairs(arg0.subShips) do
		if iter7 == var0 then
			return table.remove(arg0.subShips, iter6), TeamType.Submarine
		end
	end

	return nil
end

function var0.isFull(arg0)
	local var0 = arg0:getFleetType()

	if var0 == FleetType.Normal then
		return #arg0.vanguardShips + #arg0.mainShips >= TeamType.VanguardMax + TeamType.MainMax
	elseif var0 == FleetType.Submarine then
		return #arg0.subShips >= TeamType.SubmarineMax
	end

	return false
end

function var0.isEmpty(arg0)
	return #arg0.ships == 0
end

function var0.isLegalToFight(arg0)
	local var0 = arg0:getFleetType()

	if var0 == FleetType.Normal then
		if #arg0.vanguardShips == 0 then
			return TeamType.Vanguard, 1
		elseif #arg0.mainShips == 0 then
			return TeamType.Main, 1
		end
	elseif var0 == FleetType.Submarine and #arg0.subShips == 0 then
		return TeamType.Submarine, 1
	end

	return true
end

function var0.getSkillNum(arg0)
	local var0 = {
		"zhupao",
		"yulei",
		"fangkongpao",
		"jianzaiji"
	}
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		var1[iter1] = 0
	end

	local var2 = getProxy(BayProxy):getRawData()
	local var3 = ys.Battle.BattleConst.EquipmentType

	for iter2, iter3 in ipairs(arg0.ships) do
		for iter4, iter5 in ipairs(var2[iter3]:getActiveEquipments()) do
			if iter5 > 0 then
				local var4 = Equipment.New({
					id = iter5
				}):getConfig("weapon_id")

				for iter6, iter7 in ipairs(var4) do
					if iter7 > 0 then
						local var5 = pg.weapon_property[iter7].type

						if var5 == var3.POINT_HIT_AND_LOCK then
							var1.zhupao = var1.zhupao + 1
						elseif var5 == var3.TORPEDO or var5 == var3.MANUAL_TORPEDO then
							var1.yulei = var1.yulei + 1
						elseif var5 == var3.ANTI_AIR then
							var1.fangkongpao = var1.fangkongpao + 1
						elseif var5 == var3.INTERCEPT_AIRCRAFT then
							var1.jianzaiji = var1.jianzaiji + 1
						end
					end
				end
			end
		end
	end

	return var1
end

function var0.GetPropertiesSum(arg0)
	local var0 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}
	local var1 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in ipairs(arg0.ships) do
		local var2 = var1[iter1]:getProperties(arg0:getCommanders())

		var0.cannon = var0.cannon + math.floor(var2.cannon)
		var0.torpedo = var0.torpedo + math.floor(var2.torpedo)
		var0.antiAir = var0.antiAir + math.floor(var2.antiaircraft)
		var0.air = var0.air + math.floor(var2.air)
	end

	return var0
end

function var0.GetCostSum(arg0)
	local var0 = {
		gold = 0,
		oil = 0
	}
	local var1 = arg0:getStartCost()
	local var2 = arg0:getEndCost()

	if arg0:getFleetType() == FleetType.Submarine then
		var0.oil = var2.oil
	else
		var0.oil = var1.oil + var2.oil
	end

	return var0
end

function var0.getStartCost(arg0)
	local var0 = {
		gold = 0,
		oil = 0
	}
	local var1 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in ipairs(arg0.ships) do
		local var2 = var1[iter1]:getStartBattleExpend()

		var0.oil = var0.oil + var2
	end

	return var0
end

function var0.getEndCost(arg0)
	local var0 = {
		gold = 0,
		oil = 0
	}
	local var1 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in ipairs(arg0.ships) do
		local var2 = var1[iter1]:getEndBattleExpend()

		var0.oil = var0.oil + var2
	end

	return var0
end

function var0.GetGearScoreSum(arg0, arg1)
	local var0

	if arg1 == nil then
		var0 = arg0.ships
	else
		var0 = arg0:getTeamByName(arg1)
	end

	local var1 = 0
	local var2 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 + var2[iter1]:getShipCombatPower(arg0:getCommanders())
	end

	return var1
end

function var0.GetEnergyStatus(arg0)
	local var0 = false
	local var1 = ""
	local var2 = ""
	local var3 = getProxy(BayProxy)

	local function var4(arg0)
		for iter0 = 1, 3 do
			if arg0[iter0] then
				local var0 = var3:getShipById(arg0[iter0])

				if var0.energy == Ship.ENERGY_LOW then
					var0 = true
					var2 = var2 .. "「" .. var0:getConfig("name") .. "」"
				end
			end
		end
	end

	var4(arg0.mainShips)
	var4(arg0.vanguardShips)
	var4(arg0.subShips)

	if var0 then
		var1 = arg0:GetName()
	end

	return var0, i18n("ship_energy_low_warn", var1, var2)
end

function var0.genRobotDataString(arg0)
	local var0 = getProxy(BayProxy):getRawData()
	local var1 = "99999,"

	for iter0 = 1, 3 do
		if arg0.vanguardShips[iter0] and arg0.vanguardShips[iter0] > 0 then
			var1 = var1 .. var0[arg0.vanguardShips[iter0]].configId .. "," .. var0[arg0.vanguardShips[iter0]].level .. ",\"{"

			for iter1, iter2 in pairs(var0[arg0.vanguardShips[iter0]]:getActiveEquipments()) do
				var1 = var1 .. (iter2 and iter2.id or 0)

				if iter1 < 5 then
					var1 = var1 .. ","
				end
			end

			var1 = var1 .. "}\","
		else
			var1 = var1 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	for iter3 = 1, 3 do
		if arg0.mainShips[iter3] and arg0.mainShips[iter3] > 0 then
			var1 = var1 .. var0[arg0.mainShips[iter3]].configId .. "," .. var0[arg0.mainShips[iter3]].level .. ",\"{"

			for iter4, iter5 in pairs(var0[arg0.mainShips[iter3]]:getActiveEquipments()) do
				var1 = var1 .. (iter5 and iter5.id or 0)

				if iter4 < 5 then
					var1 = var1 .. ","
				end
			end

			var1 = var1 .. "}\","
		else
			var1 = var1 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	local var2 = arg0:GetGearScoreSum(TeamType.Vanguard)
	local var3 = arg0:GetGearScoreSum(TeamType.Main)

	return var1 .. math.floor(var2 + var3) .. ","
end

function var0.getIndex(arg0)
	if arg0.id >= var0.SUBMARINE_FLEET_ID and arg0.id < var0.SUBMARINE_FLEET_ID + var0.SUBMARINE_FLEET_NUMS then
		return arg0.id - var0.SUBMARINE_FLEET_ID + 1
	elseif arg0.id >= var0.REGULAR_FLEET_ID and arg0.id < var0.REGULAR_FLEET_ID + var0.REGULAR_FLEET_NUMS then
		return arg0.id - var0.REGULAR_FLEET_ID + 1
	end

	return arg0.id
end

function var0.getShipCount(arg0)
	return #arg0.ships
end

function var0.avgLevel(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.ships) do
		var0 = getProxy(BayProxy):getShipById(iter1).level + var0
	end

	return math.floor(var0 / #arg0.ships)
end

function var0.clearFleet(arg0)
	local var0 = Clone(arg0.ships)
	local var1 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(var0) do
		local var2 = var1:getShipById(iter1)

		arg0:removeShip(var2)
	end
end

function var0.EnergyCheck(arg0, arg1, arg2, arg3, arg4)
	arg4 = arg4 or "ship_energy_low_warn"

	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		if iter1.energy == Ship.ENERGY_LOW then
			table.insert(var0, iter1)
		end
	end

	if #var0 > 0 then
		local var1 = ""
		local var2 = _.map(var0, function(arg0)
			return "「" .. arg0:getConfig("name") .. "」"
		end)

		if PLATFORM_CODE ~= PLATFORM_US or #var2 == 1 then
			for iter2, iter3 in ipairs(var2) do
				var1 = var1 .. iter3
			end
		else
			if arg4 == "ship_energy_low_warn_no_exp" or arg4 == "ship_energy_low_warn" or arg4 == "ship_energy_low_desc" then
				arg4 = "multiple_" .. arg4
			end

			for iter4 = 1, #var2 - 2 do
				local var3 = var2[iter4]

				var1 = var1 .. var3 .. ", "
			end

			var1 = var1 .. var2[#var2 - 1] .. " and " .. var2[#var2]
		end

		existCall(arg3, false)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg4, arg1, var1),
			onYes = function()
				arg2(true)
			end,
			onNo = function()
				arg2(false)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		existCall(arg3, true)
		arg2(true)
	end
end

function var0.getFleetAirDominanceValue(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = arg0:getCommanders()
	local var2 = 0

	for iter0, iter1 in ipairs(arg0.ships) do
		var2 = (function(arg0, arg1)
			return arg0 + calcAirDominanceValue(var0:getShipById(arg1), var1)
		end)(var2, iter1)
	end

	return var2
end

function var0.RemoveUnusedItems(arg0)
	local var0 = Clone(arg0.ships)
	local var1 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(var0) do
		if not var1:getShipById(iter1) then
			arg0:removeShipById(iter1)
		end
	end

	local var2 = getProxy(CommanderProxy)
	local var3 = {}

	for iter2, iter3 in pairs(arg0.commanderIds) do
		if not var2:getCommanderById(iter3) then
			table.insert(var3, iter2)
		end
	end

	if #var3 > 0 then
		for iter4, iter5 in pairs(var3) do
			arg0.commanderIds[iter5] = nil
		end

		arg0.skills = {}

		arg0:updateCommanderSkills()
	end
end

function var0.removeShipById(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.ships) do
		if iter1 == arg1 then
			table.remove(arg0.ships, iter0)

			break
		end
	end

	for iter2, iter3 in ipairs(arg0.vanguardShips) do
		if iter3 == arg1 then
			return table.remove(arg0.vanguardShips, iter2), TeamType.Vanguard
		end
	end

	for iter4, iter5 in ipairs(arg0.mainShips) do
		if iter5 == arg1 then
			return table.remove(arg0.mainShips, iter4), TeamType.Main
		end
	end

	for iter6, iter7 in ipairs(arg0.subShips) do
		if iter7 == arg1 then
			return table.remove(arg0.subShips, iter6), TeamType.Submarine
		end
	end
end

function var0.HaveShipsInEvent(arg0)
	local var0 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in ipairs(arg0.ships) do
		if var0[iter1]:getFlag("inEvent") then
			return true, i18n("elite_disable_ship_escort")
		end
	end
end

function var0.GetFleetSonarRange(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4 = 0
	local var5 = ys.Battle.BattleConfig

	for iter0, iter1 in ipairs(arg0.ships) do
		local var6 = var0:getShipById(iter1)

		if var6 then
			local var7 = var6:getShipType()
			local var8 = var5.VAN_SONAR_PROPERTY[var7]

			if var8 then
				local var9 = (var6:getShipProperties()[AttributeType.AntiSub] or 0) / var8.a - var8.b

				var1 = math.max(var1, Mathf.Clamp(var9, var8.minRange, var8.maxRange))
			end

			if table.contains(TeamType.MainShipType, var7) then
				var4 = var4 + (var6:getShipProperties()[AttributeType.AntiSub] or 0)
			end

			for iter2, iter3 in ipairs(var6:getActiveEquipments()) do
				if iter3 then
					var3 = var3 + (iter3:getConfig("equip_parameters").range or 0)
				end
			end
		end
	end

	if var1 ~= 0 then
		local var10 = var5.MAIN_SONAR_PROPERTY
		local var11 = var4 / var10.a

		var2 = var3 + Mathf.Clamp(var11, var10.minRange, var10.maxRange)
	end

	return var1 + var2
end

function var0.getInvestSums(arg0)
	local var0 = getProxy(BayProxy)

	local function var1(arg0, arg1)
		local var0 = var0:getShipById(arg1):getProperties(arg0:getCommanders())

		return arg0 + var0[AttributeType.Air] + var0[AttributeType.Dodge]
	end

	local var2 = _.reduce(arg0.ships, 0, var1)

	return math.pow(var2, 0.666666666666667)
end

function var0.ExistActNpcShip(arg0)
	local var0 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg0.ships) do
		local var1 = var0:RawGetShipById(iter1)

		if var1 and var1:isActivityNpc() then
			return true
		end
	end

	return false
end

function var0.GetName(arg0)
	return arg0.name == "" and var0.DEFAULT_NAME[arg0.id] or arg0.name
end

return var0
