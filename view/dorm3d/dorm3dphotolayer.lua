local var0_0 = class("Dorm3dPhotoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dPhotoUI"
end

var0_0.PANEL = {
	CAMERA = 2,
	LIGHTING = 3,
	ACTION = 1
}

function var0_0.init(arg0_2)
	arg0_2.topPanel = arg0_2._tf:Find("Top")
	arg0_2.leftPanel = arg0_2._tf:Find("Left")
	arg0_2.btnAction = arg0_2._tf:Find("Left/Action")
	arg0_2.btnCamera = arg0_2._tf:Find("Left/Camera")
	arg0_2.btnLighting = arg0_2._tf:Find("Left/Lighting")
	arg0_2.sliderZoom = arg0_2._tf:Find("Left/Zoom/Slider")
	arg0_2.panelAction = arg0_2._tf:Find("Left/ActionSelect")

	setActive(arg0_2.panelAction, false)
	setActive(arg0_2.panelAction:Find("Mask"), false)

	arg0_2.panelCamera = arg0_2._tf:Find("Left/CameraSettings")

	setActive(arg0_2.panelCamera, false)

	arg0_2.panelLightning = arg0_2._tf:Find("Left/LightningSettings")

	setActive(arg0_2.panelLightning, false)

	arg0_2.rightPanel = arg0_2._tf:Find("Right")
	arg0_2.scrollZones = arg0_2._tf:Find("Right/List/Scroll")
	arg0_2.listZones = arg0_2.scrollZones:Find("Content")
	arg0_2.btnHideUI = arg0_2._tf:Find("Right/HideUI")
	arg0_2.btnReset = arg0_2._tf:Find("Right/Reset")
	arg0_2.btnFreeze = arg0_2._tf:Find("Right/Freeze")
	arg0_2.btnAnimSpeed = arg0_2._tf:Find("Right/AnimSpeed")
	arg0_2.listAnimSpeed = arg0_2.btnAnimSpeed:Find("Bar")

	setActive(arg0_2.listAnimSpeed, false)

	arg0_2.textAnimSpeed = arg0_2.btnAnimSpeed:Find("Speed")
	arg0_2.btnAR = arg0_2._tf:Find("Right/AR")
	arg0_2.mask = arg0_2._tf:Find("Mask")

	setActive(arg0_2.mask, false)

	arg0_2.btnFilm = arg0_2._tf:Find("RightTop/Film")
	arg0_2.btnShoot = arg0_2._tf:Find("RightTop/Shot")
	arg0_2.ysScreenShoter = arg0_2._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenShoter))
	arg0_2.ysScreenRecorder = arg0_2._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenRecorder))
end

function var0_0.SetSceneRoot(arg0_3, arg1_3)
	arg0_3.scene = arg1_3
end

function var0_0.SetApartment(arg0_4, arg1_4)
	arg0_4.apartment = arg1_4:clone()
end

