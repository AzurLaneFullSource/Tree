local var0_0 = class("MainPaintingView", import("..base.MainBaseView"))

var0_0.STATE_PAINTING = 1
var0_0.STATE_L2D = 2
var0_0.STATE_SPINE_PAINTING = 3
var0_0.STATE_EDUCATE_CHAR = 4
var0_0.STATE_EDUCATE_SPINE = 5
var0_0.STATE_EDUCATE_L2D = 6
var0_0.MESH_POSITION_X_OFFSET = 145

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg3_1)

	arg0_1._bgTf = arg2_1
	arg0_1._bgGo = arg2_1.gameObject
	arg0_1.l2dContainer = arg1_1:Find("live2d")
	arg0_1.spineContainer = arg1_1:Find("spinePainting")
	arg0_1.bgOffset = arg0_1._bgTf.localPosition - arg0_1._tf.localPosition
	arg0_1.cg = arg0_1._tf:GetComponent(typeof(CanvasGroup))
	arg0_1.paintings = {
		MainMeshImagePainting.New(arg0_1._tf, arg0_1.event),
		MainLive2dPainting.New(arg0_1._tf, arg0_1.event),
		MainSpinePainting.New(arg0_1._tf, arg0_1.event, arg0_1._bgGo),
		MainEducateCharPainting.New(arg0_1._tf, arg0_1.event),
		MainEducateSpinePainting.New(arg0_1._tf, arg0_1.event, arg0_1._bgGo)
	}

	arg0_1:Register()
end

function var0_0.Register(arg0_2)
	arg0_2:bind(TaskProxy.TASK_ADDED, function(arg0_3)
		arg0_2:OnStopVoice()
	end)
	arg0_2:bind(NewMainScene.CHAT_STATE_CHANGE, function(arg0_4, arg1_4)
		arg0_2:OnChatStateChange(arg1_4)
	end)
	arg0_2:bind(NewMainScene.ENABLE_PAITING_MOVE, function(arg0_5, arg1_5)
		arg0_2:EnableOrDisableMove(arg1_5)
	end)
	arg0_2:bind(NewMainScene.SAVE_PART_SCALE, function(arg0_6, arg1_6)
		arg0_2.painting:SavePartScaleData()
	end)
	arg0_2:bind(NewMainScene.ENABLE_PAITING_SCALE, function(arg0_7, arg1_7)
		arg0_2:EnableOrDisableScale(arg1_7)
	end)
	arg0_2:bind(NewMainScene.RESET_PAITING_SCALE, function(arg0_8, arg1_8)
		arg0_2.painting:ResetPartScale()
	end)
	arg0_2:bind(NewMainScene.ON_ENTER_DONE, function(arg0_9)
		if arg0_2.painting then
			arg0_2.painting:TriggerEventAtFirstTime()
		end
	end)
	arg0_2:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0_2.cg.blocksRaycasts = false
		arg0_2.silentFlag = true

		for iter0_10, iter1_10 in ipairs(arg0_2.paintings) do
			iter1_10:PauseForSilent()
		end
	end)
	arg0_2:bind(NewMainScene.EXIT_SILENT_VIEW, function()
		arg0_2.cg.blocksRaycasts = true
		arg0_2.silentFlag = false

		for iter0_11, iter1_11 in ipairs(arg0_2.paintings) do
			iter1_11:ResumeForSilent()
		end
	end)
	arg0_2:bind(NewMainScene.RESET_L2D, function()
		if not arg0_2.painting then
			return
		end

		if not isa(arg0_2.painting, MainLive2dPainting) then
			return
		end

		arg0_2.painting:ResetState()
	end)
	arg0_2:bind(NewMainScene.STORY_BEGIN, function()
		if arg0_2.painting then
			arg0_2.painting:Pause()
		end
	end)
	arg0_2:bind(NewMainScene.STORY_END, function()
		if arg0_2.painting then
			arg0_2.painting:Resume()
		end
	end)

	function Live2dConst.UnLoadL2dPating()
		if not arg0_2.reloadOnResume and arg0_2.painting and isa(arg0_2.painting, MainLive2dPainting) then
			arg0_2.painting:SetContainerVisible(false)

			arg0_2.reloadOnResume = true
		end
	end
