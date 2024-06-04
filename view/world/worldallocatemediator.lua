local var0 = class("WorldAllocateMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0.viewComponent:setItem(arg0.contextData.itemVO)
	arg0.viewComponent:setFleets(arg0.contextData.fleetList)
	arg0.viewComponent:setConfirmCallback(arg0.contextData.confirmCallback)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORLD_ITEM_USE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORLD_ITEM_USE_DONE then
		arg0.viewComponent:flush(var1.item)
	end
end

return var0
