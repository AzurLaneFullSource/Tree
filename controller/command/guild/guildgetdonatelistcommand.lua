local var0_0 = class("GuildGetDonateListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(62031, {
		type = 0
	}, 62032, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.donate_tasks) do
				local var1_2 = GuildDonateTask.New({
					id = iter1_2
				})

				table.insert(var0_2, var1_2)
				print("donate id : ", var1_2.id)
			end

			local var2_2 = getProxy(GuildProxy)
			local var3_2 = var2_2:getData()

			var3_2:updateDonateTasks(var0_2)
			var2_2:updateGuild(var3_2)
			arg0_1:sendNotification(GAME.GUILD_DONATE_LIST_UPDATE_DONE)

			getProxy(GuildProxy).shouldRefreshDonateList = false
			getProxy(GuildProxy).refreshDonateListFailed = false

			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_list_updated"))
		elseif arg0_2.result == 4 then
			getProxy(GuildProxy).refreshDonateListFailed = true

			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_list_update_failed"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end

		if var0_1 then
			var0_1()
		end
	end)
end

return var0_0
