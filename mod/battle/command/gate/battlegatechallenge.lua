local var0 = class("BattleGateChallenge")

ys.Battle.BattleGateChallenge = var0
var0.__name = "BattleGateChallenge"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.mode
	local var1 = arg0.actId
	local var2 = getProxy(PlayerProxy)
	local var3 = getProxy(BayProxy)
	local var4 = getProxy(ChallengeProxy)
	local var5 = pg.battle_cost_template[SYSTEM_CHALLENGE]
	local var6 = var5.oil_cost > 0
	local var7 = {}
	local var8 = 0
	local var9 = 0
	local var10 = 0
	local var11 = 0
	local var12 = var4:getUserChallengeInfo(var0)
	local var13 = var12:getRegularFleet():getShips(false)

	for iter0, iter1 in ipairs(var13) do
		var7[#var7 + 1] = iter1.id
	end

	local var14 = var2:getData()

	if var6 and var11 > var14.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var15 = var12:getLevel()
	local var16 = var12:getNextStageID()
	local var17 = {
		var15,
		var0
	}

	arg1.ShipVertify()

	local function var18(arg0)
		if var6 then
			var14:consume({
				gold = 0,
				oil = var9
			})
		end

		if var5.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var13) do
				iter1:cosumeEnergy(var0)
				var3:updateShip(iter1)
			end
		end

		var2:updatePlayer(var14)

		local var1 = {
			prefabFleet = {},
			stageId = var16,
			system = SYSTEM_CHALLENGE,
			actId = var1,
			token = arg0.key,
			mode = var0
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var19(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_CHALLENGE, var7, {
		var16,
		var17
	}, var18, var19)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_CHALLENGE]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(ChallengeProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = {}
	local var6 = {}
	local var7 = arg0.mode
	local var8 = var2:getUserChallengeInfo(var7)
	local var9 = var8:getRegularFleet():getShips(true)

	for iter0, iter1 in ipairs(var9) do
		table.insert(var6, iter1)
	end

	local var10 = {
		var8:getLevel(),
		var7
	}
	local var11 = 0
	local var12 = arg1.GeneralPackage(arg0, var6)

	var12.data2 = var10

	local function var13(arg0)
		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics)

		arg0.statistics.mvpShipID = arg0.mvp

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var3 > ys.Battle.BattleConst.BattleScore.C

		arg1.GeneralPlayerCosume(SYSTEM_CHALLENGE, var2, var11, arg0.player_exp, exFlag)

		local var3 = {
			system = SYSTEM_CHALLENGE,
			statistics = arg0.statistics,
			score = var3,
			drops = var0,
			commanderExps = {},
			result = arg0.result,
			extraDrops = var1
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var3)

		local var4 = var8:getShipUIDList()

		local function var5(arg0)
			local var0 = arg0.statistics[arg0]

			if var0 then
				var8:updateShipHP(arg0, var0.bp)
			end
		end

		for iter0, iter1 in pairs(var4) do
			var5(iter1)
		end
	end

	arg1:SendRequest(var12, var13)
end

return var0
