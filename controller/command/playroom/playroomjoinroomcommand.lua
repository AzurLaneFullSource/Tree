local var0_0 = class("PlayRoomJoinRoomCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23007, {
		room_id = var0_1.id
	}, 23008, function(arg0_2)
		if arg0_2.result == 0 then
			PlayRoomTools.SetGameTypeID(var0_1.gameType)

			local var0_2 = getProxy(PlayRoomProxy)

			var0_2:UpdateRoomData(arg0_2.room)
			var0_2:ClearInviteList()
			var0_2:ClearInviteRecordList()
			arg0_1:sendNotification(GAME.PLAY_ROOM_JOIN_ROOM_DONE, {
				gameType = var0_1.gameType
			})
		elseif var0_1.id == 0 and arg0_2.result == 20 then
			arg0_1:sendNotification(GAME.PLAY_ROOM_JOIN_ROOM_QUICK_FAIL)
		elseif arg0_2.result == 19 then
			PlayRoomTools.ShowPunishementBox(arg0_2.cd)
		elseif arg0_2.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("match_room_full2"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
