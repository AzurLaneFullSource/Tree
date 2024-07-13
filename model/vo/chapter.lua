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
	return getProxy(ChapterProxy):getMapById(arg0_13:getConfig("map")):getMapType() == Map.ACT_EXTRA and arg0_13:getPlayType() == ChapterConst.TypeRange
end

function var0_0.getConfig(arg0_14, arg1_14)
	if arg0_14:isLoop() then
		local var0_14 = pg.chapter_template_loop[arg0_14.id]

		assert(var0_14, "chapter_template_loop not exist: " .. arg0_14.id)

		if var0_14[arg1_14] ~= nil and var0_14[arg1_14] ~= "&&" then
			return var0_14[arg1_14]
		end

		if (arg1_14 == "air_dominance" or arg1_14 == "best_air_dominance") and var0_14.air_dominance_loop_rate ~= nil then
			local var1_14 = arg0_14:getConfigTable()
			local var2_14 = var0_14.air_dominance_loop_rate * 0.01

			return math.floor(var1_14[arg1_14] * var2_14)
		end
	end

	return var0_0.super.getConfig(arg0_14, arg1_14)
end

function var0_0.existLoop(arg0_15)
	return pg.chapter_template_loop[arg0_15.id] ~= nil
end

function var0_0.canActivateLoop(arg0_16)
	return arg0_16.progress == 100
end

function var0_0.isLoop(arg0_17)
	return arg0_17.loopFlag == 1
end

function var0_0.existAmbush(arg0_18)
	return arg0_18:getConfig("is_ambush") == 1 or arg0_18:getConfig("is_air_attack") == 1
end

function var0_0.isUnlock(arg0_19)
	return arg0_19:IsCleanPrevChapter() and arg0_19:IsCleanPrevStory()
end

function var0_0.IsCleanPrevChapter(arg0_20)
	local var0_20 = arg0_20:getConfig("pre_chapter")

	if var0_20 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0_20):isClear()
end

function var0_0.IsCleanPrevStory(arg0_21)
	local var0_21 = arg0_21:getConfig("pre_story")

	if var0_21 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0_21):isClear()
end

function var0_0.isPlayerLVUnlock(arg0_22)
	return getProxy(PlayerProxy):getRawData().level >= arg0_22:getConfig("unlocklevel")
end

function var0_0.isClear(arg0_23)
	return arg0_23.progress >= 100
end

function var0_0.ifNeedHide(arg0_24)
	if table.contains(pg.chapter_setting.all, arg0_24.id) and pg.chapter_setting[arg0_24.id].hide == 1 then
		return arg0_24:isClear()
	end
end

function var0_0.existAchieve(arg0_25)
	return #arg0_25.achieves > 0
end

function var0_0.isAllAchieve(arg0_26)
	return _.all(arg0_26.achieves, function(arg0_27)
		return ChapterConst.IsAchieved(arg0_27)
	end)
end

function var0_0.clearEliterFleetByIndex(arg0_28, arg1_28)
	if arg1_28 > #arg0_28.eliteFleetList then
		return
	end

	arg0_28.eliteFleetList[arg1_28] = {}
end

function var0_0.wrapEliteFleet(arg0_29, arg1_29)
	local var0_29 = {}
	local var1_29 = arg1_29 > 2 and FleetType.Submarine or FleetType.Normal
	local var2_29 = _.flatten(arg0_29:getEliteFleetList()[arg1_29])

	for iter0_29, iter1_29 in pairs(arg0_29:getEliteFleetCommanders()[arg1_29]) do
		table.insert(var0_29, {
			pos = iter0_29,
			id = iter1_29
		})
	end

	return TypedFleet.New({
		id = arg1_29,
		fleetType = var1_29,
		ship_list = var2_29,
		commanders = var0_29
	})
end

function var0_0.setEliteCommanders(arg0_30, arg1_30)
	arg0_30.eliteCommanderList = arg1_30
