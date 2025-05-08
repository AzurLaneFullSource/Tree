local var0_0 = class("AgoraView", import(".BaseAgoraView"))
local var1_0 = false

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	arg0_1.moulds = {}

	if var1_0 then
		arg0_1.debugMap = AgoraDebugMap.New(arg0_1)

		arg0_1.debugMap:Init()
	end

	arg0_1.decorationView = AgoraDecorationView.New(arg0_1)
	arg0_1.mouldBuilder = AgoraMouldBuilder.New(arg0_1)
	arg0_1.boards = {
		[2916] = GameObject.Find("[MainBlock]/[Model]/grid/level1_54x54"),
		[4356] = GameObject.Find("[MainBlock]/[Model]/grid/level2_66x66"),
		[6084] = GameObject.Find("[MainBlock]/[Model]/grid/level3_78x78")
	}
	arg0_1.grids = {
		[2916] = GameObject.Find("[MainBlock]/[Model]/nobake/grid/level1_54x54"),
		[4356] = GameObject.Find("[MainBlock]/[Model]/nobake/grid/level2_66x66"),
		[6084] = GameObject.Find("[MainBlock]/[Model]/nobake/grid/level3_78x78")
	}

	for iter0_1, iter1_1 in pairs(arg0_1.grids) do
		setActive(iter1_1, false)
	end

	arg0_1.agoraLookAtObj = GameObject.Find("AgoraMainStage/lookat"):GetComponent("AgoraLookAtObj")
end

function var0_0.CreateOpView(arg0_2)
	return AgoraOpView.New(arg0_2)
end

function var0_0.IsLoaded(arg0_3)
	local function var0_3()
		for iter0_4, iter1_4 in pairs(arg0_3.moulds) do
			if not iter1_4:IsLoaded() then
				return false
			end
		end

		return true
	end

	return var0_0.super.IsLoaded(arg0_3) and var0_3()
end

function var0_0.AddAgoraListeners(arg0_5)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.GEN_ITEM, arg0_5.OnGenItem)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.REMOVE_ITEM, arg0_5.OnRemoveItem)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.ENTER_EDIT, arg0_5.EnterEditMode)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.EXIT_EDIT, arg0_5.ExitEditMode)

	if var1_0 then
		arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.MAP_STATE_UPDATE, arg0_5.OnMapStateUpdate)
	end

	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_5.OnSelectedItem)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.UNSELECTED_ITEM, arg0_5.OnUnSelectedItem)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_5.OnDragItem)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_5.OnBoardUpdate)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.START_INTERACTION, arg0_5.OnStartInteraction)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.END_INTERACTION, arg0_5.OnEndInteraction)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.ITEM_OCCUPIED, arg0_5.OnPositionOccupied)
	arg0_5:AddAgoraListener(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, arg0_5.OnClearPositionOccupied)
end

function var0_0.RemoveAgoraListeners(arg0_6)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.GEN_ITEM, arg0_6.OnGenItem)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.REMOVE_ITEM, arg0_6.OnRemoveItem)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.ENTER_EDIT, arg0_6.EnterEditMode)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.EXIT_EDIT, arg0_6.ExitEditMode)

	if var1_0 then
		arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.MAP_STATE_UPDATE, arg0_6.OnMapStateUpdate)
	end

	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.SELECTED_ITEM, arg0_6.OnSelectedItem)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.UNSELECTED_ITEM, arg0_6.OnUnSelectedItem)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.DRAG_ITEM, arg0_6.OnDragItem)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_6.OnBoardUpdate)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.START_INTERACTION, arg0_6.OnStartInteraction)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.END_INTERACTION, arg0_6.OnEndInteraction)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.ITEM_OCCUPIED, arg0_6.OnPositionOccupied)
	arg0_6:RemoveAgoraListener(ISLAND_AGORA_EVT.ITEM_CLEAR_OCCUPIED, arg0_6.OnClearPositionOccupied)
end

function var0_0.OnSceneInited(arg0_7)
	var0_0.super.OnSceneInited(arg0_7)

	for iter0_7, iter1_7 in pairs(arg0_7.moulds) do
		iter1_7:Start()
	end
end

function var0_0.OnGenItem(arg0_8, arg1_8)
	arg0_8.moulds[arg1_8.id] = arg0_8.mouldBuilder:Build(arg1_8)

	if arg0_8.decorationView:IsLoaded() then
		arg0_8.decorationView:Flush()
	end

	local var0_8 = AgoraCalc.GetCenterMapPos()
	local var1_8 = arg1_8:GetPosition()

	if var0_8 ~= var1_8 then
		local var2_8 = AgoraCalc.MapPosition2WorldPosition(var1_8)

		arg0_8.agoraLookAtObj:SetTargetPosition(var2_8)
	end
end

function var0_0.OnRemoveItem(arg0_9, arg1_9)
	arg0_9.moulds[arg1_9.id]:Dispose()

	arg0_9.moulds[arg1_9.id] = nil

	if arg0_9.decorationView:IsLoaded() then
		arg0_9.decorationView:Flush()
	end
end

function var0_0.OnBoardUpdate(arg0_10, arg1_10)
	local var0_10 = arg1_10.x * arg1_10.y

	for iter0_10, iter1_10 in pairs(arg0_10.boards) do
		setActive(iter1_10, iter0_10 <= var0_10)
	end

	if arg0_10.isEditing then
		for iter2_10, iter3_10 in pairs(arg0_10.grids) do
			setActive(iter3_10, iter2_10 <= var0_10)
		end
	end

	local var1_10 = AgoraCalc.GetSizeCoord(arg1_10)

	arg0_10.agoraLookAtObj:SetRange(var1_10)
