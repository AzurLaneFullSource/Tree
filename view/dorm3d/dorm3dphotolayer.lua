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

	arg0_2.mainCamera = GameObject.Find("BackYardMainCamera"):GetComponent(typeof(Camera))
	arg0_2.stopRecBtn = arg0_2._tf:Find("stopRec")
	arg0_2.videoTipPanel = arg0_2._tf:Find("videoTipPanel")

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

			arg0_7._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = arg0_16 and 1 or 0
		end

		if not arg0_7.recordState then
			local function var1_15(arg0_17)
				if not arg0_17 then
					var0_15(true)

					arg0_7.recordState = false

					LeanTween.moveX(arg0_7.stopRecBtn, arg0_7.stopRecBtn.rect.width, 0.15)
				else
					arg0_7.recordState = true
				end
			end

			local function var2_15()
				setActive(arg0_7.stopRecBtn, true)
				LeanTween.moveX(arg0_7.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)

					arg0_7.recordFilePath = YSNormalTool.RecordTool.GenRecordFilePath()

					YSNormalTool.RecordTool.StartRecording(var1_15, arg0_7.recordFilePath)
				end))
			end

			seriesAsync({
				function(arg0_20)
					PermissionHelper.Request3DDorm(arg0_20, nil)
				end,
				function(arg0_21)
					var0_15(false)

					local var0_21 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_21 or var0_21 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_7.videoTipPanel:Find("Text"):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_7, arg0_7.videoTipPanel, function()
							setActive(arg0_7.videoTipPanel, false)
							var2_15()
						end)
						setActive(arg0_7.videoTipPanel, true)
					else
						var2_15()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.stopRecBtn, function()
		arg0_7.recordState = false

		local function var0_23(arg0_24)
			if arg0_24 and PLATFORM == PLATFORM_ANDROID then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("word_save_video"),
					onNo = function()
						if System.IO.File.Exists(arg0_7.recordFilePath) then
							System.IO.File.Delete(arg0_7.recordFilePath)
						end
					end,
					onYes = function()
						YSNormalTool.MediaTool.SaveVideoToAlbum(arg0_7.recordFilePath, function(arg0_27, arg1_27)
							if arg0_27 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))

								if System.IO.File.Exists(arg0_7.recordFilePath) then
									System.IO.File.Delete(arg0_7.recordFilePath)
								end
							end
						end)
					end
				})
			end

			arg0_7.recordState = false
		end

		local function var1_23(arg0_28)
			setActive(arg0_7.centerPanel, arg0_28)

			arg0_7._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = arg0_28 and 1 or 0
		end

		if not LeanTween.isTweening(go(arg0_7.stopRecBtn)) then
			LeanTween.moveX(arg0_7.stopRecBtn, arg0_7.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_7.stopRecBtn, false)
				seriesAsync({
					function(arg0_30)
						YSNormalTool.RecordTool.StopRecording(var0_23)
						var1_23(true)
						var0_0.SetMute(false)

						local var0_30 = arg0_7.room:GetCameraZones()[arg0_7.zoneIndex]
						local var1_30 = Dorm3dCameraAnim.New({
							configId = arg0_7.animID
						})

						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_7.scene.apartment:GetConfigID(), 2, arg0_7.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_30:GetName(), var1_30:GetStateName(), arg0_7.cameraSettings.depthOfField.focusDistance.value, arg0_7.cameraSettings.depthOfField.blurRadius.value, arg0_7.cameraSettings.postExposure.value, arg0_7.cameraSettings.contrast.value, arg0_7.cameraSettings.saturate.value)))
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
			getProxy(Dorm3dChatProxy):TriggerEvent({
				{
					value = 1,
					event_type = 160,
					ship_id = arg0_7.scene.apartment:GetConfigID()
				}
			})

			local var0_35 = arg0_7.room:GetCameraZones()[arg0_7.zoneIndex]
			local var1_35 = Dorm3dCameraAnim.New({
				configId = arg0_7.animID
			})

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_7.scene.apartment:GetConfigID(), 1, arg0_7.room:GetConfigID(), Dorm3dTrackCommand.BuildCameraMsg(var0_35:GetName(), var1_35:GetStateName(), arg0_7.cameraSettings.depthOfField.focusDistance.value, arg0_7.cameraSettings.depthOfField.blurRadius.value, arg0_7.cameraSettings.postExposure.value, arg0_7.cameraSettings.contrast.value, arg0_7.cameraSettings.saturate.value)))
		end

		local function var3_32(arg0_36)
			var1_32(true)

			local var0_36 = Tex2DExtension.EncodeToJPG(arg0_36)

			var2_32(var0_36, arg0_36)
		end

		BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(arg0_7.mainCamera, var3_32)
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
		local var0_39 = isActive(arg0_7.listZones)

		setActive(arg0_7.listZones, not var0_39)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.zoneMask, function()
		setActive(arg0_7.listZones, false)
	end)
	onButton(arg0_7, arg0_7.btnAr, function()
		arg0_7.ARchecker:StartCheck(function(arg0_42)
			if PLATFORM == PLATFORM_WINDOWSEDITOR then
				arg0_42 = -1
			end

			originalPrint("AR CODE: " .. arg0_42)
			arg0_7:emit(Dorm3dPhotoMediator.GO_AR, arg0_42)
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
		arg0_7:emit(Dorm3dPhotoMediator.OPEN_SKIN_SELECT_LAYER, arg0_7.groupId, arg0_7.scene.ladyDict[arg0_7.groupId], function(arg0_47, arg1_47, arg2_47)
			arg0_7:OnSwitchSkin(arg0_47, arg1_47, arg2_47)
		end, not arg0_7.scene.room:isPersonalRoom())
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

	table.Ipairs(var2_7, function(arg0_54, arg1_54)
		onToggle(arg0_7, arg1_54.btn, function(arg0_55)
			if not arg0_55 then
				return
			end

			table.Ipairs(var2_7, function(arg0_56, arg1_56)
				if arg0_56 == arg0_54 then
					return
				end

				arg1_56.Off()
			end)

			arg0_7.activePanel = arg0_54

			arg1_54.On()
		end, SFX_PANEL)
	end)
	;(function()
		local var0_57 = {
			arg0_7.panelAction:Find("Layout/Title/Regular"),
			arg0_7.panelAction:Find("Layout/Title/Special")
		}

		triggerToggle(var0_57[1], true)
	end)()
	;(function()
		local var0_58 = {
			arg0_7.panelLightning:Find("Layout/Title/Filter")
		}

		triggerToggle(var0_58[1], true)
	end)()

	arg0_7.zoneIndex = 1

	arg0_7:InitData()
	arg0_7:FirstEnterZone()
	triggerToggle(var2_7[arg0_7.activePanel].btn, true)
	arg0_7:UpdateZoneList()
end

function var0_0.InitData(arg0_59)
	arg0_59.cameraSettings = Clone(arg0_59.scene:GetCameraSettings())
	arg0_59.settingHideCharacter = false
	arg0_59.settingFaceCamera = true
	arg0_59.settingFilterIndex = nil
	arg0_59.settingFilterStrength = 1

	arg0_59:RefreshData()
end

function var0_0.RefreshData(arg0_60)
	local var0_60 = arg0_60.room:GetCameraZones()[arg0_60.zoneIndex]

	arg0_60.animID = var0_60:GetRegularAnimsByShipId(arg0_60.groupId)[1]:GetConfigID()

	local function var1_60(arg0_61, arg1_61)
		arg0_61.min = arg1_61[1]
		arg0_61.max = arg1_61[2]
		arg0_61.value = math.clamp(arg0_61.value, arg1_61[1], arg1_61[2])
	end

	var1_60(arg0_60.cameraSettings.depthOfField.focusDistance, var0_60:GetFocusDistanceRange())
	var1_60(arg0_60.cameraSettings.depthOfField.blurRadius, var0_60:GetDepthOfFieldBlurRange())
	var1_60(arg0_60.cameraSettings.postExposure, var0_60:GetExposureRange())
	var1_60(arg0_60.cameraSettings.contrast, var0_60:GetContrastRange())
	var1_60(arg0_60.cameraSettings.saturate, var0_60:GetSaturationRange())

	arg0_60.animSpeeds = var0_60:GetAnimSpeeds()
	arg0_60.animSpeed = 1
end

function var0_0.FirstEnterZone(arg0_62)
	local var0_62 = arg0_62.room:GetCameraZones()[arg0_62.zoneIndex]
	local var1_62 = Dorm3dCameraAnim.New({
		configId = arg0_62.animID
	})

	arg0_62.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnterPhotoMode", var0_62, var1_62:GetStateName())
	arg0_62:UpdateAnimSpeedPanel()
end

function var0_0.SwitchZone(arg0_63)
	local var0_63 = arg0_63.room:GetCameraZones()[arg0_63.zoneIndex]
	local var1_63 = Dorm3dCameraAnim.New({
		configId = arg0_63.animID
	})

	arg0_63.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCameraZone", var0_63, var1_63:GetStateName())

	if arg0_63.timerAnim then
		arg0_63.timerAnim:Stop()

		arg0_63.timerAnim = nil
	end

	arg0_63.animPlaying = nil

	arg0_63:UpdateActionPanel()
	arg0_63:UpdateCameraPanel()
	arg0_63:UpdateLightingPanel()
	arg0_63:UpdateAnimSpeedPanel()
	arg0_63:SetAllAnimSpeed(arg0_63.animSpeed)
end

function var0_0.UpdateZoneList(arg0_64)
	local var0_64 = arg0_64.room:GetCameraZones()

	local function var1_64()
		setText(arg0_64.btnZone:Find("Text"), var0_64[arg0_64.zoneIndex]:GetName())
		UIItemList.StaticAlign(arg0_64.listZones:Find("List"), arg0_64.listZones:Find("List"):GetChild(0), #var0_64, function(arg0_66, arg1_66, arg2_66)
			if arg0_66 ~= UIItemList.EventUpdate then
				return
			end

			arg1_66 = arg1_66 + 1

			local var0_66 = var0_64[arg1_66]

			setText(arg2_66:Find("Name"), var0_66:GetName())

			local var1_66 = arg0_64.zoneIndex == arg1_66 and Color.NewHex("5CCAFF") or Color.NewHex("FFFFFF99")

			setTextColor(arg2_66:Find("Name"), var1_66)
			setActive(arg2_66:Find("Line"), arg1_66 < #var0_64)
		end)
	end

	var1_64()
	UIItemList.StaticAlign(arg0_64.listZones:Find("List"), arg0_64.listZones:Find("List"):GetChild(0), #var0_64, function(arg0_67, arg1_67, arg2_67)
		if arg0_67 ~= UIItemList.EventUpdate then
			return
		end

		arg1_67 = arg1_67 + 1

		onButton(arg0_64, arg2_67, function()
			if arg0_64.zoneIndex == arg1_67 then
				return
			end

			arg0_64.zoneIndex = arg1_67

			arg0_64:RefreshData()
			arg0_64:SwitchZone()
			setActive(arg0_64.listZones, false)
			var1_64()
		end, SFX_PANEL)
	end)
end

local var2_0 = 0.2

function var0_0.UpdateActionPanel(arg0_69)
	if not arg0_69.activeSetting then
		return
	end

	if arg0_69.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_69 = arg0_69.room:GetCameraZones()[arg0_69.zoneIndex]
	local var1_69 = var0_69:GetRegularAnimsByShipId(arg0_69.groupId)
	local var2_69 = arg0_69.panelAction:Find("Layout/Regular/Scroll/Viewport/Content")
	local var3_69 = var0_69:GetAllSpecialList(arg0_69.room.id)
	local var4_69 = arg0_69.panelAction:Find("Layout/Special/Scroll/Viewport/Content")
	local var5_69 = #var3_69 > 0

	setActive(arg0_69.panelAction:Find("Layout/Title/Special"), var5_69)

	local function var6_69()
		UIItemList.StaticAlign(var2_69, var2_69:GetChild(0), #var1_69, function(arg0_71, arg1_71, arg2_71)
			if arg0_71 ~= UIItemList.EventUpdate then
				return
			end

			arg1_71 = arg1_71 + 1

			local var0_71 = var1_69[arg1_71]

			setActive(arg2_71:Find("Selected"), var0_71:GetConfigID() == arg0_69.animID)
			setActive(arg2_71:Find("Slider"), var0_71:GetConfigID() == arg0_69.animID and tobool(arg0_69.timerAnim))
		end)
		UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_72, arg1_72, arg2_72)
			if arg0_72 ~= UIItemList.EventUpdate then
				return
			end

			arg1_72 = arg1_72 + 1

			local var0_72 = var3_69[arg1_72].anims
			local var1_72 = arg2_72:Find("Actions")

			UIItemList.StaticAlign(var1_72, var1_72:GetChild(0), #var0_72, function(arg0_73, arg1_73, arg2_73)
				if arg0_73 ~= UIItemList.EventUpdate then
					return
				end

				arg1_73 = arg1_73 + 1

				local var0_73 = var0_72[arg1_73]

				setActive(arg2_73:Find("Selected"), var0_73:GetConfigID() == arg0_69.animID)
				setActive(arg2_73:Find("Slider"), var0_73:GetConfigID() == arg0_69.animID and tobool(arg0_69.timerAnim))
			end)
		end)
	end

	local function var7_69(arg0_74, arg1_74)
		if arg0_69.animPlaying then
			return
		end

		local var0_74 = arg0_74:GetConfigID()

		if arg0_69.animID == var0_74 then
			return
		end

		local var1_74 = arg0_69:GetAnimPlayList(var0_74)
		local var2_74 = Dorm3dCameraAnim.New({
			configId = arg0_69.animID
		}):GetFinishAnimID()

		arg0_69.animID = var0_74

		var6_69()
		arg0_69:BlockActionPanel(true)

		arg0_69.animPlaying = true

		local var3_74 = (table.indexof(var1_74, _.detect(var1_74, function(arg0_75)
			return arg0_75:GetConfigID() == var2_74
		end)) or 0) + 1
		local var4_74 = _.rest(var1_74, var3_74)
		local var5_74 = arg1_74:Find("Slider"):GetComponent(typeof(Slider))

		setActive(arg1_74:Find("Slider"), true)

		local function var6_74()
			setActive(arg1_74:Find("Selected"), true)
			setActive(arg1_74:Find("Slider"), false)
			arg0_69:BlockActionPanel(false)

			arg0_69.animPlaying = nil
		end

		if #var4_74 == 0 then
			var6_74()

			return
		end

		local function var7_74(arg0_77, arg1_77, arg2_77)
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayEnterSceneAnim", arg0_77:GetEnterSceneAnim(), arg2_77 ~= arg1_77, arg0_69.animSpeed)
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayEnterExtraItem", arg0_77:GetEnterExtraItem(), arg0_69.animSpeed)
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideSceneItem", arg0_77:GetHideSceneItem())

			arg0_69.cacheSceneAnim = arg0_77:GetEnterSceneAnim()
			arg0_69.cacheExtraItem = arg0_77:GetEnterExtraItem()
		end

		local var8_74 = _.reduce(var4_74, 0, function(arg0_78, arg1_78)
			return arg0_78 + math.max(var2_0, arg1_78:GetAnimTime())
		end)

		if arg0_69.timerAnim then
			arg0_69.timerAnim:Stop()
		end

		arg0_69.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_74,
			totalTime = var8_74,
			startStamp = Time.time
		}
		arg0_69.timerAnim = FrameTimer.New(function()
			local var0_79 = arg0_69.animInfo
			local var1_79 = var0_79.animPlayList[var0_79.index]
			local var2_79 = math.max(var2_0, var1_79:GetAnimTime())
			local var3_79 = var0_79.startStamp
			local var4_79 = Time.time
			local var5_79 = math.min(1, var0_79.ratio + (var4_79 - var3_79) * arg0_69.animSpeed / var2_79)
			local var6_79 = var0_79.passedTime + var2_79 * var5_79

			var5_74.value = var6_79 / var8_74

			if var5_79 < 1 then
				return
			end

			var0_79.index = var0_79.index + 1
			var0_79.ratio = 0
			var0_79.passedTime = var0_79.passedTime + var2_79
			var0_79.startStamp = var4_79

			local var7_79 = var1_79:GetStartPoint()

			if #var7_79 > 0 then
				arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var7_79)
			end

			if var0_79.index > #var0_79.animPlayList then
				var6_74()
				arg0_69.timerAnim:Stop()

				arg0_69.timerAnim = nil
				arg0_69.animInfo = nil

				return
			end

			local var8_79 = var0_79.animPlayList[var0_79.index]

			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var8_79:GetStateName(), nil, 0)
			var7_74(var8_79, var0_74, var2_74)
		end, 1, -1)

		local var9_74 = arg0_69.animInfo.animPlayList[1]

		if var3_74 == 1 then
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCurrentAnim", var9_74:GetStateName())
			onNextTick(function()
				local var0_80 = var9_74:GetStartPoint()

				if #var0_80 == 0 then
					var0_80 = var0_69:GetWatchCameraName()
				end

				arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var0_80)
				arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")
				var7_74(var9_74, var0_74, var2_74)

				if arg0_69.freeMode then
					local var1_80 = arg0_69.scene.cameras[arg0_69.scene.CAMERA.PHOTO_FREE]
					local var2_80 = var1_80:GetComponent(typeof(UnityEngine.CharacterController))
					local var3_80 = var1_80.transform.forward

					var3_80.y = 0

					var3_80:Normalize()

					local var4_80 = var3_80 * -0.01

					var2_80:Move(var4_80)
					var2_80:Move(-var4_80)
				end
			end)
		else
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var9_74:GetStateName(), nil, 0)
			var7_74(var9_74, var0_74, var2_74)
		end

		arg0_69.timerAnim:Start()
	end

	UIItemList.StaticAlign(var2_69, var2_69:GetChild(0), #var1_69, function(arg0_81, arg1_81, arg2_81)
		if arg0_81 ~= UIItemList.EventUpdate then
			return
		end

		arg1_81 = arg1_81 + 1

		local var0_81 = var1_69[arg1_81]

		setText(arg2_81:Find("Name"), var0_81:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_81:GetZoneIcon()), "", arg2_81:Find("Icon"))
		setActive(arg2_81:Find("Slider"), false)
		setActive(arg2_81:Find("Selected"), false)
		onButton(arg0_69, arg2_81, function()
			var7_69(var0_81, arg2_81)
		end)
	end)

	local function var8_69()
		UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_84, arg1_84, arg2_84)
			if arg0_84 ~= UIItemList.EventUpdate then
				return
			end

			arg1_84 = arg1_84 + 1

			local var0_84 = var3_69[arg1_84].anims
			local var1_84 = arg2_84:Find("Actions")

			UIItemList.StaticAlign(var1_84, var1_84:GetChild(0), #var0_84, function(arg0_85, arg1_85, arg2_85)
				if arg0_85 ~= UIItemList.EventUpdate then
					return
				end

				arg1_85 = arg1_85 + 1

				local var0_85 = var0_84[arg1_85]

				setActive(arg2_85:Find("Selected"), var0_85:GetConfigID() == arg0_69.animID)
				setActive(arg2_85:Find("Slider"), var0_85:GetConfigID() == arg0_69.animID and tobool(arg0_69.timerAnim))
			end)
		end)
	end

	local function var9_69()
		UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_87, arg1_87, arg2_87)
			if arg0_87 ~= UIItemList.EventUpdate then
				return
			end

			arg1_87 = arg1_87 + 1

			setActive(arg2_87:Find("Button/Active"), arg0_69.settingSpecialFurnitureIndex == arg1_87)
			setActive(arg2_87:Find("Actions"), arg0_69.settingSpecialFurnitureIndex == arg1_87)
		end)
		var8_69()
	end

	local function var10_69(arg0_88, arg1_88)
		local var0_88 = arg1_88:Find("Actions")
		local var1_88 = arg0_88.anims

		UIItemList.StaticAlign(var0_88, var0_88:GetChild(0), #var1_88, function(arg0_89, arg1_89, arg2_89)
			if arg0_89 ~= UIItemList.EventUpdate then
				return
			end

			arg1_89 = arg1_89 + 1

			local var0_89 = var1_88[arg1_89]
			local var1_89 = var0_69:CheckFurnitureIdInZone(arg0_88.furnitureId)
			local var2_89 = arg0_69.room:IsFurnitureSetIn(arg0_88.furnitureId)
			local var3_89 = var1_89 and var2_89

			SetActive(arg2_89:Find("Other"), not var3_89)
			SetActive(arg2_89:Find("Name"), var3_89)

			if var3_89 then
				onButton(arg0_69, arg2_89, function()
					var7_69(var0_89, arg2_89)
				end)
				setText(arg2_89:Find("Name"), var0_89:GetName())
			else
				removeOnButton(arg2_89)

				if not var1_89 then
					local var4_89 = var0_89:GetZoneName()

					warnText = i18n("dorm3d_photo_active_zone", var4_89)
				else
					warnText = i18n("dorm3d_furniture_replace_tip")
				end

				setText(arg2_89:Find("Other/Content"), warnText)
			end

			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_89:GetZoneIcon()), "", arg2_89:Find("Icon"))
			setActive(arg2_89:Find("Slider"), false)
			setActive(arg2_89:Find("Selected"), false)
		end)
	end

	setActive(var4_69, #var3_69 > 0)
	UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_91, arg1_91, arg2_91)
		if arg0_91 ~= UIItemList.EventUpdate then
			return
		end

		arg1_91 = arg1_91 + 1

		local var0_91 = var3_69[arg1_91]
		local var1_91 = Dorm3dFurniture.New({
			configId = var0_91.furnitureId
		})
		local var2_91 = tobool(_.detect(arg0_69.room:GetFurnitures(), function(arg0_92)
			return arg0_92:GetConfigID() == var0_91.furnitureId
		end))

		setText(arg2_91:Find("Button/Name"), var1_91:GetName())
		GetImageSpriteFromAtlasAsync(var1_91:GetIcon(), "", arg2_91:Find("Button/Icon"))
		setActive(arg2_91:Find("Button/Lock"), not var2_91)
		setActive(arg2_91:Find("Button/BG"), var2_91)

		local var3_91 = var0_69:CheckFurnitureIdInZone(var0_91.furnitureId)
		local var4_91

		if var3_91 then
			var4_91 = Color.New(1, 1, 1, 0.850980392156863)
		else
			var4_91 = Color.New(0.788235294117647, 0.788235294117647, 0.788235294117647, 0.850980392156863)
		end

		setImageColor(arg2_91:Find("Button/BG"), var4_91)
		onButton(arg0_69, arg2_91:Find("Button"), function()
			if not var2_91 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_furniture_locked"))

				return
			end

			if arg0_69.settingSpecialFurnitureIndex == arg1_91 then
				arg0_69.settingSpecialFurnitureIndex = nil
			else
				arg0_69.settingSpecialFurnitureIndex = arg1_91
			end

			var9_69()
		end)
		var10_69(var0_91, arg2_91)
	end)
	var9_69()
	var6_69()
