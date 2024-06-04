pg = pg or {}

local var0 = singletonClass("UIMgr")

pg.UIMgr = var0

local var1 = pg

var0._loadPanel = nil
var0.CameraUI = 1
var0.CameraLevel = 2
var0.CameraOverlay = 3
var0.OptimizedBlur = 1
var0.StaticBlur = 2
var0.PartialBlur = 3

function var0.Init(arg0, arg1)
	print("initializing ui manager...")

	arg0.mainCamera = GameObject.Find("MainCamera")
	arg0.mainCameraComp = arg0.mainCamera:GetComponent("Camera")
	arg0.uiCamera = tf(GameObject.Find("UICamera"))
	arg0.uiCameraComp = arg0.uiCamera:GetComponent("Camera")
	arg0.uiCameraComp.allowMSAA = false
	arg0.levelCamera = tf(GameObject.Find("LevelCamera"))
	arg0.levelCameraComp = arg0.levelCamera:GetComponent("Camera")
	arg0.levelCameraComp.allowMSAA = false
	arg0.overlayCamera = tf(GameObject.Find("OverlayCamera"))
	arg0.overlayCameraComp = arg0.overlayCamera:GetComponent("Camera")
	arg0.overlayCameraComp.allowMSAA = false
	arg0.UIMain = arg0.uiCamera:Find("Canvas/UIMain")
	arg0.LevelMain = arg0.levelCamera:Find("Canvas/UIMain")
	arg0.OverlayMain = arg0.overlayCamera:Find("Overlay/UIMain")
	arg0.OverlayToast = arg0.overlayCamera:Find("Overlay/UIOverlay")
	arg0.OverlayEffect = arg0.overlayCamera:Find("Overlay/UIEffect")
	arg0._normalUIMain = nil
	arg0._cameraBlurPartial = arg0.uiCamera:GetComponent("UIPartialBlur")
	arg0._levelCameraPartial = arg0.levelCamera:GetComponent("UIPartialBlur")

	ReflectionHelp.RefCallMethod(typeof("UIPartialBlur"), "Cleanup", arg0._levelCameraPartial)

	arg0._levelCameraPartial.blurCam = arg0.levelCameraComp
	arg0.cameraBlurs = {
		[var0.CameraUI] = {
			arg0.uiCamera:GetComponent("BlurOptimized"),
			arg0.uiCamera:GetComponent("UIStaticBlur"),
			arg0._cameraBlurPartial
		},
		[var0.CameraLevel] = {
			arg0.levelCamera:GetComponent("BlurOptimized"),
			arg0.levelCamera:GetComponent("UIStaticBlur"),
			arg0._levelCameraPartial
		},
		[var0.CameraOverlay] = {
			arg0.overlayCamera:GetComponent("BlurOptimized"),
			(arg0.overlayCamera:GetComponent("UIStaticBlur"))
		}
	}
	arg0.camLockStatus = {
		[var0.CameraUI] = false,
		[var0.CameraLevel] = false,
		[var0.CameraOverlay] = false
	}

	local function var0(arg0)
		if arg0 == nil then
			return
		end

		arg0.downsample = 2
		arg0.blurSize = 4
		arg0.blurIterations = 2
	end

	local function var1(arg0)
		if arg0 == nil then
			return
		end

		arg0.downsample = 2
		arg0.blurSize = 1.5
		arg0.blurIteration = 4
	end

	local function var2(arg0)
		if arg0 == nil then
			return
		end

		arg0.downsample = 2
		arg0.blurSize = 4
		arg0.blurIterations = 1
	end

	local function var3(arg0)
		if arg0 == nil then
			return
		end

		arg0.downsample = 2
		arg0.blurSize = 1.5
		arg0.blurIteration = 1
	end

	local var4 = DevicePerformanceUtil.GetDeviceLevel()

	for iter0, iter1 in ipairs(arg0.cameraBlurs) do
		if var4 == DevicePerformanceLevel.Low then
			var2(iter1[var0.OptimizedBlur])
			var3(iter1[var0.PartialBlur])
		else
			var0(iter1[var0.OptimizedBlur])
			var1(iter1[var0.PartialBlur])
		end
	end

	arg0.defaultMaterial = Material.New(Shader.Find("UI/Default"))
	arg0.partialBlurMaterial = Material.New(Shader.Find("UI/PartialBlur"))
	arg0._debugPanel = DebugPanel.New()

	setActive(arg0.uiCamera, false)
	seriesAsync({
		function(arg0)
			buildTempAB("ui/commonui_atlas", function(arg0)
				arg0._common_ui_bundle = arg0

				arg0()
			end)
		end,
		function(arg0)
			buildTempAB("skinicon", function(arg0)
				arg0._skinicon_bundle = arg0

				arg0()
			end)
		end,
		function(arg0)
			buildTempAB("attricon", function(arg0)
				arg0._attricon_bundle = arg0

				arg0()
			end)
		end,
		function(arg0)
			setActive(arg0.uiCamera, true)

			arg0._loadPanel = LoadingPanel.New(arg0)
		end,
		function(arg0)
			PoolMgr.GetInstance():GetUI("ClickEffect", true, function(arg0)
				setParent(arg0, arg0.OverlayEffect)

				local var0 = PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0

				SetActive(arg0.OverlayEffect, var0)
				arg0()
			end)
		end
	}, arg1)
