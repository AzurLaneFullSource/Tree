local var0_0 = class("BattleGateSimulation")

ys.Battle.BattleGateSimulation = var0_0
var0_0.__name = "BattleGateSimulation"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.stageId
	local var1_1 = pg.expedition_data_template[var0_1].dungeon_id
	local var2_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1_1).fleet_prefab
	local var3_1 = {
		prefabFleet = var2_1,
		stageId = var0_1,
		system = SYSTEM_SIMULATION,
		exitCallback = arg0_1.exitCallback,
		warnMsg = arg0_1.warnMsg
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var3_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	arg1_2:sendNotification(GAME.FINISH_STAGE_DONE, {
		system = SYSTEM_SIMULATION,
		exitCallback = arg0_2.exitCallback
	})
end

return var0_0
