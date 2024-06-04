local var0 = class("AtelierCompositeCommand", pm.SimpleCommand)

function var0.SerialAsyncUnitl(arg0, arg1, arg2)
	local var0 = 0
	local var1

	local function var2()
		var0 = var0 + 1

		if var0 <= arg1 then
			arg0(var0, var2)
		else
			existCall(arg2)
		end
	end

	var2()
end

function var0.execute(arg0, arg1)
	local var0 = arg1.body
	local var1 = var0.formulaId
	local var2 = var0.items
	local var3 = var0.repeats
	local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var4)
	pg.ConnectionMgr.GetInstance():Send(26053, {
		act_id = var4.id,
		recipe_id = var1,
		items = var2,
		times = var3
	}, 26054, function(arg0)
		if arg0.result == 0 then
			var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			local var0 = var4:GetItems()

			_.each(var2, function(arg0)
				if not var0[arg0.value] then
					return
				end

				var0[arg0.value].count = var0[arg0.value].count - var3

				if var0[arg0.value].count <= 0 then
					var0[arg0.value] = nil
				end
			end)
			var4:AddFormulaUseCount(var1, var3)
			getProxy(ActivityProxy):updateActivity(var4)

			local var1 = PlayerConst.addTranDrop(arg0.award_list)

			arg0:sendNotification(GAME.COMPOSITE_ATELIER_RECIPE_DONE, var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
