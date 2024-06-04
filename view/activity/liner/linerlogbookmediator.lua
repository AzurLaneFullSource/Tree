local var0 = class("LinerLogBookMediator", import("view.base.ContextMediator"))

var0.GET_SCHEDULE_AWARD = "LinerLogBookMediator.GET_SCHEDULE_AWARD"
var0.GET_ROOM_AWARD = "LinerLogBookMediator.GET_ROOM_AWARD"
var0.ON_START_REASONING = "LinerLogBookMediator.ON_START_REASONING"
var0.GET_EVENT_AWARD = "LinerLogBookMediator.GET_EVENT_AWARD"
var0.ON_CLOSE = "LinerLogBookMediator.ON_CLOSE"

function var0.register(arg0)
	arg0:bind(var0.GET_SCHEDULE_AWARD, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 2,
			activity_id = arg1,
			arg1 = arg2,
			drop = arg3
		})
	end)
	arg0:bind(var0.GET_ROOM_AWARD, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 3,
			activity_id = arg1,
			arg1 = arg2,
			drop = arg3
		})
	end)
	arg0:bind(var0.ON_START_REASONING, function(arg0, arg1, arg2)
		arg0.viewComponent:OnStartReasoning(arg1, arg2)
	end)
	arg0:bind(var0.GET_EVENT_AWARD, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ACTIVITY_LINER_OP, {
			cmd = 4,
			activity_id = arg1,
			arg1 = arg2,
			arg2 = arg3,
			drop = arg4
		})
	end)
	arg0:bind(var0.ON_CLOSE, function()
		arg0.viewComponent:onBackPressed()
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ACTIVITY_LINER_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ACTIVITY_LINER_OP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		arg0.viewComponent:UpdateView()
	end
end

return var0
