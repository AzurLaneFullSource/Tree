local var0 = class("GuildCommitDonateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().taskId
	local var1 = getProxy(GuildProxy)
	local var2 = var1:getData()

	if not var2 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	local var3 = var2:getDonateTaskById(var0)

	if not var3 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_donate_task"))

		return
	end

	if not var3:canCommit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var2:canDonate() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_donate_times_not enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62002, {
		id = var0
	}, 62003, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.donate_tasks) do
				local var1 = GuildDonateTask.New({
					id = iter1
				})

				table.insert(var0, var1)
			end

			local var2 = getProxy(PlayerProxy)
			local var3 = var2:getData()
			local var4 = var1:getData()

			var4:getMemberById(var3.id):AddLiveness(var3:GetLivenessAddition())
			var4:updateDonateTasks(var0)
			var4:updateDonateCount()
			var1:updateGuild(var4)

			local var5 = var3:getConfig("award_contribution")

			var3:addResources({
				guildCoin = var5
			})
			var2:updatePlayer(var3)

			local var6 = var3:getCommitItem()

			arg0:sendNotification(GAME.CONSUME_ITEM, Drop.Create(var6))

			local var7 = {}
			local var8 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGuildCoin,
				count = var5
			})

			table.insert(var7, var8)

			local var9 = var3:getConfig("award_capital")
			local var10 = var3:getConfig("award_tech_exp")

			arg0:sendNotification(GAME.GUILD_COMMIT_DONATE_DONE, {
				awards = var7,
				capital = var9,
				techPoint = var10
			})
		else
			pg.TipsMgr:GetInstance():ShowTips(errorTip("guild_dissolve_erro", arg0.result))
		end
	end)
end

return var0
