local var0_0 = class("CourtYardCanPutFurniture", import(".CourtYardFurniture"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.childs = {}
	arg0_1.placeableArea = CourtYardFurniturePlaceableArea.New(arg1_1, arg0_1, Vector4(35, 35, 0, 0))
end

function var0_0.GetPlaceableArea(arg0_2)
	return arg0_2.placeableArea
end

function var0_0.GetChilds(arg0_3)
	return arg0_3.childs
end

function var0_0.AnyNotRotateChilds(arg0_4)
	if #arg0_4.childs > 0 then
		return _.any(arg0_4.childs, function(arg0_5)
			return isa(arg0_5, CourtYardFurniture) and arg0_5:DisableRotation()
		end)
	end

	return false
end

function var0_0.GetCanputonPosition(arg0_6)
	local var0_6 = arg0_6:GetPosition()

	if arg0_6:GetDirection() == 1 then
		return _.map(arg0_6.config.canputonGrid, function(arg0_7)
			return Vector2(arg0_7[1], arg0_7[2]) + var0_6
		end)
	else
		return _.map(arg0_6.config.canputonGrid, function(arg0_8)
			return Vector2(arg0_8[2], arg0_8[1]) + var0_6
		end)
	end
end

function var0_0.CanPutChildInPosition(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetLevel() < arg1_9:GetLevel()
	local var1_9 = arg0_9:AllowDepthType()
	local var2_9 = table.contains(var1_9, arg1_9:GetDeathType())
	local var3_9 = arg1_9:GetAreaByPosition(arg2_9)

	return var2_9 and var0_9 and _.all(var3_9, function(arg0_10)
		return arg0_9.placeableArea:LegalPosition(arg0_10)
	end)
end

function var0_0.AllowDepthType(arg0_11)
	return {
		CourtYardConst.DEPTH_TYPE_MAT,
		CourtYardConst.DEPTH_TYPE_FURNITURE
	}
end

function var0_0.AddChild(arg0_12, arg1_12)
	arg0_12:SetDirty()
	arg1_12:SetParent(arg0_12)
	table.insert(arg0_12.childs, arg1_12)
	arg0_12.placeableArea:AddItem(arg1_12)
	arg1_12:SetPosition(arg1_12:GetPosition())
end

function var0_0.RemoveChild(arg0_13, arg1_13)
	arg0_13:SetDirty()
	arg1_13:SetParent(nil)
	table.removebyvalue(arg0_13.childs, arg1_13)
	arg0_13.placeableArea:RemoveItem(arg1_13)
end

function var0_0.AreaWithInfo(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	return arg0_14.placeableArea:AreaWithInfo(arg1_14, arg2_14, arg3_14, arg4_14)
end

function var0_0.SetPosition(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetPosition()

	var0_0.super.SetPosition(arg0_15, arg1_15)

	local var1_15 = {}

	for iter0_15 = #arg0_15.childs, 1, -1 do
		local var2_15 = arg0_15.childs[iter0_15]
		local var3_15 = var2_15:GetPosition() - var0_15

		arg0_15:RemoveChild(var2_15)
		table.insert(var1_15, {
			var2_15,
			arg1_15 + var3_15
		})
	end

	for iter1_15, iter2_15 in ipairs(var1_15) do
		iter2_15[1]:SetPosition(iter2_15[2])
		arg0_15:AddChild(iter2_15[1])
	end
end

function var0_0.Rotate(arg0_16)
	local var0_16 = arg0_16:GetPosition()

	var0_0.super.Rotate(arg0_16)

	local var1_16 = arg0_16:GetPosition()
	local var2_16 = {}

	for iter0_16 = #arg0_16.childs, 1, -1 do
		local var3_16 = arg0_16.childs[iter0_16]
		local var4_16 = var3_16:GetPosition() - var0_16

		arg0_16:RemoveChild(var3_16)
		table.insert(var2_16, {
			var3_16,
			var1_16 + Vector2(var4_16.y, var4_16.x)
		})
	end

	for iter1_16, iter2_16 in ipairs(var2_16) do
		iter2_16[1]:SetPosition(iter2_16[2])
		iter2_16[1]:Rotate()
		arg0_16:AddChild(iter2_16[1])
	end
end

function var0_0.CanRotateChild(arg0_17, arg1_17)
	local var0_17 = false

	arg0_17:RemoveChild(arg1_17)

	if _.all(arg1_17:GetRotatePositions(), function(arg0_18)
		return arg0_17.placeableArea:LegalPosition(arg0_18)
	end) then
		var0_17 = true
	end

	arg0_17:AddChild(arg1_17)

	return var0_17
end

function var0_0.ToTable(arg0_19)
	local var0_19 = var0_0.super.ToTable(arg0_19)
	local var1_19 = {}
	local var2_19 = arg0_19:GetPosition()

	for iter0_19, iter1_19 in ipairs(arg0_19.childs) do
		var1_19[iter1_19.id] = iter1_19:GetPosition() - var2_19
	end

	var0_19.child = var1_19

	return var0_19
end

return var0_0
