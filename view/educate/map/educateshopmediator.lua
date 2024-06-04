local var0 = class("EducateShopMediator", import("..base.EducateContextMediator"))

var0.ON_SHOPPING = "ON_SHOPPING"

function var0.register(arg0)
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_SHOPPING, {
			shopId = arg1.shopId,
			goods = arg1.goods
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EDUCATE_SHOPPING_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EDUCATE_SHOPPING_DONE then
		arg0.viewComponent:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
			items = var1.drops
		})
		arg0.viewComponent:refreshShops()
	end
end

return var0
