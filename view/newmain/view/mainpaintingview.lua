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

	if arg1_18.skinId == arg0_18.ship.skinId and arg1_18.id == arg0_18.ship.id and arg0_18.state == var0_18 and arg0_18.bgToggle == var1_18 and arg1_18:GetRecordPosKey() == arg0_18.ship:GetRecordPosKey() and not arg0_18.reloadOnResume then
		return false
	else
		if arg0_18.reloadOnResume then
			arg0_18.reloadOnResume = false
		end

		return true
	end
end

function var0_0.Disable(arg0_19)
	if arg0_19.painting then
		arg0_19.painting:Puase()
	end
end

function var0_0.AdjustPositionWithAnim(arg0_20, arg1_20)
	LeanTween.cancel(go(arg0_20._tf))
	LeanTween.cancel(go(arg0_20._bgTf))

	local var0_20 = arg0_20:GetPositionAndScale(arg1_20)

	LeanTween.moveLocal(go(arg0_20._tf), var0_20, 0.3):setEase(LeanTweenType.easeInOutExpo)
	LeanTween.moveLocal(go(arg0_20._bgTf), var0_20, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var1_20, var2_20 = arg0_20.shift:GetL2dShift()

	LeanTween.moveLocal(go(arg0_20.spineContainer), var1_20, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var3_20, var4_20 = arg0_20.shift:GetSpineShift()

	LeanTween.moveLocal(go(arg0_20.l2dContainer), var3_20, 0.3):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
		arg0_20:AdjustPosition(arg1_20)
	end))
end

function var0_0.AdjustPosition(arg0_22, arg1_22)
	local var0_22, var1_22 = arg0_22:GetPositionAndScale(arg1_22)

	arg0_22._tf.anchoredPosition = var0_22
	arg0_22._bgTf.anchoredPosition = var0_22

	local var2_22, var3_22 = arg0_22.shift:GetL2dShift()

	arg0_22.l2dContainer.anchoredPosition = var2_22

	local var4_22, var5_22 = arg0_22.shift:GetSpineShift()

	arg0_22.spineContainer.anchoredPosition = var4_22

	local var6_22, var7_22, var8_22 = getProxy(SettingsProxy):getSkinPosSetting(arg1_22)

	if var8_22 then
		arg0_22._bgTf.localScale = Vector3(var8_22, var8_22, 1)
		arg0_22._tf.localScale = Vector3(var8_22, var8_22, 1)
	elseif arg0_22.state == var0_0.STATE_L2D then
		arg0_22._bgTf.localScale = var3_22
		arg0_22._tf.localScale = var3_22
	elseif arg0_22.state == var0_0.STATE_SPINE_PAINTING then
		arg0_22._bgTf.localScale = var5_22
		arg0_22._tf.localScale = var5_22
	else
		arg0_22._bgTf.localScale = var1_22
		arg0_22._tf.localScale = var1_22
	end
end

function var0_0.GetPositionAndScale(arg0_23, arg1_23)
	local var0_23, var1_23, var2_23 = getProxy(SettingsProxy):getSkinPosSetting(arg1_23)
	local var3_23 = Vector3(0, 0, 0)
	local var4_23 = Vector3(1, 1, 1)

	if var0_23 then
		var3_23 = Vector3(var0_23, var1_23, 0)
		var4_23 = Vector3(var2_23, var2_23, 1)
	else
		local var5_23, var6_23 = arg0_23.shift:GetMeshImageShift()

		var3_23 = var5_23
		var4_23 = var6_23
	end

	return var3_23, var4_23
end

function var0_0.GetAssistantStatus(arg0_24)
	local var0_24 = arg0_24:getPainting()
	local var1_24 = getProxy(SettingsProxy)
	local var2_24 = HXSet.autoHxShiftPath("spinepainting/" .. var0_24)
	local var3_24 = checkABExist(var2_24)
	local var4_24 = HXSet.autoHxShiftPath("live2d/" .. var0_24)
	local var5_24 = var0_0.Live2dIsDownload(var4_24) and checkABExist(var4_24)
	local var6_24 = var1_24:getCharacterSetting(arg0_24.id, SHIP_FLAG_BG)

	if var1_24:getCharacterSetting(arg0_24.id, SHIP_FLAG_SP) and var3_24 then
		return var0_0.STATE_SPINE_PAINTING, var6_24
	elseif var1_24:getCharacterSetting(arg0_24.id, SHIP_FLAG_L2D) and var5_24 then
		return var0_0.STATE_L2D, var6_24
	elseif isa(arg0_24, VirtualEducateCharShip) then
		return var0_0.STATE_EDUCATE_CHAR, var6_24
	else
		return var0_0.STATE_PAINTING, var6_24
	end
end

