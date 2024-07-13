local var0_0 = class("PileGameSignedMediator", import("...base.ContextMediator"))

var0_0.ON_GET_AWARD = "PileGameSignedMediator:ON_GET_AWARD"
var0_0.MINIGAME_ID = 5

function var0_0.register(arg0_1)
	local var0_1 = getProxy(MiniGameProxy)

	arg0_1:bind(var0_0.ON_GET_AWARD, function(arg0_2)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_0.MINIGAME_ID,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end)

	local var1_1 = var0_1:GetHubByHubId(var0_0.MINIGAME_ID)

	arg0_1.viewComponent:SetData(var1_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		MiniGameProxy.ON_HUB_DATA_UPDATE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		arg0_4.viewComponent:SetData(var1_4)
		arg0_4.viewComponent:UpdateSigned()
	end
end

return var0_0
