local var0_0 = class("PlayRoomQuickMatchCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23418, {
		type = var0_1.type
	}, 23419, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.PLAY_ROOM_QUICK_MATCH_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
