local var0_0 = class("BattleGateSubRoutine")

ys.Battle.BattleGateSubRoutine = var0_0
var0_0.__name = "BattleGateSubRoutine"

function var0_0.Entrance(arg0_1, arg1_1)
	if not arg1_1.LegalFleet(arg0_1.mainFleetId) then
		return
	end

	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = getProxy(PlayerProxy)
	local var1_1 = getProxy(BayProxy)
	local var2_1 = getProxy(FleetProxy)
	local var3_1 = pg.battle_cost_template[SYSTEM_SUB_ROUTINE]
	local var4_1 = var3_1.oil_cost > 0
	local var5_1 = {}
	local var6_1 = 0
	local var7_1 = 0
	local var8_1 = 0
	local var9_1 = 0
	local var10_1 = var2_1:getFleetById(arg0_1.mainFleetId)
	local var11_1 = var1_1:getShipByTeam(var10_1, TeamType.Submarine)

	for iter0_1, iter1_1 in ipairs(var11_1) do
		var5_1[#var5_1 + 1] = iter1_1.id
	end

	local var12_1 = var10_1:getStartCost().oil
	local var13_1 = var10_1:GetCostSum().oil
	local var14_1 = var0_1:getData()

	if var4_1 and var13_1 > var14_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var15_1 = arg0_1.mainFleetId
	local var16_1 = arg0_1.stageId
	local var17_1 = pg.expedition_data_template[var16_1].dungeon_id
	local var18_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var17_1).fleet_prefab

	arg1_1.ShipVertify()

	local function var19_1(arg0_2)
		if var4_1 then
			var14_1:consume({
				gold = 0,
				oil = var12_1
			})
		end

		if var3_1.enter_energy_cost > 0 and not exFlag then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var11_1) do
				iter1_2:cosumeEnergy(var0_2)
				var1_1:updateShip(iter1_2)
			end
		end

		var0_1:updatePlayer(var14_1)

		local var1_2 = {
			mainFleetId = var15_1,
			prefabFleet = var18_1,
			stageId = var16_1,
			system = SYSTEM_SUB_ROUTINE,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var20_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_SUB_ROUTINE, var5_1, {
		var16_1
	}, var19_1, var20_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_SUB_ROUTINE]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = {}
	local var6_4 = var1_4:getFleetById(arg0_4.mainFleetId)
	local var7_4 = var2_4:getSortShipsByFleet(var6_4)
	local var8_4 = var6_4:getEndCost().oil
	local var9_4 = arg1_4.GeneralPackage(arg0_4, var7_4)

	local function var10_4(arg0_5)
		arg1_4.addShipsExp(arg0_5.ship_exp_list, arg0_4.statistics, true)

		arg0_4.statistics.mvpShipID = arg0_5.mvp

		local var0_5, var1_5 = arg1_4:GeneralLoot(arg0_5)
		local var2_5 = var3_4 > ys.Battle.BattleConst.BattleScore.C

		arg1_4.GeneralPlayerCosume(SYSTEM_SUB_ROUTINE, var2_5, var8_4, arg0_5.player_exp, exFlag)

		local var3_5 = getProxy(DailyLevelProxy)

		if var2_5 then
			var3_5.data[var3_5.dailyLevelId] = (var3_5.data[var3_5.dailyLevelId] or 0) + 1
		end

		if var3_4 == ys.Battle.BattleConst.BattleScore.S then
			var3_5:AddQuickStage(arg0_4.stageId)
		end

		local var4_5 = {
			system = SYSTEM_SUB_ROUTINE,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_5,
			commanderExps = {},
			result = arg0_5.result,
			extraDrops = var1_5
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_5)
	end

	arg1_4:SendRequest(var9_4, var10_4)
end

return var0_0
