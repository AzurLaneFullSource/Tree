local var0_0 = class("CryptolaliaMediator", import("view.base.ContextMediator"))

var0_0.UNLOCK = "CryptolaliaMediator:UNLOCK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.UNLOCK, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.UNLOCK_CRYPTOLALIA, {
			id = arg1_2,
			costType = arg2_2
		})
	end)

	local var0_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:SetCryptolaliaList(var0_1:GetCryptolaliaList())
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.UNLOCK_CRYPTOLALIA_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.UNLOCK_CRYPTOLALIA_DONE then
		arg0_4.viewComponent:emit(CryptolaliaScene.ON_UNLOCK, var1_4.id)
	end
end

return var0_0
