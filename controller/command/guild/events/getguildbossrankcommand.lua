local var0 = class("GetGuildBossRankCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(61029, {
		type = 0
	}, 61030, function(arg0)
		local var0 = getProxy(GuildProxy)
		local var1 = var0:getRawData()
		local var2 = {}

		for iter0, iter1 in ipairs(arg0.list) do
			local var3 = var1:getMemberById(iter1.user_id)

			if var3 then
				table.insert(var2, {
					name = var3.name,
					damage = iter1.damage
				})
			end
		end

		var0:UpdateBossRank(var2)
		var0:UpdateBossRankRefreshTime(pg.TimeMgr.GetInstance():GetServerTime())

		if var0 then
			var0()
		end

		arg0:sendNotification(GAME.GET_GUILD_BOSS_RANK_DONE)
	end)
end

return var0
