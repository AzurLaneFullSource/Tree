pg = pg or {}

local var0_0 = singletonClass("UIMgr")

pg.UIMgr = var0_0

local var1_0 = pg

var0_0._loadPanel = nil
var0_0.CameraUI = 1
var0_0.CameraLevel = 2
var0_0.CameraOverlay = 3
var0_0.OptimizedBlur = 1
var0_0.StaticBlur = 2
var0_0.PartialBlur = 3

local function var2_0(arg0_1)
	if arg0_1 == nil then
		return
	end

	arg0_1.downsample = 2
	arg0_1.blurSize = 4
	arg0_1.blurIterations = 2
end

local function var3_0(arg0_2)
	if arg0_2 == nil then
		return
	end

	arg0_2.downsample = 2
	arg0_2.blurSize = 1.5
	arg0_2.blurIteration = 4
end

local function var4_0(arg0_3)
	if arg0_3 == nil then
		return
	end

	arg0_3.downsample = 2
	arg0_3.blurSize = 4
	arg0_3.blurIterations = 1
end

local function var5_0(arg0_4)
	if arg0_4 == nil then
		return
	end

	arg0_4.downsample = 2
	arg0_4.blurSize = 1.5
	arg0_4.blurIteration = 1
end

function var0_0.Init(arg0_5, arg1_5)
	print("initializing ui manager...")

	arg0_5.mainCamera = GameObject.Find("MainCamera")

	setActive(arg0_5.mainCamera, false)

	arg0_5.mainCameraComp = arg0_5.mainCamera:GetComponent("Camera")
	arg0_5.uiCamera = tf(GameObject.Find("UICamera"))
	arg0_5.uiCameraComp = arg0_5.uiCamera:GetComponent("Camera")
	arg0_5.uiCameraComp.allowMSAA = false
	arg0_5.levelCamera = tf(GameObject.Find("LevelCamera"))
	arg0_5.levelCameraComp = arg0_5.levelCamera:GetComponent("Camera")
	arg0_5.levelCameraComp.allowMSAA = false
	arg0_5.overlayCamera = tf(GameObject.Find("OverlayCamera"))
	arg0_5.overlayCameraComp = arg0_5.overlayCamera:GetComponent("Camera")
	arg0_5.overlayCameraComp.allowMSAA = false
	arg0_5.UIMain = arg0_5.uiCamera:Find("Canvas/UIMain")
	arg0_5.LevelMain = arg0_5.levelCamera:Find("Canvas/UIMain")
	arg0_5.OverlayMain = arg0_5.overlayCamera:Find("Overlay/UIMain")
	arg0_5.OverlayToast = arg0_5.overlayCamera:Find("Overlay/UIOverlay")
	arg0_5.OverlayEffect = arg0_5.overlayCamera:Find("Overlay/UIEffect")
	arg0_5._normalUIMain = nil
	arg0_5._cameraBlurPartial = arg0_5.uiCamera:GetComponent("UIPartialBlur")
	arg0_5._levelCameraPartial = arg0_5.levelCamera:GetComponent("UIPartialBlur")

	ReflectionHelp.RefCallMethod(typeof("UIPartialBlur"), "Cleanup", arg0_5._levelCameraPartial)

	arg0_5._levelCameraPartial.blurCam = arg0_5.levelCameraComp
	arg0_5.cameraBlurs = {
		[var0_0.CameraUI] = {
			arg0_5.uiCamera:GetComponent("BlurOptimized"),
			arg0_5.uiCamera:GetComponent("UIStaticBlur"),
			arg0_5._cameraBlurPartial
		},
		[var0_0.CameraLevel] = {
			arg0_5.levelCamera:GetComponent("BlurOptimized"),
			arg0_5.levelCamera:GetComponent("UIStaticBlur"),
			arg0_5._levelCameraPartial
		},
		[var0_0.CameraOverlay] = {
			arg0_5.overlayCamera:GetComponent("BlurOptimized"),
			(arg0_5.overlayCamera:GetComponent("UIStaticBlur"))
		}
	}
	arg0_5.camLockStatus = {
		[var0_0.CameraUI] = false,
		[var0_0.CameraLevel] = false,
		[var0_0.CameraOverlay] = false
	}

	local var0_5 = DevicePerformanceUtil.GetDeviceLevel()

	for iter0_5, iter1_5 in ipairs(arg0_5.cameraBlurs) do
		if var0_5 == DevicePerformanceLevel.Low then
			var4_0(iter1_5[var0_0.OptimizedBlur])
			var5_0(iter1_5[var0_0.PartialBlur])
		else
			var2_0(iter1_5[var0_0.OptimizedBlur])
			var3_0(iter1_5[var0_0.PartialBlur])
		end
	end

	arg0_5.defaultMaterial = Material.New(Shader.Find("UI/Default"))
	arg0_5.partialBlurMaterial = Material.New(Shader.Find("UI/PartialBlur"))
	arg0_5._debugPanel = DebugPanel.New()

	setActive(arg0_5.uiCamera, false)
	seriesAsync({
		function(arg0_6)
			setActive(arg0_5.uiCamera, true)

			arg0_5._loadPanel = LoadingPanel.New(arg0_6)
		end
	}, arg1_5)