end

function var0_0.getEliteFleetCommanders(arg0_31)
	return arg0_31.eliteCommanderList
end

function var0_0.updateCommander(arg0_32, arg1_32, arg2_32, arg3_32)
	arg0_32.eliteCommanderList[arg1_32][arg2_32] = arg3_32
end

function var0_0.getEliteFleetList(arg0_33)
	arg0_33:EliteShipTypeFilter()

	return arg0_33.eliteFleetList
end

function var0_0.setEliteFleetList(arg0_34, arg1_34)
	arg0_34.eliteFleetList = arg1_34
end

function var0_0.IsEliteFleetLegal(arg0_35)
	local var0_35 = 0
	local var1_35 = 0
	local var2_35 = 0
	local var3_35 = 0
	local var4_35
	local var5_35

	for iter0_35 = 1, #arg0_35.eliteFleetList do
		local var6_35, var7_35 = arg0_35:singleEliteFleetVertify(iter0_35)

		if not var6_35 then
			if not var7_35 then
				if iter0_35 >= 3 then
					var2_35 = var2_35 + 1
				else
					var0_35 = var0_35 + 1
				end
			else
				var4_35 = var7_35
				var5_35 = iter0_35
			end
		elseif iter0_35 >= 3 then
			var3_35 = var3_35 + 1
		else
			var1_35 = var1_35 + 1
		end
	end

	if var0_35 == 2 then
		return false, i18n("elite_disable_no_fleet")
	elseif var1_35 == 0 then
		return false, var4_35
	elseif var2_35 + var3_35 < arg0_35:getConfig("submarine_num") then
		return false, var4_35
	end

	local var8_35 = arg0_35:IsPropertyLimitationSatisfy()
	local var9_35 = 1

	for iter1_35, iter2_35 in ipairs(var8_35) do
		var9_35 = var9_35 * iter2_35
	end

	if var9_35 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true, var5_35
end

function var0_0.IsPropertyLimitationSatisfy(arg0_36)
	local var0_36 = getProxy(BayProxy):getRawData()
	local var1_36 = arg0_36:getConfig("property_limitation")
	local var2_36 = {}

	for iter0_36, iter1_36 in ipairs(var1_36) do
		var2_36[iter1_36[1]] = 0
	end

	local var3_36 = arg0_36:getEliteFleetList()
	local var4_36 = 0

	for iter2_36 = 1, 2 do
		if not arg0_36:singleEliteFleetVertify(iter2_36) then
			-- block empty
		else
			local var5_36 = {}
			local var6_36 = {}

			for iter3_36, iter4_36 in ipairs(var1_36) do
				local var7_36, var8_36, var9_36, var10_36 = unpack(iter4_36)

				if string.sub(var7_36, 1, 5) == "fleet" then
					var5_36[var7_36] = 0
					var6_36[var7_36] = var10_36
				end
			end

			local var11_36 = var3_36[iter2_36]

			for iter5_36, iter6_36 in ipairs(var11_36) do
				local var12_36 = var0_36[iter6_36]

				var4_36 = var4_36 + 1

				local var13_36 = intProperties(var12_36:getProperties())

				for iter7_36, iter8_36 in pairs(var2_36) do
					if string.sub(iter7_36, 1, 5) == "fleet" then
						if iter7_36 == "fleet_totle_level" then
							var5_36[iter7_36] = var5_36[iter7_36] + var12_36.level
						end
					elseif iter7_36 == "level" then
						var2_36[iter7_36] = iter8_36 + var12_36.level
					else
						var2_36[iter7_36] = iter8_36 + var13_36[iter7_36]
					end
				end
			end

			for iter9_36, iter10_36 in pairs(var5_36) do
				if iter9_36 == "fleet_totle_level" and iter10_36 > var6_36[iter9_36] then
					var2_36[iter9_36] = var2_36[iter9_36] + 1
				end
			end
		end
	end

	local var14_36 = {}

	for iter11_36, iter12_36 in ipairs(var1_36) do
		local var15_36, var16_36, var17_36 = unpack(iter12_36)

		if var15_36 == "level" and var4_36 > 0 then
			var2_36[var15_36] = math.ceil(var2_36[var15_36] / var4_36)
		end

		var14_36[iter11_36] = AttributeType.EliteConditionCompare(var16_36, var2_36[var15_36], var17_36) and 1 or 0
	end

	return var14_36, var2_36
