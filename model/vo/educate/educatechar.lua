local var0_0 = class("EducateChar", import("model.vo.BaseVO"))

var0_0.ATTR_TYPE_MAJOR = 1
var0_0.ATTR_TYPE_PERSONALITY = 2
var0_0.ATTR_TYPE_MINOR = 3
var0_0.RES_MONEY_ID = 1
var0_0.RES_MOOD_ID = 2
var0_0.RES_SITE_ID = 3
var0_0.RES_FAVOR_ID = 4
var0_0.RES_ID_2_NAME = {
	[var0_0.RES_MONEY_ID] = "money",
	[var0_0.RES_MOOD_ID] = "mood",
	[var0_0.RES_SITE_ID] = "site",
	[var0_0.RES_FAVOR_ID] = "favor"
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child_data
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.tid or 1
	arg0_2.configId = arg0_2.id

	arg0_2:checkCfg()
	arg0_2:initStageCfg()
	arg0_2:initFavorCfg()

	arg0_2.curTime = arg1_2.cur_time or {
		week = 4,
		month = 2,
		day = 7
	}
	arg0_2.stage = arg0_2:GetStageByTime(arg0_2.curTime)
	arg0_2.mood = arg1_2.mood or pg.child_resource[var0_0.RES_MOOD_ID].default_value
	arg0_2.money = arg1_2.money or pg.child_resource[var0_0.RES_MONEY_ID].default_value
	arg0_2.site = arg1_2.site_number or arg0_2:GetSiteCnt()
	arg0_2.favor = arg1_2.favor or {
		lv = 1,
		exp = 0
	}
	arg0_2.attrs = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.attrs) do
		arg0_2.attrs[iter1_2.id] = iter1_2.val
	end

	arg0_2.isAddedExtraAttr = arg1_2.had_adjustment == 1 or false
	arg0_2.addExtraAttrTime = EducateHelper.GetTimeFromCfg(pg.gameset.child_attr_2_add.description)
	arg0_2.callName = arg1_2.user_name or ""

	arg0_2:UpdateMainInfo()
end

