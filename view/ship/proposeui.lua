local var0_0 = class("ProposeUI", import("..base.BaseUI"))
local var1_0 = {
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

var0_0.nationSpriteIndex = {
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

function var0_0.getUIName(arg0_1)
	return "ProposeUI"
end

function var0_0.setShip(arg0_2, arg1_2)
	arg0_2.shipVO = arg1_2
	arg0_2.proposeType = arg0_2.shipVO:getProposeType()

	arg0_2:setShipGroupID(arg0_2.shipVO:getGroupId())
end

function var0_0.setShipGroupID(arg0_3, arg1_3)
	arg0_3.shipGroupID = arg1_3
end

function var0_0.setWeddingReviewSkinID(arg0_4, arg1_4)
	arg0_4.reviewSkinID = arg1_4
end

function var0_0.setBagProxy(arg0_5, arg1_5)
	arg0_5.bagProxy = arg1_5
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6
end

function var0_0.init(arg0_7)
	arg0_7.storybg = arg0_7._tf:Find("close/bg")
	arg0_7.bgAdd = arg0_7._tf:Find("add")

	setActive(arg0_7.storybg, false)
	setActive(arg0_7.bgAdd, false)

	arg0_7.targetActorTF = arg0_7._tf:Find("actor_middle")
	arg0_7.maskTF = arg0_7._tf:Find("mask")
	arg0_7.skipBtn = arg0_7._tf:Find("skip_button")
	arg0_7.actorPainting = nil
	arg0_7.materialFace = arg0_7._tf:Find("Resource/face"):GetComponent(typeof(Image)).material
	arg0_7.materialPaint = arg0_7._tf:Find("Resource/paint"):GetComponent(typeof(Image)).material
	arg0_7.finishCallback = arg0_7.contextData.finishCallback
	arg0_7.commonTF = GameObject.Find("OverlayCamera/Overlay/UIMain/common")
	arg0_7.exchangePanel = arg0_7._tf:Find("exchange_panel")

	local var0_7 = arg0_7.exchangePanel:Find("window/msg_panel/content")

	setText(var0_7:Find("text"), i18n("word_propose_cost_tip2"))

	local var1_7 = pg.gameset.vow_prop_conversion.description

	for iter0_7, iter1_7 in ipairs(var1_7) do
		local var2_7 = Drop.New({
			count = 1,
			type = DROP_TYPE_ITEM,
			id = iter1_7
		})

		updateDrop(var0_7:Find("icon_" .. iter0_7), var2_7)
		onButton(arg0_7, var0_7:Find("icon_" .. iter0_7), function()
			arg0_7:emit(BaseUI.ON_DROP, var2_7)
		end, SFX_PANEL)
	end

	onButton(arg0_7, arg0_7.exchangePanel:Find("bg"), function()
		arg0_7:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.exchangePanel:Find("window/top/btnBack"), function()
		arg0_7:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.exchangePanel:Find("window/button_container/cancel"), function()
		arg0_7:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.exchangePanel:Find("window/button_container/confirm"), function()
		if getProxy(BagProxy):getItemCountById(ITEM_ID_FOR_PROPOSE) > 0 then
			arg0_7:emit(ProposeMediator.EXCHANGE_TIARA)
		else
			ItemTipPanel.ShowRingBuyTip()
		end

		arg0_7:hideExchangePanel()
	end, SFX_CONFIRM)

	arg0_7.tweenList = {}
end

function var0_0.didEnter(arg0_13)
	arg0_13:emit(ProposeMediator.HIDE_SHIP_MAIN_WORD)

	if arg0_13.commonTF then
		setActive(arg0_13.commonTF, false)
	end

	if arg0_13.contextData.review then
		arg0_13.weddingReview = true
		arg0_13.proposeType = arg0_13.contextData.group:getProposeType()

		local var0_13 = arg0_13.contextData.group:getNation()

		arg0_13.bgName = Nation.Nation2BG(var0_13) or Nation.Nation2BG(0)

		onButton(arg0_13, arg0_13.skipBtn, function()
			arg0_13:closeView()
		end, SFX_CANCEL)
		pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
		arg0_13:doPlay()
	else
		arg0_13:doMain()
	end
end

function var0_0.doPlay(arg0_15)
	setActive(arg0_15.skipBtn, arg0_15.weddingReview)
	arg0_15:setMask(true)
	pg.BgmMgr.GetInstance():TempPlay("wedding")
	arg0_15:showProposePanel()
end

function var0_0.doMain(arg0_16)
	onButton(arg0_16, arg0_16.skipBtn, function()
		arg0_16:closeView()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16._tf:Find("close0"), function()
		if arg0_16.proposeEndFlag then
			arg0_16:DisplayRenamePanel()
		else
			arg0_16:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16._tf:Find("close_end"), function()
		if arg0_16.proposeEndFlag then
			arg0_16:DisplayRenamePanel()
		else
			arg0_16:closeView()
		end
	end, SFX_CANCEL)

	local var0_16 = arg0_16.shipVO:getConfigTable().nationality
	local var1_16 = "Propose" .. Nation.Nation2Side(var0_16) .. "UI"

	arg0_16.bgName = Nation.Nation2BG(var0_16) or Nation.Nation2BG(0)

	PoolMgr.GetInstance():GetUI(var1_16, true, function(arg0_20)
		if arg0_16.exited then
			PoolMgr.GetInstance():ReturnUI(var1_16, arg0_20)

			return
		end

		arg0_16.window = tf(arg0_20)

		setParent(tf(arg0_20), arg0_16._tf:Find("window"))

		arg0_16.intimacyTF = arg0_16.window:Find("intimacy/icon")
		arg0_16.intimacyValueTF = arg0_16.window:Find("intimacy/value")
		arg0_16.button = arg0_16.window:Find("button")
		arg0_16.giftButton = arg0_16.window:Find("giftBtn")
		arg0_16.intimacyDesc = arg0_16.window:Find("desc")
		arg0_16.intimacydescTime = arg0_16.window:Find("descPic/desc_time")
		arg0_16.intimacyDescPic = arg0_16.window:Find("descPic")
		arg0_16.intimacyBuffDesc = arg0_16.window:Find("desc_buff")
		arg0_16._paintingTF = arg0_16.window:Find("paintMask/paint")
		arg0_16.intimacyAchieved = arg0_16.window:Find("intimacy/achieved")
		arg0_16.intimacyNoAchieved = arg0_16.window:Find("intimacy/no_achieved")
		arg0_16.ringAchieved = arg0_16.window:Find("ringCount/achieved")
		arg0_16.ringNoAchieved = arg0_16.window:Find("ringCount/no_achieved")
		arg0_16.ringValue = arg0_16.window:Find("ringCount/value")
		arg0_16.nameTF = arg0_16.window:Find("title1/Text")
		arg0_16.shipNameTF = arg0_16.window:Find("title2/Text")
		arg0_16.campTF = arg0_16.window:Find("Camp")
		arg0_16.doneTF = arg0_16.window:Find("done")
		arg0_16.CampSprite = arg0_16.window:Find("CampSprite")

		setActive(arg0_16.window, true)
		setText(arg0_16.nameTF, arg0_16.player.name)
		setText(arg0_16.shipNameTF, arg0_16.shipVO:getName())

		if arg0_16.CampSprite then
			local var0_20 = getImageSprite(arg0_16.CampSprite:Find(Nation.Nation2Print(var0_16)))

			if not var0_20 then
				warning("找不到印花, shipConfigId: " .. arg0_16.shipVO.configId)
				setActive(arg0_16.campTF, false)
			else
				setImageSprite(arg0_16.campTF, var0_20, false)
				setActive(arg0_16.campTF, true)
			end
		end

		setIntimacyIcon(arg0_16.intimacyTF, arg0_16.shipVO:getIntimacyIcon())

		local var1_20, var2_20 = arg0_16.shipVO:getIntimacyDetail()

		setText(arg0_16.intimacyValueTF, i18n("propose_intimacy_tip", var2_20))

		if var2_20 >= 100 then
			setTextColor(arg0_16.intimacyValueTF, Color.white)
		else
			setTextColor(arg0_16.intimacyValueTF, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
		end

		setActive(arg0_16.intimacyAchieved, arg0_16.shipVO.propose or var2_20 >= 100)
		setActive(arg0_16.intimacyNoAchieved, var2_20 < 100 and not arg0_16.shipVO.propose)
		arg0_16:onUpdateItemCount()
		setActive(arg0_16.doneTF, arg0_16.shipVO.propose)

		local var3_20, var4_20 = arg0_16.shipVO:getIntimacyInfo()

		if arg0_16.shipVO.propose then
			if arg0_16.intimacyDescPic then
				setActive(arg0_16.intimacyDescPic, true)
				arg0_16:onUpdateIntimacydescTime(arg0_16.shipVO.proposeTime)
			end

			if arg0_16.intimacyDesc then
				setActive(arg0_16.intimacyDesc, not arg0_16.intimacyDescPic)

				local var5_20 = arg0_16:getProposeText()

				setText(arg0_16.intimacyDesc, var5_20)
			end
		else
			if arg0_16.intimacyDesc and GetComponent(arg0_16.intimacyDesc, "VerticalText") then
				GetComponent(arg0_16.intimacyDesc, "VerticalText").enabled = false
			end

			if arg0_16.intimacyDescPic then
				setActive(arg0_16.intimacyDescPic, false)
			end

			if arg0_16.intimacyDesc then
				setActive(arg0_16.intimacyDesc, true)
				setText(arg0_16.intimacyDesc, i18n(var4_20, arg0_16.shipVO.name))
			end
		end

		setText(arg0_16.intimacyBuffDesc, "*" .. i18n(var4_20 .. "_buff"))
		arg0_16:loadChar()
		pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf)
		setActive(arg0_16.button, not arg0_16.shipVO:ShowPropose())

		local var6_20 = not arg0_16.shipVO.propose and var1_20 <= var2_20
		local var7_20 = arg0_16.shipVO.propose and not arg0_16.shipVO:ShowPropose()

		arg0_16.button:GetComponent(typeof(Button)).interactable = var6_20 or var7_20

		onButton(arg0_16, arg0_16.button, function()
			if var6_20 then
				local var0_21 = arg0_16.bagProxy:getItemCountById(arg0_16:getProposeItemId())

				if var0_21 < 1 then
					if arg0_16.proposeType == "imas" then
						arg0_16:showExchangePanel()
					else
						ItemTipPanel.ShowRingBuyTip()
					end

					return
				end

				local var1_21, var2_21 = ShipStatus.ShipStatusCheck("onPropose", arg0_16.shipVO)

				if not var1_21 then
					pg.TipsMgr.GetInstance():ShowTips(var2_21)

					return
				end

				arg0_16:checkPaintingRes(arg0_16.shipVO, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("word_propose_cost_tip" .. (arg0_16.proposeType == "imas" and "1" or ""), var0_21),
						onYes = function()
							if arg0_16.intimacydescTime then
								arg0_16:onUpdateIntimacydescTime(pg.TimeMgr.GetInstance():GetServerTime())
							end

							arg0_16:hideWindow()
							setActive(arg0_16.window, false)
							arg0_16:doPlay()
						end
					})
				end)
			elseif var7_20 then
				function arg0_16.afterRegisterCall()
					arg0_16.afterRegisterCall = nil

					pg.TipsMgr.GetInstance():ShowTips(i18n("word_propose_switch_tip"))
					arg0_16:closeView()
				end

				arg0_16:emit(ProposeMediator.REGISTER_SHIP, arg0_16.shipVO.id)
			else
				arg0_16:closeView()
			end
		end, SFX_PANEL)
		setActive(arg0_16.giftButton, not LOCK_SHIP_GIFT)
		onButton(arg0_16, arg0_16.giftButton, function()
			if LOCK_SHIP_GIFT then
				return
			end

			arg0_16:emit(ProposeMediator.GIFT_SHIP, arg0_16.shipVO.id)
		end, SFX_PANEL)
	end)
