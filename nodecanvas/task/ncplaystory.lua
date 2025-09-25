local var0_0 = class("NcPlayStory", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetStringArg("storyName")

	arg0_1:DoAction(var0_1, true, function()
		arg0_1:EndAction()
	end)
end

function var0_0.DoAction(arg0_3, arg1_3, arg2_3, arg3_3)
	if not _IslandCore then
		return
	end

	_IslandCore:GetController():NotifiyIsland(ISLAND_EX_EVT.PLAY_STORY, {
		name = arg1_3,
		refreshNpc = arg2_3,
		callback = arg3_3
	})
end

return var0_0
