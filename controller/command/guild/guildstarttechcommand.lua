local var0_0 = class("GuildStartTechCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(GuildProxy)
	local var3_1 = var2_1:getData()
	local var4_1 = var1_1:getData()

	if not var3_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	local var5_1 = var3_1:getTechnologyById(var0_1)

	if not var5_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if not var5_1:CanUpgrade() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	local var6_1, var7_1 = var5_1:GetConsume()

	if var7_1 > var4_1.gold then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_gold_no_enough"))

		return
	end

	if var6_1 > var4_1.guildCoin then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_guildgold_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62015, {
		id = var5_1.id
	}, 62016, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1:getData()

			var4_1:consume({
				gold = var7_1,
				guildCoin = var6_1
			})
			var1_1:updatePlayer(var4_1)

			var5_1 = var0_2:getTechnologyById(var0_1)

			var5_1:levelUp()
			var2_1:updateGuild(var0_2)
			arg0_1:sendNotification(GAME.GUILD_START_TECH_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_upgrade_done"))
		elseif arg0_2.result == 4305 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_is_frozen_when_start_tech"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
