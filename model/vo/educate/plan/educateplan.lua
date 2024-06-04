local var0 = class("EducatePlan", import("model.vo.BaseVO"))

var0.RARITY2BG = {
	"plan_icon_grey",
	"plan_icon_purple",
	"plan_icon_yellow"
}
var0.TYPE_SCHOOL = 1
var0.TYPE_INTEREST = 2
var0.TYPE_COMMUNITY = 3
var0.TYPE_FREETIME = 4
var0.TYPE_FREETIME_2 = 5

function var0.bindConfigTable(arg0)
	return pg.child_plan
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
end

function var0.GetIconBgName(arg0)
	return var0.RARITY2BG[arg0:getConfig("rare")]
end

function var0.IsInStage(arg0, arg1)
	return #arg0:getConfig("stage") == 0 or table.contains(arg0:getConfig("stage"), arg1)
end

function var0.GetType(arg0)
	if arg0:getConfig("type") == var0.TYPE_FREETIME_2 then
		return var0.TYPE_FREETIME
	end

	return arg0:getConfig("type")
end

function var0.IsInTime(arg0, arg1, arg2)
	return underscore.any(arg0:getConfig("time"), function(arg0)
		return arg0[1] == arg1 and arg0[2] == arg2
	end)
end

function var0.IsShow(arg0, arg1, arg2, arg3)
	return arg0:IsInStage(arg1) and arg0:IsInTime(arg2, arg3)
end

function var0.IsMatchAttr(arg0, arg1)
	return underscore.all(arg0:getConfig("ability"), function(arg0)
		return arg1:GetAttrById(arg0[2]) >= arg0[3]
	end)
end

function var0.ExistNextPlanCanFill(arg0, arg1)
	local var0 = arg0:getConfig("pre_next")

	if var0 == 0 then
		return false
	end

	local var1 = pg.child_plan[var0].pre[2]
	local var2 = getProxy(EducateProxy):GetPlanProxy():GetHistoryCntById(arg0.id)
	local var3 = EducatePlan.New(var0)

	return var1 <= var2 and var3:IsMatchAttr(arg1)
end

function var0.IsMatchPre(arg0, arg1)
	local var0 = arg0:getConfig("pre")

	if #var0 == 0 then
		return true
	end

	return arg1 >= var0[2]
end

function var0.GetCost(arg0)
	return arg0:getConfig("cost_resource1"), arg0:getConfig("cost_resource2"), arg0:getConfig("cost_resource3")
end

function var0.GetResult(arg0)
	return arg0:getConfig("result_display")
end

function var0.CheckResult(arg0, arg1, arg2)
	return underscore.any(arg0:GetResult(), function(arg0)
		return arg0[1] == arg1 and arg0[2] == arg2 and arg0[3] > 0
	end)
end

function var0.CheckResultBySubType(arg0, arg1, arg2)
	return underscore.any(arg0:GetResult(), function(arg0)
		return arg0[1] == arg1 and EducateHelper.IsMatchSubType(arg2, arg0[2]) and arg0[3] > 0
	end)
end

function var0.GetAttrResultValue(arg0, arg1)
	local var0 = underscore.select(arg0:GetResult(), function(arg0)
		return arg0[1] == EducateConst.DROP_TYPE_ATTR and arg0[2] == arg1 and arg0[3] > 0
	end)

	return var0 and var0[3] or 0
end

function var0.GetDropInfo(arg0)
	local var0 = {}

	underscore.each(arg0:GetResult(), function(arg0)
		table.insert(var0, Drop.New({
			type = arg0[1],
			id = arg0[2],
			number = arg0[3]
		}))
	end)

	return var0
end

function var0.GetPerformance(arg0)
	return arg0:getConfig("performance")
end

return var0
