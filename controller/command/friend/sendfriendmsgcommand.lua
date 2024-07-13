local var0_0 = class("SendFriendMsgCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.playerId
	local var2_1 = var0_1.msg
	local var3_1 = getProxy(FriendProxy)

	if not var3_1:isFriend(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_sendFriendMsg_error_noFriend"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50105, {
		id = var1_1,
		content = var2_1
	}, 50106, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayerProxy)

			var3_1:addChatMsg(var1_1, ChatMsg.New(ChatConst.ChannelFriend, {
				player = var0_2:getData(),
				content = var2_1,
				timestamp = pg.TimeMgr.GetInstance():GetServerTime()
			}))
			arg0_1:sendNotification(GAME.FRIEND_SEND_MSG_DONE)
		elseif arg0_2.result == 28 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_offline"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_sendFriendMsg", arg0_2.result))
		end
	end)
end

return var0_0
