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

	function Live2dConst.UnLoadL2dPating()
		if not arg0_2.reloadOnResume and arg0_2.painting and isa(arg0_2.painting, MainLive2dPainting) then
			arg0_2.painting:SetContainerVisible(false)

			arg0_2.reloadOnResume = true
		end
	end
end

function var0_0.OnChatStateChange(arg0_14, arg1_14)
	if not arg1_14 then
		arg0_14.painting:StopChatAnimtion()
	end
end

function var0_0.OnStopVoice(arg0_15)
	if arg0_15.painting then
		arg0_15.painting:OnStopVoice()
	end
end

function var0_0.IsLive2DState(arg0_16)
	return var0_0.STATE_L2D == arg0_16.state
end

function var0_0.IsLoading(arg0_17)
	if arg0_17.painting and arg0_17.painting:IsLoading() then
		return true
	end

	return false
end

function var0_0.Init(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg0_18:ShouldReLoad(arg1_18) then
		arg0_18:Reload(arg1_18)
	else
		arg0_18.painting:Resume()
	end

	arg0_18.shift = arg2_18 or arg0_18.shift

	assert(arg0_18.shift)

	if arg3_18 then
		arg0_18:AdjustPositionWithAnim(arg1_18)
	else
		arg0_18:AdjustPosition(arg1_18)
	end

	arg0_18.painting:SetShift(arg0_18.shift)
end

function var0_0.Reload(arg0_19, arg1_19)
	arg0_19.ship = arg1_19

	local var0_19, var1_19 = var0_0.GetAssistantStatus(arg1_19)
	local var2_19 = arg0_19.paintings[var0_19]

	if arg0_19.painting then
		arg0_19.painting:Unload()
	end

	var2_19:Load(arg1_19)

	arg0_19.painting = var2_19
	arg0_19.state = var0_19
	arg0_19.bgToggle = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_19.painting.paintingName, 0)
	arg0_19.skinId = arg1_19:getSkinId()
end

function var0_0.Refresh(arg0_20, arg1_20, arg2_20)
	arg0_20:Init(arg1_20, arg2_20)
end

function var0_0.ShouldReLoad(arg0_21, arg1_21)
	if not arg0_21.painting or not arg0_21.ship or not arg0_21.state or not arg0_21.bgToggle then
		return true
	end

	local var0_21 = var0_0.GetAssistantStatus(arg1_21)
	local var1_21 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_21.painting.paintingName, 0)

	if arg0_21.skinId == arg0_21.ship:getSkinId() and arg1_21.id == arg0_21.ship.id and arg0_21.state == var0_21 and arg0_21.bgToggle == var1_21 and arg1_21:GetRecordPosKey() == arg0_21.ship:GetRecordPosKey() and not arg0_21.reloadOnResume then
		return false
	else
		if arg0_21.reloadOnResume then
			arg0_21.reloadOnResume = false
		end

		return true
	end
end

function var0_0.SetOnceLoadedCall(arg0_22, arg1_22)
	arg0_22.painting:SetOnceLoadedCall(arg1_22)
end

function var0_0.PlayChangeSkinActionIn(arg0_23, arg1_23)
	arg0_23.painting:PlayChangeSkinActionIn(arg1_23)
end

function var0_0.PlayChangeSkinActionOut(arg0_24, arg1_24)
	arg0_24.painting:PlayChangeSkinActionOut(arg1_24)
end

function var0_0.Disable(arg0_25)
	if arg0_25.painting then
		arg0_25.painting:Pause()
	end
end

function var0_0.AdjustPositionWithAnim(arg0_26, arg1_26)
	LeanTween.cancel(go(arg0_26._tf))
	LeanTween.cancel(go(arg0_26._bgTf))

	local var0_26 = arg0_26:GetPositionAndScale(arg1_26)

	LeanTween.moveLocal(go(arg0_26._tf), var0_26, 0.3):setEase(LeanTweenType.easeInOutExpo)
	LeanTween.moveLocal(go(arg0_26._bgTf), var0_26, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var1_26, var2_26 = arg0_26.shift:GetSpineShift()

	LeanTween.moveLocal(go(arg0_26.spineContainer), var1_26, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var3_26, var4_26 = arg0_26.shift:GetL2dShift()

	if arg0_26.painting:IslimitYPos() then
		var3_26.y = arg0_26.painting:GetHalfBodyOffsetY()
	end

	LeanTween.moveLocal(go(arg0_26.l2dContainer), var3_26, 0.3):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
		arg0_26:AdjustPosition(arg1_26)
	end))
