local var0 = class("WorldPortReqCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33401, {
		map_id = var0.mapId
	}, 33402, function(arg0)
		if (arg0.port.port_id > 0 and 0 or 1) == 0 then
			getProxy(WorldProxy):NetUpdateMapPort(var0.mapId, arg0.port)
			nowWorld():GetAtlas():UpdatePortMark(arg0.port.port_id, nil, false)
		else
			pg.TipsMgr.GetInstance():ShowTips("port req error.")
		end

		arg0:sendNotification(GAME.WORLD_PORT_REQ_DONE)
	end)
end

return var0
