local var0 = class("SeasonInfo", import(".BaseVO"))

var0.RECOVER_UP_COUNT = 5
var0.MAX_FIGHTCOUNT = 10
var0.RECOVER_UP_SIX_HOUR = 6
var0.RECOVER_UP_TWELVE_HOUR = 12
var0.INIT_POINT = pg.arena_data_rank[1].point
var0.ONE_SEASON_TIME = 1209600
var0.preRivals = {}

function var0.Ctor(arg0, arg1)
	arg0.score = arg1.score or 0
	arg0.rank = arg1.rank
	arg0.fightCount = arg1.fight_count
	arg0.resetTime = arg1.fight_count_reset_time
	arg0.flashTargetCount = arg1.flash_target_count + 1
	arg0.score = arg0.score + var0.INIT_POINT

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.vanguard_ship_id_list) do
		table.insert(var0, iter1)
	end

	for iter2, iter3 in ipairs(arg1.main_ship_id_list) do
		table.insert(var0, iter3)
	end

	arg0.fleet = TypedFleet.New({
		saveLastShipFlag = true,
		ship_list = var0,
		fleetType = FleetType.Normal
	})
	arg0.rivals = {}

	for iter4, iter5 in ipairs(arg1.target_list) do
		local var1 = Rival.New(iter5)

		table.insert(arg0.rivals, var1)

		var0.preRivals[var1.id] = var1
	end
end

function var0.getFlashCount(arg0)
	return arg0.flashTargetCount
end

function var0.increaseFlashCount(arg0)
	arg0.flashTargetCount = arg0.flashTargetCount + 1
end

function var0.resetFlashCount(arg0)
	arg0.flashTargetCount = 0
end

function var0.getconsumeGem(arg0)
	local var0 = arg0.getMilitaryRank(arg0.score, arg0.rank)

	return var0.refresh_price[arg0.flashTargetCount] or var0.refresh_price[#var0.refresh_price]
end

function var0.updateRank(arg0, arg1)
	arg0.rank = arg1
end

function var0.updateScore(arg0, arg1)
	arg0.score = arg1
end

function var0.getRivals(arg0)
	return Clone(arg0.rivals)
end

function var0.updateRivals(arg0, arg1)
	for iter0, iter1 in pairs(arg0.rivals) do
		var0.preRivals[iter1.id] = iter1
	end

	arg0.rivals = arg1
end

function var0.GetPreRivals(arg0)
	return var0.preRivals
end

function var0.updateFleet(arg0, arg1)
	arg0.fleet = arg1
end

function var0.canExercise(arg0)
	return arg0.fightCount > 0
end

function var0.reduceExerciseCount(arg0)
	assert(arg0.fightCount > 0, "演习次数必须大于0")

	arg0.fightCount = arg0.fightCount - 1
end

function var0.updateExerciseCount(arg0, arg1)
	local var0 = arg0.fightCount + arg1

	arg0.fightCount = math.min(var0, var0.MAX_FIGHTCOUNT)
end

function var0.setExerciseCount(arg0, arg1)
	arg0.fightCount = arg1
end

function var0.updateResetTime(arg0, arg1)
	arg0.resetTime = arg1
end

function var0.getMilitaryRank(arg0, arg1)
	local var0
	local var1 = pg.arena_data_rank

	for iter0 = #var1.all, 1, -1 do
		local var2 = var1.all[iter0]
		local var3 = var1[var2].point
		local var4 = var1[var2].order

		if var1[var2].order ~= 0 then
			if arg1 <= var4 and var3 <= arg0 then
				var0 = var1[var2]

				break
			end
		elseif var3 <= arg0 then
			var0 = var1[var2]

			break
		end
	end

	var0 = var0 or var1[var1.all[1]]

	return var0
end

function var0.getNextMilitaryRank(arg0, arg1)
	local var0 = var0.getMilitaryRank(arg0, arg1)
	local var1 = pg.arena_data_rank[var0.id + 1] or pg.arena_data_rank[#pg.arena_data_rank.all]

	return var1.name, var1.point, var1.order
end

function var0.maxRankScore()
	local var0 = pg.arena_data_rank
	local var1 = var0[var0.all[#var0.all]]

	return var1.name, var1.point
end

function var0.getEmblem(arg0, arg1)
	local var0 = var0.getMilitaryRank(arg0, arg1)

	return math.min(math.max(var0.id, 1), 14)
end

function var0.getMainShipIds(arg0)
	return arg0.fleet.mainShips
end

function var0.getVanguardShipIds(arg0)
	return arg0.fleet.vanguardShips
end

function var0.getMainFleetShipCount(arg0)
	return table.getCount(arg0.mainShips)
end

function var0.getVanguardShipsShipCount(arg0)
	return table.getCount(arg0.vanguardShips)
end

return var0
