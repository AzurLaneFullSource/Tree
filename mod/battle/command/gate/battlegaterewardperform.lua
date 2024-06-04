local var0 = class("BattleGateRewardPerform")

ys.Battle.BattleGateRewardPerform = var0
var0.__name = "BattleGateRewardPerform"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.stageId
	local var1 = pg.expedition_data_template[var0].dungeon_id
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1).fleet_prefab
	local var3 = {
		prefabFleet = var2,
		stageId = var0,
		system = SYSTEM_REWARD_PERFORM
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var3)
end

function var0.Exit(arg0, arg1)
	local var0 = arg0
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXPEDITION)
	local var2 = var1.data1_list
	local var3

	for iter0 = 1, #var2 do
		if bit.rshift(var2[iter0], 4) == var0.stageId then
			var3 = iter0

			break
		end
	end

	arg1:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 3,
		activity_id = var1 and var1.id,
		statistics = var0.statistics,
		arg1 = var0.statistics._battleScore,
		arg2 = var3
	})
end

return var0
