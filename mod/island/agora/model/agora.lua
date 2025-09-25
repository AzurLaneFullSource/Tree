local var0_0 = class("Agora", import(".AgoraPlaceableArea"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.size)

	arg0_1.placeableList = arg1_1.placeableList
	arg0_1.themes = arg1_1.themes
	arg0_1.systemThemes = arg1_1.systemThemes
	arg0_1.capacity = arg1_1.capacity
	arg0_1.maxCustomThemeCnt = pg.island_set.build_self_theme_num.key_value_int
	arg0_1.virtualInteractUnitData = {}
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

function var0_0.IsMaxCapacityWhenAdd(arg0_18, arg1_18)
	return arg0_18:GetCapacity() + arg1_18 > arg0_18:GetMaxCapacity()
end

function var0_0.AddPlaceable(arg0_19, arg1_19)
	if arg0_19.placeableList[arg1_19.id] then
		return
	end

	arg0_19.placeableList[arg1_19.id] = arg1_19
end

function var0_0.AddPlaceableList(arg0_20, arg1_20)
	arg0_20.placeableList[arg1_20.id] = arg1_20
end

function var0_0.GetPlaceableList(arg0_21)
	return arg0_21.placeableList
end

function var0_0.GetPlaceableItem(arg0_22, arg1_22)
	return arg0_22.placeableList[arg1_22]
end

function var0_0.PlaceItem(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23 = arg0_23.placeableList[arg1_23]

	var0_23:UpdatePosition(arg2_23)
	var0_23:UpdateRotation(arg3_23)
	arg0_23:AddItem(var0_23)
	arg0_23:DispatchEvent(ISLAND_AGORA_EVT.GEN_ITEM, var0_23, arg4_23)
	arg0_23:AddVirtualInteractUnitData(arg1_23, var0_23)
end

function var0_0.UnPlaceItem(arg0_24, arg1_24)
	local var0_24 = arg0_24.placeableList[arg1_24]

	arg0_24:RemoveVirtualInteractUnitData(arg1_24, var0_24)
	arg0_24:RemoveItem(var0_24)
	arg0_24:DispatchEvent(ISLAND_AGORA_EVT.REMOVE_ITEM, var0_24)
end

function var0_0.GetBuilding(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.placedlist) do
		if iter1_25:IsBuildingType() then
			return iter1_25
		end
	end

	return nil
end

function var0_0.GetFoundation(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.placedlist) do
		if iter1_26:IsFoundationType() then
			return iter1_26
		end
	end

	return nil
end

function var0_0.GetPlacedListWithoutFoundationAndBuilding(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27.placedlist) do
		if iter1_27:IsBuildingType() or iter1_27:IsFoundationType() then
			-- block empty
		else
			table.insert(var0_27, iter1_27)
		end
	end

	return var0_27
end

function var0_0.HasTileCell(arg0_28, arg1_28)
	return not arg0_28:GetTileCell(arg1_28):IsEmpty()
end

function var0_0.IsSameTile(arg0_29, arg1_29, arg2_29, arg3_29)
	return arg0_29:GetTileCell(arg3_29):IsSameValue(arg1_29, arg2_29)
end

function var0_0.PlaceTile(arg0_30, arg1_30, arg2_30, arg3_30)
	if arg0_30:IsSameTile(arg1_30, arg2_30, arg3_30) then
		return
	end

	arg0_30:FillTileLayer(arg1_30, arg2_30, arg3_30)

	local var0_30 = arg0_30:GetTileCell(arg3_30)

	arg0_30:DispatchEvent(ISLAND_AGORA_EVT.FILL_TILE_CELL, var0_30)
end

function var0_0.UnPlaceTile(arg0_31, arg1_31)
	if not arg0_31:HasTileCell(arg1_31) then
		return
	end

	arg0_31:ClearTileLayer(arg1_31)
	arg0_31:DispatchEvent(ISLAND_AGORA_EVT.CLEAR_TILE_CELL, arg1_31)
end

function var0_0.HasFloorCell(arg0_32, arg1_32)
	return not arg0_32:GetFloorCell(arg1_32):IsEmpty()
end

function var0_0.IsSameFloor(arg0_33, arg1_33, arg2_33, arg3_33)
	return arg0_33:GetFloorCell(arg3_33):IsSameValue(arg1_33, arg2_33)
end

function var0_0.PlaceFloor(arg0_34, arg1_34, arg2_34, arg3_34)
	if arg0_34:IsSameFloor(arg1_34, arg2_34, arg3_34) then
		return
	end

	arg0_34:FillFloorLayer(arg1_34, arg2_34, arg3_34)

	local var0_34 = arg0_34:GetFloorCell(arg3_34)

	arg0_34:DispatchEvent(ISLAND_AGORA_EVT.FILL_FLOOR_CELL, var0_34)
end

function var0_0.UnPlaceFloor(arg0_35, arg1_35)
	if not arg0_35:HasFloorCell(arg1_35) then
		return
	end

	arg0_35:ClearFloorLayer(arg1_35)
	arg0_35:DispatchEvent(ISLAND_AGORA_EVT.CLEAR_FLOOR_CELL, arg1_35)
end

function var0_0.AddVirtualInteractUnitData(arg0_36, arg1_36, arg2_36)
	if arg2_36:CanInteraction() then
		for iter0_36, iter1_36 in ipairs(arg2_36:GetInteractionPoints()) do
			local var0_36 = AgoraCalc.GetVirtualInteractUnitId(arg1_36, iter0_36)
			local var1_36 = pg.island_interact_point[iter1_36]
			local var2_36 = arg2_36:GetRotation()
			local var3_36 = AgoraCalc.GetAreaCenterPos(arg2_36:GetArea()) + Vector3(unpack(var1_36.offset)) * Quaternion.Euler(0, var2_36.y, 0) + IslandConst.AGORA_POSITION_OFFSET
			local var4_36 = IslandDataConvertor.GenInteractUnitByAgoraFurniture({
				id = var0_36,
				pointId = iter1_36,
				position = {
					var3_36.x,
					var3_36.y,
					var3_36.z
				},
				rotation = {
					var2_36.x,
					var2_36.y,
					var2_36.z
				}
			})

			arg0_36.virtualInteractUnitData[var0_36] = var4_36

			arg2_36:AddListener(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, function(arg0_37, arg1_37)
				local var0_37 = AgoraCalc.GetAreaCenterPos(arg1_37)
				local var1_37 = Vector3(unpack(var1_36.offset)) * Quaternion.Euler(0, arg2_36:GetRotation().y, 0)

				arg0_36:DispatchEvent(ISLAND_EVT.RESET_UNIT_POS, var4_36.id, IslandConst.UNIT_LIST_OBJ, var0_37 + var1_37 + IslandConst.AGORA_POSITION_OFFSET)
			end)
			arg2_36:AddListener(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, function(arg0_38, arg1_38)
				arg0_36:DispatchEvent(ISLAND_EVT.RESET_UNIT_ROT, var4_36.id, IslandConst.UNIT_LIST_OBJ, arg1_38)
			end)
			arg0_36:DispatchEvent(ISLAND_EVT.GEN_UNIT, var4_36)
		end
	end
end

function var0_0.RemoveVirtualInteractUnitData(arg0_39, arg1_39, arg2_39)
	if arg2_39:CanInteraction() then
		for iter0_39, iter1_39 in ipairs(arg2_39:GetInteractionPoints()) do
			local var0_39 = AgoraCalc.GetVirtualInteractUnitId(arg1_39, iter0_39)

			arg0_39.virtualInteractUnitData[var0_39] = nil

			arg0_39:DispatchEvent(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_OBJ, var0_39)
		end
	end
end

function var0_0.GetVirtualInteractUnitData(arg0_40, arg1_40)
	return arg0_40.virtualInteractUnitData[arg1_40]
end

function var0_0.GetAllVirtualInteractUnitData(arg0_41)
	return arg0_41.virtualInteractUnitData
end

function var0_0.GetPlacedInfoList(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42.placedlist) do
		table.insert(var0_42, {
			count = 1,
			icon = iter1_42:GetIcon(),
			name = iter1_42:GetName(),
			capacity = iter1_42:GetCost()
		})
	end

	return var0_42
end

function var0_0.IsBuilding(arg0_43, arg1_43)
	return arg0_43:GetPlaceableItem(arg1_43):IsBuildingType()
end

function var0_0.IsFoundation(arg0_44, arg1_44)
	return arg0_44:GetPlaceableItem(arg1_44):IsFoundationType()
end

return var0_0
