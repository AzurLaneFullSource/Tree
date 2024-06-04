local var0 = class("CourtYardStoreyModule", import("..CourtYardBaseModule"))
local var1 = false

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.modules = {}
	arg0.gridAgents = {
		CourtYardGridAgent.New(arg0),
		CourtYardWallGridAgent.New(arg0)
	}
	arg0.effectAgent = CourtYardEffectAgent.New(arg0)
	arg0.soundAgent = CourtYardSoundAgent.New(arg0)
	arg0.bgAgent = CourtYardBGAgent.New(arg0)
	arg0.bgmAgent = CourtYardBGMAgent.New(arg0)
	arg0.factorys = {
		[CourtYardConst.OBJ_TYPE_SHIP] = CourtYardShipFactory.New(arg0:GetView().poolMgr),
		[CourtYardConst.OBJ_TYPE_COMMOM] = CourtYardFurnitureFactory.New(arg0:GetView().poolMgr)
	}
	arg0.descPage = CourtYardFurnitureDescPage.New(arg0)
	arg0.playTheLutePage = CourtyardPlayTheLutePage.New(arg0)
end

function var0.GetDefaultBgm(arg0)
	return pg.voice_bgm.CourtYardScene.default_bgm
end

function var0.OnInit(arg0)
	arg0.zoomAgent = arg0._tf:Find("bg"):GetComponent("PinchZoom")
	arg0.scrollrect = arg0._tf:Find("scroll_view")
	arg0.bg = arg0._tf:Find("bg")
	arg0.rectTF = arg0._tf:Find("bg/rect")
	arg0.gridsTF = arg0.rectTF:Find("grids")
	arg0.rootTF = arg0._tf:Find("root")
	arg0.selectedTF = arg0._tf:Find("root/drag")
	arg0.selectedAnimation = arg0.selectedTF:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0.selectedTF:GetComponent(typeof(DftAniEvent))
	arg0.rotationBtn = arg0.selectedTF:Find("panel/animroot/rotation")
	arg0.removeBtn = arg0.selectedTF:Find("panel/animroot/cancel")
	arg0.confirmBtn = arg0.selectedTF:Find("panel/animroot/ok")
	arg0.dragBtn = CourtYardStoreyDragBtn.New(arg0.selectedTF:Find("panel/animroot"), arg0.rectTF)
	arg0.effectContainer = arg0._tf:Find("effects")

	local var0 = arg0.rootTF:Find("white"):GetComponent(typeof(Image)).material
	local var1 = arg0.rootTF:Find("green"):GetComponent(typeof(Image)).material
	local var2 = arg0.rootTF:Find("red"):GetComponent(typeof(Image)).material

	arg0.furnitureStateMgrs = {
		CourtyardFurnitureState.New(arg0._tf:Find("root/furnitureState"), arg0.rectTF, var0, var1, var2),
		CourtyardSpineFurnitureState.New(arg0._tf:Find("root/furnitureSpineState"), arg0.rectTF, var0, var1, var2)
	}

	arg0:InitPedestalModule()

	arg0.bg.localScale = Vector3(1.438, 1.438, 1)
end

function var0.GetFurnitureStateMgr(arg0, arg1)
	return arg1:IsSpine() and arg0.furnitureStateMgrs[2] or arg0.furnitureStateMgrs[1]
end

function var0.InitPedestalModule(arg0)
	arg0.pedestalModule = CourtYardPedestalModule.New(arg0.data, arg0.bg)
end

