local var0 = class("BattleGateSimulation")

ys.Battle.BattleGateSimulation = var0
var0.__name = "BattleGateSimulation"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.stageId
	local var1 = pg.expedition_data_template[var0].dungeon_id
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1).fleet_prefab
	local var3 = {
		prefabFleet = var2,
		stageId = var0,
		system = SYSTEM_SIMULATION,
		exitCallback = arg0.exitCallback,
		warnMsg = arg0.warnMsg
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var3)
end

function var0.Exit(arg0, arg1)
	arg1:sendNotification(GAME.FINISH_STAGE_DONE, {
		system = SYSTEM_SIMULATION,
		exitCallback = arg0.exitCallback
	})
end

return var0
