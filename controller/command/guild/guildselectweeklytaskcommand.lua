local var0 = class("GuildSelectWeeklyTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.taskId
	local var2 = var0.num
	local var3 = getProxy(GuildProxy):getRawData()

	if not var3 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if var3:getWeeklyTask():getState() ~= GuildTask.STATE_EMPTY then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_week_task_state_is_wrong"))

		return
	end

	if not GuildMember.IsAdministrator(var3:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62013, {
		id = var1
	}, 62014, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.GUILD_SELECT_TASK_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
