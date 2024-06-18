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
end

function var0_0.addSeasonInfo(arg0_3, arg1_3)
	assert(isa(arg1_3, SeasonInfo), "seasonInfo be an instance of SeasonInfo")

	arg0_3.seasonInfo = arg1_3

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0_3:sendNotification(var0_0.SEASON_INFO_ADDED, arg1_3:clone())
	arg0_3:addRefreshCountTimer()
end

function var0_0.addRefreshCountTimer(arg0_4)
	arg0_4:removeRefreshTimer()

	local function var0_4()
		arg0_4:sendNotification(GAME.EXERCISE_COUNT_RECOVER_UP)
	end

	local var1_4 = arg0_4.seasonInfo.resetTime - pg.TimeMgr.GetInstance():GetServerTime()

	if var1_4 > 0 then
		arg0_4.refreshCountTimer = Timer.New(function()
			var0_4()
		end, var1_4, 1)

		arg0_4.refreshCountTimer:Start()
	else
		var0_4()
	end
end

function var0_0.addSeasonOverTimer(arg0_7)
	arg0_7:removeSeasonOverTimer()

	local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE)

	if var0_7 and not var0_7:isEnd() then
		local function var1_7()
			arg0_7:removeSeasonOverTimer()

			local var0_8 = arg0_7:getSeasonInfo()

			var0_8:setExerciseCount(0)
			arg0_7:updateSeasonInfo(var0_8)
		end

		local var2_7 = var0_7.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		if var2_7 > 0 then
			arg0_7.SeasonOverTimer = Timer.New(function()
				var1_7()
			end, var2_7, 1)

			arg0_7.SeasonOverTimer:Start()
		else
			var1_7()
		end
	end
end

function var0_0.removeRefreshTimer(arg0_10)
	if arg0_10.refreshCountTimer then
		arg0_10.refreshCountTimer:Stop()

		arg0_10.refreshCountTimer = nil
	end
end

function var0_0.removeSeasonOverTimer(arg0_11)
	if arg0_11.SeasonOverTimer then
		arg0_11.SeasonOverTimer:Stop()

		arg0_11.SeasonOverTimer = nil
	end
end

function var0_0.remove(arg0_12)
	arg0_12:removeRefreshTimer()
	arg0_12:removeSeasonOverTimer()
end

function var0_0.updateSeasonInfo(arg0_13, arg1_13)
	assert(isa(arg1_13, SeasonInfo), "seasonInfo be an instance of SeasonInfo")

	arg0_13.seasonInfo = arg1_13

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0_13:sendNotification(var0_0.SEASON_INFO_UPDATED, arg1_13:clone())
end

function var0_0.getSeasonInfo(arg0_14)
	return Clone(arg0_14.seasonInfo)
end

function var0_0.RawGetSeasonInfo(arg0_15)
	return arg0_15.seasonInfo
end

function var0_0.updateRivals(arg0_16, arg1_16)
	arg0_16.seasonInfo:updateRivals(arg1_16)
	arg0_16:sendNotification(var0_0.RIVALS_UPDATED, Clone(arg1_16))
end

function var0_0.getRivals(arg0_17)
	return Clone(arg0_17.seasonInfo.rivals)
end

function var0_0.getRivalById(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18:getRivals()) do
		if iter1_18.id == arg1_18 then
			return iter1_18
		end
	end
end

function var0_0.getPreRivalById(arg0_19, arg1_19)
	for iter0_19, iter1_19 in pairs(arg0_19.seasonInfo:GetPreRivals()) do
		if arg1_19 == iter0_19 then
			return Clone(iter1_19)
		end
	end
end

function var0_0.getExerciseFleet(arg0_20)
	return Clone(arg0_20.seasonInfo.fleet)
end

function var0_0.updateExerciseFleet(arg0_21, arg1_21)
	arg0_21.seasonInfo:updateFleet(arg1_21)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0_21:sendNotification(var0_0.EXERCISE_FLEET_UPDATED, arg1_21:clone())
end

function var0_0.increaseExerciseCount(arg0_22)
	arg0_22.seasonInfo:increaseExerciseCount()
end

function var0_0.reduceExerciseCount(arg0_23)
	arg0_23.seasonInfo:reduceExerciseCount()
end

function var0_0.updateArenaRankLsit(arg0_24, arg1_24)
	assert(arg1_24, "should exist arenaRankLsit")

	arg0_24.arenaRankLsit = arg1_24

	arg0_24:sendNotification(var0_0.ARENARANK_UPDATED, Clone(arg1_24))
end

function var0_0.getArenaRankList(arg0_25)
	return arg0_25.arenaRankLsit
end

function var0_0.getData(arg0_26)
	return Clone(arg0_26.seasonInfo)
end

return var0_0
