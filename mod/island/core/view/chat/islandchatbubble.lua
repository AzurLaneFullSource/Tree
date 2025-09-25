local var0_0 = class("IslandChatBubble", import("view.main.ChatBubble"))

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.chatBgWidth = 655
end

function var0_0.GetAttireFrameRes(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = AttireFrame.attireFrameRes(arg1_2, arg2_2, AttireConst.TYPE_CHAT_FRAME, arg3_2)

	if var0_2 == "0_self" then
		return "island_self"
	end

	if var0_2 == "0_other" then
		return "island_other"
	end

	return var0_2
end

function var0_0.UpdateChannel(arg0_3, arg1_3)
	local var0_3 = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_3.type) .. "_mel")

	setImageSprite(arg0_3.channel, var0_3, true)
end

return var0_0
