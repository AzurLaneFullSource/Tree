local var0_0 = class("AgoraLayerCell")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.position = arg1_1
	arg0_1.id = 0
	arg0_1.shapeId = -1
end

function var0_0.Fill(arg0_2, arg1_2, arg2_2)
	arg0_2.id = arg1_2
	arg0_2.shapeId = arg2_2
end

function var0_0.IsEmpty(arg0_3)
	return arg0_3.id == 0 or arg0_3.shapeId < 0
end

function var0_0.IsSameValue(arg0_4, arg1_4, arg2_4)
	return arg0_4.id == arg1_4 and arg0_4.shapeId == arg2_4
end

function var0_0.GetPosition(arg0_5)
	return arg0_5.position
end

function var0_0.GetShapeId(arg0_6)
	return arg0_6.shapeId
end

function var0_0.GetID(arg0_7)
	return arg0_7.id
end

function var0_0.GetModel(arg0_8)
	if arg0_8:IsEmpty() then
		return ""
	end

	local var0_8 = math.floor(arg0_8.id / 100)

	return pg.island_furniture_template[var0_8].model
end

function var0_0.Clear(arg0_9)
	arg0_9.id = 0
	arg0_9.shapeId = -1
end

function var0_0.ToPlacementData(arg0_10)
	local var0_10 = arg0_10:GetPosition()

	return {
		x = var0_10.x,
		y = var0_10.y,
		id = arg0_10.id,
		shapeId = arg0_10:GetShapeId()
	}
end

function var0_0.IsSame(arg0_11, arg1_11)
	return arg0_11.id == arg1_11.id and arg0_11.shapeId == arg1_11.shapeId
end

return var0_0
