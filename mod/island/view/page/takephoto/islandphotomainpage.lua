local var0_0 = class("IslandPhotoMainPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandMainPhotoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.centerPanel = arg0_2._tf:Find("Center")
	arg0_2.normalPanel = arg0_2._tf:Find("Center/Normal")

	setActive(arg0_2.normalPanel, true)

	arg0_2.btnHideUI = arg0_2._tf:Find("Center/HideUI")
	arg0_2.btnReset = arg0_2._tf:Find("Center/Reset")
	arg0_2.btnFreeze = arg0_2._tf:Find("Center/Freeze")
	arg0_2.RightTopTf = arg0_2._tf:Find("RightTop")
	arg0_2.FilmTf = arg0_2._tf:Find("RightTop/Film")
	arg0_2.ShotTf = arg0_2._tf:Find("RightTop/Shot")
	arg0_2.btnFilm = arg0_2._tf:Find("RightTop/Film/Film")
	arg0_2.filmTime = arg0_2._tf:Find("RightTop/FilmTime")

	setActive(arg0_2.filmTime, false)

	arg0_2.btnShoot = arg0_2._tf:Find("RightTop/Shot/Shot")
	arg0_2.hideuiMask = arg0_2._tf:Find("Mask")

	setActive(arg0_2.hideuiMask, false)

	arg0_2.ysScreenShoter = arg0_2._tf:Find("Shoter"):GetComponent(typeof(YSTool.YSScreenShoter))
	arg0_2.stopRecBtn = arg0_2._tf:Find("stopRec")
	arg0_2.videoTipPanel = arg0_2._tf:Find("videoTipPanel")

	setActive(arg0_2.videoTipPanel, false)

	arg0_2.photoModel = arg0_2._tf:Find("Center/photoModel")
	arg0_2.unselectBgTF = arg0_2.photoModel:Find("un_select_bg")
	arg0_2.select_bgTF = arg0_2.photoModel:Find("select_bg")
	arg0_2.firstModelTF = arg0_2.photoModel:Find("first")
	arg0_2.thirdModelTF = arg0_2.photoModel:Find("third")
	arg0_2.mainCamera = IslandCameraMgr.instance._mainCamera
	arg0_2.takeModelTFDic = {
		[IslandConst.TakePhotoModel.First] = arg0_2.firstModelTF,
		[IslandConst.TakePhotoModel.Third] = arg0_2.thirdModelTF
	}
	arg0_2.sliderZoom = arg0_2.normalPanel:Find("Zoom/Slider")
	arg0_2.fpsCamera = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.FIRST_PERSON_TAKE_PHOTO_CAMERA_NAME)
	arg0_2.tpsCamera = IslandCameraMgr.instance:GetVirtualCamera(IslandConst.Third_PERSON_TAKE_PHOTO_CAMERA_NAME)
	arg0_2.fpsHeight = pg.island_set.island_photohight_FPS.key_value_varchar
	arg0_2.tpsHeight = pg.island_set.island_photohight_TPS.key_value_varchar
end

function var0_0.AddListeners(arg0_3)
	return
end