end

function var0_0.AdjustPosition(arg0_28, arg1_28)
	local var0_28, var1_28 = arg0_28:GetPositionAndScale(arg1_28)

	arg0_28._tf.anchoredPosition = var0_28
	arg0_28._bgTf.anchoredPosition = var0_28

	local var2_28, var3_28 = arg0_28.shift:GetL2dShift()

	if arg0_28.painting:IslimitYPos() then
		var2_28.y = arg0_28.painting:GetHalfBodyOffsetY()
	end

	arg0_28.l2dContainer.anchoredPosition = var2_28

	local var4_28, var5_28 = arg0_28.shift:GetSpineShift()

	arg0_28.spineContainer.anchoredPosition = var4_28

	local var6_28, var7_28, var8_28 = getProxy(SettingsProxy):getSkinPosSetting(arg1_28)

	if var8_28 then
		arg0_28._bgTf.localScale = Vector3(var8_28, var8_28, 1)
		arg0_28._tf.localScale = Vector3(var8_28, var8_28, 1)
	elseif arg0_28.state == var0_0.STATE_L2D then
		arg0_28._bgTf.localScale = var3_28
		arg0_28._tf.localScale = var3_28
	elseif arg0_28.state == var0_0.STATE_SPINE_PAINTING then
		arg0_28._bgTf.localScale = var5_28
		arg0_28._tf.localScale = var5_28
	else
		arg0_28._bgTf.localScale = var1_28
		arg0_28._tf.localScale = var1_28
	end
end

function var0_0.GetPositionAndScale(arg0_29, arg1_29)
	local var0_29, var1_29, var2_29 = getProxy(SettingsProxy):getSkinPosSetting(arg1_29)
	local var3_29 = Vector3(0, 0, 0)
	local var4_29 = Vector3(1, 1, 1)

	if var0_29 then
		var3_29 = Vector3(var0_29, var1_29, 0)
		var4_29 = Vector3(var2_29, var2_29, 1)
	else
		local var5_29, var6_29 = arg0_29.shift:GetMeshImageShift()

		var3_29 = var5_29
		var4_29 = var6_29
	end

	return var3_29, var4_29
end

function var0_0.GetAssistantStatus(arg0_30)
	local var0_30 = arg0_30:getPainting()
	local var1_30 = getProxy(SettingsProxy)
	local var2_30 = HXSet.autoHxShiftPath("spinepainting/" .. var0_30)
	local var3_30 = checkABExist(var2_30)
	local var4_30 = HXSet.autoHxShiftPath("live2d/" .. var0_30)
	local var5_30 = var0_0.Live2dIsDownload(var4_30) and checkABExist(var4_30)
	local var6_30 = var1_30:getCharacterSetting(arg0_30.id, SHIP_FLAG_BG)

	if var1_30:getCharacterSetting(arg0_30.id, SHIP_FLAG_L2D) and var5_30 then
		return isa(arg0_30, VirtualEducateCharShip) and var0_0.STATE_EDUCATE_L2D or var0_0.STATE_L2D, var6_30
	elseif var1_30:getCharacterSetting(arg0_30.id, SHIP_FLAG_SP) and var3_30 then
		return isa(arg0_30, VirtualEducateCharShip) and var0_0.STATE_EDUCATE_SPINE or var0_0.STATE_SPINE_PAINTING, var6_30
	else
		return isa(arg0_30, VirtualEducateCharShip) and var0_0.STATE_EDUCATE_CHAR or var0_0.STATE_PAINTING, var6_30
	end
end

function var0_0.Live2dIsDownload(arg0_31)
	local var0_31 = GroupHelper.GetGroupMgrByName("L2D"):CheckF(arg0_31)

	return var0_31 == DownloadState.None or var0_31 == DownloadState.UpdateSuccess
end

