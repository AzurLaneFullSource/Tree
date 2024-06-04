local var0 = class("ProposeUI", import("..base.BaseUI"))
local var1 = {
	1,
	2,
	3,
	4,
	4,
	5,
	5,
	7,
	7,
	7,
	7,
	6,
	7
}

var0.nationSpriteIndex = {
	cn = 5,
	de = 4,
	cm = 0,
	jp = 3,
	np = 9,
	sn = 6,
	en = 2,
	um = 11,
	mnf = 8,
	bili = 10,
	ff = 7,
	us = 1
}

function var0.getUIName(arg0)
	return "ProposeUI"
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1
	arg0.proposeType = arg0.shipVO:getProposeType()

	arg0:setShipGroupID(arg0.shipVO:getGroupId())
end

function var0.setShipGroupID(arg0, arg1)
	arg0.shipGroupID = arg1
end

function var0.setWeddingReviewSkinID(arg0, arg1)
	arg0.reviewSkinID = arg1
end

function var0.setBagProxy(arg0, arg1)
	arg0.bagProxy = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0.storybg = arg0:findTF("close/bg")
	arg0.bgAdd = arg0:findTF("add")

	setActive(arg0.storybg, false)
	setActive(arg0.bgAdd, false)

	arg0.targetActorTF = arg0:findTF("actor_middle")
	arg0.maskTF = arg0:findTF("mask")
	arg0.skipBtn = arg0:findTF("skip_button")
	arg0.actorPainting = nil
	arg0.materialFace = arg0._tf:Find("Resource/face"):GetComponent(typeof(Image)).material
	arg0.materialPaint = arg0._tf:Find("Resource/paint"):GetComponent(typeof(Image)).material
	arg0.finishCallback = arg0.contextData.finishCallback
	arg0.commonTF = GameObject.Find("OverlayCamera/Overlay/UIMain/common")
	arg0.exchangePanel = arg0._tf:Find("exchange_panel")

	local var0 = arg0.exchangePanel:Find("window/msg_panel/content")

	setText(var0:Find("text"), i18n("word_propose_cost_tip2"))

	local var1 = pg.gameset.vow_prop_conversion.description

	for iter0, iter1 in ipairs(var1) do
		local var2 = Drop.New({
			count = 1,
			type = DROP_TYPE_ITEM,
			id = iter1
		})

		updateDrop(var0:Find("icon_" .. iter0), var2)
		onButton(arg0, var0:Find("icon_" .. iter0), function()
			arg0:emit(BaseUI.ON_DROP, var2)
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.exchangePanel:Find("bg"), function()
		arg0:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.exchangePanel:Find("window/top/btnBack"), function()
		arg0:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.exchangePanel:Find("window/button_container/cancel"), function()
		arg0:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.exchangePanel:Find("window/button_container/confirm"), function()
		if getProxy(BagProxy):getItemCountById(ITEM_ID_FOR_PROPOSE) > 0 then
			arg0:emit(ProposeMediator.EXCHANGE_TIARA)
		else
			ItemTipPanel.ShowRingBuyTip()
		end

		arg0:hideExchangePanel()
	end, SFX_CONFIRM)

	arg0.tweenList = {}
end

function var0.didEnter(arg0)
	arg0:emit(ProposeMediator.HIDE_SHIP_MAIN_WORD)

	if arg0.commonTF then
		setActive(arg0.commonTF, false)
	end

	if arg0.contextData.review then
		arg0.weddingReview = true
		arg0.proposeType = arg0.contextData.group:getProposeType()

		local var0 = arg0.contextData.group:getNation()

		arg0.bgName = Nation.Nation2BG(var0) or Nation.Nation2BG(0)

		onButton(arg0, arg0.skipBtn, function()
			arg0:closeView()
		end, SFX_CANCEL)
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
		arg0:doPlay()
	else
		arg0:doMain()
	end
end

function var0.doPlay(arg0)
	setActive(arg0.skipBtn, arg0.weddingReview)
	arg0:setMask(true)
	pg.BgmMgr.GetInstance():TempPlay("wedding")
	arg0:showProposePanel()
end

