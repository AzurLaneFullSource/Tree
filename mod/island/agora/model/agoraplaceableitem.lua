local var0_0 = class("AgoraPlaceableItem", import("...IslandDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.id = arg1_1.id
	arg0_1.position = Vector2.zero
	arg0_1.rotation = Vector3.zero
	arg0_1.size = arg2_1 or Vector2.one
	arg0_1.area = arg0_1:GenArea()
end

function var0_0.GetMapType(arg0_2)
	return IslandConst.AGORA_MAP_TYPE_COMMON
end

function var0_0.IsSame(arg0_3, arg1_3)
	return arg0_3.position == arg1_3.position and arg0_3.rotation == arg1_3.rotation
end

function var0_0.Clear(arg0_4)
	arg0_4.position = Vector2.zero
	arg0_4.rotation = Vector3.zero
end

function var0_0.GetSize(arg0_5)
	return arg0_5.size
end

function var0_0.GetSizeWithRotation(arg0_6)
	if arg0_6:IsForward() then
		return arg0_6:GetSize()
	else
		return Vector2(arg0_6.size.y, arg0_6.size.x)
	end
end

function var0_0.GetRotation(arg0_7)
	return arg0_7.rotation
end

function var0_0.UpdateRotation(arg0_8, arg1_8)
	arg0_8.rotation = arg1_8

	arg0_8:DispatchEvent(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, arg0_8.rotation)
	arg0_8:UpdatePosition(arg0_8.position)
end

function var0_0.UpdatePosition(arg0_9, arg1_9)
	arg0_9.position = arg1_9
	arg0_9.area = arg0_9:ReGenArea(true)

	arg0_9:DispatchEvent(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, arg0_9.area)
end

function var0_0.GetPosition(arg0_10)
	return arg0_10.position
end

function var0_0.IsSquareSize(arg0_11)
	return arg0_11.size.x == arg0_11.size.y
end

function var0_0.ReGenArea(arg0_12, arg1_12)
	if arg0_12:IsSquareSize() and not arg1_12 then
		return arg0_12:GetArea()
	end

	return arg0_12:GenArea()
end

function var0_0.IsForward(arg0_13)
	return arg0_13.rotation.y == 0 or arg0_13.rotation.y == 180
end

function var0_0.Rotation(arg0_14)
	local var0_14 = arg0_14.rotation.y + 90

	if var0_14 > 270 then
		var0_14 = 0
	end

	arg0_14:UpdateRotation(Vector3(0, var0_14, 0))
end

function var0_0.GenArea(arg0_15)
	return arg0_15:GenAreaByPosition(arg0_15.position)
end

function var0_0.GenAreaByPosition(arg0_16, arg1_16)
	if arg0_16:IsForward() then
		return AgoraCalc.GetArea(arg1_16, arg0_16.size)
	else
		return AgoraCalc.GetArea(arg1_16, Vector2(arg0_16.size.y, arg0_16.size.x))
	end
end

function var0_0.GetNeighborPoints(arg0_17)
	local var0_17

	if arg0_17:IsForward() then
		var0_17 = AgoraCalc.GetSizeCoord(arg0_17.size)
	else
		var0_17 = AgoraCalc.GetSizeCoord(Vector2(arg0_17.size.y, arg0_17.size.x))
	end

	local var1_17 = var0_17.x
	local var2_17 = var0_17.y
	local var3_17 = var0_17.z
	local var4_17 = var0_17.w

	return {
		arg0_17.position + Vector2(0, var2_17 + 1),
		arg0_17.position + Vector2(0, var4_17 - 1),
		arg0_17.position + Vector2(var1_17 - 1, 0),
		arg0_17.position + Vector2(var3_17 + 1, 0)
	}
end

function var0_0.GetArea(arg0_18)
	return arg0_18.area
end

function var0_0.GetResPath(arg0_19)
	assert(false)
end

function var0_0.ToPlacementData(arg0_20)
	return {
		id = arg0_20.id,
		x = arg0_20.position.x,
		y = arg0_20.position.y,
		dir = arg0_20.rotation.y / 90
	}
end

function var0_0.FlushDataFromPlacementData(arg0_21, arg1_21)
	arg0_21:UpdatePosition(arg1_21.position)
	arg0_21:UpdateRotation(arg1_21.rotation)
end

return var0_0
