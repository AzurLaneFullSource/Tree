local var0 = class("BattleGateDodgem")

ys.Battle.BattleGateDodgem = var0
var0.__name = "BattleGateDodgem"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.stageId
	local var1 = pg.expedition_data_template[var0].dungeon_id
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1).fleet_prefab
	local var3 = {
		prefabFleet = var2,
		stageId = var0,
		system = SYSTEM_DODGEM
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var3)
end

function var0.Exit(arg0, arg1)
	local var0 = arg0
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DODGEM)

	arg1:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = var1 and var1.id,
		statistics = var0.statistics,
		arg1 = var0.statistics._battleScore,
		arg2 = var0.statistics.dodgemResult.score
	})
end

return var0