end

function var0.Loading(arg0, arg1)
	arg0._loadPanel:appendInfo(arg1)
end

function var0.LoadingOn(arg0, arg1)
	arg0._loadPanel:on(arg1)
end

function var0.displayLoadingBG(arg0, arg1)
	arg0._loadPanel:displayBG(arg1)
end

function var0.LoadingOff(arg0)
	arg0._loadPanel:off()
end

function var0.OnLoading(arg0)
	return arg0._loadPanel:onLoading()
end

function var0.LoadingRetainCount(arg0)
	return arg0._loadPanel:getRetainCount()
end

function var0.AddDebugButton(arg0, arg1, arg2)
	arg0._debugPanel:addCustomBtn(arg1, arg2)
end

function var0.AddWorldTestButton(arg0, arg1, arg2)
	arg0._debugPanel:addCustomBtn(arg1, function()
		arg0._debugPanel:hidePanel()
		arg2()
	end)
end

var0._maxbianjie = 50
var0._maxbianjieInv = 0.02
var0._maxbianjieSqr = 2500
var0._followRange = 0
var0._stick = nil
var0._areaImg = nil
var0._stickImg = nil
var0._stickCom = nil
var0._normalColor = Color(255, 255, 255, 1)
var0._darkColor = Color(255, 255, 255, 0.5)
var0._firstPos = Vector3.zero

function var0.AttachStickOb(arg0, arg1)
	arg0.hrz = 0
	arg0.vtc = 0
	arg0.fingerId = -1

	local var0 = arg1:Find("Area")

	arg0._stick = var0:Find("Stick")
	arg0._areaImg = var0:GetComponent(typeof(Image))
	arg0._stickImg = arg0._stick:GetComponent(typeof(Image))
	arg0._stickCom = arg1:GetComponent(typeof(StickController))
	arg0._stickCom.StickBorderRate = 1

	arg0._stickCom:SetStickFunc(function(arg0, arg1)
		arg0:UpdateStick(arg0, arg1)
	end)

	arg0._firstPos = var0.localPosition
	arg0.vtc = 0

	arg0:SetActive(true)
end

function var0.SetActive(arg0, arg1)
	arg0._stickActive = arg1
end

function var0.Marching(arg0)
	local var0 = ys.Battle.BattleConfig

	LeanTween.value(go(arg0._stick), 0, 0.625, 1.8):setOnUpdate(System.Action_float(function(arg0)
		arg0.hrz = var0.START_SPEED_CONST_B * (arg0 - var0.START_SPEED_CONST_A) * (arg0 - var0.START_SPEED_CONST_A)
	end)):setOnComplete(System.Action(function()
		arg0.hrz = 0
	end))
