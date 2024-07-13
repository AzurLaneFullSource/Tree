local var0_0 = class("BattleGateBossSingle")

ys.Battle.BattleGateBossSingle = var0_0
var0_0.__name = "BattleGateBossSingle"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(FleetProxy)
	local var3_1 = getProxy(BayProxy)
	local var4_1 = pg.battle_cost_template[SYSTEM_BOSS_SINGLE]
	local var5_1 = var4_1.oil_cost > 0
	local var6_1 = getProxy(ActivityProxy):getActivityById(var0_1)
	local var7_1 = arg0_1.stageId
	local var8_1 = arg0_1.mainFleetId
	local var9_1 = var2_1:getActivityFleets()[var0_1][var8_1]
	local var10_1 = {}
	local var11_1 = var3_1:getSortShipsByFleet(var9_1)

	for iter0_1, iter1_1 in ipairs(var11_1) do
		var10_1[#var10_1 + 1] = iter1_1.id
	end

	local var12_1 = var6_1:GetEnemyDataByStageId(var7_1)
	local var13_1 = 0
	local var14_1 = var1_1:getRawData()
	local var15_1 = var9_1:GetCostSum().oil
	local var16_1 = var12_1:GetOilLimit()
	local var17_1 = math.min(var15_1, var16_1[1])

	if var5_1 and var17_1 > var14_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1_1.ShipVertify()

	local var18_1 = var9_1:getStartCost().oil

	local function var19_1(arg0_2)
		if var5_1 then
			var14_1:consume({
				gold = 0,
				oil = var18_1
			})
		end

		if var4_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var11_1) do
				iter1_2:cosumeEnergy(var0_2)
				var3_1:updateShip(iter1_2)
			end
		end

		var1_1:updatePlayer(var14_1)

		local var1_2 = {
			mainFleetId = var8_1,
			prefabFleet = {},
			stageId = var7_1,
			system = SYSTEM_BOSS_SINGLE,
			actId = var0_1,
			token = arg0_2.key,
			continuousBattleTimes = arg0_1.continuousBattleTimes,
			totalBattleTimes = arg0_1.totalBattleTimes
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var20_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_BOSS_SINGLE, var10_1, {
		var7_1
	}, var19_1, var20_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_BOSS_SINGLE]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = getProxy(ActivityProxy):getActivityById(arg0_4.actId):GetEnemyDataByStageId(arg0_4.stageId):GetOilLimit()
	local var5_4 = var1_4:getActivityFleets()[arg0_4.actId]
	local var6_4 = var5_4[arg0_4.mainFleetId]
	local var7_4
	local var8_4 = 0
	local var9_4 = {}
	local var10_4 = {}
	local var11_4 = var0_4.oil_cost > 0

	local function var12_4(arg0_5, arg1_5)
		if var11_4 then
			local var0_5 = arg0_5:getEndCost().oil

			if arg1_5 > 0 then
				local var1_5 = arg0_5:getStartCost().oil

				var0_5 = math.clamp(arg1_5 - var1_5, 0, var0_5)
			end

			var8_4 = var8_4 + var0_5
		end

		table.insertto(var9_4, var2_4:getSortShipsByFleet(arg0_5))
		table.insertto(var10_4, arg0_5.commanderIds)
	end

	var12_4(var6_4, var4_4[1] or 0)

	if arg0_4.statistics.submarineAid then
		var7_4 = var5_4[arg0_4.mainFleetId + 10]

		if var7_4 then
			var12_4(var7_4, var4_4[2] or 0)
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var13_4 = arg1_4.GeneralPackage(arg0_4, var9_4)

	var13_4.commander_id_list = var10_4

	local function var14_4(arg0_6)
		arg1_4.addShipsExp(arg0_6.ship_exp_list, arg0_4.statistics, true)

		arg0_4.statistics.mvpShipID = arg0_6.mvp

		local var0_6, var1_6 = arg1_4:GeneralLoot(arg0_6)
		local var2_6 = var3_4 > ys.Battle.BattleConst.BattleScore.C
		local var3_6 = arg1_4.GenerateCommanderExp(arg0_6, var6_4, var7_4)

		arg1_4.GeneralPlayerCosume(SYSTEM_BOSS_SINGLE, var2_6, var8_4, arg0_6.player_exp)

		if var2_6 then
			local var4_6 = getProxy(ActivityProxy):getActivityById(arg0_4.actId)
			local var5_6 = var4_6:GetEnemyDataByStageId(arg0_4.stageId)

			var4_6:AddDailyCount(var5_6.id)
			var4_6:AddPassStage(var5_6:GetExpeditionId())
			getProxy(ActivityProxy):updateActivity(var4_6)
		end

		local var6_6 = {
			system = SYSTEM_BOSS_SINGLE,
			statistics = arg0_4.statistics,
			score = var3_4,
			result = arg0_6.result,
			drops = var0_6,
			commanderExps = var3_6,
			extraDrops = var1_6
		}

		if PlayerConst.CanDropItem(var0_6) then
			local var7_6 = {}

			for iter0_6, iter1_6 in ipairs(var0_6) do
				table.insert(var7_6, iter1_6)
			end

			for iter2_6, iter3_6 in ipairs(var1_6) do
				iter3_6.riraty = true

				table.insert(var7_6, iter3_6)
			end

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				getProxy(ChapterProxy):AddBossSingleRewards(var7_6)
			end
		end

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var6_6)
	end

	arg1_4:SendRequest(var13_4, var14_4)
end

return var0_0
