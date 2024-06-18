local var0_0 = class("ChangeRefreshTechnologysTendencyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.pool_id
	local var2_1 = var0_1.tendency

	pg.ConnectionMgr.GetInstance():Send(63009, {
		id = var1_1,
		target = var2_1
	}, 63010, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(TechnologyProxy):setTendency(var1_1, var2_1)
			arg0_1:sendNotification(GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("change_technology_refresh_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
