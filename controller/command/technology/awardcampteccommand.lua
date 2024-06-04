local var0 = class("AwardCampTecCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupID
	local var2 = var0.tecID
	local var3 = {
		group_id = var1,
		tech_id = var2
	}

	print("64005 Get TecCamp Award", var1, var2)
	pg.ConnectionMgr.GetInstance():Send(64005, var3, 64006, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.rewards)
			local var1 = getProxy(TechnologyNationProxy)

			var1:updateTecItemAward(var1, var2)
			arg0:sendNotification(TechnologyConst.GOT_TEC_CAMP_AWARD, {
				awardList = var0,
				groupID = var1,
				tecID = var2
			})
			var1:refreshRedPoint()
			arg0:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)
		else
			pg.TipsMgr.GetInstance():ShowTips("64005 Error Code:" .. arg0.result)
		end
	end)
end

return var0
