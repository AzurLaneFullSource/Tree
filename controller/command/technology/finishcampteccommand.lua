local var0 = class("FinishCampTecCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.tecID
	local var2 = var0.levelID

	pg.ConnectionMgr.GetInstance():Send(64003, {
		tech_group_id = var1
	}, 64004, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(TechnologyNationProxy)

			var0:updateTecItem(var1, var2, 0, 0)
			var0:setTimer()
			var0:calculateTecBuff()
			arg0:sendNotification(TechnologyConst.FINISH_TEC_SUCCESS, var1)
			var0:refreshRedPoint()
			arg0:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_cell", arg0.result))
		end
	end)
end

return var0
