local var0 = class("WorkBenchFormula", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.activity_workbench_recipe
end

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.times = arg0.times or 0
	arg0.unlock = true
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetIconPath(arg0)
	return arg0:getConfig("icon")
end

function var0.GetLockLimit(arg0)
	return FilterVarchar(arg0:getConfig("recipe_lock"))
end

function var0.GetLockDesc(arg0)
	return (arg0:getConfig("lock_display"))
end

function var0.BuildFromActivity(arg0)
	arg0.unlock = (function()
		local var0 = arg0:GetLockLimit()

		if var0 and var0[1] == 1 then
			local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			assert(var1)

			return var1:GetBuildingLevel(var0[2]) >= var0[3]
		end

		return true
	end)()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	assert(var0)

	arg0.times = var0:GetFormulaUseCount(arg0:GetConfigID())
end

function var0.IsUnlock(arg0)
	return arg0.unlock
end

function var0.GetMaxLimit(arg0)
	return arg0:getConfig("item_num")
end

function var0.SetUsedCount(arg0, arg1)
	arg0.times = arg1
end

function var0.GetUsedCount(arg0)
	return arg0.times
end

function var0.IsAvaliable(arg0)
	return arg0:GetMaxLimit() <= 0 or arg0:GetUsedCount() < arg0:GetMaxLimit()
end

function var0.GetProduction(arg0)
	return arg0:getConfig("item_id")
end

function var0.GetMaterials(arg0)
	return arg0:getConfig("recipe")
end

return var0
