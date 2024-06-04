local var0 = class("BattleGateBossRushEX")

ys.Battle.BattleGateBossRushEX = var0
var0.__name = "BattleGateBossRushEX"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.actId
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(FleetProxy)
	local var3 = getProxy(BayProxy)
	local var4 = pg.battle_cost_template[SYSTEM_BOSS_RUSH_EX]
	local var5 = var4.oil_cost > 0
	local var6 = 0
	local var7 = 0
	local var8 = 0
	local var9 = 0
	local var10 = getProxy(ActivityProxy):getActivityById(var0):GetSeriesData()
	local var11 = var10:GetStaegLevel() + 1
	local var12 = var10:GetExpeditionIds()[var11]
	local var13 = var10:GetFleetIds()
	local var14 = var13[var11]
	local var15 = var13[#var13]

	if var10:GetMode() == BossRushSeriesData.MODE.SINGLE then
		var14 = var13[1]
	end

	local var16 = var2:getActivityFleets()[var0]
	local var17 = var16[var14]
	local var18 = var16[var15]
	local var19 = {}
	local var20 = var3:getSortShipsByFleet(var17)

	for iter0, iter1 in ipairs(var20) do
		var19[#var19 + 1] = iter1.id
	end

	local var21 = var1:getRawData()

	if var5 and var9 > var21.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1.ShipVertify()

	local function var22(arg0)
		if var5 then
			var21:consume({
				gold = 0,
				oil = var7
			})
		end

		if var4.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var20) do
				iter1:cosumeEnergy(var0)
				var3:updateShip(iter1)
			end
		end

		var1:updatePlayer(var21)

		local var1 = {
			prefabFleet = {},
			stageId = var12,
			system = SYSTEM_BOSS_RUSH_EX,
			actId = var0,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var23(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_BOSS_RUSH_EX, var19, {
		var12
	}, var22, var23)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_BOSS_RUSH_EX]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = var3 > ys.Battle.BattleConst.BattleScore.C
	local var5 = 0
	local var6 = {}
	local var7 = {}

	;(function()
		local var0 = arg0.actId
		local var1 = getProxy(ActivityProxy):getActivityById(var0):GetSeriesData()
		local var2 = var1:GetStaegLevel() + 1
		local var3 = var1:GetFleetIds()
		local var4 = var3[var2]
		local var5 = var3[#var3]

		if var1:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var4 = var3[1]
		end

		local var6 = var1:getActivityFleets()[var0]
		local var7 = var6[var4]
		local var8 = var6[var5]

		local function var9(arg0)
			table.insertto(var7, _.values(arg0.commanderIds))
			table.insertto(var6, var2:getSortShipsByFleet(arg0))
		end

		var9(var7)

		if arg0.statistics.submarineAid then
			var9(var8)
		end
	end)()

	local var8 = arg1.GeneralPackage(arg0, var6)

	var8.commander_id_list = var7

	local function var9(arg0)
		arg0.statistics.mvpShipID = arg0.mvp

		local var0 = {
			system = SYSTEM_BOSS_RUSH_EX,
			statistics = arg0.statistics,
			score = var3,
			result = arg0.result
		}
		local var1 = arg0.actId
		local var2 = getProxy(ActivityProxy):getActivityById(var1)

		var2:GetSeriesData():PassStage(var0)
		getProxy(ActivityProxy):updateActivity(var2)
		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var0)
	end

	seriesAsync({
		function(arg0)
			if var4 then
				arg1:SendRequest(var8, function(arg0)
					arg0(arg0)
				end)

				return
			end

			arg0({})
		end,
		function(arg0, arg1)
			var9(arg1)
		end
	})
end

return var0
