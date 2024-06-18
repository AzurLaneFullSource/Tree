local var0_0 = class("GuildFetchCapitalLogCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)

	if not var1_1:getData() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62011, {
		type = 0
	}, 62012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:getData()
			local var1_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.inclog) do
				local var2_2 = GuildCapitalLog.New(iter1_2)

				table.insert(var1_2, var2_2)
			end

			for iter2_2, iter3_2 in ipairs(arg0_2.declog) do
				local var3_2 = GuildCapitalLog.New(iter3_2)

				table.insert(var1_2, var3_2)
			end

			for iter4_2, iter5_2 in ipairs(arg0_2.otherlog) do
				local var4_2 = GuildCapitalLog.New(iter5_2)

				table.insert(var1_2, var4_2)
			end

			if #var1_2 > 0 then
				var0_2:updateCapitalLogs(var1_2)
				var1_1:updateGuild(var0_2)
			end

			arg0_1:sendNotification(GAME.GUILD_FETCH_CAPITAL_LOG_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
