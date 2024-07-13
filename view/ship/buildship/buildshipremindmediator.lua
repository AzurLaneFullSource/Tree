local var0_0 = class("BuildShipRemindMediator", import("...base.ContextMediator"))

var0_0.SHOW_NEW_SHIP = "BuildShipRemindMediator.SHOW_NEW_SHIP"
var0_0.ON_LOCK = "BuildShipRemindMediator.ON_LOCK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SHOW_NEW_SHIP, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_LOCK, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.UPDATE_LOCK, {
			ship_id_list = arg1_3,
			is_locked = arg2_3,
			callback = arg3_3
		})
	end)
	arg0_1.viewComponent:setShips(arg0_1.contextData.ships)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

return var0_0
