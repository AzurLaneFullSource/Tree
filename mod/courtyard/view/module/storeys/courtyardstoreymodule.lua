local var0_0 = class("CourtYardStoreyModule", import("..CourtYardBaseModule"))
local var1_0 = false

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.modules = {}
	arg0_1.gridAgents = {
		CourtYardGridAgent.New(arg0_1),
		CourtYardWallGridAgent.New(arg0_1)
	}
	arg0_1.effectAgent = CourtYardEffectAgent.New(arg0_1)
	arg0_1.soundAgent = CourtYardSoundAgent.New(arg0_1)
	arg0_1.bgAgent = CourtYardBGAgent.New(arg0_1)
	arg0_1.bgmAgent = CourtYardBGMAgent.New(arg0_1)
	arg0_1.factorys = {
		[CourtYardConst.OBJ_TYPE_SHIP] = CourtYardShipFactory.New(arg0_1:GetView().poolMgr),
		[CourtYardConst.OBJ_TYPE_COMMOM] = CourtYardFurnitureFactory.New(arg0_1:GetView().poolMgr)
	}
	arg0_1.descPage = CourtYardFurnitureDescPage.New(arg0_1)
	arg0_1.playTheLutePage = CourtyardPlayTheLutePage.New(arg0_1)
end

function var0_0.GetDefaultBgm(arg0_2)
	return pg.voice_bgm.CourtYardScene.default_bgm
end

function var0_0.OnInit(arg0_3)
	arg0_3.zoomAgent = arg0_3._tf:Find("bg"):GetComponent("PinchZoom")
	arg0_3.scrollrect = arg0_3._tf:Find("scroll_view")
	arg0_3.bg = arg0_3._tf:Find("bg")
	arg0_3.rectTF = arg0_3._tf:Find("bg/rect")
	arg0_3.gridsTF = arg0_3.rectTF:Find("grids")
	arg0_3.rootTF = arg0_3._tf:Find("root")
	arg0_3.selectedTF = arg0_3._tf:Find("root/drag")
	arg0_3.selectedAnimation = arg0_3.selectedTF:GetComponent(typeof(Animation))
	arg0_3.dftAniEvent = arg0_3.selectedTF:GetComponent(typeof(DftAniEvent))
	arg0_3.rotationBtn = arg0_3.selectedTF:Find("panel/animroot/rotation")
	arg0_3.removeBtn = arg0_3.selectedTF:Find("panel/animroot/cancel")
	arg0_3.confirmBtn = arg0_3.selectedTF:Find("panel/animroot/ok")
	arg0_3.dragBtn = CourtYardStoreyDragBtn.New(arg0_3.selectedTF:Find("panel/animroot"), arg0_3.rectTF)
	arg0_3.effectContainer = arg0_3._tf:Find("effects")

	local var0_3 = arg0_3.rootTF:Find("white"):GetComponent(typeof(Image)).material
	local var1_3 = arg0_3.rootTF:Find("green"):GetComponent(typeof(Image)).material
	local var2_3 = arg0_3.rootTF:Find("red"):GetComponent(typeof(Image)).material

	arg0_3.furnitureStateMgrs = {
		CourtyardFurnitureState.New(arg0_3._tf:Find("root/furnitureState"), arg0_3.rectTF, var0_3, var1_3, var2_3),
		CourtyardSpineFurnitureState.New(arg0_3._tf:Find("root/furnitureSpineState"), arg0_3.rectTF, var0_3, var1_3, var2_3)
	}

	arg0_3:InitPedestalModule()

	arg0_3.bg.localScale = Vector3(1.438, 1.438, 1)
end

function var0_0.GetFurnitureStateMgr(arg0_4, arg1_4)
	return arg1_4:IsSpine() and arg0_4.furnitureStateMgrs[2] or arg0_4.furnitureStateMgrs[1]
end

