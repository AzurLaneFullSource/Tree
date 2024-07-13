local var0_0 = class("AddBlackListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if var0_1:isFriend() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_player_is_friend_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50109, {
		id = var0_1.id
	}, 50110, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(FriendProxy):addIntoBlackList(var0_1)
			arg0_1:sendNotification(GAME.FRIEND_ADD_BLACKLIST_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_addblacklist_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_addblacklist", arg0_2.result))
		end
	end)
end

return var0_0
