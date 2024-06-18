local var0_0 = class("GetShipCntCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(11800, {
		type = 0
	}, 11801, function(arg0_2)
		var0_1(arg0_2.ship_count)
	end)
end

return var0_0
