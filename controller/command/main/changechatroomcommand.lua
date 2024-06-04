local var0 = class("ChangeChatRoomCommand", pm.SimpleCommand)
local var1 = 99

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(PlayerProxy)

	if not var1 then
		return
	end

	local var2 = var1:getData()

	if not var2 then
		return
	end

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_not_roomId"))

		return
	end

	if var0 > var1 or var0 < 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_roomId_invaild"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11401, {
		room_id = var0
	}, 11402, function(arg0)
		if arg0.result == 0 then
			var2:changeChatRoom(arg0.room_id or var0)
			var1:updatePlayer(var2)
			getProxy(ChatProxy):clearMsg()
			arg0:sendNotification(GAME.CHANGE_CHAT_ROOM_DONE, var2)
		elseif arg0.result == 6 then
			arg0:sendNotification(GAME.CHAT_ROOM_MAX_NUMBER)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_change_chat_room_erro", arg0.result))
		end
	end)
end

return var0
