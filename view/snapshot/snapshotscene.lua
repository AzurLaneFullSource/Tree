local var0 = class("SnapshotScene", import("..base.BaseUI"))

var0.SELECT_CHAR_PANEL = "SnapshotScene.SELECT_CHAR_PANEL"
var0.SHARE_PANEL = "SnapshotScene.SHARE_PANEL"
var0.SHOW_PAINT = 0
var0.SHOW_LIVE2D = 1
var0.SHOW_SPINE = 2
var0.STATE_TAKE_PHOTO = 0
var0.STATE_TAKE_VIDEO = 1

function var0.getUIName(arg0)
	return "snapshot"
end

function var0.init(arg0)
	setActive(pg.UIMgr.GetInstance().OverlayEffect, false)

	arg0.dummy = arg0:findTF("SnapshotInvisible")

	arg0:SetDummyForIOS(true)

	arg0.ui = arg0:findTF("ui")
	arg0.backBtn = arg0:findTF("ui/back")
	arg0.switchDirBtn = arg0:findTF("ui/switchDir")
	arg0.takeBtn = arg0:findTF("ui/bg/take")
	arg0.videoTakeImg = arg0:findTF("ui/bg/take/videoTakeImg")

	SetActive(arg0.videoTakeImg, false)

	arg0.switchCamBtn = arg0:findTF("ui/bg/switchCam")
	arg0.selectCharBtn = arg0:findTF("ui/bg/selectChar")
	arg0.l2dCtrlPanl = arg0:findTF("ui/bg/l2dBgImg")
	arg0.l2dStopBtnGo = arg0:findTF("ui/bg/l2dBgImg/stopBtn")
	arg0.l2dPlayBtnGo = arg0:findTF("ui/bg/l2dBgImg/playBtn")

	SetActive(arg0.l2dPlayBtnGo, false)

	arg0.l2dAnimationBtnGo = arg0:findTF("ui/bg/l2dBgImg/animationsBtn").gameObject
	arg0.l2dAnimations = arg0:findTF("ui/bg/animationsBg")
	arg0.l2dAnimationBackBtnTrans = arg0:findTF("animationsBackBtn", arg0.l2dAnimations)

	SetActive(arg0.l2dAnimations, false)

	arg0.selectedID = 1
	arg0.scrollItems = {}
	arg0.isPause = false
	arg0.animTpl = arg0:findTF("animation_tpl", arg0.l2dAnimations)

	SetActive(arg0.animTpl, false)

	arg0.animLayout = arg0:findTF("animation_container/animations", arg0.l2dAnimations)
	arg0.animContainer = arg0:findTF("animation_container", arg0.l2dAnimations):GetComponent("LScrollRect")
	arg0.animContainer.decelerationRate = 0.1

	function arg0.animContainer.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.animContainer.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	function arg0.animContainer.onReturnItem(arg0, arg1)
		arg0:onReturnItem(arg0, arg1)
	end

	function arg0.animContainer.onStart()
		arg0:updateSelectedItem()
	end

	arg0.paintBtn = arg0:findTF("ui/bg/paintBtn")
	arg0.live2dBtn = arg0:findTF("ui/bg/l2dBgImg/live2dBtn")
	arg0.spineBtn = arg0:findTF("ui/bg/spineBtn")
	arg0.modePnlTF = arg0:findTF("ui/bg/modePnl")
	arg0.takePhotoBtn = arg0:findTF("ui/bg/modePnl/takePhotoBtn")
	arg0.takeVideoBtn = arg0:findTF("ui/bg/modePnl/takeVideoBtn")
	arg0.stopRecBtn = arg0:findTF("stopRec")
	arg0.snapshot = arg0:findTF("snapshot")
	arg0.webcam = arg0.snapshot:GetComponent(typeof(WebCam))
	arg0.ysScreenShoter = arg0.snapshot:GetComponent(typeof(YSTool.YSScreenShoter))
	arg0.ysScreenRecorder = arg0.snapshot:GetComponent(typeof(YSTool.YSScreenRecorder))
	arg0.paint = arg0:findTF("container/paint")
	arg0.live2d = arg0:findTF("live2d", arg0.paint)
	arg0.spine = arg0:findTF("spine", arg0.paint)
	arg0.paintSkin = nil
	arg0.showLive2d = false
	arg0.showType = var0.SHOW_PAINT
	arg0.state = var0.STATE_TAKE_PHOTO

	arg0:setSkinAndLive2d(arg0.contextData.skinId, arg0.contextData.live2d)

	arg0.verticalEulerAngle = 90
	arg0.horizontalEulerAngle = 0
	arg0.rotateUseTime = 0.2
	arg0.isVertical = false
	arg0.backBtnImg = arg0:findTF("ui/back/Image")
	arg0.selectCharBtnImg = arg0:findTF("ui/bg/selectChar/Image")
	arg0.switchCamBtnImg = arg0:findTF("ui/bg/switchCam/Image")
	arg0.l2dBtnImg = arg0:findTF("ui/bg/paintBtn/Image")
	arg0.l2dStopBtnImg = arg0:findTF("ui/bg/l2dBgImg/stopBtn/Image")
	arg0.l2dPlayBtnImg = arg0:findTF("ui/bg/l2dBgImg/playBtn/Image")
	arg0.l2d2PaintBtnImg = arg0:findTF("ui/bg/l2dBgImg/live2dBtn/Image")
	arg0.takePhotoVerticalText = arg0:findTF("ui/bg/modePnl/takePhotoBtn/verticalText")
	arg0.takePhotoHorizontalText = arg0:findTF("ui/bg/modePnl/takePhotoBtn/horizontalText")
	arg0.takePhotoVerticalText:GetComponent("Text").text = i18n("word_photo_mode")
	arg0.takePhotoHorizontalText:GetComponent("Text").text = i18n("word_photo_mode")

	SetActive(arg0.takePhotoHorizontalText, false)

	arg0.takeVideoVerticalText = arg0:findTF("ui/bg/modePnl/takeVideoBtn/verticalText")
	arg0.takeVideoHorizontalText = arg0:findTF("ui/bg/modePnl/takeVideoBtn/horizontalText")
	arg0.takeVideoVerticalText:GetComponent("Text").text = i18n("word_video_mode")
	arg0.takeVideoHorizontalText:GetComponent("Text").text = i18n("word_video_mode")

	SetActive(arg0.takeVideoHorizontalText, false)

	arg0.isFlipping = false
	arg0.videoTipPanel = arg0:findTF("videoTipPanel")

	setActive(arg0.videoTipPanel, false)
