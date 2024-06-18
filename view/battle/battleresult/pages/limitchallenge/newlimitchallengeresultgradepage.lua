local var0_0 = class("NewLimitChallengeResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.GetGetObjectives(arg0_1)
	local var0_1 = arg0_1.contextData
	local var1_1 = {}

	if var0_1.statistics._battleScore > ys.Battle.BattleConst.BattleScore.C then
		local var2_1 = var0_1.statistics._totalTime
		local var3_1 = math.floor(var2_1)
		local var4_1 = ys.Battle.BattleTimerView.formatTime(var3_1)
		local var5_1 = i18n("battle_result_total_time")

		table.insert(var1_1, {
			text = setColorStr(var5_1, "#FFFFFFFF"),
			value = setColorStr(var4_1, COLOR_YELLOW)
		})
	end

	return var1_1
end

return var0_0
