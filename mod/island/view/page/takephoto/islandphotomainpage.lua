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
	arg0_2.stopRecBtn = arg0_2:findTF("stopRec")
	arg0_2.videoTipPanel = arg0_2:findTF("videoTipPanel")

	setActive(arg0_2.videoTipPanel, false)

	arg0_2.photoModel = arg0_2:findTF("Center/photoModel")
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
		local function var0_9(arg0_10)
			setActive(arg0_5.centerPanel, arg0_10)
			setActive(arg0_5._tf:Find("RightTop"), arg0_10)

			if PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0 then
				setActive(pg.UIMgr.GetInstance().OverlayEffect, arg0_10)
			end
		end

		local function var1_9(arg0_11)
			warning("截图结果：" .. tostring(true))

			local var0_11 = Tex2DExtension.EncodeToJPG(arg0_11)

			arg0_5:OpenPage(IslandPhotoSharePage, var0_11, arg0_11)
			IslandTaskHelper.UpdateClientTaskProgress(IslandTaskTargetType.TAKE_PHOTO, 0)
			IslandAchievementHelper.OnTakePhoto(0)
		end

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandTakeThoto(2))
		BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(arg0_5.mainCamera, var1_9)
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
	onSlider(arg0_5, arg0_5.sliderZoom, function(arg0_16)
		arg0_5:ChangeSliderValue(arg0_16)
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
		local var0_18

		if arg0_5.takePhotoModel == 2 then
			var0_18 = (arg0_5.fpsHeight[1] - arg0_5.fpsHeight[2]) / (arg0_5.fpsHeight[3] - arg0_5.fpsHeight[2])
		else
			var0_18 = (arg0_5.tpsHeight[1] - arg0_5.tpsHeight[2]) / (arg0_5.tpsHeight[3] - arg0_5.tpsHeight[2])

			arg0_5:emitCore(ISLAND_EVT.Change_TakePhoto_Model, arg0_5.takePhotoModel)
		end

		setSlider(arg0_5.sliderZoom, 0, 1, var0_18)
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

		local function var0_20(arg0_21)
			setActive(arg0_5.centerPanel, arg0_21)

			arg0_5:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_21 and 1 or 0

			arg0_5:emitCore(ISLAND_EVT.SetOpMoveBtnActve, arg0_21, true)
		end

		if not arg0_5.recordState then
			local function var1_20(arg0_22)
				if not arg0_22 then
					var0_20(true)

					arg0_5.recordState = false

					LeanTween.moveX(arg0_5.stopRecBtn, arg0_5.stopRecBtn.rect.width, 0.15)
				else
					arg0_5.recordState = true
				end
			end

			local function var2_20()
				setActive(arg0_5.stopRecBtn, true)
				LeanTween.moveX(arg0_5.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					var0_0.SetMute(true)

					arg0_5.recordFilePath = YSNormalTool.RecordTool.GenRecordFilePath()

					YSNormalTool.RecordTool.StartRecording(var1_20, arg0_5.recordFilePath)
				end))
			end

			seriesAsync({
				function(arg0_25)
					PermissionHelper.Request3DDorm(arg0_25, nil)
				end,
				function(arg0_26)
					var0_20(false)

					local var0_26 = PlayerPrefs.GetInt("hadShowForVideoTipDorm", 0)

					if not var0_26 or var0_26 <= 0 then
						PlayerPrefs.SetInt("hadShowForVideoTipDorm", 1)

						arg0_5:findTF("Text", arg0_5.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

						onButton(arg0_5, arg0_5.videoTipPanel, function()
							setActive(arg0_5.videoTipPanel, false)
							var2_20()
						end)
						setActive(arg0_5.videoTipPanel, true)
					else
						var2_20()
					end
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.stopRecBtn, function()
		arg0_5.recordState = false

		local function var0_28(arg0_29)
			if arg0_29 and PLATFORM == PLATFORM_ANDROID then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("word_save_video"),
					onNo = function()
						if System.IO.File.Exists(arg0_5.recordFilePath) then
							System.IO.File.Delete(arg0_5.recordFilePath)
						end
					end,
					onYes = function()
						YSNormalTool.MediaTool.SaveVideoToAlbum(arg0_5.recordFilePath, function(arg0_32, arg1_32)
							if arg0_32 then
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

		local function var1_28(arg0_33)
			setActive(arg0_5.centerPanel, arg0_33)

			arg0_5:findTF("RightTop"):GetComponent("CanvasGroup").alpha = arg0_33 and 1 or 0
		end

		if not LeanTween.isTweening(go(arg0_5.stopRecBtn)) then
			LeanTween.moveX(arg0_5.stopRecBtn, arg0_5.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_5.stopRecBtn, false)
				seriesAsync({
					function(arg0_35)
						YSNormalTool.RecordTool.StopRecording(var0_28)
						var1_28(true)
						var0_0.SetMute(false)
					end
				})
			end))
		end
	end)
	setActive(arg0_5.stopRecBtn, false)
end

function var0_0.ChangeSliderValue(arg0_36, arg1_36)
	local var0_36
	local var1_36

	if arg0_36.takePhotoModel == 2 then
		var0_36 = arg0_36.fpsCamera.gameObject:GetComponent(typeof(CameraPovLook))
		var1_36 = arg1_36 * (arg0_36.fpsHeight[3] - arg0_36.fpsHeight[2]) + arg0_36.fpsHeight[2]
	else
		var0_36 = arg0_36.tpsCamera.gameObject:GetComponent(typeof(CameraPovLook))
		var1_36 = arg1_36 * (arg0_36.tpsHeight[3] - arg0_36.tpsHeight[2]) + arg0_36.tpsHeight[2]

		arg0_36:emitCore(ISLAND_EVT.Change_Photo_Height, arg0_36.takePhotoModel, var1_36)
	end

	var0_36:SetTargetOffsetY(var1_36)
end

function var0_0.RightSelectBtnHandle(arg0_37)
	setActive(arg0_37.unselectBgTF, true)
	setActive(arg0_37.select_bgTF, false)
	setActive(arg0_37.photoModel:Find("left_btn"), true)

	for iter0_37, iter1_37 in pairs(arg0_37.takeModelTFDic) do
		if arg0_37.takePhotoModel == iter0_37 then
			setActive(iter1_37:Find("select"), true)
			setActive(iter1_37:Find("unSelect"), false)
			setActive(iter1_37, true)
			setAnchoredPosition(iter1_37, {
				x = 0
			})
		else
			setActive(iter1_37:Find("unSelect"), true)
			setActive(iter1_37:Find("select"), false)
			setActive(iter1_37, false)
		end
	end
end

function var0_0.LeftSelectBtnHandle(arg0_38)
	setActive(arg0_38.unselectBgTF, false)
	setActive(arg0_38.select_bgTF, true)
	setActive(arg0_38.photoModel:Find("left_btn"), false)

	local var0_38 = 1

	for iter0_38, iter1_38 in pairs(arg0_38.takeModelTFDic) do
		setActive(iter1_38, true)

		if arg0_38.takePhotoModel == iter0_38 then
			setAnchoredPosition(iter1_38, {
				x = 0
			})
		else
			setAnchoredPosition(iter1_38, {
				x = -66 * var0_38
			})

			var0_38 = var0_38 + 1
		end
	end
end

function var0_0.ChangeTakePhotoModel(arg0_39, arg1_39)
	if arg0_39.takePhotoModel == arg1_39 then
		return
	end

	if arg0_39.takePhotoModel then
		local var0_39 = arg0_39.takeModelTFDic[arg0_39.takePhotoModel]

		setActive(var0_39:Find("select"), false)
		setActive(var0_39:Find("unSelect"), true)
	end

	arg0_39.takePhotoModel = arg1_39

	local var1_39 = arg0_39.takeModelTFDic[arg0_39.takePhotoModel]

	setActive(var1_39:Find("select"), true)
	setActive(var1_39:Find("unSelect"), false)

	local var2_39
	local var3_39

	if arg0_39.takePhotoModel == 2 then
		var2_39 = arg0_39.fpsCamera.gameObject:GetComponent(typeof(CameraPovZoom))
		var3_39 = (arg0_39.fpsHeight[1] - arg0_39.fpsHeight[2]) / (arg0_39.fpsHeight[3] - arg0_39.fpsHeight[2])
	else
		var2_39 = arg0_39.tpsCamera.gameObject:GetComponent(typeof(CameraPovZoom))
		var3_39 = (arg0_39.tpsHeight[1] - arg0_39.tpsHeight[2]) / (arg0_39.tpsHeight[3] - arg0_39.tpsHeight[2])
	end

	setSlider(arg0_39.sliderZoom, 0, 1, var3_39)
	var2_39:SetCurrentZoom(50)
	arg0_39:emitCore(ISLAND_EVT.Change_TakePhoto_Model, arg0_39.takePhotoModel)
end

function var0_0.OnShow(arg0_40)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandTakeThoto(1))
	arg0_40:ChangeTakePhotoModel(IslandConst.TakePhotoModel.First)
	arg0_40:RightSelectBtnHandle()
end

function var0_0.OnHide(arg0_41)
	arg0_41.takePhotoModel = nil

	arg0_41:emitCore(ISLAND_EVT.Change_TakePhoto_Model, IslandConst.TakePhotoModel.None)
end

function var0_0.SetMute(arg0_42)
	if arg0_42 then
		CriWare.CriAtom.SetCategoryVolume("Category_CV", 0)
		CriWare.CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriWare.CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriWare.CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriWare.CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriWare.CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

function var0_0.OnDestroy(arg0_43)
	return
end

return var0_0
