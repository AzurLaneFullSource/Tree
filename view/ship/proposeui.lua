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

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2

	if arg1_2.shipId then
		var1_2 = getProxy(BayProxy):getShipById(arg1_2.shipId):getConfigTable().nationality
	elseif arg1_2.group then
		var1_2 = arg1_2.group:getNation()
	elseif arg1_2.skinId then
		local var2_2 = pg.ship_skin_template[arg1_2.skinId]

		var1_2 = ShipGroup.getDefaultShipConfig(var2_2.ship_group).nationality
	end

	if var1_2 then
		table.insert(var0_2, string.lower("ui/Propose" .. Nation.Nation2Side(var1_2) .. "UI"))
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.setShip(arg0_3, arg1_3)
	arg0_3.shipVO = arg1_3
	arg0_3.proposeType = arg0_3.shipVO:getProposeType()

	arg0_3:setShipGroupID(arg0_3.shipVO:getGroupId())
end

function var0_0.setShipGroupID(arg0_4, arg1_4)
	arg0_4.shipGroupID = arg1_4
end

function var0_0.setWeddingReviewSkinID(arg0_5, arg1_5)
	arg0_5.reviewSkinID = arg1_5
end

function var0_0.setBagProxy(arg0_6, arg1_6)
	arg0_6.bagProxy = arg1_6
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.init(arg0_8)
	arg0_8.storybg = arg0_8._tf:Find("close/bg")
	arg0_8.bgAdd = arg0_8._tf:Find("add")

	setActive(arg0_8.storybg, false)
	setActive(arg0_8.bgAdd, false)

	arg0_8.targetActorTF = arg0_8._tf:Find("actor_middle")
	arg0_8.maskTF = arg0_8._tf:Find("mask")
	arg0_8.skipBtn = arg0_8._tf:Find("skip_button")
	arg0_8.actorPainting = nil
	arg0_8.materialFace = arg0_8._tf:Find("Resource/face"):GetComponent(typeof(Image)).material
	arg0_8.materialPaint = arg0_8._tf:Find("Resource/paint"):GetComponent(typeof(Image)).material
	arg0_8.finishCallback = arg0_8.contextData.finishCallback
	arg0_8.commonTF = GameObject.Find("OverlayCamera/Overlay/UIMain/common")
	arg0_8.exchangePanel = arg0_8._tf:Find("exchange_panel")

	local var0_8 = arg0_8.exchangePanel:Find("window/msg_panel/content")

	setText(var0_8:Find("text"), i18n("word_propose_cost_tip2"))

	local var1_8 = pg.gameset.vow_prop_conversion.description

	for iter0_8, iter1_8 in ipairs(var1_8) do
		local var2_8 = Drop.New({
			count = 1,
			type = DROP_TYPE_ITEM,
			id = iter1_8
		})

		updateDrop(var0_8:Find("icon_" .. iter0_8), var2_8)
		onButton(arg0_8, var0_8:Find("icon_" .. iter0_8), function()
			arg0_8:emit(BaseUI.ON_DROP, var2_8)
		end, SFX_PANEL)
	end

	onButton(arg0_8, arg0_8.exchangePanel:Find("bg"), function()
		arg0_8:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.exchangePanel:Find("window/top/btnBack"), function()
		arg0_8:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.exchangePanel:Find("window/button_container/cancel"), function()
		arg0_8:hideExchangePanel()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.exchangePanel:Find("window/button_container/confirm"), function()
		if getProxy(BagProxy):getItemCountById(ITEM_ID_FOR_PROPOSE) > 0 then
			arg0_8:emit(ProposeMediator.EXCHANGE_TIARA)
		else
			ItemTipPanel.ShowRingBuyTip()
		end

		arg0_8:hideExchangePanel()
	end, SFX_CONFIRM)

	arg0_8.tweenList = {}
end

function var0_0.didEnter(arg0_14)
	arg0_14:emit(ProposeMediator.HIDE_SHIP_MAIN_WORD)

	if arg0_14.commonTF then
		setActive(arg0_14.commonTF, false)
	end

	if arg0_14.contextData.review then
		arg0_14.weddingReview = true
		arg0_14.proposeType = arg0_14.contextData.group:getProposeType()

		local var0_14 = arg0_14.contextData.group:getNation()

		arg0_14.bgName = Nation.Nation2BG(var0_14) or Nation.Nation2BG(0)

		onButton(arg0_14, arg0_14.skipBtn, function()
			arg0_14:closeView()
		end, SFX_CANCEL)
		pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
		arg0_14:doPlay()
	else
		arg0_14:doMain()
	end
end

function var0_0.doPlay(arg0_16)
	setActive(arg0_16.skipBtn, arg0_16.weddingReview)
	arg0_16:setMask(true)
	pg.BgmMgr.GetInstance():TempPlay("wedding")
	arg0_16:showProposePanel()
end