end

function var0.back(arg0)
	if arg0.exited then
		return
	end

	arg0:emit(var0.ON_BACK)
end

function var0.saveVideo(arg0)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("word_save_video"),
		onYes = function()
			YARecorder.Inst:DiscardVideo()
		end
	})
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:back()
	end)
	onButton(arg0, arg0.switchDirBtn, function()
		arg0.isVertical = not arg0.isVertical

		arg0:updateUIDirection()
		arg0:updateCameraCanvas()
	end)
	onButton(arg0, arg0.takeBtn, function()
		if arg0.state == var0.STATE_TAKE_PHOTO then
			setActive(arg0.ui, false)

			local function var0(arg0)
				warning("截图结果：" .. tostring(arg0))
				setActive(arg0.ui, true)
			end

			local function var1(arg0)
				local var0 = UnityEngine.Texture2D.New(Screen.width, Screen.height)

				Tex2DExtension.LoadImage(var0, arg0)
				arg0:emit(var0.SHARE_PANEL, var0, arg0)

				if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
					print("start photo : play sound")
					NotificationMgr.Inst:PlayShutterSound()
				end
			end

			arg0.ysScreenShoter:TakeScreenShotData(var0, var1)
		elseif arg0.state == var0.STATE_TAKE_VIDEO then
			setActive(arg0.ui, false)

			local function var2(arg0)
				if arg0 ~= -1 then
					setActive(arg0.ui, true)
					LeanTween.moveX(arg0.stopRecBtn, arg0.stopRecBtn.rect.width, 0.15)
				end
			end

			local function var3(arg0)
				warning("开始录屏结果：" .. tostring(arg0))
			end

			local function var4()
				setActive(arg0.stopRecBtn, true)
				LeanTween.moveX(arg0.stopRecBtn, 0, 0.15):setOnComplete(System.Action(function()
					arg0:SetMute(true)
					arg0.ysScreenRecorder:BeforeStart()
					arg0.ysScreenRecorder:StartRecord(var3, var2)
				end))
			end

			local var5 = PlayerPrefs.GetInt("hadShowForVideoTip")

			if not var5 or var5 <= 0 then
				PlayerPrefs.SetInt("hadShowForVideoTip", 1)

				arg0:findTF("Text", arg0.videoTipPanel):GetComponent("Text").text = i18n("word_take_video_tip")

				onButton(arg0, arg0.videoTipPanel, function()
					setActive(arg0.videoTipPanel, false)
					var4()

					if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "2" then
						print("start recording : play sound")
						NotificationMgr.Inst:PlayStartRecordSound()
					end
				end)
				setActive(arg0.videoTipPanel, true)
			else
				var4()
			end
		end
	end)
	onButton(arg0, arg0.paintBtn, function()
		if arg0.showType == var0.SHOW_PAINT then
			arg0:clearSkin()

			arg0.showType = var0.SHOW_LIVE2D

			arg0:updateShowType()
			arg0:updateSkin()
			arg0:ResetL2dPanel()
		end
	end)
	onButton(arg0, arg0.live2dBtn, function()
		if arg0.showType == var0.SHOW_LIVE2D then
			arg0:clearSkin()

			arg0.showType = var0.SHOW_PAINT

			arg0:updateShowType()
			arg0:updateSkin()
		end
	end)
	onButton(arg0, arg0.spineBtn, function()
		if arg0.showType == var0.SHOW_SPINE then
			arg0:clearSkin()

			arg0.showType = var0.SHOW_PAINT

			arg0:updateShowType()
			arg0:updateSkin()
		end
	end)

	local var0 = function()
		if arg0.state == var0.STATE_TAKE_PHOTO then
			return
		end

		arg0.state = var0.STATE_TAKE_PHOTO

		LeanTween.moveY(rtf(arg0.modePnlTF), 56, 0.1)
		SetActive(arg0.videoTakeImg, false)
	end

	onButton(arg0, arg0.takePhotoBtn, var0)
	onButton(arg0, arg0.takeVideoBtn, function()
		if CheckPermissionGranted(ANDROID_RECORD_AUDIO_PERMISSION) and CheckPermissionGranted(ANDROID_WRITE_EXTERNAL_PERMISSION) then
			arg0:changeToTakeVideo()
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
	var0()
	onButton(arg0, arg0.stopRecBtn, function()
		local function var0(arg0)
			warning("结束录屏结果：" .. tostring(arg0))
		end

		if not LeanTween.isTweening(go(arg0.stopRecBtn)) then
			LeanTween.moveX(arg0.stopRecBtn, arg0.stopRecBtn.rect.width, 0.15):setOnComplete(System.Action(function()
				setActive(arg0.ui, true)
				setActive(arg0.stopRecBtn, false)
				arg0.ysScreenRecorder:StopRecord(var0)

				if PLATFORM == PLATFORM_ANDROID then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("word_save_video"),
						onNo = function()
							arg0.ysScreenRecorder:DiscardVideo()
						end,
						onYes = function()
							local var0 = arg0.ysScreenRecorder:GetVideoFilePath()

							warning("源录像路径：" .. tostring(var0))
							MediaSaver.SaveVideoWithPath(var0)
						end
					})
				end

				arg0:SetMute(false)
			end))
		end
	end)
	setActive(arg0.stopRecBtn, false)
	onButton(arg0, arg0.switchCamBtn, function()
		arg0.isFlipping = not arg0.isFlipping

		arg0.webcam:SwitchCam()
		arg0:updateCameraCanvas()
	end)
	onButton(arg0, arg0.selectCharBtn, function()
		arg0:emit(var0.SELECT_CHAR_PANEL)
	end)

	function arg0.webcam.takeCallback(arg0)
		setActive(arg0.ui, true)
	end

	onButton(arg0, arg0.l2dStopBtnGo, function()
		arg0.isPause = true

		arg0:UpdateL2dPlayState()
	end)
	onButton(arg0, arg0.l2dPlayBtnGo, function()
		arg0.isPause = false

		arg0:UpdateL2dPlayState()
	end)
	onButton(arg0, arg0.l2dAnimationBtnGo, function()
		arg0:setLive2dAnimsPanelState(true)
	end)
	onButton(arg0, arg0.l2dAnimationBackBtnTrans, function()
		arg0:setLive2dAnimsPanelState(false)
	end)
	cameraPaintViewAdjust(true)
	arg0:updateCameraCanvas()
	arg0:updateShowType()
