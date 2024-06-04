local var0 = class("Dorm3dPhotoLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dPhotoUI"
end

var0.PANEL = {
	CAMERA = 2,
	LIGHTING = 3,
	ACTION = 1
}

function var0.init(arg0)
	arg0.topPanel = arg0._tf:Find("Top")
	arg0.leftPanel = arg0._tf:Find("Left")
	arg0.btnAction = arg0._tf:Find("Left/Action")
	arg0.btnCamera = arg0._tf:Find("Left/Camera")
	arg0.btnLighting = arg0._tf:Find("Left/Lighting")
	arg0.sliderZoom = arg0._tf:Find("Left/Zoom/Slider")
	arg0.panelAction = arg0._tf:Find("Left/ActionSelect")

	setActive(arg0.panelAction, false)
	setActive(arg0.panelAction:Find("Mask"), false)

	arg0.panelCamera = arg0._tf:Find("Left/CameraSettings")

	setActive(arg0.panelCamera, false)

	arg0.panelLightning = arg0._tf:Find("Left/LightningSettings")

	setActive(arg0.panelLightning, false)

	arg0.rightPanel = arg0._tf:Find("Right")
	arg0.scrollZones = arg0._tf:Find("Right/List/Scroll")
	arg0.listZones = arg0.scrollZones:Find("Content")
	arg0.btnHideUI = arg0._tf:Find("Right/HideUI")
	arg0.btnReset = arg0._tf:Find("Right/Reset")
	arg0.btnFreeze = arg0._tf:Find("Right/Freeze")
	arg0.btnAnimSpeed = arg0._tf:Find("Right/AnimSpeed")
	arg0.listAnimSpeed = arg0.btnAnimSpeed:Find("Bar")

	setActive(arg0.listAnimSpeed, false)

	arg0.textAnimSpeed = arg0.btnAnimSpeed:Find("Speed")
	arg0.btnAR = arg0._tf:Find("Right/AR")
	arg0.mask = arg0._tf:Find("Mask")

	setActive(arg0.mask, false)

	arg0.btnFilm = arg0._tf:Find("RightTop/Film")
	arg0.btnShoot = arg0._tf:Find("RightTop/Shot")
	arg0.ysScreenShoter = arg0._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenShoter))
	arg0.ysScreenRecorder = arg0._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenRecorder))
end

function var0.SetSceneRoot(arg0, arg1)
	arg0.scene = arg1
end

function var0.SetApartment(arg0, arg1)
	arg0.apartment = arg1:clone()
end

