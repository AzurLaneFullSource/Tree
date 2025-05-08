local var0_0 = class("SharedIslandMediator", import("..View.base.IslandBaseMediator"))

var0_0.EXIT = "SharedIslandMediator:EXIT"

function var0_0._register(arg0_1)
	arg0_1:bind(var0_0.EXIT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ISLAND_EXIT_SHARED, {
			id = arg1_2
		})
	end)
end

function var0_0._listNotificationInterests(arg0_3)
	return {
		GAME.ISLAND_EXIT_SHARED_DONE
	}
end

function var0_0._handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ISLAND_EXIT_SHARED_DONE then
		arg0_4.viewComponent:emit(BaseUI.ON_HOME)
	end
end

return var0_0
