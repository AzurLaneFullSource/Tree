local var0_0 = class("RandomDockYardMediator", import("view.base.ContextMediator"))

var0_0.OPEN_INDEX = "RandomDockYardMediator:OPEN_INDEX"
var0_0.ON_ADD_SHIPS = "RandomDockYardMediator:ON_ADD_SHIPS"
var0_0.ON_REMOVE_SHIPS = "RandomDockYardMediator:ON_REMOVE_SHIPS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ADD_SHIPS, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = arg1_2,
			deleteList = {}
		})
	end)
	arg0_1:bind(var0_0.ON_REMOVE_SHIPS, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = {},
			deleteList = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_INDEX, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = RandomDockYardIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_4
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.CHANGE_RANDOM_SHIPS_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.CHANGE_RANDOM_SHIPS_DONE then
		arg0_6.viewComponent:OnChangeRandomShips()
	end
end

return var0_0
