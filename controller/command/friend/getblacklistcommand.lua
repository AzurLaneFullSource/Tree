local var0 = class("GetBlackListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(50016, {
		type = 0
	}, 50017, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.black_list) do
			local var1 = Player.New(iter1)

			var0[var1.id] = var1
		end

		getProxy(FriendProxy):setBlackList(var0)
		arg0:sendNotification(GAME.GET_BLACK_LIST_DONE)
	end)
end

return var0
