local var0_0 = class("MarkAssultShipRecommandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.cmd
	local var3_1 = getProxy(GuildProxy)
	local var4_1 = var3_1:getRawData()

	if not var4_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if not GuildMember.IsAdministrator(var4_1:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return
	end

	local var5_1 = GuildAssaultFleet.GetUserId(var1_1)
	local var6_1 = GuildAssaultFleet.GetRealId(var1_1)

	print(var5_1, var6_1, var2_1)
	pg.ConnectionMgr.GetInstance():Send(61033, {
		recommend_uid = var5_1,
		recommend_shipid = var6_1,
		cmd = var2_1
	}, 61034, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var3_1:getData()
			local var1_2 = var0_2:getMemberById(var5_1)

			assert(var1_2)

			local var2_2 = var1_2:GetAssaultFleet()

			if var2_1 == GuildConst.RECOMMAND_SHIP then
				var2_2:SetShipBeRecommanded(var6_1, true)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_assult_ship_recommend"))
			elseif var2_1 == GuildConst.CANCEL_RECOMMAND_SHIP then
				var2_2:SetShipBeRecommanded(var6_1, false)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_cancel_assult_ship_recommend"))
			end

			var3_1:updateGuild(var0_2)
			arg0_1:sendNotification(GAME.GUILD_RECOMMAND_ASSULT_SHIP_DONE, {
				shipId = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