end

function var0_0.getProposeText(arg0_26)
	local var0_26 = ""

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		var0_26 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():ChieseDescTime(arg0_26.shipVO.proposeTime, true))

		if not IsNil(GetComponent(arg0_26.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_26.intimacyDesc, "VerticalText").enabled = true
			var0_26 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():ChieseDescTime(arg0_26.shipVO.proposeTime, true))
		end
	elseif PLATFORM_CODE == PLATFORM_KR then
		var0_26 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0_26.shipVO.proposeTime, "%Y년%m월%d일", true))

		if not IsNil(GetComponent(arg0_26.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_26.intimacyDesc, "VerticalText").enabled = true
			var0_26 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0_26.shipVO.proposeTime, "%Y년%m월%d일"))
		end
	else
		var0_26 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0_26.shipVO.proposeTime, "%Y/%m/%d", true))

		if not IsNil(GetComponent(arg0_26.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_26.intimacyDesc, "VerticalText").enabled = true
			var0_26 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0_26.shipVO.proposeTime, "%Y/%m/%d"))
		end
	end

	return var0_26
end

function var0_0.getProposeItemId(arg0_27)
	if arg0_27.proposeType == "imas" then
		return ITEM_ID_FOR_PROPOSE_IMAS
	else
		return ITEM_ID_FOR_PROPOSE
	end