end

function var0_0.Loading(arg0_7, arg1_7)
	arg0_7._loadPanel:appendInfo(arg1_7)
end

function var0_0.LoadingOn(arg0_8, arg1_8)
	arg0_8._loadPanel:on(arg1_8)
end

function var0_0.displayLoadingBG(arg0_9, arg1_9)
	if tobool(arg0_9.showBG) == arg1_9 then
		return
	end

	arg0_9._loadPanel:displayBG(arg1_9)

	arg0_9.showBG = arg1_9

	if arg0_9.showBG then
		var1_0.UIMgr.GetInstance():LoadingOn()
	else
		var1_0.UIMgr.GetInstance():LoadingOff()
	end
end

function var0_0.LoadingOff(arg0_10)
	arg0_10._loadPanel:off()
end

function var0_0.OnLoading(arg0_11)
	return arg0_11._loadPanel:onLoading()
end

function var0_0.LoadingRetainCount(arg0_12)
	return arg0_12._loadPanel:getRetainCount()
end

function var0_0.AddDebugButton(arg0_13, arg1_13, arg2_13)
	arg0_13._debugPanel:addCustomBtn(arg1_13, arg2_13)
end

function var0_0.AddWorldTestButton(arg0_14, arg1_14, arg2_14)
	arg0_14._debugPanel:addCustomBtn(arg1_14, function()
		arg0_14._debugPanel:hidePanel()
		arg2_14()
	end)
end

var0_0._maxbianjie = 50
var0_0._maxbianjieInv = 0.02
var0_0._maxbianjieSqr = 2500
var0_0._followRange = 0
var0_0._stick = nil
var0_0._areaImg = nil
var0_0._stickImg = nil
var0_0._stickCom = nil
var0_0._normalColor = Color(255, 255, 255, 1)
var0_0._darkColor = Color(255, 255, 255, 0.5)
var0_0._firstPos = Vector3.zero

function var0_0.AttachStickOb(arg0_16, arg1_16)
	arg0_16.hrz = 0
	arg0_16.vtc = 0
	arg0_16.fingerId = -1

	local var0_16 = arg1_16:Find("Area")

	arg0_16._stick = var0_16:Find("Stick")
	arg0_16._areaImg = var0_16:GetComponent(typeof(Image))
	arg0_16._stickImg = arg0_16._stick:GetComponent(typeof(Image))
	arg0_16._stickCom = arg1_16:GetComponent(typeof(StickController))
	arg0_16._stickCom.StickBorderRate = 1

	arg0_16._stickCom:SetStickFunc(function(arg0_17, arg1_17)
		arg0_16:UpdateStick(arg0_17, arg1_17)
	end)

	arg0_16._firstPos = var0_16.localPosition
	arg0_16.vtc = 0
	arg0_16._stickTailPS = arg0_16._stick:Find("tailGizmos")

	arg0_16:SetActive(true)
end

function var0_0.SetActive(arg0_18, arg1_18)
	arg0_18._stickActive = arg1_18
end

function var0_0.Marching(arg0_19)
	local var0_19 = ys.Battle.BattleConfig

	LeanTween.value(go(arg0_19._stick), 0, 0.625, 1.8):setOnUpdate(System.Action_float(function(arg0_20)
		arg0_19.hrz = var0_19.START_SPEED_CONST_B * (arg0_20 - var0_19.START_SPEED_CONST_A) * (arg0_20 - var0_19.START_SPEED_CONST_A)
	end)):setOnComplete(System.Action(function()
		arg0_19.hrz = 0
	end))
end

