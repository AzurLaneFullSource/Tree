local var0 = class("EducateChar", import("model.vo.BaseVO"))

var0.ATTR_TYPE_MAJOR = 1
var0.ATTR_TYPE_PERSONALITY = 2
var0.ATTR_TYPE_MINOR = 3
var0.RES_MONEY_ID = 1
var0.RES_MOOD_ID = 2
var0.RES_SITE_ID = 3
var0.RES_FAVOR_ID = 4
var0.RES_ID_2_NAME = {
	[var0.RES_MONEY_ID] = "money",
	[var0.RES_MOOD_ID] = "mood",
	[var0.RES_SITE_ID] = "site",
	[var0.RES_FAVOR_ID] = "favor"
}

function var0.bindConfigTable(arg0)
	return pg.child_data
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.tid or 1
	arg0.configId = arg0.id

	arg0:checkCfg()
	arg0:initStageCfg()
	arg0:initFavorCfg()

	arg0.curTime = arg1.cur_time or {
		week = 4,
		month = 2,
		day = 7
	}
	arg0.stage = arg0:GetStageByTime(arg0.curTime)
	arg0.mood = arg1.mood or pg.child_resource[var0.RES_MOOD_ID].default_value
	arg0.money = arg1.money or pg.child_resource[var0.RES_MONEY_ID].default_value
	arg0.site = arg1.site_number or arg0:GetSiteCnt()
	arg0.favor = arg1.favor or {
		lv = 1,
		exp = 0
	}
	arg0.attrs = {}

	for iter0, iter1 in ipairs(arg1.attrs) do
		arg0.attrs[iter1.id] = iter1.val
	end

	arg0.isAddedExtraAttr = arg1.had_adjustment == 1 or false
	arg0.addExtraAttrTime = EducateHelper.GetTimeFromCfg(pg.gameset.child_attr_2_add.description)
	arg0.callName = arg1.user_name or ""

	arg0:UpdateMainInfo()
end

function var0.checkCfg(arg0)
	assert(#arg0:getConfig("char_prefab") == #arg0:getConfig("main_word") and #arg0:getConfig("main_word") == #arg0:getConfig("word_expression"), "主界面立绘展示/台词/差分数量不一致，请检查相关配置")
end

function var0.initStageCfg(arg0)
	arg0.stage2timeRange = {}

	for iter0, iter1 in ipairs(arg0:getConfig("stage")) do
		arg0.stage2timeRange[iter0] = {
			EducateHelper.CfgTime2Time(iter1)
		}
	end
end

function var0.GetStageByTime(arg0, arg1)
	arg0.time2stage = {}

	for iter0, iter1 in pairs(arg0.stage2timeRange) do
		if EducateHelper.InTime(arg1, iter1[1], iter1[2]) then
			return iter0
		end
	end

	return 1
end

function var0.initFavorCfg(arg0)
	arg0.favorLv2NeedExp = {}
	arg0.favorLv2PerformIds = {}
	arg0.favorReplaceCfg = {}
	arg0.favorMaxLv = arg0:getConfig("favor_level")

	for iter0, iter1 in ipairs(arg0:getConfig("favor_exp")) do
		arg0.favorLv2NeedExp[iter0] = iter1
		arg0.favorLv2PerformIds[iter0] = arg0:getConfig("trigger_performance")[iter0]
	end

	for iter2, iter3 in ipairs(arg0:getConfig("trigger_performance_replace")) do
		arg0.favorReplaceCfg[iter3[1]] = iter3[2]
	end
end

function var0.SetCallName(arg0, arg1)
	arg0.callName = arg1
end

function var0.GetCallName(arg0)
	return arg0.callName
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetStage(arg0)
	return arg0.stage
end

function var0.GetNextWeekStage(arg0)
	local var0 = EducateHelper.GetTimeAfterWeeks(arg0.curTime, 1)

	return arg0:GetStageByTime(var0) or 1
end

function var0.GetPlanCnt(arg0)
	return arg0:getConfig("stage_plan_number")[arg0.stage]
end

function var0.GetNextWeekPlanCnt(arg0)
	return arg0:getConfig("stage_plan_number")[arg0:GetNextWeekStage()]
end

function var0.GetSiteCnt(arg0)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0:getConfig("stage_site_number")[arg0.stage]
	else
		return arg0:getConfig("stage_site_number")[arg0.stage + 1]
	end
end

function var0.GetStageReaminWeek(arg0, arg1)
	return (arg0:getConfig("stage")[arg1][2][1] + 1 - arg0.curTime.month) * 4 - arg0.curTime.week
end

function var0.GetAttrIdsByType(arg0, arg1)
	if arg1 == var0.ATTR_TYPE_MAJOR then
		return arg0:getConfig("attr_1_list")
	end

	if arg1 == var0.ATTR_TYPE_PERSONALITY then
		return arg0:getConfig("attr_2_list")
	end

	if arg1 == var0.ATTR_TYPE_MINOR then
		return arg0:getConfig("attr_3_list")
	end

	return {}
end

function var0.GetAttrTypeById(arg0, arg1)
	if table.contains(arg0:getConfig("attr_1_list"), arg1) then
		return var0.ATTR_TYPE_MAJOR
	end

	if table.contains(arg0:getConfig("attr_2_list"), arg1) then
		return var0.ATTR_TYPE_PERSONALITY
	end

	if table.contains(arg0:getConfig("attr_3_list"), arg1) then
		return var0.ATTR_TYPE_MINOR
	end

	assert(false, "not exist attr id:" .. arg1)
end

function var0.IsPersonalityAttr(arg0, arg1)
	return table.contains(arg0:getConfig("attr_2_list"), arg1)
end

function var0.GetAttrGroupByType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.attrs) do
		if pg.child_attr[iter0].type == arg1 then
			table.insert(var0, {
				iter0,
				iter1
			})
		end
	end

	table.sort(var0, CompareFuncs({
		function(arg0)
			return arg0[1]
		end
	}))

	return var0
