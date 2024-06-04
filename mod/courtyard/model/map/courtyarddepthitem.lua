local var0 = class("CourtYardDepthItem", import("...CourtYardDispatcher"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg0:GetDeathType()

	arg0.ob = {
		id = arg2,
		type = var0
	}
	arg0.initSizeX = arg3 or 0
	arg0.initSizeY = arg4 or 0
	arg0.sizeX = arg0.initSizeX
	arg0.sizeY = arg0.initSizeY
	arg0.posX = 0
	arg0.posY = 0
	arg0.maxX = 0
	arg0.maxY = 0
	arg0.posZ = 0
	arg0.dir = 1
	arg0.sortedFlag = true
	arg0.dirty = false
	arg0.parent = nil
	arg0.opFlag = false
	arg0.area = {}
end

function var0.GetInitSize(arg0)
	return {
		{
			arg0.sizeX,
			arg0.sizeY
		}
	}
end

function var0.GetInitSizeCnt(arg0)
	local var0 = arg0:GetInitSize()[1]

	return var0[1] * var0[2]
end

function var0.GetObjType(arg0)
	assert(false)
end

function var0.GetOffset(arg0)
	assert(false)
end

function var0.UpdateOpFlag(arg0, arg1)
	arg0.opFlag = arg1
end

function var0.GetOpFlag(arg0)
	return arg0.opFlag
end

function var0.InActivityRange(arg0, arg1)
	return true
end

function var0.GetDeathType(arg0)
	assert(false)
end

function var0.SetPosition(arg0, arg1)
	arg0:SetDirty()
	arg0:SetPos(arg1.x + 1, arg1.y + 1)
	arg0:ReGenArea()
end

function var0.SetDir(arg0, arg1)
	arg0:SetDirty()

	if arg1 == 2 then
		arg0.sizeX = arg0.initSizeY
		arg0.sizeY = arg0.initSizeX
	else
		arg0.sizeX = arg0.initSizeX
		arg0.sizeY = arg0.initSizeY
	end

	arg0.dir = arg1

	arg0:SetPosition(arg0:GetPosition())
end

function var0.GetDirection(arg0)
	return arg0.dir
end

function var0.GetNormalDirection(arg0)
	if arg0.dir == 1 then
		return 1
	end

	if arg0.dir == 2 then
		return -1
	end
end

function var0.ReGenArea(arg0)
	table.clear(arg0.area)

	local var0 = arg0:GetPosition()

	arg0.area = arg0:GetAreaByPosition(var0)
end

function var0.GetPosition(arg0)
	return Vector2(arg0.posX - 1, arg0.posY - 1)
end

function var0.SetPos(arg0, arg1, arg2)
	arg0.posX = arg1
	arg0.posY = arg2
	arg0.maxX = arg1 + arg0.sizeX - 1
	arg0.maxY = arg2 + arg0.sizeY - 1
end

function var0.SetDepth(arg0, arg1)
	arg0.posZ = arg1
end

function var0.GetArea(arg0)
	return arg0.area
end

function var0.GetAreaByPosition(arg0, arg1)
	local var0 = {}

	for iter0 = arg1.x, arg1.x + arg0.sizeX - 1 do
		for iter1 = arg1.y, arg1.y + arg0.sizeY - 1 do
			table.insert(var0, Vector2(iter0, iter1))
		end
	end

	return var0
end

function var0._GetRotatePositions(arg0, arg1)
	local var0 = arg0.sizeY
	local var1 = arg0.sizeX
	local var2 = {}

	for iter0 = arg1.x, arg1.x + var0 - 1 do
		for iter1 = arg1.y, arg1.y + var1 - 1 do
			table.insert(var2, Vector2(iter0, iter1))
		end
	end

	return var2
end

function var0.GetRotatePositions(arg0)
	local var0 = arg0:GetPosition()

	return arg0:_GetRotatePositions(var0)
end

function var0.SetDirty(arg0)
	arg0.dirty = true
end

function var0.UnDirty(arg0)
	arg0.dirty = false
end

function var0.IsDirty(arg0)
	return arg0.dirty
end

function var0.Interaction(arg0, arg1)
	return
end

function var0.ClearInteraction(arg0, arg1)
	return
end

function var0.SetParent(arg0, arg1)
	arg0:SetDirty()

	arg0.parent = arg1
end

function var0.HasParent(arg0)
	return arg0.parent ~= nil
end

function var0.GetParent(arg0)
	return arg0.parent
end

function var0.GetAroundPositions(arg0)
	local var0 = arg0:GetPosition()

	return {
		Vector2(var0.x + 1, var0.y),
		Vector2(var0.x, var0.y + 1),
		Vector2(var0.x - 1, var0.y),
		Vector2(var0.x, var0.y - 1)
	}
end

function var0.MarkPosition(arg0, arg1)
	arg0.markPosition = arg1
end

function var0.GetMarkPosition(arg0)
	return arg0.markPosition
end

function var0.ClearMarkPosition(arg0)
	arg0.markPosition = nil
end

function var0.GetOffset(arg0)
	if arg0:HasParent() then
		return arg0.parent:RawGetOffset()
	else
		return Vector3.zero
	end
end

function var0.UnClear(arg0, arg1)
	arg0.unClear = arg1
end

function var0.IsUnClear(arg0)
	return arg0.unClear
end

function var0.RawGetOffset(arg0)
	return Vector3.zero
end

function var0.IsDifferentDirection(arg0, arg1)
	local var0 = arg0:GetPosition()
	local var1 = (arg1.x < var0.x and arg1.y == var0.y or arg1.x == var0.x and arg1.y > var0.y) and 2 or 1

	return arg0.dir ~= var1
end

function var0.Dispose(arg0)
	arg0:ClearListeners()
end

return var0
