local var0_0 = class("Dorm3dShopDetailMediator", import("view.base.ContextMediator"))

var0_0.SHOPPING = "Dorm3dShopDetailMediator.SHOPPING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SHOPPING, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_2.shopId,
			count = arg1_2.count,
			silentTip = arg1_2.silentTip
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.SHOPPING_DONE then
		arg0_4.viewComponent:closeView()
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
