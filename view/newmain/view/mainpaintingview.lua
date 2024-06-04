local var0 = class("MainPaintingView", import("..base.MainBaseView"))

var0.STATE_PAINTING = 1
var0.STATE_L2D = 2
var0.STATE_SPINE_PAINTING = 3
var0.STATE_EDUCATE_CHAR = 4
var0.MESH_POSITION_X_OFFSET = 145

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg3)

	arg0._bgTf = arg2
	arg0._bgGo = arg2.gameObject
	arg0.l2dContainer = arg1:Find("live2d")
	arg0.spineContainer = arg1:Find("spinePainting")
	arg0.bgOffset = arg0._bgTf.localPosition - arg0._tf.localPosition
	arg0.cg = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.paintings = {
		MainMeshImagePainting.New(arg0._tf, arg0.event),
		MainLive2dPainting.New(arg0._tf, arg0.event),
		MainSpinePainting.New(arg0._tf, arg0.event, arg0._bgGo),
		MainEducateCharPainting.New(arg0._tf, arg0.event)
	}

	arg0:Register()
end

function var0.Register(arg0)
	arg0:bind(TaskProxy.TASK_ADDED, function(arg0)
		arg0:OnStopVoice()
	end)
	arg0:bind(NewMainScene.CHAT_STATE_CHANGE, function(arg0, arg1)
		arg0:OnChatStateChange(arg1)
	end)
	arg0:bind(NewMainScene.ENABLE_PAITING_MOVE, function(arg0, arg1)
		arg0:EnableOrDisableMove(arg1)
	end)
	arg0:bind(NewMainScene.ON_ENTER_DONE, function(arg0)
		if arg0.painting then
			arg0.painting:TriggerEventAtFirstTime()
		end
	end)
	arg0:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0.cg.blocksRaycasts = false
		arg0.silentFlag = true

		for iter0, iter1 in ipairs(arg0.paintings) do
			iter1:PauseForSilent()
		end
	end)
	arg0:bind(NewMainScene.EXIT_SILENT_VIEW, function()
		arg0.cg.blocksRaycasts = true
		arg0.silentFlag = false

		for iter0, iter1 in ipairs(arg0.paintings) do
			iter1:ResumeForSilent()
		end
	end)
	arg0:bind(NewMainScene.RESET_L2D, function()
		if not arg0.painting then
			return
		end

		if not isa(arg0.painting, MainLive2dPainting) then
			return
		end

		arg0.painting:ResetState()
	end)

	function Live2dConst.UnLoadL2dPating()
		if not arg0.reloadOnResume and arg0.painting and isa(arg0.painting, MainLive2dPainting) then
			arg0.painting:SetContainerVisible(false)

			arg0.reloadOnResume = true
		end
	end
end

function var0.OnChatStateChange(arg0, arg1)
	if not arg1 then
		arg0.painting:StopChatAnimtion()
	end
end

function var0.OnStopVoice(arg0)
	if arg0.painting then
		arg0.painting:OnStopVoice()
	end
end

function var0.IsLive2DState(arg0)
	return var0.STATE_L2D == arg0.state
end

function var0.IsLoading(arg0)
	if arg0.painting and arg0.painting:IsLoading() then
		return true
	end

	return false
end

function var0.Init(arg0, arg1, arg2, arg3)
	if arg0:ShouldReLoad(arg1) then
		arg0:Reload(arg1)
	else
		arg0.painting:Resume()
	end

	arg0.shift = arg2 or arg0.shift

	assert(arg0.shift)

	if arg3 then
		arg0:AdjustPositionWithAnim(arg1)
	else
		arg0:AdjustPosition(arg1)
	end
end

function var0.Reload(arg0, arg1)
	arg0.ship = arg1

	local var0, var1 = var0.GetAssistantStatus(arg1)
	local var2 = arg0.paintings[var0]

	if arg0.painting then
		arg0.painting:Unload()
	end

	var2:Load(arg1)

	arg0.painting = var2
	arg0.state = var0
	arg0.bgToggle = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0.painting.paintingName, 0)
end

function var0.Refresh(arg0, arg1, arg2)
	arg0:Init(arg1, arg2)
end