end

function var0_0.GetNomralFleetMaxCount(arg0_37)
	return arg0_37:getConfig("group_num")
end

function var0_0.GetSubmarineFleetMaxCount(arg0_38)
	return arg0_38:getConfig("submarine_num")
end

function var0_0.GetSupportFleetMaxCount(arg0_39)
	return arg0_39:getConfig("support_group_num")
end

function var0_0.EliteShipTypeFilter(arg0_40)
	if arg0_40:getConfig("type") == Chapter.SelectFleet then
		local var0_40 = {
			1,
			2,
			3
		}

		for iter0_40, iter1_40 in ipairs(var0_40) do
			table.clear(arg0_40.eliteFleetList[iter1_40])
			table.clear(arg0_40.eliteCommanderList[iter1_40])
		end
	else
		for iter2_40 = arg0_40:GetNomralFleetMaxCount() + 1, 2 do
			table.clear(arg0_40.eliteFleetList[iter2_40])
			table.clear(arg0_40.eliteCommanderList[iter2_40])
		end

		for iter3_40 = arg0_40:GetSubmarineFleetMaxCount() + 2 + 1, 3 do
			table.clear(arg0_40.eliteFleetList[iter3_40])
			table.clear(arg0_40.eliteCommanderList[iter3_40])
		end
	end

	local var1_40 = getProxy(BayProxy):getRawData()

	for iter4_40, iter5_40 in ipairs(arg0_40.eliteFleetList) do
		for iter6_40 = #iter5_40, 1, -1 do
			if var1_40[iter5_40[iter6_40]] == nil then
				table.remove(iter5_40, iter6_40)
			end
		end
	end

	local function var2_40(arg0_41, arg1_41, arg2_41)
		arg1_41 = Clone(arg1_41)

		ChapterProxy.SortRecommendLimitation(arg1_41)

		for iter0_41, iter1_41 in ipairs(arg2_41) do
			local var0_41
			local var1_41 = var1_40[iter1_41]:getShipType()

			for iter2_41, iter3_41 in ipairs(arg1_41) do
				if ShipType.ContainInLimitBundle(iter3_41, var1_41) then
					var0_41 = iter2_41

					break
				end
			end

			if var0_41 then
				table.remove(arg1_41, var0_41)
			else
				table.removebyvalue(arg0_41, iter1_41)
			end
		end
	end

	for iter7_40, iter8_40 in ipairs(arg0_40:getConfig("limitation")) do
		local var3_40 = arg0_40.eliteFleetList[iter7_40]
		local var4_40 = {}
		local var5_40 = {}
		local var6_40 = {}

		for iter9_40, iter10_40 in ipairs(var3_40) do
			local var7_40 = var1_40[iter10_40]:getTeamType()

			if var7_40 == TeamType.Main then
				table.insert(var4_40, iter10_40)
			elseif var7_40 == TeamType.Vanguard then
				table.insert(var5_40, iter10_40)
			elseif var7_40 == TeamType.Submarine then
				table.insert(var6_40, iter10_40)
			end
		end

		var2_40(var3_40, iter8_40[1], var4_40)
		var2_40(var3_40, iter8_40[2], var5_40)
		var2_40(var3_40, {
			0,
			0,
			0
		}, var6_40)
	end
end

