local var0_0 = class("EducateShopMediator", import("..base.EducateContextMediator"))

var0_0.ON_SHOPPING = "ON_SHOPPING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_SHOPPING, {
			shopId = arg1_2.shopId,
			goods = arg1_2.goods
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.EDUCATE_SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.EDUCATE_SHOPPING_DONE then
		arg0_4.viewComponent:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
			items = var1_4.drops
		})
		arg0_4.viewComponent:refreshShops()
	end
end

return var0_0
