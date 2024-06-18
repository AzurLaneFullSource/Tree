local var0_0 = class("GuildChatBubble", import(".ChatBubble"))

function var0_0.init(arg0_1)
	arg0_1.nameTF = findTF(arg0_1.tf, "name_bg/name"):GetComponent("Text")
	arg0_1.face = findTF(arg0_1.tf, "face/content")
	arg0_1.circle = findTF(arg0_1.tf, "shipicon/frame")
	arg0_1.timeTF = findTF(arg0_1.tf, "time"):GetComponent("Text")
	arg0_1.headTF = findTF(arg0_1.tf, "shipicon/icon"):GetComponent("Image")
	arg0_1.stars = findTF(arg0_1.tf, "shipicon/stars")
	arg0_1.star = findTF(arg0_1.stars, "star")
	arg0_1.frame = findTF(arg0_1.tf, "shipicon/frame"):GetComponent("Image")
	arg0_1.dutyTF = findTF(arg0_1.tf, "name_bg/duty")
	arg0_1.chatBgWidth = 550
end

function var0_0.OnChatFrameLoaded(arg0_2, arg1_2)
	local var0_2 = tf(arg1_2):Find("Text"):GetComponent(typeof(Text))

	if not arg0_2.prevChatFrameColor then
		arg0_2.prevChatFrameColor = var0_2.color
	end

	arg0_2.charFrameTxt = var0_2
end

function var0_0.dispose(arg0_3)
	var0_0.super.dispose(arg0_3)

	if arg0_3.charFrameTxt and arg0_3.prevChatFrameColor then
		arg0_3.charFrameTxt.color = arg0_3.prevChatFrameColor
	end
end

return var0_0
