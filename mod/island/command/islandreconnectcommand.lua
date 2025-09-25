local var0_0 = class("IslandReconnectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().islandId

	pg.ConnectionMgr.GetInstance():Send(21230, {
		island_id = var0_1
	}, 21231, function(arg0_2)
		if arg0_2.result == 0 then
			if _IslandCore and _IslandCore:GetView().player then
				local var0_2 = _IslandCore:GetController().mapId
				local var1_2, var2_2 = _IslandCore:GetView().player:LastGroundedPosition()

				getProxy(IslandProxy):RecordTempPlayerPosition(var0_2, var1_2, var2_2)
			end

			pg.m02:sendNotification(GAME.ISLAND_ENTER, {
				reconnect = true,
				id = var0_1
			})
		else
			pg.m02:sendNotification(GAME.ISLAND_ON_HOME)
		end
	end)
end

return var0_0