function var0_0.singleEliteFleetVertify(arg0_42, arg1_42)
	local var0_42 = getProxy(BayProxy):getRawData()
	local var1_42 = arg0_42:getEliteFleetList()[arg1_42]

	if not var1_42 or #var1_42 == 0 then
		return false
	end

	if arg1_42 >= 3 then
		return true
	end

	if arg0_42:getConfig("type") ~= Chapter.CustomFleet then
		return true
	end

	local var2_42 = 0
	local var3_42 = 0
	local var4_42 = {}

	for iter0_42, iter1_42 in ipairs(var1_42) do
		local var5_42 = var0_42[iter1_42]

		if var5_42 then
			if var5_42:getFlag("inEvent") then
				return false, i18n("elite_disable_ship_escort")
			end

			local var6_42 = var5_42:getTeamType()

			if var6_42 == TeamType.Main then
				var2_42 = var2_42 + 1
			elseif var6_42 == TeamType.Vanguard then
				var3_42 = var3_42 + 1
			end

			var4_42[#var4_42 + 1] = var5_42:getShipType()
		end
	end

	if var2_42 * var3_42 == 0 and var2_42 + var3_42 ~= 0 then
		return false
	end

	local var7_42 = checkExist(arg0_42:getConfig("limitation"), {
		arg1_42
	})
	local var8_42 = 1

	for iter2_42, iter3_42 in ipairs(var7_42 or {}) do
		local var9_42 = 0
		local var10_42 = 0

		for iter4_42, iter5_42 in ipairs(iter3_42) do
			if iter5_42 ~= 0 then
				var9_42 = var9_42 + 1

				if underscore.any(var4_42, function(arg0_43)
					return ShipType.ContainInLimitBundle(iter5_42, arg0_43)
				end) then
					var10_42 = 1

					break
				end
			end
		end

		if var9_42 == 0 then
			var10_42 = 1
		end

		var8_42 = var8_42 * var10_42
	end

	if var8_42 == 0 then
		return false, i18n("elite_disable_formation_unsatisfied")
	end

	return true
end

function var0_0.ClearSupportFleetList(arg0_44, arg1_44)
	arg0_44.supportFleet = {}
end

function var0_0.setSupportFleetList(arg0_45, arg1_45)
	arg0_45.supportFleet = arg1_45[1]
end

function var0_0.getSupportFleet(arg0_46)
	arg0_46:SupportShipTypeFilter()

	return arg0_46.supportFleet
end

function var0_0.SupportShipTypeFilter(arg0_47)
	if arg0_47:GetSupportFleetMaxCount() < 1 then
		table.clear(arg0_47.supportFleet)
	end

	local var0_47 = getProxy(BayProxy):getRawData()
	local var1_47 = arg0_47.supportFleet

	for iter0_47 = #var1_47, 1, -1 do
		if var0_47[var1_47[iter0_47]] == nil then
			table.remove(var1_47, iter0_47)
		end
	end
end

function var0_0.activeAlways(arg0_48)
	if getProxy(ChapterProxy):getMapById(arg0_48:getConfig("map")):isActivity() then
		local var0_48 = arg0_48:GetBindActID()
		local var1_48 = pg.activity_template[var0_48]

		if type(var1_48.config_client) == "table" then
			local var2_48 = var1_48.config_client.prevs or {}

			return table.contains(var2_48, arg0_48.id)
		end
	end

	return false
end

function var0_0.getPrevChapterName(arg0_49)
	local var0_49 = ""
	local var1_49 = arg0_49:getConfig("pre_chapter")

	if var1_49 ~= 0 then
		var0_49 = arg0_49:bindConfigTable()[var1_49].chapter_name
	end

	return var0_49
end

function var0_0.CanQuickPlay(arg0_50)
	local var0_50 = pg.chapter_setting[arg0_50.id]

	return var0_50 and var0_50.expedite > 0
end

function var0_0.GetQuickPlayFlag(arg0_51)
	return PlayerPrefs.GetInt("chapter_quickPlay_flag_" .. arg0_51.id, 0) == 1
end

function var0_0.writeDrops(arg0_52, arg1_52)
	_.each(arg1_52, function(arg0_53)
		if arg0_53.type == DROP_TYPE_SHIP and not table.contains(arg0_52.dropShipIdList, arg0_53.id) then
			table.insert(arg0_52.dropShipIdList, arg0_53.id)
		end
	end)
end

function var0_0.UpdateDropShipList(arg0_54, arg1_54)
	for iter0_54, iter1_54 in ipairs(arg1_54) do
		if not table.contains(arg0_54.dropShipIdList, iter1_54) then
			table.insert(arg0_54.dropShipIdList, iter1_54)
		end
	end
end

function var0_0.GetDropShipList(arg0_55)
	return arg0_55.dropShipIdList
end

function var0_0.getOniChapterInfo(arg0_56)
	return pg.chapter_capture[arg0_56.id]
end

function var0_0.getBombChapterInfo(arg0_57)
	return pg.chapter_boom[arg0_57.id]
end

function var0_0.getNpcShipByType(arg0_58, arg1_58)
	local var0_58 = {}
	local var1_58 = getProxy(TaskProxy)

	local function var2_58(arg0_59)
		if arg0_59 == 0 then
			return true
		end

		local var0_59 = var1_58:getTaskVO(arg0_59)

		return var0_59 and not var0_59:isFinish()
	end

	for iter0_58, iter1_58 in ipairs(arg0_58:getConfig("npc_data")) do
		local var3_58 = pg.npc_squad_template[iter1_58]

		if not arg1_58 or arg1_58 == var3_58.type and var2_58(var3_58.task_id) then
			for iter2_58, iter3_58 in ipairs({
				"vanguard_list",
				"main_list"
			}) do
				for iter4_58, iter5_58 in ipairs(var3_58[iter3_58]) do
					table.insert(var0_58, NpcShip.New({
						id = iter5_58[1],
						configId = iter5_58[1],
						level = iter5_58[2]
					}))
				end
			end
		end
	end

	return var0_58
end

function var0_0.getTodayDefeatCount(arg0_60)
	return getProxy(DailyLevelProxy):getChapterDefeatCount(arg0_60.configId)
end

function var0_0.isTriesLimit(arg0_61)
	local var0_61 = arg0_61:getConfig("count")

	return var0_61 and var0_61 > 0
end

function var0_0.updateTodayDefeatCount(arg0_62)
	getProxy(DailyLevelProxy):updateChapterDefeatCount(arg0_62.configId)
end

function var0_0.enoughTimes2Start(arg0_63)
	if arg0_63:isTriesLimit() then
		return arg0_63:getTodayDefeatCount() < arg0_63:getConfig("count")
	else
		return true
	end
end

function var0_0.GetRestDailyBonus(arg0_64)
	local var0_64 = 0

	if arg0_64:IsRemaster() then
		return var0_64
	end

	local var1_64 = arg0_64:getConfig("boss_expedition_id")

	for iter0_64, iter1_64 in ipairs(var1_64) do
		local var2_64 = pg.expedition_activity_template[iter1_64]

		var0_64 = math.max(var0_64, var2_64 and var2_64.bonus_time or 0)
	end

	local var3_64 = pg.chapter_defense[arg0_64.id]

	if var3_64 then
		var0_64 = math.max(var0_64, var3_64.bonus_time or 0)
	end

	return (math.max(var0_64 - arg0_64.todayDefeatCount, 0))
end

function var0_0.GetDailyBonusQuota(arg0_65)
	return arg0_65:GetRestDailyBonus() > 0
end

var0_0.OPERATION_BUFF_TYPE_COST = "more_oil"
var0_0.OPERATION_BUFF_TYPE_REWARD = "extra_drop"
var0_0.OPERATION_BUFF_TYPE_EXP = "chapter_up"
var0_0.OPERATION_BUFF_TYPE_DESC = "desc"

function var0_0.GetSPOperationItemCacheKey(arg0_66)
	return "specialOPItem_" .. arg0_66
end

function var0_0.GetSpItems(arg0_67)
	local var0_67 = {}
	local var1_67 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)
	local var2_67 = arg0_67:getConfig("special_operation_list")

	if var2_67 and #var2_67 == 0 then
		return var0_67
	end

	for iter0_67, iter1_67 in ipairs(pg.benefit_buff_template.all) do
		local var3_67 = pg.benefit_buff_template[iter1_67]

		if var3_67.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and table.contains(var2_67, var3_67.id) then
			local var4_67 = tonumber(var3_67.benefit_condition)

			for iter2_67, iter3_67 in ipairs(var1_67) do
				if var4_67 == iter3_67.configId then
					table.insert(var0_67, iter3_67)

					break
				end
			end
		end
	end

	return var0_67
