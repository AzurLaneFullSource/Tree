local var0_0 = class("CreateGuildCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1:getName()
	local var2_1 = pg.gameset.create_guild_cost.key_value
	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = var3_1:getData()

	if var2_1 > var4_1:getTotalGem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nomoney"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60001, {
		faction = var0_1:getFaction(),
		policy = var0_1:getPolicy(),
		name = var1_1,
		manifesto = var0_1:getManifesto()
	}, 60002, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Guild.New({
				base = var0_1
			})

			var0_2:setId(arg0_2.id)

			local var1_2 = getProxy(GuildProxy)
			local var2_2 = GuildMember.New({
				online = 1,
				liveness = 0,
				id = var4_1.id,
				name = var4_1.name,
				lv = var4_1.level,
				adv = var4_1.manifesto,
				display = {
					icon = var4_1.icon,
					character = var4_1.character,
					icon_theme = var4_1.iconTheme,
					transform_flag = var4_1.transformFlag,
					skin = var4_1.skinId,
					marry_flag = var4_1.proposeTime
				},
				join_time = pg.TimeMgr.GetInstance():GetServerTime()
			})

			var2_2:setDuty(GuildConst.DUTY_COMMANDER)
			var0_2:addMember(var2_2)

			local var3_2 = pg.guildset.guild_tech_default.key_value

			var0_2:StartTech(var3_2)
			var1_2:addGuild(var0_2)
			var4_1:consume({
				gem = var2_1
			})
			var3_1:updatePlayer(var4_1)
			arg0_1:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH)
			arg0_1:sendNotification(GAME.CREATE_GUILD_DONE)
			arg0_1:sendNotification(GAME.GUILD_GET_USER_INFO)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_sucess"))
		elseif arg0_2.result == 2015 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_name_invaild"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_create_error", arg0_2.result))
		end
	end)
end

return var0_0