function var0_0.doMain(arg0_17)
	onButton(arg0_17, arg0_17.skipBtn, function()
		arg0_17:closeView()
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17._tf:Find("close0"), function()
		if arg0_17.proposeEndFlag then
			arg0_17:DisplayRenamePanel()
		else
			arg0_17:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17._tf:Find("close_end"), function()
		if arg0_17.proposeEndFlag then
			arg0_17:DisplayRenamePanel()
		else
			arg0_17:closeView()
		end
	end, SFX_CANCEL)

	local var0_17 = arg0_17.shipVO:getConfigTable().nationality
	local var1_17 = "Propose" .. Nation.Nation2Side(var0_17) .. "UI"

	arg0_17.bgName = Nation.Nation2BG(var0_17) or Nation.Nation2BG(0)

	PoolMgr.GetInstance():GetUI(var1_17, true, function(arg0_21)
		if arg0_17.exited then
			PoolMgr.GetInstance():ReturnUI(var1_17, arg0_21)

			return
		end

		arg0_17.window = tf(arg0_21)

		setParent(tf(arg0_21), arg0_17._tf:Find("window"))

		arg0_17.intimacyTF = arg0_17.window:Find("intimacy/icon")
		arg0_17.intimacyValueTF = arg0_17.window:Find("intimacy/value")
		arg0_17.button = arg0_17.window:Find("button")
		arg0_17.giftButton = arg0_17.window:Find("giftBtn")
		arg0_17.intimacyDesc = arg0_17.window:Find("desc")
		arg0_17.intimacydescTime = arg0_17.window:Find("descPic/desc_time")
		arg0_17.intimacyDescPic = arg0_17.window:Find("descPic")
		arg0_17.intimacyBuffDesc = arg0_17.window:Find("desc_buff")
		arg0_17._paintingTF = arg0_17.window:Find("paintMask/paint")
		arg0_17.intimacyAchieved = arg0_17.window:Find("intimacy/achieved")
		arg0_17.intimacyNoAchieved = arg0_17.window:Find("intimacy/no_achieved")
		arg0_17.ringAchieved = arg0_17.window:Find("ringCount/achieved")
		arg0_17.ringNoAchieved = arg0_17.window:Find("ringCount/no_achieved")
		arg0_17.ringValue = arg0_17.window:Find("ringCount/value")
		arg0_17.nameTF = arg0_17.window:Find("title1/Text")
		arg0_17.shipNameTF = arg0_17.window:Find("title2/Text")
		arg0_17.campTF = arg0_17.window:Find("Camp")
		arg0_17.doneTF = arg0_17.window:Find("done")
		arg0_17.CampSprite = arg0_17.window:Find("CampSprite")

		setActive(arg0_17.window, true)
		setText(arg0_17.nameTF, arg0_17.player.name)
		setText(arg0_17.shipNameTF, arg0_17.shipVO:getName())

		if arg0_17.CampSprite then
			local var0_21 = getImageSprite(arg0_17.CampSprite:Find(Nation.Nation2Print(var0_17)))

			if not var0_21 then
				warning("找不到印花, shipConfigId: " .. arg0_17.shipVO.configId)
				setActive(arg0_17.campTF, false)
			else
				setImageSprite(arg0_17.campTF, var0_21, false)
				setActive(arg0_17.campTF, true)
			end
		end

		setIntimacyIcon(arg0_17.intimacyTF, arg0_17.shipVO:getIntimacyIcon())

		local var1_21, var2_21 = arg0_17.shipVO:getIntimacyDetail()

		setText(arg0_17.intimacyValueTF, i18n("propose_intimacy_tip", var2_21))

		if var2_21 >= 100 then
			setTextColor(arg0_17.intimacyValueTF, Color.white)
		else
			setTextColor(arg0_17.intimacyValueTF, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
		end

		setActive(arg0_17.intimacyAchieved, arg0_17.shipVO.propose or var2_21 >= 100)
		setActive(arg0_17.intimacyNoAchieved, var2_21 < 100 and not arg0_17.shipVO.propose)
		arg0_17:onUpdateItemCount()
		setActive(arg0_17.doneTF, arg0_17.shipVO.propose)

		local var3_21, var4_21 = arg0_17.shipVO:getIntimacyInfo()

		if arg0_17.shipVO.propose then
			if arg0_17.intimacyDescPic then
				setActive(arg0_17.intimacyDescPic, true)
				arg0_17:onUpdateIntimacydescTime(arg0_17.shipVO.proposeTime)
			end

			if arg0_17.intimacyDesc then
				setActive(arg0_17.intimacyDesc, not arg0_17.intimacyDescPic)

				local var5_21 = arg0_17:getProposeText()

				setText(arg0_17.intimacyDesc, var5_21)
			end
		else
			if arg0_17.intimacyDesc and GetComponent(arg0_17.intimacyDesc, "VerticalText") then
				GetComponent(arg0_17.intimacyDesc, "VerticalText").enabled = false
			end

			if arg0_17.intimacyDescPic then
				setActive(arg0_17.intimacyDescPic, false)
			end

			if arg0_17.intimacyDesc then
				setActive(arg0_17.intimacyDesc, true)
				setText(arg0_17.intimacyDesc, i18n(var4_21, arg0_17.shipVO.name))
			end
		end

		setText(arg0_17.intimacyBuffDesc, "*" .. i18n(var4_21 .. "_buff"))
		arg0_17:loadChar()
		pg.UIMgr.GetInstance():BlurPanel(arg0_17._tf)
		setActive(arg0_17.button, not arg0_17.shipVO:ShowPropose())

		local var6_21 = not arg0_17.shipVO.propose and var1_21 <= var2_21
		local var7_21 = arg0_17.shipVO.propose and not arg0_17.shipVO:ShowPropose()

		arg0_17.button:GetComponent(typeof(Button)).interactable = var6_21 or var7_21

		onButton(arg0_17, arg0_17.button, function()
			if var6_21 then
				local var0_22 = arg0_17.bagProxy:getItemCountById(arg0_17:getProposeItemId())

				if var0_22 < 1 then
					if arg0_17.proposeType == "imas" then
						arg0_17:showExchangePanel()
					else
						ItemTipPanel.ShowRingBuyTip()
					end

					return
				end

				local var1_22, var2_22 = ShipStatus.ShipStatusCheck("onPropose", arg0_17.shipVO)

				if not var1_22 then
					pg.TipsMgr.GetInstance():ShowTips(var2_22)

					return
				end

				arg0_17:checkPaintingRes(arg0_17.shipVO, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("word_propose_cost_tip" .. (arg0_17.proposeType == "imas" and "1" or ""), var0_22),
						onYes = function()
							if arg0_17.intimacydescTime then
								arg0_17:onUpdateIntimacydescTime(pg.TimeMgr.GetInstance():GetServerTime())
							end

							arg0_17:hideWindow()
							setActive(arg0_17.window, false)
							arg0_17:doPlay()
						end
					})
				end)
			elseif var7_21 then
				function arg0_17.afterRegisterCall()
					arg0_17.afterRegisterCall = nil

					pg.TipsMgr.GetInstance():ShowTips(i18n("word_propose_switch_tip"))
					arg0_17:closeView()
				end

				arg0_17:emit(ProposeMediator.REGISTER_SHIP, arg0_17.shipVO.id)
			else
				arg0_17:closeView()
			end
		end, SFX_PANEL)
		setActive(arg0_17.giftButton, not LOCK_SHIP_GIFT)
		onButton(arg0_17, arg0_17.giftButton, function()
			if LOCK_SHIP_GIFT then
				return
			end

			arg0_17:emit(ProposeMediator.GIFT_SHIP, arg0_17.shipVO.id)
		end, SFX_PANEL)
	end)
end

