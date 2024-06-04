local var0 = class("PublicGuildCommitDonateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(GuildProxy):GetPublicGuild()
	local var2 = var1:GetDonateTaskById(var0)

	if not var2 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_donate_task"))

		return
	end

	if not var2:canCommit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var1:HasDonateCnt() then
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

			var1:UpdateDonateTasks(var0)
			var1:IncDonateCount()

			local var2 = getProxy(PlayerProxy)
			local var3 = var2:getData()
			local var4 = var2:getConfig("award_contribution")

			var3:addResources({
				guildCoin = var4
			})
			var2:updatePlayer(var3)

			local var5 = var2:getCommitItem()

			arg0:sendNotification(GAME.CONSUME_ITEM, Drop.Create(var5))

			local var6 = {}
			local var7 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGuildCoin,
				count = var4
			})

			table.insert(var6, var7)
			arg0:sendNotification(GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE, {
				awards = var6
			})
		else
			pg.TipsMgr:GetInstance():ShowTips(errorTip("guild_dissolve_erro", arg0.result))
		end
	end)
end

return var0
