local var0_0 = class("BattleGateLimitChallenge")

ys.Battle.BattleGateLimitChallenge = var0_0
var0_0.__name = "BattleGateLimitChallenge"
var0_0.BattleSystem = SYSTEM_LIMIT_CHALLENGE

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = FleetProxy.CHALLENGE_FLEET_ID

	if not arg1_1.LegalFleet(var0_1) then
		return
	end

	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = var1_1:getData()
	local var3_1 = getProxy(FleetProxy)
	local var4_1 = getProxy(BayProxy)
	local var5_1 = getProxy(LimitChallengeProxy)
	local var6_1 = arg0_1.stageId
	local var7_1 = pg.expedition_data_template[var6_1].dungeon_id
	local var8_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var7_1).fleet_prefab
	local var9_1 = var3_1:getFleetById(FleetProxy.CHALLENGE_FLEET_ID)
	local var10_1 = {}
	local var11_1 = var4_1:getSortShipsByFleet(var9_1)

	for iter0_1, iter1_1 in ipairs(var11_1) do
		var10_1[#var10_1 + 1] = iter1_1.id
	end

	local var12_1 = pg.battle_cost_template[var0_0.BattleSystem]
	local var13_1 = var12_1.oil_cost > 0
	local var14_1 = 0
	local var15_1 = 0

	if var13_1 then
		var14_1 = var9_1:getStartCost().oil
		var15_1 = var9_1:GetCostSum().oil
	end

	if var13_1 and var15_1 > var2_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1_1.ShipVertify()

	local function var16_1(arg0_2)
		if var13_1 then
			var2_1:consume({
				gold = 0,
				oil = var14_1
			})
		end

		if var12_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var11_1) do
				iter1_2:cosumeEnergy(var0_2)
				var4_1:updateShip(iter1_2)
			end
		end

		var1_1:updatePlayer(var2_1)

		local var1_2 = {
			mainFleetId = mainFleetID,
			prefabFleet = var8_1,
			stageId = var6_1,
			system = var0_0.BattleSystem,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var17_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(var0_0.BattleSystem, var10_1, {
		var6_1
	}, var16_1, var17_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[var0_0.BattleSystem]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = {}
	local var6_4 = {}
	local var7_4 = arg0_4.stageId
	local var8_4 = var1_4:getFleetById(FleetProxy.CHALLENGE_FLEET_ID)
	local var9_4

	if arg0_4.statistics.submarineAid then
		var9_4 = var1_4:getFleetById(FleetProxy.CHALLENGE_SUB_FLEET_ID)
	end

	;(function()
		local function var0_5(arg0_6)
			local var0_6 = arg0_6:getEndCost().oil

			var4_4 = var4_4 + var0_6

			table.insertto(var6_4, _.values(arg0_6.commanderIds))
			table.insertto(var5_4, var2_4:getSortShipsByFleet(arg0_6))
		end

		var0_5(var8_4)

		if arg0_4.statistics.submarineAid then
			var0_5(var9_4)
		end
	end)()

	local var10_4 = arg1_4.GeneralPackage(arg0_4, var5_4)

	var10_4.commander_id_list = var6_4

	local function var11_4(arg0_7)
		arg1_4.addShipsExp(arg0_7.ship_exp_list, arg0_4.statistics, true)

		arg0_4.statistics.mvpShipID = arg0_7.mvp

		local var0_7, var1_7 = arg1_4:GeneralLoot(arg0_7)
		local var2_7 = var3_4 > ys.Battle.BattleConst.BattleScore.C
		local var3_7 = arg1_4.GenerateCommanderExp(arg0_7, var8_4, var9_4)

		arg1_4.GeneralPlayerCosume(var0_0.BattleSystem, var2_7, var4_4, arg0_7.player_exp)

		local var4_7 = {
			system = var0_0.BattleSystem,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_7,
			commanderExps = var3_7,
			result = arg0_7.result,
			extraDrops = var1_7
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_7)

		if var2_7 then
			local var5_7 = LimitChallengeConst.GetChallengeIDByStageID(var7_4)
			local var6_7 = arg0_4.statistics._totalTime

			getProxy(LimitChallengeProxy):setPassTime(var5_7, var6_7)
		end
	end

	arg1_4:SendRequest(var10_4, var11_4)
end

function var0_0.GetPreloadList(arg0_8)
	local var0_8 = {}
	local var1_8 = {}
	local var2_8
	local var3_8 = ys.Battle.BattleResourceManager.GetInstance()
	local var4_8 = FleetProxy.CHALLENGE_FLEET_ID
	local var5_8 = FleetProxy.CHALLENGE_SUB_FLEET_ID
	local var6_8 = getProxy(FleetProxy)
	local var7_8 = var6_8:getFleetById(var4_8)
	local var8_8 = var6_8:getFleetById(var5_8)
	local var9_8 = getProxy(BayProxy)

	if var7_8 then
		local var10_8 = var7_8:GetRawShipIds()

		for iter0_8, iter1_8 in ipairs(var10_8) do
			table.insert(var0_8, var9_8:getShipById(iter1_8))
		end

		var1_8 = var7_8:buildBattleBuffList()
	end

	if var8_8 then
		local var11_8 = var8_8:GetRawShipIds()

		for iter2_8, iter3_8 in ipairs(var11_8) do
			table.insert(var0_8, var9_8:getShipById(iter3_8))
		end

		for iter4_8, iter5_8 in ipairs(var8_8:buildBattleBuffList()) do
			table.insert(var1_8, iter5_8)
		end
	end

	local var12_8, var13_8 = var3_8.GetPlayerShipResource(var0_8, arg0_8.system)
	local var14_8 = var3_8.GetCommanderBuffRes(var1_8)

	for iter6_8, iter7_8 in ipairs(var14_8) do
		table.insert(var12_8, iter7_8)
	end

	local var15_8 = LimitChallengeConst.GetChallengeIDByStageID(arg0_8.stageId)
	local var16_8 = AcessWithinNull(pg.expedition_constellation_challenge_template[var15_8], "buff_id")

	if var16_8 then
		for iter8_8, iter9_8 in ipairs(var16_8) do
			local var17_8 = ys.Battle.BattleDataFunction.GetResFromBuff(iter9_8.ID, iter9_8.LV, {})

			for iter10_8, iter11_8 in ipairs(var17_8) do
				table.insert(var12_8, iter11_8)
			end
		end
	end

	return var12_8, var13_8
end

return var0_0
