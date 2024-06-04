local var0 = class("ActivityPermanentMediator", import("..base.ContextMediator"))

var0.START_SELECT = "ActivityPermanentMediator.START_SELECT"

function var0.register(arg0)
	arg0:bind(var0.START_SELECT, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_PERMANENT_START, {
			activity_id = arg1
		})
	end)
	arg0.viewComponent:setActivitys(Clone(pg.activity_task_permanent.all))
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ACTIVITY_PERMANENT_START_DONE,
		GAME.ACTIVITY_PERMANENT_FINISH_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ACTIVITY_PERMANENT_START_DONE or var0 == GAME.ACTIVITY_PERMANENT_FINISH_DONE then
		arg0.viewComponent:closeView()
	end
end

return var0
