local var0_0 = class("NewDuelResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.UpdateChapterName(arg0_1)
	local var0_1 = arg0_1.contextData
	local var1_1 = getProxy(MilitaryExerciseProxy):getPreRivalById(var0_1.rivalId or 0)
	local var2_1 = var1_1 and var1_1.name or ""

	setText(arg0_1.gradeChapterName, var2_1)
end

return var0_0