end

function var0.changeToTakeVideo(arg0)
	if arg0.state == var0.STATE_TAKE_VIDEO then
		return
	end

	arg0.state = var0.STATE_TAKE_VIDEO

	LeanTween.moveY(rtf(arg0.modePnlTF), -56, 0.1)
	SetActive(arg0.videoTakeImg, true)
end

function var0.willExit(arg0)
	arg0:SetDummyForIOS(false)
	cameraPaintViewAdjust(false)
	arg0:clearSkin()

	local var0 = PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0

	setActive(pg.UIMgr.GetInstance().OverlayEffect, var0)
end

function var0.clearSkin(arg0)
	if arg0.paintSkin and arg0.showType == var0.SHOW_PAINT then
		retPaintingPrefab(arg0.paint, arg0.paintSkin)
	end

	if arg0.spineSkin and arg0.showType == var0.SHOW_SPINE then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.spineSkin, go(arg0:findTF("model", arg0.spine)))
	end

	if arg0.live2dCom then
		arg0.live2dCom.FinishAction = nil
		arg0.live2dCom.EventAction = nil
	end

	if arg0.live2dCom and arg0.showType == var0.SHOW_LIVE2D then
		Destroy(arg0.live2dCom.gameObject)

		arg0.live2dCom = nil
	end

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0.live2dRequestId)

	arg0.live2dRequestId = nil
