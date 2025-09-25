local var0_0 = class("AgoraDecorationVO")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.list = {}
	arg0_1.agora = arg2_1.agora
	arg0_1.contoller = arg2_1:GetController()
end

function var0_0.IsPlaced(arg0_2, arg1_2)
	return arg0_2.agora:IsUsing(arg1_2) or arg0_2.contoller.selectedData and arg0_2.contoller.selectedData.id == arg1_2
end

function var0_0.IsUsing(arg0_3)
	return _.all(arg0_3.list, function(arg0_4)
		return arg0_3:IsPlaced(arg0_4.id)
	end)
end

function var0_0.IsNew(arg0_5)
	return _.any(arg0_5.list, function(arg0_6)
		return arg0_6:IsNew()
	end)
end

function var0_0.Read(arg0_7)
	return arg0_7:GetFirstItem():Read()
end

function var0_0.GetRarity(arg0_8)
	return arg0_8:GetFirstItem():GetRarity()
end

function var0_0.AddItem(arg0_9, arg1_9)
	table.insert(arg0_9.list, arg1_9)
end

function var0_0.GetFirstItem(arg0_10)
	return arg0_10.list[1]
end

function var0_0.GetAvailableItem(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.list) do
		if not arg0_11:IsPlaced(iter1_11.id) then
			return iter1_11
		end
	end

	return nil
end

function var0_0.GetAvailableCnt(arg0_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in ipairs(arg0_12.list) do
		if not arg0_12:IsPlaced(iter1_12.id) then
			var0_12 = var0_12 + 1
		end
	end

	return var0_12
end

function var0_0.GetMaxCnt(arg0_13)
	return #arg0_13.list
end

function var0_0.Contains(arg0_14, arg1_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.list) do
		if iter1_14.id == arg1_14 then
			return true
		end
	end

	return false
end

function var0_0.IsSame(arg0_15, arg1_15)
	return arg0_15.id == arg1_15
end

function var0_0.IsType(arg0_16, arg1_16)
	return arg0_16:GetFirstItem():GetType() == arg1_16
end

function var0_0.IsMatchSearch(arg0_17, arg1_17)
	if not arg1_17 or arg1_17 == "" then
		return true
	end

	return arg0_17:GetFirstItem():Match(arg1_17)
end

function var0_0.GetSortValue(arg0_18, arg1_18, arg2_18)
	local var0_18 = 0

	if arg1_18 == AgoraFurnitureType.SORT_RARITY then
		var0_18 = arg0_18:GetFirstItem():GetRarity()
	elseif arg1_18 == AgoraFurnitureType.SORT_TIME then
		var0_18 = arg0_18:GetFirstItem():GetTime()
	elseif arg1_18 == AgoraFurnitureType.SORT_CAPACITY then
		var0_18 = arg0_18:GetFirstItem():GetCost()
	else
		var0_18 = arg0_18:GetFirstItem().id
	end

	return arg2_18 == 1 and var0_18 or -1 * var0_18
end

function var0_0.IsOptionalShapeType(arg0_19)
	return arg0_19:GetFirstItem():IsOptionalShapeType()
end

function var0_0.IsBuilding(arg0_20)
	return arg0_20:GetFirstItem():IsBuildingType()
end

function var0_0.IsFoundation(arg0_21)
	return arg0_21:GetFirstItem():IsFoundationType()
end

function var0_0.GetThemeName(arg0_22)
	local var0_22 = arg0_22:GetFirstItem()
	local var1_22 = arg0_22.agora:GetSystemThemes()

	for iter0_22, iter1_22 in ipairs(var1_22) do
		if iter1_22:Belong(var0_22) then
			return iter1_22.name
		end
	end

	return i18n("agora_belong_theme_none")
end

return var0_0
