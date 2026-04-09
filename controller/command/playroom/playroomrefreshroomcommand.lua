local var0_0 = class("PlayRoomRefreshRoomCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23001, {
		arg = 1
	}, 23002, function(arg0_2)
		getProxy(PlayRoomProxy):UpdateRoomList(arg0_2.room_list)
		arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM_DONE)
	end, false)
end

return var0_0
