local var0_0 = class("EducateExecutePlansCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	local var2_1 = getProxy(EducateProxy)

	pg.ConnectionMgr.GetInstance():Send(27002, {
		type = 1
	}, 27003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1:GetPlanProxy():GetGridData()

			local function var1_2()
				arg0_1:sendNotification(GAME.EDUCATE_EXECUTE_PLANS_DONE, {
					gridData = var0_2,
					plan_results = arg0_2.plan_results,
					events = arg0_2.events,
					isSkip = var0_1.isSkip
				})
			end

			var2_1:ReduceResForPlans()
			var2_1:GetPlanProxy():OnExecutePlanDone()
			var2_1:GetPlanProxy():UpdateHistory()
			arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.EDUCATE, {
				ingoreGuideCheck = true,
				onEnter = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate execute plans error: ", arg0_2.result))
		end
	end)
end

return var0_0
