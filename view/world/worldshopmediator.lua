local var0_0 = class("WorldShopMediator", import("view.base.ContextMediator"))

var0_0.BUY_ITEM = "WorldShopMediator:BUY_ITEM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_2,
			count = arg2_2
		})
	end)

	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getRawData())
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:setPlayer(var1_4)
	elseif var0_4 == GAME.SHOPPING_DONE and #var1_4.awards > 0 then
		arg0_4.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1_4.awards
		})
	end
end

return var0_0
