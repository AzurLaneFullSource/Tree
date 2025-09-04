local var0_0 = class("AgoraController", import("Mod.Island.Core.controller.IslandController"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	local var0_1, var1_1 = arg0_1:CreateAgora(arg0_1.island)

	arg0_1.agora = var0_1
	arg0_1.placedData = var1_1
	arg0_1.isEidting = false
	arg0_1.selectedData = nil
	arg0_1.editCdTime = 0
	arg0_1.toUpdateTileList = {}
	arg0_1.dataComparator = AgoraDataComparator.New(arg0_1.agora)
	arg0_1.reloading = false
	arg0_1.isCleanLayerMode = false
end

function var0_0.GetDefaultFoundation(arg0_2)
	local var0_2 = pg.island_set.island_pre_placement.key_value_varchar

	if var0_2[1] then
		local var1_2 = var0_2[1][1]
		local var2_2 = Vector2(var0_2[1][2][1], var0_2[1][2][2])
		local var3_2 = AgoraCalc.GetUniqueId(var1_2, 1)
		local var4_2 = AgoraFurniture.New({
			id = var3_2,
			configId = var1_2
		})

		var4_2:UpdatePosition(var2_2)

		return var4_2
	end

	return nil
end

function var0_0.GetDefaultBuilding(arg0_3)
	local var0_3 = pg.island_set.island_default_building.key_value_varchar

	if var0_3[1] then
		local var1_3 = var0_3[1]
		local var2_3 = AgoraCalc.WorldPosition2MapPosition(BuildVector3(var0_3[2]))
		local var3_3 = AgoraCalc.GetUniqueId(var1_3, 1)
		local var4_3 = AgoraFurniture.New({
			id = var3_3,
			configId = var1_3
		})

		var4_3:UpdatePosition(var2_3)

		return var4_3
	end

	return nil
end

function var0_0.Update(arg0_4)
	var0_0.super.Update(arg0_4)
	arg0_4:CheckReloadFinish()
end

function var0_0.CheckReloadFinish(arg0_5)
	if not arg0_5.reloading then
		return
	end

	if arg0_5:GetView():IsLoaded() then
		arg0_5:NotifiyAgora(ISLAND_AGORA_EVT.RELOADING_FINISH)

		arg0_5.reloading = false
	end
end

function var0_0.SetUp(arg0_6)
	var0_0.super.SetUp(arg0_6)
	arg0_6:NotifiyAgora(ISLAND_AGORA_EVT.START_LOAD_ITEMS)
	arg0_6:NotifiyAgora(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_6.agora:GetSize())

	local var0_6 = arg0_6.placedData.foundation or arg0_6:GetDefaultFoundation()

	if var0_6 then
		arg0_6:PlaceItem(var0_6.id, var0_6:GetPosition(), Vector3.zero)
	end

	local var1_6 = arg0_6.placedData.building or arg0_6:GetDefaultBuilding()

	if var1_6 then
		arg0_6:PlaceItem(var1_6.id, var1_6:GetPosition(), Vector3.zero)
	end

	local var2_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.placedData.placedlist) do
		table.insert(var2_6, function(arg0_7)
			arg0_6:PlaceItem(iter1_6.id, iter1_6:GetPosition(), iter1_6:GetRotation())

			if iter0_6 % 3 == 0 then
				onNextTick(arg0_7)
			else
				arg0_7()
			end
		end)
	end

	seriesAsync(var2_6, function()
		arg0_6:NotifiyAgora(ISLAND_AGORA_EVT.END_LOAD_ITEMS, var1_6:GetPosition())
	end)
end

function var0_0.OnCoreInitFinish(arg0_9)
	arg0_9:PaveLayers(arg0_9.placedData.placedFloor, arg0_9.placedData.placedTile)
	var0_0.super.OnCoreInitFinish(arg0_9)
end

function var0_0.InitSyncMgr(arg0_10)
	arg0_10.islandSyncMgr:Init(arg0_10.sceneData.unitList, arg0_10.agora:GetPlacedlist())
end

function var0_0.PaveLayers(arg0_11, arg1_11, arg2_11)
	for iter0_11, iter1_11 in pairs(arg1_11) do
		arg0_11:PaveFloorLayer(iter1_11.id, iter1_11:GetShapeId(), iter1_11:GetPosition())
	end

	for iter2_11, iter3_11 in pairs(arg2_11) do
		arg0_11:PaveTileLayer(iter3_11.id, iter3_11:GetShapeId(), iter3_11:GetPosition())
	end
end

function var0_0.GetAgora(arg0_12)
	return arg0_12.agora
end

function var0_0.CanEnterEditMode(arg0_13)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_13.editCdTime
end

function var0_0.AnySelected(arg0_14)
	return arg0_14.selectedData ~= nil
end

function var0_0.NotifiyAgora(arg0_15, arg1_15, ...)
	arg0_15.agora:DispatchEvent(arg1_15, ...)
end

function var0_0.CheckChange(arg0_16)
	if arg0_16:AnySelected() then
		arg0_16:UnSelectedItem()
	end

	local var0_16, var1_16 = arg0_16.dataComparator:AnyChanged()

	return var0_16
end

function var0_0.EnterEditMode(arg0_17)
	if not arg0_17:CanEnterEditMode() then
		arg0_17:NotifiyAgora(ISLAND_AGORA_EVT.ENTER_EDIT_FAILED)

		return
	end

	arg0_17.isEidting = true

	arg0_17.dataComparator:TakeSample()
	arg0_17:NotifiyAgora(ISLAND_AGORA_EVT.ENTER_EDIT)
	arg0_17:NotifiyIsland(ISLAND_EX_EVT.ENTER_EDIT_AGORA)
end

function var0_0.ExitEditMode(arg0_18)
	arg0_18.isEidting = false

	arg0_18.dataComparator:Abort()
	arg0_18:NotifiyAgora(ISLAND_AGORA_EVT.EXIT_EDIT)
	arg0_18:NotifiyIsland(ISLAND_EX_EVT.EXIT_EDIT_AGORA)
end

function var0_0.SaveAndExit(arg0_19)
	arg0_19:Save(true)
	arg0_19:ExitEditMode()
end

function var0_0.Save(arg0_20, arg1_20)
	if not arg1_20 and not arg0_20:CanEnterEditMode() then
		return
	end

	if arg0_20:AnySelected() then
		arg0_20:UnSelectedItem()
	end

	local var0_20, var1_20, var2_20 = arg0_20.agora:SerializePlacementData()

	arg0_20:NotifiyMeditor(IslandMediator.SAVE_AGORA, var0_20, var1_20, var2_20)
	arg0_20.dataComparator:TakeSample()

	local var3_20 = pg.island_set.island_build_save_time.key_value_int

	arg0_20.editCdTime = pg.TimeMgr.GetInstance():GetServerTime() + var3_20

	arg0_20:NotifiyAgora(ISLAND_AGORA_EVT.SAVE)
end

function var0_0.SaveTheme(arg0_21, arg1_21, arg2_21)
	if arg0_21:AnySelected() then
		arg0_21:UnSelectedItem()
	end

	local var0_21, var1_21, var2_21 = arg0_21.agora:SerializePlacementData()

	if #var0_21 <= 0 and #var1_21 <= 0 and #var2_21 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_deco_empty"))

		return
	end

	arg0_21:NotifiyMeditor(IslandMediator.SAVE_AGORA_THEME, {
		id = arg1_21,
		name = arg2_21,
		updateList = var0_21,
		floorList = var1_21,
		tileList = var2_21
	})
end

function var0_0.ApplyTheme(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg2_22 and arg0_22.agora:GetSystemTheme(arg1_22) or arg0_22.agora:GetTheme(arg1_22)

	if not var0_22 then
		return
	end

	arg0_22:ClearAll()
	arg0_22:NotifiyAgora(ISLAND_AGORA_EVT.START_LOAD_ITEMS)

	local var1_22 = {}
	local var2_22 = var0_22:GetPlacedData()

	for iter0_22, iter1_22 in ipairs(var2_22) do
		table.insert(var1_22, function(arg0_23)
			arg0_22:PlaceItem(iter1_22.id, iter1_22:GetPosition(), iter1_22:GetRotation())

			if iter0_22 % 3 == 0 then
				onNextTick(arg0_23)
			else
				arg0_23()
			end
		end)
	end

	table.insert(var1_22, function(arg0_24)
		onNextTick(arg0_24)
	end)

	local var3_22 = var0_22:GetFloorData()

	for iter2_22, iter3_22 in ipairs(var3_22) do
		arg0_22:PaveFloorLayer(iter3_22.id, iter3_22.shapeId, iter3_22:GetPosition())
	end

	table.insert(var1_22, function(arg0_25)
		onNextTick(arg0_25)
	end)

	local var4_22 = var0_22:GetTileData()

	for iter4_22, iter5_22 in ipairs(var4_22) do
		arg0_22:PaveTileLayer(iter5_22.id, iter5_22.shapeId, iter5_22:GetPosition())
	end

	seriesAsync(var1_22, function()
		arg0_22:NotifiyAgora(ISLAND_AGORA_EVT.END_LOAD_ITEMS)
	end)
end

function var0_0.DeleteTheme(arg0_27, arg1_27)
	arg0_27:NotifiyMeditor(IslandMediator.DEL_AGORA_THEME, arg1_27)
end

function var0_0.ClearAll(arg0_28)
	if arg0_28:AnySelected() then
		arg0_28:UnPlaceItem(arg0_28.selectedData.id)

		arg0_28.selectedData = nil
	end

	arg0_28:ClearPlaced(false)
	arg0_28:ClearLayers()
end

function var0_0.ClearPlaced(arg0_29, arg1_29)
	if arg1_29 then
		for iter0_29, iter1_29 in pairs(arg0_29.agora:GetPlacedlist()) do
			arg0_29:UnPlaceItem(iter1_29.id)
		end
	else
		for iter2_29, iter3_29 in pairs(arg0_29.agora:GetPlacedlist()) do
			if iter3_29:CanOp() then
				arg0_29:UnPlaceItem(iter3_29.id)
			end
		end
	end
end

function var0_0.ClearFloorLayer(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.agora:GetFloorLayer()) do
		for iter2_30, iter3_30 in pairs(iter1_30) do
			if not iter3_30:IsEmpty() then
				arg0_30:UnPaveFloorLayer(iter3_30:GetPosition())
			end
		end
	end
end

function var0_0.ClearTileLayer(arg0_31)
	for iter0_31, iter1_31 in pairs(arg0_31.agora:GetTileLayer()) do
		for iter2_31, iter3_31 in pairs(iter1_31) do
			if not iter3_31:IsEmpty() then
				arg0_31:UnPaveTileLayer(iter3_31:GetPosition())
			end
		end
	end
end

function var0_0.ClearLayers(arg0_32)
	arg0_32:ClearFloorLayer()
	arg0_32:ClearTileLayer()
end

function var0_0.Revert(arg0_33)
	local var0_33, var1_33 = arg0_33.dataComparator:AnyChanged()

	if not var0_33 then
		return
	end

	local var2_33, var3_33, var4_33 = arg0_33.dataComparator:GetSample()

	if bit.band(var1_33, AgoraDataComparator.CHANGE_TYPE_PLACED) > 0 then
		arg0_33:ClearPlaced(true)

		for iter0_33, iter1_33 in pairs(var2_33) do
			arg0_33:PlaceItem(iter1_33.id, iter1_33:GetPosition(), iter1_33:GetRotation())
		end
	end

	if bit.band(var1_33, AgoraDataComparator.CHANGE_TYPE_FLOOR) > 0 then
		arg0_33:ClearFloorLayer()

		for iter2_33, iter3_33 in pairs(var3_33) do
			for iter4_33, iter5_33 in pairs(iter3_33) do
				if not iter5_33:IsEmpty() then
					arg0_33:PaveFloorLayer(iter5_33.id, iter5_33:GetShapeId(), iter5_33:GetPosition())
				end
			end
		end
	end

	if bit.band(var1_33, AgoraDataComparator.CHANGE_TYPE_TILE) > 0 then
		arg0_33:ClearTileLayer()

		for iter6_33, iter7_33 in pairs(var4_33) do
			for iter8_33, iter9_33 in pairs(iter7_33) do
				if not iter9_33:IsEmpty() then
					arg0_33:PaveTileLayer(iter9_33.id, iter9_33:GetShapeId(), iter9_33:GetPosition())
				end
			end
		end
	end
end

function var0_0.RevertAndExit(arg0_34)
	arg0_34:Revert()
	arg0_34:ExitEditMode()
end

function var0_0.Upgrade(arg0_35)
	arg0_35:NotifiyMeditor(IslandMediator.UPGRADE_AGORA)
end

function var0_0.TrySelectItemById(arg0_36, arg1_36)
	local var0_36 = arg0_36.agora:GetPlacedItem(arg1_36)

	arg0_36:_TrySelectItem(var0_36)
end

function var0_0.TrySelectItem(arg0_37, arg1_37)
	local var0_37 = arg0_37.agora:GetAnyMapItemInPosition(arg1_37)

	arg0_37:_TrySelectItem(var0_37)
end

function var0_0._TrySelectItem(arg0_38, arg1_38)
	if not arg1_38 then
		return
	end

	if not arg1_38:CanSelect() then
		return
	end

	if arg0_38:AnySelected() then
		arg0_38:UnSelectedItem()
	end

	arg0_38:SelectItem(arg1_38)
end

function var0_0.SelectItem(arg0_39, arg1_39)
	arg0_39.selectedData = {
		id = arg1_39.id,
		position = arg1_39:GetPosition(),
		dir = arg1_39:GetRotation()
	}

	arg0_39.agora:RemoveItem(arg1_39)

	local var0_39 = arg1_39:CanOp()

	arg0_39:NotifiyAgora(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_39.selectedData.id, var0_39)
end

function var0_0.ConfirmSelectedItem(arg0_40)
	if not arg0_40:AnySelected() then
		return
	end

	local var0_40 = arg0_40.agora:GetPlaceableItem(arg0_40.selectedData.id)

	if not arg0_40.agora:IsEmptyArea(var0_40) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_pos_unavailability"))

		return
	end

	local var1_40 = arg0_40.selectedData.id

	arg0_40:UnSelectedItem()
	arg0_40:NotifiyAgora(ISLAND_AGORA_EVT.CONFIRM_SELECTED_ITEM, var1_40)
end

function var0_0.UnSelectedItem(arg0_41)
	if not arg0_41:AnySelected() then
		return
	end

	local var0_41 = arg0_41.selectedData.id

	arg0_41:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, var0_41)

	local var1_41 = arg0_41.agora:GetPlaceableItem(var0_41)

	if not arg0_41.agora:IsEmptyArea(var1_41) then
		local var2_41 = arg0_41.selectedData.position
		local var3_41 = arg0_41.selectedData.dir

		var1_41:UpdatePosition(var2_41)
		var1_41:UpdateRotation(var3_41)
	end

	local var4_41 = var1_41:CanOp()

	arg0_41.agora:AddItem(var1_41)

	arg0_41.selectedData = nil

	arg0_41:NotifiyAgora(ISLAND_AGORA_EVT.UNSELECTED_ITEM, var0_41, var4_41)
end

function var0_0.BeginDragItem(arg0_42)
	if not arg0_42:AnySelected() then
		return
	end

	local var0_42 = arg0_42.agora:GetPlaceableItem(arg0_42.selectedData.id)
end

function var0_0.DragItem(arg0_43, arg1_43)
	if not arg0_43:AnySelected() then
		return
	end

	local var0_43 = arg0_43.agora:GetPlaceableItem(arg0_43.selectedData.id)

	var0_43:UpdatePosition(arg0_43.agora:ClampRange(arg1_43.x, arg1_43.y, var0_43))

	local var1_43 = var0_43:GetArea()
	local var2_43 = arg0_43.agora:IsEmptyArea(var0_43)

	arg0_43:NotifiyAgora(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_43.selectedData.id, var2_43)

	local var3_43 = arg0_43.agora:GetItemInArea(var0_43:GetMapType(), var1_43)

	if var3_43 then
		arg0_43:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_OCCUPIED, var3_43.id)
	else
		arg0_43:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, var0_43.id)
	end