function var0_0.Fold(arg0_32, arg1_32, arg2_32)
	LeanTween.cancel(arg0_32._tf.gameObject)
	LeanTween.cancel(arg0_32._bgTf.gameObject)

	if arg1_32 and not arg0_32.silentFlag then
		local var0_32 = arg0_32._tf.localPosition - arg0_32._bgTf.localPosition
		local var1_32 = arg0_32.shift:GetMeshImageShift()
		local var2_32 = Vector3(0 - arg0_32.painting:GetOffset(), var1_32.y, 0)

		LeanTween.moveLocal(arg0_32._tf.gameObject, var2_32, arg2_32):setEase(LeanTweenType.easeInOutExpo)

		local var3_32 = var2_32 - var0_32

		LeanTween.moveLocal(arg0_32._bgTf.gameObject, var3_32, arg2_32):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0_32.painting:Fold(arg1_32, arg2_32)
		end))
	elseif arg0_32.ship then
		local var4_32 = arg0_32:GetPositionAndScale(arg0_32.ship)

		LeanTween.moveLocal(arg0_32._tf.gameObject, var4_32, arg2_32):setEase(LeanTweenType.easeInOutExpo)
		LeanTween.moveLocal(arg0_32._bgTf.gameObject, var4_32, arg2_32):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			if arg0_32.exited then
				return
			end

			arg0_32.painting:Fold(arg1_32, arg2_32)
		end))
	end
end

function var0_0.EnableOrDisableScale(arg0_35, arg1_35)
	arg0_35.painting:EnableOrDisableMove(arg1_35)
	arg0_35.painting:OnEnablePartScale(arg1_35)
end

function var0_0.EnableOrDisableMove(arg0_36, arg1_36)
	arg0_36.painting:EnableOrDisableMove(arg1_36)

	if arg1_36 then
		arg0_36:EnableDragAndZoom()
	else
		arg0_36:DisableDragAndZoom()
	end
end

function var0_0.OnAsmrTurnning(arg0_37, arg1_37)
	arg0_37.painting:OnAsmrTurnning(arg1_37)
end

function var0_0.EnableDragAndZoom(arg0_38)
	arg0_38.isEnableDrag = true

	local var0_38 = arg0_38._tf.parent.gameObject
	local var1_38 = GetOrAddComponent(var0_38, typeof(PinchZoom))
	local var2_38 = GetOrAddComponent(var0_38, typeof(EventTriggerListener))
	local var3_38 = Vector3(0, 0, 0)

	var2_38:AddBeginDragFunc(function(arg0_39, arg1_39)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_38.processing then
			return
		end

		setButtonEnabled(var0_38, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_39 = var0_0.Screen2Local(var0_38.transform.parent, arg1_39.position)

		var3_38 = arg0_38._tf.localPosition - var0_39
	end)
	var2_38:AddDragFunc(function(arg0_40, arg1_40)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_38.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_40 = var0_0.Screen2Local(var0_38.transform.parent, arg1_40.position)
		local var1_40

		if arg0_38.painting:IslimitYPos() then
			var1_40 = Vector3(var0_40.x, arg0_38._tf.localPosition.y, 0) + Vector3(var3_38.x, 0, 0)
		else
			var1_40 = Vector3(var0_40.x, var0_40.y, 0) + var3_38
		end

		arg0_38._tf.localPosition = var1_40
		arg0_38._bgTf.localPosition = arg0_38.bgOffset + arg0_38._tf.localPosition
	end)
	var2_38:AddDragEndFunc(function()
		setButtonEnabled(var0_38, true)
	end)

	if not arg0_38.painting:IslimitYPos() then
		var1_38.enabled = true
	end

	var2_38.enabled = true
	Input.multiTouchEnabled = true
	arg0_38.cg.blocksRaycasts = false

	arg0_38:AdjustPosition(arg0_38.ship)
end

function var0_0.DisableDragAndZoom(arg0_42)
	if arg0_42.isEnableDrag then
		local var0_42 = arg0_42._tf.parent:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0_42)

		var0_42.enabled = false
		arg0_42._tf.parent:GetComponent(typeof(PinchZoom)).enabled = false
		arg0_42.cg.blocksRaycasts = true
		arg0_42.isEnableDrag = false
	end

	arg0_42:AdjustPosition(arg0_42.ship)
end

function var0_0.Dispose(arg0_43)
	var0_0.super.Dispose(arg0_43)
	arg0_43:DisableDragAndZoom()

	if arg0_43.painting then
		arg0_43.painting:Unload()
	end

	arg0_43.painting = nil

	for iter0_43, iter1_43 in ipairs(arg0_43.paintings) do
		iter1_43:Dispose()
	end

	arg0_43.paintings = nil
end

function var0_0.Screen2Local(arg0_44, arg1_44)
	local var0_44 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_44 = arg0_44:GetComponent("RectTransform")
	local var2_44 = LuaHelper.ScreenToLocal(var1_44, arg1_44, var0_44)

	return Vector3(var2_44.x, var2_44.y, 0)
end

return var0_0