function var0.onBackPressed(arg0)
	if arg0.recordState then
		triggerButton(arg0.btnFilm)

		return
	end

	arg0:closeView()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	setSlider(arg0.sliderZoom, 0, 1, 0)
	onSlider(arg0, arg0.sliderZoom, function(arg0)
		local var0 = (1 - arg0) * 0.5 + 0.5

		arg0.scene:SetPinchValue(var0)
	end)

	arg0.hideUI = false

	onButton(arg0, arg0.btnHideUI, function()
		if arg0.hideUI then
			return
		end

		setActive(arg0.mask, true)
		setActive(arg0.topPanel, false)
		setActive(arg0.leftPanel, false)
		setActive(arg0.rightPanel, false)

		arg0.hideUI = true
	end, SFX_PANEL)
	onButton(arg0, arg0.mask, function()
		if not arg0.hideUI then
			return
		end

		setActive(arg0.topPanel, true)
		setActive(arg0.leftPanel, true)
		setActive(arg0.rightPanel, true)
		setActive(arg0.mask, false)

		arg0.hideUI = false
	end)
	onButton(arg0, arg0.btnReset, function()
		return
	end, SFX_PANEL)
	onButton(arg0, arg0.btnAR, function()
		return
	end, SFX_PANEL)

	arg0.recordState = nil

	onButton(arg0, arg0.btnFilm, function()
		arg0.recordState = not arg0.recordState

		local function var0(arg0)
			setActive(arg0.topPanel, arg0)
			setActive(arg0.leftPanel, arg0)
			setActive(arg0.rightPanel, arg0)
		end

		if arg0.recordState then
			var0(false)

			local function var1(arg0)
				if arg0 ~= -1 then
					var0(true)

					arg0.recordState = nil
				end
			end

			local function var2(arg0)
				warning("开始录屏结果：" .. arg0)
			end

			seriesAsync({
				function(arg0)
					arg0()
				end,
				function(arg0)
					var0.SetMute(true)
					arg0.ysScreenRecorder:BeforeStart()
					arg0.ysScreenRecorder:StartRecord(var2, var1)

					if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
						print("start recording : play sound")
						NotificationMgr.Inst:PlayStartRecordSound()
					end
				end
			})
		else
			local function var3(arg0)
				warning("结束录屏结果：" .. arg0)
			end

			seriesAsync({
				function(arg0)
					var0(true)
					arg0.ysScreenRecorder:StopRecord(var3)

					if PLATFORM == PLATFORM_ANDROID then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("word_save_video"),
							onNo = function()
								arg0.ysScreenRecorder:DiscardVideo()
							end,
							onYes = function()
								local var0 = arg0.ysScreenRecorder:GetVideoFilePath()

								MediaSaver.SaveVideoWithPath(var0)
							end
						})
					end

					var0.SetMute(false)
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.btnShoot, function()
		local function var0(arg0)
			setActive(arg0.topPanel, arg0)
			setActive(arg0.leftPanel, arg0)
			setActive(arg0.rightPanel, arg0)
			setActive(arg0._tf:Find("RightTop"), arg0)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0)
			end
		end

		var0(false)

		local function var1(arg0)
			warning("截图结果：" .. tostring(arg0))
			var0(true)
		end

		local function var2(arg0)
			local var0 = UnityEngine.Texture2D.New(Screen.width, Screen.height)

			Tex2DExtension.LoadImage(var0, arg0)
			arg0:emit(SnapshotScene.SHARE_PANEL, var0, arg0)

			if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
				print("start photo : play sound")
				NotificationMgr.Inst:PlayShutterSound()
			end
		end

		arg0.ysScreenShoter:TakeScreenShotData(var1, var2)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnAnimSpeed, function()
		setActive(arg0.listAnimSpeed, not isActive(arg0.listAnimSpeed))
	end, SFX_PANEL)

	arg0.activePanel = nil

	local var0 = {
		{
			btn = arg0.btnAction,
			panel = arg0.panelAction,
			On = function()
				arg0:UpdateActionPanel()
				setActive(arg0.panelAction, true)
			end,
			Off = function()
				setActive(arg0.panelAction, false)
			end
		},
		{
			btn = arg0.btnCamera,
			panel = arg0.panelCamera,
			On = function()
				arg0:UpdateCameraPanel()
				setActive(arg0.panelCamera, true)
			end,
			Off = function()
				setActive(arg0.panelCamera, false)
			end
		},
		{
			btn = arg0.btnLighting,
			panel = arg0.panelLightning,
			On = function()
				arg0:UpdateLightingPanel()
				setActive(arg0.panelLightning, true)
			end,
			Off = function()
				setActive(arg0.panelLightning, false)
			end
		}
	}

	table.Ipairs(var0, function(arg0, arg1)
		onButton(arg0, arg1.btn, function()
			if arg0 == arg0.activePanel then
				arg0.activePanel = nil

				arg1.Off()
			else
				table.Ipairs(var0, function(arg0, arg1)
					if arg0 == arg0 then
						return
					end

					arg1.Off()
				end)

				arg0.activePanel = arg0

				arg1.On()
			end
		end, SFX_PANEL)
	end)

	arg0.zoneIndex = 1

	arg0:InitData()
	arg0:FirstEnterZone()

	local var1 = arg0.apartment:GetCameraZones()

	UIItemList.StaticAlign(arg0.listZones, arg0.listZones:GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var1[arg1]

		setText(arg2:Find("Name"), var0:GetName())
		onButton(arg0, arg2, function()
			if arg0.zoneIndex == arg1 then
				return
			end

			local var0 = arg0.zoneIndex

			setActive(arg2:Find("Selected"), true)
			setActive(arg0.listZones:GetChild(var0 - 1):Find("Selected"), false)

			arg0.zoneIndex = arg1

			arg0:RefreshData()
			arg0:SwitchZone()
		end, SFX_PANEL)
	end)
	setActive(arg0.listZones:GetChild(arg0.zoneIndex - 1):Find("Selected"), true)