end

function var0.UpdateStick(arg0, arg1, arg2)
	if not arg0._stickActive then
		return
	end

	if arg2 == -2 then
		arg0:SetOutput(arg1.x, arg1.y, -2)

		return
	elseif arg2 == -1 then
		arg0:SetOutput(0, 0, arg2)

		return
	end

	local var0 = arg1

	var0.z = 0

	local var1 = var0:SqrMagnitude()

	if var1 > arg0._maxbianjieSqr then
		var0 = var0 / math.sqrt(var1)

		local var2 = var0 * arg0._maxbianjie

		if arg1 - var2 ~= arg0._firstPos then
			local var3 = arg0._firstPos
		end

		arg0._stick.localPosition = var2

		arg0:SetOutput(var0.x, var0.y, arg2)
	else
		arg0._stick.localPosition = arg1

		arg0:SetOutput(var0.x * arg0._maxbianjieInv, var0.y * arg0._maxbianjieInv, arg2)
	end
end

function var0.SetOutput(arg0, arg1, arg2, arg3)
	arg0.hrz = arg1
	arg0.vtc = arg2

	local var0 = (arg3 >= 0 and 1 or 0) - (arg0.fingerId >= 0 and 1 or 0)

	if var0 ~= 0 and arg0._areaImg and arg0._stickImg then
		arg0._areaImg.color = var0 > 0 and var0._normalColor or var0._darkColor
		arg0._stickImg.color = var0 > 0 and var0._normalColor or var0._darkColor
	end

	if arg3 < 0 then
		arg0._stick.localPosition = Vector3.zero
	end

	arg0.fingerId = arg3
end

function var0.ClearStick(arg0)
	arg0._stick.localPosition = Vector3.zero

	arg0._stickCom:ClearStickFunc()

	arg0._stick = nil
	arg0._areaImg = nil
	arg0._stickImg = nil
	arg0._stickCom = nil
end

local var2 = {}
local var3 = false

function var0.OverlayPanel(arg0, arg1, arg2)
	arg2 = arg2 or {}
	arg2.globalBlur = false

	var1.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1, arg2)
end

function var0.UnOverlayPanel(arg0, arg1, arg2)
	var1.LayerWeightMgr.GetInstance():DelFromOverlay(arg1, arg2 or arg0.UIMain)
end

function var0.BlurPanel(arg0, arg1, arg2, arg3)
	arg3 = arg3 or {}
	arg3.globalBlur = true
	arg3.staticBlur = arg2

	var1.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1, arg3)
end

function var0.UnblurPanel(arg0, arg1, arg2)
	var1.LayerWeightMgr.GetInstance():DelFromOverlay(arg1, arg2 or arg0.UIMain)
end

function var0.OverlayPanelPB(arg0, arg1, arg2)
	arg2 = arg2 or {}
	arg2.globalBlur = false

	var1.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg1, arg2)
end

function var0.PartialBlurTfs(arg0, arg1)
	var3 = true
	var2 = arg1

	arg0:UpdatePBEnable(true)
end

function var0.ShutdownPartialBlur(arg0)
	var3 = false
	var2 = {}

	arg0:UpdatePBEnable(false)
end

