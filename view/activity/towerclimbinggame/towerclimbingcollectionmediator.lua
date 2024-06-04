local var0 = class("TowerClimbingCollectionMediator", import("...base.ContextMediator"))

var0.ON_GET = "TowerClimbingCollectionMediator:ON_GET"

function var0.register(arg0)
	arg0:bind(var0.ON_GET, function(arg0, arg1)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				MiniGameDataCreator.TowerClimbingGameID,
				2,
				arg1
			}
		})
	end)

	local var0 = getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.TowerClimbingGameID):clone()

	arg0.viewComponent:SetData(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SEND_MINI_GAME_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SEND_MINI_GAME_OP_DONE and var1.hubid == 9 and var1.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and var1.argList[1] == MiniGameDataCreator.TowerClimbingGameID and var1.argList[2] == 2 then
		local var2 = getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.TowerClimbingGameID)

		arg0.viewComponent:SetData(var2)
		arg0.viewComponent:OpenBook(var1.argList[3])
		arg0.viewComponent:UpdateTip()
	end
end

return var0
