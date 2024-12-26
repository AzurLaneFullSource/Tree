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
	arg0_2.btnMove = arg0_2._tf:Find("Center/Move")
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
	arg0_2.skinSelectPanel = arg0_2._tf:Find("SkinSelectPanel")

	setActive(arg0_2.skinSelectPanel, false)

	arg0_2.btnMenuSmall = arg0_2._tf:Find("Center/MenuSmall")
	arg0_2.btnMenu = arg0_2._tf:Find("Center/Menu")

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
	setText(arg0_2.skinSelectPanel:Find("BG/Scroll/Content/Unlock/Title/Text"), i18n("word_unlock"))
	setText(arg0_2.skinSelectPanel:Find("BG/Scroll/Content/Lock/Title/Text"), i18n("word_lock"))

	arg0_2.mainCamera = GameObject.Find("BackYardMainCamera"):GetComponent(typeof(Camera))
	arg0_2.stopRecBtn = arg0_2:findTF("stopRec")
	arg0_2.videoTipPanel = arg0_2:findTF("videoTipPanel")

	setActive(arg0_2.videoTipPanel, false)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.SetSceneRoot(arg0_3, arg1_3)
	arg0_3.scene = arg1_3
end

function var0_0.SetRoom(arg0_4, arg1_4)
	arg0_4.room = arg1_4
end

function var0_0.SetGroupId(arg0_5, arg1_5)
	arg0_5.groupId = arg1_5
end

