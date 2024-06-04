local var0 = class("CourtYardCanPutFurniture", import(".CourtYardFurniture"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.childs = {}
	arg0.placeableArea = CourtYardFurniturePlaceableArea.New(arg1, arg0, Vector4(35, 35, 0, 0))
end

function var0.GetPlaceableArea(arg0)
	return arg0.placeableArea
end

function var0.GetChilds(arg0)
	return arg0.childs
end

function var0.AnyNotRotateChilds(arg0)
	if #arg0.childs > 0 then
		return _.any(arg0.childs, function(arg0)
			return isa(arg0, CourtYardFurniture) and arg0:DisableRotation()
		end)
	end

	return false
end

function var0.GetCanputonPosition(arg0)
	local var0 = arg0:GetPosition()

	if arg0:GetDirection() == 1 then
		return _.map(arg0.config.canputonGrid, function(arg0)
			return Vector2(arg0[1], arg0[2]) + var0
		end)
	else
		return _.map(arg0.config.canputonGrid, function(arg0)
			return Vector2(arg0[2], arg0[1]) + var0
		end)
	end
end

function var0.CanPutChildInPosition(arg0, arg1, arg2)
	local var0 = arg0:GetLevel() < arg1:GetLevel()
	local var1 = arg0:AllowDepthType()
	local var2 = table.contains(var1, arg1:GetDeathType())
	local var3 = arg1:GetAreaByPosition(arg2)

	return var2 and var0 and _.all(var3, function(arg0)
		return arg0.placeableArea:LegalPosition(arg0)
	end)
end

function var0.AllowDepthType(arg0)
	return {
		CourtYardConst.DEPTH_TYPE_MAT,
		CourtYardConst.DEPTH_TYPE_FURNITURE
	}
end

function var0.AddChild(arg0, arg1)
	arg0:SetDirty()
	arg1:SetParent(arg0)
	table.insert(arg0.childs, arg1)
	arg0.placeableArea:AddItem(arg1)
	arg1:SetPosition(arg1:GetPosition())
end

function var0.RemoveChild(arg0, arg1)
	arg0:SetDirty()
	arg1:SetParent(nil)
	table.removebyvalue(arg0.childs, arg1)
	arg0.placeableArea:RemoveItem(arg1)
end

function var0.AreaWithInfo(arg0, arg1, arg2, arg3, arg4)
	return arg0.placeableArea:AreaWithInfo(arg1, arg2, arg3, arg4)
end

function var0.SetPosition(arg0, arg1)
	local var0 = arg0:GetPosition()

	var0.super.SetPosition(arg0, arg1)

	local var1 = {}

	for iter0 = #arg0.childs, 1, -1 do
		local var2 = arg0.childs[iter0]
		local var3 = var2:GetPosition() - var0

		arg0:RemoveChild(var2)
		table.insert(var1, {
			var2,
			arg1 + var3
		})
	end

	for iter1, iter2 in ipairs(var1) do
		iter2[1]:SetPosition(iter2[2])
		arg0:AddChild(iter2[1])
	end
end

function var0.Rotate(arg0)
	local var0 = arg0:GetPosition()

	var0.super.Rotate(arg0)

	local var1 = arg0:GetPosition()
	local var2 = {}

	for iter0 = #arg0.childs, 1, -1 do
		local var3 = arg0.childs[iter0]
		local var4 = var3:GetPosition() - var0

		arg0:RemoveChild(var3)
		table.insert(var2, {
			var3,
			var1 + Vector2(var4.y, var4.x)
		})
	end

	for iter1, iter2 in ipairs(var2) do
		iter2[1]:SetPosition(iter2[2])
		iter2[1]:Rotate()
		arg0:AddChild(iter2[1])
	end
end

function var0.CanRotateChild(arg0, arg1)
	local var0 = false

	arg0:RemoveChild(arg1)

	if _.all(arg1:GetRotatePositions(), function(arg0)
		return arg0.placeableArea:LegalPosition(arg0)
	end) then
		var0 = true
	end

	arg0:AddChild(arg1)

	return var0
end

function var0.ToTable(arg0)
	local var0 = var0.super.ToTable(arg0)
	local var1 = {}
	local var2 = arg0:GetPosition()

	for iter0, iter1 in ipairs(arg0.childs) do
		var1[iter1.id] = iter1:GetPosition() - var2
	end

	var0.child = var1

	return var0
end

return var0
