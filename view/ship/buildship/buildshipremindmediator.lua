local var0 = class("BuildShipRemindMediator", import("...base.ContextMediator"))

var0.SHOW_NEW_SHIP = "BuildShipRemindMediator.SHOW_NEW_SHIP"
var0.ON_LOCK = "BuildShipRemindMediator.ON_LOCK"

function var0.register(arg0)
	arg0:bind(var0.SHOW_NEW_SHIP, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_LOCK, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.UPDATE_LOCK, {
			ship_id_list = arg1,
			is_locked = arg2,
			callback = arg3
		})
	end)
	arg0.viewComponent:setShips(arg0.contextData.ships)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
