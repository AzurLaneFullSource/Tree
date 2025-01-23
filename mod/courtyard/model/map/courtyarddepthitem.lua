local var0_0 = class("CourtYardDepthItem", import("...CourtYardDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg0_1:GetDeathType()

	arg0_1.ob = {
		id = arg2_1,
		type = var0_1
	}
	arg0_1.initSizeX = arg3_1 or 0
	arg0_1.initSizeY = arg4_1 or 0
	arg0_1.sizeX = arg0_1.initSizeX
	arg0_1.sizeY = arg0_1.initSizeY

	assert(arg0_1.sizeX > 0 and arg0_1.sizeY > 0, "size 必须大于0============>" .. arg2_1)

	arg0_1.posX = 0
	arg0_1.posY = 0
	arg0_1.maxX = 0
	arg0_1.maxY = 0
	arg0_1.posZ = 0
	arg0_1.dir = 1
	arg0_1.sortedFlag = true
	arg0_1.dirty = false
	arg0_1.parent = nil
	arg0_1.opFlag = false
	arg0_1.area = {}
end

function var0_0.GetInitSize(arg0_2)
	return {
		{
			arg0_2.sizeX,
			arg0_2.sizeY
		}
	}
end

function var0_0.GetInitSizeCnt(arg0_3)
	local var0_3 = arg0_3:GetInitSize()[1]

	return var0_3[1] * var0_3[2]
end

function var0_0.GetObjType(arg0_4)
	assert(false)
end

function var0_0.GetOffset(arg0_5)
	assert(false)
end

function var0_0.UpdateOpFlag(arg0_6, arg1_6)
	arg0_6.opFlag = arg1_6
end

function var0_0.GetOpFlag(arg0_7)
	return arg0_7.opFlag
end

function var0_0.InActivityRange(arg0_8, arg1_8)
	return true
end

function var0_0.GetDeathType(arg0_9)
	assert(false)
end

function var0_0.SetPosition(arg0_10, arg1_10)
	arg0_10:SetDirty()
	arg0_10:SetPos(arg1_10.x + 1, arg1_10.y + 1)
	arg0_10:ReGenArea()
end

function var0_0.SetDir(arg0_11, arg1_11)
	arg0_11:SetDirty()

	if arg1_11 == 2 then
		arg0_11.sizeX = arg0_11.initSizeY
		arg0_11.sizeY = arg0_11.initSizeX
	else
		arg0_11.sizeX = arg0_11.initSizeX
		arg0_11.sizeY = arg0_11.initSizeY
	end

	arg0_11.dir = arg1_11

	arg0_11:SetPosition(arg0_11:GetPosition())
end

function var0_0.GetDirection(arg0_12)
	return arg0_12.dir
end

function var0_0.GetNormalDirection(arg0_13)
	if arg0_13.dir == 1 then
		return 1
	end

	if arg0_13.dir == 2 then
		return -1
	end
end

function var0_0.ReGenArea(arg0_14)
	table.clear(arg0_14.area)

	local var0_14 = arg0_14:GetPosition()

	arg0_14.area = arg0_14:GetAreaByPosition(var0_14)
end

function var0_0.GetPosition(arg0_15)
	return Vector2(arg0_15.posX - 1, arg0_15.posY - 1)
end

function var0_0.SetPos(arg0_16, arg1_16, arg2_16)
	arg0_16.posX = arg1_16
	arg0_16.posY = arg2_16
	arg0_16.maxX = arg1_16 + arg0_16.sizeX - 1
	arg0_16.maxY = arg2_16 + arg0_16.sizeY - 1
end

function var0_0.SetDepth(arg0_17, arg1_17)
	arg0_17.posZ = arg1_17
end

function var0_0.GetArea(arg0_18)
	return arg0_18.area
end

function var0_0.GetAreaByPosition(arg0_19, arg1_19)
	local var0_19 = {}

	for iter0_19 = arg1_19.x, arg1_19.x + arg0_19.sizeX - 1 do
		for iter1_19 = arg1_19.y, arg1_19.y + arg0_19.sizeY - 1 do
			table.insert(var0_19, Vector2(iter0_19, iter1_19))
		end
	end

	return var0_19
end

function var0_0._GetRotatePositions(arg0_20, arg1_20)
	local var0_20 = arg0_20.sizeY
	local var1_20 = arg0_20.sizeX
	local var2_20 = {}

	for iter0_20 = arg1_20.x, arg1_20.x + var0_20 - 1 do
		for iter1_20 = arg1_20.y, arg1_20.y + var1_20 - 1 do
			table.insert(var2_20, Vector2(iter0_20, iter1_20))
		end
	end

	return var2_20
end

function var0_0.GetRotatePositions(arg0_21)
	local var0_21 = arg0_21:GetPosition()

	return arg0_21:_GetRotatePositions(var0_21)
end

function var0_0.SetDirty(arg0_22)
	arg0_22.dirty = true
end

function var0_0.UnDirty(arg0_23)
	arg0_23.dirty = false
end

function var0_0.IsDirty(arg0_24)
	return arg0_24.dirty
end

function var0_0.Interaction(arg0_25, arg1_25)
	return
end

function var0_0.ClearInteraction(arg0_26, arg1_26)
	return
end

function var0_0.SetParent(arg0_27, arg1_27)
	arg0_27:SetDirty()

	arg0_27.parent = arg1_27
end

function var0_0.HasParent(arg0_28)
	return arg0_28.parent ~= nil
end

function var0_0.GetParent(arg0_29)
	return arg0_29.parent
end

function var0_0.GetAroundPositions(arg0_30)
	local var0_30 = arg0_30:GetPosition()

	return {
		Vector2(var0_30.x + 1, var0_30.y),
		Vector2(var0_30.x, var0_30.y + 1),
		Vector2(var0_30.x - 1, var0_30.y),
		Vector2(var0_30.x, var0_30.y - 1)
	}
end

function var0_0.MarkPosition(arg0_31, arg1_31)
	arg0_31.markPosition = arg1_31
end

function var0_0.GetMarkPosition(arg0_32)
	return arg0_32.markPosition
end

function var0_0.ClearMarkPosition(arg0_33)
	arg0_33.markPosition = nil
end

function var0_0.GetOffset(arg0_34)
	if arg0_34:HasParent() then
		return arg0_34.parent:RawGetOffset()
	else
		return Vector3.zero
	end
end

function var0_0.UnClear(arg0_35, arg1_35)
	arg0_35.unClear = arg1_35
end

function var0_0.IsUnClear(arg0_36)
	return arg0_36.unClear
end

function var0_0.RawGetOffset(arg0_37)
	return Vector3.zero
end

function var0_0.IsDifferentDirection(arg0_38, arg1_38)
	local var0_38 = arg0_38:GetPosition()
	local var1_38 = (arg1_38.x < var0_38.x and arg1_38.y == var0_38.y or arg1_38.x == var0_38.x and arg1_38.y > var0_38.y) and 2 or 1

	return arg0_38.dir ~= var1_38
end

function var0_0.Dispose(arg0_39)
	arg0_39:ClearListeners()
end

return var0_0
