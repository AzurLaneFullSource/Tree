local var0_0 = class("GetGuildRequestsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60003, {
		id = var0_1
	}, 60004, function(arg0_2)
		local var0_2 = {}
		local var1_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.request_list) do
			local var2_2 = ChatMsg.New(ChatConst.ChannelGuild, {
				player = Player.New(iter1_2.player),
				content = iter1_2.content,
				timestamp = iter1_2.timestamp
			})

			var0_2[var2_2.player.id] = var2_2

			table.insert(var1_2, var2_2)
		end

		getProxy(GuildProxy):setRequestList(var0_2)
		arg0_1:sendNotification(GAME.GUILD_GET_REQUEST_LIST_DONE, var1_2)
	end)
end

return var0_0
