local var0_0 = class("BeachGuardGrid")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._gridTf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.preIcon = findTF(arg0_1._gridTf, "charPos/preIcon")

	setActive(arg0_1.preIcon, false)

	arg0_1.collider = findTF(arg0_1._gridTf, "gridCollider")
	arg0_1.minX = arg0_1.collider.rect.min.x
	arg0_1.minY = arg0_1.collider.rect.min.y
	arg0_1.maxX = arg0_1.collider.rect.max.x
	arg0_1.maxY = arg0_1.collider.rect.max.y
	arg0_1.select = findTF(arg0_1._gridTf, "select")

	setActive(arg0_1.select, false)

	arg0_1.char = nil
	arg0_1.range = findTF(arg0_1._gridTf, "range")

	setActive(arg0_1.range, false)

	arg0_1.full = findTF(arg0_1._gridTf, "full")

	setActive(arg0_1.full, false)

	arg0_1.recycle = findTF(arg0_1._gridTf, "recycle")

	setActive(arg0_1.recycle, false)

	arg0_1.pos = findTF(arg0_1._gridTf, "charPos")
end

function var0_0.setLineIndex(arg0_2, arg1_2)
	arg0_2._lineIndex = arg1_2
end

function var0_0.getLineIndex(arg0_3)
	return arg0_3._lineIndex
end

function var0_0.setIndex(arg0_4, arg1_4)
	arg0_4._index = arg1_4
end

function var0_0.getIndex(arg0_5)
	return arg0_5._index
end

function var0_0.getPos(arg0_6)
	return arg0_6.pos
end

function var0_0.active(arg0_7, arg1_7)
	setActive(arg0_7._lineTf, arg1_7)
end

function var0_0.prechar(arg0_8, arg1_8)
	local var0_8 = GetComponent(arg0_8.preIcon, typeof(Image))
	local var1_8 = BeachGuardConst.chars[arg1_8].name

	var0_8.sprite = BeachGuardAsset.getCardIcon(var1_8)

	var0_8:SetNativeSize()
	setActive(arg0_8.preIcon, true)
	setActive(arg0_8.select, true)
end

function var0_0.unPreChar(arg0_9)
	setActive(arg0_9.preIcon, false)
	setActive(arg0_9.select, false)
end

function var0_0.inGridWorld(arg0_10, arg1_10)
	local var0_10 = arg0_10._gridTf:InverseTransformPoint(arg1_10)

	if var0_10.x > arg0_10.minX and var0_10.x < arg0_10.maxX and var0_10.y > arg0_10.minY and var0_10.y < arg0_10.maxY then
		return true
	end

	return false
end

function var0_0.setChar(arg0_11, arg1_11)
	if arg0_11.char then
		return
	end

	arg0_11.char = arg1_11
end

function var0_0.getChar(arg0_12)
	return arg0_12.char
end

function var0_0.removeChar(arg0_13)
	arg0_13.char = nil

	setActive(arg0_13.full, false)
end

function var0_0.isEmpty(arg0_14)
	return arg0_14.char == nil
end

function var0_0.start(arg0_15)
	return
end

function var0_0.step(arg0_16, arg1_16)
	if arg0_16.char and arg0_16.char:getRecycleFlag() then
		setActive(arg0_16.recycle, true)
	else
		setActive(arg0_16.recycle, false)
	end
end

function var0_0.clear(arg0_17)
	setActive(arg0_17.select, false)
	setActive(arg0_17.preIcon, false)
	setActive(arg0_17.full, false)

	arg0_17.char = nil
end

function var0_0.preDistance(arg0_18)
	setActive(arg0_18.range, true)
end

function var0_0.unPreDistance(arg0_19)
	setActive(arg0_19.range, false)
end

return var0_0
