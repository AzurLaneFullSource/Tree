local var0_0 = class("AgoraView", import(".BaseAgoraView"))

var0_0.MODE_OVERVIEW = 1
var0_0.MODE_EDIT = 2
var0_0.MODE_PAVE_TILE = 3

local var1_0 = false

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	local var0_1 = GameObject.Find("AgoraMainStage")

	arg0_1.agoraLookAtObj = var0_1.transform:Find("lookat"):GetComponent("AgoraLookAtObj")
	arg0_1.lookatBuilding = var0_1.transform:Find("lookat_building")
	arg0_1.furnitureRoot = var0_1.transform:Find("furniture")

	arg0_1:RegisterUnitList(IslandConst.UNIT_LIST_AGORA)

	arg0_1.mouldBuilder = AgoraMouldBuilder.New(arg0_1, IslandConst.UNIT_LIST_AGORA)

	if var1_0 then
		arg0_1.debugMap = AgoraDebugMap.New(arg0_1)

		arg0_1.debugMap:Init()
	end

	arg0_1.mode = var0_0.MODE_OVERVIEW
	arg0_1.decorationView = arg0_1:CreateDecorationView()
	arg0_1.paveTileView = AgoraPaveTileView.New(arg0_1)
	arg0_1.reloadingView = AgoraReloadingView.New(arg0_1)
	arg0_1.gridTr = GameObject.Find("[MainBlock]/[Model]/nobake/grid")
	arg0_1.trees = {
		[4356] = GameObject.Find("[MainBlock]/[Model]/fbx/lightmap04_jhs_autumn/tree_level_2"),
		[6084] = GameObject.Find("[MainBlock]/[Model]/fbx/lightmap04_jhs_autumn/tree_level_3")
	}
	arg0_1.stones = {
		[4356] = GameObject.Find("[MainBlock]/[Model]/fbx/lightmap04_jhs_autumn/shanti_Level_2"),
		[6084] = GameObject.Find("[MainBlock]/[Model]/fbx/lightmap04_jhs_autumn/shanti_Level_3")
	}
	arg0_1.grids = {
		[2916] = GameObject.Find("[MainBlock]/[Model]/nobake/grid/level1_54x54"),
		[4356] = GameObject.Find("[MainBlock]/[Model]/nobake/grid/level2_66x66"),
		[6084] = GameObject.Find("[MainBlock]/[Model]/nobake/grid/level3_78x78")
	}

	for iter0_1, iter1_1 in pairs(arg0_1.grids) do
		setActive(iter1_1, false)
	end

	setActive(arg0_1.gridTr, true)
end

function var0_0.CreateOpView(arg0_2)
	return AgoraOpView.New(arg0_2)
end

function var0_0.CreateDecorationView(arg0_3)
	return AgoraDecorationView.New(arg0_3)
end

function var0_0.AddAgoraListeners(arg0_4)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.GEN_ITEM, arg0_4.OnGenItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.REMOVE_ITEM, arg0_4.OnRemoveItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.UNPLACE_ITEM, arg0_4.OnUnplaceItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.ENTER_EDIT, arg0_4.OnEnterEditMode)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.ENTER_EDIT_FAILED, arg0_4.OnEnterFailed)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.EXIT_EDIT, arg0_4.OnExitEditMode)

	if var1_0 then
		arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.MAP_STATE_UPDATE, arg0_4.OnMapStateUpdate)
	end

	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_4.OnSelectedItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.UNSELECTED_ITEM, arg0_4.OnUnSelectedItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.CONFIRM_SELECTED_ITEM, arg0_4.OnConfirmItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_4.OnDragItem)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_4.OnBoardUpdate)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.START_INTERACTION, arg0_4.OnStartInteraction)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.END_INTERACTION, arg0_4.OnEndInteraction)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.ITEM_OCCUPIED, arg0_4.OnPositionOccupied)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, arg0_4.OnClearPositionOccupied)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.SIGN_IN_CNT_UPDATE, arg0_4.OnSignCntUpdate)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.FILL_TILE_CELL, arg0_4.OnGenTileCell)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.CLEAR_TILE_CELL, arg0_4.OnRemoveTileCell)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.FILL_FLOOR_CELL, arg0_4.OnGenFloorCell)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.CLEAR_FLOOR_CELL, arg0_4.OnRemoveFloorCell)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.THEME_UPDATE, arg0_4.OnThemeUpdate)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.RELOADING, arg0_4.OnReload)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.RELOADING_FINISH, arg0_4.OnReloadFinish)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.START_LOAD_ITEMS, arg0_4.OnStartLoadItems)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.END_LOAD_ITEMS, arg0_4.OnEndLoadItems)
	arg0_4:AddAgoraListener(ISLAND_AGORA_EVT.SAVE, arg0_4.OnSave)
