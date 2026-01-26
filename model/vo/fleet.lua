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
var0_0.DEFAULT_NAME_BOSS_SINGLE_VARIABLE_ACT = {
	i18n("ship_formationUI_fleetName_1"),
	i18n("ship_formationUI_fleetName_2"),
	i18n("ship_formationUI_fleetName_3"),
	i18n("ship_formationUI_fleetName_4"),
	i18n("ship_formationUI_fleetName_5"),
	i18n("ship_formationUI_fleetName_6"),
	i18n("ship_formationUI_fleetName_7"),
	i18n("ship_formationUI_fleetName_8"),
	i18n("ship_formationUI_fleetName_9"),
	i18n("ship_formationUI_fleetName_10"),
	i18n("ship_formationUI_fleetName_11"),
	i18n("ship_formationUI_fleetName_12"),
	(i18n("ship_formationUI_fleetName_13"))
}
var0_0.DEFAULT_ELITE_NAME = {
	i18n("ship_formationUI_fleetName1"),
	i18n("ship_formationUI_fleetName2"),
	i18n("ship_formationUI_fleetName11"),
	(i18n("ship_formationUI_fleetName13"))
}
var0_0.REGULAR_FLEET_ID = 1
var0_0.REGULAR_FLEET_NUMS = 6
var0_0.SUBMARINE_FLEET_ID = 11
var0_0.SUBMARINE_FLEET_NUMS = 4
var0_0.MEGA_SUBMARINE_FLEET_OFFSET = 100

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

function var0_0.SeparateOut(arg0_2)
	return {
		id = arg0_2.id,
		name = arg0_2.name,
		ship_list = underscore.to_array(arg0_2.ships),
		commanders = underscore(arg0_2.commanderIds):chain():keys():map(function(arg0_3)
			return {
				pos = arg0_3,
				id = arg0_2.commanderIds[arg0_3]
			}
		end):value()
	}
end

function var0_0.isUnlock(arg0_4)
	local var0_4 = {
		nil,
		nil,
		404,
		504,
		604,
		704
	}
	local var1_4 = getProxy(ChapterProxy)
	local var2_4 = var0_4[arg0_4.id]

	if var2_4 then
		local var3_4 = var1_4:getChapterById(var2_4)

		return var3_4 and var3_4:isClear(), i18n("formation_chapter_lock", string.sub(tostring(var2_4), 1, 1), arg0_4.id)
	end

	return true
end

function var0_0.containShip(arg0_5, arg1_5)
	return table.contains(arg0_5.ships, arg1_5.id)
end

function var0_0.isFirstFleet(arg0_6)
	return arg0_6.id == var0_0.REGULAR_FLEET_ID
end

function var0_0.outputCommanders(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.commanderIds) do
		assert(iter1_7, "id is nil")
		table.insert(var0_7, {
			pos = iter0_7,
			id = iter1_7
		})
	end

	return var0_7
end

function var0_0.clearCommanders(arg0_8)
	arg0_8.commanderIds = {}

	arg0_8:updateCommanderSkills()
end

function var0_0.getCommanders(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.commanderIds) do
		var0_9[iter0_9] = getProxy(CommanderProxy):getCommanderById(iter1_9)
	end

	return var0_9
end

function var0_0.getCommanderByPos(arg0_10, arg1_10)
	return arg0_10:getCommanders()[arg1_10]
end

function var0_0.updateCommanderByPos(arg0_11, arg1_11, arg2_11)
	if arg2_11 then
		arg0_11.commanderIds[arg1_11] = arg2_11.id
	else
		arg0_11.commanderIds[arg1_11] = nil
	end

	arg0_11:updateCommanderSkills()
end