end

function var0.checkSkin(arg0, arg1)
	local var0 = pg.ship_skin_template[arg1]

	assert(arg1 == -1 or var0, "invalid skin id " .. arg1)

	arg0.skin = var0

	local var1 = false

	if arg0.contextData.tbId then
		arg0.paintSkin = pg.secretary_special_ship[arg0.contextData.tbId].prefab or "tbniang"
		var1 = true
		arg0.contextData.tbId = nil
	elseif arg0.paintSkin ~= var0.painting or var0.spineSkin ~= var0.prefab then
		arg0:clearSkin()

		arg0.paintSkin = var0.painting
		arg0.spineSkin = var0.prefab
		arg0.l2dAnims = var0.l2d_animations

		if arg0.l2dAnims == "" then
			arg0.l2dAnims = {
				"idle"
			}
		end

		var1 = true
	end

	return var1
end

function var0.setSkinAndLive2d(arg0, arg1, arg2)
	local var0 = arg0:checkSkin(arg1)

	if arg0.showType ~= var0.SHOW_LIVE2D and arg2 then
		arg0.showType = var0.SHOW_LIVE2D

		arg0:updateShowType()

		var0 = true
	end

	if var0 then
		arg0:updateSkin()
	end
end

function var0.setSkin(arg0, arg1)
	if arg0:checkSkin(arg1) then
		arg0:updateSkin()
	end
end

function var0.setLive2d(arg0, arg1)
	if arg0.showType ~= var0.SHOW_LIVE2D and arg1 then
		arg0:clearSkin()

		arg0.showType = var0.SHOW_LIVE2D

		arg0:updateShowType()
		arg0:updateSkin()
	end
end

function var0.updateShowType(arg0)
	setActive(arg0.paintBtn, false)
	arg0:setLive2dAnimsPanelState(false)
	setActive(arg0.live2dBtn, false)
	setActive(arg0.l2dCtrlPanl, false)
	setActive(arg0.spineBtn, false)

	if arg0.showType == var0.SHOW_PAINT then
		setActive(arg0.paintBtn, true)
	elseif arg0.showType == var0.SHOW_LIVE2D then
		setActive(arg0.live2dBtn, true)
		SetActive(arg0.l2dCtrlPanl, true)
	elseif arg0.showType == var0.SHOW_SPINE then
		setActive(arg0.spineBtn, true)
	end
end

local function var1(arg0)
	if arg0 == var0.SHOW_PAINT then
		return 0.5, 2
	elseif arg0 == var0.SHOW_LIVE2D then
		return 0.5, 2
	elseif arg0 == var0.SHOW_SPINE then
		return 0.5, 4
	end