function var0.doMain(arg0)
	onButton(arg0, arg0.skipBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("close0"), function()
		if arg0.proposeEndFlag then
			arg0:DisplayRenamePanel()
		else
			arg0:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("close_end"), function()
		if arg0.proposeEndFlag then
			arg0:DisplayRenamePanel()
		else
			arg0:closeView()
		end
	end, SFX_CANCEL)

	local var0 = arg0.shipVO:getConfigTable().nationality
	local var1 = "Propose" .. Nation.Nation2Side(var0) .. "UI"

	arg0.bgName = Nation.Nation2BG(var0) or Nation.Nation2BG(0)

	PoolMgr.GetInstance():GetUI(var1, true, function(arg0)
		if arg0.exited then
			PoolMgr.GetInstance():ReturnUI(var1, arg0)

			return
		end

		arg0.window = tf(arg0)

		setParent(tf(arg0), arg0:findTF("window"))

		arg0.intimacyTF = arg0:findTF("intimacy/icon", arg0.window)
		arg0.intimacyValueTF = arg0:findTF("intimacy/value", arg0.window)
		arg0.button = arg0:findTF("button", arg0.window)
		arg0.intimacyDesc = arg0:findTF("desc", arg0.window)
		arg0.intimacydescTime = arg0:findTF("descPic/desc_time", arg0.window)
		arg0.intimacyDescPic = arg0:findTF("descPic", arg0.window)
		arg0.intimacyBuffDesc = arg0:findTF("desc_buff", arg0.window)
		arg0._paintingTF = arg0:findTF("paintMask/paint", arg0.window)
		arg0.intimacyAchieved = arg0:findTF("intimacy/achieved", arg0.window)
		arg0.intimacyNoAchieved = arg0:findTF("intimacy/no_achieved", arg0.window)
		arg0.ringAchieved = arg0:findTF("ringCount/achieved", arg0.window)
		arg0.ringNoAchieved = arg0:findTF("ringCount/no_achieved", arg0.window)
		arg0.ringValue = arg0:findTF("ringCount/value", arg0.window)
		arg0.nameTF = arg0:findTF("title1/Text", arg0.window)
		arg0.shipNameTF = arg0:findTF("title2/Text", arg0.window)
		arg0.campTF = arg0:findTF("Camp", arg0.window)
		arg0.doneTF = arg0:findTF("done", arg0.window)
		arg0.CampSprite = arg0:findTF("CampSprite", arg0.window)

		setActive(arg0.window, true)
		setText(arg0.nameTF, arg0.player.name)
		setText(arg0.shipNameTF, arg0.shipVO:getName())

		if arg0.CampSprite then
			local var0 = getImageSprite(arg0:findTF(Nation.Nation2Print(var0), arg0.CampSprite))

			if not var0 then
				warning("找不到印花, shipConfigId: " .. arg0.shipVO.configId)
				setActive(arg0.campTF, false)
			else
				setImageSprite(arg0.campTF, var0, false)
				setActive(arg0.campTF, true)
			end
		end

		setIntimacyIcon(arg0.intimacyTF, arg0.shipVO:getIntimacyIcon())

		local var1, var2 = arg0.shipVO:getIntimacyDetail()

		setText(arg0.intimacyValueTF, i18n("propose_intimacy_tip", var2))

		if var2 >= 100 then
			setTextColor(arg0.intimacyValueTF, Color.white)
		else
			setTextColor(arg0.intimacyValueTF, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
		end

		setActive(arg0.intimacyAchieved, arg0.shipVO.propose or var2 >= 100)
		setActive(arg0.intimacyNoAchieved, var2 < 100 and not arg0.shipVO.propose)
		arg0:onUpdateItemCount()
		setActive(arg0.doneTF, arg0.shipVO.propose)

		local var3, var4 = arg0.shipVO:getIntimacyInfo()

		if arg0.shipVO.propose then
			if arg0.intimacyDescPic then
				setActive(arg0.intimacyDescPic, true)
				arg0:onUpdateIntimacydescTime(arg0.shipVO.proposeTime)
			end

			if arg0.intimacyDesc then
				setActive(arg0.intimacyDesc, not arg0.intimacyDescPic)

				local var5 = arg0:getProposeText()

				setText(arg0.intimacyDesc, var5)
			end
		else
			if arg0.intimacyDesc and GetComponent(arg0.intimacyDesc, "VerticalText") then
				GetComponent(arg0.intimacyDesc, "VerticalText").enabled = false
			end

			if arg0.intimacyDescPic then
				setActive(arg0.intimacyDescPic, false)
			end

			if arg0.intimacyDesc then
				setActive(arg0.intimacyDesc, true)
				setText(arg0.intimacyDesc, i18n(var4, arg0.shipVO.name))
			end
		end

		setText(arg0.intimacyBuffDesc, "*" .. i18n(var4 .. "_buff"))
		arg0:loadChar()
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setActive(arg0.button, not arg0.shipVO:ShowPropose())

		local var6 = not arg0.shipVO.propose and var1 <= var2
		local var7 = arg0.shipVO.propose and not arg0.shipVO:ShowPropose()

		arg0.button:GetComponent(typeof(Button)).interactable = var6 or var7

		onButton(arg0, arg0.button, function()
			if var6 then
				local var0 = arg0.bagProxy:getItemCountById(arg0:getProposeItemId())

				if var0 < 1 then
					if arg0.proposeType == "imas" then
						arg0:showExchangePanel()
					else
						ItemTipPanel.ShowRingBuyTip()
					end

					return
				end

				local var1, var2 = ShipStatus.ShipStatusCheck("onPropose", arg0.shipVO)

				if not var1 then
					pg.TipsMgr.GetInstance():ShowTips(var2)

					return
				end

				arg0:checkPaintingRes(arg0.shipVO, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("word_propose_cost_tip" .. (arg0.proposeType == "imas" and "1" or ""), var0),
						onYes = function()
							if arg0.intimacydescTime then
								arg0:onUpdateIntimacydescTime(pg.TimeMgr.GetInstance():GetServerTime())
							end

							arg0:hideWindow()
							setActive(arg0.window, false)
							arg0:doPlay()
						end
					})
				end)
			elseif var7 then
				function arg0.afterRegisterCall()
					arg0.afterRegisterCall = nil

					pg.TipsMgr.GetInstance():ShowTips(i18n("word_propose_switch_tip"))
					arg0:closeView()
				end

				arg0:emit(ProposeMediator.REGISTER_SHIP, arg0.shipVO.id)
			else
				arg0:closeView()
			end
		end, SFX_PANEL)
	end)
end