end

function var0_0.OnSelectedItem(arg0_11, arg1_11)
	local var0_11 = arg0_11.moulds[arg1_11]

	var0_11:ShowOrHideArea(true)
	arg0_11.opView:ActiveDragBtn(var0_11)
end

function var0_0.OnUnSelectedItem(arg0_12, arg1_12)
	local var0_12 = arg0_12.moulds[arg1_12]

	var0_12:ShowOrHideArea(false)
	var0_12:UpdateAreaState(true)
	arg0_12.opView:InActiveDragBtn(var0_12)
end

function var0_0.OnDragItem(arg0_13, arg1_13, arg2_13)
	arg0_13.moulds[arg1_13]:UpdateAreaState(arg2_13)
end

function var0_0.OnPositionOccupied(arg0_14, arg1_14)
	local var0_14 = arg0_14.moulds[arg1_14]

	var0_14:ShowOrHideArea(true)
	var0_14:UpdateAreaState(false)
end

function var0_0.OnClearPositionOccupied(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.moulds) do
		if iter0_15 ~= arg1_15 then
			iter1_15:ShowOrHideArea(false)
			iter1_15:UpdateAreaState(true)
		end
	end
end

function var0_0.OnStartInteraction(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16:GetHostId()
	local var1_16 = arg2_16:GetUserId()
	local var2_16 = arg0_16.moulds[var0_16]
	local var3_16 = arg0_16:GetUnitModule(var1_16)

	if arg0_16.player == var3_16 then
		arg0_16.opView:Disable()
		var2_16.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", true)
	end

	local var4_16 = var2_16.root.transform:Find("playable"):GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

	if arg1_16:AnySlotUsing() then
		var4_16:Stop()
	end

	var3_16._go.transform:SetParent(var2_16._go.transform)

	local var5_16 = TimelineHelper.GetTimelineTracks(var4_16)
	local var6_16 = arg2_16.id

	if var5_16 and var6_16 < var5_16.Length then
		local var7_16 = var5_16[var6_16]

		TimelineHelper.SetSceneBinding(var4_16, var7_16, var3_16._go)
	end

	var4_16.enabled = true

	var4_16:Play()
end

function var0_0.OnEndInteraction(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17:GetHostId()
	local var1_17 = arg2_17:GetUserId()
	local var2_17 = arg0_17.moulds[var0_17]
	local var3_17 = arg0_17:GetUnitModule(var1_17)
	local var4_17 = var2_17.root.transform:Find("playable"):GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

	if not arg1_17:AnySlotUsing() then
		var4_17:Stop()

		var4_17.enabled = true
	end

	local var5_17 = TimelineHelper.GetTimelineTracks(var4_17)
	local var6_17 = arg2_17.id

	if var5_17 and var6_17 < var5_17.Length then
		local var7_17 = var5_17[var6_17]

		TimelineHelper.SetSceneBinding(var4_17, var7_17, nil)
	end

	if arg0_17.player == var3_17 then
		arg0_17.opView:Enable()
		var2_17.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", false)
	end

	var3_17._go.transform:SetParent(nil)
end

function var0_0.OnMapStateUpdate(arg0_18, arg1_18)
	if arg0_18.debugMap then
		arg0_18.debugMap:UpdateItem(arg1_18.position, arg1_18.flag)
	end
end

function var0_0.EnterEditMode(arg0_19)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_NAME)
	arg0_19.opView:DisablePlayerOp()
	arg0_19.opView:EnableAgoraOp()
	arg0_19.decorationView:Show()

	for iter0_19, iter1_19 in ipairs(arg0_19:GetUnitList()) do
		iter1_19:Disable()
	end

	for iter2_19, iter3_19 in pairs(arg0_19.moulds) do
		iter3_19:Disable()
	end

	local var0_19 = arg0_19.agora:GetSize()
	local var1_19 = var0_19.x * var0_19.y

	for iter4_19, iter5_19 in pairs(arg0_19.grids) do
		setActive(iter5_19, iter4_19 <= var1_19)
	end

	arg0_19.isEditing = true
end

function var0_0.ExitEditMode(arg0_20)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	arg0_20.opView:EnablePlayerOp()
	arg0_20.opView:DisableAgoraOp()
	arg0_20.decorationView:Hide()

	for iter0_20, iter1_20 in ipairs(arg0_20:GetUnitList()) do
		iter1_20:Enable()
	end

	for iter2_20, iter3_20 in pairs(arg0_20.moulds) do
		iter3_20:Enable()
	end

	for iter4_20, iter5_20 in pairs(arg0_20.grids) do
		setActive(iter5_20, false)
	end

	arg0_20.isEditing = false
end

function var0_0.GetAgoraMould(arg0_21, arg1_21)
	return arg0_21.moulds[arg1_21]
end

function var0_0.OnDispose(arg0_22)
	var0_0.super.OnDispose(arg0_22)

	if arg0_22.decorationView then
		arg0_22.decorationView:Dispose()

		arg0_22.decorationView = nil
	end

	if var1_0 and arg0_22.debugMap then
		arg0_22.debugMap:Dispose()

		arg0_22.debugMap = nil
	end
end

return var0_0
