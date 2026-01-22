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
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {},
		[FleetType.Support] = {}
	}
	arg0_2.loopFlag = 0
	arg0_2.miscArgDic = {}

	for iter1_2, iter2_2 in ipairs(noEmptyStr(arg0_2:getConfig("misc_arg")) or {}) do
		local var2_2, var3_2 = unpack(iter2_2)

		arg0_2.miscArgDic[var2_2] = var3_2
	end
end

function var0_0.getConfigMiscArg(arg0_3, arg1_3)
	return arg0_3.miscArgDic[arg1_3]
end

function var0_0.BuildEliteFleetInfo(arg0_4)
	return {
		[FleetType.Normal] = var0_0.BuildEliteTeamInfo(arg0_4.main_team),
		[FleetType.Submarine] = var0_0.BuildEliteTeamInfo(arg0_4.submarine_team),
		[FleetType.Support] = var0_0.BuildEliteTeamInfo(arg0_4.support_team)
	}
end

function var0_0.BuildEliteTeamInfo(arg0_5)
	return underscore.map(arg0_5, function(arg0_6)
		return {
			[TeamType.FormShips] = underscore.to_array(arg0_6.ship_list),
			[TeamType.FormCommander] = {
				arg0_6.commander_main or 0,
				arg0_6.commander_sub or 0
			}
		}
	end)
end

function var0_0.PackEliteFleetInfo(arg0_7)
	return {
		id = 0,
		main_team = underscore.map(arg0_7[FleetType.Normal], function(arg0_8)
			return var0_0.PackEliteTeamInfo(arg0_8)
		end),
		submarine_team = underscore.map(arg0_7[FleetType.Submarine], function(arg0_9)
			return var0_0.PackEliteTeamInfo(arg0_9)
		end),
		support_team = underscore.map(arg0_7[FleetType.Support], function(arg0_10)
			return var0_0.PackEliteTeamInfo(arg0_10)
		end)
	}
end

function var0_0.PackEliteTeamInfo(arg0_11)
	return {
		id = arg0_11.id or 0,
		ship_list = underscore.to_array(arg0_11[TeamType.FormShips]),
		commander_main = arg0_11[TeamType.FormCommander][1],
		commander_sub = arg0_11[TeamType.FormCommander][2]
	}
end

function var0_0.getMaxCount(arg0_12)
	local var0_12 = arg0_12:getConfig("risk_levels")

	if #var0_12 == 0 then
		return 0
	end

	return var0_12[1][1]
end

function var0_0.hasMitigation(arg0_13)
	if not LOCK_MITIGATION then
		return arg0_13:getConfig("mitigation_level") > 0
	else
		return false
	end
end

function var0_0.getRemainPassCount(arg0_14)
	local var0_14 = arg0_14:getMaxCount()

	return math.max(var0_14 - arg0_14.passCount, 0)
end

function var0_0.getRiskLevel(arg0_15)
	local var0_15 = arg0_15:getRemainPassCount()
	local var1_15 = arg0_15:getConfig("risk_levels")

	for iter0_15, iter1_15 in ipairs(var1_15) do
		if var0_15 <= iter1_15[1] and var0_15 >= iter1_15[2] then
			return iter0_15
		end
	end

	assert(false, "index can not be nil")
end

function var0_0.getMitigationRate(arg0_16)
	local var0_16 = arg0_16:getMaxCount()
	local var1_16 = LOCK_MITIGATION and 0 or arg0_16:getConfig("mitigation_rate")

	return math.min(arg0_16.passCount, var0_16) * var1_16
end

function var0_0.getRepressInfo(arg0_17)
	return {
		repressMax = arg0_17:getMaxCount(),
		repressCount = arg0_17.passCount,
		repressReduce = arg0_17:getMitigationRate(),
		repressLevel = LOCK_MITIGATION and 0 or arg0_17:getRemainPassCount() > 0 and 0 or arg0_17:getConfig("mitigation_level") or 0,
		repressEnemyHpRant = 1 - arg0_17:getStageCell(arg0_17.fleet.line.row, arg0_17.fleet.line.column).data / 10000
	}
end

