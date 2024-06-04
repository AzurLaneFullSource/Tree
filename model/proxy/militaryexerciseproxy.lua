local var0 = class("MilitaryExerciseProxy", import(".NetProxy"))

var0.SEASON_INFO_ADDED = "MilitaryExerciseProxy SEASON_INFO_ADDED"
var0.SEASON_INFO_UPDATED = "MilitaryExerciseProxy SEASON_INFO_UPDATED"
var0.ARENARANK_UPDATED = "MilitaryExerciseProxy ARENARANK_UPDATED"
var0.EXERCISE_FLEET_UPDATED = "MilitaryExerciseProxy EXERCISE_FLEET_UPDATED"
var0.RIVALS_UPDATED = "MilitaryExerciseProxy RIVALS_UPDATED"

function var0.register(arg0)
	arg0:on(18005, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.target_list) do
			table.insert(var0, Rival.New(iter1))
		end

		local var1 = arg0:getSeasonInfo()

		var1:updateScore(arg0.score + SeasonInfo.INIT_POINT)
		var1:updateRank(arg0.rank)
		var1:updateRivals(var0)
		arg0:updateSeasonInfo(var1)

		local var2 = getProxy(PlayerProxy)
		local var3 = var2:getData()

		var3:updateScoreAndRank(var1.score, var1.rank)
		var2:updatePlayer(var3)
	end)
end

function var0.addSeasonInfo(arg0, arg1)
	assert(isa(arg1, SeasonInfo), "seasonInfo be an instance of SeasonInfo")

	arg0.seasonInfo = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0:sendNotification(var0.SEASON_INFO_ADDED, arg1:clone())
	arg0:addRefreshCountTimer()
end

function var0.addRefreshCountTimer(arg0)
	arg0:removeRefreshTimer()

	local function var0()
		arg0:sendNotification(GAME.EXERCISE_COUNT_RECOVER_UP)
	end

	local var1 = arg0.seasonInfo.resetTime - pg.TimeMgr.GetInstance():GetServerTime()

	if var1 > 0 then
		arg0.refreshCountTimer = Timer.New(function()
			var0()
		end, var1, 1)

		arg0.refreshCountTimer:Start()
	else
		var0()
	end
end

function var0.addSeasonOverTimer(arg0)
	arg0:removeSeasonOverTimer()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE)

	if var0 and not var0:isEnd() then
		local function var1()
			arg0:removeSeasonOverTimer()

			local var0 = arg0:getSeasonInfo()

			var0:setExerciseCount(0)
			arg0:updateSeasonInfo(var0)
		end

		local var2 = var0.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		if var2 > 0 then
			arg0.SeasonOverTimer = Timer.New(function()
				var1()
			end, var2, 1)

			arg0.SeasonOverTimer:Start()
		else
			var1()
		end
	end
end

function var0.removeRefreshTimer(arg0)
	if arg0.refreshCountTimer then
		arg0.refreshCountTimer:Stop()

		arg0.refreshCountTimer = nil
	end
end

function var0.removeSeasonOverTimer(arg0)
	if arg0.SeasonOverTimer then
		arg0.SeasonOverTimer:Stop()

		arg0.SeasonOverTimer = nil
	end
end

function var0.remove(arg0)
	arg0:removeRefreshTimer()
	arg0:removeSeasonOverTimer()
end

function var0.updateSeasonInfo(arg0, arg1)
	assert(isa(arg1, SeasonInfo), "seasonInfo be an instance of SeasonInfo")

	arg0.seasonInfo = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0:sendNotification(var0.SEASON_INFO_UPDATED, arg1:clone())
end

function var0.getSeasonInfo(arg0)
	return Clone(arg0.seasonInfo)
end

function var0.RawGetSeasonInfo(arg0)
	return arg0.seasonInfo
end

function var0.updateRivals(arg0, arg1)
	arg0.seasonInfo:updateRivals(arg1)
	arg0:sendNotification(var0.RIVALS_UPDATED, Clone(arg1))
end

function var0.getRivals(arg0)
	return Clone(arg0.seasonInfo.rivals)
end

function var0.getRivalById(arg0, arg1)
	for iter0, iter1 in ipairs(arg0:getRivals()) do
		if iter1.id == arg1 then
			return iter1
		end
	end
end

function var0.getPreRivalById(arg0, arg1)
	for iter0, iter1 in pairs(arg0.seasonInfo:GetPreRivals()) do
		if arg1 == iter0 then
			return Clone(iter1)
		end
	end
end

function var0.getExerciseFleet(arg0)
	return Clone(arg0.seasonInfo.fleet)
end

function var0.updateExerciseFleet(arg0, arg1)
	arg0.seasonInfo:updateFleet(arg1)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inExercise")
	arg0:sendNotification(var0.EXERCISE_FLEET_UPDATED, arg1:clone())
end

function var0.increaseExerciseCount(arg0)
	arg0.seasonInfo:increaseExerciseCount()
end

function var0.reduceExerciseCount(arg0)
	arg0.seasonInfo:reduceExerciseCount()
end

function var0.updateArenaRankLsit(arg0, arg1)
	assert(arg1, "should exist arenaRankLsit")

	arg0.arenaRankLsit = arg1

	arg0:sendNotification(var0.ARENARANK_UPDATED, Clone(arg1))
end

function var0.getArenaRankList(arg0)
	return arg0.arenaRankLsit
end

function var0.getData(arg0)
	return Clone(arg0.seasonInfo)
end

return var0
