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

	local var0_6 = arg0_6.normalPanel:Find("Zoom/Slider")

	setSlider(var0_6, 0, 1, 0)
	onSlider(arg0_6, var0_6, function(arg0_8)
		arg0_6.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetPhotoCameraHeight", arg0_8)
	end)
	setActive(var0_6, false)

	local var1_6 = arg0_6._tf:Find("Center/Stick")

	setActive(var1_6, false)

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
		local function var0_14(arg0_15)
			setActive(arg0_6.centerPanel, arg0_15)

			arg0_6:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_15 and 1 or 0
		end

		if not arg0_6.recordState then
			local function var1_14(arg0_16)
				if arg0_16 ~= -1 then
					var0_14(true)

					arg0_6.recordState = false

					LeanTween.moveX(arg0_6.stopRecBtn, arg0_6.stopRecBtn.rect.width, 0.15)
				end
			end

			local function var2_14(arg0_17)
				warning("开始录屏结果：" .. tostring(arg0_17))
			end

			local function var3_14()
				setActive(arg0_6.stopRecBtn, true)
				LeanTween.moveX(arg0_6.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)
					arg0_6.ysScreenRecorder:BeforeStart()
					arg0_6.ysScreenRecorder:StartRecord(var2_14, var1_14)
				end))

				if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
					print("start recording : play sound")
					NotificationMgr.Inst:PlayStartRecordSound()
				end
			end

			seriesAsync({
				function(arg0_20)
					CameraHelper.Request3DDorm(arg0_20, nil)
				end,
				function(arg0_21)
					arg0_6.recordState = true

					var0_14(false)

					local var0_21 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_21 or var0_21 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_6:findTF("Text", arg0_6.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_6, arg0_6.videoTipPanel, function()
							setActive(arg0_6.videoTipPanel, false)
							var3_14()
						end)
						setActive(arg0_6.videoTipPanel, true)
					else
						var3_14()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.stopRecBtn, function()
		arg0_6.recordState = false

		local function var0_23(arg0_24)
			warning("结束录屏结果：" .. tostring(arg0_24))
		end

		local function var1_23(arg0_25)
			setActive(arg0_6.centerPanel, arg0_25)

			arg0_6:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_25 and 1 or 0
		end

		if not LeanTween.isTweening(go(arg0_6.stopRecBtn)) then
			LeanTween.moveX(arg0_6.stopRecBtn, arg0_6.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_6.stopRecBtn, false)
				seriesAsync({
					function(arg0_27)
						arg0_6.ysScreenRecorder:StopRecord(var0_23)

						if PLATFORM == PLATFORM_ANDROID then
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("word_save_video"),
								onNo = function()
									arg0_6.ysScreenRecorder:DiscardVideo()
								end,
								onYes = function()
									local var0_29 = arg0_6.ysScreenRecorder:GetVideoFilePath()

									MediaSaver.SaveVideoWithPath(var0_29)
								end
							})
						end

						var1_23(true)
						var0_0.SetMute(false)

						local var0_27 = arg0_6.room:GetCameraZones()[arg0_6.zoneIndex]
						local var1_27 = Dorm3dCameraAnim.New({
							configId = arg0_6.animID
						})

						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_6.scene.apartment:GetConfigID(), 2, arg0_6.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_27:GetName(), var1_27:GetStateName(), arg0_6.cameraSettings.depthOfField.focusDistance.value, arg0_6.cameraSettings.depthOfField.blurRadius.value, arg0_6.cameraSettings.postExposure.value, arg0_6.cameraSettings.contrast.value, arg0_6.cameraSettings.saturate.value)))
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
		local function var0_31(arg0_32)
			setActive(arg0_6.centerPanel, arg0_32)
			setActive(arg0_6._tf:Find("RightTop"), arg0_32)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_32)
			end
		end

		local function var1_31(arg0_33)
			warning("截图结果：" .. tostring(arg0_33))
		end

		local function var2_31(arg0_34, arg1_34)
			arg0_6:emit(Dorm3dPhotoMediator.SHARE_PANEL, arg1_34, arg0_34)

			if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
				print("start photo : play sound")
				NotificationMgr.Inst:PlayShutterSound()
			end

			local var0_34 = arg0_6.room:GetCameraZones()[arg0_6.zoneIndex]
			local var1_34 = Dorm3dCameraAnim.New({
				configId = arg0_6.animID
			})

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_6.scene.apartment:GetConfigID(), 1, arg0_6.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_34:GetName(), var1_34:GetStateName(), arg0_6.cameraSettings.depthOfField.focusDistance.value, arg0_6.cameraSettings.depthOfField.blurRadius.value, arg0_6.cameraSettings.postExposure.value, arg0_6.cameraSettings.contrast.value, arg0_6.cameraSettings.saturate.value)))
		end

		local var3_31 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32):TakePhoto(arg0_6.mainCamera)
		local var4_31 = Tex2DExtension.EncodeToJPG(var3_31)

		var1_31(true)
		var2_31(var4_31, var3_31)
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
		local var0_37 = isActive(arg0_6.listZones)

		setActive(arg0_6.listZones, not var0_37)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.zoneMask, function()
		setActive(arg0_6.listZones, false)
	end)
	onButton(arg0_6, arg0_6.btnAr, function()
		arg0_6.ARchecker:StartCheck(function(arg0_40)
			if PLATFORM == PLATFORM_WINDOWSEDITOR then
				arg0_40 = -1
			end

			originalPrint("AR CODE: " .. arg0_40)
			arg0_6:emit(Dorm3dPhotoMediator.GO_AR, arg0_40)
		end)
	end)
	onButton(arg0_6, arg0_6.btnMove, function()
		arg0_6.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchPhotoCamera")

		arg0_6.freeMode = not arg0_6.freeMode

		setActive(var0_6, arg0_6.freeMode)
		setActive(var1_6, arg0_6.freeMode)
		setActive(arg0_6.btnMove:Find("Selected"), arg0_6.freeMode)
	end)
	onButton(arg0_6, arg0_6.btnMenuSmall, function()
		setActive(arg0_6.btnMenuSmall, false)
		setActive(arg0_6.btnMenu, true)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnMenu:Find("Collapse"), function()
		setActive(arg0_6.btnMenu, false)
		setActive(arg0_6.btnMenuSmall, true)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnMenu, function()
		setActive(arg0_6.skinSelectPanel, true)
		arg0_6:UpdateSkinList()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.skinSelectPanel:Find("BG/Close"), function()
		setActive(arg0_6.skinSelectPanel, false)
	end, SFX_PANEL)

	arg0_6.activePanel = 1

	local var2_6 = {
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

	table.Ipairs(var2_6, function(arg0_52, arg1_52)
		onToggle(arg0_6, arg1_52.btn, function(arg0_53)
			if not arg0_53 then
				return
			end

			table.Ipairs(var2_6, function(arg0_54, arg1_54)
				if arg0_54 == arg0_52 then
					return
				end

				arg1_54.Off()
			end)

			arg0_6.activePanel = arg0_52

			arg1_52.On()
		end, SFX_PANEL)
	end)
	;(function()
		local var0_55 = {
			arg0_6.panelAction:Find("Layout/Title/Regular"),
			arg0_6.panelAction:Find("Layout/Title/Special")
		}

		triggerToggle(var0_55[1], true)
	end)()
	;(function()
		local var0_56 = {
			arg0_6.panelLightning:Find("Layout/Title/Filter")
		}

		triggerToggle(var0_56[1], true)
	end)()

	arg0_6.zoneIndex = 1

	arg0_6:InitData()
	arg0_6:FirstEnterZone()
	triggerToggle(var2_6[arg0_6.activePanel].btn, true)
	arg0_6:UpdateZoneList()
end

function var0_0.InitData(arg0_57)
	arg0_57.cameraSettings = Clone(arg0_57.scene:GetCameraSettings())
	arg0_57.settingHideCharacter = false
	arg0_57.settingFaceCamera = true
	arg0_57.settingFilterIndex = nil
	arg0_57.settingFilterStrength = 1

	arg0_57:RefreshData()
end

function var0_0.RefreshData(arg0_58)
	local var0_58 = arg0_58.room:GetCameraZones()[arg0_58.zoneIndex]

	arg0_58.animID = var0_58:GetRegularAnims()[1]:GetConfigID()

	local function var1_58(arg0_59, arg1_59)
		arg0_59.min = arg1_59[1]
		arg0_59.max = arg1_59[2]
		arg0_59.value = math.clamp(arg0_59.value, arg1_59[1], arg1_59[2])
	end

	var1_58(arg0_58.cameraSettings.depthOfField.focusDistance, var0_58:GetFocusDistanceRange())
	var1_58(arg0_58.cameraSettings.depthOfField.blurRadius, var0_58:GetDepthOfFieldBlurRange())
	var1_58(arg0_58.cameraSettings.postExposure, var0_58:GetExposureRange())
	var1_58(arg0_58.cameraSettings.contrast, var0_58:GetContrastRange())
	var1_58(arg0_58.cameraSettings.saturate, var0_58:GetSaturationRange())

	arg0_58.animSpeeds = var0_58:GetAnimSpeeds()
	arg0_58.animSpeed = 1
end

function var0_0.FirstEnterZone(arg0_60)
	local var0_60 = arg0_60.room:GetCameraZones()[arg0_60.zoneIndex]
	local var1_60 = Dorm3dCameraAnim.New({
		configId = arg0_60.animID
	})

	arg0_60.scene:HideCharacter(arg0_60.scene.apartment:GetConfigID())
	arg0_60.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnterPhotoMode", var0_60, var1_60:GetStateName())
	arg0_60:UpdateAnimSpeedPanel()
end

function var0_0.SwitchZone(arg0_61)
	local var0_61 = arg0_61.room:GetCameraZones()[arg0_61.zoneIndex]
	local var1_61 = Dorm3dCameraAnim.New({
		configId = arg0_61.animID
	})

	arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCameraZone", var0_61, var1_61:GetStateName())

	if arg0_61.timerAnim then
		arg0_61.timerAnim:Stop()

		arg0_61.timerAnim = nil
	end

	arg0_61.animPlaying = nil

	arg0_61:UpdateActionPanel()
	arg0_61:UpdateCameraPanel()
	arg0_61:UpdateLightingPanel()
	arg0_61:UpdateAnimSpeedPanel()
	arg0_61.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", arg0_61.animSpeed)
end

function var0_0.UpdateZoneList(arg0_62)
	local var0_62 = arg0_62.room:GetCameraZones()

	local function var1_62()
		setText(arg0_62.btnZone:Find("Text"), var0_62[arg0_62.zoneIndex]:GetName())
		UIItemList.StaticAlign(arg0_62.listZones:Find("List"), arg0_62.listZones:Find("List"):GetChild(0), #var0_62, function(arg0_64, arg1_64, arg2_64)
			if arg0_64 ~= UIItemList.EventUpdate then
				return
			end

			arg1_64 = arg1_64 + 1

			local var0_64 = var0_62[arg1_64]

			setText(arg2_64:Find("Name"), var0_64:GetName())

			local var1_64 = arg0_62.zoneIndex == arg1_64 and Color.NewHex("5CCAFF") or Color.NewHex("FFFFFF99")

			setTextColor(arg2_64:Find("Name"), var1_64)
			setActive(arg2_64:Find("Line"), arg1_64 < #var0_62)
		end)
	end

	var1_62()
	UIItemList.StaticAlign(arg0_62.listZones:Find("List"), arg0_62.listZones:Find("List"):GetChild(0), #var0_62, function(arg0_65, arg1_65, arg2_65)
		if arg0_65 ~= UIItemList.EventUpdate then
			return
		end

		arg1_65 = arg1_65 + 1

		onButton(arg0_62, arg2_65, function()
			if arg0_62.zoneIndex == arg1_65 then
				return
			end

			arg0_62.zoneIndex = arg1_65

			arg0_62:RefreshData()
			arg0_62:SwitchZone()
			setActive(arg0_62.listZones, false)
			var1_62()
		end, SFX_PANEL)
	end)
end

local var2_0 = 0.2

function var0_0.UpdateActionPanel(arg0_67)
	if not arg0_67.activeSetting then
		return
	end

	if arg0_67.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_67 = arg0_67.room:GetCameraZones()[arg0_67.zoneIndex]
	local var1_67 = var0_67:GetRegularAnims()
	local var2_67 = arg0_67.panelAction:Find("Layout/Regular/Scroll/Viewport/Content")
	local var3_67 = var0_67:GetAllSpecialList(arg0_67.room.id)
	local var4_67 = arg0_67.panelAction:Find("Layout/Special/Scroll/Viewport/Content")
	local var5_67 = #var3_67 > 0

	setActive(arg0_67.panelAction:Find("Layout/Title/Special"), var5_67)

	local function var6_67()
		UIItemList.StaticAlign(var2_67, var2_67:GetChild(0), #var1_67, function(arg0_69, arg1_69, arg2_69)
			if arg0_69 ~= UIItemList.EventUpdate then
				return
			end

			arg1_69 = arg1_69 + 1

			local var0_69 = var1_67[arg1_69]

			setActive(arg2_69:Find("Selected"), var0_69:GetConfigID() == arg0_67.animID)
			setActive(arg2_69:Find("Slider"), var0_69:GetConfigID() == arg0_67.animID and tobool(arg0_67.timerAnim))
		end)
		UIItemList.StaticAlign(var4_67, var4_67:GetChild(0), #var3_67, function(arg0_70, arg1_70, arg2_70)
			if arg0_70 ~= UIItemList.EventUpdate then
				return
			end

			arg1_70 = arg1_70 + 1

			local var0_70 = var3_67[arg1_70].anims
			local var1_70 = arg2_70:Find("Actions")

			UIItemList.StaticAlign(var1_70, var1_70:GetChild(0), #var0_70, function(arg0_71, arg1_71, arg2_71)
				if arg0_71 ~= UIItemList.EventUpdate then
					return
				end

				arg1_71 = arg1_71 + 1

				local var0_71 = var0_70[arg1_71]

				setActive(arg2_71:Find("Selected"), var0_71:GetConfigID() == arg0_67.animID)
				setActive(arg2_71:Find("Slider"), var0_71:GetConfigID() == arg0_67.animID and tobool(arg0_67.timerAnim))
			end)
		end)
	end

	local function var7_67(arg0_72, arg1_72)
		if arg0_67.animPlaying then
			return
		end

		local var0_72 = arg0_72:GetConfigID()

		if arg0_67.animID == var0_72 then
			return
		end

		local var1_72 = arg0_67:GetAnimPlayList(var0_72)
		local var2_72 = Dorm3dCameraAnim.New({
			configId = arg0_67.animID
		}):GetFinishAnimID()

		arg0_67.animID = var0_72

		var6_67()
		arg0_67:BlockActionPanel(true)

		arg0_67.animPlaying = true

		local var3_72 = (table.indexof(var1_72, _.detect(var1_72, function(arg0_73)
			return arg0_73:GetConfigID() == var2_72
		end)) or 0) + 1
		local var4_72 = _.rest(var1_72, var3_72)
		local var5_72 = arg1_72:Find("Slider"):GetComponent(typeof(Slider))

		setActive(arg1_72:Find("Slider"), true)

		local function var6_72()
			setActive(arg1_72:Find("Selected"), true)
			setActive(arg1_72:Find("Slider"), false)
			arg0_67:BlockActionPanel(false)

			arg0_67.animPlaying = nil
		end

		if #var4_72 == 0 then
			var6_72()

			return
		end

		local var7_72 = _.reduce(var4_72, 0, function(arg0_75, arg1_75)
			return arg0_75 + math.max(var2_0, arg1_75:GetAnimTime())
		end)

		if arg0_67.timerAnim then
			arg0_67.timerAnim:Stop()
		end

		arg0_67.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_72,
			totalTime = var7_72,
			startStamp = Time.time
		}
		arg0_67.timerAnim = FrameTimer.New(function()
			local var0_76 = arg0_67.animInfo
			local var1_76 = var0_76.animPlayList[var0_76.index]
			local var2_76 = math.max(var2_0, var1_76:GetAnimTime())
			local var3_76 = var0_76.startStamp
			local var4_76 = Time.time
			local var5_76 = math.min(1, var0_76.ratio + (var4_76 - var3_76) * arg0_67.animSpeed / var2_76)
			local var6_76 = var0_76.passedTime + var2_76 * var5_76

			var5_72.value = var6_76 / var7_72

			if var5_76 < 1 then
				return
			end

			var0_76.index = var0_76.index + 1
			var0_76.ratio = 0
			var0_76.passedTime = var0_76.passedTime + var2_76
			var0_76.startStamp = var4_76

			local var7_76 = var1_76:GetStartPoint()

			if #var7_76 > 0 then
				arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var7_76)
			end

			arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

			if var0_76.index > #var0_76.animPlayList then
				var6_72()
				arg0_67.timerAnim:Stop()

				arg0_67.timerAnim = nil
				arg0_67.animInfo = nil

				return
			end

			local var8_76 = var0_76.animPlayList[var0_76.index]

			arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlaySingleAction", var8_76:GetStateName())
		end, 1, -1)

		local var8_72 = arg0_67.animInfo.animPlayList[1]

		if var3_72 == 1 then
			arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchAnim", var8_72:GetStateName())
			onNextTick(function()
				local var0_77 = var8_72:GetStartPoint()

				if #var0_77 == 0 then
					var0_77 = var0_67:GetWatchCameraName()
				end

				arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var0_77)
				arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

				if arg0_67.freeMode then
					local var1_77 = arg0_67.scene.cameras[arg0_67.scene.CAMERA.PHOTO_FREE]
					local var2_77 = var1_77:GetComponent(typeof(UnityEngine.CharacterController))
					local var3_77 = var1_77.transform.forward

					var3_77.y = 0

					var3_77:Normalize()

					local var4_77 = var3_77 * -0.01

					var2_77:Move(var4_77)
					var2_77:Move(-var4_77)
				end
			end)
		else
			arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlaySingleAction", var8_72:GetStateName())
		end

		arg0_67.timerAnim:Start()
	end

	UIItemList.StaticAlign(var2_67, var2_67:GetChild(0), #var1_67, function(arg0_78, arg1_78, arg2_78)
		if arg0_78 ~= UIItemList.EventUpdate then
			return
		end

		arg1_78 = arg1_78 + 1

		local var0_78 = var1_67[arg1_78]

		setText(arg2_78:Find("Name"), var0_78:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_78:GetZoneIcon()), "", arg2_78:Find("Icon"))
		setActive(arg2_78:Find("Slider"), false)
		setActive(arg2_78:Find("Selected"), false)
		onButton(arg0_67, arg2_78, function()
			var7_67(var0_78, arg2_78)
		end)
	end)

	local function var8_67()
		UIItemList.StaticAlign(var4_67, var4_67:GetChild(0), #var3_67, function(arg0_81, arg1_81, arg2_81)
			if arg0_81 ~= UIItemList.EventUpdate then
				return
			end

			arg1_81 = arg1_81 + 1

			local var0_81 = var3_67[arg1_81].anims
			local var1_81 = arg2_81:Find("Actions")

			UIItemList.StaticAlign(var1_81, var1_81:GetChild(0), #var0_81, function(arg0_82, arg1_82, arg2_82)
				if arg0_82 ~= UIItemList.EventUpdate then
					return
				end

				arg1_82 = arg1_82 + 1

				local var0_82 = var0_81[arg1_82]

				setActive(arg2_82:Find("Selected"), var0_82:GetConfigID() == arg0_67.animID)
				setActive(arg2_82:Find("Slider"), var0_82:GetConfigID() == arg0_67.animID and tobool(arg0_67.timerAnim))
			end)
		end)
	end

	local function var9_67()
		UIItemList.StaticAlign(var4_67, var4_67:GetChild(0), #var3_67, function(arg0_84, arg1_84, arg2_84)
			if arg0_84 ~= UIItemList.EventUpdate then
				return
			end

			arg1_84 = arg1_84 + 1

			setActive(arg2_84:Find("Button/Active"), arg0_67.settingSpecialFurnitureIndex == arg1_84)
			setActive(arg2_84:Find("Actions"), arg0_67.settingSpecialFurnitureIndex == arg1_84)
		end)
		var8_67()
	end

	local var10_67 = arg0_67.room:GetCameraZones()[arg0_67.zoneIndex]

	local function var11_67(arg0_85, arg1_85)
		local var0_85 = arg1_85:Find("Actions")
		local var1_85 = arg0_85.anims

		UIItemList.StaticAlign(var0_85, var0_85:GetChild(0), #var1_85, function(arg0_86, arg1_86, arg2_86)
			if arg0_86 ~= UIItemList.EventUpdate then
				return
			end

			arg1_86 = arg1_86 + 1

			local var0_86 = var1_85[arg1_86]
			local var1_86 = var10_67:CheckFurnitureIdInZone(arg0_85.furnitureId)
			local var2_86 = arg0_67.room:IsFurnitureSetIn(arg0_85.furnitureId)
			local var3_86 = var1_86 and var2_86

			SetActive(arg2_86:Find("Other"), not var3_86)
			SetActive(arg2_86:Find("Name"), var3_86)

			if var3_86 then
				onButton(arg0_67, arg2_86, function()
					arg0_67.room:ReplaceFurniture(arg0_85.slotId, arg0_85.furnitureId)
					arg0_67.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RefreshSlots", arg0_67.room)
					var7_67(var0_86, arg2_86)
				end)
				setText(arg2_86:Find("Name"), var0_86:GetName())
			else
				removeOnButton(arg2_86)

				if not var1_86 then
					local var4_86 = var0_86:GetZoneName()

					warnText = i18n("dorm3d_photo_active_zone", var4_86)
				else
					warnText = i18n("dorm3d_furniture_replace_tip")
				end

				setText(arg2_86:Find("Other/Content"), warnText)
			end

			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_86:GetZoneIcon()), "", arg2_86:Find("Icon"))
			setActive(arg2_86:Find("Slider"), false)
			setActive(arg2_86:Find("Selected"), false)
		end)
	end

	setActive(var4_67, #var3_67 > 0)
	UIItemList.StaticAlign(var4_67, var4_67:GetChild(0), #var3_67, function(arg0_88, arg1_88, arg2_88)
		if arg0_88 ~= UIItemList.EventUpdate then
			return
		end

		arg1_88 = arg1_88 + 1

		local var0_88 = var3_67[arg1_88]
		local var1_88 = Dorm3dFurniture.New({
			configId = var0_88.furnitureId
		})
		local var2_88 = tobool(_.detect(arg0_67.room:GetFurnitures(), function(arg0_89)
			return arg0_89:GetConfigID() == var0_88.furnitureId
		end))

		setText(arg2_88:Find("Button/Name"), var1_88:GetName())
		GetImageSpriteFromAtlasAsync(var1_88:GetIcon(), "", arg2_88:Find("Button/Icon"))
		setActive(arg2_88:Find("Button/Lock"), not var2_88)
		setActive(arg2_88:Find("Button/BG"), var2_88)

		local var3_88 = var10_67:CheckFurnitureIdInZone(var0_88.furnitureId)
		local var4_88

		if var3_88 then
			var4_88 = Color.New(1, 1, 1, 0.850980392156863)
		else
			var4_88 = Color.New(0.788235294117647, 0.788235294117647, 0.788235294117647, 0.850980392156863)
		end

		setImageColor(arg2_88:Find("Button/BG"), var4_88)
		onButton(arg0_67, arg2_88:Find("Button"), function()
			if not var2_88 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_furniture_locked"))

				return
			end

			if arg0_67.settingSpecialFurnitureIndex == arg1_88 then
				arg0_67.settingSpecialFurnitureIndex = nil
			else
				arg0_67.settingSpecialFurnitureIndex = arg1_88
			end

			var11_67(var0_88, arg2_88, arg1_88)
			var9_67()
		end)
	end)
	var9_67()
	var6_67()
end

function var0_0.BlockActionPanel(arg0_91, arg1_91)
	return
end

function var0_0.GetAnimPlayList(arg0_92, arg1_92)
	local var0_92 = arg1_92
	local var1_92 = {}

	while true do
		local var2_92 = Dorm3dCameraAnim.New({
			configId = var0_92
		})

		if not var2_92 then
			return var1_92
		end

		table.insert(var1_92, 1, var2_92)

		var0_92 = var2_92:GetPreAnimID()

		if var0_92 == 0 then
			return var1_92
		end
	end
end

function var0_0.UpdateCameraPanel(arg0_93)
	if not arg0_93.activeSetting then
		return
	end

	if arg0_93.activePanel ~= var0_0.PANEL.CAMERA then
		return
	end

	;(function()
		local var0_94 = arg0_93.panelCamera:Find("Layout/DepthOfField/Switch/Toggle")

		triggerToggle(var0_94, arg0_93.cameraSettings.depthOfField.enabled)
		onToggle(arg0_93, var0_94, function(arg0_95)
			arg0_93.cameraSettings.depthOfField.enabled = arg0_95

			setActive(arg0_93.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_93.cameraSettings.depthOfField.enabled)
			arg0_93:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	setActive(arg0_93.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_93.cameraSettings.depthOfField.enabled)
	;(function()
		local var0_96 = arg0_93.cameraSettings.depthOfField.focusDistance
		local var1_96 = arg0_93.panelCamera:Find("Layout/DepthOfField/DepthOfField/FocusDistance/Slider")

		setSlider(var1_96, var0_96.min, var0_96.max, var0_96.value)
		onSlider(arg0_93, var1_96, function(arg0_97)
			var0_96.value = arg0_97

			arg0_93:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_98 = arg0_93.cameraSettings.depthOfField.blurRadius
		local var1_98 = arg0_93.panelCamera:Find("Layout/DepthOfField/DepthOfField/BlurRadius/Slider")

		setSlider(var1_98, var0_98.min, var0_98.max, var0_98.value)
		onSlider(arg0_93, var1_98, function(arg0_99)
			var0_98.value = arg0_99

			arg0_93:RefreshCamera()
		end)
	end)()

	local var0_93 = {
		"PostExposure",
		"Saturation",
		"Contrast"
	}

	arg0_93.paramIndex = arg0_93.paramIndex or 1

	local function var1_93()
		table.Ipairs(var0_93, function(arg0_101, arg1_101)
			local var0_101 = arg0_93.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_101 - 1)

			setActive(var0_101:Find("Selected"), arg0_101 == arg0_93.paramIndex)
			setActive(arg0_93.panelCamera:Find("Layout/Paramaters/" .. arg1_101), arg0_101 == arg0_93.paramIndex)
		end)
	end

	table.Ipairs(var0_93, function(arg0_102, arg1_102)
		local var0_102 = arg0_93.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_102 - 1)

		onButton(arg0_93, var0_102, function()
			arg0_93.paramIndex = arg0_102

			var1_93()
		end, SFX_PANEL)
	end)
	var1_93()
	;(function()
		local var0_104 = arg0_93.cameraSettings.postExposure
		local var1_104 = arg0_93.panelCamera:Find("Layout/Paramaters/PostExposure/PostExposure/Slider")
		local var2_104 = var1_104:Find("Background/Fill")

		onSlider(arg0_93, var1_104, function(arg0_105)
			var0_104.value = arg0_105

			local var0_105 = (arg0_105 - var0_104.min) / (var0_104.max - var0_104.min)
			local var1_105 = math.min(var0_105, 0.5)
			local var2_105 = math.max(var0_105, 0.5)

			var2_104.anchorMin = Vector2.New(var1_105, 0)
			var2_104.anchorMax = Vector2.New(var2_105, 1)
			var2_104.offsetMin = Vector2.zero
			var2_104.offsetMax = Vector2.zero

			arg0_93:RefreshCamera()
		end)
		setSlider(var1_104, var0_104.min, var0_104.max, var0_104.value)
	end)()
	;(function()
		local var0_106 = arg0_93.cameraSettings.contrast
		local var1_106 = arg0_93.panelCamera:Find("Layout/Paramaters/Contrast/Contrast/Slider")
		local var2_106 = var1_106:Find("Background/Fill")

		onSlider(arg0_93, var1_106, function(arg0_107)
			var0_106.value = arg0_107

			local var0_107 = (arg0_107 - var0_106.min) / (var0_106.max - var0_106.min)
			local var1_107 = math.min(var0_107, 0.5)
			local var2_107 = math.max(var0_107, 0.5)

			var2_106.anchorMin = Vector2.New(var1_107, 0)
			var2_106.anchorMax = Vector2.New(var2_107, 1)
			var2_106.offsetMin = Vector2.zero
			var2_106.offsetMax = Vector2.zero

			arg0_93:RefreshCamera()
		end)
		setSlider(var1_106, var0_106.min, var0_106.max, var0_106.value)
	end)()
	;(function()
		local var0_108 = arg0_93.cameraSettings.saturate
		local var1_108 = arg0_93.panelCamera:Find("Layout/Paramaters/Saturation/Saturation/Slider")
		local var2_108 = var1_108:Find("Background/Fill")

		onSlider(arg0_93, var1_108, function(arg0_109)
			var0_108.value = arg0_109

			local var0_109 = (arg0_109 - var0_108.min) / (var0_108.max - var0_108.min)
			local var1_109 = math.min(var0_109, 0.5)
			local var2_109 = math.max(var0_109, 0.5)

			var2_108.anchorMin = Vector2.New(var1_109, 0)
			var2_108.anchorMax = Vector2.New(var2_109, 1)
			var2_108.offsetMin = Vector2.zero
			var2_108.offsetMax = Vector2.zero

			arg0_93:RefreshCamera()
		end)
		setSlider(var1_108, var0_108.min, var0_108.max, var0_108.value)
	end)()
	;(function()
		local var0_110 = arg0_93.panelCamera:Find("Layout/Other/FaceCamera/Toggle")

		triggerToggle(var0_110, arg0_93.settingFaceCamera)
		onToggle(arg0_93, var0_110, function(arg0_111)
			arg0_93.settingFaceCamera = arg0_111

			arg0_93.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableHeadIK", arg0_111)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_112 = arg0_93.panelCamera:Find("Layout/Other/HideCharacter/Toggle")

		triggerToggle(var0_112, arg0_93.settingHideCharacter)
		onToggle(arg0_93, var0_112, function(arg0_113)
			arg0_93.settingHideCharacter = arg0_113

			if arg0_113 then
				arg0_93.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			else
				arg0_93.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0_0.RefreshCamera(arg0_114)
	arg0_114.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SettingCamera", arg0_114.cameraSettings)
end

function var0_0.UpdateAnimSpeedPanel(arg0_115)
	local function var0_115()
		if not arg0_115.timerAnim then
			return
		end

		local var0_116 = arg0_115.animInfo
		local var1_116 = var0_116.animPlayList[var0_116.index]
		local var2_116 = math.max(var2_0, var1_116:GetAnimTime())
		local var3_116 = var0_116.startStamp
		local var4_116 = Time.time

		var0_116.ratio = math.min(1, var0_116.ratio + (var4_116 - var3_116) * arg0_115.animSpeed / var2_116)
		var0_116.startStamp = var4_116
	end

	local var1_115 = arg0_115.animSpeeds

	UIItemList.StaticAlign(arg0_115.listAnimSpeed, arg0_115.listAnimSpeed:GetChild(0), #var1_115, function(arg0_117, arg1_117, arg2_117)
		if arg0_117 ~= UIItemList.EventUpdate then
			return
		end

		arg1_117 = #var1_115 - arg1_117

		local var0_117 = var1_115[arg1_117]

		setText(arg2_117:Find("Name"), var0_117)
		setText(arg2_117:Find("Selected"), var0_117)
		setActive(arg2_117:Find("Line"), arg1_117 ~= #var1_115)
		onButton(arg0_115, arg2_117, function()
			if arg0_115.animSpeed == var0_117 then
				return
			end

			var0_115()

			arg0_115.animSpeed = var0_117

			arg0_115.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_117)
			arg0_115:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0_115, arg0_115.btnFreeze, function()
		local var0_119 = 0

		if arg0_115.animSpeed ~= 0 then
			arg0_115.lastAnimSpeed = arg0_115.animSpeed
		else
			var0_119 = arg0_115.lastAnimSpeed or 1
			arg0_115.lastAnimSpeed = nil
		end

		var0_115()

		arg0_115.animSpeed = var0_119

		arg0_115.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_119)
		arg0_115:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_115.listAnimSpeed, arg0_115.listAnimSpeed:GetChild(0), #var1_115, function(arg0_120, arg1_120, arg2_120)
		if arg0_120 ~= UIItemList.EventUpdate then
			return
		end

		arg1_120 = #var1_115 - arg1_120

		local var0_120 = var1_115[arg1_120]

		setActive(arg2_120:Find("Name"), arg0_115.animSpeed ~= var0_120)
		setActive(arg2_120:Find("Selected"), arg0_115.animSpeed == var0_120)
	end)
	setActive(arg0_115.btnFreeze:Find("Icon"), arg0_115.animSpeed ~= 0)
	setActive(arg0_115.btnFreeze:Find("Selected"), arg0_115.animSpeed == 0)
	setText(arg0_115.textAnimSpeed, i18n("dorm3d_photo_animspeed", string.format("%.1f", arg0_115.animSpeed)))
end

function var0_0.UpdateLightingPanel(arg0_121)
	if not arg0_121.activeSetting then
		return
	end

	if arg0_121.activePanel ~= var0_0.PANEL.LIGHTING then
		return
	end

	local var0_121 = {}

	for iter0_121, iter1_121 in ipairs(pg.dorm3d_camera_volume_template.all) do
		table.insert(var0_121, iter1_121)
	end

	table.sort(var0_121, function(arg0_122, arg1_122)
		return arg0_122 < arg1_122
	end)

	local function var1_121()
		if not arg0_121.settingFilterIndex then
			arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")

			return
		end

		local var0_123 = pg.dorm3d_camera_volume_template[var0_121[arg0_121.settingFilterIndex]]

		arg0_121.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetVolumeProfile", var0_123.volume, arg0_121.settingFilterStrength)
	end

	UIItemList.StaticAlign(arg0_121.panelLightning:Find("Layout/Filter/List"), arg0_121.panelLightning:Find("Layout/Filter/List"):GetChild(0), #var0_121, function(arg0_124, arg1_124, arg2_124)
		if arg0_124 ~= UIItemList.EventUpdate then
			return
		end

		arg1_124 = arg1_124 + 1

		local var0_124 = pg.dorm3d_camera_volume_template[var0_121[arg1_124]]

		setText(arg2_124:Find("Name"), var0_124.name)

		var0_124.icon = ""

		if var0_124.icon ~= "" then
			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_124.icon), "", arg2_124:Find("BG"))
		end

		if arg0_121.settingFilterIndex == arg1_124 then
			setActive(arg2_124:Find("Selected"), true)
		else
			setActive(arg2_124:Find("Selected"), false)
		end

		local var1_124, var2_124 = ApartmentProxy.CheckUnlockConfig(var0_124.unlock)

		setActive(arg2_124:Find("lock"), not var1_124)

		if not var1_124 then
			setText(arg2_124:Find("lock/Image/Text"), var0_124.unlock_text)
		end

		onButton(arg0_121, arg2_124, function()
			if not var1_124 then
				pg.TipsMgr.GetInstance():ShowTips(var2_124)

				return
			end

			local var0_125 = arg0_121.settingFilterIndex

			if arg0_121.settingFilterIndex ~= arg1_124 then
				arg0_121.settingFilterIndex = arg1_124
			else
				arg0_121.settingFilterIndex = nil
			end

			var1_121()

			if var0_125 then
				local var1_125 = arg0_121.panelLightning:Find("Layout/Filter/List"):GetChild(var0_125 - 1)

				setActive(var1_125:Find("Selected"), false)
			end

			if arg0_121.settingFilterIndex == arg1_124 then
				setActive(arg2_124:Find("Selected"), true)
			end
		end, SFX_PANEL)
	end)
	setActive(arg0_121.panelLightning:Find("Layout/Filter/Slider"), false)
end

function var0_0.UpdateSkinList(arg0_126)
	local var0_126 = arg0_126.scene.apartment:GetConfigID()
	local var1_126 = arg0_126.scene.ladyDict[var0_126]
	local var2_126 = var1_126.skinIdList
	local var3_126 = var1_126.skinId
	local var4_126 = {}
	local var5_126 = {}

	_.each(var2_126, function(arg0_127)
		if ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[arg0_127].unlock) then
			table.insert(var4_126, arg0_127)
		else
			table.insert(var5_126, arg0_127)
		end
	end)

	local function var6_126(arg0_128, arg1_128)
		local var0_128 = arg1_128 and var4_126 or var5_126

		UIItemList.StaticAlign(arg0_128, arg0_128:GetChild(0), #var0_128, function(arg0_129, arg1_129, arg2_129)
			if arg0_129 ~= UIItemList.EventUpdate then
				return
			end

			local var0_129 = var0_128[arg1_129 + 1]

			setActive(arg2_129:Find("Selected"), var0_129 == var3_126)
			setActive(arg2_129:Find("Lock"), not arg1_128)

			if not arg1_128 then
				setText(arg2_129:Find("Lock/Bar/Text"), pg.dorm3d_resource[var0_129].unlock_text)
			end

			arg0_126.loader:GetSpriteQuiet(string.format("dorm3dselect/apartment_skin_%d", var0_129), "", arg2_129:Find("Icon"))
			onButton(arg0_126, arg2_129, function()
				if not arg1_128 then
					local var0_130, var1_130 = ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[var0_129].unlock)

					pg.TipsMgr.GetInstance():ShowTips(var1_130)

					return
				end

				if var0_129 == var3_126 then
					return
				end

				local var2_130 = var0_129

				seriesAsync({
					function(arg0_131)
						if arg0_126.settingHideCharacter then
							arg0_126.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
						end

						arg0_126.scene.SwitchCharacterSkin(var1_126, var0_126, var2_130, arg0_131)
					end,
					function(arg0_132)
						if not arg0_126.animInfo then
							return arg0_132()
						end

						local var0_132 = arg0_126.animInfo

						for iter0_132 = #var0_132.animPlayList, 1, -1 do
							local var1_132 = var0_132.animPlayList[iter0_132]:GetStartPoint()

							if #var1_132 > 0 then
								arg0_126.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var1_132)

								break
							end

							if iter0_132 == 1 then
								local var2_132 = arg0_126.room:GetCameraZones()[arg0_126.zoneIndex]

								arg0_126.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharPoint", var2_132:GetWatchCameraName())
							end
						end

						arg0_126.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

						local var3_132 = var0_132.animPlayList[#var0_132.animPlayList]
						local var4_132 = var3_132:GetAnimTime()

						arg0_126.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlaySingleAction", var3_132:GetStateName())

						local var5_132 = arg0_126.scene.apartment:GetConfigID()

						arg0_126.scene.ladyDict[var5_132].ladyAnimator:Update(var4_132)
						arg0_126.timerAnim:Stop()

						arg0_126.timerAnim = nil
						arg0_126.animInfo = nil
						arg0_126.animPlaying = nil

						arg0_132()
					end,
					function()
						arg0_126:UpdateActionPanel()

						if arg0_126.settingHideCharacter then
							arg0_126.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
						end

						arg0_126:UpdateSkinList()
					end
				})
			end, SFX_PANEL)
		end)
	end

	var6_126(arg0_126.skinSelectPanel:Find("BG/Scroll/Content/Unlock/List"), true)
	var6_126(arg0_126.skinSelectPanel:Find("BG/Scroll/Content/Lock/List"), false)
end

function var0_0.SetMute(arg0_134)
	if arg0_134 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.willExit(arg0_135)
	arg0_135.loader:Clear()

	if arg0_135.timerAnim then
		arg0_135.timerAnim:Stop()

		arg0_135.timerAnim = nil
	end

	local var0_135 = arg0_135.scene.apartment:GetConfigID()
	local var1_135 = arg0_135.scene.ladyDict[var0_135]
	local var2_135 = var1_135.skinIdList

	if var1_135.skinId ~= var2_135[1] then
		arg0_135.scene.SwitchCharacterSkin(var1_135, var0_135, var2_135[1])
	end

	if arg0_135.animSpeed ~= 1 then
		arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", 1)
	end

	if arg0_135.settingHideCharacter then
		arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
	end

	if not arg0_135.settingFaceCamera then
		arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableHeadIK", true)
	end

	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterLight")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCameraSettings")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ExitPhotoMode")
	arg0_135.scene:RevertCharacter(arg0_135.scene.apartment:GetConfigID())
end

function var0_0.SetPhotoCameraSliderValue(arg0_136, arg1_136)
	local var0_136 = arg0_136.normalPanel:Find("Zoom/Slider")

	setSlider(var0_136, 0, 1, arg1_136)
end

function var0_0.SetPhotoStickDelta(arg0_137, arg1_137)
	arg1_137 = arg1_137 * 0.5

	local var0_137 = arg0_137._tf:Find("Center/Stick")
	local var1_137 = var0_137.rect.height
	local var2_137 = var0_137.rect.width
	local var3_137 = var0_137:Find("Handler")

	setAnchoredPosition(var3_137, Vector2.New(var1_137 * arg1_137.x, var2_137 * arg1_137.y))
end

return var0_0
