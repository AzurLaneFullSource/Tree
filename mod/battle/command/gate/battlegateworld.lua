local var0_0 = class("BattleGateWorld")

ys.Battle.BattleGateWorld = var0_0
var0_0.__name = "BattleGateWorld"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = nowWorld()

	if BeginStageCommand.DockOverload() then
		var0_1:TriggerAutoFight(false)

		return
	end

	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(BayProxy)
	local var3_1 = pg.battle_cost_template[SYSTEM_WORLD]
	local var4_1 = var3_1.oil_cost > 0
	local var5_1 = {}
	local var6_1 = 0
	local var7_1 = 0
	local var8_1 = 0
	local var9_1 = 0
	local var10_1 = var0_1:GetActiveMap():GetFleet()
	local var11_1 = var10_1:GetShipVOs(false)

	for iter0_1, iter1_1 in ipairs(var11_1) do
		var5_1[#var5_1 + 1] = iter1_1.id
	end

	local var12_1, var13_1 = var10_1:GetCost()
	local var14_1 = var12_1.gold
	local var15_1 = var12_1.oil
	local var16_1 = var12_1.gold + var13_1.gold
	local var17_1 = var12_1.oil + var13_1.oil
	local var18_1 = var1_1:getData()

	if var4_1 and var17_1 > var18_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var19_1 = arg0_1.stageId
	local var20_1 = pg.expedition_data_template[var19_1].dungeon_id
	local var21_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var20_1).fleet_prefab
	local var22_1 = arg0_1.hpRate

	arg1_1.ShipVertify()

	local function var23_1(arg0_2)
		if var4_1 then
			var18_1:consume({
				gold = 0,
				oil = var15_1
			})
		end

		if var3_1.enter_energy_cost > 0 and not exFlag then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var11_1) do
				iter1_2:cosumeEnergy(var0_2)
				var2_1:updateShip(iter1_2)
			end
		end

		var1_1:updatePlayer(var18_1)

		local var1_2 = {
			prefabFleet = var21_1,
			stageId = var19_1,
			system = SYSTEM_WORLD,
			token = arg0_2.key,
			hpRate = var22_1
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var24_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_WORLD, var5_1, {
		var19_1
	}, var23_1, var24_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	if arg1_4.CheaterVertify() then
		return
	end

	local var0_4 = pg.battle_cost_template[SYSTEM_WORLD]
	local var1_4 = arg0_4.statistics._battleScore
	local var2_4 = 0
	local var3_4 = {}
	local var4_4 = nowWorld():GetActiveMap()
	local var5_4 = var4_4:GetFleet()
	local var6_4 = var5_4:GetShipVOs(true)
	local var7_4, var8_4 = var5_4:GetCost()
	local var9_4 = var8_4.oil

	if arg0_4.statistics.submarineAid then
		local var10_4 = var4_4:GetSubmarineFleet()

		assert(var10_4, "submarine fleet not exist.")

		local var11_4 = var10_4:GetTeamShipVOs(TeamType.Submarine, true)

		for iter0_4, iter1_4 in ipairs(var11_4) do
			if arg0_4.statistics[iter1_4.id] then
				table.insert(var6_4, iter1_4)
			end
		end

		local var12_4, var13_4 = var10_4:GetCost()

		var9_4 = var9_4 + var13_4.oil
	end

	local var14_4 = arg1_4.GeneralPackage(arg0_4, var6_4)

	local function var15_4(arg0_5)
		arg1_4.addShipsExp(arg0_5.ship_exp_list, arg0_4.statistics, true)

		local var0_5 = arg1_4.GenerateCommanderExp(arg0_5, var5_4, var4_4:GetSubmarineFleet())

		arg0_4.statistics.mvpShipID = arg0_5.mvp

		local var1_5, var2_5 = arg1_4:GeneralLoot(arg0_5)
		local var3_5 = var1_4 > ys.Battle.BattleConst.BattleScore.C

		arg1_4.GeneralPlayerCosume(SYSTEM_WORLD, var3_5, var9_4, arg0_5.player_exp, exFlag)

		arg0_4.hpDropInfo = arg0_5.hp_drop_info

		local var4_5 = {
			system = SYSTEM_WORLD,
			statistics = arg0_4.statistics,
			score = var1_4,
			drops = var1_5,
			commanderExps = var0_5,
			result = arg0_5.result,
			extraDrops = var2_5
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_5)
		var4_4:WriteBack(var3_5, arg0_4)
	end

	arg1_4:SendRequest(var14_4, var15_4)
end

function var0_0.GetPreloadList(arg0_6)
	local var0_6 = {}
	local var1_6
	local var2_6 = ys.Battle.BattleResourceManager.GetInstance()
	local var3_6 = nowWorld()
	local var4_6 = var3_6:GetActiveMap()
	local var5_6 = var4_6:GetFleet()

	for iter0_6, iter1_6 in ipairs(var5_6:GetShipVOs(true)) do
		table.insert(var0_6, iter1_6)
	end

	local var6_6, var7_6 = var4_6:getFleetBattleBuffs(var5_6)

	if var3_6:GetSubAidFlag() == true then
		local var8_6 = var4_6:GetSubmarineFleet()
		local var9_6 = var8_6:GetTeamShipVOs(TeamType.Submarine, false)

		for iter2_6, iter3_6 in ipairs(var9_6) do
			table.insert(var0_6, iter3_6)
		end

		local var10_6, var11_6 = var4_6:getFleetBattleBuffs(var8_6)

		for iter4_6, iter5_6 in ipairs(var10_6) do
			table.insert(var6_6, iter5_6)
		end

		for iter6_6, iter7_6 in ipairs(var11_6) do
			table.insert(var7_6, iter7_6)
		end
	end

	local var12_6, var13_6 = var2_6.GetPlayerShipResource(var0_6, arg0_6.system)
	local var14_6 = var4_6:GetChapterAuraBuffs()
	local var15_6 = var4_6:GetChapterAidBuffs()

	for iter8_6, iter9_6 in pairs(var15_6) do
		for iter10_6, iter11_6 in ipairs(iter9_6) do
			table.insert(var14_6, iter11_6)
		end
	end

	local var16_6 = var2_6.GetResFromBuffList(var14_6)

	for iter12_6, iter13_6 in ipairs(var16_6) do
		table.insert(var12_6, iter13_6)
	end

	local var17_6 = var4_6:GetCell(var5_6.row, var5_6.column):GetStageEnemy()
	local var18_6 = table.mergeArray(var17_6:GetBattleLuaBuffs(), var4_6:GetBattleLuaBuffs(WorldMap.FactionEnemy, var17_6))

	for iter14_6, iter15_6 in ipairs(var18_6) do
		table.insert(var6_6, iter15_6)
	end

	local var19_6 = var2_6.GetResFromBuffIDList(var6_6)

	for iter16_6, iter17_6 in ipairs(var19_6) do
		table.insert(var12_6, iter17_6)
	end

	local var20_6 = var2_6.GetCommanderBuffRes(var7_6)

	for iter18_6, iter19_6 in ipairs(var20_6) do
		table.insert(var12_6, iter19_6)
	end

	return var12_6, var13_6
end

return var0_0
