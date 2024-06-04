local var0 = class("BeachGuardGrid")

function var0.Ctor(arg0, arg1, arg2)
	arg0._gridTf = arg1
	arg0._event = arg2
	arg0.preIcon = findTF(arg0._gridTf, "charPos/preIcon")

	setActive(arg0.preIcon, false)

	arg0.collider = findTF(arg0._gridTf, "gridCollider")
	arg0.minX = arg0.collider.rect.min.x
	arg0.minY = arg0.collider.rect.min.y
	arg0.maxX = arg0.collider.rect.max.x
	arg0.maxY = arg0.collider.rect.max.y
	arg0.select = findTF(arg0._gridTf, "select")

	setActive(arg0.select, false)

	arg0.char = nil
	arg0.range = findTF(arg0._gridTf, "range")

	setActive(arg0.range, false)

	arg0.full = findTF(arg0._gridTf, "full")

	setActive(arg0.full, false)

	arg0.recycle = findTF(arg0._gridTf, "recycle")

	setActive(arg0.recycle, false)

	arg0.pos = findTF(arg0._gridTf, "charPos")
end

function var0.setLineIndex(arg0, arg1)
	arg0._lineIndex = arg1
end

function var0.getLineIndex(arg0)
	return arg0._lineIndex
end

function var0.setIndex(arg0, arg1)
	arg0._index = arg1
end

function var0.getIndex(arg0)
	return arg0._index
end

function var0.getPos(arg0)
	return arg0.pos
end

function var0.active(arg0, arg1)
	setActive(arg0._lineTf, arg1)
end

function var0.prechar(arg0, arg1)
	local var0 = GetComponent(arg0.preIcon, typeof(Image))
	local var1 = BeachGuardConst.chars[arg1].name

	var0.sprite = BeachGuardAsset.getCardIcon(var1)

	var0:SetNativeSize()
	setActive(arg0.preIcon, true)
	setActive(arg0.select, true)
end

function var0.unPreChar(arg0)
	setActive(arg0.preIcon, false)
	setActive(arg0.select, false)
end

function var0.inGridWorld(arg0, arg1)
	local var0 = arg0._gridTf:InverseTransformPoint(arg1)

	if var0.x > arg0.minX and var0.x < arg0.maxX and var0.y > arg0.minY and var0.y < arg0.maxY then
		return true
	end

	return false
end

function var0.setChar(arg0, arg1)
	if arg0.char then
		return
	end

	arg0.char = arg1
end

function var0.getChar(arg0)
	return arg0.char
end

function var0.removeChar(arg0)
	arg0.char = nil

	setActive(arg0.full, false)
end

function var0.isEmpty(arg0)
	return arg0.char == nil
end

function var0.start(arg0)
	return
end

function var0.step(arg0, arg1)
	if arg0.char and arg0.char:getRecycleFlag() then
		setActive(arg0.recycle, true)
	else
		setActive(arg0.recycle, false)
	end
end

function var0.clear(arg0)
	setActive(arg0.select, false)
	setActive(arg0.preIcon, false)
	setActive(arg0.full, false)

	arg0.char = nil
end

function var0.preDistance(arg0)
	setActive(arg0.range, true)
end

function var0.unPreDistance(arg0)
	setActive(arg0.range, false)
end

return var0
