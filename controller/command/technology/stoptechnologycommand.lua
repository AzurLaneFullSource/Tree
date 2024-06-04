local var0 = class("StopTechnologyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.pool_id
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getTechnologyById(var1)

	if not var4 or not var4:isActivate() or var4:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63005, {
		tech_id = var1,
		refresh_id = var2
	}, 63006, function(arg0)
		if arg0.result == 0 then
			var4:reset()
			var3:updateTechnology(var4)
			arg0:sendNotification(GAME.STOP_TECHNOLOGY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_stop_erro") .. arg0.result)
		end
	end)
end

return var0
