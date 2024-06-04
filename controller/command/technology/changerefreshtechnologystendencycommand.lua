local var0 = class("ChangeRefreshTechnologysTendencyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.pool_id
	local var2 = var0.tendency

	pg.ConnectionMgr.GetInstance():Send(63009, {
		id = var1,
		target = var2
	}, 63010, function(arg0)
		if arg0.result == 0 then
			getProxy(TechnologyProxy):setTendency(var1, var2)
			arg0:sendNotification(GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("change_technology_refresh_erro") .. arg0.result)
		end
	end)
end

return var0
