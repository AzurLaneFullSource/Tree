local var0 = class("GetGuildRankCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(GuildProxy)
	local var2 = var1:getRawData()
	local var3 = {}

	if var2.memberCount < 1 then
		var1:SetRank(var0, var3)
	else
		pg.ConnectionMgr.GetInstance():Send(62029, {
			type = var0
		}, 62030, function(arg0)
			for iter0, iter1 in ipairs(arg0.list) do
				for iter2, iter3 in ipairs(iter1.rankuserinfo) do
					local var0 = var2:getMemberById(iter3.user_id)

					if var0 then
						local var1 = var3[iter3.user_id]

						if not var1 then
							var1 = GuildRank.New(iter3.user_id)

							var1:SetName(var0.name)

							var3[var1.id] = var1
						end

						var1:SetScore(iter1.period, iter3.count)
					end
				end
			end

			var1:SetRank(var0, var3)
			arg0:sendNotification(GAME.GUILD_GET_RANK_DONE, {
				id = var0,
				list = var3
			})
		end)
	end
end

return var0
