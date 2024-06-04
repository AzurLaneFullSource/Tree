local var0 = class("WorldShopMediator", import("view.base.ContextMediator"))

var0.BUY_ITEM = "WorldShopMediator:BUY_ITEM"

function var0.register(arg0)
	arg0:bind(var0.BUY_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)

	local var0 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var0:getRawData())
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.SHOPPING_DONE and #var1.awards > 0 then
		arg0.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1.awards
		})
	end
end

return var0
