local var0 = class("Chapter", import(".BaseVO"))

var0.SelectFleet = 1
var0.CustomFleet = 2
var0.CHAPTER_STATE = {
	i18n("level_chapter_state_high_risk"),
	i18n("level_chapter_state_risk"),
	i18n("level_chapter_state_low_risk"),
	i18n("level_chapter_state_safety")
}

function var0.bindConfigTable(arg0)
	return pg.chapter_template
end

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.id = arg0.configId
	arg0.active = false
	arg0.progress = defaultValue(arg1.progress, 0)
	arg0.defeatCount = arg1.defeat_count or 0
	arg0.passCount = arg1.pass_count or 0
	arg0.todayDefeatCount = arg1.today_defeat_count or 0

	local var0 = {
		defaultValue(arg1.kill_boss_count, 0),
		defaultValue(arg1.kill_enemy_count, 0),
		defaultValue(arg1.take_box_count, 0)
	}

	arg0.achieves = {}

	for iter0 = 1, 3 do
		local var1 = arg0:getConfig("star_require_" .. iter0)

		if var1 > 0 then
			table.insert(arg0.achieves, {
				type = var1,
				config = arg0:getConfig("num_" .. iter0),
				count = var0[iter0]
			})
		end
	end

	arg0.dropShipIdList = {}
	arg0.eliteFleetList = {
		{},
		{},
		{}
	}
	arg0.eliteCommanderList = {
		{},
		{},
		{}
	}
	arg0.supportFleet = {}
	arg0.loopFlag = 0
end

function var0.BuildEliteFleetList(arg0)
	local var0 = {
		{},
		{},
		{}
	}
	local var1 = {
		{},
		{},
		{}
	}
	local var2 = {
		{}
	}

	for iter0, iter1 in ipairs(arg0 or {}) do
		local var3 = {}

		for iter2, iter3 in ipairs(iter1.main_id) do
			var3[#var3 + 1] = iter3
		end

		if iter0 == 4 then
			var2[1] = var3
		else
			var0[iter0] = var3
		end

		local var4 = {}

		for iter4, iter5 in ipairs(iter1.commanders) do
			local var5 = iter5.id
			local var6 = iter5.pos

			if getProxy(CommanderProxy):getCommanderById(var5) and Commander.canEquipToFleetList(var1, iter0, var6, var5) then
				var4[var6] = var5
			end
		end

		var1[iter0] = var4
	end

	return var0, var1, var2
end

function var0.getMaxCount(arg0)
	local var0 = arg0:getConfig("risk_levels")

	if #var0 == 0 then
		return 0
	end

	return var0[1][1]
end

function var0.hasMitigation(arg0)
	if not LOCK_MITIGATION then
		return arg0:getConfig("mitigation_level") > 0
	else
		return false
	end
end

function var0.getRemainPassCount(arg0)
	local var0 = arg0:getMaxCount()

	return math.max(var0 - arg0.passCount, 0)
end

function var0.getRiskLevel(arg0)
	local var0 = arg0:getRemainPassCount()
	local var1 = arg0:getConfig("risk_levels")

	for iter0, iter1 in ipairs(var1) do
		if var0 <= iter1[1] and var0 >= iter1[2] then
			return iter0
		end
	end

	assert(false, "index can not be nil")
end

function var0.getMitigationRate(arg0)
	local var0 = arg0:getMaxCount()
	local var1 = LOCK_MITIGATION and 0 or arg0:getConfig("mitigation_rate")

	return math.min(arg0.passCount, var0) * var1
end

function var0.getRepressInfo(arg0)
	return {
		repressMax = arg0:getMaxCount(),
		repressCount = arg0.passCount,
		repressReduce = arg0:getMitigationRate(),
		repressLevel = LOCK_MITIGATION and 0 or arg0:getRemainPassCount() > 0 and 0 or arg0:getConfig("mitigation_level") or 0,
		repressEnemyHpRant = 1 - arg0:getStageCell(arg0.fleet.line.row, arg0.fleet.line.column).data / 10000
	}
end

function var0.getChapterState(arg0)
	local var0 = arg0:getRiskLevel()

	assert(var0.CHAPTER_STATE[var0], "state desc is nil")

	return var0.CHAPTER_STATE[var0]
end

function var0.getPlayType(arg0)
	return arg0:getConfig("model")
end

function var0.isTypeDefence(arg0)
	return arg0:getPlayType() == ChapterConst.TypeDefence
end

function var0.IsSpChapter(arg0)
	return getProxy(ChapterProxy):getMapById(arg0:getConfig("map")):getMapType() == Map.ACT_EXTRA and arg0:getPlayType() == ChapterConst.TypeRange
end

function var0.getConfig(arg0, arg1)
	if arg0:isLoop() then
		local var0 = pg.chapter_template_loop[arg0.id]

		assert(var0, "chapter_template_loop not exist: " .. arg0.id)

		if var0[arg1] ~= nil and var0[arg1] ~= "&&" then
			return var0[arg1]
		end

		if (arg1 == "air_dominance" or arg1 == "best_air_dominance") and var0.air_dominance_loop_rate ~= nil then
			local var1 = arg0:getConfigTable()
			local var2 = var0.air_dominance_loop_rate * 0.01

			return math.floor(var1[arg1] * var2)
		end
	end

	return var0.super.getConfig(arg0, arg1)
end

function var0.existLoop(arg0)
	return pg.chapter_template_loop[arg0.id] ~= nil
end

function var0.canActivateLoop(arg0)
	return arg0.progress == 100
end

function var0.isLoop(arg0)
	return arg0.loopFlag == 1
end

function var0.existAmbush(arg0)
	return arg0:getConfig("is_ambush") == 1 or arg0:getConfig("is_air_attack") == 1
end

function var0.isUnlock(arg0)
	return arg0:IsCleanPrevChapter() and arg0:IsCleanPrevStory()
end

function var0.IsCleanPrevChapter(arg0)
	local var0 = arg0:getConfig("pre_chapter")

	if var0 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0):isClear()