function var0_0.InitPedestalModule(arg0_5)
	arg0_5.pedestalModule = CourtYardPedestalModule.New(arg0_5.data, arg0_5.bg)
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(CourtYardEvent.INITED, arg0_6.OnInited)
	arg0_6:AddListener(CourtYardEvent.CREATE_ITEM, arg0_6.OnCreateItem)
	arg0_6:AddListener(CourtYardEvent.REMOVE_ITEM, arg0_6.OnRemoveItem)
	arg0_6:AddListener(CourtYardEvent.ADD_MAT_ITEM, arg0_6.OnAddMatItem)
	arg0_6:AddListener(CourtYardEvent.REMOVE_MAT_ITEM, arg0_6.OnRemoveMatItem)
	arg0_6:AddListener(CourtYardEvent.ADD_ITEM, arg0_6.OnAddItem)
	arg0_6:AddListener(CourtYardEvent.DRAG_ITEM, arg0_6.OnDragItem)
	arg0_6:AddListener(CourtYardEvent.DRAGING_ITEM, arg0_6.OnDragingItem)
	arg0_6:AddListener(CourtYardEvent.DRAG_ITEM_END, arg0_6.OnDragItemEnd)
	arg0_6:AddListener(CourtYardEvent.SELETED_ITEM, arg0_6.OnSelectedItem)
	arg0_6:AddListener(CourtYardEvent.UNSELETED_ITEM, arg0_6.OnUnSelectedItem)
	arg0_6:AddListener(CourtYardEvent.ENTER_EDIT_MODE, arg0_6.OnEnterEidtMode)
	arg0_6:AddListener(CourtYardEvent.EXIT_EDIT_MODE, arg0_6.OnExitEidtMode)
	arg0_6:AddListener(CourtYardEvent.ROTATE_ITEM, arg0_6.OnItemDirChange)
	arg0_6:AddListener(CourtYardEvent.ROTATE_ITEM_FAILED, arg0_6.OnRotateItemFailed)
	arg0_6:AddListener(CourtYardEvent.DETORY_ITEM, arg0_6.OnDestoryItem)
	arg0_6:AddListener(CourtYardEvent.CHILD_ITEM, arg0_6.OnChildItem)
	arg0_6:AddListener(CourtYardEvent.UN_CHILD_ITEM, arg0_6.OnUnChildItem)
	arg0_6:AddListener(CourtYardEvent.REMIND_SAVE, arg0_6.OnRemindSave)
	arg0_6:AddListener(CourtYardEvent.ADD_ITEM_FAILED, arg0_6.OnAddItemFailed)
	arg0_6:AddListener(CourtYardEvent.SHOW_FURNITURE_DESC, arg0_6.OnShowFurnitureDesc)
	arg0_6:AddListener(CourtYardEvent.ITEM_INTERACTION, arg0_6.OnItemInterAction)
	arg0_6:AddListener(CourtYardEvent.CLEAR_ITEM_INTERACTION, arg0_6.OnClearItemInterAction)
	arg0_6:AddListener(CourtYardEvent.ON_TOUCH_ITEM, arg0_6.OnTouchItem)
	arg0_6:AddListener(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, arg0_6.OnCancelTouchItem)
	arg0_6:AddListener(CourtYardEvent.ON_ITEM_PLAY_MUSIC, arg0_6.OnItemPlayMusic)
	arg0_6:AddListener(CourtYardEvent.ON_ITEM_STOP_MUSIC, arg0_6.OnItemStopMusic)
	arg0_6:AddListener(CourtYardEvent.ON_ADD_EFFECT, arg0_6.OnAddEffect)
	arg0_6:AddListener(CourtYardEvent.ON_REMOVE_EFFECT, arg0_6.OnRemoveEffect)
	arg0_6:AddListener(CourtYardEvent.DISABLE_ROTATE_ITEM, arg0_6.OnDisableRotation)
	arg0_6:AddListener(CourtYardEvent.TAKE_PHOTO, arg0_6.OnTakePhoto)
	arg0_6:AddListener(CourtYardEvent.END_TAKE_PHOTO, arg0_6.OnEndTakePhoto)
	arg0_6:AddListener(CourtYardEvent.ENTER_ARCH, arg0_6.OnEnterArch)
	arg0_6:AddListener(CourtYardEvent.EXIT_ARCH, arg0_6.OnExitArch)
	arg0_6:AddListener(CourtYardEvent.REMOVE_ILLEGALITY_ITEM, arg0_6.OnRemoveIllegalityItem)
	arg0_6:AddListener(CourtYardEvent.OPEN_LAYER, arg0_6.OnOpenLayer)
	arg0_6:AddListener(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, arg0_6.OnPlayMusicalInstruments)
	arg0_6:AddListener(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, arg0_6.OnStopPlayMusicalInstruments)
	arg0_6:AddListener(CourtYardEvent.FURNITURE_MUTE_ALL, arg0_6.OnMuteAll)
	arg0_6:AddListener(CourtYardEvent.BACK_PRESSED, arg0_6.OnBackPressed)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(CourtYardEvent.INITED, arg0_7.OnInited)
	arg0_7:RemoveListener(CourtYardEvent.CREATE_ITEM, arg0_7.OnCreateItem)
	arg0_7:RemoveListener(CourtYardEvent.REMOVE_ITEM, arg0_7.OnRemoveItem)
	arg0_7:RemoveListener(CourtYardEvent.ADD_MAT_ITEM, arg0_7.OnAddMatItem)
	arg0_7:RemoveListener(CourtYardEvent.REMOVE_MAT_ITEM, arg0_7.OnRemoveMatItem)
	arg0_7:RemoveListener(CourtYardEvent.ADD_ITEM, arg0_7.OnAddItem)
	arg0_7:RemoveListener(CourtYardEvent.DRAG_ITEM, arg0_7.OnDragItem)
	arg0_7:RemoveListener(CourtYardEvent.DRAGING_ITEM, arg0_7.OnDragingItem)
	arg0_7:RemoveListener(CourtYardEvent.DRAG_ITEM_END, arg0_7.OnDragItemEnd)
	arg0_7:RemoveListener(CourtYardEvent.SELETED_ITEM, arg0_7.OnSelectedItem)
	arg0_7:RemoveListener(CourtYardEvent.UNSELETED_ITEM, arg0_7.OnUnSelectedItem)
	arg0_7:RemoveListener(CourtYardEvent.ENTER_EDIT_MODE, arg0_7.OnEnterEidtMode)
	arg0_7:RemoveListener(CourtYardEvent.EXIT_EDIT_MODE, arg0_7.OnExitEidtMode)
	arg0_7:RemoveListener(CourtYardEvent.ROTATE_ITEM, arg0_7.OnItemDirChange)
	arg0_7:RemoveListener(CourtYardEvent.ROTATE_ITEM_FAILED, arg0_7.OnRotateItemFailed)
	arg0_7:RemoveListener(CourtYardEvent.DETORY_ITEM, arg0_7.OnDestoryItem)
	arg0_7:RemoveListener(CourtYardEvent.CHILD_ITEM, arg0_7.OnChildItem)
	arg0_7:RemoveListener(CourtYardEvent.UN_CHILD_ITEM, arg0_7.OnUnChildItem)
	arg0_7:RemoveListener(CourtYardEvent.REMIND_SAVE, arg0_7.OnRemindSave)
	arg0_7:RemoveListener(CourtYardEvent.ADD_ITEM_FAILED, arg0_7.OnAddItemFailed)
	arg0_7:RemoveListener(CourtYardEvent.SHOW_FURNITURE_DESC, arg0_7.OnShowFurnitureDesc)
	arg0_7:RemoveListener(CourtYardEvent.ITEM_INTERACTION, arg0_7.OnItemInterAction)
	arg0_7:RemoveListener(CourtYardEvent.CLEAR_ITEM_INTERACTION, arg0_7.OnClearItemInterAction)
	arg0_7:RemoveListener(CourtYardEvent.ON_TOUCH_ITEM, arg0_7.OnTouchItem)
	arg0_7:RemoveListener(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, arg0_7.OnCancelTouchItem)
	arg0_7:RemoveListener(CourtYardEvent.ON_ITEM_PLAY_MUSIC, arg0_7.OnItemPlayMusic)
	arg0_7:RemoveListener(CourtYardEvent.ON_ITEM_STOP_MUSIC, arg0_7.OnItemStopMusic)
	arg0_7:RemoveListener(CourtYardEvent.ON_ADD_EFFECT, arg0_7.OnAddEffect)
	arg0_7:RemoveListener(CourtYardEvent.ON_REMOVE_EFFECT, arg0_7.OnRemoveEffect)
	arg0_7:RemoveListener(CourtYardEvent.DISABLE_ROTATE_ITEM, arg0_7.OnDisableRotation)
	arg0_7:RemoveListener(CourtYardEvent.TAKE_PHOTO, arg0_7.OnTakePhoto)
	arg0_7:RemoveListener(CourtYardEvent.END_TAKE_PHOTO, arg0_7.OnEndTakePhoto)
	arg0_7:RemoveListener(CourtYardEvent.ENTER_ARCH, arg0_7.OnEnterArch)
	arg0_7:RemoveListener(CourtYardEvent.EXIT_ARCH, arg0_7.OnExitArch)
	arg0_7:RemoveListener(CourtYardEvent.REMOVE_ILLEGALITY_ITEM, arg0_7.OnRemoveIllegalityItem)
	arg0_7:RemoveListener(CourtYardEvent.OPEN_LAYER, arg0_7.OnOpenLayer)
	arg0_7:RemoveListener(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, arg0_7.OnPlayMusicalInstruments)
	arg0_7:RemoveListener(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, arg0_7.OnStopPlayMusicalInstruments)
	arg0_7:RemoveListener(CourtYardEvent.FURNITURE_MUTE_ALL, arg0_7.OnMuteAll)
	arg0_7:RemoveListener(CourtYardEvent.BACK_PRESSED, arg0_7.OnBackPressed)