function var0.AddListeners(arg0)
	arg0:AddListener(CourtYardEvent.INITED, arg0.OnInited)
	arg0:AddListener(CourtYardEvent.CREATE_ITEM, arg0.OnCreateItem)
	arg0:AddListener(CourtYardEvent.REMOVE_ITEM, arg0.OnRemoveItem)
	arg0:AddListener(CourtYardEvent.ADD_MAT_ITEM, arg0.OnAddMatItem)
	arg0:AddListener(CourtYardEvent.REMOVE_MAT_ITEM, arg0.OnRemoveMatItem)
	arg0:AddListener(CourtYardEvent.ADD_ITEM, arg0.OnAddItem)
	arg0:AddListener(CourtYardEvent.DRAG_ITEM, arg0.OnDragItem)
	arg0:AddListener(CourtYardEvent.DRAGING_ITEM, arg0.OnDragingItem)
	arg0:AddListener(CourtYardEvent.DRAG_ITEM_END, arg0.OnDragItemEnd)
	arg0:AddListener(CourtYardEvent.SELETED_ITEM, arg0.OnSelectedItem)
	arg0:AddListener(CourtYardEvent.UNSELETED_ITEM, arg0.OnUnSelectedItem)
	arg0:AddListener(CourtYardEvent.ENTER_EDIT_MODE, arg0.OnEnterEidtMode)
	arg0:AddListener(CourtYardEvent.EXIT_EDIT_MODE, arg0.OnExitEidtMode)
	arg0:AddListener(CourtYardEvent.ROTATE_ITEM, arg0.OnItemDirChange)
	arg0:AddListener(CourtYardEvent.ROTATE_ITEM_FAILED, arg0.OnRotateItemFailed)
	arg0:AddListener(CourtYardEvent.DETORY_ITEM, arg0.OnDestoryItem)
	arg0:AddListener(CourtYardEvent.CHILD_ITEM, arg0.OnChildItem)
	arg0:AddListener(CourtYardEvent.UN_CHILD_ITEM, arg0.OnUnChildItem)
	arg0:AddListener(CourtYardEvent.REMIND_SAVE, arg0.OnRemindSave)
	arg0:AddListener(CourtYardEvent.ADD_ITEM_FAILED, arg0.OnAddItemFailed)
	arg0:AddListener(CourtYardEvent.SHOW_FURNITURE_DESC, arg0.OnShowFurnitureDesc)
	arg0:AddListener(CourtYardEvent.ITEM_INTERACTION, arg0.OnItemInterAction)
	arg0:AddListener(CourtYardEvent.CLEAR_ITEM_INTERACTION, arg0.OnClearItemInterAction)
	arg0:AddListener(CourtYardEvent.ON_TOUCH_ITEM, arg0.OnTouchItem)
	arg0:AddListener(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, arg0.OnCancelTouchItem)
	arg0:AddListener(CourtYardEvent.ON_ITEM_PLAY_MUSIC, arg0.OnItemPlayMusic)
	arg0:AddListener(CourtYardEvent.ON_ITEM_STOP_MUSIC, arg0.OnItemStopMusic)
	arg0:AddListener(CourtYardEvent.ON_ADD_EFFECT, arg0.OnAddEffect)
	arg0:AddListener(CourtYardEvent.ON_REMOVE_EFFECT, arg0.OnRemoveEffect)
	arg0:AddListener(CourtYardEvent.DISABLE_ROTATE_ITEM, arg0.OnDisableRotation)
	arg0:AddListener(CourtYardEvent.TAKE_PHOTO, arg0.OnTakePhoto)
	arg0:AddListener(CourtYardEvent.END_TAKE_PHOTO, arg0.OnEndTakePhoto)
	arg0:AddListener(CourtYardEvent.ENTER_ARCH, arg0.OnEnterArch)
	arg0:AddListener(CourtYardEvent.EXIT_ARCH, arg0.OnExitArch)
	arg0:AddListener(CourtYardEvent.REMOVE_ILLEGALITY_ITEM, arg0.OnRemoveIllegalityItem)
	arg0:AddListener(CourtYardEvent.OPEN_LAYER, arg0.OnOpenLayer)
	arg0:AddListener(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, arg0.OnPlayMusicalInstruments)
	arg0:AddListener(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, arg0.OnStopPlayMusicalInstruments)
	arg0:AddListener(CourtYardEvent.FURNITURE_MUTE_ALL, arg0.OnMuteAll)
	arg0:AddListener(CourtYardEvent.BACK_PRESSED, arg0.OnBackPressed)
end