end

function var0_0.onUpdateItemCount(arg0_28)
	local var0_28 = arg0_28.bagProxy:getItemCountById(arg0_28:getProposeItemId())

	setActive(arg0_28.ringAchieved, arg0_28.shipVO.propose or var0_28 > 0)
	setActive(arg0_28.ringNoAchieved, var0_28 <= 0 and not arg0_28.shipVO.propose)
	setText(arg0_28.ringValue, i18n(arg0_28.proposeType == "imas" and "intimacy_desc_tiara" or "intimacy_desc_ring"))

	if arg0_28.shipVO.propose or var0_28 > 0 then
		setTextColor(arg0_28.ringValue, Color.white)
	else
		setTextColor(arg0_28.ringValue, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
	end

	if arg0_28.proposeType == "imas" then
		local var1_28 = not arg0_28.shipVO.propose and var0_28 == 0

		setActive(arg0_28.window:Find("ringCount/bg_exchange"), var1_28)
		setActive(arg0_28.window:Find("ringCount/icon/btn_exchange"), var1_28)
		onButton(arg0_28, arg0_28.window:Find("ringCount/icon/btn_exchange"), function()
			arg0_28:showExchangePanel()
		end, SFX_PANEL)
	else
		setActive(arg0_28.window:Find("ringCount/icon/base"), PLATFORM_CODE ~= PLATFORM_CH)
		setActive(arg0_28.window:Find("ringCount/icon/hx"), PLATFORM_CODE == PLATFORM_CH)
	end
end

function var0_0.onUpdateIntimacydescTime(arg0_30, arg1_30)
	local var0_30

	if PLATFORM_CODE == PLATFORM_JP then
		if arg0_30.proposeType == "imas" then
			var0_30 = "%Y.%m.%d"
		else
			var0_30 = "%B.%d,    %y"
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		var0_30 = "%B %d, %Y"
	elseif arg0_30.proposeType == "imas" then
		var0_30 = i18n("intimacy_desc_day") .. " %Y.%m.%d"
	else
		var0_30 = "%B.%d,    %y"
	end

	setText(arg0_30.intimacydescTime, pg.TimeMgr.GetInstance():STimeDescS(arg1_30, var0_30))
end

function var0_0.onBackPressed(arg0_31)
	if isActive(arg0_31.exchangePanel) then
		arg0_31:hideExchangePanel()

		return
	end

	if arg0_31.window and isActive(arg0_31.window) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_31._tf:Find("close_end"))
	end
end

function var0_0.willExit(arg0_32)
	if arg0_32._currentVoice then
		arg0_32._currentVoice:PlaybackStop()
	end

	arg0_32._currentVoice = nil

	pg.BgmMgr.GetInstance():ContinuePlay()

	if not IsNil(arg0_32.actorPainting) then
		local var0_32 = tf(arg0_32.actorPainting)

		if var0_32:Find("temp_mask") then
			Destroy(var0_32:Find("temp_mask"))
		end

		var0_32:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0_32.paintingName, arg0_32.actorPainting)

		arg0_32.actorPainting = nil
	end

	if arg0_32.delayTId then
		LeanTween.cancel(arg0_32.delayTId)
	end

	if arg0_32.commonTF then
		setActive(arg0_32.commonTF, true)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32._tf)

	if arg0_32.l2dChar then
		arg0_32.l2dChar:ClearPics()

		arg0_32.l2dChar = nil
	end

	if arg0_32.live2dRequestId then
		pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_32.live2dRequestId)

		arg0_32.live2dRequestId = nil
	end

	if arg0_32._delayVoiceTweenID then
		LeanTween.cancel(arg0_32._delayVoiceTweenID)

		arg0_32._delayVoiceTweenID = nil
	end

	if arg0_32.tweenList then
		cancelTweens(arg0_32.tweenList)

		arg0_32.tweenList = nil
	end

	if arg0_32.contextData.callback then
		arg0_32.contextData.callback()
	end

	if arg0_32.finishCallback then
		arg0_32.finishCallback()

		arg0_32.finishCallback = nil
	end
end

function var0_0.setMask(arg0_33, arg1_33)
	setActive(arg0_33.maskTF, arg1_33)
end

function var0_0.bgAddAnimation(arg0_34, arg1_34)
	setActive(arg0_34.storybg, true)
	arg0_34:showbgAdd(true, arg1_34)
end

function var0_0.showbgChurch(arg0_35)
	table.insert(arg0_35.tweenList, LeanTween.scale(arg0_35.storybg, Vector3(1, 1, 1), 6).uniqueId)
	setActive(arg0_35.churchLight, true)
	table.insert(arg0_35.tweenList, LeanTween.delayedCall(6, System.Action(function()
		setActive(arg0_35.churchLight, false)
	end)).uniqueId)
end

