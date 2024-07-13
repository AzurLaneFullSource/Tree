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
	arg0_7.storybg = arg0_7:findTF("close/bg")
	arg0_7.bgAdd = arg0_7:findTF("add")

	setActive(arg0_7.storybg, false)
	setActive(arg0_7.bgAdd, false)

	arg0_7.targetActorTF = arg0_7:findTF("actor_middle")
	arg0_7.maskTF = arg0_7:findTF("mask")
	arg0_7.skipBtn = arg0_7:findTF("skip_button")
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
	onButton(arg0_16, arg0_16:findTF("close0"), function()
		if arg0_16.proposeEndFlag then
			arg0_16:DisplayRenamePanel()
		else
			arg0_16:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16:findTF("close_end"), function()
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

		setParent(tf(arg0_20), arg0_16:findTF("window"))

		arg0_16.intimacyTF = arg0_16:findTF("intimacy/icon", arg0_16.window)
		arg0_16.intimacyValueTF = arg0_16:findTF("intimacy/value", arg0_16.window)
		arg0_16.button = arg0_16:findTF("button", arg0_16.window)
		arg0_16.intimacyDesc = arg0_16:findTF("desc", arg0_16.window)
		arg0_16.intimacydescTime = arg0_16:findTF("descPic/desc_time", arg0_16.window)
		arg0_16.intimacyDescPic = arg0_16:findTF("descPic", arg0_16.window)
		arg0_16.intimacyBuffDesc = arg0_16:findTF("desc_buff", arg0_16.window)
		arg0_16._paintingTF = arg0_16:findTF("paintMask/paint", arg0_16.window)
		arg0_16.intimacyAchieved = arg0_16:findTF("intimacy/achieved", arg0_16.window)
		arg0_16.intimacyNoAchieved = arg0_16:findTF("intimacy/no_achieved", arg0_16.window)
		arg0_16.ringAchieved = arg0_16:findTF("ringCount/achieved", arg0_16.window)
		arg0_16.ringNoAchieved = arg0_16:findTF("ringCount/no_achieved", arg0_16.window)
		arg0_16.ringValue = arg0_16:findTF("ringCount/value", arg0_16.window)
		arg0_16.nameTF = arg0_16:findTF("title1/Text", arg0_16.window)
		arg0_16.shipNameTF = arg0_16:findTF("title2/Text", arg0_16.window)
		arg0_16.campTF = arg0_16:findTF("Camp", arg0_16.window)
		arg0_16.doneTF = arg0_16:findTF("done", arg0_16.window)
		arg0_16.CampSprite = arg0_16:findTF("CampSprite", arg0_16.window)

		setActive(arg0_16.window, true)
		setText(arg0_16.nameTF, arg0_16.player.name)
		setText(arg0_16.shipNameTF, arg0_16.shipVO:getName())

		if arg0_16.CampSprite then
			local var0_20 = getImageSprite(arg0_16:findTF(Nation.Nation2Print(var0_16), arg0_16.CampSprite))

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
		pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
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
	end)
end

function var0_0.getProposeText(arg0_25)
	local var0_25 = ""

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		var0_25 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():ChieseDescTime(arg0_25.shipVO.proposeTime, true))

		if not IsNil(GetComponent(arg0_25.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_25.intimacyDesc, "VerticalText").enabled = true
			var0_25 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():ChieseDescTime(arg0_25.shipVO.proposeTime, true))
		end
	elseif PLATFORM_CODE == PLATFORM_KR then
		var0_25 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0_25.shipVO.proposeTime, "%Y년%m월%d일", true))

		if not IsNil(GetComponent(arg0_25.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_25.intimacyDesc, "VerticalText").enabled = true
			var0_25 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0_25.shipVO.proposeTime, "%Y년%m월%d일"))
		end
	else
		var0_25 = i18n("intimacy_desc_propose", pg.TimeMgr.GetInstance():STimeDescS(arg0_25.shipVO.proposeTime, "%Y/%m/%d", true))

		if not IsNil(GetComponent(arg0_25.intimacyDesc, "VerticalText")) then
			GetComponent(arg0_25.intimacyDesc, "VerticalText").enabled = true
			var0_25 = i18n("intimacy_desc_propose_vertical", pg.TimeMgr.GetInstance():STimeDescS(arg0_25.shipVO.proposeTime, "%Y/%m/%d"))
		end
	end

	return var0_25
end

function var0_0.getProposeItemId(arg0_26)
	if arg0_26.proposeType == "imas" then
		return ITEM_ID_FOR_PROPOSE_IMAS
	else
		return ITEM_ID_FOR_PROPOSE
	end
end

