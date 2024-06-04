local var0 = class("NewSkinMediator", import("..base.ContextMediator"))

var0.SET_SKIN = "NewSkinMediator:SET_SKIN"
var0.ON_EXIT = "NewSkinMediator:ON_EXIT"

function var0.register(arg0)
	arg0.viewComponent:setSkin(arg0.contextData.skinId)
	arg0:bind(var0.SET_SKIN, function(arg0, arg1, arg2)
		for iter0, iter1 in ipairs(arg1) do
			arg0:sendNotification(GAME.SET_SHIP_SKIN, {
				shipId = iter1,
				skinId = arg0.contextData.skinId
			})
		end

		getProxy(SettingsProxy):SetFlagShip(arg2)

		if arg2 then
			local var0 = arg1[1]

			arg0:sendNotification(GAME.CHANGE_PLAYER_ICON, {
				skinPage = true,
				characterId = var0
			})
		end

		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)

	local var0 = getProxy(BayProxy):getData()

	arg0.viewComponent:setShipVOs(var0)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