function var0.RevertPBMaterial(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1:GetComponent(typeof(Image))

		assert(var0, "mask should be an image.")

		var0.material = arg0.defaultMaterial
	end
end

function var0.UpdatePBEnable(arg0, arg1)
	if arg1 then
		if var2 ~= nil then
			for iter0, iter1 in ipairs(var2) do
				local var0 = iter1:GetComponent(typeof(Image))

				assert(var0, "mask should be an image.")

				var0.material = arg1 and arg0.partialBlurMaterial or nil
			end
		end

		if arg0.levelCameraComp.enabled then
			arg0.cameraBlurs[var0.CameraLevel][var0.PartialBlur].enabled = true
			arg0.cameraBlurs[var0.CameraUI][var0.PartialBlur].enabled = false
		else
			arg0.cameraBlurs[var0.CameraLevel][var0.PartialBlur].enabled = false
			arg0.cameraBlurs[var0.CameraUI][var0.PartialBlur].enabled = true
		end
	else
		for iter2, iter3 in ipairs(arg0.cameraBlurs) do
			if iter3[var0.PartialBlur] then
				iter3[var0.PartialBlur].enabled = false
			end
		end
	end
end

function var0.BlurCamera(arg0, arg1, arg2, arg3)
	if not arg0.camLockStatus[arg1] or arg3 then
		local var0 = arg0.cameraBlurs[arg1][var0.OptimizedBlur]
		local var1 = arg0.cameraBlurs[arg1][var0.StaticBlur]

		if arg2 then
			var0.enabled = true
			var0.staticBlur = true
			var1.enabled = false
		else
			var0.enabled = true
			var0.staticBlur = false
			var1.enabled = false
		end

		if arg3 then
			arg0.camLockStatus[arg1] = true
		end
	end
end

function var0.UnblurCamera(arg0, arg1, arg2)
	if not arg0.camLockStatus[arg1] or arg2 then
		local var0 = arg0.cameraBlurs[arg1][var0.OptimizedBlur]

		arg0.cameraBlurs[arg1][var0.StaticBlur].enabled = false
		var0.enabled = false

		if arg2 then
			arg0.camLockStatus[arg1] = false
		end
	end
end

function var0.GetStaticRtt(arg0, arg1)
	local var0 = arg0.cameraBlurs[arg1][var0.OptimizedBlur]

	return (ReflectionHelp.RefGetField(typeof("UnityStandardAssets.ImageEffects.BlurOptimized"), "staticRtt", var0))
end

function var0.SetMainCamBlurTexture(arg0, arg1)
	local var0 = arg0.mainCamera:GetComponent(typeof(Camera))
	local var1 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width,
		Screen.height,
		0
	})

	var0.targetTexture = var1

	var0:Render()

	local var2 = var1.ShaderMgr.GetInstance():BlurTexture(var1)

	var0.targetTexture = nil

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1
	})

	arg1.uvRect = var0.rect
	arg1.texture = var2

	return var2
end

function var0.GetMainCamera(arg0)
	return arg0.mainCamera
end

function var0.InitBgmCfg(arg0, arg1)
	arg0.isDefaultBGM = false

	if OPEN_SPECIAL_IP_BGM and PLATFORM_CODE == PLATFORM_US then
		if IsUnityEditor then
			if arg1 then
				arg1()
			end

			return
		end

		local var0 = {
			"Malaysia",
			"Indonesia"
		}
		local var1 = "https://pro.ip-api.com/json/?key=TShzQlq7O9KuthI"
		local var2 = ""

		local function var3(arg0)
			local var0 = "\"country\":\""
			local var1 = "\","
			local var2, var3 = string.find(arg0, var0)

			if var3 then
				arg0 = string.sub(arg0, var3 + 1)
			end

			local var4 = string.find(arg0, var1)

			if var4 then
				arg0 = string.sub(arg0, 1, var4 - 1)
			end

			return arg0
		end

		local function var4(arg0)
			local var0 = false

			for iter0, iter1 in ipairs(var0) do
				if iter1 == arg0 then
					var0 = true
				end
			end

			return var0
		end

		VersionMgr.Inst:WebRequest(var1, function(arg0, arg1)
			local var0 = var3(arg1)

			originalPrint("content: " .. arg1)
			originalPrint("country is: " .. var0)

			arg0.isDefaultBGM = var4(var0)

			originalPrint("IP limit: " .. tostring(arg0.isDefaultBGM))

			if arg1 then
				arg1()
			end
		end)
	elseif arg1 then
		arg1()
	end
end

function var0.IsDefaultBGM(arg0)
	return arg0.isDefaultBGM
end
