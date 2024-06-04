local var0 = class("RejectFriendRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(NotificationProxy)

	if var1:getRequestCount() == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_no_request"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50009, {
		id = var0
	}, 50010, function(arg0)
		if arg0.result == 0 then
			if var0 == 0 then
				var1:removeAllRequest()
				pg.TipsMgr.GetInstance():ShowTips(i18n("reject_all_friend_ok"))
			else
				var1:removeRequest(var0)
				pg.TipsMgr.GetInstance():ShowTips(i18n("reject_friend_ok"))
			end

			arg0:sendNotification(GAME.FRIEND_REJECT_REQUEST_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_rejectFriendRequest", arg0.result))
		end
	end)
end

return var0