function var0.getProposeText(arg0)
	local var0 = ""

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		var0 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():ChieseDescTime(arg0.shipVO.proposeTime, true))

		if not IsNil(GetComponent(arg0.intimacyDesc, "VerticalText")) then
			GetComponent(arg0.intimacyDesc, "VerticalText").enabled = true
			var0 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():ChieseDescTime(arg0.shipVO.proposeTime, true))
		end
	elseif PLATFORM_CODE == PLATFORM_KR then
		var0 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0.shipVO.proposeTime, "%Y년%m월%d일", true))

		if not IsNil(GetComponent(arg0.intimacyDesc, "VerticalText")) then
			GetComponent(arg0.intimacyDesc, "VerticalText").enabled = true
			var0 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0.shipVO.proposeTime, "%Y년%m월%d일"))
		end
	else
		var0 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0.shipVO.proposeTime, "%Y/%m/%d", true))

		if not IsNil(GetComponent(arg0.intimacyDesc, "VerticalText")) then
			GetComponent(arg0.intimacyDesc, "VerticalText").enabled = true
			var0 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0.shipVO.proposeTime, "%Y/%m/%d"))
		end
	end

	return var0
end

function var0.getProposeItemId(arg0)
	if arg0.proposeType == "imas" then
		return ITEM_ID_FOR_PROPOSE_IMAS
	else
		return ITEM_ID_FOR_PROPOSE
	end
end

function var0.onUpdateItemCount(arg0)
	local var0 = arg0.bagProxy:getItemCountById(arg0:getProposeItemId())

	setActive(arg0.ringAchieved, arg0.shipVO.propose or var0 > 0)
	setActive(arg0.ringNoAchieved, var0 <= 0 and not arg0.shipVO.propose)
	setText(arg0.ringValue, i18n(arg0.proposeType == "imas" and "intimacy_desc_tiara" or "intimacy_desc_ring"))

	if arg0.shipVO.propose or var0 > 0 then
		setTextColor(arg0.ringValue, Color.white)
	else
		setTextColor(arg0.ringValue, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
	end

	if arg0.proposeType == "imas" then
		local var1 = not arg0.shipVO.propose and var0 == 0

		setActive(arg0.window:Find("ringCount/bg_exchange"), var1)
		setActive(arg0.window:Find("ringCount/icon/btn_exchange"), var1)
		onButton(arg0, arg0.window:Find("ringCount/icon/btn_exchange"), function()
			arg0:showExchangePanel()
		end, SFX_PANEL)
	else
		setActive(arg0.window:Find("ringCount/icon/base"), PLATFORM_CODE ~= PLATFORM_CH)
		setActive(arg0.window:Find("ringCount/icon/hx"), PLATFORM_CODE == PLATFORM_CH)
	end
end

function var0.onUpdateIntimacydescTime(arg0, arg1)
	local var0

	if PLATFORM_CODE == PLATFORM_JP then
		if arg0.proposeType == "imas" then
			var0 = "%Y.%m.%d"
		else
			var0 = "%B.%d,    %y"
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		var0 = "%B %d, %Y"
	elseif arg0.proposeType == "imas" then
		var0 = i18n("intimacy_desc_day") .. " %Y.%m.%d"
	else
		var0 = "%B.%d,    %y"
	end

	setText(arg0.intimacydescTime, pg.TimeMgr.GetInstance():STimeDescS(arg1, var0))
end

function var0.onBackPressed(arg0)
	if isActive(arg0.exchangePanel) then
		arg0:hideExchangePanel()

		return
	end

	if arg0.window and isActive(arg0.window) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0:findTF("close_end"))
	end
end

function var0.willExit(arg0)
	if arg0._currentVoice then
		arg0._currentVoice:PlaybackStop()
	end

	arg0._currentVoice = nil

	pg.BgmMgr.GetInstance():ContinuePlay()

	if not IsNil(arg0.actorPainting) then
		local var0 = tf(arg0.actorPainting)

		if var0:Find("temp_mask") then
			Destroy(var0:Find("temp_mask"))
		end

		var0:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0.paintingName, arg0.actorPainting)

		arg0.actorPainting = nil
	end

	if arg0.delayTId then
		LeanTween.cancel(arg0.delayTId)
	end

	if arg0.commonTF then
		setActive(arg0.commonTF, true)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.l2dChar then
		arg0.l2dChar:ClearPics()

		arg0.l2dChar = nil
	end

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0.live2dRequestId)

	arg0.live2dRequestId = nil

	if arg0._delayVoiceTweenID then
		LeanTween.cancel(arg0._delayVoiceTweenID)

		arg0._delayVoiceTweenID = nil
	end

	if arg0.tweenList then
		cancelTweens(arg0.tweenList)

		arg0.tweenList = nil
	end

	if arg0.contextData.callback then
		arg0.contextData.callback()
	end

	if arg0.finishCallback then
		arg0.finishCallback()

		arg0.finishCallback = nil
	end
end

function var0.setMask(arg0, arg1)
	setActive(arg0.maskTF, arg1)
end

function var0.bgAddAnimation(arg0, arg1)
	setActive(arg0.storybg, true)
	arg0:showbgAdd(true, arg1)
end

function var0.showbgChurch(arg0)
	table.insert(arg0.tweenList, LeanTween.scale(arg0.storybg, Vector3(1, 1, 1), 6).uniqueId)
	setActive(arg0.churchLight, true)
	table.insert(arg0.tweenList, LeanTween.delayedCall(6, System.Action(function()
		setActive(arg0.churchLight, false)
	end)).uniqueId)
end

