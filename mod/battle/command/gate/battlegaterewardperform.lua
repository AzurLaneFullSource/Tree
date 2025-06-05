local var0_0 = class("BattleGateRewardPerform")

ys.Battle.BattleGateRewardPerform = var0_0
var0_0.__name = "BattleGateRewardPerform"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.stageId
	local var1_1 = pg.expedition_data_template[var0_1].dungeon_id
	local var2_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1_1).fleet_prefab
	local var3_1

	if not var2_1 or #var2_1 == 0 then
		var3_1 = arg0_1.mainFleetId
	end

	local var4_1 = {
		mainFleetId = var3_1,
		prefabFleet = var2_1,
		stageId = var0_1,
		system = SYSTEM_REWARD_PERFORM,
		actId = arg0_1.actId
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var4_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	local var0_2 = arg0_2

	if arg0_2.actId then
		if var0_2.statistics._battleScore > ys.Battle.BattleConst.BattleScore.C then
			arg1_2:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 2,
				activity_id = arg0_2.actId,
				statistics = var0_2.statistics,
				arg1 = var0_2.stageId
			})
		else
			arg1_2:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg0_2.statistics,
				score = arg0_2.statistics._battleScore,
				system = SYSTEM_REWARD_PERFORM
			})
		end
	else
		local var1_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXPEDITION)
		local var2_2 = var1_2.data1_list
		local var3_2

		for iter0_2 = 1, #var2_2 do
			if bit.rshift(var2_2[iter0_2], 4) == var0_2.stageId then
				var3_2 = iter0_2

				break
			end
		end

		arg1_2:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 3,
			activity_id = var1_2 and var1_2.id,
			statistics = var0_2.statistics,
			arg1 = var0_2.statistics._battleScore,
			arg2 = var3_2
		})
	end
end

return var0_0
