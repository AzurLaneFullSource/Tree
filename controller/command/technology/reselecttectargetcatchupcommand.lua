local var0_0 = class("ReSelectTecTargetCatchupCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().charID

	pg.ConnectionMgr.GetInstance():Send(63013, {
		target = var0_1
	}, 63014, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(TechnologyProxy)
			local var1_2 = var0_2:getNewestCatchupTecID()
			local var2_2 = var0_1

			var0_2:setCurCatchupTecInfo(var1_2, var2_2)
			arg0_1:sendNotification(GAME.RESELECT_TEC_TARGET_CATCHUP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. arg0_2.result)
		end
	end)
end

return var0_0
