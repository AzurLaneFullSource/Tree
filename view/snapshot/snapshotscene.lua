local var0_0 = class("SnapshotScene", import("..base.BaseUI"))

var0_0.SELECT_CHAR_PANEL = "SnapshotScene.SELECT_CHAR_PANEL"
var0_0.SHARE_PANEL = "SnapshotScene.SHARE_PANEL"
var0_0.SHOW_PAINT = 0
var0_0.SHOW_LIVE2D = 1
var0_0.SHOW_SPINE = 2
var0_0.STATE_TAKE_PHOTO = 0
var0_0.STATE_TAKE_VIDEO = 1

function var0_0.getUIName(arg0_1)
	return "snapshot"
end

function var0_0.init(arg0_2)
	setActive(pg.UIMgr.GetInstance().OverlayEffect, false)

	arg0_2.dummy = arg0_2:findTF("SnapshotInvisible")

	arg0_2:SetDummyForIOS(true)

	arg0_2.ui = arg0_2:findTF("ui")
	arg0_2.backBtn = arg0_2:findTF("ui/back")
	arg0_2.switchDirBtn = arg0_2:findTF("ui/switchDir")
	arg0_2.takeBtn = arg0_2:findTF("ui/bg/take")
	arg0_2.videoTakeImg = arg0_2:findTF("ui/bg/take/videoTakeImg")

	SetActive(arg0_2.videoTakeImg, false)

	arg0_2.switchCamBtn = arg0_2:findTF("ui/bg/switchCam")
	arg0_2.selectCharBtn = arg0_2:findTF("ui/bg/selectChar")
	arg0_2.l2dCtrlPanl = arg0_2:findTF("ui/bg/l2dBgImg")
	arg0_2.l2dStopBtnGo = arg0_2:findTF("ui/bg/l2dBgImg/stopBtn")
	arg0_2.l2dPlayBtnGo = arg0_2:findTF("ui/bg/l2dBgImg/playBtn")

	SetActive(arg0_2.l2dPlayBtnGo, false)

	arg0_2.l2dAnimationBtnGo = arg0_2:findTF("ui/bg/l2dBgImg/animationsBtn").gameObject
	arg0_2.l2dAnimations = arg0_2:findTF("ui/bg/animationsBg")
	arg0_2.l2dAnimationBackBtnTrans = arg0_2:findTF("animationsBackBtn", arg0_2.l2dAnimations)

	SetActive(arg0_2.l2dAnimations, false)

	arg0_2.selectedID = 1
	arg0_2.scrollItems = {}
	arg0_2.isPause = false
	arg0_2.animTpl = arg0_2:findTF("animation_tpl", arg0_2.l2dAnimations)

	SetActive(arg0_2.animTpl, false)

	arg0_2.animLayout = arg0_2:findTF("animation_container/animations", arg0_2.l2dAnimations)
	arg0_2.animContainer = arg0_2:findTF("animation_container", arg0_2.l2dAnimations):GetComponent("LScrollRect")
	arg0_2.animContainer.decelerationRate = 0.1

	function arg0_2.animContainer.onInitItem(arg0_3)
		arg0_2:onInitItem(arg0_3)
	end

	function arg0_2.animContainer.onUpdateItem(arg0_4, arg1_4)
		arg0_2:onUpdateItem(arg0_4, arg1_4)
	end

	function arg0_2.animContainer.onReturnItem(arg0_5, arg1_5)
		arg0_2:onReturnItem(arg0_5, arg1_5)
	end

	function arg0_2.animContainer.onStart()
		arg0_2:updateSelectedItem()
	end

	arg0_2.paintBtn = arg0_2:findTF("ui/bg/paintBtn")
	arg0_2.live2dBtn = arg0_2:findTF("ui/bg/l2dBgImg/live2dBtn")
	arg0_2.spineBtn = arg0_2:findTF("ui/bg/spineBtn")
	arg0_2.modePnlTF = arg0_2:findTF("ui/bg/modePnl")
	arg0_2.takePhotoBtn = arg0_2:findTF("ui/bg/modePnl/takePhotoBtn")
	arg0_2.takeVideoBtn = arg0_2:findTF("ui/bg/modePnl/takeVideoBtn")
	arg0_2.stopRecBtn = arg0_2:findTF("stopRec")
	arg0_2.snapshot = arg0_2:findTF("snapshot")
	arg0_2.webcam = arg0_2.snapshot:GetComponent(typeof(WebCam))
	arg0_2.ysScreenShoter = arg0_2.snapshot:GetComponent(typeof(YSTool.YSScreenShoter))
	arg0_2.ysScreenRecorder = arg0_2.snapshot:GetComponent(typeof(YSTool.YSScreenRecorder))
	arg0_2.paint = arg0_2:findTF("container/paint")
	arg0_2.live2d = arg0_2:findTF("live2d", arg0_2.paint)
	arg0_2.spine = arg0_2:findTF("spine", arg0_2.paint)
	arg0_2.paintSkin = nil
	arg0_2.showLive2d = false
	arg0_2.showType = var0_0.SHOW_PAINT
	arg0_2.state = var0_0.STATE_TAKE_PHOTO

	arg0_2:setSkinAndLive2d(arg0_2.contextData.skinId, arg0_2.contextData.live2d)

	arg0_2.verticalEulerAngle = 90
	arg0_2.horizontalEulerAngle = 0
	arg0_2.rotateUseTime = 0.2
	arg0_2.isVertical = false
	arg0_2.backBtnImg = arg0_2:findTF("ui/back/Image")
	arg0_2.selectCharBtnImg = arg0_2:findTF("ui/bg/selectChar/Image")
	arg0_2.switchCamBtnImg = arg0_2:findTF("ui/bg/switchCam/Image")
	arg0_2.l2dBtnImg = arg0_2:findTF("ui/bg/paintBtn/Image")
	arg0_2.l2dStopBtnImg = arg0_2:findTF("ui/bg/l2dBgImg/stopBtn/Image")
	arg0_2.l2dPlayBtnImg = arg0_2:findTF("ui/bg/l2dBgImg/playBtn/Image")
	arg0_2.l2d2PaintBtnImg = arg0_2:findTF("ui/bg/l2dBgImg/live2dBtn/Image")
	arg0_2.takePhotoVerticalText = arg0_2:findTF("ui/bg/modePnl/takePhotoBtn/verticalText")
	arg0_2.takePhotoHorizontalText = arg0_2:findTF("ui/bg/modePnl/takePhotoBtn/horizontalText")
	arg0_2.takePhotoVerticalText:GetComponent("Text").text = i18n("word_photo_mode")
	arg0_2.takePhotoHorizontalText:GetComponent("Text").text = i18n("word_photo_mode")

	SetActive(arg0_2.takePhotoHorizontalText, false)

	arg0_2.takeVideoVerticalText = arg0_2:findTF("ui/bg/modePnl/takeVideoBtn/verticalText")
	arg0_2.takeVideoHorizontalText = arg0_2:findTF("ui/bg/modePnl/takeVideoBtn/horizontalText")
	arg0_2.takeVideoVerticalText:GetComponent("Text").text = i18n("word_video_mode")
	arg0_2.takeVideoHorizontalText:GetComponent("Text").text = i18n("word_video_mode")

	SetActive(arg0_2.takeVideoHorizontalText, false)

	arg0_2.isFlipping = false
	arg0_2.videoTipPanel = arg0_2:findTF("videoTipPanel")

	setActive(arg0_2.videoTipPanel, false)