end

function var0.IsCleanPrevStory(arg0)
	local var0 = arg0:getConfig("pre_story")

	if var0 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0):isClear()
end

function var0.isPlayerLVUnlock(arg0)
	return getProxy(PlayerProxy):getRawData().level >= arg0:getConfig("unlocklevel")
end

function var0.isClear(arg0)
	return arg0.progress >= 100
end

function var0.ifNeedHide(arg0)
	if table.contains(pg.chapter_setting.all, arg0.id) and pg.chapter_setting[arg0.id].hide == 1 then
		return arg0:isClear()
	end
end

function var0.existAchieve(arg0)
	return #arg0.achieves > 0
end

function var0.isAllAchieve(arg0)
	return _.all(arg0.achieves, function(arg0)
		return ChapterConst.IsAchieved(arg0)
	end)
end

function var0.clearEliterFleetByIndex(arg0, arg1)
	if arg1 > #arg0.eliteFleetList then
		return
	end

	arg0.eliteFleetList[arg1] = {}
end

function var0.wrapEliteFleet(arg0, arg1)
	local var0 = {}
	local var1 = arg1 > 2 and FleetType.Submarine or FleetType.Normal
	local var2 = _.flatten(arg0:getEliteFleetList()[arg1])

	for iter0, iter1 in pairs(arg0:getEliteFleetCommanders()[arg1]) do
		table.insert(var0, {
			pos = iter0,
			id = iter1
		})
	end

	return TypedFleet.New({
		id = arg1,
		fleetType = var1,
		ship_list = var2,
		commanders = var0
	})
end

function var0.setEliteCommanders(arg0, arg1)
	arg0.eliteCommanderList = arg1
end

function var0.getEliteFleetCommanders(arg0)
	return arg0.eliteCommanderList
end

function var0.updateCommander(arg0, arg1, arg2, arg3)
	arg0.eliteCommanderList[arg1][arg2] = arg3