end

function var0.InitData(arg0)
	arg0.cameraSettings = Clone(arg0.scene:GetCameraSettings())
	arg0.settingHideCharacter = false
	arg0.settingFaceCamera = true
	arg0.settingLightingColorIndex = nil
	arg0.settingLightingStrength = 1
	arg0.settingLightingAlpha = 1
	arg0.settingFilterIndex = nil
	arg0.settingFilterStrength = 1

	arg0:RefreshData()
end

function var0.RefreshData(arg0)
	local var0 = arg0.apartment:GetCameraZones()[arg0.zoneIndex]

	arg0.animID = var0:GetRegularAnims()[1]:GetConfigID()

	local function var1(arg0, arg1)
		arg0.min = arg1[1]
		arg0.max = arg1[2]
		arg0.value = math.clamp(arg0.value, arg1[1], arg1[2])
	end

	var1(arg0.cameraSettings.depthOfField.focusDistance, var0:GetFocusDistanceRange())
	var1(arg0.cameraSettings.depthOfField.blurRadius, var0:GetDepthOfFieldBlurRange())
	var1(arg0.cameraSettings.postExposure, var0:GetExposureRange())
	var1(arg0.cameraSettings.contrast, var0:GetContrastRange())
	var1(arg0.cameraSettings.saturate, var0:GetSaturationRange())

	arg0.animSpeeds = var0:GetAnimSpeeds()
	arg0.animSpeed = 1
end

function var0.FirstEnterZone(arg0)
	local var0 = arg0.apartment:GetCameraZones()[arg0.zoneIndex]

	arg0.scene:EnterPhotoMode(var0)
	arg0:UpdateActionPanel()
	arg0:UpdateCameraPanel()
	arg0:UpdateLightingPanel()
	arg0:UpdateAnimSpeedPanel()
end

function var0.SwitchZone(arg0)
	local var0 = arg0.apartment:GetCameraZones()[arg0.zoneIndex]

	arg0.scene:SwitchCameraZone(var0)
	arg0:UpdateActionPanel()
	arg0:UpdateCameraPanel()
	arg0:UpdateLightingPanel()
	arg0:UpdateAnimSpeedPanel()
end

local var1 = 0.2