end

function var0.updateSkin(arg0)
	if arg0.showType == var0.SHOW_LIVE2D and (not ResourceMgr.Inst:AssetExist("live2d/" .. arg0.paintSkin) or not checkABExist("live2d/" .. arg0.paintSkin)) then
		arg0.showType = var0.SHOW_PAINT

		arg0:updateShowType()
	end

	local var0 = arg0.paint:GetComponent(typeof(Zoom))
	local var1 = 0
	local var2 = 0
	local var3, var4 = var1(arg0.showType)

	var0.minZoom, var0.maxZoom = var3, var4

	if var4 < arg0.paint.localScale.x then
		arg0.paint.localScale = Vector3(var4, var4, var4)
	elseif var3 > arg0.paint.localScale.x then
		arg0.paint.localScale = Vector3(var3, var3, var3)
	end

	if arg0.showType == var0.SHOW_LIVE2D then
		pg.UIMgr.GetInstance():LoadingOn()

		arg0.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg0.paintSkin, function(arg0)
			UIUtil.SetLayerRecursively(arg0, LayerMask.NameToLayer("UI"))

			local var0 = arg0.transform

			var0:SetParent(arg0.live2d, true)

			var0.localScale = Vector3(52, 52, 52)
			var0.localPosition = BuildVector3(arg0.skin.live2d_offset)

			local var1 = arg0:GetComponent(typeof(Live2dChar))
			local var2 = pg.AssistantInfo.action2Id.idle

			var1:SetAction(var2)

			function var1.FinishAction(arg0)
				if arg0.selectedID and arg0.selectedID ~= pg.AssistantInfo.action2Id.idle then
					arg0:setL2dAction(arg0.selectedID)
				end
			end

			arg0.live2dCom = var1
			arg0.live2dCom.name = arg0.paintSkin
			arg0.playActionId = pg.AssistantInfo.action2Id.idle
			arg0.selectedID = pg.AssistantInfo.action2Id.idle
			arg0.live2dAnimator = arg0:GetComponent(typeof(Animator))

			local var3 = arg0.live2dCom:GetCubismParameter("Paramring")

			if var3 then
				if arg0.contextData and arg0.contextData.propose then
					arg0.live2dCom:AddParameterValue(var3, 1, CubismParameterBlendMode.Override)
				else
					arg0.live2dCom:AddParameterValue(var3, 0, CubismParameterBlendMode.Override)
				end
			end

			arg0:ResetL2dPanel()
			arg0:setLive2dAnimsPanelState(true)
			SetActive(arg0.spine, false)
			SetActive(arg0.live2d, true)
			pg.UIMgr.GetInstance():LoadingOff()

			local var4 = arg0.skin.lip_sync_gain
			local var5 = arg0.skin.lip_smoothing

			if var4 and var4 ~= 0 then
				arg0.live2d:GetChild(0):GetComponent("CubismCriSrcMouthInput").Gain = var4
			end

			if var5 and var5 ~= 0 then
				arg0.live2d:GetChild(0):GetComponent("CubismCriSrcMouthInput").Smoothing = var5
			end
		end)
	elseif arg0.showType == var0.SHOW_PAINT then
		SetActive(arg0.live2d, false)
		SetActive(arg0.spine, false)
		setPaintingPrefabAsync(arg0.paint, arg0.paintSkin, "mainNormal")
	elseif arg0.showType == var0.SHOW_SPINE then
		SetActive(arg0.live2d, false)
		SetActive(arg0.spine, true)
		PoolMgr.GetInstance():GetSpineChar(arg0.spineSkin, true, function(arg0)
			arg0.name = "model"

			local var0 = arg0.transform

			var0:SetParent(arg0.spine, true)

			var0.localScale = Vector3(0.5, 0.5, 0.5)
			var0.localPosition = Vector3.zero

			arg0:playAction("normal")
		end)
	end
end

function var0.playAction(arg0, arg1)
	if arg0.showType ~= var0.SHOW_SPINE then
		return
	end

	GetOrAddComponent(arg0:findTF("model", arg0.spine), typeof(SpineAnimUI)):SetAction(arg1, 0)
end

function var0.ResetL2dPanel(arg0)
	arg0.selectedID = pg.AssistantInfo.action2Id.idle
	arg0.isPause = false

	arg0:UpdateL2dPlayState(true)
	arg0:updateSelectedItem()
