local var0_0 = class("ChargeActGiftMediator", import("view.base.ContextMediator"))

var0_0.DO_PAY = "ChargeActGiftMediator.DO_PAY"
var0_0.GO_SHOP = "ChargeActGiftMediator.GO_SHOP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.DO_PAY, function(arg0_2)
		local var0_2 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId)

		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = var0_2.id,
			costDrop = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResDiamond,
				count = GiftActCommodity.CalcPrice(var0_2)
			})
		})
	end)
	arg0_1:bind(var0_0.GO_SHOP, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_OPERATION_DONE and var1_5 == arg0_5.contextData.actId then
		arg0_5.viewComponent:closeView()
	end
end

return var0_0
