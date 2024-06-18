local var0_0 = class("RefluxGetPTAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1)
	pg.ConnectionMgr.GetInstance():Send(11755, {
		type = 0
	}, 11756, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(RefluxProxy):addPTStage()

			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			pg.m02:sendNotification(GAME.REFLUX_GET_PT_AWARD_DONE, {
				awards = var0_2
			})
		end
	end)
end

return var0_0
