local var0_0 = class("CourtYardPlaceableArea", import("...CourtYardDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.sizeX = arg2_1.x
	arg0_1.sizeY = arg2_1.y
	arg0_1.minSizeX = arg2_1.z
	arg0_1.minSizeY = arg2_1.w
	arg0_1.map = {}
	arg0_1.mats = {}
	arg0_1.chars = {}

	for iter0_1 = 0, arg0_1.sizeX do
		arg0_1.map[iter0_1] = {}

		for iter1_1 = 0, arg0_1.sizeY do
			arg0_1.map[iter0_1][iter1_1] = false
		end
	end

	arg0_1.depthMap = CourtYardDepthMap.New(arg0_1.sizeX + 1, arg0_1.sizeY + 1)
end

function var0_0.GetRange(arg0_2)
	return Vector4(arg0_2.sizeX, arg0_2.sizeY, arg0_2.minSizeX, arg0_2.minSizeY)
end

function var0_0.GetRangeWithoutWall(arg0_3)
	return Vector4(arg0_3.sizeX - 1, arg0_3.sizeY - 1, arg0_3.minSizeX, arg0_3.minSizeY)
end

function var0_0.UpdateMinRange(arg0_4, arg1_4)
	arg0_4.minSizeX = arg1_4.x
	arg0_4.minSizeY = arg1_4.y
end

function var0_0.LockPosition(arg0_5, arg1_5)
	arg0_5.map[arg1_5.x][arg1_5.y] = true
end

function var0_0._ClearLockPosition(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetMarkPosition()

	if var0_6 then
		arg0_6:ClearLockPosition(var0_6)
		arg1_6:ClearMarkPosition()
	end
end

function var0_0.ClearLockPosition(arg0_7, arg1_7)
	arg0_7.map[arg1_7.x][arg1_7.y] = false
end

function var0_0.AddItem(arg0_8, arg1_8)
	assert(isa(arg1_8, CourtYardDepthItem))

	local var0_8 = arg1_8:GetDeathType()

	if var0_8 == CourtYardConst.DEPTH_TYPE_MAT then
		table.insert(arg0_8.mats, arg1_8)
		arg0_8:DispatchEvent(CourtYardEvent.ADD_MAT_ITEM, arg1_8)

		return
	end

	if var0_8 == CourtYardConst.DEPTH_TYPE_SHIP then
		arg0_8.depthMap:InsertChar(arg1_8)
		table.insert(arg0_8.chars, arg1_8)
	else
		arg0_8.depthMap:PlaceItem(arg1_8)
	end

	local var1_8 = arg1_8:GetArea()

	for iter0_8, iter1_8 in ipairs(var1_8) do
		if arg0_8.map[iter1_8.x] then
			arg0_8.map[iter1_8.x][iter1_8.y] = true
		end
	end

	arg0_8:DispatchEvent(CourtYardEvent.ADD_ITEM, arg1_8)
end

function var0_0.RemoveItem(arg0_9, arg1_9)
	assert(isa(arg1_9, CourtYardDepthItem))

	local var0_9 = arg1_9:GetDeathType()

	if var0_9 == CourtYardConst.DEPTH_TYPE_MAT then
		table.removebyvalue(arg0_9.mats, arg1_9)
		arg0_9:DispatchEvent(CourtYardEvent.REMOVE_MAT_ITEM, arg1_9)

		return
	end

	local var1_9 = 1

	if var0_9 == CourtYardConst.DEPTH_TYPE_SHIP then
		arg0_9.depthMap:RemoveChar(arg1_9)

		var1_9 = table.removebyvalue(arg0_9.chars, arg1_9)
	else
		arg0_9.depthMap:RemoveItem(arg1_9)
	end

	if var1_9 > 0 then
		local var2_9 = arg1_9:GetArea()

		for iter0_9, iter1_9 in ipairs(var2_9) do
			if arg0_9.map[iter1_9.x] then
				arg0_9.map[iter1_9.x][iter1_9.y] = false
			end
		end

		arg0_9:DispatchEvent(CourtYardEvent.REMOVE_ITEM, arg1_9)
	end
end

function var0_0.RemoveItemAndRefresh(arg0_10, arg1_10)
	local var0_10 = _.map(arg0_10.chars, function(arg0_11)
		return arg0_11
	end)

	arg0_10:RemoveItem(arg1_10)
	_.each(var0_10, function(arg0_12)
		arg0_10:RemoveItem(arg0_12)
		arg0_10:AddItem(arg0_12)
	end)
end

function var0_0.AddItemAndRefresh(arg0_13, arg1_13)
	local var0_13 = _.map(arg0_13.chars, function(arg0_14)
		return arg0_14
	end)

	arg0_13:AddItem(arg1_13)
	_.each(var0_13, function(arg0_15)
		arg0_13:RemoveItem(arg0_15)
		arg0_13:AddItem(arg0_15)
	end)
end

function var0_0.GetPositions(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in pairs(arg0_16.map) do
		for iter2_16, iter3_16 in pairs(iter1_16) do
			table.insert(var0_16, Vector2(iter0_16, iter2_16))
		end
	end

	return var0_16
end

function var0_0.IsEmptyPosition(arg0_17, arg1_17)
	if not arg0_17.map[arg1_17.x] then
		return false
	end

	return arg0_17.map[arg1_17.x][arg1_17.y] == false
end

function var0_0.InSide(arg0_18, arg1_18)
	return arg1_18.x >= arg0_18.minSizeX and arg1_18.y >= arg0_18.minSizeY and arg1_18.x <= arg0_18.sizeX and arg1_18.y <= arg0_18.sizeY
end

function var0_0.LegalPosition(arg0_19, arg1_19, arg2_19)
	return arg0_19:InSide(arg1_19) and (arg0_19:IsEmptyPosition(arg1_19) or arg2_19:GetDeathType() == CourtYardConst.DEPTH_TYPE_MAT)
end

function var0_0.GetItems(arg0_20)
	return arg0_20.depthMap.sortedItems
end

function var0_0.GetMatItems(arg0_21)
	table.sort(arg0_21.mats, function(arg0_22, arg1_22)
		local var0_22 = arg0_22:GetInitSizeCnt()
		local var1_22 = arg1_22:GetInitSizeCnt()

		if var0_22 == var1_22 then
			local var2_22 = arg0_22:GetPosition()
			local var3_22 = arg1_22:GetPosition()

			return var2_22.x + var2_22.y > var3_22.x + var3_22.y
		else
			return var1_22 < var0_22
		end
	end)

	return arg0_21.mats
end

function var0_0.GetEmptyPositions(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetPositions()

	return (_.select(var0_23, function(arg0_24)
		return arg0_23:LegalPosition(arg0_24, arg1_23)
	end))
end

function var0_0.GetRandomPosition(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetEmptyPositions(arg1_25)

	if #var0_25 > 0 then
		return var0_25[math.random(1, #var0_25)]
	end

	return nil
end

function var0_0.GetEmptyArea(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetInitSize()

	for iter0_26, iter1_26 in ipairs(var0_26) do
		local var1_26 = arg0_26:_GetEmptyArea(arg1_26, iter1_26[1], iter1_26[2])

		if var1_26 then
			return var1_26
		end
	end

	return nil
end

function var0_0._GetEmptyArea(arg0_27, arg1_27, arg2_27, arg3_27)
	local function var0_27(arg0_28)
		local var0_28 = {}

		for iter0_28 = arg0_28.x, arg0_28.x + arg2_27 - 1 do
			for iter1_28 = arg0_28.y, arg0_28.y + arg3_27 - 1 do
				table.insert(var0_28, Vector2(iter0_28, iter1_28))
			end
		end

		return var0_28
	end

	for iter0_27 = arg0_27.sizeX, arg0_27.minSizeX, -1 do
		for iter1_27 = arg0_27.sizeY, arg0_27.minSizeY, -1 do
			local var1_27 = var0_27(Vector2(iter0_27, iter1_27))

			if _.all(var1_27, function(arg0_29)
				return arg0_27:LegalPosition(arg0_29, arg1_27)
			end) then
				return Vector2(iter0_27, iter1_27)
			end
		end
	end

	return nil
end

function var0_0._GetNextPositionForMove(arg0_30, arg1_30)
	local var0_30 = arg1_30:GetAroundPositions()
	local var1_30 = _.select(var0_30, function(arg0_31)
		return arg0_30:LegalPosition(arg0_31, arg1_30)
	end)

	if #var1_30 > 0 then
		return var1_30[math.random(1, #var1_30)]
	end

	return nil
end

function var0_0.GetMapNotIncludeItem(arg0_32, arg1_32)
	local var0_32 = arg1_32:GetAreaByPosition(arg1_32:GetPosition())
	local var1_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.map) do
		var1_32[iter0_32] = {}

		for iter2_32, iter3_32 in pairs(iter1_32) do
			if table.contains(var0_32, Vector2(iter0_32, iter2_32)) then
				var1_32[iter0_32][iter2_32] = false
			else
				var1_32[iter0_32][iter2_32] = iter3_32
			end
		end
	end

	return var1_32
end

function var0_0.__GetNextPositionForMove(arg0_33, arg1_33)
	local var0_33 = arg0_33:GetMapNotIncludeItem(arg1_33)

	local function var1_33(arg0_34)
		local var0_34 = arg1_33:IsDifferentDirection(arg0_34)
		local var1_34

		if var0_34 and arg0_33:CanRotateItem(arg1_33) then
			var1_34 = arg1_33:_GetRotatePositions(arg0_34)
		else
			var1_34 = arg1_33:GetAreaByPosition(arg0_34)
		end

		return _.all(var1_34, function(arg0_35)
			return var0_33[arg0_35.x] and var0_33[arg0_35.x][arg0_35.y] == false and arg0_33:InSide(arg0_35) and arg1_33:InActivityRange(arg0_35)
		end)
	end

	local var2_33 = arg1_33:GetAroundPositions()
	local var3_33 = _.select(var2_33, var1_33)

	if #var3_33 > 0 then
		return var3_33[math.random(1, #var3_33)]
	end

	return nil
end

function var0_0.GetNextPositionForMove(arg0_36, arg1_36)
	if arg1_36:GetInitSizeCnt() == 1 then
		return arg0_36:_GetNextPositionForMove(arg1_36)
	else
		return arg0_36:__GetNextPositionForMove(arg1_36)
	end
end

function var0_0.AreaWithInfo(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	return (_.map(arg1_37:GetAreaByPosition(arg2_37), function(arg0_38)
		local var0_38 = arg4_37 or arg0_37:LegalPosition(arg0_38, arg1_37)

		return {
			flag = var0_38 and 1 or 2,
			position = arg0_38,
			offset = arg3_37
		}
	end))
end

function var0_0.CanRotateItem(arg0_39, arg1_39)
	if arg1_39:HasParent() then
		return arg1_39:GetParent():CanRotateChild(arg1_39)
	elseif isa(arg1_39, CourtYardCanPutFurniture) and arg1_39:AnyNotRotateChilds() then
		return false
	else
		local var0_39 = arg0_39:GetMapNotIncludeItem(arg1_39)

		return _.all(arg1_39:GetRotatePositions(), function(arg0_40)
			return var0_39[arg0_40.x] and var0_39[arg0_40.x][arg0_40.y] == false and arg0_39:InSide(arg0_40) and arg1_39:InActivityRange(arg0_40)
		end)
	end
end

function var0_0.GetAroundEmptyPosition(arg0_41, arg1_41)
	local var0_41 = {}
	local var1_41 = {}
	local var2_41 = arg1_41:GetPosition()

	table.insert(var0_41, Vector2(var2_41.x, var2_41.y - 1))

	while #var0_41 > 0 do
		local var3_41 = table.remove(var0_41, 1)

		if arg0_41:IsEmptyPosition(var3_41) then
			return var3_41
		end

		table.insert(var1_41, var3_41)

		for iter0_41, iter1_41 in ipairs({
			Vector2(var3_41.x, var3_41.y - 1),
			Vector2(var3_41.x - 1, var3_41.y),
			Vector2(var3_41.x + 1, var3_41.y),
			Vector2(var3_41.x, var3_41.y + 1)
		}) do
			if not table.contains(var1_41, iter1_41) and arg0_41:InSide(iter1_41) then
				table.insert(var0_41, iter1_41)
			end
		end
	end

	assert(false)
end

function var0_0.GetAroundEmptyArea(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg1_42:GetInitSize()
	local var1_42 = var0_42[1][1]
	local var2_42 = var0_42[1][2]
	local var3_42 = arg0_42:GetPositions()

	local function var4_42(arg0_43, arg1_43)
		local var0_43 = arg0_43.x + arg0_43.y - (arg1_43.x + arg1_43.y)

		return math.abs(var0_43)
	end

	local var5_42 = _.map(var3_42, function(arg0_44)
		return {
			cost = var4_42(arg0_44, arg2_42),
			value = arg0_44
		}
	end)

	table.sort(var5_42, function(arg0_45, arg1_45)
		return arg0_45.cost < arg1_45.cost
	end)

	for iter0_42, iter1_42 in ipairs(var5_42) do
		local var6_42 = iter1_42.value
		local var7_42 = arg1_42:GetAreaByPosition(var6_42)

		if _.all(var7_42, function(arg0_46)
			return arg0_42:LegalPosition(arg0_46, arg1_42)
		end) then
			return var6_42
		end
	end

	return nil
end

function var0_0.Dispose(arg0_47)
	arg0_47:ClearListeners()
end

return var0_0
