local var0_0 = class("AgoraController", import("Mod.Island.Core.controller.IslandController"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	arg0_1.agora = arg0_1:CreateAgora(arg0_1.island)
	arg0_1.isEidting = false
	arg0_1.selectedData = nil
	arg0_1.sample = nil
end

function var0_0.GetAgora(arg0_2)
	return arg0_2.agora
end

function var0_0.SetUp(arg0_3)
	var0_0.super.SetUp(arg0_3)
	arg0_3:NotifiyAgora(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_3.agora:GetSize())

	for iter0_3, iter1_3 in pairs(arg0_3.agora:GetPlacedlist()) do
		arg0_3:PlaceItem(iter1_3.id, iter1_3:GetPosition())
	end
end

function var0_0.EnterEditMode(arg0_4)
	arg0_4.isEidting = true

	local var0_4 = arg0_4.agora:GetPlacedlist()

	arg0_4.sample = Clone(var0_4)

	arg0_4:NotifiyAgora(ISLAND_AGORA_EVT.ENTER_EDIT)
	arg0_4:NotifiyIsland(ISLAND_EX_EVT.ENTER_EDIT_AGORA)
end

function var0_0.ExitEditMode(arg0_5)
	arg0_5.isEidting = false
	arg0_5.sample = nil

	arg0_5:NotifiyAgora(ISLAND_AGORA_EVT.EXIT_EDIT)
	arg0_5:NotifiyIsland(ISLAND_EX_EVT.EXIT_EDIT_AGORA)
end

function var0_0.Save(arg0_6)
	if arg0_6:AnySelected() then
		arg0_6:UnSelectedItem()
	end

	arg0_6:ExitEditMode()

	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.agora:GetPlacedlist()) do
		table.insert(var0_6, iter1_6:ToPlacementData())
	end

	arg0_6:NotifiyIsland(ISLAND_EX_EVT.SAVE_AGORA, var0_6)
end

function var0_0.ClearAll(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.agora:GetPlacedlist()) do
		arg0_7:UnPlaceItem(iter1_7.id)
	end
end

function var0_0.Revert(arg0_8)
	if not arg0_8:AnyChanged() then
		return
	end

	arg0_8:ClearAll()

	for iter0_8, iter1_8 in pairs(arg0_8.sample) do
		arg0_8:PlaceItem(iter1_8.id, iter1_8:GetPosition())
	end
end

function var0_0.RevertAndExit(arg0_9)
	arg0_9:Revert()
	arg0_9:ExitEditMode()
end

function var0_0.AnyChanged(arg0_10)
	if not arg0_10.sample then
		return false
	end

	local var0_10 = table.getCount(arg0_10.sample)
	local var1_10 = arg0_10.agora:GetPlacedlist()

	if var0_10 ~= table.getCount(var1_10) then
		return true
	end

	for iter0_10, iter1_10 in pairs(arg0_10.sample) do
		local var2_10 = var1_10[iter0_10]

		if not var2_10 or not var2_10:IsSame(iter1_10) then
			return true
		end
	end

	for iter2_10, iter3_10 in pairs(var1_10) do
		local var3_10 = arg0_10.sample[iter2_10]

		if not var3_10 or not var3_10:IsSame(iter3_10) then
			return true
		end
	end

	return false
end

function var0_0.Upgrade(arg0_11)
	arg0_11:NotifiyIsland(ISLAND_EX_EVT.UPGRADE_AGORA)
end

function var0_0.SelectItem(arg0_12, arg1_12)
	local var0_12 = arg0_12.agora:GetItemInPosition(arg1_12)

	if not var0_12 then
		return
	end

	if arg0_12:AnySelected() then
		arg0_12:UnSelectedItem()
	end

	arg0_12:_SelectItem(var0_12)
end

function var0_0._SelectItem(arg0_13, arg1_13)
	arg0_13.selectedData = {
		id = arg1_13.id,
		position = arg1_13:GetPosition(),
		dir = arg1_13:GetRotation()
	}

	arg0_13.agora:RemoveItem(arg1_13)
	arg0_13:NotifiyAgora(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_13.selectedData.id)
end

function var0_0.ConfirmSelectedItem(arg0_14)
	if not arg0_14:AnySelected() then
		return
	end

	local var0_14 = arg0_14.agora:GetPlaceableItem(arg0_14.selectedData.id)

	if not arg0_14.agora:IsEmptyArea(var0_14:GetArea()) then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("该位置已被占用"))

		return
	end

	arg0_14:UnSelectedItem()