function var0_0.showbgAdd(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg1_37 and 1 or 0
	local var1_37 = arg1_37 and 0 or 1
	local var2_37 = GetOrAddComponent(arg0_37.bgAdd, typeof(CanvasGroup))

	table.insert(arg0_37.tweenList, LeanTween.alphaCanvas(var2_37, var1_37, arg2_37):setFrom(var0_37).uniqueId)
	setActive(arg0_37.bgAdd, true)
end

function var0_0.showBlackBG(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = arg1_38 and 1 or 0
	local var1_38 = arg1_38 and 0 or 1
	local var2_38 = GetOrAddComponent(arg0_38.blackBG, typeof(CanvasGroup))

	setActive(arg0_38.blackBG, true)
	table.insert(arg0_38.tweenList, LeanTween.alphaCanvas(var2_38, var1_38, arg2_38):setFrom(var0_38):setOnComplete(System.Action(function()
		if arg1_38 then
			setActive(arg0_38.blackBG, false)
		end

		if arg3_38 then
			arg3_38()
		end
	end)).uniqueId)
end

function var0_0.showPainting(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = {}

	if arg1_40 then
		table.insert(var0_40, function(arg0_41)
			arg0_40:loadChar(arg0_40.targetActorTF, "duihua", arg0_41)
		end)
	end

	seriesAsync(var0_40, function()
		local var0_42 = arg1_40 and 0 or 1
		local var1_42 = arg1_40 and 1 or 0
		local var2_42 = GetOrAddComponent(arg0_40.targetActorTF, typeof(CanvasGroup))

		table.insert(arg0_40.tweenList, LeanTween.alphaCanvas(var2_42, var1_42, arg2_40):setFrom(var0_42):setOnComplete(System.Action(function()
			if arg3_40 then
				arg3_40()
			end
		end)).uniqueId)
	end)
end

var0_0.Live2DProposeDelayTime = 2

function var0_0.showLive2D(arg0_44, arg1_44)
	setActive(arg0_44.targetActorTF:Find("fitter"), false)
	setActive(arg0_44.targetActorTF:Find("live2d"), true)

	local var0_44 = GetOrAddComponent(arg0_44.targetActorTF, typeof(CanvasGroup))

	table.insert(arg0_44.tweenList, LeanTween.alphaCanvas(var0_44, 1, var0_0.Live2DProposeDelayTime):setFrom(0):setOnComplete(System.Action(function()
		arg0_44:changeParamaterValue("Paramring", 1)
		arg0_44.l2dChar:SetAction(pg.AssistantInfo.action2Id[arg1_44])
	end)).uniqueId)
end

function var0_0.changeParamaterValue(arg0_46, arg1_46, arg2_46)
	if not arg1_46 or string.len(arg1_46) == 0 then
		return
	end

	local var0_46 = arg0_46.l2dChar:GetCubismParameter(arg1_46)

	if not var0_46 then
		return
	end

	arg0_46.l2dChar:AddParameterValue(var0_46, arg2_46, CubismParameterBlendMode.Override)
end

function var0_0.hideWindow(arg0_47)
	local var0_47 = GetOrAddComponent(arg0_47.window, typeof(CanvasGroup))

	var0_47.interactable = false

	table.insert(arg0_47.tweenList, LeanTween.alphaCanvas(var0_47, 0, 0.2):setFrom(1):setOnComplete(System.Action(function()
		var0_47.interactable = true
	end)).uniqueId)
end

function var0_0.stampWindow(arg0_49)
	arg0_49.proposeEndFlag = true

	arg0_49:loadChar(nil, nil, function()
		return
	end)
	setActive(arg0_49.window, true)
	setActive(arg0_49.button, false)
	setActive(arg0_49.giftButton, false)
	setActive(arg0_49.targetActorTF:Find("live2d"), false)

	local var0_49

	if arg0_49.intimacyDescPic then
		setActive(arg0_49.intimacyDescPic, true)

		var0_49 = GetOrAddComponent(arg0_49.intimacyDescPic, typeof(CanvasGroup))
	end

	if arg0_49.intimacyDesc then
		setActive(arg0_49.intimacyDesc, not arg0_49.intimacyDescPic)

		local var1_49 = arg0_49:getProposeText()

		setText(arg0_49.intimacyDesc, var1_49)

		var0_49 = GetOrAddComponent(arg0_49.intimacyDesc, typeof(CanvasGroup))
	end

	setText(arg0_49.intimacyBuffDesc, "")
	setActive(arg0_49.doneTF, false)

	var0_49.alpha = 0

	local var2_49 = GetOrAddComponent(arg0_49.window, typeof(CanvasGroup))

	var2_49.interactable = false

	table.insert(arg0_49.tweenList, LeanTween.alphaCanvas(var2_49, 1, 0.8):setFrom(0).uniqueId)
	table.insert(arg0_49.tweenList, LeanTween.delayedCall(1.5, System.Action(function()
		table.insert(arg0_49.tweenList, LeanTween.alphaCanvas(var0_49, 1, 2):setFrom(0).uniqueId)
	end)).uniqueId)

	arg0_49.delayTId = LeanTween.delayedCall(5, System.Action(function()
		if not var2_49 then
			return
		end

		var2_49.interactable = true

		setActive(arg0_49.doneTF, true)
		arg0_49:setMask(false)
		setActive(arg0_49._tf:Find("close_end"), true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_SEAL)
	end)).id
end

function var0_0.showProposePanel(arg0_53)
	local var0_53 = {}

	arg0_53.proposeSkin = ShipGroup.getProposeSkin(arg0_53.shipGroupID)

	if arg0_53.proposeSkin and arg0_53.actorPainting then
		local var1_53 = tf(arg0_53.actorPainting)

		if var1_53:Find("temp_mask") then
			Destroy(var1_53:Find("temp_mask"))
		end

		var1_53:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0_53.paintingName, arg0_53.actorPainting)

		arg0_53.actorPainting = nil
	end

	if not arg0_53.proposePanel then
		table.insert(var0_53, function(arg0_54)
			local var0_54 = "ProposeRingUI"

			PoolMgr.GetInstance():GetUI(var0_54, true, function(arg0_55)
				if arg0_53.exited then
					PoolMgr.GetInstance():ReturnUI(var0_54, arg0_55)

					return
				end

				arg0_53.proposePanel = tf(arg0_55)

				setParent(tf(arg0_55), arg0_53._tf:Find("contain"))
				eachChild(arg0_53.proposePanel:Find("ringBox"), function(arg0_56)
					setActive(arg0_56, arg0_56.name == arg0_53.proposeType)

					if arg0_56.name == arg0_53.proposeType then
						arg0_53.ringBoxTF = arg0_56
					end
				end)

				arg0_53.ringBoxCG = GetOrAddComponent(arg0_53.ringBoxTF, typeof(CanvasGroup))
				arg0_53.ringBoxFull = arg0_53.ringBoxTF:Find("full")
				arg0_53.churchBefore = arg0_53.proposePanel:Find("before")
				arg0_53.churchLight = arg0_53.churchBefore:Find("light")

				setParent(arg0_53.churchLight, arg0_53._tf)
				arg0_53.churchLight:SetSiblingIndex(2)

				arg0_53.blackBG = arg0_53.churchBefore:Find("blackbg")
				arg0_53.doorLightBG = arg0_53.churchBefore:Find("door_light")
				arg0_53.door = arg0_53.churchBefore:Find("door")
				arg0_53.doorAni = GetOrAddComponent(arg0_53.door, "SpineAnimUI")

				setParent(arg0_53.churchBefore, arg0_53._tf:Find("contain"))

				arg0_53.ringTipTF = arg0_53.proposePanel:Find("tip")
				arg0_53.ringTipCG = GetOrAddComponent(arg0_53.ringTipTF, typeof(CanvasGroup))

				setText(arg0_53.ringTipTF:Find("Text"), i18n(arg0_53.proposeType == "imas" and "word_propose_tiara_tip" or "word_propose_ring_tip"))
				setActive(arg0_53.ringTipTF:Find("finger"), false)
				LoadImageSpriteAsync(arg0_53.bgName, arg0_53.storybg)

				arg0_53.storybg.localScale = Vector3(1.2, 1.2, 1.2)

				local var0_55 = arg0_53.weddingReview and arg0_53.reviewSkinID or arg0_53.shipVO:getSkinId()

				arg0_53.handId = pg.ship_skin_template[var0_55].hand_id

				local var1_55 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y%m%d", true)

				if SPECIAL_PROPOSE and SPECIAL_PROPOSE[1] == var1_55 then
					for iter0_55, iter1_55 in ipairs(SPECIAL_PROPOSE[2]) do
						if iter1_55[1] == var0_55 then
							arg0_53.handId = iter1_55[2]
						end
					end
				end

				local var2_55 = ({
					default = "",
					meta = "Meta_",
					imas = "Imas_"
				})[arg0_53.proposeType] .. "ProposeHand_" .. arg0_53.handId

				arg0_53.handName = var2_55

				PoolMgr.GetInstance():GetUI(var2_55, true, function(arg0_57)
					if arg0_53.exited then
						PoolMgr.GetInstance():ReturnUI(var2_55, arg0_57)

						return
					end

					arg0_53.transHand = tf(arg0_57)

					setActive(arg0_53.transHand, false)
					setParent(arg0_53.transHand, arg0_53.proposePanel)
					arg0_53.transHand:SetAsFirstSibling()

					arg0_53.handTF = arg0_53.transHand:Find("hand")
					arg0_53.ringTF = arg0_53.transHand:Find("ring")
					arg0_53.ringCG = GetOrAddComponent(arg0_53.ringTF, typeof(CanvasGroup))
					arg0_53.ringAnim = arg0_53.ringTF:GetComponent(typeof(Animator))
					arg0_53.ringAnim.enabled = false
					arg0_53.ringLight = arg0_53.ringTF:Find("ring_light")
					arg0_53.ringLightCG = GetOrAddComponent(arg0_53.ringLight, typeof(CanvasGroup))

					arg0_54()
				end)
			end)
		end)
	end

	table.insert(var0_53, function(arg0_58)
		table.insert(arg0_53.tweenList, LeanTween.scale(arg0_53.door, Vector3(2.1, 2.1, 2.1), 4).uniqueId)
		arg0_53.doorAni:SetActionCallBack(function(arg0_59)
			if arg0_59 == "FINISH" then
				arg0_53.doorAni:SetActionCallBack(nil)
				setActive(arg0_53.door, false)
				arg0_53:showBlackBG(true, 0.1)
				setActive(arg0_53.doorLightBG, false)
				arg0_58()
			end
		end)
		table.insert(arg0_53.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0_53:showbgAdd(false, 2)
		end)).uniqueId)
		table.insert(arg0_53.tweenList, LeanTween.alpha(rtf(arg0_53.doorLightBG), 1, 2):setFrom(0).uniqueId)
		arg0_53:showBlackBG(false, 0.1)
		arg0_53.doorAni:SetAction("OPEN", 0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOOR)
	end)
	table.insert(var0_53, function(arg0_61)
		arg0_53.handTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 0)

		arg0_53:bgAddAnimation(2)
		table.insert(arg0_53.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0_53:showPainting(true, 1.5, function()
				table.insert(arg0_53.tweenList, LeanTween.delayedCall(1.5, System.Action(arg0_61)).uniqueId)
			end)
		end)).uniqueId)
	end)
	table.insert(var0_53, function(arg0_64)
		arg0_53:showBlackBG(false, 1.2, function()
			arg0_53:showBlackBG(true, 1.2)
		end)
		arg0_53:showPainting(false, 1, arg0_64)
	end)
	table.insert(var0_53, function(arg0_66)
		setAnchoredPosition(arg0_53.handTF, {
			y = arg0_53.handTF.rect.height
		})
		setAnchoredPosition(arg0_53.ringTF, {
			y = 0
		})
		setActive(arg0_53.proposePanel, true)
		setActive(arg0_53.transHand, true)

		arg0_53.ringBoxCG.alpha = 0
		arg0_53.ringCG.alpha = 0

		arg0_66()
	end)

	if arg0_53.proposeType ~= "imas" then
		table.insert(var0_53, function(arg0_67)
			table.insert(arg0_53.tweenList, LeanTween.alpha(rtf(arg0_53.handTF), 1, 1.2).uniqueId)
			table.insert(arg0_53.tweenList, LeanTween.moveY(rtf(arg0_53.handTF), 0, 2):setOnComplete(System.Action(function()
				table.insert(arg0_53.tweenList, LeanTween.alphaCanvas(arg0_53.ringBoxCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(arg0_67)).uniqueId)
			end)).uniqueId)
		end)
		table.insert(var0_53, function(arg0_69)
			table.insert(arg0_53.tweenList, LeanTween.alpha(rtf(arg0_53.ringBoxFull), 0, 0.6):setOnComplete(System.Action(arg0_69)).uniqueId)
			table.insert(arg0_53.tweenList, LeanTween.alphaCanvas(arg0_53.ringCG, 1, 0.6).uniqueId)
		end)
	end

	table.insert(var0_53, function(arg0_70)
		arg0_53.ringCG.alpha = 1

		arg0_53:setMask(false)
		table.insert(arg0_53.tweenList, LeanTween.delayedCall(0.1, System.Action(arg0_70)).uniqueId)
	end)
	table.insert(var0_53, function(arg0_71)
		arg0_53.ringAnim.enabled = true

		arg0_53.ringAnim:Play("movein")

		local var0_71 = arg0_53.proposeType == "imas" and 1 or 0.5

		table.insert(arg0_53.tweenList, LeanTween.delayedCall(var0_71, System.Action(arg0_71)).uniqueId)
	end)
	seriesAsync(var0_53, function()
		arg0_53.ringAnim:Play("blink")
		table.insert(arg0_53.tweenList, LeanTween.alphaCanvas(arg0_53.ringTipCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(function()
			setActive(arg0_53.ringTipTF:Find("finger"), true)
			arg0_53:enableRingDrag(true)
		end)).uniqueId)
	end)
