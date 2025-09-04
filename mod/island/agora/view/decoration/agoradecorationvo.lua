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

function var0_0.AddItem(arg0_5, arg1_5)
	table.insert(arg0_5.list, arg1_5)
end

function var0_0.GetFirstItem(arg0_6)
	return arg0_6.list[1]
end

function var0_0.GetAvailableItem(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.list) do
		if not arg0_7:IsPlaced(iter1_7.id) then
			return iter1_7
		end
	end

	return nil
end

function var0_0.GetAvailableCnt(arg0_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.list) do
		if not arg0_8:IsPlaced(iter1_8.id) then
			var0_8 = var0_8 + 1
		end
	end

	return var0_8
end

function var0_0.GetMaxCnt(arg0_9)
	return #arg0_9.list
end

function var0_0.Contains(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.list) do
		if iter1_10.id == arg1_10 then
			return true
		end
	end

	return false
end

function var0_0.IsSame(arg0_11, arg1_11)
	return arg0_11.id == arg1_11
end

function var0_0.IsType(arg0_12, arg1_12)
	return arg0_12:GetFirstItem():GetType() == arg1_12
end

function var0_0.IsMatchSearch(arg0_13, arg1_13)
	if not arg1_13 or arg1_13 == "" then
		return true
	end

	return arg0_13:GetFirstItem():Match(arg1_13)
end

function var0_0.GetSortValue(arg0_14, arg1_14, arg2_14)
	local var0_14 = 0

	if arg1_14 == AgoraFurnitureType.SORT_RARITY then
		var0_14 = arg0_14:GetFirstItem():GetRarity()
	elseif arg1_14 == AgoraFurnitureType.SORT_TIME then
		var0_14 = arg0_14:GetFirstItem():GetTime()
	elseif arg1_14 == AgoraFurnitureType.SORT_CAPACITY then
		var0_14 = arg0_14:GetFirstItem():GetCost()
	else
		var0_14 = arg0_14:GetFirstItem().id
	end

	return arg2_14 == 1 and var0_14 or -1 * var0_14
end

function var0_0.IsOptionalShapeType(arg0_15)
	return arg0_15:GetFirstItem():IsOptionalShapeType()
end

function var0_0.IsBuilding(arg0_16)
	return arg0_16:GetFirstItem():IsBuildingType()
end

function var0_0.IsFoundation(arg0_17)
	return arg0_17:GetFirstItem():IsFoundationType()
end

function var0_0.GetThemeName(arg0_18)
	local var0_18 = arg0_18:GetFirstItem()
	local var1_18 = arg0_18.agora:GetSystemThemes()

	for iter0_18, iter1_18 in ipairs(var1_18) do
		if iter1_18:Belong(var0_18) then
			return iter1_18.name
		end
	end

	return i18n("agora_belong_theme_none")
end

return var0_0