function var0_0.getProposeText(arg0_27)
	local var0_27 = ""

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		var0_27 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():ChieseDescTime(arg0_27.shipVO.proposeTime, true))

		if not IsNil(GetComponent(arg0_27.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_27.intimacyDesc, "VerticalText").enabled = true
			var0_27 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():ChieseDescTime(arg0_27.shipVO.proposeTime, true))
		end
	elseif PLATFORM_CODE == PLATFORM_KR then
		var0_27 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0_27.shipVO.proposeTime, "%Y년%m월%d일", true))

		if not IsNil(GetComponent(arg0_27.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_27.intimacyDesc, "VerticalText").enabled = true
			var0_27 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0_27.shipVO.proposeTime, "%Y년%m월%d일"))
		end
	else
		var0_27 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0_27.shipVO.proposeTime, "%Y/%m/%d", true))

		if not IsNil(GetComponent(arg0_27.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_27.intimacyDesc, "VerticalText").enabled = true
			var0_27 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0_27.shipVO.proposeTime, "%Y/%m/%d"))
		end
	end

	return var0_27
end

function var0_0.getProposeItemId(arg0_28)
	if arg0_28.proposeType == "imas" then
		return ITEM_ID_FOR_PROPOSE_IMAS
	else
		return ITEM_ID_FOR_PROPOSE
	end
end

function var0_0.onUpdateItemCount(arg0_29)
	local var0_29 = arg0_29.bagProxy:getItemCountById(arg0_29:getProposeItemId())

	setActive(arg0_29.ringAchieved, arg0_29.shipVO.propose or var0_29 > 0)
	setActive(arg0_29.ringNoAchieved, var0_29 <= 0 and not arg0_29.shipVO.propose)
	setText(arg0_29.ringValue, i18n(arg0_29.proposeType == "imas" and "intimacy_desc_tiara" or "intimacy_desc_ring"))

	if arg0_29.shipVO.propose or var0_29 > 0 then
		setTextColor(arg0_29.ringValue, Color.white)
	else
		setTextColor(arg0_29.ringValue, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
	end

	if arg0_29.proposeType == "imas" then
		local var1_29 = not arg0_29.shipVO.propose and var0_29 == 0

		setActive(arg0_29.window:Find("ringCount/bg_exchange"), var1_29)
		setActive(arg0_29.window:Find("ringCount/icon/btn_exchange"), var1_29)
		onButton(arg0_29, arg0_29.window:Find("ringCount/icon/btn_exchange"), function()
			arg0_29:showExchangePanel()
		end, SFX_PANEL)
	else
		setActive(arg0_29.window:Find("ringCount/icon/base"), PLATFORM_CODE ~= PLATFORM_CH)
		setActive(arg0_29.window:Find("ringCount/icon/hx"), PLATFORM_CODE == PLATFORM_CH)
	end
end

function var0_0.onUpdateIntimacydescTime(arg0_31, arg1_31)
	local var0_31

	if PLATFORM_CODE == PLATFORM_JP then
		if arg0_31.proposeType == "imas" then
			var0_31 = "%Y.%m.%d"
		else
			var0_31 = "%B.%d,    %y"
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		var0_31 = "%B %d, %Y"
	elseif arg0_31.proposeType == "imas" then
		var0_31 = i18n("intimacy_desc_day") .. " %Y.%m.%d"
	else
		var0_31 = "%B.%d,    %y"
	end

	setText(arg0_31.intimacydescTime, pg.TimeMgr.GetInstance():STimeDescS(arg1_31, var0_31))
end

function var0_0.onBackPressed(arg0_32)
	if isActive(arg0_32.exchangePanel) then
		arg0_32:hideExchangePanel()

		return
	end

	if arg0_32.window and isActive(arg0_32.window) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_32._tf:Find("close_end"))
	end
end

function var0_0.willExit(arg0_33)
	if arg0_33._currentVoice then
		arg0_33._currentVoice:PlaybackStop()
	end

	arg0_33._currentVoice = nil

	pg.BgmMgr.GetInstance():ContinuePlay()

	if not IsNil(arg0_33.actorPainting) then
		local var0_33 = tf(arg0_33.actorPainting)

		if var0_33:Find("temp_mask") then
			Destroy(var0_33:Find("temp_mask"))
		end

		var0_33:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0_33.paintingName, arg0_33.actorPainting)

		arg0_33.actorPainting = nil
	end

	if arg0_33.delayTId then
		LeanTween.cancel(arg0_33.delayTId)
	end

	if arg0_33.commonTF then
		setActive(arg0_33.commonTF, true)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_33._tf)

	if arg0_33.l2dChar then
		arg0_33.l2dChar:ClearPics()

		arg0_33.l2dChar = nil
	end

	if arg0_33.live2dRequestId then
		pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_33.live2dRequestId)

		arg0_33.live2dRequestId = nil
	end

	if arg0_33._delayVoiceTweenID then
		LeanTween.cancel(arg0_33._delayVoiceTweenID)

		arg0_33._delayVoiceTweenID = nil
	end

	if arg0_33.tweenList then
		cancelTweens(arg0_33.tweenList)

		arg0_33.tweenList = nil
	end

	if arg0_33.contextData.callback then
		arg0_33.contextData.callback()
	end

	if arg0_33.finishCallback then
		arg0_33.finishCallback()

		arg0_33.finishCallback = nil
	end
end

function var0_0.setMask(arg0_34, arg1_34)
	setActive(arg0_34.maskTF, arg1_34)
end

function var0_0.bgAddAnimation(arg0_35, arg1_35)
	setActive(arg0_35.storybg, true)
	arg0_35:showbgAdd(true, arg1_35)
end

function var0_0.showbgChurch(arg0_36)
	table.insert(arg0_36.tweenList, LeanTween.scale(arg0_36.storybg, Vector3(1, 1, 1), 6).uniqueId)
	setActive(arg0_36.churchLight, true)
	table.insert(arg0_36.tweenList, LeanTween.delayedCall(6, System.Action(function()
		setActive(arg0_36.churchLight, false)
	end)).uniqueId)
end