end

function var0_0.RemoveAgoraListeners(arg0_5)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.GEN_ITEM, arg0_5.OnGenItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.REMOVE_ITEM, arg0_5.OnRemoveItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.UNPLACE_ITEM, arg0_5.OnUnplaceItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.ENTER_EDIT, arg0_5.OnEnterEditMode)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.ENTER_EDIT_FAILED, arg0_5.OnEnterFailed)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.EXIT_EDIT, arg0_5.OnExitEditMode)

	if var1_0 then
		arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.MAP_STATE_UPDATE, arg0_5.OnMapStateUpdate)
	end

	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_5.OnSelectedItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.UNSELECTED_ITEM, arg0_5.OnUnSelectedItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.CONFIRM_SELECTED_ITEM, arg0_5.OnConfirmItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_5.OnDragItem)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_5.OnBoardUpdate)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.START_INTERACTION, arg0_5.OnStartInteraction)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.END_INTERACTION, arg0_5.OnEndInteraction)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.ITEM_OCCUPIED, arg0_5.OnPositionOccupied)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, arg0_5.OnClearPositionOccupied)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.SIGN_IN_CNT_UPDATE, arg0_5.OnSignCntUpdate)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.FILL_TILE_CELL, arg0_5.OnGenTileCell)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.CLEAR_TILE_CELL, arg0_5.OnRemoveTileCell)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.FILL_FLOOR_CELL, arg0_5.OnGenFloorCell)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.CLEAR_FLOOR_CELL, arg0_5.OnRemoveFloorCell)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.THEME_UPDATE, arg0_5.OnThemeUpdate)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.RELOADING, arg0_5.OnReload)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.RELOADING_FINISH, arg0_5.OnReloadFinish)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.START_LOAD_ITEMS, arg0_5.OnStartLoadItems)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.END_LOAD_ITEMS, arg0_5.OnEndLoadItems)
	arg0_5:RemoveAgoraListener(ISLAND_AGORA_EVT.SAVE, arg0_5.OnSave)
end

function var0_0.OnSave(arg0_6)
	if arg0_6.decorationView and arg0_6.decorationView:IsLoaded() then
		arg0_6.decorationView:Execute("FlushSaveBtn")
	end
end

function var0_0.OnStartLoadItems(arg0_7)
	arg0_7.startLoadItemsFlag = true
end

function var0_0.OnEndLoadItems(arg0_8, arg1_8)
	arg0_8.startLoadItemsFlag = false

	local var0_8 = AgoraCalc.MapPosition2WorldPosition(arg1_8)

	arg0_8.lookatBuilding.position = var0_8
end

function var0_0.OnReload(arg0_9)
	arg0_9.reloadingView:Execute("Show")
end

function var0_0.OnReloadFinish(arg0_10)
	arg0_10.reloadingView:Execute("Hide")
end

function var0_0.OnThemeUpdate(arg0_11)
	arg0_11.decorationView:Execute("FlushThemeList")
end

function var0_0.OnGenFloorCell(arg0_12, arg1_12)
	arg0_12:GetSystemModule(IslandConst.AGORA_GROUND_SYSTEM_ID):FillFloorCell(arg1_12)
end

function var0_0.OnRemoveFloorCell(arg0_13, arg1_13)
	arg0_13:GetSystemModule(IslandConst.AGORA_GROUND_SYSTEM_ID):ClearFloorCell(arg1_13)
