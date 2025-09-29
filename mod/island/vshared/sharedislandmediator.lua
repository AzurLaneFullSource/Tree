local var0_0 = class("SharedIslandMediator", import("..View.base.IslandBaseMediator"))

var0_0.EXIT = "SharedIslandMediator:EXIT"
var0_0.RETURN_SELF_ISLAND = "SharedIslandMediator:RETURN_SELF_ISLAND"

function var0_0._register(arg0_1)
	arg0_1:bind(IslandMediator.SELECT_GIFT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ISLAND_SELECT_GIFT, {
			islandId = arg1_2,
			pos = arg2_2
		})
	end)
	arg0_1:bind(var0_0.EXIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ISLAND_EXIT_SHARED, {
			id = arg1_3
		})
	end)
	arg0_1:bind(var0_0.RETURN_SELF_ISLAND, function(arg0_4)
		local var0_4 = arg0_1.viewComponent:GetIsland()
		local var1_4 = getProxy(IslandProxy):GetIsland()

		pg.m02:sendNotification(GAME.ISLAND_EXIT, {
			id = var0_4.id,
			callback = function()
				pg.m02:sendNotification(GAME.ISLAND_ENTER, {
					id = var1_4.id
				})
			end
		})
	end)
end

function var0_0._listNotificationInterests(arg0_6)
	return {
		GAME.ISLAND_EXIT_SHARED_DONE
	}
end

function var0_0._handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.ISLAND_EXIT_SHARED_DONE then
		arg0_7.viewComponent:emit(BaseUI.ON_HOME)
	end
end

return var0_0
