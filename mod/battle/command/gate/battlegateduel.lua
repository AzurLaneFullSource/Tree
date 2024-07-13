local var0_0 = class("BattleGateDuel")

ys.Battle.BattleGateDuel = var0_0
var0_0.__name = "BattleGateDuel"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.mainFleetId

	if not arg1_1.LegalFleet(arg0_1.mainFleetId) then
		return
	end

	if not getProxy(MilitaryExerciseProxy):getSeasonInfo():canExercise() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_count_insufficient"))

		return
	end

	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(BayProxy)
	local var3_1 = getProxy(FleetProxy)
	local var4_1
	local var5_1
	local var6_1 = arg0_1.rivalId
	local var7_1 = getProxy(MilitaryExerciseProxy):getRivalById(var6_1)
	local var8_1 = pg.battle_cost_template[SYSTEM_DUEL]
	local var9_1 = var8_1.oil_cost > 0
	local var10_1 = {}
	local var11_1 = 0
	local var12_1 = 0
	local var13_1 = 0
	local var14_1 = 0
	local var15_1 = var3_1:getFleetById(var0_1)
	local var16_1 = var2_1:getSortShipsByFleet(var15_1)

	for iter0_1, iter1_1 in ipairs(var16_1) do
		var10_1[#var10_1 + 1] = iter1_1.id
	end

	local var17_1 = var1_1:getData()

	if var9_1 and var14_1 > var17_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var18_1 = 0

	for iter2_1, iter3_1 in ipairs(var7_1.mainShips) do
		var18_1 = var18_1 + iter3_1.level
	end

	for iter4_1, iter5_1 in ipairs(var7_1.vanguardShips) do
		var18_1 = var18_1 + iter5_1.level
	end

	RivalLevelVertiry = var18_1

	arg1_1.ShipVertify()

	local function var19_1(arg0_2)
		if var9_1 then
			var17_1:consume({
				gold = 0,
				oil = var12_1
			})
		end

		if var8_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var16_1) do
				iter1_2:cosumeEnergy(var0_2)
				var2_1:updateShip(iter1_2)
			end
		end

		local var1_2 = ys.Battle.BattleConfig.ARENA_LIST
		local var2_2 = var1_2[math.random(#var1_2)]

		var1_1:updatePlayer(var17_1)

		local var3_2 = {
			mainFleetId = var0_1,
			prefabFleet = {},
			stageId = var2_2,
			system = SYSTEM_DUEL,
			rivalId = var6_1,
			token = arg0_2.key,
			mode = mode
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var3_2)
	end

	local function var20_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_DUEL, var10_1, {
		var6_1
	}, var19_1, var20_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_DUEL]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = {}
	local var6_4 = var1_4:getFleetById(arg0_4.mainFleetId)
	local var7_4 = var2_4:getSortShipsByFleet(var6_4)
	local var8_4 = var6_4:getEndCost().oil
	local var9_4 = arg1_4.GeneralPackage(arg0_4, var7_4)

	local function var10_4(arg0_5)
		arg1_4.addShipsExp(arg0_5.ship_exp_list, arg0_4.statistics, false)

		arg0_4.statistics.mvpShipID = arg0_5.mvp

		local var0_5, var1_5 = arg1_4:GeneralLoot(arg0_5)
		local var2_5 = var3_4 > ys.Battle.BattleConst.BattleScore.C

		arg1_4.GeneralPlayerCosume(SYSTEM_DUEL, var2_5, var8_4, arg0_5.player_exp, exFlag)
		getProxy(MilitaryExerciseProxy):reduceExerciseCount()

		local var3_5 = {
			system = SYSTEM_DUEL,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_5,
			commanderExps = {},
			result = arg0_5.result,
			extraDrops = var1_5
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var3_5)
	end

	arg1_4:SendRequest(var9_4, var10_4)
end

return var0_0
