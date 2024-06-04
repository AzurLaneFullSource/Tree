local var0 = class("CreateGuildCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0:getName()
	local var2 = pg.gameset.create_guild_cost.key_value
	local var3 = getProxy(PlayerProxy)
	local var4 = var3:getData()

	if var2 > var4:getTotalGem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nomoney"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60001, {
		faction = var0:getFaction(),
		policy = var0:getPolicy(),
		name = var1,
		manifesto = var0:getManifesto()
	}, 60002, function(arg0)
		if arg0.result == 0 then
			local var0 = Guild.New({
				base = var0
			})

			var0:setId(arg0.id)

			local var1 = getProxy(GuildProxy)
			local var2 = GuildMember.New({
				online = 1,
				liveness = 0,
				id = var4.id,
				name = var4.name,
				lv = var4.level,
				adv = var4.manifesto,
				display = {
					icon = var4.icon,
					character = var4.character,
					icon_theme = var4.iconTheme,
					transform_flag = var4.transformFlag,
					skin = var4.skinId,
					marry_flag = var4.proposeTime
				},
				join_time = pg.TimeMgr.GetInstance():GetServerTime()
			})

			var2:setDuty(GuildConst.DUTY_COMMANDER)
			var0:addMember(var2)

			local var3 = pg.guildset.guild_tech_default.key_value

			var0:StartTech(var3)
			var1:addGuild(var0)
			var4:consume({
				gem = var2
			})
			var3:updatePlayer(var4)
			arg0:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH)
			arg0:sendNotification(GAME.CREATE_GUILD_DONE)
			arg0:sendNotification(GAME.GUILD_GET_USER_INFO)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_sucess"))
		elseif arg0.result == 2015 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_name_invaild"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_create_error", arg0.result))
		end
	end)
end

return var0