end

function var0_0.EndDragItem(arg0_44, arg1_44)
	arg0_44:DragItem(arg1_44)
end

function var0_0.RotationItem(arg0_45)
	if not arg0_45:AnySelected() then
		return
	end

	arg0_45.agora:GetPlaceableItem(arg0_45.selectedData.id):Rotation()
end

function var0_0.InterAction(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = 1
	local var1_46 = arg0_46.agora:GetPlacedItem(arg1_46)

	if not var1_46 then
		return
	end

	local var2_46 = var1_46:GetEmptySlot()

	if not var2_46 then
		return
	end

	local function var3_46()
		var2_46:Lock(arg2_46)
		arg0_46:NotifiyAgora(ISLAND_AGORA_EVT.START_INTERACTION, var1_46, var2_46, var0_46)
	end

	if arg3_46 then
		var3_46()
	else
		arg0_46.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_AGORA, arg1_46, var2_46.id, var0_46, function(arg0_48)
			if arg0_48 then
				var3_46()
			end
		end)
	end
end

function var0_0.InterActionEnd(arg0_49, arg1_49, arg2_49, arg3_49)
	local var0_49 = arg0_49.agora:GetPlacedItem(arg1_49)

	if not var0_49 then
		return
	end

	local var1_49 = var0_49:GetUsingSlot(arg2_49)

	if not var1_49 then
		return
	end

	local function var2_49()
		local var0_50 = Clone(var1_49)

		var1_49:Release()
		arg0_49:NotifiyAgora(ISLAND_AGORA_EVT.END_INTERACTION, var0_49, var0_50)

		local var1_50 = arg0_49.agora:GetPlaceableItem(arg1_49).position
		local var2_50 = arg0_49.agora:FindEmptyArea4Item(var1_50, AgoraPlaceableItem.New({}))

		if var2_50 then
			arg0_49:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, arg2_49, AgoraCalc.MapPosition2WorldPosition(var2_50))
		end
	end

	if arg3_49 then
		var2_49()
	else
		arg0_49.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_AGORA, arg1_49, var1_49.id, function(arg0_51)
			if arg0_51 then
				var2_49()
			end
		end)
	end
