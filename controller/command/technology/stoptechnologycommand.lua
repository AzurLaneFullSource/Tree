local var0_0 = class("StopTechnologyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.pool_id
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getTechnologyById(var1_1)

	if not var4_1 or not var4_1:isActivate() or var4_1:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63005, {
		tech_id = var1_1,
		refresh_id = var2_1
	}, 63006, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:reset()
			var3_1:updateTechnology(var4_1)
			arg0_1:sendNotification(GAME.STOP_TECHNOLOGY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_stop_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
