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

function var0_0.InterAction(arg0_48, arg1_48, arg2_48)
	local var0_48 = 1
	local var1_48 = arg0_48.agora:GetVirtualInteractUnitData(arg1_48)
	local var2_48 = var1_48:GetEmptySlot()

	if not var2_48 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_interact_point"))

		return
	end

	local function var3_48()
		var2_48:Lock(arg2_48)
		arg0_48:NotifiyAgora(ISLAND_AGORA_EVT.START_INTERACTION, var1_48, var2_48, var0_48)
	end

	arg0_48.islandSyncMgr:TryControlUnit(IslandConst.SYNC_TYPE_AGORA, arg1_48, var2_48.id, var0_48, function(arg0_50)
		if arg0_50 then
			var3_48()
		end
	end)
end

function var0_0.InterActionSync(arg0_51, arg1_51, arg2_51, arg3_51)
	if arg0_51.isEditing then
		return
	end

	local var0_51 = 1
	local var1_51 = arg0_51.agora:GetVirtualInteractUnitData(arg1_51)
	local var2_51 = var1_51:GetSlotById(arg3_51)

	var2_51:Lock(arg2_51)
	arg0_51:NotifiyAgora(ISLAND_AGORA_EVT.START_INTERACTION, var1_51, var2_51, var0_51)
end

function var0_0.InterActionEnd(arg0_52, arg1_52, arg2_52)
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

function var0_0.InterActionEndSync(arg0_55, arg1_55, arg2_55)
	if arg0_55.isEditing then
		return
	end

	local var0_55 = arg0_55.agora:GetVirtualInteractUnitData(arg1_55)
	local var1_55 = var0_55:GetUsingSlot(arg2_55)
	local var2_55 = Clone(var1_55)

	var1_55:Release()
	arg0_55:NotifiyAgora(ISLAND_AGORA_EVT.END_INTERACTION, var0_55, var2_55)
end

function var0_0.PlaceItemRandonPosition(arg0_56, arg1_56)
	local var0_56 = arg0_56.agora:GetPlaceableItem(arg1_56)
	local var1_56 = var0_56:GetCost()

	if arg0_56.agora:IsMaxCapacityWhenAdd(var1_56) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_max_capacity"))

		return
	end

	local var2_56 = AgoraCalc.GetCenterMapPos()

	if not var2_56 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_size"))

		return
	end

	if arg0_56:AnySelected() then
		arg0_56:UnSelectedItem()
	end

	var0_56:Clear()

	local var3_56 = arg0_56.agora:FindEmptyArea4Item(var2_56, var0_56)

	if not var3_56 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_size"))

		return
	end

	arg0_56:PlaceItem(arg1_56, var3_56, Vector3.zero)
	arg0_56:SelectItem(var0_56)
end

function var0_0.PlaceItem(arg0_57, arg1_57, arg2_57, arg3_57, arg4_57)
	arg0_57.agora:PlaceItem(arg1_57, arg2_57, arg3_57, arg4_57)
end

function var0_0.RemovePlaceItem(arg0_58, arg1_58)
	arg0_58:UnPlaceItem(arg1_58)
	arg0_58:NotifiyAgora(ISLAND_AGORA_EVT.UNPLACE_ITEM)
end