function var0_0.onBackPressed(arg0_6)
	if arg0_6.recordState then
		triggerButton(arg0_6.btnFilm)

		return
	end

	if arg0_6.activeSetting then
		triggerButton(arg0_6._tf:Find("Center/Settings/Back"))

		return
	end

	arg0_6:closeView()
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._tf:Find("Center/Normal/Back"), function()
		arg0_7:onBackPressed()
	end, SFX_CANCEL)

	local var0_7 = arg0_7.normalPanel:Find("Zoom/Slider")

	setSlider(var0_7, 0, 1, 0)
	onSlider(arg0_7, var0_7, function(arg0_9)
		arg0_7.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetPhotoCameraHeight", arg0_9)
	end)
	setActive(var0_7, false)

	local var1_7 = arg0_7._tf:Find("Center/Stick")

	setActive(var1_7, false)

	arg0_7.activeSetting = false

	onButton(arg0_7, arg0_7._tf:Find("Center/Normal/Settings"), function()
		arg0_7.activeSetting = true

		quickPlayAnimation(arg0_7._tf:Find("Center"), "anim_dorm3d_photo_normal_out")
		arg0_7:UpdateActionPanel()
		arg0_7:UpdateCameraPanel()
		arg0_7:UpdateLightingPanel()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("Center/Settings/Back"), function()
		arg0_7.activeSetting = false

		quickPlayAnimation(arg0_7._tf:Find("Center"), "anim_dorm3d_photo_normal_in")
	end, SFX_CANCEL)

	arg0_7.hideUI = false

	onButton(arg0_7, arg0_7.btnHideUI, function()
		if arg0_7.hideUI then
			return
		end

		setActive(arg0_7.hideuiMask, true)
		setActive(arg0_7.centerPanel, false)

		arg0_7.hideUI = true
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.hideuiMask, function()
		if not arg0_7.hideUI then
			return
		end

		setActive(arg0_7.centerPanel, true)
		setActive(arg0_7.hideuiMask, false)

		arg0_7.hideUI = false
	end)
	onButton(arg0_7, arg0_7.btnReset, function()
		arg0_7.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetPhotoCameraPosition")
	end, SFX_PANEL)

	arg0_7.recordState = false

	onButton(arg0_7, arg0_7.btnFilm, function()
		local function var0_15(arg0_16)
			setActive(arg0_7.centerPanel, arg0_16)

			arg0_7:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_16 and 1 or 0
		end

		if not arg0_7.recordState then
			local function var1_15(arg0_17)
				if arg0_17 ~= -1 then
					var0_15(true)

					arg0_7.recordState = false

					LeanTween.moveX(arg0_7.stopRecBtn, arg0_7.stopRecBtn.rect.width, 0.15)
				end
			end

			local function var2_15(arg0_18)
				warning("开始录屏结果：" .. tostring(arg0_18))
			end

			local function var3_15()
				setActive(arg0_7.stopRecBtn, true)
				LeanTween.moveX(arg0_7.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)
					arg0_7.ysScreenRecorder:BeforeStart()
					arg0_7.ysScreenRecorder:StartRecord(var2_15, var1_15)
				end))

				if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
					print("start recording : play sound")
					NotificationMgr.Inst:PlayStartRecordSound()
				end
			end

			seriesAsync({
				function(arg0_21)
					CameraHelper.Request3DDorm(arg0_21, nil)
				end,
				function(arg0_22)
					arg0_7.recordState = true

					var0_15(false)

					local var0_22 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_22 or var0_22 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_7:findTF("Text", arg0_7.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_7, arg0_7.videoTipPanel, function()
							setActive(arg0_7.videoTipPanel, false)
							var3_15()
						end)
						setActive(arg0_7.videoTipPanel, true)
					else
						var3_15()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.stopRecBtn, function()
		arg0_7.recordState = false

		local function var0_24(arg0_25)
			warning("结束录屏结果：" .. tostring(arg0_25))
		end

		local function var1_24(arg0_26)
			setActive(arg0_7.centerPanel, arg0_26)

			arg0_7:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_26 and 1 or 0
		end

		if not LeanTween.isTweening(go(arg0_7.stopRecBtn)) then
			LeanTween.moveX(arg0_7.stopRecBtn, arg0_7.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_7.stopRecBtn, false)
				seriesAsync({
					function(arg0_28)
						arg0_7.ysScreenRecorder:StopRecord(var0_24)

						if PLATFORM == PLATFORM_ANDROID then
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("word_save_video"),
								onNo = function()
									arg0_7.ysScreenRecorder:DiscardVideo()
								end,
								onYes = function()
									local var0_30 = arg0_7.ysScreenRecorder:GetVideoFilePath()

									MediaSaver.SaveVideoWithPath(var0_30)
								end
							})
						end

						var1_24(true)
						var0_0.SetMute(false)

						local var0_28 = arg0_7.room:GetCameraZones()[arg0_7.zoneIndex]
						local var1_28 = Dorm3dCameraAnim.New({
							configId = arg0_7.animID
						})

						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_7.scene.apartment:GetConfigID(), 2, arg0_7.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_28:GetName(), var1_28:GetStateName(), arg0_7.cameraSettings.depthOfField.focusDistance.value, arg0_7.cameraSettings.depthOfField.blurRadius.value, arg0_7.cameraSettings.postExposure.value, arg0_7.cameraSettings.contrast.value, arg0_7.cameraSettings.saturate.value)))
					end
				})
			end))
		end
	end)
	setActive(arg0_7.stopRecBtn, false)
	onButton(arg0_7, arg0_7._tf:Find("RightTop/Film/Switch"), function()
		GetOrAddComponent(arg0_7._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = false

		quickPlayAnimation(arg0_7._tf:Find("RightTop"), "anim_dorm3d_photo_FtoS")
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("RightTop/Shot/Shot"), function()
		local function var0_32(arg0_33)
			setActive(arg0_7.centerPanel, arg0_33)
			setActive(arg0_7._tf:Find("RightTop"), arg0_33)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_33)
			end
		end

		local function var1_32(arg0_34)
			warning("截图结果：" .. tostring(arg0_34))
		end

		local function var2_32(arg0_35, arg1_35)
			arg0_7:emit(Dorm3dPhotoMediator.SHARE_PANEL, arg1_35, arg0_35)

			if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
				print("start photo : play sound")
				NotificationMgr.Inst:PlayShutterSound()
			end

			local var0_35 = arg0_7.room:GetCameraZones()[arg0_7.zoneIndex]
			local var1_35 = Dorm3dCameraAnim.New({
				configId = arg0_7.animID
			})

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_7.scene.apartment:GetConfigID(), 1, arg0_7.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_35:GetName(), var1_35:GetStateName(), arg0_7.cameraSettings.depthOfField.focusDistance.value, arg0_7.cameraSettings.depthOfField.blurRadius.value, arg0_7.cameraSettings.postExposure.value, arg0_7.cameraSettings.contrast.value, arg0_7.cameraSettings.saturate.value)))
		end

		local var3_32 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32):TakePhoto(arg0_7.mainCamera)
		local var4_32 = Tex2DExtension.EncodeToJPG(var3_32)

		var1_32(true)
		var2_32(var4_32, var3_32)
	end, "ui-dorm_photograph")

	GetOrAddComponent(arg0_7._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = false

	onButton(arg0_7, arg0_7._tf:Find("RightTop/Shot/Switch"), function()
		GetOrAddComponent(arg0_7._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = true

		quickPlayAnimation(arg0_7._tf:Find("RightTop"), "anim_dorm3d_photo_StoF")
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.btnAnimSpeed, function()
		setActive(arg0_7.listAnimSpeed, not isActive(arg0_7.listAnimSpeed))
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.btnZone, function()
		local var0_38 = isActive(arg0_7.listZones)

		setActive(arg0_7.listZones, not var0_38)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.zoneMask, function()
		setActive(arg0_7.listZones, false)
	end)
	onButton(arg0_7, arg0_7.btnAr, function()
		arg0_7.ARchecker:StartCheck(function(arg0_41)
			if PLATFORM == PLATFORM_WINDOWSEDITOR then
				arg0_41 = -1
			end

			originalPrint("AR CODE: " .. arg0_41)
			arg0_7:emit(Dorm3dPhotoMediator.GO_AR, arg0_41)
		end)
	end)
	onButton(arg0_7, arg0_7.btnMove, function()
		arg0_7.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchPhotoCamera")

		arg0_7.freeMode = not arg0_7.freeMode

		setActive(var0_7, arg0_7.freeMode)
		setActive(var1_7, arg0_7.freeMode)
		setActive(arg0_7.btnMove:Find("Selected"), arg0_7.freeMode)
	end)
	onButton(arg0_7, arg0_7.btnMenuSmall, function()
		setActive(arg0_7.btnMenuSmall, false)
		setActive(arg0_7.btnMenu, true)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.btnMenu:Find("Collapse"), function()
		setActive(arg0_7.btnMenu, false)
		setActive(arg0_7.btnMenuSmall, true)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.btnMenu, function()
		setActive(arg0_7.skinSelectPanel, true)
		arg0_7:UpdateSkinList()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.skinSelectPanel:Find("BG/Close"), function()
		setActive(arg0_7.skinSelectPanel, false)
	end, SFX_PANEL)

	arg0_7.activePanel = 1

	local var2_7 = {
		{
			btn = arg0_7.btnAction,
			On = function()
				arg0_7:UpdateActionPanel()
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_7.btnCamera,
			On = function()
				arg0_7:UpdateCameraPanel()
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_7.btnLighting,
			On = function()
				arg0_7:UpdateLightingPanel()
			end,
			Off = function()
				return
			end
		}
	}

	table.Ipairs(var2_7, function(arg0_53, arg1_53)
		onToggle(arg0_7, arg1_53.btn, function(arg0_54)
			if not arg0_54 then
				return
			end

			table.Ipairs(var2_7, function(arg0_55, arg1_55)
				if arg0_55 == arg0_53 then
					return
				end

				arg1_55.Off()
			end)

			arg0_7.activePanel = arg0_53

			arg1_53.On()
		end, SFX_PANEL)
	end)
	;(function()
		local var0_56 = {
			arg0_7.panelAction:Find("Layout/Title/Regular"),
			arg0_7.panelAction:Find("Layout/Title/Special")
		}

		triggerToggle(var0_56[1], true)
	end)()
	;(function()
		local var0_57 = {
			arg0_7.panelLightning:Find("Layout/Title/Filter")
		}

		triggerToggle(var0_57[1], true)
	end)()

	arg0_7.zoneIndex = 1

	arg0_7:InitData()
	arg0_7:FirstEnterZone()
	triggerToggle(var2_7[arg0_7.activePanel].btn, true)
	arg0_7:UpdateZoneList()
end

function var0_0.InitData(arg0_58)
	arg0_58.cameraSettings = Clone(arg0_58.scene:GetCameraSettings())
	arg0_58.settingHideCharacter = false
	arg0_58.settingFaceCamera = true
	arg0_58.settingFilterIndex = nil
	arg0_58.settingFilterStrength = 1

	arg0_58:RefreshData()
end

function var0_0.RefreshData(arg0_59)
	local var0_59 = arg0_59.room:GetCameraZones()[arg0_59.zoneIndex]

	arg0_59.animID = var0_59:GetRegularAnimsByShipId(arg0_59.groupId)[1]:GetConfigID()

	local function var1_59(arg0_60, arg1_60)
		arg0_60.min = arg1_60[1]
		arg0_60.max = arg1_60[2]
		arg0_60.value = math.clamp(arg0_60.value, arg1_60[1], arg1_60[2])
	end

	var1_59(arg0_59.cameraSettings.depthOfField.focusDistance, var0_59:GetFocusDistanceRange())
	var1_59(arg0_59.cameraSettings.depthOfField.blurRadius, var0_59:GetDepthOfFieldBlurRange())
	var1_59(arg0_59.cameraSettings.postExposure, var0_59:GetExposureRange())
	var1_59(arg0_59.cameraSettings.contrast, var0_59:GetContrastRange())
	var1_59(arg0_59.cameraSettings.saturate, var0_59:GetSaturationRange())

	arg0_59.animSpeeds = var0_59:GetAnimSpeeds()
	arg0_59.animSpeed = 1
end

function var0_0.FirstEnterZone(arg0_61)
	local var0_61 = arg0_61.room:GetCameraZones()[arg0_61.zoneIndex]
	local var1_61 = Dorm3dCameraAnim.New({
		configId = arg0_61.animID
	})

	arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnterPhotoMode", var0_61, var1_61:GetStateName())
	arg0_61:UpdateAnimSpeedPanel()
end

function var0_0.SwitchZone(arg0_62)
	local var0_62 = arg0_62.room:GetCameraZones()[arg0_62.zoneIndex]
	local var1_62 = Dorm3dCameraAnim.New({
		configId = arg0_62.animID
	})

	arg0_62.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCameraZone", var0_62, var1_62:GetStateName())

	if arg0_62.timerAnim then
		arg0_62.timerAnim:Stop()

		arg0_62.timerAnim = nil
	end

	arg0_62.animPlaying = nil

	arg0_62:UpdateActionPanel()
	arg0_62:UpdateCameraPanel()
	arg0_62:UpdateLightingPanel()
	arg0_62:UpdateAnimSpeedPanel()
	arg0_62.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", arg0_62.animSpeed)
end

function var0_0.UpdateZoneList(arg0_63)
	local var0_63 = arg0_63.room:GetCameraZones()

	local function var1_63()
		setText(arg0_63.btnZone:Find("Text"), var0_63[arg0_63.zoneIndex]:GetName())
		UIItemList.StaticAlign(arg0_63.listZones:Find("List"), arg0_63.listZones:Find("List"):GetChild(0), #var0_63, function(arg0_65, arg1_65, arg2_65)
			if arg0_65 ~= UIItemList.EventUpdate then
				return
			end

			arg1_65 = arg1_65 + 1

			local var0_65 = var0_63[arg1_65]

			setText(arg2_65:Find("Name"), var0_65:GetName())

			local var1_65 = arg0_63.zoneIndex == arg1_65 and Color.NewHex("5CCAFF") or Color.NewHex("FFFFFF99")

			setTextColor(arg2_65:Find("Name"), var1_65)
			setActive(arg2_65:Find("Line"), arg1_65 < #var0_63)
		end)
	end

	var1_63()
	UIItemList.StaticAlign(arg0_63.listZones:Find("List"), arg0_63.listZones:Find("List"):GetChild(0), #var0_63, function(arg0_66, arg1_66, arg2_66)
		if arg0_66 ~= UIItemList.EventUpdate then
			return
		end

		arg1_66 = arg1_66 + 1

		onButton(arg0_63, arg2_66, function()
			if arg0_63.zoneIndex == arg1_66 then
				return
			end

			arg0_63.zoneIndex = arg1_66

			arg0_63:RefreshData()
			arg0_63:SwitchZone()
			setActive(arg0_63.listZones, false)
			var1_63()
		end, SFX_PANEL)
	end)
end

local var2_0 = 0.2

function var0_0.UpdateActionPanel(arg0_68)
	if not arg0_68.activeSetting then
		return
	end

	if arg0_68.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_68 = arg0_68.room:GetCameraZones()[arg0_68.zoneIndex]
	local var1_68 = var0_68:GetRegularAnimsByShipId(arg0_68.groupId)
	local var2_68 = arg0_68.panelAction:Find("Layout/Regular/Scroll/Viewport/Content")
	local var3_68 = var0_68:GetAllSpecialList(arg0_68.room.id)
	local var4_68 = arg0_68.panelAction:Find("Layout/Special/Scroll/Viewport/Content")
	local var5_68 = #var3_68 > 0

	setActive(arg0_68.panelAction:Find("Layout/Title/Special"), var5_68)

	local function var6_68()
		UIItemList.StaticAlign(var2_68, var2_68:GetChild(0), #var1_68, function(arg0_70, arg1_70, arg2_70)
			if arg0_70 ~= UIItemList.EventUpdate then
				return
			end

			arg1_70 = arg1_70 + 1

			local var0_70 = var1_68[arg1_70]

			setActive(arg2_70:Find("Selected"), var0_70:GetConfigID() == arg0_68.animID)
			setActive(arg2_70:Find("Slider"), var0_70:GetConfigID() == arg0_68.animID and tobool(arg0_68.timerAnim))
		end)
		UIItemList.StaticAlign(var4_68, var4_68:GetChild(0), #var3_68, function(arg0_71, arg1_71, arg2_71)
			if arg0_71 ~= UIItemList.EventUpdate then
				return
			end

			arg1_71 = arg1_71 + 1

			local var0_71 = var3_68[arg1_71].anims
			local var1_71 = arg2_71:Find("Actions")

			UIItemList.StaticAlign(var1_71, var1_71:GetChild(0), #var0_71, function(arg0_72, arg1_72, arg2_72)
				if arg0_72 ~= UIItemList.EventUpdate then
					return
				end

				arg1_72 = arg1_72 + 1

				local var0_72 = var0_71[arg1_72]

				setActive(arg2_72:Find("Selected"), var0_72:GetConfigID() == arg0_68.animID)
				setActive(arg2_72:Find("Slider"), var0_72:GetConfigID() == arg0_68.animID and tobool(arg0_68.timerAnim))
			end)
		end)
	end

	local function var7_68(arg0_73, arg1_73)
		if arg0_68.animPlaying then
			return
		end

		local var0_73 = arg0_73:GetConfigID()

		if arg0_68.animID == var0_73 then
			return
		end

		local var1_73 = arg0_68:GetAnimPlayList(var0_73)
		local var2_73 = Dorm3dCameraAnim.New({
			configId = arg0_68.animID
		}):GetFinishAnimID()

		arg0_68.animID = var0_73

		var6_68()
		arg0_68:BlockActionPanel(true)

		arg0_68.animPlaying = true

		local var3_73 = (table.indexof(var1_73, _.detect(var1_73, function(arg0_74)
			return arg0_74:GetConfigID() == var2_73
		end)) or 0) + 1
		local var4_73 = _.rest(var1_73, var3_73)
		local var5_73 = arg1_73:Find("Slider"):GetComponent(typeof(Slider))

		setActive(arg1_73:Find("Slider"), true)

		local function var6_73()
			setActive(arg1_73:Find("Selected"), true)
			setActive(arg1_73:Find("Slider"), false)
			arg0_68:BlockActionPanel(false)

			arg0_68.animPlaying = nil
		end

		if #var4_73 == 0 then
			var6_73()

			return
		end

		local var7_73 = _.reduce(var4_73, 0, function(arg0_76, arg1_76)
			return arg0_76 + math.max(var2_0, arg1_76:GetAnimTime())
		end)

		if arg0_68.timerAnim then
			arg0_68.timerAnim:Stop()
		end

		arg0_68.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_73,
			totalTime = var7_73,
			startStamp = Time.time
		}
		arg0_68.timerAnim = FrameTimer.New(function()
			local var0_77 = arg0_68.animInfo
			local var1_77 = var0_77.animPlayList[var0_77.index]
			local var2_77 = math.max(var2_0, var1_77:GetAnimTime())
			local var3_77 = var0_77.startStamp
			local var4_77 = Time.time
			local var5_77 = math.min(1, var0_77.ratio + (var4_77 - var3_77) * arg0_68.animSpeed / var2_77)
			local var6_77 = var0_77.passedTime + var2_77 * var5_77

			var5_73.value = var6_77 / var7_73

			if var5_77 < 1 then
				return
			end

			var0_77.index = var0_77.index + 1
			var0_77.ratio = 0
			var0_77.passedTime = var0_77.passedTime + var2_77
			var0_77.startStamp = var4_77

			local var7_77 = var1_77:GetStartPoint()

			if #var7_77 > 0 then
				arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var7_77)
			end

			arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

			if var0_77.index > #var0_77.animPlayList then
				var6_73()
				arg0_68.timerAnim:Stop()

				arg0_68.timerAnim = nil
				arg0_68.animInfo = nil

				return
			end

			local var8_77 = var0_77.animPlayList[var0_77.index]

			arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var8_77:GetStateName())
		end, 1, -1)

		local var8_73 = arg0_68.animInfo.animPlayList[1]

		if var3_73 == 1 then
			arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCurrentAnim", var8_73:GetStateName())
			onNextTick(function()
				local var0_78 = var8_73:GetStartPoint()

				if #var0_78 == 0 then
					var0_78 = var0_68:GetWatchCameraName()
				end

				arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var0_78)
				arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

				if arg0_68.freeMode then
					local var1_78 = arg0_68.scene.cameras[arg0_68.scene.CAMERA.PHOTO_FREE]
					local var2_78 = var1_78:GetComponent(typeof(UnityEngine.CharacterController))
					local var3_78 = var1_78.transform.forward

					var3_78.y = 0

					var3_78:Normalize()

					local var4_78 = var3_78 * -0.01

					var2_78:Move(var4_78)
					var2_78:Move(-var4_78)
				end
			end)
		else
			arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var8_73:GetStateName())
		end

		arg0_68.timerAnim:Start()
	end

	UIItemList.StaticAlign(var2_68, var2_68:GetChild(0), #var1_68, function(arg0_79, arg1_79, arg2_79)
		if arg0_79 ~= UIItemList.EventUpdate then
			return
		end

		arg1_79 = arg1_79 + 1

		local var0_79 = var1_68[arg1_79]

		setText(arg2_79:Find("Name"), var0_79:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_79:GetZoneIcon()), "", arg2_79:Find("Icon"))
		setActive(arg2_79:Find("Slider"), false)
		setActive(arg2_79:Find("Selected"), false)
		onButton(arg0_68, arg2_79, function()
			var7_68(var0_79, arg2_79)
		end)
	end)

	local function var8_68()
		UIItemList.StaticAlign(var4_68, var4_68:GetChild(0), #var3_68, function(arg0_82, arg1_82, arg2_82)
			if arg0_82 ~= UIItemList.EventUpdate then
				return
			end

			arg1_82 = arg1_82 + 1

			local var0_82 = var3_68[arg1_82].anims
			local var1_82 = arg2_82:Find("Actions")

			UIItemList.StaticAlign(var1_82, var1_82:GetChild(0), #var0_82, function(arg0_83, arg1_83, arg2_83)
				if arg0_83 ~= UIItemList.EventUpdate then
					return
				end

				arg1_83 = arg1_83 + 1

				local var0_83 = var0_82[arg1_83]

				setActive(arg2_83:Find("Selected"), var0_83:GetConfigID() == arg0_68.animID)
				setActive(arg2_83:Find("Slider"), var0_83:GetConfigID() == arg0_68.animID and tobool(arg0_68.timerAnim))
			end)
		end)
	end

	local function var9_68()
		UIItemList.StaticAlign(var4_68, var4_68:GetChild(0), #var3_68, function(arg0_85, arg1_85, arg2_85)
			if arg0_85 ~= UIItemList.EventUpdate then
				return
			end

			arg1_85 = arg1_85 + 1

			setActive(arg2_85:Find("Button/Active"), arg0_68.settingSpecialFurnitureIndex == arg1_85)
			setActive(arg2_85:Find("Actions"), arg0_68.settingSpecialFurnitureIndex == arg1_85)
		end)
		var8_68()
	end

	local var10_68 = arg0_68.room:GetCameraZones()[arg0_68.zoneIndex]

	local function var11_68(arg0_86, arg1_86)
		local var0_86 = arg1_86:Find("Actions")
		local var1_86 = arg0_86.anims

		UIItemList.StaticAlign(var0_86, var0_86:GetChild(0), #var1_86, function(arg0_87, arg1_87, arg2_87)
			if arg0_87 ~= UIItemList.EventUpdate then
				return
			end

			arg1_87 = arg1_87 + 1

			local var0_87 = var1_86[arg1_87]
			local var1_87 = var10_68:CheckFurnitureIdInZone(arg0_86.furnitureId)
			local var2_87 = arg0_68.room:IsFurnitureSetIn(arg0_86.furnitureId)
			local var3_87 = var1_87 and var2_87

			SetActive(arg2_87:Find("Other"), not var3_87)
			SetActive(arg2_87:Find("Name"), var3_87)

			if var3_87 then
				onButton(arg0_68, arg2_87, function()
					arg0_68.room:ReplaceFurniture(arg0_86.slotId, arg0_86.furnitureId)
					arg0_68.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RefreshSlots", arg0_68.room)
					var7_68(var0_87, arg2_87)
				end)
				setText(arg2_87:Find("Name"), var0_87:GetName())
			else
				removeOnButton(arg2_87)

				if not var1_87 then
					local var4_87 = var0_87:GetZoneName()

					warnText = i18n("dorm3d_photo_active_zone", var4_87)
				else
					warnText = i18n("dorm3d_furniture_replace_tip")
				end

				setText(arg2_87:Find("Other/Content"), warnText)
			end

			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_87:GetZoneIcon()), "", arg2_87:Find("Icon"))
			setActive(arg2_87:Find("Slider"), false)
			setActive(arg2_87:Find("Selected"), false)
		end)
	end

	setActive(var4_68, #var3_68 > 0)
	UIItemList.StaticAlign(var4_68, var4_68:GetChild(0), #var3_68, function(arg0_89, arg1_89, arg2_89)
		if arg0_89 ~= UIItemList.EventUpdate then
			return
		end

		arg1_89 = arg1_89 + 1

		local var0_89 = var3_68[arg1_89]
		local var1_89 = Dorm3dFurniture.New({
			configId = var0_89.furnitureId
		})
		local var2_89 = tobool(_.detect(arg0_68.room:GetFurnitures(), function(arg0_90)
			return arg0_90:GetConfigID() == var0_89.furnitureId
		end))

		setText(arg2_89:Find("Button/Name"), var1_89:GetName())
		GetImageSpriteFromAtlasAsync(var1_89:GetIcon(), "", arg2_89:Find("Button/Icon"))
		setActive(arg2_89:Find("Button/Lock"), not var2_89)
		setActive(arg2_89:Find("Button/BG"), var2_89)

		local var3_89 = var10_68:CheckFurnitureIdInZone(var0_89.furnitureId)
		local var4_89

		if var3_89 then
			var4_89 = Color.New(1, 1, 1, 0.850980392156863)
		else
			var4_89 = Color.New(0.788235294117647, 0.788235294117647, 0.788235294117647, 0.850980392156863)
		end

		setImageColor(arg2_89:Find("Button/BG"), var4_89)
		onButton(arg0_68, arg2_89:Find("Button"), function()
			if not var2_89 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_furniture_locked"))

				return
			end

			if arg0_68.settingSpecialFurnitureIndex == arg1_89 then
				arg0_68.settingSpecialFurnitureIndex = nil
			else
				arg0_68.settingSpecialFurnitureIndex = arg1_89
			end

			var11_68(var0_89, arg2_89, arg1_89)
			var9_68()
		end)
	end)
	var9_68()
	var6_68()
end

function var0_0.BlockActionPanel(arg0_92, arg1_92)
	return
end

function var0_0.GetAnimPlayList(arg0_93, arg1_93)
	local var0_93 = arg1_93
	local var1_93 = {}
	local var2_93 = 10

	while true do
		local var3_93 = Dorm3dCameraAnim.New({
			configId = var0_93
		})

		if not var3_93 then
			return var1_93
		end

		table.insert(var1_93, 1, var3_93)

		var0_93 = var3_93:GetPreAnimID()

		if var0_93 == 0 then
			return var1_93
		end

		var2_93 = var2_93 - 1

		assert(var2_93 > 0)
	end
end

function var0_0.UpdateCameraPanel(arg0_94)
	if not arg0_94.activeSetting then
		return
	end

	if arg0_94.activePanel ~= var0_0.PANEL.CAMERA then
		return
	end

	;(function()
		local var0_95 = arg0_94.panelCamera:Find("Layout/DepthOfField/Switch/Toggle")

		triggerToggle(var0_95, arg0_94.cameraSettings.depthOfField.enabled)
		onToggle(arg0_94, var0_95, function(arg0_96)
			arg0_94.cameraSettings.depthOfField.enabled = arg0_96

			setActive(arg0_94.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_94.cameraSettings.depthOfField.enabled)
			arg0_94:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	setActive(arg0_94.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_94.cameraSettings.depthOfField.enabled)
	;(function()
		local var0_97 = arg0_94.cameraSettings.depthOfField.focusDistance
		local var1_97 = arg0_94.panelCamera:Find("Layout/DepthOfField/DepthOfField/FocusDistance/Slider")

		setSlider(var1_97, var0_97.min, var0_97.max, var0_97.value)
		onSlider(arg0_94, var1_97, function(arg0_98)
			var0_97.value = arg0_98

			arg0_94:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_99 = arg0_94.cameraSettings.depthOfField.blurRadius
		local var1_99 = arg0_94.panelCamera:Find("Layout/DepthOfField/DepthOfField/BlurRadius/Slider")

		setSlider(var1_99, var0_99.min, var0_99.max, var0_99.value)
		onSlider(arg0_94, var1_99, function(arg0_100)
			var0_99.value = arg0_100

			arg0_94:RefreshCamera()
		end)
	end)()

	local var0_94 = {
		"PostExposure",
		"Saturation",
		"Contrast"
	}

	arg0_94.paramIndex = arg0_94.paramIndex or 1

	local function var1_94()
		table.Ipairs(var0_94, function(arg0_102, arg1_102)
			local var0_102 = arg0_94.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_102 - 1)

			setActive(var0_102:Find("Selected"), arg0_102 == arg0_94.paramIndex)
			setActive(arg0_94.panelCamera:Find("Layout/Paramaters/" .. arg1_102), arg0_102 == arg0_94.paramIndex)
		end)
	end

	table.Ipairs(var0_94, function(arg0_103, arg1_103)
		local var0_103 = arg0_94.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_103 - 1)

		onButton(arg0_94, var0_103, function()
			arg0_94.paramIndex = arg0_103

			var1_94()
		end, SFX_PANEL)
	end)
	var1_94()
	;(function()
		local var0_105 = arg0_94.cameraSettings.postExposure
		local var1_105 = arg0_94.panelCamera:Find("Layout/Paramaters/PostExposure/PostExposure/Slider")
		local var2_105 = var1_105:Find("Background/Fill")

		onSlider(arg0_94, var1_105, function(arg0_106)
			var0_105.value = arg0_106

			local var0_106 = (arg0_106 - var0_105.min) / (var0_105.max - var0_105.min)
			local var1_106 = math.min(var0_106, 0.5)
			local var2_106 = math.max(var0_106, 0.5)

			var2_105.anchorMin = Vector2.New(var1_106, 0)
			var2_105.anchorMax = Vector2.New(var2_106, 1)
			var2_105.offsetMin = Vector2.zero
			var2_105.offsetMax = Vector2.zero

			arg0_94:RefreshCamera()
		end)
		setSlider(var1_105, var0_105.min, var0_105.max, var0_105.value)
	end)()
	;(function()
		local var0_107 = arg0_94.cameraSettings.contrast
		local var1_107 = arg0_94.panelCamera:Find("Layout/Paramaters/Contrast/Contrast/Slider")
		local var2_107 = var1_107:Find("Background/Fill")

		onSlider(arg0_94, var1_107, function(arg0_108)
			var0_107.value = arg0_108

			local var0_108 = (arg0_108 - var0_107.min) / (var0_107.max - var0_107.min)
			local var1_108 = math.min(var0_108, 0.5)
			local var2_108 = math.max(var0_108, 0.5)

			var2_107.anchorMin = Vector2.New(var1_108, 0)
			var2_107.anchorMax = Vector2.New(var2_108, 1)
			var2_107.offsetMin = Vector2.zero
			var2_107.offsetMax = Vector2.zero

			arg0_94:RefreshCamera()
		end)
		setSlider(var1_107, var0_107.min, var0_107.max, var0_107.value)
	end)()
	;(function()
		local var0_109 = arg0_94.cameraSettings.saturate
		local var1_109 = arg0_94.panelCamera:Find("Layout/Paramaters/Saturation/Saturation/Slider")
		local var2_109 = var1_109:Find("Background/Fill")

		onSlider(arg0_94, var1_109, function(arg0_110)
			var0_109.value = arg0_110

			local var0_110 = (arg0_110 - var0_109.min) / (var0_109.max - var0_109.min)
			local var1_110 = math.min(var0_110, 0.5)
			local var2_110 = math.max(var0_110, 0.5)

			var2_109.anchorMin = Vector2.New(var1_110, 0)
			var2_109.anchorMax = Vector2.New(var2_110, 1)
			var2_109.offsetMin = Vector2.zero
			var2_109.offsetMax = Vector2.zero

			arg0_94:RefreshCamera()
		end)
		setSlider(var1_109, var0_109.min, var0_109.max, var0_109.value)
	end)()
	;(function()
		local var0_111 = arg0_94.panelCamera:Find("Layout/Other/FaceCamera/Toggle")

		triggerToggle(var0_111, arg0_94.settingFaceCamera)
		onToggle(arg0_94, var0_111, function(arg0_112)
			arg0_94.settingFaceCamera = arg0_112

			arg0_94.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableCurrentHeadIK", arg0_112)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_113 = arg0_94.panelCamera:Find("Layout/Other/HideCharacter/Toggle")

		triggerToggle(var0_113, arg0_94.settingHideCharacter)
		onToggle(arg0_94, var0_113, function(arg0_114)
			arg0_94.settingHideCharacter = arg0_114

			if arg0_114 then
				arg0_94.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			else
				arg0_94.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0_0.RefreshCamera(arg0_115)
	arg0_115.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SettingCamera", arg0_115.cameraSettings)
end

function var0_0.UpdateAnimSpeedPanel(arg0_116)
	local function var0_116()
		if not arg0_116.timerAnim then
			return
		end

		local var0_117 = arg0_116.animInfo
		local var1_117 = var0_117.animPlayList[var0_117.index]
		local var2_117 = math.max(var2_0, var1_117:GetAnimTime())
		local var3_117 = var0_117.startStamp
		local var4_117 = Time.time

		var0_117.ratio = math.min(1, var0_117.ratio + (var4_117 - var3_117) * arg0_116.animSpeed / var2_117)
		var0_117.startStamp = var4_117
	end

	local var1_116 = arg0_116.animSpeeds

	UIItemList.StaticAlign(arg0_116.listAnimSpeed, arg0_116.listAnimSpeed:GetChild(0), #var1_116, function(arg0_118, arg1_118, arg2_118)
		if arg0_118 ~= UIItemList.EventUpdate then
			return
		end

		arg1_118 = #var1_116 - arg1_118

		local var0_118 = var1_116[arg1_118]

		setText(arg2_118:Find("Name"), var0_118)
		setText(arg2_118:Find("Selected"), var0_118)
		setActive(arg2_118:Find("Line"), arg1_118 ~= #var1_116)
		onButton(arg0_116, arg2_118, function()
			if arg0_116.animSpeed == var0_118 then
				return
			end

			var0_116()

			arg0_116.animSpeed = var0_118

			arg0_116.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_118)
			arg0_116:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0_116, arg0_116.btnFreeze, function()
		local var0_120 = 0

		if arg0_116.animSpeed ~= 0 then
			arg0_116.lastAnimSpeed = arg0_116.animSpeed
		else
			var0_120 = arg0_116.lastAnimSpeed or 1
			arg0_116.lastAnimSpeed = nil
		end

		var0_116()

		arg0_116.animSpeed = var0_120

		arg0_116.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_120)
		arg0_116:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_116.listAnimSpeed, arg0_116.listAnimSpeed:GetChild(0), #var1_116, function(arg0_121, arg1_121, arg2_121)
		if arg0_121 ~= UIItemList.EventUpdate then
			return
		end

		arg1_121 = #var1_116 - arg1_121

		local var0_121 = var1_116[arg1_121]

		setActive(arg2_121:Find("Name"), arg0_116.animSpeed ~= var0_121)
		setActive(arg2_121:Find("Selected"), arg0_116.animSpeed == var0_121)
	end)
	setActive(arg0_116.btnFreeze:Find("Icon"), arg0_116.animSpeed ~= 0)
	setActive(arg0_116.btnFreeze:Find("Selected"), arg0_116.animSpeed == 0)
	setText(arg0_116.textAnimSpeed, i18n("dorm3d_photo_animspeed", string.format("%.1f", arg0_116.animSpeed)))
end

function var0_0.UpdateLightingPanel(arg0_122)
	if not arg0_122.activeSetting then
		return
	end

	if arg0_122.activePanel ~= var0_0.PANEL.LIGHTING then
		return
	end

	local var0_122 = {}

	for iter0_122, iter1_122 in ipairs(pg.dorm3d_camera_volume_template.all) do
		table.insert(var0_122, iter1_122)
	end

	table.sort(var0_122, function(arg0_123, arg1_123)
		return arg0_123 < arg1_123
	end)

	local function var1_122()
		if not arg0_122.settingFilterIndex then
			arg0_122.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")

			return
		end

		local var0_124 = pg.dorm3d_camera_volume_template[var0_122[arg0_122.settingFilterIndex]]

		arg0_122.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetVolumeProfile", var0_124.volume, arg0_122.settingFilterStrength)
	end

	UIItemList.StaticAlign(arg0_122.panelLightning:Find("Layout/Filter/List"), arg0_122.panelLightning:Find("Layout/Filter/List"):GetChild(0), #var0_122, function(arg0_125, arg1_125, arg2_125)
		if arg0_125 ~= UIItemList.EventUpdate then
			return
		end

		arg1_125 = arg1_125 + 1

		local var0_125 = pg.dorm3d_camera_volume_template[var0_122[arg1_125]]

		setText(arg2_125:Find("Name"), var0_125.name)

		var0_125.icon = ""

		if var0_125.icon ~= "" then
			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_125.icon), "", arg2_125:Find("BG"))
		end

		if arg0_122.settingFilterIndex == arg1_125 then
			setActive(arg2_125:Find("Selected"), true)
		else
			setActive(arg2_125:Find("Selected"), false)
		end

		local var1_125, var2_125 = ApartmentProxy.CheckUnlockConfig(var0_125.unlock)

		setActive(arg2_125:Find("lock"), not var1_125)

		if not var1_125 then
			setText(arg2_125:Find("lock/Image/Text"), var0_125.unlock_text)
		end

		onButton(arg0_122, arg2_125, function()
			if not var1_125 then
				pg.TipsMgr.GetInstance():ShowTips(var2_125)

				return
			end

			local var0_126 = arg0_122.settingFilterIndex

			if arg0_122.settingFilterIndex ~= arg1_125 then
				arg0_122.settingFilterIndex = arg1_125
			else
				arg0_122.settingFilterIndex = nil
			end

			var1_122()

			if var0_126 then
				local var1_126 = arg0_122.panelLightning:Find("Layout/Filter/List"):GetChild(var0_126 - 1)

				setActive(var1_126:Find("Selected"), false)
			end

			if arg0_122.settingFilterIndex == arg1_125 then
				setActive(arg2_125:Find("Selected"), true)
			end
		end, SFX_PANEL)
	end)
	setActive(arg0_122.panelLightning:Find("Layout/Filter/Slider"), false)
end

function var0_0.UpdateSkinList(arg0_127)
	local var0_127 = arg0_127.scene.apartment:GetConfigID()
	local var1_127 = arg0_127.scene.ladyDict[var0_127]
	local var2_127 = var1_127.skinIdList
	local var3_127 = var1_127.skinId
	local var4_127 = {}
	local var5_127 = {}

	_.each(var2_127, function(arg0_128)
		if ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[arg0_128].unlock) then
			table.insert(var4_127, arg0_128)
		else
			table.insert(var5_127, arg0_128)
		end
	end)

	local function var6_127(arg0_129, arg1_129)
		local var0_129 = arg1_129 and var4_127 or var5_127

		UIItemList.StaticAlign(arg0_129, arg0_129:GetChild(0), #var0_129, function(arg0_130, arg1_130, arg2_130)
			if arg0_130 ~= UIItemList.EventUpdate then
				return
			end

			local var0_130 = var0_129[arg1_130 + 1]

			setActive(arg2_130:Find("Selected"), var0_130 == var3_127)
			setActive(arg2_130:Find("Lock"), not arg1_129)

			if not arg1_129 then
				setText(arg2_130:Find("Lock/Bar/Text"), pg.dorm3d_resource[var0_130].unlock_text)
			end

			arg0_127.loader:GetSpriteQuiet(string.format("dorm3dselect/apartment_skin_%d", var0_130), "", arg2_130:Find("Icon"))
			onButton(arg0_127, arg2_130, function()
				if not arg1_129 then
					local var0_131, var1_131 = ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[var0_130].unlock)

					pg.TipsMgr.GetInstance():ShowTips(var1_131)

					return
				end

				if var0_130 == var3_127 then
					return
				end

				local var2_131 = var0_130

				seriesAsync({
					function(arg0_132)
						if arg0_127.settingHideCharacter then
							arg0_127.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
						end

						arg0_127.scene:SwitchCharacterSkin(var1_127, var0_127, var2_131, arg0_132)
					end,
					function(arg0_133)
						setActive(var1_127.ladySafeCollider, true)

						if not arg0_127.animInfo then
							return arg0_133()
						end

						local var0_133 = arg0_127.animInfo

						for iter0_133 = #var0_133.animPlayList, 1, -1 do
							local var1_133 = var0_133.animPlayList[iter0_133]:GetStartPoint()

							if #var1_133 > 0 then
								arg0_127.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var1_133)

								break
							end

							if iter0_133 == 1 then
								local var2_133 = arg0_127.room:GetCameraZones()[arg0_127.zoneIndex]

								arg0_127.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var2_133:GetWatchCameraName())
							end
						end

						arg0_127.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

						local var3_133 = var0_133.animPlayList[#var0_133.animPlayList]
						local var4_133 = var3_133:GetAnimTime()

						arg0_127.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var3_133:GetStateName())
						arg0_127.scene.ladyDict[var0_127].ladyAnimator:Update(var4_133)
						arg0_127.timerAnim:Stop()

						arg0_127.timerAnim = nil
						arg0_127.animInfo = nil
						arg0_127.animPlaying = nil

						arg0_133()
					end,
					function()
						arg0_127:UpdateActionPanel()

						if arg0_127.settingHideCharacter then
							arg0_127.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
						end

						arg0_127:UpdateSkinList()
					end
				})
			end, SFX_PANEL)
		end)
	end

	var6_127(arg0_127.skinSelectPanel:Find("BG/Scroll/Content/Unlock/List"), true)
	var6_127(arg0_127.skinSelectPanel:Find("BG/Scroll/Content/Lock/List"), false)
