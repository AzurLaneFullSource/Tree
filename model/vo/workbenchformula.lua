local var0_0 = class("WorkBenchFormula", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_workbench_recipe
end

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.times = arg0_2.times or 0
	arg0_2.unlock = true
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("name")
end

function var0_0.GetIconPath(arg0_4)
	return arg0_4:getConfig("icon")
end

function var0_0.GetLockLimit(arg0_5)
	return FilterVarchar(arg0_5:getConfig("recipe_lock"))
end

function var0_0.GetLockDesc(arg0_6)
	return (arg0_6:getConfig("lock_display"))
end

function var0_0.BuildFromActivity(arg0_7)
	arg0_7.unlock = (function()
		local var0_8 = arg0_7:GetLockLimit()

		if var0_8 and var0_8[1] == 1 then
			local var1_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			assert(var1_8)

			return var1_8:GetBuildingLevel(var0_8[2]) >= var0_8[3]
		end

		return true
	end)()

	local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	assert(var0_7)

	arg0_7.times = var0_7:GetFormulaUseCount(arg0_7:GetConfigID())
end

function var0_0.IsUnlock(arg0_9)
	return arg0_9.unlock
end

function var0_0.GetMaxLimit(arg0_10)
	return arg0_10:getConfig("item_num")
end

function var0_0.SetUsedCount(arg0_11, arg1_11)
	arg0_11.times = arg1_11
end

function var0_0.GetUsedCount(arg0_12)
	return arg0_12.times
end

function var0_0.IsAvaliable(arg0_13)
	return arg0_13:GetMaxLimit() <= 0 or arg0_13:GetUsedCount() < arg0_13:GetMaxLimit()
end

function var0_0.GetProduction(arg0_14)
	return arg0_14:getConfig("item_id")
end

function var0_0.GetMaterials(arg0_15)
	return arg0_15:getConfig("recipe")
end

return var0_0