function var0.ShouldReLoad(arg0, arg1)
	if not arg0.painting or not arg0.ship or not arg0.state or not arg0.bgToggle then
		return true
	end

	local var0 = var0.GetAssistantStatus(arg1)
	local var1 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0.painting.paintingName, 0)

	if arg1.skinId == arg0.ship.skinId and arg1.id == arg0.ship.id and arg0.state == var0 and arg0.bgToggle == var1 and arg1:GetRecordPosKey() == arg0.ship:GetRecordPosKey() and not arg0.reloadOnResume then
		return false
	else
		if arg0.reloadOnResume then
			arg0.reloadOnResume = false
		end

		return true
	end
end

function var0.Disable(arg0)
	if arg0.painting then
		arg0.painting:Puase()
	end
end

function var0.AdjustPositionWithAnim(arg0, arg1)
	LeanTween.cancel(go(arg0._tf))
	LeanTween.cancel(go(arg0._bgTf))

	local var0 = arg0:GetPositionAndScale(arg1)

	LeanTween.moveLocal(go(arg0._tf), var0, 0.3):setEase(LeanTweenType.easeInOutExpo)
	LeanTween.moveLocal(go(arg0._bgTf), var0, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var1, var2 = arg0.shift:GetL2dShift()

	LeanTween.moveLocal(go(arg0.spineContainer), var1, 0.3):setEase(LeanTweenType.easeInOutExpo)

	local var3, var4 = arg0.shift:GetSpineShift()

	LeanTween.moveLocal(go(arg0.l2dContainer), var3, 0.3):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
		arg0:AdjustPosition(arg1)
	end))
end

function var0.AdjustPosition(arg0, arg1)
	local var0, var1 = arg0:GetPositionAndScale(arg1)

	arg0._tf.anchoredPosition = var0
	arg0._bgTf.anchoredPosition = var0

	local var2, var3 = arg0.shift:GetL2dShift()

	arg0.l2dContainer.anchoredPosition = var2

	local var4, var5 = arg0.shift:GetSpineShift()

	arg0.spineContainer.anchoredPosition = var4

	local var6, var7, var8 = getProxy(SettingsProxy):getSkinPosSetting(arg1)

	if var8 then
		arg0._bgTf.localScale = Vector3(var8, var8, 1)
		arg0._tf.localScale = Vector3(var8, var8, 1)
	elseif arg0.state == var0.STATE_L2D then
		arg0._bgTf.localScale = var3
		arg0._tf.localScale = var3
	elseif arg0.state == var0.STATE_SPINE_PAINTING then
		arg0._bgTf.localScale = var5
		arg0._tf.localScale = var5
	else
		arg0._bgTf.localScale = var1
		arg0._tf.localScale = var1
	end
end

function var0.GetPositionAndScale(arg0, arg1)
	local var0, var1, var2 = getProxy(SettingsProxy):getSkinPosSetting(arg1)
	local var3 = Vector3(0, 0, 0)
	local var4 = Vector3(1, 1, 1)

	if var0 then
		var3 = Vector3(var0, var1, 0)
		var4 = Vector3(var2, var2, 1)
	else
		local var5, var6 = arg0.shift:GetMeshImageShift()

		var3 = var5
		var4 = var6
	end

	return var3, var4
end

function var0.GetAssistantStatus(arg0)
	local var0 = arg0:getPainting()
	local var1 = getProxy(SettingsProxy)
	local var2 = HXSet.autoHxShiftPath("spinepainting/" .. var0)
	local var3 = checkABExist(var2)
	local var4 = HXSet.autoHxShiftPath("live2d/" .. var0)
	local var5 = var0.Live2dIsDownload(var4) and checkABExist(var4)
	local var6 = var1:getCharacterSetting(arg0.id, SHIP_FLAG_BG)

	if var1:getCharacterSetting(arg0.id, SHIP_FLAG_SP) and var3 then
		return var0.STATE_SPINE_PAINTING, var6
	elseif var1:getCharacterSetting(arg0.id, SHIP_FLAG_L2D) and var5 then
		return var0.STATE_L2D, var6
	elseif isa(arg0, VirtualEducateCharShip) then
		return var0.STATE_EDUCATE_CHAR, var6
	else
		return var0.STATE_PAINTING, var6
	end