end

function var0_0.back(arg0_7)
	if arg0_7.exited then
		return
	end

	arg0_7:emit(var0_0.ON_BACK)
end

function var0_0.saveVideo(arg0_8)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("word_save_video"),
		onYes = function()
			YARecorder.Inst:DiscardVideo()
		end
	})
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:back()
	end)
	onButton(arg0_10, arg0_10.switchDirBtn, function()
		arg0_10.isVertical = not arg0_10.isVertical

		arg0_10:updateUIDirection()
		arg0_10:updateCameraCanvas()
	end)
	onButton(arg0_10, arg0_10.takeBtn, function()
		if arg0_10.state == var0_0.STATE_TAKE_PHOTO then
			setActive(arg0_10.ui, false)

			local function var0_13(arg0_14)
				warning("截图结果：" .. tostring(arg0_14))
				setActive(arg0_10.ui, true)
			end

			local function var1_13(arg0_15)
				local var0_15 = UnityEngine.Texture2D.New(Screen.width, Screen.height)

				Tex2DExtension.LoadImage(var0_15, arg0_15)
				arg0_10:emit(var0_0.SHARE_PANEL, var0_15, arg0_15)

				if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
					print("start photo : play sound")
					NotificationMgr.Inst:PlayShutterSound()
				end
			end

			arg0_10.ysScreenShoter:TakeScreenShotData(var0_13, var1_13)
		elseif arg0_10.state == var0_0.STATE_TAKE_VIDEO then
			setActive(arg0_10.ui, false)

			local function var2_13(arg0_16)
				if arg0_16 ~= -1 then
					setActive(arg0_10.ui, true)
					LeanTween.moveX(arg0_10.stopRecBtn, arg0_10.stopRecBtn.rect.width, 0.15)
				end
			end

			local function var3_13(arg0_17)
				warning("开始录屏结果：" .. tostring(arg0_17))
			end

			local function var4_13()
				setActive(arg0_10.stopRecBtn, true)
				LeanTween.moveX(arg0_10.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					arg0_10:SetMute(true)
					arg0_10.ysScreenRecorder:BeforeStart()
					arg0_10.ysScreenRecorder:StartRecord(var3_13, var2_13)
				end))
			end

			local var5_13 = PlayerPrefs.GetInt("hadShowForVideoTip")

			if not var5_13 or var5_13 <= 0 then
				PlayerPrefs.SetInt("hadShowForVideoTip", 1)

				arg0_10:findTF("Text", arg0_10.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

				onButton(arg0_10, arg0_10.videoTipPanel, function()
					setActive(arg0_10.videoTipPanel, false)
					var4_13()

					if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
						print("start recording : play sound")
						NotificationMgr.Inst:PlayStartRecordSound()
					end
				end)
				setActive(arg0_10.videoTipPanel, true)
			else
				var4_13()
			end
		end
	end)
	onButton(arg0_10, arg0_10.paintBtn, function()
		if arg0_10.showType == var0_0.SHOW_PAINT then
			arg0_10:clearSkin()

			arg0_10.showType = var0_0.SHOW_LIVE2D

			arg0_10:updateShowType()
			arg0_10:updateSkin()
			arg0_10:ResetL2dPanel()
		end
	end)
	onButton(arg0_10, arg0_10.live2dBtn, function()
		if arg0_10.showType == var0_0.SHOW_LIVE2D then
			arg0_10:clearSkin()

			arg0_10.showType = var0_0.SHOW_PAINT

			arg0_10:updateShowType()
			arg0_10:updateSkin()
		end
	end)
	onButton(arg0_10, arg0_10.spineBtn, function()
		if arg0_10.showType == var0_0.SHOW_SPINE then
			arg0_10:clearSkin()

			arg0_10.showType = var0_0.SHOW_PAINT

			arg0_10:updateShowType()
			arg0_10:updateSkin()
		end
	end)

	local function var0_10()
		if arg0_10.state == var0_0.STATE_TAKE_PHOTO then
			return
		end

		arg0_10.state = var0_0.STATE_TAKE_PHOTO

		LeanTween.moveY(rtf(arg0_10.modePnlTF), 56, 0.1)
		SetActive(arg0_10.videoTakeImg, false)
	end

	onButton(arg0_10, arg0_10.takePhotoBtn, var0_10)
	onButton(arg0_10, arg0_10.takeVideoBtn, function()
		if CheckPermissionGranted(ANDROID_RECORD_AUDIO_PERMISSION) and CheckPermissionGranted(ANDROID_WRITE_EXTERNAL_PERMISSION) then
			arg0_10:changeToTakeVideo()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_record_audio_tip1"),
				onYes = function()
					ApplyPermission({
						ANDROID_RECORD_AUDIO_PERMISSION,
						ANDROID_WRITE_EXTERNAL_PERMISSION
					})
				end
			})
		end
	end)
	var0_10()
	onButton(arg0_10, arg0_10.stopRecBtn, function()
		local function var0_27(arg0_28)
			warning("结束录屏结果：" .. tostring(arg0_28))
		end

		if not LeanTween.isTweening(go(arg0_10.stopRecBtn)) then
			LeanTween.moveX(arg0_10.stopRecBtn, arg0_10.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0_10.ui, true)
				setActive(arg0_10.stopRecBtn, false)
				arg0_10.ysScreenRecorder:StopRecord(var0_27)

				if PLATFORM == PLATFORM_ANDROID then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("word_save_video"),
						onNo = function()
							arg0_10.ysScreenRecorder:DiscardVideo()
						end,
						onYes = function()
							local var0_31 = arg0_10.ysScreenRecorder:GetVideoFilePath()

							warning("源录像路径：" .. tostring(var0_31))
							MediaSaver.SaveVideoWithPath(var0_31)
						end
					})
				end

				arg0_10:SetMute(false)
			end))
		end
	end)
	setActive(arg0_10.stopRecBtn, false)
	onButton(arg0_10, arg0_10.switchCamBtn, function()
		arg0_10.isFlipping = not arg0_10.isFlipping

		arg0_10.webcam:SwitchCam()
		arg0_10:updateCameraCanvas()
	end)
	onButton(arg0_10, arg0_10.selectCharBtn, function()
		arg0_10:emit(var0_0.SELECT_CHAR_PANEL)
	end)

	function arg0_10.webcam.takeCallback(arg0_34)
		setActive(arg0_10.ui, true)
	end

	onButton(arg0_10, arg0_10.l2dStopBtnGo, function()
		arg0_10.isPause = true

		arg0_10:UpdateL2dPlayState()
	end)
	onButton(arg0_10, arg0_10.l2dPlayBtnGo, function()
		arg0_10.isPause = false

		arg0_10:UpdateL2dPlayState()
	end)
	onButton(arg0_10, arg0_10.l2dAnimationBtnGo, function()
		arg0_10:setLive2dAnimsPanelState(true)
	end)
	onButton(arg0_10, arg0_10.l2dAnimationBackBtnTrans, function()
		arg0_10:setLive2dAnimsPanelState(false)
	end)
	cameraPaintViewAdjust(true)
	arg0_10:updateCameraCanvas()
	arg0_10:updateShowType()
