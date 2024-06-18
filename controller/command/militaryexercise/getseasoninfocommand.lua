local var0_0 = class("GetSeasonInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(18001, {
		type = 0
	}, 18002, function(arg0_2)
		local var0_2 = SeasonInfo.New(arg0_2)
		local var1_2 = getProxy(MilitaryExerciseProxy)

		if var1_2:getData() then
			var1_2:updateSeasonInfo(var0_2)
		else
			var1_2:addSeasonInfo(var0_2)
		end

		local var2_2 = getProxy(PlayerProxy)
		local var3_2 = var2_2:getData()

		var3_2:updateScoreAndRank(var0_2.score, var0_2.rank)
		var2_2:updatePlayer(var3_2)
		arg0_1:sendNotification(GAME.GET_SEASON_INFO_DONE, var0_2)
	end)
end

return var0_0