end

function var0_0.UnSelectedItem(arg0_15)
	if not arg0_15:AnySelected() then
		return
	end

	local var0_15 = arg0_15.selectedData.id

	arg0_15:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, var0_15)

	local var1_15 = arg0_15.agora:GetPlaceableItem(var0_15)

	if not arg0_15.agora:IsEmptyArea(var1_15:GetArea()) then
		local var2_15 = arg0_15.selectedData.position
		local var3_15 = arg0_15.selectedData.dir

		var1_15:UpdatePosition(var2_15)
		var1_15:UpdateRotation(var3_15)
	end

	arg0_15.agora:AddItem(var1_15)

	arg0_15.selectedData = nil

	arg0_15:NotifiyAgora(ISLAND_AGORA_EVT.UNSELECTED_ITEM, var0_15)
end

function var0_0.BeginDragItem(arg0_16)
	if not arg0_16:AnySelected() then
		return
	end

	local var0_16 = arg0_16.agora:GetPlaceableItem(arg0_16.selectedData.id)
end

function var0_0.DragItem(arg0_17, arg1_17)
	if not arg0_17:AnySelected() then
		return
	end

	local var0_17 = arg0_17.agora:GetPlaceableItem(arg0_17.selectedData.id)

	var0_17:UpdatePosition(arg0_17.agora:ClampRange(arg1_17.x, arg1_17.y, var0_17))

	local var1_17 = var0_17:GetArea()
	local var2_17 = arg0_17.agora:IsEmptyArea(var1_17)

	arg0_17:NotifiyAgora(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_17.selectedData.id, var2_17)

	local var3_17 = arg0_17.agora:GetItemInArea(var1_17)

	if var3_17 then
		arg0_17:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_OCCUPIED, var3_17.id)
	else
		arg0_17:NotifiyAgora(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, var0_17.id)
	end
end

function var0_0.RotationItem(arg0_18)
	if not arg0_18:AnySelected() then
		return
	end

	arg0_18.agora:GetPlaceableItem(arg0_18.selectedData.id):Rotation()
end

function var0_0.EndDragItem(arg0_19, arg1_19)
	arg0_19:DragItem(arg1_19)
end