end

function var0_0.OnChatStateChange(arg0_16, arg1_16)
	if not arg1_16 then
		arg0_16.painting:StopChatAnimtion()
	end
end

function var0_0.OnStopVoice(arg0_17)
	if arg0_17.painting then
		arg0_17.painting:OnStopVoice()
	end
end

function var0_0.IsLive2DState(arg0_18)
	return var0_0.STATE_L2D == arg0_18.state
end

function var0_0.IsLoading(arg0_19)
	if arg0_19.painting and arg0_19.painting:IsLoading() then
		return true
	end

	return false
end

function var0_0.Init(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg0_20:ShouldReLoad(arg1_20) then
		arg0_20:Reload(arg1_20)
	else
		arg0_20.painting:Resume()
	end

	arg0_20.shift = arg2_20 or arg0_20.shift

	assert(arg0_20.shift)

	if arg3_20 then
		arg0_20:AdjustPositionWithAnim(arg1_20)
	else
		arg0_20:AdjustPosition(arg1_20)
	end

	arg0_20.painting:SetShift(arg0_20.shift)
end

function var0_0.Reload(arg0_21, arg1_21)
	arg0_21.ship = arg1_21

	local var0_21, var1_21 = var0_0.GetAssistantStatus(arg1_21)
	local var2_21 = arg0_21.paintings[var0_21]

	if arg0_21.painting then
		arg0_21.painting:Unload()
	end

	var2_21:Load(arg1_21)

	arg0_21.painting = var2_21
	arg0_21.state = var0_21
	arg0_21.bgToggle = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_21.painting.paintingName, 0)
	arg0_21.skinId = arg1_21:getSkinId()
end

function var0_0.Refresh(arg0_22, arg1_22, arg2_22)
	arg0_22:Init(arg1_22, arg2_22)
end

function var0_0.ShouldReLoad(arg0_23, arg1_23)
	if not arg0_23.painting or not arg0_23.ship or not arg0_23.state or not arg0_23.bgToggle then
		return true
	end

	local var0_23 = var0_0.GetAssistantStatus(arg1_23)
	local var1_23 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_23.painting.paintingName, 0)

	if arg0_23.skinId == arg0_23.ship:getSkinId() and arg1_23.id == arg0_23.ship.id and arg0_23.state == var0_23 and arg0_23.bgToggle == var1_23 and arg1_23:GetRecordPosKey() == arg0_23.ship:GetRecordPosKey() and not arg0_23.reloadOnResume then
		return false
	else
		if arg0_23.reloadOnResume then
			arg0_23.reloadOnResume = false
		end

		return true
	end
end

function var0_0.SetOnceLoadedCall(arg0_24, arg1_24)
	arg0_24.painting:SetOnceLoadedCall(arg1_24)
end

function var0_0.PlayChangeSkinActionIn(arg0_25, arg1_25)
	arg0_25.painting:PlayChangeSkinActionIn(arg1_25)
end

function var0_0.PlayChangeSkinActionOut(arg0_26, arg1_26)
	arg0_26.painting:PlayChangeSkinActionOut(arg1_26)
end

function var0_0.Disable(arg0_27)
	if arg0_27.painting then
		arg0_27.painting:Pause()
	end
end

function var0_0.AdjustPositionWithAnim(arg0_28, arg1_28)
	LeanTween.cancel(go(arg0_28._tf))
	LeanTween.cancel(go(arg0_28._bgTf))

	local var0_28 = arg0_28:GetPositionAndScale(arg1_28)

	LeanTween.moveLocal(go(arg0_28._tf), var0_28, 0.3):setEase(LeanTweenType.easeInOutExpo)
	LeanTween.moveLocal(go(arg0_28._bgTf), var0_28, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var1_28, var2_28 = arg0_28.shift:GetSpineShift()

	LeanTween.moveLocal(go(arg0_28.spineContainer), var1_28, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var3_28, var4_28 = arg0_28.shift:GetL2dShift()

	if arg0_28.painting:IslimitYPos() then
		var3_28.y = arg0_28.painting:GetHalfBodyOffsetY()
	end

	LeanTween.moveLocal(go(arg0_28.l2dContainer), var3_28, 0.3):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
		arg0_28:AdjustPosition(arg1_28)
	end))
