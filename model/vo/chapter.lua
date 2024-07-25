local var0_0 = class("Chapter", import(".BaseVO"))

var0_0.SelectFleet = 1
var0_0.CustomFleet = 2
var0_0.CHAPTER_STATE = {
	i18n("level_chapter_state_high_risk"),
	i18n("level_chapter_state_risk"),
	i18n("level_chapter_state_low_risk"),
	i18n("level_chapter_state_safety")
}

function var0_0.bindConfigTable(arg0_1)
	return pg.chapter_template
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.configId = arg1_2.id
	arg0_2.id = arg0_2.configId
	arg0_2.active = false
	arg0_2.progress = defaultValue(arg1_2.progress, 0)
	arg0_2.defeatCount = arg1_2.defeat_count or 0
	arg0_2.passCount = arg1_2.pass_count or 0
	arg0_2.todayDefeatCount = arg1_2.today_defeat_count or 0

	local var0_2 = {
		defaultValue(arg1_2.kill_boss_count, 0),
		defaultValue(arg1_2.kill_enemy_count, 0),
		defaultValue(arg1_2.take_box_count, 0)
	}

	arg0_2.achieves = {}

	for iter0_2 = 1, 3 do
		local var1_2 = arg0_2:getConfig("star_require_" .. iter0_2)

		if var1_2 > 0 then
			table.insert(arg0_2.achieves, {
				type = var1_2,
				config = arg0_2:getConfig("num_" .. iter0_2),
				count = var0_2[iter0_2]
			})
		end
	end

	arg0_2.dropShipIdList = {}
	arg0_2.eliteFleetList = {
		{},
		{},
		{}
	}
	arg0_2.eliteCommanderList = {
		{},
		{},
		{}
	}
	arg0_2.supportFleet = {}
	arg0_2.loopFlag = 0
end

