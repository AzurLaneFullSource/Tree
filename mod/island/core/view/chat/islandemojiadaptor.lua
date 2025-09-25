local var0_0 = class("IslandEmojiAdaptor", import("..IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.loaded = false
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.emojiLayer = IslandEmojiLayer.New()

	arg0_2.emojiLayer:bind(BaseUI.ON_CLOSE, function()
		arg0_2.emojiLayer:exit()

		arg0_2.emojiLayer = nil
		arg0_2.loaded = false
	end)
	arg0_2.emojiLayer:setContextData(arg1_2)

	local var0_2

	local function var1_2()
		arg0_2.emojiLayer.event:disconnect(BaseUI.LOADED, var1_2)
		arg0_2.emojiLayer:enter()
		var0_0.super.Init(arg0_2)

		arg0_2.loaded = true
	end

	arg0_2.emojiLayer.event:connect(BaseUI.LOADED, var1_2)
	arg0_2.emojiLayer:load()
end

function var0_0.OnDispose(arg0_5)
	var0_0.super.OnDispose(arg0_5)

	if arg0_5.loaded then
		arg0_5.emojiLayer:exit()

		arg0_5.emojiLayer = nil
	end
end

return var0_0
