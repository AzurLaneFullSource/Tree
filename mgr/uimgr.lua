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

function var0_0.Init(arg0_1, arg1_1)
	print("initializing ui manager...")

	arg0_1.mainCamera = GameObject.Find("MainCamera")
	arg0_1.mainCameraComp = arg0_1.mainCamera:GetComponent("Camera")
	arg0_1.uiCamera = tf(GameObject.Find("UICamera"))
	arg0_1.uiCameraComp = arg0_1.uiCamera:GetComponent("Camera")
	arg0_1.uiCameraComp.allowMSAA = false
	arg0_1.levelCamera = tf(GameObject.Find("LevelCamera"))
	arg0_1.levelCameraComp = arg0_1.levelCamera:GetComponent("Camera")
	arg0_1.levelCameraComp.allowMSAA = false
	arg0_1.overlayCamera = tf(GameObject.Find("OverlayCamera"))
	arg0_1.overlayCameraComp = arg0_1.overlayCamera:GetComponent("Camera")
	arg0_1.overlayCameraComp.allowMSAA = false
	arg0_1.UIMain = arg0_1.uiCamera:Find("Canvas/UIMain")
	arg0_1.LevelMain = arg0_1.levelCamera:Find("Canvas/UIMain")
	arg0_1.OverlayMain = arg0_1.overlayCamera:Find("Overlay/UIMain")
	arg0_1.OverlayToast = arg0_1.overlayCamera:Find("Overlay/UIOverlay")
	arg0_1.OverlayEffect = arg0_1.overlayCamera:Find("Overlay/UIEffect")
	arg0_1._normalUIMain = nil
	arg0_1._cameraBlurPartial = arg0_1.uiCamera:GetComponent("UIPartialBlur")
	arg0_1._levelCameraPartial = arg0_1.levelCamera:GetComponent("UIPartialBlur")

	ReflectionHelp.RefCallMethod(typeof("UIPartialBlur"), "Cleanup", arg0_1._levelCameraPartial)

	arg0_1._levelCameraPartial.blurCam = arg0_1.levelCameraComp
	arg0_1.cameraBlurs = {
		[var0_0.CameraUI] = {
			arg0_1.uiCamera:GetComponent("BlurOptimized"),
			arg0_1.uiCamera:GetComponent("UIStaticBlur"),
			arg0_1._cameraBlurPartial
		},
		[var0_0.CameraLevel] = {
			arg0_1.levelCamera:GetComponent("BlurOptimized"),
			arg0_1.levelCamera:GetComponent("UIStaticBlur"),
			arg0_1._levelCameraPartial
		},
		[var0_0.CameraOverlay] = {
			arg0_1.overlayCamera:GetComponent("BlurOptimized"),
			(arg0_1.overlayCamera:GetComponent("UIStaticBlur"))
		}
	}
	arg0_1.camLockStatus = {
		[var0_0.CameraUI] = false,
		[var0_0.CameraLevel] = false,
		[var0_0.CameraOverlay] = false
	}

	local function var0_1(arg0_2)
		if arg0_2 == nil then
			return
		end

		arg0_2.downsample = 2
		arg0_2.blurSize = 4
		arg0_2.blurIterations = 2
	end

	local function var1_1(arg0_3)
		if arg0_3 == nil then
			return
		end

		arg0_3.downsample = 2
		arg0_3.blurSize = 1.5
		arg0_3.blurIteration = 4
	end

	local function var2_1(arg0_4)
		if arg0_4 == nil then
			return
		end

		arg0_4.downsample = 2
		arg0_4.blurSize = 4
		arg0_4.blurIterations = 1
	end

	local function var3_1(arg0_5)
		if arg0_5 == nil then
			return
		end

		arg0_5.downsample = 2
		arg0_5.blurSize = 1.5
		arg0_5.blurIteration = 1
	end

	local var4_1 = DevicePerformanceUtil.GetDeviceLevel()

	for iter0_1, iter1_1 in ipairs(arg0_1.cameraBlurs) do
		if var4_1 == DevicePerformanceLevel.Low then
			var2_1(iter1_1[var0_0.OptimizedBlur])
			var3_1(iter1_1[var0_0.PartialBlur])
		else
			var0_1(iter1_1[var0_0.OptimizedBlur])
			var1_1(iter1_1[var0_0.PartialBlur])
		end
	end

	arg0_1.defaultMaterial = Material.New(Shader.Find("UI/Default"))
	arg0_1.partialBlurMaterial = Material.New(Shader.Find("UI/PartialBlur"))
	arg0_1._debugPanel = DebugPanel.New()

	setActive(arg0_1.uiCamera, false)
	seriesAsync({
		function(arg0_6)
			setActive(arg0_1.uiCamera, true)

			arg0_1._loadPanel = LoadingPanel.New(arg0_6)
		end,
		function(arg0_7)
			PoolMgr.GetInstance():GetUI("ClickEffect", true, function(arg0_8)
				setParent(arg0_8, arg0_1.OverlayEffect)

				local var0_8 = PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0

				SetActive(arg0_1.OverlayEffect, var0_8)
				arg0_7()
			end)
		end
	}, arg1_1)
