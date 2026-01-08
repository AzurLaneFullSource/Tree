local var0_0 = class("BattleGateScenarioSubStrike")

ys.Battle.BattleGateScenarioSubStrike = var0_0
var0_0.__name = "BattleGateScenarioSubStrike"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = getProxy(ChapterProxy):getActiveChapter():getConfigMiscArg("submarine_support")
	local var1_1 = {
		prefabFleet = {},
		stageId = var0_1,
		system = SYSTEM_SCENARIO_SUB_STRIKE
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	local var0_2 = getProxy(ChapterProxy):getActiveChapter()
	local var1_2 = arg0_2.statistics._battleScore >= ys.Battle.BattleConst.BattleScore.S

	var0_2:writeBack(var1_2, arg0_2)

	local function var2_2()
		arg1_2:sendNotification(GAME.FINISH_STAGE_DONE, {
			statistics = arg0_2.statistics,
			score = arg0_2.statistics._battleScore,
			system = SYSTEM_SCENARIO_SUB_STRIKE
		})
	end

	arg1_2:sendNotification(GAME.CHAPTER_OP, {
		type = ChapterConst.OPSubStrike,
		arg1 = arg0_2.statistics._battleScore,
		callback = var2_2
	})
end

return var0_0
