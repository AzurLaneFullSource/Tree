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
			buildTempAB("ui/commonui_atlas", function(arg0_7)
				arg0_1._common_ui_bundle = arg0_7

				arg0_6()
			end)
		end,
		function(arg0_8)
			buildTempAB("skinicon", function(arg0_9)
				arg0_1._skinicon_bundle = arg0_9

				arg0_8()
			end)
		end,
		function(arg0_10)
			buildTempAB("attricon", function(arg0_11)
				arg0_1._attricon_bundle = arg0_11

				arg0_10()
			end)
		end,
		function(arg0_12)
			setActive(arg0_1.uiCamera, true)

			arg0_1._loadPanel = LoadingPanel.New(arg0_12)
		end,
		function(arg0_13)
			PoolMgr.GetInstance():GetUI("ClickEffect", true, function(arg0_14)
				setParent(arg0_14, arg0_1.OverlayEffect)

				local var0_14 = PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0

				SetActive(arg0_1.OverlayEffect, var0_14)
				arg0_13()
			end)
		end
	}, arg1_1)
end

function var0_0.Loading(arg0_15, arg1_15)
	arg0_15._loadPanel:appendInfo(arg1_15)
end

function var0_0.LoadingOn(arg0_16, arg1_16)
	arg0_16._loadPanel:on(arg1_16)
end

function var0_0.displayLoadingBG(arg0_17, arg1_17)
	arg0_17._loadPanel:displayBG(arg1_17)
end

function var0_0.LoadingOff(arg0_18)
	arg0_18._loadPanel:off()
end

function var0_0.OnLoading(arg0_19)
	return arg0_19._loadPanel:onLoading()
end

function var0_0.LoadingRetainCount(arg0_20)
	return arg0_20._loadPanel:getRetainCount()
end

function var0_0.AddDebugButton(arg0_21, arg1_21, arg2_21)
	arg0_21._debugPanel:addCustomBtn(arg1_21, arg2_21)
end

function var0_0.AddWorldTestButton(arg0_22, arg1_22, arg2_22)
	arg0_22._debugPanel:addCustomBtn(arg1_22, function()
		arg0_22._debugPanel:hidePanel()
		arg2_22()
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

function var0_0.AttachStickOb(arg0_24, arg1_24)
	arg0_24.hrz = 0
	arg0_24.vtc = 0
	arg0_24.fingerId = -1

	local var0_24 = arg1_24:Find("Area")

	arg0_24._stick = var0_24:Find("Stick")
	arg0_24._areaImg = var0_24:GetComponent(typeof(Image))
	arg0_24._stickImg = arg0_24._stick:GetComponent(typeof(Image))
	arg0_24._stickCom = arg1_24:GetComponent(typeof(StickController))
	arg0_24._stickCom.StickBorderRate = 1

	arg0_24._stickCom:SetStickFunc(function(arg0_25, arg1_25)
		arg0_24:UpdateStick(arg0_25, arg1_25)
	end)

	arg0_24._firstPos = var0_24.localPosition
	arg0_24.vtc = 0

	arg0_24:SetActive(true)
end

function var0_0.SetActive(arg0_26, arg1_26)
	arg0_26._stickActive = arg1_26
end

function var0_0.Marching(arg0_27)
	local var0_27 = ys.Battle.BattleConfig

	LeanTween.value(go(arg0_27._stick), 0, 0.625, 1.8):setOnUpdate(System.Action_float(function(arg0_28)
		arg0_27.hrz = var0_27.START_SPEED_CONST_B * (arg0_28 - var0_27.START_SPEED_CONST_A) * (arg0_28 - var0_27.START_SPEED_CONST_A)
	end)):setOnComplete(System.Action(function()
		arg0_27.hrz = 0
	end))
end

function var0_0.UpdateStick(arg0_30, arg1_30, arg2_30)
	if not arg0_30._stickActive then
		return
	end

	if arg2_30 == -2 then
		arg0_30:SetOutput(arg1_30.x, arg1_30.y, -2)

		return
	elseif arg2_30 == -1 then
		arg0_30:SetOutput(0, 0, arg2_30)

		return
	end

	local var0_30 = arg1_30

	var0_30.z = 0

	local var1_30 = var0_30:SqrMagnitude()

	if var1_30 > arg0_30._maxbianjieSqr then
		var0_30 = var0_30 / math.sqrt(var1_30)

		local var2_30 = var0_30 * arg0_30._maxbianjie

		if arg1_30 - var2_30 ~= arg0_30._firstPos then
			local var3_30 = arg0_30._firstPos
		end

		arg0_30._stick.localPosition = var2_30

		arg0_30:SetOutput(var0_30.x, var0_30.y, arg2_30)
	else
		arg0_30._stick.localPosition = arg1_30

		arg0_30:SetOutput(var0_30.x * arg0_30._maxbianjieInv, var0_30.y * arg0_30._maxbianjieInv, arg2_30)
	end
end

function var0_0.SetOutput(arg0_31, arg1_31, arg2_31, arg3_31)
	arg0_31.hrz = arg1_31
	arg0_31.vtc = arg2_31

	local var0_31 = (arg3_31 >= 0 and 1 or 0) - (arg0_31.fingerId >= 0 and 1 or 0)

	if var0_31 ~= 0 and arg0_31._areaImg and arg0_31._stickImg then
		arg0_31._areaImg.color = var0_31 > 0 and var0_0._normalColor or var0_0._darkColor
		arg0_31._stickImg.color = var0_31 > 0 and var0_0._normalColor or var0_0._darkColor
	end

	if arg3_31 < 0 then
		arg0_31._stick.localPosition = Vector3.zero
	end

	arg0_31.fingerId = arg3_31
end

function var0_0.ClearStick(arg0_32)
	arg0_32._stick.localPosition = Vector3.zero

	arg0_32._stickCom:ClearStickFunc()

	arg0_32._stick = nil
	arg0_32._areaImg = nil
	arg0_32._stickImg = nil
	arg0_32._stickCom = nil
end

local var2_0 = {}
local var3_0 = false

function var0_0.OverlayPanel(arg0_33, arg1_33, arg2_33)
	arg2_33 = arg2_33 or {}
	arg2_33.globalBlur = false

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_33, arg2_33)
end

