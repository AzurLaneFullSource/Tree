local var0_0 = class("Dorm3dPhotoARLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dARPhotoUI"
end

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
	setText(arg0_2.panelLightning:Find("Layout/Title/Lighting/Name"), i18n("dorm3d_photo_lighting"))
	setText(arg0_2.panelLightning:Find("Layout/Title/Lighting/Selected"), i18n("dorm3d_photo_lighting"))
	setText(arg0_2.panelLightning:Find("Layout/Title/Filter/Name"), i18n("dorm3d_photo_filter"))
	setText(arg0_2.panelLightning:Find("Layout/Title/Filter/Selected"), i18n("dorm3d_photo_filter"))
	setText(arg0_2.panelLightning:Find("Layout/Lighting/Strength/Name"), i18n("dorm3d_photo_strength"))
	setText(arg0_2.panelAction:Find("Layout/Title/Regular/Name"), i18n("dorm3d_photo_regular_anim"))
	setText(arg0_2.panelAction:Find("Layout/Title/Regular/Selected"), i18n("dorm3d_photo_regular_anim"))
	setText(arg0_2.panelAction:Find("Layout/Title/Special/Name"), i18n("dorm3d_photo_special_anim"))
	setText(arg0_2.panelAction:Find("Layout/Title/Special/Selected"), i18n("dorm3d_photo_special_anim"))

	arg0_2.mainCamera = GameObject.Find("AR/AR Session Origin/AR Camera"):GetComponent(typeof(Camera))
	arg0_2.stopRecBtn = arg0_2:findTF("stopRec")
	arg0_2.videoTipPanel = arg0_2:findTF("videoTipPanel")

	setActive(arg0_2.videoTipPanel, false)
end

function var0_0.SetSceneRoot(arg0_3, arg1_3)
	arg0_3.scene = arg1_3
end

function var0_0.SetRoom(arg0_4, arg1_4)
	arg0_4.room = getProxy(ApartmentProxy):getRoom(arg1_4)
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
	setActive(arg0_7._tf:Find("Center/Normal/Back"), false)
	onButton(arg0_7, arg0_7._tf:Find("Center/Normal/Back"), function()
		arg0_7:onBackPressed()
	end, SFX_CANCEL)

	local var0_7 = arg0_7.normalPanel:Find("Zoom/Slider")

	setSlider(var0_7, 0, 1, 0)
	onSlider(arg0_7, var0_7, function(arg0_9)
		local var0_9 = (1 - arg0_9) * 0.5 + 0.5

		arg0_7:emit(Dorm3dPhotoARMediator.SCENE_CALL, "SetPinchValue", var0_9)
	end)

	arg0_7.activeSetting = false

	onButton(arg0_7, arg0_7._tf:Find("Center/Normal/Settings"), function()
		arg0_7.activeSetting = true

		quickPlayAnimation(arg0_7._tf:Find("Center"), "anim_dorm3d_photo_normal_out")
		arg0_7:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, false)
		arg0_7:UpdateActionPanel()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("Center/Settings/Back"), function()
		arg0_7.activeSetting = false

		quickPlayAnimation(arg0_7._tf:Find("Center"), "anim_dorm3d_photo_normal_in")
		arg0_7:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, true)
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
		arg0_7:emit(Dorm3dPhotoARMediator.SCENE_CALL, "ResetPhotoCameraPosition")
	end, SFX_PANEL)

	arg0_7.recordState = false

	onButton(arg0_7, arg0_7.btnFilm, function()
		local function var0_15(arg0_16)
			setActive(arg0_7.centerPanel, arg0_16)

			arg0_7:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_16 and 1 or 0

			arg0_7:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, arg0_16)
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

			arg0_7:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, arg0_26)
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
			arg0_7:emit(Dorm3dPhotoARMediator.SHARE_PANEL, arg1_35, arg0_35)

			if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
				print("start photo : play sound")
				NotificationMgr.Inst:PlayShutterSound()
			end

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_7.groupId, 3, arg0_7.room:GetConfigID(), Dorm3dCameraAnim.New({
				configId = arg0_7.animID
			}):GetStateName()))
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
		arg0_7:emit(Dorm3dPhotoMediator.GO_AR)
	end)

	arg0_7.activePanel = 1

	local var1_7 = {
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
				return
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_7.btnLighting,
			On = function()
				return
			end,
			Off = function()
				return
			end
		}
	}

	table.Ipairs(var1_7, function(arg0_47, arg1_47)
		onToggle(arg0_7, arg1_47.btn, function(arg0_48)
			if not arg0_48 then
				return
			end

			table.Ipairs(var1_7, function(arg0_49, arg1_49)
				if arg0_49 == arg0_47 then
					return
				end

				arg1_49.Off()
			end)

			arg0_7.activePanel = arg0_47

			arg1_47.On()
		end, SFX_PANEL)
	end)
	;(function()
		local var0_50 = {
			arg0_7.panelAction:Find("Layout/Title/Regular")
		}

		triggerToggle(var0_50[1], true)
	end)()
	;(function()
		local var0_51 = {
			arg0_7.panelLightning:Find("Layout/Title/Lighting")
		}

		triggerToggle(var0_51[1], true)
	end)()
	arg0_7:InitData()
	triggerToggle(var1_7[arg0_7.activePanel].btn, true)
	arg0_7:emit(Dorm3dPhotoARMediator.AR_PHOTO_INITED)
