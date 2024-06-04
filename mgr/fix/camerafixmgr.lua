pg = pg or {}
pg.CameraFixMgr = singletonClass("CameraFixMgr", import("view.base.BaseEventLogic"))

local var0 = pg.CameraFixMgr

var0.ASPECT_RATIO_UPDATE = "aspect_ratio_update"

local var1 = 211

function var0.Init(arg0, arg1)
	arg0.orientation = Screen.orientation
	arg0.adpterTr = GameObject.Find("UICamera/Adpter").transform
	arg0.adpterCanvas = arg0.adpterTr:GetComponent("Canvas")
	arg0.leftPanel = arg0.adpterTr:Find("left")
	arg0.rightPanel = arg0.adpterTr:Find("right")
	arg0.topPanel = arg0.adpterTr:Find("top")
	arg0.bottomPanel = arg0.adpterTr:Find("bottom")
	arg0.cameraMgr = CameraMgr.instance
	arg0.paddingCanvas = arg0.adpterTr
	arg0.mainCam = arg0.cameraMgr.mainCamera
	arg0.shouldFix = false
	arg0.aspectRatio = 1.77777777777778
	arg0.targetRatio = arg0.aspectRatio
	arg0.maxAspectRatio = 2.3

	arg0:AddListener()

	arg0.currentWidth = Screen.width
	arg0.currentHeight = Screen.height

	arg0:Adapt()
	arg0:SetMaskAsTopLayer(false)
	arg1()
end

function var0.SetMaskAsTopLayer(arg0, arg1)
	if arg1 then
		arg0.adpterCanvas.sortingOrder = 1000
	else
		arg0.adpterCanvas.sortingOrder = -1000
	end
end

function var0.AddListener(arg0)
	arg0:Clear()

	if not arg0.handle then
		arg0.cameraMgr.AutoAdapt = false
		arg0.handle = LateUpdateBeat:CreateListener(arg0.LateUpdate, arg0)
	end

	LateUpdateBeat:AddListener(arg0.handle)
end

function var0.LateUpdate(arg0)
	if arg0.shouldFix then
		arg0.shouldFix = false

		arg0:Adapt()
	end

	local var0 = Screen.width
	local var1 = Screen.height

	if arg0.currentWidth ~= var0 or arg0.currentHeight ~= var1 or Screen.orientation ~= arg0.orientation then
		arg0.shouldFix = true
		arg0.orientation = Screen.orientation
		arg0.currentWidth = var0
		arg0.currentHeight = var1
	end
end

function var0.Adapt(arg0)
	local var0 = arg0.currentWidth / arg0.currentHeight
	local var1 = false

	if var0 > arg0.aspectRatio then
		var1 = true
	end

	arg0.targetRatio = arg0.aspectRatio

	if var1 then
		if var0 < arg0.aspectRatio then
			arg0.targetRatio = arg0.aspectRatio
		else
			arg0.targetRatio = math.min(var0, arg0.maxAspectRatio)
		end

		arg0:AdaptTo(arg0.mainCam, arg0.targetRatio)
		arg0:Padding()
	else
		arg0:AdaptTo(arg0.mainCam, arg0.targetRatio)
		arg0:Padding()
	end

	arg0:emit(var0.ASPECT_RATIO_UPDATE, arg0.targetRatio)
end