function var0_0.onUpdateItemCount(arg0_27)
	local var0_27 = arg0_27.bagProxy:getItemCountById(arg0_27:getProposeItemId())

	setActive(arg0_27.ringAchieved, arg0_27.shipVO.propose or var0_27 > 0)
	setActive(arg0_27.ringNoAchieved, var0_27 <= 0 and not arg0_27.shipVO.propose)
	setText(arg0_27.ringValue, i18n(arg0_27.proposeType == "imas" and "intimacy_desc_tiara" or "intimacy_desc_ring"))

	if arg0_27.shipVO.propose or var0_27 > 0 then
		setTextColor(arg0_27.ringValue, Color.white)
	else
		setTextColor(arg0_27.ringValue, Color.New(0.584313725490196, 0.52156862745098, 0.407843137254902))
	end

	if arg0_27.proposeType == "imas" then
		local var1_27 = not arg0_27.shipVO.propose and var0_27 == 0

		setActive(arg0_27.window:Find("ringCount/bg_exchange"), var1_27)
		setActive(arg0_27.window:Find("ringCount/icon/btn_exchange"), var1_27)
		onButton(arg0_27, arg0_27.window:Find("ringCount/icon/btn_exchange"), function()
			arg0_27:showExchangePanel()
		end, SFX_PANEL)
	else
		setActive(arg0_27.window:Find("ringCount/icon/base"), PLATFORM_CODE ~= PLATFORM_CH)
		setActive(arg0_27.window:Find("ringCount/icon/hx"), PLATFORM_CODE == PLATFORM_CH)
	end
end

function var0_0.onUpdateIntimacydescTime(arg0_29, arg1_29)
	local var0_29

	if PLATFORM_CODE == PLATFORM_JP then
		if arg0_29.proposeType == "imas" then
			var0_29 = "%Y.%m.%d"
		else
			var0_29 = "%B.%d,    %y"
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		var0_29 = "%B %d, %Y"
	elseif arg0_29.proposeType == "imas" then
		var0_29 = i18n("intimacy_desc_day") .. " %Y.%m.%d"
	else
		var0_29 = "%B.%d,    %y"
	end

	setText(arg0_29.intimacydescTime, pg.TimeMgr.GetInstance():STimeDescS(arg1_29, var0_29))
end

function var0_0.onBackPressed(arg0_30)
	if isActive(arg0_30.exchangePanel) then
		arg0_30:hideExchangePanel()

		return
	end

	if arg0_30.window and isActive(arg0_30.window) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_30:findTF("close_end"))
	end
end

function var0_0.willExit(arg0_31)
	if arg0_31._currentVoice then
		arg0_31._currentVoice:PlaybackStop()
	end

	arg0_31._currentVoice = nil

	pg.BgmMgr.GetInstance():ContinuePlay()

	if not IsNil(arg0_31.actorPainting) then
		local var0_31 = tf(arg0_31.actorPainting)

		if var0_31:Find("temp_mask") then
			Destroy(var0_31:Find("temp_mask"))
		end

		var0_31:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0_31.paintingName, arg0_31.actorPainting)

		arg0_31.actorPainting = nil
	end

	if arg0_31.delayTId then
		LeanTween.cancel(arg0_31.delayTId)
	end

	if arg0_31.commonTF then
		setActive(arg0_31.commonTF, true)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_31._tf)

	if arg0_31.l2dChar then
		arg0_31.l2dChar:ClearPics()

		arg0_31.l2dChar = nil
	end

	pg.Live2DMgr.GetInstance():StopLoadingLive2d(arg0_31.live2dRequestId)

	arg0_31.live2dRequestId = nil

	if arg0_31._delayVoiceTweenID then
		LeanTween.cancel(arg0_31._delayVoiceTweenID)

		arg0_31._delayVoiceTweenID = nil
	end

	if arg0_31.tweenList then
		cancelTweens(arg0_31.tweenList)

		arg0_31.tweenList = nil
	end

	if arg0_31.contextData.callback then
		arg0_31.contextData.callback()
	end

	if arg0_31.finishCallback then
		arg0_31.finishCallback()

		arg0_31.finishCallback = nil
	end
end

function var0_0.setMask(arg0_32, arg1_32)
	setActive(arg0_32.maskTF, arg1_32)
end

function var0_0.bgAddAnimation(arg0_33, arg1_33)
	setActive(arg0_33.storybg, true)
	arg0_33:showbgAdd(true, arg1_33)
end

function var0_0.showbgChurch(arg0_34)
	table.insert(arg0_34.tweenList, LeanTween.scale(arg0_34.storybg, Vector3(1, 1, 1), 6).uniqueId)
	setActive(arg0_34.churchLight, true)
	table.insert(arg0_34.tweenList, LeanTween.delayedCall(6, System.Action(function()
		setActive(arg0_34.churchLight, false)
	end)).uniqueId)
end