end

function var0_0.ringOn(arg0_74)
	if arg0_74.isRingOn then
		return
	end

	setActive(arg0_74.ringTipTF, false)

	arg0_74.isRingOn = true

	arg0_74.ringTF:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_75)
		arg0_74.ringAnim.enabled = false
		arg0_74.isRingOn = false

		if not arg0_74.weddingReview then
			arg0_74:emit(ProposeMediator.ON_PROPOSE, arg0_74.shipVO.id)
		else
			arg0_74:RingFadeout()
		end
	end)

	arg0_74.ringAnim.enabled = true

	arg0_74.ringAnim:Play("wear")

	if arg0_74.handId == "101" then
		local var0_74 = GetOrAddComponent(arg0_74.handTF, typeof(CanvasGroup))

		table.insert(arg0_74.tweenList, LeanTween.alphaCanvas(var0_74, 0, 2).uniqueId)
	end
end

function var0_0.enableRingDrag(arg0_76, arg1_76)
	if not arg0_76.press then
		arg0_76:addRingDragListenter()
	end

	arg0_76.press.enabled = arg1_76
end

function var0_0.addRingDragListenter(arg0_77)
	arg0_77.press = GetOrAddComponent(arg0_77.proposePanel, "EventTriggerListener")

	local var0_77

	arg0_77.press:AddBeginDragFunc(function()
		return
	end)
	arg0_77.press:AddDragFunc(function(arg0_79, arg1_79)
		local var0_79 = arg1_79.position

		if not var0_77 then
			var0_77 = var0_79
		end

		if var0_79.y - var0_77.y > 100 then
			arg0_77:setMask(true)
			arg0_77:ringOn()
			arg0_77:enableRingDrag(false)
		end
	end)
	arg0_77.press:AddDragEndFunc(function(arg0_80, arg1_80)
		return
	end)
