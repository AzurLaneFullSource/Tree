local var0_0 = class("ShipGiftScene", import("view.base.BaseUI"))
local var1_0 = 0.3
local var2_0 = 3

function var0_0.getUIName(arg0_1)
	return "ShipGiftUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3.adapt = arg0_3:findTF("adapt")
	arg0_3.topPanel = arg0_3:findTF("adapt/top")
	arg0_3.backBtn = arg0_3:findTF("adapt/top/back_btn")
	arg0_3.homeBtn = arg0_3:findTF("adapt/top/option")
	arg0_3.bgTf = arg0_3:findTF("bgGo")
	arg0_3.imageGrass = arg0_3:findTF("bgGo/ImageGrass")
	arg0_3.character = arg0_3:findTF("adapt/content")
	arg0_3.chat = arg0_3:findTF("adapt/content/chat")
	arg0_3.chatBg = arg0_3:findTF("adapt/content/chat/chatbgtop")
	arg0_3.chatText = arg0_3:findTF("adapt/content/chat/Text")
	rtf(arg0_3.chat).localScale = Vector3.New(0, 0, 1)
	arg0_3.initChatBgH = arg0_3.chatBg.sizeDelta.y
	arg0_3.initChatTextH = arg0_3.chatText.sizeDelta.y
	arg0_3.initfontSize = arg0_3.chatText:GetComponent(typeof(Text)).fontSize
	arg0_3.namePanel = arg0_3:findTF("adapt/name")
	arg0_3.shipName = arg0_3:findTF("adapt/name/nameRect/name_mask/Text")
	arg0_3.shipNameEn = arg0_3:findTF("adapt/name/english_name")
	arg0_3.starts = arg0_3:findTF("adapt/name/stars")
	arg0_3.shipInfoStarTpl = arg0_3:findTF("adapt/name/star_tpl")
	arg0_3.shipType = arg0_3:findTF("adapt/name/type")
	arg0_3.intimacyIcon = arg0_3:findTF("adapt/intimacy/icon")
	arg0_3.intimacyValueText = arg0_3:findTF("adapt/intimacy/value")
	arg0_3.intimacyAddValueText = GetComponent(arg0_3:findTF("adapt/intimacy/addValue"), typeof(RectTransform))
	arg0_3.painting = arg0_3:findTF("content/paint/fitter", arg0_3.adapt)
	arg0_3.l2dParent = arg0_3:findTF("content/paint/live2d", arg0_3.adapt)
	arg0_3.spineParent = arg0_3:findTF("content/paint/spinePainting", arg0_3.adapt)
	arg0_3.effectParent = arg0_3:findTF("content/paint/effect", arg0_3.adapt)
	arg0_3.intimacyAddValuePos = arg0_3.intimacyAddValueText.localPosition
	arg0_3.rightPanel = arg0_3:findTF("adapt/right")
	arg0_3.scrollRect = GetComponent(arg0_3:findTF("adapt/right/scrollRect"), "LScrollRect")
	arg0_3.giftBtn = arg0_3:findTF("adapt/right/giftBtn")

	setText(arg0_3:findTF("adapt/right/titlePanel/title/text"), i18n("ship_gift"))
	setText(arg0_3:findTF("label", arg0_3.giftBtn), i18n("ship_gift2"))
	setActive(arg0_3.intimacyAddValueText, false)

	arg0_3.giftItemList = {}
	arg0_3.anim = arg0_3._tf:GetComponent(typeof(Animation))
end