function var0_0.UnPlaceItem(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg1_59 or arg0_59.selectedData and arg0_59.selectedData.id

	if not var0_59 then
		return
	end

	local var1_59 = arg0_59.agora:GetPlaceableItem(var0_59)

	if arg0_59:AnySelected() and arg0_59.selectedData.id == var0_59 then
		arg0_59:UnSelectedItem()
	end

	if not var1_59:CanOp() and not arg2_59 then
		return
	end

	arg0_59.agora:UnPlaceItem(var0_59)
end

function var0_0.ReplaceBuilding(arg0_60, arg1_60)
	if arg0_60:AnySelected() and arg0_60.agora:IsBuilding(arg0_60.selectedData.id) then
		arg0_60:UnSelectedItem()
	end

	local var0_60 = arg0_60.agora:GetBuilding()
	local var1_60 = Vector2.zero

	if var0_60 then
		var1_60 = var0_60:GetPosition()

		arg0_60:UnPlaceItem(var0_60.id, true)
	end

	arg0_60:PlaceItem(arg1_60, var1_60, Vector3.zero)
end

function var0_0.ReplaceFoundation(arg0_61, arg1_61)
	if arg0_61:AnySelected() and arg0_61.agora:IsFoundation(arg0_61.selectedData.id) then
		arg0_61:UnSelectedItem()
	end

	local var0_61 = arg0_61.agora:GetFoundation()
	local var1_61 = Vector2.zero

	if var0_61 then
		var1_61 = var0_61:GetPosition()

		arg0_61:UnPlaceItem(var0_61.id, true)
	end

	arg0_61:PlaceItem(arg1_61, var1_61, Vector3.zero)
end

function var0_0.SelectedPaveItem(arg0_62, arg1_62, arg2_62)
	if arg0_62:AnySelected() then
		arg0_62:UnSelectedItem()
	end

	arg0_62.toUpdateTileList = {}
	arg0_62.selectedPaveItemId = arg1_62
	arg0_62.paveItemShapeId = arg2_62
	arg0_62.isCleanLayerMode = false
end

function var0_0.UnSelectedPaveItem(arg0_63)
	arg0_63.toUpdateTileList = {}
	arg0_63.selectedPaveItemId = nil
	arg0_63.paveItemShapeId = nil
	arg0_63.isCleanLayerMode = false
end

function var0_0.ChangeSelectedShape(arg0_64, arg1_64)
	if not arg0_64.selectedPaveItemId then
		return
	end

	arg0_64.paveItemShapeId = arg1_64
end

function var0_0.ChangePaveMode(arg0_65, arg1_65)
	arg0_65.isCleanLayerMode = arg1_65
end

function var0_0.OpLayer(arg0_66, arg1_66)
	if not arg0_66.selectedPaveItemId then
		return
	end

	local var0_66 = arg0_66.agora:GetPlaceableItem(arg0_66.selectedPaveItemId)

	if not var0_66 then
		return
	end

	if not arg0_66.agora:InRange(arg1_66.x, arg1_66.y) then
		return
	end

	if not var0_66:IsOptionalShapeType() then
		return
	end

	if arg0_66.isCleanLayerMode then
		arg0_66:UnPaveLayer(var0_66, arg1_66)
	else
		arg0_66:PaveLayer(var0_66, arg1_66)
	end
end

function var0_0.PaveLayer(arg0_67, arg1_67, arg2_67)
	local var0_67 = arg1_67.id
	local var1_67 = arg0_67.paveItemShapeId

	arg0_67:RecordLayer(arg1_67, arg2_67)

	if arg1_67:IsFloor() then
		arg0_67:PaveFloorLayer(var0_67, var1_67, arg2_67)
	elseif arg1_67:IsTile() then
		arg0_67:PaveTileLayer(var0_67, var1_67, arg2_67)
	end
end

function var0_0.RecordLayer(arg0_68, arg1_68, arg2_68)
	if not arg0_68.toUpdateTileList[arg2_68.x] or not arg0_68.toUpdateTileList[arg2_68.x][arg2_68.y] then
		local var0_68

		if arg1_68:IsFloor() then
			var0_68 = arg0_68.agora:GetFloorCell(arg2_68)
		elseif arg1_68:IsTile() then
			var0_68 = arg0_68.agora:GetTileCell(arg2_68)
		end

		if var0_68 then
			if not arg0_68.toUpdateTileList[arg2_68.x] then
				arg0_68.toUpdateTileList[arg2_68.x] = {}
			end

			arg0_68.toUpdateTileList[arg2_68.x][arg2_68.y] = var0_68:GetShapeId()
		end
	end
end

function var0_0.UnPaveLayer(arg0_69, arg1_69, arg2_69)
	if arg1_69:IsFloor() and not arg0_69.agora:HasFloorCell(arg2_69) or arg1_69:IsTile() and not arg0_69.agora:HasTileCell(arg2_69) then
		return
	end

	arg0_69:RecordLayer(arg1_69, arg2_69)

	if arg1_69:IsFloor() then
		arg0_69:UnPaveFloorLayer(arg2_69)
	elseif arg1_69:IsTile() then
		arg0_69:UnPaveTileLayer(arg2_69)
	end
end

function var0_0.PaveFloorLayer(arg0_70, arg1_70, arg2_70, arg3_70)
	arg0_70.agora:PlaceFloor(arg1_70, arg2_70, arg3_70)
end

function var0_0.PaveTileLayer(arg0_71, arg1_71, arg2_71, arg3_71)
	arg0_71.agora:PlaceTile(arg1_71, arg2_71, arg3_71)
end

function var0_0.RevertPaveLayer(arg0_72)
	local function var0_72(arg0_73, arg1_73, arg2_73, arg3_73)
		if arg0_73 then
			arg0_72:UnPaveFloorLayer(arg2_73)

			return
		end

		arg0_72:PaveFloorLayer(arg1_73, arg3_73, arg2_73)
	end

	local function var1_72(arg0_74, arg1_74, arg2_74, arg3_74)
		if arg0_74 then
			arg0_72:UnPaveTileLayer(arg2_74)

			return
		end

		arg0_72:PaveTileLayer(arg1_74, arg3_74, arg2_74)
	end

	local var2_72 = arg0_72.agora:GetPlaceableItem(arg0_72.selectedPaveItemId)

	if not var2_72 then
		return
	end

	local var3_72 = var2_72.id

	for iter0_72, iter1_72 in pairs(arg0_72.toUpdateTileList) do
		for iter2_72, iter3_72 in pairs(iter1_72) do
			local var4_72 = Vector2(iter0_72, iter2_72)
			local var5_72 = iter3_72 < 0

			if var2_72:IsFloor() then
				var0_72(var5_72, var3_72, var4_72, iter3_72)
			elseif var2_72:IsTile() then
				var1_72(var5_72, var3_72, var4_72, iter3_72)
			end
		end
	end

	arg0_72.toUpdateTileList = {}
end

function var0_0.UnPaveFloorLayer(arg0_75, arg1_75)
	arg0_75.agora:UnPlaceFloor(arg1_75)
end

function var0_0.UnPaveTileLayer(arg0_76, arg1_76)
	arg0_76.agora:UnPlaceTile(arg1_76)
end

function var0_0.AddListeners(arg0_77)
	var0_0.super.AddListeners(arg0_77)
	arg0_77:AddIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_77.OnAgoraUpdate)
	arg0_77:AddIslandListener(IslandSignInAgency.GIFT_CNT_UPDATE, arg0_77.OnSignInGiftCntUpdate)
	arg0_77:AddIslandListener(IslandSignInAgency.SIGN_CNT_UPDATE, arg0_77.OnSignCntUpdate)
	arg0_77:AddIslandListener(IslandAgoraAgency.ADD_THEME, arg0_77.OnThemeAdded)
	arg0_77:AddIslandListener(IslandAgoraAgency.DEL_THEME, arg0_77.OnThemeDeleted)
	arg0_77:AddIslandListener(IslandAgoraAgency.PLACEMENT_UPDATE, arg0_77.OnPlacementUpdate)
	arg0_77:AddIslandListener(IslandAgoraAgency.ADD_FURNITURE, arg0_77.OnFurnitureAdded)
