local var0_0 = class("NewSkinMediator", import("..base.ContextMediator"))

var0_0.SET_SKIN = "NewSkinMediator:SET_SKIN"
var0_0.ON_EXIT = "NewSkinMediator:ON_EXIT"

function var0_0.register(arg0_1)
	arg0_1.viewComponent:setSkin(arg0_1.contextData.skinId)
	arg0_1:bind(var0_0.SET_SKIN, function(arg0_2, arg1_2, arg2_2)
		for iter0_2, iter1_2 in ipairs(arg1_2) do
			local var0_2, var1_2 = ShipPhantom.UnpackMark(iter1_2)

			arg0_1:sendNotification(GAME.SET_SHIP_SKIN, {
				shipId = var0_2,
				phantomId = var1_2,
				skinId = arg0_1.contextData.skinId
			})
		end

		getProxy(SettingsProxy):SetFlagShip(arg2_2)

		if arg2_2 then
			local var2_2

			var2_2[1], var2_2 = arg1_2[1], getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()

			arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON, {
				skinPage = true,
				after = var2_2
			})
		end

		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
