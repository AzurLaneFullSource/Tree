local var0_0 = class("AgoraPlaceableArea", import("...IslandDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.size = arg1_1
	arg0_1.placedlist = arg2_1
	arg0_1.map = arg0_1:GenMap()
end

function var0_0.GetSize(arg0_2)
	return arg0_2.size
end

function var0_0.UpdateSize(arg0_3, arg1_3)
	arg0_3.size = arg1_3

	local var0_3 = arg0_3:GenMap()
	local var1_3 = arg0_3.map

	for iter0_3, iter1_3 in pairs(var0_3) do
		for iter2_3, iter3_3 in pairs(iter1_3) do
			if var1_3[iter0_3] ~= nil and var1_3[iter0_3][iter2_3] ~= nil then
				var0_3[iter0_3][iter2_3] = var1_3[iter0_3][iter2_3]
			end
		end
	end

	arg0_3.map = var0_3

	arg0_3:DispatchEvent(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_3.size)
end

function var0_0.GetRangeCoord(arg0_4)
	return (AgoraCalc.GetSizeCoord(arg0_4.size))
end

function var0_0.InRange(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GetRangeCoord()

	return arg1_5 >= var0_5.x and arg1_5 <= var0_5.z and arg2_5 <= var0_5.y and arg2_5 >= var0_5.w
end

function var0_0.ClampRange(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg3_6:GetSizeWithRotation()
	local var1_6 = AgoraCalc.GetSizeCoord(var0_6)
	local var2_6 = arg0_6:GetRangeCoord()
	local var3_6 = var2_6.x - var1_6.x
	local var4_6 = var2_6.z - var1_6.z
	local var5_6 = var2_6.w - var1_6.w
	local var6_6 = var2_6.y - var1_6.y

	arg1_6 = Mathf.Clamp(arg1_6, var3_6, var4_6)
	arg2_6 = Mathf.Clamp(arg2_6, var5_6, var6_6)

	return Vector2(arg1_6, arg2_6)
end

function var0_0.GenMap(arg0_7)
	local var0_7 = {}
	local var1_7 = AgoraCalc.GetArea(Vector2.zero, arg0_7.size)

	for iter0_7, iter1_7 in ipairs(var1_7) do
		local var2_7 = iter1_7.x
		local var3_7 = iter1_7.y

		if not var0_7[var2_7] then
			var0_7[var2_7] = {}
		end

		var0_7[var2_7][var3_7] = true
	end

	return var0_7
end

function var0_0.IsUsing(arg0_8, arg1_8)
	return arg0_8.placedlist[arg1_8] ~= nil
end

function var0_0.GetPlacedlist(arg0_9)
	return arg0_9.placedlist
end

function var0_0.AddItem(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetArea()

	for iter0_10, iter1_10 in ipairs(var0_10) do
		arg0_10:UpdateMapState(iter1_10.x, iter1_10.y, false)
	end

	arg0_10.placedlist[arg1_10.id] = arg1_10
end

function var0_0.RemoveItem(arg0_11, arg1_11)
	local var0_11 = arg1_11:GetArea()

	for iter0_11, iter1_11 in ipairs(var0_11) do
		arg0_11:UpdateMapState(iter1_11.x, iter1_11.y, true)
	end

	arg0_11.placedlist[arg1_11.id] = nil
end

function var0_0.GetPlacedItem(arg0_12, arg1_12)
	return arg0_12.placedlist[arg1_12]
end

function var0_0.IsEmptyArea(arg0_13, arg1_13)
	return _.all(arg1_13, function(arg0_14)
		return arg0_13:InRange(arg0_14.x, arg0_14.y) and arg0_13.map[arg0_14.x][arg0_14.y] == true
	end)
end

function var0_0.GetItemInArea(arg0_15, arg1_15)
	local var0_15 = _.detect(arg1_15, function(arg0_16)
		return arg0_15.map[arg0_16.x][arg0_16.y] == false
	end)

	if var0_15 then
		local var1_15 = arg0_15:GetItemInPosition(var0_15)

		if var1_15 then
			return var1_15
		end
	end

	return nil
end

function var0_0.FindEmptyArea4Item(arg0_17, arg1_17, arg2_17)
	local var0_17 = {}
	local var1_17 = {}

	table.insert(var0_17, arg1_17)

	while #var0_17 > 0 do
		local var2_17 = table.remove(var0_17, 1)
		local var3_17 = arg2_17:GenAreaByPosition(var2_17)

		if arg0_17:IsEmptyArea(var3_17) then
			return var2_17
		end

		table.insert(var1_17, var2_17)

		for iter0_17, iter1_17 in ipairs({
			Vector2(var2_17.x, var2_17.y - 1),
			Vector2(var2_17.x - 1, var2_17.y),
			Vector2(var2_17.x + 1, var2_17.y),
			Vector2(var2_17.x, var2_17.y + 1)
		}) do
			if not table.contains(var1_17, iter1_17) and arg0_17:InRange(iter1_17.x, iter1_17.y) then
				table.insert(var0_17, iter1_17)
			end
		end
	end
end

function var0_0.GetItemInPosition(arg0_18, arg1_18)
	if not arg0_18:InRange(arg1_18.x, arg1_18.y) then
		return nil
	end

	if arg0_18.map[arg1_18.x][arg1_18.y] == false then
		return arg0_18:FindItemInPosition(arg1_18)
	end

	return nil
end

function var0_0.FindItemInPosition(arg0_19, arg1_19)
	for iter0_19, iter1_19 in pairs(arg0_19.placedlist) do
		local var0_19 = iter1_19:GetArea()

		for iter2_19, iter3_19 in ipairs(var0_19) do
			if iter3_19 == arg1_19 then
				return iter1_19
			end
		end
	end

	return nil
end

function var0_0.UpdateMapState(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20.map[arg1_20][arg2_20] = arg3_20

	arg0_20:DispatchEvent(ISLAND_AGORA_EVT.MAP_STATE_UPDATE, {
		position = Vector2(arg1_20, arg2_20),
		flag = arg3_20
	})
end

return var0_0
