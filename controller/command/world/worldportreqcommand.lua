local var0_0 = class("WorldPortReqCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33401, {
		map_id = var0_1.mapId
	}, 33402, function(arg0_2)
		if (arg0_2.port.port_id > 0 and 0 or 1) == 0 then
			getProxy(WorldProxy):NetUpdateMapPort(var0_1.mapId, arg0_2.port)
			nowWorld():GetAtlas():UpdatePortMark(arg0_2.port.port_id, nil, false)
		else
			pg.TipsMgr.GetInstance():ShowTips("port req error.")
		end

		arg0_1:sendNotification(GAME.WORLD_PORT_REQ_DONE)
	end)
end

return var0_0