function var0_0.UnOverlayPanel(arg0_34, arg1_34, arg2_34)
	var1_0.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_34, arg2_34 or arg0_34.UIMain)
end

function var0_0.BlurPanel(arg0_35, arg1_35, arg2_35, arg3_35)
	arg3_35 = arg3_35 or {}
	arg3_35.globalBlur = true
	arg3_35.staticBlur = arg2_35

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_35, arg3_35)
end

function var0_0.UnblurPanel(arg0_36, arg1_36, arg2_36)
	var1_0.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_36, arg2_36 or arg0_36.UIMain)
end

function var0_0.OverlayPanelPB(arg0_37, arg1_37, arg2_37)
	arg2_37 = arg2_37 or {}
	arg2_37.globalBlur = false

	var1_0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1_37, arg2_37)
end

function var0_0.PartialBlurTfs(arg0_38, arg1_38)
	var3_0 = true
	var2_0 = arg1_38

	arg0_38:UpdatePBEnable(true)
end

function var0_0.ShutdownPartialBlur(arg0_39)
	var3_0 = false
	var2_0 = {}

	arg0_39:UpdatePBEnable(false)
end

function var0_0.RevertPBMaterial(arg0_40, arg1_40)
	for iter0_40, iter1_40 in ipairs(arg1_40) do
		local var0_40 = iter1_40:GetComponent(typeof(Image))

		assert(var0_40, "mask should be an image.")

		var0_40.material = arg0_40.defaultMaterial
	end
end

function var0_0.UpdatePBEnable(arg0_41, arg1_41)
	if arg1_41 then
		if var2_0 ~= nil then
			for iter0_41, iter1_41 in ipairs(var2_0) do
				local var0_41 = iter1_41:GetComponent(typeof(Image))

				assert(var0_41, "mask should be an image.")

				var0_41.material = arg1_41 and arg0_41.partialBlurMaterial or nil
			end
		end

		if arg0_41.levelCameraComp.enabled then
			arg0_41.cameraBlurs[var0_0.CameraLevel][var0_0.PartialBlur].enabled = true
			arg0_41.cameraBlurs[var0_0.CameraUI][var0_0.PartialBlur].enabled = false
		else
			arg0_41.cameraBlurs[var0_0.CameraLevel][var0_0.PartialBlur].enabled = false
			arg0_41.cameraBlurs[var0_0.CameraUI][var0_0.PartialBlur].enabled = true
		end
	else
		for iter2_41, iter3_41 in ipairs(arg0_41.cameraBlurs) do
			if iter3_41[var0_0.PartialBlur] then
				iter3_41[var0_0.PartialBlur].enabled = false
			end
		end
	end
end

function var0_0.BlurCamera(arg0_42, arg1_42, arg2_42, arg3_42)
	if not arg0_42.camLockStatus[arg1_42] or arg3_42 then
		local var0_42 = arg0_42.cameraBlurs[arg1_42][var0_0.OptimizedBlur]
		local var1_42 = arg0_42.cameraBlurs[arg1_42][var0_0.StaticBlur]

		if arg2_42 then
			var0_42.enabled = true
			var0_42.staticBlur = true
			var1_42.enabled = false
		else
			var0_42.enabled = true
			var0_42.staticBlur = false
			var1_42.enabled = false
		end

		if arg3_42 then
			arg0_42.camLockStatus[arg1_42] = true
		end
	end
end

function var0_0.UnblurCamera(arg0_43, arg1_43, arg2_43)
	if not arg0_43.camLockStatus[arg1_43] or arg2_43 then
		local var0_43 = arg0_43.cameraBlurs[arg1_43][var0_0.OptimizedBlur]

		arg0_43.cameraBlurs[arg1_43][var0_0.StaticBlur].enabled = false
		var0_43.enabled = false

		if arg2_43 then
			arg0_43.camLockStatus[arg1_43] = false
		end
	end
end

function var0_0.GetStaticRtt(arg0_44, arg1_44)
	local var0_44 = arg0_44.cameraBlurs[arg1_44][var0_0.OptimizedBlur]

	return (ReflectionHelp.RefGetField(typeof("UnityStandardAssets.ImageEffects.BlurOptimized"), "staticRtt", var0_44))
end

function var0_0.SetMainCamBlurTexture(arg0_45, arg1_45)
	local var0_45 = arg0_45.mainCamera:GetComponent(typeof(Camera))
	local var1_45 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width,
		Screen.height,
		0
	})

	var0_45.targetTexture = var1_45

	var0_45:Render()

	local var2_45 = var1_0.ShaderMgr.GetInstance():BlurTexture(var1_45)

	var0_45.targetTexture = nil

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1_45
	})

	arg1_45.uvRect = var0_45.rect
	arg1_45.texture = var2_45

	return var2_45
end

function var0_0.GetMainCamera(arg0_46)
	return arg0_46.mainCamera
end