end

function var0_0.RemoveListeners(arg0_78)
	var0_0.super.RemoveListeners(arg0_78)
	arg0_78:RemoveIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_78.OnAgoraUpdate)
	arg0_78:RemoveIslandListener(IslandSignInAgency.GIFT_CNT_UPDATE, arg0_78.OnSignInGiftCntUpdate)
	arg0_78:RemoveIslandListener(IslandSignInAgency.SIGN_CNT_UPDATE, arg0_78.OnSignCntUpdate)
	arg0_78:RemoveIslandListener(IslandAgoraAgency.ADD_THEME, arg0_78.OnThemeAdded)
	arg0_78:RemoveIslandListener(IslandAgoraAgency.DEL_THEME, arg0_78.OnThemeDeleted)
	arg0_78:RemoveIslandListener(IslandAgoraAgency.PLACEMENT_UPDATE, arg0_78.OnPlacementUpdate)
	arg0_78:RemoveIslandListener(IslandAgoraAgency.ADD_FURNITURE, arg0_78.OnFurnitureAdded)
end

function var0_0.ClearNew(arg0_79, arg1_79)
	local var0_79 = arg0_79.agora:GetPlaceableItem(arg1_79)

	if not var0_79 then
		return
	end

	var0_79:ClearNew()
	arg0_79:GetIsland():GetAgoraAgency():ClearNew(var0_79.configId)
