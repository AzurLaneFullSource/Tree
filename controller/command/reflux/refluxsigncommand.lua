local var0 = class("RefluxSignCommand", pm.SimpleCommand)

function var0.execute(arg0)
	pg.ConnectionMgr.GetInstance():Send(11753, {
		type = 0
	}, 11754, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(RefluxProxy)

			var0:setSignLastTimestamp()
			var0:addSignCount()

			local var1 = PlayerConst.addTranDrop(arg0.award_list)

			pg.m02:sendNotification(GAME.REFLUX_SIGN_DONE, {
				awards = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Sign Error:" .. arg0.result)
			getProxy(RefluxProxy):setAutoActionForbidden(true)
		end
	end)
end

return var0
