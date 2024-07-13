local var0_0 = class("SubmitGuildReportCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ids
	local var2_1 = getProxy(GuildProxy)
	local var3_1 = var2_1:getRawData()
	local var4_1 = getProxy(PlayerProxy):getRawData().id

	if var3_1:getMemberById(var4_1):IsRecruit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_duty_is_too_low"))

		return
	end

	if _.any(var1_1, function(arg0_2)
		return not var2_1:GetReportById(arg0_2):CanSubmit()
	end) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_get_report_failed"))

		return
	end

	local var5_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(61019, {
		ids = var1_1
	}, 61020, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = PlayerConst.addTranDrop(arg0_3.drop_list)

			for iter0_3, iter1_3 in ipairs(var1_1) do
				var2_1:GetReportById(iter1_3):Submit()
			end

			arg0_1:sendNotification(GAME.SUBMIT_GUILD_REPORT_DONE, {
				awards = var0_3,
				list = var1_1,
				callback = var5_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