function var0_0.didEnter(arg0_4)
	arg0_4._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_5)
		arg0_4:closeView()
	end)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4.anim:Play("anim_ShipGiftUI_out")
	end, SFX_CANEL)
	onButton(arg0_4, arg0_4.homeBtn, function()
		arg0_4:emit(var0_0.ON_HOME)
	end, SFX_CANEL)
	onButton(arg0_4, arg0_4.giftBtn, function()
		if arg0_4.selectIndex == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shipyard_gift_non_existent"))

			return
		end

		local var0_8 = ShipGiftTools.GetShipNeedIntimacyValue(arg0_4.shipVO)

		if var0_8 == 0 then
			if arg0_4.shipVO.propose then
				pg.TipsMgr.GetInstance():ShowTips(i18n("shipyard_favorability_max"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("shipyard_favorability_threshold"))
			end

			return
		end

		if arg0_4.selectCnt == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shipyard_gift_non_existent"))

			return
		end

		local var1_8 = arg0_4.selectCnt
		local var2_8 = arg0_4.giftList[arg0_4.selectIndex + 1]
		local var3_8 = var2_8.id
		local var4_8 = ShipGiftTools.GetItemIntimacyValue(arg0_4.shipVO, var2_8) * var1_8 - var0_8

		if var4_8 > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("shipyard_favorability_exceed", math.floor(var4_8 / 100)),
				onYes = function()
					arg0_4:emit(ShipGiftMediator.SHIP_GIFT, var3_8, var1_8, arg0_4.shipVO.id)
				end
			})
		else
			arg0_4:emit(ShipGiftMediator.SHIP_GIFT, var3_8, var1_8, arg0_4.shipVO.id)
		end
	end, SFX_PANEL)

	arg0_4.scrollRect.onInitItem = handler(arg0_4, arg0_4.ScrollInit)
	arg0_4.scrollRect.onUpdateItem = handler(arg0_4, arg0_4.ScrollUpdate)
	arg0_4.scrollRect.onReturnItem = handler(arg0_4, arg0_4.ScrollReturn)

	local var0_4 = arg0_4.contextData.shipID

	arg0_4.shipVO = getProxy(BayProxy):getShipById(var0_4)
	arg0_4.giftList = ShipGiftTools.GetGiftList(arg0_4.shipVO)
	arg0_4.shipLoadClass = ShipLoad.New(function(arg0_10)
		setParent(arg0_10.transform, arg0_4.painting)
	end)

	arg0_4.shipLoadClass:LoadShip(var0_4)
	arg0_4:updatePreference()
	arg0_4:RefreshUI()
	arg0_4:OverlayPanel(arg0_4.bgTf, {
		pbList = {
			arg0_4.imageGrass
		}
	})
	arg0_4:OverlayPanel(arg0_4.adapt)

	arg0_4.selectIndex = nil
	arg0_4.eventList = {
		arg0_4:bind(ShipGiftItem.SELECT_ITEM, handler(arg0_4, arg0_4.OnSelectItem)),
		arg0_4:bind(ShipGiftItem.REFRESH_USE_ITEM_CNT, handler(arg0_4, arg0_4.OnRefreshUseItemCnt))
	}
end

function var0_0.willExit(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.eventList) do
		arg0_11:disconnect(iter1_11)
	end

	arg0_11.eventList = nil

	arg0_11:StopWaitClickTimer()
	arg0_11:StopAutoClickTimer()
	ClearLScrollrect(arg0_11.scrollRect)

	for iter2_11, iter3_11 in pairs(arg0_11.giftItemList) do
		iter3_11:willExit()
	end

	arg0_11.giftItemList = nil

	arg0_11.shipLoadClass:Dispose()

	arg0_11.shipLoadClass = nil

	arg0_11:UnOverlayPanel(arg0_11.bgTf, arg0_11._tf)
	arg0_11:UnOverlayPanel(arg0_11.adapt, arg0_11._tf)
end

function var0_0.ScrollInit(arg0_12, arg1_12)
	arg0_12.giftItemList[arg1_12] = ShipGiftItem.New(arg1_12, arg0_12)
end