end

function var0.getEliteFleetList(arg0)
	arg0:EliteShipTypeFilter()

	return arg0.eliteFleetList
end

function var0.setEliteFleetList(arg0, arg1)
	arg0.eliteFleetList = arg1
end

function var0.IsEliteFleetLegal(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4
	local var5

	for iter0 = 1, #arg0.eliteFleetList do
		local var6, var7 = arg0:singleEliteFleetVertify(iter0)

		if not var6 then
			if not var7 then
				if iter0 >= 3 then
					var2 = var2 + 1
				else
					var0 = var0 + 1
				end
			else
				var4 = var7
				var5 = iter0
			end
		elseif iter0 >= 3 then
			var3 = var3 + 1
		else
			var1 = var1 + 1
		end
	end

	if var0 == 2 then
		return false, i18n("elite_disable_no_fleet")
	elseif var1 == 0 then
		return false, var4
	elseif var2 + var3 < arg0:getConfig("submarine_num") then
		return false, var4
	end

	local var8 = arg0:IsPropertyLimitationSatisfy()
	local var9 = 1

	for iter1, iter2 in ipairs(var8) do
		var9 = var9 * iter2
	end

	if var9 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true, var5
end

function var0.IsPropertyLimitationSatisfy(arg0)
	local var0 = getProxy(BayProxy):getRawData()
	local var1 = arg0:getConfig("property_limitation")
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		var2[iter1[1]] = 0
	end

	local var3 = arg0:getEliteFleetList()
	local var4 = 0

	for iter2 = 1, 2 do
		if not arg0:singleEliteFleetVertify(iter2) then
			-- block empty
		else
			local var5 = {}
			local var6 = {}

			for iter3, iter4 in ipairs(var1) do
				local var7, var8, var9, var10 = unpack(iter4)

				if string.sub(var7, 1, 5) == "fleet" then
					var5[var7] = 0
					var6[var7] = var10
				end
			end

			local var11 = var3[iter2]

			for iter5, iter6 in ipairs(var11) do
				local var12 = var0[iter6]

				var4 = var4 + 1

				local var13 = intProperties(var12:getProperties())

				for iter7, iter8 in pairs(var2) do
					if string.sub(iter7, 1, 5) == "fleet" then
						if iter7 == "fleet_totle_level" then
							var5[iter7] = var5[iter7] + var12.level
						end
					elseif iter7 == "level" then
						var2[iter7] = iter8 + var12.level
					else
						var2[iter7] = iter8 + var13[iter7]
					end
				end
			end

			for iter9, iter10 in pairs(var5) do
				if iter9 == "fleet_totle_level" and iter10 > var6[iter9] then
					var2[iter9] = var2[iter9] + 1
				end
			end
		end
	end

	local var14 = {}

	for iter11, iter12 in ipairs(var1) do
		local var15, var16, var17 = unpack(iter12)

		if var15 == "level" and var4 > 0 then
			var2[var15] = math.ceil(var2[var15] / var4)
		end

		var14[iter11] = AttributeType.EliteConditionCompare(var16, var2[var15], var17) and 1 or 0
	end

	return var14, var2
end

function var0.GetNomralFleetMaxCount(arg0)
	return arg0:getConfig("group_num")
end

function var0.GetSubmarineFleetMaxCount(arg0)
	return arg0:getConfig("submarine_num")
end

function var0.GetSupportFleetMaxCount(arg0)
	return arg0:getConfig("support_group_num")
end

function var0.EliteShipTypeFilter(arg0)
	if arg0:getConfig("type") == Chapter.SelectFleet then
		local var0 = {
			1,
			2,
			3
		}

		for iter0, iter1 in ipairs(var0) do
			table.clear(arg0.eliteFleetList[iter1])
			table.clear(arg0.eliteCommanderList[iter1])
		end
	else
		for iter2 = arg0:GetNomralFleetMaxCount() + 1, 2 do
			table.clear(arg0.eliteFleetList[iter2])
			table.clear(arg0.eliteCommanderList[iter2])
		end

		for iter3 = arg0:GetSubmarineFleetMaxCount() + 2 + 1, 3 do
			table.clear(arg0.eliteFleetList[iter3])
			table.clear(arg0.eliteCommanderList[iter3])
		end
	end

	local var1 = getProxy(BayProxy):getRawData()

	for iter4, iter5 in ipairs(arg0.eliteFleetList) do
		for iter6 = #iter5, 1, -1 do
			if var1[iter5[iter6]] == nil then
				table.remove(iter5, iter6)
			end
		end
	end

	local function var2(arg0, arg1, arg2)
		arg1 = Clone(arg1)

		ChapterProxy.SortRecommendLimitation(arg1)

		for iter0, iter1 in ipairs(arg2) do
			local var0
			local var1 = var1[iter1]:getShipType()

			for iter2, iter3 in ipairs(arg1) do
				if ShipType.ContainInLimitBundle(iter3, var1) then
					var0 = iter2

					break
				end
			end

			if var0 then
				table.remove(arg1, var0)
			else
				table.removebyvalue(arg0, iter1)
			end
		end
	end

	for iter7, iter8 in ipairs(arg0:getConfig("limitation")) do
		local var3 = arg0.eliteFleetList[iter7]
		local var4 = {}
		local var5 = {}
		local var6 = {}

		for iter9, iter10 in ipairs(var3) do
			local var7 = var1[iter10]:getTeamType()

			if var7 == TeamType.Main then
				table.insert(var4, iter10)
			elseif var7 == TeamType.Vanguard then
				table.insert(var5, iter10)
			elseif var7 == TeamType.Submarine then
				table.insert(var6, iter10)
			end
		end

		var2(var3, iter8[1], var4)
		var2(var3, iter8[2], var5)
		var2(var3, {
			0,
			0,
			0
		}, var6)
	end
end

function var0.singleEliteFleetVertify(arg0, arg1)
	local var0 = getProxy(BayProxy):getRawData()
	local var1 = arg0:getEliteFleetList()[arg1]

	if not var1 or #var1 == 0 then
		return false
	end

	if arg1 >= 3 then
		return true
	end

	if arg0:getConfig("type") ~= Chapter.CustomFleet then
		return true
	end

	local var2 = 0
	local var3 = 0
	local var4 = {}

	for iter0, iter1 in ipairs(var1) do
		local var5 = var0[iter1]

		if var5 then
			if var5:getFlag("inEvent") then
				return false, i18n("elite_disable_ship_escort")
			end

			local var6 = var5:getTeamType()

			if var6 == TeamType.Main then
				var2 = var2 + 1
			elseif var6 == TeamType.Vanguard then
				var3 = var3 + 1
			end

			var4[#var4 + 1] = var5:getShipType()
		end
	end

	if var2 * var3 == 0 and var2 + var3 ~= 0 then
		return false
	end

	local var7 = checkExist(arg0:getConfig("limitation"), {
		arg1
	})
	local var8 = 1

	for iter2, iter3 in ipairs(var7 or {}) do
		local var9 = 0
		local var10 = 0

		for iter4, iter5 in ipairs(iter3) do
			if iter5 ~= 0 then
				var9 = var9 + 1

				if underscore.any(var4, function(arg0)
					return ShipType.ContainInLimitBundle(iter5, arg0)
				end) then
					var10 = 1

					break
				end
			end
		end

		if var9 == 0 then
			var10 = 1
		end

		var8 = var8 * var10
	end

	if var8 == 0 then
		return false, i18n("elite_disable_formation_unsatisfied")
	end

	return true
end

function var0.ClearSupportFleetList(arg0, arg1)
	arg0.supportFleet = {}
end

function var0.setSupportFleetList(arg0, arg1)
	arg0.supportFleet = arg1[1]
end

function var0.getSupportFleet(arg0)
	arg0:SupportShipTypeFilter()

	return arg0.supportFleet
end

function var0.SupportShipTypeFilter(arg0)
	if arg0:GetSupportFleetMaxCount() < 1 then
		table.clear(arg0.supportFleet)
	end

	local var0 = getProxy(BayProxy):getRawData()
	local var1 = arg0.supportFleet

	for iter0 = #var1, 1, -1 do
		if var0[var1[iter0]] == nil then
			table.remove(var1, iter0)
		end
	end
end

function var0.activeAlways(arg0)
	if getProxy(ChapterProxy):getMapById(arg0:getConfig("map")):isActivity() then
		local var0 = arg0:GetBindActID()
		local var1 = pg.activity_template[var0]

		if type(var1.config_client) == "table" then
			local var2 = var1.config_client.prevs or {}

			return table.contains(var2, arg0.id)
		end
	end

	return false
end

function var0.getPrevChapterName(arg0)
	local var0 = ""
	local var1 = arg0:getConfig("pre_chapter")

	if var1 ~= 0 then
		var0 = arg0:bindConfigTable()[var1].chapter_name
	end

	return var0
end

function var0.CanQuickPlay(arg0)
	local var0 = pg.chapter_setting[arg0.id]

	return var0 and var0.expedite > 0
end

function var0.GetQuickPlayFlag(arg0)
	return PlayerPrefs.GetInt("chapter_quickPlay_flag_" .. arg0.id, 0) == 1
end

function var0.writeDrops(arg0, arg1)
	_.each(arg1, function(arg0)
		if arg0.type == DROP_TYPE_SHIP and not table.contains(arg0.dropShipIdList, arg0.id) then
			table.insert(arg0.dropShipIdList, arg0.id)
		end
	end)
end

function var0.UpdateDropShipList(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		if not table.contains(arg0.dropShipIdList, iter1) then
			table.insert(arg0.dropShipIdList, iter1)
		end
	end
end

function var0.GetDropShipList(arg0)
	return arg0.dropShipIdList
end

function var0.getOniChapterInfo(arg0)
	return pg.chapter_capture[arg0.id]
end

function var0.getBombChapterInfo(arg0)
	return pg.chapter_boom[arg0.id]
end

function var0.getNpcShipByType(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(TaskProxy)

	local function var2(arg0)
		if arg0 == 0 then
			return true
		end

		local var0 = var1:getTaskVO(arg0)

		return var0 and not var0:isFinish()
	end

	for iter0, iter1 in ipairs(arg0:getConfig("npc_data")) do
		local var3 = pg.npc_squad_template[iter1]

		if not arg1 or arg1 == var3.type and var2(var3.task_id) then
			for iter2, iter3 in ipairs({
				"vanguard_list",
				"main_list"
			}) do
				for iter4, iter5 in ipairs(var3[iter3]) do
					table.insert(var0, NpcShip.New({
						id = iter5[1],
						configId = iter5[1],
						level = iter5[2]
					}))
				end
			end
		end
	end

	return var0
end

function var0.getTodayDefeatCount(arg0)
	return getProxy(DailyLevelProxy):getChapterDefeatCount(arg0.configId)
end

function var0.isTriesLimit(arg0)
	local var0 = arg0:getConfig("count")

	return var0 and var0 > 0
end

function var0.updateTodayDefeatCount(arg0)
	getProxy(DailyLevelProxy):updateChapterDefeatCount(arg0.configId)
end

function var0.enoughTimes2Start(arg0)
	if arg0:isTriesLimit() then
		return arg0:getTodayDefeatCount() < arg0:getConfig("count")
	else
		return true
	end
end

function var0.GetRestDailyBonus(arg0)
	local var0 = 0

	if arg0:IsRemaster() then
		return var0
	end

	local var1 = arg0:getConfig("boss_expedition_id")

	for iter0, iter1 in ipairs(var1) do
		local var2 = pg.expedition_activity_template[iter1]

		var0 = math.max(var0, var2 and var2.bonus_time or 0)
	end

	local var3 = pg.chapter_defense[arg0.id]

	if var3 then
		var0 = math.max(var0, var3.bonus_time or 0)
	end

	return (math.max(var0 - arg0.todayDefeatCount, 0))
end

function var0.GetDailyBonusQuota(arg0)
	return arg0:GetRestDailyBonus() > 0
end

var0.OPERATION_BUFF_TYPE_COST = "more_oil"
var0.OPERATION_BUFF_TYPE_REWARD = "extra_drop"
var0.OPERATION_BUFF_TYPE_EXP = "chapter_up"
var0.OPERATION_BUFF_TYPE_DESC = "desc"

function var0.GetSPOperationItemCacheKey(arg0)
	return "specialOPItem_" .. arg0
end

function var0.GetSpItems(arg0)
	local var0 = {}
	local var1 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)
	local var2 = arg0:getConfig("special_operation_list")

	if var2 and #var2 == 0 then
		return var0
	end

	for iter0, iter1 in ipairs(pg.benefit_buff_template.all) do
		local var3 = pg.benefit_buff_template[iter1]

		if var3.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and table.contains(var2, var3.id) then
			local var4 = tonumber(var3.benefit_condition)

			for iter2, iter3 in ipairs(var1) do
				if var4 == iter3.configId then
					table.insert(var0, iter3)

					break
				end
			end
		end
	end

	return var0
end

function var0.GetSPBuffByItem(arg0)
	for iter0, iter1 in ipairs(pg.benefit_buff_template.all) do
		buffConfig = pg.benefit_buff_template[iter1]

		if buffConfig.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and tonumber(buffConfig.benefit_condition) == arg0 then
			return buffConfig.id
		end
	end
end

function var0.GetActiveSPItemID(arg0)
	local var0 = Chapter.GetSPOperationItemCacheKey(arg0.id)
	local var1 = PlayerPrefs.GetInt(var0, 0)

	if var1 == 0 then
		return 0
	end

	if arg0:GetRestDailyBonus() > 0 then
		return 0
	end

	local var2 = arg0:GetSpItems()

	if _.detect(var2, function(arg0)
		return arg0:GetConfigID() == var1
	end) then
		return var1
	end

	return 0
end

function var0.GetLimitOilCost(arg0, arg1, arg2)
	if not arg0:isLoop() then
		return 9999
	end

	local var0
	local var1

	if arg1 then
		var1 = 3
	else
		local var2 = pg.expedition_data_template[arg2]

		var1 = (var2.type == ChapterConst.ExpeditionTypeBoss or var2.type == ChapterConst.ExpeditionTypeMulBoss) and 2 or 1
	end

	return arg0:getConfig("use_oil_limit")[var1] or 9999
end

function var0.IsRemaster(arg0)
	local var0 = getProxy(ChapterProxy):getMapById(arg0:getConfig("map"))

	return var0 and var0:isRemaster()
end

function var0.GetBindActID(arg0)
	return arg0:getConfig("act_id")
end

function var0.GetMaxBattleCount(arg0)
	local var0 = 0
	local var1 = getProxy(ChapterProxy):getMapById(arg0:getConfig("map"))

	if var1:getMapType() == Map.ELITE then
		var0 = pg.gameset.hard_level_multiple_sorties_times.key_value
		var0 = math.clamp(var0, 0, getProxy(DailyLevelProxy):GetRestEliteCount())
	elseif var1:isRemaster() then
		var0 = pg.gameset.archives_level_multiple_sorties_times.key_value
		var0 = math.clamp(var0, 0, getProxy(ChapterProxy).remasterTickets)
	elseif var1:isActivity() then
		var0 = pg.gameset.activity_level_multiple_sorties_times.key_value
	else
		var0 = pg.gameset.main_level_multiple_sorties_times.key_value
	end

	if arg0:isTriesLimit() then
		local var2 = arg0:getConfig("count") - arg0:getTodayDefeatCount()

		var0 = math.clamp(var0, 0, var2)
	end

	return var0
end

return var0
