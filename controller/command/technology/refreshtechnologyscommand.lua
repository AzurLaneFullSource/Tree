local var0_0 = class("RefreshTechnologysCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(TechnologyProxy)

	if var1_1.refreshTechnologysFlag ~= 0 then
		return
	end

	if tobool(var1_1:getActivateTechnology()) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63007, {
		type = 1
	}, 63008, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:updateTechnologys(arg0_2.refresh_list)
			var1_1:updateRefreshFlag(1)
			arg0_1:sendNotification(GAME.REFRESH_TECHNOLOGYS_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_refresh_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_refresh_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