function var0_0.ScrollUpdate(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.giftItemList[arg2_13] or ShipGiftItem.New(arg2_13, arg0_13)
	local var1_13 = arg0_13.giftList[arg1_13 + 1]

	var0_13:didEnter(arg0_13.shipVO, var1_13, arg1_13, arg0_13.selectCnt, arg0_13.selectIndex)
end

function var0_0.ScrollReturn(arg0_14, arg1_14, arg2_14)
	(arg0_14.giftItemList[arg2_14] or ShipGiftItem.New(arg2_14, arg0_14)):willExit()
end

function var0_0.RefreshScroll(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.giftItemList) do
		iter1_15:RefreshUI(arg0_15.selectIndex, arg0_15.selectCnt)
	end
end

function var0_0.RefreshUI(arg0_16)
	setImageSprite(arg0_16.intimacyIcon, GetSpriteFromAtlas("energy", arg0_16.shipVO:getIntimacyIcon()), true)

	local var0_16, var1_16 = arg0_16.shipVO:getIntimacyDetail()

	setText(arg0_16.intimacyValueText, var1_16)
	arg0_16.scrollRect:SetTotalCount(#arg0_16.giftList)
end

function var0_0.updatePreference(arg0_17)
	local var0_17 = arg0_17.shipVO
	local var1_17 = var0_17:getConfigTable()
	local var2_17 = arg0_17.shipVO:getName()

	setScrollText(arg0_17.shipName, var2_17)
	setText(arg0_17.shipNameEn, var1_17.english_name)

	local var3_17 = arg0_17.starts

	removeAllChildren(var3_17)

	local var4_17 = var0_17:getStar()
	local var5_17 = var0_17:getMaxStar()

	for iter0_17 = 1, var5_17 do
		local var6_17 = cloneTplTo(arg0_17.shipInfoStarTpl, var3_17, "star_" .. iter0_17)

		setActive(var6_17:Find("star_tpl"), iter0_17 <= var4_17)
		setActive(var6_17:Find("empty_star_tpl"), true)
	end

	local var7_17 = GetSpriteFromAtlas("shiptype", var0_17:getShipType())

	setImageSprite(arg0_17.shipType, var7_17, true)
end

function var0_0.OnGiftSuccess(arg0_18, arg1_18)
	local var0_18 = arg0_18.giftList[arg0_18.selectIndex + 1]
	local var1_18 = ShipGiftTools.GetItemFavoriteState(arg0_18.shipVO, var0_18)
	local var2_18 = ""

	if var1_18 == ShipGiftConst.GIFT_FAVORITE_STATE.HATE then
		arg0_18:displayShipWord("gift_dislike", true)
		ShipExpressionHelper.SetExpression(arg0_18.painting:GetChild(0), arg0_18.shipVO:getPainting(), "gift_dislike")
	else
		arg0_18:displayShipWord("gift_prefer", true)
		ShipExpressionHelper.SetExpression(arg0_18.painting:GetChild(0), arg0_18.shipVO:getPainting(), "gift_prefer")
	end

	local var3_18 = (arg0_18.selectCnt - arg1_18) * ShipGiftTools.GetItemIntimacyValue(arg0_18.shipVO, var0_18)

	if var3_18 > 0 then
		setText(arg0_18.intimacyAddValueText, string.format("+%s", var3_18 / 100))
		arg0_18:PlayAddValueAnimation()
		setActive(arg0_18.intimacyAddValueText, true)
	else
		setActive(arg0_18.intimacyAddValueText, false)
	end

	arg0_18:StopWaitClickTimer()

	arg0_18.waitClickTimer = FrameTimer.New(function()
		if Input.anyKeyDown then
			arg0_18:ClickBackGift()
		end
	end, 1, -1)

	arg0_18.waitClickTimer:Start()
	arg0_18:StopAutoClickTimer()

	arg0_18.autoClickTimer = Timer.New(function()
		arg0_18:ClickBackGift()
	end, 1.5, 1)

	arg0_18.autoClickTimer:Start()

	if var3_18 > 0 then
		arg0_18:emit(ShipGiftMediator.ADD_SHIP_INTIMACY, arg0_18.shipVO, var3_18)
	end

	local var4_18 = arg0_18.contextData.shipID

	arg0_18.shipVO = getProxy(BayProxy):getShipById(var4_18)
	arg0_18.giftList = ShipGiftTools.GetGiftList(arg0_18.shipVO)
	arg0_18.selectIndex = nil
	arg0_18.selectCnt = 0

	arg0_18:RefreshUI()
	arg0_18.anim:Play("anim_ShipGiftUI_success")
end

function var0_0.displayShipWord(arg0_21, arg1_21, arg2_21)
	if arg2_21 or not arg0_21.chatFlag then
		arg0_21.chatFlag = true
		arg0_21.chat.localScale = Vector3.zero

		setActive(arg0_21.chat, true)

		local var0_21 = arg0_21.shipVO:getCVIntimacy()
		local var1_21, var2_21, var3_21 = ShipWordHelper.GetWordAndCV(arg0_21.shipVO:getSkinId(), arg1_21, nil, nil, var0_21)

		if var3_21 == "" then
			if arg1_21 == "gift_dislike" then
				var3_21 = arg0_21.shipVO:getName() .. i18n("gift_giving_dislike")
			else
				var3_21 = arg0_21.shipVO:getName() .. i18n("gift_giving_prefer")
			end
		end

		local var4_21 = arg0_21.chatText:GetComponent(typeof(Text))

		if PLATFORM_CODE ~= PLATFORM_US then
			setText(arg0_21.chatText, SwitchSpecialChar(var3_21))
		else
			var4_21.fontSize = arg0_21.initfontSize

			setTextEN(arg0_21.chatText, var3_21)

			while var4_21.preferredHeight > arg0_21.initChatTextH do
				var4_21.fontSize = var4_21.fontSize - 2

				setTextEN(arg0_21.chatText, var3_21)

				if var4_21.fontSize < 20 then
					break
				end
			end
		end

		if #var4_21.text > CHAT_POP_STR_LEN then
			var4_21.alignment = TextAnchor.MiddleLeft
		else
			var4_21.alignment = TextAnchor.MiddleCenter
		end

		local var5_21 = var4_21.preferredHeight + 120

		if var5_21 > arg0_21.initChatBgH then
			arg0_21.chatBg.sizeDelta = Vector2.New(arg0_21.chatBg.sizeDelta.x, var5_21)
		else
			arg0_21.chatBg.sizeDelta = Vector2.New(arg0_21.chatBg.sizeDelta.x, arg0_21.initChatBgH)
		end

		local var6_21 = var2_0

		local function var7_21()
			if arg0_21.chatFlag then
				if arg0_21.chatani1Id then
					LeanTween.cancel(arg0_21.chatani1Id)
				end

				if arg0_21.chatani2Id then
					LeanTween.cancel(arg0_21.chatani2Id)
				end
			end

			arg0_21.chatani1Id = LeanTween.scale(rtf(arg0_21.chat.gameObject), Vector3.New(1, 1, 1), var1_0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				arg0_21.chatani2Id = LeanTween.scale(rtf(arg0_21.chat.gameObject), Vector3.New(0, 0, 1), var1_0):setEase(LeanTweenType.easeInBack):setDelay(var1_0 + var6_21):setOnComplete(System.Action(function()
					arg0_21.chatFlag = nil
				end)).uniqueId
			end)).uniqueId
		end

		if var2_21 then
			arg0_21:StopPreVoice()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_21, function(arg0_25)
				if arg0_25 then
					var6_21 = arg0_25:GetLength() * 0.001
				end

				var7_21()
			end)

			arg0_21.preVoiceContent = var2_21
		else
			var7_21()
		end
	end
