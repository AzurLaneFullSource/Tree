local var0_0 = class("PlayRoomStartGameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23017, {
		arg = 1
	}, 23018, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.PLAY_ROOM_START_GAME_DONE)

			if getProxy(PlayRoomProxy):GetRoomData().roomType == PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
				getProxy(PlayRoomProxy):SetStartMatch(true)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
