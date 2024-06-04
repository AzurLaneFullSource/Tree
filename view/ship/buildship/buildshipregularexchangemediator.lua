local var0 = class("BuildShipRegularExchangeMediator", import("...base.ContextMediator"))

var0.EXCHAGNE_SHIP = "BuildShipRegularExchangeMediator.EXCHAGNE_SHIP"

function var0.register(arg0)
	arg0:bind(var0.EXCHAGNE_SHIP, function(arg0, arg1)
		arg0:sendNotification(GAME.REGULAR_BUILD_POOL_EXCHANGE, {
			id = arg1
		})
	end)
	arg0.viewComponent:setCount(getProxy(BuildShipProxy):getRegularExchangeCount())
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