end

function var0_0.AdjustPosition(arg0_30, arg1_30)
	local var0_30, var1_30 = arg0_30:GetPositionAndScale(arg1_30)

	arg0_30._tf.anchoredPosition = var0_30
	arg0_30._bgTf.anchoredPosition = var0_30

	local var2_30, var3_30 = arg0_30.shift:GetL2dShift()

	if arg0_30.painting:IslimitYPos() then
		var2_30.y = arg0_30.painting:GetHalfBodyOffsetY()
	end

	arg0_30.l2dContainer.anchoredPosition = var2_30

	local var4_30, var5_30 = arg0_30.shift:GetSpineShift()

	arg0_30.spineContainer.anchoredPosition = var4_30

	local var6_30, var7_30, var8_30 = getProxy(SettingsProxy):getSkinPosSetting(arg1_30)

	if var8_30 then
		arg0_30._bgTf.localScale = Vector3(var8_30, var8_30, 1)
		arg0_30._tf.localScale = Vector3(var8_30, var8_30, 1)
	elseif arg0_30.state == var0_0.STATE_L2D then
		arg0_30._bgTf.localScale = var3_30
		arg0_30._tf.localScale = var3_30
	elseif arg0_30.state == var0_0.STATE_SPINE_PAINTING then
		arg0_30._bgTf.localScale = var5_30
		arg0_30._tf.localScale = var5_30
	else
		arg0_30._bgTf.localScale = var1_30
		arg0_30._tf.localScale = var1_30
	end
end

function var0_0.GetPositionAndScale(arg0_31, arg1_31)
	local var0_31, var1_31, var2_31 = getProxy(SettingsProxy):getSkinPosSetting(arg1_31)
	local var3_31 = Vector3(0, 0, 0)
	local var4_31 = Vector3(1, 1, 1)

	if var0_31 then
		var3_31 = Vector3(var0_31, var1_31, 0)
		var4_31 = Vector3(var2_31, var2_31, 1)
	else
		local var5_31, var6_31 = arg0_31.shift:GetMeshImageShift()

		var3_31 = var5_31
		var4_31 = var6_31
	end

	return var3_31, var4_31
end

function var0_0.GetAssistantStatus(arg0_32)
	local var0_32 = arg0_32:getPainting()
	local var1_32 = getProxy(SettingsProxy)
	local var2_32 = HXSet.autoHxShiftPath("spinepainting/" .. var0_32)
	local var3_32 = checkABExist(var2_32)
	local var4_32 = HXSet.autoHxShiftPath("live2d/" .. var0_32)
	local var5_32 = var0_0.Live2dIsDownload(var4_32) and checkABExist(var4_32)
	local var6_32 = var1_32:getCharacterSetting(arg0_32.id, SHIP_FLAG_BG)

	if var1_32:getCharacterSetting(arg0_32.id, SHIP_FLAG_L2D) and var5_32 then
		return isa(arg0_32, VirtualEducateCharShip) and var0_0.STATE_EDUCATE_L2D or var0_0.STATE_L2D, var6_32
	elseif var1_32:getCharacterSetting(arg0_32.id, SHIP_FLAG_SP) and var3_32 then
		return isa(arg0_32, VirtualEducateCharShip) and var0_0.STATE_EDUCATE_SPINE or var0_0.STATE_SPINE_PAINTING, var6_32
	else
		return isa(arg0_32, VirtualEducateCharShip) and var0_0.STATE_EDUCATE_CHAR or var0_0.STATE_PAINTING, var6_32
	end
end

function var0_0.OnBoundChange(arg0_33)
	if arg0_33.painting then
		arg0_33.painting:UpdateBound()
	end
