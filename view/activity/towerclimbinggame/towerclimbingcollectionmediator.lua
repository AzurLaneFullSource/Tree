local var0_0 = class("TowerClimbingCollectionMediator", import("...base.ContextMediator"))

var0_0.ON_GET = "TowerClimbingCollectionMediator:ON_GET"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_GET, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				MiniGameDataCreator.TowerClimbingGameID,
				2,
				arg1_2
			}
		})
	end)

	local var0_1 = getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.TowerClimbingGameID):clone()

	arg0_1.viewComponent:SetData(var0_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.SEND_MINI_GAME_OP_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.SEND_MINI_GAME_OP_DONE and var1_4.hubid == 9 and var1_4.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and var1_4.argList[1] == MiniGameDataCreator.TowerClimbingGameID and var1_4.argList[2] == 2 then
		local var2_4 = getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.TowerClimbingGameID)

		arg0_4.viewComponent:SetData(var2_4)
		arg0_4.viewComponent:OpenBook(var1_4.argList[3])
		arg0_4.viewComponent:UpdateTip()
	end
end

return var0_0
