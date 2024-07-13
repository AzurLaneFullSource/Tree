local var0_0 = class("SendFriendRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.msg
	local var3_1 = getProxy(PlayerProxy):getData()

	if wordVer(var2_1) > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_msg_forbid"))

		return
	end

	if var3_1.id == var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dont_add_self"))

		return
	end

	local var4_1 = getProxy(FriendProxy)

	if var4_1:isFriend(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_already_add"))

		return
	end

	if var4_1:getFriendCount() == MAX_FRIEND_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_max_count"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50003, {
		id = var1_1,
		content = var2_1
	}, 50004, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.FRIEND_SEND_REQUEST_DONE, var1_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_sendFriendRequest_success"))
		elseif arg0_2.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_sendFriendRequest_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_sendFriendRequest", arg0_2.result))
		end
	end)
end

return var0_0
