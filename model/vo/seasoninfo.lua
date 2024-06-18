local var0_0 = class("SeasonInfo", import(".BaseVO"))

var0_0.RECOVER_UP_COUNT = 5
var0_0.MAX_FIGHTCOUNT = 10
var0_0.RECOVER_UP_SIX_HOUR = 6
var0_0.RECOVER_UP_TWELVE_HOUR = 12
var0_0.INIT_POINT = pg.arena_data_rank[1].point
var0_0.ONE_SEASON_TIME = 1209600
var0_0.preRivals = {}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.score = arg1_1.score or 0
	arg0_1.rank = arg1_1.rank
	arg0_1.fightCount = arg1_1.fight_count
	arg0_1.resetTime = arg1_1.fight_count_reset_time
	arg0_1.flashTargetCount = arg1_1.flash_target_count + 1
	arg0_1.score = arg0_1.score + var0_0.INIT_POINT

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.vanguard_ship_id_list) do
		table.insert(var0_1, iter1_1)
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.main_ship_id_list) do
		table.insert(var0_1, iter3_1)
	end

	arg0_1.fleet = TypedFleet.New({
		saveLastShipFlag = true,
		ship_list = var0_1,
		fleetType = FleetType.Normal
	})
	arg0_1.rivals = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.target_list) do
		local var1_1 = Rival.New(iter5_1)

		table.insert(arg0_1.rivals, var1_1)

		var0_0.preRivals[var1_1.id] = var1_1
	end
end

function var0_0.getFlashCount(arg0_2)
	return arg0_2.flashTargetCount
end

function var0_0.increaseFlashCount(arg0_3)
	arg0_3.flashTargetCount = arg0_3.flashTargetCount + 1
end

function var0_0.resetFlashCount(arg0_4)
	arg0_4.flashTargetCount = 0
end

function var0_0.getconsumeGem(arg0_5)
	local var0_5 = arg0_5.getMilitaryRank(arg0_5.score, arg0_5.rank)

	return var0_5.refresh_price[arg0_5.flashTargetCount] or var0_5.refresh_price[#var0_5.refresh_price]
end

function var0_0.updateRank(arg0_6, arg1_6)
	arg0_6.rank = arg1_6
end

function var0_0.updateScore(arg0_7, arg1_7)
	arg0_7.score = arg1_7
end

function var0_0.getRivals(arg0_8)
	return Clone(arg0_8.rivals)
end

function var0_0.updateRivals(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.rivals) do
		var0_0.preRivals[iter1_9.id] = iter1_9
	end

	arg0_9.rivals = arg1_9
end

function var0_0.GetPreRivals(arg0_10)
	return var0_0.preRivals
end

function var0_0.updateFleet(arg0_11, arg1_11)
	arg0_11.fleet = arg1_11
end

function var0_0.canExercise(arg0_12)
	return arg0_12.fightCount > 0
end

function var0_0.reduceExerciseCount(arg0_13)
	assert(arg0_13.fightCount > 0, "演习次数必须大于0")

	arg0_13.fightCount = arg0_13.fightCount - 1
end

function var0_0.updateExerciseCount(arg0_14, arg1_14)
	local var0_14 = arg0_14.fightCount + arg1_14

	arg0_14.fightCount = math.min(var0_14, var0_0.MAX_FIGHTCOUNT)
end

function var0_0.setExerciseCount(arg0_15, arg1_15)
	arg0_15.fightCount = arg1_15
end

function var0_0.updateResetTime(arg0_16, arg1_16)
	arg0_16.resetTime = arg1_16
end

function var0_0.getMilitaryRank(arg0_17, arg1_17)
	local var0_17
	local var1_17 = pg.arena_data_rank

	for iter0_17 = #var1_17.all, 1, -1 do
		local var2_17 = var1_17.all[iter0_17]
		local var3_17 = var1_17[var2_17].point
		local var4_17 = var1_17[var2_17].order

		if var1_17[var2_17].order ~= 0 then
			if arg1_17 <= var4_17 and var3_17 <= arg0_17 then
				var0_17 = var1_17[var2_17]

				break
			end
		elseif var3_17 <= arg0_17 then
			var0_17 = var1_17[var2_17]

			break
		end
	end

	var0_17 = var0_17 or var1_17[var1_17.all[1]]

	return var0_17
end

function var0_0.getNextMilitaryRank(arg0_18, arg1_18)
	local var0_18 = var0_0.getMilitaryRank(arg0_18, arg1_18)
	local var1_18 = pg.arena_data_rank[var0_18.id + 1] or pg.arena_data_rank[#pg.arena_data_rank.all]

	return var1_18.name, var1_18.point, var1_18.order
end

function var0_0.maxRankScore()
	local var0_19 = pg.arena_data_rank
	local var1_19 = var0_19[var0_19.all[#var0_19.all]]

	return var1_19.name, var1_19.point
end

function var0_0.getEmblem(arg0_20, arg1_20)
	local var0_20 = var0_0.getMilitaryRank(arg0_20, arg1_20)

	return math.min(math.max(var0_20.id, 1), 14)
end

function var0_0.getMainShipIds(arg0_21)
	return arg0_21.fleet.mainShips
end

function var0_0.getVanguardShipIds(arg0_22)
	return arg0_22.fleet.vanguardShips
end

function var0_0.getMainFleetShipCount(arg0_23)
	return table.getCount(arg0_23.mainShips)
end

function var0_0.getVanguardShipsShipCount(arg0_24)
	return table.getCount(arg0_24.vanguardShips)
end

return var0_0
