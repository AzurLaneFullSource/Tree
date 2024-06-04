local var0 = class("BattleGateActBossSP")

ys.Battle.BattleGateActBossSP = var0
var0.__name = "BattleGateActBossSP"
var0.BattleSystem = SYSTEM_ACT_BOSS_SP

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg0.actId
	local var1 = getProxy(ActivityProxy):getActivityById(var0)
	local var2 = getProxy(PlayerProxy)
	local var3 = var2:getData()
	local var4 = getProxy(BayProxy)
	local var5 = getProxy(FleetProxy)
	local var6 = getProxy(ActivityProxy):GetActivityBossRuntime(var0).buffIds
	local var7 = arg0.stageId
	local var8 = pg.expedition_data_template[var7].dungeon_id
	local var9 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var8).fleet_prefab
	local var10 = arg0.mainFleetId
	local var11 = var5:getActivityFleets()[var0][var10]
	local var12 = {}
	local var13 = var4:getSortShipsByFleet(var11)

	for iter0, iter1 in ipairs(var13) do
		var12[#var12 + 1] = iter1.id
	end

	local var14 = pg.battle_cost_template[var0.BattleSystem]
	local var15 = var14.oil_cost > 0
	local var16 = 0
	local var17 = 0

	if var15 then
		var16 = var11:getStartCost().oil
		var17 = var11:GetCostSum().oil
	end

	if var17 > var3.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1.ShipVertify()

	local function var18(arg0)
		if var15 then
			var3:consume({
				gold = 0,
				oil = var16
			})
		end

		if var14.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var13) do
				iter1:cosumeEnergy(var0)
				var4:updateShip(iter1)
			end
		end

		var2:updatePlayer(var3)

		var1 = getProxy(ActivityProxy):getActivityById(var0)

		var1:UpdateHistoryBuffs(var6)
		getProxy(ActivityProxy):updateActivity(var1)

		local var1 = {
			mainFleetId = var10,
			actId = var0,
			prefabFleet = var9,
			stageId = var7,
			system = var0.BattleSystem,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var19(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(var0.BattleSystem, var12, {
		var7,
		var6
	}, var18, var19)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[var0.BattleSystem]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = getProxy(ActivityProxy):getActivityById(arg0.actId):getConfig("config_id")
	local var5 = pg.activity_event_worldboss[var4]
	local var6 = var1:getActivityFleets()[arg0.actId]
	local var7 = var6[arg0.mainFleetId]
	local var8
	local var9 = 0
	local var10 = {}
	local var11 = {}
	local var12 = var0.oil_cost > 0

	local function var13(arg0, arg1)
		if var12 then
			local var0 = arg0:getEndCost().oil

			if arg1 > 0 then
				local var1 = arg0:getStartCost().oil

				var0 = math.clamp(arg1 - var1, 0, var0)
			end

			var9 = var9 + var0
		end

		table.insertto(var10, var2:getSortShipsByFleet(arg0))
		table.insertto(var11, arg0.commanderIds)
	end

	var13(var7, 0)

	if arg0.statistics.submarineAid then
		local var14 = var6[arg0.mainFleetId + 10]

		if var14 then
			var13(var14, 0)
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var15 = arg1.GeneralPackage(arg0, var10)

	var15.commander_id_list = var11

	local function var16(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C
		local var3 = arg1.GenerateCommanderExp(arg0, var7, var6[arg0.mainFleetId + 10])

		arg1.GeneralPlayerCosume(var0.BattleSystem, var2, var9, arg0.player_exp)

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
	end

	arg1:SendRequest(var15, var16)
end

return var0
