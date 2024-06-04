local var0 = class("NewCommanderMediator", import("..base.ContextMediator"))

var0.ON_LOCK = "NewCommanderMediator:ON_LOCK"

function var0.register(arg0)
	arg0:bind(var0.ON_LOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMMANDER_LOCK, {
			commanderId = arg1,
			flag = arg2
		})
	end)

	local var0 = arg0.contextData.commander

	assert(var0, "commander can not be nil")
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.COMMANDER_LOCK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.COMMANDER_LOCK_DONE then
		arg0.viewComponent:updateLockState()
	end
end

return var0
