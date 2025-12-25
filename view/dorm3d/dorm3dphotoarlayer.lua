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

	arg0_2.stopRecBtn = arg0_2._tf:Find("stopRec")
	arg0_2.videoTipPanel = arg0_2._tf:Find("videoTipPanel")

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

function var0_0.SetARLite(arg0_6, arg1_6)
	local var0_6 = {
		5,
		6,
		7
	}

	arg0_6.ARState = arg1_6
	arg0_6.ARCheck = table.contains(var0_6, arg1_6)

	if GraphApiHelper.IsUsingVulkan() then
		arg0_6.ARCheck = false
	end

	if arg0_6.ARCheck then
		arg0_6.mainCamera = GameObject.Find("AR/XR Origin/Camera Offset/Main Camera"):GetComponent(typeof(Camera))
	else
		arg0_6.mainCamera = GameObject.Find("FakeAR/Main Camera"):GetComponent(typeof(Camera))
	end
end

function var0_0.onBackPressed(arg0_7)
	if arg0_7.recordState then
		triggerButton(arg0_7.btnFilm)

		return
	end

	if arg0_7.activeSetting then
		triggerButton(arg0_7._tf:Find("Center/Settings/Back"))

		return
	end

	arg0_7:closeView()
end

function var0_0.didEnter(arg0_8)
	setActive(arg0_8._tf:Find("Center/Normal/Back"), false)
	onButton(arg0_8, arg0_8._tf:Find("Center/Normal/Back"), function()
		arg0_8:onBackPressed()
	end, SFX_CANCEL)

	local var0_8 = arg0_8.normalPanel:Find("Zoom/Slider")

	setSlider(var0_8, 0, 1, 0)
	onSlider(arg0_8, var0_8, function(arg0_10)
		local var0_10 = (1 - arg0_10) * 0.5 + 0.5

		arg0_8:emit(Dorm3dPhotoARMediator.SCENE_CALL, "SetPinchValue", var0_10)
	end)

	arg0_8.activeSetting = false

	onButton(arg0_8, arg0_8._tf:Find("Center/Normal/Settings"), function()
		arg0_8.activeSetting = true

		quickPlayAnimation(arg0_8._tf:Find("Center"), "anim_dorm3d_photo_normal_out")
		arg0_8:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, false)
		arg0_8:UpdateActionPanel()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("Center/Settings/Back"), function()
		arg0_8.activeSetting = false

		quickPlayAnimation(arg0_8._tf:Find("Center"), "anim_dorm3d_photo_normal_in")
		arg0_8:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, true)
	end, SFX_CANCEL)

	arg0_8.hideUI = false

	onButton(arg0_8, arg0_8.btnHideUI, function()
		if arg0_8.hideUI then
			return
		end

		setActive(arg0_8.hideuiMask, true)
		setActive(arg0_8.centerPanel, false)

		arg0_8.hideUI = true
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.hideuiMask, function()
		if not arg0_8.hideUI then
			return
		end

		setActive(arg0_8.centerPanel, true)
		setActive(arg0_8.hideuiMask, false)

		arg0_8.hideUI = false
	end)
	onButton(arg0_8, arg0_8.btnReset, function()
		arg0_8:emit(Dorm3dPhotoARMediator.SCENE_CALL, "ResetPhotoCameraPosition")
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.btnFilm, function()
		local function var0_16(arg0_17)
			setActive(arg0_8.centerPanel, arg0_17)

			arg0_8._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = arg0_17 and 1 or 0

			arg0_8:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, arg0_17)
		end

		if not arg0_8.recordState then
			local function var1_16(arg0_18)
				if not arg0_18 then
					var0_16(true)

					arg0_8.recordState = false

					LeanTween.moveX(arg0_8.stopRecBtn, arg0_8.stopRecBtn.rect.width, 0.15)
				else
					arg0_8.recordState = true
				end
			end

			local function var2_16()
				setActive(arg0_8.stopRecBtn, true)
				LeanTween.moveX(arg0_8.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)

					arg0_8.recordFilePath = YSNormalTool.RecordTool.GenRecordFilePath()

					YSNormalTool.RecordTool.StartRecording(var1_16, arg0_8.recordFilePath)
				end))
			end

			seriesAsync({
				function(arg0_21)
					PermissionHelper.Request3DDorm(arg0_21, nil)
				end,
				function(arg0_22)
					var0_16(false)

					local var0_22 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_22 or var0_22 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_8.videoTipPanel:Find("Text"):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_8, arg0_8.videoTipPanel, function()
							setActive(arg0_8.videoTipPanel, false)
							var2_16()
						end)
						setActive(arg0_8.videoTipPanel, true)
					else
						var2_16()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.stopRecBtn, function()
		local function var0_24(arg0_25)
			if arg0_25 and PLATFORM == PLATFORM_ANDROID then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("word_save_video"),
					onNo = function()
						if System.IO.File.Exists(arg0_8.recordFilePath) then
							System.IO.File.Delete(arg0_8.recordFilePath)
						end
					end,
					onYes = function()
						YSNormalTool.MediaTool.SaveVideoToAlbum(arg0_8.recordFilePath, function(arg0_28, arg1_28)
							if arg0_28 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))

								if System.IO.File.Exists(arg0_8.recordFilePath) then
									System.IO.File.Delete(arg0_8.recordFilePath)
								end
							end
						end)
					end
				})
			end

			arg0_8.recordState = false
		end

		local function var1_24(arg0_29)
			setActive(arg0_8.centerPanel, arg0_29)

			arg0_8._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = arg0_29 and 1 or 0

			arg0_8:emit(Dorm3dPhotoARMediator.ACTIVE_AR_UI, arg0_29)
		end

		if not LeanTween.isTweening(go(arg0_8.stopRecBtn)) then
			LeanTween.moveX(arg0_8.stopRecBtn, arg0_8.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_8.stopRecBtn, false)
				seriesAsync({
					function(arg0_31)
						YSNormalTool.RecordTool.StopRecording(var0_24)
						var1_24(true)
						var0_0.SetMute(false)
					end
				})
			end))
		end
	end)
	setActive(arg0_8.stopRecBtn, false)
	onButton(arg0_8, arg0_8._tf:Find("RightTop/Film/Switch"), function()
		GetOrAddComponent(arg0_8._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = false

		quickPlayAnimation(arg0_8._tf:Find("RightTop"), "anim_dorm3d_photo_FtoS")
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("RightTop/Shot/Shot"), function()
		local function var0_33(arg0_34)
			setActive(arg0_8.centerPanel, arg0_34)
			setActive(arg0_8._tf:Find("RightTop"), arg0_34)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_34)
			end
		end

		local function var1_33(arg0_35)
			warning("截图结果：" .. tostring(arg0_35))
		end

		local function var2_33(arg0_36, arg1_36)
			arg0_8:emit(Dorm3dPhotoARMediator.SHARE_PANEL, arg1_36, arg0_36)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCamera(arg0_8.groupId, 3, arg0_8.room:GetConfigID(), Dorm3dCameraAnim.New({
				configId = arg0_8.animID
			}):GetStateName()))
		end

		local function var3_33(arg0_37)
			var1_33(true)

			local var0_37 = Tex2DExtension.EncodeToJPG(arg0_37)

			var2_33(var0_37, arg0_37)
		end

		local var4_33, var5_33 = Dorm3dHxHelper.GetHolyLightScreenShotInfo(arg0_8.contextData.holyLightRoot)

		GraphicsInterface.Instance:TakePhotoWithPost(arg0_8.mainCamera, var4_33, var5_33, var3_33)
	end, "ui-dorm_photograph")

	GetOrAddComponent(arg0_8._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = false

	onButton(arg0_8, arg0_8._tf:Find("RightTop/Shot/Switch"), function()
		GetOrAddComponent(arg0_8._tf:Find("RightTop/Film"), typeof(CanvasGroup)).blocksRaycasts = true

		quickPlayAnimation(arg0_8._tf:Find("RightTop"), "anim_dorm3d_photo_StoF")
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.btnAnimSpeed, function()
		setActive(arg0_8.listAnimSpeed, not isActive(arg0_8.listAnimSpeed))
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.btnZone, function()
		local var0_40 = isActive(arg0_8.listZones)

		setActive(arg0_8.listZones, not var0_40)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.zoneMask, function()
		setActive(arg0_8.listZones, false)
	end)
	onButton(arg0_8, arg0_8.btnAr, function()
		arg0_8:emit(Dorm3dPhotoMediator.GO_AR)
	end)

	arg0_8.activePanel = 1

	local var1_8 = {
		{
			btn = arg0_8.btnAction,
			On = function()
				arg0_8:UpdateActionPanel()
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_8.btnCamera,
			On = function()
				return
			end,
			Off = function()
				return
			end
		},
		{
			btn = arg0_8.btnLighting,
			On = function()
				return
			end,
			Off = function()
				return
			end
		}
	}

	table.Ipairs(var1_8, function(arg0_49, arg1_49)
		onToggle(arg0_8, arg1_49.btn, function(arg0_50)
			if not arg0_50 then
				return
			end

			table.Ipairs(var1_8, function(arg0_51, arg1_51)
				if arg0_51 == arg0_49 then
					return
				end

				arg1_51.Off()
			end)

			arg0_8.activePanel = arg0_49

			arg1_49.On()
		end, SFX_PANEL)
	end)
	;(function()
		local var0_52 = {
			arg0_8.panelAction:Find("Layout/Title/Regular")
		}

		triggerToggle(var0_52[1], true)
	end)()
	;(function()
		local var0_53 = {
			arg0_8.panelLightning:Find("Layout/Title/Lighting")
		}

		triggerToggle(var0_53[1], true)
	end)()
	arg0_8:InitData()
	triggerToggle(var1_8[arg0_8.activePanel].btn, true)
	arg0_8:emit(Dorm3dPhotoARMediator.AR_PHOTO_INITED)
end

function var0_0.InitData(arg0_54)
	arg0_54:RefreshData()
end

function var0_0.RefreshData(arg0_55)
	arg0_55.animID = arg0_55.room:getAllARAnimationListByShip(arg0_55.groupId)[1]:GetConfigID()
	arg0_55.animSpeed = 1
end

local var1_0 = 0.2

function var0_0.UpdateActionPanel(arg0_56)
	if not arg0_56.activeSetting then
		return
	end

	if arg0_56.activePanel ~= var0_0.PANEL.ACTION then
		return
	end

	local var0_56 = arg0_56.room:getAllARAnimationListByShip(arg0_56.groupId)
	local var1_56 = arg0_56.panelAction:Find("Layout/Regular/Scroll/Viewport/Content")

	local function var2_56()
		UIItemList.StaticAlign(var1_56, var1_56:GetChild(0), #var0_56, function(arg0_58, arg1_58, arg2_58)
			if arg0_58 ~= UIItemList.EventUpdate then
				return
			end

			arg1_58 = arg1_58 + 1

			local var0_58 = var0_56[arg1_58]

			setActive(arg2_58:Find("Selected"), var0_58:GetConfigID() == arg0_56.animID)
			setActive(arg2_58:Find("Slider"), var0_58:GetConfigID() == arg0_56.animID and tobool(arg0_56.timerAnim))
		end)
	end

	local function var3_56(arg0_59, arg1_59)
		if arg0_56.animPlaying then
			return
		end

		local var0_59 = arg0_59:GetConfigID()

		if arg0_56.animID == var0_59 then
			return
		end

		local var1_59 = arg0_56:GetAnimPlayList(var0_59)
		local var2_59 = Dorm3dCameraAnim.New({
			configId = arg0_56.animID
		}):GetFinishAnimID()

		arg0_56.animID = var0_59

		var2_56()
		arg0_56:BlockActionPanel(true)

		arg0_56.animPlaying = true

		local var3_59 = (table.indexof(var1_59, _.detect(var1_59, function(arg0_60)
			return arg0_60:GetConfigID() == var2_59
		end)) or 0) + 1
		local var4_59 = _.rest(var1_59, var3_59)
		local var5_59 = arg1_59:Find("Slider"):GetComponent(typeof(Slider))

		setActive(arg1_59:Find("Slider"), true)

		local function var6_59()
			setActive(arg1_59:Find("Selected"), true)
			setActive(arg1_59:Find("Slider"), false)
			arg0_56:BlockActionPanel(false)

			arg0_56.animPlaying = nil
		end

		if #var4_59 == 0 then
			var6_59()

			return
		end

		local var7_59 = _.reduce(var4_59, 0, function(arg0_62, arg1_62)
			return arg0_62 + math.max(var1_0, arg1_62:GetAnimTime())
		end)

		if arg0_56.timerAnim then
			arg0_56.timerAnim:Stop()
		end

		arg0_56.animInfo = {
			index = 1,
			passedTime = 0,
			ratio = 0,
			animPlayList = var4_59,
			totalTime = var7_59,
			startStamp = Time.time
		}
		arg0_56.timerAnim = FrameTimer.New(function()
			local var0_63 = arg0_56.animInfo
			local var1_63 = var0_63.animPlayList[var0_63.index]
			local var2_63 = math.max(var1_0, var1_63:GetAnimTime())
			local var3_63 = var0_63.startStamp
			local var4_63 = Time.time
			local var5_63 = math.min(1, var0_63.ratio + (var4_63 - var3_63) * arg0_56.animSpeed / var2_63)
			local var6_63 = var0_63.passedTime + var2_63 * var5_63

			var5_59.value = var6_63 / var7_59

			if var5_63 < 1 then
				return
			end

			var0_63.index = var0_63.index + 1
			var0_63.ratio = 0
			var0_63.passedTime = var0_63.passedTime + var2_63
			var0_63.startStamp = var4_63

			warning(var0_63.startStamp)

			if var0_63.index > #var0_63.animPlayList then
				var6_59()
				arg0_56.timerAnim:Stop()

				arg0_56.timerAnim = nil
				arg0_56.animInfo = nil

				return
			end

			local var7_63 = var0_63.animPlayList[var0_63.index]

			arg0_56:emit(Dorm3dPhotoARMediator.SCENE_CALL, "PlaySingleAction", var7_63:GetStateName())
		end, 1, -1)

		local var8_59 = arg0_56.animInfo.animPlayList[1]

		if var3_59 == 1 then
			arg0_56:emit(Dorm3dPhotoARMediator.SCENE_CALL, "SwitchAnim", var8_59:GetStateName())
			onNextTick(function()
				arg0_56:emit(Dorm3dPhotoARMediator.SCENE_CALL, "ResetCharPos")
			end)
		else
			arg0_56:emit(Dorm3dPhotoARMediator.SCENE_CALL, "PlaySingleAction", var8_59:GetStateName())
		end

		arg0_56.timerAnim:Start()
	end

	UIItemList.StaticAlign(var1_56, var1_56:GetChild(0), #var0_56, function(arg0_65, arg1_65, arg2_65)
		if arg0_65 ~= UIItemList.EventUpdate then
			return
		end

		arg1_65 = arg1_65 + 1

		local var0_65 = var0_56[arg1_65]

		setText(arg2_65:Find("Name"), var0_65:GetName())
		GetImageSpriteFromAtlasAsync(string.format("Dorm3DPhoto/%s", var0_65:GetZoneIcon()), "", arg2_65:Find("Icon"))
		setActive(arg2_65:Find("Slider"), false)
		setActive(arg2_65:Find("Selected"), false)
		onButton(arg0_56, arg2_65, function()
			var3_56(var0_65, arg2_65)
		end)
	end)
	var2_56()
end

function var0_0.BlockActionPanel(arg0_67, arg1_67)
	return
end

function var0_0.SetPhotoUIActive(arg0_68, arg1_68)
	setActive(arg0_68._tf:Find("RightTop"), arg1_68)
	setActive(arg0_68._tf:Find("Center"), arg1_68)
end

function var0_0.GetAnimPlayList(arg0_69, arg1_69)
	local var0_69 = arg1_69
	local var1_69 = {}

	while true do
		local var2_69 = Dorm3dCameraAnim.New({
			configId = var0_69
		})

		if not var2_69 then
			return var1_69
		end

		table.insert(var1_69, 1, var2_69)

		var0_69 = var2_69:GetPreAnimID()

		if var0_69 == 0 then
			return var1_69
		end
	end
end

function var0_0.SetMute(arg0_70)
	if arg0_70 then
		pg.CriMgr.GetInstance():MuteAllVolume()
	else
		pg.CriMgr.GetInstance():ResetAllVolume()
	end
end

function var0_0.willExit(arg0_71)
	if arg0_71.timerAnim then
		arg0_71.timerAnim:Stop()

		arg0_71.timerAnim = nil
	end

	if arg0_71.filmTimer then
		arg0_71.filmTimer:Stop()

		arg0_71.filmTimer = nil
	end
end

function var0_0.SetCamaraPinchSliderValue(arg0_72, arg1_72)
	local var0_72 = arg0_72.normalPanel:Find("Zoom/Slider")

	setSlider(var0_72, 0, 1, 1 - (arg1_72 - 0.5) / 0.5)
end

function var0_0.ShowPhotoImage(arg0_73, arg1_73)
	local var0_73 = arg1_73 and 1 or 0

	arg0_73.normalPanel:GetComponent("CanvasGroup").alpha = var0_73
	arg0_73._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = var0_73
end

return var0_0
