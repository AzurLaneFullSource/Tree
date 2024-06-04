local var0 = class("DeleteFriendCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(FriendProxy):getFriend(var0)

	pg.ConnectionMgr.GetInstance():Send(50011, {
		id = var0
	}, 50012, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(DormProxy):GetVisitorShip()

			if var0 and var0.name == var1.name then
				getProxy(DormProxy):SetVisitorShip(nil)
			end

			arg0:sendNotification(GAME.FRIEND_DELETE_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_deleteFriend", arg0.result))
		end
	end)
end

return var0
