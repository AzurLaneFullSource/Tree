local var0_0 = class("BatchGetFriendsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = {}
	local var3_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1.list) do
		local var4_1 = getProxy(IslandProxy):GetPlayerDataCache(iter1_1)

		if not var4_1 then
			table.insert(var3_1, iter1_1)
		else
			table.insert(var2_1, var4_1)
		end
	end

	if #var3_1 == 0 then
		var1_1(var2_1)
		arg0_1:sendNotification(GAME.BATCH_GET_FRIEND_DONE)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50018, {
		user_id_list = var3_1
	}, 50019, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.user_list) do
			local var0_2 = Friend.New(iter1_2)

			table.insert(var2_1, var0_2)
			getProxy(IslandProxy):AddPlayerDataCache(var0_2)
		end

		var1_1(var2_1)
		arg0_1:sendNotification(GAME.BATCH_GET_FRIEND_DONE)
	end)
end

return var0_0
