local var0_0 = class("IslandFlowerFieldGetAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0_1.act_id
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy)
			local var1_2 = var0_2:getActivityById(var0_1.act_id)

			var1_2.data1 = arg0_2.number[1]
			var1_2.data2 = arg0_2.number[2]

			var0_2:updateActivity(var1_2)

			local var2_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			pg.m02:sendNotification(GAME.ISLAND_FLOWER_GET_DONE, {
				isAuto = var0_1.isAuto,
				awards = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("flower award get failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