end

function var0_0.Live2dIsDownload(arg0_34)
	local var0_34 = GroupHelper.GetGroupMgrByName("L2D"):CheckF(arg0_34)

	return var0_34 == DownloadState.None or var0_34 == DownloadState.UpdateSuccess
end

function var0_0.Fold(arg0_35, arg1_35, arg2_35)
	return
end

function var0_0.EnableOrDisableScale(arg0_36, arg1_36)
	arg0_36.painting:EnableOrDisableMove(arg1_36)
	arg0_36.painting:OnEnablePartScale(arg1_36)
end

function var0_0.EnableOrDisableMove(arg0_37, arg1_37)
	arg0_37.painting:EnableOrDisableMove(arg1_37)

	if arg1_37 then
		arg0_37:EnableDragAndZoom()
	else
		arg0_37:DisableDragAndZoom()
	end
end

function var0_0.OnAsmrTurnning(arg0_38, arg1_38)
	arg0_38.painting:OnAsmrTurnning(arg1_38)
end

function var0_0.EnableDragAndZoom(arg0_39)
	arg0_39.isEnableDrag = true

	local var0_39 = arg0_39._tf.parent.gameObject
	local var1_39 = GetOrAddComponent(var0_39, typeof(PinchZoom))
	local var2_39 = GetOrAddComponent(var0_39, typeof(EventTriggerListener))
	local var3_39 = Vector3(0, 0, 0)

	var2_39:AddBeginDragFunc(function(arg0_40, arg1_40)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_39.processing then
			return
		end

		setButtonEnabled(var0_39, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_40 = var0_0.Screen2Local(var0_39.transform.parent, arg1_40.position)

		var3_39 = arg0_39._tf.localPosition - var0_40
	end)
	var2_39:AddDragFunc(function(arg0_41, arg1_41)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_39.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_41 = var0_0.Screen2Local(var0_39.transform.parent, arg1_41.position)
		local var1_41

		if arg0_39.painting:IslimitYPos() then
			var1_41 = Vector3(var0_41.x, arg0_39._tf.localPosition.y, 0) + Vector3(var3_39.x, 0, 0)
		else
			var1_41 = Vector3(var0_41.x, var0_41.y, 0) + var3_39
		end

		arg0_39._tf.localPosition = var1_41
		arg0_39._bgTf.localPosition = arg0_39.bgOffset + arg0_39._tf.localPosition
	end)
	var2_39:AddDragEndFunc(function()
		setButtonEnabled(var0_39, true)
	end)

	if not arg0_39.painting:IslimitYPos() then
		var1_39.enabled = true
	end

	var2_39.enabled = true
	Input.multiTouchEnabled = true
	arg0_39.cg.blocksRaycasts = false

	arg0_39:AdjustPosition(arg0_39.ship)
end

function var0_0.DisableDragAndZoom(arg0_43)
	if arg0_43.isEnableDrag then
		local var0_43 = arg0_43._tf.parent:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0_43)

		var0_43.enabled = false
		arg0_43._tf.parent:GetComponent(typeof(PinchZoom)).enabled = false
		arg0_43.cg.blocksRaycasts = true
		arg0_43.isEnableDrag = false
	end

	arg0_43:AdjustPosition(arg0_43.ship)
end

function var0_0.Dispose(arg0_44)
	var0_0.super.Dispose(arg0_44)
	arg0_44:DisableDragAndZoom()

	if arg0_44.painting then
		arg0_44.painting:Unload()
	end

	arg0_44.painting = nil

	for iter0_44, iter1_44 in ipairs(arg0_44.paintings) do
		iter1_44:Dispose()
	end

	arg0_44.paintings = nil
end

function var0_0.Screen2Local(arg0_45, arg1_45)
	local var0_45 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_45 = arg0_45:GetComponent("RectTransform")
	local var2_45 = LuaHelper.ScreenToLocal(var1_45, arg1_45, var0_45)

	return Vector3(var2_45.x, var2_45.y, 0)
end

return var0_0
