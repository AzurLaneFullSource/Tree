local var0_0 = class("MainPaintingView", import("..base.MainBaseView"))

var0_0.STATE_PAINTING = 1
var0_0.STATE_L2D = 2
var0_0.STATE_SPINE_PAINTING = 3
var0_0.STATE_EDUCATE_CHAR = 4
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
		MainEducateCharPainting.New(arg0_1._tf, arg0_1.event)
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
	arg0_2:bind(NewMainScene.ON_ENTER_DONE, function(arg0_6)
		if arg0_2.painting then
			arg0_2.painting:TriggerEventAtFirstTime()
		end
	end)
	arg0_2:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0_2.cg.blocksRaycasts = false
		arg0_2.silentFlag = true

		for iter0_7, iter1_7 in ipairs(arg0_2.paintings) do
			iter1_7:PauseForSilent()
		end
	end)
	arg0_2:bind(NewMainScene.EXIT_SILENT_VIEW, function()
		arg0_2.cg.blocksRaycasts = true
		arg0_2.silentFlag = false

		for iter0_8, iter1_8 in ipairs(arg0_2.paintings) do
			iter1_8:ResumeForSilent()
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

function var0_0.OnChatStateChange(arg0_11, arg1_11)
	if not arg1_11 then
		arg0_11.painting:StopChatAnimtion()
	end
end

function var0_0.OnStopVoice(arg0_12)
	if arg0_12.painting then
		arg0_12.painting:OnStopVoice()
	end
end

function var0_0.IsLive2DState(arg0_13)
	return var0_0.STATE_L2D == arg0_13.state
end

function var0_0.IsLoading(arg0_14)
	if arg0_14.painting and arg0_14.painting:IsLoading() then
		return true
	end

	return false
end

function var0_0.Init(arg0_15, arg1_15, arg2_15, arg3_15)
	if arg0_15:ShouldReLoad(arg1_15) then
		arg0_15:Reload(arg1_15)
	else
		arg0_15.painting:Resume()
	end

	arg0_15.shift = arg2_15 or arg0_15.shift

	assert(arg0_15.shift)

	if arg3_15 then
		arg0_15:AdjustPositionWithAnim(arg1_15)
	else
		arg0_15:AdjustPosition(arg1_15)
	end
end

function var0_0.Reload(arg0_16, arg1_16)
	arg0_16.ship = arg1_16

	local var0_16, var1_16 = var0_0.GetAssistantStatus(arg1_16)
	local var2_16 = arg0_16.paintings[var0_16]

	if arg0_16.painting then
		arg0_16.painting:Unload()
	end

	var2_16:Load(arg1_16)

	arg0_16.painting = var2_16
	arg0_16.state = var0_16
	arg0_16.bgToggle = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_16.painting.paintingName, 0)
	arg0_16.skinId = arg1_16.skinId
end

function var0_0.Refresh(arg0_17, arg1_17, arg2_17)
	arg0_17:Init(arg1_17, arg2_17)
end

function var0_0.ShouldReLoad(arg0_18, arg1_18)
	if not arg0_18.painting or not arg0_18.ship or not arg0_18.state or not arg0_18.bgToggle then
		return true
	end

	local var0_18 = var0_0.GetAssistantStatus(arg1_18)
	local var1_18 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_18.painting.paintingName, 0)

	if arg0_18.skinId == arg0_18.ship.skinId and arg1_18.id == arg0_18.ship.id and arg0_18.state == var0_18 and arg0_18.bgToggle == var1_18 and arg1_18:GetRecordPosKey() == arg0_18.ship:GetRecordPosKey() and not arg0_18.reloadOnResume then
		return false
	else
		if arg0_18.reloadOnResume then
			arg0_18.reloadOnResume = false
		end

		return true
	end
end

function var0_0.SetOnceLoadedCall(arg0_19, arg1_19)
	arg0_19.painting:SetOnceLoadedCall(arg1_19)
end

function var0_0.PlayChangeSkinActionIn(arg0_20, arg1_20)
	arg0_20.painting:PlayChangeSkinActionIn(arg1_20)
end

function var0_0.PlayChangeSkinActionOut(arg0_21, arg1_21)
	arg0_21.painting:PlayChangeSkinActionOut(arg1_21)
end

function var0_0.Disable(arg0_22)
	if arg0_22.painting then
		arg0_22.painting:Puase()
	end
end