function var0_0.showbgAdd(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg1_38 and 1 or 0
	local var1_38 = arg1_38 and 0 or 1
	local var2_38 = GetOrAddComponent(arg0_38.bgAdd, typeof(CanvasGroup))

	table.insert(arg0_38.tweenList, LeanTween.alphaCanvas(var2_38, var1_38, arg2_38):setFrom(var0_38).uniqueId)
	setActive(arg0_38.bgAdd, true)
end

function var0_0.showBlackBG(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = arg1_39 and 1 or 0
	local var1_39 = arg1_39 and 0 or 1
	local var2_39 = GetOrAddComponent(arg0_39.blackBG, typeof(CanvasGroup))

	setActive(arg0_39.blackBG, true)
	table.insert(arg0_39.tweenList, LeanTween.alphaCanvas(var2_39, var1_39, arg2_39):setFrom(var0_39):setOnComplete(System.Action(function()
		if arg1_39 then
			setActive(arg0_39.blackBG, false)
		end

		if arg3_39 then
			arg3_39()
		end
	end)).uniqueId)
end

function var0_0.showPainting(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41 = {}

	if arg1_41 then
		table.insert(var0_41, function(arg0_42)
			arg0_41:loadChar(arg0_41.targetActorTF, "duihua", arg0_42)
		end)
	end

	seriesAsync(var0_41, function()
		local var0_43 = arg1_41 and 0 or 1
		local var1_43 = arg1_41 and 1 or 0
		local var2_43 = GetOrAddComponent(arg0_41.targetActorTF, typeof(CanvasGroup))

		table.insert(arg0_41.tweenList, LeanTween.alphaCanvas(var2_43, var1_43, arg2_41):setFrom(var0_43):setOnComplete(System.Action(function()
			if arg3_41 then
				arg3_41()
			end
		end)).uniqueId)
	end)
end

var0_0.Live2DProposeDelayTime = 2

function var0_0.showLive2D(arg0_45, arg1_45)
	setActive(arg0_45.targetActorTF:Find("fitter"), false)
	setActive(arg0_45.targetActorTF:Find("live2d"), true)

	local var0_45 = GetOrAddComponent(arg0_45.targetActorTF, typeof(CanvasGroup))

	table.insert(arg0_45.tweenList, LeanTween.alphaCanvas(var0_45, 1, var0_0.Live2DProposeDelayTime):setFrom(0):setOnComplete(System.Action(function()
		arg0_45:changeParamaterValue("Paramring", 1)
		arg0_45.l2dChar:SetAction(pg.AssistantInfo.action2Id[arg1_45])
	end)).uniqueId)
end

function var0_0.changeParamaterValue(arg0_47, arg1_47, arg2_47)
	if not arg1_47 or string.len(arg1_47) == 0 then
		return
	end

	local var0_47 = arg0_47.l2dChar:GetCubismParameter(arg1_47)

	if not var0_47 then
		return
	end

	arg0_47.l2dChar:AddParameterValue(var0_47, arg2_47, CubismParameterBlendMode.Override)
end

function var0_0.hideWindow(arg0_48)
	local var0_48 = GetOrAddComponent(arg0_48.window, typeof(CanvasGroup))

	var0_48.interactable = false

	table.insert(arg0_48.tweenList, LeanTween.alphaCanvas(var0_48, 0, 0.2):setFrom(1):setOnComplete(System.Action(function()
		var0_48.interactable = true
	end)).uniqueId)
end

function var0_0.stampWindow(arg0_50)
	arg0_50.proposeEndFlag = true

	arg0_50:loadChar(nil, nil, function()
		return
	end)
	setActive(arg0_50.window, true)
	setActive(arg0_50.button, false)
	setActive(arg0_50.giftButton, false)
	setActive(arg0_50.targetActorTF:Find("live2d"), false)

	local var0_50

	if arg0_50.intimacyDescPic then
		setActive(arg0_50.intimacyDescPic, true)

		var0_50 = GetOrAddComponent(arg0_50.intimacyDescPic, typeof(CanvasGroup))
	end

	if arg0_50.intimacyDesc then
		setActive(arg0_50.intimacyDesc, not arg0_50.intimacyDescPic)

		local var1_50 = arg0_50:getProposeText()

		setText(arg0_50.intimacyDesc, var1_50)

		var0_50 = GetOrAddComponent(arg0_50.intimacyDesc, typeof(CanvasGroup))
	end

	setText(arg0_50.intimacyBuffDesc, "")
	setActive(arg0_50.doneTF, false)

	var0_50.alpha = 0

	local var2_50 = GetOrAddComponent(arg0_50.window, typeof(CanvasGroup))

	var2_50.interactable = false

	table.insert(arg0_50.tweenList, LeanTween.alphaCanvas(var2_50, 1, 0.8):setFrom(0).uniqueId)
	table.insert(arg0_50.tweenList, LeanTween.delayedCall(1.5, System.Action(function()
		table.insert(arg0_50.tweenList, LeanTween.alphaCanvas(var0_50, 1, 2):setFrom(0).uniqueId)
	end)).uniqueId)

	arg0_50.delayTId = LeanTween.delayedCall(5, System.Action(function()
		if not var2_50 then
			return
		end

		var2_50.interactable = true

		setActive(arg0_50.doneTF, true)
		arg0_50:setMask(false)
		setActive(arg0_50._tf:Find("close_end"), true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_SEAL)
	end)).id
end

function var0_0.showProposePanel(arg0_54)
	local var0_54 = {}

	arg0_54.proposeSkin = ShipGroup.getProposeSkin(arg0_54.shipGroupID)

	if arg0_54.proposeSkin and arg0_54.actorPainting then
		local var1_54 = tf(arg0_54.actorPainting)

		if var1_54:Find("temp_mask") then
			Destroy(var1_54:Find("temp_mask"))
		end

		var1_54:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0_54.paintingName, arg0_54.actorPainting)

		arg0_54.actorPainting = nil
	end

	if not arg0_54.proposePanel then
		table.insert(var0_54, function(arg0_55)
			local var0_55 = "ProposeRingUI"

			PoolMgr.GetInstance():GetUI(var0_55, true, function(arg0_56)
				if arg0_54.exited then
					PoolMgr.GetInstance():ReturnUI(var0_55, arg0_56)

					return
				end

				arg0_54.proposePanel = tf(arg0_56)

				setParent(tf(arg0_56), arg0_54._tf:Find("contain"))
				eachChild(arg0_54.proposePanel:Find("ringBox"), function(arg0_57)
					setActive(arg0_57, arg0_57.name == arg0_54.proposeType)

					if arg0_57.name == arg0_54.proposeType then
						arg0_54.ringBoxTF = arg0_57
					end
				end)

				arg0_54.ringBoxCG = GetOrAddComponent(arg0_54.ringBoxTF, typeof(CanvasGroup))
				arg0_54.ringBoxFull = arg0_54.ringBoxTF:Find("full")
				arg0_54.churchBefore = arg0_54.proposePanel:Find("before")
				arg0_54.churchLight = arg0_54.churchBefore:Find("light")

				setParent(arg0_54.churchLight, arg0_54._tf)
				arg0_54.churchLight:SetSiblingIndex(2)

				arg0_54.blackBG = arg0_54.churchBefore:Find("blackbg")
				arg0_54.doorLightBG = arg0_54.churchBefore:Find("door_light")
				arg0_54.door = arg0_54.churchBefore:Find("door")
				arg0_54.doorAni = GetOrAddComponent(arg0_54.door, "SpineAnimUI")

				setParent(arg0_54.churchBefore, arg0_54._tf:Find("contain"))

				arg0_54.ringTipTF = arg0_54.proposePanel:Find("tip")
				arg0_54.ringTipCG = GetOrAddComponent(arg0_54.ringTipTF, typeof(CanvasGroup))

				setText(arg0_54.ringTipTF:Find("Text"), i18n(arg0_54.proposeType == "imas" and "word_propose_tiara_tip" or "word_propose_ring_tip"))
				setActive(arg0_54.ringTipTF:Find("finger"), false)
				LoadImageSpriteAsync(arg0_54.bgName, arg0_54.storybg)

				arg0_54.storybg.localScale = Vector3(1.2, 1.2, 1.2)

				local var0_56 = arg0_54.weddingReview and arg0_54.reviewSkinID or arg0_54.shipVO:getSkinId()

				arg0_54.handId = pg.ship_skin_template[var0_56].hand_id

				local var1_56 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y%m%d", true)

				if SPECIAL_PROPOSE and SPECIAL_PROPOSE[1] == var1_56 then
					for iter0_56, iter1_56 in ipairs(SPECIAL_PROPOSE[2]) do
						if iter1_56[1] == var0_56 then
							arg0_54.handId = iter1_56[2]
						end
					end
				end

				local var2_56 = ({
					default = "",
					meta = "Meta_",
					imas = "Imas_"
				})[arg0_54.proposeType] .. "ProposeHand_" .. arg0_54.handId

				arg0_54.handName = var2_56

				PoolMgr.GetInstance():GetUI(var2_56, true, function(arg0_58)
					if arg0_54.exited then
						PoolMgr.GetInstance():ReturnUI(var2_56, arg0_58)

						return
					end

					arg0_54.transHand = tf(arg0_58)

					setActive(arg0_54.transHand, false)
					setParent(arg0_54.transHand, arg0_54.proposePanel)
					arg0_54.transHand:SetAsFirstSibling()

					arg0_54.handTF = arg0_54.transHand:Find("hand")
					arg0_54.ringTF = arg0_54.transHand:Find("ring")
					arg0_54.ringCG = GetOrAddComponent(arg0_54.ringTF, typeof(CanvasGroup))
					arg0_54.ringAnim = arg0_54.ringTF:GetComponent(typeof(Animator))
					arg0_54.ringAnim.enabled = false
					arg0_54.ringLight = arg0_54.ringTF:Find("ring_light")
					arg0_54.ringLightCG = GetOrAddComponent(arg0_54.ringLight, typeof(CanvasGroup))

					arg0_55()
				end)
			end)
		end)
	end

	table.insert(var0_54, function(arg0_59)
		table.insert(arg0_54.tweenList, LeanTween.scale(arg0_54.door, Vector3(2.1, 2.1, 2.1), 4).uniqueId)
		arg0_54.doorAni:SetActionCallBack(function(arg0_60)
			if arg0_60 == "FINISH" then
				arg0_54.doorAni:SetActionCallBack(nil)
				setActive(arg0_54.door, false)
				arg0_54:showBlackBG(true, 0.1)
				setActive(arg0_54.doorLightBG, false)
				arg0_59()
			end
		end)
		table.insert(arg0_54.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0_54:showbgAdd(false, 2)
		end)).uniqueId)
		table.insert(arg0_54.tweenList, LeanTween.alpha(rtf(arg0_54.doorLightBG), 1, 2):setFrom(0).uniqueId)
		arg0_54:showBlackBG(false, 0.1)
		arg0_54.doorAni:SetAction("OPEN", 0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOOR)
	end)
	table.insert(var0_54, function(arg0_62)
		arg0_54.handTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 0)

		arg0_54:bgAddAnimation(2)
		table.insert(arg0_54.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0_54:showPainting(true, 1.5, function()
				table.insert(arg0_54.tweenList, LeanTween.delayedCall(1.5, System.Action(arg0_62)).uniqueId)
			end)
		end)).uniqueId)
	end)
	table.insert(var0_54, function(arg0_65)
		arg0_54:showBlackBG(false, 1.2, function()
			arg0_54:showBlackBG(true, 1.2)
		end)
		arg0_54:showPainting(false, 1, arg0_65)
	end)
	table.insert(var0_54, function(arg0_67)
		setAnchoredPosition(arg0_54.handTF, {
			y = arg0_54.handTF.rect.height
		})
		setAnchoredPosition(arg0_54.ringTF, {
			y = 0
		})
		setActive(arg0_54.proposePanel, true)
		setActive(arg0_54.transHand, true)

		arg0_54.ringBoxCG.alpha = 0
		arg0_54.ringCG.alpha = 0

		arg0_67()
	end)

	if arg0_54.proposeType ~= "imas" then
		table.insert(var0_54, function(arg0_68)
			table.insert(arg0_54.tweenList, LeanTween.alpha(rtf(arg0_54.handTF), 1, 1.2).uniqueId)
			table.insert(arg0_54.tweenList, LeanTween.moveY(rtf(arg0_54.handTF), 0, 2):setOnComplete(System.Action(function()
				table.insert(arg0_54.tweenList, LeanTween.alphaCanvas(arg0_54.ringBoxCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(arg0_68)).uniqueId)
			end)).uniqueId)
		end)
		table.insert(var0_54, function(arg0_70)
			table.insert(arg0_54.tweenList, LeanTween.alpha(rtf(arg0_54.ringBoxFull), 0, 0.6):setOnComplete(System.Action(arg0_70)).uniqueId)
			table.insert(arg0_54.tweenList, LeanTween.alphaCanvas(arg0_54.ringCG, 1, 0.6).uniqueId)
		end)
	end

	table.insert(var0_54, function(arg0_71)
		arg0_54.ringCG.alpha = 1

		arg0_54:setMask(false)
		table.insert(arg0_54.tweenList, LeanTween.delayedCall(0.1, System.Action(arg0_71)).uniqueId)
	end)
	table.insert(var0_54, function(arg0_72)
		arg0_54.ringAnim.enabled = true

		arg0_54.ringAnim:Play("movein")

		local var0_72 = arg0_54.proposeType == "imas" and 1 or 0.5

		table.insert(arg0_54.tweenList, LeanTween.delayedCall(var0_72, System.Action(arg0_72)).uniqueId)
	end)
	seriesAsync(var0_54, function()
		arg0_54.ringAnim:Play("blink")
		table.insert(arg0_54.tweenList, LeanTween.alphaCanvas(arg0_54.ringTipCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(function()
			setActive(arg0_54.ringTipTF:Find("finger"), true)
			arg0_54:enableRingDrag(true)
		end)).uniqueId)
	end)
