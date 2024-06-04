local var0 = class("GuildGetSupplyAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)
	local var2 = var1:getData()

	if not var2 then
		return
	end

	if not var2:isOpenedSupply() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_supply_no_open"))

		return
	end

	if var2:getSupplyCnt() <= 0 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_supply_award_got"))

		return
	end

	local var3 = getProxy(PlayerProxy):getData()
	local var4 = var2:getMemberById(var3.id)

	if not var4 or var4:isNewMember() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_new_member_get_award_tip"))

		return
	end

	if var4:IsRecruit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_duty_is_too_low"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62009, {
		type = 0
	}, 62010, function(arg0)
		if arg0.result == 0 then
			local var0 = GetZeroTime() - 86400
			local var1 = var1:getData()

			if not var1:ExistSupply() then
				var0 = var1:GetSupplyEndTime()
			end

			var1:updateSupplyTime(var0)
			var1:updateGuild(var1)

			local var2 = PlayerConst.addTranDrop(arg0.drop_list)

			arg0:sendNotification(GAME.GUILD_GET_SUPPLY_AWARD_DONE, {
				list = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
