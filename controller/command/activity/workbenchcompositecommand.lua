local var0_0 = class("WorkBenchCompositeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	local var2_1 = var1_1.id
	local var3_1 = var0_1.formulaId
	local var4_1 = var0_1.repeats
	local var5_1 = WorkBenchFormula.New({
		configId = var3_1
	})

	var5_1:BuildFromActivity()

	local var6_1 = var5_1:GetMaterials()

	if not (function()
		if not var5_1:IsUnlock() then
			return
		end

		local var0_2 = var5_1:GetMaxLimit()
		local var1_2 = var5_1:GetUsedCount()

		if var4_1 <= 0 then
			return
		end

		if var0_2 > 0 and var4_1 > var0_2 - var1_2 then
			return
		end

		local var2_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

		if not _.all(var6_1, function(arg0_3)
			assert(arg0_3[1] > DROP_TYPE_USE_ACTIVITY_DROP)

			local var0_3 = arg0_3[2]

			return arg0_3[3] * var4_1 <= var2_2:getVitemNumber(var0_3)
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips2"))

			return
		end

		return true
	end)() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2_1,
		arg1 = var3_1,
		arg2 = var4_1,
		arg_list = {}
	}, 11203, function(arg0_4)
		if arg0_4.result == 0 then
			local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

			_.each(var6_1, function(arg0_5)
				local var0_5 = arg0_5[2]
				local var1_5 = arg0_5[3] * var4_1

				var0_4:subVitemNumber(var0_5, var1_5)
			end)
			getProxy(ActivityProxy):updateActivity(var0_4)

			local var1_4 = PlayerConst.GetTranAwards(var0_1, arg0_4)
			local var2_4 = getProxy(ActivityProxy):getActivityById(var2_1)

			var2_4:AddFormulaUseCount(var3_1, var4_1)
			getProxy(ActivityProxy):updateActivity(var2_4)
			arg0_1:sendNotification(GAME.WORKBENCH_COMPOSITE_DONE, var1_4)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_4.result))
		end
	end)
end

return var0_0
