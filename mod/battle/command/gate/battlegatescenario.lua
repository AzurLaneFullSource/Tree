local var0 = class("BattleGateScenario")

ys.Battle.BattleGateScenario = var0
var0.__name = "BattleGateScenario"

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.DOCK_OVERLOADED)

		return
	end

	local var0 = getProxy(PlayerProxy)
	local var1 = getProxy(BayProxy)
	local var2 = pg.battle_cost_template[SYSTEM_SCENARIO]
	local var3 = var2.oil_cost > 0
	local var4 = {}
	local var5 = 0
	local var6 = 0
	local var7 = 0
	local var8 = 0
	local var9 = getProxy(ChapterProxy):getActiveChapter()
	local var10 = var9.fleet
	local var11 = var10:getShips(false)

	for iter0, iter1 in ipairs(var11) do
		var4[#var4 + 1] = iter1.id
	end

	local var12, var13 = var9:getFleetCost(var10, arg0.stageId)
	local var14 = var12.gold
	local var15 = var12.oil
	local var16 = var12.gold + var13.gold
	local var17 = var12.oil + var13.oil
	local var18 = var0:getData()

	if var3 and var17 > var18.oil then
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.OIL_LACK)

		if not ItemTipPanel.ShowOilBuyTip(var17) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))
		end

		return
	end

	local var19 = arg0.stageId
	local var20 = pg.expedition_data_template[var19].dungeon_id
	local var21 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var20).fleet_prefab

	arg1.ShipVertify()

	local var22

	if var9:getPlayType() == ChapterConst.TypeExtra then
		var22 = true
	end

	local var23 = var9:GetExtraCostRate()

	local function var24(arg0)
		if var3 then
			var18:consume({
				gold = 0,
				oil = var15
			})
		end

		if var2.enter_energy_cost > 0 and not var22 then
			local var0 = pg.gameset.battle_consume_energy.key_value * var23

			for iter0, iter1 in ipairs(var4) do
				local var1 = var1:getShipById(iter1)

				if var1 then
					var1:cosumeEnergy(var0)
					var1:updateShip(var1)
				end
			end
		end

		var0:updatePlayer(var18)

		local var2 = {
			prefabFleet = var21,
			stageId = var19,
			system = SYSTEM_SCENARIO,
			token = arg0.key,
			exitCallback = arg0.exitCallback
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var2)
	end

	local function var25(arg0)
		arg1:RequestFailStandardProcess(arg0)
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.UNKNOWN)
	end

	BeginStageCommand.SendRequest(SYSTEM_SCENARIO, var4, {
		var19
	}, var24, var25)
end

function var0.Exit(arg0, arg1)
	if arg1.CheaterVertify() then
		return
	end

	local var0 = pg.battle_cost_template[SYSTEM_SCENARIO]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(ChapterProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = 0
	local var6 = {}
	local var7 = var2:getActiveChapter()
	local var8 = var7.fleet
	local var9 = var8:getShips(true)

	for iter0, iter1 in ipairs(var9) do
		table.insert(var6, iter1)
	end

	local var10 = arg0.stageId
	local var11, var12 = var7:getFleetCost(var8, var10)
	local var13 = var12.gold
	local var14 = var12.oil
	local var15 = var7:GetExtraCostRate()

	if arg0.statistics.submarineAid then
		local var16 = var7:GetSubmarineFleet()

		if var16 then
			local var17 = 0

			for iter2, iter3 in ipairs(var16:getShipsByTeam(TeamType.Submarine, true)) do
				if arg0.statistics[iter3.id] then
					table.insert(var6, iter3)

					var17 = var17 + iter3:getEndBattleExpend()
				end
			end

			var14 = var14 + math.min(var17, var7:GetLimitOilCost(true)) * var15
		else
			originalPrint("finish stage error: can not find submarine fleet.")
		end
	end

	local var18 = var3 > ys.Battle.BattleConst.BattleScore.C

	var7:writeBack(var18, arg0)
	var2:updateChapter(var7)

	local var19 = arg1.GeneralPackage(arg0, var6)

	local function var20(arg0)
		local var0 = var7:getPlayType() == ChapterConst.TypeExtra

		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, true)

		local var1 = arg1.GenerateCommanderExp(arg0, var2:getActiveChapter().fleet, var7:GetSubmarineFleet())

		arg0.statistics.mvpShipID = arg0.mvp

		local var2, var3 = arg1:GeneralLoot(arg0)

		arg1.GeneralPlayerCosume(SYSTEM_SCENARIO, var18, var14, arg0.player_exp, var0)

		local var4 = {
			system = SYSTEM_SCENARIO,
			statistics = arg0.statistics,
			score = var3,
			drops = var2,
			commanderExps = var1,
			result = arg0.result,
			extraDrops = var3,
			exitCallback = arg0.exitCallback
		}

		var2:updateActiveChapterShips()

		local var5 = var2:getActiveChapter()

		var5:writeDrops(var2)
		var2:updateChapter(var5)

		if PlayerConst.CanDropItem(var2) then
			local var6 = {}

			for iter0, iter1 in ipairs(var2) do
				table.insert(var6, iter1)
			end

			for iter2, iter3 in ipairs(var3) do
				iter3.riraty = true

				table.insert(var6, iter3)
			end

			local var7 = getProxy(ChapterProxy):getActiveChapter(true)

			if var7 then
				if var7:isLoop() then
					getProxy(ChapterProxy):AddExtendChapterDataArray(var7.id, "TotalDrops", var6)
				end

				var7:writeDrops(var6)
			end
		end

		local var8 = var2:getLastUnlockMap().id
		local var9 = var2:getLastUnlockMap().id

		if Map.lastMap and var9 ~= var8 and var8 < var9 then
			Map.autoNextPage = true
		end

		arg1:sendNotification(GAME.CHAPTER_BATTLE_RESULT_REQUEST, {
			callback = function()
				arg1:sendNotification(GAME.FINISH_STAGE_DONE, var4)
			end
		})
	end

	arg1:SendRequest(var19, var20)
end

return var0
