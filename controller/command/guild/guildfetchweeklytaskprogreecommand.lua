local var0 = class("GuildFetchWeeklyTaskProgreeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)
	local var2 = var1:getRawData()

	if not var2 then
		return
	end

	local var3 = var2:getWeeklyTask()

	if not var3 or var3:getState() ~= GuildTask.STATE_ONGOING then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(62022, {
		type = 0
	}, 62023, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:getRawData()

			var3 = var0:getWeeklyTask()

			local var1 = var3:getState()

			var3:updateProgress(arg0.progress)
			var1:updateGuild(var0)
			var0:setRefreshWeeklyTaskProgressTime()
			arg0:sendNotification(GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE_DONE)

			if var1 ~= var3:getState() then
				arg0:sendNotification(GAME.GUILD_REFRESH_CAPITAL)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
