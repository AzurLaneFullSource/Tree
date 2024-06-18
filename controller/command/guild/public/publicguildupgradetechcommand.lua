local var0_0 = class("PublicGuildUpgradeTechCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(GuildProxy):GetPublicGuild()
	local var3_1 = var1_1:getData()
	local var4_1 = var2_1:GetTechnologyById(var0_1)

	if not var4_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if var4_1:isMaxLevel() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	local var5_1, var6_1 = var4_1:GetConsume()

	if var6_1 > var3_1.gold then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_gold_no_enough"))

		return
	end

	if var5_1 > var3_1.guildCoin then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_guildgold_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62015, {
		id = var4_1.id
	}, 62016, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:consume({
				gold = var6_1,
				guildCoin = var5_1
			})
			var1_1:updatePlayer(var3_1)
			var4_1:levelUp()
			arg0_1:sendNotification(GAME.PULIC_GUILD_UPGRADE_TECH_DONE, {
				id = var0_1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_upgrade_done"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
