local var0 = class("GetGuildChatListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = GuildConst.CHAT_LOG_MAX_COUNT
	local var2 = getProxy(GuildProxy)
	local var3 = var2:getData()

	if not var3 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(60100, {
		count = var1
	}, 60101, function(arg0)
		var2.isGetChatMsg = true

		local var0 = {}

		for iter0, iter1 in ipairs(arg0.chat_list or {}) do
			local var1 = var3:warpChatInfo(iter1)

			var2:addMsg(var1)
		end

		arg0:sendNotification(GAME.GET_GUILD_CHAT_LIST_DONE)
	end)
end

return var0
