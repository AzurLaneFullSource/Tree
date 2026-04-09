local var0_0 = class("PlayRoomSwitchRoomTypeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(PlayRoomProxy):GetRoomData()

	if PlayRoomTools.GetHostID() ~= getProxy(PlayerProxy):getPlayerId() then
		return
	end

	local var1_1 = switch(var0_1.roomType, {
		[PlayRoomConst.PLAY_ROOM_TYPE.PERSON] = function()
			return PlayRoomConst.PLAY_ROOM_TYPE.COMMON
		end,
		[PlayRoomConst.PLAY_ROOM_TYPE.COMMON] = function()
			return PlayRoomConst.PLAY_ROOM_TYPE.PERSON
		end
	}, function()
		assert(false)
	end)

	pg.ConnectionMgr.GetInstance():Send(23005, {
		type = var1_1,
		game_type = var0_1.gameType
	}, 23006, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5 = getProxy(PlayRoomProxy)

			var0_5:UpdateRoomData(arg0_5.room)
			var0_5:ClearInviteList()
			var0_5:ClearInviteRecordList()
			arg0_1:sendNotification(GAME.PLAY_ROOM_SWITCH_ROOM_TYPE_DONE)
		elseif arg0_5.result == 19 then
			PlayRoomTools.ShowPunishementBox(arg0_5.cd)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_5.result))
		end
	end)
end

return var0_0
