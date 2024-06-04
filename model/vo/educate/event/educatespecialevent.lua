local var0 = class("EducateSpecialEvent", import("model.vo.BaseVO"))

var0.TYPE_PLAN = 1
var0.TYPE_SITE = 2
var0.TYPE_BUBBLE_MIND = 3
var0.TYPE_BUBBLE_DISCOUNT = 4
var0.TAG_ING = 1
var0.TAG_COMING = 2
var0.TAG_END = 3
var0.TAG2NAME = {
	[var0.TAG_ING] = "ING",
	[var0.TAG_COMING] = "COMING",
	[var0.TAG_END] = "END"
}

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id

	arg0:initTime()
end

function var0.bindConfigTable(arg0)
	return pg.child_event_special
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.IsPlanType(arg0)
	return arg0:GetType() == var0.TYPE_PLAN
end

function var0.GetGridIndexs(arg0)
	local var0 = {}

	for iter0 = arg0.startTime.day, arg0.endTime.day do
		for iter1 = arg0:getConfig("date")[1][4], arg0:getConfig("date")[2][4] do
			table.insert(var0, {
				iter0,
				iter1
			})
		end
	end

	return var0
end

function var0.IsSiteType(arg0)
	return arg0:GetType() == var0.TYPE_SITE
end

function var0.IsMatchSite(arg0, arg1)
	return table.contains(arg0:getConfig("type_param"), arg1)
end

function var0.initTime(arg0)
	local var0 = arg0:getConfig("date")

	arg0.startTime, arg0.endTime = EducateHelper.CfgTime2Time(var0)
end

function var0.InTime(arg0, arg1)
	return EducateHelper.InTime(arg1, arg0.startTime, arg0.endTime)
end

function var0.IsMatch(arg0, arg1)
	if arg0:getConfig("child_attr2") == 0 then
		return true
	end

	return arg0:getConfig("child_attr2") == arg1
end

function var0.IsUnlockSite(arg0)
	if not arg0:IsSiteType() then
		return true
	end

	return EducateHelper.IsSiteUnlock(arg0:getConfig("type_param")[1], getProxy(EducateProxy):IsFirstGame())
end

function var0.InNextWeekTime(arg0, arg1)
	local var0 = EducateHelper.GetTimeAfterDays(arg1, 7)

	return var0.month >= arg0.startTime.month and var0.month <= arg0.endTime.month and var0.week >= arg0.startTime.week and var0.week <= arg0.endTime.week
end

function var0.GetPerformance(arg0)
	return arg0:getConfig("performance")
end

function var0.GetResult(arg0)
	return arg0:getConfig("result_display") or {}
end

function var0.InMonth(arg0, arg1)
	return arg1 <= arg0.startTime.month and arg1 >= arg0.endTime.month
end

function var0.IsShow(arg0)
	return arg0:getConfig("show") ~= 0
end

function var0.IsImport(arg0)
	return arg0:getConfig("show") == 1
end

function var0.IsOther(arg0)
	return arg0:getConfig("show") == 2
end

function var0.GetTag(arg0, arg1, arg2)
	if table.contains(arg1, arg0.id) or arg2 > arg0.endTime.week then
		return var0.TAG_END
	else
		return arg2 >= arg0.startTime.week and var0.TAG_ING or var0.TAG_COMING
	end
end

function var0.GetTimeDesc(arg0)
	if arg0.startTime.week == arg0.endTime.week then
		return i18n("word_which_week", arg0.startTime.week)
	else
		local var0 = i18n("word_which_week", arg0.startTime.week)
		local var1 = i18n("word_which_week", arg0.endTime.week)

		return var0 .. "-" .. var1
	end
end

function var0.GetDiscountShopId(arg0)
	if arg0:getConfig("type") == var0.TYPE_BUBBLE_DISCOUNT then
		local var0 = arg0:getConfig("type_param")[1]

		return pg.child_site_option[var0].param[1]
	end

	assert(nil, "not discount type:" .. arg0.id)
end

function var0.GetDiscountRatio(arg0)
	if arg0:getConfig("type") == var0.TYPE_BUBBLE_DISCOUNT then
		return arg0:getConfig("type_param")[2]
	end

	assert(nil, "not discount type:" .. arg0.id)
end

function var0.InDiscountTime(arg0, arg1)
	if arg0:getConfig("type") == var0.TYPE_BUBBLE_DISCOUNT then
		local var0 = arg0:getConfig("type_param")[3]
		local var1 = EducateHelper.GetTimeAfterWeeks(arg1, var0)

		return EducateHelper.InTime(arg1, arg0.startTime, var1)
	end

	assert(nil, "not discount type:" .. arg0.id)
end

return var0
