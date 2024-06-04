local var0 = class("SubmitGuildReportCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.ids
	local var2 = getProxy(GuildProxy)
	local var3 = var2:getRawData()
	local var4 = getProxy(PlayerProxy):getRawData().id

	if var3:getMemberById(var4):IsRecruit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_duty_is_too_low"))

		return
	end

	if _.any(var1, function(arg0)
		return not var2:GetReportById(arg0):CanSubmit()
	end) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_get_report_failed"))

		return
	end

	local var5 = var0.callback

	pg.ConnectionMgr.GetInstance():Send(61019, {
		ids = var1
	}, 61020, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			for iter0, iter1 in ipairs(var1) do
				var2:GetReportById(iter1):Submit()
			end

			arg0:sendNotification(GAME.SUBMIT_GUILD_REPORT_DONE, {
				awards = var0,
				list = var1,
				callback = var5
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