end

function var0_0.ringOn(arg0_75)
	if arg0_75.isRingOn then
		return
	end

	setActive(arg0_75.ringTipTF, false)

	arg0_75.isRingOn = true

	arg0_75.ringTF:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_76)
		arg0_75.ringAnim.enabled = false
		arg0_75.isRingOn = false

		if not arg0_75.weddingReview then
			arg0_75:emit(ProposeMediator.ON_PROPOSE, arg0_75.shipVO.id)
		else
			arg0_75:RingFadeout()
		end
	end)

	arg0_75.ringAnim.enabled = true

	arg0_75.ringAnim:Play("wear")

	if arg0_75.handId == "101" then
		local var0_75 = GetOrAddComponent(arg0_75.handTF, typeof(CanvasGroup))

		table.insert(arg0_75.tweenList, LeanTween.alphaCanvas(var0_75, 0, 2).uniqueId)
	end
end

function var0_0.enableRingDrag(arg0_77, arg1_77)
	if not arg0_77.press then
		arg0_77:addRingDragListenter()
	end

	arg0_77.press.enabled = arg1_77
end

function var0_0.addRingDragListenter(arg0_78)
	arg0_78.press = GetOrAddComponent(arg0_78.proposePanel, "EventTriggerListener")

	local var0_78

	arg0_78.press:AddBeginDragFunc(function()
		return
	end)
	arg0_78.press:AddDragFunc(function(arg0_80, arg1_80)
		local var0_80 = arg1_80.position

		if not var0_78 then
			var0_78 = var0_80
		end

		if var0_80.y - var0_78.y > 100 then
			arg0_78:setMask(true)
			arg0_78:ringOn()
			arg0_78:enableRingDrag(false)
		end
	end)
	arg0_78.press:AddDragEndFunc(function(arg0_81, arg1_81)
		return
	end)
