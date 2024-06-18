local var0_0 = class("Fleet", import(".BaseVO"))

var0_0.C_TEAM_NAME = {
	vanguard = i18n("word_vanguard_fleet"),
	main = i18n("word_main_fleet"),
	submarine = i18n("word_sub_fleet")
}
var0_0.DEFAULT_NAME = {
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
var0_0.DEFAULT_NAME_FOR_DOCKYARD = {
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
var0_0.DEFAULT_NAME_BOSS_ACT = {
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
var0_0.DEFAULT_NAME_BOSS_SINGLE_ACT = {
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
var0_0.REGULAR_FLEET_ID = 1
var0_0.REGULAR_FLEET_NUMS = 6
var0_0.SUBMARINE_FLEET_ID = 11
var0_0.SUBMARINE_FLEET_NUMS = 4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.name = arg1_1.name or ""
	arg0_1.defaultName = var0_0.DEFAULT_NAME[arg0_1.id]

	arg0_1:updateShips(arg1_1.ship_list)

	arg0_1.commanderIds = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.commanders or {}) do
		arg0_1.commanderIds[iter1_1.pos] = iter1_1.id
	end

	arg0_1.skills = {}

	arg0_1:updateCommanderSkills()
end

function var0_0.isUnlock(arg0_2)
	local var0_2 = {
		nil,
		nil,
		404,
		504,
		604,
		704
	}
	local var1_2 = getProxy(ChapterProxy)
	local var2_2 = var0_2[arg0_2.id]

	if var2_2 then
		local var3_2 = var1_2:getChapterById(var2_2)

		return var3_2 and var3_2:isClear(), i18n("formation_chapter_lock", string.sub(tostring(var2_2), 1, 1), arg0_2.id)
	end

	return true
end

function var0_0.containShip(arg0_3, arg1_3)
	return table.contains(arg0_3.ships, arg1_3.id)
end

function var0_0.isFirstFleet(arg0_4)
	return arg0_4.id == var0_0.REGULAR_FLEET_ID
end

function var0_0.outputCommanders(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.commanderIds) do
		assert(iter1_5, "id is nil")
		table.insert(var0_5, {
			pos = iter0_5,
			id = iter1_5
		})
	end

	return var0_5
end

function var0_0.getCommanders(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.commanderIds) do
		var0_6[iter0_6] = getProxy(CommanderProxy):getCommanderById(iter1_6)
	end

	return var0_6
end

function var0_0.getCommanderByPos(arg0_7, arg1_7)
	return arg0_7:getCommanders()[arg1_7]
end

function var0_0.updateCommanderByPos(arg0_8, arg1_8, arg2_8)
	if arg2_8 then
		arg0_8.commanderIds[arg1_8] = arg2_8.id
	else
		arg0_8.commanderIds[arg1_8] = nil
	end

	arg0_8:updateCommanderSkills()
end

function var0_0.getCommandersAddition(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(CommanderConst.PROPERTIES) do
		local var1_9 = 0

		for iter2_9, iter3_9 in pairs(arg0_9:getCommanders()) do
			var1_9 = var1_9 + iter3_9:getAbilitysAddition()[iter1_9]
		end

		if var1_9 > 0 then
			table.insert(var0_9, {
				attrName = iter1_9,
				value = var1_9
			})
		end
	end

	return var0_9
end

function var0_0.getCommandersTalentDesc(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10:getCommanders()) do
		local var1_10 = iter1_10:getTalentsDesc()

		for iter2_10, iter3_10 in pairs(var1_10) do
			if var0_10[iter2_10] then
				var0_10[iter2_10].value = var0_10[iter2_10].value + iter3_10.value
			else
				var0_10[iter2_10] = {
					name = iter2_10,
					value = iter3_10.value,
					type = iter3_10.type
				}
			end
		end
	end

	return var0_10
end

function var0_0.findCommanderBySkillId(arg0_11, arg1_11)
	local var0_11 = arg0_11:getCommanders()

	for iter0_11, iter1_11 in pairs(var0_11) do
		if _.any(iter1_11:getSkills(), function(arg0_12)
			return _.any(arg0_12:getTacticSkill(), function(arg0_13)
				return arg0_13 == arg1_11
			end)
		end) then
			return iter1_11
		end
	end
end

function var0_0.updateCommanderSkills(arg0_14)
	local var0_14 = #arg0_14.skills

	while var0_14 > 0 do
		local var1_14 = arg0_14.skills[var0_14]

		if not arg0_14:findCommanderBySkillId(var1_14.id) and var1_14:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0_14.skills, var0_14)
		end

		var0_14 = var0_14 - 1
	end

	local var2_14 = arg0_14:getCommanders()

	for iter0_14, iter1_14 in pairs(var2_14) do
		for iter2_14, iter3_14 in ipairs(iter1_14:getSkills()) do
			for iter4_14, iter5_14 in ipairs(iter3_14:getTacticSkill()) do
				table.insert(arg0_14.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5_14))
			end
		end
	end
end

function var0_0.buildBattleBuffList(arg0_15)
	local var0_15 = {}
	local var1_15, var2_15 = FleetSkill.triggerSkill(arg0_15, FleetSkill.TypeBattleBuff)

	if var1_15 and #var1_15 > 0 then
		local var3_15 = {}

		for iter0_15, iter1_15 in ipairs(var1_15) do
			local var4_15 = var2_15[iter0_15]
			local var5_15 = arg0_15:findCommanderBySkillId(var4_15.id)

			var3_15[var5_15] = var3_15[var5_15] or {}

			table.insert(var3_15[var5_15], iter1_15)
		end

		for iter2_15, iter3_15 in pairs(var3_15) do
			table.insert(var0_15, {
				iter2_15,
				iter3_15
			})
		end
	end

	local var6_15 = arg0_15:getCommanders()

	for iter4_15, iter5_15 in pairs(var6_15) do
		local var7_15 = iter5_15:getTalents()

		for iter6_15, iter7_15 in ipairs(var7_15) do
			local var8_15 = iter7_15:getBuffsAddition()

			if #var8_15 > 0 then
				local var9_15

				for iter8_15, iter9_15 in ipairs(var0_15) do
					if iter9_15[1] == iter5_15 then
						var9_15 = iter9_15[2]

						break
					end
				end

				if not var9_15 then
					var9_15 = {}

					table.insert(var0_15, {
						iter5_15,
						var9_15
					})
				end

				for iter10_15, iter11_15 in ipairs(var8_15) do
					table.insert(var9_15, iter11_15)
				end
			end
		end
	end

	return var0_15
end

function var0_0.getSkills(arg0_16)
	return arg0_16.skills
end

function var0_0.getShipIds(arg0_17)
	local var0_17 = {}
	local var1_17 = {
		arg0_17.mainShips,
		arg0_17.vanguardShips,
		arg0_17.subShips
	}

	for iter0_17, iter1_17 in ipairs(var1_17) do
		for iter2_17, iter3_17 in ipairs(iter1_17) do
			table.insert(var0_17, iter3_17)
		end
	end

	return var0_17
end

function var0_0.GetRawShipIds(arg0_18)
	return arg0_18.ships
end

function var0_0.GetRawCommanderIds(arg0_19)
	return arg0_19.commanderIds
end

function var0_0.findSkills(arg0_20, arg1_20)
	return _.filter(arg0_20:getSkills(), function(arg0_21)
		return arg0_21:GetType() == arg1_20
	end)
end

function var0_0.updateShips(arg0_22, arg1_22)
	arg0_22.ships = {}
	arg0_22.vanguardShips = {}
	arg0_22.mainShips = {}
	arg0_22.subShips = {}

	local var0_22 = getProxy(BayProxy)

	for iter0_22, iter1_22 in ipairs(arg1_22) do
		local var1_22 = var0_22:getShipById(iter1_22)

		if var1_22 then
			arg0_22:insertShip(var1_22, nil, var1_22:getTeamType())
		end
	end
end

function var0_0.switchShip(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg0_23:getTeamByName(arg1_23)

	var0_23[arg2_23], var0_23[arg3_23] = var0_23[arg3_23], var0_23[arg2_23]
end

function var0_0.getShipPos(arg0_24, arg1_24)
	if not arg1_24 then
		return
	end

	local var0_24 = arg1_24:getTeamType()
	local var1_24 = arg0_24:getTeamByName(var0_24)

	return table.indexof(var1_24, arg1_24.id) or -1, var0_24
end

function var0_0.getTeamByName(arg0_25, arg1_25)
	if arg1_25 == TeamType.Vanguard then
		return arg0_25.vanguardShips
	elseif arg1_25 == TeamType.Main then
		return arg0_25.mainShips
	elseif arg1_25 == TeamType.Submarine then
		return arg0_25.subShips
	end
end

function var0_0.CanInsertShip(arg0_26, arg1_26, arg2_26)
	if arg0_26:isFull() or arg0_26:containShip(arg1_26) or not arg1_26:isAvaiable() or #arg0_26:getTeamByName(arg2_26) >= TeamType.GetTeamShipMax(arg2_26) then
		return false
	end

	return true
end

function var0_0.insertShip(arg0_27, arg1_27, arg2_27, arg3_27)
	if not arg0_27:CanInsertShip(arg1_27, arg3_27) then
		errorMsg("fleet insert error")
		pg.TipsMgr.GetInstance():ShowTips("fleet insert error")
	else
		local var0_27 = arg0_27:getTeamByName(arg3_27)

		arg2_27 = arg2_27 or #var0_27 + 1

		local var1_27 = arg3_27 == TeamType.Main and #arg0_27.vanguardShips or 0

		table.insert(var0_27, arg2_27, arg1_27.id)
		table.insert(arg0_27.ships, var1_27 + arg2_27, arg1_27.id)
	end
end

function var0_0.canRemove(arg0_28, arg1_28)
	local var0_28, var1_28 = arg0_28:getShipPos(arg1_28)

	if var0_28 > 0 and #(arg0_28:getTeamByName(var1_28) or {}) == 1 and arg0_28:isFirstFleet() then
		return false
	else
		return true
	end
end

function var0_0.isRegularFleet(arg0_29)
	return arg0_29.id >= var0_0.SUBMARINE_FLEET_ID and arg0_29.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS or arg0_29.id >= var0_0.REGULAR_FLEET_ID and arg0_29.id < var0_0.REGULAR_FLEET_ID + var0_0.REGULAR_FLEET_NUMS
end

function var0_0.isSubmarineFleet(arg0_30)
	return arg0_30.id >= var0_0.SUBMARINE_FLEET_ID and arg0_30.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS
end

function var0_0.isPVPFleet(arg0_31)
	return arg0_31.id == FleetProxy.PVP_FLEET_ID
end

function var0_0.getFleetType(arg0_32)
	if arg0_32.id and arg0_32.id >= var0_0.SUBMARINE_FLEET_ID and arg0_32.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS then
		return FleetType.Submarine
	end

	return FleetType.Normal
end

function var0_0.removeShip(arg0_33, arg1_33)
	assert(arg0_33:containShip(arg1_33), "ship are not in fleet")

	local var0_33 = arg1_33.id

	for iter0_33, iter1_33 in ipairs(arg0_33.ships) do
		if iter1_33 == var0_33 then
			table.remove(arg0_33.ships, iter0_33)

			break
		end
	end

	for iter2_33, iter3_33 in ipairs(arg0_33.vanguardShips) do
		if iter3_33 == var0_33 then
			return table.remove(arg0_33.vanguardShips, iter2_33), TeamType.Vanguard
		end
	end

	for iter4_33, iter5_33 in ipairs(arg0_33.mainShips) do
		if iter5_33 == var0_33 then
			return table.remove(arg0_33.mainShips, iter4_33), TeamType.Main
		end
	end

	for iter6_33, iter7_33 in ipairs(arg0_33.subShips) do
		if iter7_33 == var0_33 then
			return table.remove(arg0_33.subShips, iter6_33), TeamType.Submarine
		end
	end

	return nil
end

function var0_0.isFull(arg0_34)
	local var0_34 = arg0_34:getFleetType()

	if var0_34 == FleetType.Normal then
		return #arg0_34.vanguardShips + #arg0_34.mainShips >= TeamType.VanguardMax + TeamType.MainMax
	elseif var0_34 == FleetType.Submarine then
		return #arg0_34.subShips >= TeamType.SubmarineMax
	end

	return false
end

function var0_0.isEmpty(arg0_35)
	return #arg0_35.ships == 0
end

function var0_0.isLegalToFight(arg0_36)
	local var0_36 = arg0_36:getFleetType()

	if var0_36 == FleetType.Normal then
		if #arg0_36.vanguardShips == 0 then
			return TeamType.Vanguard, 1
		elseif #arg0_36.mainShips == 0 then
			return TeamType.Main, 1
		end
	elseif var0_36 == FleetType.Submarine and #arg0_36.subShips == 0 then
		return TeamType.Submarine, 1
	end

	return true
end

function var0_0.getSkillNum(arg0_37)
	local var0_37 = {
		"zhupao",
		"yulei",
		"fangkongpao",
		"jianzaiji"
	}
	local var1_37 = {}

	for iter0_37, iter1_37 in pairs(var0_37) do
		var1_37[iter1_37] = 0
	end

	local var2_37 = getProxy(BayProxy):getRawData()
	local var3_37 = ys.Battle.BattleConst.EquipmentType

	for iter2_37, iter3_37 in ipairs(arg0_37.ships) do
		for iter4_37, iter5_37 in ipairs(var2_37[iter3_37]:getActiveEquipments()) do
			if iter5_37 > 0 then
				local var4_37 = Equipment.New({
					id = iter5_37
				}):getConfig("weapon_id")

				for iter6_37, iter7_37 in ipairs(var4_37) do
					if iter7_37 > 0 then
						local var5_37 = pg.weapon_property[iter7_37].type

						if var5_37 == var3_37.POINT_HIT_AND_LOCK then
							var1_37.zhupao = var1_37.zhupao + 1
						elseif var5_37 == var3_37.TORPEDO or var5_37 == var3_37.MANUAL_TORPEDO then
							var1_37.yulei = var1_37.yulei + 1
						elseif var5_37 == var3_37.ANTI_AIR then
							var1_37.fangkongpao = var1_37.fangkongpao + 1
						elseif var5_37 == var3_37.INTERCEPT_AIRCRAFT then
							var1_37.jianzaiji = var1_37.jianzaiji + 1
						end
					end
				end
			end
		end
	end

	return var1_37
end

function var0_0.GetPropertiesSum(arg0_38)
	local var0_38 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}
	local var1_38 = getProxy(BayProxy):getRawData()

	for iter0_38, iter1_38 in ipairs(arg0_38.ships) do
		local var2_38 = var1_38[iter1_38]:getProperties(arg0_38:getCommanders())

		var0_38.cannon = var0_38.cannon + math.floor(var2_38.cannon)
		var0_38.torpedo = var0_38.torpedo + math.floor(var2_38.torpedo)
		var0_38.antiAir = var0_38.antiAir + math.floor(var2_38.antiaircraft)
		var0_38.air = var0_38.air + math.floor(var2_38.air)
	end

	return var0_38
end

function var0_0.GetCostSum(arg0_39)
	local var0_39 = {
		gold = 0,
		oil = 0
	}
	local var1_39 = arg0_39:getStartCost()
	local var2_39 = arg0_39:getEndCost()

	if arg0_39:getFleetType() == FleetType.Submarine then
		var0_39.oil = var2_39.oil
	else
		var0_39.oil = var1_39.oil + var2_39.oil
	end

	return var0_39
end

function var0_0.getStartCost(arg0_40)
	local var0_40 = {
		gold = 0,
		oil = 0
	}
	local var1_40 = getProxy(BayProxy):getRawData()

	for iter0_40, iter1_40 in ipairs(arg0_40.ships) do
		local var2_40 = var1_40[iter1_40]:getStartBattleExpend()

		var0_40.oil = var0_40.oil + var2_40
	end

	return var0_40
end

function var0_0.getEndCost(arg0_41)
	local var0_41 = {
		gold = 0,
		oil = 0
	}
	local var1_41 = getProxy(BayProxy):getRawData()

	for iter0_41, iter1_41 in ipairs(arg0_41.ships) do
		local var2_41 = var1_41[iter1_41]:getEndBattleExpend()

		var0_41.oil = var0_41.oil + var2_41
	end

	return var0_41
end

function var0_0.GetGearScoreSum(arg0_42, arg1_42)
	local var0_42

	if arg1_42 == nil then
		var0_42 = arg0_42.ships
	else
		var0_42 = arg0_42:getTeamByName(arg1_42)
	end

	local var1_42 = 0
	local var2_42 = getProxy(BayProxy):getRawData()

	for iter0_42, iter1_42 in ipairs(var0_42) do
		var1_42 = var1_42 + var2_42[iter1_42]:getShipCombatPower(arg0_42:getCommanders())
	end

	return var1_42
end

function var0_0.GetEnergyStatus(arg0_43)
	local var0_43 = false
	local var1_43 = ""
	local var2_43 = ""
	local var3_43 = getProxy(BayProxy)

	local function var4_43(arg0_44)
		for iter0_44 = 1, 3 do
			if arg0_44[iter0_44] then
				local var0_44 = var3_43:getShipById(arg0_44[iter0_44])

				if var0_44.energy == Ship.ENERGY_LOW then
					var0_43 = true
					var2_43 = var2_43 .. "「" .. var0_44:getConfig("name") .. "」"
				end
			end
		end
	end

	var4_43(arg0_43.mainShips)
	var4_43(arg0_43.vanguardShips)
	var4_43(arg0_43.subShips)

	if var0_43 then
		var1_43 = arg0_43:GetName()
	end

	return var0_43, i18n("ship_energy_low_warn", var1_43, var2_43)
end

function var0_0.genRobotDataString(arg0_45)
	local var0_45 = getProxy(BayProxy):getRawData()
	local var1_45 = "99999,"

	for iter0_45 = 1, 3 do
		if arg0_45.vanguardShips[iter0_45] and arg0_45.vanguardShips[iter0_45] > 0 then
			var1_45 = var1_45 .. var0_45[arg0_45.vanguardShips[iter0_45]].configId .. "," .. var0_45[arg0_45.vanguardShips[iter0_45]].level .. ",\"{"

			for iter1_45, iter2_45 in pairs(var0_45[arg0_45.vanguardShips[iter0_45]]:getActiveEquipments()) do
				var1_45 = var1_45 .. (iter2_45 and iter2_45.id or 0)

				if iter1_45 < 5 then
					var1_45 = var1_45 .. ","
				end
			end

			var1_45 = var1_45 .. "}\","
		else
			var1_45 = var1_45 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	for iter3_45 = 1, 3 do
		if arg0_45.mainShips[iter3_45] and arg0_45.mainShips[iter3_45] > 0 then
			var1_45 = var1_45 .. var0_45[arg0_45.mainShips[iter3_45]].configId .. "," .. var0_45[arg0_45.mainShips[iter3_45]].level .. ",\"{"

			for iter4_45, iter5_45 in pairs(var0_45[arg0_45.mainShips[iter3_45]]:getActiveEquipments()) do
				var1_45 = var1_45 .. (iter5_45 and iter5_45.id or 0)

				if iter4_45 < 5 then
					var1_45 = var1_45 .. ","
				end
			end

			var1_45 = var1_45 .. "}\","
		else
			var1_45 = var1_45 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	local var2_45 = arg0_45:GetGearScoreSum(TeamType.Vanguard)
	local var3_45 = arg0_45:GetGearScoreSum(TeamType.Main)

	return var1_45 .. math.floor(var2_45 + var3_45) .. ","
end

function var0_0.getIndex(arg0_46)
	if arg0_46.id >= var0_0.SUBMARINE_FLEET_ID and arg0_46.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS then
		return arg0_46.id - var0_0.SUBMARINE_FLEET_ID + 1
	elseif arg0_46.id >= var0_0.REGULAR_FLEET_ID and arg0_46.id < var0_0.REGULAR_FLEET_ID + var0_0.REGULAR_FLEET_NUMS then
		return arg0_46.id - var0_0.REGULAR_FLEET_ID + 1
	end

	return arg0_46.id
end

function var0_0.getShipCount(arg0_47)
	return #arg0_47.ships
end

function var0_0.avgLevel(arg0_48)
	local var0_48 = 0

	for iter0_48, iter1_48 in ipairs(arg0_48.ships) do
		var0_48 = getProxy(BayProxy):getShipById(iter1_48).level + var0_48
	end

	return math.floor(var0_48 / #arg0_48.ships)
end

function var0_0.clearFleet(arg0_49)
	local var0_49 = Clone(arg0_49.ships)
	local var1_49 = getProxy(BayProxy)

	for iter0_49, iter1_49 in ipairs(var0_49) do
		local var2_49 = var1_49:getShipById(iter1_49)

		arg0_49:removeShip(var2_49)
	end
end

function var0_0.EnergyCheck(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	arg4_50 = arg4_50 or "ship_energy_low_warn"

	local var0_50 = {}

	for iter0_50, iter1_50 in ipairs(arg0_50) do
		if iter1_50.energy == Ship.ENERGY_LOW then
			table.insert(var0_50, iter1_50)
		end
	end

	if #var0_50 > 0 then
		local var1_50 = ""
		local var2_50 = _.map(var0_50, function(arg0_51)
			return "「" .. arg0_51:getConfig("name") .. "」"
		end)

		if PLATFORM_CODE ~= PLATFORM_US or #var2_50 == 1 then
			for iter2_50, iter3_50 in ipairs(var2_50) do
				var1_50 = var1_50 .. iter3_50
			end
		else
			if arg4_50 == "ship_energy_low_warn_no_exp" or arg4_50 == "ship_energy_low_warn" or arg4_50 == "ship_energy_low_desc" then
				arg4_50 = "multiple_" .. arg4_50
			end

			for iter4_50 = 1, #var2_50 - 2 do
				local var3_50 = var2_50[iter4_50]

				var1_50 = var1_50 .. var3_50 .. ", "
			end

			var1_50 = var1_50 .. var2_50[#var2_50 - 1] .. " and " .. var2_50[#var2_50]
		end

		existCall(arg3_50, false)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg4_50, arg1_50, var1_50),
			onYes = function()
				arg2_50(true)
			end,
			onNo = function()
				arg2_50(false)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		existCall(arg3_50, true)
		arg2_50(true)
	end
end

function var0_0.getFleetAirDominanceValue(arg0_54)
	local var0_54 = getProxy(BayProxy)
	local var1_54 = arg0_54:getCommanders()
	local var2_54 = 0

	for iter0_54, iter1_54 in ipairs(arg0_54.ships) do
		var2_54 = (function(arg0_55, arg1_55)
			return arg0_55 + calcAirDominanceValue(var0_54:getShipById(arg1_55), var1_54)
		end)(var2_54, iter1_54)
	end

	return var2_54
end

function var0_0.RemoveUnusedItems(arg0_56)
	local var0_56 = Clone(arg0_56.ships)
	local var1_56 = getProxy(BayProxy)

	for iter0_56, iter1_56 in ipairs(var0_56) do
		if not var1_56:getShipById(iter1_56) then
			arg0_56:removeShipById(iter1_56)
		end
	end

	local var2_56 = getProxy(CommanderProxy)
	local var3_56 = {}

	for iter2_56, iter3_56 in pairs(arg0_56.commanderIds) do
		if not var2_56:getCommanderById(iter3_56) then
			table.insert(var3_56, iter2_56)
		end
	end

	if #var3_56 > 0 then
		for iter4_56, iter5_56 in pairs(var3_56) do
			arg0_56.commanderIds[iter5_56] = nil
		end

		arg0_56.skills = {}

		arg0_56:updateCommanderSkills()
	end
end

function var0_0.removeShipById(arg0_57, arg1_57)
	for iter0_57, iter1_57 in ipairs(arg0_57.ships) do
		if iter1_57 == arg1_57 then
			table.remove(arg0_57.ships, iter0_57)

			break
		end
	end

	for iter2_57, iter3_57 in ipairs(arg0_57.vanguardShips) do
		if iter3_57 == arg1_57 then
			return table.remove(arg0_57.vanguardShips, iter2_57), TeamType.Vanguard
		end
	end

	for iter4_57, iter5_57 in ipairs(arg0_57.mainShips) do
		if iter5_57 == arg1_57 then
			return table.remove(arg0_57.mainShips, iter4_57), TeamType.Main
		end
	end

	for iter6_57, iter7_57 in ipairs(arg0_57.subShips) do
		if iter7_57 == arg1_57 then
			return table.remove(arg0_57.subShips, iter6_57), TeamType.Submarine
		end
	end
end

function var0_0.HaveShipsInEvent(arg0_58)
	local var0_58 = getProxy(BayProxy):getRawData()

	for iter0_58, iter1_58 in ipairs(arg0_58.ships) do
		if var0_58[iter1_58]:getFlag("inEvent") then
			return true, i18n("elite_disable_ship_escort")
		end
	end
end

function var0_0.GetFleetSonarRange(arg0_59)
	local var0_59 = getProxy(BayProxy)
	local var1_59 = 0
	local var2_59 = 0
	local var3_59 = 0
	local var4_59 = 0
	local var5_59 = ys.Battle.BattleConfig

	for iter0_59, iter1_59 in ipairs(arg0_59.ships) do
		local var6_59 = var0_59:getShipById(iter1_59)

		if var6_59 then
			local var7_59 = var6_59:getShipType()
			local var8_59 = var5_59.VAN_SONAR_PROPERTY[var7_59]

			if var8_59 then
				local var9_59 = (var6_59:getShipProperties()[AttributeType.AntiSub] or 0) / var8_59.a - var8_59.b

				var1_59 = math.max(var1_59, Mathf.Clamp(var9_59, var8_59.minRange, var8_59.maxRange))
			end

			if table.contains(TeamType.MainShipType, var7_59) then
				var4_59 = var4_59 + (var6_59:getShipProperties()[AttributeType.AntiSub] or 0)
			end

			for iter2_59, iter3_59 in ipairs(var6_59:getActiveEquipments()) do
				if iter3_59 then
					var3_59 = var3_59 + (iter3_59:getConfig("equip_parameters").range or 0)
				end
			end
		end
	end

	if var1_59 ~= 0 then
		local var10_59 = var5_59.MAIN_SONAR_PROPERTY
		local var11_59 = var4_59 / var10_59.a

		var2_59 = var3_59 + Mathf.Clamp(var11_59, var10_59.minRange, var10_59.maxRange)
	end

	return var1_59 + var2_59
end

function var0_0.getInvestSums(arg0_60)
	local var0_60 = getProxy(BayProxy)

	local function var1_60(arg0_61, arg1_61)
		local var0_61 = var0_60:getShipById(arg1_61):getProperties(arg0_60:getCommanders())

		return arg0_61 + var0_61[AttributeType.Air] + var0_61[AttributeType.Dodge]
	end

	local var2_60 = _.reduce(arg0_60.ships, 0, var1_60)

	return math.pow(var2_60, 0.666666666666667)
end

function var0_0.ExistActNpcShip(arg0_62)
	local var0_62 = getProxy(BayProxy)

	for iter0_62, iter1_62 in ipairs(arg0_62.ships) do
		local var1_62 = var0_62:RawGetShipById(iter1_62)

		if var1_62 and var1_62:isActivityNpc() then
			return true
		end
	end

	return false
end

function var0_0.GetName(arg0_63)
	return arg0_63.name == "" and var0_0.DEFAULT_NAME[arg0_63.id] or arg0_63.name
end

return var0_0
