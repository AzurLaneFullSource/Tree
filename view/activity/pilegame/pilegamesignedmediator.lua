local var0 = class("PileGameSignedMediator", import("...base.ContextMediator"))

var0.ON_GET_AWARD = "PileGameSignedMediator:ON_GET_AWARD"
var0.MINIGAME_ID = 5

function var0.register(arg0)
	local var0 = getProxy(MiniGameProxy)

	arg0:bind(var0.ON_GET_AWARD, function(arg0)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.MINIGAME_ID,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end)

	local var1 = var0:GetHubByHubId(var0.MINIGAME_ID)

	arg0.viewComponent:SetData(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		MiniGameProxy.ON_HUB_DATA_UPDATE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		arg0.viewComponent:SetData(var1)
		arg0.viewComponent:UpdateSigned()
	end
end

return var0
