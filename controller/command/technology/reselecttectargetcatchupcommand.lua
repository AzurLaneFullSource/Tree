local var0 = class("ReSelectTecTargetCatchupCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().charID

	pg.ConnectionMgr.GetInstance():Send(63013, {
		target = var0
	}, 63014, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(TechnologyProxy)
			local var1 = var0:getNewestCatchupTecID()
			local var2 = var0

			var0:setCurCatchupTecInfo(var1, var2)
			arg0:sendNotification(GAME.RESELECT_TEC_TARGET_CATCHUP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. arg0.result)
		end
	end)
end

return var0
