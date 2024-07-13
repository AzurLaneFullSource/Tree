local var0_0 = class("DeleteFriendCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(FriendProxy):getFriend(var0_1)

	pg.ConnectionMgr.GetInstance():Send(50011, {
		id = var0_1
	}, 50012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(DormProxy):GetVisitorShip()

			if var0_2 and var0_2.name == var1_1.name then
				getProxy(DormProxy):SetVisitorShip(nil)
			end

			arg0_1:sendNotification(GAME.FRIEND_DELETE_DONE, var0_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_deleteFriend", arg0_2.result))
		end
	end)
end

return var0_0
