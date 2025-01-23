local var0_0 = class("NewEducateChar", import("model.vo.BaseVO"))

var0_0.RES_TYPE = {
	FAVOR = 4,
	MONEY = 1,
	ACTION = 3,
	MOOD = 2
}
var0_0.ATTR_TYPE = {
	ATTR = 1,
	PERSONALITY = 2
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_data
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.roundData = NewEducateRound.New(arg0_2.id, arg1_2.round)

	arg0_2:SetResources(arg1_2.res.resource)
	arg0_2:SetAttrs(arg1_2.res.attrs)

	arg0_2.group2Plan = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.plan.plan_upgrade or {}) do
		local var0_2 = pg.child2_plan[iter1_2].group_id

		arg0_2.group2Plan[var0_2] = iter1_2
	end

	arg0_2:InitSiteData(arg1_2.site)

	arg0_2.assessRecords = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.evaluations) do
		arg0_2.assessRecords[iter3_2.key] = iter3_2.value
	end

	arg0_2.callName = arg1_2.name or ""
	arg0_2.gotFavorLv = arg1_2.favor_lv or 0
	arg0_2.benefitData = NewEducateBenefit.New(arg1_2.benefit)

	arg0_2:BuildSiteIdMap()
end

function var0_0.InitPermanent(arg0_3, arg1_3)
	arg0_3.permanentData = NewEducatePermanent.New(arg0_3.id, arg1_3)
end

function var0_0.SetPermanent(arg0_4, arg1_4)
	arg0_4.permanentData = arg1_4
end

function var0_0.GetPermanentData(arg0_5)
	return arg0_5.permanentData
end

function var0_0.GetGameCnt(arg0_6)
	return arg0_6.permanentData:GetGameCnt()
end

function var0_0.InitFSM(arg0_7, arg1_7)
	arg0_7.fsm = NewEducateFSM.New(arg0_7.id, arg1_7)
end

function var0_0.InitSiteData(arg0_8, arg1_8)
	arg0_8.siteShips = arg1_8.characters or {}
	arg0_8.normalType2Id = {}

	for iter0_8, iter1_8 in ipairs(arg1_8.works or {}) do
		local var0_8 = pg.child2_site_normal[iter1_8].type

		arg0_8.normalType2Id[var0_8] = iter1_8
	end

	local var1_8 = pg.child2_site_normal.get_id_list_by_character[arg0_8.id]

	for iter2_8, iter3_8 in pairs(NewEducateConst.SITE_NORMAL_TYPE) do
		if not arg0_8.normalType2Id[iter3_8] then
			arg0_8.normalType2Id[iter3_8] = underscore.detect(var1_8, function(arg0_9)
				local var0_9 = pg.child2_site_normal[arg0_9]

				return var0_9.type == iter3_8 and var0_9.site_lv == 1
			end)
		end
	end

	arg0_8.normalRecords = {}

	for iter4_8, iter5_8 in ipairs(arg1_8.work_counter or {}) do
		arg0_8.normalRecords[iter5_8.key] = iter5_8.value
	end

	arg0_8.eventRecords = {}

	for iter6_8, iter7_8 in ipairs(arg1_8.event_counter or {}) do
		arg0_8.eventRecords[iter7_8.key] = iter7_8.value
	end
end

function var0_0.GetSelectInfo(arg0_10)
	return {
		bg = arg0_10.roundData:getConfig("main_background"),
		name = arg0_10:getConfig("name2"),
		gameCnt = arg0_10:GetGameCnt(),
		progressStr = i18n("child2_cur_round", arg0_10.roundData.round)
	}
end

function var0_0.GetName(arg0_11)
	return arg0_11:getConfig("name")
end

function var0_0.SetCallName(arg0_12, arg1_12)
	arg0_12.callName = arg1_12
end

function var0_0.GetCallName(arg0_13)
	return arg0_13.callName
end

