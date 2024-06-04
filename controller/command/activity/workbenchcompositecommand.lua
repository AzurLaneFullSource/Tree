local var0 = class("WorkBenchCompositeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

	if not var1 or var1:isEnd() then
		return
	end

	local var2 = var1.id
	local var3 = var0.formulaId
	local var4 = var0.repeats
	local var5 = WorkBenchFormula.New({
		configId = var3
	})

	var5:BuildFromActivity()

	local var6 = var5:GetMaterials()

	if not (function()
		if not var5:IsUnlock() then
			return
		end

		local var0 = var5:GetMaxLimit()
		local var1 = var5:GetUsedCount()

		if var4 <= 0 then
			return
		end

		if var0 > 0 and var4 > var0 - var1 then
			return
		end

		local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

		if not _.all(var6, function(arg0)
			assert(arg0[1] > DROP_TYPE_USE_ACTIVITY_DROP)

			local var0 = arg0[2]

			return arg0[3] * var4 <= var2:getVitemNumber(var0)
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
		activity_id = var2,
		arg1 = var3,
		arg2 = var4,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

			_.each(var6, function(arg0)
				local var0 = arg0[2]
				local var1 = arg0[3] * var4

				var0:subVitemNumber(var0, var1)
			end)
			getProxy(ActivityProxy):updateActivity(var0)

			local var1 = PlayerConst.GetTranAwards(var0, arg0)
			local var2 = getProxy(ActivityProxy):getActivityById(var2)

			var2:AddFormulaUseCount(var3, var4)
			getProxy(ActivityProxy):updateActivity(var2)
			arg0:sendNotification(GAME.WORKBENCH_COMPOSITE_DONE, var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
