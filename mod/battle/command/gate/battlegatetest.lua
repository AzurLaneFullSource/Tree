local var0 = class("BattleGateTest")

ys.Battle.BattleGateTest = var0
var0.__name = "BattleGateTest"

function var0.Entrance(arg0, arg1)
	if not arg1.LegalFleet(arg0.mainFleetId) then
		return
	end

	local var0 = getProxy(BayProxy)
	local var1 = getProxy(FleetProxy)
	local var2 = {}
	local var3 = var1:getFleetById(arg0.mainFleetId)
	local var4 = var0:getSortShipsByFleet(var3)

	for iter0, iter1 in ipairs(var4) do
		var2[#var2 + 1] = iter1.id
	end

	local var5 = arg0.mainFleetId
	local var6 = arg0.stageId
	local var7 = pg.expedition_data_template[var6].dungeon_id

	local function var8(arg0)
		local var0 = {
			mainFleetId = var5,
			prefabFleet = {},
			stageId = var6,
			system = SYSTEM_TEST,
			token = arg0.key
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var0)
	end

	local function var9(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_TEST, var2, {
		var6
	}, var8, var9)
end

function var0.Exit(arg0, arg1)
	local var0 = pg.battle_cost_template[SYSTEM_TEST]
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = arg0.statistics._battleScore
	local var4 = 0
	local var5 = {}
	local var6 = var1:getFleetById(arg0.mainFleetId)
	local var7 = var2:getSortShipsByFleet(var6)
	local var8 = arg1.GeneralPackage(arg0, var7)

	local function var9(arg0)
		arg0.statistics.mvpShipID = -1

		local var0 = {
			system = SYSTEM_TEST,
			statistics = arg0.statistics,
			score = var3,
			drops = {},
			commanderExps = {},
			result = arg0.result,
			extraDrops = {}
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var0)
	end

	arg1:SendRequest(var8, var9)
end

return var0
