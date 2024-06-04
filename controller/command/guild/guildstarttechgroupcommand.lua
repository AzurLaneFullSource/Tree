local var0 = class("GuildStartTechGroupCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(GuildProxy):getData()

	if not var1 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if not var1:CanCancelTech() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_cancel_only_once_pre_day"))

		return
	end

	local var2 = var1:getTechnologyGroupById(var0)

	if not var2 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if var2:isMaxLevel() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62020, {
		id = var2.pid
	}, 62021, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.GUILD_START_TECH_TASK_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
