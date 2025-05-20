local var0_0 = class("CollectionBookMediator", import("..base.ContextMediator"))

var0_0.ACT_ID = ActivityConst.HOLIDAY_ACT_ID

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.SUBMIT_TASK_AWARD_DOWN
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.SUBMIT_TASK_AWARD_DOWN then
		arg0_3.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_3.awards, function()
			arg0_3.viewComponent:updateAwardPanel()
			arg0_3.viewComponent:updateTag()
		end)
	end
end

function var0_0.GetCollectionBookTip()
	local var0_5 = CollectionBookMediator.ACT_ID
	local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5):getConfig("config_client").collect_task

	for iter0_5 = 1, #var1_5 do
		local var2_5 = getProxy(TaskProxy):getTaskById(var1_5[iter0_5])

		if var2_5 and var2_5:getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

return var0_0