end

function var0_0.PlaceItemRandonPosition(arg0_52, arg1_52)
	if arg0_52.agora:IsMaxCapacity() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_max_capacity"))

		return
	end

	local var0_52 = AgoraCalc.GetCenterMapPos()

	if not var0_52 then
		return
	end

	if arg0_52:AnySelected() then
		arg0_52:UnSelectedItem()
	end

	local var1_52 = arg0_52.agora:GetPlaceableItem(arg1_52)

	var1_52:Clear()

	local var2_52 = arg0_52.agora:FindEmptyArea4Item(var0_52, var1_52)

	if not var2_52 then
		return
	end

	arg0_52:PlaceItem(arg1_52, var2_52, Vector3.zero)
	arg0_52:SelectItem(var1_52)
end

function var0_0.PlaceItem(arg0_53, arg1_53, arg2_53, arg3_53)
	arg0_53.agora:PlaceItem(arg1_53, arg2_53, arg3_53)
end

function var0_0.RemovePlaceItem(arg0_54, arg1_54)
	arg0_54:UnPlaceItem(arg1_54)
	arg0_54:NotifiyAgora(ISLAND_AGORA_EVT.UNPLACE_ITEM)
end

function var0_0.UnPlaceItem(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg1_55 or arg0_55.selectedData and arg0_55.selectedData.id

	if not var0_55 then
		return
	end

	local var1_55 = arg0_55.agora:GetPlaceableItem(var0_55)

	if arg0_55:AnySelected() and arg0_55.selectedData.id == var0_55 then
		arg0_55:UnSelectedItem()
	end

	if not var1_55:CanOp() and not arg2_55 then
		return
	end

	arg0_55.agora:UnPlaceItem(var0_55)
end

function var0_0.ReplaceBuilding(arg0_56, arg1_56)
	local var0_56 = arg0_56.agora:GetBuilding()
	local var1_56 = Vector2.zero

	if var0_56 then
		var1_56 = var0_56:GetPosition()

		arg0_56:UnPlaceItem(var0_56.id, true)
	end

	arg0_56:PlaceItem(arg1_56, var1_56, Vector3.zero)
end

function var0_0.ReplaceFoundation(arg0_57, arg1_57)
	local var0_57 = arg0_57.agora:GetFoundation()
	local var1_57 = Vector2.zero

	if var0_57 then
		var1_57 = var0_57:GetPosition()

		arg0_57:UnPlaceItem(var0_57.id, true)
	end

	arg0_57:PlaceItem(arg1_57, var1_57, Vector3.zero)
end

function var0_0.SelectedPaveItem(arg0_58, arg1_58, arg2_58)
	if arg0_58:AnySelected() then
		arg0_58:UnSelectedItem()
	end

	arg0_58.toUpdateTileList = {}
	arg0_58.selectedPaveItemId = arg1_58
	arg0_58.paveItemShapeId = arg2_58
	arg0_58.isCleanLayerMode = false
end

function var0_0.UnSelectedPaveItem(arg0_59)
	arg0_59.toUpdateTileList = {}
	arg0_59.selectedPaveItemId = nil
	arg0_59.paveItemShapeId = nil
	arg0_59.isCleanLayerMode = false
end

function var0_0.ChangeSelectedShape(arg0_60, arg1_60)
	if not arg0_60.selectedPaveItemId then
		return
	end

	arg0_60.paveItemShapeId = arg1_60
end

function var0_0.ChangePaveMode(arg0_61, arg1_61)
	arg0_61.isCleanLayerMode = arg1_61
end

function var0_0.OpLayer(arg0_62, arg1_62)
	if not arg0_62.selectedPaveItemId then
		return
	end

	local var0_62 = arg0_62.agora:GetPlaceableItem(arg0_62.selectedPaveItemId)

	if not var0_62 then
		return
	end

	if not arg0_62.agora:InRange(arg1_62.x, arg1_62.y) then
		return
	end

	if not var0_62:IsOptionalShapeType() then
		return
	end

	if arg0_62.isCleanLayerMode then
		arg0_62:UnPaveLayer(var0_62, arg1_62)
	else
		arg0_62:PaveLayer(var0_62, arg1_62)
	end
end

function var0_0.PaveLayer(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg1_63.id
	local var1_63 = arg0_63.paveItemShapeId

	arg0_63:RecordLayer(arg1_63, arg2_63)

	if arg1_63:IsFloor() then
		arg0_63:PaveFloorLayer(var0_63, var1_63, arg2_63)
	elseif arg1_63:IsTile() then
		arg0_63:PaveTileLayer(var0_63, var1_63, arg2_63)
	end
end

function var0_0.RecordLayer(arg0_64, arg1_64, arg2_64)
	if not arg0_64.toUpdateTileList[arg2_64.x] or not arg0_64.toUpdateTileList[arg2_64.x][arg2_64.y] then
		local var0_64

		if arg1_64:IsFloor() then
			var0_64 = arg0_64.agora:GetFloorCell(arg2_64)
		elseif arg1_64:IsTile() then
			var0_64 = arg0_64.agora:GetTileCell(arg2_64)
		end

		if var0_64 then
			if not arg0_64.toUpdateTileList[arg2_64.x] then
				arg0_64.toUpdateTileList[arg2_64.x] = {}
			end

			arg0_64.toUpdateTileList[arg2_64.x][arg2_64.y] = var0_64:GetShapeId()
		end
	end
end

function var0_0.UnPaveLayer(arg0_65, arg1_65, arg2_65)
	if arg1_65:IsFloor() and not arg0_65.agora:HasFloorCell(arg2_65) or arg1_65:IsTile() and not arg0_65.agora:HasTileCell(arg2_65) then
		return
	end

	arg0_65:RecordLayer(arg1_65, arg2_65)

	if arg1_65:IsFloor() then
		arg0_65:UnPaveFloorLayer(arg2_65)
	elseif arg1_65:IsTile() then
		arg0_65:UnPaveTileLayer(arg2_65)
	end
end

function var0_0.PaveFloorLayer(arg0_66, arg1_66, arg2_66, arg3_66)
	arg0_66.agora:PlaceFloor(arg1_66, arg2_66, arg3_66)
end

function var0_0.PaveTileLayer(arg0_67, arg1_67, arg2_67, arg3_67)
	arg0_67.agora:PlaceTile(arg1_67, arg2_67, arg3_67)
end

function var0_0.RevertPaveLayer(arg0_68)
	local function var0_68(arg0_69, arg1_69, arg2_69, arg3_69)
		if arg0_69 then
			arg0_68:UnPaveFloorLayer(arg2_69)

			return
		end

		arg0_68:PaveFloorLayer(arg1_69, arg3_69, arg2_69)
	end

	local function var1_68(arg0_70, arg1_70, arg2_70, arg3_70)
		if arg0_70 then
			arg0_68:UnPaveTileLayer(arg2_70)

			return
		end

		arg0_68:PaveTileLayer(arg1_70, arg3_70, arg2_70)
	end

	local var2_68 = arg0_68.agora:GetPlaceableItem(arg0_68.selectedPaveItemId)

	if not var2_68 then
		return
	end

	local var3_68 = var2_68.id

	for iter0_68, iter1_68 in pairs(arg0_68.toUpdateTileList) do
		for iter2_68, iter3_68 in pairs(iter1_68) do
			local var4_68 = Vector2(iter0_68, iter2_68)
			local var5_68 = iter3_68 < 0

			if var2_68:IsFloor() then
				var0_68(var5_68, var3_68, var4_68, iter3_68)
			elseif var2_68:IsTile() then
				var1_68(var5_68, var3_68, var4_68, iter3_68)
			end
		end
	end

	arg0_68.toUpdateTileList = {}
end

function var0_0.UnPaveFloorLayer(arg0_71, arg1_71)
	arg0_71.agora:UnPlaceFloor(arg1_71)
end

function var0_0.UnPaveTileLayer(arg0_72, arg1_72)
	arg0_72.agora:UnPlaceTile(arg1_72)
end

function var0_0.AddListeners(arg0_73)
	var0_0.super.AddListeners(arg0_73)
	arg0_73:AddIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_73.OnAgoraUpdate)
	arg0_73:AddIslandListener(IslandSignInAgency.GIFT_CNT_UPDATE, arg0_73.OnSignInGiftCntUpdate)
	arg0_73:AddIslandListener(IslandSignInAgency.SIGN_CNT_UPDATE, arg0_73.OnSignCntUpdate)
	arg0_73:AddIslandListener(IslandAgoraAgency.ADD_THEME, arg0_73.OnThemeAdded)
	arg0_73:AddIslandListener(IslandAgoraAgency.DEL_THEME, arg0_73.OnThemeDeleted)
	arg0_73:AddIslandListener(IslandAgoraAgency.PLACEMENT_UPDATE, arg0_73.OnPlacementUpdate)
	arg0_73:AddIslandListener(IslandAgoraAgency.ADD_FURNITURE, arg0_73.OnFurnitureAdded)
end

function var0_0.RemoveListeners(arg0_74)
	var0_0.super.RemoveListeners(arg0_74)
	arg0_74:RemoveIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_74.OnAgoraUpdate)
	arg0_74:RemoveIslandListener(IslandSignInAgency.GIFT_CNT_UPDATE, arg0_74.OnSignInGiftCntUpdate)
	arg0_74:RemoveIslandListener(IslandSignInAgency.SIGN_CNT_UPDATE, arg0_74.OnSignCntUpdate)
	arg0_74:RemoveIslandListener(IslandAgoraAgency.ADD_THEME, arg0_74.OnThemeAdded)
	arg0_74:RemoveIslandListener(IslandAgoraAgency.DEL_THEME, arg0_74.OnThemeDeleted)
	arg0_74:RemoveIslandListener(IslandAgoraAgency.PLACEMENT_UPDATE, arg0_74.OnPlacementUpdate)
	arg0_74:RemoveIslandListener(IslandAgoraAgency.ADD_FURNITURE, arg0_74.OnFurnitureAdded)
