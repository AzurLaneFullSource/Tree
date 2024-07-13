local var0_0 = class("BattleGateActBoss")

ys.Battle.BattleGateActBoss = var0_0
var0_0.__name = "BattleGateActBoss"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.continuousBattleTimes
	local var1_1 = arg0_1.totalBattleTimes
	local var2_1 = arg0_1.actId
	local var3_1 = getProxy(ActivityProxy):getActivityById(var2_1)
	local var4_1 = var3_1:getConfig("config_id")
	local var5_1 = pg.activity_event_worldboss[var4_1]
	local var6_1 = getProxy(PlayerProxy)
	local var7_1 = getProxy(BayProxy)
	local var8_1 = getProxy(FleetProxy)
	local var9_1 = pg.battle_cost_template[SYSTEM_ACT_BOSS]
	local var10_1 = var9_1.oil_cost > 0
	local var11_1 = {}
	local var12_1 = 0
	local var13_1 = 0
	local var14_1 = 0
	local var15_1 = 0
	local var16_1 = arg0_1.stageId
	local var17_1 = arg0_1.mainFleetId
	local var18_1 = var8_1:getActivityFleets()[var2_1][var17_1]
	local var19_1 = var7_1:getSortShipsByFleet(var18_1)

	for iter0_1, iter1_1 in ipairs(var19_1) do
		var11_1[#var11_1 + 1] = iter1_1.id
	end

	local var20_1 = var18_1:getStartCost().oil
	local var21_1 = var18_1:GetCostSum().oil
	local var22_1 = var5_1.use_oil_limit[var17_1]

	if var3_1:IsOilLimit(var16_1) and var22_1[1] > 0 then
		var21_1 = math.min(var21_1, var22_1[1])
	end

	local var23_1 = var6_1:getData()

	if var10_1 and var21_1 > var23_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var24_1 = pg.expedition_data_template[var16_1].dungeon_id
	local var25_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var24_1).fleet_prefab

	arg1_1.ShipVertify()

	local function var26_1(arg0_2)
		if var10_1 then
			var23_1:consume({
				gold = 0,
				oil = var20_1
			})
		end

		if var9_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var19_1) do
				iter1_2:cosumeEnergy(var0_2)
				var7_1:updateShip(iter1_2)
			end
		end

		var6_1:updatePlayer(var23_1)

		local var1_2 = {
			mainFleetId = var17_1,
			actId = var2_1,
			prefabFleet = var25_1,
			stageId = var16_1,
			system = SYSTEM_ACT_BOSS,
			token = arg0_2.key,
			continuousBattleTimes = var0_1,
			totalBattleTimes = var1_1
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var27_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_ACT_BOSS, var11_1, {
		var16_1
	}, var26_1, var27_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_ACT_BOSS]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = getProxy(ActivityProxy):getActivityById(arg0_4.actId)
	local var5_4 = var4_4:getConfig("config_id")
	local var6_4 = pg.activity_event_worldboss[var5_4].use_oil_limit[arg0_4.mainFleetId]
	local var7_4 = var4_4:IsOilLimit(arg0_4.stageId)
	local var8_4 = var1_4:getActivityFleets()[arg0_4.actId]
	local var9_4 = var8_4[arg0_4.mainFleetId]
	local var10_4
	local var11_4 = 0
	local var12_4 = {}
	local var13_4 = {}
	local var14_4 = var0_4.oil_cost > 0

	local function var15_4(arg0_5, arg1_5)
		if var14_4 then
			local var0_5 = arg0_5:getEndCost().oil

			if arg1_5 > 0 then
				local var1_5 = arg0_5:getStartCost().oil

				var0_5 = math.clamp(arg1_5 - var1_5, 0, var0_5)
			end

			var11_4 = var11_4 + var0_5
		end

		table.insertto(var12_4, var2_4:getSortShipsByFleet(arg0_5))
		table.insertto(var13_4, arg0_5.commanderIds)
	end

	var15_4(var9_4, var7_4 and var6_4[1] or 0)

	if arg0_4.statistics.submarineAid then
		var10_4 = var8_4[arg0_4.mainFleetId + 10]

		if var10_4 then
			var15_4(var10_4, var7_4 and var6_4[2] or 0)
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var16_4 = arg1_4.GeneralPackage(arg0_4, var12_4)

	var16_4.commander_id_list = var13_4

	local function var17_4(arg0_6)
		arg1_4.addShipsExp(arg0_6.ship_exp_list, arg0_4.statistics, true)

		arg0_4.statistics.mvpShipID = arg0_6.mvp

		local var0_6, var1_6 = arg1_4:GeneralLoot(arg0_6)
		local var2_6 = var3_4 > ys.Battle.BattleConst.BattleScore.C
		local var3_6 = arg1_4.GenerateCommanderExp(arg0_6, var9_4, var10_4)

		arg1_4.GeneralPlayerCosume(SYSTEM_ACT_BOSS, var2_6, var11_4, arg0_6.player_exp)

		local var4_6

		if var2_6 then
			var4_6 = (function()
				local var0_7 = getProxy(ActivityProxy):getActivityById(arg0_4.actId)
				local var1_7 = arg0_4.stageId

				return var0_7.data1KeyValueList[1][var1_7] == 1 and var0_7.data1KeyValueList[2][var1_7] <= 0
			end)()

			arg1_4:sendNotification(GAME.ACT_BOSS_NORMAL_UPDATE, {
				stageId = arg0_4.stageId
			})
		end

		local var5_6 = {
			system = SYSTEM_ACT_BOSS,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_6,
			commanderExps = var3_6,
			result = arg0_6.result,
			extraDrops = var1_6,
			isLastBonus = var4_6
		}

		if PlayerConst.CanDropItem(var0_6) then
			local var6_6 = {}

			for iter0_6, iter1_6 in ipairs(var0_6) do
				table.insert(var6_6, iter1_6)
			end

			for iter2_6, iter3_6 in ipairs(var1_6) do
				iter3_6.riraty = true

				table.insert(var6_6, iter3_6)
			end

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				getProxy(ChapterProxy):AddActBossRewards(var6_6)
			end
		end

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var5_6)
	end

	arg1_4:SendRequest(var16_4, var17_4)
end

return var0_0
