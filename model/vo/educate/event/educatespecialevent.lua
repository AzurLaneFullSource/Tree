local var0_0 = class("EducateSpecialEvent", import("model.vo.BaseVO"))

var0_0.TYPE_PLAN = 1
var0_0.TYPE_SITE = 2
var0_0.TYPE_BUBBLE_MIND = 3
var0_0.TYPE_BUBBLE_DISCOUNT = 4
var0_0.TAG_ING = 1
var0_0.TAG_COMING = 2
var0_0.TAG_END = 3
var0_0.TAG2NAME = {
	[var0_0.TAG_ING] = "ING",
	[var0_0.TAG_COMING] = "COMING",
	[var0_0.TAG_END] = "END"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id

	arg0_1:initTime()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_event_special
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.IsPlanType(arg0_4)
	return arg0_4:GetType() == var0_0.TYPE_PLAN
end

function var0_0.GetGridIndexs(arg0_5)
	local var0_5 = {}

	for iter0_5 = arg0_5.startTime.day, arg0_5.endTime.day do
		for iter1_5 = arg0_5:getConfig("date")[1][4], arg0_5:getConfig("date")[2][4] do
			table.insert(var0_5, {
				iter0_5,
				iter1_5
			})
		end
	end

	return var0_5
end

function var0_0.IsSiteType(arg0_6)
	return arg0_6:GetType() == var0_0.TYPE_SITE
end

function var0_0.IsMatchSite(arg0_7, arg1_7)
	return table.contains(arg0_7:getConfig("type_param"), arg1_7)
end

function var0_0.initTime(arg0_8)
	local var0_8 = arg0_8:getConfig("date")

	arg0_8.startTime, arg0_8.endTime = EducateHelper.CfgTime2Time(var0_8)
end

function var0_0.InTime(arg0_9, arg1_9)
	return EducateHelper.InTime(arg1_9, arg0_9.startTime, arg0_9.endTime)
end

function var0_0.IsMatch(arg0_10, arg1_10)
	if arg0_10:getConfig("child_attr2") == 0 then
		return true
	end

	return arg0_10:getConfig("child_attr2") == arg1_10
end

function var0_0.IsUnlockSite(arg0_11)
	if not arg0_11:IsSiteType() then
		return true
	end

	return EducateHelper.IsSiteUnlock(arg0_11:getConfig("type_param")[1], getProxy(EducateProxy):IsFirstGame())
end

function var0_0.InNextWeekTime(arg0_12, arg1_12)
	local var0_12 = EducateHelper.GetTimeAfterDays(arg1_12, 7)

	return var0_12.month >= arg0_12.startTime.month and var0_12.month <= arg0_12.endTime.month and var0_12.week >= arg0_12.startTime.week and var0_12.week <= arg0_12.endTime.week
end

function var0_0.GetPerformance(arg0_13)
	return arg0_13:getConfig("performance")
end

function var0_0.GetResult(arg0_14)
	return arg0_14:getConfig("result_display") or {}
end

function var0_0.InMonth(arg0_15, arg1_15)
	return arg1_15 <= arg0_15.startTime.month and arg1_15 >= arg0_15.endTime.month
end

function var0_0.IsShow(arg0_16)
	return arg0_16:getConfig("show") ~= 0
end

function var0_0.IsImport(arg0_17)
	return arg0_17:getConfig("show") == 1
end

function var0_0.IsOther(arg0_18)
	return arg0_18:getConfig("show") == 2
end

function var0_0.GetTag(arg0_19, arg1_19, arg2_19)
	if table.contains(arg1_19, arg0_19.id) or arg2_19 > arg0_19.endTime.week then
		return var0_0.TAG_END
	else
		return arg2_19 >= arg0_19.startTime.week and var0_0.TAG_ING or var0_0.TAG_COMING
	end
end

function var0_0.GetTimeDesc(arg0_20)
	if arg0_20.startTime.week == arg0_20.endTime.week then
		return i18n("word_which_week", arg0_20.startTime.week)
	else
		local var0_20 = i18n("word_which_week", arg0_20.startTime.week)
		local var1_20 = i18n("word_which_week", arg0_20.endTime.week)

		return var0_20 .. "-" .. var1_20
	end
end

function var0_0.GetDiscountShopId(arg0_21)
	if arg0_21:getConfig("type") == var0_0.TYPE_BUBBLE_DISCOUNT then
		local var0_21 = arg0_21:getConfig("type_param")[1]

		return pg.child_site_option[var0_21].param[1]
	end

	assert(nil, "not discount type:" .. arg0_21.id)
end

function var0_0.GetDiscountRatio(arg0_22)
	if arg0_22:getConfig("type") == var0_0.TYPE_BUBBLE_DISCOUNT then
		return arg0_22:getConfig("type_param")[2]
	end

	assert(nil, "not discount type:" .. arg0_22.id)
end

function var0_0.InDiscountTime(arg0_23, arg1_23)
	if arg0_23:getConfig("type") == var0_0.TYPE_BUBBLE_DISCOUNT then
		local var0_23 = arg0_23:getConfig("type_param")[3]
		local var1_23 = EducateHelper.GetTimeAfterWeeks(arg1_23, var0_23)

		return EducateHelper.InTime(arg1_23, arg0_23.startTime, var1_23)
	end

	assert(nil, "not discount type:" .. arg0_23.id)
end

return var0_0
