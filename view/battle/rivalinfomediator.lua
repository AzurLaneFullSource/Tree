local var0 = class("RivalInfoMediator", import("..base.ContextMediator"))

var0.START_BATTLE = "RivalInfoMediator:START_BATTLE"

function var0.register(arg0)
	assert(arg0.contextData.rival, "rival should exist")
	assert(arg0.contextData.type, "type should exist")
	arg0.viewComponent:setRival(arg0.contextData.rival)
	arg0:bind(var0.START_BATTLE, function(arg0)
		local var0

		if arg0.contextData.type == RivalInfoLayer.TYPE_BATTLE then
			var0 = SYSTEM_DUEL
		end

		arg0:sendNotification(GAME.MILITARY_STARTED, {
			rivalId = arg0.contextData.rival.id,
			system = var0
		})
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
