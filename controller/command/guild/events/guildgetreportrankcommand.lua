local var0 = class("GuildGetReportRankCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(GuildProxy)
	local var2 = var1:GetReportRankList(var0)

	if var2 then
		arg0:sendNotification(GAME.GET_GUILD_REPORT_RANK_DONE, {
			ranks = var2
		})
	else
		pg.ConnectionMgr.GetInstance():Send(61037, {
			id = var0
		}, 61038, function(arg0)
			local var0 = var1:getRawData()
			local var1 = {}

			for iter0, iter1 in ipairs(arg0.list) do
				local var2 = var0:getMemberById(iter1.user_id)

				if var2 then
					table.insert(var1, {
						name = var2.name,
						damage = iter1.damage
					})
				end
			end

			table.sort(var1, function(arg0, arg1)
				return arg0.damage > arg1.damage
			end)
			var1:SetReportRankList(var0, var1)
			arg0:sendNotification(GAME.GET_GUILD_REPORT_RANK_DONE, {
				ranks = var1
			})
		end)
	end
end

return var0
