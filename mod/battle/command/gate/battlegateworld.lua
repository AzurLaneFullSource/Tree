local var0 = class("BattleGateWorld")

ys.Battle.BattleGateWorld = var0
var0.__name = "BattleGateWorld"

function var0.Entrance(arg0, arg1)
	local var0 = nowWorld()

	if BeginStageCommand.DockOverload() then
		var0:TriggerAutoFight(false)

		return
	end

	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(BayProxy)
	local var3 = pg.battle_cost_template[SYSTEM_WORLD]
	local var4 = var3.oil_cost > 0
	local var5 = {}
	local var6 = 0
	local var7 = 0
	local var8 = 0
	local var9 = 0
	local var10 = var0:GetActiveMap():GetFleet()
	local var11 = var10:GetShipVOs(false)

	for iter0, iter1 in ipairs(var11) do
		var5[#var5 + 1] = iter1.id
	end

	local var12, var13 = var10:GetCost()
	local var14 = var12.gold
	local var15 = var12.oil
	local var16 = var12.gold + var13.gold
	local var17 = var12.oil + var13.oil
	local var18 = var1:getData()

	if var4 and var17 > var18.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var19 = arg0.stageId
	local var20 = pg.expedition_data_template[var19].dungeon_id
	local var21 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var20).fleet_prefab

	arg1.ShipVertify()

	local function var22(arg0)
		if var4 then
			var18:consume({
				gold = 0,
				oil = var15
			})
		end

		if var3.enter_energy_cost > 0 and not exFlag then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var11) do
				iter1:cosumeEnergy(var0)
				var2:updateShip(iter1)
			end
		end

		var1:updatePlayer(var18)

		local var1 = {
			prefabFleet = var21,
			stageId = var19,
			system = SYSTEM_WORLD,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var23(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_WORLD, var5, {
		var19
	}, var22, var23)
end

function var0.Exit(arg0, arg1)
	if arg1.CheaterVertify() then
		return
	end

	local var0 = pg.battle_cost_template[SYSTEM_WORLD]
	local var1 = arg0.statistics._battleScore
	local var2 = 0
	local var3 = {}
	local var4 = nowWorld():GetActiveMap()
	local var5 = var4:GetFleet()
	local var6 = var5:GetShipVOs(true)
	local var7, var8 = var5:GetCost()
	local var9 = var8.oil

	if arg0.statistics.submarineAid then
		local var10 = var4:GetSubmarineFleet()

		assert(var10, "submarine fleet not exist.")

		local var11 = var10:GetTeamShipVOs(TeamType.Submarine, true)

		for iter0, iter1 in ipairs(var11) do
			if arg0.statistics[iter1.id] then
				table.insert(var6, iter1)
			end
		end

		local var12, var13 = var10:GetCost()

		var9 = var9 + var13.oil
	end

	local var14 = arg1.GeneralPackage(arg0, var6)

	local function var15(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		local var0 = arg1.GenerateCommanderExp(arg0, var5, var4:GetSubmarineFleet())

		arg0.statistics.mvpShipID = arg0.mvp

		local var1, var2 = arg1:GeneralLoot(arg0)
		local var3 = var1 > ys.Battle.BattleConst.BattleScore.C

		arg1.GeneralPlayerCosume(SYSTEM_WORLD, var3, var9, arg0.player_exp, exFlag)

		arg0.hpDropInfo = arg0.hp_drop_info

		local var4 = {
			system = SYSTEM_WORLD,
			statistics = arg0.statistics,
			score = var1,
			drops = var1,
			commanderExps = var0,
			result = arg0.result,
			extraDrops = var2
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var4)
		var4:WriteBack(var3, arg0)
	end

	arg1:SendRequest(var14, var15)
end

return var0