end

function var0.UpdateL2dPlayState(arg0, arg1)
	if arg0.showType ~= var0.SHOW_LIVE2D then
		return
	end

	if arg0.isPause then
		SetActive(arg0.l2dStopBtnGo, false)
		SetActive(arg0.l2dPlayBtnGo, true)
	else
		SetActive(arg0.l2dStopBtnGo, true)
		SetActive(arg0.l2dPlayBtnGo, false)
	end

	if not arg1 then
		arg0:L2dAnimationState()
	end
end

function var0.L2dAnimationState(arg0)
	if arg0.showType ~= var0.SHOW_LIVE2D then
		return
	end

	if arg0.isPause then
		arg0.live2dAnimator.speed = 0
	else
		arg0.live2dAnimator.speed = 1
	end
end

function var0.updateLive2dAnimationPanel(arg0)
	SetActive(arg0.l2dAnimations, arg0.isShowL2dAnims)
	SetActive(arg0.l2dAnimationBtnGo, not arg0.isShowL2dAnims)

	if arg0.isShowL2dAnims and #arg0.l2dAnims > 1 then
		arg0.animContainer:SetTotalCount(#arg0.l2dAnims, 0)
	end
end

function var0.setLive2dAnimsPanelState(arg0, arg1)
	arg0.isShowL2dAnims = arg1

	arg0:updateLive2dAnimationPanel()
end

local var2 = 3

function var0.onInitItem(arg0, arg1)
	local var0 = SnapshotItem.New(arg1, false)

	onButton(arg0, var0.go, function()
		if arg0.l2dClickCD and Time.fixedTime - arg0.l2dClickCD < var2 then
			return
		end

		if arg0.selectedID == var0:GetID() then
			return
		end

		if var0:GetID() == 6 or var0:GetID() == 7 then
			arg0.l2dClickCD = Time.fixedTime
		end

		arg0.selectedID = var0:GetID()

		arg0:updateSelectedItem()
		arg0:setL2dAction(arg0.selectedID)
	end, SFX_CONFIRM)

	arg0.scrollItems[arg1] = var0
end

function var0.setL2dAction(arg0, arg1)
	if arg1 ~= pg.AssistantInfo.action2Id.idle then
		-- block empty
	end

	if arg0.live2dCom and arg1 then
		if arg1 == pg.AssistantInfo.action2Id.idle then
			arg0.live2dCom:SetAction(arg1)
		elseif arg0.playActionId == pg.AssistantInfo.action2Id.idle then
			arg0.live2dCom:SetAction(arg1)
		elseif arg0.playActionId == arg1 then
			arg0.live2dCom:SetAction(arg1)
		end

		arg0.playActionId = arg1
	end
end

function var0.onUpdateItem(arg0, arg1, arg2)
	arg1 = arg1 + 1

	local var0 = arg0.scrollItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.scrollItems[arg2]
	end

	local var1 = arg0.l2dAnims[arg1]
	local var2 = pg.AssistantInfo.action2Id[var1]
	local var3 = {
		id = var2,
		name = i18n(var1)
	}

	var0:Update(var3)

	if arg0.isVertical then
		var0:SetEulerAngle(arg0.verticalEulerAngle)
	else
		var0:SetEulerAngle(arg0.horizontalEulerAngle)
	end

	if var0:GetID() == arg0.selectedID then
		var0:UpdateSelected(true)
	else
		var0:UpdateSelected(false)
	end
end

function var0.onReturnItem(arg0, arg1, arg2)
	return
end

function var0.updateSelectedItem(arg0)
	for iter0, iter1 in pairs(arg0.scrollItems) do
		if iter1:HasInfo() then
			if iter1:GetID() == arg0.selectedID then
				iter1:UpdateSelected(true)
			else
				iter1:UpdateSelected(false)
			end
		end
	end
end

function var0.updateUIDirection(arg0)
	if arg0.isVertical then
		local var0 = arg0.verticalEulerAngle
		local var1 = arg0.rotateUseTime

		LeanTween.rotateZ(go(arg0.backBtnImg), var0, var1)
		LeanTween.rotateZ(go(arg0.selectCharBtnImg), var0, var1)
		LeanTween.rotateZ(go(arg0.switchCamBtnImg), var0, var1)
		LeanTween.rotateZ(go(arg0.l2dBtnImg), var0, var1)
		LeanTween.rotateZ(go(arg0.l2dStopBtnImg), var0, var1)
		LeanTween.rotateZ(go(arg0.l2dPlayBtnImg), var0, var1)
		LeanTween.rotateZ(go(arg0.l2d2PaintBtnImg), var0, var1)
		SetActive(arg0.takePhotoVerticalText, false)
		SetActive(arg0.takePhotoHorizontalText, true)
		SetActive(arg0.takeVideoVerticalText, false)
		SetActive(arg0.takeVideoHorizontalText, true)
		LeanTween.rotateZ(go(arg0.paint), var0, var1)
		arg0:updateListItemRotate(var0, var1)
	else
		local var2 = arg0.horizontalEulerAngle
		local var3 = arg0.rotateUseTime

		LeanTween.rotateZ(go(arg0.backBtnImg), var2, var3)
		LeanTween.rotateZ(go(arg0.selectCharBtnImg), var2, var3)
		LeanTween.rotateZ(go(arg0.switchCamBtnImg), var2, var3)
		LeanTween.rotateZ(go(arg0.l2dBtnImg), var2, var3)
		LeanTween.rotateZ(go(arg0.l2dStopBtnImg), var2, var3)
		LeanTween.rotateZ(go(arg0.l2dPlayBtnImg), var2, var3)
		LeanTween.rotateZ(go(arg0.l2d2PaintBtnImg), var2, var3)
		SetActive(arg0.takePhotoVerticalText, true)
		SetActive(arg0.takePhotoHorizontalText, false)
		SetActive(arg0.takeVideoVerticalText, true)
		SetActive(arg0.takeVideoHorizontalText, false)
		LeanTween.rotateZ(go(arg0.paint), var2, var3)
		arg0:updateListItemRotate(var2, var3)
	end
end

function var0.updateListItemRotate(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg0.scrollItems) do
		iter1:RotateUI(arg1, arg2)
	end
end

function var0.updateCameraCanvas(arg0)
	local var0 = CameraMgr.instance.AspectRatio
	local var1 = UnityEngine.Screen.width
	local var2 = UnityEngine.Screen.height
	local var3 = 1
	local var4 = var1 / var2

	if var4 < var0 then
		var3 = var0 / var4
	elseif var0 < var4 then
		var3 = var4 / var0
	end

	if arg0.isFlipping then
		arg0.snapshot.localScale = Vector3(-var3, var3, 1)
	else
		arg0.snapshot.localScale = Vector3(var3, var3, 1)
	end
end

function var0.SetDummyForIOS(arg0, arg1)
	if PLATFORM ~= PLATFORM_IPHONEPLAYER then
		setActive(arg0.dummy, false)

		return
	end

	local var0 = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))

	if arg1 then
		var0.nearClipPlane = 0

		arg0.dummy:SetParent(pg.UIMgr.GetInstance():GetMainCamera().transform)

		arg0.dummy.localPosition = Vector3(0, 0, 3)
		arg0.dummy.localRotation = Vector3(0, 0, 0)
		arg0.dummy.localScale = Vector3(1, 1, 1)

		setActive(arg0.dummy, true)
	else
		var0.nearClipPlane = -100

		arg0.dummy:SetParent(arg0._tf)

		arg0.dummy.localPosition = Vector3(0, 0, 0)
		arg0.dummy.localRotation = Vector3(0, 0, 0)
		arg0.dummy.localScale = Vector3(1, 1, 1)
	end
end

function var0.SetMute(arg0, arg1)
	if arg1 then
		CriAtom.SetCategoryVolume("Category_CV", 0)
		CriAtom.SetCategoryVolume("Category_BGM", 0)
		CriAtom.SetCategoryVolume("Category_SE", 0)
	else
		CriAtom.SetCategoryVolume("Category_CV", pg.CriMgr.GetInstance():getCVVolume())
		CriAtom.SetCategoryVolume("Category_BGM", pg.CriMgr.GetInstance():getBGMVolume())
		CriAtom.SetCategoryVolume("Category_SE", pg.CriMgr.GetInstance():getSEVolume())
	end
end

return var0
