local var0_0 = class("PublicGuildCommitDonateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(GuildProxy):GetPublicGuild()
	local var2_1 = var1_1:GetDonateTaskById(var0_1)

	if not var2_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_donate_task"))

		return
	end

	if not var2_1:canCommit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var1_1:HasDonateCnt() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_donate_times_not enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62002, {
		id = var0_1
	}, 62003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.donate_tasks) do
				local var1_2 = GuildDonateTask.New({
					id = iter1_2
				})

				table.insert(var0_2, var1_2)
			end

			var1_1:UpdateDonateTasks(var0_2)
			var1_1:IncDonateCount()

			local var2_2 = getProxy(PlayerProxy)
			local var3_2 = var2_2:getData()
			local var4_2 = var2_1:getConfig("award_contribution")

			var3_2:addResources({
				guildCoin = var4_2
			})
			var2_2:updatePlayer(var3_2)

			local var5_2 = var2_1:getCommitItem()

			arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.Create(var5_2))

			local var6_2 = {}
			local var7_2 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGuildCoin,
				count = var4_2
			})

			table.insert(var6_2, var7_2)
			arg0_1:sendNotification(GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE, {
				awards = var6_2
			})
		else
			pg.TipsMgr:GetInstance():ShowTips(errorTip("guild_dissolve_erro", arg0_2.result))
		end
	end)
end

return var0_0
