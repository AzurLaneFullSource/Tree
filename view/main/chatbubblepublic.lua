local var0_0 = class("ChatBubblePublic")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tf = tf(arg1_1)
	arg0_1.richText = findTF(arg0_1.tf, "text"):GetComponent("RichText")

	local var0_1 = findTF(arg0_1.tf, "channel")

	if not IsNil(var0_1) then
		arg0_1.channel = var0_1:GetComponent("Image")
	end
end

function var0_0.update(arg0_2, arg1_2)
	if arg0_2.data == arg1_2 then
		return
	end

	arg0_2.data = arg1_2
	arg0_2.richText.supportRichText = true

	ChatProxy.InjectPublic(arg0_2.richText, arg1_2)
	arg0_2.richText:AddListener(function(arg0_3, arg1_3)
		arg0_2:clickItem(arg0_3, arg1_3)
	end)

	if arg0_2.channel then
		arg0_2.channel.sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_2.type) .. "_1920")

		arg0_2.channel:SetNativeSize()
	end
end

function var0_0.clickItem(arg0_4, arg1_4, arg2_4)
	if arg1_4 == "clickPlayer" then
		print("click player : ")
	elseif arg1_4 == "clickShip" then
		print("click ship : ")
	end
end

function var0_0.dispose(arg0_5)
	arg0_5.richText:RemoveAllListeners()
end

return var0_0
