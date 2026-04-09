local var0_0 = class("PlayRoomRefreshRoomInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23003, {
		arg = 1
	}, 23004, function(arg0_2)
		if arg0_2.room.id ~= 0 then
			getProxy(PlayRoomProxy):UpdateRoomData(arg0_2.room)
			arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM_INFO_DONE)
		end
	end, false)
end

return var0_0