function var0_0.AdjustPositionWithAnim(arg0_23, arg1_23)
	LeanTween.cancel(go(arg0_23._tf))
	LeanTween.cancel(go(arg0_23._bgTf))

	local var0_23 = arg0_23:GetPositionAndScale(arg1_23)

	LeanTween.moveLocal(go(arg0_23._tf), var0_23, 0.3):setEase(LeanTweenType.easeInOutExpo)
	LeanTween.moveLocal(go(arg0_23._bgTf), var0_23, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var1_23, var2_23 = arg0_23.shift:GetL2dShift()

	LeanTween.moveLocal(go(arg0_23.spineContainer), var1_23, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var3_23, var4_23 = arg0_23.shift:GetSpineShift()

	LeanTween.moveLocal(go(arg0_23.l2dContainer), var3_23, 0.3):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
		arg0_23:AdjustPosition(arg1_23)
	end))
end

function var0_0.AdjustPosition(arg0_25, arg1_25)
	local var0_25, var1_25 = arg0_25:GetPositionAndScale(arg1_25)

	arg0_25._tf.anchoredPosition = var0_25
	arg0_25._bgTf.anchoredPosition = var0_25

	local var2_25, var3_25 = arg0_25.shift:GetL2dShift()

	arg0_25.l2dContainer.anchoredPosition = var2_25

	local var4_25, var5_25 = arg0_25.shift:GetSpineShift()

	arg0_25.spineContainer.anchoredPosition = var4_25

	local var6_25, var7_25, var8_25 = getProxy(SettingsProxy):getSkinPosSetting(arg1_25)

	if var8_25 then
		arg0_25._bgTf.localScale = Vector3(var8_25, var8_25, 1)
		arg0_25._tf.localScale = Vector3(var8_25, var8_25, 1)
	elseif arg0_25.state == var0_0.STATE_L2D then
		arg0_25._bgTf.localScale = var3_25
		arg0_25._tf.localScale = var3_25
	elseif arg0_25.state == var0_0.STATE_SPINE_PAINTING then
		arg0_25._bgTf.localScale = var5_25
		arg0_25._tf.localScale = var5_25
	else
		arg0_25._bgTf.localScale = var1_25
		arg0_25._tf.localScale = var1_25
	end
end

function var0_0.GetPositionAndScale(arg0_26, arg1_26)
	local var0_26, var1_26, var2_26 = getProxy(SettingsProxy):getSkinPosSetting(arg1_26)
	local var3_26 = Vector3(0, 0, 0)
	local var4_26 = Vector3(1, 1, 1)

	if var0_26 then
		var3_26 = Vector3(var0_26, var1_26, 0)
		var4_26 = Vector3(var2_26, var2_26, 1)
	else
		local var5_26, var6_26 = arg0_26.shift:GetMeshImageShift()

		var3_26 = var5_26
		var4_26 = var6_26
	end

	return var3_26, var4_26
end

function var0_0.GetAssistantStatus(arg0_27)
	local var0_27 = arg0_27:getPainting()
	local var1_27 = getProxy(SettingsProxy)
	local var2_27 = HXSet.autoHxShiftPath("spinepainting/" .. var0_27)
	local var3_27 = checkABExist(var2_27)
	local var4_27 = HXSet.autoHxShiftPath("live2d/" .. var0_27)
	local var5_27 = var0_0.Live2dIsDownload(var4_27) and checkABExist(var4_27)
	local var6_27 = var1_27:getCharacterSetting(arg0_27.id, SHIP_FLAG_BG)

	if var1_27:getCharacterSetting(arg0_27.id, SHIP_FLAG_SP) and var3_27 then
		return var0_0.STATE_SPINE_PAINTING, var6_27
	elseif var1_27:getCharacterSetting(arg0_27.id, SHIP_FLAG_L2D) and var5_27 then
		return var0_0.STATE_L2D, var6_27
	elseif isa(arg0_27, VirtualEducateCharShip) then
		return var0_0.STATE_EDUCATE_CHAR, var6_27
	else
		return var0_0.STATE_PAINTING, var6_27
	end
end

function var0_0.Live2dIsDownload(arg0_28)
	local var0_28 = GroupHelper.GetGroupMgrByName("L2D"):CheckF(arg0_28)

	return var0_28 == DownloadState.None or var0_28 == DownloadState.UpdateSuccess
end

