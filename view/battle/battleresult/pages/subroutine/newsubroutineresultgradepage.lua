local var0 = class("NewSubRoutineResultGradePage", import("..NewBattleResultGradePage"))

function var0.GetGetObjectives(arg0)
	local var0 = arg0.contextData
	local var1 = {}
	local var2 = var0.statistics.subRunResult
	local var3 = i18n("battle_result_base_score")

	table.insert(var1, {
		icon = "check_mark",
		text = setColorStr(var3, "#FFFFFFFF"),
		value = setColorStr("+" .. var2.basePoint, COLOR_BLUE)
	})

	local var4 = i18n("battle_result_dead_score", var2.deadCount)

	table.insert(var1, {
		icon = "check_mark",
		text = setColorStr(var4, "#FFFFFFFF"),
		value = setColorStr("-" .. var2.losePoint, COLOR_BLUE)
	})

	local var5 = i18n("battle_result_score", var2.score)

	table.insert(var1, {
		icon = "check_mark",
		text = setColorStr(var5, "#FFFFFFFF"),
		value = setColorStr("+" .. var2.point, COLOR_BLUE)
	})

	local var6 = i18n("battle_result_score_total")

	table.insert(var1, {
		text = setColorStr(var6, "#FFFFFFFF"),
		value = setColorStr(var2.total, COLOR_YELLOW)
	})

	return var1
end

return var0