end

function var0_0.changeToTakeVideo(arg0_39)
	if arg0_39.state == var0_0.STATE_TAKE_VIDEO then
		return
	end

	arg0_39.state = var0_0.STATE_TAKE_VIDEO

	LeanTween.moveY(rtf(arg0_39.modePnlTF), -56, 0.1)
	SetActive(arg0_39.videoTakeImg, true)
end

function var0_0.willExit(arg0_40)
	arg0_40:SetDummyForIOS(false)
	cameraPaintViewAdjust(false)
	arg0_40:clearSkin()

	local var0_40 = PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0

	setActive(pg.UIMgr.GetInstance().OverlayEffect, var0_40)
end

function var0_0.clearSkin(arg0_41)
	if arg0_41.paintSkin and arg0_41.showType == var0_0.SHOW_PAINT then
		retPaintingPrefab(arg0_41.paint, arg0_41.paintSkin)
	end

	if arg0_41.spineSkin and arg0_41.showType == var0_0.SHOW_SPINE then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_41.spineSkin, go(arg0_41:findTF("model", arg0_41.spine)))
	end

	if arg0_41.live2dCom then
		arg0_41.live2dCom.FinishAction = nil
		arg0_41.live2dCom.EventAction = nil
	end

	if arg0_41.live2dCom and arg0_41.showType == var0_0.SHOW_LIVE2D then
		Destroy(arg0_41.live2dCom.gameObject)

		arg0_41.live2dCom = nil
	end

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_41.live2dRequestId)

	arg0_41.live2dRequestId = nil
