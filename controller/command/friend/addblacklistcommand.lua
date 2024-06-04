local var0 = class("AddBlackListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if var0:isFriend() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_player_is_friend_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50109, {
		id = var0.id
	}, 50110, function(arg0)
		if arg0.result == 0 then
			getProxy(FriendProxy):addIntoBlackList(var0)
			arg0:sendNotification(GAME.FRIEND_ADD_BLACKLIST_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_addblacklist_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_addblacklist", arg0.result))
		end
	end)
end

return var0
