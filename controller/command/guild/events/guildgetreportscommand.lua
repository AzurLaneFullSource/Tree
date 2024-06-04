local var0 = class("GuildGetReportsCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = getProxy(GuildProxy)

	if not var1:ShouldRequestReport() then
		local var2 = var1:GetReports()

		if var0 then
			var0(var2)
		end

		return
	end

	local var3 = getProxy(GuildProxy):GetMaxReportId()

	pg.ConnectionMgr.GetInstance():Send(61017, {
		index = var3
	}, 61018, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.reports) do
			local var1

			if iter1.event_type == GuildConst.REPORT_TYPE_BOSS then
				var1 = GuildBossReport.New(iter1)
			else
				var1 = GuildReport.New(iter1)
			end

			var1:AddReport(var1)
		end

		if var0 then
			local var2 = var1:GetReports()

			var0(var2)
		end

		arg0:sendNotification(GAME.GET_GUILD_REPORT_DONE)
	end)
end

return var0