function var0.showbgAdd(arg0, arg1, arg2)
	local var0 = arg1 and 1 or 0
	local var1 = arg1 and 0 or 1
	local var2 = GetOrAddComponent(arg0.bgAdd, typeof(CanvasGroup))

	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var2, var1, arg2):setFrom(var0).uniqueId)
	setActive(arg0.bgAdd, true)
end

function var0.showBlackBG(arg0, arg1, arg2, arg3)
	local var0 = arg1 and 1 or 0
	local var1 = arg1 and 0 or 1
	local var2 = GetOrAddComponent(arg0.blackBG, typeof(CanvasGroup))

	setActive(arg0.blackBG, true)
	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var2, var1, arg2):setFrom(var0):setOnComplete(System.Action(function()
		if arg1 then
			setActive(arg0.blackBG, false)
		end

		if arg3 then
			arg3()
		end
	end)).uniqueId)
end

function var0.showPainting(arg0, arg1, arg2, arg3)
	local var0 = {}

	if arg1 then
		table.insert(var0, function(arg0)
			arg0:loadChar(arg0.targetActorTF, "duihua", arg0)
		end)
	end

	seriesAsync(var0, function()
		local var0 = arg1 and 0 or 1
		local var1 = arg1 and 1 or 0
		local var2 = GetOrAddComponent(arg0.targetActorTF, typeof(CanvasGroup))

		table.insert(arg0.tweenList, LeanTween.alphaCanvas(var2, var1, arg2):setFrom(var0):setOnComplete(System.Action(function()
			if arg3 then
				arg3()
			end
		end)).uniqueId)
	end)
end

var0.Live2DProposeDelayTime = 2

function var0.showLive2D(arg0, arg1)
	setActive(arg0:findTF("fitter", arg0.targetActorTF), false)
	setActive(arg0:findTF("live2d", arg0.targetActorTF), true)

	local var0 = GetOrAddComponent(arg0.targetActorTF, typeof(CanvasGroup))

	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var0, 1, var0.Live2DProposeDelayTime):setFrom(0):setOnComplete(System.Action(function()
		arg0:changeParamaterValue("Paramring", 1)
		arg0.l2dChar:SetAction(pg.AssistantInfo.action2Id[arg1])
	end)).uniqueId)
end

function var0.changeParamaterValue(arg0, arg1, arg2)
	if not arg1 or string.len(arg1) == 0 then
		return
	end

	local var0 = arg0.l2dChar:GetCubismParameter(arg1)

	if not var0 then
		return
	end

	arg0.l2dChar:AddParameterValue(var0, arg2, CubismParameterBlendMode.Override)
end

function var0.hideWindow(arg0)
	local var0 = GetOrAddComponent(arg0.window, typeof(CanvasGroup))

	var0.interactable = false

	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var0, 0, 0.2):setFrom(1):setOnComplete(System.Action(function()
		var0.interactable = true
	end)).uniqueId)
end

function var0.stampWindow(arg0)
	arg0.proposeEndFlag = true

	arg0:loadChar(nil, nil, function()
		return
	end)
	setActive(arg0.window, true)
	setActive(arg0.button, false)
	setActive(arg0:findTF("live2d", arg0.targetActorTF), false)

	local var0

	if arg0.intimacyDescPic then
		setActive(arg0.intimacyDescPic, true)

		var0 = GetOrAddComponent(arg0.intimacyDescPic, typeof(CanvasGroup))
	end

	if arg0.intimacyDesc then
		setActive(arg0.intimacyDesc, not arg0.intimacyDescPic)

		local var1 = arg0:getProposeText()

		setText(arg0.intimacyDesc, var1)

		var0 = GetOrAddComponent(arg0.intimacyDesc, typeof(CanvasGroup))
	end

	setText(arg0.intimacyBuffDesc, "")
	setActive(arg0.doneTF, false)

	var0.alpha = 0

	local var2 = GetOrAddComponent(arg0.window, typeof(CanvasGroup))

	var2.interactable = false

	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var2, 1, 0.8):setFrom(0).uniqueId)
	table.insert(arg0.tweenList, LeanTween.delayedCall(1.5, System.Action(function()
		table.insert(arg0.tweenList, LeanTween.alphaCanvas(var0, 1, 2):setFrom(0).uniqueId)
	end)).uniqueId)

	arg0.delayTId = LeanTween.delayedCall(5, System.Action(function()
		if not var2 then
			return
		end

		var2.interactable = true

		setActive(arg0.doneTF, true)
		arg0:setMask(false)
		setActive(arg0:findTF("close_end"), true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_SEAL)
	end)).id
end

