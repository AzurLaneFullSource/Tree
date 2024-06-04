local var0 = class("RefreshTechnologysCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(TechnologyProxy)

	if var1.refreshTechnologysFlag ~= 0 then
		return
	end

	if tobool(var1:getActivateTechnology()) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63007, {
		type = 1
	}, 63008, function(arg0)
		if arg0.result == 0 then
			var1:updateTechnologys(arg0.refresh_list)
			var1:updateRefreshFlag(1)
			arg0:sendNotification(GAME.REFRESH_TECHNOLOGYS_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_refresh_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_refresh_erro") .. arg0.result)
		end
	end)
end

return var0
