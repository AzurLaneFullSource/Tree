local var0_0 = class("ShipGiftMediator", import("view.base.ContextMediator"))

var0_0.SHIP_GIFT = "ShipGiftMediator:shipGift"
var0_0.ADD_SHIP_INTIMACY = "ShipGiftMediator:addShipIntimacy"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SHIP_GIFT, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_2,
			count = arg2_2,
			arg = {
				arg3_2
			}
		})
	end)
	arg0_1:bind(var0_0.ADD_SHIP_INTIMACY, function(arg0_3, arg1_3, arg2_3)
		local var0_3 = arg1_3.id

		getProxy(BayProxy):RawGetShipById(var0_3):addLikability(arg2_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.USE_ITEM_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.USE_ITEM_DONE then
		local var2_5 = var1_5.drops[1] and var1_5.drops[1].count or 0

		arg0_5.viewComponent:OnGiftSuccess(var2_5)
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
