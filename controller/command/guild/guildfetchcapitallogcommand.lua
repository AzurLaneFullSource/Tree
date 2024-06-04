local var0 = class("GuildFetchCapitalLogCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)

	if not var1:getData() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62011, {
		type = 0
	}, 62012, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:getData()
			local var1 = {}

			for iter0, iter1 in ipairs(arg0.inclog) do
				local var2 = GuildCapitalLog.New(iter1)

				table.insert(var1, var2)
			end

			for iter2, iter3 in ipairs(arg0.declog) do
				local var3 = GuildCapitalLog.New(iter3)

				table.insert(var1, var3)
			end

			for iter4, iter5 in ipairs(arg0.otherlog) do
				local var4 = GuildCapitalLog.New(iter5)

				table.insert(var1, var4)
			end

			if #var1 > 0 then
				var0:updateCapitalLogs(var1)
				var1:updateGuild(var0)
			end

			arg0:sendNotification(GAME.GUILD_FETCH_CAPITAL_LOG_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
