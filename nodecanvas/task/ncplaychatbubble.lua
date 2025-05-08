local var0_0 = class("NcPlayChatBubble", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetStringArg("storyName")

	arg0_1:DoAction(var0_1, function()
		arg0_1:EndAction()
	end)
end

function var0_0.DoAction(arg0_3, arg1_3, arg2_3)
	arg0_3:SendEvent(ISLAND_EVT.PLAY_BUBBLE, {
		name = arg1_3,
		callback = arg2_3
	})
end

return var0_0
