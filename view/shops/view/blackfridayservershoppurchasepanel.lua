local var0_0 = class("BlackFridayServerShopPurchasePanel", import(".NewServerShopPurchasePanel"))

function var0_0.OnConfirm(arg0_1)
	pg.m02:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING, {
		actType = ActivityConst.ACTIVITY_TYPE_BLACK_FRIDAY_SHOP,
		id = arg0_1.commodity.id,
		selectedList = arg0_1.selectedList
	})
end

return var0_0
