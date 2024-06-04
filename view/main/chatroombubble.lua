local var0 = class("ChatRoomBubble", import(".ChatBubble"))

function var0.init(arg0)
	arg0.nameTF = findTF(arg0.tf, "desc/name"):GetComponent("Text")
	arg0.circle = findTF(arg0.tf, "shipicon/frame")
	arg0.face = findTF(arg0.tf, "face/content")
	arg0.timeTF = findTF(arg0.tf, "time"):GetComponent("Text")
	arg0.headTF = findTF(arg0.tf, "shipicon/icon"):GetComponent("Image")
	arg0.stars = findTF(arg0.tf, "shipicon/stars")
	arg0.star = findTF(arg0.stars, "star")
	arg0.frame = findTF(arg0.tf, "shipicon/frame"):GetComponent("Image")
	arg0.chatBgWidth = 665
end

return var0