function var0.RemoveListeners(arg0)
	arg0:RemoveListener(CourtYardEvent.INITED, arg0.OnInited)
	arg0:RemoveListener(CourtYardEvent.CREATE_ITEM, arg0.OnCreateItem)
	arg0:RemoveListener(CourtYardEvent.REMOVE_ITEM, arg0.OnRemoveItem)
	arg0:RemoveListener(CourtYardEvent.ADD_MAT_ITEM, arg0.OnAddMatItem)
	arg0:RemoveListener(CourtYardEvent.REMOVE_MAT_ITEM, arg0.OnRemoveMatItem)
	arg0:RemoveListener(CourtYardEvent.ADD_ITEM, arg0.OnAddItem)
	arg0:RemoveListener(CourtYardEvent.DRAG_ITEM, arg0.OnDragItem)
	arg0:RemoveListener(CourtYardEvent.DRAGING_ITEM, arg0.OnDragingItem)
	arg0:RemoveListener(CourtYardEvent.DRAG_ITEM_END, arg0.OnDragItemEnd)
	arg0:RemoveListener(CourtYardEvent.SELETED_ITEM, arg0.OnSelectedItem)
	arg0:RemoveListener(CourtYardEvent.UNSELETED_ITEM, arg0.OnUnSelectedItem)
	arg0:RemoveListener(CourtYardEvent.ENTER_EDIT_MODE, arg0.OnEnterEidtMode)
	arg0:RemoveListener(CourtYardEvent.EXIT_EDIT_MODE, arg0.OnExitEidtMode)
	arg0:RemoveListener(CourtYardEvent.ROTATE_ITEM, arg0.OnItemDirChange)
	arg0:RemoveListener(CourtYardEvent.ROTATE_ITEM_FAILED, arg0.OnRotateItemFailed)
	arg0:RemoveListener(CourtYardEvent.DETORY_ITEM, arg0.OnDestoryItem)
	arg0:RemoveListener(CourtYardEvent.CHILD_ITEM, arg0.OnChildItem)
	arg0:RemoveListener(CourtYardEvent.UN_CHILD_ITEM, arg0.OnUnChildItem)
	arg0:RemoveListener(CourtYardEvent.REMIND_SAVE, arg0.OnRemindSave)
	arg0:RemoveListener(CourtYardEvent.ADD_ITEM_FAILED, arg0.OnAddItemFailed)
	arg0:RemoveListener(CourtYardEvent.SHOW_FURNITURE_DESC, arg0.OnShowFurnitureDesc)
	arg0:RemoveListener(CourtYardEvent.ITEM_INTERACTION, arg0.OnItemInterAction)
	arg0:RemoveListener(CourtYardEvent.CLEAR_ITEM_INTERACTION, arg0.OnClearItemInterAction)
	arg0:RemoveListener(CourtYardEvent.ON_TOUCH_ITEM, arg0.OnTouchItem)
	arg0:RemoveListener(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, arg0.OnCancelTouchItem)
	arg0:RemoveListener(CourtYardEvent.ON_ITEM_PLAY_MUSIC, arg0.OnItemPlayMusic)
	arg0:RemoveListener(CourtYardEvent.ON_ITEM_STOP_MUSIC, arg0.OnItemStopMusic)
	arg0:RemoveListener(CourtYardEvent.ON_ADD_EFFECT, arg0.OnAddEffect)
	arg0:RemoveListener(CourtYardEvent.ON_REMOVE_EFFECT, arg0.OnRemoveEffect)
	arg0:RemoveListener(CourtYardEvent.DISABLE_ROTATE_ITEM, arg0.OnDisableRotation)
	arg0:RemoveListener(CourtYardEvent.TAKE_PHOTO, arg0.OnTakePhoto)
	arg0:RemoveListener(CourtYardEvent.END_TAKE_PHOTO, arg0.OnEndTakePhoto)
	arg0:RemoveListener(CourtYardEvent.ENTER_ARCH, arg0.OnEnterArch)
	arg0:RemoveListener(CourtYardEvent.EXIT_ARCH, arg0.OnExitArch)
	arg0:RemoveListener(CourtYardEvent.REMOVE_ILLEGALITY_ITEM, arg0.OnRemoveIllegalityItem)
	arg0:RemoveListener(CourtYardEvent.OPEN_LAYER, arg0.OnOpenLayer)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, arg0.OnPlayMusicalInstruments)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, arg0.OnStopPlayMusicalInstruments)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_MUTE_ALL, arg0.OnMuteAll)
	arg0:RemoveListener(CourtYardEvent.BACK_PRESSED, arg0.OnBackPressed)
end

function var0.OnInited(arg0)
	arg0.isInit = true

	if var1 then
		arg0.mapDebug = CourtYardMapDebug.New(arg0.data)
	end

	arg0:RefreshDepth()
	arg0:RefreshMatDepth()
end

function var0.AllModulesAreCompletion(arg0)
	for iter0, iter1 in pairs(arg0.modules) do
		if not iter1:IsCompletion() then
			return false
		end
	end

	return true
end

