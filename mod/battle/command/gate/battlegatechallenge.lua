local var0_0 = class("BattleGateChallenge")

ys.Battle.BattleGateChallenge = var0_0
var0_0.__name = "BattleGateChallenge"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.mode
	local var1_1 = arg0_1.actId
	local var2_1 = getProxy(PlayerProxy)
	local var3_1 = getProxy(BayProxy)
	local var4_1 = getProxy(ChallengeProxy)
	local var5_1 = pg.battle_cost_template[SYSTEM_CHALLENGE]
	local var6_1 = var5_1.oil_cost > 0
	local var7_1 = {}
	local var8_1 = 0
	local var9_1 = 0
	local var10_1 = 0
	local var11_1 = 0
	local var12_1 = var4_1:getUserChallengeInfo(var0_1)
	local var13_1 = var12_1:getRegularFleet():getShips(false)

	for iter0_1, iter1_1 in ipairs(var13_1) do
		var7_1[#var7_1 + 1] = iter1_1.id
	end

	local var14_1 = var2_1:getData()

	if var6_1 and var11_1 > var14_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var15_1 = var12_1:getLevel()
	local var16_1 = var12_1:getNextStageID()
	local var17_1 = {
		var15_1,
		var0_1
	}

	arg1_1.ShipVertify()

	local function var18_1(arg0_2)
		if var6_1 then
			var14_1:consume({
				gold = 0,
				oil = var9_1
			})
		end

		if var5_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var13_1) do
				iter1_2:cosumeEnergy(var0_2)
				var3_1:updateShip(iter1_2)
			end
		end

		var2_1:updatePlayer(var14_1)

		local var1_2 = {
			prefabFleet = {},
			stageId = var16_1,
			system = SYSTEM_CHALLENGE,
			actId = var1_1,
			token = arg0_2.key,
			mode = var0_1
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var19_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_CHALLENGE, var7_1, {
		var16_1,
		var17_1
	}, var18_1, var19_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_CHALLENGE]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(ChallengeProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = {}
	local var6_4 = {}
	local var7_4 = arg0_4.mode
	local var8_4 = var2_4:getUserChallengeInfo(var7_4)
	local var9_4 = var8_4:getRegularFleet():getShips(true)

	for iter0_4, iter1_4 in ipairs(var9_4) do
		table.insert(var6_4, iter1_4)
	end

	local var10_4 = {
		var8_4:getLevel(),
		var7_4
	}
	local var11_4 = 0
	local var12_4 = arg1_4.GeneralPackage(arg0_4, var6_4)

	var12_4.data2 = var10_4

	local function var13_4(arg0_5)
		arg1_4.addShipsExp(arg0_5.ship_exp_list, arg0_4.statistics)

		arg0_4.statistics.mvpShipID = arg0_5.mvp

		local var0_5, var1_5 = arg1_4:GeneralLoot(arg0_5)
		local var2_5 = var3_4 > ys.Battle.BattleConst.BattleScore.C

		arg1_4.GeneralPlayerCosume(SYSTEM_CHALLENGE, var2_5, var11_4, arg0_5.player_exp, exFlag)

		local var3_5 = {
			system = SYSTEM_CHALLENGE,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = var0_5,
			commanderExps = {},
			result = arg0_5.result,
			extraDrops = var1_5
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var3_5)

		local var4_5 = var8_4:getShipUIDList()

		local function var5_5(arg0_6)
			local var0_6 = arg0_4.statistics[arg0_6]

			if var0_6 then
				var8_4:updateShipHP(arg0_6, var0_6.bp)
			end
		end

		for iter0_5, iter1_5 in pairs(var4_5) do
			var5_5(iter1_5)
		end
	end

	arg1_4:SendRequest(var12_4, var13_4)
end

return var0_0