function var0_0.onBackPressed(arg0_5)
	if arg0_5.recordState then
		triggerButton(arg0_5.btnFilm)

		return
	end

	arg0_5:closeView()
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("Top/Back"), function()
		arg0_6:onBackPressed()
	end, SFX_CANCEL)
	setSlider(arg0_6.sliderZoom, 0, 1, 0)
	onSlider(arg0_6, arg0_6.sliderZoom, function(arg0_8)
		local var0_8 = (1 - arg0_8) * 0.5 + 0.5

		arg0_6.scene:SetPinchValue(var0_8)
	end)

	arg0_6.hideUI = false

	onButton(arg0_6, arg0_6.btnHideUI, function()
		if arg0_6.hideUI then
			return
		end

		setActive(arg0_6.mask, true)
		setActive(arg0_6.topPanel, false)
		setActive(arg0_6.leftPanel, false)
		setActive(arg0_6.rightPanel, false)

		arg0_6.hideUI = true
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.mask, function()
		if not arg0_6.hideUI then
			return
		end

		setActive(arg0_6.topPanel, true)
		setActive(arg0_6.leftPanel, true)
		setActive(arg0_6.rightPanel, true)
		setActive(arg0_6.mask, false)

		arg0_6.hideUI = false
	end)
	onButton(arg0_6, arg0_6.btnReset, function()
		return
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnAR, function()
		return
	end, SFX_PANEL)

	arg0_6.recordState = nil

	onButton(arg0_6, arg0_6.btnFilm, function()
		arg0_6.recordState = not arg0_6.recordState

		local function var0_13(arg0_14)
			setActive(arg0_6.topPanel, arg0_14)
			setActive(arg0_6.leftPanel, arg0_14)
			setActive(arg0_6.rightPanel, arg0_14)
		end

		if arg0_6.recordState then
			var0_13(false)

			local function var1_13(arg0_15)
				if arg0_15 ~= -1 then
					var0_13(true)

					arg0_6.recordState = nil
				end
			end

			local function var2_13(arg0_16)
				warning("开始录屏结果：" .. arg0_16)
			end

			seriesAsync({
				function(arg0_17)
					arg0_17()
				end,
				function(arg0_18)
					var0_0.SetMute(true)
					arg0_6.ysScreenRecorder:BeforeStart()
					arg0_6.ysScreenRecorder:StartRecord(var2_13, var1_13)

					if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
						print("start recording : play sound")
						NotificationMgr.Inst:PlayStartRecordSound()
					end
				end
			})
		else
			local function var3_13(arg0_19)
				warning("结束录屏结果：" .. arg0_19)
			end

			seriesAsync({
				function(arg0_20)
					var0_13(true)
					arg0_6.ysScreenRecorder:StopRecord(var3_13)

					if PLATFORM == PLATFORM_ANDROID then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("word_save_video"),
							onNo = function()
								arg0_6.ysScreenRecorder:DiscardVideo()
							end,
							onYes = function()
								local var0_22 = arg0_6.ysScreenRecorder:GetVideoFilePath()

								MediaSaver.SaveVideoWithPath(var0_22)
							end
						})
					end

					var0_0.SetMute(false)
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnShoot, function()
		local function var0_23(arg0_24)
			setActive(arg0_6.topPanel, arg0_24)
			setActive(arg0_6.leftPanel, arg0_24)
			setActive(arg0_6.rightPanel, arg0_24)
			setActive(arg0_6._tf:Find("RightTop"), arg0_24)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_24)
			end
		end

		var0_23(false)

		local function var1_23(arg0_25)
			warning("截图结果：" .. tostring(arg0_25))
			var0_23(true)
		end

		local function var2_23(arg0_26)
			local var0_26 = UnityEngine.Texture2D.New(Screen.width, Screen.height)

			Tex2DExtension.LoadImage(var0_26, arg0_26)
			arg0_6:emit(SnapshotScene.SHARE_PANEL, var0_26, arg0_26)

			if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
				print("start photo : play sound")
				NotificationMgr.Inst:PlayShutterSound()
			end
		end

		arg0_6.ysScreenShoter:TakeScreenShotData(var1_23, var2_23)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnAnimSpeed, function()
		setActive(arg0_6.listAnimSpeed, not isActive(arg0_6.listAnimSpeed))
	end, SFX_PANEL)

	arg0_6.activePanel = nil

	local var0_6 = {
		{
			btn = arg0_6.btnAction,
			panel = arg0_6.panelAction,
			On = function()
				arg0_6:UpdateActionPanel()
				setActive(arg0_6.panelAction, true)
			end,
			Off = function()
				setActive(arg0_6.panelAction, false)
			end
		},
		{
			btn = arg0_6.btnCamera,
			panel = arg0_6.panelCamera,
			On = function()
				arg0_6:UpdateCameraPanel()
				setActive(arg0_6.panelCamera, true)
			end,
			Off = function()
				setActive(arg0_6.panelCamera, false)
			end
		},
		{
			btn = arg0_6.btnLighting,
			panel = arg0_6.panelLightning,
			On = function()
				arg0_6:UpdateLightingPanel()
				setActive(arg0_6.panelLightning, true)
			end,
			Off = function()
				setActive(arg0_6.panelLightning, false)
			end
		}
	}

	table.Ipairs(var0_6, function(arg0_34, arg1_34)
		onButton(arg0_6, arg1_34.btn, function()
			if arg0_34 == arg0_6.activePanel then
				arg0_6.activePanel = nil

				arg1_34.Off()
			else
				table.Ipairs(var0_6, function(arg0_36, arg1_36)
					if arg0_36 == arg0_34 then
						return
					end

					arg1_36.Off()
				end)

				arg0_6.activePanel = arg0_34

				arg1_34.On()
			end
		end, SFX_PANEL)
	end)

	arg0_6.zoneIndex = 1

	arg0_6:InitData()
	arg0_6:FirstEnterZone()

	local var1_6 = arg0_6.apartment:GetCameraZones()

	UIItemList.StaticAlign(arg0_6.listZones, arg0_6.listZones:GetChild(0), #var1_6, function(arg0_37, arg1_37, arg2_37)
		if arg0_37 ~= UIItemList.EventUpdate then
			return
		end

		arg1_37 = arg1_37 + 1

		local var0_37 = var1_6[arg1_37]

		setText(arg2_37:Find("Name"), var0_37:GetName())
		onButton(arg0_6, arg2_37, function()
			if arg0_6.zoneIndex == arg1_37 then
				return
			end

			local var0_38 = arg0_6.zoneIndex

			setActive(arg2_37:Find("Selected"), true)
			setActive(arg0_6.listZones:GetChild(var0_38 - 1):Find("Selected"), false)

			arg0_6.zoneIndex = arg1_37

			arg0_6:RefreshData()
			arg0_6:SwitchZone()
		end, SFX_PANEL)
	end)
	setActive(arg0_6.listZones:GetChild(arg0_6.zoneIndex - 1):Find("Selected"), true)
