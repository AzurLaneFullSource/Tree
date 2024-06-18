local var0_0 = class("GuildFetchWeeklyTaskProgreeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var1_1:getRawData()

	if not var2_1 then
		return
	end

	local var3_1 = var2_1:getWeeklyTask()

	if not var3_1 or var3_1:getState() ~= GuildTask.STATE_ONGOING then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(62022, {
		type = 0
	}, 62023, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:getRawData()

			var3_1 = var0_2:getWeeklyTask()

			local var1_2 = var3_1:getState()

			var3_1:updateProgress(arg0_2.progress)
			var1_1:updateGuild(var0_2)
			var0_2:setRefreshWeeklyTaskProgressTime()
			arg0_1:sendNotification(GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE_DONE)

			if var1_2 ~= var3_1:getState() then
				arg0_1:sendNotification(GAME.GUILD_REFRESH_CAPITAL)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
