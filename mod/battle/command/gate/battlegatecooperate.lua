local var0_0 = class("BattleGateCooperate")

ys.Battle.BattleGateCooperate = var0_0
var0_0.__name = "BattleGateCooperate"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(BayProxy)
	local var3_1 = getProxy(FleetProxy)
	local var4_1 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var5_1 = var4_1.oil_cost > 0
	local var6_1 = {}
	local var7_1 = 0
	local var8_1 = 0
	local var9_1 = 0
	local var10_1 = 0
	local var11_1 = var3_1:getActivityFleets()[var0_1][Fleet.REGULAR_FLEET_ID]

	for iter0_1, iter1_1 in ipairs(var11_1.ships) do
		var6_1[#var6_1 + 1] = iter1_1
	end

	local var12_1 = var11_1:getStartCost().oil
	local var13_1 = var11_1:GetCostSum().oil
	local var14_1 = var2_1:getSortShipsByFleet(var11_1)
	local var15_1 = var1_1:getData()

	if var5_1 and var13_1 > var15_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var16_1 = arg0_1.stageId
	local var17_1 = pg.expedition_data_template[var16_1].dungeon_id
	local var18_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var17_1).fleet_prefab

	arg1_1.ShipVertify()

	local var19_1

	if chapter:getPlayType() == ChapterConst.TypeExtra then
		var19_1 = true
	end

	local function var20_1(arg0_2)
		if var5_1 then
			var15_1:consume({
				gold = 0,
				oil = var12_1
			})
		end

		if var4_1.enter_energy_cost > 0 and not var19_1 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var14_1) do
				iter1_2:cosumeEnergy(var0_2)
				var2_1:updateShip(iter1_2)
			end
		end

		var1_1:updatePlayer(var15_1)

		local var1_2 = Fleet.REGULAR_FLEET_ID
		local var2_2 = {
			mainFleetId = var1_2,
			prefabFleet = var18_1,
			stageId = var16_1,
			actId = var0_1,
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var2_2)
	end

	local function var21_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_HP_SHARE_ACT_BOSS, var6_1, {
		var16_1
	}, var20_1, var21_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	if client.CheaterVertify() then
		return
	end

	local var0_4 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(ChapterProxy)
	local var3_4 = ys.Battle.BattleConst.BattleScore.S
	local var4_4 = 0
	local var5_4 = 0
	local var6_4
	local var7_4 = var1_4:getActivityFleets()[arg0_4.actId][arg0_4.mainFleetId]
	local var8_4 = bayProxy:getSortShipsByFleet(var7_4)
	local var9_4 = var7_4:getEndCost().oil

	if arg0_4.statistics.submarineAid then
		local var10_4 = var1_4:getActivityFleets()[arg0_4.actId][Fleet.SUBMARINE_FLEET_ID]

		if var10_4 then
			local var11_4 = bayProxy:getSortShipsByFleet(var10_4)

			for iter0_4, iter1_4 in ipairs(var11_4) do
				if arg0_4.statistics[iter1_4.id] then
					table.insert(var8_4, iter1_4)

					var9_4 = var9_4 + iter1_4:getEndBattleExpend()
				end
			end
		else
			originalPrint("finish stage error: can not find submarine fleet.")
		end
	end

	local var12_4 = client.GeneralPackage(arg0_4, var8_4)
	local var13_4 = {}

	for iter2_4, iter3_4 in ipairs(arg0_4.statistics._enemyInfoList) do
		table.insert(var13_4, {
			enemy_id = iter3_4.id,
			damage_taken = iter3_4.damage,
			total_hp = iter3_4.totalHp
		})
	end

	var12_4.enemy_info = var13_4

	local function var14_4(arg0_5)
		client.addShipsExp(arg0_5.ship_exp_list, arg0_4.statistics)

		arg0_4.statistics.mvpShipID = arg0_5.mvp

		local var0_5, var1_5 = client:GeneralLoot(arg0_5)
		local var2_5 = var3_4 > ys.Battle.BattleConst.BattleScore.C

		var0_0.GeneralPlayerCosume(SYSTEM_HP_SHARE_ACT_BOSS, var2_5, var9_4, arg0_5.player_exp)

		local var3_5 = {
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_5,
			commanderExps = {},
			result = arg0_5.result,
			extraDrops = var1_5
		}

		client:sendNotification(GAME.FINISH_STAGE_DONE, var3_5)
	end

	client:SendRequest(var12_4, var14_4)
end

return var0_0