end

function var0_0.RingFadeout(arg0_81)
	local var0_81 = {}

	if arg0_81.proposeType == "imas" then
		table.insert(var0_81, function(arg0_82)
			local var0_82 = arg0_81.ringLight:GetChild(0)

			setActive(var0_82, true)
			table.insert(arg0_81.tweenList, LeanTween.delayedCall(3.5, System.Action(function()
				setActive(var0_82, false)
				arg0_82()
			end)).uniqueId)
		end)
	else
		table.insert(var0_81, function(arg0_84)
			table.insert(arg0_81.tweenList, LeanTween.alphaCanvas(arg0_81.ringLightCG, 0.7, 0.5):setFrom(0).uniqueId)
			table.insert(arg0_81.tweenList, LeanTween.scale(arg0_81.ringLight, Vector3(8, 8, 8), 1).uniqueId)
			table.insert(arg0_81.tweenList, LeanTween.rotate(arg0_81.ringLight, 90, 3):setOnComplete(System.Action(arg0_84)).uniqueId)
		end)
		table.insert(var0_81, function(arg0_85)
			table.insert(arg0_81.tweenList, LeanTween.delayedCall(0.5, System.Action(arg0_85)).uniqueId)
		end)
	end

	seriesAsync(var0_81, function()
		arg0_81:displayShipWord("propose")
	end)
	table.insert(arg0_81.tweenList, LeanTween.delayedCall(1.2, System.Action(function()
		arg0_81:showbgAdd(false, 1.8)
	end)).uniqueId)
	table.insert(arg0_81.tweenList, LeanTween.delayedCall(3.2, System.Action(function()
		setActive(arg0_81.proposePanel, false)
		arg0_81:showbgAdd(true, 2)
	end)).uniqueId)
end

function var0_0.displayShipWord(arg0_89, arg1_89)
	local var0_89 = ShipGroup.getDefaultSkin(arg0_89.shipGroupID)
	local var1_89, var2_89, var3_89 = ShipWordHelper.GetWordAndCV(var0_89.id, arg1_89)
	local var4_89

	if arg0_89.reviewSkinID then
		var4_89 = arg0_89.reviewSkinID
	elseif arg0_89.proposeSkin then
		var4_89 = arg0_89.proposeSkin.id
	else
		var4_89 = arg0_89.shipVO:getSkinId()
	end

	local var5_89 = ShipWordHelper.GetL2dCvCalibrate(var4_89, arg1_89)

	arg0_89:showStoryUI(var3_89)

	if var2_89 then
		local function var6_89()
			if arg0_89._currentVoice then
				arg0_89._currentVoice:PlaybackStop()
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_89, function(arg0_91)
				arg0_89._currentVoice = arg0_91
			end)
		end

		local var7_89 = var0_0.Live2DProposeDelayTime

		if not arg0_89:useL2dOrPainting() then
			var7_89 = 0
		end

		table.insert(arg0_89.tweenList, LeanTween.delayedCall(var7_89, System.Action(function()
			if arg0_89.l2dChar and var5_89 and var5_89 ~= 0 then
				arg0_89._delayVoiceTweenID = LeanTween.delayedCall(var5_89, System.Action(function()
					var6_89()

					arg0_89._delayVoiceTweenID = nil
				end)).uniqueId
			else
				var6_89()
			end
		end)).uniqueId)
	end
end

function var0_0.useL2dOrPainting(arg0_94)
	return checkABExist("live2d/" .. string.lower(arg0_94.paintingName))
end

