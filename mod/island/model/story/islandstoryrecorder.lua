local var0_0 = class("IslandStoryRecorder", import("Mgr.Story.model.Record.StoryRecorder"))
local var1_0 = "#5ce6ff"
local var2_0 = "#39BFFF"
local var3_0 = "#70747F"
local var4_0 = "#BCBCBC"
local var5_0 = "#FFFFFF"

function var0_0.Convert(arg0_1)
	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg0_1.recordList) do
		arg0_1:Collect3DDialogueContent(var0_1, iter1_1)
	end

	arg0_1.recordList = {}

	return var0_1
end

function var0_0.Collect3DDialogueContent(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg2_2:GetSay()
	local var1_2 = arg2_2:IsPlayer()
	local var2_2 = arg2_2:GetActorName()
	local var3_2 = arg2_2:GetActorIcon()
	local var4_2 = var1_2 and var2_0 or var4_0

	table.insert(arg1_2, {
		icon = var3_2,
		name = var2_2,
		nameColor = var4_2,
		list = {
			setColorStr(arg0_2:FormatContent(var0_2), var1_2 and var2_0 or var5_0)
		},
		isPlayer = var1_2
	})
end

return var0_0
