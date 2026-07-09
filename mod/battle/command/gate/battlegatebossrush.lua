local var0_0 = class("BattleGateBossRush")

ys.Battle.BattleGateBossRush = var0_0
var0_0.__name = "BattleGateBossRush"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(FleetProxy)
	local var3_1 = getProxy(BayProxy)
	local var4_1 = pg.battle_cost_template[SYSTEM_BOSS_RUSH]
	local var5_1 = var4_1.oil_cost > 0
	local var6_1 = getProxy(ActivityProxy):getActivityById(var0_1):GetSeriesData()
	local var7_1 = var6_1:GetStaegLevel() + 1
	local var8_1 = var6_1:GetExpeditionIds()[var7_1]
	local var9_1 = var6_1:GetMode()
	local var10_1, var11_1 = var6_1:GetStageFleets(var9_1, var7_1)
	local var12_1 = var2_1:getActivityFleets()[var0_1]
	local var13_1 = var12_1[var10_1]
	local var14_1 = var12_1[var11_1]
	local var15_1 = {}
	local var16_1 = var3_1:getSortShipsByFleet(var13_1)

	for iter0_1, iter1_1 in ipairs(var16_1) do
		var15_1[#var15_1 + 1] = iter1_1.id
	end

	local var17_1 = var1_1:getRawData()
	local var18_1 = var13_1:GetCostSum().oil

	if var5_1 and var18_1 > var17_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1_1.ShipVertify()

	local var19_1 = var13_1:getStartCost().oil

	local function var20_1(arg0_2)
		if var5_1 then
			var17_1:consume({
				gold = 0,
				oil = var19_1
			})
		end

		if var4_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var16_1) do
				iter1_2:cosumeEnergy(var0_2)
				var3_1:updateShip(iter1_2)
			end
		end

		var1_1:updatePlayer(var17_1)

		local var1_2 = {
			prefabFleet = {},
			stageId = var8_1,
			system = SYSTEM_BOSS_RUSH,
			actId = var0_1,
			token = arg0_2.key,
			continuousBattleTimes = arg0_1.continuousBattleTimes,
			totalBattleTimes = arg0_1.totalBattleTimes,
			curIndex = arg0_1.curIndex,
			maxIndex = arg0_1.maxIndex
		}

		if arg0_1.curIndex then
			arg1_1:sendNotification(GAME.CONTINUE_STAGE_DONE, var1_2)
		else
			arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
		end
	end

	local function var21_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_BOSS_RUSH, var15_1, {
		var8_1
	}, var20_1, var21_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_BOSS_RUSH]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = {}
	local var6_4 = {}
	local var7_4 = false

	;(function()
		local var0_5 = arg0_4.actId
		local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5):GetSeriesData()

		if not var1_5 then
			var7_4 = true

			return
		end

		local var2_5 = var1_5:GetStaegLevel() + 1
		local var3_5 = var1_5:GetMode()
		local var4_5, var5_5 = var1_5:GetStageFleets(var3_5, var2_5)
		local var6_5 = var1_4:getActivityFleets()[var0_5]
		local var7_5 = var6_5[var4_5]
		local var8_5 = var6_5[var5_5]

		local function var9_5(arg0_6)
			table.insertto(var6_4, _.values(arg0_6.commanderIds))
			table.insertto(var5_4, var2_4:getSortShipsByFleet(arg0_6))
		end

		var9_5(var7_5)

		if arg0_4.statistics.submarineAid then
			var9_5(var8_5)
		end
	end)()

	if var7_4 then
		arg1_4:sendNotification(GAME.FINISH_STAGE_ERROR)

		return
	end

	local var8_4 = arg1_4.GeneralPackage(arg0_4, var5_4)

	var8_4.commander_id_list = var6_4

	local function var9_4(arg0_7)
		arg0_4.statistics.mvpShipID = arg0_7.mvp

		local var0_7 = {
			system = SYSTEM_BOSS_RUSH,
			statistics = arg0_4.statistics,
			score = var3_4,
			result = arg0_7.result
		}
		local var1_7 = arg0_4.actId
		local var2_7 = getProxy(ActivityProxy):getActivityById(var1_7)

		var2_7:GetSeriesData():PassStage(var0_7)
		getProxy(ActivityProxy):updateActivity(var2_7)
		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var0_7)
	end

	arg1_4:SendRequest(var8_4, var9_4)
end

function var0_0.GetPreloadList(arg0_8)
	local var0_8 = {}
	local var1_8 = {}
	local var2_8
	local var3_8 = ys.Battle.BattleResourceManager.GetInstance()
	local var4_8 = getProxy(FleetProxy)
	local var5_8 = getProxy(BayProxy)
	local var6_8 = getProxy(ActivityProxy):getActivityById(arg0_8.actId):GetSeriesData()
	local var7_8 = var6_8:GetStaegLevel() + 1
	local var8_8 = var6_8:GetFleetIds()
	local var9_8 = var6_8:GetMode()
	local var10_8, var11_8 = var6_8:GetStageFleets(var9_8, var7_8)
	local var12_8 = var4_8:getActivityFleets()[arg0_8.actId]
	local var13_8 = var12_8[var10_8]
	local var14_8 = var12_8[var11_8]

	if var13_8 then
		local var15_8 = var13_8:GetRawShipIds()

		for iter0_8, iter1_8 in ipairs(var15_8) do
			table.insert(var0_8, var5_8:getShipById(iter1_8))
		end

		var1_8 = var13_8:buildBattleBuffList()
	end

	if var14_8 then
		local var16_8 = var14_8:GetRawShipIds()

		for iter2_8, iter3_8 in ipairs(var16_8) do
			table.insert(var0_8, var5_8:getShipById(iter3_8))
		end

		for iter4_8, iter5_8 in ipairs(var14_8:buildBattleBuffList()) do
			table.insert(var1_8, iter5_8)
		end
	end

	local var17_8, var18_8 = var3_8.GetPlayerShipResource(var0_8, arg0_8.system)
	local var19_8 = var3_8.GetCommanderBuffRes(var1_8)

	for iter6_8, iter7_8 in ipairs(var19_8) do
		table.insert(var17_8, iter7_8)
	end

	return var17_8, var18_8
end

return var0_0
