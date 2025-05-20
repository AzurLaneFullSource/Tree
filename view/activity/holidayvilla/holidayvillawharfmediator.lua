local var0_0 = class("HolidayVillaWharfMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_SUBMIT_ONESTEP = "HolidayVillaWharfMediator.ON_TASK_SUBMIT_ONESTEP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_2,
			task_ids = arg2_2,
			callback = arg3_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_4.viewComponent:SetAwardsShow(var1_4.awards)
		arg0_4.viewComponent:RefreshData()
		arg0_4.viewComponent:Show()
		arg0_4.viewComponent:ShowCompletePage()
	end
end

return var0_0
