local var0_0 = class("NewRecommendationShopMediator", import("...base.ContextMediator"))

var0_0.GO_SHOP = "NewRecommendationShopMediator.GO_SHOP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SHOP, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_2, arg2_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		NewShopMainScene.CLOSE_ALL_LAYER
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == NewShopMainScene.CLOSE_ALL_LAYER then
		arg0_4.viewComponent:closeView()
	end
end

return var0_0