end

function var0_0.OnFurnitureAdded(arg0_75, arg1_75)
	for iter0_75 = 1, arg1_75.count do
		local var0_75 = AgoraCalc.GetUniqueId(arg1_75.id, iter0_75)
		local var1_75 = AgoraFurniture.New({
			id = var0_75,
			configId = arg1_75.id
		})

		arg0_75.agora:AddPlaceable(var1_75)
	end
end

function var0_0.OnPlacementUpdate(arg0_76, arg1_76)
	arg0_76.islandSyncMgr:OnClearAgora()

	local var0_76 = AgoraTheme.New(arg1_76, arg0_76.agora.placeableList)
	local var1_76, var2_76, var3_76 = var0_76:GetSeparatedPlacedData()
	local var4_76 = arg0_76.agora:GetFoundation()

	if var2_76 and var4_76.id ~= var2_76.id then
		arg0_76:ReplaceFoundation(var2_76.id)
	end

	local var5_76 = arg0_76.agora:GetBuilding()

	if var3_76 and var5_76.id ~= var3_76.id then
		arg0_76:ReplaceBuilding(var3_76.id)
	end

	local var6_76 = arg0_76.agora:GetPlacedListWithoutFoundationAndBuilding()
	local var7_76, var8_76, var9_76 = AgoraCalc.GetChangePlacementList(var1_76, var6_76)

	for iter0_76, iter1_76 in ipairs(var8_76) do
		arg0_76.agora:UnPlaceItem(iter1_76.id)
	end

	for iter2_76, iter3_76 in ipairs(var9_76) do
		arg0_76.agora:PlaceItem(iter3_76.id, iter3_76:GetPosition(), iter3_76:GetRotation())
	end

	for iter4_76, iter5_76 in ipairs(var7_76) do
		arg0_76.agora:UnPlaceItem(iter5_76.id)
		arg0_76.agora:PlaceItem(iter5_76.id, iter5_76:GetPosition(), iter5_76:GetRotation())
	end

	arg0_76:ClearLayers()

	local var10_76 = var0_76:GetFloorData()
	local var11_76 = var0_76:GetTileData()

	arg0_76:PaveLayers(var10_76, var11_76)

	arg0_76.reloading = true

	arg0_76:NotifiyAgora(ISLAND_AGORA_EVT.RELOADING)

	if (#var9_76 > 0 or #var7_76 > 0) and not arg0_76:IsSelfIsland() then
		arg0_76:ResetPlayerPosition()
	end

	arg0_76.islandSyncMgr:InitAgora(arg0_76.agora:GetPlacedlist())
end

function var0_0.OnThemeAdded(arg0_77, arg1_77)
	local var0_77 = AgoraTheme.New(arg1_77, arg0_77.agora.placeableList)

	arg0_77.agora:AddTheme(var0_77)
end

function var0_0.OnThemeDeleted(arg0_78, arg1_78)
	arg0_78.agora:DeleteTheme(arg1_78)
end

function var0_0.OnSignCntUpdate(arg0_79, arg1_79)
	local var0_79 = arg0_79:GetIsland():GetSignInAgency()

	arg0_79:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_79:NotifiyAgora(ISLAND_AGORA_EVT.SIGN_IN_CNT_UPDATE, arg1_79)
end

function var0_0.OnSignInGiftCntUpdate(arg0_80, arg1_80)
	arg0_80.giftAllocator:Flush()
end

function var0_0.OnAgoraUpdate(arg0_81, arg1_81, arg2_81)
	local var0_81 = IslandConst.AGORA_LEVEL_2_SIZE[arg1_81]

	arg0_81.agora:UpdateSize(Vector2(var0_81, var0_81))
	arg0_81.agora:UpdateCapacity(arg2_81)
end

function var0_0.CreateAgora(arg0_82, arg1_82)
	local var0_82 = arg1_82:GetAgoraAgency()
	local var1_82 = {}

	for iter0_82, iter1_82 in ipairs(var0_82:GetFurnitures()) do
		for iter2_82 = 1, iter1_82.count do
			local var2_82 = AgoraCalc.GetUniqueId(iter1_82.id, iter2_82)
			local var3_82 = AgoraFurniture.New({
				id = var2_82,
				configId = iter1_82.id
			})

			var1_82[var3_82.id] = var3_82
		end
	end

	local var4_82 = AgoraTheme.New(var0_82:GetPlacedData(), var1_82)
	local var5_82, var6_82, var7_82 = var4_82:GetSeparatedPlacedData()
	local var8_82 = var4_82:GetFloorData()
	local var9_82 = var4_82:GetTileData()
	local var10_82 = {}

	for iter3_82, iter4_82 in ipairs(var0_82:GetThemes()) do
		local var11_82 = AgoraTheme.New(iter4_82, var1_82)

		table.insert(var10_82, var11_82)
	end

	local var12_82 = {}

	for iter5_82, iter6_82 in ipairs(var0_82:GetSystemThemes()) do
		local var13_82 = AgoraSystemTheme.New(iter6_82)

		table.insert(var12_82, var13_82)
	end

	local var14_82 = var0_82:GetLevel()
	local var15_82 = math.clamp(var14_82, 1, #IslandConst.AGORA_LEVEL_2_SIZE)
	local var16_82 = IslandConst.AGORA_LEVEL_2_SIZE[var15_82]
	local var17_82 = var0_82:GetCapacity()

	return Agora.New({
		size = Vector2(var16_82, var16_82),
		placeableList = var1_82,
		capacity = var17_82,
		themes = var10_82,
		systemThemes = var12_82
	}), {
		placedlist = var5_82,
		foundation = var6_82,
		building = var7_82,
		placedFloor = var8_82,
		placedTile = var9_82
	}
end

return var0_0
