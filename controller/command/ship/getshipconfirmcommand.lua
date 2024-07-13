local var0_0 = class("GetShipConfirmCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(12045, {
		type = 0
	}, 12046, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayerProxy)
			local var1_2 = var0_2:getData()

			var1_2.buildShipNotification = {}

			var0_2:updatePlayer(var1_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