function var0_0.getChapterState(arg0_18)
	local var0_18 = arg0_18:getRiskLevel()

	assert(var0_0.CHAPTER_STATE[var0_18], "state desc is nil")

	return var0_0.CHAPTER_STATE[var0_18]
end

function var0_0.getPlayType(arg0_19)
	return arg0_19:getConfig("model")
end

function var0_0.isTypeDefence(arg0_20)
	return arg0_20:getPlayType() == ChapterConst.TypeDefence
end

function var0_0.IsSpChapter(arg0_21)
	return arg0_21:isTriesLimit()
end

function var0_0.IsEXChapter(arg0_22)
	return arg0_22:getPlayType() == ChapterConst.TypeExtra
end

function var0_0.getConfig(arg0_23, arg1_23)
	if arg0_23:isLoop() then
		local var0_23 = pg.chapter_template_loop[arg0_23.id]

		assert(var0_23, "chapter_template_loop not exist: " .. arg0_23.id)

		if var0_23[arg1_23] ~= nil and var0_23[arg1_23] ~= "&&" then
			return var0_23[arg1_23]
		end

		if (arg1_23 == "air_dominance" or arg1_23 == "best_air_dominance") and var0_23.air_dominance_loop_rate ~= nil then
			local var1_23 = arg0_23:getConfigTable()
			local var2_23 = var0_23.air_dominance_loop_rate * 0.01

			return math.floor(var1_23[arg1_23] * var2_23)
		end
	end

	return var0_0.super.getConfig(arg0_23, arg1_23)
end

function var0_0.existLoop(arg0_24)
	return pg.chapter_template_loop[arg0_24.id] ~= nil
end

function var0_0.canActivateLoop(arg0_25)
	return arg0_25.progress == 100
end

function var0_0.isLoop(arg0_26)
	return arg0_26.loopFlag == 1
end

function var0_0.existAmbush(arg0_27)
	return arg0_27:getConfig("is_ambush") == 1 or arg0_27:getConfig("is_air_attack") == 1
end

function var0_0.isUnlock(arg0_28)
	return arg0_28:IsCleanPrevChapter() and arg0_28:IsCleanPrevStory()
end

function var0_0.IsCleanPrevChapter(arg0_29)
	for iter0_29, iter1_29 in ipairs(arg0_29:getConfig("pre_chapter")) do
		if _.all(iter1_29, function(arg0_30)
			if arg0_30 == 0 then
				return true
			end

			return getProxy(ChapterProxy):GetChapterItemById(arg0_30):isClear()
		end) then
			return true
		end
	end

	return false
end

function var0_0.IsCleanPrevStory(arg0_31)
	local var0_31 = arg0_31:getConfig("pre_story")

	if var0_31 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0_31):isClear()
end

function var0_0.isPlayerLVUnlock(arg0_32)
	return getProxy(PlayerProxy):getRawData().level >= arg0_32:getConfig("unlocklevel")
end

function var0_0.isClear(arg0_33)
	return arg0_33.progress >= 100
end

function var0_0.ifNeedHide(arg0_34)
	if table.contains(pg.chapter_setting.all, arg0_34.id) and pg.chapter_setting[arg0_34.id].hide == 1 then
		return arg0_34:isClear()
	end
end

function var0_0.existAchieve(arg0_35)
	return #arg0_35.achieves > 0
end

function var0_0.isAllAchieve(arg0_36)
	return _.all(arg0_36.achieves, function(arg0_37)
		return ChapterConst.IsAchieved(arg0_37)
	end)
end

function var0_0.GetFleetTypeByIndex(arg0_38)
	assert(arg0_38 > 0)

	return switch(arg0_38, {
		[4] = function()
			return FleetType.Support, 1
		end,
		[3] = function()
			return FleetType.Submarine, 1
		end
	}, function()
		return FleetType.Normal, arg0_38
	end)
end

function var0_0.getEliteTeamByIndex(arg0_42, arg1_42)
	local var0_42, var1_42 = var0_0.GetFleetTypeByIndex(arg1_42)

	if not arg0_42.eliteFleetList[var0_42][var1_42] then
		for iter0_42 = #arg0_42.eliteFleetList[var0_42] + 1, var1_42 do
			arg0_42.eliteFleetList[var0_42][iter0_42] = {
				id = 0,
				[TeamType.FormShips] = {},
				[TeamType.FormCommander] = {
					0,
					0
				}
			}
		end
	end

	return arg0_42.eliteFleetList[var0_42][var1_42], var0_42