function var0_0.BuildEliteFleetList(arg0_3)
	local var0_3 = {
		{},
		{},
		{}
	}
	local var1_3 = {
		{},
		{},
		{}
	}
	local var2_3 = {
		{}
	}

	for iter0_3, iter1_3 in ipairs(arg0_3 or {}) do
		local var3_3 = {}

		for iter2_3, iter3_3 in ipairs(iter1_3.main_id) do
			var3_3[#var3_3 + 1] = iter3_3
		end

		if iter0_3 == 4 then
			var2_3[1] = var3_3
		else
			var0_3[iter0_3] = var3_3
		end

		local var4_3 = {}

		for iter4_3, iter5_3 in ipairs(iter1_3.commanders) do
			local var5_3 = iter5_3.id
			local var6_3 = iter5_3.pos

			if getProxy(CommanderProxy):getCommanderById(var5_3) and Commander.canEquipToFleetList(var1_3, iter0_3, var6_3, var5_3) then
				var4_3[var6_3] = var5_3
			end
		end

		var1_3[iter0_3] = var4_3
	end

	return var0_3, var1_3, var2_3
end

function var0_0.getMaxCount(arg0_4)
	local var0_4 = arg0_4:getConfig("risk_levels")

	if #var0_4 == 0 then
		return 0
	end

	return var0_4[1][1]
end

function var0_0.hasMitigation(arg0_5)
	if not LOCK_MITIGATION then
		return arg0_5:getConfig("mitigation_level") > 0
	else
		return false
	end
end

function var0_0.getRemainPassCount(arg0_6)
	local var0_6 = arg0_6:getMaxCount()

	return math.max(var0_6 - arg0_6.passCount, 0)
end

function var0_0.getRiskLevel(arg0_7)
	local var0_7 = arg0_7:getRemainPassCount()
	local var1_7 = arg0_7:getConfig("risk_levels")

	for iter0_7, iter1_7 in ipairs(var1_7) do
		if var0_7 <= iter1_7[1] and var0_7 >= iter1_7[2] then
			return iter0_7
		end
	end

	assert(false, "index can not be nil")
end

function var0_0.getMitigationRate(arg0_8)
	local var0_8 = arg0_8:getMaxCount()
	local var1_8 = LOCK_MITIGATION and 0 or arg0_8:getConfig("mitigation_rate")

	return math.min(arg0_8.passCount, var0_8) * var1_8
end

function var0_0.getRepressInfo(arg0_9)
	return {
		repressMax = arg0_9:getMaxCount(),
		repressCount = arg0_9.passCount,
		repressReduce = arg0_9:getMitigationRate(),
		repressLevel = LOCK_MITIGATION and 0 or arg0_9:getRemainPassCount() > 0 and 0 or arg0_9:getConfig("mitigation_level") or 0,
		repressEnemyHpRant = 1 - arg0_9:getStageCell(arg0_9.fleet.line.row, arg0_9.fleet.line.column).data / 10000
	}
end

function var0_0.getChapterState(arg0_10)
	local var0_10 = arg0_10:getRiskLevel()

	assert(var0_0.CHAPTER_STATE[var0_10], "state desc is nil")

	return var0_0.CHAPTER_STATE[var0_10]
end

function var0_0.getPlayType(arg0_11)
	return arg0_11:getConfig("model")
end

function var0_0.isTypeDefence(arg0_12)
	return arg0_12:getPlayType() == ChapterConst.TypeDefence
end

function var0_0.IsSpChapter(arg0_13)
	return arg0_13:isTriesLimit()
end

function var0_0.IsEXChapter(arg0_14)
	return arg0_14:getPlayType() == ChapterConst.TypeExtra
end

function var0_0.getConfig(arg0_15, arg1_15)
	if arg0_15:isLoop() then
		local var0_15 = pg.chapter_template_loop[arg0_15.id]

		assert(var0_15, "chapter_template_loop not exist: " .. arg0_15.id)

		if var0_15[arg1_15] ~= nil and var0_15[arg1_15] ~= "&&" then
			return var0_15[arg1_15]
		end

		if (arg1_15 == "air_dominance" or arg1_15 == "best_air_dominance") and var0_15.air_dominance_loop_rate ~= nil then
			local var1_15 = arg0_15:getConfigTable()
			local var2_15 = var0_15.air_dominance_loop_rate * 0.01

			return math.floor(var1_15[arg1_15] * var2_15)
		end
	end

	return var0_0.super.getConfig(arg0_15, arg1_15)
end

function var0_0.existLoop(arg0_16)
	return pg.chapter_template_loop[arg0_16.id] ~= nil
end

function var0_0.canActivateLoop(arg0_17)
	return arg0_17.progress == 100
end

function var0_0.isLoop(arg0_18)
	return arg0_18.loopFlag == 1
end

function var0_0.existAmbush(arg0_19)
	return arg0_19:getConfig("is_ambush") == 1 or arg0_19:getConfig("is_air_attack") == 1
end

function var0_0.isUnlock(arg0_20)
	return arg0_20:IsCleanPrevChapter() and arg0_20:IsCleanPrevStory()
end

function var0_0.IsCleanPrevChapter(arg0_21)
	for iter0_21, iter1_21 in ipairs(arg0_21:getConfig("pre_chapter")) do
		if _.all(iter1_21, function(arg0_22)
			if arg0_22 == 0 then
				return true
			end

			return getProxy(ChapterProxy):GetChapterItemById(arg0_22):isClear()
		end) then
			return true
		end
	end

	return false
end

function var0_0.IsCleanPrevStory(arg0_23)
	local var0_23 = arg0_23:getConfig("pre_story")

	if var0_23 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0_23):isClear()
end

function var0_0.isPlayerLVUnlock(arg0_24)
	return getProxy(PlayerProxy):getRawData().level >= arg0_24:getConfig("unlocklevel")
end

function var0_0.isClear(arg0_25)
	return arg0_25.progress >= 100
end

function var0_0.ifNeedHide(arg0_26)
	if table.contains(pg.chapter_setting.all, arg0_26.id) and pg.chapter_setting[arg0_26.id].hide == 1 then
		return arg0_26:isClear()
	end
end

function var0_0.existAchieve(arg0_27)
	return #arg0_27.achieves > 0
end

function var0_0.isAllAchieve(arg0_28)
	return _.all(arg0_28.achieves, function(arg0_29)
		return ChapterConst.IsAchieved(arg0_29)
	end)