end

function var0_0.InitData(arg0_39)
	arg0_39.cameraSettings = Clone(arg0_39.scene:GetCameraSettings())
	arg0_39.settingHideCharacter = false
	arg0_39.settingFaceCamera = true
	arg0_39.settingLightingColorIndex = nil
	arg0_39.settingLightingStrength = 1
	arg0_39.settingLightingAlpha = 1
	arg0_39.settingFilterIndex = nil
	arg0_39.settingFilterStrength = 1

	arg0_39:RefreshData()
end

function var0_0.RefreshData(arg0_40)
	local var0_40 = arg0_40.apartment:GetCameraZones()[arg0_40.zoneIndex]

	arg0_40.animID = var0_40:GetRegularAnims()[1]:GetConfigID()

	local function var1_40(arg0_41, arg1_41)
		arg0_41.min = arg1_41[1]
		arg0_41.max = arg1_41[2]
		arg0_41.value = math.clamp(arg0_41.value, arg1_41[1], arg1_41[2])
	end

	var1_40(arg0_40.cameraSettings.depthOfField.focusDistance, var0_40:GetFocusDistanceRange())
	var1_40(arg0_40.cameraSettings.depthOfField.blurRadius, var0_40:GetDepthOfFieldBlurRange())
	var1_40(arg0_40.cameraSettings.postExposure, var0_40:GetExposureRange())
	var1_40(arg0_40.cameraSettings.contrast, var0_40:GetContrastRange())
	var1_40(arg0_40.cameraSettings.saturate, var0_40:GetSaturationRange())

	arg0_40.animSpeeds = var0_40:GetAnimSpeeds()
	arg0_40.animSpeed = 1
end

function var0_0.FirstEnterZone(arg0_42)
	local var0_42 = arg0_42.apartment:GetCameraZones()[arg0_42.zoneIndex]

	arg0_42.scene:EnterPhotoMode(var0_42)
	arg0_42:UpdateActionPanel()
	arg0_42:UpdateCameraPanel()
	arg0_42:UpdateLightingPanel()
	arg0_42:UpdateAnimSpeedPanel()
end

function var0_0.SwitchZone(arg0_43)
	local var0_43 = arg0_43.apartment:GetCameraZones()[arg0_43.zoneIndex]

	arg0_43.scene:SwitchCameraZone(var0_43)
	arg0_43:UpdateActionPanel()
	arg0_43:UpdateCameraPanel()
	arg0_43:UpdateLightingPanel()
	arg0_43:UpdateAnimSpeedPanel()
