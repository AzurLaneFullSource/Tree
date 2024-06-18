local var0_0 = class("NewSubRoutineResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.GetGetObjectives(arg0_1)
	local var0_1 = arg0_1.contextData
	local var1_1 = {}
	local var2_1 = var0_1.statistics.subRunResult
	local var3_1 = i18n("battle_result_base_score")

	table.insert(var1_1, {
		icon = "check_mark",
		text = setColorStr(var3_1, "#FFFFFFFF"),
		value = setColorStr("+" .. var2_1.basePoint, COLOR_BLUE)
	})

	local var4_1 = i18n("battle_result_dead_score", var2_1.deadCount)

	table.insert(var1_1, {
		icon = "check_mark",
		text = setColorStr(var4_1, "#FFFFFFFF"),
		value = setColorStr("-" .. var2_1.losePoint, COLOR_BLUE)
	})

	local var5_1 = i18n("battle_result_score", var2_1.score)

	table.insert(var1_1, {
		icon = "check_mark",
		text = setColorStr(var5_1, "#FFFFFFFF"),
		value = setColorStr("+" .. var2_1.point, COLOR_BLUE)
	})

	local var6_1 = i18n("battle_result_score_total")

	table.insert(var1_1, {
		text = setColorStr(var6_1, "#FFFFFFFF"),
		value = setColorStr(var2_1.total, COLOR_YELLOW)
	})

	return var1_1
end

return var0_0