end

function var0_0.clearEliterFleetByIndex(arg0_30, arg1_30)
	if arg1_30 > #arg0_30.eliteFleetList then
		return
	end

	arg0_30.eliteFleetList[arg1_30] = {}
end

function var0_0.wrapEliteFleet(arg0_31, arg1_31)
	local var0_31 = {}
	local var1_31 = arg1_31 > 2 and FleetType.Submarine or FleetType.Normal
	local var2_31 = _.flatten(arg0_31:getEliteFleetList()[arg1_31])

	for iter0_31, iter1_31 in pairs(arg0_31:getEliteFleetCommanders()[arg1_31]) do
		table.insert(var0_31, {
			pos = iter0_31,
			id = iter1_31
		})
	end

	return TypedFleet.New({
		id = arg1_31,
		fleetType = var1_31,
		ship_list = var2_31,
		commanders = var0_31
	})
end

function var0_0.setEliteCommanders(arg0_32, arg1_32)
	arg0_32.eliteCommanderList = arg1_32
end

function var0_0.getEliteFleetCommanders(arg0_33)
	return arg0_33.eliteCommanderList
end

function var0_0.updateCommander(arg0_34, arg1_34, arg2_34, arg3_34)
	arg0_34.eliteCommanderList[arg1_34][arg2_34] = arg3_34
end

function var0_0.getEliteFleetList(arg0_35)
	arg0_35:EliteShipTypeFilter()

	return arg0_35.eliteFleetList
end

function var0_0.setEliteFleetList(arg0_36, arg1_36)
	arg0_36.eliteFleetList = arg1_36
end

function var0_0.IsEliteFleetLegal(arg0_37)
	local var0_37 = 0
	local var1_37 = 0
	local var2_37 = 0
	local var3_37 = 0
	local var4_37
	local var5_37

	for iter0_37 = 1, #arg0_37.eliteFleetList do
		local var6_37, var7_37 = arg0_37:singleEliteFleetVertify(iter0_37)

		if not var6_37 then
			if not var7_37 then
				if iter0_37 >= 3 then
					var2_37 = var2_37 + 1
				else
					var0_37 = var0_37 + 1
				end
			else
				var4_37 = var7_37
				var5_37 = iter0_37
			end
		elseif iter0_37 >= 3 then
			var3_37 = var3_37 + 1
		else
			var1_37 = var1_37 + 1
		end
	end

	if var0_37 == 2 then
		return false, i18n("elite_disable_no_fleet")
	elseif var1_37 == 0 then
		return false, var4_37
	elseif var2_37 + var3_37 < arg0_37:getConfig("submarine_num") then
		return false, var4_37
	end

	local var8_37 = arg0_37:IsPropertyLimitationSatisfy()
	local var9_37 = 1

	for iter1_37, iter2_37 in ipairs(var8_37) do
		var9_37 = var9_37 * iter2_37
	end

	if var9_37 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true, var5_37
end