function var0_0.RemoveListeners(arg0_4)
	return
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("Center/Normal/Back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_photo.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Center/Normal/Back"), function()
		arg0_5:Hide()
	end, SFX_CANCEL)
	setActive(arg0_5.ShotTf, true)
	setActive(arg0_5.FilmTf, false)
	onButton(arg0_5, arg0_5._tf:Find("RightTop/Shot/Switch"), function()
		setActive(arg0_5.ShotTf, false)
		setActive(arg0_5.FilmTf, true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("RightTop/Film/Switch"), function()
		setActive(arg0_5.ShotTf, true)
		setActive(arg0_5.FilmTf, false)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnShoot, function()
		local function var0_10(arg0_11)
			setActive(arg0_5.centerPanel, arg0_11)
			setActive(arg0_5._tf:Find("RightTop"), arg0_11)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_11)
			end
		end

		local function var1_10(arg0_12)
			warning("截图结果：" .. tostring(true))

			local var0_12 = Tex2DExtension.EncodeToJPG(arg0_12)

			arg0_5:OpenPage(IslandPhotoSharePage, var0_12, arg0_12)
			IslandTaskHelper.UpdateClientTaskProgress(IslandTaskTargetType.TAKE_PHOTO, 0)
			IslandAchievementHelper.OnTakePhoto(0)
		end

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandTakeThoto(2))
		BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(arg0_5.mainCamera, var1_10)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.photoModel:Find("left_btn"), function()
		arg0_5:LeftSelectBtnHandle()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.select_bgTF:Find("left_btn"), function()
		arg0_5:RightSelectBtnHandle()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.firstModelTF, function()
		arg0_5:ChangeTakePhotoModel(IslandConst.TakePhotoModel.First)
		arg0_5:RightSelectBtnHandle()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.thirdModelTF, function()
		arg0_5:ChangeTakePhotoModel(IslandConst.TakePhotoModel.Third)
		arg0_5:RightSelectBtnHandle()
	end, SFX_PANEL)
	onSlider(arg0_5, arg0_5.sliderZoom, function(arg0_17)
		arg0_5:ChangeSliderValue(arg0_17)
	end)

	arg0_5.hideUI = false

	onButton(arg0_5, arg0_5.btnHideUI, function()
		if arg0_5.hideUI then
			return
		end

		setActive(arg0_5.hideuiMask, true)
		setActive(arg0_5.centerPanel, false)

		arg0_5.RightTopTf:GetComponent("CanvasGroup").alpha = 0
		arg0_5.RightTopTf:GetComponent("CanvasGroup").blocksRaycasts = false
		arg0_5.hideUI = true

		arg0_5:emitCore(ISLAND_EVT.SetOpMoveBtnActve, false)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnReset, function()
		local var0_19

		if arg0_5.takePhotoModel == 2 then
			var0_19 = (arg0_5.fpsHeight[1] - arg0_5.fpsHeight[2]) / (arg0_5.fpsHeight[3] - arg0_5.fpsHeight[2])
		else
			var0_19 = (arg0_5.tpsHeight[1] - arg0_5.tpsHeight[2]) / (arg0_5.tpsHeight[3] - arg0_5.tpsHeight[2])

			arg0_5:emitCore(ISLAND_EVT.Change_TakePhoto_Model, arg0_5.takePhotoModel)
		end

		setSlider(arg0_5.sliderZoom, 0, 1, var0_19)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.hideuiMask, function()
		if not arg0_5.hideUI then
			return
		end

		setActive(arg0_5.centerPanel, true)
		setActive(arg0_5.hideuiMask, false)

		arg0_5.RightTopTf:GetComponent("CanvasGroup").alpha = 1
		arg0_5.RightTopTf:GetComponent("CanvasGroup").blocksRaycasts = true
		arg0_5.hideUI = false

		arg0_5:emitCore(ISLAND_EVT.SetOpMoveBtnActve, true)
	end)

	arg0_5.recordState = false

	onButton(arg0_5, arg0_5.btnFilm, function()
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandTakeThoto(3))

		local function var0_21(arg0_22)
			setActive(arg0_5.centerPanel, arg0_22)

			arg0_5._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = arg0_22 and 1 or 0

			arg0_5:emitCore(ISLAND_EVT.SetOpMoveBtnActve, arg0_22, true)
		end

		if not arg0_5.recordState then
			local function var1_21(arg0_23)
				if not arg0_23 then
					var0_21(true)

					arg0_5.recordState = false

					LeanTween.moveX(arg0_5.stopRecBtn, arg0_5.stopRecBtn.rect.width, 0.15)
				else
					arg0_5.recordState = true
				end
			end

			local function var2_21()
				setActive(arg0_5.stopRecBtn, true)
				LeanTween.moveX(arg0_5.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)

					arg0_5.recordFilePath = YSNormalTool.RecordTool.GenRecordFilePath()

					YSNormalTool.RecordTool.StartRecording(var1_21, arg0_5.recordFilePath)
				end))
			end

			seriesAsync({
				function(arg0_26)
					PermissionHelper.Request3DDorm(arg0_26, nil)
				end,
				function(arg0_27)
					var0_21(false)

					local var0_27 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_27 or var0_27 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_5.videoTipPanel:Find("Text"):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_5, arg0_5.videoTipPanel, function()
							setActive(arg0_5.videoTipPanel, false)
							var2_21()
						end)
						setActive(arg0_5.videoTipPanel, true)
					else
						var2_21()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.stopRecBtn, function()
		arg0_5.recordState = false

		local function var0_29(arg0_30)
			if arg0_30 and PLATFORM == PLATFORM_ANDROID then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("word_save_video"),
					onNo = function()
						if System.IO.File.Exists(arg0_5.recordFilePath) then
							System.IO.File.Delete(arg0_5.recordFilePath)
						end
					end,
					onYes = function()
						YSNormalTool.MediaTool.SaveVideoToAlbum(arg0_5.recordFilePath, function(arg0_33, arg1_33)
							if arg0_33 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))

								if System.IO.File.Exists(arg0_5.recordFilePath) then
									System.IO.File.Delete(arg0_5.recordFilePath)
								end
							end
						end)
					end
				})
			end

			arg0_5.recordState = false
		end

		local function var1_29(arg0_34)
			setActive(arg0_5.centerPanel, arg0_34)

			arg0_5._tf:Find("RightTop"):GetComponent("CanvasGroup").alpha = arg0_34 and 1 or 0
		end

		if not LeanTween.isTweening(go(arg0_5.stopRecBtn)) then
			LeanTween.moveX(arg0_5.stopRecBtn, arg0_5.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_5.stopRecBtn, false)
				seriesAsync({
					function(arg0_36)
						YSNormalTool.RecordTool.StopRecording(var0_29)
						var1_29(true)
						var0_0.SetMute(false)
					end
				})
			end))
		end
	end)
	setActive(arg0_5.stopRecBtn, false)
end