end

function var0_0.RingFadeout(arg0_82)
	local var0_82 = {}

	if arg0_82.proposeType == "imas" then
		table.insert(var0_82, function(arg0_83)
			local var0_83 = arg0_82.ringLight:GetChild(0)

			setActive(var0_83, true)
			table.insert(arg0_82.tweenList, LeanTween.delayedCall(3.5, System.Action(function()
				setActive(var0_83, false)
				arg0_83()
			end)).uniqueId)
		end)
	else
		table.insert(var0_82, function(arg0_85)
			table.insert(arg0_82.tweenList, LeanTween.alphaCanvas(arg0_82.ringLightCG, 0.7, 0.5):setFrom(0).uniqueId)
			table.insert(arg0_82.tweenList, LeanTween.scale(arg0_82.ringLight, Vector3(8, 8, 8), 1).uniqueId)
			table.insert(arg0_82.tweenList, LeanTween.rotate(arg0_82.ringLight, 90, 3):setOnComplete(System.Action(arg0_85)).uniqueId)
		end)
		table.insert(var0_82, function(arg0_86)
			table.insert(arg0_82.tweenList, LeanTween.delayedCall(0.5, System.Action(arg0_86)).uniqueId)
		end)
	end

	seriesAsync(var0_82, function()
		arg0_82:displayShipWord("propose")
	end)
	table.insert(arg0_82.tweenList, LeanTween.delayedCall(1.2, System.Action(function()
		arg0_82:showbgAdd(false, 1.8)
	end)).uniqueId)
	table.insert(arg0_82.tweenList, LeanTween.delayedCall(3.2, System.Action(function()
		setActive(arg0_82.proposePanel, false)
		arg0_82:showbgAdd(true, 2)
	end)).uniqueId)
end

function var0_0.displayShipWord(arg0_90, arg1_90)
	local var0_90 = ShipGroup.getDefaultSkin(arg0_90.shipGroupID)
	local var1_90, var2_90, var3_90 = ShipWordHelper.GetWordAndCV(var0_90.id, arg1_90)
	local var4_90

	if arg0_90.reviewSkinID then
		var4_90 = arg0_90.reviewSkinID
	elseif arg0_90.proposeSkin then
		var4_90 = arg0_90.proposeSkin.id
	else
		var4_90 = arg0_90.shipVO:getSkinId()
	end

	local var5_90 = ShipWordHelper.GetL2dCvCalibrate(var4_90, arg1_90)

	arg0_90:showStoryUI(var3_90)

	if var2_90 then
		local function var6_90()
			if arg0_90._currentVoice then
				arg0_90._currentVoice:PlaybackStop()
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_90, function(arg0_92)
				arg0_90._currentVoice = arg0_92
			end)
		end

		local var7_90 = var0_0.Live2DProposeDelayTime

		if not arg0_90:useL2dOrPainting() then
			var7_90 = 0
		end

		table.insert(arg0_90.tweenList, LeanTween.delayedCall(var7_90, System.Action(function()
			if arg0_90.l2dChar and var5_90 and var5_90 ~= 0 then
				arg0_90._delayVoiceTweenID = LeanTween.delayedCall(var5_90, System.Action(function()
					var6_90()

					arg0_90._delayVoiceTweenID = nil
				end)).uniqueId
			else
				var6_90()
			end
		end)).uniqueId)
	end
end

function var0_0.useL2dOrPainting(arg0_95)
	return checkABExist("live2d/" .. string.lower(arg0_95.paintingName))
end

