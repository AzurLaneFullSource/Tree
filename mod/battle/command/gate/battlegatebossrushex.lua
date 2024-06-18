local var0_0 = class("BattleGateBossRushEX")

ys.Battle.BattleGateBossRushEX = var0_0
var0_0.__name = "BattleGateBossRushEX"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(FleetProxy)
	local var3_1 = getProxy(BayProxy)
	local var4_1 = pg.battle_cost_template[SYSTEM_BOSS_RUSH_EX]
	local var5_1 = var4_1.oil_cost > 0
	local var6_1 = 0
	local var7_1 = 0
	local var8_1 = 0
	local var9_1 = 0
	local var10_1 = getProxy(ActivityProxy):getActivityById(var0_1):GetSeriesData()
	local var11_1 = var10_1:GetStaegLevel() + 1
	local var12_1 = var10_1:GetExpeditionIds()[var11_1]
	local var13_1 = var10_1:GetFleetIds()
	local var14_1 = var13_1[var11_1]
	local var15_1 = var13_1[#var13_1]

	if var10_1:GetMode() == BossRushSeriesData.MODE.SINGLE then
		var14_1 = var13_1[1]
	end

	local var16_1 = var2_1:getActivityFleets()[var0_1]
	local var17_1 = var16_1[var14_1]
	local var18_1 = var16_1[var15_1]
	local var19_1 = {}
	local var20_1 = var3_1:getSortShipsByFleet(var17_1)

	for iter0_1, iter1_1 in ipairs(var20_1) do
		var19_1[#var19_1 + 1] = iter1_1.id
	end

	local var21_1 = var1_1:getRawData()

	if var5_1 and var9_1 > var21_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1_1.ShipVertify()

	local function var22_1(arg0_2)
		if var5_1 then
			var21_1:consume({
				gold = 0,
				oil = var7_1
			})
		end

		if var4_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var20_1) do
				iter1_2:cosumeEnergy(var0_2)
				var3_1:updateShip(iter1_2)
			end
		end

		var1_1:updatePlayer(var21_1)

		local var1_2 = {
			prefabFleet = {},
			stageId = var12_1,
			system = SYSTEM_BOSS_RUSH_EX,
			actId = var0_1,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var23_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_BOSS_RUSH_EX, var19_1, {
		var12_1
	}, var22_1, var23_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_BOSS_RUSH_EX]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = var3_4 > ys.Battle.BattleConst.BattleScore.C
	local var5_4 = 0
	local var6_4 = {}
	local var7_4 = {}

	;(function()
		local var0_5 = arg0_4.actId
		local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5):GetSeriesData()
		local var2_5 = var1_5:GetStaegLevel() + 1
		local var3_5 = var1_5:GetFleetIds()
		local var4_5 = var3_5[var2_5]
		local var5_5 = var3_5[#var3_5]

		if var1_5:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var4_5 = var3_5[1]
		end

		local var6_5 = var1_4:getActivityFleets()[var0_5]
		local var7_5 = var6_5[var4_5]
		local var8_5 = var6_5[var5_5]

		local function var9_5(arg0_6)
			table.insertto(var7_4, _.values(arg0_6.commanderIds))
			table.insertto(var6_4, var2_4:getSortShipsByFleet(arg0_6))
		end

		var9_5(var7_5)

		if arg0_4.statistics.submarineAid then
			var9_5(var8_5)
		end
	end)()

	local var8_4 = arg1_4.GeneralPackage(arg0_4, var6_4)

	var8_4.commander_id_list = var7_4

	local function var9_4(arg0_7)
		arg0_4.statistics.mvpShipID = arg0_7.mvp

		local var0_7 = {
			system = SYSTEM_BOSS_RUSH_EX,
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

	seriesAsync({
		function(arg0_8)
			if var4_4 then
				arg1_4:SendRequest(var8_4, function(arg0_9)
					arg0_8(arg0_9)
				end)

				return
			end

			arg0_8({})
		end,
		function(arg0_10, arg1_10)
			var9_4(arg1_10)
		end
	})
end

return var0_0
