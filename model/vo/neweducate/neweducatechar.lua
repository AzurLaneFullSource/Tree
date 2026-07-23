local var0_0 = class("NewEducateChar", import("model.vo.BaseVO"))

var0_0.RES_TYPE = {
	REFRESH_SHOP = 5,
	MONEY = 1,
	ACTION = 3,
	MOOD = 2,
	FAVOR = 4,
	REFRESH_CHOICE = 6
}
var0_0.ATTR_TYPE = {
	ATTR = 1,
	PERSONALITY = 2
}
var0_0.DIFFICULTY = {
	EASY = 0,
	HARD = 1
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_data
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.difficulty = arg1_2.difficulty or var0_0.DIFFICULTY.EASY
	arg0_2.roundData = NewEducateRound.New(arg1_2)

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
	arg0_2.benefitData = NewEducateBenefit.New(arg1_2.benefit, arg1_2.display)

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
	arg0_7.fsm = NewEducateStateMgr.New(arg0_7.id, arg1_7)
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
			arg0_8.normalType2Id[iter3_8] = underscore.detect(var1_8 or {}, function(arg0_9)
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
		progressStr = arg0_10.roundData:IsEndless() and i18n("child2_game_endless_cnt", arg0_10.roundData:GetWave()) or i18n("child2_cur_round", arg0_10.roundData.round),
		isHard = arg0_10.difficulty == var0_0.DIFFICULTY.HARD,
		isEndless = arg0_10.roundData:IsEndless()
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
				arg0_14.siteIdMap[iter1_14] = {}

				underscore.each(var0_14, function(arg0_18)
					if pg.child2_site_display[arg0_18].character == arg0_14.id then
						table.insert(arg0_14.siteIdMap[iter1_14], arg0_18)
					end
				end)
			end,
			[NewEducateConst.SITE_TYPE.WORK] = function()
				arg0_14.siteIdMap[iter1_14] = {}

				underscore.each(var0_14, function(arg0_20)
					if pg.child2_site_display[arg0_20].character == arg0_14.id then
						table.insert(arg0_14.siteIdMap[iter1_14], arg0_20)
					end
				end)
			end,
			[NewEducateConst.SITE_TYPE.TRAVEL] = function()
				arg0_14.siteIdMap[iter1_14] = {}

				underscore.each(var0_14, function(arg0_22)
					if pg.child2_site_display[arg0_22].character == arg0_14.id then
						table.insert(arg0_14.siteIdMap[iter1_14], arg0_22)
					end
				end)
			end,
			[NewEducateConst.SITE_TYPE.EVENT] = function()
				underscore.each(var0_14, function(arg0_24)
					local var0_24 = pg.child2_site_display[arg0_24].param

					arg0_14.siteIdMap[iter1_14][var0_24] = arg0_24
				end)
			end
		})
	end
end

