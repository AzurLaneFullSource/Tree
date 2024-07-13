local var0_0 = class("MetaQuickTacticsOverflowMediator", import("...base.ContextMediator"))

var0_0.USE_TACTICS_BOOK = "MetaQuickTacticsOverflowMediator.USE_TACTICS_BOOK"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()
end

function var0_0.bindEvent(arg0_4)
	arg0_4:bind(var0_0.USE_TACTICS_BOOK, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_4:sendNotification(GAME.META_QUICK_TACTICS, {
			shipID = arg1_5,
			skillID = arg2_5,
			useCountDict = arg3_5
		})
	end)
end

return var0_0
