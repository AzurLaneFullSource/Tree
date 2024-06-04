local var0 = class("GuildGetDonateListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(62031, {
		type = 0
	}, 62032, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.donate_tasks) do
				local var1 = GuildDonateTask.New({
					id = iter1
				})

				table.insert(var0, var1)
				print("donate id : ", var1.id)
			end

			local var2 = getProxy(GuildProxy)
			local var3 = var2:getData()

			var3:updateDonateTasks(var0)
			var2:updateGuild(var3)
			arg0:sendNotification(GAME.GUILD_DONATE_LIST_UPDATE_DONE)

			getProxy(GuildProxy).shouldRefreshDonateList = false
			getProxy(GuildProxy).refreshDonateListFailed = false

			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_list_updated"))
		elseif arg0.result == 4 then
			getProxy(GuildProxy).refreshDonateListFailed = true

			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_list_update_failed"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end

		if var0 then
			var0()
		end
	end)
end

return var0