function var0_0.showStoryUI(arg0_95, arg1_95)
	local var0_95 = {}

	if not arg0_95.storyTF then
		table.insert(var0_95, function(arg0_96)
			local var0_96 = "ProposeStoryUI"

			PoolMgr.GetInstance():GetUI(var0_96, true, function(arg0_97)
				if arg0_95.exited then
					PoolMgr.GetInstance():ReturnUI(var0_96, arg0_97)

					return
				end

				arg0_95.storyTF = tf(arg0_97)

				setParent(tf(arg0_97), arg0_95._tf:Find("contain"))

				arg0_95.storyCG = GetOrAddComponent(arg0_95.storyTF, typeof(CanvasGroup))
				arg0_95.storyContent = arg0_95.storyTF:Find("dialogue/content")
				arg0_95.typeWriter = arg0_95.storyContent:GetComponent(typeof(Typewriter))
				arg0_95.targetNameTF = arg0_95.storyTF:Find("dialogue/content/name")
				arg0_95._renamePanel = arg0_95.storyTF:Find("changeName_panel")

				setText(findTF(arg0_95._renamePanel, "frame/name_field/Placeholder"), i18n("rename_input"))
				setActive(arg0_95._renamePanel, false)
				onButton(arg0_95, arg0_95.storyTF, function()
					if arg0_95.inTypeWritter then
						arg0_95.typeWriter:setSpeed(arg0_95.typeWritterSpeedUp)

						return
					end

					if not arg0_95.initStory then
						return
					end

					table.insert(arg0_95.tweenList, LeanTween.alphaCanvas(arg0_95.storyCG, 0, 1):setFrom(1):setOnComplete(System.Action(function()
						setActive(arg0_95.storyTF, false)
					end)).uniqueId)

					if arg0_95._currentVoice then
						arg0_95._currentVoice:PlaybackStop()
					end

					arg0_95._currentVoice = nil

					arg0_95:setMask(true)
					table.insert(arg0_95.tweenList, LeanTween.delayedCall(0.5, System.Action(function()
						if arg0_95.weddingReview then
							arg0_95:closeView()
						else
							arg0_95:initChangeNamePanel()
							arg0_95:stampWindow()
						end
					end)).uniqueId)
				end)
				arg0_96()
			end)
		end)
	end

	seriesAsync(var0_95, function()
		if arg0_95:useL2dOrPainting() then
			arg0_95:showLive2D("wedding")
		else
			arg0_95:showPainting(true, 2)
		end

		local var0_101 = ShipGroup.getDefaultShipNameByGroupID(arg0_95.shipGroupID)

		setText(arg0_95.targetNameTF:Find("Text"), var0_101)
		setText(arg0_95.storyContent, "")

		arg0_95.storyCG.alpha = 0

		setActive(arg0_95.storyTF, true)

		arg0_95.initStory = false

		table.insert(arg0_95.tweenList, LeanTween.alphaCanvas(arg0_95.storyCG, 1, 1):setFrom(0):setDelay(1):setOnComplete(System.Action(function()
			if findTF(arg0_95.targetActorTF, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0_95.targetActorTF, "fitter"):GetChild(0), arg0_95.paintingName, "propose")
			end

			setText(arg0_95.storyContent, arg1_95)

			arg0_95.onWords = true

			arg0_95:TypeWriter()

			arg0_95.initStory = true

			arg0_95:setMask(false)

			if not arg0_95.weddingReview then
				arg0_95:showTip()
			end
		end)).uniqueId)
	end)
end

function var0_0.TypeWriter(arg0_103)
	local var0_103 = 0.1

	arg0_103.inTypeWritter = true
	arg0_103.typeWritterSpeedUp = 0.01

	arg0_103.typeWriter:setSpeed(var0_103)
	arg0_103.typeWriter:Play()

	function arg0_103.typeWriter.endFunc()
		arg0_103.inTypeWritter = false
		arg0_103.typeWritterSpeedUp = nil
	end
end

function var0_0.loadChar(arg0_105, arg1_105, arg2_105, arg3_105)
	arg1_105 = arg1_105 or arg0_105._paintingTF
	arg2_105 = arg2_105 or "wedding"

	local var0_105 = {}

	if not arg0_105.actorPainting then
		table.insert(var0_105, function(arg0_106)
			if arg0_105.reviewSkinID then
				arg0_105.paintingName = pg.ship_skin_template[arg0_105.reviewSkinID].painting
			elseif arg0_105.proposeSkin then
				arg0_105.paintingName = arg0_105.proposeSkin.painting
			else
				arg0_105.paintingName = arg0_105.shipVO:getPainting()
			end

			local var0_106 = arg0_105.paintingName

			if checkABExist("painting/" .. var0_106 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_106, 0) ~= 0 then
				var0_106 = var0_106 .. "_n"
			end

			PoolMgr.GetInstance():GetPainting(var0_106, true, function(arg0_107)
				local var0_107 = findTF(arg0_107, "Touch")

				if not IsNil(var0_107) then
					setActive(var0_107, false)
				end

				arg0_105.actorPainting = arg0_107

				local var1_107 = (arg0_105.weddingReview or arg0_105.shipVO and arg0_105.shipVO.propose) and "propose" or nil

				ShipExpressionHelper.SetExpression(arg0_105.actorPainting, arg0_105.paintingName, var1_107)
				arg0_106()
			end)

			if checkABExist("live2d/" .. string.lower(arg0_105.paintingName)) then
				arg0_105:createLive2D(arg0_105.paintingName)
			end
		end)
	end

	seriesAsync(var0_105, function()
		if not IsNil(arg1_105) then
			local var0_108 = findTF(arg1_105, "fitter")

			assert(var0_108, "请添加子物体fitter")

			local var1_108 = GetOrAddComponent(var0_108, "PaintingScaler")

			var1_108.FrameName = arg2_105
			var1_108.Tween = 1

			setParent(arg0_105.actorPainting, var0_108)
		end

		if arg3_105 then
			arg3_105()
		end
	end)
end