function var0.showProposePanel(arg0)
	local var0 = {}

	arg0.proposeSkin = ShipGroup.getProposeSkin(arg0.shipGroupID)

	if arg0.proposeSkin and arg0.actorPainting then
		local var1 = tf(arg0.actorPainting)

		if var1:Find("temp_mask") then
			Destroy(var1:Find("temp_mask"))
		end

		var1:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0.paintingName, arg0.actorPainting)

		arg0.actorPainting = nil
	end

	if not arg0.proposePanel then
		table.insert(var0, function(arg0)
			local var0 = "ProposeRingUI"

			PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
				if arg0.exited then
					PoolMgr.GetInstance():ReturnUI(var0, arg0)

					return
				end

				arg0.proposePanel = tf(arg0)

				setParent(tf(arg0), arg0:findTF("contain"))
				eachChild(arg0.proposePanel:Find("ringBox"), function(arg0)
					setActive(arg0, arg0.name == arg0.proposeType)

					if arg0.name == arg0.proposeType then
						arg0.ringBoxTF = arg0
					end
				end)

				arg0.ringBoxCG = GetOrAddComponent(arg0.ringBoxTF, typeof(CanvasGroup))
				arg0.ringBoxFull = arg0:findTF("full", arg0.ringBoxTF)
				arg0.churchBefore = arg0:findTF("before", arg0.proposePanel)
				arg0.churchLight = arg0:findTF("light", arg0.churchBefore)

				setParent(arg0.churchLight, arg0._tf)
				arg0.churchLight:SetSiblingIndex(2)

				arg0.blackBG = arg0:findTF("blackbg", arg0.churchBefore)
				arg0.doorLightBG = arg0:findTF("door_light", arg0.churchBefore)
				arg0.door = arg0:findTF("door", arg0.churchBefore)
				arg0.doorAni = GetOrAddComponent(arg0.door, "SpineAnimUI")

				setParent(arg0.churchBefore, arg0:findTF("contain"))

				arg0.ringTipTF = arg0:findTF("tip", arg0.proposePanel)
				arg0.ringTipCG = GetOrAddComponent(arg0.ringTipTF, typeof(CanvasGroup))

				setText(arg0:findTF("Text", arg0.ringTipTF), i18n(arg0.proposeType == "imas" and "word_propose_tiara_tip" or "word_propose_ring_tip"))
				setActive(arg0:findTF("finger", arg0.ringTipTF), false)
				LoadImageSpriteAsync(arg0.bgName, arg0.storybg)

				arg0.storybg.localScale = Vector3(1.2, 1.2, 1.2)

				local var0 = arg0.weddingReview and arg0.reviewSkinID or arg0.shipVO.skinId

				arg0.handId = pg.ship_skin_template[var0].hand_id

				local var1 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y%m%d", true)

				if SPECIAL_PROPOSE and SPECIAL_PROPOSE[1] == var1 then
					for iter0, iter1 in ipairs(SPECIAL_PROPOSE[2]) do
						if iter1[1] == var0 then
							arg0.handId = iter1[2]
						end
					end
				end

				local var2 = ({
					default = "",
					meta = "Meta_",
					imas = "Imas_"
				})[arg0.proposeType] .. "ProposeHand_" .. arg0.handId

				arg0.handName = var2

				PoolMgr.GetInstance():GetUI(var2, true, function(arg0)
					if arg0.exited then
						PoolMgr.GetInstance():ReturnUI(var2, arg0)

						return
					end

					arg0.transHand = tf(arg0)

					setActive(arg0.transHand, false)
					setParent(arg0.transHand, arg0.proposePanel)
					arg0.transHand:SetAsFirstSibling()

					arg0.handTF = arg0:findTF("hand", arg0.transHand)
					arg0.ringTF = arg0:findTF("ring", arg0.transHand)
					arg0.ringCG = GetOrAddComponent(arg0.ringTF, typeof(CanvasGroup))
					arg0.ringAnim = arg0.ringTF:GetComponent(typeof(Animator))
					arg0.ringAnim.enabled = false
					arg0.ringLight = arg0:findTF("ring_light", arg0.ringTF)
					arg0.ringLightCG = GetOrAddComponent(arg0.ringLight, typeof(CanvasGroup))

					arg0()
				end)
			end)
		end)
	end

	table.insert(var0, function(arg0)
		table.insert(arg0.tweenList, LeanTween.scale(arg0.door, Vector3(2.1, 2.1, 2.1), 4).uniqueId)
		arg0.doorAni:SetActionCallBack(function(arg0)
			if arg0 == "FINISH" then
				arg0.doorAni:SetActionCallBack(nil)
				setActive(arg0.door, false)
				arg0:showBlackBG(true, 0.1)
				setActive(arg0.doorLightBG, false)
				arg0()
			end
		end)
		table.insert(arg0.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0:showbgAdd(false, 2)
		end)).uniqueId)
		table.insert(arg0.tweenList, LeanTween.alpha(rtf(arg0.doorLightBG), 1, 2):setFrom(0).uniqueId)
		arg0:showBlackBG(false, 0.1)
		arg0.doorAni:SetAction("OPEN", 0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOOR)
	end)
	table.insert(var0, function(arg0)
		arg0.handTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 0)

		arg0:bgAddAnimation(2)
		table.insert(arg0.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0:showPainting(true, 1.5, function()
				table.insert(arg0.tweenList, LeanTween.delayedCall(1.5, System.Action(arg0)).uniqueId)
			end)
		end)).uniqueId)
	end)
	table.insert(var0, function(arg0)
		arg0:showBlackBG(false, 1.2, function()
			arg0:showBlackBG(true, 1.2)
		end)
		arg0:showPainting(false, 1, arg0)
	end)
	table.insert(var0, function(arg0)
		setAnchoredPosition(arg0.handTF, {
			y = arg0.handTF.rect.height
		})
		setAnchoredPosition(arg0.ringTF, {
			y = 0
		})
		setActive(arg0.proposePanel, true)
		setActive(arg0.transHand, true)

		arg0.ringBoxCG.alpha = 0
		arg0.ringCG.alpha = 0

		arg0()
	end)

	if arg0.proposeType ~= "imas" then
		table.insert(var0, function(arg0)
			table.insert(arg0.tweenList, LeanTween.alpha(rtf(arg0.handTF), 1, 1.2).uniqueId)
			table.insert(arg0.tweenList, LeanTween.moveY(rtf(arg0.handTF), 0, 2):setOnComplete(System.Action(function()
				table.insert(arg0.tweenList, LeanTween.alphaCanvas(arg0.ringBoxCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(arg0)).uniqueId)
			end)).uniqueId)
		end)
		table.insert(var0, function(arg0)
			table.insert(arg0.tweenList, LeanTween.alpha(rtf(arg0.ringBoxFull), 0, 0.6):setOnComplete(System.Action(arg0)).uniqueId)
			table.insert(arg0.tweenList, LeanTween.alphaCanvas(arg0.ringCG, 1, 0.6).uniqueId)
		end)
	end

	table.insert(var0, function(arg0)
		arg0.ringCG.alpha = 1

		arg0:setMask(false)
		table.insert(arg0.tweenList, LeanTween.delayedCall(0.1, System.Action(arg0)).uniqueId)
	end)
	table.insert(var0, function(arg0)
		arg0.ringAnim.enabled = true

		arg0.ringAnim:Play("movein")

		local var0 = arg0.proposeType == "imas" and 1 or 0.5

		table.insert(arg0.tweenList, LeanTween.delayedCall(var0, System.Action(arg0)).uniqueId)
	end)
	seriesAsync(var0, function()
		arg0.ringAnim:Play("blink")
		table.insert(arg0.tweenList, LeanTween.alphaCanvas(arg0.ringTipCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(function()
			setActive(arg0:findTF("finger", arg0.ringTipTF), true)
			arg0:enableRingDrag(true)
		end)).uniqueId)
	end)