end

function var0_0.Loading(arg0_9, arg1_9)
	arg0_9._loadPanel:appendInfo(arg1_9)
end

function var0_0.LoadingOn(arg0_10, arg1_10)
	arg0_10._loadPanel:on(arg1_10)
end

function var0_0.displayLoadingBG(arg0_11, arg1_11)
	arg0_11._loadPanel:displayBG(arg1_11)
end

function var0_0.LoadingOff(arg0_12)
	arg0_12._loadPanel:off()
end

function var0_0.OnLoading(arg0_13)
	return arg0_13._loadPanel:onLoading()
end

function var0_0.LoadingRetainCount(arg0_14)
	return arg0_14._loadPanel:getRetainCount()
end

function var0_0.AddDebugButton(arg0_15, arg1_15, arg2_15)
	arg0_15._debugPanel:addCustomBtn(arg1_15, arg2_15)
end

function var0_0.AddWorldTestButton(arg0_16, arg1_16, arg2_16)
	arg0_16._debugPanel:addCustomBtn(arg1_16, function()
		arg0_16._debugPanel:hidePanel()
		arg2_16()
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

function var0_0.AttachStickOb(arg0_18, arg1_18)
	arg0_18.hrz = 0
	arg0_18.vtc = 0
	arg0_18.fingerId = -1

	local var0_18 = arg1_18:Find("Area")

	arg0_18._stick = var0_18:Find("Stick")
	arg0_18._areaImg = var0_18:GetComponent(typeof(Image))
	arg0_18._stickImg = arg0_18._stick:GetComponent(typeof(Image))
	arg0_18._stickCom = arg1_18:GetComponent(typeof(StickController))
	arg0_18._stickCom.StickBorderRate = 1

	arg0_18._stickCom:SetStickFunc(function(arg0_19, arg1_19)
		arg0_18:UpdateStick(arg0_19, arg1_19)
	end)

	arg0_18._firstPos = var0_18.localPosition
	arg0_18.vtc = 0
	arg0_18._stickTailPS = arg0_18._stick:Find("tailGizmos")

	arg0_18:SetActive(true)
end

function var0_0.SetActive(arg0_20, arg1_20)
	arg0_20._stickActive = arg1_20
end

function var0_0.Marching(arg0_21)
	local var0_21 = ys.Battle.BattleConfig

	LeanTween.value(go(arg0_21._stick), 0, 0.625, 1.8):setOnUpdate(System.Action_float(function(arg0_22)
		arg0_21.hrz = var0_21.START_SPEED_CONST_B * (arg0_22 - var0_21.START_SPEED_CONST_A) * (arg0_22 - var0_21.START_SPEED_CONST_A)
	end)):setOnComplete(System.Action(function()
		arg0_21.hrz = 0
	end))
end

function var0_0.UpdateStick(arg0_24, arg1_24, arg2_24)
	if not arg0_24._stickActive then
		return
	end

	if arg0_24._stickTailPS then
		if arg2_24 == -1 then
			if arg2_24 ~= arg0_24.fingerId then
				setActive(arg0_24._stickTailPS, false)
			end
		elseif arg2_24 > 0 and arg2_24 ~= arg0_24.fingerId then
			setActive(arg0_24._stickTailPS, true)
		end
	end

	if arg2_24 == -2 then
		arg0_24:SetOutput(arg1_24.x, arg1_24.y, -2)

		return
	elseif arg2_24 == -1 then
		arg0_24:SetOutput(0, 0, arg2_24)

		return
	end

	local var0_24 = arg1_24

	var0_24.z = 0

	local var1_24 = var0_24:SqrMagnitude()

	if var1_24 > arg0_24._maxbianjieSqr then
		var0_24 = var0_24 / math.sqrt(var1_24)

		local var2_24 = var0_24 * arg0_24._maxbianjie

		if arg1_24 - var2_24 ~= arg0_24._firstPos then
			local var3_24 = arg0_24._firstPos
		end

		arg0_24._stick.localPosition = var2_24

		arg0_24:SetOutput(var0_24.x, var0_24.y, arg2_24)
	else
		arg0_24._stick.localPosition = arg1_24

		arg0_24:SetOutput(var0_24.x * arg0_24._maxbianjieInv, var0_24.y * arg0_24._maxbianjieInv, arg2_24)
	end
end

function var0_0.SetOutput(arg0_25, arg1_25, arg2_25, arg3_25)
	arg0_25.hrz = arg1_25
	arg0_25.vtc = arg2_25

	local var0_25 = (arg3_25 >= 0 and 1 or 0) - (arg0_25.fingerId >= 0 and 1 or 0)

	if var0_25 ~= 0 and arg0_25._areaImg and arg0_25._stickImg then
		arg0_25._areaImg.color = var0_25 > 0 and var0_0._normalColor or var0_0._darkColor
		arg0_25._stickImg.color = var0_25 > 0 and var0_0._normalColor or var0_0._darkColor
	end

	if arg3_25 < 0 then
		arg0_25._stick.localPosition = Vector3.zero
	end

	arg0_25.fingerId = arg3_25
end

function var0_0.ClearStick(arg0_26)
	arg0_26._stick.localPosition = Vector3.zero

	arg0_26._stickCom:ClearStickFunc()

	arg0_26._stick = nil
	arg0_26._areaImg = nil
	arg0_26._stickImg = nil
	arg0_26._stickCom = nil
end

local var2_0 = {}
local var3_0 = false

function var0_0.OverlayPanel(arg0_27, arg1_27, arg2_27)
	arg2_27 = arg2_27 or {}
	arg2_27.globalBlur = false

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_27, arg2_27)
end

