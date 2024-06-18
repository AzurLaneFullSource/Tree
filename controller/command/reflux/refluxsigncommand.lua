local var0_0 = class("RefluxSignCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1)
	pg.ConnectionMgr.GetInstance():Send(11753, {
		type = 0
	}, 11754, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(RefluxProxy)

			var0_2:setSignLastTimestamp()
			var0_2:addSignCount()

			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			pg.m02:sendNotification(GAME.REFLUX_SIGN_DONE, {
				awards = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Sign Error:" .. arg0_2.result)
			getProxy(RefluxProxy):setAutoActionForbidden(true)
		end
	end)
end

return var0_0
