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

function var0_0.getCommanders(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.commanderIds) do
		var0_8[iter0_8] = getProxy(CommanderProxy):getCommanderById(iter1_8)
	end

	return var0_8
end

function var0_0.getCommanderByPos(arg0_9, arg1_9)
	return arg0_9:getCommanders()[arg1_9]
end

function var0_0.updateCommanderByPos(arg0_10, arg1_10, arg2_10)
	if arg2_10 then
		arg0_10.commanderIds[arg1_10] = arg2_10.id
	else
		arg0_10.commanderIds[arg1_10] = nil
	end

	arg0_10:updateCommanderSkills()
end

function var0_0.getCommandersAddition(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(CommanderConst.PROPERTIES) do
		local var1_11 = 0

		for iter2_11, iter3_11 in pairs(arg0_11:getCommanders()) do
			var1_11 = var1_11 + iter3_11:getAbilitysAddition()[iter1_11]
		end

		if var1_11 > 0 then
			table.insert(var0_11, {
				attrName = iter1_11,
				value = var1_11
			})
		end
	end

	return var0_11
end

function var0_0.getCommandersTalentDesc(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12:getCommanders()) do
		local var1_12 = iter1_12:getTalentsDesc()

		for iter2_12, iter3_12 in pairs(var1_12) do
			if var0_12[iter2_12] then
				var0_12[iter2_12].value = var0_12[iter2_12].value + iter3_12.value
			else
				var0_12[iter2_12] = {
					name = iter2_12,
					value = iter3_12.value,
					type = iter3_12.type
				}
			end
		end
	end

	return var0_12
end

function var0_0.findCommanderBySkillId(arg0_13, arg1_13)
	local var0_13 = arg0_13:getCommanders()

	for iter0_13, iter1_13 in pairs(var0_13) do
		if _.any(iter1_13:getSkills(), function(arg0_14)
			return _.any(arg0_14:getTacticSkill(), function(arg0_15)
				return arg0_15 == arg1_13
			end)
		end) then
			return iter1_13
		end
	end
end

function var0_0.updateCommanderSkills(arg0_16)
	local var0_16 = #arg0_16.skills

	while var0_16 > 0 do
		local var1_16 = arg0_16.skills[var0_16]

		if not arg0_16:findCommanderBySkillId(var1_16.id) and var1_16:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0_16.skills, var0_16)
		end

		var0_16 = var0_16 - 1
	end

	local var2_16 = arg0_16:getCommanders()

	for iter0_16, iter1_16 in pairs(var2_16) do
		for iter2_16, iter3_16 in ipairs(iter1_16:getSkills()) do
			for iter4_16, iter5_16 in ipairs(iter3_16:getTacticSkill()) do
				table.insert(arg0_16.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5_16))
			end
		end
	end
end

function var0_0.buildBattleBuffList(arg0_17)
	local var0_17 = {}
	local var1_17, var2_17 = FleetSkill.triggerSkill(arg0_17, FleetSkill.TypeBattleBuff)

	if var1_17 and #var1_17 > 0 then
		local var3_17 = {}

		for iter0_17, iter1_17 in ipairs(var1_17) do
			local var4_17 = var2_17[iter0_17]
			local var5_17 = arg0_17:findCommanderBySkillId(var4_17.id)

			var3_17[var5_17] = var3_17[var5_17] or {}

			table.insert(var3_17[var5_17], iter1_17)
		end

		for iter2_17, iter3_17 in pairs(var3_17) do
			table.insert(var0_17, {
				iter2_17,
				iter3_17
			})
		end
	end

	local var6_17 = arg0_17:getCommanders()

	for iter4_17, iter5_17 in pairs(var6_17) do
		local var7_17 = iter5_17:getTalents()

		for iter6_17, iter7_17 in ipairs(var7_17) do
			local var8_17 = iter7_17:getBuffsAddition()

			if #var8_17 > 0 then
				local var9_17

				for iter8_17, iter9_17 in ipairs(var0_17) do
					if iter9_17[1] == iter5_17 then
						var9_17 = iter9_17[2]

						break
					end
				end

				if not var9_17 then
					var9_17 = {}

					table.insert(var0_17, {
						iter5_17,
						var9_17
					})
				end

				for iter10_17, iter11_17 in ipairs(var8_17) do
					table.insert(var9_17, iter11_17)
				end
			end
		end
	end

	return var0_17
