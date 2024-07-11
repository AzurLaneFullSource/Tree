local var0_0 = class("MilitaryExerciseProxy", import(".NetProxy"))

var0_0.SEASON_INFO_ADDED = "MilitaryExerciseProxy SEASON_INFO_ADDED"
var0_0.SEASON_INFO_UPDATED = "MilitaryExerciseProxy SEASON_INFO_UPDATED"
var0_0.ARENARANK_UPDATED = "MilitaryExerciseProxy ARENARANK_UPDATED"
var0_0.EXERCISE_FLEET_UPDATED = "MilitaryExerciseProxy EXERCISE_FLEET_UPDATED"
var0_0.RIVALS_UPDATED = "MilitaryExerciseProxy RIVALS_UPDATED"

function var0_0.register(arg0_1)
	arg0_1:on(18005, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.target_list) do
			table.insert(var0_2, Rival.New(iter1_2))
		end

		local var1_2 = arg0_1:getSeasonInfo()

		var1_2:updateScore(arg0_2.score + SeasonInfo.INIT_POINT)
		var1_2:updateRank(arg0_2.rank)
		var1_2:updateRivals(var0_2)
		arg0_1:updateSeasonInfo(var1_2)

		local var2_2 = getProxy(PlayerProxy)
		local var3_2 = var2_2:getData()

		var3_2:updateScoreAndRank(var1_2.score, var1_2.rank)
		var2_2:updatePlayer(var3_2)
	end)

	arg0_1.waiting = true
end

function var0_0.timeCall(arg0_3)
	return {
		[ProxyRegister.DayCall] = function(arg0_4)
			local var0_4 = arg0_3:getSeasonInfo()

			if var0_4 then
				var0_4:resetFlashCount()
				arg0_3:updateSeasonInfo(var0_4)
			end
		end,
		[ProxyRegister.SecondCall] = function(arg0_5)
			if arg0_3.waiting then
				return
			end

			if arg0_3.seasonInfo.resetTime <= pg.TimeMgr.GetInstance():GetServerTime() then
				arg0_3.waiting = true

				arg0_3:sendNotification(GAME.EXERCISE_COUNT_RECOVER_UP)
			end
		end
	}
end

function var0_0.addSeasonInfo(arg0_6, arg1_6)
	assert(isa(arg1_6, SeasonInfo), "seasonInfo be an instance of SeasonInfo")

	arg0_6.seasonInfo = arg1_6

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0_6:sendNotification(var0_0.SEASON_INFO_ADDED, arg1_6:clone())

	arg0_6.waiting = false
end

function var0_0.setSeasonOver(arg0_7)
	local var0_7 = arg0_7:getSeasonInfo()

	var0_7:setExerciseCount(0)
	arg0_7:updateSeasonInfo(var0_7)
end

function var0_0.remove(arg0_8)
	return
end

function var0_0.updateSeasonInfo(arg0_9, arg1_9)
	assert(isa(arg1_9, SeasonInfo), "seasonInfo be an instance of SeasonInfo")

	arg0_9.seasonInfo = arg1_9

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0_9:sendNotification(var0_0.SEASON_INFO_UPDATED, arg1_9:clone())
end

function var0_0.getSeasonInfo(arg0_10)
	return Clone(arg0_10.seasonInfo)
end

function var0_0.RawGetSeasonInfo(arg0_11)
	return arg0_11.seasonInfo
end

function var0_0.updateRivals(arg0_12, arg1_12)
	arg0_12.seasonInfo:updateRivals(arg1_12)
	arg0_12:sendNotification(var0_0.RIVALS_UPDATED, Clone(arg1_12))
end

function var0_0.getRivals(arg0_13)
	return Clone(arg0_13.seasonInfo.rivals)
end

function var0_0.getRivalById(arg0_14, arg1_14)
	for iter0_14, iter1_14 in ipairs(arg0_14:getRivals()) do
		if iter1_14.id == arg1_14 then
			return iter1_14
		end
	end
end

function var0_0.getPreRivalById(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.seasonInfo:GetPreRivals()) do
		if arg1_15 == iter0_15 then
			return Clone(iter1_15)
		end
	end
end

function var0_0.getExerciseFleet(arg0_16)
	return Clone(arg0_16.seasonInfo.fleet)
end

function var0_0.updateExerciseFleet(arg0_17, arg1_17)
	arg0_17.seasonInfo:updateFleet(arg1_17)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0_17:sendNotification(var0_0.EXERCISE_FLEET_UPDATED, arg1_17:clone())
end

function var0_0.increaseExerciseCount(arg0_18)
	arg0_18.seasonInfo:increaseExerciseCount()
end

function var0_0.reduceExerciseCount(arg0_19)
	arg0_19.seasonInfo:reduceExerciseCount()
end

function var0_0.updateArenaRankLsit(arg0_20, arg1_20)
	assert(arg1_20, "should exist arenaRankLsit")

	arg0_20.arenaRankLsit = arg1_20

	arg0_20:sendNotification(var0_0.ARENARANK_UPDATED, Clone(arg1_20))
end

function var0_0.getArenaRankList(arg0_21)
	return arg0_21.arenaRankLsit
end

function var0_0.getData(arg0_22)
	return Clone(arg0_22.seasonInfo)
end

return var0_0
