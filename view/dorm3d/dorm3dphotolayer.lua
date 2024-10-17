local var0_0 = class("Dorm3dPhotoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dPhotoUI"
end

local var1_0 = {
	"/OverlayCamera/Overlay/UIOverlay/TipPanel(Clone)"
}

var0_0.PANEL = {
	CAMERA = 2,
	LIGHTING = 3,
	ACTION = 1
}

function var0_0.init(arg0_2)
	arg0_2.centerPanel = arg0_2._tf:Find("Center")
	arg0_2.normalPanel = arg0_2._tf:Find("Center/Normal")

	setActive(arg0_2.normalPanel, true)

	arg0_2.settingPanel = arg0_2._tf:Find("Center/Settings")
	arg0_2.btnAction = arg0_2.settingPanel:Find("Action")
	arg0_2.btnCamera = arg0_2.settingPanel:Find("Camera")
	arg0_2.btnLighting = arg0_2.settingPanel:Find("Lighting")
	arg0_2.panelAction = arg0_2.settingPanel:Find("ActionSelect")

	setActive(arg0_2.panelAction, false)
	setActive(arg0_2.panelAction:Find("Mask"), false)

	arg0_2.panelCamera = arg0_2.settingPanel:Find("CameraSettings")

	setActive(arg0_2.panelCamera, false)

	arg0_2.panelLightning = arg0_2.settingPanel:Find("LightningSettings")

	setActive(arg0_2.panelLightning, false)

	arg0_2.listZones = arg0_2._tf:Find("ZoneList")

	setActive(arg0_2.listZones, false)

	arg0_2.zoneMask = arg0_2.listZones:Find("Mask")
	arg0_2.btnHideUI = arg0_2._tf:Find("Center/HideUI")
	arg0_2.btnReset = arg0_2._tf:Find("Center/Reset")
	arg0_2.btnFreeze = arg0_2._tf:Find("Center/Freeze")
	arg0_2.btnZone = arg0_2._tf:Find("Center/Zone")
	arg0_2.btnAr = arg0_2._tf:Find("Center/Ar")
	arg0_2.ARchecker = GetComponent(arg0_2.btnAr.gameObject, "ARChecker")
	arg0_2.btnAnimSpeed = arg0_2._tf:Find("Center/AnimSpeed")
	arg0_2.listAnimSpeed = arg0_2.btnAnimSpeed:Find("Bar")

	setActive(arg0_2.listAnimSpeed, false)

	arg0_2.textAnimSpeed = arg0_2.btnAnimSpeed:Find("Text")
	arg0_2.hideuiMask = arg0_2._tf:Find("RightTop/Mask")

	setActive(arg0_2.hideuiMask, false)

	arg0_2.btnFilm = arg0_2._tf:Find("RightTop/Film/Film")
	arg0_2.filmTime = arg0_2._tf:Find("RightTop/FilmTime")

	setActive(arg0_2.filmTime, false)

	arg0_2.shareUI = arg0_2._tf:Find("ShareUI")

	setActive(arg0_2.shareUI, false)

	arg0_2.ysScreenShoter = arg0_2._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenShoter))
	arg0_2.ysScreenRecorder = arg0_2._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenRecorder))

	local var0_2 = arg0_2.panelAction:Find("Layout/Regular/Index")

	setActive(var0_2, false)
	setText(arg0_2.panelCamera:Find("Layout/DepthOfField/Title/Text"), i18n("dorm3d_photo_len"))
	setText(arg0_2.panelCamera:Find("Layout/DepthOfField/Switch/Title"), i18n("dorm3d_photo_depthoffield"))
	setText(arg0_2.panelCamera:Find("Layout/DepthOfField/DepthOfField/FocusDistance/Title"), i18n("dorm3d_photo_focusdistance"))
	setText(arg0_2.panelCamera:Find("Layout/DepthOfField/DepthOfField/BlurRadius/Title"), i18n("dorm3d_photo_focusstrength"))
	setText(arg0_2.panelCamera:Find("Layout/Paramaters/Title/Text"), i18n("dorm3d_photo_paramaters"))
	setText(arg0_2.panelCamera:Find("Layout/Paramaters/PostExposure/PostExposure/Title"), i18n("dorm3d_photo_postexposure"))
	setText(arg0_2.panelCamera:Find("Layout/Paramaters/Saturation/Saturation/Title"), i18n("dorm3d_photo_saturation"))
	setText(arg0_2.panelCamera:Find("Layout/Paramaters/Contrast/Contrast/Title"), i18n("dorm3d_photo_contrast"))
	setText(arg0_2.panelCamera:Find("Layout/Other/Title/Text"), i18n("dorm3d_photo_Others"))
	setText(arg0_2.panelCamera:Find("Layout/Other/HideCharacter/Title"), i18n("dorm3d_photo_hidecharacter"))
	setText(arg0_2.panelCamera:Find("Layout/Other/FaceCamera/Title"), i18n("dorm3d_photo_facecamera"))
	setText(arg0_2.panelLightning:Find("Layout/Title/Filter/Name"), i18n("dorm3d_photo_filter"))
	setText(arg0_2.panelLightning:Find("Layout/Title/Filter/Selected"), i18n("dorm3d_photo_filter"))
	setText(arg0_2.panelAction:Find("Layout/Title/Regular/Name"), i18n("dorm3d_photo_regular_anim"))
	setText(arg0_2.panelAction:Find("Layout/Title/Regular/Selected"), i18n("dorm3d_photo_regular_anim"))
	setText(arg0_2.panelAction:Find("Layout/Title/Special/Name"), i18n("dorm3d_photo_special_anim"))
	setText(arg0_2.panelAction:Find("Layout/Title/Special/Selected"), i18n("dorm3d_photo_special_anim"))

	arg0_2.mainCamera = GameObject.Find("BackYardMainCamera"):GetComponent(typeof(Camera))
	arg0_2.stopRecBtn = arg0_2:findTF("stopRec")
	arg0_2.videoTipPanel = arg0_2:findTF("videoTipPanel")

	setActive(arg0_2.videoTipPanel, false)
