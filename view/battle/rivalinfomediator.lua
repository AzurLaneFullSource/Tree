local var0_0 = class("RivalInfoMediator", import("..base.ContextMediator"))

var0_0.START_BATTLE = "RivalInfoMediator:START_BATTLE"

function var0_0.register(arg0_1)
	assert(arg0_1.contextData.rival, "rival should exist")
	assert(arg0_1.contextData.type, "type should exist")
	arg0_1.viewComponent:setRival(arg0_1.contextData.rival)
	arg0_1:bind(var0_0.START_BATTLE, function(arg0_2)
		local var0_2

		if arg0_1.contextData.type == RivalInfoLayer.TYPE_BATTLE then
			var0_2 = SYSTEM_DUEL
		end

		arg0_1:sendNotification(GAME.MILITARY_STARTED, {
			rivalId = arg0_1.contextData.rival.id,
			system = var0_2
		})
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
