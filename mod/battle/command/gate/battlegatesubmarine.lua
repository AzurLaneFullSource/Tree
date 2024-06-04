local var0 = class("BattleGateSubmarine")

ys.Battle.BattleGateSubmarine = var0
var0.__name = "BattleGateSubmarine"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.stageId
	local var1 = pg.expedition_data_template[var0].dungeon_id
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1).fleet_prefab
	local var3 = {
		prefabFleet = var2,
		stageId = var0,
		system = SYSTEM_SUBMARINE_RUN
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var3)
end

function var0.Exit(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN)

	arg1:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = var0 and var0.id,
		statistics = arg0.statistics,
		arg1 = arg0.statistics._battleScore,
		arg2 = arg0.statistics.subRunResult.score
	})
end

return var0
