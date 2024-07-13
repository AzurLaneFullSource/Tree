local var0_0 = class("GuildGetSupplyAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var1_1:getData()

	if not var2_1 then
		return
	end

	if not var2_1:isOpenedSupply() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_supply_no_open"))

		return
	end

	if var2_1:getSupplyCnt() <= 0 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_supply_award_got"))

		return
	end

	local var3_1 = getProxy(PlayerProxy):getData()
	local var4_1 = var2_1:getMemberById(var3_1.id)

	if not var4_1 or var4_1:isNewMember() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_new_member_get_award_tip"))

		return
	end

	if var4_1:IsRecruit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_duty_is_too_low"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62009, {
		type = 0
	}, 62010, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = GetZeroTime() - 86400
			local var1_2 = var1_1:getData()

			if not var1_2:ExistSupply() then
				var0_2 = var1_2:GetSupplyEndTime()
			end

			var1_2:updateSupplyTime(var0_2)
			var1_1:updateGuild(var1_2)

			local var2_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.GUILD_GET_SUPPLY_AWARD_DONE, {
				list = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
