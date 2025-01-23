local var0_0 = class("NewEducatePlan", import("model.vo.BaseVO"))

var0_0.TYPE = {
	OTHER = 2,
	STUDY = 1
}
var0_0.TYPE2NAME = {
	[var0_0.TYPE.STUDY] = i18n("child2_plan_type1"),
	[var0_0.TYPE.OTHER] = i18n("child2_plan_type2")
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_plan
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg0_2.id
	arg0_2.isExtraPlan = arg2_2
end

function var0_0.IsShow(arg0_3)
	return arg0_3:getConfig("is_show") == 1
end

function var0_0.GetCostShowInfos(arg0_4)
	return NewEducateHelper.Config2Drops(arg0_4:getConfig("cost"))
end

function var0_0.GetCostWithBenefit(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = arg1_5[arg0_5.id]

	if var1_5 then
		for iter0_5, iter1_5 in ipairs(arg0_5:GetCostShowInfos()) do
			local var2_5 = Clone(iter1_5)

			if var1_5[iter1_5.type] then
				local var3_5 = var1_5[iter1_5.type][iter1_5.id]

				if var3_5 then
					var2_5.number = NewEducateHelper.GetBenefitValue(iter1_5.number, var3_5)
				end
			end

			table.insert(var0_5, var2_5)
		end

		return var0_5
	else
		return arg0_5:GetCostShowInfos()
	end
end

function var0_0.GetAwardShowInfos(arg0_6)
	return NewEducateHelper.Config2Drops(arg0_6:getConfig("result_display"))
end

function var0_0.GetNextId(arg0_7)
	local var0_7 = pg.child2_plan.get_id_list_by_group_id[arg0_7:getConfig("group_id")]

	return underscore.detect(var0_7, function(arg0_8)
		return pg.child2_plan[arg0_8].level == arg0_7:getConfig("level") + 1
	end)
end

function var0_0.GetUpgradeConditions(arg0_9, arg1_9)
	local var0_9 = arg0_9:getConfig("level_condition")
	local var1_9 = arg1_9:GetConditionIdsFromComplex(var0_9)

	return underscore.select(var1_9, function(arg0_10)
		local var0_10 = pg.child2_condition[arg0_10]

		return var0_10.type == NewEducateConst.CONDITION_TYPE.DROP and var0_10.param[1] == NewEducateConst.DROP_TYPE.ATTR
	end) or {}
end

function var0_0.IsExtraPlan(arg0_11)
	return arg0_11.isExtraPlan
end

function var0_0.GetAwardBg(arg0_12)
	return arg0_12:getConfig("type") == var0_0.TYPE.STUDY and "desc_bg_orange" or "desc_bg_purple"
end

return var0_0
