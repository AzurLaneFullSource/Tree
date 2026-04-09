local var0_0 = class("PlayRoomReadyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23015, {
		arg = var0_1.arg
	}, 23016, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.PLAY_ROOM_READY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