function var0_0.getCommandersAddition(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(CommanderConst.PROPERTIES) do
		local var1_12 = 0

		for iter2_12, iter3_12 in pairs(arg0_12:getCommanders()) do
			var1_12 = var1_12 + iter3_12:getAbilitysAddition()[iter1_12]
		end

		if var1_12 > 0 then
			table.insert(var0_12, {
				attrName = iter1_12,
				value = var1_12
			})
		end
	end

	return var0_12
end

function var0_0.getCommandersTalentDesc(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13:getCommanders()) do
		local var1_13 = iter1_13:getTalentsDesc()

		for iter2_13, iter3_13 in pairs(var1_13) do
			if var0_13[iter2_13] then
				var0_13[iter2_13].value = var0_13[iter2_13].value + iter3_13.value
			else
				var0_13[iter2_13] = {
					name = iter2_13,
					value = iter3_13.value,
					type = iter3_13.type
				}
			end
		end
	end

	return var0_13
end

function var0_0.findCommanderBySkillId(arg0_14, arg1_14)
	local var0_14 = arg0_14:getCommanders()

	for iter0_14, iter1_14 in pairs(var0_14) do
		if _.any(iter1_14:getSkills(), function(arg0_15)
			return _.any(arg0_15:getTacticSkill(), function(arg0_16)
				return arg0_16 == arg1_14
			end)
		end) then
			return iter1_14
		end
	end
end

function var0_0.updateCommanderSkills(arg0_17)
	local var0_17 = #arg0_17.skills

	while var0_17 > 0 do
		local var1_17 = arg0_17.skills[var0_17]

		if not arg0_17:findCommanderBySkillId(var1_17.id) and var1_17:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0_17.skills, var0_17)
		end

		var0_17 = var0_17 - 1
	end

	local var2_17 = arg0_17:getCommanders()

	for iter0_17, iter1_17 in pairs(var2_17) do
		for iter2_17, iter3_17 in ipairs(iter1_17:getSkills()) do
			for iter4_17, iter5_17 in ipairs(iter3_17:getTacticSkill()) do
				table.insert(arg0_17.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5_17))
			end
		end
	end
end

function var0_0.buildBattleBuffList(arg0_18)
	local var0_18 = {}
	local var1_18, var2_18 = FleetSkill.triggerSkill(arg0_18, FleetSkill.TypeBattleBuff)

	if var1_18 and #var1_18 > 0 then
		local var3_18 = {}

		for iter0_18, iter1_18 in ipairs(var1_18) do
			local var4_18 = var2_18[iter0_18]
			local var5_18 = arg0_18:findCommanderBySkillId(var4_18.id)

			var3_18[var5_18] = var3_18[var5_18] or {}

			table.insert(var3_18[var5_18], iter1_18)
		end

		for iter2_18, iter3_18 in pairs(var3_18) do
			table.insert(var0_18, {
				iter2_18,
				iter3_18
			})
		end
	end

	local var6_18 = arg0_18:getCommanders()

	for iter4_18, iter5_18 in pairs(var6_18) do
		local var7_18 = iter5_18:getTalents()

		for iter6_18, iter7_18 in ipairs(var7_18) do
			local var8_18 = iter7_18:getBuffsAddition()

			if #var8_18 > 0 then
				local var9_18

				for iter8_18, iter9_18 in ipairs(var0_18) do
					if iter9_18[1] == iter5_18 then
						var9_18 = iter9_18[2]

						break
					end
				end

				if not var9_18 then
					var9_18 = {}

					table.insert(var0_18, {
						iter5_18,
						var9_18
					})
				end

				for iter10_18, iter11_18 in ipairs(var8_18) do
					table.insert(var9_18, iter11_18)
				end
			end
		end
	end

	return var0_18
end

function var0_0.getSkills(arg0_19)
	return arg0_19.skills
end

function var0_0.getShipIds(arg0_20)
	local var0_20 = {}
	local var1_20 = {
		arg0_20.mainShips,
		arg0_20.vanguardShips,
		arg0_20.subShips
	}

	for iter0_20, iter1_20 in ipairs(var1_20) do
		for iter2_20, iter3_20 in ipairs(iter1_20) do
			table.insert(var0_20, iter3_20)
		end
	end

	return var0_20
end

function var0_0.GetRawShipIds(arg0_21)
	return arg0_21.ships
end

function var0_0.GetRawCommanderIds(arg0_22)
	return arg0_22.commanderIds
end

function var0_0.findSkills(arg0_23, arg1_23)
	return _.filter(arg0_23:getSkills(), function(arg0_24)
		return arg0_24:GetType() == arg1_23
	end)
end

function var0_0.updateShips(arg0_25, arg1_25)
	arg0_25.ships = {}
	arg0_25.vanguardShips = {}
	arg0_25.mainShips = {}
	arg0_25.subShips = {}

	local var0_25 = getProxy(BayProxy)

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		local var1_25 = var0_25:getShipById(iter1_25)

		if var1_25 then
			arg0_25:insertShip(var1_25, nil, var1_25:getTeamType())
		end
	end
