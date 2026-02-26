local var0_0 = class("LiquorFloorBookMediator", import("view.base.ContextMediator"))

var0_0.ON_GET_TASK = "LiquorFloorBookMediator:ON_GET_TASK"
var0_0.ACT_ID = ActivityConst.LiquorFloor_ACT_ID

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_GET_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.SUBMIT_TASK_AWARD_DOWN
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.SUBMIT_TASK_AWARD_DOWN then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, function()
			arg0_4.viewComponent:updateAwardPanel()
			arg0_4.viewComponent:updateTag()
		end)
	end
end

return var0_0