end

function var0_0.checkSkin(arg0_42, arg1_42)
	local var0_42 = pg.ship_skin_template[arg1_42]

	assert(arg1_42 == -1 or var0_42, "invalid skin id " .. arg1_42)

	arg0_42.skin = var0_42

	local var1_42 = false

	if arg0_42.contextData.tbId then
		arg0_42.paintSkin = pg.secretary_special_ship[arg0_42.contextData.tbId].prefab or "tbniang"
		var1_42 = true
		arg0_42.contextData.tbId = nil
	elseif arg0_42.paintSkin ~= var0_42.painting or var0_42.spineSkin ~= var0_42.prefab then
		arg0_42:clearSkin()

		arg0_42.paintSkin = var0_42.painting
		arg0_42.spineSkin = var0_42.prefab
		arg0_42.l2dAnims = var0_42.l2d_animations

		if arg0_42.l2dAnims == "" then
			arg0_42.l2dAnims = {
				"idle"
			}
		end

		var1_42 = true
	end

	return var1_42
end

function var0_0.setSkinAndLive2d(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43:checkSkin(arg1_43)

	if arg0_43.showType ~= var0_0.SHOW_LIVE2D and arg2_43 then
		arg0_43.showType = var0_0.SHOW_LIVE2D

		arg0_43:updateShowType()

		var0_43 = true
	end

	if var0_43 then
		arg0_43:updateSkin()
	end
end

function var0_0.setSkin(arg0_44, arg1_44)
	if arg0_44:checkSkin(arg1_44) then
		arg0_44:updateSkin()
	end
end

function var0_0.setLive2d(arg0_45, arg1_45)
	if arg0_45.showType ~= var0_0.SHOW_LIVE2D and arg1_45 then
		arg0_45:clearSkin()

		arg0_45.showType = var0_0.SHOW_LIVE2D

		arg0_45:updateShowType()
		arg0_45:updateSkin()
	end
end

function var0_0.updateShowType(arg0_46)
	setActive(arg0_46.paintBtn, false)
	arg0_46:setLive2dAnimsPanelState(false)
	setActive(arg0_46.live2dBtn, false)
	setActive(arg0_46.l2dCtrlPanl, false)
	setActive(arg0_46.spineBtn, false)

	if arg0_46.showType == var0_0.SHOW_PAINT then
		setActive(arg0_46.paintBtn, true)
	elseif arg0_46.showType == var0_0.SHOW_LIVE2D then
		setActive(arg0_46.live2dBtn, true)
		SetActive(arg0_46.l2dCtrlPanl, true)
	elseif arg0_46.showType == var0_0.SHOW_SPINE then
		setActive(arg0_46.spineBtn, true)
	end
end

local function var1_0(arg0_47)
	if arg0_47 == var0_0.SHOW_PAINT then
		return 0.5, 2
	elseif arg0_47 == var0_0.SHOW_LIVE2D then
		return 0.5, 2
	elseif arg0_47 == var0_0.SHOW_SPINE then
		return 0.5, 4
	end
end

function var0_0.updateSkin(arg0_48)
	if arg0_48.showType == var0_0.SHOW_LIVE2D and (not ResourceMgr.Inst:AssetExist("live2d/" .. arg0_48.paintSkin) or not checkABExist("live2d/" .. arg0_48.paintSkin)) then
		arg0_48.showType = var0_0.SHOW_PAINT

		arg0_48:updateShowType()
	end

	local var0_48 = arg0_48.paint:GetComponent(typeof(Zoom))
	local var1_48 = 0
	local var2_48 = 0
	local var3_48, var4_48 = var1_0(arg0_48.showType)

	var0_48.minZoom, var0_48.maxZoom = var3_48, var4_48

	if var4_48 < arg0_48.paint.localScale.x then
		arg0_48.paint.localScale = Vector3(var4_48, var4_48, var4_48)
	elseif var3_48 > arg0_48.paint.localScale.x then
		arg0_48.paint.localScale = Vector3(var3_48, var3_48, var3_48)
	end

	if arg0_48.showType == var0_0.SHOW_LIVE2D then
		pg.UIMgr.GetInstance():LoadingOn()

		arg0_48.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg0_48.paintSkin, function(arg0_49)
			UIUtil.SetLayerRecursively(arg0_49, LayerMask.NameToLayer("UI"))

			local var0_49 = arg0_49.transform

			var0_49:SetParent(arg0_48.live2d, true)

			var0_49.localScale = Vector3(52, 52, 52)
			var0_49.localPosition = BuildVector3(arg0_48.skin.live2d_offset)

			local var1_49 = arg0_49:GetComponent(typeof(Live2dChar))
			local var2_49 = pg.AssistantInfo.action2Id.idle

			var1_49:SetAction(var2_49)

			function var1_49.FinishAction(arg0_50)
				if arg0_48.selectedID and arg0_48.selectedID ~= pg.AssistantInfo.action2Id.idle then
					arg0_48:setL2dAction(arg0_48.selectedID)
				end
			end

			arg0_48.live2dCom = var1_49
			arg0_48.live2dCom.name = arg0_48.paintSkin
			arg0_48.playActionId = pg.AssistantInfo.action2Id.idle
			arg0_48.selectedID = pg.AssistantInfo.action2Id.idle
			arg0_48.live2dAnimator = arg0_49:GetComponent(typeof(Animator))

			local var3_49 = arg0_48.live2dCom:GetCubismParameter("Paramring")

			if var3_49 then
				if arg0_48.contextData and arg0_48.contextData.propose then
					arg0_48.live2dCom:AddParameterValue(var3_49, 1, CubismParameterBlendMode.Override)
				else
					arg0_48.live2dCom:AddParameterValue(var3_49, 0, CubismParameterBlendMode.Override)
				end
			end

			arg0_48:ResetL2dPanel()
			arg0_48:setLive2dAnimsPanelState(true)
			SetActive(arg0_48.spine, false)
			SetActive(arg0_48.live2d, true)
			pg.UIMgr.GetInstance():LoadingOff()

			local var4_49 = arg0_48.skin.lip_sync_gain
			local var5_49 = arg0_48.skin.lip_smoothing

			if var4_49 and var4_49 ~= 0 then
				arg0_48.live2d:GetChild(0):GetComponent("CubismCriSrcMouthInput").Gain = var4_49
			end

			if var5_49 and var5_49 ~= 0 then
				arg0_48.live2d:GetChild(0):GetComponent("CubismCriSrcMouthInput").Smoothing = var5_49
			end
		end)
	elseif arg0_48.showType == var0_0.SHOW_PAINT then
		SetActive(arg0_48.live2d, false)
		SetActive(arg0_48.spine, false)
		setPaintingPrefabAsync(arg0_48.paint, arg0_48.paintSkin, "mainNormal")
	elseif arg0_48.showType == var0_0.SHOW_SPINE then
		SetActive(arg0_48.live2d, false)
		SetActive(arg0_48.spine, true)
		PoolMgr.GetInstance():GetSpineChar(arg0_48.spineSkin, true, function(arg0_51)
			arg0_51.name = "model"

			local var0_51 = arg0_51.transform

			var0_51:SetParent(arg0_48.spine, true)

			var0_51.localScale = Vector3(0.5, 0.5, 0.5)
			var0_51.localPosition = Vector3.zero

			arg0_48:playAction("normal")
		end)
	end
