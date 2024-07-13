local var0_0 = class("NewCommanderMediator", import("..base.ContextMediator"))

var0_0.ON_LOCK = "NewCommanderMediator:ON_LOCK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_LOCK, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.COMMANDER_LOCK, {
			commanderId = arg1_2,
			flag = arg2_2
		})
	end)

	local var0_1 = arg0_1.contextData.commander

	assert(var0_1, "commander can not be nil")
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.COMMANDER_LOCK_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.COMMANDER_LOCK_DONE then
		arg0_4.viewComponent:updateLockState()
	end
end

return var0_0
