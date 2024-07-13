local var0_0 = class("GuildGetReportsCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = getProxy(GuildProxy)

	if not var1_1:ShouldRequestReport() then
		local var2_1 = var1_1:GetReports()

		if var0_1 then
			var0_1(var2_1)
		end

		return
	end

	local var3_1 = getProxy(GuildProxy):GetMaxReportId()

	pg.ConnectionMgr.GetInstance():Send(61017, {
		index = var3_1
	}, 61018, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.reports) do
			local var1_2

			if iter1_2.event_type == GuildConst.REPORT_TYPE_BOSS then
				var1_2 = GuildBossReport.New(iter1_2)
			else
				var1_2 = GuildReport.New(iter1_2)
			end

			var1_1:AddReport(var1_2)
		end

		if var0_1 then
			local var2_2 = var1_1:GetReports()

			var0_1(var2_2)
		end

		arg0_1:sendNotification(GAME.GET_GUILD_REPORT_DONE)
	end)
end

return var0_0