function var0_0.showbgAdd(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg1_36 and 1 or 0
	local var1_36 = arg1_36 and 0 or 1
	local var2_36 = GetOrAddComponent(arg0_36.bgAdd, typeof(CanvasGroup))

	table.insert(arg0_36.tweenList, LeanTween.alphaCanvas(var2_36, var1_36, arg2_36):setFrom(var0_36).uniqueId)
	setActive(arg0_36.bgAdd, true)
end

function var0_0.showBlackBG(arg0_37, arg1_37, arg2_37, arg3_37)
	local var0_37 = arg1_37 and 1 or 0
	local var1_37 = arg1_37 and 0 or 1
	local var2_37 = GetOrAddComponent(arg0_37.blackBG, typeof(CanvasGroup))

	setActive(arg0_37.blackBG, true)
	table.insert(arg0_37.tweenList, LeanTween.alphaCanvas(var2_37, var1_37, arg2_37):setFrom(var0_37):setOnComplete(System.Action(function()
		if arg1_37 then
			setActive(arg0_37.blackBG, false)
		end

		if arg3_37 then
			arg3_37()
		end
	end)).uniqueId)
end

function var0_0.showPainting(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = {}

	if arg1_39 then
		table.insert(var0_39, function(arg0_40)
			arg0_39:loadChar(arg0_39.targetActorTF, "duihua", arg0_40)
		end)
	end

	seriesAsync(var0_39, function()
		local var0_41 = arg1_39 and 0 or 1
		local var1_41 = arg1_39 and 1 or 0
		local var2_41 = GetOrAddComponent(arg0_39.targetActorTF, typeof(CanvasGroup))

		table.insert(arg0_39.tweenList, LeanTween.alphaCanvas(var2_41, var1_41, arg2_39):setFrom(var0_41):setOnComplete(System.Action(function()
			if arg3_39 then
				arg3_39()
			end
		end)).uniqueId)
	end)
end

var0_0.Live2DProposeDelayTime = 2

function var0_0.showLive2D(arg0_43, arg1_43)
	setActive(arg0_43:findTF("fitter", arg0_43.targetActorTF), false)
	setActive(arg0_43:findTF("live2d", arg0_43.targetActorTF), true)

	local var0_43 = GetOrAddComponent(arg0_43.targetActorTF, typeof(CanvasGroup))

	table.insert(arg0_43.tweenList, LeanTween.alphaCanvas(var0_43, 1, var0_0.Live2DProposeDelayTime):setFrom(0):setOnComplete(System.Action(function()
		arg0_43:changeParamaterValue("Paramring", 1)
		arg0_43.l2dChar:SetAction(pg.AssistantInfo.action2Id[arg1_43])
	end)).uniqueId)
end

function var0_0.changeParamaterValue(arg0_45, arg1_45, arg2_45)
	if not arg1_45 or string.len(arg1_45) == 0 then
		return
	end

	local var0_45 = arg0_45.l2dChar:GetCubismParameter(arg1_45)

	if not var0_45 then
		return
	end

	arg0_45.l2dChar:AddParameterValue(var0_45, arg2_45, CubismParameterBlendMode.Override)
end

function var0_0.hideWindow(arg0_46)
	local var0_46 = GetOrAddComponent(arg0_46.window, typeof(CanvasGroup))

	var0_46.interactable = false

	table.insert(arg0_46.tweenList, LeanTween.alphaCanvas(var0_46, 0, 0.2):setFrom(1):setOnComplete(System.Action(function()
		var0_46.interactable = true
	end)).uniqueId)
end

function var0_0.stampWindow(arg0_48)
	arg0_48.proposeEndFlag = true

	arg0_48:loadChar(nil, nil, function()
		return
	end)
	setActive(arg0_48.window, true)
	setActive(arg0_48.button, false)
	setActive(arg0_48:findTF("live2d", arg0_48.targetActorTF), false)

	local var0_48

	if arg0_48.intimacyDescPic then
		setActive(arg0_48.intimacyDescPic, true)

		var0_48 = GetOrAddComponent(arg0_48.intimacyDescPic, typeof(CanvasGroup))
	end

	if arg0_48.intimacyDesc then
		setActive(arg0_48.intimacyDesc, not arg0_48.intimacyDescPic)

		local var1_48 = arg0_48:getProposeText()

		setText(arg0_48.intimacyDesc, var1_48)

		var0_48 = GetOrAddComponent(arg0_48.intimacyDesc, typeof(CanvasGroup))
	end

	setText(arg0_48.intimacyBuffDesc, "")
	setActive(arg0_48.doneTF, false)

	var0_48.alpha = 0

	local var2_48 = GetOrAddComponent(arg0_48.window, typeof(CanvasGroup))

	var2_48.interactable = false

	table.insert(arg0_48.tweenList, LeanTween.alphaCanvas(var2_48, 1, 0.8):setFrom(0).uniqueId)
	table.insert(arg0_48.tweenList, LeanTween.delayedCall(1.5, System.Action(function()
		table.insert(arg0_48.tweenList, LeanTween.alphaCanvas(var0_48, 1, 2):setFrom(0).uniqueId)
	end)).uniqueId)

	arg0_48.delayTId = LeanTween.delayedCall(5, System.Action(function()
		if not var2_48 then
			return
		end

		var2_48.interactable = true

		setActive(arg0_48.doneTF, true)
		arg0_48:setMask(false)
		setActive(arg0_48:findTF("close_end"), true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_SEAL)
	end)).id
end

function var0_0.showProposePanel(arg0_52)
	local var0_52 = {}

	arg0_52.proposeSkin = ShipGroup.getProposeSkin(arg0_52.shipGroupID)

	if arg0_52.proposeSkin and arg0_52.actorPainting then
		local var1_52 = tf(arg0_52.actorPainting)

		if var1_52:Find("temp_mask") then
			Destroy(var1_52:Find("temp_mask"))
		end

		var1_52:GetComponent(typeof(Image)).material = nil

		PoolMgr.GetInstance():ReturnPainting(arg0_52.paintingName, arg0_52.actorPainting)

		arg0_52.actorPainting = nil
	end

	if not arg0_52.proposePanel then
		table.insert(var0_52, function(arg0_53)
			local var0_53 = "ProposeRingUI"

			PoolMgr.GetInstance():GetUI(var0_53, true, function(arg0_54)
				if arg0_52.exited then
					PoolMgr.GetInstance():ReturnUI(var0_53, arg0_54)

					return
				end

				arg0_52.proposePanel = tf(arg0_54)

				setParent(tf(arg0_54), arg0_52:findTF("contain"))
				eachChild(arg0_52.proposePanel:Find("ringBox"), function(arg0_55)
					setActive(arg0_55, arg0_55.name == arg0_52.proposeType)

					if arg0_55.name == arg0_52.proposeType then
						arg0_52.ringBoxTF = arg0_55
					end
				end)

				arg0_52.ringBoxCG = GetOrAddComponent(arg0_52.ringBoxTF, typeof(CanvasGroup))
				arg0_52.ringBoxFull = arg0_52:findTF("full", arg0_52.ringBoxTF)
				arg0_52.churchBefore = arg0_52:findTF("before", arg0_52.proposePanel)
				arg0_52.churchLight = arg0_52:findTF("light", arg0_52.churchBefore)

				setParent(arg0_52.churchLight, arg0_52._tf)
				arg0_52.churchLight:SetSiblingIndex(2)

				arg0_52.blackBG = arg0_52:findTF("blackbg", arg0_52.churchBefore)
				arg0_52.doorLightBG = arg0_52:findTF("door_light", arg0_52.churchBefore)
				arg0_52.door = arg0_52:findTF("door", arg0_52.churchBefore)
				arg0_52.doorAni = GetOrAddComponent(arg0_52.door, "SpineAnimUI")

				setParent(arg0_52.churchBefore, arg0_52:findTF("contain"))

				arg0_52.ringTipTF = arg0_52:findTF("tip", arg0_52.proposePanel)
				arg0_52.ringTipCG = GetOrAddComponent(arg0_52.ringTipTF, typeof(CanvasGroup))

				setText(arg0_52:findTF("Text", arg0_52.ringTipTF), i18n(arg0_52.proposeType == "imas" and "word_propose_tiara_tip" or "word_propose_ring_tip"))
				setActive(arg0_52:findTF("finger", arg0_52.ringTipTF), false)
				LoadImageSpriteAsync(arg0_52.bgName, arg0_52.storybg)

				arg0_52.storybg.localScale = Vector3(1.2, 1.2, 1.2)

				local var0_54 = arg0_52.weddingReview and arg0_52.reviewSkinID or arg0_52.shipVO.skinId

				arg0_52.handId = pg.ship_skin_template[var0_54].hand_id

				local var1_54 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y%m%d", true)

				if SPECIAL_PROPOSE and SPECIAL_PROPOSE[1] == var1_54 then
					for iter0_54, iter1_54 in ipairs(SPECIAL_PROPOSE[2]) do
						if iter1_54[1] == var0_54 then
							arg0_52.handId = iter1_54[2]
						end
					end
				end

				local var2_54 = ({
					default = "",
					meta = "Meta_",
					imas = "Imas_"
				})[arg0_52.proposeType] .. "ProposeHand_" .. arg0_52.handId

				arg0_52.handName = var2_54

				PoolMgr.GetInstance():GetUI(var2_54, true, function(arg0_56)
					if arg0_52.exited then
						PoolMgr.GetInstance():ReturnUI(var2_54, arg0_56)

						return
					end

					arg0_52.transHand = tf(arg0_56)

					setActive(arg0_52.transHand, false)
					setParent(arg0_52.transHand, arg0_52.proposePanel)
					arg0_52.transHand:SetAsFirstSibling()

					arg0_52.handTF = arg0_52:findTF("hand", arg0_52.transHand)
					arg0_52.ringTF = arg0_52:findTF("ring", arg0_52.transHand)
					arg0_52.ringCG = GetOrAddComponent(arg0_52.ringTF, typeof(CanvasGroup))
					arg0_52.ringAnim = arg0_52.ringTF:GetComponent(typeof(Animator))
					arg0_52.ringAnim.enabled = false
					arg0_52.ringLight = arg0_52:findTF("ring_light", arg0_52.ringTF)
					arg0_52.ringLightCG = GetOrAddComponent(arg0_52.ringLight, typeof(CanvasGroup))

					arg0_53()
				end)
			end)
		end)
	end

	table.insert(var0_52, function(arg0_57)
		table.insert(arg0_52.tweenList, LeanTween.scale(arg0_52.door, Vector3(2.1, 2.1, 2.1), 4).uniqueId)
		arg0_52.doorAni:SetActionCallBack(function(arg0_58)
			if arg0_58 == "FINISH" then
				arg0_52.doorAni:SetActionCallBack(nil)
				setActive(arg0_52.door, false)
				arg0_52:showBlackBG(true, 0.1)
				setActive(arg0_52.doorLightBG, false)
				arg0_57()
			end
		end)
		table.insert(arg0_52.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0_52:showbgAdd(false, 2)
		end)).uniqueId)
		table.insert(arg0_52.tweenList, LeanTween.alpha(rtf(arg0_52.doorLightBG), 1, 2):setFrom(0).uniqueId)
		arg0_52:showBlackBG(false, 0.1)
		arg0_52.doorAni:SetAction("OPEN", 0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOOR)
	end)
	table.insert(var0_52, function(arg0_60)
		arg0_52.handTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 0)

		arg0_52:bgAddAnimation(2)
		table.insert(arg0_52.tweenList, LeanTween.delayedCall(2, System.Action(function()
			arg0_52:showPainting(true, 1.5, function()
				table.insert(arg0_52.tweenList, LeanTween.delayedCall(1.5, System.Action(arg0_60)).uniqueId)
			end)
		end)).uniqueId)
	end)
	table.insert(var0_52, function(arg0_63)
		arg0_52:showBlackBG(false, 1.2, function()
			arg0_52:showBlackBG(true, 1.2)
		end)
		arg0_52:showPainting(false, 1, arg0_63)
	end)
	table.insert(var0_52, function(arg0_65)
		setAnchoredPosition(arg0_52.handTF, {
			y = arg0_52.handTF.rect.height
		})
		setAnchoredPosition(arg0_52.ringTF, {
			y = 0
		})
		setActive(arg0_52.proposePanel, true)
		setActive(arg0_52.transHand, true)

		arg0_52.ringBoxCG.alpha = 0
		arg0_52.ringCG.alpha = 0

		arg0_65()
	end)

	if arg0_52.proposeType ~= "imas" then
		table.insert(var0_52, function(arg0_66)
			table.insert(arg0_52.tweenList, LeanTween.alpha(rtf(arg0_52.handTF), 1, 1.2).uniqueId)
			table.insert(arg0_52.tweenList, LeanTween.moveY(rtf(arg0_52.handTF), 0, 2):setOnComplete(System.Action(function()
				table.insert(arg0_52.tweenList, LeanTween.alphaCanvas(arg0_52.ringBoxCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(arg0_66)).uniqueId)
			end)).uniqueId)
		end)
		table.insert(var0_52, function(arg0_68)
			table.insert(arg0_52.tweenList, LeanTween.alpha(rtf(arg0_52.ringBoxFull), 0, 0.6):setOnComplete(System.Action(arg0_68)).uniqueId)
			table.insert(arg0_52.tweenList, LeanTween.alphaCanvas(arg0_52.ringCG, 1, 0.6).uniqueId)
		end)
	end

	table.insert(var0_52, function(arg0_69)
		arg0_52.ringCG.alpha = 1

		arg0_52:setMask(false)
		table.insert(arg0_52.tweenList, LeanTween.delayedCall(0.1, System.Action(arg0_69)).uniqueId)
	end)
	table.insert(var0_52, function(arg0_70)
		arg0_52.ringAnim.enabled = true

		arg0_52.ringAnim:Play("movein")

		local var0_70 = arg0_52.proposeType == "imas" and 1 or 0.5

		table.insert(arg0_52.tweenList, LeanTween.delayedCall(var0_70, System.Action(arg0_70)).uniqueId)
	end)
	seriesAsync(var0_52, function()
		arg0_52.ringAnim:Play("blink")
		table.insert(arg0_52.tweenList, LeanTween.alphaCanvas(arg0_52.ringTipCG, 1, 1.5):setFrom(0):setOnComplete(System.Action(function()
			setActive(arg0_52:findTF("finger", arg0_52.ringTipTF), true)
			arg0_52:enableRingDrag(true)
		end)).uniqueId)
	end)
