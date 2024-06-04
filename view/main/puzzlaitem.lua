local var0 = class("PuzzlaItem")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.img = arg1:GetComponent(typeof(Image))
	arg0.btn = arg1:AddComponent(typeof(Button))
	arg0._go = arg1
	arg0._tr = rtf(arg0._go)
	arg0._tr.pivot = Vector2(0, 1)
	arg0.width = 0
	arg0.height = 0
	arg0.position = nil
	arg0.index = arg2
	arg0.isWhite = false
	arg0.currIndex = nil
	arg0.isOpen = arg3
	arg0.desc = arg4
	arg0.mask = GameObject("mask")
	arg0.maskImg = arg0.mask:AddComponent(typeof(Image))

	setParent(arg0.mask, arg0._go)

	tf(arg0.mask).pivot = Vector2(0, 1)
	arg0.maskImg.color = Color.New(0, 0, 0, 0.85)
	arg0.textTF = GameObject("Text")
	arg0.textTFText = arg0.textTF:AddComponent(typeof(Text))

	setParent(arg0.textTF, arg0.mask)

	tf(arg0.textTF).pivot = Vector2(0, 1)
	arg0.textTFText.font = pg.FontMgr.GetInstance().fonts.heiti
	arg0.textTFText.fontSize = 18
	arg0.textTFText.alignment = TextAnchor.MiddleCenter
end

function var0.activeMask(arg0, arg1)
	setActive(arg0.mask, arg1)
end

function var0.activeDesc(arg0, arg1)
	setActive(arg0.textTF, arg1)
end

function var0.setDesc(arg0, arg1)
	arg0.textTFText.text = arg1
end

function var0.setCurrIndex(arg0, arg1)
	arg0.currIndex = arg1
end

function var0.isBlock(arg0)
	return arg0.isWhite
end

function var0.isRestoration(arg0)
	return arg0.currIndex == arg0.index and arg0.isOpen
end

function var0.update(arg0, arg1, arg2, arg3)
	arg0:setSprite(arg1)
	arg0:setPosition(arg2, arg0.index)

	if arg3 then
		arg0:setBlock()

		arg0.isWhite = true
		arg0.isOpen = true
	end

	arg0:activeMask(not arg0.isOpen)
	arg0:activeDesc(arg0.desc)

	if arg0.desc then
		arg0:setDesc(arg0.desc)
	end
end

function var0.setHightLight(arg0)
	arg0.img.color = Color.New(1, 1, 1, 1)
end

function var0.setBlock(arg0)
	arg0.img.color = Color.New(1, 1, 1, 0)
end

function var0.setSprite(arg0, arg1)
	arg0.img.sprite = arg1

	arg0.img:SetNativeSize()

	arg0.width = arg1.rect.width
	arg0.height = arg1.rect.height
	tf(arg0.mask).sizeDelta = Vector2(arg0.width, arg0.height)
	tf(arg0.mask).localPosition = Vector2(0, 0)
	tf(arg0.textTF).sizeDelta = Vector2(arg0.width, arg0.height)
	tf(arg0.textTF).localPosition = Vector2(0, 0)
end

function var0.setPosition(arg0, arg1, arg2)
	arg0.position = arg1
	arg0.currIndex = arg2
end

function var0.getPosition(arg0)
	return arg0.position
end

function var0.getCurrIndex(arg0)
	return arg0.currIndex
end

function var0.setLocalPosition(arg0, arg1)
	arg0._tr.localPosition = arg1
end

function var0.getLocalPosition(arg0)
	return arg0._tr.localPosition
end

function var0.getSurroundPosition(arg0)
	local var0 = {}

	table.insert(var0, Vector2(arg0.position.x, arg0.position.y + 1))
	table.insert(var0, Vector2(arg0.position.x, arg0.position.y - 1))
	table.insert(var0, Vector2(arg0.position.x - 1, arg0.position.y))
	table.insert(var0, Vector2(arg0.position.x + 1, arg0.position.y))

	return var0
end

return var0