function var0_0.checkCfg(arg0_3)
	assert(#arg0_3:getConfig("char_prefab") == #arg0_3:getConfig("main_word") and #arg0_3:getConfig("main_word") == #arg0_3:getConfig("word_expression"), "主界面立绘展示/台词/差分数量不一致，请检查相关配置")
end

function var0_0.initStageCfg(arg0_4)
	arg0_4.stage2timeRange = {}

	for iter0_4, iter1_4 in ipairs(arg0_4:getConfig("stage")) do
		arg0_4.stage2timeRange[iter0_4] = {
			EducateHelper.CfgTime2Time(iter1_4)
		}
	end
end

function var0_0.GetStageByTime(arg0_5, arg1_5)
	arg0_5.time2stage = {}

	for iter0_5, iter1_5 in pairs(arg0_5.stage2timeRange) do
		if EducateHelper.InTime(arg1_5, iter1_5[1], iter1_5[2]) then
			return iter0_5
		end
	end

	return 1
end

function var0_0.initFavorCfg(arg0_6)
	arg0_6.favorLv2NeedExp = {}
	arg0_6.favorLv2PerformIds = {}
	arg0_6.favorReplaceCfg = {}
	arg0_6.favorMaxLv = arg0_6:getConfig("favor_level")

	for iter0_6, iter1_6 in ipairs(arg0_6:getConfig("favor_exp")) do
		arg0_6.favorLv2NeedExp[iter0_6] = iter1_6
		arg0_6.favorLv2PerformIds[iter0_6] = arg0_6:getConfig("trigger_performance")[iter0_6]
	end

	for iter2_6, iter3_6 in ipairs(arg0_6:getConfig("trigger_performance_replace")) do
		arg0_6.favorReplaceCfg[iter3_6[1]] = iter3_6[2]
	end
end

function var0_0.SetCallName(arg0_7, arg1_7)
	arg0_7.callName = arg1_7
end

function var0_0.GetCallName(arg0_8)
	return arg0_8.callName
end

function var0_0.GetName(arg0_9)
	return arg0_9:getConfig("name")
end

function var0_0.GetStage(arg0_10)
	return arg0_10.stage
end

function var0_0.GetNextWeekStage(arg0_11)
	local var0_11 = EducateHelper.GetTimeAfterWeeks(arg0_11.curTime, 1)

	return arg0_11:GetStageByTime(var0_11) or 1
end

function var0_0.GetPlanCnt(arg0_12)
	return arg0_12:getConfig("stage_plan_number")[arg0_12.stage]
end

function var0_0.GetNextWeekPlanCnt(arg0_13)
	return arg0_13:getConfig("stage_plan_number")[arg0_13:GetNextWeekStage()]
end

function var0_0.GetSiteCnt(arg0_14)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0_14:getConfig("stage_site_number")[arg0_14.stage]
	else
		return arg0_14:getConfig("stage_site_number")[arg0_14.stage + 1]
	end
end

function var0_0.GetStageReaminWeek(arg0_15, arg1_15)
	return (arg0_15:getConfig("stage")[arg1_15][2][1] + 1 - arg0_15.curTime.month) * 4 - arg0_15.curTime.week
end

function var0_0.GetAttrIdsByType(arg0_16, arg1_16)
	if arg1_16 == var0_0.ATTR_TYPE_MAJOR then
		return arg0_16:getConfig("attr_1_list")
	end

	if arg1_16 == var0_0.ATTR_TYPE_PERSONALITY then
		return arg0_16:getConfig("attr_2_list")
	end

	if arg1_16 == var0_0.ATTR_TYPE_MINOR then
		return arg0_16:getConfig("attr_3_list")
	end

	return {}
end

function var0_0.GetAttrTypeById(arg0_17, arg1_17)
	if table.contains(arg0_17:getConfig("attr_1_list"), arg1_17) then
		return var0_0.ATTR_TYPE_MAJOR
	end

	if table.contains(arg0_17:getConfig("attr_2_list"), arg1_17) then
		return var0_0.ATTR_TYPE_PERSONALITY
	end

	if table.contains(arg0_17:getConfig("attr_3_list"), arg1_17) then
		return var0_0.ATTR_TYPE_MINOR
	end

	assert(false, "not exist attr id:" .. arg1_17)
end

function var0_0.IsPersonalityAttr(arg0_18, arg1_18)
	return table.contains(arg0_18:getConfig("attr_2_list"), arg1_18)
end

function var0_0.GetAttrGroupByType(arg0_19, arg1_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in pairs(arg0_19.attrs) do
		if pg.child_attr[iter0_19].type == arg1_19 then
			table.insert(var0_19, {
				iter0_19,
				iter1_19
			})
		end
	end

	table.sort(var0_19, CompareFuncs({
		function(arg0_20)
			return arg0_20[1]
		end
	}))

	return var0_19
end

function var0_0.GetAttrSortIds(arg0_21)
	local var0_21 = table.mergeArray(arg0_21:getConfig("attr_1_list"), arg0_21:getConfig("attr_2_list"))
	local var1_21 = table.mergeArray(var0_21, arg0_21:getConfig("attr_3_list"))

	table.sort(var1_21, CompareFuncs({
		function(arg0_22)
			return -arg0_21:GetAttrById(arg0_22)
		end,
		function(arg0_23)
			return arg0_23
		end
	}))

	return var1_21
end

function var0_0.GetAttrById(arg0_24, arg1_24)
	return arg0_24.attrs[arg1_24] or 0
end

function var0_0.GetAttrInfo(arg0_25, arg1_25)
	local var0_25 = pg.child_attr[arg1_25].rank
	local var1_25 = arg0_25.attrs[arg1_25]

	for iter0_25, iter1_25 in ipairs(var0_25) do
		if var1_25 >= iter1_25[1][1] and var1_25 < iter1_25[1][2] then
			return iter1_25[2], var1_25 .. "/" .. iter1_25[1][2]
		end
	end

	return var0_25[#var0_25][2], var1_25 .. "/" .. var0_25[#var0_25][1][2]
end

function var0_0.UpdateAttr(arg0_26, arg1_26, arg2_26)
	assert(arg0_26.attrs[arg1_26], "not exist attr id: " .. arg1_26)

	arg0_26.attrs[arg1_26] = arg0_26.attrs[arg1_26] + arg2_26
end

function var0_0.GetPersonalityId(arg0_27)
	local var0_27 = arg0_27:getConfig("attr_2_list")
	local var1_27 = var0_27[1]

	for iter0_27, iter1_27 in ipairs(var0_27) do
		if arg0_27.attrs[iter1_27] > arg0_27.attrs[var1_27] then
			var1_27 = iter1_27
		end
	end

	return var1_27
end

function var0_0.CheckExtraAttrAdd(arg0_28)
	return not arg0_28.isAddedExtraAttr and EducateHelper.IsSameDay(arg0_28.addExtraAttrTime, arg0_28.curTime)
end

function var0_0.SetIsAddedExtraAttr(arg0_29, arg1_29)
	arg0_29.isAddedExtraAttr = arg1_29
end

function var0_0.GetResById(arg0_30, arg1_30)
	return arg0_30[var0_0.RES_ID_2_NAME[arg1_30]]
end

function var0_0.UpdateRes(arg0_31, arg1_31, arg2_31)
	if arg1_31 ~= var0_0.RES_FAVOR_ID then
		arg0_31[var0_0.RES_ID_2_NAME[arg1_31]] = arg0_31[var0_0.RES_ID_2_NAME[arg1_31]] + arg2_31
		arg0_31[var0_0.RES_ID_2_NAME[arg1_31]] = math.max(pg.child_resource[arg1_31].min_value, arg0_31[var0_0.RES_ID_2_NAME[arg1_31]])
		arg0_31[var0_0.RES_ID_2_NAME[arg1_31]] = math.min(pg.child_resource[arg1_31].max_value, arg0_31[var0_0.RES_ID_2_NAME[arg1_31]])
	else
		arg0_31.favor.exp = arg0_31.favor.exp + arg2_31
	end
end

function var0_0.GetFavor(arg0_32)
	return arg0_32.favor
end

function var0_0.GetFavorMaxLv(arg0_33)
	return arg0_33.favorMaxLv
end

function var0_0.GetFavorUpgradExp(arg0_34, arg1_34)
	return arg0_34.favorLv2NeedExp[arg1_34] or 999999
end

function var0_0.GetFavorUpgradPerformIds(arg0_35, arg1_35)
	return arg0_35:GetPerformByReplace(arg1_35) or {}
end

function var0_0.GetPerformByReplace(arg0_36, arg1_36)
	if arg0_36.favorReplaceCfg[arg1_36] then
		local var0_36 = arg0_36:GetPersonalityId()

		for iter0_36, iter1_36 in ipairs(arg0_36.favorReplaceCfg[arg1_36]) do
			if iter1_36[1] == 1 and var0_36 == iter1_36[2] then
				return iter1_36[3]
			end
		end
	end

	return arg0_36.favorLv2PerformIds[arg1_36]
end

function var0_0.CheckFavor(arg0_37)
	if arg0_37.favor.lv >= arg0_37:GetFavorMaxLv() then
		return false
	end

	return arg0_37.favor.exp >= arg0_37:GetFavorUpgradExp(arg0_37.favor.lv)
end

function var0_0.UpgradeFavor(arg0_38)
	local var0_38 = arg0_38:GetFavorUpgradExp(arg0_38.favor.lv)

	arg0_38.favor.lv = arg0_38.favor.lv + 1
	arg0_38.favor.exp = arg0_38.favor.exp - var0_38
end

function var0_0.GetFavorPerformIds(arg0_39)
	return arg0_39:GetFavorUpgradPerformIds(arg0_39.favor.lv)
end

function var0_0.GetMoodStage(arg0_40)
	local var0_40 = pg.gameset.child_emotion.description

	if arg0_40.mood <= var0_40[1][1][1] then
		return 1
	end

	if arg0_40.mood >= var0_40[#var0_40][1][2] then
		return #var0_40
	end

	for iter0_40, iter1_40 in ipairs(var0_40) do
		if arg0_40.mood >= iter1_40[1][1] and arg0_40.mood <= iter1_40[1][2] then
			return iter0_40
		end
	end
end

function var0_0.CheckEndCondition(arg0_41, arg1_41)
	local var0_41 = arg0_41:GetPersonalityId()
	local var1_41 = true

	for iter0_41, iter1_41 in ipairs(arg1_41) do
		local var2_41 = iter1_41[1]

		if var2_41 == EducateConst.DROP_TYPE_ATTR then
			if not iter1_41[3] then
				if var0_41 ~= iter1_41[2] then
					return false
				end
			elseif arg0_41.attrs[iter1_41[2]] < iter1_41[3] then
				return false
			end
		elseif var2_41 == EducateConst.DROP_TYPE_RES and arg0_41[var0_0.RES_ID_2_NAME[iter1_41[2]]] < iter1_41[3] then
			return false
		end
	end

	return true
end

function var0_0.getCurMainIndex(arg0_42, arg1_42)
	local var0_42 = arg1_42 or arg0_42.curTime
	local var1_42 = arg0_42:GetPersonalityId()

	for iter0_42, iter1_42 in ipairs(arg0_42:getConfig("char_prefab")) do
		local var2_42, var3_42 = EducateHelper.CfgTime2Time(iter1_42[1])

		if EducateHelper.InTime(var0_42, var2_42, var3_42) then
			if iter1_42[2] == 0 then
				return iter0_42
			elseif iter1_42[2] == var1_42 then
				return iter0_42
			end
		end
	end

	return 1
end

function var0_0.UpdateMainInfo(arg0_43)
	local var0_43 = arg0_43:getCurMainIndex()

	arg0_43.paintingName = arg0_43:getConfig("char_prefab")[var0_43][3]
	arg0_43.mainWordList = arg0_43:getConfig("main_word")[var0_43]
	arg0_43.mainFaceList = arg0_43:getConfig("word_expression")[var0_43]
end

function var0_0.GetBGName(arg0_44)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0_44:getConfig("background_prefab")[arg0_44.stage] or ""
	else
		return arg0_44:getConfig("background_prefab")[arg0_44.stage + 1] or ""
	end
end

function var0_0.getBgmByStage(arg0_45, arg1_45)
	local var0_45 = arg0_45:getConfig("bgm")[arg1_45]

	if type(var0_45) == "string" then
		return var0_45
	elseif type(var0_45) == "table" then
		local var1_45 = arg0_45:GetPersonalityId()

		for iter0_45, iter1_45 in ipairs(var0_45) do
			if iter1_45[1] == var1_45 then
				return iter1_45[2]
			end
		end
	end
end

function var0_0.GetBgm(arg0_46)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0_46:getBgmByStage(arg0_46.stage)
	else
		return arg0_46:getBgmByStage(arg0_46.stage + 1)
	end
end

function var0_0.GetPaintingName(arg0_47)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0_47.paintingName or "tbniang"
	else
		local var0_47, var1_47, var2_47 = arg0_47:GetNextWeekMainInfo()

		return var0_47
	end
end

function var0_0.GetMainDialogueInfo(arg0_48)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0_48.mainWordList, arg0_48.mainFaceList
	else
		local var0_48, var1_48, var2_48 = arg0_48:GetNextWeekMainInfo()

		return var1_48, var2_48
	end
end

function var0_0.GetNextWeekMainInfo(arg0_49)
	local var0_49 = EducateHelper.GetTimeAfterWeeks(arg0_49.curTime, 1)
	local var1_49 = arg0_49:getCurMainIndex(var0_49)

	return arg0_49:getConfig("char_prefab")[var1_49][3], arg0_49:getConfig("main_word")[var1_49], arg0_49:getConfig("word_expression")[var1_49]
end

function var0_0.OnNewWeek(arg0_50, arg1_50)
	arg0_50.curTime = arg1_50
	arg0_50.stage = arg0_50:GetStageByTime(arg0_50.curTime)
	arg0_50.site = arg0_50:GetSiteCnt()

	arg0_50:UpdateMainInfo()
end

return var0_0