end

function var0_0.ringOn(arg0_73)
	if arg0_73.isRingOn then
		return
	end

	setActive(arg0_73.ringTipTF, false)

	arg0_73.isRingOn = true

	arg0_73.ringTF:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_74)
		arg0_73.ringAnim.enabled = false
		arg0_73.isRingOn = false

		if not arg0_73.weddingReview then
			arg0_73:emit(ProposeMediator.ON_PROPOSE, arg0_73.shipVO.id)
		else
			arg0_73:RingFadeout()
		end
	end)

	arg0_73.ringAnim.enabled = true

	arg0_73.ringAnim:Play("wear")

	if arg0_73.handId == "101" then
		local var0_73 = GetOrAddComponent(arg0_73.handTF, typeof(CanvasGroup))

		table.insert(arg0_73.tweenList, LeanTween.alphaCanvas(var0_73, 0, 2).uniqueId)
	end
end

function var0_0.enableRingDrag(arg0_75, arg1_75)
	if not arg0_75.press then
		arg0_75:addRingDragListenter()
	end

	arg0_75.press.enabled = arg1_75
end

function var0_0.addRingDragListenter(arg0_76)
	arg0_76.press = GetOrAddComponent(arg0_76.proposePanel, "EventTriggerListener")

	local var0_76

	arg0_76.press:AddBeginDragFunc(function()
		return
	end)
	arg0_76.press:AddDragFunc(function(arg0_78, arg1_78)
		local var0_78 = arg1_78.position

		if not var0_76 then
			var0_76 = var0_78
		end

		if var0_78.y - var0_76.y > 100 then
			arg0_76:setMask(true)
			arg0_76:ringOn()
			arg0_76:enableRingDrag(false)
		end
	end)
	arg0_76.press:AddDragEndFunc(function(arg0_79, arg1_79)
		return
	end)
