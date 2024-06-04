local var0 = class("GuildBuySupplyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy):getData()

	if not var1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if not GuildMember.IsAdministrator(var1:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_op_only_administrator"))

		return
	end

	if var1:getSupplyConsume() > var1:getCapital() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62007, {
		type = 0
	}, 62008, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.GUILD_BUY_SUPPLY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