end

function var0_0.InitData(arg0_52)
	arg0_52:RefreshData()
end

function var0_0.RefreshData(arg0_53)
	arg0_53.animID = arg0_53.room:getAllARAnimationListByShip(arg0_53.groupId)[1]:GetConfigID()
	arg0_53.animSpeed = 1
end

local var1_0 = 0.2

function var0_0.UpdateActionPanel(arg0_54)
	if not arg0_54.activeSetting then
		return
	end

	if arg0_54.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_54 = arg0_54.room:getAllARAnimationListByShip(arg0_54.groupId)
	local var1_54 = arg0_54.panelAction:Find("Layout/Regular/Scroll/Viewport/Content")

	local function var2_54()
		UIItemList.StaticAlign(var1_54, var1_54:GetChild(0), #var0_54, function(arg0_56, arg1_56, arg2_56)
			if arg0_56 ~= UIItemList.EventUpdate then
				return
			end

			arg1_56 = arg1_56 + 1

			local var0_56 = var0_54[arg1_56]

			setActive(arg2_56:Find("Selected"), var0_56:GetConfigID() == arg0_54.animID)
			setActive(arg2_56:Find("Slider"), var0_56:GetConfigID() == arg0_54.animID and tobool(arg0_54.timerAnim))
		end)
	end

	local function var3_54(arg0_57, arg1_57)
		if arg0_54.animPlaying then
			return
		end

		local var0_57 = arg0_57:GetConfigID()

		if arg0_54.animID == var0_57 then
			return
		end

		local var1_57 = arg0_54:GetAnimPlayList(var0_57)
		local var2_57 = Dorm3dCameraAnim.New({
			configId = arg0_54.animID
		}):GetFinishAnimID()

		arg0_54.animID = var0_57

		var2_54()
		arg0_54:BlockActionPanel(true)

		arg0_54.animPlaying = true

		local var3_57 = (table.indexof(var1_57, _.detect(var1_57, function(arg0_58)
			return arg0_58:GetConfigID() == var2_57
		end)) or 0) + 1
		local var4_57 = _.rest(var1_57, var3_57)
		local var5_57 = arg1_57:Find("Slider"):GetComponent(typeof(Slider))

		setActive(arg1_57:Find("Slider"), true)

		local function var6_57()
			setActive(arg1_57:Find("Selected"), true)
			setActive(arg1_57:Find("Slider"), false)
			arg0_54:BlockActionPanel(false)

			arg0_54.animPlaying = nil
		end

		if #var4_57 == 0 then
			var6_57()

			return
		end

		local var7_57 = _.reduce(var4_57, 0, function(arg0_60, arg1_60)
			return arg0_60 + math.max(var1_0, arg1_60:GetAnimTime())
		end)

		if arg0_54.timerAnim then
			arg0_54.timerAnim:Stop()
		end

		arg0_54.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_57,
			totalTime = var7_57,
			startStamp = Time.time
		}
		arg0_54.timerAnim = FrameTimer.New(function()
			local var0_61 = arg0_54.animInfo
			local var1_61 = var0_61.animPlayList[var0_61.index]
			local var2_61 = math.max(var1_0, var1_61:GetAnimTime())
			local var3_61 = var0_61.startStamp
			local var4_61 = Time.time
			local var5_61 = math.min(1, var0_61.ratio + (var4_61 - var3_61) * arg0_54.animSpeed / var2_61)
			local var6_61 = var0_61.passedTime + var2_61 * var5_61

			var5_57.value = var6_61 / var7_57

			if var5_61 < 1 then
				return
			end

			var0_61.index = var0_61.index + 1
			var0_61.ratio = 0
			var0_61.passedTime = var0_61.passedTime + var2_61
			var0_61.startStamp = var4_61

			warning(var0_61.startStamp)

			if var0_61.index > #var0_61.animPlayList then
				var6_57()
				arg0_54.timerAnim:Stop()

				arg0_54.timerAnim = nil
				arg0_54.animInfo = nil

				return
			end

			local var7_61 = var0_61.animPlayList[var0_61.index]

			arg0_54:emit(Dorm3dPhotoARMediator.SCENE_CALL, "PlaySingleAction", var7_61:GetStateName())
		end, 1, -1)

		local var8_57 = arg0_54.animInfo.animPlayList[1]

		if var3_57 == 1 then
			arg0_54:emit(Dorm3dPhotoARMediator.SCENE_CALL, "SwitchAnim", var8_57:GetStateName())
			onNextTick(function()
				arg0_54:emit(Dorm3dPhotoARMediator.SCENE_CALL, "ResetCharPos")
			end)
		else
			arg0_54:emit(Dorm3dPhotoARMediator.SCENE_CALL, "PlaySingleAction", var8_57:GetStateName())
		end

		arg0_54.timerAnim:Start()
	end

	UIItemList.StaticAlign(var1_54, var1_54:GetChild(0), #var0_54, function(arg0_63, arg1_63, arg2_63)
		if arg0_63 ~= UIItemList.EventUpdate then
			return
		end

		arg1_63 = arg1_63 + 1

		local var0_63 = var0_54[arg1_63]

		setText(arg2_63:Find("Name"), var0_63:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_63:GetZoneIcon()), "", arg2_63:Find("Icon"))
		setActive(arg2_63:Find("Slider"), false)
		setActive(arg2_63:Find("Selected"), false)
		onButton(arg0_54, arg2_63, function()
			var3_54(var0_63, arg2_63)
		end)
	end)
	var2_54()