end

local var1_0 = 0.2

function var0_0.UpdateActionPanel(arg0_44)
	if arg0_44.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_44 = arg0_44.apartment:GetCameraZones()[arg0_44.zoneIndex]
	local var1_44 = var0_44:GetRegularAnims()

	arg0_44.lastSelectedAnimBG = nil

	local function var2_44(arg0_45, arg1_45)
		local var0_45 = arg0_45:GetConfigID()

		if arg0_44.animID == var0_45 then
			return
		end

		if arg0_44.lastSelectedAnimBG then
			setActive(arg0_44.lastSelectedAnimBG, false)
		end

		local var1_45 = arg0_44:GetAnimPlayList(var0_45)
		local var2_45 = Dorm3dCameraAnim.New({
			configId = arg0_44.animID
		}):GetFinishAnimID()

		arg0_44.animID = var0_45
		arg0_44.lastSelectedAnimBG = arg1_45:Find("Selected")

		arg0_44:BlockActionPanel(true)

		local var3_45 = (table.indexof(var1_45, _.detect(var1_45, function(arg0_46)
			return arg0_46:GetConfigID() == var2_45
		end)) or 0) + 1
		local var4_45 = _.rest(var1_45, var3_45)
		local var5_45 = arg1_45:Find("Fill"):GetComponent(typeof(Image))

		setActive(arg1_45:Find("Fill"), true)

		local function var6_45()
			setActive(arg1_45:Find("Selected"), true)
			setActive(arg1_45:Find("Fill"), false)
			arg0_44:BlockActionPanel(false)

			arg0_44.animPlaying = nil
		end

		if #var4_45 == 0 then
			var6_45()

			return
		end

		local var7_45 = _.reduce(var4_45, 0, function(arg0_48, arg1_48)
			return arg0_48 + math.max(var1_0, arg1_48:GetAnimTime())
		end)

		arg0_44.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_45,
			totalTime = var7_45,
			imgFill = var5_45,
			startStamp = Time.time
		}
		arg0_44.timerAnim = FrameTimer.New(function()
			local var0_49 = arg0_44.animInfo
			local var1_49 = var0_49.animPlayList[var0_49.index]
			local var2_49 = math.max(var1_0, var1_49:GetAnimTime())
			local var3_49 = var0_49.startStamp
			local var4_49 = Time.time
			local var5_49 = math.min(1, var0_49.ratio + (var4_49 - var3_49) * arg0_44.animSpeed / var2_49)
			local var6_49 = var0_49.passedTime + var2_49 * var5_49

			var5_45.fillAmount = var6_49 / var7_45

			if var5_49 < 1 then
				return
			end

			var0_49.index = var0_49.index + 1
			var0_49.ratio = 0
			var0_49.passedTime = var0_49.passedTime + var2_49
			var0_49.startStamp = var4_49

			warning(var0_49.startStamp)

			if var0_49.index > #var0_49.animPlayList then
				var6_45()
				arg0_44.timerAnim:Stop()

				arg0_44.timerAnim = nil
				arg0_44.animInfo = nil

				return
			end

			local var7_49 = var0_49.animPlayList[var0_49.index]

			arg0_44.scene:PlaySingleAction(var7_49:GetStateName())
		end, 1, -1)

		local var8_45 = arg0_44.animInfo.animPlayList[1]

		if var3_45 == 1 then
			arg0_44.scene:SwitchAnim(var8_45:GetStateName())
			onNextTick(function()
				arg0_44.scene:ResetCharPosByZone(var0_44)
			end)
		else
			arg0_44.scene:PlaySingleAction(var8_45:GetStateName())
		end

		arg0_44.timerAnim:Start()
	end

	local var3_44 = arg0_44.panelAction:Find("Regular/List")

	UIItemList.StaticAlign(var3_44, var3_44:GetChild(0), #var1_44, function(arg0_51, arg1_51, arg2_51)
		if arg0_51 ~= UIItemList.EventUpdate then
			return
		end

		arg1_51 = arg1_51 + 1

		local var0_51 = var1_44[arg1_51]

		setText(arg2_51:Find("Name"), var0_51:GetName())
		setActive(arg2_51:Find("Fill"), false)
		setActive(arg2_51:Find("Selected"), false)
		onButton(arg0_44, arg2_51, function()
			var2_44(var0_51, arg2_51)
		end)
	end)

	local var4_44, var5_44 = table.Find(var1_44, function(arg0_53, arg1_53)
		return arg1_53:GetConfigID() == arg0_44.animID
	end)

	arg0_44.lastSelectedAnimBG = var3_44:GetChild(var5_44 - 1):Find("Selected")

	setActive(arg0_44.lastSelectedAnimBG, true)

	local var6_44 = var0_44:GetSpecialAnims()
	local var7_44 = arg0_44.panelAction:Find("Special/Furnitures")

	arg0_44.lastFurniture = nil
	arg0_44.lastSelectedFurnitureBG = nil

	local var8_44 = arg0_44.panelAction:Find("Special/List")

	setActive(var8_44, false)

	local var9_44 = arg0_44.panelAction:Find("Special/Arrow")

	setActive(var9_44, false)

	local function var10_44(arg0_54, arg1_54)
		if arg0_44.lastSelectedFurnitureBG then
			setActive(arg0_44.lastSelectedFurnitureBG, false)
		end

		arg0_44.lastFurniture = arg0_54
		arg0_44.lastSelectedFurnitureBG = arg1_54:Find("Selected")

		setActive(arg0_44.lastSelectedFurnitureBG, true)
		setActive(var8_44, true)
		setActive(var9_44, true)

		var9_44.position = arg1_54.position
		var9_44.anchoredPosition = var9_44.anchoredPosition + Vector2(0, -60)

		local var0_54 = arg0_54.anims

		UIItemList.StaticAlign(var8_44, var8_44:GetChild(0), #var0_54, function(arg0_55, arg1_55, arg2_55)
			if arg0_55 ~= UIItemList.EventUpdate then
				return
			end

			arg1_55 = arg1_55 + 1

			local var0_55 = var0_54[arg1_55]

			setText(arg2_55:Find("Name"), var0_55:GetName())
			setActive(arg2_55:Find("Fill"), false)
			setActive(arg2_55:Find("Selected"), false)

			if var0_55:GetConfigID() == arg0_44.animID then
				arg0_44.lastSelectedAnimBG = arg2_55:Find("Selected")

				setActive(arg0_44.lastSelectedAnimBG, true)
			end

			onButton(arg0_44, arg2_55, function()
				arg0_44.apartment:ReplaceFurniture(arg0_54.slotId, arg0_54.furnitureId)
				arg0_44.scene:RefreshSlots(arg0_44.apartment)
				var2_44(var0_55, arg2_55)
			end)
		end)
	end

	setActive(arg0_44.panelAction:Find("Special"), #var6_44 > 0)
	UIItemList.StaticAlign(var7_44, var7_44:GetChild(0), #var6_44, function(arg0_57, arg1_57, arg2_57)
		arg1_57 = arg1_57 + 1

		local var0_57 = var6_44[arg1_57]
		local var1_57 = Dorm3dFurniture.New({
			configId = var0_57.furnitureId
		})
		local var2_57 = tobool(_.detect(arg0_44.apartment:GetFurnitures(), function(arg0_58)
			return arg0_58:GetConfigID() == var0_57.furnitureId
		end))

		updateDrop(arg2_57:Find("Icon"), {
			type = DROP_TYPE_DORM3D_FURNITURE,
			id = var1_57:GetConfigID()
		})
		setText(arg2_57:Find("Name"), var1_57:GetName())
		setActive(arg2_57:Find("Lock"), not var2_57)
		onButton(arg0_44, arg2_57, function()
			if not var2_57 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("furniture not unlock"))

				return
			end

			var10_44(var0_57, arg2_57)
		end)
	end)
