local var0 = class("MetaQuickTacticsMediator", import("...base.ContextMediator"))

var0.USE_TACTICS_BOOK = "MetaQuickTacticsMediator.USE_TACTICS_BOOK"
var0.OPEN_OVERFLOW_LAYER = "MetaQuickTacticsMediator.OPEN_OVERFLOW_LAYER"

function var0.register(arg0)
	arg0:bindEvent()
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.META_QUICK_TACTICS_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.META_QUICK_TACTICS_DONE then
		arg0.viewComponent:updateAfterUse()
		arg0.viewComponent:resetUseData()
		arg0.viewComponent:updateAfterModifyUseCount()
	end
end

function var0.bindEvent(arg0)
	arg0:bind(var0.USE_TACTICS_BOOK, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.META_QUICK_TACTICS, {
			shipID = arg1,
			skillID = arg2,
			useCountDict = arg3
		})
	end)
	arg0:bind(var0.OPEN_OVERFLOW_LAYER, function(arg0, arg1, arg2, arg3, arg4)
		arg0:addSubLayers(Context.New({
			mediator = MetaQuickTacticsOverflowMediator,
			viewComponent = MetaQuickTacticsOverflowLayer,
			data = {
				shipID = arg1,
				skillID = arg2,
				useCountDict = arg3,
				overExp = arg4
			}
		}))
	end)
end

return var0
