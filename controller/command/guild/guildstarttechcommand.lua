local var0 = class("GuildStartTechCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(GuildProxy)
	local var3 = var2:getData()
	local var4 = var1:getData()

	if not var3 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	local var5 = var3:getTechnologyById(var0)

	if not var5 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if not var5:CanUpgrade() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	local var6, var7 = var5:GetConsume()

	if var7 > var4.gold then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_gold_no_enough"))

		return
	end

	if var6 > var4.guildCoin then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_guildgold_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62015, {
		id = var5.id
	}, 62016, function(arg0)
		if arg0.result == 0 then
			local var0 = var2:getData()

			var4:consume({
				gold = var7,
				guildCoin = var6
			})
			var1:updatePlayer(var4)

			var5 = var0:getTechnologyById(var0)

			var5:levelUp()
			var2:updateGuild(var0)
			arg0:sendNotification(GAME.GUILD_START_TECH_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_upgrade_done"))
		elseif arg0.result == 4305 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_is_frozen_when_start_tech"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
