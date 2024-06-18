local var0_0 = class("BattleGateBossExperiment")

ys.Battle.BattleGateBossExperiment = var0_0
var0_0.__name = "BattleGateBossExperiment"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.actId
	local var1_1 = arg0_1.mainFleetId
	local var2_1 = arg0_1.stageId
	local var3_1 = pg.expedition_data_template[var2_1].dungeon_id
	local var4_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var3_1).fleet_prefab
	local var5_1 = {
		mainFleetId = var1_1,
		actId = var0_1,
		prefabFleet = var4_1,
		stageId = var2_1,
		system = SYSTEM_BOSS_EXPERIMENT
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var5_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	local var0_2 = ys.Battle.BattleConst.BattleScore.S
	local var1_2 = {
		system = SYSTEM_BOSS_EXPERIMENT,
		statistics = arg0_2.statistics,
		score = var0_2,
		commanderExps = {}
	}

	arg1_2:sendNotification(GAME.FINISH_STAGE_DONE, var1_2)
end

return var0_0