end

function var0_0.BlockActionPanel(arg0_94, arg1_94)
	return
end

function var0_0.GetAnimPlayList(arg0_95, arg1_95)
	local var0_95 = arg1_95
	local var1_95 = {}
	local var2_95 = 100

	while true do
		local var3_95 = Dorm3dCameraAnim.New({
			configId = var0_95
		})

		if not var3_95 then
			return var1_95
		end

		table.insert(var1_95, 1, var3_95)

		var0_95 = var3_95:GetPreAnimID()

		if var0_95 == 0 then
			return var1_95
		end

		var2_95 = var2_95 - 1

		assert(var2_95 > 0)
	end
end

function var0_0.UpdateCameraPanel(arg0_96)
	if not arg0_96.activeSetting then
		return
	end

	if arg0_96.activePanel ~= var0_0.PANEL.CAMERA then
		return
	end

	;(function()
		local var0_97 = arg0_96.panelCamera:Find("Layout/DepthOfField/Switch/Toggle")

		triggerToggle(var0_97, arg0_96.cameraSettings.depthOfField.enabled)
		onToggle(arg0_96, var0_97, function(arg0_98)
			arg0_96.cameraSettings.depthOfField.enabled = arg0_98

			setActive(arg0_96.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_96.cameraSettings.depthOfField.enabled)
			arg0_96:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	setActive(arg0_96.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_96.cameraSettings.depthOfField.enabled)
	;(function()
		local var0_99 = arg0_96.cameraSettings.depthOfField.focusDistance
		local var1_99 = arg0_96.panelCamera:Find("Layout/DepthOfField/DepthOfField/FocusDistance/Slider")

		setSlider(var1_99, var0_99.min, var0_99.max, var0_99.value)
		onSlider(arg0_96, var1_99, function(arg0_100)
			var0_99.value = arg0_100

			arg0_96:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_101 = arg0_96.cameraSettings.depthOfField.blurRadius
		local var1_101 = arg0_96.panelCamera:Find("Layout/DepthOfField/DepthOfField/BlurRadius/Slider")

		setSlider(var1_101, var0_101.min, var0_101.max, var0_101.value)
		onSlider(arg0_96, var1_101, function(arg0_102)
			var0_101.value = arg0_102

			arg0_96:RefreshCamera()
		end)
	end)()

	local var0_96 = {
		"PostExposure",
		"Saturation",
		"Contrast"
	}

	arg0_96.paramIndex = arg0_96.paramIndex or 1

	local function var1_96()
		table.Ipairs(var0_96, function(arg0_104, arg1_104)
			local var0_104 = arg0_96.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_104 - 1)

			setActive(var0_104:Find("Selected"), arg0_104 == arg0_96.paramIndex)
			setActive(arg0_96.panelCamera:Find("Layout/Paramaters/" .. arg1_104), arg0_104 == arg0_96.paramIndex)
		end)
	end

	table.Ipairs(var0_96, function(arg0_105, arg1_105)
		local var0_105 = arg0_96.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_105 - 1)

		onButton(arg0_96, var0_105, function()
			arg0_96.paramIndex = arg0_105

			var1_96()
		end, SFX_PANEL)
	end)
	var1_96()
	;(function()
		local var0_107 = arg0_96.cameraSettings.postExposure
		local var1_107 = arg0_96.panelCamera:Find("Layout/Paramaters/PostExposure/PostExposure/Slider")
		local var2_107 = var1_107:Find("Background/Fill")

		onSlider(arg0_96, var1_107, function(arg0_108)
			var0_107.value = arg0_108

			local var0_108 = (arg0_108 - var0_107.min) / (var0_107.max - var0_107.min)
			local var1_108 = math.min(var0_108, 0.5)
			local var2_108 = math.max(var0_108, 0.5)

			var2_107.anchorMin = Vector2.New(var1_108, 0)
			var2_107.anchorMax = Vector2.New(var2_108, 1)
			var2_107.offsetMin = Vector2.zero
			var2_107.offsetMax = Vector2.zero

			arg0_96:RefreshCamera()
		end)
		setSlider(var1_107, var0_107.min, var0_107.max, var0_107.value)
	end)()
	;(function()
		local var0_109 = arg0_96.cameraSettings.contrast
		local var1_109 = arg0_96.panelCamera:Find("Layout/Paramaters/Contrast/Contrast/Slider")
		local var2_109 = var1_109:Find("Background/Fill")

		onSlider(arg0_96, var1_109, function(arg0_110)
			var0_109.value = arg0_110

			local var0_110 = (arg0_110 - var0_109.min) / (var0_109.max - var0_109.min)
			local var1_110 = math.min(var0_110, 0.5)
			local var2_110 = math.max(var0_110, 0.5)

			var2_109.anchorMin = Vector2.New(var1_110, 0)
			var2_109.anchorMax = Vector2.New(var2_110, 1)
			var2_109.offsetMin = Vector2.zero
			var2_109.offsetMax = Vector2.zero

			arg0_96:RefreshCamera()
		end)
		setSlider(var1_109, var0_109.min, var0_109.max, var0_109.value)
	end)()
	;(function()
		local var0_111 = arg0_96.cameraSettings.saturate
		local var1_111 = arg0_96.panelCamera:Find("Layout/Paramaters/Saturation/Saturation/Slider")
		local var2_111 = var1_111:Find("Background/Fill")

		onSlider(arg0_96, var1_111, function(arg0_112)
			var0_111.value = arg0_112

			local var0_112 = (arg0_112 - var0_111.min) / (var0_111.max - var0_111.min)
			local var1_112 = math.min(var0_112, 0.5)
			local var2_112 = math.max(var0_112, 0.5)

			var2_111.anchorMin = Vector2.New(var1_112, 0)
			var2_111.anchorMax = Vector2.New(var2_112, 1)
			var2_111.offsetMin = Vector2.zero
			var2_111.offsetMax = Vector2.zero

			arg0_96:RefreshCamera()
		end)
		setSlider(var1_111, var0_111.min, var0_111.max, var0_111.value)
	end)()
	;(function()
		local var0_113 = arg0_96.panelCamera:Find("Layout/Other/FaceCamera/Toggle")

		triggerToggle(var0_113, arg0_96.settingFaceCamera)
		onToggle(arg0_96, var0_113, function(arg0_114)
			arg0_96.settingFaceCamera = arg0_114

			arg0_96.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableCurrentHeadIK", arg0_114)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_115 = arg0_96.panelCamera:Find("Layout/Other/HideCharacter/Toggle")

		triggerToggle(var0_115, arg0_96.settingHideCharacter)
		onToggle(arg0_96, var0_115, function(arg0_116)
			arg0_96.settingHideCharacter = arg0_116

			if arg0_116 then
				arg0_96.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			else
				arg0_96.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0_0.RefreshCamera(arg0_117)
	arg0_117.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SettingCamera", arg0_117.cameraSettings)
end

function var0_0.SetAllAnimSpeed(arg0_118, arg1_118)
	arg0_118.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", arg1_118)
	arg0_118.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetSceneAnimSpeed", arg0_118.cacheSceneAnim, arg1_118)
	arg0_118.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetExtraAnimSpeed", arg0_118.cacheExtraItem, arg1_118)
end

function var0_0.UpdateAnimSpeedPanel(arg0_119)
	local function var0_119()
		if not arg0_119.timerAnim then
			return
		end

		local var0_120 = arg0_119.animInfo
		local var1_120 = var0_120.animPlayList[var0_120.index]
		local var2_120 = math.max(var2_0, var1_120:GetAnimTime())
		local var3_120 = var0_120.startStamp
		local var4_120 = Time.time

		var0_120.ratio = math.min(1, var0_120.ratio + (var4_120 - var3_120) * arg0_119.animSpeed / var2_120)
		var0_120.startStamp = var4_120
	end

	local var1_119 = arg0_119.animSpeeds

	UIItemList.StaticAlign(arg0_119.listAnimSpeed, arg0_119.listAnimSpeed:GetChild(0), #var1_119, function(arg0_121, arg1_121, arg2_121)
		if arg0_121 ~= UIItemList.EventUpdate then
			return
		end

		arg1_121 = #var1_119 - arg1_121

		local var0_121 = var1_119[arg1_121]

		setText(arg2_121:Find("Name"), var0_121)
		setText(arg2_121:Find("Selected"), var0_121)
		setActive(arg2_121:Find("Line"), arg1_121 ~= #var1_119)
		onButton(arg0_119, arg2_121, function()
			if arg0_119.animSpeed == var0_121 then
				return
			end

			var0_119()

			arg0_119.animSpeed = var0_121

			arg0_119:SetAllAnimSpeed(var0_121)
			arg0_119:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0_119, arg0_119.btnFreeze, function()
		local var0_123 = 0

		if arg0_119.animSpeed ~= 0 then
			arg0_119.lastAnimSpeed = arg0_119.animSpeed
		else
			var0_123 = arg0_119.lastAnimSpeed or 1
			arg0_119.lastAnimSpeed = nil
		end

		var0_119()

		arg0_119.animSpeed = var0_123

		arg0_119:SetAllAnimSpeed(var0_123)
		arg0_119:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_119.listAnimSpeed, arg0_119.listAnimSpeed:GetChild(0), #var1_119, function(arg0_124, arg1_124, arg2_124)
		if arg0_124 ~= UIItemList.EventUpdate then
			return
		end

		arg1_124 = #var1_119 - arg1_124

		local var0_124 = var1_119[arg1_124]

		setActive(arg2_124:Find("Name"), arg0_119.animSpeed ~= var0_124)
		setActive(arg2_124:Find("Selected"), arg0_119.animSpeed == var0_124)
	end)
	setActive(arg0_119.btnFreeze:Find("Icon"), arg0_119.animSpeed ~= 0)
	setActive(arg0_119.btnFreeze:Find("Selected"), arg0_119.animSpeed == 0)
	setText(arg0_119.textAnimSpeed, i18n("dorm3d_photo_animspeed", string.format("%.1f", arg0_119.animSpeed)))
end

function var0_0.UpdateLightingPanel(arg0_125)
	if not arg0_125.activeSetting then
		return
	end

	if arg0_125.activePanel ~= var0_0.PANEL.LIGHTING then
		return
	end

	local var0_125 = {}

	for iter0_125, iter1_125 in ipairs(pg.dorm3d_camera_volume_template.all) do
		table.insert(var0_125, iter1_125)
	end

	table.sort(var0_125, function(arg0_126, arg1_126)
		return arg0_126 < arg1_126
	end)

	local function var1_125()
		if not arg0_125.settingFilterIndex then
			arg0_125.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")

			return
		end

		local var0_127 = pg.dorm3d_camera_volume_template[var0_125[arg0_125.settingFilterIndex]]

		arg0_125.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetVolumeProfile", var0_127.volume, arg0_125.settingFilterStrength)
	end

	UIItemList.StaticAlign(arg0_125.panelLightning:Find("Layout/Filter/List"), arg0_125.panelLightning:Find("Layout/Filter/List"):GetChild(0), #var0_125, function(arg0_128, arg1_128, arg2_128)
		if arg0_128 ~= UIItemList.EventUpdate then
			return
		end

		arg1_128 = arg1_128 + 1

		local var0_128 = pg.dorm3d_camera_volume_template[var0_125[arg1_128]]

		setText(arg2_128:Find("Name"), var0_128.name)

		var0_128.icon = ""

		if var0_128.icon ~= "" then
			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_128.icon), "", arg2_128:Find("BG"))
		end

		if arg0_125.settingFilterIndex == arg1_128 then
			setActive(arg2_128:Find("Selected"), true)
		else
			setActive(arg2_128:Find("Selected"), false)
		end

		local var1_128, var2_128 = ApartmentProxy.CheckUnlockConfig(var0_128.unlock)

		setActive(arg2_128:Find("lock"), not var1_128)

		if not var1_128 then
			setText(arg2_128:Find("lock/Image/Text"), var0_128.unlock_text)
		end

		onButton(arg0_125, arg2_128, function()
			if not var1_128 then
				pg.TipsMgr.GetInstance():ShowTips(var2_128)

				return
			end

			local var0_129 = arg0_125.settingFilterIndex

			if arg0_125.settingFilterIndex ~= arg1_128 then
				arg0_125.settingFilterIndex = arg1_128
			else
				arg0_125.settingFilterIndex = nil
			end

			var1_125()

			if var0_129 then
				local var1_129 = arg0_125.panelLightning:Find("Layout/Filter/List"):GetChild(var0_129 - 1)

				setActive(var1_129:Find("Selected"), false)
			end

			if arg0_125.settingFilterIndex == arg1_128 then
				setActive(arg2_128:Find("Selected"), true)
			end
		end, SFX_PANEL)
	end)
	setActive(arg0_125.panelLightning:Find("Layout/Filter/Slider"), false)
end

function var0_0.OnSwitchSkin(arg0_130, arg1_130, arg2_130, arg3_130)
	seriesAsync({
		function(arg0_131)
			if arg0_130.settingHideCharacter then
				arg0_130.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end

			arg1_130:SwitchCharacterSkin(arg2_130, arg3_130, arg0_131)
		end,
		function(arg0_132)
			setActive(arg1_130.ladySafeCollider, true)

			if not arg0_130.animInfo then
				return arg0_132()
			end

			local var0_132 = arg0_130.animInfo

			for iter0_132 = #var0_132.animPlayList, 1, -1 do
				local var1_132 = var0_132.animPlayList[iter0_132]:GetStartPoint()

				if #var1_132 > 0 then
					arg0_130.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var1_132)

					break
				end

				if iter0_132 == 1 then
					local var2_132 = arg0_130.room:GetCameraZones()[arg0_130.zoneIndex]

					arg0_130.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var2_132:GetWatchCameraName())
				end
			end

			arg0_130.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

			local var3_132 = var0_132.animPlayList[#var0_132.animPlayList]
			local var4_132 = var3_132:GetAnimTime()

			arg0_130.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var3_132:GetStateName())
			arg0_130.scene.ladyDict[arg2_130].ladyAnimator:Update(var4_132)
			arg0_130.timerAnim:Stop()

			arg0_130.timerAnim = nil
			arg0_130.animInfo = nil
			arg0_130.animPlaying = nil

			arg0_132()
		end,
		function()
			arg0_130:UpdateActionPanel()

			if arg0_130.settingHideCharacter then
				arg0_130.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			end
		end
	})
end

function var0_0.SetMute(arg0_134)
	if arg0_134 then
		pg.CriMgr.GetInstance():MuteAllVolume()
	else
		pg.CriMgr.GetInstance():ResetAllVolume()
	end
end

function var0_0.willExit(arg0_135)
	arg0_135.loader:Clear()

	if arg0_135.timerAnim then
		arg0_135.timerAnim:Stop()

		arg0_135.timerAnim = nil
	end

	if arg0_135.animSpeed ~= 1 then
		arg0_135:SetAllAnimSpeed(1)
	end

	if arg0_135.settingHideCharacter then
		arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
	end

	if not arg0_135.settingFaceCamera then
		arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableCurrentHeadIK", true)
	end

	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetSceneItemAnimators")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCharacterExtraItem")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetTempHideSceneItems")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterLight")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCameraSettings")
	arg0_135.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ExitPhotoMode")
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
