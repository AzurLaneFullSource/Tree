local var0 = class("ZumaPTShopWindowMediator", import("...base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ISLAND_SHOPPING_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ISLAND_SHOPPING_DONE then
		arg0.viewComponent:closeView()
	end
end

return var0
