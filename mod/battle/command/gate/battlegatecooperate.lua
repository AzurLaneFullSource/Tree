local var0 = class("BattleGateCooperate")

ys.Battle.BattleGateCooperate = var0
var0.__name = "BattleGateCooperate"

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg0.actId
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(BayProxy)
	local var3 = getProxy(FleetProxy)
	local var4 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var5 = var4.oil_cost > 0
	local var6 = {}
	local var7 = 0
	local var8 = 0
	local var9 = 0
	local var10 = 0
	local var11 = var3:getActivityFleets()[var0][Fleet.REGULAR_FLEET_ID]

	for iter0, iter1 in ipairs(var11.ships) do
		var6[#var6 + 1] = iter1
	end

	local var12 = var11:getStartCost().oil
	local var13 = var11:GetCostSum().oil
	local var14 = var2:getSortShipsByFleet(var11)
	local var15 = var1:getData()

	if var5 and var13 > var15.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var16 = arg0.stageId
	local var17 = pg.expedition_data_template[var16].dungeon_id
	local var18 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var17).fleet_prefab

	arg1.ShipVertify()

	local var19

	if chapter:getPlayType() == ChapterConst.TypeExtra then
		var19 = true
	end

	local function var20(arg0)
		if var5 then
			var15:consume({
				gold = 0,
				oil = var12
			})
		end

		if var4.enter_energy_cost > 0 and not var19 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var14) do
				iter1:cosumeEnergy(var0)
				var2:updateShip(iter1)
			end
		end

		var1:updatePlayer(var15)

		local var1 = Fleet.REGULAR_FLEET_ID
		local var2 = {
			mainFleetId = var1,
			prefabFleet = var18,
			stageId = var16,
			actId = var0,
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var2)
	end

	local function var21(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_HP_SHARE_ACT_BOSS, var6, {
		var16
	}, var20, var21)
end

function var0.Exit(arg0, arg1)
	if client.CheaterVertify() then
		return
	end

	local var0 = pg.battle_cost_template[SYSTEM_HP_SHARE_ACT_BOSS]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(ChapterProxy)
	local var3 = ys.Battle.BattleConst.BattleScore.S
	local var4 = 0
	local var5 = 0
	local var6
	local var7 = var1:getActivityFleets()[arg0.actId][arg0.mainFleetId]
	local var8 = bayProxy:getSortShipsByFleet(var7)
	local var9 = var7:getEndCost().oil

	if arg0.statistics.submarineAid then
		local var10 = var1:getActivityFleets()[arg0.actId][Fleet.SUBMARINE_FLEET_ID]

		if var10 then
			local var11 = bayProxy:getSortShipsByFleet(var10)

			for iter0, iter1 in ipairs(var11) do
				if arg0.statistics[iter1.id] then
					table.insert(var8, iter1)

					var9 = var9 + iter1:getEndBattleExpend()
				end
			end
		else
			originalPrint("finish stage error: can not find submarine fleet.")
		end
	end

	local var12 = client.GeneralPackage(arg0, var8)
	local var13 = {}

	for iter2, iter3 in ipairs(arg0.statistics._enemyInfoList) do
		table.insert(var13, {
			enemy_id = iter3.id,
			damage_taken = iter3.damage,
			total_hp = iter3.totalHp
		})
	end

	var12.enemy_info = var13

	local function var14(arg0)
		client.addShipsExp(arg0.ship_exp_list, arg0.statistics)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = client:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C

		var0.GeneralPlayerCosume(SYSTEM_HP_SHARE_ACT_BOSS, var2, var9, arg0.player_exp)

		local var3 = {
			system = SYSTEM_HP_SHARE_ACT_BOSS,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = {},
			result = arg0.result,
			extraDrops = var1
		}

		client:sendNotification(GAME.FINISH_STAGE_DONE, var3)
	end

	client:SendRequest(var12, var14)
end

return var0