end

function var0.ringOn(arg0)
	if arg0.isRingOn then
		return
	end

	setActive(arg0.ringTipTF, false)

	arg0.isRingOn = true

	arg0.ringTF:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		arg0.ringAnim.enabled = false
		arg0.isRingOn = false

		if not arg0.weddingReview then
			arg0:emit(ProposeMediator.ON_PROPOSE, arg0.shipVO.id)
		else
			arg0:RingFadeout()
		end
	end)

	arg0.ringAnim.enabled = true

	arg0.ringAnim:Play("wear")

	if arg0.handId == "101" then
		local var0 = GetOrAddComponent(arg0.handTF, typeof(CanvasGroup))

		table.insert(arg0.tweenList, LeanTween.alphaCanvas(var0, 0, 2).uniqueId)
	end
end

function var0.enableRingDrag(arg0, arg1)
	if not arg0.press then
		arg0:addRingDragListenter()
	end

	arg0.press.enabled = arg1
end

function var0.addRingDragListenter(arg0)
	arg0.press = GetOrAddComponent(arg0.proposePanel, "EventTriggerListener")

	local var0

	arg0.press:AddBeginDragFunc(function()
		return
	end)
	arg0.press:AddDragFunc(function(arg0, arg1)
		local var0 = arg1.position

		if not var0 then
			var0 = var0
		end

		if var0.y - var0.y > 100 then
			arg0:setMask(true)
			arg0:ringOn()
			arg0:enableRingDrag(false)
		end
	end)
	arg0.press:AddDragEndFunc(function(arg0, arg1)
		return
	end)
end

function var0.RingFadeout(arg0)
	local var0 = {}

	if arg0.proposeType == "imas" then
		table.insert(var0, function(arg0)
			local var0 = arg0.ringLight:GetChild(0)

			setActive(var0, true)
			table.insert(arg0.tweenList, LeanTween.delayedCall(3.5, System.Action(function()
				setActive(var0, false)
				arg0()
			end)).uniqueId)
		end)
	else
		table.insert(var0, function(arg0)
			table.insert(arg0.tweenList, LeanTween.alphaCanvas(arg0.ringLightCG, 0.7, 0.5):setFrom(0).uniqueId)
			table.insert(arg0.tweenList, LeanTween.scale(arg0.ringLight, Vector3(8, 8, 8), 1).uniqueId)
			table.insert(arg0.tweenList, LeanTween.rotate(arg0.ringLight, 90, 3):setOnComplete(System.Action(arg0)).uniqueId)
		end)
		table.insert(var0, function(arg0)
			table.insert(arg0.tweenList, LeanTween.delayedCall(0.5, System.Action(arg0)).uniqueId)
		end)
	end

	seriesAsync(var0, function()
		arg0:displayShipWord("propose")
	end)
	table.insert(arg0.tweenList, LeanTween.delayedCall(1.2, System.Action(function()
		arg0:showbgAdd(false, 1.8)
	end)).uniqueId)
	table.insert(arg0.tweenList, LeanTween.delayedCall(3.2, System.Action(function()
		setActive(arg0.proposePanel, false)
		arg0:showbgAdd(true, 2)
	end)).uniqueId)
end

function var0.displayShipWord(arg0, arg1)
	local var0 = ShipGroup.getDefaultSkin(arg0.shipGroupID)
	local var1, var2, var3 = ShipWordHelper.GetWordAndCV(var0.id, arg1)
	local var4

	if arg0.reviewSkinID then
		var4 = arg0.reviewSkinID
	elseif arg0.proposeSkin then
		var4 = arg0.proposeSkin.id
	else
		var4 = arg0.shipVO.skinId
	end

	local var5 = ShipWordHelper.GetL2dCvCalibrate(var4, arg1)

	arg0:showStoryUI(var3)

	if var2 then
		local function var6()
			if arg0._currentVoice then
				arg0._currentVoice:PlaybackStop()
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2, function(arg0)
				arg0._currentVoice = arg0
			end)
		end

		local var7 = var0.Live2DProposeDelayTime

		if not arg0:useL2dOrPainting() then
			var7 = 0
		end

		table.insert(arg0.tweenList, LeanTween.delayedCall(var7, System.Action(function()
			if arg0.l2dChar and var5 and var5 ~= 0 then
				arg0._delayVoiceTweenID = LeanTween.delayedCall(var5, System.Action(function()
					var6()

					arg0._delayVoiceTweenID = nil
				end)).uniqueId
			else
				var6()
			end
		end)).uniqueId)
	end
