local var0 = class("PublicGuildUpgradeTechCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(GuildProxy):GetPublicGuild()
	local var3 = var1:getData()
	local var4 = var2:GetTechnologyById(var0)

	if not var4 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if var4:isMaxLevel() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	local var5, var6 = var4:GetConsume()

	if var6 > var3.gold then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_gold_no_enough"))

		return
	end

	if var5 > var3.guildCoin then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_guildgold_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62015, {
		id = var4.id
	}, 62016, function(arg0)
		if arg0.result == 0 then
			var3:consume({
				gold = var6,
				guildCoin = var5
			})
			var1:updatePlayer(var3)
			var4:levelUp()
			arg0:sendNotification(GAME.PULIC_GUILD_UPGRADE_TECH_DONE, {
				id = var0
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_upgrade_done"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
