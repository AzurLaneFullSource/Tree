local var0_0 = class("RejectFriendRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(NotificationProxy)

	if var1_1:getRequestCount() == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_no_request"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50009, {
		id = var0_1
	}, 50010, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1 == 0 then
				var1_1:removeAllRequest()
				pg.TipsMgr.GetInstance():ShowTips(i18n("reject_all_friend_ok"))
			else
				var1_1:removeRequest(var0_1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("reject_friend_ok"))
			end

			arg0_1:sendNotification(GAME.FRIEND_REJECT_REQUEST_DONE, var0_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_rejectFriendRequest", arg0_2.result))
		end
	end)
end

return var0_0