end

function var0_0.playAction(arg0_52, arg1_52)
	if arg0_52.showType ~= var0_0.SHOW_SPINE then
		return
	end

	GetOrAddComponent(arg0_52:findTF("model", arg0_52.spine), typeof(SpineAnimUI)):SetAction(arg1_52, 0)
end

function var0_0.ResetL2dPanel(arg0_53)
	arg0_53.selectedID = pg.AssistantInfo.action2Id.idle
	arg0_53.isPause = false

	arg0_53:UpdateL2dPlayState(true)
	arg0_53:updateSelectedItem()
end

function var0_0.UpdateL2dPlayState(arg0_54, arg1_54)
	if arg0_54.showType ~= var0_0.SHOW_LIVE2D then
		return
	end

	if arg0_54.isPause then
		SetActive(arg0_54.l2dStopBtnGo, false)
		SetActive(arg0_54.l2dPlayBtnGo, true)
	else
		SetActive(arg0_54.l2dStopBtnGo, true)
		SetActive(arg0_54.l2dPlayBtnGo, false)
	end

	if not arg1_54 then
		arg0_54:L2dAnimationState()
	end
end

function var0_0.L2dAnimationState(arg0_55)
	if arg0_55.showType ~= var0_0.SHOW_LIVE2D then
		return
	end

	if arg0_55.isPause then
		arg0_55.live2dAnimator.speed = 0
	else
		arg0_55.live2dAnimator.speed = 1
	end
