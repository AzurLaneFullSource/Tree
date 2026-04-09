local var0_0 = class("IslandStartSoloGameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().bot_num

	pg.ConnectionMgr.GetInstance():Send(23109, {
		bot_num = var0_1
	}, 23110, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.ISLAND_CHEATER_START_SOLO_GAME_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end, false)
end

return var0_0