function var0_0.GetSiteId(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg2_25 or 1

	return arg0_25.siteIdMap[arg1_25][var0_25]
end

function var0_0.GetNormalIdByType(arg0_26, arg1_26)
	return arg0_26.normalType2Id[arg1_26]
end

function var0_0.UpdateNormalType2Id(arg0_27, arg1_27, arg2_27)
	arg0_27.normalType2Id[arg1_27] = arg2_27
end

function var0_0.AddNormalRecord(arg0_28, arg1_28)
	arg0_28.normalRecords[arg1_28] = (arg0_28.normalRecords[arg1_28] or 0) + 1
end

function var0_0.GetNormalCnt(arg0_29, arg1_29)
	return arg0_29.normalRecords[arg1_29] or 0
end

function var0_0.AddEventRecord(arg0_30, arg1_30)
	arg0_30.eventRecords[arg1_30] = (arg0_30.eventRecords[arg1_30] or 0) + 1
end

function var0_0.GetEventCnt(arg0_31, arg1_31)
	return arg0_31.eventRecords[arg1_31] or 0
end

function var0_0.SetShipIds(arg0_32, arg1_32)
	arg0_32.siteShips = arg1_32
end

function var0_0.GetShipIds(arg0_33)
	return arg0_33.siteShips
end

function var0_0.UpdateShipId(arg0_34, arg1_34, arg2_34)
	table.removebyvalue(arg0_34.siteShips, arg1_34)
	table.insert(arg0_34.siteShips, arg2_34)
end

function var0_0.AddAssessRecord(arg0_35, arg1_35, arg2_35)
	arg0_35.assessRecords[arg1_35] = arg2_35
end

function var0_0.GetResources(arg0_36)
	return Clone(arg0_36.resources)
end

function var0_0.SetResources(arg0_37, arg1_37)
	arg0_37.resources = {}

	for iter0_37, iter1_37 in ipairs(arg1_37) do
		arg0_37.resources[iter1_37.key] = iter1_37.value
		arg0_37.resources[iter1_37.key] = math.max(pg.child2_resource[iter1_37.key].min_value, arg0_37.resources[iter1_37.key])
		arg0_37.resources[iter1_37.key] = math.min(pg.child2_resource[iter1_37.key].max_value, arg0_37.resources[iter1_37.key])
	end
end

function var0_0.GetRes(arg0_38, arg1_38)
	return arg0_38.resources[arg1_38] or 0
end

function var0_0.GetPoint(arg0_39)
	return arg0_39:GetResByType(var0_0.RES_TYPE.ACTION)
end

function var0_0.GetResByType(arg0_40, arg1_40)
	return arg0_40.resources[arg0_40:GetResIdByType(arg1_40)] or 0
end

function var0_0.GetResIdByType(arg0_41, arg1_41)
	return underscore.detect(underscore.keys(arg0_41.resources), function(arg0_42)
		return pg.child2_resource[arg0_42].type == arg1_41
	end)
end

function var0_0.UpdateRes(arg0_43, arg1_43, arg2_43)
	if not arg0_43.resources[arg1_43] then
		warning("不符合当前角色的资源更新！！！")

		arg0_43.resources[arg1_43] = 0
	end

	arg0_43.resources[arg1_43] = arg0_43.resources[arg1_43] + arg2_43
	arg0_43.resources[arg1_43] = math.max(pg.child2_resource[arg1_43].min_value, arg0_43.resources[arg1_43])
	arg0_43.resources[arg1_43] = math.min(pg.child2_resource[arg1_43].max_value, arg0_43.resources[arg1_43])
end

function var0_0.GetMoodStage(arg0_44, arg1_44)
	local var0_44 = pg.gameset.child_emotion.description
	local var1_44 = arg1_44 or arg0_44:GetResByType(var0_0.RES_TYPE.MOOD)

	if var1_44 <= var0_44[1][1][1] then
		return 1, var0_44[1][2]
	end

	if var1_44 >= var0_44[#var0_44][1][2] then
		return #var0_44, var0_44[#var0_44][2]
	end

	for iter0_44, iter1_44 in ipairs(var0_44) do
		if var1_44 >= iter1_44[1][1] and var1_44 < iter1_44[1][2] then
			return iter0_44, iter1_44[2]
		end
	end
end

function var0_0.UpgradeFavor(arg0_45)
	arg0_45.gotFavorLv = arg0_45.gotFavorLv + 1
end

function var0_0.CheckFavor(arg0_46)
	local var0_46 = arg0_46:GetFavorInfo()
	local var1_46 = arg0_46:getConfig("favor_exp")[var0_46.lv]

	if not var1_46 then
		return false
	end

	return var1_46 <= var0_46.value
end

function var0_0.GetFavorInfo(arg0_47)
	local var0_47 = arg0_47:GetResByType(var0_0.RES_TYPE.FAVOR)
	local var1_47 = math.min(arg0_47.gotFavorLv + 1, arg0_47:getConfig("favor_level"))
	local var2_47 = 0

	if arg0_47.gotFavorLv > 0 then
		for iter0_47 = 1, arg0_47.gotFavorLv do
			var2_47 = var2_47 + arg0_47:getConfig("favor_exp")[iter0_47]
		end
	end

	return {
		lv = var1_47,
		value = var0_47 - var2_47
	}
end

function var0_0.GetAttrs(arg0_48)
	return Clone(arg0_48.attrs)
end

function var0_0.SetAttrs(arg0_49, arg1_49)
	arg0_49.attrs = {}

	for iter0_49, iter1_49 in ipairs(arg1_49) do
		arg0_49.attrs[iter1_49.key] = iter1_49.value
		arg0_49.attrs[iter1_49.key] = math.max(pg.child2_attr[iter1_49.key].min_value, arg0_49.attrs[iter1_49.key])
		arg0_49.attrs[iter1_49.key] = math.min(pg.child2_attr[iter1_49.key].max_value, arg0_49.attrs[iter1_49.key])
	end
end

function var0_0.GetAttr(arg0_50, arg1_50)
	return arg0_50.attrs[arg1_50]
end

function var0_0.GetAttrIds(arg0_51)
	local var0_51 = underscore.select(underscore.keys(arg0_51.attrs), function(arg0_52)
		return pg.child2_attr[arg0_52].type == var0_0.ATTR_TYPE.ATTR
	end)

	table.sort(var0_51)

	return var0_51
end

function var0_0.GetAttrSum(arg0_53)
	return underscore.reduce(arg0_53:GetAttrIds(), 0, function(arg0_54, arg1_54)
		return arg0_54 + arg0_53.attrs[arg1_54]
	end)
end

function var0_0.GetPersonalityId(arg0_55)
	return underscore.detect(underscore.keys(arg0_55.attrs), function(arg0_56)
		return pg.child2_attr[arg0_56].type == var0_0.ATTR_TYPE.PERSONALITY
	end)
end

function var0_0.GetPersonality(arg0_57)
	return arg0_57.attrs[arg0_57:GetPersonalityId()]
end

function var0_0.GetPersonalityMiddle(arg0_58)
	local var0_58 = arg0_58:GetPersonalityId()
	local var1_58 = pg.child2_attr[var0_58]

	return math.floor((var1_58.min_value + var1_58.max_value) / 2)
end

function var0_0.GetPersonalityTag(arg0_59, arg1_59)
	local var0_59 = arg1_59 or arg0_59:GetPersonality()

	return (switch(arg0_59:getConfig("personality_type"), {
		function()
			for iter0_60, iter1_60 in ipairs(arg0_59:getConfig("personality_param")) do
				if var0_59 >= iter1_60[2][1] and var0_59 <= iter1_60[2][2] then
					return iter1_60[1]
				end
			end

			return arg0_59:getConfig("personality_param")[1][1]
		end
	}, function()
		assert(false, "不合法的personality_type")
	end))
end

function var0_0.GetPersonalityTagTip(arg0_62, arg1_62)
	return i18n("child2_personal_id" .. arg0_62.id .. "_tag" .. arg1_62)
end

function var0_0.GetPersonalityTagOptionBg(arg0_63, arg1_63)
	local var0_63 = arg0_63:getConfig("personality_tag_icon")

	return underscore.detect(var0_63, function(arg0_64)
		return arg0_64[1] == "tag" .. arg1_63
	end)[3]
end

function var0_0.UpdateAttr(arg0_65, arg1_65, arg2_65)
	if not arg0_65.attrs[arg1_65] then
		warning("不符合当前角色的属性更新！！！")

		arg0_65.attrs[arg1_65] = 0
	end

	arg0_65.attrs[arg1_65] = arg0_65.attrs[arg1_65] + arg2_65
	arg0_65.attrs[arg1_65] = math.max(pg.child2_attr[arg1_65].min_value, arg0_65.attrs[arg1_65])
	arg0_65.attrs[arg1_65] = math.min(pg.child2_attr[arg1_65].max_value, arg0_65.attrs[arg1_65])
end

function var0_0.GetAssessRankIdx(arg0_66)
	local var0_66 = arg0_66.roundData:getConfig("target_id")

	if var0_66 == 0 or arg0_66.roundData:IsTemp() then
		return 0
	end

	local var1_66 = arg0_66.roundData:GetExtraFactor()
	local var2_66 = arg0_66:GetAttrSum()
	local var3_66 = pg.child2_target[var0_66].attr_sum_level

	for iter0_66 = #var3_66, 1, -1 do
		if var2_66 >= var3_66[iter0_66] * var1_66 then
			return iter0_66
		end
	end

	return #var3_66
end

function var0_0.GetAssessPreStory(arg0_67)
	local var0_67 = arg0_67.roundData:getConfig("target_id")

	if var0_67 == 0 then
		return nil
	end

	return pg.child2_target[var0_67].pre_perform
end

function var0_0.GetRoundData(arg0_68)
	return arg0_68.roundData
end

function var0_0.GetFSM(arg0_69)
	return arg0_69.fsm
end

function var0_0.GetBgm(arg0_70)
	local var0_70 = arg0_70:GetPersonalityTag()

	return underscore.detect(arg0_70:getConfig("bgm"), function(arg0_71)
		return arg0_71[1] == var0_70
	end)[2]
end

function var0_0.GetPaintingName(arg0_72)
	local var0_72 = arg0_72:GetPersonalityTag()

	return underscore.detect(arg0_72.roundData:getConfig("main_painting"), function(arg0_73)
		return arg0_73[1] == var0_72
	end)[2]
end

function var0_0.GetBGName(arg0_74)
	return arg0_74.roundData:getConfig("main_background")
end

function var0_0.GetMainDialogueInfo(arg0_75)
	local var0_75 = arg0_75:GetPersonalityTag()
	local var1_75 = underscore.detect(arg0_75.roundData:getConfig("main_word"), function(arg0_76)
		return arg0_76[1] == var0_75
	end)
	local var2_75 = underscore.detect(arg0_75.roundData:getConfig("main_word_expression"), function(arg0_77)
		return arg0_77[1] == var0_75
	end)

	return var1_75[2], var2_75[2]
end

function var0_0.OnUpgradedPlan(arg0_78, arg1_78)
	local var0_78 = pg.child2_plan[arg1_78].group_id

	arg0_78.group2Plan[var0_78] = arg1_78
end

function var0_0.GetPlanList(arg0_79)
	local var0_79 = {}
	local var1_79 = arg0_79.roundData:getConfig("plan_group")

	for iter0_79, iter1_79 in ipairs(var1_79) do
		local var2_79 = pg.child2_plan.get_id_list_by_group_id[iter1_79]

		if #var2_79 == 1 then
			table.insert(var0_79, NewEducatePlan.New(var2_79[1]))
		elseif arg0_79.group2Plan[iter1_79] then
			table.insert(var0_79, NewEducatePlan.New(arg0_79.group2Plan[iter1_79]))
		else
			table.sort(var2_79, function(arg0_80, arg1_80)
				return pg.child2_plan[arg0_80].level < pg.child2_plan[arg1_80].level
			end)
			table.insert(var0_79, NewEducatePlan.New(var2_79[1]))
		end
	end

	for iter2_79, iter3_79 in ipairs(arg0_79.benefitData:GetExtraPlan(arg0_79)) do
		table.insert(var0_79, NewEducatePlan.New(iter3_79, true))
	end

	return var0_79
end

function var0_0.OnNextRound(arg0_81)
	arg0_81.siteShips = {}

	arg0_81.fsm:Reset()
	arg0_81.roundData:OnNextRound()

	arg0_81.resources[arg0_81:GetResIdByType(NewEducateChar.RES_TYPE.ACTION)] = arg0_81.roundData:getConfig("map_mobility")

	if arg0_81.resources[arg0_81:GetResIdByType(NewEducateChar.RES_TYPE.REFRESH_SHOP)] then
		arg0_81.resources[arg0_81:GetResIdByType(NewEducateChar.RES_TYPE.REFRESH_SHOP)] = arg0_81.roundData:getConfig("refresh_refill")
	end

	arg0_81.benefitData:OnNextRound(arg0_81.roundData.round)
	arg0_81.permanentData:OnNextRound(arg0_81.roundData.round)
end

function var0_0.GetBenefitData(arg0_82)
	return arg0_82.benefitData
end

function var0_0.AddBuff(arg0_83, arg1_83, arg2_83)
	arg0_83.permanentData:CheckBuffRecord(arg1_83)

	if arg2_83 > 0 then
		local var0_83 = not arg0_83.fsm:IsImmediateBenefit()
		local var1_83 = {
			id = arg1_83,
			round = arg0_83.roundData.round,
			is_pending = var0_83
		}

		arg0_83.benefitData:AddBuff(var1_83)
	else
		arg0_83.benefitData:RemoveBuff(arg1_83)
	end
end

function var0_0.GetTalentList(arg0_84)
	return arg0_84.benefitData:GetListByType(NewEducateBuff.TYPE.TALENT)
end

function var0_0.GetTalent(arg0_85, arg1_85)
	return arg0_85.benefitData:GetBuff(arg1_85)
end

function var0_0.GetStatusList(arg0_86)
	return arg0_86.benefitData:GetListByType(NewEducateBuff.TYPE.STATUS)
end

function var0_0.GetStatus(arg0_87, arg1_87)
	return arg0_87.benefitData:GetBuff(arg1_87)
end

function var0_0.GetTarotId(arg0_88)
	local var0_88 = arg0_88.benefitData:GetListByType(NewEducateBuff.TYPE.TAROT)[1]

	return var0_88 and var0_88.id
end

function var0_0.GetGoodsDiscountInfos(arg0_89)
	return arg0_89.benefitData:GetGoodsDiscountInfos(arg0_89)
end

function var0_0.GetPlanDiscountInfos(arg0_90)
	return arg0_90.benefitData:GetPlanDiscountInfos(arg0_90)
end

function var0_0.IsUnlock(arg0_91, arg1_91)
	local var0_91 = underscore.detect(arg0_91:getConfig("unlock"), function(arg0_92)
		return arg0_92[1] == arg1_91
	end)

	return (var0_91 and var0_91[2] or 1) <= arg0_91.roundData.round
end

function var0_0.GetOwnCnt(arg0_93, arg1_93)
	return switch(arg1_93.type, {
		[NewEducateConst.DROP_TYPE.ATTR] = function()
			return arg0_93:GetAttr(arg1_93.id)
		end,
		[NewEducateConst.DROP_TYPE.RES] = function()
			return arg0_93:GetRes(arg1_93.id)
		end,
		[NewEducateConst.DROP_TYPE.BUFF] = function()
			return arg0_93.benefitData:ExistBuff(arg1_93.id) and 1 or 0
		end
	}, function()
		return 0
	end)
end

function var0_0.IsMatch(arg0_98, arg1_98)
	return compareNumber(arg0_98:GetOwnCnt(arg1_98), arg1_98.operator, arg1_98.number)
end

function var0_0.IsMatchs(arg0_99, arg1_99)
	return underscore.all(arg1_99, function(arg0_100)
		return arg0_99:IsMatch(arg0_100)
	end)
end

function var0_0.IsMatchCondition(arg0_101, arg1_101)
	local var0_101 = pg.child2_condition[arg1_101]

	return (switch(var0_101.type, {
		[NewEducateConst.CONDITION_TYPE.DROP] = function()
			local var0_102 = {
				type = var0_101.param[1],
				id = var0_101.param[2],
				number = var0_101.param[4]
			}

			return compareNumber(arg0_101:GetOwnCnt(var0_102), var0_101.param[3], var0_101.param[4])
		end,
		[NewEducateConst.CONDITION_TYPE.ATTR_SUM] = function()
			return compareNumber(arg0_101:GetAttrSum(), var0_101.param[1], var0_101.param[2])
		end,
		[NewEducateConst.CONDITION_TYPE.EVENT_SITE_CNT] = function()
			return compareNumber(arg0_101:GetEventCnt(var0_101.param[1]), var0_101.param[2], var0_101.param[3])
		end,
		[NewEducateConst.CONDITION_TYPE.ROUND] = function()
			return compareNumber(arg0_101.roundData.round, var0_101.param[1], var0_101.param[2])
		end,
		[NewEducateConst.CONDITION_TYPE.NORMAL_SITE_CNT] = function()
			local var0_106 = underscore.reduce(var0_101.param[1], 0, function(arg0_107, arg1_107)
				return arg0_107 + arg0_101:GetNormalCnt(arg1_107)
			end)

			return compareNumber(var0_106, var0_101.param[2], var0_101.param[3])
		end
	}, function()
		assert(false, "非法condition type" .. var0_101.type)
	end))
end

function var0_0.LogicalOperator(arg0_109, arg1_109)
	if type(arg1_109) == "number" then
		return arg0_109:IsMatchCondition(arg1_109)
	end

	local var0_109 = arg1_109.operator

	if var0_109 == "||" then
		if arg1_109.conditions.operator then
			return underscore.any(arg1_109.conditions, function(arg0_110)
				return arg0_109:LogicalOperator(arg0_110)
			end)
		else
			return underscore.any(arg1_109.conditions, function(arg0_111)
				return arg0_109:IsMatchCondition(arg0_111)
			end)
		end
	elseif var0_109 == "&&" then
		if arg1_109.conditions.operator then
			return underscore.all(arg1_109.conditions, function(arg0_112)
				return arg0_109:LogicalOperator(arg0_112)
			end)
		else
			return underscore.all(arg1_109.conditions, function(arg0_113)
				return arg0_109:IsMatchCondition(arg0_113)
			end)
		end
	end
end

function var0_0.IsFormatCondition(arg0_114, arg1_114)
	return (arg1_114[1] == "||" or arg1_114[1] == "&&") and type(arg1_114[2]) == "table" and type(arg1_114[2][1]) == "number"
end

function var0_0.GetFormatCondition(arg0_115, arg1_115)
	if type(arg1_115) == "number" then
		return arg1_115
	end

	if arg0_115:IsFormatCondition(arg1_115) then
		return {
			operator = arg1_115[1],
			conditions = arg1_115[2]
		}
	elseif arg0_115:IsFormatCondition(arg1_115[2]) then
		return {
			operator = arg1_115[1],
			conditions = underscore.map(arg1_115[2], function(arg0_116)
				arg0_115:GetFormatCondition(arg0_116)
			end)
		}
	end
end

function var0_0.IsMatchComplex(arg0_117, arg1_117)
	if #arg1_117 == 0 then
		return true
	end

	return arg0_117:LogicalOperator(arg0_117:GetFormatCondition(arg1_117))
end

function var0_0.GetConditionIdsFromComplex(arg0_118, arg1_118)
	if type(arg1_118) == "number" then
		return {
			arg1_118
		}
	end

	if type(arg1_118) == "table" and #arg1_118 == 0 then
		return arg1_118
	end

	if arg0_118:IsFormatCondition(arg1_118) then
		return arg1_118[2]
	elseif arg0_118:IsFormatCondition(arg1_118[2]) then
		return underscore.map(arg1_118[2], function(arg0_119)
			arg0_118:GetConditionIdsFromComplex(arg0_119)
		end)
	end
end

return var0_0