end

function var0_0.RingFadeout(arg0_80)
	local var0_80 = {}

	if arg0_80.proposeType == "imas" then
		table.insert(var0_80, function(arg0_81)
			local var0_81 = arg0_80.ringLight:GetChild(0)

			setActive(var0_81, true)
			table.insert(arg0_80.tweenList, LeanTween.delayedCall(3.5, System.Action(function()
				setActive(var0_81, false)
				arg0_81()
			end)).uniqueId)
		end)
	else
		table.insert(var0_80, function(arg0_83)
			table.insert(arg0_80.tweenList, LeanTween.alphaCanvas(arg0_80.ringLightCG, 0.7, 0.5):setFrom(0).uniqueId)
			table.insert(arg0_80.tweenList, LeanTween.scale(arg0_80.ringLight, Vector3(8, 8, 8), 1).uniqueId)
			table.insert(arg0_80.tweenList, LeanTween.rotate(arg0_80.ringLight, 90, 3):setOnComplete(System.Action(arg0_83)).uniqueId)
		end)
		table.insert(var0_80, function(arg0_84)
			table.insert(arg0_80.tweenList, LeanTween.delayedCall(0.5, System.Action(arg0_84)).uniqueId)
		end)
	end

	seriesAsync(var0_80, function()
		arg0_80:displayShipWord("propose")
	end)
	table.insert(arg0_80.tweenList, LeanTween.delayedCall(1.2, System.Action(function()
		arg0_80:showbgAdd(false, 1.8)
	end)).uniqueId)
	table.insert(arg0_80.tweenList, LeanTween.delayedCall(3.2, System.Action(function()
		setActive(arg0_80.proposePanel, false)
		arg0_80:showbgAdd(true, 2)
	end)).uniqueId)
