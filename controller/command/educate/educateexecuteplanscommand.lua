local var0 = class("EducateExecutePlansCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	local var2 = getProxy(EducateProxy)

	pg.ConnectionMgr.GetInstance():Send(27002, {
		type = 1
	}, 27003, function(arg0)
		if arg0.result == 0 then
			local var0 = var2:GetPlanProxy():GetGridData()

			local function var1()
				arg0:sendNotification(GAME.EDUCATE_EXECUTE_PLANS_DONE, {
					gridData = var0,
					plan_results = arg0.plan_results,
					events = arg0.events,
					isSkip = var0.isSkip
				})
			end

			var2:ReduceResForPlans()
			var2:GetPlanProxy():OnExecutePlanDone()
			var2:GetPlanProxy():UpdateHistory()
			arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.EDUCATE, {
				ingoreGuideCheck = true,
				onEnter = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate execute plans error: ", arg0.result))
		end
	end)
end

return var0