function var0_0.UpdateStick(arg0_22, arg1_22, arg2_22)
	if not arg0_22._stickActive then
		return
	end

	if arg0_22._stickTailPS then
		if arg2_22 == -1 then
			if arg2_22 ~= arg0_22.fingerId then
				setActive(arg0_22._stickTailPS, false)
			end
		elseif arg2_22 > 0 and arg2_22 ~= arg0_22.fingerId then
			setActive(arg0_22._stickTailPS, true)
		end
	end

	if arg2_22 == -2 then
		arg0_22:SetOutput(arg1_22.x, arg1_22.y, -2)

		return
	elseif arg2_22 == -1 then
		arg0_22:SetOutput(0, 0, arg2_22)

		return
	end

	local var0_22 = arg1_22

	var0_22.z = 0

	local var1_22 = var0_22:SqrMagnitude()

	if var1_22 > arg0_22._maxbianjieSqr then
		var0_22 = var0_22 / math.sqrt(var1_22)

		local var2_22 = var0_22 * arg0_22._maxbianjie

		if arg1_22 - var2_22 ~= arg0_22._firstPos then
			local var3_22 = arg0_22._firstPos
		end

		arg0_22._stick.localPosition = var2_22

		arg0_22:SetOutput(var0_22.x, var0_22.y, arg2_22)
	else
		arg0_22._stick.localPosition = arg1_22

		arg0_22:SetOutput(var0_22.x * arg0_22._maxbianjieInv, var0_22.y * arg0_22._maxbianjieInv, arg2_22)
	end
end

function var0_0.SetOutput(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23.hrz = arg1_23
	arg0_23.vtc = arg2_23

	local var0_23 = (arg3_23 >= 0 and 1 or 0) - (arg0_23.fingerId >= 0 and 1 or 0)

	if var0_23 ~= 0 and arg0_23._areaImg and arg0_23._stickImg then
		arg0_23._areaImg.color = var0_23 > 0 and var0_0._normalColor or var0_0._darkColor
		arg0_23._stickImg.color = var0_23 > 0 and var0_0._normalColor or var0_0._darkColor
	end

	if arg3_23 < 0 then
		arg0_23._stick.localPosition = Vector3.zero
	end

	arg0_23.fingerId = arg3_23
end

function var0_0.ClearStick(arg0_24)
	arg0_24._stick.localPosition = Vector3.zero

	arg0_24._stickCom:ClearStickFunc()

	arg0_24._stick = nil
	arg0_24._areaImg = nil
	arg0_24._stickImg = nil
	arg0_24._stickCom = nil
end

local var6_0 = {}
local var7_0 = false

function var0_0.OverlayPanel(arg0_25, arg1_25, arg2_25)
	arg2_25 = arg2_25 or {}
	arg2_25.globalBlur = false

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_25, arg2_25)
end

function var0_0.UnOverlayPanel(arg0_26, arg1_26, arg2_26)
	var1_0.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_26, arg2_26 or arg0_26.UIMain)
end

function var0_0.BlurPanel(arg0_27, arg1_27, arg2_27, arg3_27)
	arg3_27 = arg3_27 or {}
	arg3_27.globalBlur = true
	arg3_27.staticBlur = arg2_27

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_27, arg3_27)
end

function var0_0.UnblurPanel(arg0_28, arg1_28, arg2_28)
	var1_0.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_28, arg2_28 or arg0_28.UIMain)
end

function var0_0.OverlayPanelPB(arg0_29, arg1_29, arg2_29)
	arg2_29 = arg2_29 or {}
	arg2_29.globalBlur = false

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_29, arg2_29)
end

function var0_0.PartialBlurTfs(arg0_30, arg1_30)
	var7_0 = true
	var6_0 = arg1_30

	arg0_30:UpdatePBEnable(true)
end

function var0_0.ShutdownPartialBlur(arg0_31)
	var7_0 = false
	var6_0 = {}

	arg0_31:UpdatePBEnable(false)
end

function var0_0.RevertPBMaterial(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg1_32) do
		local var0_32 = iter1_32:GetComponent(typeof(Image))

		assert(var0_32, "mask should be an image.")

		var0_32.material = arg0_32.defaultMaterial
	end
end

function var0_0.UpdatePBEnable(arg0_33, arg1_33)
	if var6_0 ~= nil then
		for iter0_33, iter1_33 in ipairs(var6_0) do
			local var0_33 = iter1_33:GetComponent(typeof(Image))

			assert(var0_33, "mask should be an image.")

			var0_33.material = arg1_33 and arg0_33.partialBlurMaterial or nil
		end
	end

	if arg1_33 then
		if arg0_33.levelCameraComp.enabled then
			arg0_33.cameraBlurs[var0_0.CameraLevel][var0_0.PartialBlur].enabled = true
			arg0_33.cameraBlurs[var0_0.CameraUI][var0_0.PartialBlur].enabled = false
		else
			arg0_33.cameraBlurs[var0_0.CameraLevel][var0_0.PartialBlur].enabled = false
			arg0_33.cameraBlurs[var0_0.CameraUI][var0_0.PartialBlur].enabled = true
		end
	else
		for iter2_33, iter3_33 in ipairs(arg0_33.cameraBlurs) do
			if iter3_33[var0_0.PartialBlur] then
				iter3_33[var0_0.PartialBlur].enabled = false
			end
		end
	end
