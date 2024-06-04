local var0 = class("GetSeasonInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(18001, {
		type = 0
	}, 18002, function(arg0)
		local var0 = SeasonInfo.New(arg0)
		local var1 = getProxy(MilitaryExerciseProxy)

		if var1:getData() then
			var1:updateSeasonInfo(var0)
		else
			var1:addSeasonInfo(var0)
		end

		local var2 = getProxy(PlayerProxy)
		local var3 = var2:getData()

		var3:updateScoreAndRank(var0.score, var0.rank)
		var2:updatePlayer(var3)
		arg0:sendNotification(GAME.GET_SEASON_INFO_DONE, var0)
	end)
end

return var0