function var0_0.UnOverlayPanel(arg0_28, arg1_28, arg2_28)
	var1_0.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_28, arg2_28 or arg0_28.UIMain)
end

function var0_0.BlurPanel(arg0_29, arg1_29, arg2_29, arg3_29)
	arg3_29 = arg3_29 or {}
	arg3_29.globalBlur = true
	arg3_29.staticBlur = arg2_29

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_29, arg3_29)
end

function var0_0.UnblurPanel(arg0_30, arg1_30, arg2_30)
	var1_0.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_30, arg2_30 or arg0_30.UIMain)
end

function var0_0.OverlayPanelPB(arg0_31, arg1_31, arg2_31)
	arg2_31 = arg2_31 or {}
	arg2_31.globalBlur = false

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_31, arg2_31)
end

function var0_0.PartialBlurTfs(arg0_32, arg1_32)
	var3_0 = true
	var2_0 = arg1_32

	arg0_32:UpdatePBEnable(true)
end

function var0_0.ShutdownPartialBlur(arg0_33)
	var3_0 = false
	var2_0 = {}

	arg0_33:UpdatePBEnable(false)
end

function var0_0.RevertPBMaterial(arg0_34, arg1_34)
	for iter0_34, iter1_34 in ipairs(arg1_34) do
		local var0_34 = iter1_34:GetComponent(typeof(Image))

		assert(var0_34, "mask should be an image.")

		var0_34.material = arg0_34.defaultMaterial
	end