end

function var0.useL2dOrPainting(arg0)
	return checkABExist("live2d/" .. string.lower(arg0.paintingName))
end

function var0.showStoryUI(arg0, arg1)
	local var0 = {}

	if not arg0.storyTF then
		table.insert(var0, function(arg0)
			local var0 = "ProposeStoryUI"

			PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
				if arg0.exited then
					PoolMgr.GetInstance():ReturnUI(var0, arg0)

					return
				end

				arg0.storyTF = tf(arg0)

				setParent(tf(arg0), arg0:findTF("contain"))

				arg0.storyCG = GetOrAddComponent(arg0.storyTF, typeof(CanvasGroup))
				arg0.storyContent = arg0:findTF("dialogue/content", arg0.storyTF)
				arg0.typeWriter = arg0.storyContent:GetComponent(typeof(Typewriter))
				arg0.targetNameTF = arg0:findTF("dialogue/content/name", arg0.storyTF)
				arg0._renamePanel = arg0:findTF("changeName_panel", arg0.storyTF)

				setText(findTF(arg0._renamePanel, "frame/name_field/Placeholder"), i18n("rename_input"))
				setActive(arg0._renamePanel, false)
				onButton(arg0, arg0.storyTF, function()
					if arg0.inTypeWritter then
						arg0.typeWriter:setSpeed(arg0.typeWritterSpeedUp)

						return
					end

					if not arg0.initStory then
						return
					end

					table.insert(arg0.tweenList, LeanTween.alphaCanvas(arg0.storyCG, 0, 1):setFrom(1):setOnComplete(System.Action(function()
						setActive(arg0.storyTF, false)
					end)).uniqueId)

					if arg0._currentVoice then
						arg0._currentVoice:PlaybackStop()
					end

					arg0._currentVoice = nil

					arg0:setMask(true)
					table.insert(arg0.tweenList, LeanTween.delayedCall(0.5, System.Action(function()
						if arg0.weddingReview then
							arg0:closeView()
						else
							arg0:initChangeNamePanel()
							arg0:stampWindow()
						end
					end)).uniqueId)
				end)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, function()
		if arg0:useL2dOrPainting() then
			arg0:showLive2D("wedding")
		else
			arg0:showPainting(true, 2)
		end

		local var0 = ShipGroup.getDefaultShipNameByGroupID(arg0.shipGroupID)

		setText(arg0.targetNameTF:Find("Text"), var0)
		setText(arg0.storyContent, "")

		arg0.storyCG.alpha = 0

		setActive(arg0.storyTF, true)

		arg0.initStory = false

		table.insert(arg0.tweenList, LeanTween.alphaCanvas(arg0.storyCG, 1, 1):setFrom(0):setDelay(1):setOnComplete(System.Action(function()
			if findTF(arg0.targetActorTF, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0.targetActorTF, "fitter"):GetChild(0), arg0.paintingName, "propose")
			end

			setText(arg0.storyContent, arg1)

			arg0.onWords = true

			arg0:TypeWriter()

			arg0.initStory = true

			arg0:setMask(false)

			if not arg0.weddingReview then
				arg0:showTip()
			end
		end)).uniqueId)
	end)
end

function var0.TypeWriter(arg0)
	local var0 = 0.1

	arg0.inTypeWritter = true
	arg0.typeWritterSpeedUp = 0.01

	arg0.typeWriter:setSpeed(var0)
	arg0.typeWriter:Play()

	function arg0.typeWriter.endFunc()
		arg0.inTypeWritter = false
		arg0.typeWritterSpeedUp = nil
	end
end

function var0.loadChar(arg0, arg1, arg2, arg3)
	arg1 = arg1 or arg0._paintingTF
	arg2 = arg2 or "wedding"

	local var0 = {}

	if not arg0.actorPainting then
		table.insert(var0, function(arg0)
			if arg0.reviewSkinID then
				arg0.paintingName = pg.ship_skin_template[arg0.reviewSkinID].painting
			elseif arg0.proposeSkin then
				arg0.paintingName = arg0.proposeSkin.painting
			else
				arg0.paintingName = arg0.shipVO:getPainting()
			end

			local var0 = arg0.paintingName

			if checkABExist("painting/" .. var0 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0, 0) ~= 0 then
				var0 = var0 .. "_n"
			end

			PoolMgr.GetInstance():GetPainting(var0, true, function(arg0)
				local var0 = findTF(arg0, "Touch")

				if not IsNil(var0) then
					setActive(var0, false)
				end

				arg0.actorPainting = arg0

				ShipExpressionHelper.SetExpression(arg0.actorPainting, arg0.paintingName)
				arg0()
			end)

			if checkABExist("live2d/" .. string.lower(arg0.paintingName)) then
				arg0:createLive2D(arg0.paintingName)
			end
		end)
	end

	seriesAsync(var0, function()
		if not IsNil(arg1) then
			local var0 = findTF(arg1, "fitter")

			assert(var0, "请添加子物体fitter")

			local var1 = GetOrAddComponent(var0, "PaintingScaler")

			var1.FrameName = arg2
			var1.Tween = 1

			setParent(arg0.actorPainting, var0)
		end

		if arg3 then
			arg3()
		end
	end)
