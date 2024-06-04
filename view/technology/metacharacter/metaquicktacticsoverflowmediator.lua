local var0 = class("MetaQuickTacticsOverflowMediator", import("...base.ContextMediator"))

var0.USE_TACTICS_BOOK = "MetaQuickTacticsOverflowMediator.USE_TACTICS_BOOK"

function var0.register(arg0)
	arg0:bindEvent()
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

function var0.bindEvent(arg0)
	arg0:bind(var0.USE_TACTICS_BOOK, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.META_QUICK_TACTICS, {
			shipID = arg1,
			skillID = arg2,
			useCountDict = arg3
		})
	end)
end

return var0