end

function var0_0.BlockActionPanel(arg0_65, arg1_65)
	return
end

function var0_0.SetPhotoUIActive(arg0_66, arg1_66)
	setActive(arg0_66._tf:Find("RightTop"), arg1_66)
	setActive(arg0_66._tf:Find("Center"), arg1_66)
end

function var0_0.GetAnimPlayList(arg0_67, arg1_67)
	local var0_67 = arg1_67
	local var1_67 = {}

	while true do
		local var2_67 = Dorm3dCameraAnim.New({
			configId = var0_67
		})

		if not var2_67 then
			return var1_67
		end

		table.insert(var1_67, 1, var2_67)

		var0_67 = var2_67:GetPreAnimID()

		if var0_67 == 0 then
			return var1_67
		end
	end
end

function var0_0.SetMute(arg0_68)
	if arg0_68 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.willExit(arg0_69)
	if arg0_69.timerAnim then
		arg0_69.timerAnim:Stop()

		arg0_69.timerAnim = nil
	end

	if arg0_69.filmTimer then
		arg0_69.filmTimer:Stop()

		arg0_69.filmTimer = nil
	end
end

function var0_0.SetCamaraPinchSliderValue(arg0_70, arg1_70)
	local var0_70 = arg0_70.normalPanel:Find("Zoom/Slider")

	setSlider(var0_70, 0, 1, 1 - (arg1_70 - 0.5) / 0.5)
end

function var0_0.ShowPhotoImage(arg0_71, arg1_71)
	local var0_71 = arg1_71 and 1 or 0

	arg0_71.normalPanel:GetComponent("CanvasGroup").alpha = var0_71
	arg0_71._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = var0_71
end

return var0_0
