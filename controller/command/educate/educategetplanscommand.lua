local var0 = class("EducateGetPlansCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27012, {
		plans = var0.plans
	}, 27013, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):GetPlanProxy():SetGridData(arg0.plans)
			arg0:sendNotification(GAME.EDUCATE_EXECUTE_PLANS, {
				isSkip = var0.isSkip
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate get plans error: ", arg0.result))
		end
	end)
end

return var0
