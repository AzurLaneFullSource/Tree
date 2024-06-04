local var0 = class("MiniHubMediator", import("..BaseMiniGameMediator"))

function var0.register(arg0)
	var0.super.register(arg0)

	local var0 = {}

	arg0.viewComponent:SetExtraData(var0)
end

function var0.OnMiniGameOPeration(arg0, arg1, arg2)
	local var0 = arg0.miniGameProxy:GetHubByGameId(arg0.miniGameId)

	arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
		hubid = var0.id,
		cmd = arg1,
		args1 = arg2
	})
end

function var0.OnMiniGameSuccess(arg0, arg1)
	if arg0.gameRoomData then
		if arg0.gameRoonCoinCount and arg0.gameRoonCoinCount == 0 then
			return
		end

		local var0 = arg1
		local var1 = arg0.gameRoonCoinCount or 1
		local var2 = arg0.gameRoomData.id

		arg0:sendNotification(GAME.GAME_ROOM_SUCCESS, {
			roomId = var2,
			times = var1,
			score = var0
		})
	else
		local var3 = arg0.miniGameProxy:GetHubByGameId(arg0.miniGameId)

		if var3.count <= 0 then
			return
		end

		local var4

		if arg1 and type(arg1) == "table" then
			var4 = arg1
		else
			var4 = {
				arg1
			}
		end

		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var3.id,
			cmd = MiniGameOPCommand.CMD_COMPLETE,
			args1 = var4,
			id = arg0.miniGameId
		})
	end
end

function var0.OnMiniGameFailure(arg0, arg1)
	return
end

function var0.listNotificationInterests(arg0)
	local var0 = {}

	table.insertto(var0, var0.super.listNotificationInterests(arg0))

	return var0
end

function var0.handleNotification(arg0, arg1)
	var0.super.handleNotification(arg0, arg1)
end

return var0
