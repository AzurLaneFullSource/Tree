local var0 = class("BattleGateDuel")

ys.Battle.BattleGateDuel = var0
var0.__name = "BattleGateDuel"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.mainFleetId

	if not arg1.LegalFleet(arg0.mainFleetId) then
		return
	end

	if not getProxy(MilitaryExerciseProxy):getSeasonInfo():canExercise() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_count_insufficient"))

		return
	end

	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(BayProxy)
	local var3 = getProxy(FleetProxy)
	local var4
	local var5
	local var6 = arg0.rivalId
	local var7 = getProxy(MilitaryExerciseProxy):getRivalById(var6)
	local var8 = pg.battle_cost_template[SYSTEM_DUEL]
	local var9 = var8.oil_cost > 0
	local var10 = {}
	local var11 = 0
	local var12 = 0
	local var13 = 0
	local var14 = 0
	local var15 = var3:getFleetById(var0)
	local var16 = var2:getSortShipsByFleet(var15)

	for iter0, iter1 in ipairs(var16) do
		var10[#var10 + 1] = iter1.id
	end

	local var17 = var1:getData()

	if var9 and var14 > var17.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var18 = 0

	for iter2, iter3 in ipairs(var7.mainShips) do
		var18 = var18 + iter3.level
	end

	for iter4, iter5 in ipairs(var7.vanguardShips) do
		var18 = var18 + iter5.level
	end

	RivalLevelVertiry = var18

	arg1.ShipVertify()

	local function var19(arg0)
		if var9 then
			var17:consume({
				gold = 0,
				oil = var12
			})
		end

		if var8.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var16) do
				iter1:cosumeEnergy(var0)
				var2:updateShip(iter1)
			end
		end

		local var1 = ys.Battle.BattleConfig.ARENA_LIST
		local var2 = var1[math.random(#var1)]

		var1:updatePlayer(var17)

		local var3 = {
			mainFleetId = var0,
			prefabFleet = {},
			stageId = var2,
			system = SYSTEM_DUEL,
			rivalId = var6,
			token = arg0.key,
			mode = mode
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var3)
	end

	local function var20(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_DUEL, var10, {
		var6
	}, var19, var20)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_DUEL]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = {}
	local var6 = var1:getFleetById(arg0.mainFleetId)
	local var7 = var2:getSortShipsByFleet(var6)
	local var8 = var6:getEndCost().oil
	local var9 = arg1.GeneralPackage(arg0, var7)

	local function var10(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, false)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C

		arg1.GeneralPlayerCosume(SYSTEM_DUEL, var2, var8, arg0.player_exp, exFlag)
		getProxy(MilitaryExerciseProxy):reduceExerciseCount()

		local var3 = {
			system = SYSTEM_DUEL,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = {},
			result = arg0.result,
			extraDrops = var1
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var3)
	end

	arg1:SendRequest(var9, var10)
end

return var0
