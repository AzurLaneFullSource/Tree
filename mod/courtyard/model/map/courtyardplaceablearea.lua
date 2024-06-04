local var0 = class("CourtYardPlaceableArea", import("...CourtYardDispatcher"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1)

	arg0.sizeX = arg2.x
	arg0.sizeY = arg2.y
	arg0.minSizeX = arg2.z
	arg0.minSizeY = arg2.w
	arg0.map = {}
	arg0.mats = {}
	arg0.chars = {}

	for iter0 = 0, arg0.sizeX do
		arg0.map[iter0] = {}

		for iter1 = 0, arg0.sizeY do
			arg0.map[iter0][iter1] = false
		end
	end

	arg0.depthMap = CourtYardDepthMap.New(arg0.sizeX + 1, arg0.sizeY + 1)
end

function var0.GetRange(arg0)
	return Vector4(arg0.sizeX, arg0.sizeY, arg0.minSizeX, arg0.minSizeY)
end

function var0.GetRangeWithoutWall(arg0)
	return Vector4(arg0.sizeX - 1, arg0.sizeY - 1, arg0.minSizeX, arg0.minSizeY)
end

function var0.UpdateMinRange(arg0, arg1)
	arg0.minSizeX = arg1.x
	arg0.minSizeY = arg1.y
end

function var0.LockPosition(arg0, arg1)
	arg0.map[arg1.x][arg1.y] = true
end

function var0._ClearLockPosition(arg0, arg1)
	local var0 = arg1:GetMarkPosition()

	if var0 then
		arg0:ClearLockPosition(var0)
		arg1:ClearMarkPosition()
	end
end

function var0.ClearLockPosition(arg0, arg1)
	arg0.map[arg1.x][arg1.y] = false
end

function var0.AddItem(arg0, arg1)
	assert(isa(arg1, CourtYardDepthItem))

	local var0 = arg1:GetDeathType()

	if var0 == CourtYardConst.DEPTH_TYPE_MAT then
		table.insert(arg0.mats, arg1)
		arg0:DispatchEvent(CourtYardEvent.ADD_MAT_ITEM, arg1)

		return
	end

	if var0 == CourtYardConst.DEPTH_TYPE_SHIP then
		arg0.depthMap:InsertChar(arg1)
		table.insert(arg0.chars, arg1)
	else
		arg0.depthMap:PlaceItem(arg1)
	end

	local var1 = arg1:GetArea()

	for iter0, iter1 in ipairs(var1) do
		if arg0.map[iter1.x] then
			arg0.map[iter1.x][iter1.y] = true
		end
	end

	arg0:DispatchEvent(CourtYardEvent.ADD_ITEM, arg1)
end

function var0.RemoveItem(arg0, arg1)
	assert(isa(arg1, CourtYardDepthItem))

	local var0 = arg1:GetDeathType()

	if var0 == CourtYardConst.DEPTH_TYPE_MAT then
		table.removebyvalue(arg0.mats, arg1)
		arg0:DispatchEvent(CourtYardEvent.REMOVE_MAT_ITEM, arg1)

		return
	end

	local var1 = 1

	if var0 == CourtYardConst.DEPTH_TYPE_SHIP then
		arg0.depthMap:RemoveChar(arg1)

		var1 = table.removebyvalue(arg0.chars, arg1)
	else
		arg0.depthMap:RemoveItem(arg1)
	end

	if var1 > 0 then
		local var2 = arg1:GetArea()

		for iter0, iter1 in ipairs(var2) do
			if arg0.map[iter1.x] then
				arg0.map[iter1.x][iter1.y] = false
			end
		end

		arg0:DispatchEvent(CourtYardEvent.REMOVE_ITEM, arg1)
	end
end

function var0.RemoveItemAndRefresh(arg0, arg1)
	local var0 = _.map(arg0.chars, function(arg0)
		return arg0
	end)

	arg0:RemoveItem(arg1)
	_.each(var0, function(arg0)
		arg0:RemoveItem(arg0)
		arg0:AddItem(arg0)
	end)
end

function var0.AddItemAndRefresh(arg0, arg1)
	local var0 = _.map(arg0.chars, function(arg0)
		return arg0
	end)

	arg0:AddItem(arg1)
	_.each(var0, function(arg0)
		arg0:RemoveItem(arg0)
		arg0:AddItem(arg0)
	end)
end

function var0.GetPositions(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.map) do
		for iter2, iter3 in pairs(iter1) do
			table.insert(var0, Vector2(iter0, iter2))
		end
	end

	return var0
end

function var0.IsEmptyPosition(arg0, arg1)
	if not arg0.map[arg1.x] then
		return false
	end

	return arg0.map[arg1.x][arg1.y] == false
end

function var0.InSide(arg0, arg1)
	return arg1.x >= arg0.minSizeX and arg1.y >= arg0.minSizeY and arg1.x <= arg0.sizeX and arg1.y <= arg0.sizeY
end

function var0.LegalPosition(arg0, arg1, arg2)
	return arg0:InSide(arg1) and (arg0:IsEmptyPosition(arg1) or arg2:GetDeathType() == CourtYardConst.DEPTH_TYPE_MAT)
end

function var0.GetItems(arg0)
	return arg0.depthMap.sortedItems
end

function var0.GetMatItems(arg0)
	table.sort(arg0.mats, function(arg0, arg1)
		local var0 = arg0:GetInitSizeCnt()
		local var1 = arg1:GetInitSizeCnt()

		if var0 == var1 then
			local var2 = arg0:GetPosition()
			local var3 = arg1:GetPosition()

			return var2.x + var2.y > var3.x + var3.y
		else
			return var1 < var0
		end
	end)

	return arg0.mats
end

function var0.GetEmptyPositions(arg0, arg1)
	local var0 = arg0:GetPositions()

	return (_.select(var0, function(arg0)
		return arg0:LegalPosition(arg0, arg1)
	end))
end

function var0.GetRandomPosition(arg0, arg1)
	local var0 = arg0:GetEmptyPositions(arg1)

	if #var0 > 0 then
		return var0[math.random(1, #var0)]
	end

	return nil
end

function var0.GetEmptyArea(arg0, arg1)
	local var0 = arg1:GetInitSize()

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0:_GetEmptyArea(arg1, iter1[1], iter1[2])

		if var1 then
			return var1
		end
	end

	return nil
end

function var0._GetEmptyArea(arg0, arg1, arg2, arg3)
	local function var0(arg0)
		local var0 = {}

		for iter0 = arg0.x, arg0.x + arg2 - 1 do
			for iter1 = arg0.y, arg0.y + arg3 - 1 do
				table.insert(var0, Vector2(iter0, iter1))
			end
		end

		return var0
	end

	for iter0 = arg0.sizeX, arg0.minSizeX, -1 do
		for iter1 = arg0.sizeY, arg0.minSizeY, -1 do
			local var1 = var0(Vector2(iter0, iter1))

			if _.all(var1, function(arg0)
				return arg0:LegalPosition(arg0, arg1)
			end) then
				return Vector2(iter0, iter1)
			end
		end
	end

	return nil
end

function var0._GetNextPositionForMove(arg0, arg1)
	local var0 = arg1:GetAroundPositions()
	local var1 = _.select(var0, function(arg0)
		return arg0:LegalPosition(arg0, arg1)
	end)

	if #var1 > 0 then
		return var1[math.random(1, #var1)]
	end

	return nil
end

function var0.GetMapNotIncludeItem(arg0, arg1)
	local var0 = arg1:GetAreaByPosition(arg1:GetPosition())
	local var1 = {}

	for iter0, iter1 in pairs(arg0.map) do
		var1[iter0] = {}

		for iter2, iter3 in pairs(iter1) do
			if table.contains(var0, Vector2(iter0, iter2)) then
				var1[iter0][iter2] = false
			else
				var1[iter0][iter2] = iter3
			end
		end
	end

	return var1
end

function var0.__GetNextPositionForMove(arg0, arg1)
	local var0 = arg0:GetMapNotIncludeItem(arg1)

	local function var1(arg0)
		local var0 = arg1:IsDifferentDirection(arg0)
		local var1

		if var0 and arg0:CanRotateItem(arg1) then
			var1 = arg1:_GetRotatePositions(arg0)
		else
			var1 = arg1:GetAreaByPosition(arg0)
		end

		return _.all(var1, function(arg0)
			return var0[arg0.x] and var0[arg0.x][arg0.y] == false and arg0:InSide(arg0) and arg1:InActivityRange(arg0)
		end)
	end

	local var2 = arg1:GetAroundPositions()
	local var3 = _.select(var2, var1)

	if #var3 > 0 then
		return var3[math.random(1, #var3)]
	end

	return nil
end

function var0.GetNextPositionForMove(arg0, arg1)
	if arg1:GetInitSizeCnt() == 1 then
		return arg0:_GetNextPositionForMove(arg1)
	else
		return arg0:__GetNextPositionForMove(arg1)
	end
end

function var0.AreaWithInfo(arg0, arg1, arg2, arg3, arg4)
	return (_.map(arg1:GetAreaByPosition(arg2), function(arg0)
		local var0 = arg4 or arg0:LegalPosition(arg0, arg1)

		return {
			flag = var0 and 1 or 2,
			position = arg0,
			offset = arg3
		}
	end))
end

function var0.CanRotateItem(arg0, arg1)
	if arg1:HasParent() then
		return arg1:GetParent():CanRotateChild(arg1)
	elseif isa(arg1, CourtYardCanPutFurniture) and arg1:AnyNotRotateChilds() then
		return false
	else
		local var0 = arg0:GetMapNotIncludeItem(arg1)

		return _.all(arg1:GetRotatePositions(), function(arg0)
			return var0[arg0.x] and var0[arg0.x][arg0.y] == false and arg0:InSide(arg0) and arg1:InActivityRange(arg0)
		end)
	end
end

function var0.GetAroundEmptyPosition(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = arg1:GetPosition()

	table.insert(var0, Vector2(var2.x, var2.y - 1))

	while #var0 > 0 do
		local var3 = table.remove(var0, 1)

		if arg0:IsEmptyPosition(var3) then
			return var3
		end

		table.insert(var1, var3)

		for iter0, iter1 in ipairs({
			Vector2(var3.x, var3.y - 1),
			Vector2(var3.x - 1, var3.y),
			Vector2(var3.x + 1, var3.y),
			Vector2(var3.x, var3.y + 1)
		}) do
			if not table.contains(var1, iter1) and arg0:InSide(iter1) then
				table.insert(var0, iter1)
			end
		end
	end

	assert(false)
end

function var0.GetAroundEmptyArea(arg0, arg1, arg2)
	local var0 = arg1:GetInitSize()
	local var1 = var0[1][1]
	local var2 = var0[1][2]
	local var3 = arg0:GetPositions()

	local function var4(arg0, arg1)
		local var0 = arg0.x + arg0.y - (arg1.x + arg1.y)

		return math.abs(var0)
	end

	local var5 = _.map(var3, function(arg0)
		return {
			cost = var4(arg0, arg2),
			value = arg0
		}
	end)

	table.sort(var5, function(arg0, arg1)
		return arg0.cost < arg1.cost
	end)

	for iter0, iter1 in ipairs(var5) do
		local var6 = iter1.value
		local var7 = arg1:GetAreaByPosition(var6)

		if _.all(var7, function(arg0)
			return arg0:LegalPosition(arg0, arg1)
		end) then
			return var6
		end
	end

	return nil
end

function var0.Dispose(arg0)
	arg0:ClearListeners()
end

return var0