end

function var0_0.OnInited(arg0_8)
	arg0_8.isInit = true

	if var1_0 then
		arg0_8.mapDebug = CourtYardMapDebug.New(arg0_8.data)
	end

	arg0_8:RefreshDepth()
	arg0_8:RefreshMatDepth()
end

function var0_0.AllModulesAreCompletion(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.modules) do
		if not iter1_9:IsCompletion() then
			return false
		end
	end

	return true
end

function var0_0.OnRemindSave(arg0_10)
	_BackyardMsgBoxMgr:Show({
		content = i18n("backyard_backyardScene_quest_saveFurniture"),
		onYes = function()
			arg0_10:Emit("SaveFurnitures")
		end,
		yesSound = SFX_FURNITRUE_SAVE,
		onNo = function()
			arg0_10:Emit("RestoreFurnitures")
		end
	})
end

function var0_0.OnEnterEidtMode(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.modules) do
		if isa(iter1_13, CourtYardShipModule) then
			iter1_13:SetActive(false)
		else
			iter1_13:BlocksRaycasts(true)
		end
	end

	arg0_13.bg.localScale = Vector3(0.95, 0.95, 1)
end

function var0_0.OnExitEidtMode(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.modules) do
		if isa(iter1_14, CourtYardShipModule) then
			iter1_14:SetActive(true)
		else
			iter1_14:BlocksRaycasts(false)
		end
	end
