local var0 = class("BattleGateBossExperiment")

ys.Battle.BattleGateBossExperiment = var0
var0.__name = "BattleGateBossExperiment"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.actId
	local var1 = arg0.mainFleetId
	local var2 = arg0.stageId
	local var3 = pg.expedition_data_template[var2].dungeon_id
	local var4 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var3).fleet_prefab
	local var5 = {
		mainFleetId = var1,
		actId = var0,
		prefabFleet = var4,
		stageId = var2,
		system = SYSTEM_BOSS_EXPERIMENT
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var5)
end

function var0.Exit(arg0, arg1)
	local var0 = ys.Battle.BattleConst.BattleScore.S
	local var1 = {
		system = SYSTEM_BOSS_EXPERIMENT,
		statistics = arg0.statistics,
		score = var0,
		commanderExps = {}
	}

	arg1:sendNotification(GAME.FINISH_STAGE_DONE, var1)
end

return var0
