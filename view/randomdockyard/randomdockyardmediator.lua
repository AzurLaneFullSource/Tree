local var0_0 = class("RandomDockYardMediator", import("view.base.ContextMediator"))

var0_0.OPEN_INDEX = "RandomDockYardMediator:OPEN_INDEX"
var0_0.ON_ADD_SHIPS = "RandomDockYardMediator:ON_ADD_SHIPS"
var0_0.ON_REMOVE_SHIPS = "RandomDockYardMediator:ON_REMOVE_SHIPS"
var0_0.OPEN_PHANTOM_LAYER = "RandomDockYardMediator.OPEN_PHANTOM_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ADD_SHIPS, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = underscore.map(arg1_2, function(arg0_3)
				return ShipPhantom.PackMark(arg0_3, 0)
			end),
			deleteList = {}
		})
	end)
	arg0_1:bind(var0_0.ON_REMOVE_SHIPS, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = {},
			deleteList = underscore.map(arg1_4, function(arg0_5)
				return ShipPhantom.PackMark(arg0_5, 0)
			end)
		})
	end)
	arg0_1:bind(var0_0.OPEN_INDEX, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = RandomDockYardIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_6
		}))
	end)
	arg0_1:bind(var0_0.OPEN_PHANTOM_LAYER, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			mediator = DockyardMediator,
			viewComponent = DockyardScene,
			data = {
				mode = DockyardScene.MODE_SHIP_PHANTOM
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.CHANGE_RANDOM_SHIPS_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.CHANGE_RANDOM_SHIPS_DONE then
		arg0_9.viewComponent:OnChangeRandomShips()
	end
end

return var0_0
