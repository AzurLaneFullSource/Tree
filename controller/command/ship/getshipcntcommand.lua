local var0 = class("GetShipCntCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(11800, {
		type = 0
	}, 11801, function(arg0)
		var0(arg0.ship_count)
	end)
end

return var0
