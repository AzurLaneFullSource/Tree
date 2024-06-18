local var0_0 = class("EducateGetPlansCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27012, {
		plans = var0_1.plans
	}, 27013, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):GetPlanProxy():SetGridData(arg0_2.plans)
			arg0_1:sendNotification(GAME.EDUCATE_EXECUTE_PLANS, {
				isSkip = var0_1.isSkip
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate get plans error: ", arg0_2.result))
		end
	end)
end

return var0_0