end

function var0.Live2dIsDownload(arg0)
	local var0 = GroupHelper.GetGroupMgrByName("L2D"):CheckF(arg0)

	return var0 == DownloadState.None or var0 == DownloadState.UpdateSuccess
end

function var0.Fold(arg0, arg1, arg2)
	LeanTween.cancel(arg0._tf.gameObject)
	LeanTween.cancel(arg0._bgTf.gameObject)

	if arg1 and not arg0.silentFlag then
		local var0 = arg0._tf.localPosition - arg0._bgTf.localPosition
		local var1 = arg0.shift:GetMeshImageShift()
		local var2 = Vector3(0 - arg0.painting:GetOffset(), var1.y, 0)

		LeanTween.moveLocal(arg0._tf.gameObject, var2, arg2):setEase(LeanTweenType.easeInOutExpo)

		local var3 = var2 - var0

		LeanTween.moveLocal(arg0._bgTf.gameObject, var3, arg2):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0.painting:Fold(arg1, arg2)
		end))
	elseif arg0.ship then
		local var4 = arg0:GetPositionAndScale(arg0.ship)

		LeanTween.moveLocal(arg0._tf.gameObject, var4, arg2):setEase(LeanTweenType.easeInOutExpo)
		LeanTween.moveLocal(arg0._bgTf.gameObject, var4, arg2):setEase(LeanTweenType.easeInOutExpo):setOnComplete(System.Action(function()
			arg0.painting:Fold(arg1, arg2)
		end))
	end
end

function var0.EnableOrDisableMove(arg0, arg1)
	arg0.painting:EnableOrDisableMove(arg1)

	if arg1 then
		arg0:EnableDragAndZoom()
	else
		arg0:DisableDragAndZoom()
	end
end

function var0.EnableDragAndZoom(arg0)
	arg0.isEnableDrag = true

	local var0 = arg0._tf.parent.gameObject
	local var1 = GetOrAddComponent(var0, typeof(PinchZoom))
	local var2 = GetOrAddComponent(var0, typeof(EventTriggerListener))
	local var3 = Vector3(0, 0, 0)

	var2:AddBeginDragFunc(function(arg0, arg1)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1.processing then
			return
		end

		setButtonEnabled(var0, false)

		if Input.touchCount > 1 then
			return
		end

		local var0 = var0.Screen2Local(var0.transform.parent, arg1.position)

		var3 = arg0._tf.localPosition - var0
	end)
	var2:AddDragFunc(function(arg0, arg1)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0 = var0.Screen2Local(var0.transform.parent, arg1.position)

		arg0._tf.localPosition = arg0.painting:IslimitYPos() and Vector3(var0.x, var0.transform.localPosition.y, 0) + Vector3(var3.x, 0, 0) or Vector3(var0.x, var0.y, 0) + var3
		arg0._bgTf.localPosition = arg0.bgOffset + arg0._tf.localPosition
	end)
	var2:AddDragEndFunc(function()
		setButtonEnabled(var0, true)
	end)

	if not arg0.painting:IslimitYPos() then
		var1.enabled = true
	end

	var2.enabled = true
	Input.multiTouchEnabled = true
	arg0.cg.blocksRaycasts = false

	arg0:AdjustPosition(arg0.ship)
end

function var0.DisableDragAndZoom(arg0)
	if arg0.isEnableDrag then
		local var0 = arg0._tf.parent:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0)

		var0.enabled = false
		arg0._tf.parent:GetComponent(typeof(PinchZoom)).enabled = false
		arg0.cg.blocksRaycasts = true
		arg0.isEnableDrag = false
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:DisableDragAndZoom()

	if arg0.painting then
		arg0.painting:Unload()
	end

	arg0.painting = nil

	for iter0, iter1 in ipairs(arg0.paintings) do
		iter1:Dispose()
	end

	arg0.paintings = nil
end

function var0.Screen2Local(arg0, arg1)
	local var0 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")
	local var2 = LuaHelper.ScreenToLocal(var1, arg1, var0)

	return Vector3(var2.x, var2.y, 0)
end

return var0
