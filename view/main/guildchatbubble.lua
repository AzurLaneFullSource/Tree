local var0 = class("GuildChatBubble", import(".ChatBubble"))

function var0.init(arg0)
	arg0.nameTF = findTF(arg0.tf, "name_bg/name"):GetComponent("Text")
	arg0.face = findTF(arg0.tf, "face/content")
	arg0.circle = findTF(arg0.tf, "shipicon/frame")
	arg0.timeTF = findTF(arg0.tf, "time"):GetComponent("Text")
	arg0.headTF = findTF(arg0.tf, "shipicon/icon"):GetComponent("Image")
	arg0.stars = findTF(arg0.tf, "shipicon/stars")
	arg0.star = findTF(arg0.stars, "star")
	arg0.frame = findTF(arg0.tf, "shipicon/frame"):GetComponent("Image")
	arg0.dutyTF = findTF(arg0.tf, "name_bg/duty")
	arg0.chatBgWidth = 550
end

function var0.OnChatFrameLoaded(arg0, arg1)
	local var0 = tf(arg1):Find("Text"):GetComponent(typeof(Text))

	if not arg0.prevChatFrameColor then
		arg0.prevChatFrameColor = var0.color
	end

	arg0.charFrameTxt = var0
end

function var0.dispose(arg0)
	var0.super.dispose(arg0)

	if arg0.charFrameTxt and arg0.prevChatFrameColor then
		arg0.charFrameTxt.color = arg0.prevChatFrameColor
	end
end

return var0
