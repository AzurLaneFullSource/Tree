local var0_0 = class("PlayRoomSwitchViewerCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = 0

	if PlayRoomTools.IsViewer() then
		var1_1 = var0_1.teamIndex
	end

	pg.ConnectionMgr.GetInstance():Send(23009, {
		team_id = var1_1
	}, 23010, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.PLAY_ROOM_SWITCH_VIEWER_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