end

function var0_0.GetSPBuffByItem(arg0_68)
	for iter0_68, iter1_68 in ipairs(pg.benefit_buff_template.all) do
		buffConfig = pg.benefit_buff_template[iter1_68]

		if buffConfig.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and tonumber(buffConfig.benefit_condition) == arg0_68 then
			return buffConfig.id
		end
	end
end

function var0_0.GetActiveSPItemID(arg0_69)
	local var0_69 = Chapter.GetSPOperationItemCacheKey(arg0_69.id)
	local var1_69 = PlayerPrefs.GetInt(var0_69, 0)

	if var1_69 == 0 then
		return 0
	end

	if arg0_69:GetRestDailyBonus() > 0 then
		return 0
	end

	local var2_69 = arg0_69:GetSpItems()

	if _.detect(var2_69, function(arg0_70)
		return arg0_70:GetConfigID() == var1_69
	end) then
		return var1_69
	end

	return 0
end

function var0_0.GetLimitOilCost(arg0_71, arg1_71, arg2_71)
	if not arg0_71:isLoop() then
		return 9999
	end

	local var0_71
	local var1_71

	if arg1_71 then
		var1_71 = 3
	else
		local var2_71 = pg.expedition_data_template[arg2_71]

		var1_71 = (var2_71.type == ChapterConst.ExpeditionTypeBoss or var2_71.type == ChapterConst.ExpeditionTypeMulBoss) and 2 or 1
	end

	return arg0_71:getConfig("use_oil_limit")[var1_71] or 9999
