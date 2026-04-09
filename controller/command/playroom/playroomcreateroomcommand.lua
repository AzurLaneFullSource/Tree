local var0_0 = class("PlayRoomCreateRoomCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23005, {
		type = var0_1.type,
		game_type = var0_1.gameType
	}, 23006, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayRoomProxy)

			var0_2:UpdateRoomData(arg0_2.room)
			var0_2:ClearInviteList()
			var0_2:ClearInviteRecordList()
			arg0_1:sendNotification(GAME.PLAY_ROOM_CREATE_ROOM_DONE)
		elseif arg0_2.result == 19 then
			PlayRoomTools.ShowPunishementBox(arg0_2.cd)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
