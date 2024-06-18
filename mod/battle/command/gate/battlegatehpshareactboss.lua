local var0_0 = class("BattleGateHPShareActBoss")

ys.Battle.BattleGateHPShareActBoss = var0_0
var0_0.__name = "BattleGateHPShareActBoss"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)
	local var2_1 = var1_1:getConfig("config_id")
	local var3_1 = pg.activity_event_worldboss[var2_1]
	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = getProxy(BayProxy)
	local var6_1 = getProxy(FleetProxy)
	local var7_1 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var8_1 = var7_1.oil_cost > 0
	local var9_1 = {}
	local var10_1 = 0
	local var11_1 = 0
	local var12_1 = 0
	local var13_1 = 0
	local var14_1 = arg0_1.stageId
	local var15_1 = arg0_1.mainFleetId
	local var16_1 = var6_1:getActivityFleets()[var0_1][var15_1]
	local var17_1 = var5_1:getSortShipsByFleet(var16_1)

	for iter0_1, iter1_1 in ipairs(var17_1) do
		var9_1[#var9_1 + 1] = iter1_1.id
	end

	local var18_1 = var16_1:getStartCost().oil
	local var19_1 = var16_1:GetCostSum().oil
	local var20_1 = var3_1.use_oil_limit[var15_1]

	if var1_1:IsOilLimit(var14_1) and var20_1[1] > 0 then
		var19_1 = math.min(var19_1, var20_1[1])
	end

	local var21_1 = var4_1:getData()
	local var22_1 = pg.activity_template[var0_1]
	local var23_1 = pg.activity_event_worldboss[var22_1.config_id].ticket

	if var4_1:getRawData():getResource(var23_1) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noTicket"))

		return
	end

	if var8_1 and var19_1 > var21_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var24_1 = pg.expedition_data_template[var14_1].dungeon_id
	local var25_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var24_1).fleet_prefab

	arg1_1.ShipVertify()

	local function var26_1(arg0_2)
		if var8_1 then
			var21_1:consume({
				gold = 0,
				oil = var18_1
			})
		end

		local var0_2 = id2res(var23_1)

		var21_1:consume({
			[var0_2] = 1
		})

		if var7_1.enter_energy_cost > 0 then
			local var1_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var17_1) do
				iter1_2:cosumeEnergy(var1_2)
				var5_1:updateShip(iter1_2)
			end
		end

		var4_1:updatePlayer(var21_1)

		local var2_2 = {
			mainFleetId = var15_1,
			actId = var0_1,
			prefabFleet = var25_1,
			stageId = var14_1,
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var2_2)
	end

	local function var27_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_HP_SHARE_ACT_BOSS, var9_1, {
		var14_1
	}, var26_1, var27_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = ys.Battle.BattleConst.BattleScore.S

	arg0_4.statistics._battleScore = var3_4

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

	local var17_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.statistics._enemyInfoList) do
		table.insert(var17_4, {
			enemy_id = iter1_4.id,
			damage_taken = iter1_4.damage,
			total_hp = iter1_4.totalHp
		})
	end

	var16_4.enemy_info = var17_4

	local function var18_4(arg0_6)
		arg1_4.addShipsExp(arg0_6.ship_exp_list, arg0_4.statistics, true)

		arg0_4.statistics.mvpShipID = arg0_6.mvp

		local var0_6, var1_6 = arg1_4:GeneralLoot(arg0_6)
		local var2_6 = var3_4 > ys.Battle.BattleConst.BattleScore.C
		local var3_6 = arg1_4.GenerateCommanderExp(arg0_6, var9_4, var10_4)

		arg1_4.GeneralPlayerCosume(SYSTEM_HP_SHARE_ACT_BOSS, var2_6, var11_4, arg0_6.player_exp)

		local var4_6 = {
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_6,
			commanderExps = var3_6,
			result = arg0_6.result,
			extraDrops = var1_6
		}

		var4_4:AddStage(arg0_4.stageId)
		getProxy(ActivityProxy):updateActivity(var4_4)
		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_6)
	end

	arg1_4:SendRequest(var16_4, var18_4)
end

return var0_0