end

function var0_0.OnCreateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.factorys[arg1_15:GetObjType()]:Make(arg1_15)

	if arg2_15 then
		var0_15:CreateWhenStoreyInit()
	end

	arg0_15.modules[arg1_15:GetDeathType() .. arg1_15.id] = var0_15
end

function var0_0.OnAddItem(arg0_16)
	if not arg0_16.isInit then
		return
	end

	arg0_16:RefreshDepth()

	if var1_0 then
		arg0_16.mapDebug:Flush()
	end
end

function var0_0.OnRemoveItem(arg0_17, arg1_17)
	arg0_17:Item2Module(arg1_17):SetAsLastSibling()

	if var1_0 then
		arg0_17.mapDebug:Flush()
	end
end

function var0_0.OnSelectedItem(arg0_18, arg1_18, arg2_18)
	arg0_18.selectedModule = arg0_18:Item2Module(arg1_18)
	arg0_18.gridAgent = arg0_18:GetGridAgent(arg1_18, arg2_18)

	if isa(arg1_18, CourtYardFurniture) then
		arg0_18.selectedAnimation:Play("anim_courtyard_dragin")

		local var0_18 = arg0_18:Item2Module(arg1_18)

		arg0_18:InitFurnitureState(var0_18, arg1_18)
		setParent(arg0_18.selectedTF, arg0_18.rectTF)

		arg0_18.selectedTF.sizeDelta = var0_18._tf.sizeDelta

		arg0_18:UpdateSelectedPosition(arg1_18)
		arg0_18:RegisterOp(arg1_18)
	end
end

function var0_0.InitFurnitureState(arg0_19, arg1_19, arg2_19)
	arg0_19:GetFurnitureStateMgr(arg2_19):OnInit(arg1_19, arg2_19)
end

