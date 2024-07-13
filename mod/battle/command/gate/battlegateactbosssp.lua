local var0_0 = class("BattleGateActBossSP")

ys.Battle.BattleGateActBossSP = var0_0
var0_0.__name = "BattleGateActBossSP"
var0_0.BattleSystem = SYSTEM_ACT_BOSS_SP

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)
	local var2_1 = getProxy(PlayerProxy)
	local var3_1 = var2_1:getData()
	local var4_1 = getProxy(BayProxy)
	local var5_1 = getProxy(FleetProxy)
	local var6_1 = getProxy(ActivityProxy):GetActivityBossRuntime(var0_1).buffIds
	local var7_1 = arg0_1.stageId
	local var8_1 = pg.expedition_data_template[var7_1].dungeon_id
	local var9_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var8_1).fleet_prefab
	local var10_1 = arg0_1.mainFleetId
	local var11_1 = var5_1:getActivityFleets()[var0_1][var10_1]
	local var12_1 = {}
	local var13_1 = var4_1:getSortShipsByFleet(var11_1)

	for iter0_1, iter1_1 in ipairs(var13_1) do
		var12_1[#var12_1 + 1] = iter1_1.id
	end

	local var14_1 = pg.battle_cost_template[var0_0.BattleSystem]
	local var15_1 = var14_1.oil_cost > 0
	local var16_1 = 0
	local var17_1 = 0

	if var15_1 then
		var16_1 = var11_1:getStartCost().oil
		var17_1 = var11_1:GetCostSum().oil
	end

	if var17_1 > var3_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1_1.ShipVertify()

	local function var18_1(arg0_2)
		if var15_1 then
			var3_1:consume({
				gold = 0,
				oil = var16_1
			})
		end

		if var14_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var13_1) do
				iter1_2:cosumeEnergy(var0_2)
				var4_1:updateShip(iter1_2)
			end
		end

		var2_1:updatePlayer(var3_1)

		var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)

		var1_1:UpdateHistoryBuffs(var6_1)
		getProxy(ActivityProxy):updateActivity(var1_1)

		local var1_2 = {
			mainFleetId = var10_1,
			actId = var0_1,
			prefabFleet = var9_1,
			stageId = var7_1,
			system = var0_0.BattleSystem,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var19_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(var0_0.BattleSystem, var12_1, {
		var7_1,
		var6_1
	}, var18_1, var19_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[var0_0.BattleSystem]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = getProxy(ActivityProxy):getActivityById(arg0_4.actId):getConfig("config_id")
	local var5_4 = pg.activity_event_worldboss[var4_4]
	local var6_4 = var1_4:getActivityFleets()[arg0_4.actId]
	local var7_4 = var6_4[arg0_4.mainFleetId]
	local var8_4
	local var9_4 = 0
	local var10_4 = {}
	local var11_4 = {}
	local var12_4 = var0_4.oil_cost > 0

	local function var13_4(arg0_5, arg1_5)
		if var12_4 then
			local var0_5 = arg0_5:getEndCost().oil

			if arg1_5 > 0 then
				local var1_5 = arg0_5:getStartCost().oil

				var0_5 = math.clamp(arg1_5 - var1_5, 0, var0_5)
			end

			var9_4 = var9_4 + var0_5
		end

		table.insertto(var10_4, var2_4:getSortShipsByFleet(arg0_5))
		table.insertto(var11_4, arg0_5.commanderIds)
	end

	var13_4(var7_4, 0)

	if arg0_4.statistics.submarineAid then
		local var14_4 = var6_4[arg0_4.mainFleetId + 10]

		if var14_4 then
			var13_4(var14_4, 0)
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var15_4 = arg1_4.GeneralPackage(arg0_4, var10_4)

	var15_4.commander_id_list = var11_4

	local function var16_4(arg0_6)
		arg1_4.addShipsExp(arg0_6.ship_exp_list, arg0_4.statistics, true)

		arg0_4.statistics.mvpShipID = arg0_6.mvp

		local var0_6, var1_6 = arg1_4:GeneralLoot(arg0_6)
		local var2_6 = var3_4 > ys.Battle.BattleConst.BattleScore.C
		local var3_6 = arg1_4.GenerateCommanderExp(arg0_6, var7_4, var6_4[arg0_4.mainFleetId + 10])

		arg1_4.GeneralPlayerCosume(var0_0.BattleSystem, var2_6, var9_4, arg0_6.player_exp)

		local var4_6 = {
			system = var0_0.BattleSystem,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_6,
			commanderExps = var3_6,
			result = arg0_6.result,
			extraDrops = var1_6
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_6)
	end

	arg1_4:SendRequest(var15_4, var16_4)
end

return var0_0