function var0.OnRemindSave(arg0)
	_BackyardMsgBoxMgr:Show({
		content = i18n("backyard_backyardScene_quest_saveFurniture"),
		onYes = function()
			arg0:Emit("SaveFurnitures")
		end,
		yesSound = SFX_FURNITRUE_SAVE,
		onNo = function()
			arg0:Emit("RestoreFurnitures")
		end
	})
end

function var0.OnEnterEidtMode(arg0)
	for iter0, iter1 in pairs(arg0.modules) do
		if isa(iter1, CourtYardShipModule) then
			iter1:SetActive(false)
		else
			iter1:BlocksRaycasts(true)
		end
	end

	arg0.bg.localScale = Vector3(0.95, 0.95, 1)
end

function var0.OnExitEidtMode(arg0)
	for iter0, iter1 in pairs(arg0.modules) do
		if isa(iter1, CourtYardShipModule) then
			iter1:SetActive(true)
		else
			iter1:BlocksRaycasts(false)
		end
	end
end

function var0.OnCreateItem(arg0, arg1, arg2)
	local var0 = arg0.factorys[arg1:GetObjType()]:Make(arg1)

	if arg2 then
		var0:CreateWhenStoreyInit()
	end

	arg0.modules[arg1:GetDeathType() .. arg1.id] = var0
end

function var0.OnAddItem(arg0)
	if not arg0.isInit then
		return
	end

	arg0:RefreshDepth()

	if var1 then
		arg0.mapDebug:Flush()
	end
end

function var0.OnRemoveItem(arg0, arg1)
	arg0:Item2Module(arg1):SetAsLastSibling()

	if var1 then
		arg0.mapDebug:Flush()
	end
end

function var0.OnSelectedItem(arg0, arg1, arg2)
	arg0.selectedModule = arg0:Item2Module(arg1)
	arg0.gridAgent = arg0:GetGridAgent(arg1, arg2)

	if isa(arg1, CourtYardFurniture) then
		arg0.selectedAnimation:Play("anim_courtyard_dragin")

		local var0 = arg0:Item2Module(arg1)

		arg0:InitFurnitureState(var0, arg1)
		setParent(arg0.selectedTF, arg0.rectTF)

		arg0.selectedTF.sizeDelta = var0._tf.sizeDelta

		arg0:UpdateSelectedPosition(arg1)
		arg0:RegisterOp(arg1)
	end
end

function var0.InitFurnitureState(arg0, arg1, arg2)
	arg0:GetFurnitureStateMgr(arg2):OnInit(arg1, arg2)
end