end

function var0_0.displayShipWord(arg0_88, arg1_88)
	local var0_88 = ShipGroup.getDefaultSkin(arg0_88.shipGroupID)
	local var1_88, var2_88, var3_88 = ShipWordHelper.GetWordAndCV(var0_88.id, arg1_88)
	local var4_88

	if arg0_88.reviewSkinID then
		var4_88 = arg0_88.reviewSkinID
	elseif arg0_88.proposeSkin then
		var4_88 = arg0_88.proposeSkin.id
	else
		var4_88 = arg0_88.shipVO.skinId
	end

	local var5_88 = ShipWordHelper.GetL2dCvCalibrate(var4_88, arg1_88)

	arg0_88:showStoryUI(var3_88)

	if var2_88 then
		local function var6_88()
			if arg0_88._currentVoice then
				arg0_88._currentVoice:PlaybackStop()
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_88, function(arg0_90)
				arg0_88._currentVoice = arg0_90
			end)
		end

		local var7_88 = var0_0.Live2DProposeDelayTime

		if not arg0_88:useL2dOrPainting() then
			var7_88 = 0
		end

		table.insert(arg0_88.tweenList, LeanTween.delayedCall(var7_88, System.Action(function()
			if arg0_88.l2dChar and var5_88 and var5_88 ~= 0 then
				arg0_88._delayVoiceTweenID = LeanTween.delayedCall(var5_88, System.Action(function()
					var6_88()

					arg0_88._delayVoiceTweenID = nil
				end)).uniqueId
			else
				var6_88()
			end
		end)).uniqueId)
	end
end

function var0_0.useL2dOrPainting(arg0_93)
	return checkABExist("live2d/" .. string.lower(arg0_93.paintingName))
end

function var0_0.showStoryUI(arg0_94, arg1_94)
	local var0_94 = {}

	if not arg0_94.storyTF then
		table.insert(var0_94, function(arg0_95)
			local var0_95 = "ProposeStoryUI"

			PoolMgr.GetInstance():GetUI(var0_95, true, function(arg0_96)
				if arg0_94.exited then
					PoolMgr.GetInstance():ReturnUI(var0_95, arg0_96)

					return
				end

				arg0_94.storyTF = tf(arg0_96)

				setParent(tf(arg0_96), arg0_94:findTF("contain"))

				arg0_94.storyCG = GetOrAddComponent(arg0_94.storyTF, typeof(CanvasGroup))
				arg0_94.storyContent = arg0_94:findTF("dialogue/content", arg0_94.storyTF)
				arg0_94.typeWriter = arg0_94.storyContent:GetComponent(typeof(Typewriter))
				arg0_94.targetNameTF = arg0_94:findTF("dialogue/content/name", arg0_94.storyTF)
				arg0_94._renamePanel = arg0_94:findTF("changeName_panel", arg0_94.storyTF)

				setText(findTF(arg0_94._renamePanel, "frame/name_field/Placeholder"), i18n("rename_input"))
				setActive(arg0_94._renamePanel, false)
				onButton(arg0_94, arg0_94.storyTF, function()
					if arg0_94.inTypeWritter then
						arg0_94.typeWriter:setSpeed(arg0_94.typeWritterSpeedUp)

						return
					end

					if not arg0_94.initStory then
						return
					end

					table.insert(arg0_94.tweenList, LeanTween.alphaCanvas(arg0_94.storyCG, 0, 1):setFrom(1):setOnComplete(System.Action(function()
						setActive(arg0_94.storyTF, false)
					end)).uniqueId)

					if arg0_94._currentVoice then
						arg0_94._currentVoice:PlaybackStop()
					end

					arg0_94._currentVoice = nil

					arg0_94:setMask(true)
					table.insert(arg0_94.tweenList, LeanTween.delayedCall(0.5, System.Action(function()
						if arg0_94.weddingReview then
							arg0_94:closeView()
						else
							arg0_94:initChangeNamePanel()
							arg0_94:stampWindow()
						end
					end)).uniqueId)
				end)
				arg0_95()
			end)
		end)
	end

	seriesAsync(var0_94, function()
		if arg0_94:useL2dOrPainting() then
			arg0_94:showLive2D("wedding")
		else
			arg0_94:showPainting(true, 2)
		end

		local var0_100 = ShipGroup.getDefaultShipNameByGroupID(arg0_94.shipGroupID)

		setText(arg0_94.targetNameTF:Find("Text"), var0_100)
		setText(arg0_94.storyContent, "")

		arg0_94.storyCG.alpha = 0

		setActive(arg0_94.storyTF, true)

		arg0_94.initStory = false

		table.insert(arg0_94.tweenList, LeanTween.alphaCanvas(arg0_94.storyCG, 1, 1):setFrom(0):setDelay(1):setOnComplete(System.Action(function()
			if findTF(arg0_94.targetActorTF, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0_94.targetActorTF, "fitter"):GetChild(0), arg0_94.paintingName, "propose")
			end

			setText(arg0_94.storyContent, arg1_94)

			arg0_94.onWords = true

			arg0_94:TypeWriter()

			arg0_94.initStory = true

			arg0_94:setMask(false)

			if not arg0_94.weddingReview then
				arg0_94:showTip()
			end
		end)).uniqueId)
	end)