end

function var0_0.getSkills(arg0_18)
	return arg0_18.skills
end

function var0_0.getShipIds(arg0_19)
	local var0_19 = {}
	local var1_19 = {
		arg0_19.mainShips,
		arg0_19.vanguardShips,
		arg0_19.subShips
	}

	for iter0_19, iter1_19 in ipairs(var1_19) do
		for iter2_19, iter3_19 in ipairs(iter1_19) do
			table.insert(var0_19, iter3_19)
		end
	end

	return var0_19
end

function var0_0.GetRawShipIds(arg0_20)
	return arg0_20.ships
end

function var0_0.GetRawCommanderIds(arg0_21)
	return arg0_21.commanderIds
end

function var0_0.findSkills(arg0_22, arg1_22)
	return _.filter(arg0_22:getSkills(), function(arg0_23)
		return arg0_23:GetType() == arg1_22
	end)
end

function var0_0.updateShips(arg0_24, arg1_24)
	arg0_24.ships = {}
	arg0_24.vanguardShips = {}
	arg0_24.mainShips = {}
	arg0_24.subShips = {}

	local var0_24 = getProxy(BayProxy)

	for iter0_24, iter1_24 in ipairs(arg1_24) do
		local var1_24 = var0_24:getShipById(iter1_24)

		if var1_24 then
			arg0_24:insertShip(var1_24, nil, var1_24:getTeamType())
		end
	end
end

