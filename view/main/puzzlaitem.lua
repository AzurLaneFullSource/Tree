local var0_0 = class("PuzzlaItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.img = arg1_1:GetComponent(typeof(Image))
	arg0_1.btn = arg1_1:AddComponent(typeof(Button))
	arg0_1._go = arg1_1
	arg0_1._tr = rtf(arg0_1._go)
	arg0_1._tr.pivot = Vector2(0, 1)
	arg0_1.width = 0
	arg0_1.height = 0
	arg0_1.position = nil
	arg0_1.index = arg2_1
	arg0_1.isWhite = false
	arg0_1.currIndex = nil
	arg0_1.isOpen = arg3_1
	arg0_1.desc = arg4_1
	arg0_1.mask = GameObject("mask")
	arg0_1.maskImg = arg0_1.mask:AddComponent(typeof(Image))

	setParent(arg0_1.mask, arg0_1._go)

	tf(arg0_1.mask).pivot = Vector2(0, 1)
	arg0_1.maskImg.color = Color.New(0, 0, 0, 0.85)
	arg0_1.textTF = GameObject("Text")
	arg0_1.textTFText = arg0_1.textTF:AddComponent(typeof(Text))

	setParent(arg0_1.textTF, arg0_1.mask)

	tf(arg0_1.textTF).pivot = Vector2(0, 1)
	arg0_1.textTFText.font = ResourceMgr.Inst:getAssetAsync("font/zhunyuan", "", nil, true, false)
	arg0_1.textTFText.fontSize = 18
	arg0_1.textTFText.alignment = TextAnchor.MiddleCenter
end

function var0_0.activeMask(arg0_2, arg1_2)
	setActive(arg0_2.mask, arg1_2)
end

function var0_0.activeDesc(arg0_3, arg1_3)
	setActive(arg0_3.textTF, arg1_3)
end

function var0_0.setDesc(arg0_4, arg1_4)
	arg0_4.textTFText.text = arg1_4
end

function var0_0.setCurrIndex(arg0_5, arg1_5)
	arg0_5.currIndex = arg1_5
end

function var0_0.isBlock(arg0_6)
	return arg0_6.isWhite
end

function var0_0.isRestoration(arg0_7)
	return arg0_7.currIndex == arg0_7.index and arg0_7.isOpen
end

function var0_0.update(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8:setSprite(arg1_8)
	arg0_8:setPosition(arg2_8, arg0_8.index)

	if arg3_8 then
		arg0_8:setBlock()

		arg0_8.isWhite = true
		arg0_8.isOpen = true
	end

	arg0_8:activeMask(not arg0_8.isOpen)
	arg0_8:activeDesc(arg0_8.desc)

	if arg0_8.desc then
		arg0_8:setDesc(arg0_8.desc)
	end
end

function var0_0.setHightLight(arg0_9)
	arg0_9.img.color = Color.New(1, 1, 1, 1)
end

function var0_0.setBlock(arg0_10)
	arg0_10.img.color = Color.New(1, 1, 1, 0)
end

function var0_0.setSprite(arg0_11, arg1_11)
	arg0_11.img.sprite = arg1_11

	arg0_11.img:SetNativeSize()

	arg0_11.width = arg1_11.rect.width
	arg0_11.height = arg1_11.rect.height
	tf(arg0_11.mask).sizeDelta = Vector2(arg0_11.width, arg0_11.height)
	tf(arg0_11.mask).localPosition = Vector2(0, 0)
	tf(arg0_11.textTF).sizeDelta = Vector2(arg0_11.width, arg0_11.height)
	tf(arg0_11.textTF).localPosition = Vector2(0, 0)
end

function var0_0.setPosition(arg0_12, arg1_12, arg2_12)
	arg0_12.position = arg1_12
	arg0_12.currIndex = arg2_12
end

function var0_0.getPosition(arg0_13)
	return arg0_13.position
end

function var0_0.getCurrIndex(arg0_14)
	return arg0_14.currIndex
end

function var0_0.setLocalPosition(arg0_15, arg1_15)
	arg0_15._tr.localPosition = arg1_15
end

function var0_0.getLocalPosition(arg0_16)
	return arg0_16._tr.localPosition
end

function var0_0.getSurroundPosition(arg0_17)
	local var0_17 = {}

	table.insert(var0_17, Vector2(arg0_17.position.x, arg0_17.position.y + 1))
	table.insert(var0_17, Vector2(arg0_17.position.x, arg0_17.position.y - 1))
	table.insert(var0_17, Vector2(arg0_17.position.x - 1, arg0_17.position.y))
	table.insert(var0_17, Vector2(arg0_17.position.x + 1, arg0_17.position.y))

	return var0_17
end

return var0_0