end

function var0_0.TypeWriter(arg0_102)
	local var0_102 = 0.1

	arg0_102.inTypeWritter = true
	arg0_102.typeWritterSpeedUp = 0.01

	arg0_102.typeWriter:setSpeed(var0_102)
	arg0_102.typeWriter:Play()

	function arg0_102.typeWriter.endFunc()
		arg0_102.inTypeWritter = false
		arg0_102.typeWritterSpeedUp = nil
	end
end

function var0_0.loadChar(arg0_104, arg1_104, arg2_104, arg3_104)
	arg1_104 = arg1_104 or arg0_104._paintingTF
	arg2_104 = arg2_104 or "wedding"

	local var0_104 = {}

	if not arg0_104.actorPainting then
		table.insert(var0_104, function(arg0_105)
			if arg0_104.reviewSkinID then
				arg0_104.paintingName = pg.ship_skin_template[arg0_104.reviewSkinID].painting
			elseif arg0_104.proposeSkin then
				arg0_104.paintingName = arg0_104.proposeSkin.painting
			else
				arg0_104.paintingName = arg0_104.shipVO:getPainting()
			end

			local var0_105 = arg0_104.paintingName

			if checkABExist("painting/" .. var0_105 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_105, 0) ~= 0 then
				var0_105 = var0_105 .. "_n"
			end

			PoolMgr.GetInstance():GetPainting(var0_105, true, function(arg0_106)
				local var0_106 = findTF(arg0_106, "Touch")

				if not IsNil(var0_106) then
					setActive(var0_106, false)
				end

				arg0_104.actorPainting = arg0_106

				ShipExpressionHelper.SetExpression(arg0_104.actorPainting, arg0_104.paintingName)
				arg0_105()
			end)

			if checkABExist("live2d/" .. string.lower(arg0_104.paintingName)) then
				arg0_104:createLive2D(arg0_104.paintingName)
			end
		end)
	end

	seriesAsync(var0_104, function()
		if not IsNil(arg1_104) then
			local var0_107 = findTF(arg1_104, "fitter")

			assert(var0_107, "请添加子物体fitter")

			local var1_107 = GetOrAddComponent(var0_107, "PaintingScaler")

			var1_107.FrameName = arg2_104
			var1_107.Tween = 1

			setParent(arg0_104.actorPainting, var0_107)
		end

		if arg3_104 then
			arg3_104()
		end
	end)
end

function var0_0.createLive2D(arg0_108, arg1_108)
	arg0_108.live2dRequestId = pg.Live2DMgr.GetInstance():GetLive2DModelAsync(arg1_108, function(arg0_109)
		local var0_109 = arg0_108:findTF("live2d", arg0_108.targetActorTF)

		UIUtil.SetLayerRecursively(arg0_109, LayerMask.NameToLayer("UI"))

		local var1_109 = arg0_109.transform

		var1_109:SetParent(var0_109, true)

		local var2_109

		if arg0_108.reviewSkinID then
			var2_109 = arg0_108.reviewSkinID
		elseif arg0_108.proposeSkin then
			var2_109 = arg0_108.proposeSkin.id
		else
			var2_109 = arg0_108.shipVO.skinId
		end

		var1_109.localPosition = BuildVector3(pg.ship_skin_template[var2_109].live2d_offset) + Vector3(0, 0, 100)
		var1_109.localScale = Vector3.Scale(Vector3(1, 1, 10), var1_109.localScale)
		arg0_108.l2dChar = GetComponent(arg0_109, "Live2dChar")
		arg0_108.l2dChar.name = arg1_108

		local var3_109 = pg.AssistantInfo.action2Id.idle

		function arg0_108.l2dChar.FinishAction(arg0_110)
			if var3_109 ~= arg0_110 then
				arg0_108.l2dChar:SetAction(var3_109)
			end
		end

		arg0_108.l2dChar:SetAction(var3_109)

		local var4_109 = pg.ship_skin_template[var2_109]
		local var5_109 = var4_109.lip_sync_gain
		local var6_109 = var4_109.lip_smoothing

		if var5_109 and var5_109 ~= 0 then
			var0_109:GetChild(0):GetComponent("CubismCriSrcMouthInput").Gain = var5_109
		end

		if var6_109 and var6_109 ~= 0 then
			var0_109:GetChild(0):GetComponent("CubismCriSrcMouthInput").Smoothing = var6_109
		end
	end)
