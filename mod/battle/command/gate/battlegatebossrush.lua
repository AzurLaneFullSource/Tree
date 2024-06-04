local var0 = class("BattleGateBossRush")

ys.Battle.BattleGateBossRush = var0
var0.__name = "BattleGateBossRush"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.actId
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(FleetProxy)
	local var3 = getProxy(BayProxy)
	local var4 = pg.battle_cost_template[SYSTEM_BOSS_RUSH]
	local var5 = var4.oil_cost > 0
	local var6 = getProxy(ActivityProxy):getActivityById(var0):GetSeriesData()
	local var7 = var6:GetStaegLevel() + 1
	local var8 = var6:GetExpeditionIds()[var7]
	local var9 = var6:GetFleetIds()
	local var10 = var9[var7]
	local var11 = var9[#var9]

	if var6:GetMode() == BossRushSeriesData.MODE.SINGLE then
		var10 = var9[1]
	end

	local var12 = var2:getActivityFleets()[var0]
	local var13 = var12[var10]
	local var14 = var12[var11]
	local var15 = {}
	local var16 = var3:getSortShipsByFleet(var13)

	for iter0, iter1 in ipairs(var16) do
		var15[#var15 + 1] = iter1.id
	end

	local var17 = var1:getRawData()
	local var18 = var13:GetCostSum().oil

	if var5 and var18 > var17.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1.ShipVertify()

	local var19 = var13:getStartCost().oil

	local function var20(arg0)
		if var5 then
			var17:consume({
				gold = 0,
				oil = var19
			})
		end

		if var4.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var16) do
				iter1:cosumeEnergy(var0)
				var3:updateShip(iter1)
			end
		end

		var1:updatePlayer(var17)

		local var1 = {
			prefabFleet = {},
			stageId = var8,
			system = SYSTEM_BOSS_RUSH,
			actId = var0,
			token = arg0.key,
			continuousBattleTimes = arg0.continuousBattleTimes,
			totalBattleTimes = arg0.totalBattleTimes
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var21(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_BOSS_RUSH, var15, {
		var8
	}, var20, var21)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_BOSS_RUSH]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = {}
	local var6 = {}
	local var7 = false

	;(function()
		local var0 = arg0.actId
		local var1 = getProxy(ActivityProxy):getActivityById(var0):GetSeriesData()

		if not var1 then
			var7 = true

			return
		end

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
			table.insertto(var6, _.values(arg0.commanderIds))
			table.insertto(var5, var2:getSortShipsByFleet(arg0))
		end

		var9(var7)

		if arg0.statistics.submarineAid then
			var9(var8)
		end
	end)()

	if var7 then
		arg1:sendNotification(GAME.FINISH_STAGE_ERROR)

		return
	end

	local var8 = arg1.GeneralPackage(arg0, var5)

	var8.commander_id_list = var6

	local function var9(arg0)
		arg0.statistics.mvpShipID = arg0.mvp

		local var0 = {
			system = SYSTEM_BOSS_RUSH,
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

	arg1:SendRequest(var8, var9)
end

return var0