function var0_0.BuildSiteIdMap(arg0_14)
	arg0_14.siteIdMap = {}

	for iter0_14, iter1_14 in pairs(NewEducateConst.SITE_TYPE) do
		local var0_14 = pg.child2_site_display.get_id_list_by_type[iter1_14]

		arg0_14.siteIdMap[iter1_14] = {}

		switch(iter1_14, {
			[NewEducateConst.SITE_TYPE.SHIP] = function()
				underscore.each(var0_14, function(arg0_16)
					local var0_16 = pg.child2_site_display[arg0_16].param

					arg0_14.siteIdMap[iter1_14][var0_16] = arg0_16
				end)
			end,
			[NewEducateConst.SITE_TYPE.SHOP] = function()
				arg0_14.siteIdMap[iter1_14] = var0_14
			end,
			[NewEducateConst.SITE_TYPE.WORK] = function()
				arg0_14.siteIdMap[iter1_14] = var0_14
			end,
			[NewEducateConst.SITE_TYPE.TRAVEL] = function()
				arg0_14.siteIdMap[iter1_14] = var0_14
			end,
			[NewEducateConst.SITE_TYPE.EVENT] = function()
				underscore.each(var0_14, function(arg0_21)
					local var0_21 = pg.child2_site_display[arg0_21].param

					arg0_14.siteIdMap[iter1_14][var0_21] = arg0_21
				end)
			end
		})
	end
end

