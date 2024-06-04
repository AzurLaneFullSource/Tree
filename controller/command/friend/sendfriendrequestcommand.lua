local var0 = class("SendFriendRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.msg
	local var3 = getProxy(PlayerProxy):getData()

	if wordVer(var2) > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_msg_forbid"))

		return
	end

	if var3.id == var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dont_add_self"))

		return
	end

	local var4 = getProxy(FriendProxy)

	if var4:isFriend(var1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_already_add"))

		return
	end

	if var4:getFriendCount() == MAX_FRIEND_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_max_count"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50003, {
		id = var1,
		content = var2
	}, 50004, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.FRIEND_SEND_REQUEST_DONE, var1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_sendFriendRequest_success"))
		elseif arg0.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_sendFriendRequest_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_sendFriendRequest", arg0.result))
		end
	end)
end

return var0
