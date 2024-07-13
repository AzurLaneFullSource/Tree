local var0_0 = class("BattleGateDodgem")

ys.Battle.BattleGateDodgem = var0_0
var0_0.__name = "BattleGateDodgem"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.stageId
	local var1_1 = pg.expedition_data_template[var0_1].dungeon_id
	local var2_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1_1).fleet_prefab
	local var3_1 = {
		prefabFleet = var2_1,
		stageId = var0_1,
		system = SYSTEM_DODGEM
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var3_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	local var0_2 = arg0_2
	local var1_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DODGEM)

	arg1_2:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = var1_2 and var1_2.id,
		statistics = var0_2.statistics,
		arg1 = var0_2.statistics._battleScore,
		arg2 = var0_2.statistics.dodgemResult.score
	})
end

return var0_0