end

local var8_0

function var0_0.TempOverlayPanelPB(arg0_34, arg1_34, arg2_34)
	arg0_34:OverlayPanel(arg1_34, setmetatable({}, {
		__index = function(arg0_35, arg1_35)
			if arg1_35 == "pbList" then
				return nil
			end

			return arg2_34[arg1_35]
		end
	}))

	var6_0 = arg2_34.pbList

	local var0_34 = arg2_34.baseCamera

	var8_0 = {
		var0_34:GetComponent("BlurOptimized"),
		var0_34:GetComponent("UIStaticBlur"),
		var0_34:GetComponent("UIPartialBlur")
	}

	if DevicePerformanceUtil.GetDeviceLevel() == DevicePerformanceLevel.Low then
		var4_0(var8_0[var0_0.OptimizedBlur])
		var5_0(var8_0[var0_0.PartialBlur])
	else
		var2_0(var8_0[var0_0.OptimizedBlur])
		var3_0(var8_0[var0_0.PartialBlur])
	end

	var8_0[var0_0.PartialBlur].maskCam = arg0_34.overlayCamera:GetComponent("Camera")

	arg0_34:UpdateOtherPBEnable(true, var8_0)
end

function var0_0.TempUnblurPanel(arg0_36, arg1_36, arg2_36)
	arg0_36:UnOverlayPanel(arg1_36, arg2_36)
	arg0_36:UpdateOtherPBEnable(false, var8_0)

	var8_0 = nil

	setParent(arg1_36, arg2_36)
end

function var0_0.UpdateOtherPBEnable(arg0_37, arg1_37, arg2_37)
	if var6_0 ~= nil then
		for iter0_37, iter1_37 in ipairs(var6_0) do
			local var0_37 = iter1_37:GetComponent(typeof(Image))

			assert(var0_37, "mask should be an image.")

			var0_37.material = arg1_37 and arg0_37.partialBlurMaterial or nil
		end
	end

	arg2_37[var0_0.PartialBlur].enabled = arg1_37
end

function var0_0.BlurCamera(arg0_38, arg1_38, arg2_38, arg3_38)
	if not arg0_38.camLockStatus[arg1_38] or arg3_38 then
		local var0_38 = arg0_38.cameraBlurs[arg1_38][var0_0.OptimizedBlur]
		local var1_38 = arg0_38.cameraBlurs[arg1_38][var0_0.StaticBlur]

		if arg2_38 then
			var0_38.enabled = true
			var0_38.staticBlur = true
			var1_38.enabled = false
		else
			var0_38.enabled = true
			var0_38.staticBlur = false
			var1_38.enabled = false
		end

		if arg3_38 then
			arg0_38.camLockStatus[arg1_38] = true
		end
	end
end

function var0_0.UnblurCamera(arg0_39, arg1_39, arg2_39)
	if not arg0_39.camLockStatus[arg1_39] or arg2_39 then
		local var0_39 = arg0_39.cameraBlurs[arg1_39][var0_0.OptimizedBlur]

		arg0_39.cameraBlurs[arg1_39][var0_0.StaticBlur].enabled = false
		var0_39.enabled = false

		if arg2_39 then
			arg0_39.camLockStatus[arg1_39] = false
		end
	end
end

function var0_0.GetStaticRtt(arg0_40, arg1_40)
	local var0_40 = arg0_40.cameraBlurs[arg1_40][var0_0.OptimizedBlur]

	return (ReflectionHelp.RefGetField(typeof("UnityStandardAssets.ImageEffects.BlurOptimized"), "staticRtt", var0_40))
end

function var0_0.SetMainCamBlurTexture(arg0_41, arg1_41)
	local var0_41 = arg0_41.mainCamera:GetComponent(typeof(Camera))
	local var1_41 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width,
		Screen.height,
		0
	})

	var0_41.targetTexture = var1_41

	var0_41:Render()

	local var2_41 = var1_0.ShaderMgr.GetInstance():BlurTexture(var1_41)

	var0_41.targetTexture = nil

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1_41
	})

	arg1_41.uvRect = var0_41.rect
	arg1_41.texture = var2_41

	return var2_41
end

function var0_0.GetMainCamera(arg0_42)
	return arg0_42.mainCamera
end