end

function var0_0.UpdatePBEnable(arg0_35, arg1_35)
	if arg1_35 then
		if var2_0 ~= nil then
			for iter0_35, iter1_35 in ipairs(var2_0) do
				local var0_35 = iter1_35:GetComponent(typeof(Image))

				assert(var0_35, "mask should be an image.")

				var0_35.material = arg1_35 and arg0_35.partialBlurMaterial or nil
			end
		end

		if arg0_35.levelCameraComp.enabled then
			arg0_35.cameraBlurs[var0_0.CameraLevel][var0_0.PartialBlur].enabled = true
			arg0_35.cameraBlurs[var0_0.CameraUI][var0_0.PartialBlur].enabled = false
		else
			arg0_35.cameraBlurs[var0_0.CameraLevel][var0_0.PartialBlur].enabled = false
			arg0_35.cameraBlurs[var0_0.CameraUI][var0_0.PartialBlur].enabled = true
		end
	else
		for iter2_35, iter3_35 in ipairs(arg0_35.cameraBlurs) do
			if iter3_35[var0_0.PartialBlur] then
				iter3_35[var0_0.PartialBlur].enabled = false
			end
		end
	end
end

function var0_0.BlurCamera(arg0_36, arg1_36, arg2_36, arg3_36)
	if not arg0_36.camLockStatus[arg1_36] or arg3_36 then
		local var0_36 = arg0_36.cameraBlurs[arg1_36][var0_0.OptimizedBlur]
		local var1_36 = arg0_36.cameraBlurs[arg1_36][var0_0.StaticBlur]

		if arg2_36 then
			var0_36.enabled = true
			var0_36.staticBlur = true
			var1_36.enabled = false
		else
			var0_36.enabled = true
			var0_36.staticBlur = false
			var1_36.enabled = false
		end

		if arg3_36 then
			arg0_36.camLockStatus[arg1_36] = true
		end
	end
end

function var0_0.UnblurCamera(arg0_37, arg1_37, arg2_37)
	if not arg0_37.camLockStatus[arg1_37] or arg2_37 then
		local var0_37 = arg0_37.cameraBlurs[arg1_37][var0_0.OptimizedBlur]

		arg0_37.cameraBlurs[arg1_37][var0_0.StaticBlur].enabled = false
		var0_37.enabled = false

		if arg2_37 then
			arg0_37.camLockStatus[arg1_37] = false
		end
	end
end

function var0_0.GetStaticRtt(arg0_38, arg1_38)
	local var0_38 = arg0_38.cameraBlurs[arg1_38][var0_0.OptimizedBlur]

	return (ReflectionHelp.RefGetField(typeof("UnityStandardAssets.ImageEffects.BlurOptimized"), "staticRtt", var0_38))
end

function var0_0.SetMainCamBlurTexture(arg0_39, arg1_39)
	local var0_39 = arg0_39.mainCamera:GetComponent(typeof(Camera))
	local var1_39 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width,
		Screen.height,
		0
	})

	var0_39.targetTexture = var1_39

	var0_39:Render()

	local var2_39 = var1_0.ShaderMgr.GetInstance():BlurTexture(var1_39)

	var0_39.targetTexture = nil

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1_39
	})

	arg1_39.uvRect = var0_39.rect
	arg1_39.texture = var2_39

	return var2_39
end

function var0_0.GetMainCamera(arg0_40)
	return arg0_40.mainCamera
end