function var0_0.showStoryUI(arg0_96, arg1_96)
	local var0_96 = {}

	if not arg0_96.storyTF then
		table.insert(var0_96, function(arg0_97)
			local var0_97 = "ProposeStoryUI"

			PoolMgr.GetInstance():GetUI(var0_97, true, function(arg0_98)
				if arg0_96.exited then
					PoolMgr.GetInstance():ReturnUI(var0_97, arg0_98)

					return
				end

				arg0_96.storyTF = tf(arg0_98)

				setParent(tf(arg0_98), arg0_96._tf:Find("contain"))

				arg0_96.storyCG = GetOrAddComponent(arg0_96.storyTF, typeof(CanvasGroup))
				arg0_96.storyContent = arg0_96.storyTF:Find("dialogue/content")
				arg0_96.typeWriter = arg0_96.storyContent:GetComponent(typeof(Typewriter))
				arg0_96.targetNameTF = arg0_96.storyTF:Find("dialogue/content/name")
				arg0_96._renamePanel = arg0_96.storyTF:Find("changeName_panel")

				setText(findTF(arg0_96._renamePanel, "frame/name_field/Placeholder"), i18n("rename_input"))
				setActive(arg0_96._renamePanel, false)
				onButton(arg0_96, arg0_96.storyTF, function()
					if arg0_96.inTypeWritter then
						arg0_96.typeWriter:setSpeed(arg0_96.typeWritterSpeedUp)

						return
					end

					if not arg0_96.initStory then
						return
					end

					table.insert(arg0_96.tweenList, LeanTween.alphaCanvas(arg0_96.storyCG, 0, 1):setFrom(1):setOnComplete(System.Action(function()
						setActive(arg0_96.storyTF, false)
					end)).uniqueId)

					if arg0_96._currentVoice then
						arg0_96._currentVoice:PlaybackStop()
					end

					arg0_96._currentVoice = nil

					arg0_96:setMask(true)
					table.insert(arg0_96.tweenList, LeanTween.delayedCall(0.5, System.Action(function()
						if arg0_96.weddingReview then
							arg0_96:closeView()
						else
							arg0_96:initChangeNamePanel()
							arg0_96:stampWindow()
						end
					end)).uniqueId)
				end)
				arg0_97()
			end)
		end)
	end

	seriesAsync(var0_96, function()
		if arg0_96:useL2dOrPainting() then
			arg0_96:showLive2D("wedding")
		else
			arg0_96:showPainting(true, 2)
		end

		local var0_102 = ShipGroup.getDefaultShipNameByGroupID(arg0_96.shipGroupID)

		setText(arg0_96.targetNameTF:Find("Text"), var0_102)
		setText(arg0_96.storyContent, "")

		arg0_96.storyCG.alpha = 0

		setActive(arg0_96.storyTF, true)

		arg0_96.initStory = false

		table.insert(arg0_96.tweenList, LeanTween.alphaCanvas(arg0_96.storyCG, 1, 1):setFrom(0):setDelay(1):setOnComplete(System.Action(function()
			if findTF(arg0_96.targetActorTF, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0_96.targetActorTF, "fitter"):GetChild(0), arg0_96.paintingName, "propose")
			end

			setText(arg0_96.storyContent, arg1_96)

			arg0_96.onWords = true

			if arg1_96 and arg1_96 ~= "" then
				arg0_96:TypeWriter()
			end

			arg0_96.initStory = true

			arg0_96:setMask(false)

			if not arg0_96.weddingReview then
				arg0_96:showTip()
			end
		end)).uniqueId)
	end)
end

function var0_0.TypeWriter(arg0_104)
	local var0_104 = 0.1

	arg0_104.inTypeWritter = true
	arg0_104.typeWritterSpeedUp = 0.01

	arg0_104.typeWriter:setSpeed(var0_104)
	arg0_104.typeWriter:Play()

	function arg0_104.typeWriter.endFunc()
		arg0_104.inTypeWritter = false
		arg0_104.typeWritterSpeedUp = nil
	end
end

function var0_0.loadChar(arg0_106, arg1_106, arg2_106, arg3_106)
	arg1_106 = arg1_106 or arg0_106._paintingTF
	arg2_106 = arg2_106 or "wedding"

	local var0_106 = {}

	if not arg0_106.actorPainting then
		table.insert(var0_106, function(arg0_107)
			if arg0_106.reviewSkinID then
				arg0_106.paintingName = pg.ship_skin_template[arg0_106.reviewSkinID].painting
			elseif arg0_106.proposeSkin then
				arg0_106.paintingName = arg0_106.proposeSkin.painting
			else
				arg0_106.paintingName = arg0_106.shipVO:getPainting()
			end

			local var0_107 = arg0_106.paintingName

			if checkABExist("painting/" .. var0_107 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_107, 0) ~= 0 then
				var0_107 = var0_107 .. "_n"
			end

			PoolMgr.GetInstance():GetPainting(var0_107, true, function(arg0_108)
				local var0_108 = findTF(arg0_108, "Touch")

				if not IsNil(var0_108) then
					setActive(var0_108, false)
				end

				arg0_106.actorPainting = arg0_108

				local var1_108 = (arg0_106.weddingReview or arg0_106.shipVO and arg0_106.shipVO.propose) and "propose" or nil

				ShipExpressionHelper.SetExpression(arg0_106.actorPainting, arg0_106.paintingName, var1_108)
				arg0_107()
			end)

			if checkABExist("live2d/" .. string.lower(arg0_106.paintingName)) then
				arg0_106:createLive2D(arg0_106.paintingName)
			end
		end)
	end

	seriesAsync(var0_106, function()
		if not IsNil(arg1_106) then
			local var0_109 = findTF(arg1_106, "fitter")

			assert(var0_109, "请添加子物体fitter")

			local var1_109 = GetOrAddComponent(var0_109, "PaintingScaler")

			var1_109.FrameName = arg2_106
			var1_109.Tween = 1

			setParent(arg0_106.actorPainting, var0_109)
		end

		if arg3_106 then
			arg3_106()
		end
	end)
end

