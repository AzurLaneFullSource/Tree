local var0_0 = class("WorldMapReqCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33106, {
		id = var0_1.mapId
	}, 33107, function(arg0_2)
		if arg0_2.result == 0 then
			if arg0_2.is_reset == 1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_map_version"))
			end

			getProxy(WorldProxy):NetUpdateMap(arg0_2.map)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_map_req_error_", arg0_2.result))
		end

		arg0_1:sendNotification(GAME.WORLD_MAP_REQ_DONE, {
			result = arg0_2.result
		})
	end)
end

return var0_0
