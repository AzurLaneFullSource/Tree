local var0_0 = class("PlayRoomInviteCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23021, {
		user_id = var0_1.id
	}, 23022, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(PlayRoomProxy):AddInviteRecord(var0_1.id)
			arg0_1:sendNotification(GAME.PLAY_ROOM_INVITE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
