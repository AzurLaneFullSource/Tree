local var0_0 = class("IslandChangeViewDressCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id
	local var2_1 = var0_1.game_type
	local var3_1 = var0_1.type

	pg.ConnectionMgr.GetInstance():Send(23029, {
		type = var3_1,
		game_type = var2_1,
		ship_id = var1_1
	}, 23030, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetCharacterAgency():SetMiniGameShipViewId(var2_1, var1_1)
			arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM_INFO)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
