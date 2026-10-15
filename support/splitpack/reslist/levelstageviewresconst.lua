ResList = ResList or {}
ResList.LevelStageViewResConst = {}

local var0_0 = ResList.LevelStageViewResConst

function var0_0.GetResource(arg0_1)
	local var0_1 = {}
	local var1_1 = arg0_1 and arg0_1.chapterVO

	table.insertto(var0_1, ResList.ChapterResConst.GetStrategyResList(var1_1))
	table.insertto(var0_1, ResList.ChapterResConst.GetCommanderSkillResList(var1_1))
	table.insertto(var0_1, ResList.ChapterResConst.GetFleetIconResList(var1_1))

	return var0_1
end

return var0_0