function var0_0.createLive2D(arg0_110, arg1_110)
	arg0_110.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg1_110, function(arg0_111)
		local var0_111 = arg0_111.transform

		GetOrAddComponent(var0_111, typeof(DftAniEvent))

		local var1_111 = arg0_110.targetActorTF:Find("live2d")

		HotfixHelper.SetLayerRecursively(arg0_111, LayerMask.NameToLayer("UI"))
		var0_111:SetParent(var1_111, true)

		local var2_111

		if arg0_110.reviewSkinID then
			var2_111 = arg0_110.reviewSkinID
		elseif arg0_110.proposeSkin then
			var2_111 = arg0_110.proposeSkin.id
		else
			var2_111 = arg0_110.shipVO:getSkinId()
		end

		Live2DPainting.SetL2dSortingLayer(arg0_111, LayerWeightConst.L2D_DEFAULT_LAYER)

		var0_111.localPosition = BuildVector3(pg.ship_skin_template[var2_111].live2d_offset) + Vector3(0, 0, 100)

		local var3_111 = 52

		if pg.ship_skin_template[var2_111].live2d_offset and #pg.ship_skin_template[var2_111].live2d_offset >= 4 then
			var3_111 = pg.ship_skin_template[var2_111].live2d_offset[4]
		end

		var0_111.localScale = Vector3(var3_111, var3_111, var3_111)
		arg0_110.l2dChar = GetComponent(arg0_111, "Live2dChar")
		arg0_110.l2dChar.name = arg1_110

		local var4_111 = pg.AssistantInfo.action2Id.idle

		function arg0_110.l2dChar.FinishAction(arg0_112)
			if var4_111 ~= arg0_112 then
				arg0_110.l2dChar:SetAction(var4_111)
			end
		end

		arg0_110.l2dChar:SetAction(var4_111)

		local var5_111 = pg.ship_skin_template[var2_111]
		local var6_111 = var5_111.lip_sync_gain
		local var7_111 = var5_111.lip_smoothing

		if var6_111 and var6_111 ~= 0 then
			var1_111:GetChild(0):GetComponent("CubismCriSrcMouthInput").Gain = var6_111
		end

		if arg1_110 == "mojiaduoer_4" then
			arg0_110.l2dChar:AddParameterValue(arg0_110.l2dChar:GetCubismParameter("ParamAngleX1"), 3, CubismParameterBlendMode.Override)
			arg0_110.l2dChar:AddParameterValue(arg0_110.l2dChar:GetCubismParameter("touch_drag45"), 7, CubismParameterBlendMode.Override)
		end

		local var8_111 = arg0_110.l2dChar:GetCubismParameter("l2d_hx")

		if var8_111 then
			if HXSet.isHx() then
				arg0_110.l2dChar:AddParameterValue(var8_111, 1, CubismParameterBlendMode.Override)
			else
				arg0_110.l2dChar:AddParameterValue(var8_111, 0, CubismParameterBlendMode.Override)
			end
		end

		if var7_111 and var7_111 ~= 0 then
			var1_111:GetChild(0):GetComponent("CubismCriSrcMouthInput").Smoothing = var7_111
		end
	end)
end

function var0_0.showTip(arg0_113)
	local var0_113 = arg0_113.proposeSkin

	if not var0_113 then
		return
	end

	local var1_113 = arg0_113.storyTF:Find("tip")
	local var2_113 = var1_113:Find("Image_bg/Text")

	setText(var2_113, i18n("achieve_propose_tip", var0_113.name))
	eachChild(var1_113:Find("Image_bg/Image"), function(arg0_114)
		setActive(arg0_114, arg0_114.name == arg0_113.proposeType)
	end)

	local var3_113 = GetOrAddComponent(var1_113, typeof(CanvasGroup))

	setActive(var1_113, true)
	table.insert(arg0_113.tweenList, LeanTween.alphaCanvas(var3_113, 1, 0.01):setFrom(0).uniqueId)
	table.insert(arg0_113.tweenList, LeanTween.alphaCanvas(var3_113, 0, 1.5):setFrom(1):setDelay(4).uniqueId)
end

function var0_0.initChangeNamePanel(arg0_115)
	setText(arg0_115._renamePanel:Find("frame/border/title"), i18n("word_propose_changename_title", arg0_115.shipVO:getName()))
	setText(arg0_115._renamePanel:Find("frame/setting_ship_name/text"), i18n("word_propose_changename_tip1"))
	setText(arg0_115._renamePanel:Find("frame/text"), i18n("word_propose_changename_tip2"))

	arg0_115._renameConfirmBtn = arg0_115._renamePanel:Find("frame/queren")
	arg0_115._renameCancelBtn = arg0_115._renamePanel:Find("frame/cancel")
	arg0_115._renameToggle = findTF(arg0_115._renamePanel, "frame/setting_ship_name"):GetComponent(typeof(Toggle))
	arg0_115._renameRevert = arg0_115._renamePanel:Find("frame/revert_button")
	arg0_115._closeBtn = arg0_115._renamePanel:Find("frame/close_btn")

	onButton(arg0_115, arg0_115._renameConfirmBtn, function()
		local var0_116 = getInputText(findTF(arg0_115._renamePanel, "frame/name_field"))

		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg0_115._renameToggle.isOn)
		arg0_115:emit(ProposeMediator.RENAME_SHIP, arg0_115.shipVO.id, var0_116)
	end, SFX_CONFIRM)
	onButton(arg0_115, arg0_115._renameRevert, function()
		local var0_117 = arg0_115.shipVO:isRemoulded() and pg.ship_skin_template[arg0_115.shipVO:getRemouldSkinId()].name or pg.ship_data_statistics[arg0_115.shipVO.configId].name

		setInputText(findTF(arg0_115._renamePanel, "frame/name_field"), var0_117)
	end, SFX_PANEL)
	onButton(arg0_115, arg0_115._renameCancelBtn, function()
		arg0_115:closeView()
	end, SFX_CANCEL)
	onButton(arg0_115, arg0_115._closeBtn, function()
		arg0_115:closeView()
	end, SFX_CANCEL)
end

function var0_0.DisplayRenamePanel(arg0_120)
	if arg0_120.shipVO:IsXIdol() then
		arg0_120:closeView()
	else
		setParent(arg0_120._renamePanel, arg0_120._tf)
		setActive(arg0_120._renamePanel, true)

		local var0_120 = arg0_120.shipVO:getName()

		setInputText(findTF(arg0_120._renamePanel, "frame/name_field"), var0_120)
		setIntimacyIcon(arg0_120.intimacyTF, arg0_120.shipVO:getIntimacyIcon())
	end
end

function var0_0.showExchangePanel(arg0_121)
	setActive(arg0_121.exchangePanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_121.exchangePanel)
end

function var0_0.hideExchangePanel(arg0_122)
	setActive(arg0_122.exchangePanel, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_122.exchangePanel, arg0_122._tf)
end

function var0_0.checkPaintingRes(arg0_123, arg1_123, arg2_123)
	local var0_123 = {}
	local var1_123 = arg1_123:getProposeSkin()

	if var1_123 and var1_123.id > 0 then
		local var2_123 = var1_123.id

		PaintingGroupConst.AddPaintingNameBySkinID(var0_123, var2_123)
	end

	local var3_123 = {
		isShowBox = true,
		paintingNameList = var0_123,
		finishFunc = arg2_123
	}

	PaintingGroupConst.PaintingDownload(var3_123)
end

return var0_0
