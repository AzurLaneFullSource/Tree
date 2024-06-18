local var0_0 = class("SixthAnniversaryIslandShopWindowMediator", import("..base.ContextMediator"))

var0_0.SHOPPING_CONFIRM = "SixthAnniversaryIslandShopWindowMediator.SHOPPING_CONFIRM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SHOPPING_CONFIRM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ISLAND_SHOPPING, {
			shop = arg0_1.contextData.shop,
			arg1 = arg0_1.contextData.goods.id,
			arg2 = arg1_2
		})
	end)
	arg0_1.viewComponent:setGoods(arg0_1.contextData.goods)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ISLAND_SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ISLAND_SHOPPING_DONE then
		arg0_4.viewComponent:closeView()
	end
end

return var0_0