end

function var0_0.showTip(arg0_111)
	local var0_111 = arg0_111.proposeSkin

	if not var0_111 then
		return
	end

	local var1_111 = arg0_111:findTF("tip", arg0_111.storyTF)
	local var2_111 = arg0_111:findTF("Image_bg/Text", var1_111)

	setText(var2_111, i18n("achieve_propose_tip", var0_111.name))
	eachChild(var1_111:Find("Image_bg/Image"), function(arg0_112)
		setActive(arg0_112, arg0_112.name == arg0_111.proposeType)
	end)

	local var3_111 = GetOrAddComponent(var1_111, typeof(CanvasGroup))

	setActive(var1_111, true)
	table.insert(arg0_111.tweenList, LeanTween.alphaCanvas(var3_111, 1, 0.01):setFrom(0).uniqueId)
	table.insert(arg0_111.tweenList, LeanTween.alphaCanvas(var3_111, 0, 1.5):setFrom(1):setDelay(4).uniqueId)
end

function var0_0.initChangeNamePanel(arg0_113)
	setText(arg0_113._renamePanel:Find("frame/border/title"), i18n("word_propose_changename_title", arg0_113.shipVO:getName()))
	setText(arg0_113._renamePanel:Find("frame/setting_ship_name/text"), i18n("word_propose_changename_tip1"))
	setText(arg0_113._renamePanel:Find("frame/text"), i18n("word_propose_changename_tip2"))

	arg0_113._renameConfirmBtn = arg0_113._renamePanel:Find("frame/queren")
	arg0_113._renameCancelBtn = arg0_113._renamePanel:Find("frame/cancel")
	arg0_113._renameToggle = findTF(arg0_113._renamePanel, "frame/setting_ship_name"):GetComponent(typeof(Toggle))
	arg0_113._renameRevert = arg0_113._renamePanel:Find("frame/revert_button")
	arg0_113._closeBtn = arg0_113._renamePanel:Find("frame/close_btn")

	onButton(arg0_113, arg0_113._renameConfirmBtn, function()
		local var0_114 = getInputText(findTF(arg0_113._renamePanel, "frame/name_field"))

		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg0_113._renameToggle.isOn)
		arg0_113:emit(ProposeMediator.RENAME_SHIP, arg0_113.shipVO.id, var0_114)
	end, SFX_CONFIRM)
	onButton(arg0_113, arg0_113._renameRevert, function()
		local var0_115 = arg0_113.shipVO:isRemoulded() and pg.ship_skin_template[arg0_113.shipVO:getRemouldSkinId()].name or pg.ship_data_statistics[arg0_113.shipVO.configId].name

		setInputText(findTF(arg0_113._renamePanel, "frame/name_field"), var0_115)
	end, SFX_PANEL)
	onButton(arg0_113, arg0_113._renameCancelBtn, function()
		arg0_113:closeView()
	end, SFX_CANCEL)
	onButton(arg0_113, arg0_113._closeBtn, function()
		arg0_113:closeView()
	end, SFX_CANCEL)
end

function var0_0.DisplayRenamePanel(arg0_118)
	if arg0_118.shipVO:IsXIdol() then
		arg0_118:closeView()
	else
		setParent(arg0_118._renamePanel, arg0_118._tf)
		setActive(arg0_118._renamePanel, true)

		local var0_118 = arg0_118.shipVO:getName()

		setInputText(findTF(arg0_118._renamePanel, "frame/name_field"), var0_118)
		setIntimacyIcon(arg0_118.intimacyTF, arg0_118.shipVO:getIntimacyIcon())
	end
end

function var0_0.showExchangePanel(arg0_119)
	setActive(arg0_119.exchangePanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_119.exchangePanel, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.hideExchangePanel(arg0_120)
	setActive(arg0_120.exchangePanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_120.exchangePanel, arg0_120._tf)
end

function var0_0.checkPaintingRes(arg0_121, arg1_121, arg2_121)
	local var0_121 = {}
	local var1_121 = arg1_121:getProposeSkin()

	if var1_121 and var1_121.id > 0 then
		local var2_121 = var1_121.id

		PaintingGroupConst.AddPaintingNameBySkinID(var0_121, var2_121)
	end

	local var3_121 = {
		isShowBox = true,
		paintingNameList = var0_121,
		finishFunc = arg2_121
	}

	PaintingGroupConst.PaintingDownload(var3_121)
end

return var0_0
