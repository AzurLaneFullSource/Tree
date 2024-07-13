local var0_0 = class("LinerLogBookMediator", import("view.base.ContextMediator"))

var0_0.GET_SCHEDULE_AWARD = "LinerLogBookMediator.GET_SCHEDULE_AWARD"
var0_0.GET_ROOM_AWARD = "LinerLogBookMediator.GET_ROOM_AWARD"
var0_0.ON_START_REASONING = "LinerLogBookMediator.ON_START_REASONING"
var0_0.GET_EVENT_AWARD = "LinerLogBookMediator.GET_EVENT_AWARD"
var0_0.ON_CLOSE = "LinerLogBookMediator.ON_CLOSE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_SCHEDULE_AWARD, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 2,
			activity_id = arg1_2,
			arg1 = arg2_2,
			drop = arg3_2
		})
	end)
	arg0_1:bind(var0_0.GET_ROOM_AWARD, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 3,
			activity_id = arg1_3,
			arg1 = arg2_3,
			drop = arg3_3
		})
	end)
	arg0_1:bind(var0_0.ON_START_REASONING, function(arg0_4, arg1_4, arg2_4)
		arg0_1.viewComponent:OnStartReasoning(arg1_4, arg2_4)
	end)
	arg0_1:bind(var0_0.GET_EVENT_AWARD, function(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
		arg0_1:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 4,
			activity_id = arg1_5,
			arg1 = arg2_5,
			arg2 = arg3_5,
			drop = arg4_5
		})
	end)
	arg0_1:bind(var0_0.ON_CLOSE, function()
		arg0_1.viewComponent:onBackPressed()
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.ACTIVITY_LINER_OP_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.ACTIVITY_LINER_OP_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
		arg0_8.viewComponent:UpdateView()
	end
end

return var0_0
