local var0 = class("IslandFlowerFieldGetAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0.act_id
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy)
			local var1 = var0:getActivityById(var0.act_id)

			var1.data1 = arg0.number[1]
			var1.data2 = arg0.number[2]

			var0:updateActivity(var1)

			local var2 = PlayerConst.addTranDrop(arg0.award_list)

			pg.m02:sendNotification(GAME.ISLAND_FLOWER_GET_DONE, {
				isAuto = var0.isAuto,
				awards = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("flower award get failed:" .. arg0.result)
		end
	end)
end

return var0