end

function var0_0.ClearAllNew(arg0_80)
	local var0_80 = arg0_80.agora:GetPlaceableList()

	for iter0_80, iter1_80 in pairs(var0_80) do
		iter1_80:ClearNew()
	end

	arg0_80:GetIsland():GetAgoraAgency():ClearAllNew()
end

function var0_0.OnFurnitureAdded(arg0_81, arg1_81)
	for iter0_81 = 1, arg1_81.count do
		local var0_81 = AgoraCalc.GetUniqueId(arg1_81.id, iter0_81)
		local var1_81 = AgoraFurniture.New({
			id = var0_81,
			configId = arg1_81.id,
			time = arg1_81.time,
			isNew = arg1_81.isNew
		})

		arg0_81.agora:AddPlaceable(var1_81)
	end
end

function var0_0.OnPlacementUpdate(arg0_82, arg1_82)
	arg0_82.islandSyncMgr:CancelAgoraInteract()
	arg0_82.islandSyncMgr:ClearAgoraInteractData()

	local var0_82 = AgoraTheme.New(arg1_82, arg0_82.agora.placeableList)
	local var1_82, var2_82, var3_82 = var0_82:GetSeparatedPlacedData()
	local var4_82 = arg0_82.agora:GetFoundation()

	if var2_82 and var4_82.id ~= var2_82.id then
		arg0_82:ReplaceFoundation(var2_82.id)
	end

	local var5_82 = arg0_82.agora:GetBuilding()

	if var3_82 and var5_82.id ~= var3_82.id then
		arg0_82:ReplaceBuilding(var3_82.id)
	end

	local var6_82 = arg0_82.agora:GetPlacedListWithoutFoundationAndBuilding()
	local var7_82, var8_82, var9_82 = AgoraCalc.GetChangePlacementList(var1_82, var6_82)

	for iter0_82, iter1_82 in ipairs(var8_82) do
		arg0_82.agora:UnPlaceItem(iter1_82.id)
	end

	for iter2_82, iter3_82 in ipairs(var9_82) do
		arg0_82.agora:PlaceItem(iter3_82.id, iter3_82:GetPosition(), iter3_82:GetRotation())
	end

	for iter4_82, iter5_82 in ipairs(var7_82) do
		arg0_82.agora:UnPlaceItem(iter5_82.id)
		arg0_82.agora:PlaceItem(iter5_82.id, iter5_82:GetPosition(), iter5_82:GetRotation())
	end

	arg0_82:ClearLayers()

	local var10_82 = var0_82:GetFloorData()
	local var11_82 = var0_82:GetTileData()

	arg0_82:PaveLayers(var10_82, var11_82)

	arg0_82.reloading = true
	arg0_82.nextReloadingEndTime = pg.TimeMgr.GetInstance():GetServerTime() + arg0_82.baseReloadingCd

	arg0_82:NotifiyAgora(ISLAND_AGORA_EVT.RELOADING)

	if (#var9_82 > 0 or #var7_82 > 0) and not arg0_82:IsSelfIsland() then
		arg0_82:ResetPlayerPosition()
	end

	arg0_82.islandSyncMgr:InitAgora(arg0_82.agora:GetAllVirtualInteractUnitData())
end

function var0_0.OnThemeAdded(arg0_83, arg1_83)
	local var0_83 = AgoraTheme.New(arg1_83, arg0_83.agora.placeableList)

	arg0_83.agora:AddTheme(var0_83)
end

function var0_0.OnThemeDeleted(arg0_84, arg1_84)
	arg0_84.agora:DeleteTheme(arg1_84)
end

function var0_0.OnSignCntUpdate(arg0_85, arg1_85)
	local var0_85 = arg0_85:GetIsland():GetSignInAgency()

	arg0_85:NotifiyCore(ISLAND_EVT.REFRESH_INTERACTION)
	arg0_85:NotifiyAgora(ISLAND_AGORA_EVT.SIGN_IN_CNT_UPDATE, arg1_85)
end

function var0_0.OnSignInGiftCntUpdate(arg0_86, arg1_86)
	arg0_86.giftAllocator:Flush()
end

function var0_0.OnAgoraUpdate(arg0_87, arg1_87, arg2_87)
	local var0_87 = IslandConst.AGORA_LEVEL_2_SIZE[arg1_87]

	arg0_87.agora:UpdateSize(Vector2(var0_87, var0_87))
	arg0_87.agora:UpdateCapacity(arg2_87)
end

function var0_0.CreateAgora(arg0_88, arg1_88)
	local var0_88 = arg1_88:GetAgoraAgency()
	local var1_88 = {}

	for iter0_88, iter1_88 in ipairs(var0_88:GetFurnitures()) do
		for iter2_88 = 1, iter1_88.count do
			local var2_88 = AgoraCalc.GetUniqueId(iter1_88.id, iter2_88)
			local var3_88 = AgoraFurniture.New({
				id = var2_88,
				configId = iter1_88.id,
				time = iter1_88.time,
				isNew = iter1_88.isNew
			})

			var1_88[var3_88.id] = var3_88
		end
	end

	local var4_88 = AgoraTheme.New(var0_88:GetPlacedData(), var1_88)
	local var5_88, var6_88, var7_88 = var4_88:GetSeparatedPlacedData()
	local var8_88 = var4_88:GetFloorData()
	local var9_88 = var4_88:GetTileData()
	local var10_88 = {}

	for iter3_88, iter4_88 in ipairs(var0_88:GetThemes()) do
		local var11_88 = AgoraTheme.New(iter4_88, var1_88)

		table.insert(var10_88, var11_88)
	end

	local var12_88 = {}

	for iter5_88, iter6_88 in ipairs(var0_88:GetSystemThemes()) do
		local var13_88 = AgoraSystemTheme.New(iter6_88)

		table.insert(var12_88, var13_88)
	end

	local var14_88 = var0_88:GetLevel()
	local var15_88 = math.clamp(var14_88, 1, #IslandConst.AGORA_LEVEL_2_SIZE)
	local var16_88 = IslandConst.AGORA_LEVEL_2_SIZE[var15_88]
	local var17_88 = var0_88:GetCapacity()

	return Agora.New({
		size = Vector2(var16_88, var16_88),
		placeableList = var1_88,
		capacity = var17_88,
		themes = var10_88,
		systemThemes = var12_88
	}), {
		placedlist = var5_88,
		foundation = var6_88,
		building = var7_88,
		placedFloor = var8_88,
		placedTile = var9_88
	}
end

return var0_0
