local var0_0 = class("ChangeChatRoomCommand", pm.SimpleCommand)
local var1_0 = 99

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(PlayerProxy)

	if not var1_1 then
		return
	end

	local var2_1 = var1_1:getData()

	if not var2_1 then
		return
	end

	if not var0_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_not_roomId"))

		return
	end

	if var0_1 > var1_0 or var0_1 < 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_roomId_invaild"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11401, {
		room_id = var0_1
	}, 11402, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:changeChatRoom(arg0_2.room_id or var0_1)
			var1_1:updatePlayer(var2_1)
			getProxy(ChatProxy):clearMsg()
			arg0_1:sendNotification(GAME.CHANGE_CHAT_ROOM_DONE, var2_1)
		elseif arg0_2.result == 6 then
			arg0_1:sendNotification(GAME.CHAT_ROOM_MAX_NUMBER)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_change_chat_room_erro", arg0_2.result))
		end
	end)
end

return var0_0
