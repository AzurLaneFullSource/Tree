local var0 = class("BattleGateBossSingle")

ys.Battle.BattleGateBossSingle = var0
var0.__name = "BattleGateBossSingle"

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg0.actId
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(FleetProxy)
	local var3 = getProxy(BayProxy)
	local var4 = pg.battle_cost_template[SYSTEM_BOSS_SINGLE]
	local var5 = var4.oil_cost > 0
	local var6 = getProxy(ActivityProxy):getActivityById(var0)
	local var7 = arg0.stageId
	local var8 = arg0.mainFleetId
	local var9 = var2:getActivityFleets()[var0][var8]
	local var10 = {}
	local var11 = var3:getSortShipsByFleet(var9)

	for iter0, iter1 in ipairs(var11) do
		var10[#var10 + 1] = iter1.id
	end

	local var12 = var6:GetEnemyDataByStageId(var7)
	local var13 = 0
	local var14 = var1:getRawData()
	local var15 = var9:GetCostSum().oil
	local var16 = var12:GetOilLimit()
	local var17 = math.min(var15, var16[1])

	if var5 and var17 > var14.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1.ShipVertify()

	local var18 = var9:getStartCost().oil

	local function var19(arg0)
		if var5 then
			var14:consume({
				gold = 0,
				oil = var18
			})
		end

		if var4.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var11) do
				iter1:cosumeEnergy(var0)
				var3:updateShip(iter1)
			end
		end

		var1:updatePlayer(var14)

		local var1 = {
			mainFleetId = var8,
			prefabFleet = {},
			stageId = var7,
			system = SYSTEM_BOSS_SINGLE,
			actId = var0,
			token = arg0.key,
			continuousBattleTimes = arg0.continuousBattleTimes,
			totalBattleTimes = arg0.totalBattleTimes
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var20(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_BOSS_SINGLE, var10, {
		var7
	}, var19, var20)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_BOSS_SINGLE]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = getProxy(ActivityProxy):getActivityById(arg0.actId):GetEnemyDataByStageId(arg0.stageId):GetOilLimit()
	local var5 = var1:getActivityFleets()[arg0.actId]
	local var6 = var5[arg0.mainFleetId]
	local var7
	local var8 = 0
	local var9 = {}
	local var10 = {}
	local var11 = var0.oil_cost > 0

	local function var12(arg0, arg1)
		if var11 then
			local var0 = arg0:getEndCost().oil

			if arg1 > 0 then
				local var1 = arg0:getStartCost().oil

				var0 = math.clamp(arg1 - var1, 0, var0)
			end

			var8 = var8 + var0
		end

		table.insertto(var9, var2:getSortShipsByFleet(arg0))
		table.insertto(var10, arg0.commanderIds)
	end

	var12(var6, var4[1] or 0)

	if arg0.statistics.submarineAid then
		var7 = var5[arg0.mainFleetId + 10]

		if var7 then
			var12(var7, var4[2] or 0)
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var13 = arg1.GeneralPackage(arg0, var9)

	var13.commander_id_list = var10

	local function var14(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C
		local var3 = arg1.GenerateCommanderExp(arg0, var6, var7)

		arg1.GeneralPlayerCosume(SYSTEM_BOSS_SINGLE, var2, var8, arg0.player_exp)

		if var2 then
			local var4 = getProxy(ActivityProxy):getActivityById(arg0.actId)
			local var5 = var4:GetEnemyDataByStageId(arg0.stageId)

			var4:AddDailyCount(var5.id)
			var4:AddPassStage(var5:GetExpeditionId())
			getProxy(ActivityProxy):updateActivity(var4)
		end

		local var6 = {
			system = SYSTEM_BOSS_SINGLE,
			statistics = arg0.statistics,
			score = var3,
			result = arg0.result,
			drops = var0,
			commanderExps = var3,
			extraDrops = var1
		}

		if PlayerConst.CanDropItem(var0) then
			local var7 = {}

			for iter0, iter1 in ipairs(var0) do
				table.insert(var7, iter1)
			end

			for iter2, iter3 in ipairs(var1) do
				iter3.riraty = true

				table.insert(var7, iter3)
			end

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				getProxy(ChapterProxy):AddBossSingleRewards(var7)
			end
		end

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var6)
	end

	arg1:SendRequest(var13, var14)
end

return var0