end

function var0_0.updateLive2dAnimationPanel(arg0_56)
	SetActive(arg0_56.l2dAnimations, arg0_56.isShowL2dAnims)
	SetActive(arg0_56.l2dAnimationBtnGo, not arg0_56.isShowL2dAnims)

	if arg0_56.isShowL2dAnims and #arg0_56.l2dAnims > 1 then
		arg0_56.animContainer:SetTotalCount(#arg0_56.l2dAnims, 0)
	end
end

function var0_0.setLive2dAnimsPanelState(arg0_57, arg1_57)
	arg0_57.isShowL2dAnims = arg1_57

	arg0_57:updateLive2dAnimationPanel()
end

local var2_0 = 3

function var0_0.onInitItem(arg0_58, arg1_58)
	local var0_58 = SnapshotItem.New(arg1_58, false)

	onButton(arg0_58, var0_58.go, function()
		if arg0_58.l2dClickCD and Time.fixedTime - arg0_58.l2dClickCD < var2_0 then
			return
		end

		if arg0_58.selectedID == var0_58:GetID() then
			return
		end

		if var0_58:GetID() == 6 or var0_58:GetID() == 7 then
			arg0_58.l2dClickCD = Time.fixedTime
		end

		arg0_58.selectedID = var0_58:GetID()

		arg0_58:updateSelectedItem()
		arg0_58:setL2dAction(arg0_58.selectedID)
	end, SFX_CONFIRM)

	arg0_58.scrollItems[arg1_58] = var0_58
end

function var0_0.setL2dAction(arg0_60, arg1_60)
	if arg1_60 ~= pg.AssistantInfo.action2Id.idle then
		-- block empty
	end

	if arg0_60.live2dCom and arg1_60 then
		if arg1_60 == pg.AssistantInfo.action2Id.idle then
			arg0_60.live2dCom:SetAction(arg1_60)
		elseif arg0_60.playActionId == pg.AssistantInfo.action2Id.idle then
			arg0_60.live2dCom:SetAction(arg1_60)
		elseif arg0_60.playActionId == arg1_60 then
			arg0_60.live2dCom:SetAction(arg1_60)
		end

		arg0_60.playActionId = arg1_60
	end
end

function var0_0.onUpdateItem(arg0_61, arg1_61, arg2_61)
	arg1_61 = arg1_61 + 1

	local var0_61 = arg0_61.scrollItems[arg2_61]

	if not var0_61 then
		arg0_61:onInitItem(arg2_61)

		var0_61 = arg0_61.scrollItems[arg2_61]
	end

	local var1_61 = arg0_61.l2dAnims[arg1_61]
	local var2_61 = pg.AssistantInfo.action2Id[var1_61]
	local var3_61 = {
		id = var2_61,
		name = i18n(var1_61)
	}

	var0_61:Update(var3_61)

	if arg0_61.isVertical then
		var0_61:SetEulerAngle(arg0_61.verticalEulerAngle)
	else
		var0_61:SetEulerAngle(arg0_61.horizontalEulerAngle)
	end

	if var0_61:GetID() == arg0_61.selectedID then
		var0_61:UpdateSelected(true)
	else
		var0_61:UpdateSelected(false)
	end
end

function var0_0.onReturnItem(arg0_62, arg1_62, arg2_62)
	return
end

function var0_0.updateSelectedItem(arg0_63)
	for iter0_63, iter1_63 in pairs(arg0_63.scrollItems) do
		if iter1_63:HasInfo() then
			if iter1_63:GetID() == arg0_63.selectedID then
				iter1_63:UpdateSelected(true)
			else
				iter1_63:UpdateSelected(false)
			end
		end
	end
end

function var0_0.updateUIDirection(arg0_64)
	if arg0_64.isVertical then
		local var0_64 = arg0_64.verticalEulerAngle
		local var1_64 = arg0_64.rotateUseTime

		LeanTween.rotateZ(go(arg0_64.backBtnImg), var0_64, var1_64)
		LeanTween.rotateZ(go(arg0_64.selectCharBtnImg), var0_64, var1_64)
		LeanTween.rotateZ(go(arg0_64.switchCamBtnImg), var0_64, var1_64)
		LeanTween.rotateZ(go(arg0_64.l2dBtnImg), var0_64, var1_64)
		LeanTween.rotateZ(go(arg0_64.l2dStopBtnImg), var0_64, var1_64)
		LeanTween.rotateZ(go(arg0_64.l2dPlayBtnImg), var0_64, var1_64)
		LeanTween.rotateZ(go(arg0_64.l2d2PaintBtnImg), var0_64, var1_64)
		SetActive(arg0_64.takePhotoVerticalText, false)
		SetActive(arg0_64.takePhotoHorizontalText, true)
		SetActive(arg0_64.takeVideoVerticalText, false)
		SetActive(arg0_64.takeVideoHorizontalText, true)
		LeanTween.rotateZ(go(arg0_64.paint), var0_64, var1_64)
		arg0_64:updateListItemRotate(var0_64, var1_64)
	else
		local var2_64 = arg0_64.horizontalEulerAngle
		local var3_64 = arg0_64.rotateUseTime

		LeanTween.rotateZ(go(arg0_64.backBtnImg), var2_64, var3_64)
		LeanTween.rotateZ(go(arg0_64.selectCharBtnImg), var2_64, var3_64)
		LeanTween.rotateZ(go(arg0_64.switchCamBtnImg), var2_64, var3_64)
		LeanTween.rotateZ(go(arg0_64.l2dBtnImg), var2_64, var3_64)
		LeanTween.rotateZ(go(arg0_64.l2dStopBtnImg), var2_64, var3_64)
		LeanTween.rotateZ(go(arg0_64.l2dPlayBtnImg), var2_64, var3_64)
		LeanTween.rotateZ(go(arg0_64.l2d2PaintBtnImg), var2_64, var3_64)
		SetActive(arg0_64.takePhotoVerticalText, true)
		SetActive(arg0_64.takePhotoHorizontalText, false)
		SetActive(arg0_64.takeVideoVerticalText, true)
		SetActive(arg0_64.takeVideoHorizontalText, false)
		LeanTween.rotateZ(go(arg0_64.paint), var2_64, var3_64)
		arg0_64:updateListItemRotate(var2_64, var3_64)
	end
end

function var0_0.updateListItemRotate(arg0_65, arg1_65, arg2_65)
	for iter0_65, iter1_65 in pairs(arg0_65.scrollItems) do
		iter1_65:RotateUI(arg1_65, arg2_65)
	end
end

function var0_0.updateCameraCanvas(arg0_66)
	local var0_66 = CameraMgr.instance.AspectRatio
	local var1_66 = UnityEngine.Screen.width
	local var2_66 = UnityEngine.Screen.height
	local var3_66 = 1
	local var4_66 = var1_66 / var2_66

	if var4_66 < var0_66 then
		var3_66 = var0_66 / var4_66
	elseif var0_66 < var4_66 then
		var3_66 = var4_66 / var0_66
	end

	if arg0_66.isFlipping then
		arg0_66.snapshot.localScale = Vector3(-var3_66, var3_66, 1)
	else
		arg0_66.snapshot.localScale = Vector3(var3_66, var3_66, 1)
	end
end

function var0_0.SetDummyForIOS(arg0_67, arg1_67)
	if PLATFORM ~= PLATFORM_IPHONEPLAYER then
		setActive(arg0_67.dummy, false)

		return
	end

	local var0_67 = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))

	if arg1_67 then
		var0_67.nearClipPlane = 0

		arg0_67.dummy:SetParent(pg.UIMgr.GetInstance():GetMainCamera().transform)

		arg0_67.dummy.localPosition = Vector3(0, 0, 3)
		arg0_67.dummy.localRotation = Vector3(0, 0, 0)
		arg0_67.dummy.localScale = Vector3(1, 1, 1)

		setActive(arg0_67.dummy, true)
	else
		var0_67.nearClipPlane = -100

		arg0_67.dummy:SetParent(arg0_67._tf)

		arg0_67.dummy.localPosition = Vector3(0, 0, 0)
		arg0_67.dummy.localRotation = Vector3(0, 0, 0)
		arg0_67.dummy.localScale = Vector3(1, 1, 1)
	end
end

function var0_0.SetMute(arg0_68, arg1_68)
	if arg1_68 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

return var0_0
