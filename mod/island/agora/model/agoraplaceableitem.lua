local var0_0 = class("AgoraPlaceableItem", import("...IslandDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.id = arg1_1.id
	arg0_1.position = Vector2.zero
	arg0_1.rotation = Vector3.zero
	arg0_1.size = arg2_1 or Vector2.one
	arg0_1.area = arg0_1:GenArea()
end

function var0_0.IsSame(arg0_2, arg1_2)
	return arg0_2.position == arg1_2.position and arg0_2.rotation == arg1_2.rotation
end

function var0_0.Clear(arg0_3)
	arg0_3.position = Vector2.zero
	arg0_3.rotation = Vector3.zero
end

function var0_0.GetSize(arg0_4)
	return arg0_4.size
end

function var0_0.GetSizeWithRotation(arg0_5)
	if arg0_5:IsForward() then
		return arg0_5:GetSize()
	else
		return Vector2(arg0_5.size.y, arg0_5.size.x)
	end
end

function var0_0.GetRotation(arg0_6)
	return arg0_6.rotation
end

function var0_0.UpdateRotation(arg0_7, arg1_7)
	arg0_7.rotation = arg1_7

	arg0_7:DispatchEvent(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, arg0_7.rotation)
	arg0_7:UpdatePosition(arg0_7.position)
end

function var0_0.UpdatePosition(arg0_8, arg1_8)
	arg0_8.position = arg1_8
	arg0_8.area = arg0_8:ReGenArea(true)

	arg0_8:DispatchEvent(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, arg0_8.area)
end

function var0_0.GetPosition(arg0_9)
	return arg0_9.position
end

function var0_0.IsSquareSize(arg0_10)
	return arg0_10.size.x == arg0_10.size.y
end

function var0_0.ReGenArea(arg0_11, arg1_11)
	if arg0_11:IsSquareSize() and not arg1_11 then
		return arg0_11:GetArea()
	end

	return arg0_11:GenArea()
end

function var0_0.IsForward(arg0_12)
	return arg0_12.rotation.y == 0 or arg0_12.rotation.y == 180
end

function var0_0.Rotation(arg0_13)
	local var0_13 = arg0_13.rotation.y + 90

	if var0_13 > 270 then
		var0_13 = 0
	end

	arg0_13:UpdateRotation(Vector3(0, var0_13, 0))
end

function var0_0.GenArea(arg0_14)
	return arg0_14:GenAreaByPosition(arg0_14.position)
end

function var0_0.GenAreaByPosition(arg0_15, arg1_15)
	if arg0_15:IsForward() then
		return AgoraCalc.GetArea(arg1_15, arg0_15.size)
	else
		return AgoraCalc.GetArea(arg1_15, Vector2(arg0_15.size.y, arg0_15.size.x))
	end
end

function var0_0.GetArea(arg0_16)
	return arg0_16.area
end

function var0_0.GetResPath(arg0_17)
	assert(false)
end

function var0_0.ToPlacementData(arg0_18)
	return IslandPlacementData.New({
		id = arg0_18.id,
		x = arg0_18.position.x,
		y = arg0_18.position.y,
		dir = arg0_18.rotation.y / 90
	})
end

function var0_0.FlushDataFromPlacementData(arg0_19, arg1_19)
	arg0_19:UpdatePosition(arg1_19:GetPosition())
	arg0_19:UpdateRotation(arg1_19:GetRotation())
end

return var0_0