function var0.UpdateFurnitureState(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetFurnitureStateMgr(arg3)

	if _.any(arg2, function(arg0)
		return arg0.flag == 2
	end) then
		var0:OnCantPlace()
	else
		var0:OnCanPlace()
	end
end

function var0.ResetFurnitureSelectedState(arg0, arg1)
	local var0 = arg0:GetFurnitureStateMgr(arg1)
	local var1 = arg0:Item2Module(arg1)

	var0:OnReset(var1)
end

function var0.ClearFurnitureSelectedState(arg0, arg1)
	arg0:GetFurnitureStateMgr(arg1):OnClear()
end

function var0.OnDragItem(arg0, arg1)
	arg0:EnableZoom(false)
end

function var0.OnDragingItem(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:Item2Module(arg1)

	var0:UpdatePosition(arg3, arg4)
	arg0.gridAgent:Flush(arg2)

	if isa(arg1, CourtYardFurniture) then
		arg0:UpdateSelectedPosition(arg1)
		arg0:UpdateFurnitureState(var0, arg2, arg1)
	end
end

function var0.OnDragItemEnd(arg0, arg1, arg2)
	arg0:EnableZoom(true)

	if isa(arg1, CourtYardFurniture) then
		arg0.gridAgent:Flush(arg2)
		arg0:UpdateSelectedPosition(arg1)
		arg0:ResetFurnitureSelectedState(arg1)
	end
end

function var0.OnUnSelectedItem(arg0, arg1)
	arg0.selectedModule = nil

	arg0.gridAgent:Clear()

	arg0.gridAgent = nil

	if isa(arg1, CourtYardFurniture) then
		arg0.dftAniEvent:SetEndEvent(function()
			arg0.dftAniEvent:SetEndEvent(nil)
			setParent(arg0.selectedTF, arg0.rootTF)
		end)
		arg0:ClearFurnitureSelectedState(arg1)
		arg0.selectedAnimation:Play("anim_courtyard_dragout")
		arg0:UnRegisterOp()
	end
end

function var0.OnRemoveIllegalityItem(arg0)
	pg.TipsMgr.GetInstance():ShowTips("Remove illegal Item")
end

function var0.OnOpenLayer(arg0, arg1)
	for iter0, iter1 in pairs(arg0.modules) do
		if isa(iter1, CourtYardShipModule) then
			iter1:HideAttachment(arg1)
		end
	end
end

function var0.EnableZoom(arg0, arg1)
	arg0.zoomAgent.enabled = arg1
end

function var0.RegisterOp(arg0, arg1)
	setActive(arg0.rotationBtn, not arg1:DisableRotation())
	onButton(arg0, arg0.rotationBtn, function()
		arg0:Emit("RotateFurniture", arg1.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Emit("UnSelectFurniture", arg1.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.removeBtn, function()
		arg0:Emit("RemoveFurniture", arg1.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.scrollrect, function()
		arg0:Emit("UnSelectFurniture", arg1.id)
	end, SFX_PANEL)

	local function var0()
		arg0:Emit("BeginDragFurniture", arg1.id)
	end

	local function var1(arg0)
		arg0:Emit("DragingFurniture", arg1.id, arg0)
	end

	local function var2(arg0)
		arg0:Emit("DragFurnitureEnd", arg1.id, arg0)
	end

	arg0.dragBtn:Active(var0, var1, var2)
end

function var0.UnRegisterOp(arg0)
	removeOnButton(arg0.rotationBtn)
	removeOnButton(arg0.confirmBtn)
	removeOnButton(arg0.removeBtn)
	removeOnButton(arg0.scrollrect)
	arg0.dragBtn:DeActive(false)
end

function var0.OnItemDirChange(arg0, arg1, arg2)
	if isa(arg1, CourtYardFurniture) then
		arg0:UpdateSelectedPosition(arg1)

		if arg0.data:InEidtMode() and arg0.gridAgent then
			arg0.gridAgent:Flush(arg2)
		end

		arg0:GetFurnitureStateMgr(arg1):OnUpdateScale(arg0:Item2Module(arg1))
	else
		arg0.gridAgent:Flush(arg2)
	end
end

function var0.OnRotateItemFailed(arg0)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardScene_error_canNotRotate"))
end

function var0.OnDisableRotation(arg0)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardScene_Disable_Rotation"))
end

function var0.OnAddItemFailed(arg0)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardScene_error_noPosPutFurniture"))
end

function var0.OnDestoryItem(arg0, arg1)
	arg0:Item2Module(arg1):Dispose()

	arg0.modules[arg1:GetDeathType() .. arg1.id] = nil
end

function var0.OnChildItem(arg0, arg1, arg2)
	local var0 = arg0:Item2Module(arg1)
	local var1 = arg0:Item2Module(arg2)

	var1:AddChild(var0)

	if isa(arg1, CourtYardShip) then
		var1:BlocksRaycasts(true)
	end
end

function var0.OnUnChildItem(arg0, arg1, arg2)
	local var0 = arg0:Item2Module(arg1)
	local var1 = arg0:Item2Module(arg2)

	var1:RemoveChild(var0)

	if isa(arg1, CourtYardShip) then
		var1:BlocksRaycasts(false)
	end
end

function var0.OnEnterArch(arg0, arg1, arg2)
	return
end

function var0.OnExitArch(arg0, arg1, arg2)
	return
end

function var0.OnAddMatItem(arg0)
	if not arg0.isInit then
		return
	end

	arg0:RefreshMatDepth()
end

function var0.OnRemoveMatItem(arg0, arg1)
	arg0:Item2Module(arg1):SetAsLastSibling()
end

function var0.OnShowFurnitureDesc(arg0, arg1)
	arg0.descPage:ExecuteAction("Show", arg1)
end

function var0.OnItemInterAction(arg0, arg1, arg2, arg3)
	local var0 = arg0:Item2Module(arg1)
	local var1 = arg0:Item2Module(arg2)

	var1:BlocksRaycasts(true)

	local var2 = {}

	if arg3:GetBodyMask() then
		table.insert(var2, var1:GetBodyMask(arg3.id))
	end

	local var3 = arg3:GetUsingAnimator()

	if var3 then
		table.insert(var2, var1:GetAnimator(var3.key))
	end

	local var4

	if #var2 == 0 then
		var0._tf:SetParent(var1.interactionTF)

		var4 = var0._tf
	else
		local var5 = var0._tf

		for iter0, iter1 in ipairs(var2) do
			var5:SetParent(iter1, false)

			var5 = iter1
		end

		var4 = var5

		local var6 = CourtYardCalcUtil.GetSign(var1._tf.localScale.x)
		local var7 = var0._tf.localScale

		var0._tf.localScale = Vector3(var6 * var7.x, var7.y, 1)
	end

	var0:SetSiblingIndex(arg3.id - 1)
	arg0.bgmAgent:Play(arg2:GetInterActionBgm())
	arg0:AddInteractionFollower(arg3, var4, var1)
end

function var0.OnClearItemInterAction(arg0, arg1, arg2, arg3)
	local var0 = arg0:Item2Module(arg1)
	local var1 = arg0:Item2Module(arg2)

	if isa(var1, CourtYardFurnitureModule) and #arg2:GetUsingSlots() == 0 then
		var1:BlocksRaycasts(false)
	end

	local var2 = arg0:Item2Module(arg2)

	if arg3:GetBodyMask() then
		local var3 = var1:GetBodyMask(arg3.id)

		var3:SetParent(var1.interactionTF)

		local var4 = arg2:GetBodyMasks()[arg3.id]

		var3.sizeDelta = var4.size
		var3.anchoredPosition = var4.offset
	end

	var0._tf:SetParent(var0:GetParentTF())
	arg0.bgmAgent:Stop(arg2:GetInterActionBgm())
	arg0:ClearInteractionFollower(arg3, var0, var1)
end

function var0.AddInteractionFollower(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetFollower()

	if not var0 or not arg2 then
		return
	end

	local var1 = var0.bone
	local var2 = arg3:FindBoneFollower(var1)

	if IsNil(var2) then
		var2 = arg3:NewBoneFollower(var1)
	else
		setActive(var2, true)
	end

	var2.localScale = Vector3(1, 1, 1)

	arg2:SetParent(var2, false)
end

function var0.ClearInteractionFollower(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetFollower()

	if not var0 then
		return
	end

	local var1 = var0.bone
	local var2 = arg3:FindBoneFollower(var1)

	if not IsNil(var2) then
		setActive(var2, false)
	end
end

function var0.OnTouchItem(arg0, arg1)
	if isa(arg1, CourtYardFurniture) then
		arg0.effectAgent:EnableEffect(arg1:GetTouchEffect())
		arg0.soundAgent:Play(arg1:GetTouchSound())
		arg0.bgAgent:Switch(true, arg1:GetTouchBg())
	end
end

function var0.OnCancelTouchItem(arg0, arg1)
	if isa(arg1, CourtYardFurniture) then
		arg0.effectAgent:DisableEffect(arg1:GetTouchEffect())
		arg0.bgAgent:Switch(false, arg1:GetTouchBg())
	end
end

function var0.OnItemPlayMusic(arg0, arg1, arg2)
	if arg2 == 1 then
		arg0.soundAgent:Play(arg1)
	elseif arg2 == 2 then
		arg0.bgmAgent:Play(arg1)
	end
end

function var0.OnItemStopMusic(arg0, arg1, arg2)
	if arg2 == 2 then
		arg0.bgmAgent:Reset()
	elseif arg2 == 1 then
		arg0.soundAgent:Stop()
	end
end

function var0.OnMuteAll(arg0)
	arg0.bgmAgent:Clear()
	arg0.soundAgent:Clear()
end

function var0.OnPlayMusicalInstruments(arg0, arg1)
	if arg0.descPage and arg0.descPage:GetLoaded() and arg0.descPage:isShowing() then
		arg0.descPage:Close()
	end

	if arg1:GetType() == Furniture.TYPE_LUTE then
		arg0.playTheLutePage:ExecuteAction("Show", arg1)
	end
end

function var0.OnStopPlayMusicalInstruments(arg0, arg1)
	arg0.bgmAgent:Reset()

	if arg0.descPage and arg0.descPage:GetLoaded() then
		arg0.descPage:ExecuteAction("Show", arg1)
	end
end

function var0.OnAddEffect(arg0, arg1)
	arg0.effectAgent:EnableEffect(arg1)
end

function var0.OnRemoveEffect(arg0, arg1)
	arg0.effectAgent:DisableEffect(arg1)
end

function var0.OnBackPressed(arg0)
	if arg0.playTheLutePage and arg0.playTheLutePage:GetLoaded() and arg0.playTheLutePage:isShowing() then
		arg0.playTheLutePage:Hide()

		return
	end

	if arg0.descPage and arg0.descPage:GetLoaded() and arg0.descPage:isShowing() then
		arg0.descPage:Close()

		return
	end

	arg0:Emit("Quit")
end

function var0.UpdateSelectedPosition(arg0, arg1)
	local var0 = arg0:Item2Module(arg1)
	local var1 = var0:GetCenterPoint()

	arg0.selectedTF.localPosition = var1

	arg0:GetFurnitureStateMgr(arg1):OnUpdate(var0)
end

function var0.GetGridAgent(arg0, arg1, arg2)
	local var0

	if isa(arg1, CourtYardWallFurniture) then
		var0 = arg0.gridAgents[2]
	else
		var0 = arg0.gridAgents[1]
	end

	if arg0.gridAgent and var0 ~= arg0.gridAgent then
		arg0.gridAgent:Clear()
	end

	var0:Reset(arg2)

	return var0
end

function var0.ItemsIsLoaded(arg0)
	if table.getCount(arg0.modules) == 0 then
		return false
	end

	for iter0, iter1 in pairs(arg0.modules) do
		if not iter1:IsInit() then
			return false
		end
	end

	return true
end

function var0.Item2Module(arg0, arg1)
	return arg0.modules[arg1:GetDeathType() .. arg1.id]
end

function var0.RefreshDepth(arg0)
	for iter0, iter1 in ipairs(arg0.data:GetItems()) do
		arg0:Item2Module(iter1):SetSiblingIndex(iter0 - 1)
	end
end

function var0.RefreshMatDepth(arg0)
	for iter0, iter1 in ipairs(arg0.data:GetMatItems()) do
		arg0:Item2Module(iter1):SetSiblingIndex(iter0 - 1)
	end
end

function var0.OnTakePhoto(arg0)
	GetOrAddComponent(arg0.selectedTF, typeof(CanvasGroup)).alpha = 0

	local var0 = Vector3(0.6, 0.6, 1)

	arg0.bgScale = arg0.bg.localScale
	arg0.bg.localScale = var0

	if arg0.bg.localPosition ~= Vector3(0, -100, 0) then
		arg0.bgPos = arg0.bg.localPosition
		arg0.bg.localPosition = Vector3(0, -100, 0)
	end
end

function var0.OnEndTakePhoto(arg0)
	GetOrAddComponent(arg0.selectedTF, typeof(CanvasGroup)).alpha = 1

	if arg0.bgScale then
		arg0.bg.localScale = arg0.bgScale
	end

	if arg0.bgPos then
		arg0.bg.localPosition = arg0.bgPos
	end
end

function var0.OnDispose(arg0)
	arg0.exited = true

	arg0.dftAniEvent:SetEndEvent(nil)

	for iter0, iter1 in pairs(arg0.modules) do
		iter1:Dispose()
	end

	arg0.modules = nil

	for iter2, iter3 in pairs(arg0.factorys) do
		iter3:Dispose()
	end

	arg0.factorys = nil

	arg0.dragBtn:Dispose()

	arg0.dragBtn = nil

	for iter4, iter5 in pairs(arg0.gridAgents) do
		iter5:Dispose()
	end

	arg0.gridAgents = nil

	if var1 then
		arg0.mapDebug:Dispose()
	end

	if arg0.pedestalModule then
		arg0.pedestalModule:Dispose()

		arg0.pedestalModule = nil
	end

	arg0.effectAgent:Dispose()

	arg0.effectAgent = nil

	arg0.soundAgent:Dispose()

	arg0.soundAgent = nil

	arg0.bgAgent:Dispose()

	arg0.bgAgent = nil

	arg0.bgmAgent:Dispose()

	arg0.bgmAgent = nil

	arg0.descPage:Destroy()

	arg0.descPage = nil

	arg0.playTheLutePage:Destroy()

	arg0.playTheLutePage = nil

	if not IsNil(arg0._go) then
		Object.Destroy(arg0._go)
	end
end

return var0
