local var0_0 = class("RelieveBlackListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(FriendProxy)

	if not var1_1:getBlackPlayerById(var0_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(50107, {
		id = var0_1
	}, 50108, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:relieveBlackListById(var0_1)
			arg0_1:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_relieveblacklist_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_relieveblacklist", arg0_2.result))
		end
	end)
end

return var0_0