end

function var0_0.SetMute(arg0_135)
	if arg0_135 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.willExit(arg0_136)
	arg0_136.loader:Clear()

	if arg0_136.timerAnim then
		arg0_136.timerAnim:Stop()

		arg0_136.timerAnim = nil
	end

	local var0_136 = arg0_136.scene.apartment:GetConfigID()
	local var1_136 = arg0_136.scene.ladyDict[var0_136]
	local var2_136 = var1_136.skinIdList

	if var1_136.skinId ~= var2_136[1] then
		arg0_136.scene:SwitchCharacterSkin(var1_136, var0_136, var2_136[1])
	end

	if arg0_136.animSpeed ~= 1 then
		arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", 1)
	end

	if arg0_136.settingHideCharacter then
		arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
	end

	if not arg0_136.settingFaceCamera then
		arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableCurrentHeadIK", true)
	end

	arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterLight")
	arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")
	arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCameraSettings")
	arg0_136.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ExitPhotoMode")
end

function var0_0.SetPhotoCameraSliderValue(arg0_137, arg1_137)
	local var0_137 = arg0_137.normalPanel:Find("Zoom/Slider")

	setSlider(var0_137, 0, 1, arg1_137)
end

function var0_0.SetPhotoStickDelta(arg0_138, arg1_138)
	arg1_138 = arg1_138 * 0.5

	local var0_138 = arg0_138._tf:Find("Center/Stick")
	local var1_138 = var0_138.rect.height
	local var2_138 = var0_138.rect.width
	local var3_138 = var0_138:Find("Handler")

	setAnchoredPosition(var3_138, Vector2.New(var1_138 * arg1_138.x, var2_138 * arg1_138.y))
end

return var0_0
