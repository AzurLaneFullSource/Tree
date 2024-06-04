local var0 = class("GetGuildRequestsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60003, {
		id = var0
	}, 60004, function(arg0)
		local var0 = {}
		local var1 = {}

		for iter0, iter1 in ipairs(arg0.request_list) do
			local var2 = ChatMsg.New(ChatConst.ChannelGuild, {
				player = Player.New(iter1.player),
				content = iter1.content,
				timestamp = iter1.timestamp
			})

			var0[var2.player.id] = var2

			table.insert(var1, var2)
		end

		getProxy(GuildProxy):setRequestList(var0)
		arg0:sendNotification(GAME.GUILD_GET_REQUEST_LIST_DONE, var1)
	end)
end

return var0
