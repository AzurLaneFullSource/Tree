local var0_0 = class("BattleGateTest")

ys.Battle.BattleGateTest = var0_0
var0_0.__name = "BattleGateTest"

function var0_0.Entrance(arg0_1, arg1_1)
	if not arg1_1.LegalFleet(arg0_1.mainFleetId) then
		return
	end

	local var0_1 = getProxy(BayProxy)
	local var1_1 = getProxy(FleetProxy)
	local var2_1 = {}
	local var3_1 = var1_1:getFleetById(arg0_1.mainFleetId)
	local var4_1 = var0_1:getSortShipsByFleet(var3_1)

	for iter0_1, iter1_1 in ipairs(var4_1) do
		var2_1[#var2_1 + 1] = iter1_1.id
	end

	local var5_1 = arg0_1.mainFleetId
	local var6_1 = arg0_1.stageId
	local var7_1 = pg.expedition_data_template[var6_1].dungeon_id

	local function var8_1(arg0_2)
		local var0_2 = {
			mainFleetId = var5_1,
			prefabFleet = {},
			stageId = var6_1,
			system = SYSTEM_TEST,
			token = arg0_2.key
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var0_2)
	end

	local function var9_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_TEST, var2_1, {
		var6_1
	}, var8_1, var9_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = pg.battle_cost_template[SYSTEM_TEST]
	local var1_4 = getProxy(FleetProxy)
	local var2_4 = getProxy(BayProxy)
	local var3_4 = arg0_4.statistics._battleScore
	local var4_4 = 0
	local var5_4 = {}
	local var6_4 = var1_4:getFleetById(arg0_4.mainFleetId)
	local var7_4 = var2_4:getSortShipsByFleet(var6_4)
	local var8_4 = arg1_4.GeneralPackage(arg0_4, var7_4)

	local function var9_4(arg0_5)
		arg0_4.statistics.mvpShipID = -1

		local var0_5 = {
			system = SYSTEM_TEST,
			statistics = arg0_4.statistics,
			score = var3_4,
			drops = {},
			commanderExps = {},
			result = arg0_5.result,
			extraDrops = {}
		}

		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var0_5)
	end

	arg1_4:SendRequest(var8_4, var9_4)
end

return var0_0
