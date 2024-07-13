local var0_0 = class("BattleGateScenario")

ys.Battle.BattleGateScenario = var0_0
var0_0.__name = "BattleGateScenario"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.DOCK_OVERLOADED)

		return
	end

	local var0_1 = getProxy(PlayerProxy)
	local var1_1 = getProxy(BayProxy)
	local var2_1 = pg.battle_cost_template[SYSTEM_SCENARIO]
	local var3_1 = var2_1.oil_cost > 0
	local var4_1 = {}
	local var5_1 = 0
	local var6_1 = 0
	local var7_1 = 0
	local var8_1 = 0
	local var9_1 = getProxy(ChapterProxy):getActiveChapter()
	local var10_1 = var9_1.fleet
	local var11_1 = var10_1:getShips(false)

	for iter0_1, iter1_1 in ipairs(var11_1) do
		var4_1[#var4_1 + 1] = iter1_1.id
	end

	local var12_1, var13_1 = var9_1:getFleetCost(var10_1, arg0_1.stageId)
	local var14_1 = var12_1.gold
	local var15_1 = var12_1.oil
	local var16_1 = var12_1.gold + var13_1.gold
	local var17_1 = var12_1.oil + var13_1.oil
	local var18_1 = var0_1:getData()

	if var3_1 and var17_1 > var18_1.oil then
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.OIL_LACK)

		if not ItemTipPanel.ShowOilBuyTip(var17_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))
		end

		return
	end

	local var19_1 = arg0_1.stageId
	local var20_1 = pg.expedition_data_template[var19_1].dungeon_id
	local var21_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var20_1).fleet_prefab

	arg1_1.ShipVertify()

	local var22_1

	if var9_1:getPlayType() == ChapterConst.TypeExtra then
		var22_1 = true
	end

	local var23_1 = var9_1:GetExtraCostRate()

	local function var24_1(arg0_2)
		if var3_1 then
			var18_1:consume({
				gold = 0,
				oil = var15_1
			})
		end

		if var2_1.enter_energy_cost > 0 and not var22_1 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value * var23_1

			for iter0_2, iter1_2 in ipairs(var4_1) do
				local var1_2 = var1_1:getShipById(iter1_2)

				if var1_2 then
					var1_2:cosumeEnergy(var0_2)
					var1_1:updateShip(var1_2)
				end
			end
		end

		var0_1:updatePlayer(var18_1)

		local var2_2 = {
			prefabFleet = var21_1,
			stageId = var19_1,
			system = SYSTEM_SCENARIO,
			token = arg0_2.key,
			exitCallback = arg0_2.exitCallback
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var2_2)
	end

	local function var25_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.UNKNOWN)
	end

	BeginStageCommand.SendRequest(SYSTEM_SCENARIO, var4_1, {
		var19_1
	}, var24_1, var25_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	if arg1_4.CheaterVertify() then
		return
	end

	local var0_4 = pg.battle_cost_template[SYSTEM_SCENARIO]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(ChapterProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = 0
	local var6_4 = {}
	local var7_4 = var2_4:getActiveChapter()
	local var8_4 = var7_4.fleet
	local var9_4 = var8_4:getShips(true)

	for iter0_4, iter1_4 in ipairs(var9_4) do
		table.insert(var6_4, iter1_4)
	end

	local var10_4 = arg0_4.stageId
	local var11_4, var12_4 = var7_4:getFleetCost(var8_4, var10_4)
	local var13_4 = var12_4.gold
	local var14_4 = var12_4.oil
	local var15_4 = var7_4:GetExtraCostRate()

	if arg0_4.statistics.submarineAid then
		local var16_4 = var7_4:GetSubmarineFleet()

		if var16_4 then
			local var17_4 = 0

			for iter2_4, iter3_4 in ipairs(var16_4:getShipsByTeam(TeamType.Submarine, true)) do
				if arg0_4.statistics[iter3_4.id] then
					table.insert(var6_4, iter3_4)

					var17_4 = var17_4 + iter3_4:getEndBattleExpend()
				end
			end

			var14_4 = var14_4 + math.min(var17_4, var7_4:GetLimitOilCost(true)) * var15_4
		else
			originalPrint("finish stage error: can not find submarine fleet.")
		end
	end

	local var18_4 = var3_4 > ys.Battle.BattleConst.BattleScore.C

	var7_4:writeBack(var18_4, arg0_4)
	var2_4:updateChapter(var7_4)

	local var19_4 = arg1_4.GeneralPackage(arg0_4, var6_4)

	local function var20_4(arg0_5)
		local var0_5 = var7_4:getPlayType() == ChapterConst.TypeExtra

		arg1_4.addShipsExp(arg0_5.ship_exp_list, arg0_4.statistics, true)

		local var1_5 = arg1_4.GenerateCommanderExp(arg0_5, var2_4:getActiveChapter().fleet, var7_4:GetSubmarineFleet())

		arg0_4.statistics.mvpShipID = arg0_5.mvp

		local var2_5, var3_5 = arg1_4:GeneralLoot(arg0_5)

		arg1_4.GeneralPlayerCosume(SYSTEM_SCENARIO, var18_4, var14_4, arg0_5.player_exp, var0_5)

		local var4_5 = {
			system = SYSTEM_SCENARIO,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var2_5,
			commanderExps = var1_5,
			result = arg0_5.result,
			extraDrops = var3_5,
			exitCallback = arg0_4.exitCallback
		}

		var2_4:updateActiveChapterShips()

		local var5_5 = var2_4:getActiveChapter()

		var5_5:writeDrops(var2_5)
		var2_4:updateChapter(var5_5)

		if PlayerConst.CanDropItem(var2_5) then
			local var6_5 = {}

			for iter0_5, iter1_5 in ipairs(var2_5) do
				table.insert(var6_5, iter1_5)
			end

			for iter2_5, iter3_5 in ipairs(var3_5) do
				iter3_5.riraty = true

				table.insert(var6_5, iter3_5)
			end

			local var7_5 = getProxy(ChapterProxy):getActiveChapter(true)

			if var7_5 then
				if var7_5:isLoop() then
					getProxy(ChapterProxy):AddExtendChapterDataArray(var7_5.id, "TotalDrops", var6_5)
				end

				var7_5:writeDrops(var6_5)
			end
		end

		local var8_5 = var2_4:getLastUnlockMap().id
		local var9_5 = var2_4:getLastUnlockMap().id

		if Map.lastMap and var9_5 ~= var8_5 and var8_5 < var9_5 then
			Map.autoNextPage = true
		end

		arg1_4:sendNotification(GAME.CHAPTER_BATTLE_RESULT_REQUEST, {
			callback = function()
				arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_5)
			end
		})
	end

	arg1_4:SendRequest(var19_4, var20_4)
end

return var0_0
