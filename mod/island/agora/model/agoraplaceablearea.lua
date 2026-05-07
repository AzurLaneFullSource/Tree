local var0_0 = class("AgoraPlaceableArea", import("...IslandDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.size = arg1_1
	arg0_1.placedlist = {}
	arg0_1.maps = {
		[IslandConst.AGORA_MAP_TYPE_COMMON] = AgoraMap.New(arg1_1),
		[IslandConst.AGORA_MAP_TYPE_NEWTILE] = AgoraMap.New(arg1_1),
		[IslandConst.AGORA_MAP_TYPE_BUILDING] = AgoraBuildingMap.New()
	}
	arg0_1.floorLayer = arg0_1:GenLayer()
	arg0_1.tileLayer = arg0_1:GenLayer()
end

function var0_0.GetFloorLayer(arg0_2)
	return arg0_2.floorLayer
end

function var0_0.GetTileLayer(arg0_3)
	return arg0_3.tileLayer
end

function var0_0.GetFloorCell(arg0_4, arg1_4)
	return arg0_4.floorLayer[arg1_4.x][arg1_4.y]
end

function var0_0.GetTileCell(arg0_5, arg1_5)
	return arg0_5.tileLayer[arg1_5.x][arg1_5.y]
end

function var0_0.GenLayer(arg0_6)
	local var0_6 = {}
	local var1_6 = IslandConst.AGORA_LEVEL_2_SIZE[#IslandConst.AGORA_LEVEL_2_SIZE]
	local var2_6 = AgoraCalc.GetArea(Vector2.zero, Vector2(var1_6, var1_6))

	for iter0_6, iter1_6 in ipairs(var2_6) do
		local var3_6 = iter1_6.x
		local var4_6 = iter1_6.y

		if not var0_6[var3_6] then
			var0_6[var3_6] = {}
		end

		var0_6[var3_6][var4_6] = AgoraLayerCell.New(Vector2(var3_6, var4_6))
	end

	return var0_6
end

function var0_0.FillFloorLayer(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = (arg0_7.floorLayer[arg3_7.x] or {})[arg3_7.y]

	if not var0_7 then
		return
	end

	var0_7:Fill(arg1_7, arg2_7)
end

function var0_0.ClearFloorLayer(arg0_8, arg1_8)
	local var0_8 = (arg0_8.floorLayer[arg1_8.x] or {})[arg1_8.y]

	if not var0_8 then
		return
	end

	var0_8:Clear()
end

function var0_0.FillTileLayer(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = (arg0_9.tileLayer[arg3_9.x] or {})[arg3_9.y]

	if not var0_9 then
		return
	end

	var0_9:Fill(arg1_9, arg2_9)
end

function var0_0.ClearTileLayer(arg0_10, arg1_10)
	local var0_10 = (arg0_10.tileLayer[arg1_10.x] or {})[arg1_10.y]

	if not var0_10 then
		return
	end

	var0_10:Clear()
end

function var0_0.UpdateSize(arg0_11, arg1_11)
	arg0_11.size = arg1_11

	for iter0_11, iter1_11 in pairs(arg0_11.maps) do
		iter1_11:UpdateSize(arg1_11)
	end

	arg0_11:DispatchEvent(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_11.size)
end

function var0_0.GetSize(arg0_12)
	return arg0_12.size
end

function var0_0.GetRangeCoord(arg0_13)
	return (AgoraCalc.GetSizeCoord(arg0_13.size))
end

function var0_0.InRange(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:GetRangeCoord()

	return arg1_14 >= var0_14.x and arg1_14 <= var0_14.z and arg2_14 <= var0_14.y and arg2_14 >= var0_14.w
end

function var0_0._InRange(arg0_15, arg1_15, arg2_15, arg3_15)
	return arg2_15 >= arg1_15.x and arg2_15 <= arg1_15.z and arg3_15 <= arg1_15.y and arg3_15 >= arg1_15.w
end

function var0_0.ClampRange(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg3_16:GetSizeWithRotation()
	local var1_16 = AgoraCalc.GetSizeCoord(var0_16)
	local var2_16 = arg0_16:GetRangeCoord()
	local var3_16 = var2_16.x - var1_16.x
	local var4_16 = var2_16.z - var1_16.z
	local var5_16 = var2_16.w - var1_16.w
	local var6_16 = var2_16.y - var1_16.y

	arg1_16 = Mathf.Clamp(arg1_16, var3_16, var4_16)
	arg2_16 = Mathf.Clamp(arg2_16, var5_16, var6_16)

	return Vector2(arg1_16, arg2_16)
end

function var0_0._ClampRange(arg0_17, arg1_17, arg2_17)
	if arg0_17:_InRange(arg1_17, arg2_17.x, arg2_17.y) then
		return arg2_17
	end

	local var0_17 = Mathf.Clamp(arg2_17.x, arg1_17.x, arg1_17.z)
	local var1_17 = Mathf.Clamp(arg2_17.y, arg1_17.y, arg1_17.w)

	return Vector2(var0_17, var1_17)
end

function var0_0.IsUsing(arg0_18, arg1_18)
	return arg0_18.placedlist[arg1_18] ~= nil
end

function var0_0.GetPlacedlist(arg0_19)
	return arg0_19.placedlist
end

function var0_0.GetPlacedItem(arg0_20, arg1_20)
	return arg0_20.placedlist[arg1_20]
end

function var0_0.GetMap(arg0_21, arg1_21)
	return arg0_21.maps[arg1_21:GetMapType()]
end

function var0_0.AddItem(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetArea()
	local var1_22 = arg0_22:GetMap(arg1_22)

	for iter0_22, iter1_22 in ipairs(var0_22) do
		var1_22:UpdateMapState(iter1_22.x, iter1_22.y, false)
	end

	arg0_22.placedlist[arg1_22.id] = arg1_22
end

function var0_0.RemoveItem(arg0_23, arg1_23)
	local var0_23 = arg1_23:GetArea()
	local var1_23 = arg0_23:GetMap(arg1_23)

	for iter0_23, iter1_23 in ipairs(var0_23) do
		var1_23:UpdateMapState(iter1_23.x, iter1_23.y, true)
	end

	arg0_23.placedlist[arg1_23.id] = nil
end

function var0_0.IsEmptyArea(arg0_24, arg1_24)
	local var0_24 = arg1_24:GetArea()
	local var1_24 = arg0_24:GetMap(arg1_24)
	local var2_24 = arg0_24:GetRangeCoord()

	return _.all(var0_24, function(arg0_25)
		return arg0_24:_InRange(var2_24, arg0_25.x, arg0_25.y) and var1_24:GetMapState(arg0_25.x, arg0_25.y) == true
	end)
end

function var0_0.IsEmptyAreaInPoint(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg1_26:GenAreaByPosition(arg2_26)
	local var1_26 = arg0_26:GetMap(arg1_26)
	local var2_26 = arg0_26:GetRangeCoord()

	return _.all(var0_26, function(arg0_27)
		return arg0_26:_InRange(var2_26, arg0_27.x, arg0_27.y) and var1_26:GetMapState(arg0_27.x, arg0_27.y) == true
	end)
end

function var0_0.IsEmptyPoint(arg0_28, arg1_28, arg2_28)
	return arg0_28:GetMap(arg1_28):IsEmptyPoint(arg2_28)
end

function var0_0.GetItemInArea(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.maps[arg1_29]
	local var1_29 = _.detect(arg2_29, function(arg0_30)
		return var0_29:GetMapState(arg0_30.x, arg0_30.y) == false
	end)

	if var1_29 then
		local var2_29 = arg0_29:GetItemInPosition(arg1_29, var1_29)

		if var2_29 then
			return var2_29
		end
	end

	return nil
end

function var0_0.GetAnyMapItemInPosition(arg0_31, arg1_31)
	for iter0_31, iter1_31 in pairs(arg0_31.maps) do
		local var0_31 = arg0_31:GetItemInPosition(iter0_31, arg1_31)

		if var0_31 then
			return var0_31
		end
	end

	return nil
end

function var0_0.GetItemInPosition(arg0_32, arg1_32, arg2_32)
	if not arg0_32:InRange(arg2_32.x, arg2_32.y) then
		return nil
	end

	if arg0_32.maps[arg1_32]:GetMapState(arg2_32.x, arg2_32.y) == false then
		return arg0_32:FindItemInPosition(arg1_32, arg2_32)
	end

	return nil
end

function var0_0.FindItemInPosition(arg0_33, arg1_33, arg2_33)
	for iter0_33, iter1_33 in pairs(arg0_33.placedlist) do
		if iter1_33:GetMapType() == arg1_33 then
			local var0_33 = iter1_33:GetArea()

			for iter2_33, iter3_33 in ipairs(var0_33) do
				if iter3_33 == arg2_33 then
					return iter1_33
				end
			end
		end
	end

	return nil
end

function var0_0.FindEmptyArea4Item(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34:GetRangeCoord()
	local var1_34 = AgoraCalc.GetSizeCoord(arg2_34:GetSizeWithRotation())
	local var2_34 = var0_34.x - var1_34.x
	local var3_34 = var0_34.z - var1_34.z
	local var4_34 = var0_34.w - var1_34.w
	local var5_34 = var0_34.y - var1_34.y

	if var3_34 < var2_34 or var5_34 < var4_34 then
		return nil
	end

	local var6_34 = Mathf.Clamp(arg1_34.x, var2_34, var3_34)
	local var7_34 = Mathf.Clamp(arg1_34.y, var4_34, var5_34)
	local var8_34 = arg0_34:GetMap(arg2_34)
	local var9_34 = math.max(math.abs(var6_34 - var2_34) + math.abs(var7_34 - var4_34), math.abs(var6_34 - var2_34) + math.abs(var7_34 - var5_34), math.abs(var6_34 - var3_34) + math.abs(var7_34 - var4_34), math.abs(var6_34 - var3_34) + math.abs(var7_34 - var5_34))

	local function var10_34(arg0_35, arg1_35)
		if arg0_35 < var2_34 or arg0_35 > var3_34 or arg1_35 < var4_34 or arg1_35 > var5_34 then
			return false
		end

		return _.all(arg2_34:GenAreaByPosition(Vector2(arg0_35, arg1_35)), function(arg0_36)
			return arg0_34:_InRange(var0_34, arg0_36.x, arg0_36.y) and var8_34:GetMapState(arg0_36.x, arg0_36.y) == true
		end)
	end

	for iter0_34 = 0, var9_34 do
		for iter1_34 = -iter0_34, iter0_34 do
			local var11_34 = iter0_34 - math.abs(iter1_34)
			local var12_34 = var6_34 + iter1_34

			if var10_34(var12_34, var7_34 + var11_34) then
				return Vector2(var12_34, var7_34 + var11_34)
			end

			if var11_34 ~= 0 and var10_34(var12_34, var7_34 - var11_34) then
				return Vector2(var12_34, var7_34 - var11_34)
			end
		end
	end

	return nil
end

function var0_0.SerializePlacementData(arg0_37)
	local var0_37 = {}

	for iter0_37, iter1_37 in pairs(arg0_37:GetPlacedlist()) do
		table.insert(var0_37, iter1_37:ToPlacementData())
	end

	local var1_37 = {}

	for iter2_37, iter3_37 in pairs(arg0_37:GetFloorLayer()) do
		for iter4_37, iter5_37 in pairs(iter3_37) do
			if not iter5_37:IsEmpty() then
				table.insert(var1_37, iter5_37:ToPlacementData())
			end
		end
	end

	local var2_37 = {}

	for iter6_37, iter7_37 in pairs(arg0_37:GetTileLayer()) do
		for iter8_37, iter9_37 in pairs(iter7_37) do
			if not iter9_37:IsEmpty() then
				table.insert(var2_37, iter9_37:ToPlacementData())
			end
		end
	end

	return var0_37, var1_37, var2_37
end

function var0_0.ToString(arg0_38)
	local var0_38, var1_38, var2_38 = arg0_38:SerializePlacementData()
	local var3_38 = AgoraCalc.EncodeLayer(var1_38)
	local var4_38 = AgoraCalc.EncodeLayer(var2_38)
	local var5_38 = _.map(var0_38, function(arg0_39)
		return string.format("\t\t\t{id = %s,x = %s,y = %s,dir = %s,configId = %s},", arg0_39.id, arg0_39.x, arg0_39.y, arg0_39.dir, arg0_39.configId)
	end)
	local var6_38 = _.map(var3_38, function(arg0_40)
		return "\t\t\t" .. tostring(arg0_40)
	end)
	local var7_38 = _.map(var4_38, function(arg0_41)
		return "\t\t\t" .. tostring(arg0_41)
	end)
	local var8_38 = {}

	table.insert(var8_38, "return {")
	table.insert(var8_38, "\tid = 0,")
	table.insert(var8_38, "\tname = '',")
	table.insert(var8_38, "\tplaced_data = {")
	table.insert(var8_38, "\t\tplaced_list = {")
	table.insert(var8_38, table.concat(var5_38, "\n"))
	table.insert(var8_38, "\t\t},")
	table.insert(var8_38, "\t\tfloor_data = {")
	table.insert(var8_38, table.concat(var6_38, ",\n"))
	table.insert(var8_38, "\t\t},")
	table.insert(var8_38, "\t\ttile_data = {")
	table.insert(var8_38, table.concat(var7_38, ",\n"))
	table.insert(var8_38, "\t\t},")
	table.insert(var8_38, "\t}")
	table.insert(var8_38, "}")

	return table.concat(var8_38, "\n")
end

return var0_0