function var0_0.UpdateFurnitureState(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg0_20:GetFurnitureStateMgr(arg3_20)

	if _.any(arg2_20, function(arg0_21)
		return arg0_21.flag == 2
	end) then
		var0_20:OnCantPlace()
	else
		var0_20:OnCanPlace()
	end

	var0_20:OnUpdateScale(arg1_20)
end

function var0_0.ResetFurnitureSelectedState(arg0_22, arg1_22)
	local var0_22 = arg0_22:GetFurnitureStateMgr(arg1_22)
	local var1_22 = arg0_22:Item2Module(arg1_22)

	var0_22:OnReset(var1_22)
end

function var0_0.ClearFurnitureSelectedState(arg0_23, arg1_23)
	arg0_23:GetFurnitureStateMgr(arg1_23):OnClear()
end

function var0_0.OnDragItem(arg0_24, arg1_24)
	arg0_24:EnableZoom(false)
end

function var0_0.OnDragingItem(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = arg0_25:Item2Module(arg1_25)

	var0_25:UpdatePosition(arg3_25, arg4_25)
	arg0_25.gridAgent:Flush(arg2_25)

	if isa(arg1_25, CourtYardFurniture) then
		arg0_25:UpdateSelectedPosition(arg1_25)
		arg0_25:UpdateFurnitureState(var0_25, arg2_25, arg1_25)
	end
end

function var0_0.OnDragItemEnd(arg0_26, arg1_26, arg2_26)
	arg0_26:EnableZoom(true)

	if isa(arg1_26, CourtYardFurniture) then
		arg0_26.gridAgent:Flush(arg2_26)
		arg0_26:UpdateSelectedPosition(arg1_26)
		arg0_26:ResetFurnitureSelectedState(arg1_26)
	end
end

function var0_0.OnUnSelectedItem(arg0_27, arg1_27)
	arg0_27.selectedModule = nil

	arg0_27.gridAgent:Clear()

	arg0_27.gridAgent = nil

	if isa(arg1_27, CourtYardFurniture) then
		arg0_27.dftAniEvent:SetEndEvent(function()
			arg0_27.dftAniEvent:SetEndEvent(nil)
			setParent(arg0_27.selectedTF, arg0_27.rootTF)
		end)
		arg0_27:ClearFurnitureSelectedState(arg1_27)
		arg0_27.selectedAnimation:Play("anim_courtyard_dragout")
		arg0_27:UnRegisterOp()
	end
end

function var0_0.OnRemoveIllegalityItem(arg0_29)
	pg.TipsMgr.GetInstance():ShowTips("Remove illegal Item")
end

function var0_0.OnOpenLayer(arg0_30, arg1_30)
	for iter0_30, iter1_30 in pairs(arg0_30.modules) do
		if isa(iter1_30, CourtYardShipModule) then
			iter1_30:HideAttachment(arg1_30)
		end
	end
end

function var0_0.EnableZoom(arg0_31, arg1_31)
	arg0_31.zoomAgent.enabled = arg1_31
end

function var0_0.RegisterOp(arg0_32, arg1_32)
	setActive(arg0_32.rotationBtn, not arg1_32:DisableRotation())
	onButton(arg0_32, arg0_32.rotationBtn, function()
		arg0_32:Emit("RotateFurniture", arg1_32.id)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.confirmBtn, function()
		arg0_32:Emit("UnSelectFurniture", arg1_32.id)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.removeBtn, function()
		arg0_32:Emit("RemoveFurniture", arg1_32.id)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.scrollrect, function()
		arg0_32:Emit("UnSelectFurniture", arg1_32.id)
	end, SFX_PANEL)

	local function var0_32()
		arg0_32:Emit("BeginDragFurniture", arg1_32.id)
	end

	local function var1_32(arg0_38)
		arg0_32:Emit("DragingFurniture", arg1_32.id, arg0_38)
	end

	local function var2_32(arg0_39)
		arg0_32:Emit("DragFurnitureEnd", arg1_32.id, arg0_39)
	end

	arg0_32.dragBtn:Active(var0_32, var1_32, var2_32)
end

function var0_0.UnRegisterOp(arg0_40)
	removeOnButton(arg0_40.rotationBtn)
	removeOnButton(arg0_40.confirmBtn)
	removeOnButton(arg0_40.removeBtn)
	removeOnButton(arg0_40.scrollrect)
	arg0_40.dragBtn:DeActive(false)
end

function var0_0.OnItemDirChange(arg0_41, arg1_41, arg2_41)
	if isa(arg1_41, CourtYardFurniture) then
		arg0_41:UpdateSelectedPosition(arg1_41)

		if arg0_41.data:InEidtMode() and arg0_41.gridAgent then
			arg0_41.gridAgent:Flush(arg2_41)
		end

		arg0_41:GetFurnitureStateMgr(arg1_41):OnUpdateScale(arg0_41:Item2Module(arg1_41))
	else
		arg0_41.gridAgent:Flush(arg2_41)
	end
end

function var0_0.OnRotateItemFailed(arg0_42)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardScene_error_canNotRotate"))
end

function var0_0.OnDisableRotation(arg0_43)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardScene_Disable_Rotation"))
end

function var0_0.OnAddItemFailed(arg0_44)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardScene_error_noPosPutFurniture"))
end

function var0_0.OnDestoryItem(arg0_45, arg1_45)
	arg0_45:Item2Module(arg1_45):Dispose()

	arg0_45.modules[arg1_45:GetDeathType() .. arg1_45.id] = nil
end

function var0_0.OnChildItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46:Item2Module(arg1_46)
	local var1_46 = arg0_46:Item2Module(arg2_46)

	var1_46:AddChild(var0_46)

	if isa(arg1_46, CourtYardShip) then
		var1_46:BlocksRaycasts(true)
	end
end

function var0_0.OnUnChildItem(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg0_47:Item2Module(arg1_47)
	local var1_47 = arg0_47:Item2Module(arg2_47)

	var1_47:RemoveChild(var0_47)

	if isa(arg1_47, CourtYardShip) then
		var1_47:BlocksRaycasts(false)
	end
end

function var0_0.OnEnterArch(arg0_48, arg1_48, arg2_48)
	return
end

function var0_0.OnExitArch(arg0_49, arg1_49, arg2_49)
	return
end

function var0_0.OnAddMatItem(arg0_50)
	if not arg0_50.isInit then
		return
	end

	arg0_50:RefreshMatDepth()
end

function var0_0.OnRemoveMatItem(arg0_51, arg1_51)
	arg0_51:Item2Module(arg1_51):SetAsLastSibling()
end

function var0_0.OnShowFurnitureDesc(arg0_52, arg1_52)
	arg0_52.descPage:ExecuteAction("Show", arg1_52)
end

function var0_0.OnItemInterAction(arg0_53, arg1_53, arg2_53, arg3_53)
	local var0_53 = arg0_53:Item2Module(arg1_53)
	local var1_53 = arg0_53:Item2Module(arg2_53)

	var1_53:BlocksRaycasts(true)

	local var2_53 = {}

	if arg3_53:GetBodyMask() then
		table.insert(var2_53, var1_53:GetBodyMask(arg3_53.id))
	end

	local var3_53 = arg3_53:GetUsingAnimator()

	if var3_53 then
		table.insert(var2_53, var1_53:GetAnimator(var3_53.key))
	end

	local var4_53

	if #var2_53 == 0 then
		var0_53._tf:SetParent(var1_53.interactionTF)

		var4_53 = var0_53._tf
	else
		local var5_53 = var0_53._tf

		for iter0_53, iter1_53 in ipairs(var2_53) do
			var5_53:SetParent(iter1_53, false)

			var5_53 = iter1_53
		end

		var4_53 = var5_53

		local var6_53 = CourtYardCalcUtil.GetSign(var1_53._tf.localScale.x)
		local var7_53 = var0_53._tf.localScale

		var0_53._tf.localScale = Vector3(var6_53 * var7_53.x, var7_53.y, 1)
	end

	var0_53:SetSiblingIndex(arg3_53.id - 1)
	arg0_53.bgmAgent:Play(arg2_53:GetInterActionBgm())
	arg0_53:AddInteractionFollower(arg3_53, var4_53, var1_53)
end

function var0_0.OnClearItemInterAction(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54 = arg0_54:Item2Module(arg1_54)
	local var1_54 = arg0_54:Item2Module(arg2_54)

	if isa(var1_54, CourtYardFurnitureModule) and #arg2_54:GetUsingSlots() == 0 then
		var1_54:BlocksRaycasts(false)
	end

	local var2_54 = arg0_54:Item2Module(arg2_54)

	if arg3_54:GetBodyMask() then
		local var3_54 = var1_54:GetBodyMask(arg3_54.id)

		var3_54:SetParent(var1_54.interactionTF)

		local var4_54 = arg2_54:GetBodyMasks()[arg3_54.id]

		var3_54.sizeDelta = var4_54.size
		var3_54.anchoredPosition = var4_54.offset
	end

	var0_54._tf:SetParent(var0_54:GetParentTF())
	arg0_54.bgmAgent:Stop(arg2_54:GetInterActionBgm())
	arg0_54:ClearInteractionFollower(arg3_54, var0_54, var1_54)
end

function var0_0.AddInteractionFollower(arg0_55, arg1_55, arg2_55, arg3_55)
	local var0_55 = arg1_55:GetFollower()

	if not var0_55 or not arg2_55 then
		return
	end

	local var1_55 = var0_55.bone
	local var2_55 = arg3_55:FindBoneFollower(var1_55)

	if IsNil(var2_55) then
		var2_55 = arg3_55:NewBoneFollower(var1_55)
	else
		setActive(var2_55, true)
	end

	var2_55.localScale = Vector3(1, 1, 1)

	arg2_55:SetParent(var2_55, false)
end

function var0_0.ClearInteractionFollower(arg0_56, arg1_56, arg2_56, arg3_56)
	local var0_56 = arg1_56:GetFollower()

	if not var0_56 then
		return
	end

	local var1_56 = var0_56.bone
	local var2_56 = arg3_56:FindBoneFollower(var1_56)

	if not IsNil(var2_56) then
		setActive(var2_56, false)
	end
end

function var0_0.OnTouchItem(arg0_57, arg1_57)
	if isa(arg1_57, CourtYardFurniture) then
		arg0_57.effectAgent:EnableEffect(arg1_57:GetTouchEffect())
		arg0_57.soundAgent:Play(arg1_57:GetTouchSound())
		arg0_57.bgAgent:Switch(true, arg1_57:GetTouchBg())
	end
end

function var0_0.OnCancelTouchItem(arg0_58, arg1_58)
	if isa(arg1_58, CourtYardFurniture) then
		arg0_58.effectAgent:DisableEffect(arg1_58:GetTouchEffect())
		arg0_58.bgAgent:Switch(false, arg1_58:GetTouchBg())
	end
end

function var0_0.OnItemPlayMusic(arg0_59, arg1_59, arg2_59)
	if arg2_59 == 1 then
		arg0_59.soundAgent:Play(arg1_59)
	elseif arg2_59 == 2 then
		arg0_59.bgmAgent:Play(arg1_59)
	end
end

function var0_0.OnItemStopMusic(arg0_60, arg1_60, arg2_60)
	if arg2_60 == 2 then
		arg0_60.bgmAgent:Reset()
	elseif arg2_60 == 1 then
		arg0_60.soundAgent:Stop()
	end
end

function var0_0.OnMuteAll(arg0_61)
	arg0_61.bgmAgent:Clear()
	arg0_61.soundAgent:Clear()
end

function var0_0.OnPlayMusicalInstruments(arg0_62, arg1_62)
	if arg0_62.descPage and arg0_62.descPage:GetLoaded() and arg0_62.descPage:isShowing() then
		arg0_62.descPage:Close()
	end

	if arg1_62:GetType() == Furniture.TYPE_LUTE then
		arg0_62.playTheLutePage:ExecuteAction("Show", arg1_62)
	end
end

function var0_0.OnStopPlayMusicalInstruments(arg0_63, arg1_63)
	arg0_63.bgmAgent:Reset()

	if arg0_63.descPage and arg0_63.descPage:GetLoaded() then
		arg0_63.descPage:ExecuteAction("Show", arg1_63)
	end
end

function var0_0.OnAddEffect(arg0_64, arg1_64)
	arg0_64.effectAgent:EnableEffect(arg1_64)
end

function var0_0.OnRemoveEffect(arg0_65, arg1_65)
	arg0_65.effectAgent:DisableEffect(arg1_65)
end

function var0_0.OnBackPressed(arg0_66)
	if arg0_66.playTheLutePage and arg0_66.playTheLutePage:GetLoaded() and arg0_66.playTheLutePage:isShowing() then
		arg0_66.playTheLutePage:Hide()

		return
	end

	if arg0_66.descPage and arg0_66.descPage:GetLoaded() and arg0_66.descPage:isShowing() then
		arg0_66.descPage:Close()

		return
	end

	arg0_66:Emit("Quit")
end

function var0_0.UpdateSelectedPosition(arg0_67, arg1_67)
	local var0_67 = arg0_67:Item2Module(arg1_67)
	local var1_67 = var0_67:GetCenterPoint()

	arg0_67.selectedTF.localPosition = var1_67

	arg0_67:GetFurnitureStateMgr(arg1_67):OnUpdate(var0_67)
end

function var0_0.GetGridAgent(arg0_68, arg1_68, arg2_68)
	local var0_68

	if isa(arg1_68, CourtYardWallFurniture) then
		var0_68 = arg0_68.gridAgents[2]
	else
		var0_68 = arg0_68.gridAgents[1]
	end

	if arg0_68.gridAgent and var0_68 ~= arg0_68.gridAgent then
		arg0_68.gridAgent:Clear()
	end

	var0_68:Reset(arg2_68)

	return var0_68
end

function var0_0.ItemsIsLoaded(arg0_69)
	if table.getCount(arg0_69.modules) == 0 then
		return false
	end

	for iter0_69, iter1_69 in pairs(arg0_69.modules) do
		if not iter1_69:IsInit() then
			return false
		end
	end

	return true
end

function var0_0.Item2Module(arg0_70, arg1_70)
	return arg0_70.modules[arg1_70:GetDeathType() .. arg1_70.id]
end

function var0_0.RefreshDepth(arg0_71)
	for iter0_71, iter1_71 in ipairs(arg0_71.data:GetItems()) do
		arg0_71:Item2Module(iter1_71):SetSiblingIndex(iter0_71 - 1)
	end
end

function var0_0.RefreshMatDepth(arg0_72)
	for iter0_72, iter1_72 in ipairs(arg0_72.data:GetMatItems()) do
		arg0_72:Item2Module(iter1_72):SetSiblingIndex(iter0_72 - 1)
	end
end

function var0_0.OnTakePhoto(arg0_73)
	GetOrAddComponent(arg0_73.selectedTF, typeof(CanvasGroup)).alpha = 0

	local var0_73 = Vector3(0.6, 0.6, 1)

	arg0_73.bgScale = arg0_73.bg.localScale
	arg0_73.bg.localScale = var0_73

	if arg0_73.bg.localPosition ~= Vector3(0, -100, 0) then
		arg0_73.bgPos = arg0_73.bg.localPosition
		arg0_73.bg.localPosition = Vector3(0, -100, 0)
	end
end

function var0_0.OnEndTakePhoto(arg0_74)
	GetOrAddComponent(arg0_74.selectedTF, typeof(CanvasGroup)).alpha = 1

	if arg0_74.bgScale then
		arg0_74.bg.localScale = arg0_74.bgScale
	end

	if arg0_74.bgPos then
		arg0_74.bg.localPosition = arg0_74.bgPos
	end
end

function var0_0.OnDispose(arg0_75)
	arg0_75.exited = true

	arg0_75.dftAniEvent:SetEndEvent(nil)

	for iter0_75, iter1_75 in pairs(arg0_75.modules) do
		iter1_75:Dispose()
	end

	arg0_75.modules = nil

	for iter2_75, iter3_75 in pairs(arg0_75.factorys) do
		iter3_75:Dispose()
	end

	arg0_75.factorys = nil

	arg0_75.dragBtn:Dispose()

	arg0_75.dragBtn = nil

	for iter4_75, iter5_75 in pairs(arg0_75.gridAgents) do
		iter5_75:Dispose()
	end

	arg0_75.gridAgents = nil

	if var1_0 then
		arg0_75.mapDebug:Dispose()
	end

	if arg0_75.pedestalModule then
		arg0_75.pedestalModule:Dispose()

		arg0_75.pedestalModule = nil
	end

	arg0_75.effectAgent:Dispose()

	arg0_75.effectAgent = nil

	arg0_75.soundAgent:Dispose()

	arg0_75.soundAgent = nil

	arg0_75.bgAgent:Dispose()

	arg0_75.bgAgent = nil

	arg0_75.bgmAgent:Dispose()

	arg0_75.bgmAgent = nil

	arg0_75.descPage:Destroy()

	arg0_75.descPage = nil

	arg0_75.playTheLutePage:Destroy()

	arg0_75.playTheLutePage = nil

	if not IsNil(arg0_75._go) then
		Object.Destroy(arg0_75._go)
	end
end

return var0_0
