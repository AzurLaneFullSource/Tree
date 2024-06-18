local var0_0 = class("EducatePlan", import("model.vo.BaseVO"))

var0_0.RARITY2BG = {
	"plan_icon_grey",
	"plan_icon_purple",
	"plan_icon_yellow"
}
var0_0.TYPE_SCHOOL = 1
var0_0.TYPE_INTEREST = 2
var0_0.TYPE_COMMUNITY = 3
var0_0.TYPE_FREETIME = 4
var0_0.TYPE_FREETIME_2 = 5

function var0_0.bindConfigTable(arg0_1)
	return pg.child_plan
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg0_2.id
end

function var0_0.GetIconBgName(arg0_3)
	return var0_0.RARITY2BG[arg0_3:getConfig("rare")]
end

function var0_0.IsInStage(arg0_4, arg1_4)
	return #arg0_4:getConfig("stage") == 0 or table.contains(arg0_4:getConfig("stage"), arg1_4)
end

function var0_0.GetType(arg0_5)
	if arg0_5:getConfig("type") == var0_0.TYPE_FREETIME_2 then
		return var0_0.TYPE_FREETIME
	end

	return arg0_5:getConfig("type")
end

function var0_0.IsInTime(arg0_6, arg1_6, arg2_6)
	return underscore.any(arg0_6:getConfig("time"), function(arg0_7)
		return arg0_7[1] == arg1_6 and arg0_7[2] == arg2_6
	end)
end

function var0_0.IsShow(arg0_8, arg1_8, arg2_8, arg3_8)
	return arg0_8:IsInStage(arg1_8) and arg0_8:IsInTime(arg2_8, arg3_8)
end

function var0_0.IsMatchAttr(arg0_9, arg1_9)
	return underscore.all(arg0_9:getConfig("ability"), function(arg0_10)
		return arg1_9:GetAttrById(arg0_10[2]) >= arg0_10[3]
	end)
end

function var0_0.ExistNextPlanCanFill(arg0_11, arg1_11)
	local var0_11 = arg0_11:getConfig("pre_next")

	if var0_11 == 0 then
		return false
	end

	local var1_11 = pg.child_plan[var0_11].pre[2]
	local var2_11 = getProxy(EducateProxy):GetPlanProxy():GetHistoryCntById(arg0_11.id)
	local var3_11 = EducatePlan.New(var0_11)

	return var1_11 <= var2_11 and var3_11:IsMatchAttr(arg1_11)
end

function var0_0.IsMatchPre(arg0_12, arg1_12)
	local var0_12 = arg0_12:getConfig("pre")

	if #var0_12 == 0 then
		return true
	end

	return arg1_12 >= var0_12[2]
end

function var0_0.GetCost(arg0_13)
	return arg0_13:getConfig("cost_resource1"), arg0_13:getConfig("cost_resource2"), arg0_13:getConfig("cost_resource3")
end

function var0_0.GetResult(arg0_14)
	return arg0_14:getConfig("result_display")
end

function var0_0.CheckResult(arg0_15, arg1_15, arg2_15)
	return underscore.any(arg0_15:GetResult(), function(arg0_16)
		return arg0_16[1] == arg1_15 and arg0_16[2] == arg2_15 and arg0_16[3] > 0
	end)
end

function var0_0.CheckResultBySubType(arg0_17, arg1_17, arg2_17)
	return underscore.any(arg0_17:GetResult(), function(arg0_18)
		return arg0_18[1] == arg1_17 and EducateHelper.IsMatchSubType(arg2_17, arg0_18[2]) and arg0_18[3] > 0
	end)
end

function var0_0.GetAttrResultValue(arg0_19, arg1_19)
	local var0_19 = underscore.select(arg0_19:GetResult(), function(arg0_20)
		return arg0_20[1] == EducateConst.DROP_TYPE_ATTR and arg0_20[2] == arg1_19 and arg0_20[3] > 0
	end)

	return var0_19 and var0_19[3] or 0
end

function var0_0.GetDropInfo(arg0_21)
	local var0_21 = {}

	underscore.each(arg0_21:GetResult(), function(arg0_22)
		table.insert(var0_21, Drop.New({
			type = arg0_22[1],
			id = arg0_22[2],
			number = arg0_22[3]
		}))
	end)

	return var0_21
end

function var0_0.GetPerformance(arg0_23)
	return arg0_23:getConfig("performance")
end

return var0_0
