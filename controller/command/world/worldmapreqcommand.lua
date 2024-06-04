local var0 = class("WorldMapReqCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33106, {
		id = var0.mapId
	}, 33107, function(arg0)
		if arg0.result == 0 then
			if arg0.is_reset == 1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_map_version"))
			end

			getProxy(WorldProxy):NetUpdateMap(arg0.map)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_map_req_error_", arg0.result))
		end

		arg0:sendNotification(GAME.WORLD_MAP_REQ_DONE, {
			result = arg0.result
		})
	end)
end

return var0
