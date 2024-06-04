local var0 = class("SixthAnniversaryIslandShopWindowMediator", import("..base.ContextMediator"))

var0.SHOPPING_CONFIRM = "SixthAnniversaryIslandShopWindowMediator.SHOPPING_CONFIRM"

function var0.register(arg0)
	arg0:bind(var0.SHOPPING_CONFIRM, function(arg0, arg1)
		arg0:sendNotification(GAME.ISLAND_SHOPPING, {
			shop = arg0.contextData.shop,
			arg1 = arg0.contextData.goods.id,
			arg2 = arg1
		})
	end)
	arg0.viewComponent:setGoods(arg0.contextData.goods)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ISLAND_SHOPPING_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ISLAND_SHOPPING_DONE then
		arg0.viewComponent:closeView()
	end
end

return var0
