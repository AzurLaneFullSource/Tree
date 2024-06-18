local var0_0 = class("GetGuildRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var1_1:getRawData()
	local var3_1 = {}

	if var2_1.memberCount < 1 then
		var1_1:SetRank(var0_1, var3_1)
	else
		pg.ConnectionMgr.GetInstance():Send(62029, {
			type = var0_1
		}, 62030, function(arg0_2)
			for iter0_2, iter1_2 in ipairs(arg0_2.list) do
				for iter2_2, iter3_2 in ipairs(iter1_2.rankuserinfo) do
					local var0_2 = var2_1:getMemberById(iter3_2.user_id)

					if var0_2 then
						local var1_2 = var3_1[iter3_2.user_id]

						if not var1_2 then
							var1_2 = GuildRank.New(iter3_2.user_id)

							var1_2:SetName(var0_2.name)

							var3_1[var1_2.id] = var1_2
						end

						var1_2:SetScore(iter1_2.period, iter3_2.count)
					end
				end
			end

			var1_1:SetRank(var0_1, var3_1)
			arg0_1:sendNotification(GAME.GUILD_GET_RANK_DONE, {
				id = var0_1,
				list = var3_1
			})
		end)
	end
end

return var0_0
