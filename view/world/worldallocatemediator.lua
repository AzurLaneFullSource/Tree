local var0_0 = class("WorldAllocateMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1.viewComponent:setItem(arg0_1.contextData.itemVO)
	arg0_1.viewComponent:setFleets(arg0_1.contextData.fleetList)
	arg0_1.viewComponent:setConfirmCallback(arg0_1.contextData.confirmCallback)
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.WORLD_ITEM_USE_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.WORLD_ITEM_USE_DONE then
		arg0_3.viewComponent:flush(var1_3.item)
	end
end

return var0_0
