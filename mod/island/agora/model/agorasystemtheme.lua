local var0_0 = class("AgoraSystemTheme", import(".AgoraBaseTheme"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	arg0_1:Flush(arg1_1)
end

function var0_0.Owned(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.placedlist) do
		if not arg1_2[iter1_2.id] then
			return false
		end
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.floorData) do
		if not arg1_2[iter3_2.id] then
			return false
		end
	end

	for iter4_2, iter5_2 in ipairs(arg0_2.tileData) do
		if not arg1_2[iter5_2.id] then
			return false
		end
	end

	return true
end

function var0_0.Flush(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3:GetPlacedList()) do
		local var0_3 = AgoraFurniture.New({
			id = iter1_3.id,
			configId = iter1_3.configId
		})

		var0_3:FlushDataFromPlacementData(iter1_3)
		table.insert(arg0_3.placedlist, var0_3)
	end

	for iter2_3, iter3_3 in ipairs(arg1_3:GetFloorLayer()) do
		local var1_3 = AgoraLayerCell.New(iter3_3.position)

		var1_3:Fill(iter3_3.id, iter3_3.shapeId)
		table.insert(arg0_3.floorData, var1_3)
	end

	for iter4_3, iter5_3 in ipairs(arg1_3:GetTileLayer()) do
		local var2_3 = AgoraLayerCell.New(iter5_3.position)

		var2_3:Fill(iter5_3.id, iter5_3.shapeId)
		table.insert(arg0_3.tileData, var2_3)
	end
end

function var0_0.Belong(arg0_4, arg1_4)
	local var0_4 = pg.island_furniture_theme[arg0_4.id].furniture
	local var1_4

	if type(var0_4) == "table" then
		var1_4 = var0_4
	else
		var1_4 = {}
	end

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if iter1_4 == arg1_4.configId then
			return true
		end
	end

	return false
end

return var0_0
