local var0_0 = class("BuildShipRegularExchangeMediator", import("...base.ContextMediator"))

var0_0.EXCHAGNE_SHIP = "BuildShipRegularExchangeMediator.EXCHAGNE_SHIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EXCHAGNE_SHIP, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.REGULAR_BUILD_POOL_EXCHANGE, {
			id = arg1_2
		})
	end)
	arg0_1.viewComponent:setCount(getProxy(BuildShipProxy):getRegularExchangeCount())
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
