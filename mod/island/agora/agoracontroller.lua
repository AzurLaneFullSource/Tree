local var0_0 = class("AgoraController", import("Mod.Island.Core.controller.IslandController"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	local var0_1, var1_1 = arg0_1:CreateAgora(arg0_1.island)

	arg0_1.agora = var0_1
	arg0_1.placedData = var1_1
	arg0_1.isEditing = false
	arg0_1.selectedData = nil
	arg0_1.editCdTime = 0
	arg0_1.toUpdateTileList = {}
	arg0_1.dataComparator = AgoraDataComparator.New(arg0_1.agora)
	arg0_1.reloading = false
	arg0_1.baseReloadingCd = pg.island_set.agora_reloading_base_cd.key_value_int
	arg0_1.nextReloadingEndTime = 0
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

	if pg.TimeMgr.GetInstance():GetServerTime() < arg0_5.nextReloadingEndTime then
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
	arg0_10.islandSyncMgr:Init(arg0_10.sceneData.unitList, arg0_10.agora:GetAllVirtualInteractUnitData())
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

	arg0_17.islandSyncMgr:CancelAgoraInteract()

	arg0_17.isEditing = true

	arg0_17.dataComparator:TakeSample()
	arg0_17:NotifiyAgora(ISLAND_AGORA_EVT.ENTER_EDIT)
	arg0_17:NotifiyIsland(ISLAND_EX_EVT.ENTER_EDIT_AGORA)
end

function var0_0.ExitEditMode(arg0_18)
	arg0_18.isEditing = false

	arg0_18.dataComparator:Abort()
	arg0_18:NotifiyAgora(ISLAND_AGORA_EVT.EXIT_EDIT)
	arg0_18:NotifiyIsland(ISLAND_EX_EVT.EXIT_EDIT_AGORA)
	arg0_18:ClearAllNew()
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

	arg0_20.islandSyncMgr:ClearAgoraInteractData()

	local var0_20, var1_20, var2_20 = arg0_20.agora:SerializePlacementData()

	arg0_20:NotifiyMeditor(IslandMediator.SAVE_AGORA, var0_20, var1_20, var2_20)
	arg0_20.dataComparator:TakeSample()

	local var3_20 = pg.island_set.island_build_save_time.key_value_int

	arg0_20.editCdTime = pg.TimeMgr.GetInstance():GetServerTime() + var3_20

	arg0_20:NotifiyAgora(ISLAND_AGORA_EVT.SAVE)
	arg0_20.islandSyncMgr:InitAgora(arg0_20.agora:GetAllVirtualInteractUnitData())
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
			if iter1_22:IsFoundationType() then
				arg0_22:ReplaceFoundation(iter1_22.id)
			elseif iter1_22:IsBuildingType() then
				arg0_22:ReplaceBuilding(iter1_22.id)
			else
				arg0_22:PlaceItem(iter1_22.id, iter1_22:GetPosition(), iter1_22:GetRotation())
			end

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
			arg0_29:UnPlaceItem(iter1_29.id, true)
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
		arg0_33.islandSyncMgr:ResumeAgoraInteract()

		return
	end

	local var2_33, var3_33, var4_33 = arg0_33.dataComparator:GetSample()
	local var5_33 = {}

	if bit.band(var1_33, AgoraDataComparator.CHANGE_TYPE_PLACED) > 0 then
		arg0_33:ClearPlaced(true)

		for iter0_33, iter1_33 in pairs(var2_33) do
			table.insert(var5_33, function(arg0_34)
				arg0_33:PlaceItem(iter1_33.id, iter1_33:GetPosition(), iter1_33:GetRotation(), arg0_34)
			end)
		end
	end

	parallelAsync(var5_33, function()
		arg0_33.islandSyncMgr:ResumeAgoraInteract()
	end)

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

function var0_0.RevertAndExit(arg0_36)
	arg0_36:Revert()
	arg0_36:ExitEditMode()
end

function var0_0.Upgrade(arg0_37)
	arg0_37:NotifiyMeditor(IslandMediator.UPGRADE_AGORA)
end

function var0_0.TrySelectItemById(arg0_38, arg1_38)
	local var0_38 = arg0_38.agora:GetPlacedItem(arg1_38)

	arg0_38:_TrySelectItem(var0_38)
end

function var0_0.TrySelectItem(arg0_39, arg1_39)
	local var0_39 = arg0_39.agora:GetAnyMapItemInPosition(arg1_39)

	arg0_39:_TrySelectItem(var0_39)
end

function var0_0._TrySelectItem(arg0_40, arg1_40)
	if not arg1_40 then
		return
	end

	if not arg1_40:CanSelect() then
		return
	end

	if arg0_40:AnySelected() then
		arg0_40:UnSelectedItem()
	end

	arg0_40:SelectItem(arg1_40)
end

function var0_0.SelectItem(arg0_41, arg1_41)
	arg0_41.selectedData = {
		id = arg1_41.id,
		position = arg1_41:GetPosition(),
		dir = arg1_41:GetRotation()
	}

	arg0_41.agora:RemoveItem(arg1_41)

	local var0_41 = arg1_41:CanOp()

	arg0_41:NotifiyAgora(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_41.selectedData.id, var0_41)
end

function var0_0.ConfirmSelectedItem(arg0_42)
	if not arg0_42:AnySelected() then
		return
	end

	local var0_42 = arg0_42.agora:GetPlaceableItem(arg0_42.selectedData.id)

	if not arg0_42.agora:IsEmptyArea(var0_42) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_pos_unavailability"))

		return
	end

	local var1_42 = arg0_42.selectedData.id

	arg0_42:UnSelectedItem()
	arg0_42:NotifiyAgora(ISLAND_AGORA_EVT.CONFIRM_SELECTED_ITEM, var1_42)
end

function var0_0.UnSelectedItem(arg0_43)
	if not arg0_43:AnySelected() then
		return
	end

	local var0_43 = arg0_43.selectedData.id

	arg0_43:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, var0_43)

	local var1_43 = arg0_43.agora:GetPlaceableItem(var0_43)

	if not arg0_43.agora:IsEmptyArea(var1_43) then
		local var2_43 = arg0_43.selectedData.position
		local var3_43 = arg0_43.selectedData.dir

		var1_43:UpdatePosition(var2_43)
		var1_43:UpdateRotation(var3_43)
	end

	local var4_43 = var1_43:CanOp()

	arg0_43.agora:AddItem(var1_43)

	arg0_43.selectedData = nil

	arg0_43:NotifiyAgora(ISLAND_AGORA_EVT.UNSELECTED_ITEM, var0_43, var4_43)
end

function var0_0.BeginDragItem(arg0_44)
	if not arg0_44:AnySelected() then
		return
	end

	local var0_44 = arg0_44.agora:GetPlaceableItem(arg0_44.selectedData.id)

	arg0_44:NotifiyAgora(ISLAND_AGORA_EVT.DRAG_ITEM_BEGIN, var0_44)
end

function var0_0.DragItem(arg0_45, arg1_45)
	if not arg0_45:AnySelected() then
		return
	end

	local var0_45 = arg0_45.agora:GetPlaceableItem(arg0_45.selectedData.id)

	var0_45:UpdatePosition(arg0_45.agora:ClampRange(arg1_45.x, arg1_45.y, var0_45))

	local var1_45 = var0_45:GetArea()
	local var2_45 = arg0_45.agora:IsEmptyArea(var0_45)

	arg0_45:NotifiyAgora(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_45.selectedData.id, var2_45)

	local var3_45 = arg0_45.agora:GetItemInArea(var0_45:GetMapType(), var1_45)

	if var3_45 then
		arg0_45:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_OCCUPIED, var3_45.id)
	else
		arg0_45:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, var0_45.id)
	end