end

function var0_0.BlockActionPanel(arg0_60, arg1_60)
	setActive(arg0_60.panelAction:Find("Mask"), arg1_60)
end

function var0_0.GetAnimPlayList(arg0_61, arg1_61)
	local var0_61 = arg1_61
	local var1_61 = {}

	while true do
		local var2_61 = Dorm3dCameraAnim.New({
			configId = var0_61
		})

		if not var2_61 then
			return var1_61
		end

		table.insert(var1_61, 1, var2_61)

		var0_61 = var2_61:GetPreAnimID()

		if var0_61 == 0 then
			return var1_61
		end
	end
end

function var0_0.UpdateCameraPanel(arg0_62)
	if arg0_62.activePanel ~= var0_0.PANEL.CAMERA then
		return
	end

	local var0_62 = arg0_62.apartment:GetCameraZones()[arg0_62.zoneIndex]

	;(function()
		local var0_63 = arg0_62.panelCamera:Find("DepthOfField/Toggle")

		triggerToggleWithoutNotify(var0_63, arg0_62.cameraSettings.depthOfField.enabled)
		onToggle(arg0_62, var0_63, function(arg0_64)
			arg0_62.cameraSettings.depthOfField.enabled = arg0_64

			arg0_62:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_65 = arg0_62.cameraSettings.depthOfField.focusDistance
		local var1_65 = arg0_62.panelCamera:Find("DepthOfField/List/FocusDistance/Slider")

		setSlider(var1_65, var0_65.min, var0_65.max, var0_65.value)
		onSlider(arg0_62, var1_65, function(arg0_66)
			var0_65.value = arg0_66

			arg0_62:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_67 = arg0_62.cameraSettings.depthOfField.blurRadius
		local var1_67 = arg0_62.panelCamera:Find("DepthOfField/List/BlurRadius/Slider")

		setSlider(var1_67, var0_67.min, var0_67.max, var0_67.value)
		onSlider(arg0_62, var1_67, function(arg0_68)
			var0_67.value = arg0_68

			arg0_62:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_69 = arg0_62.cameraSettings.postExposure
		local var1_69 = arg0_62.panelCamera:Find("PostExposure/Slider")

		setSlider(var1_69, var0_69.min, var0_69.max, var0_69.value)
		onSlider(arg0_62, var1_69, function(arg0_70)
			var0_69.value = arg0_70

			arg0_62:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_71 = arg0_62.cameraSettings.contrast
		local var1_71 = arg0_62.panelCamera:Find("Contrast/Slider")

		setSlider(var1_71, var0_71.min, var0_71.max, var0_71.value)
		onSlider(arg0_62, var1_71, function(arg0_72)
			var0_71.value = arg0_72

			arg0_62:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_73 = arg0_62.cameraSettings.saturate
		local var1_73 = arg0_62.panelCamera:Find("Saturation/Slider")

		setSlider(var1_73, var0_73.min, var0_73.max, var0_73.value)
		onSlider(arg0_62, var1_73, function(arg0_74)
			var0_73.value = arg0_74

			arg0_62:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_75 = arg0_62.panelCamera:Find("FaceCamera/Toggle")

		triggerToggleWithoutNotify(var0_75, arg0_62.settingFaceCamera)
		setActive(var0_75:Find("Selected"), arg0_62.settingFaceCamera)
		onToggle(arg0_62, var0_75, function(arg0_76)
			arg0_62.settingFaceCamera = arg0_76

			arg0_62.scene:EnableHeadIK(arg0_76)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_77 = arg0_62.panelCamera:Find("HideCharacter/Toggle")

		triggerToggleWithoutNotify(var0_77, arg0_62.settingHideCharacter)
		setActive(var0_77:Find("Selected"), arg0_62.settingHideCharacter)
		onToggle(arg0_62, var0_77, function(arg0_78)
			arg0_62.settingHideCharacter = arg0_78

			if arg0_78 then
				arg0_62.scene:SwitchLadyInterestInPhotoMode(false)
				arg0_62.scene:HideCharacter()
			else
				arg0_62.scene:SwitchLadyInterestInPhotoMode(true)
				arg0_62.scene:RevertCharacter()
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0_0.RefreshCamera(arg0_79)
	arg0_79.scene:SettingCamera(arg0_79.cameraSettings)
end

function var0_0.UpdateAnimSpeedPanel(arg0_80)
	local function var0_80()
		if not arg0_80.timerAnim then
			return
		end

		local var0_81 = arg0_80.animInfo
		local var1_81 = var0_81.animPlayList[var0_81.index]
		local var2_81 = math.max(var1_0, var1_81:GetAnimTime())
		local var3_81 = var0_81.startStamp
		local var4_81 = Time.time

		var0_81.ratio = math.min(1, var0_81.ratio + (var4_81 - var3_81) * arg0_80.animSpeed / var2_81)
		var0_81.startStamp = var4_81
	end

	local var1_80 = arg0_80.animSpeeds

	UIItemList.StaticAlign(arg0_80.listAnimSpeed, arg0_80.listAnimSpeed:GetChild(0), #var1_80, function(arg0_82, arg1_82, arg2_82)
		if arg0_82 ~= UIItemList.EventUpdate then
			return
		end

		arg1_82 = arg1_82 + 1

		local var0_82 = var1_80[arg1_82]

		setText(arg2_82:Find("Text"), var0_82)
		onButton(arg0_80, arg2_82, function()
			if arg0_80.animSpeed == var0_82 then
				return
			end

			if arg0_80.animPlaying then
				return
			end

			var0_80()

			arg0_80.animSpeed = var0_82

			arg0_80.scene:SetCharacterAnimSpeed(var0_82)
			arg0_80:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0_80, arg0_80.btnFreeze, function()
		if arg0_80.animPlaying then
			return
		end

		local var0_84 = 0

		if arg0_80.animSpeed ~= 0 then
			arg0_80.lastAnimSpeed = arg0_80.animSpeed
		else
			var0_84 = arg0_80.lastAnimSpeed or 1
			arg0_80.lastAnimSpeed = nil
		end

		var0_80()

		arg0_80.animSpeed = var0_84

		arg0_80.scene:SetCharacterAnimSpeed(var0_84)
		arg0_80:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_80.listAnimSpeed, arg0_80.listAnimSpeed:GetChild(0), #var1_80, function(arg0_85, arg1_85, arg2_85)
		if arg0_85 ~= UIItemList.EventUpdate then
			return
		end

		arg1_85 = arg1_85 + 1

		local var0_85 = var1_80[arg1_85]

		setActive(arg2_85:Find("Selected"), arg0_80.animSpeed == var0_85)
	end)
	setActive(arg0_80.btnFreeze:Find("Selected"), arg0_80.animSpeed == 0)
	setText(arg0_80.textAnimSpeed, "X" .. arg0_80.animSpeed)
end

function var0_0.UpdateLightingPanel(arg0_86)
	if arg0_86.activePanel ~= var0_0.PANEL.LIGHTING then
		return
	end

	local var0_86 = arg0_86.apartment:GetCameraZones()[arg0_86.zoneIndex]
	local var1_86 = {
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

	local function var2_86()
		if not arg0_86.settingLightingColorIndex then
			arg0_86.scene:RevertCharacterLight()

			return
		end

		local var0_87 = var1_86[arg0_86.settingLightingColorIndex]

		arg0_86.scene:SetCharacterLight(Color.NewHex(var0_87.color), arg0_86.settingLightingAlpha, arg0_86.settingLightingStrength)
	end

	arg0_86.lastSelectedColorBG = nil

	UIItemList.StaticAlign(arg0_86.panelLightning:Find("Lighting/List"), arg0_86.panelLightning:Find("Lighting/List"):GetChild(0), #var1_86, function(arg0_88, arg1_88, arg2_88)
		if arg0_88 ~= UIItemList.EventUpdate then
			return
		end

		arg1_88 = arg1_88 + 1

		local var0_88 = var1_86[arg1_88]

		setText(arg2_88:Find("Name"), var0_88.name)

		if arg0_86.settingLightingColorIndex == arg1_88 then
			arg0_86.lastSelectedColorBG = arg2_88:Find("Selected")

			setActive(arg0_86.lastSelectedColorBG, true)
		end

		onButton(arg0_86, arg2_88, function()
			if arg0_86.settingLightingColorIndex ~= arg1_88 then
				arg0_86.settingLightingColorIndex = arg1_88
			else
				arg0_86.settingLightingColorIndex = nil
			end

			var2_86()

			if arg0_86.lastSelectedColorBG then
				setActive(arg0_86.lastSelectedColorBG, false)
			end

			if arg0_86.settingLightingColorIndex == arg1_88 then
				arg0_86.lastSelectedColorBG = arg2_88:Find("Selected")

				setActive(arg0_86.lastSelectedColorBG, true)
			end
		end, SFX_PANEL)
	end)
	;(function()
		local var0_90 = arg0_86.panelLightning:Find("Lighting/Sliders/Strength/Slider")

		setSlider(var0_90, 0, 1, arg0_86.settingLightingStrength)
		onSlider(arg0_86, var0_90, function(arg0_91)
			arg0_86.settingLightingStrength = arg0_91

			var2_86()
		end)
	end)()
	;(function()
		local var0_92 = arg0_86.panelLightning:Find("Lighting/Sliders/Alpha/Slider")

		setSlider(var0_92, 0, 1, arg0_86.settingLightingAlpha)
		onSlider(arg0_86, var0_92, function(arg0_93)
			arg0_86.settingLightingAlpha = arg0_93

			var2_86()
		end)
	end)()

	local var3_86 = {
		{
			name = "泛紫",
			profile = "volume_purple"
		}
	}

	local function var4_86()
		if not arg0_86.settingFilterIndex then
			arg0_86.scene:RevertVolumeProfile()

			return
		end

		local var0_94 = var3_86[arg0_86.settingFilterIndex]

		arg0_86.scene:SetVolumeProfile(var0_94.profile, arg0_86.settingFilterStrength)
	end

	arg0_86.lastSelectedFilterBG = nil

	UIItemList.StaticAlign(arg0_86.panelLightning:Find("Filter/List"), arg0_86.panelLightning:Find("Filter/List"):GetChild(0), #var3_86, function(arg0_95, arg1_95, arg2_95)
		if arg0_95 ~= UIItemList.EventUpdate then
			return
		end

		arg1_95 = arg1_95 + 1

		local var0_95 = var3_86[arg1_95]

		setText(arg2_95:Find("Name"), var0_95.name)

		if arg0_86.settingFilterIndex == arg1_95 then
			arg0_86.lastSelectedFilterBG = arg2_95:Find("Selected")

			setActive(arg0_86.lastSelectedFilterBG, true)
		end

		onButton(arg0_86, arg2_95, function()
			if arg0_86.settingFilterIndex ~= arg1_95 then
				arg0_86.settingFilterIndex = arg1_95
			else
				arg0_86.settingFilterIndex = nil
			end

			var4_86()

			if arg0_86.lastSelectedFilterBG then
				setActive(arg0_86.lastSelectedFilterBG, false)
			end

			if arg0_86.settingFilterIndex == arg1_95 then
				arg0_86.lastSelectedFilterBG = arg2_95:Find("Selected")

				setActive(arg0_86.lastSelectedFilterBG, true)
			end
		end, SFX_PANEL)
	end)
	;(function()
		local var0_97 = arg0_86.panelLightning:Find("Filter/Sliders/Strength/Slider")

		setSlider(var0_97, 0, 1, arg0_86.settingFilterStrength)
		onSlider(arg0_86, var0_97, function(arg0_98)
			arg0_86.settingFilterStrength = arg0_98

			var4_86()
		end)
	end)()
end

function var0_0.SetMute(arg0_99)
	if arg0_99 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.willExit(arg0_100)
	if arg0_100.animSpeed ~= 1 then
		arg0_100.scene:SetCharacterAnimSpeed(1)
	end

	if arg0_100.settingHideCharacter then
		arg0_100.scene:SwitchLadyInterestInPhotoMode(true)
		arg0_100.scene:RevertCharacter()
	end

	if not arg0_100.settingFaceCamera then
		arg0_100.scene:EnableHeadIK(true)
	end

	arg0_100.scene:RevertCharacterLight()
	arg0_100.scene:RevertVolumeProfile()
	arg0_100.scene:RevertCameraSettings()
	arg0_100.scene:ExitPhotoMode()
end

return var0_0
