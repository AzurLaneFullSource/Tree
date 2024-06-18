local var0_0 = class("AtelierCompositeCommand", pm.SimpleCommand)

function var0_0.SerialAsyncUnitl(arg0_1, arg1_1, arg2_1)
	local var0_1 = 0
	local var1_1

	local function var2_1()
		var0_1 = var0_1 + 1

		if var0_1 <= arg1_1 then
			arg0_1(var0_1, var2_1)
		else
			existCall(arg2_1)
		end
	end

	var2_1()
end

function var0_0.execute(arg0_3, arg1_3)
	local var0_3 = arg1_3.body
	local var1_3 = var0_3.formulaId
	local var2_3 = var0_3.items
	local var3_3 = var0_3.repeats
	local var4_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var4_3)
	pg.ConnectionMgr.GetInstance():Send(26053, {
		act_id = var4_3.id,
		recipe_id = var1_3,
		items = var2_3,
		times = var3_3
	}, 26054, function(arg0_4)
		if arg0_4.result == 0 then
			var4_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			local var0_4 = var4_3:GetItems()

			_.each(var2_3, function(arg0_5)
				if not var0_4[arg0_5.value] then
					return
				end

				var0_4[arg0_5.value].count = var0_4[arg0_5.value].count - var3_3

				if var0_4[arg0_5.value].count <= 0 then
					var0_4[arg0_5.value] = nil
				end
			end)
			var4_3:AddFormulaUseCount(var1_3, var3_3)
			getProxy(ActivityProxy):updateActivity(var4_3)

			local var1_4 = PlayerConst.addTranDrop(arg0_4.award_list)

			arg0_3:sendNotification(GAME.COMPOSITE_ATELIER_RECIPE_DONE, var1_4)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_4.result))
		end
	end)
end

return var0_0