end

function var0_0.EndDragItem(arg0_46, arg1_46)
	local var0_46 = arg0_46.agora:GetPlaceableItem(arg0_46.selectedData.id)

	arg0_46:DragItem(arg1_46)
	arg0_46:NotifiyAgora(ISLAND_AGORA_EVT.DRAG_ITEM_END, var0_46)
end

function var0_0.RotationItem(arg0_47)
	if not arg0_47:AnySelected() then
		return
	end

	arg0_47.agora:GetPlaceableItem(arg0_47.selectedData.id):Rotation()
end

function var0_0.AgoraVirtualInterAction(arg0_48, arg1_48, arg2_48, arg3_48)
	arg3_48 = arg3_48 or 1

	local var0_48 = arg0_48.agora:GetVirtualInteractUnitData(arg1_48)
	local var1_48 = var0_48:GetEmptySlot()

	if not var1_48 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var2_48()
		var1_48:Lock(arg2_48)
		arg0_48:NotifiyAgora(ISLAND_AGORA_EVT.START_INTERACTION, var0_48, var1_48, arg3_48)
	end

	arg0_48.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_AGORA, arg1_48, var1_48.id, arg3_48, function(arg0_50)
		if arg0_50 then
			var2_48()
		end
	end)
end

function var0_0.AgoraVirtualInterActionSync(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	if arg0_51.isEditing then
		return
	end

	arg3_51 = arg3_51 or 1

	local var0_51 = arg0_51.agora:GetVirtualInteractUnitData(arg1_51)
	local var1_51 = var0_51:GetSlotById(arg4_51)

	var1_51:Lock(arg2_51)
	arg0_51:NotifiyAgora(ISLAND_AGORA_EVT.START_INTERACTION, var0_51, var1_51, arg3_51)
end

function var0_0.AgoraVirtualInterActionEnd(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52.agora:GetVirtualInteractUnitData(arg1_52)
	local var1_52 = var0_52:GetUsingSlot(arg2_52)

	local function var2_52()
		local var0_53 = Clone(var1_52)

		var1_52:Release()
		arg0_52:NotifiyAgora(ISLAND_AGORA_EVT.END_INTERACTION, var0_52, var0_53)
	end

	arg0_52.islandSyncMgr:EndControlUnit(IslandConst.SYNC_TYPE_AGORA, arg1_52, var1_52.id, function(arg0_54)
		if arg0_54 then
			var2_52()
		end
	end)
end

function var0_0.AgoraVirtualInterActionEndSync(arg0_55, arg1_55, arg2_55)
	if arg0_55.isEditing then
		return
	end

	local var0_55 = arg0_55.agora:GetVirtualInteractUnitData(arg1_55)
	local var1_55 = var0_55:GetUsingSlot(arg2_55)
	local var2_55 = Clone(var1_55)

	var1_55:Release()
	arg0_55:NotifiyAgora(ISLAND_AGORA_EVT.END_INTERACTION, var0_55, var2_55)
end

function var0_0.AgoraVirtualInitStatus(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56.agora:GetVirtualInteractUnitData(arg1_56)

	if not var0_56 then
		return
	end

	arg0_56:NotifiyCore(ISLAND_EVT.WORLD_OBJECT_INIT_STATUS, var0_56, arg2_56)
end

function var0_0.PlaceItemRandonPosition(arg0_57, arg1_57)
	local var0_57 = arg0_57.agora:GetPlaceableItem(arg1_57)
	local var1_57 = var0_57:GetCost()

	if arg0_57.agora:IsMaxCapacityWhenAdd(var1_57) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_max_capacity"))

		return
	end

	local var2_57 = AgoraCalc.GetCenterMapPos()

	if not var2_57 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_size"))

		return
	end

	if arg0_57:AnySelected() then
		arg0_57:UnSelectedItem()
	end

	var0_57:Clear()

	local var3_57 = arg0_57.agora:FindEmptyArea4Item(var2_57, var0_57)

	if not var3_57 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_size"))

		return
	end

	arg0_57:PlaceItem(arg1_57, var3_57, Vector3.zero)
	arg0_57:SelectItem(var0_57)
end

function var0_0.PlaceItem(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58)
	arg0_58.agora:PlaceItem(arg1_58, arg2_58, arg3_58, arg4_58)
end

function var0_0.RemovePlaceItem(arg0_59, arg1_59)
	arg0_59:UnPlaceItem(arg1_59)
	arg0_59:NotifiyAgora(ISLAND_AGORA_EVT.UNPLACE_ITEM)
end

function var0_0.UnPlaceItem(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg1_60 or arg0_60.selectedData and arg0_60.selectedData.id

	if not var0_60 then
		return
	end

	local var1_60 = arg0_60.agora:GetPlaceableItem(var0_60)

	if arg0_60:AnySelected() and arg0_60.selectedData.id == var0_60 then
		arg0_60:UnSelectedItem()
	end

	if not var1_60:CanOp() and not arg2_60 then
		return
	end

	arg0_60.agora:UnPlaceItem(var0_60)
end

function var0_0.ReplaceBuilding(arg0_61, arg1_61)
	if arg0_61:AnySelected() and arg0_61.agora:IsBuilding(arg0_61.selectedData.id) then
		arg0_61:UnSelectedItem()
	end

	local var0_61 = arg0_61.agora:GetBuilding()
	local var1_61 = Vector2.zero

	if var0_61 then
		var1_61 = var0_61:GetPosition()

		arg0_61:UnPlaceItem(var0_61.id, true)
	end

	arg0_61:PlaceItem(arg1_61, var1_61, Vector3.zero)
end

function var0_0.ReplaceFoundation(arg0_62, arg1_62)
	if arg0_62:AnySelected() and arg0_62.agora:IsFoundation(arg0_62.selectedData.id) then
		arg0_62:UnSelectedItem()
	end

	local var0_62 = arg0_62.agora:GetFoundation()
	local var1_62 = Vector2.zero

	if var0_62 then
		var1_62 = var0_62:GetPosition()

		arg0_62:UnPlaceItem(var0_62.id, true)
	end

	arg0_62:PlaceItem(arg1_62, var1_62, Vector3.zero)
end

function var0_0.SelectedPaveItem(arg0_63, arg1_63, arg2_63)
	if arg0_63:AnySelected() then
		arg0_63:UnSelectedItem()
	end

	arg0_63.toUpdateTileList = {}
	arg0_63.selectedPaveItemId = arg1_63
	arg0_63.paveItemShapeId = arg2_63
	arg0_63.isCleanLayerMode = false
end

function var0_0.UnSelectedPaveItem(arg0_64)
	arg0_64.toUpdateTileList = {}
	arg0_64.selectedPaveItemId = nil
	arg0_64.paveItemShapeId = nil
	arg0_64.isCleanLayerMode = false
end

function var0_0.ChangeSelectedShape(arg0_65, arg1_65)
	if not arg0_65.selectedPaveItemId then
		return
	end

	arg0_65.paveItemShapeId = arg1_65
end

function var0_0.ChangePaveMode(arg0_66, arg1_66)
	arg0_66.isCleanLayerMode = arg1_66
end

function var0_0.OpLayer(arg0_67, arg1_67)
	if not arg0_67.selectedPaveItemId then
		return
	end

	local var0_67 = arg0_67.agora:GetPlaceableItem(arg0_67.selectedPaveItemId)

	if not var0_67 then
		return
	end

	if not arg0_67.agora:InRange(arg1_67.x, arg1_67.y) then
		return
	end

	if not var0_67:IsOptionalShapeType() then
		return
	end

	if arg0_67.isCleanLayerMode then
		arg0_67:UnPaveLayer(var0_67, arg1_67)
	else
		arg0_67:PaveLayer(var0_67, arg1_67)
	end
end

function var0_0.PaveLayer(arg0_68, arg1_68, arg2_68)
	local var0_68 = arg1_68.id
	local var1_68 = arg0_68.paveItemShapeId

	arg0_68:RecordLayer(arg1_68, arg2_68)

	if arg1_68:IsFloor() then
		arg0_68:PaveFloorLayer(var0_68, var1_68, arg2_68)
	elseif arg1_68:IsTile() then
		arg0_68:PaveTileLayer(var0_68, var1_68, arg2_68)
	end
end

function var0_0.RecordLayer(arg0_69, arg1_69, arg2_69)
	if not arg0_69.toUpdateTileList[arg2_69.x] or not arg0_69.toUpdateTileList[arg2_69.x][arg2_69.y] then
		local var0_69

		if arg1_69:IsFloor() then
			var0_69 = arg0_69.agora:GetFloorCell(arg2_69)
		elseif arg1_69:IsTile() then
			var0_69 = arg0_69.agora:GetTileCell(arg2_69)
		end

		if var0_69 then
			if not arg0_69.toUpdateTileList[arg2_69.x] then
				arg0_69.toUpdateTileList[arg2_69.x] = {}
			end

			arg0_69.toUpdateTileList[arg2_69.x][arg2_69.y] = var0_69:GetShapeId()
		end
	end
end

function var0_0.UnPaveLayer(arg0_70, arg1_70, arg2_70)
	if arg1_70:IsFloor() and not arg0_70.agora:HasFloorCell(arg2_70) or arg1_70:IsTile() and not arg0_70.agora:HasTileCell(arg2_70) then
		return
	end

	arg0_70:RecordLayer(arg1_70, arg2_70)

	if arg1_70:IsFloor() then
		arg0_70:UnPaveFloorLayer(arg2_70)
	elseif arg1_70:IsTile() then
		arg0_70:UnPaveTileLayer(arg2_70)
	end
end

function var0_0.PaveFloorLayer(arg0_71, arg1_71, arg2_71, arg3_71)
	arg0_71.agora:PlaceFloor(arg1_71, arg2_71, arg3_71)
end

function var0_0.PaveTileLayer(arg0_72, arg1_72, arg2_72, arg3_72)
	arg0_72.agora:PlaceTile(arg1_72, arg2_72, arg3_72)
end

function var0_0.RevertPaveLayer(arg0_73)
	local function var0_73(arg0_74, arg1_74, arg2_74, arg3_74)
		if arg0_74 then
			arg0_73:UnPaveFloorLayer(arg2_74)

			return
		end

		arg0_73:PaveFloorLayer(arg1_74, arg3_74, arg2_74)
	end

	local function var1_73(arg0_75, arg1_75, arg2_75, arg3_75)
		if arg0_75 then
			arg0_73:UnPaveTileLayer(arg2_75)

			return
		end

		arg0_73:PaveTileLayer(arg1_75, arg3_75, arg2_75)
	end

	local var2_73 = arg0_73.agora:GetPlaceableItem(arg0_73.selectedPaveItemId)

	if not var2_73 then
		return
	end

	local var3_73 = var2_73.id

	for iter0_73, iter1_73 in pairs(arg0_73.toUpdateTileList) do
		for iter2_73, iter3_73 in pairs(iter1_73) do
			local var4_73 = Vector2(iter0_73, iter2_73)
			local var5_73 = iter3_73 < 0

			if var2_73:IsFloor() then
				var0_73(var5_73, var3_73, var4_73, iter3_73)
			elseif var2_73:IsTile() then
				var1_73(var5_73, var3_73, var4_73, iter3_73)
			end
		end
	end

	arg0_73.toUpdateTileList = {}
end

function var0_0.UnPaveFloorLayer(arg0_76, arg1_76)
	arg0_76.agora:UnPlaceFloor(arg1_76)
end

function var0_0.UnPaveTileLayer(arg0_77, arg1_77)
	arg0_77.agora:UnPlaceTile(arg1_77)
end

function var0_0.AddListeners(arg0_78)
	var0_0.super.AddListeners(arg0_78)
	arg0_78:AddIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_78.OnAgoraUpdate)
	arg0_78:AddIslandListener(IslandSignInAgency.GIFT_CNT_UPDATE, arg0_78.OnSignInGiftCntUpdate)
	arg0_78:AddIslandListener(IslandSignInAgency.SIGN_CNT_UPDATE, arg0_78.OnSignCntUpdate)
	arg0_78:AddIslandListener(IslandAgoraAgency.ADD_THEME, arg0_78.OnThemeAdded)
	arg0_78:AddIslandListener(IslandAgoraAgency.DEL_THEME, arg0_78.OnThemeDeleted)
	arg0_78:AddIslandListener(IslandAgoraAgency.PLACEMENT_UPDATE, arg0_78.OnPlacementUpdate)
	arg0_78:AddIslandListener(IslandAgoraAgency.ADD_FURNITURE, arg0_78.OnFurnitureAdded)
end

function var0_0.RemoveListeners(arg0_79)
	var0_0.super.RemoveListeners(arg0_79)
	arg0_79:RemoveIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_79.OnAgoraUpdate)
	arg0_79:RemoveIslandListener(IslandSignInAgency.GIFT_CNT_UPDATE, arg0_79.OnSignInGiftCntUpdate)
	arg0_79:RemoveIslandListener(IslandSignInAgency.SIGN_CNT_UPDATE, arg0_79.OnSignCntUpdate)
	arg0_79:RemoveIslandListener(IslandAgoraAgency.ADD_THEME, arg0_79.OnThemeAdded)
	arg0_79:RemoveIslandListener(IslandAgoraAgency.DEL_THEME, arg0_79.OnThemeDeleted)
	arg0_79:RemoveIslandListener(IslandAgoraAgency.PLACEMENT_UPDATE, arg0_79.OnPlacementUpdate)
	arg0_79:RemoveIslandListener(IslandAgoraAgency.ADD_FURNITURE, arg0_79.OnFurnitureAdded)
end

function var0_0.ClearNew(arg0_80, arg1_80)
	local var0_80 = arg0_80.agora:GetPlaceableItem(arg1_80)

	if not var0_80 then
		return
	end

	var0_80:ClearNew()
	arg0_80:GetIsland():GetAgoraAgency():ClearNew(var0_80.configId)
end

function var0_0.ClearAllNew(arg0_81)
	local var0_81 = arg0_81.agora:GetPlaceableList()

	for iter0_81, iter1_81 in pairs(var0_81) do
		iter1_81:ClearNew()
	end

	arg0_81:GetIsland():GetAgoraAgency():ClearAllNew()
end

function var0_0.OnFurnitureAdded(arg0_82, arg1_82)
	for iter0_82 = 1, arg1_82.count do
		local var0_82 = AgoraCalc.GetUniqueId(arg1_82.id, iter0_82)
		local var1_82 = AgoraFurniture.New({
			id = var0_82,
			configId = arg1_82.id,
			time = arg1_82.time,
			isNew = arg1_82.isNew
		})

		arg0_82.agora:AddPlaceable(var1_82)
	end
end

function var0_0.OnPlacementUpdate(arg0_83, arg1_83)
	arg0_83.islandSyncMgr:CancelAgoraInteract()
	arg0_83.islandSyncMgr:ClearAgoraInteractData()

	local var0_83 = AgoraTheme.New(arg1_83, arg0_83.agora.placeableList)
	local var1_83, var2_83, var3_83 = var0_83:GetSeparatedPlacedData()
	local var4_83 = arg0_83.agora:GetFoundation()

	if var2_83 and var4_83.id ~= var2_83.id then
		arg0_83:ReplaceFoundation(var2_83.id)
	end

	local var5_83 = arg0_83.agora:GetBuilding()

	if var3_83 and var5_83.id ~= var3_83.id then
		arg0_83:ReplaceBuilding(var3_83.id)
	end

	local var6_83 = arg0_83.agora:GetPlacedListWithoutFoundationAndBuilding()
	local var7_83, var8_83, var9_83 = AgoraCalc.GetChangePlacementList(var1_83, var6_83)

	for iter0_83, iter1_83 in ipairs(var8_83) do
		arg0_83.agora:UnPlaceItem(iter1_83.id)
	end

	for iter2_83, iter3_83 in ipairs(var9_83) do
		arg0_83.agora:PlaceItem(iter3_83.id, iter3_83:GetPosition(), iter3_83:GetRotation())
	end

	for iter4_83, iter5_83 in ipairs(var7_83) do
		arg0_83.agora:UnPlaceItem(iter5_83.id)
		arg0_83.agora:PlaceItem(iter5_83.id, iter5_83:GetPosition(), iter5_83:GetRotation())
	end

	arg0_83:ClearLayers()

	local var10_83 = var0_83:GetFloorData()
	local var11_83 = var0_83:GetTileData()

	arg0_83:PaveLayers(var10_83, var11_83)

	arg0_83.reloading = true
	arg0_83.nextReloadingEndTime = pg.TimeMgr.GetInstance():GetServerTime() + arg0_83.baseReloadingCd

	arg0_83:NotifiyAgora(ISLAND_AGORA_EVT.RELOADING)

	if (#var9_83 > 0 or #var7_83 > 0) and not arg0_83:IsSelfIsland() then
		arg0_83:ResetPlayerPosition()
	end

	arg0_83.islandSyncMgr:InitAgora(arg0_83.agora:GetAllVirtualInteractUnitData())
end

function var0_0.OnThemeAdded(arg0_84, arg1_84)
	local var0_84 = AgoraTheme.New(arg1_84, arg0_84.agora.placeableList)

	arg0_84.agora:AddTheme(var0_84)
end

function var0_0.OnThemeDeleted(arg0_85, arg1_85)
	arg0_85.agora:DeleteTheme(arg1_85)
end

function var0_0.OnSignCntUpdate(arg0_86, arg1_86)
	local var0_86 = arg0_86:GetIsland():GetSignInAgency()

	arg0_86:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_86:NotifiyAgora(ISLAND_AGORA_EVT.SIGN_IN_CNT_UPDATE, arg1_86)
end

function var0_0.OnSignInGiftCntUpdate(arg0_87, arg1_87)
	arg0_87.giftAllocator:Flush()
end

function var0_0.OnAgoraUpdate(arg0_88, arg1_88, arg2_88)
	local var0_88 = IslandConst.AGORA_LEVEL_2_SIZE[arg1_88]

	arg0_88.agora:UpdateSize(Vector2(var0_88, var0_88))
	arg0_88.agora:UpdateCapacity(arg2_88)
end

function var0_0.CreateAgora(arg0_89, arg1_89)
	local var0_89 = arg1_89:GetAgoraAgency()
	local var1_89 = {}

	for iter0_89, iter1_89 in ipairs(var0_89:GetFurnitures()) do
		for iter2_89 = 1, iter1_89.count do
			local var2_89 = AgoraCalc.GetUniqueId(iter1_89.id, iter2_89)
			local var3_89 = AgoraFurniture.New({
				id = var2_89,
				configId = iter1_89.id,
				time = iter1_89.time,
				isNew = iter1_89.isNew
			})

			var1_89[var3_89.id] = var3_89
		end
	end

	local var4_89 = AgoraTheme.New(var0_89:GetPlacedData(), var1_89)
	local var5_89, var6_89, var7_89 = var4_89:GetSeparatedPlacedData()
	local var8_89 = var4_89:GetFloorData()
	local var9_89 = var4_89:GetTileData()
	local var10_89 = {}

	for iter3_89, iter4_89 in ipairs(var0_89:GetThemes()) do
		local var11_89 = AgoraTheme.New(iter4_89, var1_89)

		table.insert(var10_89, var11_89)
	end

	local var12_89 = {}

	for iter5_89, iter6_89 in ipairs(var0_89:GetSystemThemes()) do
		local var13_89 = AgoraSystemTheme.New(iter6_89)

		table.insert(var12_89, var13_89)
	end

	local var14_89 = var0_89:GetLevel()
	local var15_89 = math.clamp(var14_89, 1, #IslandConst.AGORA_LEVEL_2_SIZE)
	local var16_89 = IslandConst.AGORA_LEVEL_2_SIZE[var15_89]
	local var17_89 = var0_89:GetCapacity()

	return Agora.New({
		size = Vector2(var16_89, var16_89),
		placeableList = var1_89,
		capacity = var17_89,
		themes = var10_89,
		systemThemes = var12_89
	}), {
		placedlist = var5_89,
		foundation = var6_89,
		building = var7_89,
		placedFloor = var8_89,
		placedTile = var9_89
	}
end

return var0_0
