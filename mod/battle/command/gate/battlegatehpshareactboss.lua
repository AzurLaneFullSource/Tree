local var0 = class("BattleGateHPShareActBoss")

ys.Battle.BattleGateHPShareActBoss = var0
var0.__name = "BattleGateHPShareActBoss"

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg0.actId
	local var1 = getProxy(ActivityProxy):getActivityById(var0)
	local var2 = var1:getConfig("config_id")
	local var3 = pg.activity_event_worldboss[var2]
	local var4 = getProxy(PlayerProxy)
	local var5 = getProxy(BayProxy)
	local var6 = getProxy(FleetProxy)
	local var7 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var8 = var7.oil_cost > 0
	local var9 = {}
	local var10 = 0
	local var11 = 0
	local var12 = 0
	local var13 = 0
	local var14 = arg0.stageId
	local var15 = arg0.mainFleetId
	local var16 = var6:getActivityFleets()[var0][var15]
	local var17 = var5:getSortShipsByFleet(var16)

	for iter0, iter1 in ipairs(var17) do
		var9[#var9 + 1] = iter1.id
	end

	local var18 = var16:getStartCost().oil
	local var19 = var16:GetCostSum().oil
	local var20 = var3.use_oil_limit[var15]

	if var1:IsOilLimit(var14) and var20[1] > 0 then
		var19 = math.min(var19, var20[1])
	end

	local var21 = var4:getData()
	local var22 = pg.activity_template[var0]
	local var23 = pg.activity_event_worldboss[var22.config_id].ticket

	if var4:getRawData():getResource(var23) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noTicket"))

		return
	end

	if var8 and var19 > var21.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var24 = pg.expedition_data_template[var14].dungeon_id
	local var25 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var24).fleet_prefab

	arg1.ShipVertify()

	local function var26(arg0)
		if var8 then
			var21:consume({
				gold = 0,
				oil = var18
			})
		end

		local var0 = id2res(var23)

		var21:consume({
			[var0] = 1
		})

		if var7.enter_energy_cost > 0 then
			local var1 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var17) do
				iter1:cosumeEnergy(var1)
				var5:updateShip(iter1)
			end
		end

		var4:updatePlayer(var21)

		local var2 = {
			mainFleetId = var15,
			actId = var0,
			prefabFleet = var25,
			stageId = var14,
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var2)
	end

	local function var27(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_HP_SHARE_ACT_BOSS, var9, {
		var14
	}, var26, var27)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = ys.Battle.BattleConst.BattleScore.S

	arg0.statistics._battleScore = var3

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

	local var17 = {}

	for iter0, iter1 in ipairs(arg0.statistics._enemyInfoList) do
		table.insert(var17, {
			enemy_id = iter1.id,
			damage_taken = iter1.damage,
			total_hp = iter1.totalHp
		})
	end

	var16.enemy_info = var17

	local function var18(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C
		local var3 = arg1.GenerateCommanderExp(arg0, var9, var10)

		arg1.GeneralPlayerCosume(SYSTEM_HP_SHARE_ACT_BOSS, var2, var11, arg0.player_exp)

		local var4 = {
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = var3,
			result = arg0.result,
			extraDrops = var1
		}

		var4:AddStage(arg0.stageId)
		getProxy(ActivityProxy):updateActivity(var4)
		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var4)
	end

	arg1:SendRequest(var16, var18)
end

return var0
