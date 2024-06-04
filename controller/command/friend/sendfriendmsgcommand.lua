local var0 = class("SendFriendMsgCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.playerId
	local var2 = var0.msg
	local var3 = getProxy(FriendProxy)

	if not var3:isFriend(var1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_sendFriendMsg_error_noFriend"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50105, {
		id = var1,
		content = var2
	}, 50106, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy)

			var3:addChatMsg(var1, ChatMsg.New(ChatConst.ChannelFriend, {
				player = var0:getData(),
				content = var2,
				timestamp = pg.TimeMgr.GetInstance():GetServerTime()
			}))
			arg0:sendNotification(GAME.FRIEND_SEND_MSG_DONE)
		elseif arg0.result == 28 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_offline"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_sendFriendMsg", arg0.result))
		end
	end)
end

return var0
