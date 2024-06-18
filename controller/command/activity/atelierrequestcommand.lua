local var0_0 = class("AtelierRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body

	pg.ConnectionMgr.GetInstance():Send(26051, {
		act_id = var0_1
	}, 26052, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1)

			var0_2:InitItems(arg0_2.items)
			var0_2:InitFormulaUseCounts(arg0_2.recipes)
			var0_2:UpdateBuffSlots(arg0_2.slots)
			getProxy(ActivityProxy):updateActivity(var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
