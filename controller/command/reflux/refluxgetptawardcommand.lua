local var0 = class("RefluxGetPTAwardCommand", pm.SimpleCommand)

function var0.execute(arg0)
	pg.ConnectionMgr.GetInstance():Send(11755, {
		type = 0
	}, 11756, function(arg0)
		if arg0.result == 0 then
			getProxy(RefluxProxy):addPTStage()

			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			pg.m02:sendNotification(GAME.REFLUX_GET_PT_AWARD_DONE, {
				awards = var0
			})
		end
	end)
end

return var0
