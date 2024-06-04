local var0 = class("BattleGateLimitChallenge")

ys.Battle.BattleGateLimitChallenge = var0
var0.__name = "BattleGateLimitChallenge"
var0.BattleSystem = SYSTEM_LIMIT_CHALLENGE

function var0.Entrance(arg0, arg1)
	local var0 = FleetProxy.CHALLENGE_FLEET_ID

	if not arg1.LegalFleet(var0) then
		return
	end

	local var1 = getProxy(PlayerProxy)
	local var2 = var1:getData()
	local var3 = getProxy(FleetProxy)
	local var4 = getProxy(BayProxy)
	local var5 = getProxy(LimitChallengeProxy)
	local var6 = arg0.stageId
	local var7 = pg.expedition_data_template[var6].dungeon_id
	local var8 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var7).fleet_prefab
	local var9 = var3:getFleetById(FleetProxy.CHALLENGE_FLEET_ID)
	local var10 = {}
	local var11 = var4:getSortShipsByFleet(var9)

	for iter0, iter1 in ipairs(var11) do
		var10[#var10 + 1] = iter1.id
	end

	local var12 = pg.battle_cost_template[var0.BattleSystem]
	local var13 = var12.oil_cost > 0
	local var14 = 0
	local var15 = 0

	if var13 then
		var14 = var9:getStartCost().oil
		var15 = var9:GetCostSum().oil
	end

	if var13 and var15 > var2.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1.ShipVertify()

	local function var16(arg0)
		if var13 then
			var2:consume({
				gold = 0,
				oil = var14
			})
		end

		if var12.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var11) do
				iter1:cosumeEnergy(var0)
				var4:updateShip(iter1)
			end
		end

		var1:updatePlayer(var2)

		local var1 = {
			mainFleetId = mainFleetID,
			prefabFleet = var8,
			stageId = var6,
			system = var0.BattleSystem,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var17(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(var0.BattleSystem, var10, {
		var6
	}, var16, var17)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[var0.BattleSystem]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = {}
	local var6 = {}
	local var7 = arg0.stageId
	local var8 = var1:getFleetById(FleetProxy.CHALLENGE_FLEET_ID)
	local var9

	if arg0.statistics.submarineAid then
		var9 = var1:getFleetById(FleetProxy.CHALLENGE_SUB_FLEET_ID)
	end

	;(function()
		local function var0(arg0)
			local var0 = arg0:getEndCost().oil

			var4 = var4 + var0

			table.insertto(var6, _.values(arg0.commanderIds))
			table.insertto(var5, var2:getSortShipsByFleet(arg0))
		end

		var0(var8)

		if arg0.statistics.submarineAid then
			var0(var9)
		end
	end)()

	local var10 = arg1.GeneralPackage(arg0, var5)

	var10.commander_id_list = var6

	local function var11(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C
		local var3 = arg1.GenerateCommanderExp(arg0, var8, var9)

		arg1.GeneralPlayerCosume(var0.BattleSystem, var2, var4, arg0.player_exp)

		local var4 = {
			system = var0.BattleSystem,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = var3,
			result = arg0.result,
			extraDrops = var1
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var4)

		if var2 then
			local var5 = LimitChallengeConst.GetChallengeIDByStageID(var7)
			local var6 = arg0.statistics._totalTime

			getProxy(LimitChallengeProxy):setPassTime(var5, var6)
		end
	end

	arg1:SendRequest(var10, var11)
end

return var0
