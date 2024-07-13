local var0_0 = class("GuildStartTechGroupCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(GuildProxy):getData()

	if not var1_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if not var1_1:CanCancelTech() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_cancel_only_once_pre_day"))

		return
	end

	local var2_1 = var1_1:getTechnologyGroupById(var0_1)

	if not var2_1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if var2_1:isMaxLevel() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62020, {
		id = var2_1.pid
	}, 62021, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.GUILD_START_TECH_TASK_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
