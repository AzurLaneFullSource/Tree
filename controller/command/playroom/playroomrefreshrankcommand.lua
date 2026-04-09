local var0_0 = class("PlayRoomRefreshRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().gameType

	pg.ConnectionMgr.GetInstance():Send(23025, {
		game_type = var0_1
	}, 23026, function(arg0_2)
		getProxy(PlayRoomProxy):UpdateRankData(var0_1, arg0_2)
		arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_RANK_DONE)
	end, false)
end

return var0_0