function var0.AdaptTo(arg0, arg1, arg2)
	local var0 = arg0.currentWidth / arg0.currentHeight
	local var1 = NotchAdapt.CheckNotchRatio

	if var0 <= arg2 then
		local var2 = 0
		local var3 = 1
		local var4 = Mathf.Clamp01(var3 * var0 / arg2)
		local var5 = Mathf.Clamp01((1 - var4) * 0.5)

		arg1.rect = UnityEngine.Rect.New(var2, var5, var3, var4)
		arg0.actualWidth = arg0.currentWidth
		arg0.actualHeight = arg0.currentWidth / arg2

		local var6 = (arg0.currentHeight - arg0.actualHeight) * 0.5

		arg0.leftBottomVector = Vector3(0, var6, 0)
		arg0.rightTopVector = Vector3(arg0.currentWidth, arg0.currentHeight - var6, 0)
		CameraMgr.instance.finalWidth = arg0.actualWidth
		CameraMgr.instance.finalHeight = arg0.actualHeight
	else
		local var7 = 0
		local var8 = 1
		local var9 = Mathf.Clamp01(var8 * arg2 / var0)
		local var10 = Mathf.Clamp01((1 - var9) * 0.5)

		arg1.rect = UnityEngine.Rect.New(var10, var7, var9, var8)
		arg0.actualWidth = arg0.currentHeight * arg2
		arg0.actualHeight = arg0.currentHeight

		local var11 = (arg0.currentWidth - arg0.actualWidth) * 0.5

		arg0.leftBottomVector = Vector3(var11, 0, 0)
		arg0.rightTopVector = Vector3(arg0.currentWidth - var11, arg0.currentHeight, 0)
		CameraMgr.instance.finalHeight = arg0.actualHeight
		CameraMgr.instance.finalWidth = arg0.actualWidth
	end

	if var0 > ADAPT_NOTICE and var1 < arg2 then
		arg0.notchAdaptWidth = arg0.currentHeight * var1
		arg0.notchAdaptHeight = arg0.currentHeight

		local var12 = (arg0.currentWidth - arg0.notchAdaptWidth) * 0.5

		arg0.notchAdaptLBVector = Vector3(var12, 0, 0)
		arg0.notchAdaptRTVector = Vector3(arg0.currentWidth - var12, arg0.currentHeight, 0)
	else
		arg0.notchAdaptWidth = arg0.actualWidth
		arg0.notchAdaptHeight = arg0.actualHeight
		arg0.notchAdaptLBVector = arg0.leftBottomVector
		arg0.notchAdaptRTVector = arg0.rightTopVector
	end
end

function var0.Padding(arg0)
	local var0 = arg0.aspectRatio
	local var1 = arg0.paddingCanvas.sizeDelta.x
	local var2 = arg0.paddingCanvas.sizeDelta.y
	local var3 = 0
	local var4 = 0
	local var5 = arg0.currentWidth / arg0.currentHeight

	if var5 <= var0 then
		var3 = var1
		var4 = var1 / var0
	elseif var5 > arg0.maxAspectRatio then
		var4 = var2
		var3 = var2 * arg0.maxAspectRatio
	else
		var4 = var2
		var3 = var1
	end

	local var6 = (var1 - var3) * 0.5
	local var7 = (var2 - var4) * 0.5

	if var7 > 0 then
		local var8 = math.max(var7, var1)

		arg0.topPanel.sizeDelta = Vector2(var8, var1)
		arg0.bottomPanel.sizeDelta = Vector2(var8, var1)

		if var7 < var1 then
			local var9 = var1 - var7 - 1

			arg0.topPanel.anchoredPosition3D = Vector3(0, var9, 0)
			arg0.bottomPanel.anchoredPosition3D = Vector3(0, -var9, 0)
		else
			arg0.topPanel.anchoredPosition3D = Vector3(0, 0, 0)
			arg0.bottomPanel.anchoredPosition3D = Vector3(0, 0, 0)
		end
	else
		arg0.topPanel.sizeDelta = Vector2.zero
		arg0.bottomPanel.sizeDelta = Vector2.zero
	end

	if var6 > 0 then
		local var10 = math.max(var6, var1)

		arg0.leftPanel.sizeDelta = Vector2(var10, var2)
		arg0.rightPanel.sizeDelta = Vector2(var10, var2)

		if var6 < var1 then
			local var11 = var1 - var6

			arg0.leftPanel.anchoredPosition3D = Vector3(-var11, 0, 0)
			arg0.rightPanel.anchoredPosition3D = Vector3(var11, 0, 0)
		else
			arg0.leftPanel.anchoredPosition3D = Vector3(0, 0, 0)
			arg0.rightPanel.anchoredPosition3D = Vector3(0, 0, 0)
		end
	else
		arg0.leftPanel.sizeDelta = Vector2.zero
		arg0.rightPanel.sizeDelta = Vector2.zero
	end
end

function var0.ResetPadding(arg0)
	arg0.topPanel.sizeDelta = Vector2.zero
	arg0.bottomPanel.sizeDelta = Vector2.zero
	arg0.leftPanel.sizeDelta = Vector2.zero
	arg0.rightPanel.sizeDelta = Vector2.zero
end

function var0.GetBattleUIRatio(arg0)
	if arg0.currentWidth / arg0.currentHeight > ADAPT_NOTICE and NotchAdapt.CheckNotchRatio < arg0.targetRatio then
		return NotchAdapt.CheckNotchRatio
	end

	return arg0.targetRatio
end

function var0.GetCurrentWidth(arg0)
	return arg0.currentWidth
end

function var0.GetCurrentHeight(arg0)
	return arg0.currentHeight
end

function var0.Clear(arg0)
	if arg0.handle then
		LateUpdateBeat:RemoveListener(arg0.handle)
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
end
