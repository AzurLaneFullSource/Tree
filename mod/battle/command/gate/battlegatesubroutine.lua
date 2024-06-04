local var0 = class("BattleGateSubRoutine")

ys.Battle.BattleGateSubRoutine = var0
var0.__name = "BattleGateSubRoutine"

function var0.Entrance(arg0, arg1)
	if not arg1.LegalFleet(arg0.mainFleetId) then
		return
	end

	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = getProxy(PlayerProxy)
	local var1 = getProxy(BayProxy)
	local var2 = getProxy(FleetProxy)
	local var3 = pg.battle_cost_template[SYSTEM_SUB_ROUTINE]
	local var4 = var3.oil_cost > 0
	local var5 = {}
	local var6 = 0
	local var7 = 0
	local var8 = 0
	local var9 = 0
	local var10 = var2:getFleetById(arg0.mainFleetId)
	local var11 = var1:getShipByTeam(var10, TeamType.Submarine)

	for iter0, iter1 in ipairs(var11) do
		var5[#var5 + 1] = iter1.id
	end

	local var12 = var10:getStartCost().oil
	local var13 = var10:GetCostSum().oil
	local var14 = var0:getData()

	if var4 and var13 > var14.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var15 = arg0.mainFleetId
	local var16 = arg0.stageId
	local var17 = pg.expedition_data_template[var16].dungeon_id
	local var18 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var17).fleet_prefab

	arg1.ShipVertify()

	local function var19(arg0)
		if var4 then
			var14:consume({
				gold = 0,
				oil = var12
			})
		end

		if var3.enter_energy_cost > 0 and not exFlag then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var11) do
				iter1:cosumeEnergy(var0)
				var1:updateShip(iter1)
			end
		end

		var0:updatePlayer(var14)

		local var1 = {
			mainFleetId = var15,
			prefabFleet = var18,
			stageId = var16,
			system = SYSTEM_SUB_ROUTINE,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var20(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_SUB_ROUTINE, var5, {
		var16
	}, var19, var20)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_SUB_ROUTINE]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = {}
	local var6 = var1:getFleetById(arg0.mainFleetId)
	local var7 = var2:getSortShipsByFleet(var6)
	local var8 = var6:getEndCost().oil
	local var9 = arg1.GeneralPackage(arg0, var7)

	local function var10(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C

		arg1.GeneralPlayerCosume(SYSTEM_SUB_ROUTINE, var2, var8, arg0.player_exp, exFlag)

		local var3 = getProxy(DailyLevelProxy)

		if var2 then
			var3.data[var3.dailyLevelId] = (var3.data[var3.dailyLevelId] or 0) + 1
		end

		if var3 == ys.Battle.BattleConst.BattleScore.S then
			var3:AddQuickStage(arg0.stageId)
		end

		local var4 = {
			system = SYSTEM_SUB_ROUTINE,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = {},
			result = arg0.result,
			extraDrops = var1
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var4)
	end

	arg1:SendRequest(var9, var10)
end

return var0
