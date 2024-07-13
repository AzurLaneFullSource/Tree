local var0_0 = class("AwardCampTecCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = 1
	local var1_1 = {
		type = var0_1
	}

	print("64007 Get TecCamp Award OneStep", var0_1)
	pg.ConnectionMgr.GetInstance():Send(64007, var1_1, 64008, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.rewards)
			local var1_2 = getProxy(TechnologyNationProxy)

			var1_2:updateTecItemAwardOneStep()
			arg0_1:sendNotification(TechnologyConst.GOT_TEC_CAMP_AWARD_ONESTEP, {
				awardList = var0_2
			})
			var1_2:refreshRedPoint()
			arg0_1:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)
		else
			pg.TipsMgr.GetInstance():ShowTips("64007 Error Code:" .. arg0_2.result)
		end
	end)
end

return var0_0
