local var0_0 = class("NcPlayChatExpression", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetStringArg("emojiId")
	local var1_1 = arg0_1:GetStringArg("id")
	local var2_1 = arg0_1:GetStringArg("type")

	arg0_1:DoAction(var0_1, tonumber(var1_1), tonumber(var2_1), function()
		return
	end)
	arg0_1:EndAction()
end

function var0_0.DoAction(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	if not _IslandCore then
		return
	end

	local var0_3 = arg0_3:WarpStory(arg1_3, arg2_3, arg3_3)

	_IslandCore:GetController():NotifiyCore(ISLAND_EVT.RAW_PLAY_BUBBLE, {
		info = var0_3,
		callback = arg4_3
	})
end

function var0_0.WarpStory(arg0_4, arg1_4, arg2_4, arg3_4)
	return {
		id = "NPC_WARP_STORY",
		mode = 9,
		map = {
			{
				9999,
				arg2_4,
				arg3_4
			}
		},
		scripts = {
			{
				emojiType = 2,
				characterId = 9999,
				emoji = arg1_4
			}
		}
	}
end

return var0_0
