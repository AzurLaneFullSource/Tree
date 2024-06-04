local var0 = class("RandomDockYardMediator", import("view.base.ContextMediator"))

var0.OPEN_INDEX = "RandomDockYardMediator:OPEN_INDEX"
var0.ON_ADD_SHIPS = "RandomDockYardMediator:ON_ADD_SHIPS"
var0.ON_REMOVE_SHIPS = "RandomDockYardMediator:ON_REMOVE_SHIPS"

function var0.register(arg0)
	arg0:bind(var0.ON_ADD_SHIPS, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = arg1,
			deleteList = {}
		})
	end)
	arg0:bind(var0.ON_REMOVE_SHIPS, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = {},
			deleteList = arg1
		})
	end)
	arg0:bind(var0.OPEN_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = RandomDockYardIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CHANGE_RANDOM_SHIPS_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CHANGE_RANDOM_SHIPS_DONE then
		arg0.viewComponent:OnChangeRandomShips()
	end
end

return var0
