local var0 = class("GetShipConfirmCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(12045, {
		type = 0
	}, 12046, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()

			var1.buildShipNotification = {}

			var0:updatePlayer(var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
