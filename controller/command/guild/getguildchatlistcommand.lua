local var0_0 = class("GetGuildChatListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = GuildConst.CHAT_LOG_MAX_COUNT
	local var2_1 = getProxy(GuildProxy)
	local var3_1 = var2_1:getData()

	if not var3_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(60100, {
		count = var1_1
	}, 60101, function(arg0_2)
		var2_1.isGetChatMsg = true

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.chat_list or {}) do
			local var1_2 = var3_1:warpChatInfo(iter1_2)

			var2_1:addMsg(var1_2)
		end

		arg0_1:sendNotification(GAME.GET_GUILD_CHAT_LIST_DONE)
	end)
end

return var0_0
