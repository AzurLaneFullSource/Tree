local var0_0 = class("WorkBenchActivity", import("model.vo.Activity"))

function var0_0.GetFormulaUseCount(arg0_1, arg1_1)
	return arg0_1.data1KeyValueList[1][arg1_1] or 0
end

function var0_0.AddFormulaUseCount(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:GetFormulaUseCount(arg1_2)

	arg0_2.data1KeyValueList[1][arg1_2] = var0_2 + arg2_2
end

function var0_0.HasAvaliableFormula(arg0_3)
	local var0_3 = _.map(pg.activity_workbench_recipe.all, function(arg0_4)
		local var0_4 = WorkBenchFormula.New({
			configId = arg0_4
		})

		var0_4:BuildFromActivity()

		return var0_4
	end)

	return _.any(var0_3, function(arg0_5)
		return arg0_5:IsUnlock() and arg0_5:IsAvaliable()
	end)
end

return var0_0
