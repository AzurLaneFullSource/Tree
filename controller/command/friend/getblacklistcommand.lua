local var0_0 = class("GetBlackListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(50016, {
		type = 0
	}, 50017, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.black_list) do
			local var1_2 = Player.New(iter1_2)

			var0_2[var1_2.id] = var1_2
		end

		getProxy(FriendProxy):setBlackList(var0_2)
		arg0_1:sendNotification(GAME.GET_BLACK_LIST_DONE)
	end)
end

return var0_0
