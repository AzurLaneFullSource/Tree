local var0_0 = class("MetaQuickTacticsMediator", import("...base.ContextMediator"))

var0_0.USE_TACTICS_BOOK = "MetaQuickTacticsMediator.USE_TACTICS_BOOK"
var0_0.OPEN_OVERFLOW_LAYER = "MetaQuickTacticsMediator.OPEN_OVERFLOW_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.META_QUICK_TACTICS_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.META_QUICK_TACTICS_DONE then
		arg0_3.viewComponent:updateAfterUse()
		arg0_3.viewComponent:resetUseData()
		arg0_3.viewComponent:updateAfterModifyUseCount()
	end
end

function var0_0.bindEvent(arg0_4)
	arg0_4:bind(var0_0.USE_TACTICS_BOOK, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_4:sendNotification(GAME.META_QUICK_TACTICS, {
			shipID = arg1_5,
			skillID = arg2_5,
			useCountDict = arg3_5
		})
	end)
	arg0_4:bind(var0_0.OPEN_OVERFLOW_LAYER, function(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
		arg0_4:addSubLayers(Context.New({
			mediator = MetaQuickTacticsOverflowMediator,
			viewComponent = MetaQuickTacticsOverflowLayer,
			data = {
				shipID = arg1_6,
				skillID = arg2_6,
				useCountDict = arg3_6,
				overExp = arg4_6
			}
		}))
	end)
end

return var0_0