function var0_0.IsPropertyLimitationSatisfy(arg0_38)
	local var0_38 = getProxy(BayProxy):getRawData()
	local var1_38 = arg0_38:getConfig("property_limitation")
	local var2_38 = {}

	for iter0_38, iter1_38 in ipairs(var1_38) do
		var2_38[iter1_38[1]] = 0
	end

	local var3_38 = arg0_38:getEliteFleetList()
	local var4_38 = 0

	for iter2_38 = 1, 2 do
		if not arg0_38:singleEliteFleetVertify(iter2_38) then
			-- block empty
		else
			local var5_38 = {}
			local var6_38 = {}

			for iter3_38, iter4_38 in ipairs(var1_38) do
				local var7_38, var8_38, var9_38, var10_38 = unpack(iter4_38)

				if string.sub(var7_38, 1, 5) == "fleet" then
					var5_38[var7_38] = 0
					var6_38[var7_38] = var10_38
				end
			end

			local var11_38 = var3_38[iter2_38]

			for iter5_38, iter6_38 in ipairs(var11_38) do
				local var12_38 = var0_38[iter6_38]

				var4_38 = var4_38 + 1

				local var13_38 = intProperties(var12_38:getProperties())

				for iter7_38, iter8_38 in pairs(var2_38) do
					if string.sub(iter7_38, 1, 5) == "fleet" then
						if iter7_38 == "fleet_totle_level" then
							var5_38[iter7_38] = var5_38[iter7_38] + var12_38.level
						end
					elseif iter7_38 == "level" then
						var2_38[iter7_38] = iter8_38 + var12_38.level
					else
						var2_38[iter7_38] = iter8_38 + var13_38[iter7_38]
					end
				end
			end

			for iter9_38, iter10_38 in pairs(var5_38) do
				if iter9_38 == "fleet_totle_level" and iter10_38 > var6_38[iter9_38] then
					var2_38[iter9_38] = var2_38[iter9_38] + 1
				end
			end
		end
	end

	local var14_38 = {}

	for iter11_38, iter12_38 in ipairs(var1_38) do
		local var15_38, var16_38, var17_38 = unpack(iter12_38)

		if var15_38 == "level" and var4_38 > 0 then
			var2_38[var15_38] = math.ceil(var2_38[var15_38] / var4_38)
		end

		var14_38[iter11_38] = AttributeType.EliteConditionCompare(var16_38, var2_38[var15_38], var17_38) and 1 or 0
	end

	return var14_38, var2_38
end

function var0_0.GetNomralFleetMaxCount(arg0_39)
	return arg0_39:getConfig("group_num")
end

function var0_0.GetSubmarineFleetMaxCount(arg0_40)
	return arg0_40:getConfig("submarine_num")
end

function var0_0.GetSupportFleetMaxCount(arg0_41)
	return arg0_41:getConfig("support_group_num")
end

function var0_0.EliteShipTypeFilter(arg0_42)
	if arg0_42:getConfig("type") == Chapter.SelectFleet then
		local var0_42 = {
			1,
			2,
			3
		}

		for iter0_42, iter1_42 in ipairs(var0_42) do
			table.clear(arg0_42.eliteFleetList[iter1_42])
			table.clear(arg0_42.eliteCommanderList[iter1_42])
		end
	else
		for iter2_42 = arg0_42:GetNomralFleetMaxCount() + 1, 2 do
			table.clear(arg0_42.eliteFleetList[iter2_42])
			table.clear(arg0_42.eliteCommanderList[iter2_42])
		end

		for iter3_42 = arg0_42:GetSubmarineFleetMaxCount() + 2 + 1, 3 do
			table.clear(arg0_42.eliteFleetList[iter3_42])
			table.clear(arg0_42.eliteCommanderList[iter3_42])
		end
	end

	local var1_42 = getProxy(BayProxy):getRawData()

	for iter4_42, iter5_42 in ipairs(arg0_42.eliteFleetList) do
		for iter6_42 = #iter5_42, 1, -1 do
			if var1_42[iter5_42[iter6_42]] == nil then
				table.remove(iter5_42, iter6_42)
			end
		end
	end

	local function var2_42(arg0_43, arg1_43, arg2_43)
		arg1_43 = Clone(arg1_43)

		ChapterProxy.SortRecommendLimitation(arg1_43)

		for iter0_43, iter1_43 in ipairs(arg2_43) do
			local var0_43
			local var1_43 = var1_42[iter1_43]:getShipType()

			for iter2_43, iter3_43 in ipairs(arg1_43) do
				if ShipType.ContainInLimitBundle(iter3_43, var1_43) then
					var0_43 = iter2_43

					break
				end
			end

			if var0_43 then
				table.remove(arg1_43, var0_43)
			else
				table.removebyvalue(arg0_43, iter1_43)
			end
		end
	end

	for iter7_42, iter8_42 in ipairs(arg0_42:getConfig("limitation")) do
		local var3_42 = arg0_42.eliteFleetList[iter7_42]
		local var4_42 = {}
		local var5_42 = {}
		local var6_42 = {}

		for iter9_42, iter10_42 in ipairs(var3_42) do
			local var7_42 = var1_42[iter10_42]:getTeamType()

			if var7_42 == TeamType.Main then
				table.insert(var4_42, iter10_42)
			elseif var7_42 == TeamType.Vanguard then
				table.insert(var5_42, iter10_42)
			elseif var7_42 == TeamType.Submarine then
				table.insert(var6_42, iter10_42)
			end
		end

		var2_42(var3_42, iter8_42[1], var4_42)
		var2_42(var3_42, iter8_42[2], var5_42)
		var2_42(var3_42, {
			0,
			0,
			0
		}, var6_42)
	end