function var0_0.Live2dIsDownload(arg0_25)
	local var0_25 = GroupHelper.GetGroupMgrByName("L2D"):CheckF(arg0_25)

	return var0_25 == DownloadState.None or var0_25 == DownloadState.UpdateSuccess
end

function var0_0.Fold(arg0_26, arg1_26, arg2_26)
	LeanTween.cancel(arg0_26._tf.gameObject)
	LeanTween.cancel(arg0_26._bgTf.gameObject)

	if arg1_26 and not arg0_26.silentFlag then
		local var0_26 = arg0_26._tf.localPosition - arg0_26._bgTf.localPosition
		local var1_26 = arg0_26.shift:GetMeshImageShift()
		local var2_26 = Vector3(0 - arg0_26.painting:GetOffset(), var1_26.y, 0)

		LeanTween.moveLocal(arg0_26._tf.gameObject, var2_26, arg2_26):setEase(LeanTweenType.easeInOutExpo)

		local var3_26 = var2_26 - var0_26

		LeanTween.moveLocal(arg0_26._bgTf.gameObject, var3_26, arg2_26):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0_26.painting:Fold(arg1_26, arg2_26)
		end))
	elseif arg0_26.ship then
		local var4_26 = arg0_26:GetPositionAndScale(arg0_26.ship)

		LeanTween.moveLocal(arg0_26._tf.gameObject, var4_26, arg2_26):setEase(LeanTweenType.easeInOutExpo)
		LeanTween.moveLocal(arg0_26._bgTf.gameObject, var4_26, arg2_26):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0_26.painting:Fold(arg1_26, arg2_26)
		end))
	end
end

function var0_0.EnableOrDisableMove(arg0_29, arg1_29)
	arg0_29.painting:EnableOrDisableMove(arg1_29)

	if arg1_29 then
		arg0_29:EnableDragAndZoom()
	else
		arg0_29:DisableDragAndZoom()
	end
end

function var0_0.EnableDragAndZoom(arg0_30)
	arg0_30.isEnableDrag = true

	local var0_30 = arg0_30._tf.parent.gameObject
	local var1_30 = GetOrAddComponent(var0_30, typeof(PinchZoom))
	local var2_30 = GetOrAddComponent(var0_30, typeof(EventTriggerListener))
	local var3_30 = Vector3(0, 0, 0)

	var2_30:AddBeginDragFunc(function(arg0_31, arg1_31)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_30.processing then
			return
		end

		setButtonEnabled(var0_30, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_31 = var0_0.Screen2Local(var0_30.transform.parent, arg1_31.position)

		var3_30 = arg0_30._tf.localPosition - var0_31
	end)
	var2_30:AddDragFunc(function(arg0_32, arg1_32)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_30.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_32 = var0_0.Screen2Local(var0_30.transform.parent, arg1_32.position)

		arg0_30._tf.localPosition = arg0_30.painting:IslimitYPos() and Vector3(var0_32.x, var0_30.transform.localPosition.y, 0) + Vector3(var3_30.x, 0, 0) or Vector3(var0_32.x, var0_32.y, 0) + var3_30
		arg0_30._bgTf.localPosition = arg0_30.bgOffset + arg0_30._tf.localPosition
	end)
	var2_30:AddDragEndFunc(function()
		setButtonEnabled(var0_30, true)
	end)

	if not arg0_30.painting:IslimitYPos() then
		var1_30.enabled = true
	end

	var2_30.enabled = true
	Input.multiTouchEnabled = true
	arg0_30.cg.blocksRaycasts = false

	arg0_30:AdjustPosition(arg0_30.ship)
end

function var0_0.DisableDragAndZoom(arg0_34)
	if arg0_34.isEnableDrag then
		local var0_34 = arg0_34._tf.parent:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0_34)

		var0_34.enabled = false
		arg0_34._tf.parent:GetComponent(typeof(PinchZoom)).enabled = false
		arg0_34.cg.blocksRaycasts = true
		arg0_34.isEnableDrag = false
	end
end

function var0_0.Dispose(arg0_35)
	var0_0.super.Dispose(arg0_35)
	arg0_35:DisableDragAndZoom()

	if arg0_35.painting then
		arg0_35.painting:Unload()
	end

	arg0_35.painting = nil

	for iter0_35, iter1_35 in ipairs(arg0_35.paintings) do
		iter1_35:Dispose()
	end

	arg0_35.paintings = nil
end

function var0_0.Screen2Local(arg0_36, arg1_36)
	local var0_36 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_36 = arg0_36:GetComponent("RectTransform")
	local var2_36 = LuaHelper.ScreenToLocal(var1_36, arg1_36, var0_36)

	return Vector3(var2_36.x, var2_36.y, 0)
end

return var0_0
