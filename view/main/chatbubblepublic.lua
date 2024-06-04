local var0 = class("ChatBubblePublic")

function var0.Ctor(arg0, arg1)
	arg0.tf = tf(arg1)
	arg0.richText = findTF(arg0.tf, "text"):GetComponent("RichText")

	local var0 = findTF(arg0.tf, "channel")

	if not IsNil(var0) then
		arg0.channel = var0:GetComponent("Image")
	end
end

function var0.update(arg0, arg1)
	if arg0.data == arg1 then
		return
	end

	arg0.data = arg1
	arg0.richText.supportRichText = true

	ChatProxy.InjectPublic(arg0.richText, arg1)
	arg0.richText:AddListener(function(arg0, arg1)
		arg0:clickItem(arg0, arg1)
	end)

	if arg0.channel then
		arg0.channel.sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1.type) .. "_1920")

		arg0.channel:SetNativeSize()
	end
end

function var0.clickItem(arg0, arg1, arg2)
	if arg1 == "clickPlayer" then
		print("click player : ")
	elseif arg1 == "clickShip" then
		print("click ship : ")
	end
end

function var0.dispose(arg0)
	arg0.richText:RemoveAllListeners()
end

return var0
