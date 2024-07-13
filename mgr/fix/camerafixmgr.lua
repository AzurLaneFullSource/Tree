pg = pg or {}
pg.CameraFixMgr = singletonClass("CameraFixMgr", import("view.base.BaseEventLogic"))

local var0_0 = pg.CameraFixMgr

var0_0.ASPECT_RATIO_UPDATE = "aspect_ratio_update"

local var1_0 = 211

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.orientation = Screen.orientation
	arg0_1.adpterTr = GameObject.Find("UICamera/Adpter").transform
	arg0_1.adpterCanvas = arg0_1.adpterTr:GetComponent("Canvas")
	arg0_1.leftPanel = arg0_1.adpterTr:Find("left")
	arg0_1.rightPanel = arg0_1.adpterTr:Find("right")
	arg0_1.topPanel = arg0_1.adpterTr:Find("top")
	arg0_1.bottomPanel = arg0_1.adpterTr:Find("bottom")
	arg0_1.cameraMgr = CameraMgr.instance
	arg0_1.paddingCanvas = arg0_1.adpterTr
	arg0_1.mainCam = arg0_1.cameraMgr.mainCamera
	arg0_1.shouldFix = false
	arg0_1.aspectRatio = 1.77777777777778
	arg0_1.targetRatio = arg0_1.aspectRatio
	arg0_1.maxAspectRatio = 2.3

	arg0_1:AddListener()

	arg0_1.currentWidth = Screen.width
	arg0_1.currentHeight = Screen.height

	arg0_1:Adapt()
	arg0_1:SetMaskAsTopLayer(false)
	arg1_1()
end

function var0_0.SetMaskAsTopLayer(arg0_2, arg1_2)
	if arg1_2 then
		arg0_2.adpterCanvas.sortingOrder = 1000
	else
		arg0_2.adpterCanvas.sortingOrder = -1000
	end
end

function var0_0.AddListener(arg0_3)
	arg0_3:Clear()

	if not arg0_3.handle then
		arg0_3.cameraMgr.AutoAdapt = false
		arg0_3.handle = LateUpdateBeat:CreateListener(arg0_3.LateUpdate, arg0_3)
	end

	LateUpdateBeat:AddListener(arg0_3.handle)
end

function var0_0.LateUpdate(arg0_4)
	if arg0_4.shouldFix then
		arg0_4.shouldFix = false

		arg0_4:Adapt()
	end

	local var0_4 = Screen.width
	local var1_4 = Screen.height

	if arg0_4.currentWidth ~= var0_4 or arg0_4.currentHeight ~= var1_4 or Screen.orientation ~= arg0_4.orientation then
		arg0_4.shouldFix = true
		arg0_4.orientation = Screen.orientation
		arg0_4.currentWidth = var0_4
		arg0_4.currentHeight = var1_4
	end
end

function var0_0.Adapt(arg0_5)
	local var0_5 = arg0_5.currentWidth / arg0_5.currentHeight
	local var1_5 = false

	if var0_5 > arg0_5.aspectRatio then
		var1_5 = true
	end

	arg0_5.targetRatio = arg0_5.aspectRatio

	if var1_5 then
		if var0_5 < arg0_5.aspectRatio then
			arg0_5.targetRatio = arg0_5.aspectRatio
		else
			arg0_5.targetRatio = math.min(var0_5, arg0_5.maxAspectRatio)
		end

		arg0_5:AdaptTo(arg0_5.mainCam, arg0_5.targetRatio)
		arg0_5:Padding()
	else
		arg0_5:AdaptTo(arg0_5.mainCam, arg0_5.targetRatio)
		arg0_5:Padding()
	end

	arg0_5:emit(var0_0.ASPECT_RATIO_UPDATE, arg0_5.targetRatio)
end

