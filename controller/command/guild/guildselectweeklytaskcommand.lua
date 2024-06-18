local var0_0 = class("GuildSelectWeeklyTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = var0_1.num
	local var3_1 = getProxy(GuildProxy):getRawData()

	if not var3_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if var3_1:getWeeklyTask():getState() ~= GuildTask.STATE_EMPTY then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_week_task_state_is_wrong"))

		return
	end

	if not GuildMember.IsAdministrator(var3_1:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62013, {
		id = var1_1
	}, 62014, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.GUILD_SELECT_TASK_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
