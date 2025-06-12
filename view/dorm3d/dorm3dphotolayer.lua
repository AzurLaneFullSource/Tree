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

						arg0_7:findTF("Text", arg0_7.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

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

			arg0_7:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_28 and 1 or 0
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

		tolua.loadassembly("Yongshi.BLHotUpdate.Runtime.Rendering")
		ReflectionHelp.RefCallStaticMethodEx(typeof("BLHX.Rendering.HotUpdate.ScreenShooterPass"), "TakePhoto", {
			typeof(Camera),
			typeof("UnityEngine.Events.UnityAction`1[UnityEngine.Object]")
		}, {
			arg0_7.mainCamera,
			UnityEngine.Events.UnityAction_UnityEngine_Object(var3_32)
		})
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
	arg0_63.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", arg0_63.animSpeed)
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

		local var7_74 = _.reduce(var4_74, 0, function(arg0_77, arg1_77)
			return arg0_77 + math.max(var2_0, arg1_77:GetAnimTime())
		end)

		if arg0_69.timerAnim then
			arg0_69.timerAnim:Stop()
		end

		arg0_69.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_74,
			totalTime = var7_74,
			startStamp = Time.time
		}
		arg0_69.timerAnim = FrameTimer.New(function()
			local var0_78 = arg0_69.animInfo
			local var1_78 = var0_78.animPlayList[var0_78.index]
			local var2_78 = math.max(var2_0, var1_78:GetAnimTime())
			local var3_78 = var0_78.startStamp
			local var4_78 = Time.time
			local var5_78 = math.min(1, var0_78.ratio + (var4_78 - var3_78) * arg0_69.animSpeed / var2_78)
			local var6_78 = var0_78.passedTime + var2_78 * var5_78

			var5_74.value = var6_78 / var7_74

			if var5_78 < 1 then
				return
			end

			var0_78.index = var0_78.index + 1
			var0_78.ratio = 0
			var0_78.passedTime = var0_78.passedTime + var2_78
			var0_78.startStamp = var4_78

			local var7_78 = var1_78:GetStartPoint()

			if #var7_78 > 0 then
				arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var7_78)
			end

			if var0_78.index > #var0_78.animPlayList then
				var6_74()
				arg0_69.timerAnim:Stop()

				arg0_69.timerAnim = nil
				arg0_69.animInfo = nil

				return
			end

			local var8_78 = var0_78.animPlayList[var0_78.index]

			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var8_78:GetStateName())
		end, 1, -1)

		local var8_74 = arg0_69.animInfo.animPlayList[1]

		if var3_74 == 1 then
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SwitchCurrentAnim", var8_74:GetStateName())
			onNextTick(function()
				local var0_79 = var8_74:GetStartPoint()

				if #var0_79 == 0 then
					var0_79 = var0_69:GetWatchCameraName()
				end

				arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var0_79)
				arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

				if arg0_69.freeMode then
					local var1_79 = arg0_69.scene.cameras[arg0_69.scene.CAMERA.PHOTO_FREE]
					local var2_79 = var1_79:GetComponent(typeof(UnityEngine.CharacterController))
					local var3_79 = var1_79.transform.forward

					var3_79.y = 0

					var3_79:Normalize()

					local var4_79 = var3_79 * -0.01

					var2_79:Move(var4_79)
					var2_79:Move(-var4_79)
				end
			end)
		else
			arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var8_74:GetStateName())
		end

		arg0_69.timerAnim:Start()
	end

	UIItemList.StaticAlign(var2_69, var2_69:GetChild(0), #var1_69, function(arg0_80, arg1_80, arg2_80)
		if arg0_80 ~= UIItemList.EventUpdate then
			return
		end

		arg1_80 = arg1_80 + 1

		local var0_80 = var1_69[arg1_80]

		setText(arg2_80:Find("Name"), var0_80:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_80:GetZoneIcon()), "", arg2_80:Find("Icon"))
		setActive(arg2_80:Find("Slider"), false)
		setActive(arg2_80:Find("Selected"), false)
		onButton(arg0_69, arg2_80, function()
			var7_69(var0_80, arg2_80)
		end)
	end)

	local function var8_69()
		UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_83, arg1_83, arg2_83)
			if arg0_83 ~= UIItemList.EventUpdate then
				return
			end

			arg1_83 = arg1_83 + 1

			local var0_83 = var3_69[arg1_83].anims
			local var1_83 = arg2_83:Find("Actions")

			UIItemList.StaticAlign(var1_83, var1_83:GetChild(0), #var0_83, function(arg0_84, arg1_84, arg2_84)
				if arg0_84 ~= UIItemList.EventUpdate then
					return
				end

				arg1_84 = arg1_84 + 1

				local var0_84 = var0_83[arg1_84]

				setActive(arg2_84:Find("Selected"), var0_84:GetConfigID() == arg0_69.animID)
				setActive(arg2_84:Find("Slider"), var0_84:GetConfigID() == arg0_69.animID and tobool(arg0_69.timerAnim))
			end)
		end)
	end

	local function var9_69()
		UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_86, arg1_86, arg2_86)
			if arg0_86 ~= UIItemList.EventUpdate then
				return
			end

			arg1_86 = arg1_86 + 1

			setActive(arg2_86:Find("Button/Active"), arg0_69.settingSpecialFurnitureIndex == arg1_86)
			setActive(arg2_86:Find("Actions"), arg0_69.settingSpecialFurnitureIndex == arg1_86)
		end)
		var8_69()
	end

	local function var10_69(arg0_87, arg1_87)
		local var0_87 = arg1_87:Find("Actions")
		local var1_87 = arg0_87.anims

		UIItemList.StaticAlign(var0_87, var0_87:GetChild(0), #var1_87, function(arg0_88, arg1_88, arg2_88)
			if arg0_88 ~= UIItemList.EventUpdate then
				return
			end

			arg1_88 = arg1_88 + 1

			local var0_88 = var1_87[arg1_88]
			local var1_88 = var0_69:CheckFurnitureIdInZone(arg0_87.furnitureId)
			local var2_88 = arg0_69.room:IsFurnitureSetIn(arg0_87.furnitureId)
			local var3_88 = var1_88 and var2_88

			SetActive(arg2_88:Find("Other"), not var3_88)
			SetActive(arg2_88:Find("Name"), var3_88)

			if var3_88 then
				onButton(arg0_69, arg2_88, function()
					arg0_69.room:ReplaceFurniture(arg0_87.slotId, arg0_87.furnitureId)
					arg0_69.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RefreshSlots", arg0_69.room)
					var7_69(var0_88, arg2_88)
				end)
				setText(arg2_88:Find("Name"), var0_88:GetName())
			else
				removeOnButton(arg2_88)

				if not var1_88 then
					local var4_88 = var0_88:GetZoneName()

					warnText = i18n("dorm3d_photo_active_zone", var4_88)
				else
					warnText = i18n("dorm3d_furniture_replace_tip")
				end

				setText(arg2_88:Find("Other/Content"), warnText)
			end

			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_88:GetZoneIcon()), "", arg2_88:Find("Icon"))
			setActive(arg2_88:Find("Slider"), false)
			setActive(arg2_88:Find("Selected"), false)
		end)
	end

	setActive(var4_69, #var3_69 > 0)
	UIItemList.StaticAlign(var4_69, var4_69:GetChild(0), #var3_69, function(arg0_90, arg1_90, arg2_90)
		if arg0_90 ~= UIItemList.EventUpdate then
			return
		end

		arg1_90 = arg1_90 + 1

		local var0_90 = var3_69[arg1_90]
		local var1_90 = Dorm3dFurniture.New({
			configId = var0_90.furnitureId
		})
		local var2_90 = tobool(_.detect(arg0_69.room:GetFurnitures(), function(arg0_91)
			return arg0_91:GetConfigID() == var0_90.furnitureId
		end))

		setText(arg2_90:Find("Button/Name"), var1_90:GetName())
		GetImageSpriteFromAtlasAsync(var1_90:GetIcon(), "", arg2_90:Find("Button/Icon"))
		setActive(arg2_90:Find("Button/Lock"), not var2_90)
		setActive(arg2_90:Find("Button/BG"), var2_90)

		local var3_90 = var0_69:CheckFurnitureIdInZone(var0_90.furnitureId)
		local var4_90

		if var3_90 then
			var4_90 = Color.New(1, 1, 1, 0.850980392156863)
		else
			var4_90 = Color.New(0.788235294117647, 0.788235294117647, 0.788235294117647, 0.850980392156863)
		end

		setImageColor(arg2_90:Find("Button/BG"), var4_90)
		onButton(arg0_69, arg2_90:Find("Button"), function()
			if not var2_90 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_furniture_locked"))

				return
			end

			if arg0_69.settingSpecialFurnitureIndex == arg1_90 then
				arg0_69.settingSpecialFurnitureIndex = nil
			else
				arg0_69.settingSpecialFurnitureIndex = arg1_90
			end

			var9_69()
		end)
		var10_69(var0_90, arg2_90)
	end)
	var9_69()
	var6_69()
end

function var0_0.BlockActionPanel(arg0_93, arg1_93)
	return
end

function var0_0.GetAnimPlayList(arg0_94, arg1_94)
	local var0_94 = arg1_94
	local var1_94 = {}
	local var2_94 = 100

	while true do
		local var3_94 = Dorm3dCameraAnim.New({
			configId = var0_94
		})

		if not var3_94 then
			return var1_94
		end

		table.insert(var1_94, 1, var3_94)

		var0_94 = var3_94:GetPreAnimID()

		if var0_94 == 0 then
			return var1_94
		end

		var2_94 = var2_94 - 1

		assert(var2_94 > 0)
	end
end

function var0_0.UpdateCameraPanel(arg0_95)
	if not arg0_95.activeSetting then
		return
	end

	if arg0_95.activePanel ~= var0_0.PANEL.CAMERA then
		return
	end

	;(function()
		local var0_96 = arg0_95.panelCamera:Find("Layout/DepthOfField/Switch/Toggle")

		triggerToggle(var0_96, arg0_95.cameraSettings.depthOfField.enabled)
		onToggle(arg0_95, var0_96, function(arg0_97)
			arg0_95.cameraSettings.depthOfField.enabled = arg0_97

			setActive(arg0_95.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_95.cameraSettings.depthOfField.enabled)
			arg0_95:RefreshCamera()
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	setActive(arg0_95.panelCamera:Find("Layout/DepthOfField/DepthOfField"), arg0_95.cameraSettings.depthOfField.enabled)
	;(function()
		local var0_98 = arg0_95.cameraSettings.depthOfField.focusDistance
		local var1_98 = arg0_95.panelCamera:Find("Layout/DepthOfField/DepthOfField/FocusDistance/Slider")

		setSlider(var1_98, var0_98.min, var0_98.max, var0_98.value)
		onSlider(arg0_95, var1_98, function(arg0_99)
			var0_98.value = arg0_99

			arg0_95:RefreshCamera()
		end)
	end)()
	;(function()
		local var0_100 = arg0_95.cameraSettings.depthOfField.blurRadius
		local var1_100 = arg0_95.panelCamera:Find("Layout/DepthOfField/DepthOfField/BlurRadius/Slider")

		setSlider(var1_100, var0_100.min, var0_100.max, var0_100.value)
		onSlider(arg0_95, var1_100, function(arg0_101)
			var0_100.value = arg0_101

			arg0_95:RefreshCamera()
		end)
	end)()

	local var0_95 = {
		"PostExposure",
		"Saturation",
		"Contrast"
	}

	arg0_95.paramIndex = arg0_95.paramIndex or 1

	local function var1_95()
		table.Ipairs(var0_95, function(arg0_103, arg1_103)
			local var0_103 = arg0_95.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_103 - 1)

			setActive(var0_103:Find("Selected"), arg0_103 == arg0_95.paramIndex)
			setActive(arg0_95.panelCamera:Find("Layout/Paramaters/" .. arg1_103), arg0_103 == arg0_95.paramIndex)
		end)
	end

	table.Ipairs(var0_95, function(arg0_104, arg1_104)
		local var0_104 = arg0_95.panelCamera:Find("Layout/Paramaters/Icons"):GetChild(arg0_104 - 1)

		onButton(arg0_95, var0_104, function()
			arg0_95.paramIndex = arg0_104

			var1_95()
		end, SFX_PANEL)
	end)
	var1_95()
	;(function()
		local var0_106 = arg0_95.cameraSettings.postExposure
		local var1_106 = arg0_95.panelCamera:Find("Layout/Paramaters/PostExposure/PostExposure/Slider")
		local var2_106 = var1_106:Find("Background/Fill")

		onSlider(arg0_95, var1_106, function(arg0_107)
			var0_106.value = arg0_107

			local var0_107 = (arg0_107 - var0_106.min) / (var0_106.max - var0_106.min)
			local var1_107 = math.min(var0_107, 0.5)
			local var2_107 = math.max(var0_107, 0.5)

			var2_106.anchorMin = Vector2.New(var1_107, 0)
			var2_106.anchorMax = Vector2.New(var2_107, 1)
			var2_106.offsetMin = Vector2.zero
			var2_106.offsetMax = Vector2.zero

			arg0_95:RefreshCamera()
		end)
		setSlider(var1_106, var0_106.min, var0_106.max, var0_106.value)
	end)()
	;(function()
		local var0_108 = arg0_95.cameraSettings.contrast
		local var1_108 = arg0_95.panelCamera:Find("Layout/Paramaters/Contrast/Contrast/Slider")
		local var2_108 = var1_108:Find("Background/Fill")

		onSlider(arg0_95, var1_108, function(arg0_109)
			var0_108.value = arg0_109

			local var0_109 = (arg0_109 - var0_108.min) / (var0_108.max - var0_108.min)
			local var1_109 = math.min(var0_109, 0.5)
			local var2_109 = math.max(var0_109, 0.5)

			var2_108.anchorMin = Vector2.New(var1_109, 0)
			var2_108.anchorMax = Vector2.New(var2_109, 1)
			var2_108.offsetMin = Vector2.zero
			var2_108.offsetMax = Vector2.zero

			arg0_95:RefreshCamera()
		end)
		setSlider(var1_108, var0_108.min, var0_108.max, var0_108.value)
	end)()
	;(function()
		local var0_110 = arg0_95.cameraSettings.saturate
		local var1_110 = arg0_95.panelCamera:Find("Layout/Paramaters/Saturation/Saturation/Slider")
		local var2_110 = var1_110:Find("Background/Fill")

		onSlider(arg0_95, var1_110, function(arg0_111)
			var0_110.value = arg0_111

			local var0_111 = (arg0_111 - var0_110.min) / (var0_110.max - var0_110.min)
			local var1_111 = math.min(var0_111, 0.5)
			local var2_111 = math.max(var0_111, 0.5)

			var2_110.anchorMin = Vector2.New(var1_111, 0)
			var2_110.anchorMax = Vector2.New(var2_111, 1)
			var2_110.offsetMin = Vector2.zero
			var2_110.offsetMax = Vector2.zero

			arg0_95:RefreshCamera()
		end)
		setSlider(var1_110, var0_110.min, var0_110.max, var0_110.value)
	end)()
	;(function()
		local var0_112 = arg0_95.panelCamera:Find("Layout/Other/FaceCamera/Toggle")

		triggerToggle(var0_112, arg0_95.settingFaceCamera)
		onToggle(arg0_95, var0_112, function(arg0_113)
			arg0_95.settingFaceCamera = arg0_113

			arg0_95.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableCurrentHeadIK", arg0_113)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
	;(function()
		local var0_114 = arg0_95.panelCamera:Find("Layout/Other/HideCharacter/Toggle")

		triggerToggle(var0_114, arg0_95.settingHideCharacter)
		onToggle(arg0_95, var0_114, function(arg0_115)
			arg0_95.settingHideCharacter = arg0_115

			if arg0_115 then
				arg0_95.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			else
				arg0_95.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
	end)()
end

function var0_0.RefreshCamera(arg0_116)
	arg0_116.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SettingCamera", arg0_116.cameraSettings)
end

function var0_0.UpdateAnimSpeedPanel(arg0_117)
	local function var0_117()
		if not arg0_117.timerAnim then
			return
		end

		local var0_118 = arg0_117.animInfo
		local var1_118 = var0_118.animPlayList[var0_118.index]
		local var2_118 = math.max(var2_0, var1_118:GetAnimTime())
		local var3_118 = var0_118.startStamp
		local var4_118 = Time.time

		var0_118.ratio = math.min(1, var0_118.ratio + (var4_118 - var3_118) * arg0_117.animSpeed / var2_118)
		var0_118.startStamp = var4_118
	end

	local var1_117 = arg0_117.animSpeeds

	UIItemList.StaticAlign(arg0_117.listAnimSpeed, arg0_117.listAnimSpeed:GetChild(0), #var1_117, function(arg0_119, arg1_119, arg2_119)
		if arg0_119 ~= UIItemList.EventUpdate then
			return
		end

		arg1_119 = #var1_117 - arg1_119

		local var0_119 = var1_117[arg1_119]

		setText(arg2_119:Find("Name"), var0_119)
		setText(arg2_119:Find("Selected"), var0_119)
		setActive(arg2_119:Find("Line"), arg1_119 ~= #var1_117)
		onButton(arg0_117, arg2_119, function()
			if arg0_117.animSpeed == var0_119 then
				return
			end

			var0_117()

			arg0_117.animSpeed = var0_119

			arg0_117.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_119)
			arg0_117:UpdateAnimSpeedPanel()
		end, SFX_PANEL)
	end)
	onButton(arg0_117, arg0_117.btnFreeze, function()
		local var0_121 = 0

		if arg0_117.animSpeed ~= 0 then
			arg0_117.lastAnimSpeed = arg0_117.animSpeed
		else
			var0_121 = arg0_117.lastAnimSpeed or 1
			arg0_117.lastAnimSpeed = nil
		end

		var0_117()

		arg0_117.animSpeed = var0_121

		arg0_117.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", var0_121)
		arg0_117:UpdateAnimSpeedPanel()
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_117.listAnimSpeed, arg0_117.listAnimSpeed:GetChild(0), #var1_117, function(arg0_122, arg1_122, arg2_122)
		if arg0_122 ~= UIItemList.EventUpdate then
			return
		end

		arg1_122 = #var1_117 - arg1_122

		local var0_122 = var1_117[arg1_122]

		setActive(arg2_122:Find("Name"), arg0_117.animSpeed ~= var0_122)
		setActive(arg2_122:Find("Selected"), arg0_117.animSpeed == var0_122)
	end)
	setActive(arg0_117.btnFreeze:Find("Icon"), arg0_117.animSpeed ~= 0)
	setActive(arg0_117.btnFreeze:Find("Selected"), arg0_117.animSpeed == 0)
	setText(arg0_117.textAnimSpeed, i18n("dorm3d_photo_animspeed", string.format("%.1f", arg0_117.animSpeed)))
end

function var0_0.UpdateLightingPanel(arg0_123)
	if not arg0_123.activeSetting then
		return
	end

	if arg0_123.activePanel ~= var0_0.PANEL.LIGHTING then
		return
	end

	local var0_123 = {}

	for iter0_123, iter1_123 in ipairs(pg.dorm3d_camera_volume_template.all) do
		table.insert(var0_123, iter1_123)
	end

	table.sort(var0_123, function(arg0_124, arg1_124)
		return arg0_124 < arg1_124
	end)

	local function var1_123()
		if not arg0_123.settingFilterIndex then
			arg0_123.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")

			return
		end

		local var0_125 = pg.dorm3d_camera_volume_template[var0_123[arg0_123.settingFilterIndex]]

		arg0_123.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetVolumeProfile", var0_125.volume, arg0_123.settingFilterStrength)
	end

	UIItemList.StaticAlign(arg0_123.panelLightning:Find("Layout/Filter/List"), arg0_123.panelLightning:Find("Layout/Filter/List"):GetChild(0), #var0_123, function(arg0_126, arg1_126, arg2_126)
		if arg0_126 ~= UIItemList.EventUpdate then
			return
		end

		arg1_126 = arg1_126 + 1

		local var0_126 = pg.dorm3d_camera_volume_template[var0_123[arg1_126]]

		setText(arg2_126:Find("Name"), var0_126.name)

		var0_126.icon = ""

		if var0_126.icon ~= "" then
			GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_126.icon), "", arg2_126:Find("BG"))
		end

		if arg0_123.settingFilterIndex == arg1_126 then
			setActive(arg2_126:Find("Selected"), true)
		else
			setActive(arg2_126:Find("Selected"), false)
		end

		local var1_126, var2_126 = ApartmentProxy.CheckUnlockConfig(var0_126.unlock)

		setActive(arg2_126:Find("lock"), not var1_126)

		if not var1_126 then
			setText(arg2_126:Find("lock/Image/Text"), var0_126.unlock_text)
		end

		onButton(arg0_123, arg2_126, function()
			if not var1_126 then
				pg.TipsMgr.GetInstance():ShowTips(var2_126)

				return
			end

			local var0_127 = arg0_123.settingFilterIndex

			if arg0_123.settingFilterIndex ~= arg1_126 then
				arg0_123.settingFilterIndex = arg1_126
			else
				arg0_123.settingFilterIndex = nil
			end

			var1_123()

			if var0_127 then
				local var1_127 = arg0_123.panelLightning:Find("Layout/Filter/List"):GetChild(var0_127 - 1)

				setActive(var1_127:Find("Selected"), false)
			end

			if arg0_123.settingFilterIndex == arg1_126 then
				setActive(arg2_126:Find("Selected"), true)
			end
		end, SFX_PANEL)
	end)
	setActive(arg0_123.panelLightning:Find("Layout/Filter/Slider"), false)
end

function var0_0.OnSwitchSkin(arg0_128, arg1_128, arg2_128, arg3_128)
	seriesAsync({
		function(arg0_129)
			if arg0_128.settingHideCharacter then
				arg0_128.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
			end

			arg1_128:SwitchCharacterSkin(arg2_128, arg3_128, arg0_129)
		end,
		function(arg0_130)
			setActive(arg1_128.ladySafeCollider, true)

			if not arg0_128.animInfo then
				return arg0_130()
			end

			local var0_130 = arg0_128.animInfo

			for iter0_130 = #var0_130.animPlayList, 1, -1 do
				local var1_130 = var0_130.animPlayList[iter0_130]:GetStartPoint()

				if #var1_130 > 0 then
					arg0_128.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var1_130)

					break
				end

				if iter0_130 == 1 then
					local var2_130 = arg0_128.room:GetCameraZones()[arg0_128.zoneIndex]

					arg0_128.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ResetCurrentCharPoint", var2_130:GetWatchCameraName())
				end
			end

			arg0_128.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SyncCurrentInterestTransform")

			local var3_130 = var0_130.animPlayList[#var0_130.animPlayList]
			local var4_130 = var3_130:GetAnimTime()

			arg0_128.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "PlayCurrentSingleAction", var3_130:GetStateName())
			arg0_128.scene.ladyDict[arg2_128].ladyAnimator:Update(var4_130)
			arg0_128.timerAnim:Stop()

			arg0_128.timerAnim = nil
			arg0_128.animInfo = nil
			arg0_128.animPlaying = nil

			arg0_130()
		end,
		function()
			arg0_128:UpdateActionPanel()

			if arg0_128.settingHideCharacter then
				arg0_128.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "HideCharacterBylayer")
			end
		end
	})
end

function var0_0.SetMute(arg0_132)
	if arg0_132 then
		CriWare.CriAtom.SetCategoryVolume("Category_CV", 0)
		CriWare.CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriWare.CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriWare.CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriWare.CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriWare.CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.willExit(arg0_133)
	arg0_133.loader:Clear()

	if arg0_133.timerAnim then
		arg0_133.timerAnim:Stop()

		arg0_133.timerAnim = nil
	end

	if arg0_133.animSpeed ~= 1 then
		arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "SetCharacterAnimSpeed", 1)
	end

	if arg0_133.settingHideCharacter then
		arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterBylayer")
	end

	if not arg0_133.settingFaceCamera then
		arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "EnableCurrentHeadIK", true)
	end

	arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCharacterLight")
	arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertVolumeProfile")
	arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "RevertCameraSettings")
	arg0_133.scene:emit(Dorm3dRoomTemplateScene.PHOTO_CALL, "ExitPhotoMode")
end

function var0_0.SetPhotoCameraSliderValue(arg0_134, arg1_134)
	local var0_134 = arg0_134.normalPanel:Find("Zoom/Slider")

	setSlider(var0_134, 0, 1, arg1_134)
end

function var0_0.SetPhotoStickDelta(arg0_135, arg1_135)
	arg1_135 = arg1_135 * 0.5

	local var0_135 = arg0_135._tf:Find("Center/Stick")
	local var1_135 = var0_135.rect.height
	local var2_135 = var0_135.rect.width
	local var3_135 = var0_135:Find("Handler")

	setAnchoredPosition(var3_135, Vector2.New(var1_135 * arg1_135.x, var2_135 * arg1_135.y))
end

return var0_0