end

function var0_0.ShowPanel(arg0_26)
	arg0_26.anim:Play("anim_ShipGiftUI_success_re")
end

function var0_0.PlayAddValueAnimation(arg0_27)
	setActive(arg0_27.intimacyAddValueText, true)

	arg0_27.intimacyAddValueText.localPosition = Vector2(arg0_27.intimacyAddValuePos.x, arg0_27.intimacyAddValuePos.y)

	arg0_27:managedTween(LeanTween.moveY, nil, arg0_27.intimacyAddValueText, arg0_27.intimacyAddValuePos.y + 20, 0.35):setOnComplete(System.Action(function()
		setActive(arg0_27.intimacyAddValueText, false)
	end))
end

function var0_0.ClickBackGift(arg0_29)
	arg0_29:StopWaitClickTimer()
	arg0_29:StopAutoClickTimer()
	arg0_29:ShowPanel()
	ShipExpressionHelper.SetExpression(arg0_29.painting:GetChild(0), arg0_29.shipVO:getPainting())
end

function var0_0.StopWaitClickTimer(arg0_30)
	if arg0_30.waitClickTimer then
		arg0_30.waitClickTimer:Stop()

		arg0_30.waitClickTimer = nil
	end
end

function var0_0.StopAutoClickTimer(arg0_31)
	if arg0_31.autoClickTimer then
		arg0_31.autoClickTimer:Stop()

		arg0_31.autoClickTimer = nil
	end
end

function var0_0.OnSelectItem(arg0_32, arg1_32, arg2_32)
	arg0_32.selectIndex = arg2_32

	local var0_32 = arg0_32.giftList[arg2_32 + 1]

	arg0_32.selectCnt = ShipGiftTools.GetNeedMinCnt(arg0_32.shipVO, var0_32)

	arg0_32:RefreshScroll()
end

function var0_0.OnRefreshUseItemCnt(arg0_33, arg1_33, arg2_33)
	arg0_33.selectCnt = arg2_33
end

function var0_0.onBackPressed(arg0_34)
	if arg0_34.waitClickTimer then
		arg0_34:ClickBackGift()

		return
	end

	var0_0.super.onBackPressed(arg0_34)
end

return var0_0
