local var0 = class("MarkAssultShipRecommandCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.cmd
	local var3 = getProxy(GuildProxy)
	local var4 = var3:getRawData()

	if not var4 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if not GuildMember.IsAdministrator(var4:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return
	end

	local var5 = GuildAssaultFleet.GetUserId(var1)
	local var6 = GuildAssaultFleet.GetRealId(var1)

	print(var5, var6, var2)
	pg.ConnectionMgr.GetInstance():Send(61033, {
		recommend_uid = var5,
		recommend_shipid = var6,
		cmd = var2
	}, 61034, function(arg0)
		if arg0.result == 0 then
			local var0 = var3:getData()
			local var1 = var0:getMemberById(var5)

			assert(var1)

			local var2 = var1:GetAssaultFleet()

			if var2 == GuildConst.RECOMMAND_SHIP then
				var2:SetShipBeRecommanded(var6, true)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_assult_ship_recommend"))
			elseif var2 == GuildConst.CANCEL_RECOMMAND_SHIP then
				var2:SetShipBeRecommanded(var6, false)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_cancel_assult_ship_recommend"))
			end

			var3:updateGuild(var0)
			arg0:sendNotification(GAME.GUILD_RECOMMAND_ASSULT_SHIP_DONE, {
				shipId = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