end

function var0_0.switchShip(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg0_26:getTeamByName(arg1_26)

	var0_26[arg2_26], var0_26[arg3_26] = var0_26[arg3_26], var0_26[arg2_26]
end

function var0_0.getShipPos(arg0_27, arg1_27)
	if not arg1_27 then
		return
	end

	local var0_27 = arg1_27:getTeamType()
	local var1_27 = arg0_27:getTeamByName(var0_27)

	return table.indexof(var1_27, arg1_27.id) or -1, var0_27
end

function var0_0.getTeamByName(arg0_28, arg1_28)
	if arg1_28 == TeamType.Vanguard then
		return arg0_28.vanguardShips
	elseif arg1_28 == TeamType.Main then
		return arg0_28.mainShips
	elseif arg1_28 == TeamType.Submarine then
		return arg0_28.subShips
	end
end

function var0_0.CanInsertShip(arg0_29, arg1_29, arg2_29)
	if arg0_29:isFull() or arg0_29:containShip(arg1_29) or not arg1_29:isAvaiable() or #arg0_29:getTeamByName(arg2_29) >= TeamType.GetTeamShipMax(arg2_29) then
		return false
	end

	return true
end

function var0_0.insertShip(arg0_30, arg1_30, arg2_30, arg3_30)
	if not arg0_30:CanInsertShip(arg1_30, arg3_30) then
		errorMsg("fleet insert error")
		pg.TipsMgr.GetInstance():ShowTips("fleet insert error")
	else
		local var0_30 = arg0_30:getTeamByName(arg3_30)

		arg2_30 = arg2_30 or #var0_30 + 1

		local var1_30 = arg3_30 == TeamType.Main and #arg0_30.vanguardShips or 0

		table.insert(var0_30, arg2_30, arg1_30.id)
		table.insert(arg0_30.ships, var1_30 + arg2_30, arg1_30.id)
	end
end

function var0_0.canRemove(arg0_31, arg1_31)
	local var0_31, var1_31 = arg0_31:getShipPos(arg1_31)

	if var0_31 > 0 and #(arg0_31:getTeamByName(var1_31) or {}) == 1 and arg0_31:isFirstFleet() then
		return false
	else
		return true
	end
end

function var0_0.isRegularFleet(arg0_32)
	return arg0_32.id >= var0_0.SUBMARINE_FLEET_ID and arg0_32.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS or arg0_32.id >= var0_0.REGULAR_FLEET_ID and arg0_32.id < var0_0.REGULAR_FLEET_ID + var0_0.REGULAR_FLEET_NUMS
end

function var0_0.isSubmarineFleet(arg0_33)
	return arg0_33.id >= var0_0.SUBMARINE_FLEET_ID and arg0_33.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS
end

function var0_0.isPVPFleet(arg0_34)
	return arg0_34.id == FleetProxy.PVP_FLEET_ID
end

function var0_0.getFleetType(arg0_35)
	assert(false)
end

function var0_0.removeShip(arg0_36, arg1_36)
	assert(arg0_36:containShip(arg1_36), "ship are not in fleet")

	local var0_36 = arg1_36.id

	for iter0_36, iter1_36 in ipairs(arg0_36.ships) do
		if iter1_36 == var0_36 then
			table.remove(arg0_36.ships, iter0_36)

			break
		end
	end

	for iter2_36, iter3_36 in ipairs(arg0_36.vanguardShips) do
		if iter3_36 == var0_36 then
			return table.remove(arg0_36.vanguardShips, iter2_36), TeamType.Vanguard
		end
	end

	for iter4_36, iter5_36 in ipairs(arg0_36.mainShips) do
		if iter5_36 == var0_36 then
			return table.remove(arg0_36.mainShips, iter4_36), TeamType.Main
		end
	end

	for iter6_36, iter7_36 in ipairs(arg0_36.subShips) do
		if iter7_36 == var0_36 then
			return table.remove(arg0_36.subShips, iter6_36), TeamType.Submarine
		end
	end

	return nil
end

function var0_0.isFull(arg0_37)
	local var0_37 = arg0_37:getFleetType()

	if var0_37 == FleetType.Normal then
		assert(#arg0_37.vanguardShips <= TeamType.VanguardMax and #arg0_37.mainShips <= TeamType.MainMax)

		return #arg0_37.vanguardShips == TeamType.VanguardMax and #arg0_37.mainShips == TeamType.MainMax
	elseif var0_37 == FleetType.Submarine then
		assert(#arg0_37.subShips <= TeamType.SubmarineMax)

		return #arg0_37.subShips == TeamType.SubmarineMax
	end

	return false
end

function var0_0.isEmpty(arg0_38)
	return #arg0_38.ships == 0
end

function var0_0.isCommanderEmpty(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.commanderIds) do
		if iter1_39 and iter1_39 ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.isLegalToFight(arg0_40)
	local var0_40 = arg0_40:getFleetType()

	if var0_40 == FleetType.Normal then
		if #arg0_40.vanguardShips == 0 then
			return TeamType.Vanguard, 1
		elseif #arg0_40.mainShips == 0 then
			return TeamType.Main, 1
		end
	elseif var0_40 == FleetType.Submarine and #arg0_40.subShips == 0 then
		return TeamType.Submarine, 1
	end

	return true
end

function var0_0.getSkillNum(arg0_41)
	local var0_41 = {
		"zhupao",
		"yulei",
		"fangkongpao",
		"jianzaiji"
	}
	local var1_41 = {}

	for iter0_41, iter1_41 in pairs(var0_41) do
		var1_41[iter1_41] = 0
	end

	local var2_41 = getProxy(BayProxy):getRawData()
	local var3_41 = ys.Battle.BattleConst.EquipmentType

	for iter2_41, iter3_41 in ipairs(arg0_41.ships) do
		for iter4_41, iter5_41 in ipairs(var2_41[iter3_41]:getActiveEquipments()) do
			if iter5_41 > 0 then
				local var4_41 = Equipment.New({
					id = iter5_41
				}):getConfig("weapon_id")

				for iter6_41, iter7_41 in ipairs(var4_41) do
					if iter7_41 > 0 then
						local var5_41 = pg.weapon_property[iter7_41].type

						if var5_41 == var3_41.POINT_HIT_AND_LOCK then
							var1_41.zhupao = var1_41.zhupao + 1
						elseif var5_41 == var3_41.TORPEDO or var5_41 == var3_41.MANUAL_TORPEDO then
							var1_41.yulei = var1_41.yulei + 1
						elseif var5_41 == var3_41.ANTI_AIR then
							var1_41.fangkongpao = var1_41.fangkongpao + 1
						elseif var5_41 == var3_41.INTERCEPT_AIRCRAFT then
							var1_41.jianzaiji = var1_41.jianzaiji + 1
						end
					end
				end
			end
		end
	end

	return var1_41
end

function var0_0.GetPropertiesSum(arg0_42)
	local var0_42 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}
	local var1_42 = getProxy(BayProxy):getRawData()

	for iter0_42, iter1_42 in ipairs(arg0_42.ships) do
		local var2_42 = var1_42[iter1_42]:getProperties(arg0_42:getCommanders())

		var0_42.cannon = var0_42.cannon + math.floor(var2_42.cannon)
		var0_42.torpedo = var0_42.torpedo + math.floor(var2_42.torpedo)
		var0_42.antiAir = var0_42.antiAir + math.floor(var2_42.antiaircraft)
		var0_42.air = var0_42.air + math.floor(var2_42.air)
	end

	return var0_42
end

function var0_0.GetCostSum(arg0_43)
	local var0_43 = {
		gold = 0,
		oil = 0
	}
	local var1_43 = arg0_43:getStartCost()
	local var2_43 = arg0_43:getEndCost()

	if arg0_43:getFleetType() == FleetType.Submarine then
		var0_43.oil = var2_43.oil
	else
		var0_43.oil = var1_43.oil + var2_43.oil
	end

	return var0_43
end

function var0_0.getStartCost(arg0_44)
	local var0_44 = {
		gold = 0,
		oil = 0
	}
	local var1_44 = getProxy(BayProxy):getRawData()

	for iter0_44, iter1_44 in ipairs(arg0_44.ships) do
		local var2_44 = var1_44[iter1_44]:getStartBattleExpend()

		var0_44.oil = var0_44.oil + var2_44
	end

	return var0_44
end

function var0_0.getEndCost(arg0_45)
	local var0_45 = {
		gold = 0,
		oil = 0
	}
	local var1_45 = getProxy(BayProxy):getRawData()

	for iter0_45, iter1_45 in ipairs(arg0_45.ships) do
		local var2_45 = var1_45[iter1_45]:getEndBattleExpend()

		var0_45.oil = var0_45.oil + var2_45
	end

	return var0_45
end

function var0_0.GetGearScoreSum(arg0_46, arg1_46)
	local var0_46

	if arg1_46 == nil then
		var0_46 = arg0_46.ships
	else
		var0_46 = arg0_46:getTeamByName(arg1_46)
	end

	local var1_46 = 0
	local var2_46 = getProxy(BayProxy):getRawData()

	for iter0_46, iter1_46 in ipairs(var0_46) do
		var1_46 = var1_46 + var2_46[iter1_46]:getShipCombatPower(arg0_46:getCommanders())
	end

	return var1_46
end

function var0_0.GetEnergyStatus(arg0_47)
	local var0_47 = false
	local var1_47 = ""
	local var2_47 = ""
	local var3_47 = getProxy(BayProxy)

	local function var4_47(arg0_48)
		for iter0_48 = 1, 3 do
			if arg0_48[iter0_48] then
				local var0_48 = var3_47:getShipById(arg0_48[iter0_48])

				if var0_48.energy == Ship.ENERGY_LOW then
					var0_47 = true
					var2_47 = var2_47 .. "「" .. var0_48:getConfig("name") .. "」"
				end
			end
		end
	end

	var4_47(arg0_47.mainShips)
	var4_47(arg0_47.vanguardShips)
	var4_47(arg0_47.subShips)

	if var0_47 then
		var1_47 = arg0_47:GetName()
	end

	return var0_47, i18n("ship_energy_low_warn", var1_47, var2_47)
end

function var0_0.genRobotDataString(arg0_49)
	local var0_49 = getProxy(BayProxy):getRawData()
	local var1_49 = "99999,"

	for iter0_49 = 1, 3 do
		if arg0_49.vanguardShips[iter0_49] and arg0_49.vanguardShips[iter0_49] > 0 then
			var1_49 = var1_49 .. var0_49[arg0_49.vanguardShips[iter0_49]].configId .. "," .. var0_49[arg0_49.vanguardShips[iter0_49]].level .. ",\"{"

			for iter1_49, iter2_49 in pairs(var0_49[arg0_49.vanguardShips[iter0_49]]:getActiveEquipments()) do
				var1_49 = var1_49 .. (iter2_49 and iter2_49.id or 0)

				if iter1_49 < 5 then
					var1_49 = var1_49 .. ","
				end
			end

			var1_49 = var1_49 .. "}\","
		else
			var1_49 = var1_49 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	for iter3_49 = 1, 3 do
		if arg0_49.mainShips[iter3_49] and arg0_49.mainShips[iter3_49] > 0 then
			var1_49 = var1_49 .. var0_49[arg0_49.mainShips[iter3_49]].configId .. "," .. var0_49[arg0_49.mainShips[iter3_49]].level .. ",\"{"

			for iter4_49, iter5_49 in pairs(var0_49[arg0_49.mainShips[iter3_49]]:getActiveEquipments()) do
				var1_49 = var1_49 .. (iter5_49 and iter5_49.id or 0)

				if iter4_49 < 5 then
					var1_49 = var1_49 .. ","
				end
			end

			var1_49 = var1_49 .. "}\","
		else
			var1_49 = var1_49 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	local var2_49 = arg0_49:GetGearScoreSum(TeamType.Vanguard)
	local var3_49 = arg0_49:GetGearScoreSum(TeamType.Main)

	return var1_49 .. math.floor(var2_49 + var3_49) .. ","
end

function var0_0.getIndex(arg0_50)
	if arg0_50.id >= var0_0.SUBMARINE_FLEET_ID and arg0_50.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS then
		return arg0_50.id - var0_0.SUBMARINE_FLEET_ID + 1
	elseif arg0_50.id >= var0_0.REGULAR_FLEET_ID and arg0_50.id < var0_0.REGULAR_FLEET_ID + var0_0.REGULAR_FLEET_NUMS then
		return arg0_50.id - var0_0.REGULAR_FLEET_ID + 1
	end

	return arg0_50.id
end

function var0_0.getShipCount(arg0_51)
	return #arg0_51.ships
end

function var0_0.avgLevel(arg0_52)
	local var0_52 = 0

	for iter0_52, iter1_52 in ipairs(arg0_52.ships) do
		var0_52 = getProxy(BayProxy):getShipById(iter1_52).level + var0_52
	end

	return math.floor(var0_52 / #arg0_52.ships)
end

function var0_0.clearFleet(arg0_53)
	local var0_53 = Clone(arg0_53.ships)
	local var1_53 = getProxy(BayProxy)

	for iter0_53, iter1_53 in ipairs(var0_53) do
		local var2_53 = var1_53:getShipById(iter1_53)

		arg0_53:removeShip(var2_53)
	end
end

function var0_0.EnergyCheck(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54)
	arg4_54 = arg4_54 or "ship_energy_low_warn"

	local var0_54 = {}

	for iter0_54, iter1_54 in ipairs(arg0_54) do
		if iter1_54.energy == Ship.ENERGY_LOW then
			table.insert(var0_54, iter1_54)
		end
	end

	if #var0_54 > 0 then
		local var1_54 = ""
		local var2_54 = _.map(var0_54, function(arg0_55)
			return "「" .. arg0_55:getConfig("name") .. "」"
		end)

		if PLATFORM_CODE ~= PLATFORM_US or #var2_54 == 1 then
			for iter2_54, iter3_54 in ipairs(var2_54) do
				var1_54 = var1_54 .. iter3_54
			end
		else
			if arg4_54 == "ship_energy_low_warn_no_exp" or arg4_54 == "ship_energy_low_warn" or arg4_54 == "ship_energy_low_desc" then
				arg4_54 = "multiple_" .. arg4_54
			end

			for iter4_54 = 1, #var2_54 - 2 do
				local var3_54 = var2_54[iter4_54]

				var1_54 = var1_54 .. var3_54 .. ", "
			end

			var1_54 = var1_54 .. var2_54[#var2_54 - 1] .. " and " .. var2_54[#var2_54]
		end

		existCall(arg3_54, false)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg4_54, arg1_54, var1_54),
			onYes = function()
				arg2_54(true)
			end,
			onNo = function()
				arg2_54(false)
			end
		})
	else
		existCall(arg3_54, true)
		arg2_54(true)
	end
end

function var0_0.getFleetAirDominanceValue(arg0_58)
	local var0_58 = getProxy(BayProxy)
	local var1_58 = arg0_58:getCommanders()
	local var2_58 = 0

	for iter0_58, iter1_58 in ipairs(arg0_58.ships) do
		var2_58 = (function(arg0_59, arg1_59)
			return arg0_59 + calcAirDominanceValue(var0_58:getShipById(arg1_59), var1_58)
		end)(var2_58, iter1_58)
	end

	return var2_58
end

function var0_0.RemoveUnusedItems(arg0_60)
	local var0_60 = Clone(arg0_60.ships)
	local var1_60 = getProxy(BayProxy)

	for iter0_60, iter1_60 in ipairs(var0_60) do
		if not var1_60:getShipById(iter1_60) then
			arg0_60:removeShipById(iter1_60)
		end
	end

	local var2_60 = getProxy(CommanderProxy)
	local var3_60 = {}

	for iter2_60, iter3_60 in pairs(arg0_60.commanderIds) do
		if not var2_60:getCommanderById(iter3_60) then
			table.insert(var3_60, iter2_60)
		end
	end

	if #var3_60 > 0 then
		for iter4_60, iter5_60 in pairs(var3_60) do
			arg0_60.commanderIds[iter5_60] = nil
		end

		arg0_60.skills = {}

		arg0_60:updateCommanderSkills()
	end
end

function var0_0.removeShipById(arg0_61, arg1_61)
	for iter0_61, iter1_61 in ipairs(arg0_61.ships) do
		if iter1_61 == arg1_61 then
			table.remove(arg0_61.ships, iter0_61)

			break
		end
	end

	for iter2_61, iter3_61 in ipairs(arg0_61.vanguardShips) do
		if iter3_61 == arg1_61 then
			return table.remove(arg0_61.vanguardShips, iter2_61), TeamType.Vanguard
		end
	end

	for iter4_61, iter5_61 in ipairs(arg0_61.mainShips) do
		if iter5_61 == arg1_61 then
			return table.remove(arg0_61.mainShips, iter4_61), TeamType.Main
		end
	end

	for iter6_61, iter7_61 in ipairs(arg0_61.subShips) do
		if iter7_61 == arg1_61 then
			return table.remove(arg0_61.subShips, iter6_61), TeamType.Submarine
		end
	end
end

function var0_0.HaveShipsInEvent(arg0_62)
	local var0_62 = getProxy(BayProxy):getRawData()

	for iter0_62, iter1_62 in ipairs(arg0_62.ships) do
		if var0_62[iter1_62]:getFlag("inEvent") then
			return true, i18n("elite_disable_ship_escort")
		end
	end
end

function var0_0.GetFleetSonarRange(arg0_63)
	local var0_63 = getProxy(BayProxy)
	local var1_63 = 0
	local var2_63 = 0
	local var3_63 = 0
	local var4_63 = 0
	local var5_63 = ys.Battle.BattleConfig

	for iter0_63, iter1_63 in ipairs(arg0_63.ships) do
		local var6_63 = var0_63:getShipById(iter1_63)

		if var6_63 then
			local var7_63 = var6_63:getShipType()
			local var8_63 = var5_63.VAN_SONAR_PROPERTY[var7_63]

			if var8_63 then
				local var9_63 = (var6_63:getShipProperties()[AttributeType.AntiSub] or 0) / var8_63.a - var8_63.b

				var1_63 = math.max(var1_63, Mathf.Clamp(var9_63, var8_63.minRange, var8_63.maxRange))
			end

			if table.contains(ShipType.MainShipType, var7_63) then
				var4_63 = var4_63 + (var6_63:getShipProperties()[AttributeType.AntiSub] or 0)
			end

			for iter2_63, iter3_63 in ipairs(var6_63:getActiveEquipments()) do
				if iter3_63 then
					var3_63 = var3_63 + (iter3_63:getConfig("equip_parameters").range or 0)
				end
			end
		end
	end

	if var1_63 ~= 0 then
		local var10_63 = var5_63.MAIN_SONAR_PROPERTY
		local var11_63 = var4_63 / var10_63.a

		var2_63 = var3_63 + Mathf.Clamp(var11_63, var10_63.minRange, var10_63.maxRange)
	end

	return var1_63 + var2_63
end

function var0_0.getInvestSums(arg0_64)
	local var0_64 = getProxy(BayProxy)

	local function var1_64(arg0_65, arg1_65)
		local var0_65 = var0_64:getShipById(arg1_65):getProperties(arg0_64:getCommanders())

		return arg0_65 + var0_65[AttributeType.Air] + var0_65[AttributeType.Dodge]
	end

	local var2_64 = _.reduce(arg0_64.ships, 0, var1_64)

	return math.pow(var2_64, 0.666666666666667)
end

function var0_0.ExistActNpcShip(arg0_66)
	local var0_66 = getProxy(BayProxy)

	for iter0_66, iter1_66 in ipairs(arg0_66.ships) do
		local var1_66 = var0_66:RawGetShipById(iter1_66)

		if var1_66 and var1_66:isActivityNpc() then
			return true
		end
	end

	return false
end

function var0_0.GetName(arg0_67)
	return noEmptyStr(arg0_67.name) or var0_0.DEFAULT_NAME[arg0_67.id]
end

function var0_0.ChangeToElite(arg0_68)
	local var0_68 = arg0_68:getFleetType()
	local var1_68 = {
		id = arg0_68.id,
		[TeamType.FormShips] = {},
		[TeamType.FormCommander] = {
			0,
			0
		}
	}

	for iter0_68, iter1_68 in ipairs(arg0_68.commanderIds) do
		var1_68[TeamType.FormCommander][iter0_68] = iter1_68
	end

	switch(var0_68, {
		[FleetType.Normal] = function()
			var1_68[TeamType.FormShips] = table.mergeArray(arg0_68.mainShips, arg0_68.vanguardShips)
		end,
		[FleetType.Submarine] = function()
			var1_68[TeamType.FormShips] = underscore.to_array(arg0_68.subShips)
		end,
		[FleetType.Support] = function()
			var1_68[TeamType.FormShips] = underscore.to_array(arg0_68.mainShips)
		end
	})

	return var1_68, var0_68
end

function var0_0.allClear(arg0_72)
	arg0_72:clearFleet()
	arg0_72:clearCommanders()
end

function var0_0.isAllEmpty(arg0_73)
	return arg0_73:isEmpty() and arg0_73:isCommanderEmpty()
end

return var0_0