end

function var0_0.OnGenTileCell(arg0_14, arg1_14)
	arg0_14:GetSystemModule(IslandConst.AGORA_GROUND_SYSTEM_ID):FillTileCell(arg1_14)
end

function var0_0.OnRemoveTileCell(arg0_15, arg1_15)
	arg0_15:GetSystemModule(IslandConst.AGORA_GROUND_SYSTEM_ID):ClearTileCell(arg1_15)
end

function var0_0.OnEnterFailed(arg0_16)
	arg0_16:NotifiyIsland(ISLAND_EX_EVT.PLAY_STORY, {
		name = "ISLANDSTORY101"
	})
end

function var0_0.OnClearSelectedUnit(arg0_17)
	var0_0.super.OnClearSelectedUnit(arg0_17)

	if arg0_17.selectedUnitId then
		arg0_17:GetSubView(AgoraOpView):HideInterActionPanel()

		local var0_17 = arg0_17:GetUnitModule(arg0_17.selectedUnitId)

		if var0_17 then
			GetOrAddComponent(var0_17._go, typeof(HighlightController)):HighlightOff()
		end

		arg0_17.selectedUnitId = nil
	end
end

function var0_0.OnSelectedUnit(arg0_18, arg1_18)
	var0_0.super.OnSelectedUnit(arg0_18, arg1_18)

	if arg0_18.selectedUnitId then
		arg0_18:OnClearSelectedUnit()
	end

	if arg1_18.data:IsGift() then
		GetOrAddComponent(arg1_18._go, typeof(HighlightController)):HighlightOn()

		arg0_18.selectedUnitId = arg1_18.id

		arg0_18:GetSubView(AgoraOpView):ShowInterActionPanel({
			type = 41
		})
	end
end

function var0_0.OnSignCntUpdate(arg0_19, arg1_19)
	arg0_19:GetSubView(AgoraOpView):UpdateSignInTip()
end

function var0_0.OnGenItem(arg0_20, arg1_20)
	local var0_20 = arg0_20.mouldBuilder:Build(arg1_20)

	arg0_20:AddUnit(var0_20)

	if arg0_20.mode == var0_0.MODE_EDIT then
		arg0_20.decorationView:Execute("FlushList")
		arg0_20.decorationView:Execute("FlushCapacity")

		if not arg0_20.startLoadItemsFlag then
			arg0_20:LookAtItem(var0_20)
		end
	end
end

function var0_0.OnTagChange(arg0_21, arg1_21)
	arg0_21:SwitchLookat(arg1_21 == AgoraFurnitureType.BUILDING)
end

function var0_0.SwitchLookat(arg0_22, arg1_22)
	local var0_22 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.AGORA_CAMERA_NAME)

	if arg1_22 then
		var0_22.Follow = arg0_22.lookatBuilding
		var0_22.LookAt = arg0_22.lookatBuilding
	else
		var0_22.Follow = arg0_22.agoraLookAtObj.gameObject.transform
		var0_22.LookAt = arg0_22.agoraLookAtObj.gameObject.transform
	end

	arg0_22.agoraLookAtObj.enabled = not arg1_22
end

function var0_0.LookAtItem(arg0_23, arg1_23)
	local var0_23 = arg1_23.data
	local var1_23 = AgoraCalc.GetCenterMapPos()
	local var2_23 = var0_23:GetPosition()

	if not var0_23:IsBuildingType() and var1_23 ~= var2_23 then
		local var3_23 = AgoraCalc.MapPosition2WorldPosition(var2_23)

		arg0_23.agoraLookAtObj:SetTargetPosition(var3_23)
	end
end

function var0_0.OnRemoveItem(arg0_24, arg1_24)
	local var0_24 = arg0_24:GetAgoraMould(arg1_24.id)

	var0_24:Dispose()
	arg0_24:RemoveUnit(var0_24)

	if arg0_24.mode == var0_0.MODE_EDIT then
		arg0_24.decorationView:Execute("FlushList")
		arg0_24.decorationView:Execute("FlushCapacity")
	end
end

