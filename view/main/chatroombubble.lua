local var0_0 = class("ChatRoomBubble", import(".ChatBubble"))

function var0_0.init(arg0_1)
	arg0_1.nameTF = findTF(arg0_1.tf, "desc/name"):GetComponent("Text")
	arg0_1.circle = findTF(arg0_1.tf, "shipicon/frame")
	arg0_1.face = findTF(arg0_1.tf, "face/content")
	arg0_1.timeTF = findTF(arg0_1.tf, "time"):GetComponent("Text")
	arg0_1.headTF = findTF(arg0_1.tf, "shipicon/icon"):GetComponent("Image")
	arg0_1.stars = findTF(arg0_1.tf, "shipicon/stars")
	arg0_1.star = findTF(arg0_1.stars, "star")
	arg0_1.frame = findTF(arg0_1.tf, "shipicon/frame"):GetComponent("Image")
	arg0_1.chatBgWidth = 665
end

return var0_0