end

function var0.GetAttrSortIds(arg0)
	local var0 = table.mergeArray(arg0:getConfig("attr_1_list"), arg0:getConfig("attr_2_list"))
	local var1 = table.mergeArray(var0, arg0:getConfig("attr_3_list"))

	table.sort(var1, CompareFuncs({
		function(arg0)
			return -arg0:GetAttrById(arg0)
		end,
		function(arg0)
			return arg0
		end
	}))

	return var1
end

function var0.GetAttrById(arg0, arg1)
	return arg0.attrs[arg1] or 0
end

function var0.GetAttrInfo(arg0, arg1)
	local var0 = pg.child_attr[arg1].rank
	local var1 = arg0.attrs[arg1]

	for iter0, iter1 in ipairs(var0) do
		if var1 >= iter1[1][1] and var1 < iter1[1][2] then
			return iter1[2], var1 .. "/" .. iter1[1][2]
		end
	end

	return var0[#var0][2], var1 .. "/" .. var0[#var0][1][2]
end

function var0.UpdateAttr(arg0, arg1, arg2)
	assert(arg0.attrs[arg1], "not exist attr id: " .. arg1)

	arg0.attrs[arg1] = arg0.attrs[arg1] + arg2
end

function var0.GetPersonalityId(arg0)
	local var0 = arg0:getConfig("attr_2_list")
	local var1 = var0[1]

	for iter0, iter1 in ipairs(var0) do
		if arg0.attrs[iter1] > arg0.attrs[var1] then
			var1 = iter1
		end
	end

	return var1
end

function var0.CheckExtraAttrAdd(arg0)
	return not arg0.isAddedExtraAttr and EducateHelper.IsSameDay(arg0.addExtraAttrTime, arg0.curTime)
end

function var0.SetIsAddedExtraAttr(arg0, arg1)
	arg0.isAddedExtraAttr = arg1
end

function var0.GetResById(arg0, arg1)
	return arg0[var0.RES_ID_2_NAME[arg1]]
end

function var0.UpdateRes(arg0, arg1, arg2)
	if arg1 ~= var0.RES_FAVOR_ID then
		arg0[var0.RES_ID_2_NAME[arg1]] = arg0[var0.RES_ID_2_NAME[arg1]] + arg2
		arg0[var0.RES_ID_2_NAME[arg1]] = math.max(pg.child_resource[arg1].min_value, arg0[var0.RES_ID_2_NAME[arg1]])
		arg0[var0.RES_ID_2_NAME[arg1]] = math.min(pg.child_resource[arg1].max_value, arg0[var0.RES_ID_2_NAME[arg1]])
	else
		arg0.favor.exp = arg0.favor.exp + arg2
	end
end

function var0.GetFavor(arg0)
	return arg0.favor
end

function var0.GetFavorMaxLv(arg0)
	return arg0.favorMaxLv
end

function var0.GetFavorUpgradExp(arg0, arg1)
	return arg0.favorLv2NeedExp[arg1] or 999999
end

function var0.GetFavorUpgradPerformIds(arg0, arg1)
	return arg0:GetPerformByReplace(arg1) or {}
end

function var0.GetPerformByReplace(arg0, arg1)
	if arg0.favorReplaceCfg[arg1] then
		local var0 = arg0:GetPersonalityId()

		for iter0, iter1 in ipairs(arg0.favorReplaceCfg[arg1]) do
			if iter1[1] == 1 and var0 == iter1[2] then
				return iter1[3]
			end
		end
	end

	return arg0.favorLv2PerformIds[arg1]
end

function var0.CheckFavor(arg0)
	if arg0.favor.lv >= arg0:GetFavorMaxLv() then
		return false
	end

	return arg0.favor.exp >= arg0:GetFavorUpgradExp(arg0.favor.lv)
end

function var0.UpgradeFavor(arg0)
	local var0 = arg0:GetFavorUpgradExp(arg0.favor.lv)

	arg0.favor.lv = arg0.favor.lv + 1
	arg0.favor.exp = arg0.favor.exp - var0
end

function var0.GetFavorPerformIds(arg0)
	return arg0:GetFavorUpgradPerformIds(arg0.favor.lv)
end

function var0.GetMoodStage(arg0)
	local var0 = pg.gameset.child_emotion.description

	if arg0.mood <= var0[1][1][1] then
		return 1
	end

	if arg0.mood >= var0[#var0][1][2] then
		return #var0
	end

	for iter0, iter1 in ipairs(var0) do
		if arg0.mood >= iter1[1][1] and arg0.mood <= iter1[1][2] then
			return iter0
		end
	end
end

function var0.CheckEndCondition(arg0, arg1)
	local var0 = arg0:GetPersonalityId()
	local var1 = true

	for iter0, iter1 in ipairs(arg1) do
		local var2 = iter1[1]

		if var2 == EducateConst.DROP_TYPE_ATTR then
			if not iter1[3] then
				if var0 ~= iter1[2] then
					return false
				end
			elseif arg0.attrs[iter1[2]] < iter1[3] then
				return false
			end
		elseif var2 == EducateConst.DROP_TYPE_RES and arg0[var0.RES_ID_2_NAME[iter1[2]]] < iter1[3] then
			return false
		end
	end

	return true
end

function var0.getCurMainIndex(arg0, arg1)
	local var0 = arg1 or arg0.curTime
	local var1 = arg0:GetPersonalityId()

	for iter0, iter1 in ipairs(arg0:getConfig("char_prefab")) do
		local var2, var3 = EducateHelper.CfgTime2Time(iter1[1])

		if EducateHelper.InTime(var0, var2, var3) then
			if iter1[2] == 0 then
				return iter0
			elseif iter1[2] == var1 then
				return iter0
			end
		end
	end

	return 1
end

function var0.UpdateMainInfo(arg0)
	local var0 = arg0:getCurMainIndex()

	arg0.paintingName = arg0:getConfig("char_prefab")[var0][3]
	arg0.mainWordList = arg0:getConfig("main_word")[var0]
	arg0.mainFaceList = arg0:getConfig("word_expression")[var0]
end

function var0.GetBGName(arg0)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0:getConfig("background_prefab")[arg0.stage] or ""
	else
		return arg0:getConfig("background_prefab")[arg0.stage + 1] or ""
	end
end

function var0.getBgmByStage(arg0, arg1)
	local var0 = arg0:getConfig("bgm")[arg1]

	if type(var0) == "string" then
		return var0
	elseif type(var0) == "table" then
		local var1 = arg0:GetPersonalityId()

		for iter0, iter1 in ipairs(var0) do
			if iter1[1] == var1 then
				return iter1[2]
			end
		end
	end
end

function var0.GetBgm(arg0)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0:getBgmByStage(arg0.stage)
	else
		return arg0:getBgmByStage(arg0.stage + 1)
	end
end

function var0.GetPaintingName(arg0)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0.paintingName or "tbniang"
	else
		local var0, var1, var2 = arg0:GetNextWeekMainInfo()

		return var0
	end
end

function var0.GetMainDialogueInfo(arg0)
	if not getProxy(EducateProxy):InVirtualStage() then
		return arg0.mainWordList, arg0.mainFaceList
	else
		local var0, var1, var2 = arg0:GetNextWeekMainInfo()

		return var1, var2
	end
end

function var0.GetNextWeekMainInfo(arg0)
	local var0 = EducateHelper.GetTimeAfterWeeks(arg0.curTime, 1)
	local var1 = arg0:getCurMainIndex(var0)

	return arg0:getConfig("char_prefab")[var1][3], arg0:getConfig("main_word")[var1], arg0:getConfig("word_expression")[var1]
end

function var0.OnNewWeek(arg0, arg1)
	arg0.curTime = arg1
	arg0.stage = arg0:GetStageByTime(arg0.curTime)
	arg0.site = arg0:GetSiteCnt()

	arg0:UpdateMainInfo()
end

return var0