end

function var0_0.setEliteFleetByIndex(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43:getEliteTeamByIndex(arg1_43)

	for iter0_43, iter1_43 in ipairs(arg2_43) do
		local var1_43, var2_43 = unpack(iter1_43)

		if var1_43 == TeamType.FormCommander then
			var0_43[var1_43][var2_43.pos] = var2_43.id
		else
			var0_43[var1_43] = var2_43
		end
	end
end

function var0_0.clearEliterFleetByIndex(arg0_44, arg1_44)
	arg0_44:setEliteFleetByIndex(arg1_44, {
		{
			TeamType.FormShips,
			{}
		}
	})
end

function var0_0.wrapEliteFleet(arg0_45, arg1_45)
	local var0_45, var1_45 = arg0_45:getEliteTeamByIndex(arg1_45)
	local var2_45 = {}

	for iter0_45, iter1_45 in pairs(var0_45[TeamType.FormCommander]) do
		if iter1_45 ~= 0 then
			table.insert(var2_45, {
				pos = iter0_45,
				id = iter1_45
			})
		end
	end

	return TypedFleet.New({
		id = arg1_45,
		fleetType = var1_45,
		ship_list = underscore.to_array(var0_45[TeamType.FormShips]),
		commanders = var2_45
	})
end

function var0_0.getEliteFleetCommanders(arg0_46)
	arg0_46:EliteCommanderFilter()

	local var0_46 = {}

	for iter0_46, iter1_46 in ipairs({
		{
			arg0_46:GetNomralFleetMaxCount(),
			0
		},
		{
			arg0_46:GetSubmarineFleetMaxCount(),
			2
		},
		{
			arg0_46:GetSupportFleetMaxCount(),
			3
		}
	}) do
		local var1_46, var2_46 = unpack(iter1_46)

		for iter2_46 = 1, var1_46 do
			local var3_46 = var2_46 + iter2_46
			local var4_46 = arg0_46:getEliteTeamByIndex(var3_46)

			var0_46[var3_46] = underscore.to_array(var4_46[TeamType.FormCommander])
		end
	end

	return var0_46
end

function var0_0.updateCommander(arg0_47, arg1_47, arg2_47, arg3_47)
	arg0_47:setEliteFleetByIndex(arg1_47, {
		{
			TeamType.FormCommander,
			{
				pos = arg2_47,
				id = arg3_47
			}
		}
	})
end

function var0_0.getEliteFleetList(arg0_48)
	arg0_48:EliteShipTypeFilter()

	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs({
		{
			arg0_48:GetNomralFleetMaxCount(),
			0
		},
		{
			arg0_48:GetSubmarineFleetMaxCount(),
			2
		},
		{
			arg0_48:GetSupportFleetMaxCount(),
			3
		}
	}) do
		local var1_48, var2_48 = unpack(iter1_48)

		for iter2_48 = 1, var1_48 do
			local var3_48 = var2_48 + iter2_48
			local var4_48 = arg0_48:getEliteTeamByIndex(var3_48)

			var0_48[var3_48] = underscore.to_array(var4_48[TeamType.FormShips])
		end
	end

	return var0_48
end

function var0_0.setEliteFleetList(arg0_49, arg1_49)
	if not arg1_49 then
		return
	end

	arg0_49.eliteFleetList = arg1_49
end

function var0_0.IsEliteFleetLegal(arg0_50)
	local var0_50 = {}

	for iter0_50, iter1_50 in ipairs({
		{
			arg0_50:GetNomralFleetMaxCount(),
			0,
			FleetType.Normal
		},
		{
			arg0_50:GetSubmarineFleetMaxCount(),
			2,
			FleetType.Submarine
		},
		{
			arg0_50:GetSupportFleetMaxCount(),
			3,
			FleetType.Support
		}
	}) do
		local var1_50, var2_50, var3_50 = unpack(iter1_50)

		for iter2_50 = 1, var1_50 do
			local var4_50 = var2_50 + iter2_50
			local var5_50, var6_50 = arg0_50:singleEliteFleetVertify(var4_50)

			if var5_50 then
				var0_50[var3_50] = defaultValue(var0_50[var3_50], 0) + 1
			elseif var6_50 == "empty" then
				-- block empty
			else
				return false, switch(var6_50, {
					inEvent = function()
						return i18n("elite_disable_ship_escort")
					end,
					teamCount = function()
						return i18n("elite_fleet_confirm", Fleet.DEFAULT_ELITE_NAME[var4_50])
					end,
					typeLimitation = function()
						return i18n("elite_disable_formation_unsatisfied")
					end
				})
			end
		end
	end

	if var0_50 == 0 then
		return false, i18n("elite_disable_no_fleet")
	end

	local var7_50 = arg0_50:IsPropertyLimitationSatisfy()
	local var8_50 = 1

	for iter3_50, iter4_50 in ipairs(var7_50) do
		var8_50 = var8_50 * iter4_50
	end

	if var8_50 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true
end

function var0_0.IsPropertyLimitationSatisfy(arg0_54)
	local var0_54 = getProxy(BayProxy):getRawData()
	local var1_54 = arg0_54:getConfig("property_limitation")
	local var2_54 = {}

	for iter0_54, iter1_54 in ipairs(var1_54) do
		var2_54[iter1_54[1]] = 0
	end

	local var3_54 = arg0_54:getEliteFleetList()
	local var4_54 = 0

	for iter2_54 = 1, 2 do
		if not arg0_54:singleEliteFleetVertify(iter2_54) then
			-- block empty
		else
			local var5_54 = {}
			local var6_54 = {}

			for iter3_54, iter4_54 in ipairs(var1_54) do
				local var7_54, var8_54, var9_54, var10_54 = unpack(iter4_54)

				if string.sub(var7_54, 1, 5) == "fleet" then
					var5_54[var7_54] = 0
					var6_54[var7_54] = var10_54
				end
			end

			local var11_54 = var3_54[iter2_54]

			for iter5_54, iter6_54 in ipairs(var11_54) do
				local var12_54 = var0_54[iter6_54]

				var4_54 = var4_54 + 1

				local var13_54 = intProperties(var12_54:getProperties())

				for iter7_54, iter8_54 in pairs(var2_54) do
					if string.sub(iter7_54, 1, 5) == "fleet" then
						if iter7_54 == "fleet_totle_level" then
							var5_54[iter7_54] = var5_54[iter7_54] + var12_54.level
						end
					elseif iter7_54 == "level" then
						var2_54[iter7_54] = iter8_54 + var12_54.level
					else
						var2_54[iter7_54] = iter8_54 + var13_54[iter7_54]
					end
				end
			end

			for iter9_54, iter10_54 in pairs(var5_54) do
				if iter9_54 == "fleet_totle_level" and iter10_54 > var6_54[iter9_54] then
					var2_54[iter9_54] = var2_54[iter9_54] + 1
				end
			end
		end
	end

	local var14_54 = {}

	for iter11_54, iter12_54 in ipairs(var1_54) do
		local var15_54, var16_54, var17_54 = unpack(iter12_54)

		if var15_54 == "level" and var4_54 > 0 then
			var2_54[var15_54] = math.ceil(var2_54[var15_54] / var4_54)
		end

		var14_54[iter11_54] = AttributeType.EliteConditionCompare(var16_54, var2_54[var15_54], var17_54) and 1 or 0
	end

	return var14_54, var2_54
end

function var0_0.GetNomralFleetMaxCount(arg0_55)
	return arg0_55:getConfig("group_num")
end

function var0_0.GetSubmarineFleetMaxCount(arg0_56)
	return arg0_56:getConfig("submarine_num")
end

function var0_0.GetSupportFleetMaxCount(arg0_57)
	return arg0_57:getConfig("support_group_num")
end

function var0_0.EliteShipTypeFilter(arg0_58)
	if arg0_58:getConfig("type") == Chapter.SelectFleet then
		arg0_58.eliteFleetList[FleetType.Normal] = {}
		arg0_58.eliteFleetList[FleetType.Submarine] = {}
	else
		for iter0_58 = arg0_58:GetNomralFleetMaxCount() + 1, #arg0_58.eliteFleetList[FleetType.Normal] do
			arg0_58.eliteFleetList[FleetType.Normal][iter0_58] = nil
		end

		for iter1_58 = arg0_58:GetSubmarineFleetMaxCount() + 1, #arg0_58.eliteFleetList[FleetType.Submarine] do
			arg0_58.eliteFleetList[FleetType.Submarine][iter1_58] = nil
		end
	end

	for iter2_58 = arg0_58:GetSupportFleetMaxCount() + 1, #arg0_58.eliteFleetList[FleetType.Support] do
		arg0_58.eliteFleetList[FleetType.Support][iter2_58] = nil
	end

	local var0_58 = getProxy(BayProxy):getRawData()

	local function var1_58(arg0_59)
		if not arg0_59 then
			return
		end

		for iter0_59 = #arg0_59, 1, -1 do
			if var0_58[arg0_59[iter0_59]] == nil then
				table.remove(arg0_59, iter0_59)
			end
		end
	end

	for iter3_58, iter4_58 in ipairs(arg0_58.eliteFleetList) do
		for iter5_58, iter6_58 in ipairs(iter4_58) do
			var1_58(iter6_58[TeamType.FormShips])
		end
	end

	local function var2_58(arg0_60, arg1_60)
		arg1_60 = Clone(arg1_60)

		ChapterProxy.SortRecommendLimitation(arg1_60)

		local var0_60 = 1

		while var0_60 <= #arg0_60 do
			local var1_60 = arg0_60[var0_60]
			local var2_60
			local var3_60 = var0_58[var1_60]:getShipType()

			for iter0_60, iter1_60 in ipairs(arg1_60) do
				if ShipType.ContainInLimitBundle(iter1_60, var3_60) then
					var2_60 = iter0_60

					break
				end
			end

			if var2_60 then
				table.remove(arg1_60, var2_60)

				var0_60 = var0_60 + 1
			else
				table.remove(arg0_60, var0_60)
			end
		end
	end

	local var3_58 = arg0_58:getConfig("limitation")

	for iter7_58, iter8_58 in pairs(arg0_58.eliteFleetList) do
		for iter9_58, iter10_58 in ipairs(iter8_58) do
			switch(iter7_58, {
				[FleetType.Normal] = function()
					local var0_61 = var3_58[iter9_58]
					local var1_61 = underscore.map({
						TeamType.Main,
						TeamType.Vanguard
					}, function(arg0_62)
						return underscore.filter(iter10_58[TeamType.FormShips], function(arg0_63)
							return var0_58[arg0_63]:getTeamType() == arg0_62
						end)
					end)

					var2_58(var1_61[1], var0_61[1])
					var2_58(var1_61[2], var0_61[2])

					iter10_58[TeamType.FormShips] = table.mergeArray(var1_61[1], var1_61[2])
				end,
				[FleetType.Submarine] = function()
					var2_58(iter10_58[TeamType.FormShips], {
						0,
						0,
						0
					})
				end,
				[FleetType.Support] = function()
					local var0_65 = arg0_58:getConfigMiscArg("submarine_support") and {
						"qian",
						"qian",
						"qian"
					} or {
						"hang",
						"hang",
						"hang"
					}

					var2_58(iter10_58[TeamType.FormShips], var0_65)
				end
			})
		end
	end
end

function var0_0.EliteCommanderFilter(arg0_66)
	local var0_66 = getProxy(CommanderProxy)

	for iter0_66, iter1_66 in pairs(arg0_66.eliteFleetList) do
		for iter2_66, iter3_66 in ipairs(iter1_66) do
			for iter4_66, iter5_66 in ipairs(iter3_66[TeamType.FormCommander]) do
				if iter5_66 ~= 0 and not var0_66:RawGetCommanderById(iter5_66) then
					iter3_66[TeamType.FormCommander][iter4_66] = 0
				end
			end
		end
	end
end

function var0_0.singleEliteFleetVertify(arg0_67, arg1_67)
	local var0_67 = getProxy(BayProxy):getRawData()
	local var1_67, var2_67 = arg0_67:getEliteTeamByIndex(arg1_67)
	local var3_67 = var1_67[TeamType.FormShips]

	if not var3_67 or #var3_67 == 0 then
		return false, "empty"
	end

	local var4_67 = {
		[TeamType.Main] = 0,
		[TeamType.Vanguard] = 0,
		[TeamType.Submarine] = 0
	}
	local var5_67 = {}

	for iter0_67, iter1_67 in ipairs(var3_67) do
		local var6_67 = var0_67[iter1_67]

		if var6_67 then
			if var6_67:getFlag("inEvent") then
				return false, "inEvent"
			end

			local var7_67 = var6_67:getTeamType()

			var4_67[var7_67] = var4_67[var7_67] + 1
			var5_67[#var5_67 + 1] = var6_67:getShipType()
		end
	end

	if var2_67 == FleetType.Normal and (var4_67[TeamType.Main] > TeamType.MainMax or var4_67[TeamType.Vanguard] > TeamType.VanguardMax or var4_67[TeamType.Main] * var4_67[TeamType.Vanguard] == 0) then
		return false, "teamCount"
	end

	local var8_67 = underscore(checkExist(arg0_67:getConfig("limitation"), {
		arg1_67
	}) or {}):chain():flatten():filter(function(arg0_68)
		return arg0_68 ~= 0
	end):value()

	ChapterProxy.SortRecommendLimitation(var8_67)

	local var9_67 = 1

	while var9_67 <= #var5_67 do
		local var10_67 = var5_67[var9_67]
		local var11_67

		for iter2_67, iter3_67 in ipairs(var8_67) do
			if ShipType.ContainInLimitBundle(iter3_67, var10_67) then
				var11_67 = iter2_67

				break
			end
		end

		if var11_67 then
			table.remove(var8_67, var11_67)

			var9_67 = var9_67 + 1
		else
			table.remove(var5_67, var9_67)
		end
	end

	if var2_67 == FleetType.Normal then
		local var12_67 = {}

		for iter4_67, iter5_67 in ipairs(var5_67) do
			var12_67[ShipType.GetTeamFromShipType(iter5_67)] = true
		end

		for iter6_67, iter7_67 in ipairs({
			TeamType.Vanguard,
			TeamType.Main
		}) do
			var12_67[iter7_67] = var12_67[iter7_67] or underscore.all(var8_67, function(arg0_69)
				return underscore.all(ShipType.GetShipTypesFromLimit(arg0_69), function(arg0_70)
					return ShipType.GetTeamFromShipType(arg0_70) ~= iter7_67
				end)
			end)
		end

		if var12_67[TeamType.Vanguard] and var12_67[TeamType.Main] then
			return true
		else
			return false, "typeLimitation"
		end
	elseif #var8_67 == 0 or #var5_67 > 0 then
		return true
	else
		return false, "typeLimitation"
	end
end

function var0_0.getSupportFleet(arg0_71)
	arg0_71:EliteShipTypeFilter()

	local var0_71 = arg0_71:getEliteTeamByIndex(4)

	return underscore.to_array(var0_71[TeamType.FormShips])
end

function var0_0.activeAlways(arg0_72)
	if getProxy(ChapterProxy):getMapById(arg0_72:getConfig("map")):isActivity() then
		local var0_72 = arg0_72:GetBindActID()

		warning(var0_72)

		local var1_72 = pg.activity_template[var0_72]

		if type(var1_72.config_client) == "table" then
			local var2_72 = var1_72.config_client.prevs or {}

			return table.contains(var2_72, arg0_72.id)
		end
	end

	return false
end

function var0_0.GetPrevChapterNames(arg0_73)
	local var0_73 = {}

	for iter0_73, iter1_73 in ipairs(arg0_73:getConfig("pre_chapter")) do
		local var1_73 = iter1_73[1]

		if var1_73 ~= 0 then
			local var2_73 = arg0_73:bindConfigTable()[var1_73].chapter_name

			table.insert(var0_73, var2_73)
		end
	end

	return var0_73
end

function var0_0.CanQuickPlay(arg0_74)
	local var0_74 = pg.chapter_setting[arg0_74.id]

	return var0_74 and var0_74.expedite > 0
end

function var0_0.GetQuickPlayFlag(arg0_75)
	return PlayerPrefs.GetInt("chapter_quickPlay_flag_" .. arg0_75.id, 0) == 1
end

function var0_0.writeDrops(arg0_76, arg1_76)
	_.each(arg1_76, function(arg0_77)
		if arg0_77.type == DROP_TYPE_SHIP and not table.contains(arg0_76.dropShipIdList, arg0_77.id) then
			table.insert(arg0_76.dropShipIdList, arg0_77.id)
		end
	end)
end

function var0_0.UpdateDropShipList(arg0_78, arg1_78)
	for iter0_78, iter1_78 in ipairs(arg1_78) do
		if not table.contains(arg0_78.dropShipIdList, iter1_78) then
			table.insert(arg0_78.dropShipIdList, iter1_78)
		end
	end
end

function var0_0.GetDropShipList(arg0_79)
	return arg0_79.dropShipIdList
end

function var0_0.getOniChapterInfo(arg0_80)
	return pg.chapter_capture[arg0_80.id]
end

function var0_0.getBombChapterInfo(arg0_81)
	return pg.chapter_boom[arg0_81.id]
end

function var0_0.getNpcShipByType(arg0_82, arg1_82)
	local var0_82 = {}
	local var1_82 = getProxy(TaskProxy)

	local function var2_82(arg0_83)
		if arg0_83 == 0 then
			return true
		end

		local var0_83 = var1_82:getTaskVO(arg0_83)

		return var0_83 and not var0_83:isFinish()
	end

	for iter0_82, iter1_82 in ipairs(arg0_82:getConfig("npc_data")) do
		local var3_82 = pg.npc_squad_template[iter1_82]

		if not arg1_82 or arg1_82 == var3_82.type and var2_82(var3_82.task_id) then
			for iter2_82, iter3_82 in ipairs({
				"vanguard_list",
				"main_list"
			}) do
				for iter4_82, iter5_82 in ipairs(var3_82[iter3_82]) do
					table.insert(var0_82, NpcShip.New({
						id = iter5_82[1],
						configId = iter5_82[1],
						level = iter5_82[2]
					}))
				end
			end
		end
	end

	return var0_82
end

function var0_0.getTodayDefeatCount(arg0_84)
	return getProxy(DailyLevelProxy):getChapterDefeatCount(arg0_84.configId)
end

function var0_0.isTriesLimit(arg0_85)
	local var0_85 = arg0_85:getConfig("count")

	return var0_85 and var0_85 > 0
end

function var0_0.updateTodayDefeatCount(arg0_86)
	getProxy(DailyLevelProxy):updateChapterDefeatCount(arg0_86.configId)
end

function var0_0.enoughTimes2Start(arg0_87)
	if arg0_87:isTriesLimit() then
		return arg0_87:getTodayDefeatCount() < arg0_87:getConfig("count")
	else
		return true
	end
end

function var0_0.GetRestDailyBonus(arg0_88)
	local var0_88 = 0

	if arg0_88:IsRemaster() then
		return var0_88
	end

	local var1_88 = arg0_88:getConfig("boss_expedition_id")

	for iter0_88, iter1_88 in ipairs(var1_88) do
		local var2_88 = pg.expedition_activity_template[iter1_88]

		var0_88 = math.max(var0_88, var2_88 and var2_88.bonus_time or 0)
	end

	local var3_88 = pg.chapter_defense[arg0_88.id]

	if var3_88 then
		var0_88 = math.max(var0_88, var3_88.bonus_time or 0)
	end

	return (math.max(var0_88 - arg0_88.todayDefeatCount, 0))
end

function var0_0.GetDailyBonusQuota(arg0_89)
	return arg0_89:GetRestDailyBonus() > 0
end

var0_0.OPERATION_BUFF_TYPE_COST = "more_oil"
var0_0.OPERATION_BUFF_TYPE_REWARD = "extra_drop"
var0_0.OPERATION_BUFF_TYPE_EXP = "chapter_up"
var0_0.OPERATION_BUFF_TYPE_DESC = "desc"

function var0_0.GetSPOperationItemCacheKey(arg0_90)
	return "specialOPItem_" .. arg0_90
end

function var0_0.GetSpItems(arg0_91)
	local var0_91 = {}
	local var1_91 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)
	local var2_91 = noEmptyStr(arg0_91:getConfig("special_operation_list"))

	if not var2_91 or not next(var2_91) then
		return var0_91
	end

	for iter0_91, iter1_91 in ipairs(var2_91) do
		local var3_91 = pg.benefit_buff_template[iter1_91]

		if var3_91 and var3_91.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			local var4_91 = ActivityBuff.GetBenefitCondition(var3_91.benefit_condition)

			for iter2_91, iter3_91 in ipairs(var1_91) do
				assert(var4_91[1] == "item")

				if var4_91[2] == iter3_91.configId then
					table.insert(var0_91, iter3_91)

					break
				end
			end
		end
	end

	return var0_91
end

function var0_0.GetSPBuffByItem(arg0_92)
	for iter0_92, iter1_92 in ipairs(pg.benefit_buff_template.get_id_list_by_benefit_type[Chapter.OPERATION_BUFF_TYPE_DESC]) do
		local var0_92 = pg.benefit_buff_template[iter1_92]
		local var1_92 = ActivityBuff.GetBenefitCondition(var0_92.benefit_condition)

		assert(var1_92[1] == "item")

		if var1_92[2] == arg0_92 then
			return var0_92.id
		end
	end
end

function var0_0.GetActiveSPItemID(arg0_93)
	local var0_93 = Chapter.GetSPOperationItemCacheKey(arg0_93.id)
	local var1_93 = PlayerPrefs.GetInt(var0_93, 0)

	if var1_93 == 0 then
		return 0
	end

	if arg0_93:GetRestDailyBonus() > 0 then
		return 0
	end

	local var2_93 = arg0_93:GetSpItems()

	if _.detect(var2_93, function(arg0_94)
		return arg0_94:GetConfigID() == var1_93
	end) then
		return var1_93
	end

	return 0
end

function var0_0.GetLimitOilCost(arg0_95, arg1_95, arg2_95)
	if not arg0_95:isLoop() then
		return 9999
	end

	local var0_95
	local var1_95

	if arg1_95 then
		var1_95 = 3
	else
		local var2_95 = pg.expedition_data_template[arg2_95]

		var1_95 = (var2_95.type == ChapterConst.ExpeditionTypeBoss or var2_95.type == ChapterConst.ExpeditionTypeMulBoss) and 2 or 1
	end

	return arg0_95:getConfig("use_oil_limit")[var1_95] or 9999
end

function var0_0.IsRemaster(arg0_96)
	local var0_96 = getProxy(ChapterProxy):getMapById(arg0_96:getConfig("map"))

	return var0_96 and var0_96:isRemaster()
end

function var0_0.GetBindActID(arg0_97)
	return arg0_97:getConfig("act_id")
end

function var0_0.GetMaxBattleCount(arg0_98)
	local var0_98 = 0
	local var1_98 = getProxy(ChapterProxy):getMapById(arg0_98:getConfig("map"))

	if var1_98:getMapType() == Map.ELITE then
		var0_98 = pg.gameset.hard_level_multiple_sorties_times.key_value
		var0_98 = math.clamp(var0_98, 0, getProxy(DailyLevelProxy):GetRestEliteCount())
	elseif var1_98:isRemaster() then
		var0_98 = pg.gameset.archives_level_multiple_sorties_times.key_value
		var0_98 = math.clamp(var0_98, 0, getProxy(ChapterProxy).remasterTickets)
	elseif var1_98:isActivity() then
		var0_98 = pg.gameset.activity_level_multiple_sorties_times.key_value
	else
		var0_98 = pg.gameset.main_level_multiple_sorties_times.key_value
	end

	if arg0_98:isTriesLimit() then
		local var2_98 = arg0_98:getConfig("count") - arg0_98:getTodayDefeatCount()

		var0_98 = math.clamp(var0_98, 0, var2_98)
	end

	return var0_98
end

function var0_0.IsSupportSubmarineStage(arg0_99)
	return arg0_99:GetSupportFleetMaxCount() > 0 and tobool(arg0_99:getConfigMiscArg("submarine_support"))
end

function var0_0.IsFogStage(arg0_100)
	return tobool(arg0_100:getConfigMiscArg("fog"))
end

return var0_0