function var0.UpdateActionPanel(arg0)
	if arg0.activePanel ~= var0.PANEL.ACTION then
		return
	end

	local var0 = arg0.apartment:GetCameraZones()[arg0.zoneIndex]
	local var1 = var0:GetRegularAnims()

	arg0.lastSelectedAnimBG = nil

	local function var2(arg0, arg1)
		local var0 = arg0:GetConfigID()

		if arg0.animID == var0 then
			return
		end

		if arg0.lastSelectedAnimBG then
			setActive(arg0.lastSelectedAnimBG, false)
		end

		local var1 = arg0:GetAnimPlayList(var0)
		local var2 = Dorm3dCameraAnim.New({
			configId = arg0.animID
		}):GetFinishAnimID()

		arg0.animID = var0
		arg0.lastSelectedAnimBG = arg1:Find("Selected")

		arg0:BlockActionPanel(true)

		local var3 = (table.indexof(var1, _.detect(var1, function(arg0)
			return arg0:GetConfigID() == var2
		end)) or 0) + 1
		local var4 = _.rest(var1, var3)
		local var5 = arg1:Find("Fill"):GetComponent(typeof(Image))

		setActive(arg1:Find("Fill"), true)

		local function var6()
			setActive(arg1:Find("Selected"), true)
			setActive(arg1:Find("Fill"), false)
			arg0:BlockActionPanel(false)

			arg0.animPlaying = nil
		end

		if #var4 == 0 then
			var6()

			return
		end

		local var7 = _.reduce(var4, 0, function(arg0, arg1)
			return arg0 + math.max(var1, arg1:GetAnimTime())
		end)

		arg0.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4,
			totalTime = var7,
			imgFill = var5,
			startStamp = Time.time
		}
		arg0.timerAnim = FrameTimer.New(function()
			local var0 = arg0.animInfo
			local var1 = var0.animPlayList[var0.index]
			local var2 = math.max(var1, var1:GetAnimTime())
			local var3 = var0.startStamp
			local var4 = Time.time
			local var5 = math.min(1, var0.ratio + (var4 - var3) * arg0.animSpeed / var2)
			local var6 = var0.passedTime + var2 * var5

			var5.fillAmount = var6 / var7

			if var5 < 1 then
				return
			end

			var0.index = var0.index + 1
			var0.ratio = 0
			var0.passedTime = var0.passedTime + var2
			var0.startStamp = var4

			warning(var0.startStamp)

			if var0.index > #var0.animPlayList then
				var6()
				arg0.timerAnim:Stop()

				arg0.timerAnim = nil
				arg0.animInfo = nil

				return
			end

			local var7 = var0.animPlayList[var0.index]

			arg0.scene:PlaySingleAction(var7:GetStateName())
		end, 1, -1)

		local var8 = arg0.animInfo.animPlayList[1]

		if var3 == 1 then
			arg0.scene:SwitchAnim(var8:GetStateName())
			onNextTick(function()
				arg0.scene:ResetCharPosByZone(var0)
			end)
		else
			arg0.scene:PlaySingleAction(var8:GetStateName())
		end

		arg0.timerAnim:Start()
	end

	local var3 = arg0.panelAction:Find("Regular/List")

	UIItemList.StaticAlign(var3, var3:GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var1[arg1]

		setText(arg2:Find("Name"), var0:GetName())
		setActive(arg2:Find("Fill"), false)
		setActive(arg2:Find("Selected"), false)
		onButton(arg0, arg2, function()
			var2(var0, arg2)
		end)
	end)

	local var4, var5 = table.Find(var1, function(arg0, arg1)
		return arg1:GetConfigID() == arg0.animID
	end)

	arg0.lastSelectedAnimBG = var3:GetChild(var5 - 1):Find("Selected")

	setActive(arg0.lastSelectedAnimBG, true)

	local var6 = var0:GetSpecialAnims()
	local var7 = arg0.panelAction:Find("Special/Furnitures")

	arg0.lastFurniture = nil
	arg0.lastSelectedFurnitureBG = nil

	local var8 = arg0.panelAction:Find("Special/List")

	setActive(var8, false)

	local var9 = arg0.panelAction:Find("Special/Arrow")

	setActive(var9, false)

	local function var10(arg0, arg1)
		if arg0.lastSelectedFurnitureBG then
			setActive(arg0.lastSelectedFurnitureBG, false)
		end

		arg0.lastFurniture = arg0
		arg0.lastSelectedFurnitureBG = arg1:Find("Selected")

		setActive(arg0.lastSelectedFurnitureBG, true)
		setActive(var8, true)
		setActive(var9, true)

		var9.position = arg1.position
		var9.anchoredPosition = var9.anchoredPosition + Vector2(0, -60)

		local var0 = arg0.anims

		UIItemList.StaticAlign(var8, var8:GetChild(0), #var0, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			arg1 = arg1 + 1

			local var0 = var0[arg1]

			setText(arg2:Find("Name"), var0:GetName())
			setActive(arg2:Find("Fill"), false)
			setActive(arg2:Find("Selected"), false)

			if var0:GetConfigID() == arg0.animID then
				arg0.lastSelectedAnimBG = arg2:Find("Selected")

				setActive(arg0.lastSelectedAnimBG, true)
			end

			onButton(arg0, arg2, function()
				arg0.apartment:ReplaceFurniture(arg0.slotId, arg0.furnitureId)
				arg0.scene:RefreshSlots(arg0.apartment)
				var2(var0, arg2)
			end)
		end)
	end

	setActive(arg0.panelAction:Find("Special"), #var6 > 0)
	UIItemList.StaticAlign(var7, var7:GetChild(0), #var6, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		local var0 = var6[arg1]
		local var1 = Dorm3dFurniture.New({
			configId = var0.furnitureId
		})
		local var2 = tobool(_.detect(arg0.apartment:GetFurnitures(), function(arg0)
			return arg0:GetConfigID() == var0.furnitureId
		end))

		updateDrop(arg2:Find("Icon"), {
			type = DROP_TYPE_DORM3D_FURNITURE,
			id = var1:GetConfigID()
		})
		setText(arg2:Find("Name"), var1:GetName())
		setActive(arg2:Find("Lock"), not var2)
		onButton(arg0, arg2, function()
			if not var2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("furniture not unlock"))

				return
			end

			var10(var0, arg2)
		end)
	end)