function var0_0.createLive2D(arg0_109, arg1_109)
	arg0_109.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg1_109, function(arg0_110)
		local var0_110 = arg0_110.transform
		local var1_110 = arg0_109.targetActorTF:Find("live2d")

		HotfixHelper.SetLayerRecursively(arg0_110, LayerMask.NameToLayer("UI"))
		var0_110:SetParent(var1_110, true)

		local var2_110

		if arg0_109.reviewSkinID then
			var2_110 = arg0_109.reviewSkinID
		elseif arg0_109.proposeSkin then
			var2_110 = arg0_109.proposeSkin.id
		else
			var2_110 = arg0_109.shipVO:getSkinId()
		end

		Live2DPainting.SetL2dSortingLayer(arg0_110, LayerWeightConst.L2D_DEFAULT_LAYER)

		var0_110.localPosition = BuildVector3(pg.ship_skin_template[var2_110].live2d_offset) + Vector3(0, 0, 100)

		local var3_110 = 52

		if pg.ship_skin_template[var2_110].live2d_offset and #pg.ship_skin_template[var2_110].live2d_offset >= 4 then
			var3_110 = pg.ship_skin_template[var2_110].live2d_offset[4]
		end

		var0_110.localScale = Vector3(var3_110, var3_110, var3_110)
		arg0_109.l2dChar = GetComponent(arg0_110, "Live2dChar")
		arg0_109.l2dChar.name = arg1_109

		local var4_110 = pg.AssistantInfo.action2Id.idle

		function arg0_109.l2dChar.FinishAction(arg0_111)
			if var4_110 ~= arg0_111 then
				arg0_109.l2dChar:SetAction(var4_110)
			end
		end

		arg0_109.l2dChar:SetAction(var4_110)

		local var5_110 = pg.ship_skin_template[var2_110]
		local var6_110 = var5_110.lip_sync_gain
		local var7_110 = var5_110.lip_smoothing

		if var6_110 and var6_110 ~= 0 then
			var1_110:GetChild(0):GetComponent("CubismCriSrcMouthInput").Gain = var6_110
		end

		if var7_110 and var7_110 ~= 0 then
			var1_110:GetChild(0):GetComponent("CubismCriSrcMouthInput").Smoothing = var7_110
		end
	end)
end

function var0_0.showTip(arg0_112)
	local var0_112 = arg0_112.proposeSkin

	if not var0_112 then
		return
	end

	local var1_112 = arg0_112.storyTF:Find("tip")
	local var2_112 = var1_112:Find("Image_bg/Text")

	setText(var2_112, i18n("achieve_propose_tip", var0_112.name))
	eachChild(var1_112:Find("Image_bg/Image"), function(arg0_113)
		setActive(arg0_113, arg0_113.name == arg0_112.proposeType)
	end)

	local var3_112 = GetOrAddComponent(var1_112, typeof(CanvasGroup))

	setActive(var1_112, true)
	table.insert(arg0_112.tweenList, LeanTween.alphaCanvas(var3_112, 1, 0.01):setFrom(0).uniqueId)
	table.insert(arg0_112.tweenList, LeanTween.alphaCanvas(var3_112, 0, 1.5):setFrom(1):setDelay(4).uniqueId)
end

function var0_0.initChangeNamePanel(arg0_114)
	setText(arg0_114._renamePanel:Find("frame/border/title"), i18n("word_propose_changename_title", arg0_114.shipVO:getName()))
	setText(arg0_114._renamePanel:Find("frame/setting_ship_name/text"), i18n("word_propose_changename_tip1"))
	setText(arg0_114._renamePanel:Find("frame/text"), i18n("word_propose_changename_tip2"))

	arg0_114._renameConfirmBtn = arg0_114._renamePanel:Find("frame/queren")
	arg0_114._renameCancelBtn = arg0_114._renamePanel:Find("frame/cancel")
	arg0_114._renameToggle = findTF(arg0_114._renamePanel, "frame/setting_ship_name"):GetComponent(typeof(Toggle))
	arg0_114._renameRevert = arg0_114._renamePanel:Find("frame/revert_button")
	arg0_114._closeBtn = arg0_114._renamePanel:Find("frame/close_btn")

	onButton(arg0_114, arg0_114._renameConfirmBtn, function()
		local var0_115 = getInputText(findTF(arg0_114._renamePanel, "frame/name_field"))

		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg0_114._renameToggle.isOn)
		arg0_114:emit(ProposeMediator.RENAME_SHIP, arg0_114.shipVO.id, var0_115)
	end, SFX_CONFIRM)
	onButton(arg0_114, arg0_114._renameRevert, function()
		local var0_116 = arg0_114.shipVO:isRemoulded() and pg.ship_skin_template[arg0_114.shipVO:getRemouldSkinId()].name or pg.ship_data_statistics[arg0_114.shipVO.configId].name

		setInputText(findTF(arg0_114._renamePanel, "frame/name_field"), var0_116)
	end, SFX_PANEL)
	onButton(arg0_114, arg0_114._renameCancelBtn, function()
		arg0_114:closeView()
	end, SFX_CANCEL)
	onButton(arg0_114, arg0_114._closeBtn, function()
		arg0_114:closeView()
	end, SFX_CANCEL)
end

function var0_0.DisplayRenamePanel(arg0_119)
	if arg0_119.shipVO:IsXIdol() then
		arg0_119:closeView()
	else
		setParent(arg0_119._renamePanel, arg0_119._tf)
		setActive(arg0_119._renamePanel, true)

		local var0_119 = arg0_119.shipVO:getName()

		setInputText(findTF(arg0_119._renamePanel, "frame/name_field"), var0_119)
		setIntimacyIcon(arg0_119.intimacyTF, arg0_119.shipVO:getIntimacyIcon())
	end
end

function var0_0.showExchangePanel(arg0_120)
	setActive(arg0_120.exchangePanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_120.exchangePanel)
end

function var0_0.hideExchangePanel(arg0_121)
	setActive(arg0_121.exchangePanel, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_121.exchangePanel, arg0_121._tf)
end

function var0_0.checkPaintingRes(arg0_122, arg1_122, arg2_122)
	local var0_122 = {}
	local var1_122 = arg1_122:getProposeSkin()

	if var1_122 and var1_122.id > 0 then
		local var2_122 = var1_122.id

		PaintingGroupConst.AddPaintingNameBySkinID(var0_122, var2_122)
	end

	local var3_122 = {
		isShowBox = true,
		paintingNameList = var0_122,
		finishFunc = arg2_122
	}

	PaintingGroupConst.PaintingDownload(var3_122)
end

return var0_0