end

function var0_0.SetSceneRoot(arg0_3, arg1_3)
	arg0_3.scene = arg1_3
end

function var0_0.SetRoom(arg0_4, arg1_4)
	arg0_4.room = arg1_4
end

function var0_0.onBackPressed(arg0_5)
	if arg0_5.recordState then
		triggerButton(arg0_5.btnFilm)

		return
	end

	if arg0_5.activeSetting then
		triggerButton(arg0_5._tf:Find("Center/Settings/Back"))

		return
	end

	arg0_5:closeView()
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("Center/Normal/Back"), function()
		arg0_6:onBackPressed()
	end, SFX_CANCEL)

	arg0_6.activeSetting = false

	onButton(arg0_6, arg0_6._tf:Find("Center/Normal/Settings"), function()
		arg0_6.activeSetting = true

		quickPlayAnimation(arg0_6._tf:Find("Center"), "anim_dorm3d_photo_normal_out")
		arg0_6:UpdateActionPanel()
		arg0_6:UpdateCameraPanel()
		arg0_6:UpdateLightingPanel()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("Center/Settings/Back"), function()
		arg0_6.activeSetting = false

		quickPlayAnimation(arg0_6._tf:Find("Center"), "anim_dorm3d_photo_normal_in")
	end, SFX_CANCEL)

	arg0_6.hideUI = false

	onButton(arg0_6, arg0_6.btnHideUI, function()
		if arg0_6.hideUI then
			return
		end

		setActive(arg0_6.hideuiMask, true)
		setActive(arg0_6.centerPanel, false)

		arg0_6.hideUI = true
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.hideuiMask, function()
		if not arg0_6.hideUI then
			return
		end

		setActive(arg0_6.centerPanel, true)
		setActive(arg0_6.hideuiMask, false)

		arg0_6.hideUI = false
	end)
	onButton(arg0_6, arg0_6.btnReset, function()
		arg0_6.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetPhotoCameraPosition")
	end, SFX_PANEL)

	arg0_6.recordState = false

	onButton(arg0_6, arg0_6.btnFilm, function()
		local function var0_13(arg0_14)
			setActive(arg0_6.centerPanel, arg0_14)

			arg0_6:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_14 and 1 or 0
		end

		if not arg0_6.recordState then
			local function var1_13(arg0_15)
				if arg0_15 ~= -1 then
					var0_13(true)

					arg0_6.recordState = false

					LeanTween.moveX(arg0_6.stopRecBtn, arg0_6.stopRecBtn.rect.width, 0.15)
				end
			end

			local function var2_13(arg0_16)
				warning("开始录屏结果：" .. tostring(arg0_16))
			end

			local function var3_13()
				setActive(arg0_6.stopRecBtn, true)
				LeanTween.moveX(arg0_6.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)
					arg0_6.ysScreenRecorder:BeforeStart()
					arg0_6.ysScreenRecorder:StartRecord(var2_13, var1_13)
				end))

				if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
					print("start recording : play sound")
					NotificationMgr.Inst:PlayStartRecordSound()
				end
			end

			seriesAsync({
				function(arg0_19)
					CameraHelper.Request3DDorm(arg0_19, nil)
				end,
				function(arg0_20)
					arg0_6.recordState = true

					var0_13(false)

					local var0_20 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_20 or var0_20 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_6:findTF("Text", arg0_6.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_6, arg0_6.videoTipPanel, function()
							setActive(arg0_6.videoTipPanel, false)
							var3_13()
						end)
						setActive(arg0_6.videoTipPanel, true)
					else
						var3_13()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.stopRecBtn, function()
		arg0_6.recordState = false

		local function var0_22(arg0_23)
			warning("结束录屏结果：" .. tostring(arg0_23))
		end

		local function var1_22(arg0_24)
			setActive(arg0_6.centerPanel, arg0_24)

			arg0_6:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_24 and 1 or 0
		end

		if not LeanTween.isTweening(go(arg0_6.stopRecBtn)) then
			LeanTween.moveX(arg0_6.stopRecBtn, arg0_6.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_6.stopRecBtn, false)
				seriesAsync({
					function(arg0_26)
						arg0_6.ysScreenRecorder:StopRecord(var0_22)

						if PLATFORM == PLATFORM_ANDROID then
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("word_save_video"),
								onNo = function()
									arg0_6.ysScreenRecorder:DiscardVideo()
								end,
								onYes = function()
									local var0_28 = arg0_6.ysScreenRecorder:GetVideoFilePath()

									MediaSaver.SaveVideoWithPath(var0_28)
								end
							})
						end

						var1_22(true)
						var0_0.SetMute(false)

						local var0_26 = arg0_6.room:GetCameraZones()[arg0_6.zoneIndex]
						local var1_26 = Dorm3dCameraAnim.New({
							configId = arg0_6.animID
						})

						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_6.scene.apartment:GetConfigID(), 2, arg0_6.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_26:GetName(), var1_26:GetStateName(), arg0_6.cameraSettings.depthOfField.focusDistance.value, arg0_6.cameraSettings.depthOfField.blurRadius.value, arg0_6.cameraSettings.postExposure.value, arg0_6.cameraSettings.contrast.value, arg0_6.cameraSettings.saturate.value)))
					end
				})
			end))
		end
	end)
	setActive(arg0_6.stopRecBtn, false)
	onButton(arg0_6, arg0_6._tf:Find("RightTop/Film/Switch"), function()
		GetOrAddComponent(arg0_6._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = false

		quickPlayAnimation(arg0_6._tf:Find("RightTop"), "anim_dorm3d_photo_FtoS")
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("RightTop/Shot/Shot"), function()
		local function var0_30(arg0_31)
			setActive(arg0_6.centerPanel, arg0_31)
			setActive(arg0_6._tf:Find("RightTop"), arg0_31)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_31)
			end
		end

		local function var1_30(arg0_32)
			warning("截图结果：" .. tostring(arg0_32))
		end

		local function var2_30(arg0_33, arg1_33)
			arg0_6:emit(Dorm3dPhotoMediator.SHARE_PANEL, arg1_33, arg0_33)

			if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
				print("start photo : play sound")
				NotificationMgr.Inst:PlayShutterSound()
			end

			local var0_33 = arg0_6.room:GetCameraZones()[arg0_6.zoneIndex]
			local var1_33 = Dorm3dCameraAnim.New({
				configId = arg0_6.animID
			})

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_6.scene.apartment:GetConfigID(), 1, arg0_6.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_33:GetName(), var1_33:GetStateName(), arg0_6.cameraSettings.depthOfField.focusDistance.value, arg0_6.cameraSettings.depthOfField.blurRadius.value, arg0_6.cameraSettings.postExposure.value, arg0_6.cameraSettings.contrast.value, arg0_6.cameraSettings.saturate.value)))
		end

		local var3_30 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32):TakePhoto(arg0_6.mainCamera)
		local var4_30 = Tex2DExtension.EncodeToJPG(var3_30)

		var1_30(true)
		var2_30(var4_30, var3_30)
	end, "ui-dorm_photograph")

	GetOrAddComponent(arg0_6._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = false

	onButton(arg0_6, arg0_6._tf:Find("RightTop/Shot/Switch"), function()
		GetOrAddComponent(arg0_6._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = true

		quickPlayAnimation(arg0_6._tf:Find("RightTop"), "anim_dorm3d_photo_StoF")
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnAnimSpeed, function()
		setActive(arg0_6.listAnimSpeed, not isActive(arg0_6.listAnimSpeed))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnZone, function()
		local var0_36 = isActive(arg0_6.listZones)

		setActive(arg0_6.listZones, not var0_36)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.zoneMask, function()
		setActive(arg0_6.listZones, false)
	end)
	onButton(arg0_6, arg0_6.btnAr, function()
		arg0_6.ARchecker:StartCheck(function(arg0_39)
			if PLATFORM == PLATFORM_WINDOWSEDITOR then
				arg0_39 = -1
			end

			originalPrint("AR CODE: " .. arg0_39)
			arg0_6:emit(Dorm3dPhotoMediator.GO_AR, arg0_39)
		end)
	end)

	arg0_6.activePanel = 1

	local var0_6 = {
		{
			btn = arg0_6.btnAction,
			On = function()
				arg0_6:UpdateActionPanel()
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_6.btnCamera,
			On = function()
				arg0_6:UpdateCameraPanel()
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_6.btnLighting,
			On = function()
				arg0_6:UpdateLightingPanel()
			end,
			Off = function()
				return
			end
		}
	}

	table.Ipairs(var0_6, function(arg0_46, arg1_46)
		onToggle(arg0_6, arg1_46.btn, function(arg0_47)
			if not arg0_47 then
				return
			end

			table.Ipairs(var0_6, function(arg0_48, arg1_48)
				if arg0_48 == arg0_46 then
					return
				end

				arg1_48.Off()
			end)

			arg0_6.activePanel = arg0_46

			arg1_46.On()
		end, SFX_PANEL)
	end)
	;(function()
		local var0_49 = {
			arg0_6.panelAction:Find("Layout/Title/Regular"),
			arg0_6.panelAction:Find("Layout/Title/Special")
		}

		triggerToggle(var0_49[1], true)
	end)()
	;(function()
		local var0_50 = {
			arg0_6.panelLightning:Find("Layout/Title/Filter")
		}

		triggerToggle(var0_50[1], true)
	end)()

	arg0_6.zoneIndex = 1

	arg0_6:InitData()
	arg0_6:FirstEnterZone()
	triggerToggle(var0_6[arg0_6.activePanel].btn, true)
	arg0_6:UpdateZoneList()
end

function var0_0.InitData(arg0_51)
	arg0_51.cameraSettings = Clone(arg0_51.scene:GetCameraSettings())
	arg0_51.settingHideCharacter = false
	arg0_51.settingFaceCamera = true
	arg0_51.settingFilterIndex = nil
	arg0_51.settingFilterStrength = 1

	arg0_51:RefreshData()
end

function var0_0.RefreshData(arg0_52)
	local var0_52 = arg0_52.room:GetCameraZones()[arg0_52.zoneIndex]

	arg0_52.animID = var0_52:GetRegularAnims()[1]:GetConfigID()

	local function var1_52(arg0_53, arg1_53)
		arg0_53.min = arg1_53[1]
		arg0_53.max = arg1_53[2]
		arg0_53.value = math.clamp(arg0_53.value, arg1_53[1], arg1_53[2])
	end

	var1_52(arg0_52.cameraSettings.depthOfField.focusDistance, var0_52:GetFocusDistanceRange())
	var1_52(arg0_52.cameraSettings.depthOfField.blurRadius, var0_52:GetDepthOfFieldBlurRange())
	var1_52(arg0_52.cameraSettings.postExposure, var0_52:GetExposureRange())
	var1_52(arg0_52.cameraSettings.contrast, var0_52:GetContrastRange())
	var1_52(arg0_52.cameraSettings.saturate, var0_52:GetSaturationRange())

	arg0_52.animSpeeds = var0_52:GetAnimSpeeds()
	arg0_52.animSpeed = 1
end

function var0_0.FirstEnterZone(arg0_54)
	local var0_54 = arg0_54.room:GetCameraZones()[arg0_54.zoneIndex]
	local var1_54 = Dorm3dCameraAnim.New({
		configId = arg0_54.animID
	})

	arg0_54.scene:HideCharacter(arg0_54.scene.apartment:GetConfigID())
	arg0_54.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnterPhotoMode", var0_54, var1_54:GetStateName())
	arg0_54:UpdateAnimSpeedPanel()
end

function var0_0.SwitchZone(arg0_55)
	local var0_55 = arg0_55.room:GetCameraZones()[arg0_55.zoneIndex]
	local var1_55 = Dorm3dCameraAnim.New({
		configId = arg0_55.animID
	})

	arg0_55.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCameraZone", var0_55, var1_55:GetStateName())

	if arg0_55.timerAnim then
		arg0_55.timerAnim:Stop()

		arg0_55.timerAnim = nil
	end

	arg0_55.animPlaying = nil

	arg0_55:UpdateActionPanel()
	arg0_55:UpdateCameraPanel()
	arg0_55:UpdateLightingPanel()
	arg0_55:UpdateAnimSpeedPanel()
	arg0_55.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", arg0_55.animSpeed)
end

function var0_0.UpdateZoneList(arg0_56)
	local var0_56 = arg0_56.room:GetCameraZones()

	local function var1_56()
		setText(arg0_56.btnZone:Find("Text"), var0_56[arg0_56.zoneIndex]:GetName())
		UIItemList.StaticAlign(arg0_56.listZones:Find("List"), arg0_56.listZones:Find("List"):GetChild(0), #var0_56, function(arg0_58, arg1_58, arg2_58)
			if arg0_58 ~= UIItemList.EventUpdate then
				return
			end

			arg1_58 = arg1_58 + 1

			local var0_58 = var0_56[arg1_58]

			setText(arg2_58:Find("Name"), var0_58:GetName())

			local var1_58 = arg0_56.zoneIndex == arg1_58 and Color.NewHex("5CCAFF") or Color.NewHex("FFFFFF99")

			setTextColor(arg2_58:Find("Name"), var1_58)
			setActive(arg2_58:Find("Line"), arg1_58 < #var0_56)
		end)
	end

	var1_56()
	UIItemList.StaticAlign(arg0_56.listZones:Find("List"), arg0_56.listZones:Find("List"):GetChild(0), #var0_56, function(arg0_59, arg1_59, arg2_59)
		if arg0_59 ~= UIItemList.EventUpdate then
			return
		end

		arg1_59 = arg1_59 + 1

		onButton(arg0_56, arg2_59, function()
			if arg0_56.zoneIndex == arg1_59 then
				return
			end

			arg0_56.zoneIndex = arg1_59

			arg0_56:RefreshData()
			arg0_56:SwitchZone()
			setActive(arg0_56.listZones, false)
			var1_56()
		end, SFX_PANEL)
	end)
end

local var2_0 = 0.2

function var0_0.UpdateActionPanel(arg0_61)
	if not arg0_61.activeSetting then
		return
	end

	if arg0_61.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_61 = arg0_61.room:GetCameraZones()[arg0_61.zoneIndex]
	local var1_61 = var0_61:GetRegularAnims()
	local var2_61 = arg0_61.panelAction:Find("Layout/Regular/Scroll/Viewport/Content")
	local var3_61 = var0_61:GetAllSpecialList(arg0_61.room.id)
	local var4_61 = arg0_61.panelAction:Find("Layout/Special/Scroll/Viewport/Content")
	local var5_61 = #var3_61 > 0

	setActive(arg0_61.panelAction:Find("Layout/Title/Special"), var5_61)

	local function var6_61()
		UIItemList.StaticAlign(var2_61, var2_61:GetChild(0), #var1_61, function(arg0_63, arg1_63, arg2_63)
			if arg0_63 ~= UIItemList.EventUpdate then
				return
			end

			arg1_63 = arg1_63 + 1

			local var0_63 = var1_61[arg1_63]

			setActive(arg2_63:Find("Selected"), var0_63:GetConfigID() == arg0_61.animID)
			setActive(arg2_63:Find("Slider"), var0_63:GetConfigID() == arg0_61.animID and tobool(arg0_61.timerAnim))
		end)
		UIItemList.StaticAlign(var4_61, var4_61:GetChild(0), #var3_61, function(arg0_64, arg1_64, arg2_64)
			if arg0_64 ~= UIItemList.EventUpdate then
				return
			end

			arg1_64 = arg1_64 + 1

			local var0_64 = var3_61[arg1_64].anims
			local var1_64 = arg2_64:Find("Actions")

			UIItemList.StaticAlign(var1_64, var1_64:GetChild(0), #var0_64, function(arg0_65, arg1_65, arg2_65)
				if arg0_65 ~= UIItemList.EventUpdate then
					return
				end

				arg1_65 = arg1_65 + 1

				local var0_65 = var0_64[arg1_65]

				setActive(arg2_65:Find("Selected"), var0_65:GetConfigID() == arg0_61.animID)
				setActive(arg2_65:Find("Slider"), var0_65:GetConfigID() == arg0_61.animID and tobool(arg0_61.timerAnim))
			end)
		end)
	end

	local function var7_61(arg0_66, arg1_66)
		if arg0_61.animPlaying then
			return
		end

		local var0_66 = arg0_66:GetConfigID()

		if arg0_61.animID == var0_66 then
			return
		end

		local var1_66 = arg0_61:GetAnimPlayList(var0_66)
		local var2_66 = Dorm3dCameraAnim.New({
			configId = arg0_61.animID
		}):GetFinishAnimID()

		arg0_61.animID = var0_66

		var6_61()
		arg0_61:BlockActionPanel(true)

		arg0_61.animPlaying = true

		local var3_66 = (table.indexof(var1_66, _.detect(var1_66, function(arg0_67)
			return arg0_67:GetConfigID() == var2_66
		end)) or 0) + 1
		local var4_66 = _.rest(var1_66, var3_66)
		local var5_66 = arg1_66:Find("Slider"):GetComponent(typeof(Slider))

		setActive(arg1_66:Find("Slider"), true)

		local function var6_66()
			setActive(arg1_66:Find("Selected"), true)
			setActive(arg1_66:Find("Slider"), false)
			arg0_61:BlockActionPanel(false)

			arg0_61.animPlaying = nil
		end

		if #var4_66 == 0 then
			var6_66()

			return
		end

		local var7_66 = _.reduce(var4_66, 0, function(arg0_69, arg1_69)
			return arg0_69 + math.max(var2_0, arg1_69:GetAnimTime())
		end)

		if arg0_61.timerAnim then
			arg0_61.timerAnim:Stop()
		end

		arg0_61.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_66,
			totalTime = var7_66,
			startStamp = Time.time
		}
		arg0_61.timerAnim = FrameTimer.New(function()
			local var0_70 = arg0_61.animInfo
			local var1_70 = var0_70.animPlayList[var0_70.index]
			local var2_70 = math.max(var2_0, var1_70:GetAnimTime())
			local var3_70 = var0_70.startStamp
			local var4_70 = Time.time
			local var5_70 = math.min(1, var0_70.ratio + (var4_70 - var3_70) * arg0_61.animSpeed / var2_70)
			local var6_70 = var0_70.passedTime + var2_70 * var5_70

			var5_66.value = var6_70 / var7_66

			if var5_70 < 1 then
				return
			end

			var0_70.index = var0_70.index + 1
			var0_70.ratio = 0
			var0_70.passedTime = var0_70.passedTime + var2_70
			var0_70.startStamp = var4_70

			local var7_70 = var1_70:GetStartPoint()

			if #var7_70 > 0 then
				arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var7_70)
			end

			arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchPhotoCamera")
			warning(var0_70.startStamp)

			if var0_70.index > #var0_70.animPlayList then
				var6_66()
				arg0_61.timerAnim:Stop()

				arg0_61.timerAnim = nil
				arg0_61.animInfo = nil

				return
			end

			local var8_70 = var0_70.animPlayList[var0_70.index]

			arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlaySingleAction", var8_70:GetStateName())
		end, 1, -1)

		local var8_66 = arg0_61.animInfo.animPlayList[1]

		if var3_66 == 1 then
			arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchAnim", var8_66:GetStateName())
			onNextTick(function()
				local var0_71 = var8_66:GetStartPoint()

				if #var0_71 == 0 then
					var0_71 = var0_61:GetWatchCameraName()
				end

				arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var0_71)
				arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchPhotoCamera")
			end)
		else
			arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlaySingleAction", var8_66:GetStateName())
		end

		arg0_61.timerAnim:Start()
	end

	UIItemList.StaticAlign(var2_61, var2_61:GetChild(0), #var1_61, function(arg0_72, arg1_72, arg2_72)
		if arg0_72 ~= UIItemList.EventUpdate then
			return
		end

		arg1_72 = arg1_72 + 1

		local var0_72 = var1_61[arg1_72]

		setText(arg2_72:Find("Name"), var0_72:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_72:GetZoneIcon()), "", arg2_72:Find("Icon"))
		setActive(arg2_72:Find("Slider"), false)
		setActive(arg2_72:Find("Selected"), false)
		onButton(arg0_61, arg2_72, function()
			var7_61(var0_72, arg2_72)
		end)
	end)

	local function var8_61()
		UIItemList.StaticAlign(var4_61, var4_61:GetChild(0), #var3_61, function(arg0_75, arg1_75, arg2_75)
			if arg0_75 ~= UIItemList.EventUpdate then
				return
			end

			arg1_75 = arg1_75 + 1

			local var0_75 = var3_61[arg1_75].anims
			local var1_75 = arg2_75:Find("Actions")

			UIItemList.StaticAlign(var1_75, var1_75:GetChild(0), #var0_75, function(arg0_76, arg1_76, arg2_76)
				if arg0_76 ~= UIItemList.EventUpdate then
					return
				end

				arg1_76 = arg1_76 + 1

				local var0_76 = var0_75[arg1_76]

				setActive(arg2_76:Find("Selected"), var0_76:GetConfigID() == arg0_61.animID)
				setActive(arg2_76:Find("Slider"), var0_76:GetConfigID() == arg0_61.animID and tobool(arg0_61.timerAnim))
			end)
		end)
	end

	local function var9_61()
		UIItemList.StaticAlign(var4_61, var4_61:GetChild(0), #var3_61, function(arg0_78, arg1_78, arg2_78)
			if arg0_78 ~= UIItemList.EventUpdate then
				return
			end

			arg1_78 = arg1_78 + 1

			setActive(arg2_78:Find("Button/Active"), arg0_61.settingSpecialFurnitureIndex == arg1_78)
			setActive(arg2_78:Find("Actions"), arg0_61.settingSpecialFurnitureIndex == arg1_78)
		end)
		var8_61()
	end

	arg0_61.settingSpecialFurnitureIndex = nil

	local var10_61 = arg0_61.room:GetCameraZones()[arg0_61.zoneIndex]

	local function var11_61(arg0_79, arg1_79)
		local var0_79 = arg1_79:Find("Actions")
		local var1_79 = arg0_79.anims

		UIItemList.StaticAlign(var0_79, var0_79:GetChild(0), #var1_79, function(arg0_80, arg1_80, arg2_80)
			if arg0_80 ~= UIItemList.EventUpdate then
				return
			end

			arg1_80 = arg1_80 + 1

			local var0_80 = var1_79[arg1_80]
			local var1_80 = var10_61:CheckFurnitureIdInZone(arg0_79.furnitureId)
			local var2_80 = arg0_61.room:IsFurnitureSetIn(arg0_79.furnitureId)
			local var3_80 = var1_80 and var2_80

			SetActive(arg2_80:Find("Other"), not var3_80)
			SetActive(arg2_80:Find("Name"), var3_80)

			if var3_80 then
				onButton(arg0_61, arg2_80, function()
					arg0_61.room:ReplaceFurniture(arg0_79.slotId, arg0_79.furnitureId)
					arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RefreshSlots", arg0_61.room)
					var7_61(var0_80, arg2_80)
				end)
				setText(arg2_80:Find("Name"), var0_80:GetName())
			else
				removeOnButton(arg2_80)

				if not var1_80 then
					local var4_80 = var0_80:GetZoneName()

					warnText = i18n("dorm3d_photo_active_zone", var4_80)
				else
					warnText = i18n("dorm3d_furniture_replace_tip")
				end

				setText(arg2_80:Find("Other/Content"), warnText)
			end

			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_80:GetZoneIcon()), "", arg2_80:Find("Icon"))
			setActive(arg2_80:Find("Slider"), false)
			setActive(arg2_80:Find("Selected"), false)
		end)
	end

	setActive(var4_61, #var3_61 > 0)
	UIItemList.StaticAlign(var4_61, var4_61:GetChild(0), #var3_61, function(arg0_82, arg1_82, arg2_82)
		if arg0_82 ~= UIItemList.EventUpdate then
			return
		end

		arg1_82 = arg1_82 + 1

		local var0_82 = var3_61[arg1_82]
		local var1_82 = Dorm3dFurniture.New({
			configId = var0_82.furnitureId
		})
		local var2_82 = tobool(_.detect(arg0_61.room:GetFurnitures(), function(arg0_83)
			return arg0_83:GetConfigID() == var0_82.furnitureId
		end))

		setText(arg2_82:Find("Button/Name"), var1_82:GetName())
		GetImageSpriteFromAtlasAsync(var1_82:GetIcon(), "", arg2_82:Find("Button/Icon"))
		setActive(arg2_82:Find("Button/Lock"), not var2_82)
		setActive(arg2_82:Find("Button/BG"), var2_82)

		local var3_82 = var10_61:CheckFurnitureIdInZone(var0_82.furnitureId)
		local var4_82

		if var3_82 then
			var4_82 = Color.New(1, 1, 1, 0.850980392156863)
		else
			var4_82 = Color.New(0.788235294117647, 0.788235294117647, 0.788235294117647, 0.850980392156863)
		end

		setImageColor(arg2_82:Find("Button/BG"), var4_82)
		onButton(arg0_61, arg2_82:Find("Button"), function()
			if not var2_82 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_furniture_locked"))

				return
			end

			if arg0_61.settingSpecialFurnitureIndex == arg1_82 then
				arg0_61.settingSpecialFurnitureIndex = nil
			else
				arg0_61.settingSpecialFurnitureIndex = arg1_82
			end

			var11_61(var0_82, arg2_82, arg1_82)
			var9_61()
		end)
	end)
	var9_61()
	var6_61()
end

function var0_0.BlockActionPanel(arg0_85, arg1_85)
	return
end

function var0_0.GetAnimPlayList(arg0_86, arg1_86)
	local var0_86 = arg1_86
	local var1_86 = {}

	while true do
		local var2_86 = Dorm3dCameraAnim.New({
			configId = var0_86
		})

		if not var2_86 then
			return var1_86
		end

		table.insert(var1_86, 1, var2_86)

		var0_86 = var2_86:GetPreAnimID()

		if var0_86 == 0 then
			return var1_86
		end
	end
end

function var0_0.UpdateCameraPanel(arg0_87)
	if not arg0_87.activeSetting then
		return
	end

	if arg0_87.activePanel ~= var0_0.PANEL.CAMERA then
		return
	end

	;(function()
		local var0_88 = arg0_87.panelCamera:Find("Layout/DepthOfField/Switch/Toggle")

		triggerToggle(var0_88, arg0_87.cameraSettings.depthOfField.enabled)
		onToggle(arg0_87, var0_88, function(arg0_89)
			arg0_87.cameraSettings.depthOfField.enabled = arg0_89

			setActive(arg0_87.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_87.cameraSettings.depthOfField.enabled)
			arg0_87:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	setActive(arg0_87.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_87.cameraSettings.depthOfField.enabled)
	;(function()
		local var0_90 = arg0_87.cameraSettings.depthOfField.focusDistance
		local var1_90 = arg0_87.panelCamera:Find("Layout/DepthOfField/DepthOfField/FocusDistance/Slider")

		setSlider(var1_90, var0_90.min, var0_90.max, var0_90.value)
		onSlider(arg0_87, var1_90, function(arg0_91)
			var0_90.value = arg0_91

			arg0_87:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_92 = arg0_87.cameraSettings.depthOfField.blurRadius
		local var1_92 = arg0_87.panelCamera:Find("Layout/DepthOfField/DepthOfField/BlurRadius/Slider")

		setSlider(var1_92, var0_92.min, var0_92.max, var0_92.value)
		onSlider(arg0_87, var1_92, function(arg0_93)
			var0_92.value = arg0_93

			arg0_87:RefreshCamera()
		end)
	end)()

	local var0_87 = {
		"PostExposure",
		"Saturation",
		"Contrast"
	}

	arg0_87.paramIndex = arg0_87.paramIndex or 1

	local function var1_87()
		table.Ipairs(var0_87, function(arg0_95, arg1_95)
			local var0_95 = arg0_87.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_95 - 1)

			setActive(var0_95:Find("Selected"), arg0_95 == arg0_87.paramIndex)
			setActive(arg0_87.panelCamera:Find("Layout/Paramaters/" .. arg1_95), arg0_95 == arg0_87.paramIndex)
		end)
	end

	table.Ipairs(var0_87, function(arg0_96, arg1_96)
		local var0_96 = arg0_87.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_96 - 1)

		onButton(arg0_87, var0_96, function()
			arg0_87.paramIndex = arg0_96

			var1_87()
		end, SFX_PANEL)
	end)
	var1_87()
	;(function()
		local var0_98 = arg0_87.cameraSettings.postExposure
		local var1_98 = arg0_87.panelCamera:Find("Layout/Paramaters/PostExposure/PostExposure/Slider")
		local var2_98 = var1_98:Find("Background/Fill")

		onSlider(arg0_87, var1_98, function(arg0_99)
			var0_98.value = arg0_99

			local var0_99 = (arg0_99 - var0_98.min) / (var0_98.max - var0_98.min)
			local var1_99 = math.min(var0_99, 0.5)
			local var2_99 = math.max(var0_99, 0.5)

			var2_98.anchorMin = Vector2.New(var1_99, 0)
			var2_98.anchorMax = Vector2.New(var2_99, 1)
			var2_98.offsetMin = Vector2.zero
			var2_98.offsetMax = Vector2.zero

			arg0_87:RefreshCamera()
		end)
		setSlider(var1_98, var0_98.min, var0_98.max, var0_98.value)
	end)()
	;(function()
		local var0_100 = arg0_87.cameraSettings.contrast
		local var1_100 = arg0_87.panelCamera:Find("Layout/Paramaters/Contrast/Contrast/Slider")
		local var2_100 = var1_100:Find("Background/Fill")

		onSlider(arg0_87, var1_100, function(arg0_101)
			var0_100.value = arg0_101

			local var0_101 = (arg0_101 - var0_100.min) / (var0_100.max - var0_100.min)
			local var1_101 = math.min(var0_101, 0.5)
			local var2_101 = math.max(var0_101, 0.5)

			var2_100.anchorMin = Vector2.New(var1_101, 0)
			var2_100.anchorMax = Vector2.New(var2_101, 1)
			var2_100.offsetMin = Vector2.zero
			var2_100.offsetMax = Vector2.zero

			arg0_87:RefreshCamera()
		end)
		setSlider(var1_100, var0_100.min, var0_100.max, var0_100.value)
	end)()
	;(function()
		local var0_102 = arg0_87.cameraSettings.saturate
		local var1_102 = arg0_87.panelCamera:Find("Layout/Paramaters/Saturation/Saturation/Slider")
		local var2_102 = var1_102:Find("Background/Fill")

		onSlider(arg0_87, var1_102, function(arg0_103)
			var0_102.value = arg0_103

			local var0_103 = (arg0_103 - var0_102.min) / (var0_102.max - var0_102.min)
			local var1_103 = math.min(var0_103, 0.5)
			local var2_103 = math.max(var0_103, 0.5)

			var2_102.anchorMin = Vector2.New(var1_103, 0)
			var2_102.anchorMax = Vector2.New(var2_103, 1)
			var2_102.offsetMin = Vector2.zero
			var2_102.offsetMax = Vector2.zero

			arg0_87:RefreshCamera()
		end)
		setSlider(var1_102, var0_102.min, var0_102.max, var0_102.value)
	end)()
	;(function()
		local var0_104 = arg0_87.panelCamera:Find("Layout/Other/FaceCamera/Toggle")

		triggerToggle(var0_104, arg0_87.settingFaceCamera)
		onToggle(arg0_87, var0_104, function(arg0_105)
			arg0_87.settingFaceCamera = arg0_105

			arg0_87.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableHeadIK", arg0_105)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_106 = arg0_87.panelCamera:Find("Layout/Other/HideCharacter/Toggle")

		triggerToggle(var0_106, arg0_87.settingHideCharacter)
		onToggle(arg0_87, var0_106, function(arg0_107)
			arg0_87.settingHideCharacter = arg0_107

			if arg0_107 then
				arg0_87.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			else
				arg0_87.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0_0.RefreshCamera(arg0_108)
	arg0_108.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SettingCamera", arg0_108.cameraSettings)
end

function var0_0.UpdateAnimSpeedPanel(arg0_109)
	local function var0_109()
		if not arg0_109.timerAnim then
			return
		end

		local var0_110 = arg0_109.animInfo
		local var1_110 = var0_110.animPlayList[var0_110.index]
		local var2_110 = math.max(var2_0, var1_110:GetAnimTime())
		local var3_110 = var0_110.startStamp
		local var4_110 = Time.time

		var0_110.ratio = math.min(1, var0_110.ratio + (var4_110 - var3_110) * arg0_109.animSpeed / var2_110)
		var0_110.startStamp = var4_110
	end

	local var1_109 = arg0_109.animSpeeds

	UIItemList.StaticAlign(arg0_109.listAnimSpeed, arg0_109.listAnimSpeed:GetChild(0), #var1_109, function(arg0_111, arg1_111, arg2_111)
		if arg0_111 ~= UIItemList.EventUpdate then
			return
		end

		arg1_111 = #var1_109 - arg1_111

		local var0_111 = var1_109[arg1_111]

		setText(arg2_111:Find("Name"), var0_111)
		setText(arg2_111:Find("Selected"), var0_111)
		setActive(arg2_111:Find("Line"), arg1_111 ~= #var1_109)
		onButton(arg0_109, arg2_111, function()
			if arg0_109.animSpeed == var0_111 then
				return
			end

			var0_109()

			arg0_109.animSpeed = var0_111

			arg0_109.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_111)
			arg0_109:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0_109, arg0_109.btnFreeze, function()
		local var0_113 = 0

		if arg0_109.animSpeed ~= 0 then
			arg0_109.lastAnimSpeed = arg0_109.animSpeed
		else
			var0_113 = arg0_109.lastAnimSpeed or 1
			arg0_109.lastAnimSpeed = nil
		end

		var0_109()

		arg0_109.animSpeed = var0_113

		arg0_109.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_113)
		arg0_109:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_109.listAnimSpeed, arg0_109.listAnimSpeed:GetChild(0), #var1_109, function(arg0_114, arg1_114, arg2_114)
		if arg0_114 ~= UIItemList.EventUpdate then
			return
		end

		arg1_114 = #var1_109 - arg1_114

		local var0_114 = var1_109[arg1_114]

		setActive(arg2_114:Find("Name"), arg0_109.animSpeed ~= var0_114)
		setActive(arg2_114:Find("Selected"), arg0_109.animSpeed == var0_114)
	end)
	setActive(arg0_109.btnFreeze:Find("Icon"), arg0_109.animSpeed ~= 0)
	setActive(arg0_109.btnFreeze:Find("Selected"), arg0_109.animSpeed == 0)
	setText(arg0_109.textAnimSpeed, i18n("dorm3d_photo_animspeed", string.format("%.1f", arg0_109.animSpeed)))
end

function var0_0.UpdateLightingPanel(arg0_115)
	if not arg0_115.activeSetting then
		return
	end

	if arg0_115.activePanel ~= var0_0.PANEL.LIGHTING then
		return
	end

	local var0_115 = {}

	for iter0_115, iter1_115 in ipairs(pg.dorm3d_camera_volume_template.all) do
		table.insert(var0_115, iter1_115)
	end

	table.sort(var0_115, function(arg0_116, arg1_116)
		return arg0_116 < arg1_116
	end)

	local function var1_115()
		if not arg0_115.settingFilterIndex then
			arg0_115.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")

			return
		end

		local var0_117 = pg.dorm3d_camera_volume_template[var0_115[arg0_115.settingFilterIndex]]

		arg0_115.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetVolumeProfile", var0_117.volume, arg0_115.settingFilterStrength)
	end

	UIItemList.StaticAlign(arg0_115.panelLightning:Find("Layout/Filter/List"), arg0_115.panelLightning:Find("Layout/Filter/List"):GetChild(0), #var0_115, function(arg0_118, arg1_118, arg2_118)
		if arg0_118 ~= UIItemList.EventUpdate then
			return
		end

		arg1_118 = arg1_118 + 1

		local var0_118 = pg.dorm3d_camera_volume_template[var0_115[arg1_118]]

		setText(arg2_118:Find("Name"), var0_118.name)

		var0_118.icon = ""

		if var0_118.icon ~= "" then
			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_118.icon), "", arg2_118:Find("BG"))
		end

		if arg0_115.settingFilterIndex == arg1_118 then
			setActive(arg2_118:Find("Selected"), true)
		else
			setActive(arg2_118:Find("Selected"), false)
		end

		local var1_118, var2_118 = ApartmentProxy.CheckUnlockConfig(var0_118.unlock)

		setActive(arg2_118:Find("lock"), not var1_118)

		if not var1_118 then
			setText(arg2_118:Find("lock/Image/Text"), var0_118.unlock_text)
		end

		onButton(arg0_115, arg2_118, function()
			if not var1_118 then
				pg.TipsMgr.GetInstance():ShowTips(var2_118)

				return
			end

			local var0_119 = arg0_115.settingFilterIndex

			if arg0_115.settingFilterIndex ~= arg1_118 then
				arg0_115.settingFilterIndex = arg1_118
			else
				arg0_115.settingFilterIndex = nil
			end

			var1_115()

			if var0_119 then
				local var1_119 = arg0_115.panelLightning:Find("Layout/Filter/List"):GetChild(var0_119 - 1)

				setActive(var1_119:Find("Selected"), false)
			end

			if arg0_115.settingFilterIndex == arg1_118 then
				setActive(arg2_118:Find("Selected"), true)
			end
		end, SFX_PANEL)
	end)
	setActive(arg0_115.panelLightning:Find("Layout/Filter/Slider"), false)
end

function var0_0.SetMute(arg0_120)
	if arg0_120 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.willExit(arg0_121)
	if arg0_121.timerAnim then
		arg0_121.timerAnim:Stop()

		arg0_121.timerAnim = nil
	end

	if arg0_121.animSpeed ~= 1 then
		arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", 1)
	end

	if arg0_121.settingHideCharacter then
		arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
	end

	if not arg0_121.settingFaceCamera then
		arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableHeadIK", true)
	end

	arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterLight")
	arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")
	arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCameraSettings")
	arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ExitPhotoMode")
	arg0_121.scene:RevertCharacter(arg0_121.scene.apartment:GetConfigID())
end

function var0_0.SetCamaraPinchSliderValue(arg0_122, arg1_122)
	local var0_122 = arg0_122.normalPanel:Find("Zoom/Slider")

	setSlider(var0_122, 0, 1, 1 - (arg1_122 - 0.5) / 0.5)
end

return var0_0
