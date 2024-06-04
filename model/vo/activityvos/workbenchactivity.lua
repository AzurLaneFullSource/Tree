local var0 = class("WorkBenchActivity", import("model.vo.Activity"))

function var0.GetFormulaUseCount(arg0, arg1)
	return arg0.data1KeyValueList[1][arg1] or 0
end

function var0.AddFormulaUseCount(arg0, arg1, arg2)
	local var0 = arg0:GetFormulaUseCount(arg1)

	arg0.data1KeyValueList[1][arg1] = var0 + arg2
end

function var0.HasAvaliableFormula(arg0)
	local var0 = _.map(pg.activity_workbench_recipe.all, function(arg0)
		local var0 = WorkBenchFormula.New({
			configId = arg0
		})

		var0:BuildFromActivity()

		return var0
	end)

	return _.any(var0, function(arg0)
		return arg0:IsUnlock() and arg0:IsAvaliable()
	end)
end

return var0