function var0_0.AdaptTo(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.currentWidth / arg0_6.currentHeight
	local var1_6 = NotchAdapt.CheckNotchRatio

	if var0_6 <= arg2_6 then
		local var2_6 = 0
		local var3_6 = 1
		local var4_6 = Mathf.Clamp01(var3_6 * var0_6 / arg2_6)
		local var5_6 = Mathf.Clamp01((1 - var4_6) * 0.5)

		arg1_6.rect = UnityEngine.Rect.New(var2_6, var5_6, var3_6, var4_6)
		arg0_6.actualWidth = arg0_6.currentWidth
		arg0_6.actualHeight = arg0_6.currentWidth / arg2_6

		local var6_6 = (arg0_6.currentHeight - arg0_6.actualHeight) * 0.5

		arg0_6.leftBottomVector = Vector3(0, var6_6, 0)
		arg0_6.rightTopVector = Vector3(arg0_6.currentWidth, arg0_6.currentHeight - var6_6, 0)
		CameraMgr.instance.finalWidth = arg0_6.actualWidth
		CameraMgr.instance.finalHeight = arg0_6.actualHeight
	else
		local var7_6 = 0
		local var8_6 = 1
		local var9_6 = Mathf.Clamp01(var8_6 * arg2_6 / var0_6)
		local var10_6 = Mathf.Clamp01((1 - var9_6) * 0.5)

		arg1_6.rect = UnityEngine.Rect.New(var10_6, var7_6, var9_6, var8_6)
		arg0_6.actualWidth = arg0_6.currentHeight * arg2_6
		arg0_6.actualHeight = arg0_6.currentHeight

		local var11_6 = (arg0_6.currentWidth - arg0_6.actualWidth) * 0.5

		arg0_6.leftBottomVector = Vector3(var11_6, 0, 0)
		arg0_6.rightTopVector = Vector3(arg0_6.currentWidth - var11_6, arg0_6.currentHeight, 0)
		CameraMgr.instance.finalHeight = arg0_6.actualHeight
		CameraMgr.instance.finalWidth = arg0_6.actualWidth
	end

	if var0_6 > ADAPT_NOTICE and var1_6 < arg2_6 then
		arg0_6.notchAdaptWidth = arg0_6.currentHeight * var1_6
		arg0_6.notchAdaptHeight = arg0_6.currentHeight

		local var12_6 = (arg0_6.currentWidth - arg0_6.notchAdaptWidth) * 0.5

		arg0_6.notchAdaptLBVector = Vector3(var12_6, 0, 0)
		arg0_6.notchAdaptRTVector = Vector3(arg0_6.currentWidth - var12_6, arg0_6.currentHeight, 0)
	else
		arg0_6.notchAdaptWidth = arg0_6.actualWidth
		arg0_6.notchAdaptHeight = arg0_6.actualHeight
		arg0_6.notchAdaptLBVector = arg0_6.leftBottomVector
		arg0_6.notchAdaptRTVector = arg0_6.rightTopVector
	end
end

function var0_0.Padding(arg0_7)
	local var0_7 = arg0_7.aspectRatio
	local var1_7 = arg0_7.paddingCanvas.sizeDelta.x
	local var2_7 = arg0_7.paddingCanvas.sizeDelta.y
	local var3_7 = 0
	local var4_7 = 0
	local var5_7 = arg0_7.currentWidth / arg0_7.currentHeight

	if var5_7 <= var0_7 then
		var3_7 = var1_7
		var4_7 = var1_7 / var0_7
	elseif var5_7 > arg0_7.maxAspectRatio then
		var4_7 = var2_7
		var3_7 = var2_7 * arg0_7.maxAspectRatio
	else
		var4_7 = var2_7
		var3_7 = var1_7
	end

	local var6_7 = (var1_7 - var3_7) * 0.5
	local var7_7 = (var2_7 - var4_7) * 0.5

	if var7_7 > 0 then
		local var8_7 = math.max(var7_7, var1_0)

		arg0_7.topPanel.sizeDelta = Vector2(var8_7, var1_7)
		arg0_7.bottomPanel.sizeDelta = Vector2(var8_7, var1_7)

		if var7_7 < var1_0 then
			local var9_7 = var1_0 - var7_7 - 1

			arg0_7.topPanel.anchoredPosition3D = Vector3(0, var9_7, 0)
			arg0_7.bottomPanel.anchoredPosition3D = Vector3(0, -var9_7, 0)
		else
			arg0_7.topPanel.anchoredPosition3D = Vector3(0, 0, 0)
			arg0_7.bottomPanel.anchoredPosition3D = Vector3(0, 0, 0)
		end
	else
		arg0_7.topPanel.sizeDelta = Vector2.zero
		arg0_7.bottomPanel.sizeDelta = Vector2.zero
	end

	if var6_7 > 0 then
		local var10_7 = math.max(var6_7, var1_0)

		arg0_7.leftPanel.sizeDelta = Vector2(var10_7, var2_7)
		arg0_7.rightPanel.sizeDelta = Vector2(var10_7, var2_7)

		if var6_7 < var1_0 then
			local var11_7 = var1_0 - var6_7

			arg0_7.leftPanel.anchoredPosition3D = Vector3(-var11_7, 0, 0)
			arg0_7.rightPanel.anchoredPosition3D = Vector3(var11_7, 0, 0)
		else
			arg0_7.leftPanel.anchoredPosition3D = Vector3(0, 0, 0)
			arg0_7.rightPanel.anchoredPosition3D = Vector3(0, 0, 0)
		end
	else
		arg0_7.leftPanel.sizeDelta = Vector2.zero
		arg0_7.rightPanel.sizeDelta = Vector2.zero
	end
end

function var0_0.ResetPadding(arg0_8)
	arg0_8.topPanel.sizeDelta = Vector2.zero
	arg0_8.bottomPanel.sizeDelta = Vector2.zero
	arg0_8.leftPanel.sizeDelta = Vector2.zero
	arg0_8.rightPanel.sizeDelta = Vector2.zero
end

function var0_0.GetBattleUIRatio(arg0_9)
	if arg0_9.currentWidth / arg0_9.currentHeight > ADAPT_NOTICE and NotchAdapt.CheckNotchRatio < arg0_9.targetRatio then
		return NotchAdapt.CheckNotchRatio
	end

	return arg0_9.targetRatio
end

function var0_0.GetCurrentWidth(arg0_10)
	return arg0_10.currentWidth
end

function var0_0.GetCurrentHeight(arg0_11)
	return arg0_11.currentHeight
end

function var0_0.Clear(arg0_12)
	if arg0_12.handle then
		LateUpdateBeat:RemoveListener(arg0_12.handle)
	end
end

function var0_0.Dispose(arg0_13)
	arg0_13:Clear()
end