function var0_0.GetSiteId(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg2_22 or 1

	return arg0_22.siteIdMap[arg1_22][var0_22]
end

function var0_0.GetNormalIdByType(arg0_23, arg1_23)
	return arg0_23.normalType2Id[arg1_23]
end

function var0_0.UpdateNormalType2Id(arg0_24, arg1_24, arg2_24)
	arg0_24.normalType2Id[arg1_24] = arg2_24
end

function var0_0.AddNormalRecord(arg0_25, arg1_25)
	arg0_25.normalRecords[arg1_25] = (arg0_25.normalRecords[arg1_25] or 0) + 1
end

function var0_0.GetNormalCnt(arg0_26, arg1_26)
	return arg0_26.normalRecords[arg1_26] or 0
end

function var0_0.AddEventRecord(arg0_27, arg1_27)
	arg0_27.eventRecords[arg1_27] = (arg0_27.eventRecords[arg1_27] or 0) + 1
end

function var0_0.GetEventCnt(arg0_28, arg1_28)
	return arg0_28.eventRecords[arg1_28] or 0
end

function var0_0.SetShipIds(arg0_29, arg1_29)
	arg0_29.siteShips = arg1_29
end

function var0_0.GetShipIds(arg0_30)
	return arg0_30.siteShips
end

function var0_0.UpdateShipId(arg0_31, arg1_31, arg2_31)
	table.removebyvalue(arg0_31.siteShips, arg1_31)
	table.insert(arg0_31.siteShips, arg2_31)
end

function var0_0.AddAssessRecord(arg0_32, arg1_32, arg2_32)
	arg0_32.assessRecords[arg1_32] = arg2_32
end

function var0_0.GetResources(arg0_33)
	return Clone(arg0_33.resources)
end

function var0_0.SetResources(arg0_34, arg1_34)
	arg0_34.resources = {}

	for iter0_34, iter1_34 in ipairs(arg1_34) do
		arg0_34.resources[iter1_34.key] = iter1_34.value
		arg0_34.resources[iter1_34.key] = math.max(pg.child2_resource[iter1_34.key].min_value, arg0_34.resources[iter1_34.key])
		arg0_34.resources[iter1_34.key] = math.min(pg.child2_resource[iter1_34.key].max_value, arg0_34.resources[iter1_34.key])
	end
end

function var0_0.GetRes(arg0_35, arg1_35)
	return arg0_35.resources[arg1_35]
end

function var0_0.GetPoint(arg0_36)
	return arg0_36:GetResByType(var0_0.RES_TYPE.ACTION)
end

function var0_0.GetResByType(arg0_37, arg1_37)
	return arg0_37.resources[arg0_37:GetResIdByType(arg1_37)]
end

function var0_0.GetResPanelIds(arg0_38)
	return underscore.select(underscore.keys(arg0_38.resources), function(arg0_39)
		return pg.child2_resource[arg0_39].type ~= var0_0.RES_TYPE.FAVOR
	end)
end

function var0_0.GetResIdByType(arg0_40, arg1_40)
	return underscore.detect(underscore.keys(arg0_40.resources), function(arg0_41)
		return pg.child2_resource[arg0_41].type == arg1_40
	end)
end

function var0_0.UpdateRes(arg0_42, arg1_42, arg2_42)
	arg0_42.resources[arg1_42] = arg0_42.resources[arg1_42] + arg2_42
	arg0_42.resources[arg1_42] = math.max(pg.child2_resource[arg1_42].min_value, arg0_42.resources[arg1_42])
	arg0_42.resources[arg1_42] = math.min(pg.child2_resource[arg1_42].max_value, arg0_42.resources[arg1_42])
end

function var0_0.GetMoodStage(arg0_43, arg1_43)
	local var0_43 = pg.gameset.child_emotion.description
	local var1_43 = arg1_43 or arg0_43:GetResByType(var0_0.RES_TYPE.MOOD)

	if var1_43 <= var0_43[1][1][1] then
		return 1
	end

	if var1_43 >= var0_43[#var0_43][1][2] then
		return #var0_43
	end

	for iter0_43, iter1_43 in ipairs(var0_43) do
		if var1_43 >= iter1_43[1][1] and var1_43 < iter1_43[1][2] then
			return iter0_43
		end
	end
end

function var0_0.UpgradeFavor(arg0_44)
	arg0_44.gotFavorLv = arg0_44.gotFavorLv + 1
end

function var0_0.CheckFavor(arg0_45)
	local var0_45 = arg0_45:GetFavorInfo()
	local var1_45 = arg0_45:getConfig("favor_exp")[var0_45.lv]

	if not var1_45 then
		return false
	end

	return var1_45 <= var0_45.value
end

function var0_0.GetFavorInfo(arg0_46)
	local var0_46 = arg0_46:GetResByType(var0_0.RES_TYPE.FAVOR)
	local var1_46 = math.min(arg0_46.gotFavorLv + 1, arg0_46:getConfig("favor_level"))
	local var2_46 = 0

	if arg0_46.gotFavorLv > 0 then
		for iter0_46 = 1, arg0_46.gotFavorLv do
			var2_46 = var2_46 + arg0_46:getConfig("favor_exp")[iter0_46]
		end
	end

	return {
		lv = var1_46,
		value = var0_46 - var2_46
	}
end

function var0_0.GetAttrs(arg0_47)
	return Clone(arg0_47.attrs)
end

function var0_0.SetAttrs(arg0_48, arg1_48)
	arg0_48.attrs = {}

	for iter0_48, iter1_48 in ipairs(arg1_48) do
		arg0_48.attrs[iter1_48.key] = iter1_48.value
		arg0_48.attrs[iter1_48.key] = math.max(pg.child2_attr[iter1_48.key].min_value, arg0_48.attrs[iter1_48.key])
		arg0_48.attrs[iter1_48.key] = math.min(pg.child2_attr[iter1_48.key].max_value, arg0_48.attrs[iter1_48.key])
	end
end

function var0_0.GetAttr(arg0_49, arg1_49)
	return arg0_49.attrs[arg1_49]
end

function var0_0.GetAttrIds(arg0_50, arg1_50)
	local var0_50 = underscore.select(underscore.keys(arg0_50.attrs), function(arg0_51)
		return pg.child2_attr[arg0_51].type == var0_0.ATTR_TYPE.ATTR
	end)

	table.sort(var0_50)

	return var0_50
end

function var0_0.GetAttrSum(arg0_52)
	return underscore.reduce(arg0_52:GetAttrIds(), 0, function(arg0_53, arg1_53)
		return arg0_53 + arg0_52.attrs[arg1_53]
	end)
end

function var0_0.GetPersonalityId(arg0_54)
	return underscore.detect(underscore.keys(arg0_54.attrs), function(arg0_55)
		return pg.child2_attr[arg0_55].type == var0_0.ATTR_TYPE.PERSONALITY
	end)
end

function var0_0.GetPersonality(arg0_56)
	return arg0_56.attrs[arg0_56:GetPersonalityId()]
end

function var0_0.GetPersonalityMiddle(arg0_57)
	local var0_57 = arg0_57:GetPersonalityId()
	local var1_57 = pg.child2_attr[var0_57]

	return math.floor((var1_57.min_value + var1_57.max_value) / 2)
end

function var0_0.GetPersonalityTag(arg0_58, arg1_58)
	local var0_58 = arg1_58 or arg0_58:GetPersonality()

	return (switch(arg0_58:getConfig("personality_type"), {
		function()
			for iter0_59, iter1_59 in ipairs(arg0_58:getConfig("personality_param")) do
				if var0_58 >= iter1_59[2][1] and var0_58 <= iter1_59[2][2] then
					return iter1_59[1]
				end
			end

			return arg0_58:getConfig("personality_param")[1][1]
		end
	}, function()
		assert(false, "不合法的personality_type")
	end))
end

function var0_0.UpdateAttr(arg0_61, arg1_61, arg2_61)
	arg0_61.attrs[arg1_61] = arg0_61.attrs[arg1_61] + arg2_61
	arg0_61.attrs[arg1_61] = math.max(pg.child2_attr[arg1_61].min_value, arg0_61.attrs[arg1_61])
	arg0_61.attrs[arg1_61] = math.min(pg.child2_attr[arg1_61].max_value, arg0_61.attrs[arg1_61])
end

function var0_0.GetAssessRankIdx(arg0_62)
	local var0_62 = arg0_62.roundData:getConfig("target_id")

	if var0_62 == 0 then
		return 0
	end

	local var1_62 = arg0_62:GetAttrSum()
	local var2_62 = pg.child2_target[var0_62].attr_sum_level

	for iter0_62, iter1_62 in ipairs(var2_62) do
		if var1_62 >= iter1_62[1] and var1_62 <= iter1_62[2] then
			return iter0_62
		end
	end

	return #var2_62
end

function var0_0.GetAssessPreStory(arg0_63)
	local var0_63 = arg0_63.roundData:getConfig("target_id")

	if var0_63 == 0 then
		return nil
	end

	return pg.child2_target[var0_63].pre_perform
end

function var0_0.GetRoundData(arg0_64)
	return arg0_64.roundData
end

function var0_0.GetFSM(arg0_65)
	return arg0_65.fsm
end

function var0_0.GetBgm(arg0_66)
	local var0_66 = arg0_66:GetPersonalityTag()

	return underscore.detect(arg0_66:getConfig("bgm"), function(arg0_67)
		return arg0_67[1] == var0_66
	end)[2]
end

function var0_0.GetPaintingName(arg0_68)
	local var0_68 = arg0_68:GetPersonalityTag()

	return underscore.detect(arg0_68.roundData:getConfig("main_painting"), function(arg0_69)
		return arg0_69[1] == var0_68
	end)[2]
end

function var0_0.GetBGName(arg0_70)
	return arg0_70.roundData:getConfig("main_background")
end

function var0_0.GetMainDialogueInfo(arg0_71)
	local var0_71 = arg0_71:GetPersonalityTag()
	local var1_71 = underscore.detect(arg0_71.roundData:getConfig("main_word"), function(arg0_72)
		return arg0_72[1] == var0_71
	end)
	local var2_71 = underscore.detect(arg0_71.roundData:getConfig("main_word_expression"), function(arg0_73)
		return arg0_73[1] == var0_71
	end)

	return var1_71[2], var2_71[2]
end

function var0_0.OnUpgradedPlan(arg0_74, arg1_74)
	local var0_74 = pg.child2_plan[arg1_74].group_id

	arg0_74.group2Plan[var0_74] = arg1_74
end

function var0_0.GetPlanList(arg0_75)
	local var0_75 = {}
	local var1_75 = arg0_75.roundData:getConfig("plan_group")

	for iter0_75, iter1_75 in ipairs(var1_75) do
		local var2_75 = pg.child2_plan.get_id_list_by_group_id[iter1_75]

		if #var2_75 == 1 then
			table.insert(var0_75, NewEducatePlan.New(var2_75[1]))
		elseif arg0_75.group2Plan[iter1_75] then
			table.insert(var0_75, NewEducatePlan.New(arg0_75.group2Plan[iter1_75]))
		else
			table.sort(var2_75, function(arg0_76, arg1_76)
				return pg.child2_plan[arg0_76].level < pg.child2_plan[arg1_76].level
			end)
			table.insert(var0_75, NewEducatePlan.New(var2_75[1]))
		end
	end

	for iter2_75, iter3_75 in ipairs(arg0_75.benefitData:GetExtraPlan(arg0_75)) do
		table.insert(var0_75, NewEducatePlan.New(iter3_75, true))
	end

	return var0_75
end

function var0_0.OnNextRound(arg0_77)
	arg0_77.siteShips = {}

	arg0_77.fsm:Reset()
	arg0_77.roundData:OnNextRound()

	arg0_77.resources[arg0_77:GetResIdByType(NewEducateChar.RES_TYPE.ACTION)] = arg0_77.roundData:getConfig("map_mobility")

	arg0_77.benefitData:OnNextRound(arg0_77.roundData.round)
end

function var0_0.GetBenefitData(arg0_78)
	return arg0_78.benefitData
end

function var0_0.AddBuff(arg0_79, arg1_79, arg2_79)
	if arg2_79 > 0 then
		if arg0_79.fsm:IsImmediateBenefit() then
			arg0_79.benefitData:AddActiveBuff(arg1_79, arg0_79.roundData.round)
		else
			arg0_79.benefitData:AddPendingBuff(arg1_79)
		end
	else
		arg0_79.benefitData:RemoveBuff(arg1_79)
	end
end

function var0_0.GetTalentList(arg0_80)
	return arg0_80.benefitData:GetListByType(NewEducateBuff.TYPE.TALENT)
end

function var0_0.GetTalent(arg0_81, arg1_81)
	return arg0_81.benefitData:GetBuff(arg1_81)
end

function var0_0.GetStatusList(arg0_82)
	return arg0_82.benefitData:GetListByType(NewEducateBuff.TYPE.STATUS)
end

function var0_0.GetStatus(arg0_83, arg1_83)
	return arg0_83.benefitData:GetBuff(arg1_83)
end

function var0_0.GetGoodsDiscountInfos(arg0_84)
	return arg0_84.benefitData:GetGoodsDiscountInfos(arg0_84)
end

function var0_0.GetPlanDiscountInfos(arg0_85)
	return arg0_85.benefitData:GetPlanDiscountInfos(arg0_85)
end

function var0_0.IsUnlock(arg0_86, arg1_86)
	local var0_86 = underscore.detect(arg0_86:getConfig("unlock"), function(arg0_87)
		return arg0_87[1] == arg1_86
	end)

	return (var0_86 and var0_86[2] or 1) <= arg0_86.roundData.round
end

function var0_0.GetOwnCnt(arg0_88, arg1_88)
	return switch(arg1_88.type, {
		[NewEducateConst.DROP_TYPE.ATTR] = function()
			return arg0_88:GetAttr(arg1_88.id)
		end,
		[NewEducateConst.DROP_TYPE.RES] = function()
			return arg0_88:GetRes(arg1_88.id)
		end,
		[NewEducateConst.DROP_TYPE.BUFF] = function()
			return arg0_88.benefitData:ExistBuff(arg1_88.id) and 1 or 0
		end
	})
end

function var0_0.IsMatch(arg0_92, arg1_92)
	return compareNumber(arg0_92:GetOwnCnt(arg1_92), arg1_92.operator, arg1_92.number)
end

function var0_0.IsMatchs(arg0_93, arg1_93)
	return underscore.all(arg1_93, function(arg0_94)
		return arg0_93:IsMatch(arg0_94)
	end)
end

function var0_0.IsMatchCondition(arg0_95, arg1_95)
	local var0_95 = pg.child2_condition[arg1_95]

	return (switch(var0_95.type, {
		[NewEducateConst.CONDITION_TYPE.DROP] = function()
			local var0_96 = {
				type = var0_95.param[1],
				id = var0_95.param[2],
				number = var0_95.param[4]
			}

			return compareNumber(arg0_95:GetOwnCnt(var0_96), var0_95.param[3], var0_95.param[4])
		end,
		[NewEducateConst.CONDITION_TYPE.ATTR_SUM] = function()
			return compareNumber(arg0_95:GetAttrSum(), var0_95.param[1], var0_95.param[2])
		end,
		[NewEducateConst.CONDITION_TYPE.EVENT_SITE_CNT] = function()
			return compareNumber(arg0_95:GetEventCnt(var0_95.param[1]), var0_95.param[2], var0_95.param[3])
		end,
		[NewEducateConst.CONDITION_TYPE.ROUND] = function()
			return compareNumber(arg0_95.roundData.round, var0_95.param[1], var0_95.param[2])
		end,
		[NewEducateConst.CONDITION_TYPE.NORMAL_SITE_CNT] = function()
			local var0_100 = underscore.reduce(var0_95.param[1], 0, function(arg0_101, arg1_101)
				return arg0_101 + arg0_95:GetNormalCnt(arg1_101)
			end)

			return compareNumber(var0_100, var0_95.param[2], var0_95.param[3])
		end
	}, function()
		assert(false, "非法condition type" .. var0_95.type)
	end))
end

function var0_0.LogicalOperator(arg0_103, arg1_103)
	if type(arg1_103) == "number" then
		return arg0_103:IsMatchCondition(arg1_103)
	end

	local var0_103 = arg1_103.operator

	if var0_103 == "||" then
		if arg1_103.conditions.operator then
			return underscore.any(arg1_103.conditions, function(arg0_104)
				return arg0_103:LogicalOperator(arg0_104)
			end)
		else
			return underscore.any(arg1_103.conditions, function(arg0_105)
				return arg0_103:IsMatchCondition(arg0_105)
			end)
		end
	elseif var0_103 == "&&" then
		if arg1_103.conditions.operator then
			return underscore.all(arg1_103.conditions, function(arg0_106)
				return arg0_103:LogicalOperator(arg0_106)
			end)
		else
			return underscore.all(arg1_103.conditions, function(arg0_107)
				return arg0_103:IsMatchCondition(arg0_107)
			end)
		end
	end
end

function var0_0.IsFormatCondition(arg0_108, arg1_108)
	return (arg1_108[1] == "||" or arg1_108[1] == "&&") and type(arg1_108[2]) == "table" and type(arg1_108[2][1]) == "number"
end

function var0_0.GetFormatCondition(arg0_109, arg1_109)
	if type(arg1_109) == "number" then
		return arg1_109
	end

	if arg0_109:IsFormatCondition(arg1_109) then
		return {
			operator = arg1_109[1],
			conditions = arg1_109[2]
		}
	elseif arg0_109:IsFormatCondition(arg1_109[2]) then
		return {
			operator = arg1_109[1],
			conditions = underscore.map(arg1_109[2], function(arg0_110)
				arg0_109:GetFormatCondition(arg0_110)
			end)
		}
	end
end

function var0_0.IsMatchComplex(arg0_111, arg1_111)
	if #arg1_111 == 0 then
		return true
	end

	return arg0_111:LogicalOperator(arg0_111:GetFormatCondition(arg1_111))
end

function var0_0.GetConditionIdsFromComplex(arg0_112, arg1_112)
	if type(arg1_112) == "number" then
		return {
			arg1_112
		}
	end

	if type(arg1_112) == "table" and #arg1_112 == 0 then
		return arg1_112
	end

	if arg0_112:IsFormatCondition(arg1_112) then
		return arg1_112[2]
	elseif arg0_112:IsFormatCondition(arg1_112[2]) then
		return underscore.map(arg1_112[2], function(arg0_113)
			arg0_112:GetConditionIdsFromComplex(arg0_113)
		end)
	end
end

return var0_0