end

function var0_0.singleEliteFleetVertify(arg0_44, arg1_44)
	local var0_44 = getProxy(BayProxy):getRawData()
	local var1_44 = arg0_44:getEliteFleetList()[arg1_44]

	if not var1_44 or #var1_44 == 0 then
		return false
	end

	if arg1_44 >= 3 then
		return true
	end

	if arg0_44:getConfig("type") ~= Chapter.CustomFleet then
		return true
	end

	local var2_44 = 0
	local var3_44 = 0
	local var4_44 = {}

	for iter0_44, iter1_44 in ipairs(var1_44) do
		local var5_44 = var0_44[iter1_44]

		if var5_44 then
			if var5_44:getFlag("inEvent") then
				return false, i18n("elite_disable_ship_escort")
			end

			local var6_44 = var5_44:getTeamType()

			if var6_44 == TeamType.Main then
				var2_44 = var2_44 + 1
			elseif var6_44 == TeamType.Vanguard then
				var3_44 = var3_44 + 1
			end

			var4_44[#var4_44 + 1] = var5_44:getShipType()
		end
	end

	if var2_44 * var3_44 == 0 and var2_44 + var3_44 ~= 0 then
		return false
	end

	local var7_44 = checkExist(arg0_44:getConfig("limitation"), {
		arg1_44
	})
	local var8_44 = 1

	for iter2_44, iter3_44 in ipairs(var7_44 or {}) do
		local var9_44 = 0
		local var10_44 = 0

		for iter4_44, iter5_44 in ipairs(iter3_44) do
			if iter5_44 ~= 0 then
				var9_44 = var9_44 + 1

				if underscore.any(var4_44, function(arg0_45)
					return ShipType.ContainInLimitBundle(iter5_44, arg0_45)
				end) then
					var10_44 = 1

					break
				end
			end
		end

		if var9_44 == 0 then
			var10_44 = 1
		end

		var8_44 = var8_44 * var10_44
	end

	if var8_44 == 0 then
		return false, i18n("elite_disable_formation_unsatisfied")
	end

	return true
end

function var0_0.ClearSupportFleetList(arg0_46, arg1_46)
	arg0_46.supportFleet = {}
end

function var0_0.setSupportFleetList(arg0_47, arg1_47)
	arg0_47.supportFleet = arg1_47[1]
end

function var0_0.getSupportFleet(arg0_48)
	arg0_48:SupportShipTypeFilter()

	return arg0_48.supportFleet
end

function var0_0.SupportShipTypeFilter(arg0_49)
	if arg0_49:GetSupportFleetMaxCount() < 1 then
		table.clear(arg0_49.supportFleet)
	end

	local var0_49 = getProxy(BayProxy):getRawData()
	local var1_49 = arg0_49.supportFleet

	for iter0_49 = #var1_49, 1, -1 do
		if var0_49[var1_49[iter0_49]] == nil then
			table.remove(var1_49, iter0_49)
		end
	end
end

function var0_0.activeAlways(arg0_50)
	if getProxy(ChapterProxy):getMapById(arg0_50:getConfig("map")):isActivity() then
		local var0_50 = arg0_50:GetBindActID()
		local var1_50 = pg.activity_template[var0_50]

		if type(var1_50.config_client) == "table" then
			local var2_50 = var1_50.config_client.prevs or {}

			return table.contains(var2_50, arg0_50.id)
		end
	end

	return false
end

function var0_0.GetPrevChapterNames(arg0_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in ipairs(arg0_51:getConfig("pre_chapter")) do
		local var1_51 = iter1_51[1]

		if var1_51 ~= 0 then
			local var2_51 = arg0_51:bindConfigTable()[var1_51].chapter_name

			table.insert(var0_51, var2_51)
		end
	end

	return var0_51
end

function var0_0.CanQuickPlay(arg0_52)
	local var0_52 = pg.chapter_setting[arg0_52.id]

	return var0_52 and var0_52.expedite > 0
end

function var0_0.GetQuickPlayFlag(arg0_53)
	return PlayerPrefs.GetInt("chapter_quickPlay_flag_" .. arg0_53.id, 0) == 1
end

function var0_0.writeDrops(arg0_54, arg1_54)
	_.each(arg1_54, function(arg0_55)
		if arg0_55.type == DROP_TYPE_SHIP and not table.contains(arg0_54.dropShipIdList, arg0_55.id) then
			table.insert(arg0_54.dropShipIdList, arg0_55.id)
		end
	end)
end

function var0_0.UpdateDropShipList(arg0_56, arg1_56)
	for iter0_56, iter1_56 in ipairs(arg1_56) do
		if not table.contains(arg0_56.dropShipIdList, iter1_56) then
			table.insert(arg0_56.dropShipIdList, iter1_56)
		end
	end
end

function var0_0.GetDropShipList(arg0_57)
	return arg0_57.dropShipIdList
end

function var0_0.getOniChapterInfo(arg0_58)
	return pg.chapter_capture[arg0_58.id]
end

function var0_0.getBombChapterInfo(arg0_59)
	return pg.chapter_boom[arg0_59.id]
end

function var0_0.getNpcShipByType(arg0_60, arg1_60)
	local var0_60 = {}
	local var1_60 = getProxy(TaskProxy)

	local function var2_60(arg0_61)
		if arg0_61 == 0 then
			return true
		end

		local var0_61 = var1_60:getTaskVO(arg0_61)

		return var0_61 and not var0_61:isFinish()
	end

	for iter0_60, iter1_60 in ipairs(arg0_60:getConfig("npc_data")) do
		local var3_60 = pg.npc_squad_template[iter1_60]

		if not arg1_60 or arg1_60 == var3_60.type and var2_60(var3_60.task_id) then
			for iter2_60, iter3_60 in ipairs({
				"vanguard_list",
				"main_list"
			}) do
				for iter4_60, iter5_60 in ipairs(var3_60[iter3_60]) do
					table.insert(var0_60, NpcShip.New({
						id = iter5_60[1],
						configId = iter5_60[1],
						level = iter5_60[2]
					}))
				end
			end
		end
	end

	return var0_60
end

function var0_0.getTodayDefeatCount(arg0_62)
	return getProxy(DailyLevelProxy):getChapterDefeatCount(arg0_62.configId)
end

function var0_0.isTriesLimit(arg0_63)
	local var0_63 = arg0_63:getConfig("count")

	return var0_63 and var0_63 > 0
end

function var0_0.updateTodayDefeatCount(arg0_64)
	getProxy(DailyLevelProxy):updateChapterDefeatCount(arg0_64.configId)
end

function var0_0.enoughTimes2Start(arg0_65)
	if arg0_65:isTriesLimit() then
		return arg0_65:getTodayDefeatCount() < arg0_65:getConfig("count")
	else
		return true
	end
end

function var0_0.GetRestDailyBonus(arg0_66)
	local var0_66 = 0

	if arg0_66:IsRemaster() then
		return var0_66
	end

	local var1_66 = arg0_66:getConfig("boss_expedition_id")

	for iter0_66, iter1_66 in ipairs(var1_66) do
		local var2_66 = pg.expedition_activity_template[iter1_66]

		var0_66 = math.max(var0_66, var2_66 and var2_66.bonus_time or 0)
	end

	local var3_66 = pg.chapter_defense[arg0_66.id]

	if var3_66 then
		var0_66 = math.max(var0_66, var3_66.bonus_time or 0)
	end

	return (math.max(var0_66 - arg0_66.todayDefeatCount, 0))
end

function var0_0.GetDailyBonusQuota(arg0_67)
	return arg0_67:GetRestDailyBonus() > 0
end

var0_0.OPERATION_BUFF_TYPE_COST = "more_oil"
var0_0.OPERATION_BUFF_TYPE_REWARD = "extra_drop"
var0_0.OPERATION_BUFF_TYPE_EXP = "chapter_up"
var0_0.OPERATION_BUFF_TYPE_DESC = "desc"

function var0_0.GetSPOperationItemCacheKey(arg0_68)
	return "specialOPItem_" .. arg0_68
end

function var0_0.GetSpItems(arg0_69)
	local var0_69 = {}
	local var1_69 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)
	local var2_69 = arg0_69:getConfig("special_operation_list")

	if var2_69 and #var2_69 == 0 then
		return var0_69
	end

	for iter0_69, iter1_69 in ipairs(pg.benefit_buff_template.all) do
		local var3_69 = pg.benefit_buff_template[iter1_69]

		if var3_69.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and table.contains(var2_69, var3_69.id) then
			local var4_69 = tonumber(var3_69.benefit_condition)

			for iter2_69, iter3_69 in ipairs(var1_69) do
				if var4_69 == iter3_69.configId then
					table.insert(var0_69, iter3_69)

					break
				end
			end
		end
	end

	return var0_69
end

function var0_0.GetSPBuffByItem(arg0_70)
	for iter0_70, iter1_70 in ipairs(pg.benefit_buff_template.all) do
		buffConfig = pg.benefit_buff_template[iter1_70]

		if buffConfig.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and tonumber(buffConfig.benefit_condition) == arg0_70 then
			return buffConfig.id
		end
	end
end

function var0_0.GetActiveSPItemID(arg0_71)
	local var0_71 = Chapter.GetSPOperationItemCacheKey(arg0_71.id)
	local var1_71 = PlayerPrefs.GetInt(var0_71, 0)

	if var1_71 == 0 then
		return 0
	end

	if arg0_71:GetRestDailyBonus() > 0 then
		return 0
	end

	local var2_71 = arg0_71:GetSpItems()

	if _.detect(var2_71, function(arg0_72)
		return arg0_72:GetConfigID() == var1_71
	end) then
		return var1_71
	end

	return 0
end

function var0_0.GetLimitOilCost(arg0_73, arg1_73, arg2_73)
	if not arg0_73:isLoop() then
		return 9999
	end

	local var0_73
	local var1_73

	if arg1_73 then
		var1_73 = 3
	else
		local var2_73 = pg.expedition_data_template[arg2_73]

		var1_73 = (var2_73.type == ChapterConst.ExpeditionTypeBoss or var2_73.type == ChapterConst.ExpeditionTypeMulBoss) and 2 or 1
	end

	return arg0_73:getConfig("use_oil_limit")[var1_73] or 9999
end

function var0_0.IsRemaster(arg0_74)
	local var0_74 = getProxy(ChapterProxy):getMapById(arg0_74:getConfig("map"))

	return var0_74 and var0_74:isRemaster()
end

function var0_0.GetBindActID(arg0_75)
	return arg0_75:getConfig("act_id")
end

function var0_0.GetMaxBattleCount(arg0_76)
	local var0_76 = 0
	local var1_76 = getProxy(ChapterProxy):getMapById(arg0_76:getConfig("map"))

	if var1_76:getMapType() == Map.ELITE then
		var0_76 = pg.gameset.hard_level_multiple_sorties_times.key_value
		var0_76 = math.clamp(var0_76, 0, getProxy(DailyLevelProxy):GetRestEliteCount())
	elseif var1_76:isRemaster() then
		var0_76 = pg.gameset.archives_level_multiple_sorties_times.key_value
		var0_76 = math.clamp(var0_76, 0, getProxy(ChapterProxy).remasterTickets)
	elseif var1_76:isActivity() then
		var0_76 = pg.gameset.activity_level_multiple_sorties_times.key_value
	else
		var0_76 = pg.gameset.main_level_multiple_sorties_times.key_value
	end

	if arg0_76:isTriesLimit() then
		local var2_76 = arg0_76:getConfig("count") - arg0_76:getTodayDefeatCount()

		var0_76 = math.clamp(var0_76, 0, var2_76)
	end

	return var0_76
end

return var0_0
