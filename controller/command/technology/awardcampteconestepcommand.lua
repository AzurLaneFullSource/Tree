local var0 = class("AwardCampTecCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = 1
	local var1 = {
		type = var0
	}

	print("64007 Get TecCamp Award OneStep", var0)
	pg.ConnectionMgr.GetInstance():Send(64007, var1, 64008, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.rewards)
			local var1 = getProxy(TechnologyNationProxy)

			var1:updateTecItemAwardOneStep()
			arg0:sendNotification(TechnologyConst.GOT_TEC_CAMP_AWARD_ONESTEP, {
				awardList = var0
			})
			var1:refreshRedPoint()
			arg0:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)
		else
			pg.TipsMgr.GetInstance():ShowTips("64007 Error Code:" .. arg0.result)
		end
	end)
end

return var0
