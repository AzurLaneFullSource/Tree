local var0_0 = class("AgoraTheme", import(".AgoraBaseTheme"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	arg0_1:Flush(arg1_1, arg2_1)
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2)
	for iter0_2, iter1_2 in ipairs(arg1_2:GetPlacedList()) do
		local var0_2 = arg2_2[iter1_2.id]

		if var0_2 then
			local var1_2 = Clone(var0_2)

			var1_2:FlushDataFromPlacementData(iter1_2)
			table.insert(arg0_2.placedlist, var1_2)
		end
	end

	for iter2_2, iter3_2 in ipairs(arg1_2:GetFloorLayer()) do
		local var2_2 = AgoraLayerCell.New(iter3_2.position)

		var2_2:Fill(iter3_2.id, iter3_2.shapeId)
		table.insert(arg0_2.floorData, var2_2)
	end

	for iter4_2, iter5_2 in ipairs(arg1_2:GetTileLayer()) do
		local var3_2 = AgoraLayerCell.New(iter5_2.position)

		var3_2:Fill(iter5_2.id, iter5_2.shapeId)
		table.insert(arg0_2.tileData, var3_2)
	end
end

return var0_0
