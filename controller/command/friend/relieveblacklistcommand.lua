local var0 = class("RelieveBlackListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(FriendProxy)

	if not var1:getBlackPlayerById(var0) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(50107, {
		id = var0
	}, 50108, function(arg0)
		if arg0.result == 0 then
			var1:relieveBlackListById(var0)
			arg0:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_relieveblacklist_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_relieveblacklist", arg0.result))
		end
	end)
end

return var0
