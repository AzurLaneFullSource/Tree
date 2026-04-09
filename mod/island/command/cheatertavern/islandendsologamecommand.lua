local var0_0 = class("IslandEndSoloGameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23111, {
		Type = 1
	}, 23112, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.ISLAND_CHEATER_END_SOLO_GAME_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end, false)
end

return var0_0