function var0_0.Fold(arg0_29, arg1_29, arg2_29)
	LeanTween.cancel(arg0_29._tf.gameObject)
	LeanTween.cancel(arg0_29._bgTf.gameObject)

	if arg1_29 and not arg0_29.silentFlag then
		local var0_29 = arg0_29._tf.localPosition - arg0_29._bgTf.localPosition
		local var1_29 = arg0_29.shift:GetMeshImageShift()
		local var2_29 = Vector3(0 - arg0_29.painting:GetOffset(), var1_29.y, 0)

		LeanTween.moveLocal(arg0_29._tf.gameObject, var2_29, arg2_29):setEase(LeanTweenType.easeInOutExpo)

		local var3_29 = var2_29 - var0_29

		LeanTween.moveLocal(arg0_29._bgTf.gameObject, var3_29, arg2_29):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0_29.painting:Fold(arg1_29, arg2_29)
		end))
	elseif arg0_29.ship then
		local var4_29 = arg0_29:GetPositionAndScale(arg0_29.ship)

		LeanTween.moveLocal(arg0_29._tf.gameObject, var4_29, arg2_29):setEase(LeanTweenType.easeInOutExpo)
		LeanTween.moveLocal(arg0_29._bgTf.gameObject, var4_29, arg2_29):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0_29.painting:Fold(arg1_29, arg2_29)
		end))
	end
end

function var0_0.EnableOrDisableMove(arg0_32, arg1_32)
	arg0_32.painting:EnableOrDisableMove(arg1_32)

	if arg1_32 then
		arg0_32:EnableDragAndZoom()
	else
		arg0_32:DisableDragAndZoom()
	end
end

function var0_0.EnableDragAndZoom(arg0_33)
	arg0_33.isEnableDrag = true

	local var0_33 = arg0_33._tf.parent.gameObject
	local var1_33 = GetOrAddComponent(var0_33, typeof(PinchZoom))
	local var2_33 = GetOrAddComponent(var0_33, typeof(EventTriggerListener))
	local var3_33 = Vector3(0, 0, 0)

	var2_33:AddBeginDragFunc(function(arg0_34, arg1_34)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_33.processing then
			return
		end

		setButtonEnabled(var0_33, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_34 = var0_0.Screen2Local(var0_33.transform.parent, arg1_34.position)

		var3_33 = arg0_33._tf.localPosition - var0_34
	end)
	var2_33:AddDragFunc(function(arg0_35, arg1_35)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_33.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_35 = var0_0.Screen2Local(var0_33.transform.parent, arg1_35.position)

		arg0_33._tf.localPosition = arg0_33.painting:IslimitYPos() and Vector3(var0_35.x, var0_33.transform.localPosition.y, 0) + Vector3(var3_33.x, 0, 0) or Vector3(var0_35.x, var0_35.y, 0) + var3_33
		arg0_33._bgTf.localPosition = arg0_33.bgOffset + arg0_33._tf.localPosition
	end)
	var2_33:AddDragEndFunc(function()
		setButtonEnabled(var0_33, true)
	end)

	if not arg0_33.painting:IslimitYPos() then
		var1_33.enabled = true
	end

	var2_33.enabled = true
	Input.multiTouchEnabled = true
	arg0_33.cg.blocksRaycasts = false

	arg0_33:AdjustPosition(arg0_33.ship)
end

function var0_0.DisableDragAndZoom(arg0_37)
	if arg0_37.isEnableDrag then
		local var0_37 = arg0_37._tf.parent:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0_37)

		var0_37.enabled = false
		arg0_37._tf.parent:GetComponent(typeof(PinchZoom)).enabled = false
		arg0_37.cg.blocksRaycasts = true
		arg0_37.isEnableDrag = false
	end
end

function var0_0.Dispose(arg0_38)
	var0_0.super.Dispose(arg0_38)
	arg0_38:DisableDragAndZoom()

	if arg0_38.painting then
		arg0_38.painting:Unload()
	end

	arg0_38.painting = nil

	for iter0_38, iter1_38 in ipairs(arg0_38.paintings) do
		iter1_38:Dispose()
	end

	arg0_38.paintings = nil
end

function var0_0.Screen2Local(arg0_39, arg1_39)
	local var0_39 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_39 = arg0_39:GetComponent("RectTransform")
	local var2_39 = LuaHelper.ScreenToLocal(var1_39, arg1_39, var0_39)

	return Vector3(var2_39.x, var2_39.y, 0)
end

return var0_0
