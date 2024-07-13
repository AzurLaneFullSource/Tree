local var0_0 = class("AwardCampTecCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupID
	local var2_1 = var0_1.tecID
	local var3_1 = {
		group_id = var1_1,
		tech_id = var2_1
	}

	print("64005 Get TecCamp Award", var1_1, var2_1)
	pg.ConnectionMgr.GetInstance():Send(64005, var3_1, 64006, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.rewards)
			local var1_2 = getProxy(TechnologyNationProxy)

			var1_2:updateTecItemAward(var1_1, var2_1)
			arg0_1:sendNotification(TechnologyConst.GOT_TEC_CAMP_AWARD, {
				awardList = var0_2,
				groupID = var1_1,
				tecID = var2_1
			})
			var1_2:refreshRedPoint()
			arg0_1:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)
		else
			pg.TipsMgr.GetInstance():ShowTips("64005 Error Code:" .. arg0_2.result)
		end
	end)
end

return var0_0
