local var0_0 = class("FinishCampTecCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.tecID
	local var2_1 = var0_1.levelID

	pg.ConnectionMgr.GetInstance():Send(64003, {
		tech_group_id = var1_1
	}, 64004, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(TechnologyNationProxy)

			var0_2:updateTecItem(var1_1, var2_1, 0, 0)
			var0_2:setTimer()
			var0_2:calculateTecBuff()
			arg0_1:sendNotification(TechnologyConst.FINISH_TEC_SUCCESS, var1_1)
			var0_2:refreshRedPoint()
			arg0_1:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_cell", arg0_2.result))
		end
	end)
end

return var0_0
