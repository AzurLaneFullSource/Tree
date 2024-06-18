local var0_0 = class("GetGuildBossRankCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(61029, {
		type = 0
	}, 61030, function(arg0_2)
		local var0_2 = getProxy(GuildProxy)
		local var1_2 = var0_2:getRawData()
		local var2_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.list) do
			local var3_2 = var1_2:getMemberById(iter1_2.user_id)

			if var3_2 then
				table.insert(var2_2, {
					name = var3_2.name,
					damage = iter1_2.damage
				})
			end
		end

		var0_2:UpdateBossRank(var2_2)
		var0_2:UpdateBossRankRefreshTime(pg.TimeMgr.GetInstance():GetServerTime())

		if var0_1 then
			var0_1()
		end

		arg0_1:sendNotification(GAME.GET_GUILD_BOSS_RANK_DONE)
	end)
end

return var0_0