end

function var0_0.IsRemaster(arg0_72)
	local var0_72 = getProxy(ChapterProxy):getMapById(arg0_72:getConfig("map"))

	return var0_72 and var0_72:isRemaster()
end

function var0_0.GetBindActID(arg0_73)
	return arg0_73:getConfig("act_id")
end

function var0_0.GetMaxBattleCount(arg0_74)
	local var0_74 = 0
	local var1_74 = getProxy(ChapterProxy):getMapById(arg0_74:getConfig("map"))

	if var1_74:getMapType() == Map.ELITE then
		var0_74 = pg.gameset.hard_level_multiple_sorties_times.key_value
		var0_74 = math.clamp(var0_74, 0, getProxy(DailyLevelProxy):GetRestEliteCount())
	elseif var1_74:isRemaster() then
		var0_74 = pg.gameset.archives_level_multiple_sorties_times.key_value
		var0_74 = math.clamp(var0_74, 0, getProxy(ChapterProxy).remasterTickets)
	elseif var1_74:isActivity() then
		var0_74 = pg.gameset.activity_level_multiple_sorties_times.key_value
	else
		var0_74 = pg.gameset.main_level_multiple_sorties_times.key_value
	end

	if arg0_74:isTriesLimit() then
		local var2_74 = arg0_74:getConfig("count") - arg0_74:getTodayDefeatCount()

		var0_74 = math.clamp(var0_74, 0, var2_74)
	end

	return var0_74
end

return var0_0
