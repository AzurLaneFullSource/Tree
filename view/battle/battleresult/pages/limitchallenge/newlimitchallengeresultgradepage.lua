local var0 = class("NewLimitChallengeResultGradePage", import("..NewBattleResultGradePage"))

function var0.GetGetObjectives(arg0)
	local var0 = arg0.contextData
	local var1 = {}

	if var0.statistics._battleScore > ys.Battle.BattleConst.BattleScore.C then
		local var2 = var0.statistics._totalTime
		local var3 = math.floor(var2)
		local var4 = ys.Battle.BattleTimerView.formatTime(var3)
		local var5 = i18n("battle_result_total_time")

		table.insert(var1, {
			text = setColorStr(var5, "#FFFFFFFF"),
			value = setColorStr(var4, COLOR_YELLOW)
		})
	end

	return var1
end

return var0
