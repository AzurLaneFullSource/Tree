local var0_0 = class("MiniHubMediator", import("..BaseMiniGameMediator"))

function var0_0.register(arg0_1)
	var0_0.super.register(arg0_1)

	local var0_1 = {}

	arg0_1.viewComponent:SetExtraData(var0_1)
end

function var0_0.OnMiniGameOPeration(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.miniGameProxy:GetHubByGameId(arg0_2.miniGameId)

	arg0_2:sendNotification(GAME.SEND_MINI_GAME_OP, {
		hubid = var0_2.id,
		cmd = arg1_2,
		args1 = arg2_2
	})
end

function var0_0.OnMiniGameSuccess(arg0_3, arg1_3)
	if arg0_3.gameRoomData then
		if arg0_3.gameRoonCoinCount and arg0_3.gameRoonCoinCount == 0 then
			return
		end

		local var0_3 = arg1_3
		local var1_3 = arg0_3.gameRoonCoinCount or 1
		local var2_3 = arg0_3.gameRoomData.id

		arg0_3:sendNotification(GAME.GAME_ROOM_SUCCESS, {
			roomId = var2_3,
			times = var1_3,
			score = var0_3
		})
	else
		local var3_3 = arg0_3.miniGameProxy:GetHubByGameId(arg0_3.miniGameId)

		if var3_3.count <= 0 then
			return
		end

		local var4_3

		if arg1_3 and type(arg1_3) == "table" then
			var4_3 = arg1_3
		else
			var4_3 = {
				arg1_3
			}
		end

		arg0_3:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var3_3.id,
			cmd = MiniGameOPCommand.CMD_COMPLETE,
			args1 = var4_3,
			id = arg0_3.miniGameId
		})
	end
end

function var0_0.OnMiniGameFailure(arg0_4, arg1_4)
	return
end

function var0_0.listNotificationInterests(arg0_5)
	local var0_5 = {}

	table.insertto(var0_5, var0_0.super.listNotificationInterests(arg0_5))

	return var0_5
end

function var0_0.handleNotification(arg0_6, arg1_6)
	var0_0.super.handleNotification(arg0_6, arg1_6)
end

return var0_0