end

function var0.BlockActionPanel(arg0, arg1)
	setActive(arg0.panelAction:Find("Mask"), arg1)
end

function var0.GetAnimPlayList(arg0, arg1)
	local var0 = arg1
	local var1 = {}

	while true do
		local var2 = Dorm3dCameraAnim.New({
			configId = var0
		})

		if not var2 then
			return var1
		end

		table.insert(var1, 1, var2)

		var0 = var2:GetPreAnimID()

		if var0 == 0 then
			return var1
		end
	end
end

function var0.UpdateCameraPanel(arg0)
	if arg0.activePanel ~= var0.PANEL.CAMERA then
		return
	end

	local var0 = arg0.apartment:GetCameraZones()[arg0.zoneIndex]

	;(function()
		local var0 = arg0.panelCamera:Find("DepthOfField/Toggle")

		triggerToggleWithoutNotify(var0, arg0.cameraSettings.depthOfField.enabled)
		onToggle(arg0, var0, function(arg0)
			arg0.cameraSettings.depthOfField.enabled = arg0

			arg0:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0 = arg0.cameraSettings.depthOfField.focusDistance
		local var1 = arg0.panelCamera:Find("DepthOfField/List/FocusDistance/Slider")

		setSlider(var1, var0.min, var0.max, var0.value)
		onSlider(arg0, var1, function(arg0)
			var0.value = arg0

			arg0:RefreshCamera()
		end)
	end)()
	;(function()
		local var0 = arg0.cameraSettings.depthOfField.blurRadius
		local var1 = arg0.panelCamera:Find("DepthOfField/List/BlurRadius/Slider")

		setSlider(var1, var0.min, var0.max, var0.value)
		onSlider(arg0, var1, function(arg0)
			var0.value = arg0

			arg0:RefreshCamera()
		end)
	end)()
	;(function()
		local var0 = arg0.cameraSettings.postExposure
		local var1 = arg0.panelCamera:Find("PostExposure/Slider")

		setSlider(var1, var0.min, var0.max, var0.value)
		onSlider(arg0, var1, function(arg0)
			var0.value = arg0

			arg0:RefreshCamera()
		end)
	end)()
	;(function()
		local var0 = arg0.cameraSettings.contrast
		local var1 = arg0.panelCamera:Find("Contrast/Slider")

		setSlider(var1, var0.min, var0.max, var0.value)
		onSlider(arg0, var1, function(arg0)
			var0.value = arg0

			arg0:RefreshCamera()
		end)
	end)()
	;(function()
		local var0 = arg0.cameraSettings.saturate
		local var1 = arg0.panelCamera:Find("Saturation/Slider")

		setSlider(var1, var0.min, var0.max, var0.value)
		onSlider(arg0, var1, function(arg0)
			var0.value = arg0

			arg0:RefreshCamera()
		end)
	end)()
	;(function()
		local var0 = arg0.panelCamera:Find("FaceCamera/Toggle")

		triggerToggleWithoutNotify(var0, arg0.settingFaceCamera)
		setActive(var0:Find("Selected"), arg0.settingFaceCamera)
		onToggle(arg0, var0, function(arg0)
			arg0.settingFaceCamera = arg0

			arg0.scene:EnableHeadIK(arg0)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0 = arg0.panelCamera:Find("HideCharacter/Toggle")

		triggerToggleWithoutNotify(var0, arg0.settingHideCharacter)
		setActive(var0:Find("Selected"), arg0.settingHideCharacter)
		onToggle(arg0, var0, function(arg0)
			arg0.settingHideCharacter = arg0

			if arg0 then
				arg0.scene:SwitchLadyInterestInPhotoMode(false)
				arg0.scene:HideCharacter()
			else
				arg0.scene:SwitchLadyInterestInPhotoMode(true)
				arg0.scene:RevertCharacter()
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0.RefreshCamera(arg0)
	arg0.scene:SettingCamera(arg0.cameraSettings)
end

function var0.UpdateAnimSpeedPanel(arg0)
	local function var0()
		if not arg0.timerAnim then
			return
		end

		local var0 = arg0.animInfo
		local var1 = var0.animPlayList[var0.index]
		local var2 = math.max(var1, var1:GetAnimTime())
		local var3 = var0.startStamp
		local var4 = Time.time

		var0.ratio = math.min(1, var0.ratio + (var4 - var3) * arg0.animSpeed / var2)
		var0.startStamp = var4
	end

	local var1 = arg0.animSpeeds

	UIItemList.StaticAlign(arg0.listAnimSpeed, arg0.listAnimSpeed:GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var1[arg1]

		setText(arg2:Find("Text"), var0)
		onButton(arg0, arg2, function()
			if arg0.animSpeed == var0 then
				return
			end

			if arg0.animPlaying then
				return
			end

			var0()

			arg0.animSpeed = var0

			arg0.scene:SetCharacterAnimSpeed(var0)
			arg0:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0, arg0.btnFreeze, function()
		if arg0.animPlaying then
			return
		end

		local var0 = 0

		if arg0.animSpeed ~= 0 then
			arg0.lastAnimSpeed = arg0.animSpeed
		else
			var0 = arg0.lastAnimSpeed or 1
			arg0.lastAnimSpeed = nil
		end

		var0()

		arg0.animSpeed = var0

		arg0.scene:SetCharacterAnimSpeed(var0)
		arg0:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0.listAnimSpeed, arg0.listAnimSpeed:GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var1[arg1]

		setActive(arg2:Find("Selected"), arg0.animSpeed == var0)
	end)
	setActive(arg0.btnFreeze:Find("Selected"), arg0.animSpeed == 0)
	setText(arg0.textAnimSpeed, "X" .. arg0.animSpeed)
end

function var0.UpdateLightingPanel(arg0)
	if arg0.activePanel ~= var0.PANEL.LIGHTING then
		return
	end

	local var0 = arg0.apartment:GetCameraZones()[arg0.zoneIndex]
	local var1 = {
		{
			color = "FF0000",
			name = "红"
		},
		{
			color = "FFFF00",
			name = "黄"
		},
		{
			color = "0000FF",
			name = "蓝"
		},
		{
			color = "00FF00",
			name = "绿"
		},
		{
			color = "FF00FF",
			name = "紫"
		},
		{
			color = "FFFFFF",
			name = "白"
		}
	}

	local function var2()
		if not arg0.settingLightingColorIndex then
			arg0.scene:RevertCharacterLight()

			return
		end

		local var0 = var1[arg0.settingLightingColorIndex]

		arg0.scene:SetCharacterLight(Color.NewHex(var0.color), arg0.settingLightingAlpha, arg0.settingLightingStrength)
	end

	arg0.lastSelectedColorBG = nil

	UIItemList.StaticAlign(arg0.panelLightning:Find("Lighting/List"), arg0.panelLightning:Find("Lighting/List"):GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var1[arg1]

		setText(arg2:Find("Name"), var0.name)

		if arg0.settingLightingColorIndex == arg1 then
			arg0.lastSelectedColorBG = arg2:Find("Selected")

			setActive(arg0.lastSelectedColorBG, true)
		end

		onButton(arg0, arg2, function()
			if arg0.settingLightingColorIndex ~= arg1 then
				arg0.settingLightingColorIndex = arg1
			else
				arg0.settingLightingColorIndex = nil
			end

			var2()

			if arg0.lastSelectedColorBG then
				setActive(arg0.lastSelectedColorBG, false)
			end

			if arg0.settingLightingColorIndex == arg1 then
				arg0.lastSelectedColorBG = arg2:Find("Selected")

				setActive(arg0.lastSelectedColorBG, true)
			end
		end, SFX_PANEL)
	end)
	;(function()
		local var0 = arg0.panelLightning:Find("Lighting/Sliders/Strength/Slider")

		setSlider(var0, 0, 1, arg0.settingLightingStrength)
		onSlider(arg0, var0, function(arg0)
			arg0.settingLightingStrength = arg0

			var2()
		end)
	end)()
	;(function()
		local var0 = arg0.panelLightning:Find("Lighting/Sliders/Alpha/Slider")

		setSlider(var0, 0, 1, arg0.settingLightingAlpha)
		onSlider(arg0, var0, function(arg0)
			arg0.settingLightingAlpha = arg0

			var2()
		end)
	end)()

	local var3 = {
		{
			name = "泛紫",
			profile = "volume_purple"
		}
	}

	local function var4()
		if not arg0.settingFilterIndex then
			arg0.scene:RevertVolumeProfile()

			return
		end

		local var0 = var3[arg0.settingFilterIndex]

		arg0.scene:SetVolumeProfile(var0.profile, arg0.settingFilterStrength)
	end

	arg0.lastSelectedFilterBG = nil

	UIItemList.StaticAlign(arg0.panelLightning:Find("Filter/List"), arg0.panelLightning:Find("Filter/List"):GetChild(0), #var3, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var3[arg1]

		setText(arg2:Find("Name"), var0.name)

		if arg0.settingFilterIndex == arg1 then
			arg0.lastSelectedFilterBG = arg2:Find("Selected")

			setActive(arg0.lastSelectedFilterBG, true)
		end

		onButton(arg0, arg2, function()
			if arg0.settingFilterIndex ~= arg1 then
				arg0.settingFilterIndex = arg1
			else
				arg0.settingFilterIndex = nil
			end

			var4()

			if arg0.lastSelectedFilterBG then
				setActive(arg0.lastSelectedFilterBG, false)
			end

			if arg0.settingFilterIndex == arg1 then
				arg0.lastSelectedFilterBG = arg2:Find("Selected")

				setActive(arg0.lastSelectedFilterBG, true)
			end
		end, SFX_PANEL)
	end)
	;(function()
		local var0 = arg0.panelLightning:Find("Filter/Sliders/Strength/Slider")

		setSlider(var0, 0, 1, arg0.settingFilterStrength)
		onSlider(arg0, var0, function(arg0)
			arg0.settingFilterStrength = arg0

			var4()
		end)
	end)()
end

function var0.SetMute(arg0)
	if arg0 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0.willExit(arg0)
	if arg0.animSpeed ~= 1 then
		arg0.scene:SetCharacterAnimSpeed(1)
	end

	if arg0.settingHideCharacter then
		arg0.scene:SwitchLadyInterestInPhotoMode(true)
		arg0.scene:RevertCharacter()
	end

	if not arg0.settingFaceCamera then
		arg0.scene:EnableHeadIK(true)
	end

	arg0.scene:RevertCharacterLight()
	arg0.scene:RevertVolumeProfile()
	arg0.scene:RevertCameraSettings()
	arg0.scene:ExitPhotoMode()
end

return var0
