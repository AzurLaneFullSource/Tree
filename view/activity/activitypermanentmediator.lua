local var0_0 = class("ActivityPermanentMediator", import("..base.ContextMediator"))

var0_0.START_SELECT = "ActivityPermanentMediator.START_SELECT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.START_SELECT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_START, {
			activity_id = arg1_2
		})
	end)
	arg0_1.viewComponent:setActivitys(Clone(pg.activity_task_permanent.all))
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ACTIVITY_PERMANENT_START_DONE,
		GAME.ACTIVITY_PERMANENT_FINISH_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ACTIVITY_PERMANENT_START_DONE or var0_4 == GAME.ACTIVITY_PERMANENT_FINISH_DONE then
		arg0_4.viewComponent:closeView()
	end
end

return var0_0
