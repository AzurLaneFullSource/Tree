local var0_0 = class("IslandTheme")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or -1
	arg0_1.name = arg1_1.name or ""
	arg0_1.placedList = {}
	arg0_1.floorLayer = {}
	arg0_1.tileLayer = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.placed_data.placed_list or {}) do
		table.insert(arg0_1.placedList, {
			id = iter1_1.id,
			position = Vector2(iter1_1.x, iter1_1.y),
			rotation = Vector3(0, iter1_1.dir * 90, 0),
			configId = iter1_1.configId
		})
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.placed_data.floor_data or {}) do
		local var0_1, var1_1, var2_1, var3_1 = AgoraCalc.DecodeLayer(iter3_1)

		table.insert(arg0_1.floorLayer, {
			position = Vector2(var2_1, var3_1),
			id = var0_1,
			shapeId = var1_1
		})
	end

	for iter4_1, iter5_1 in ipairs(arg1_1.placed_data.tile_data or {}) do
		local var4_1, var5_1, var6_1, var7_1 = AgoraCalc.DecodeLayer(iter5_1)

		table.insert(arg0_1.tileLayer, {
			position = Vector2(var6_1, var7_1),
			id = var4_1,
			shapeId = var5_1
		})
	end
end

function var0_0.GetID(arg0_2)
	return arg0_2.id
end

function var0_0.SetName(arg0_3, arg1_3)
	arg0_3.name = arg1_3
end

function var0_0.GetName(arg0_4)
	return arg0_4.name
end

function var0_0.GetPlacedList(arg0_5)
	return arg0_5.placedList
end

function var0_0.GetFloorLayer(arg0_6)
	return arg0_6.floorLayer
end

function var0_0.GetTileLayer(arg0_7)
	return arg0_7.tileLayer
end

return var0_0
