local var0 = class("NewDuelResultGradePage", import("..NewBattleResultGradePage"))

function var0.UpdateChapterName(arg0)
	local var0 = arg0.contextData
	local var1 = getProxy(MilitaryExerciseProxy):getPreRivalById(var0.rivalId or 0)
	local var2 = var1 and var1.name or ""

	setText(arg0.gradeChapterName, var2)
end

return var0
