local var0 = class("AtelierRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body

	pg.ConnectionMgr.GetInstance():Send(26051, {
		act_id = var0
	}, 26052, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy):getActivityById(var0)

			var0:InitItems(arg0.items)
			var0:InitFormulaUseCounts(arg0.recipes)
			var0:UpdateBuffSlots(arg0.slots)
			getProxy(ActivityProxy):updateActivity(var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