function var0_0.ChangeSliderValue(arg0_37, arg1_37)
	local var0_37
	local var1_37

	if arg0_37.takePhotoModel == 2 then
		var0_37 = arg0_37.fpsCamera.gameObject:GetComponent(typeof(CameraPovLook))
		var1_37 = arg1_37 * (arg0_37.fpsHeight[3] - arg0_37.fpsHeight[2]) + arg0_37.fpsHeight[2]
	else
		var0_37 = arg0_37.tpsCamera.gameObject:GetComponent(typeof(CameraPovLook))
		var1_37 = arg1_37 * (arg0_37.tpsHeight[3] - arg0_37.tpsHeight[2]) + arg0_37.tpsHeight[2]

		arg0_37:emitCore(ISLAND_EVT.Change_Photo_Height, arg0_37.takePhotoModel, var1_37)
	end

	var0_37:SetTargetOffsetY(var1_37)
end

function var0_0.RightSelectBtnHandle(arg0_38)
	setActive(arg0_38.unselectBgTF, true)
	setActive(arg0_38.select_bgTF, false)
	setActive(arg0_38.photoModel:Find("left_btn"), true)

	for iter0_38, iter1_38 in pairs(arg0_38.takeModelTFDic) do
		if arg0_38.takePhotoModel == iter0_38 then
			setActive(iter1_38:Find("select"), true)
			setActive(iter1_38:Find("unSelect"), false)
			setActive(iter1_38, true)
			setAnchoredPosition(iter1_38, {
				x = 0
			})
		else
			setActive(iter1_38:Find("unSelect"), true)
			setActive(iter1_38:Find("select"), false)
			setActive(iter1_38, false)
		end
	end
end

function var0_0.LeftSelectBtnHandle(arg0_39)
	setActive(arg0_39.unselectBgTF, false)
	setActive(arg0_39.select_bgTF, true)
	setActive(arg0_39.photoModel:Find("left_btn"), false)

	local var0_39 = 1

	for iter0_39, iter1_39 in pairs(arg0_39.takeModelTFDic) do
		setActive(iter1_39, true)

		if arg0_39.takePhotoModel == iter0_39 then
			setAnchoredPosition(iter1_39, {
				x = 0
			})
		else
			setAnchoredPosition(iter1_39, {
				x = -66 * var0_39
			})

			var0_39 = var0_39 + 1
		end
	end
end

function var0_0.ChangeTakePhotoModel(arg0_40, arg1_40)
	if arg0_40.takePhotoModel == arg1_40 then
		return
	end

	if arg0_40.takePhotoModel then
		local var0_40 = arg0_40.takeModelTFDic[arg0_40.takePhotoModel]

		setActive(var0_40:Find("select"), false)
		setActive(var0_40:Find("unSelect"), true)
	end

	arg0_40.takePhotoModel = arg1_40

	local var1_40 = arg0_40.takeModelTFDic[arg0_40.takePhotoModel]

	setActive(var1_40:Find("select"), true)
	setActive(var1_40:Find("unSelect"), false)

	local var2_40
	local var3_40

	if arg0_40.takePhotoModel == 2 then
		var2_40 = arg0_40.fpsCamera.gameObject:GetComponent(typeof(CameraPovZoom))
		var3_40 = (arg0_40.fpsHeight[1] - arg0_40.fpsHeight[2]) / (arg0_40.fpsHeight[3] - arg0_40.fpsHeight[2])
	else
		var2_40 = arg0_40.tpsCamera.gameObject:GetComponent(typeof(CameraPovZoom))
		var3_40 = (arg0_40.tpsHeight[1] - arg0_40.tpsHeight[2]) / (arg0_40.tpsHeight[3] - arg0_40.tpsHeight[2])
	end

	setSlider(arg0_40.sliderZoom, 0, 1, var3_40)
	var2_40:SetCurrentZoom(50)
	arg0_40:emitCore(ISLAND_EVT.Change_TakePhoto_Model, arg0_40.takePhotoModel)
end

function var0_0.OnShow(arg0_41)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandTakeThoto(1))
	arg0_41:ChangeTakePhotoModel(IslandConst.TakePhotoModel.First)
	arg0_41:RightSelectBtnHandle()
end

function var0_0.OnDisable(arg0_42)
	arg0_42:OnHide()
end

function var0_0.OnHide(arg0_43)
	if arg0_43.recordState then
		triggerButton(arg0_43.btnFilm)

		return
	end
end

function var0_0.OnExit(arg0_44)
	local var0_44 = arg0_44.islandScene.sceneMgr:IsAllPageClose()

	arg0_44.takePhotoModel = nil

	arg0_44:emitCore(ISLAND_EVT.Change_TakePhoto_Model, IslandConst.TakePhotoModel.None, var0_44)
end

function var0_0.SetMute(arg0_45)
	if arg0_45 then
		pg.CriMgr.GetInstance():MuteAllVolume()
	else
		pg.CriMgr.GetInstance():ResetAllVolume()
	end
end

function var0_0.OnDestroy(arg0_46)
	return
end

return var0_0
