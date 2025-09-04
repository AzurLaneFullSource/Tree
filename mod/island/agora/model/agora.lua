local var0_0 = class("Agora", import(".AgoraPlaceableArea"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.size)

	arg0_1.placeableList = arg1_1.placeableList
	arg0_1.themes = arg1_1.themes
	arg0_1.systemThemes = arg1_1.systemThemes
	arg0_1.capacity = arg1_1.capacity
	arg0_1.maxCustomThemeCnt = pg.island_set.build_self_theme_num.key_value_int
end

function var0_0.GetSystemThemes(arg0_2)
	return arg0_2.systemThemes
end

function var0_0.GetSystemTheme(arg0_3, arg1_3)
	return _.detect(arg0_3.systemThemes, function(arg0_4)
		return arg0_4.id == arg1_3
	end)
end

function var0_0.GetMaxCustomThemeCnt(arg0_5)
	return arg0_5.maxCustomThemeCnt
end

function var0_0.GetThemes(arg0_6)
	return arg0_6.themes
end

function var0_0.AddTheme(arg0_7, arg1_7)
	table.insert(arg0_7.themes, arg1_7)
	arg0_7:DispatchEvent(ISLAND_AGORA_EVT.THEME_UPDATE)
end

function var0_0.DeleteTheme(arg0_8, arg1_8)
	local var0_8 = _.detect(arg0_8.themes, function(arg0_9)
		return arg0_9.id == arg1_8
	end)

	if var0_8 then
		table.removebyvalue(arg0_8.themes, var0_8)
		arg0_8:DispatchEvent(ISLAND_AGORA_EVT.THEME_UPDATE)
	end
end

function var0_0.GetTheme(arg0_10, arg1_10)
	return _.detect(arg0_10.themes, function(arg0_11)
		return arg0_11.id == arg1_10
	end)
end

function var0_0.GetUseableThemeId(arg0_12)
	local function var0_12(arg0_13)
		for iter0_13, iter1_13 in ipairs(arg0_12.themes) do
			if iter1_13.id == arg0_13 then
				return true
			end
		end

		return false
	end

	for iter0_12 = 1, arg0_12.maxCustomThemeCnt do
		if not var0_12(iter0_12) then
			return iter0_12
		end
	end

	return nil
end

function var0_0.UpdateCapacity(arg0_14, arg1_14)
	arg0_14.capacity = arg1_14
end

function var0_0.GetMaxCapacity(arg0_15)
	return arg0_15.capacity
end

function var0_0.GetCapacity(arg0_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in pairs(arg0_16.placedlist) do
		var0_16 = var0_16 + iter1_16:GetCost()
	end

	return var0_16
end

function var0_0.IsMaxCapacity(arg0_17)
	return arg0_17:GetCapacity() >= arg0_17:GetMaxCapacity()
end

function var0_0.AddPlaceable(arg0_18, arg1_18)
	if arg0_18.placeableList[arg1_18.id] then
		return
	end

	arg0_18.placeableList[arg1_18.id] = arg1_18
end

function var0_0.AddPlaceableList(arg0_19, arg1_19)
	arg0_19.placeableList[arg1_19.id] = arg1_19
end

function var0_0.GetPlaceableList(arg0_20)
	return arg0_20.placeableList
end

function var0_0.GetPlaceableItem(arg0_21, arg1_21)
	return arg0_21.placeableList[arg1_21]
end

function var0_0.PlaceItem(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg0_22.placeableList[arg1_22]

	var0_22:UpdatePosition(arg2_22)
	var0_22:UpdateRotation(arg3_22)
	arg0_22:AddItem(var0_22)
	arg0_22:DispatchEvent(ISLAND_AGORA_EVT.GEN_ITEM, var0_22)
end

function var0_0.UnPlaceItem(arg0_23, arg1_23)
	local var0_23 = arg0_23.placeableList[arg1_23]

	arg0_23:RemoveItem(var0_23)
	arg0_23:DispatchEvent(ISLAND_AGORA_EVT.REMOVE_ITEM, var0_23)
end

function var0_0.GetBuilding(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.placedlist) do
		if iter1_24:IsBuildingType() then
			return iter1_24
		end
	end

	return nil
end

function var0_0.GetFoundation(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.placedlist) do
		if iter1_25:IsFoundationType() then
			return iter1_25
		end
	end

	return nil
end

function var0_0.GetPlacedListWithoutFoundationAndBuilding(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.placedlist) do
		if iter1_26:IsBuildingType() or iter1_26:IsFoundationType() then
			-- block empty
		else
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26
end

function var0_0.HasTileCell(arg0_27, arg1_27)
	return not arg0_27:GetTileCell(arg1_27):IsEmpty()
end

function var0_0.IsSameTile(arg0_28, arg1_28, arg2_28, arg3_28)
	return arg0_28:GetTileCell(arg3_28):IsSameValue(arg1_28, arg2_28)
end

function var0_0.PlaceTile(arg0_29, arg1_29, arg2_29, arg3_29)
	if arg0_29:IsSameTile(arg1_29, arg2_29, arg3_29) then
		return
	end

	arg0_29:FillTileLayer(arg1_29, arg2_29, arg3_29)

	local var0_29 = arg0_29:GetTileCell(arg3_29)

	arg0_29:DispatchEvent(ISLAND_AGORA_EVT.FILL_TILE_CELL, var0_29)
end

function var0_0.UnPlaceTile(arg0_30, arg1_30)
	if not arg0_30:HasTileCell(arg1_30) then
		return
	end

	arg0_30:ClearTileLayer(arg1_30)
	arg0_30:DispatchEvent(ISLAND_AGORA_EVT.CLEAR_TILE_CELL, arg1_30)
end

function var0_0.HasFloorCell(arg0_31, arg1_31)
	return not arg0_31:GetFloorCell(arg1_31):IsEmpty()
end

function var0_0.IsSameFloor(arg0_32, arg1_32, arg2_32, arg3_32)
	return arg0_32:GetFloorCell(arg3_32):IsSameValue(arg1_32, arg2_32)
end

function var0_0.PlaceFloor(arg0_33, arg1_33, arg2_33, arg3_33)
	if arg0_33:IsSameFloor(arg1_33, arg2_33, arg3_33) then
		return
	end

	arg0_33:FillFloorLayer(arg1_33, arg2_33, arg3_33)

	local var0_33 = arg0_33:GetFloorCell(arg3_33)

	arg0_33:DispatchEvent(ISLAND_AGORA_EVT.FILL_FLOOR_CELL, var0_33)
end

function var0_0.UnPlaceFloor(arg0_34, arg1_34)
	if not arg0_34:HasFloorCell(arg1_34) then
		return
	end

	arg0_34:ClearFloorLayer(arg1_34)
	arg0_34:DispatchEvent(ISLAND_AGORA_EVT.CLEAR_FLOOR_CELL, arg1_34)
end

function var0_0.GetPlacedInfoList(arg0_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.placedlist) do
		table.insert(var0_35, {
			count = 1,
			icon = iter1_35:GetIcon(),
			name = iter1_35:GetName(),
			capacity = iter1_35:GetCost()
		})
	end

	return var0_35
end

return var0_0
