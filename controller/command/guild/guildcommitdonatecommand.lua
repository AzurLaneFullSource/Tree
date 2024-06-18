local var0_0 = class("GuildCommitDonateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().taskId
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var1_1:getData()

	if not var2_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	local var3_1 = var2_1:getDonateTaskById(var0_1)

	if not var3_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_donate_task"))

		return
	end

	if not var3_1:canCommit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var2_1:canDonate() then
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

			local var2_2 = getProxy(PlayerProxy)
			local var3_2 = var2_2:getData()
			local var4_2 = var1_1:getData()

			var4_2:getMemberById(var3_2.id):AddLiveness(var3_1:GetLivenessAddition())
			var4_2:updateDonateTasks(var0_2)
			var4_2:updateDonateCount()
			var1_1:updateGuild(var4_2)

			local var5_2 = var3_1:getConfig("award_contribution")

			var3_2:addResources({
				guildCoin = var5_2
			})
			var2_2:updatePlayer(var3_2)

			local var6_2 = var3_1:getCommitItem()

			arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.Create(var6_2))

			local var7_2 = {}
			local var8_2 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGuildCoin,
				count = var5_2
			})

			table.insert(var7_2, var8_2)

			local var9_2 = var3_1:getConfig("award_capital")
			local var10_2 = var3_1:getConfig("award_tech_exp")

			arg0_1:sendNotification(GAME.GUILD_COMMIT_DONATE_DONE, {
				awards = var7_2,
				capital = var9_2,
				techPoint = var10_2
			})
		else
			pg.TipsMgr:GetInstance():ShowTips(errorTip("guild_dissolve_erro", arg0_2.result))
		end
	end)
end

return var0_0