function var0_0.InterAction(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg0_20.agora:GetPlacedItem(arg1_20)

	if not var0_20 then
		return
	end

	local var1_20 = var0_20:GetEmptySlot()

	if not var1_20 then
		return
	end

	local function var2_20()
		var1_20:Lock(arg2_20)
		arg0_20:NotifiyAgora(ISLAND_AGORA_EVT.START_INTERACTION, var0_20, var1_20)
	end

	if arg3_20 then
		var2_20()
	else
		arg0_20.islandSyncMgr:TryControlUnitAgora(arg1_20, var1_20.id, function(arg0_22)
			if arg0_22 then
				var2_20()
			end
		end)
	end
end

function var0_0.InterActionEnd(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg0_23.agora:GetPlacedItem(arg1_23)

	if not var0_23 then
		return
	end

	local var1_23 = var0_23:GetUsingSlot(arg2_23)

	if not var1_23 then
		return
	end

	local function var2_23()
		local var0_24 = Clone(var1_23)

		var1_23:Release()
		arg0_23:NotifiyAgora(ISLAND_AGORA_EVT.END_INTERACTION, var0_23, var0_24)

		local var1_24 = arg0_23.agora:GetPlaceableItem(arg1_23).position
		local var2_24 = arg0_23.agora:FindEmptyArea4Item(var1_24, AgoraPlaceableItem.New({}))

		if var2_24 then
			arg0_23:NotifiyCore(ISLAND_EVT.RESET_UNIT_POS, arg2_23, var2_24)
		end
	end

	if arg3_23 then
		var2_23()
	else
		arg0_23.islandSyncMgr:EndControlUnitAgora(arg1_23, var1_23.id, function(arg0_25)
			if arg0_25 then
				var2_23()
			end
		end)
	end
end

function var0_0.PlaceItemRandonPosition(arg0_26, arg1_26)
	local var0_26 = AgoraCalc.GetCenterMapPos()

	if not var0_26 then
		return
	end

	if arg0_26:AnySelected() then
		arg0_26:UnSelectedItem()
	end

	local var1_26 = arg0_26.agora:GetPlaceableItem(arg1_26)

	var1_26:Clear()

	local var2_26 = arg0_26.agora:FindEmptyArea4Item(var0_26, var1_26)

	if not var2_26 then
		return
	end

	arg0_26:PlaceItem(arg1_26, var2_26)
	arg0_26:_SelectItem(var1_26)
end

function var0_0.AnySelected(arg0_27)
	return arg0_27.selectedData ~= nil
end

function var0_0.PlaceItem(arg0_28, arg1_28, arg2_28)
	arg0_28.agora:PlaceItem(arg1_28, arg2_28)
end

function var0_0.UnPlaceItem(arg0_29, arg1_29)
	local var0_29 = arg1_29 or arg0_29.selectedData and arg0_29.selectedData.id

	if not var0_29 then
		return
	end

	if arg0_29:AnySelected() and arg0_29.selectedData.id == var0_29 then
		arg0_29:UnSelectedItem()
	end

	arg0_29.agora:UnPlaceItem(var0_29)
end

function var0_0.NotifiyAgora(arg0_30, arg1_30, ...)
	arg0_30.agora:DispatchEvent(arg1_30, ...)
end

function var0_0.AddListeners(arg0_31)
	var0_0.super.AddListeners(arg0_31)
	arg0_31:AddIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_31.OnAgoraUpdate)
	arg0_31:AddIslandListener(IslandAgoraAgency.ADD_PLACEMENT, arg0_31.OnAddFurniture)
	arg0_31:AddIslandListener(IslandAgoraAgency.DELETE_PLACEMENT, arg0_31.OnDeleteFurniture)
end

function var0_0.RemoveListeners(arg0_32)
	var0_0.super.RemoveListeners(arg0_32)
	arg0_32:RemoveIslandListener(IslandAgoraAgency.AGORA_UPGRADE, arg0_32.OnAgoraUpdate)
	arg0_32:RemoveIslandListener(IslandAgoraAgency.ADD_PLACEMENT, arg0_32.OnAddFurniture)
	arg0_32:RemoveIslandListener(IslandAgoraAgency.DELETE_PLACEMENT, arg0_32.OnDeleteFurniture)
end

function var0_0.OnAddFurniture(arg0_33, arg1_33)
	assert(not arg0_33.isEidting)

	local var0_33 = math.floor((arg1_33.id - 1) * 0.01)
	local var1_33 = AgoraFurniture.New({
		id = arg1_33.id,
		configId = var0_33,
		dir = arg1_33:GetRotation()
	})

	arg0_33.agora:AddPlaceableList(var1_33)
	arg0_33:PlaceItem(var1_33.id, arg1_33:GetPosition())
end

function var0_0.OnDeleteFurniture(arg0_34, arg1_34)
	assert(not arg0_34.isEidting)
	arg0_34:UnPlaceItem(arg1_34)
end

function var0_0.OnAgoraUpdate(arg0_35, arg1_35)
	local var0_35 = IslandConst.AGORA_LEVEL_2_SIZE[arg1_35]

	arg0_35.agora:UpdateSize(Vector2(var0_35, var0_35))
end

function var0_0.CreateAgora(arg0_36, arg1_36)
	local var0_36 = arg1_36:GetAgoraAgency()
	local var1_36 = {}

	for iter0_36, iter1_36 in ipairs(var0_36:GetFurnitures()) do
		for iter2_36 = 1, iter1_36.count do
			local var2_36 = iter1_36.id * 100 + iter2_36
			local var3_36 = AgoraFurniture.New({
				id = var2_36,
				configId = iter1_36.id
			})

			var1_36[var3_36.id] = var3_36
		end
	end

	local var4_36 = {}

	for iter3_36, iter4_36 in ipairs(var0_36:GetPlacedList()) do
		local var5_36 = var1_36[iter4_36.id]

		if var5_36 then
			var5_36:FlushDataFromPlacementData(iter4_36)

			var4_36[iter4_36.id] = var5_36
		end
	end

	local var6_36 = var0_36:GetLevel()
	local var7_36 = math.clamp(var6_36, 1, #IslandConst.AGORA_LEVEL_2_SIZE)
	local var8_36 = IslandConst.AGORA_LEVEL_2_SIZE[var7_36]

	return (Agora.New({
		size = Vector2(var8_36, var8_36),
		placeableList = var1_36,
		placedlist = var4_36
	}))
end

return var0_0