end

function var0.createLive2D(arg0, arg1)
	arg0.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg1, function(arg0)
		local var0 = arg0:findTF("live2d", arg0.targetActorTF)

		UIUtil.SetLayerRecursively(arg0, LayerMask.NameToLayer("UI"))

		local var1 = arg0.transform

		var1:SetParent(var0, true)

		local var2

		if arg0.reviewSkinID then
			var2 = arg0.reviewSkinID
		elseif arg0.proposeSkin then
			var2 = arg0.proposeSkin.id
		else
			var2 = arg0.shipVO.skinId
		end

		var1.localPosition = BuildVector3(pg.ship_skin_template[var2].live2d_offset) + Vector3(0, 0, 100)
		var1.localScale = Vector3.Scale(Vector3(1, 1, 10), var1.localScale)
		arg0.l2dChar = GetComponent(arg0, "Live2dChar")
		arg0.l2dChar.name = arg1

		local var3 = pg.AssistantInfo.action2Id.idle

		function arg0.l2dChar.FinishAction(arg0)
			if var3 ~= arg0 then
				arg0.l2dChar:SetAction(var3)
			end
		end

		arg0.l2dChar:SetAction(var3)

		local var4 = pg.ship_skin_template[var2]
		local var5 = var4.lip_sync_gain
		local var6 = var4.lip_smoothing

		if var5 and var5 ~= 0 then
			var0:GetChild(0):GetComponent("CubismCriSrcMouthInput").Gain = var5
		end

		if var6 and var6 ~= 0 then
			var0:GetChild(0):GetComponent("CubismCriSrcMouthInput").Smoothing = var6
		end
	end)
end

function var0.showTip(arg0)
	local var0 = arg0.proposeSkin

	if not var0 then
		return
	end

	local var1 = arg0:findTF("tip", arg0.storyTF)
	local var2 = arg0:findTF("Image_bg/Text", var1)

	setText(var2, i18n("achieve_propose_tip", var0.name))
	eachChild(var1:Find("Image_bg/Image"), function(arg0)
		setActive(arg0, arg0.name == arg0.proposeType)
	end)

	local var3 = GetOrAddComponent(var1, typeof(CanvasGroup))

	setActive(var1, true)
	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var3, 1, 0.01):setFrom(0).uniqueId)
	table.insert(arg0.tweenList, LeanTween.alphaCanvas(var3, 0, 1.5):setFrom(1):setDelay(4).uniqueId)
end

function var0.initChangeNamePanel(arg0)
	setText(arg0._renamePanel:Find("frame/border/title"), i18n("word_propose_changename_title", arg0.shipVO:getName()))
	setText(arg0._renamePanel:Find("frame/setting_ship_name/text"), i18n("word_propose_changename_tip1"))
	setText(arg0._renamePanel:Find("frame/text"), i18n("word_propose_changename_tip2"))

	arg0._renameConfirmBtn = arg0._renamePanel:Find("frame/queren")
	arg0._renameCancelBtn = arg0._renamePanel:Find("frame/cancel")
	arg0._renameToggle = findTF(arg0._renamePanel, "frame/setting_ship_name"):GetComponent(typeof(Toggle))
	arg0._renameRevert = arg0._renamePanel:Find("frame/revert_button")
	arg0._closeBtn = arg0._renamePanel:Find("frame/close_btn")

	onButton(arg0, arg0._renameConfirmBtn, function()
		local var0 = getInputText(findTF(arg0._renamePanel, "frame/name_field"))

		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg0._renameToggle.isOn)
		arg0:emit(ProposeMediator.RENAME_SHIP, arg0.shipVO.id, var0)
	end, SFX_CONFIRM)
	onButton(arg0, arg0._renameRevert, function()
		local var0 = arg0.shipVO:isRemoulded() and pg.ship_skin_template[arg0.shipVO:getRemouldSkinId()].name or pg.ship_data_statistics[arg0.shipVO.configId].name

		setInputText(findTF(arg0._renamePanel, "frame/name_field"), var0)
	end, SFX_PANEL)
	onButton(arg0, arg0._renameCancelBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._closeBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
end

function var0.DisplayRenamePanel(arg0)
	if arg0.shipVO:IsXIdol() then
		arg0:closeView()
	else
		setParent(arg0._renamePanel, arg0._tf)
		setActive(arg0._renamePanel, true)

		local var0 = arg0.shipVO:getName()

		setInputText(findTF(arg0._renamePanel, "frame/name_field"), var0)
		setIntimacyIcon(arg0.intimacyTF, arg0.shipVO:getIntimacyIcon())
	end
end

function var0.showExchangePanel(arg0)
	setActive(arg0.exchangePanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.exchangePanel, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.hideExchangePanel(arg0)
	setActive(arg0.exchangePanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.exchangePanel, arg0._tf)
end

function var0.checkPaintingRes(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1:getProposeSkin()

	if var1 and var1.id > 0 then
		local var2 = var1.id

		PaintingGroupConst.AddPaintingNameBySkinID(var0, var2)
	end

	local var3 = {
		isShowBox = true,
		paintingNameList = var0,
		finishFunc = arg2
	}

	PaintingGroupConst.PaintingDownload(var3)
end

return var0