function var0_0.switchShip(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg0_25:getTeamByName(arg1_25)

	var0_25[arg2_25], var0_25[arg3_25] = var0_25[arg3_25], var0_25[arg2_25]
end

function var0_0.getShipPos(arg0_26, arg1_26)
	if not arg1_26 then
		return
	end

	local var0_26 = arg1_26:getTeamType()
	local var1_26 = arg0_26:getTeamByName(var0_26)

	return table.indexof(var1_26, arg1_26.id) or -1, var0_26
end

function var0_0.getTeamByName(arg0_27, arg1_27)
	if arg1_27 == TeamType.Vanguard then
		return arg0_27.vanguardShips
	elseif arg1_27 == TeamType.Main then
		return arg0_27.mainShips
	elseif arg1_27 == TeamType.Submarine then
		return arg0_27.subShips
	end
end

function var0_0.CanInsertShip(arg0_28, arg1_28, arg2_28)
	if arg0_28:isFull() or arg0_28:containShip(arg1_28) or not arg1_28:isAvaiable() or #arg0_28:getTeamByName(arg2_28) >= TeamType.GetTeamShipMax(arg2_28) then
		return false
	end

	return true
end

function var0_0.insertShip(arg0_29, arg1_29, arg2_29, arg3_29)
	if not arg0_29:CanInsertShip(arg1_29, arg3_29) then
		errorMsg("fleet insert error")
		pg.TipsMgr.GetInstance():ShowTips("fleet insert error")
	else
		local var0_29 = arg0_29:getTeamByName(arg3_29)

		arg2_29 = arg2_29 or #var0_29 + 1

		local var1_29 = arg3_29 == TeamType.Main and #arg0_29.vanguardShips or 0

		table.insert(var0_29, arg2_29, arg1_29.id)
		table.insert(arg0_29.ships, var1_29 + arg2_29, arg1_29.id)
	end
end

function var0_0.canRemove(arg0_30, arg1_30)
	local var0_30, var1_30 = arg0_30:getShipPos(arg1_30)

	if var0_30 > 0 and #(arg0_30:getTeamByName(var1_30) or {}) == 1 and arg0_30:isFirstFleet() then
		return false
	else
		return true
	end
end

function var0_0.isRegularFleet(arg0_31)
	return arg0_31.id >= var0_0.SUBMARINE_FLEET_ID and arg0_31.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS or arg0_31.id >= var0_0.REGULAR_FLEET_ID and arg0_31.id < var0_0.REGULAR_FLEET_ID + var0_0.REGULAR_FLEET_NUMS
end

function var0_0.isSubmarineFleet(arg0_32)
	return arg0_32.id >= var0_0.SUBMARINE_FLEET_ID and arg0_32.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS
end

function var0_0.isPVPFleet(arg0_33)
	return arg0_33.id == FleetProxy.PVP_FLEET_ID
end

function var0_0.getFleetType(arg0_34)
	assert(false)
end

function var0_0.removeShip(arg0_35, arg1_35)
	assert(arg0_35:containShip(arg1_35), "ship are not in fleet")

	local var0_35 = arg1_35.id

	for iter0_35, iter1_35 in ipairs(arg0_35.ships) do
		if iter1_35 == var0_35 then
			table.remove(arg0_35.ships, iter0_35)

			break
		end
	end

	for iter2_35, iter3_35 in ipairs(arg0_35.vanguardShips) do
		if iter3_35 == var0_35 then
			return table.remove(arg0_35.vanguardShips, iter2_35), TeamType.Vanguard
		end
	end

	for iter4_35, iter5_35 in ipairs(arg0_35.mainShips) do
		if iter5_35 == var0_35 then
			return table.remove(arg0_35.mainShips, iter4_35), TeamType.Main
		end
	end

	for iter6_35, iter7_35 in ipairs(arg0_35.subShips) do
		if iter7_35 == var0_35 then
			return table.remove(arg0_35.subShips, iter6_35), TeamType.Submarine
		end
	end

	return nil
end

function var0_0.isFull(arg0_36)
	local var0_36 = arg0_36:getFleetType()

	if var0_36 == FleetType.Normal then
		assert(#arg0_36.vanguardShips <= TeamType.VanguardMax and #arg0_36.mainShips <= TeamType.MainMax)

		return #arg0_36.vanguardShips == TeamType.VanguardMax and #arg0_36.mainShips == TeamType.MainMax
	elseif var0_36 == FleetType.Submarine then
		assert(#arg0_36.subShips <= TeamType.SubmarineMax)

		return #arg0_36.subShips == TeamType.SubmarineMax
	end

	return false
end

function var0_0.isEmpty(arg0_37)
	return #arg0_37.ships == 0
end

function var0_0.isLegalToFight(arg0_38)
	local var0_38 = arg0_38:getFleetType()

	if var0_38 == FleetType.Normal then
		if #arg0_38.vanguardShips == 0 then
			return TeamType.Vanguard, 1
		elseif #arg0_38.mainShips == 0 then
			return TeamType.Main, 1
		end
	elseif var0_38 == FleetType.Submarine and #arg0_38.subShips == 0 then
		return TeamType.Submarine, 1
	end

	return true
end

function var0_0.getSkillNum(arg0_39)
	local var0_39 = {
		"zhupao",
		"yulei",
		"fangkongpao",
		"jianzaiji"
	}
	local var1_39 = {}

	for iter0_39, iter1_39 in pairs(var0_39) do
		var1_39[iter1_39] = 0
	end

	local var2_39 = getProxy(BayProxy):getRawData()
	local var3_39 = ys.Battle.BattleConst.EquipmentType

	for iter2_39, iter3_39 in ipairs(arg0_39.ships) do
		for iter4_39, iter5_39 in ipairs(var2_39[iter3_39]:getActiveEquipments()) do
			if iter5_39 > 0 then
				local var4_39 = Equipment.New({
					id = iter5_39
				}):getConfig("weapon_id")

				for iter6_39, iter7_39 in ipairs(var4_39) do
					if iter7_39 > 0 then
						local var5_39 = pg.weapon_property[iter7_39].type

						if var5_39 == var3_39.POINT_HIT_AND_LOCK then
							var1_39.zhupao = var1_39.zhupao + 1
						elseif var5_39 == var3_39.TORPEDO or var5_39 == var3_39.MANUAL_TORPEDO then
							var1_39.yulei = var1_39.yulei + 1
						elseif var5_39 == var3_39.ANTI_AIR then
							var1_39.fangkongpao = var1_39.fangkongpao + 1
						elseif var5_39 == var3_39.INTERCEPT_AIRCRAFT then
							var1_39.jianzaiji = var1_39.jianzaiji + 1
						end
					end
				end
			end
		end
	end

	return var1_39
end

function var0_0.GetPropertiesSum(arg0_40)
	local var0_40 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}
	local var1_40 = getProxy(BayProxy):getRawData()

	for iter0_40, iter1_40 in ipairs(arg0_40.ships) do
		local var2_40 = var1_40[iter1_40]:getProperties(arg0_40:getCommanders())

		var0_40.cannon = var0_40.cannon + math.floor(var2_40.cannon)
		var0_40.torpedo = var0_40.torpedo + math.floor(var2_40.torpedo)
		var0_40.antiAir = var0_40.antiAir + math.floor(var2_40.antiaircraft)
		var0_40.air = var0_40.air + math.floor(var2_40.air)
	end

	return var0_40
end

function var0_0.GetCostSum(arg0_41)
	local var0_41 = {
		gold = 0,
		oil = 0
	}
	local var1_41 = arg0_41:getStartCost()
	local var2_41 = arg0_41:getEndCost()

	if arg0_41:getFleetType() == FleetType.Submarine then
		var0_41.oil = var2_41.oil
	else
		var0_41.oil = var1_41.oil + var2_41.oil
	end

	return var0_41
end

function var0_0.getStartCost(arg0_42)
	local var0_42 = {
		gold = 0,
		oil = 0
	}
	local var1_42 = getProxy(BayProxy):getRawData()

	for iter0_42, iter1_42 in ipairs(arg0_42.ships) do
		local var2_42 = var1_42[iter1_42]:getStartBattleExpend()

		var0_42.oil = var0_42.oil + var2_42
	end

	return var0_42
end

function var0_0.getEndCost(arg0_43)
	local var0_43 = {
		gold = 0,
		oil = 0
	}
	local var1_43 = getProxy(BayProxy):getRawData()

	for iter0_43, iter1_43 in ipairs(arg0_43.ships) do
		local var2_43 = var1_43[iter1_43]:getEndBattleExpend()

		var0_43.oil = var0_43.oil + var2_43
	end

	return var0_43
end

function var0_0.GetGearScoreSum(arg0_44, arg1_44)
	local var0_44

	if arg1_44 == nil then
		var0_44 = arg0_44.ships
	else
		var0_44 = arg0_44:getTeamByName(arg1_44)
	end

	local var1_44 = 0
	local var2_44 = getProxy(BayProxy):getRawData()

	for iter0_44, iter1_44 in ipairs(var0_44) do
		var1_44 = var1_44 + var2_44[iter1_44]:getShipCombatPower(arg0_44:getCommanders())
	end

	return var1_44
end

function var0_0.GetEnergyStatus(arg0_45)
	local var0_45 = false
	local var1_45 = ""
	local var2_45 = ""
	local var3_45 = getProxy(BayProxy)

	local function var4_45(arg0_46)
		for iter0_46 = 1, 3 do
			if arg0_46[iter0_46] then
				local var0_46 = var3_45:getShipById(arg0_46[iter0_46])

				if var0_46.energy == Ship.ENERGY_LOW then
					var0_45 = true
					var2_45 = var2_45 .. "「" .. var0_46:getConfig("name") .. "」"
				end
			end
		end
	end

	var4_45(arg0_45.mainShips)
	var4_45(arg0_45.vanguardShips)
	var4_45(arg0_45.subShips)

	if var0_45 then
		var1_45 = arg0_45:GetName()
	end

	return var0_45, i18n("ship_energy_low_warn", var1_45, var2_45)
end

function var0_0.genRobotDataString(arg0_47)
	local var0_47 = getProxy(BayProxy):getRawData()
	local var1_47 = "99999,"

	for iter0_47 = 1, 3 do
		if arg0_47.vanguardShips[iter0_47] and arg0_47.vanguardShips[iter0_47] > 0 then
			var1_47 = var1_47 .. var0_47[arg0_47.vanguardShips[iter0_47]].configId .. "," .. var0_47[arg0_47.vanguardShips[iter0_47]].level .. ",\"{"

			for iter1_47, iter2_47 in pairs(var0_47[arg0_47.vanguardShips[iter0_47]]:getActiveEquipments()) do
				var1_47 = var1_47 .. (iter2_47 and iter2_47.id or 0)

				if iter1_47 < 5 then
					var1_47 = var1_47 .. ","
				end
			end

			var1_47 = var1_47 .. "}\","
		else
			var1_47 = var1_47 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	for iter3_47 = 1, 3 do
		if arg0_47.mainShips[iter3_47] and arg0_47.mainShips[iter3_47] > 0 then
			var1_47 = var1_47 .. var0_47[arg0_47.mainShips[iter3_47]].configId .. "," .. var0_47[arg0_47.mainShips[iter3_47]].level .. ",\"{"

			for iter4_47, iter5_47 in pairs(var0_47[arg0_47.mainShips[iter3_47]]:getActiveEquipments()) do
				var1_47 = var1_47 .. (iter5_47 and iter5_47.id or 0)

				if iter4_47 < 5 then
					var1_47 = var1_47 .. ","
				end
			end

			var1_47 = var1_47 .. "}\","
		else
			var1_47 = var1_47 .. "" .. "," .. "" .. ",{" .. "},"
		end
	end

	local var2_47 = arg0_47:GetGearScoreSum(TeamType.Vanguard)
	local var3_47 = arg0_47:GetGearScoreSum(TeamType.Main)

	return var1_47 .. math.floor(var2_47 + var3_47) .. ","
end

function var0_0.getIndex(arg0_48)
	if arg0_48.id >= var0_0.SUBMARINE_FLEET_ID and arg0_48.id < var0_0.SUBMARINE_FLEET_ID + var0_0.SUBMARINE_FLEET_NUMS then
		return arg0_48.id - var0_0.SUBMARINE_FLEET_ID + 1
	elseif arg0_48.id >= var0_0.REGULAR_FLEET_ID and arg0_48.id < var0_0.REGULAR_FLEET_ID + var0_0.REGULAR_FLEET_NUMS then
		return arg0_48.id - var0_0.REGULAR_FLEET_ID + 1
	end

	return arg0_48.id
end

function var0_0.getShipCount(arg0_49)
	return #arg0_49.ships
end

function var0_0.avgLevel(arg0_50)
	local var0_50 = 0

	for iter0_50, iter1_50 in ipairs(arg0_50.ships) do
		var0_50 = getProxy(BayProxy):getShipById(iter1_50).level + var0_50
	end

	return math.floor(var0_50 / #arg0_50.ships)
end

function var0_0.clearFleet(arg0_51)
	local var0_51 = Clone(arg0_51.ships)
	local var1_51 = getProxy(BayProxy)

	for iter0_51, iter1_51 in ipairs(var0_51) do
		local var2_51 = var1_51:getShipById(iter1_51)

		arg0_51:removeShip(var2_51)
	end
end

function var0_0.EnergyCheck(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52)
	arg4_52 = arg4_52 or "ship_energy_low_warn"

	local var0_52 = {}

	for iter0_52, iter1_52 in ipairs(arg0_52) do
		if iter1_52.energy == Ship.ENERGY_LOW then
			table.insert(var0_52, iter1_52)
		end
	end

	if #var0_52 > 0 then
		local var1_52 = ""
		local var2_52 = _.map(var0_52, function(arg0_53)
			return "「" .. arg0_53:getConfig("name") .. "」"
		end)

		if PLATFORM_CODE ~= PLATFORM_US or #var2_52 == 1 then
			for iter2_52, iter3_52 in ipairs(var2_52) do
				var1_52 = var1_52 .. iter3_52
			end
		else
			if arg4_52 == "ship_energy_low_warn_no_exp" or arg4_52 == "ship_energy_low_warn" or arg4_52 == "ship_energy_low_desc" then
				arg4_52 = "multiple_" .. arg4_52
			end

			for iter4_52 = 1, #var2_52 - 2 do
				local var3_52 = var2_52[iter4_52]

				var1_52 = var1_52 .. var3_52 .. ", "
			end

			var1_52 = var1_52 .. var2_52[#var2_52 - 1] .. " and " .. var2_52[#var2_52]
		end

		existCall(arg3_52, false)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg4_52, arg1_52, var1_52),
			onYes = function()
				arg2_52(true)
			end,
			onNo = function()
				arg2_52(false)
			end
		})
	else
		existCall(arg3_52, true)
		arg2_52(true)
	end
end

function var0_0.getFleetAirDominanceValue(arg0_56)
	local var0_56 = getProxy(BayProxy)
	local var1_56 = arg0_56:getCommanders()
	local var2_56 = 0

	for iter0_56, iter1_56 in ipairs(arg0_56.ships) do
		var2_56 = (function(arg0_57, arg1_57)
			return arg0_57 + calcAirDominanceValue(var0_56:getShipById(arg1_57), var1_56)
		end)(var2_56, iter1_56)
	end

	return var2_56
end

function var0_0.RemoveUnusedItems(arg0_58)
	local var0_58 = Clone(arg0_58.ships)
	local var1_58 = getProxy(BayProxy)

	for iter0_58, iter1_58 in ipairs(var0_58) do
		if not var1_58:getShipById(iter1_58) then
			arg0_58:removeShipById(iter1_58)
		end
	end

	local var2_58 = getProxy(CommanderProxy)
	local var3_58 = {}

	for iter2_58, iter3_58 in pairs(arg0_58.commanderIds) do
		if not var2_58:getCommanderById(iter3_58) then
			table.insert(var3_58, iter2_58)
		end
	end

	if #var3_58 > 0 then
		for iter4_58, iter5_58 in pairs(var3_58) do
			arg0_58.commanderIds[iter5_58] = nil
		end

		arg0_58.skills = {}

		arg0_58:updateCommanderSkills()
	end
end

function var0_0.removeShipById(arg0_59, arg1_59)
	for iter0_59, iter1_59 in ipairs(arg0_59.ships) do
		if iter1_59 == arg1_59 then
			table.remove(arg0_59.ships, iter0_59)

			break
		end
	end

	for iter2_59, iter3_59 in ipairs(arg0_59.vanguardShips) do
		if iter3_59 == arg1_59 then
			return table.remove(arg0_59.vanguardShips, iter2_59), TeamType.Vanguard
		end
	end

	for iter4_59, iter5_59 in ipairs(arg0_59.mainShips) do
		if iter5_59 == arg1_59 then
			return table.remove(arg0_59.mainShips, iter4_59), TeamType.Main
		end
	end

	for iter6_59, iter7_59 in ipairs(arg0_59.subShips) do
		if iter7_59 == arg1_59 then
			return table.remove(arg0_59.subShips, iter6_59), TeamType.Submarine
		end
	end
end

function var0_0.HaveShipsInEvent(arg0_60)
	local var0_60 = getProxy(BayProxy):getRawData()

	for iter0_60, iter1_60 in ipairs(arg0_60.ships) do
		if var0_60[iter1_60]:getFlag("inEvent") then
			return true, i18n("elite_disable_ship_escort")
		end
	end
end

function var0_0.GetFleetSonarRange(arg0_61)
	local var0_61 = getProxy(BayProxy)
	local var1_61 = 0
	local var2_61 = 0
	local var3_61 = 0
	local var4_61 = 0
	local var5_61 = ys.Battle.BattleConfig

	for iter0_61, iter1_61 in ipairs(arg0_61.ships) do
		local var6_61 = var0_61:getShipById(iter1_61)

		if var6_61 then
			local var7_61 = var6_61:getShipType()
			local var8_61 = var5_61.VAN_SONAR_PROPERTY[var7_61]

			if var8_61 then
				local var9_61 = (var6_61:getShipProperties()[AttributeType.AntiSub] or 0) / var8_61.a - var8_61.b

				var1_61 = math.max(var1_61, Mathf.Clamp(var9_61, var8_61.minRange, var8_61.maxRange))
			end

			if table.contains(ShipType.MainShipType, var7_61) then
				var4_61 = var4_61 + (var6_61:getShipProperties()[AttributeType.AntiSub] or 0)
			end

			for iter2_61, iter3_61 in ipairs(var6_61:getActiveEquipments()) do
				if iter3_61 then
					var3_61 = var3_61 + (iter3_61:getConfig("equip_parameters").range or 0)
				end
			end
		end
	end

	if var1_61 ~= 0 then
		local var10_61 = var5_61.MAIN_SONAR_PROPERTY
		local var11_61 = var4_61 / var10_61.a

		var2_61 = var3_61 + Mathf.Clamp(var11_61, var10_61.minRange, var10_61.maxRange)
	end

	return var1_61 + var2_61
end

function var0_0.getInvestSums(arg0_62)
	local var0_62 = getProxy(BayProxy)

	local function var1_62(arg0_63, arg1_63)
		local var0_63 = var0_62:getShipById(arg1_63):getProperties(arg0_62:getCommanders())

		return arg0_63 + var0_63[AttributeType.Air] + var0_63[AttributeType.Dodge]
	end

	local var2_62 = _.reduce(arg0_62.ships, 0, var1_62)

	return math.pow(var2_62, 0.666666666666667)
end

function var0_0.ExistActNpcShip(arg0_64)
	local var0_64 = getProxy(BayProxy)

	for iter0_64, iter1_64 in ipairs(arg0_64.ships) do
		local var1_64 = var0_64:RawGetShipById(iter1_64)

		if var1_64 and var1_64:isActivityNpc() then
			return true
		end
	end

	return false
end

function var0_0.GetName(arg0_65)
	return noEmptyStr(arg0_65.name) or var0_0.DEFAULT_NAME[arg0_65.id]
end

function var0_0.ChangeToElite(arg0_66)
	local var0_66 = arg0_66:getFleetType()
	local var1_66 = {
		id = arg0_66.id,
		[TeamType.FormShips] = {},
		[TeamType.FormCommander] = {
			0,
			0
		}
	}

	for iter0_66, iter1_66 in ipairs(arg0_66.commanderIds) do
		var1_66[TeamType.FormCommander][iter0_66] = iter1_66
	end

	switch(var0_66, {
		[FleetType.Normal] = function()
			var1_66[TeamType.FormShips] = table.mergeArray(arg0_66.mainShips, arg0_66.vanguardShips)
		end,
		[FleetType.Submarine] = function()
			var1_66[TeamType.FormShips] = underscore.to_array(arg0_66.subShips)
		end,
		[FleetType.Support] = function()
			var1_66[TeamType.FormShips] = underscore.to_array(arg0_66.mainShips)
		end
	})

	return var1_66, var0_66
end

return var0_0
