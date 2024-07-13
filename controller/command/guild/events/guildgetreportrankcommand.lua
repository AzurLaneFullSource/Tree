local var0_0 = class("GuildGetReportRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var1_1:GetReportRankList(var0_1)

	if var2_1 then
		arg0_1:sendNotification(GAME.GET_GUILD_REPORT_RANK_DONE, {
			ranks = var2_1
		})
	else
		pg.ConnectionMgr.GetInstance():Send(61037, {
			id = var0_1
		}, 61038, function(arg0_2)
			local var0_2 = var1_1:getRawData()
			local var1_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.list) do
				local var2_2 = var0_2:getMemberById(iter1_2.user_id)

				if var2_2 then
					table.insert(var1_2, {
						name = var2_2.name,
						damage = iter1_2.damage
					})
				end
			end

			table.sort(var1_2, function(arg0_3, arg1_3)
				return arg0_3.damage > arg1_3.damage
			end)
			var1_1:SetReportRankList(var0_1, var1_2)
			arg0_1:sendNotification(GAME.GET_GUILD_REPORT_RANK_DONE, {
				ranks = var1_2
			})
		end)
	end
end

return var0_0
