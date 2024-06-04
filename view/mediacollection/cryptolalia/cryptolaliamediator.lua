local var0 = class("CryptolaliaMediator", import("view.base.ContextMediator"))

var0.UNLOCK = "CryptolaliaMediator:UNLOCK"

function var0.register(arg0)
	arg0:bind(var0.UNLOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.UNLOCK_CRYPTOLALIA, {
			id = arg1,
			costType = arg2
		})
	end)

	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:SetCryptolaliaList(var0:GetCryptolaliaList())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.UNLOCK_CRYPTOLALIA_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.UNLOCK_CRYPTOLALIA_DONE then
		arg0.viewComponent:emit(CryptolaliaScene.ON_UNLOCK, var1.id)
	end
end

return var0
