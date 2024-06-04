local var0 = class("BattleGateActBoss")

ys.Battle.BattleGateActBoss = var0
var0.__name = "BattleGateActBoss"

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg0.continuousBattleTimes
	local var1 = arg0.totalBattleTimes
	local var2 = arg0.actId
	local var3 = getProxy(ActivityProxy):getActivityById(var2)
	local var4 = var3:getConfig("config_id")
	local var5 = pg.activity_event_worldboss[var4]
	local var6 = getProxy(PlayerProxy)
	local var7 = getProxy(BayProxy)
	local var8 = getProxy(FleetProxy)
	local var9 = pg.battle_cost_template[SYSTEM_ACT_BOSS]
	local var10 = var9.oil_cost > 0
	local var11 = {}
	local var12 = 0
	local var13 = 0
	local var14 = 0
	local var15 = 0
	local var16 = arg0.stageId
	local var17 = arg0.mainFleetId
	local var18 = var8:getActivityFleets()[var2][var17]
	local var19 = var7:getSortShipsByFleet(var18)

	for iter0, iter1 in ipairs(var19) do
		var11[#var11 + 1] = iter1.id
	end

	local var20 = var18:getStartCost().oil
	local var21 = var18:GetCostSum().oil
	local var22 = var5.use_oil_limit[var17]

	if var3:IsOilLimit(var16) and var22[1] > 0 then
		var21 = math.min(var21, var22[1])
	end

	local var23 = var6:getData()

	if var10 and var21 > var23.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var24 = pg.expedition_data_template[var16].dungeon_id
	local var25 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var24).fleet_prefab

	arg1.ShipVertify()

	local function var26(arg0)
		if var10 then
			var23:consume({
				gold = 0,
				oil = var20
			})
		end

		if var9.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var19) do
				iter1:cosumeEnergy(var0)
				var7:updateShip(iter1)
			end
		end

		var6:updatePlayer(var23)

		local var1 = {
			mainFleetId = var17,
			actId = var2,
			prefabFleet = var25,
			stageId = var16,
			system = SYSTEM_ACT_BOSS,
			token = arg0.key,
			continuousBattleTimes = var0,
			totalBattleTimes = var1
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var27(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_ACT_BOSS, var11, {
		var16
	}, var26, var27)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_ACT_BOSS]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = getProxy(ActivityProxy):getActivityById(arg0.actId)
	local var5 = var4:getConfig("config_id")
	local var6 = pg.activity_event_worldboss[var5].use_oil_limit[arg0.mainFleetId]
	local var7 = var4:IsOilLimit(arg0.stageId)
	local var8 = var1:getActivityFleets()[arg0.actId]
	local var9 = var8[arg0.mainFleetId]
	local var10
	local var11 = 0
	local var12 = {}
	local var13 = {}
	local var14 = var0.oil_cost > 0

	local function var15(arg0, arg1)
		if var14 then
			local var0 = arg0:getEndCost().oil

			if arg1 > 0 then
				local var1 = arg0:getStartCost().oil

				var0 = math.clamp(arg1 - var1, 0, var0)
			end

			var11 = var11 + var0
		end

		table.insertto(var12, var2:getSortShipsByFleet(arg0))
		table.insertto(var13, arg0.commanderIds)
	end

	var15(var9, var7 and var6[1] or 0)

	if arg0.statistics.submarineAid then
		var10 = var8[arg0.mainFleetId + 10]

		if var10 then
			var15(var10, var7 and var6[2] or 0)
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var16 = arg1.GeneralPackage(arg0, var12)

	var16.commander_id_list = var13

	local function var17(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C
		local var3 = arg1.GenerateCommanderExp(arg0, var9, var10)

		arg1.GeneralPlayerCosume(SYSTEM_ACT_BOSS, var2, var11, arg0.player_exp)

		local var4

		if var2 then
			var4 = (function()
				local var0 = getProxy(ActivityProxy):getActivityById(arg0.actId)
				local var1 = arg0.stageId

				return var0.data1KeyValueList[1][var1] == 1 and var0.data1KeyValueList[2][var1] <= 0
			end)()

			arg1:sendNotification(GAME.ACT_BOSS_NORMAL_UPDATE, {
				stageId = arg0.stageId
			})
		end

		local var5 = {
			system = SYSTEM_ACT_BOSS,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = var3,
			result = arg0.result,
			extraDrops = var1,
			isLastBonus = var4
		}

		if PlayerConst.CanDropItem(var0) then
			local var6 = {}

			for iter0, iter1 in ipairs(var0) do
				table.insert(var6, iter1)
			end

			for iter2, iter3 in ipairs(var1) do
				iter3.riraty = true

				table.insert(var6, iter3)
			end

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				getProxy(ChapterProxy):AddActBossRewards(var6)
			end
		end

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var5)
	end

	arg1:SendRequest(var16, var17)
end

return var0