function var0_0.OnBoardUpdate(arg0_25, arg1_25)
	local var0_25 = arg1_25.x * arg1_25.y

	for iter0_25, iter1_25 in pairs(arg0_25.trees) do
		setActive(iter1_25, var0_25 < iter0_25)
	end

	for iter2_25, iter3_25 in pairs(arg0_25.stones) do
		setActive(iter3_25, var0_25 < iter2_25)
	end

	if arg0_25.mode ~= var0_0.MODE_OVERVIEW then
		for iter4_25, iter5_25 in pairs(arg0_25.grids) do
			setActive(iter5_25, iter4_25 <= var0_25)
		end
	end

	local var1_25 = AgoraCalc.GetSizeCoord(arg1_25)

	arg0_25.agoraLookAtObj:SetRange(var1_25)
end

function var0_0.OnSelectedItem(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26:GetAgoraMould(arg1_26)

	var0_26:ShowOrHideArea(false, true)

	if arg2_26 then
		arg0_26:GetSubView(AgoraOpView):ActiveDragBtn(var0_26)
	end

	arg0_26.decorationView:Execute("OnSelectedItem", arg1_26, arg2_26, arg1_26)
end

function var0_0.OnUnSelectedItem(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27:GetAgoraMould(arg1_27)

	var0_27:ShowOrHideArea(false, false)

	if arg2_27 then
		arg0_27:GetSubView(AgoraOpView):InActiveDragBtn(var0_27)
	end

	arg0_27.decorationView:Execute("OnSelectedItem", -1, arg2_27, arg1_27)
end

function var0_0.OnConfirmItem(arg0_28, arg1_28)
	arg0_28.decorationView:Execute("OnCreateSameItem", arg1_28)
end

function var0_0.OnUnplaceItem(arg0_29)
	arg0_29.decorationView:Execute("OnSelectedItem", -1, true)
end

function var0_0.OnDragItem(arg0_30, arg1_30, arg2_30)
	arg0_30:GetAgoraMould(arg1_30):ShowOrHideArea(not arg2_30, true)
end

function var0_0.OnPositionOccupied(arg0_31, arg1_31)
	arg0_31:GetAgoraMould(arg1_31):ShowOrHideArea(true, true)
end

function var0_0.OnClearPositionOccupied(arg0_32, arg1_32)
	for iter0_32, iter1_32 in pairs(arg0_32:GetUnitListByKey(IslandConst.UNIT_LIST_AGORA)) do
		if iter0_32 ~= arg1_32 then
			iter1_32:ShowOrHideArea(false, false)
		end
	end
end

function var0_0.OnStartInteraction(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = arg2_33:GetHostId()
	local var1_33 = arg2_33:GetUserId()

	warning("start", var0_33, var1_33, arg3_33, arg2_33.id)

	local var2_33 = arg0_33:GetAgoraMould(var0_33)
	local var3_33 = arg0_33:GetUnitModule(var1_33)
	local var4_33 = arg0_33.player == var3_33

	if var4_33 then
		arg0_33:GetSubView(AgoraOpView):StartInteraction()
	end

	local var5_33 = arg1_33:GetTimeline()[arg3_33]

	var2_33:StartInteract(var3_33, arg2_33.id, arg3_33, var5_33, nil, arg1_33:AnySlotUsing(), var4_33)
end

function var0_0.OnEndInteraction(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg2_34:GetHostId()
	local var1_34 = arg2_34:GetUserId()

	warning("end", var0_34, var1_34)

	local var2_34 = arg0_34:GetAgoraMould(var0_34)
	local var3_34 = arg0_34:GetUnitModule(var1_34)
	local var4_34 = arg0_34.player == var3_34

	if var4_34 then
		arg0_34:GetSubView(AgoraOpView):EndInteraction()
	end

	var2_34:EndInteract(var3_34, arg2_34.id, not arg1_34:AnySlotUsing(), var4_34)
end

function var0_0.OnMapStateUpdate(arg0_35, arg1_35)
	if arg0_35.debugMap then
		arg0_35.debugMap:UpdateItem(arg1_35.position, arg1_35.flag)
	end
end

function var0_0.OnEnterEditMode(arg0_36)
	arg0_36:EnterMode(var0_0.MODE_EDIT)
	arg0_36:SwitchLookat(false)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_NAME)
	arg0_36.decorationView:Execute("Show")

	for iter0_36, iter1_36 in ipairs(arg0_36:GetAllUnits()) do
		iter1_36:Disable()
	end

	for iter2_36, iter3_36 in pairs(arg0_36:GetUnitListByKey(IslandConst.UNIT_LIST_AGORA)) do
		iter3_36:Disable()
	end

	local var0_36 = arg0_36.agora:GetSize()
	local var1_36 = var0_36.x * var0_36.y

	for iter4_36, iter5_36 in pairs(arg0_36.grids) do
		setActive(iter5_36, iter4_36 <= var1_36)
	end

	arg0_36:RestLookAtPosition()
end

function var0_0.OnExitEditMode(arg0_37)
	arg0_37:EnterMode(var0_0.MODE_OVERVIEW)
	arg0_37:SwitchLookat(false)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	arg0_37.decorationView:Execute("Hide")
	arg0_37:GetSubView(AgoraOpView):InActiveDragBtn()

	for iter0_37, iter1_37 in ipairs(arg0_37:GetAllUnits()) do
		iter1_37:Enable()
	end

	for iter2_37, iter3_37 in pairs(arg0_37:GetUnitListByKey(IslandConst.UNIT_LIST_AGORA)) do
		iter3_37:Enable()
	end

	for iter4_37, iter5_37 in pairs(arg0_37.grids) do
		setActive(iter5_37, false)
	end
end

function var0_0.EnterPaveTileMode(arg0_38, arg1_38, arg2_38)
	arg0_38:EnterMode(var0_0.MODE_PAVE_TILE)
	arg0_38:Op("SelectedPaveItem", arg1_38.id, arg2_38)
	arg0_38.decorationView:Execute("Hide")
	arg0_38.paveTileView:Execute("Show", arg1_38, arg2_38)
	arg0_38:RestLookAtPosition(1)
end

function var0_0.ExitPaveTileMode(arg0_39)
	arg0_39:EnterMode(var0_0.MODE_EDIT)
	arg0_39:Op("UnSelectedPaveItem")
	arg0_39.decorationView:Execute("Show")
	arg0_39.paveTileView:Execute("Hide")
end

function var0_0.EnterMode(arg0_40, arg1_40)
	arg0_40.mode = arg1_40

	arg0_40:GetSubView(AgoraOpView):EnterMode(arg1_40)
end

function var0_0.RestLookAtPosition(arg0_41, arg1_41)
	local var0_41 = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.AGORA_CAMERA_NAME)

	LuaHelper.SetCinemachineFreeLookXAndY(var0_41, 0, arg1_41 or 0.5)

	local var1_41 = AgoraCalc.MapPosition2WorldPosition(Vector2(0, 0))

	arg0_41.agoraLookAtObj:SetTargetPosition(var1_41)
end

function var0_0.GetAgoraMould(arg0_42, arg1_42)
	return arg0_42:GetUnitModuleWithType(IslandConst.UNIT_LIST_AGORA, arg1_42)
end

function var0_0.OnDispose(arg0_43)
	if arg0_43.selectedUnitId then
		arg0_43:OnClearSelectedUnit()

		arg0_43.selectedUnitId = nil
	end

	var0_0.super.OnDispose(arg0_43)

	if arg0_43.decorationView then
		arg0_43.decorationView:Dispose()

		arg0_43.decorationView = nil
	end

	if arg0_43.paveTileView then
		arg0_43.paveTileView:Dispose()

		arg0_43.paveTileView = nil
	end

	if arg0_43.reloadingView then
		arg0_43.reloadingView:Dispose()

		arg0_43.reloadingView = nil
	end

	arg0_43:GetPoolMgr():ClearAograPools()

	if var1_0 and arg0_43.debugMap then
		arg0_43.debugMap:Dispose()

		arg0_43.debugMap = nil
	end
end

return var0_0
