local var0_0 = class("ChargeScene", import("...base.BaseUI"))

var0_0.TYPE_DIAMOND = 1
var0_0.TYPE_GIFT = 2
var0_0.TYPE_ITEM = 3

function var0_0.getUIName(arg0_1)
	return "ChargeShopUI"
end

function var0_0.onBackPressed(arg0_2)
	arg0_2:closeView()
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = getProxy(ShopsProxy)

	local function var1_3()
		local var0_4 = var0_3:getFirstChargeList()
		local var1_4 = var0_3:getChargedList()
		local var2_4 = var0_3:GetNormalList()
		local var3_4 = var0_3:GetNormalGroupList()

		if var0_4 then
			arg0_3:setFirstChargeIds(var0_4)
		end

		if var1_4 then
			arg0_3:setChargedList(var1_4)
		end

		if var2_4 then
			arg0_3:setNormalList(var2_4)
		end

		if var3_4 then
			arg0_3:setNormalGroupList(var3_4)
		end

		arg1_3()
	end

	if var0_3:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1_3
		})
	else
		var1_3()
	end
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5
end

function var0_0.setFirstChargeIds(arg0_6, arg1_6)
	arg0_6.firstChargeIds = arg1_6
end

function var0_0.setChargedList(arg0_7, arg1_7)
	arg0_7.chargedList = arg1_7
end

function var0_0.setNormalList(arg0_8, arg1_8)
	arg0_8.normalList = arg1_8
end

function var0_0.setNormalGroupList(arg0_9, arg1_9)
	arg0_9.normalGroupList = arg1_9

	arg0_9:addRefreshTimer(GetZeroTime())
end

function var0_0.ResUISettings(arg0_10)
	return true
end

function var0_0.init(arg0_11)
	arg0_11.blurPanel = arg0_11:findTF("blur_panel")
	arg0_11.top = arg0_11:findTF("adapt/top", arg0_11.blurPanel)
	arg0_11.frame = arg0_11:findTF("frame")
	arg0_11.viewContainer = arg0_11:findTF("viewContainer")
	arg0_11.bg = arg0_11:findTF("viewContainer/bg")
	arg0_11.painting = arg0_11:findTF("frame/painting")
	arg0_11.chat = arg0_11:findTF("viewContainer/chat")
	arg0_11.chatText = arg0_11:findTF("Text", arg0_11.chat)
	arg0_11.switchBtn = arg0_11:findTF("blur_panel/adapt/switch_btn")
	arg0_11.skinShopBtn = arg0_11:findTF("blur_panel/adapt/skin_btn")
	arg0_11.itemToggle = arg0_11:findTF("toggle_list/item_toggle", arg0_11.viewContainer)
	arg0_11.giftToggle = arg0_11:findTF("toggle_list/gift_toggle", arg0_11.viewContainer)
	arg0_11.diamondToggle = arg0_11:findTF("toggle_list/diamond_toggle", arg0_11.viewContainer)
	arg0_11.giftTip = arg0_11:findTF("tip", arg0_11.giftToggle)
	arg0_11.chargeTipWindow = ChargeTipWindow.New(arg0_11._tf, arg0_11.event)

	local var0_11 = arg0_11:findTF("light/title", arg0_11.diamondToggle)
	local var1_11 = arg0_11:findTF("dark/title", arg0_11.diamondToggle)
	local var2_11 = arg0_11:findTF("light/title", arg0_11.giftToggle)
	local var3_11 = arg0_11:findTF("dark/title", arg0_11.giftToggle)
	local var4_11 = arg0_11:findTF("light/title", arg0_11.itemToggle)
	local var5_11 = arg0_11:findTF("dark/title", arg0_11.itemToggle)

	setText(var0_11, i18n("shop_diamond_title"))
	setText(var1_11, i18n("shop_diamond_title"))
	setText(var2_11, i18n("shop_gift_title"))
	setText(var3_11, i18n("shop_gift_title"))
	setText(var4_11, i18n("shop_item_title"))
	setText(var5_11, i18n("shop_item_title"))

	arg0_11.linkTitle = {
		arg0_11:findTF("title/title_diamond", arg0_11.top),
		arg0_11:findTF("title/title_gift", arg0_11.top),
		arg0_11:findTF("title/title_item", arg0_11.top)
	}
	arg0_11.toggleList = {
		arg0_11.diamondToggle,
		arg0_11.giftToggle,
		arg0_11.itemToggle
	}

	arg0_11:createLive2D()

	arg0_11.live2dTimer = Timer.New(function()
		local var0_12 = pg.ChargeShipTalkInfo.Actions
		local var1_12 = var0_12[math.random(#var0_12)]

		if arg0_11:checkBuyDone(var1_12.action) then
			arg0_11:displayShipWord(nil, false, var1_12.dialog_index)
		end
	end, 20, -1)

	arg0_11.live2dTimer:Start()
	arg0_11:jpUIInit()
	arg0_11:blurView()
	arg0_11:initSubView()
end

function var0_0.didEnter(arg0_13)
	setActive(arg0_13.chat, false)
	onButton(arg0_13, arg0_13:findTF("back_button", arg0_13.top), function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.painting, function()
		arg0_13:displayShipWord()
		arg0_13:emit(ChargeMediator.CLICK_MING_SHI)
	end, SFX_PANEL)

	for iter0_13 = 1, #arg0_13.toggleList do
		local var0_13 = arg0_13.toggleList[iter0_13]

		onToggle(arg0_13, var0_13, function(arg0_16)
			local var0_16 = arg0_13:findTF("dark", var0_13)

			setActive(var0_16, not arg0_16)

			if arg0_16 then
				arg0_13:switchSubView(iter0_13)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_13, arg0_13.switchBtn, function()
		arg0_13:emit(ChargeMediator.SWITCH_TO_SHOP, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
		arg0_13:stopCV()
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.skinShopBtn, function()
		arg0_13:emit(ChargeMediator.ON_SKIN_SHOP)
	end, SFX_PANEL)
	arg0_13:updateNoRes()

	if arg0_13.contextData.wrap ~= nil then
		arg0_13:switchSubViewByTogger(arg0_13.contextData.wrap)

		arg0_13.contextData.wrap = nil
	else
		arg0_13:switchSubViewByTogger(ChargeScene.TYPE_DIAMOND)
	end

	arg0_13:jpUIEnter()
end

function var0_0.OnChargeSuccess(arg0_19, arg1_19)
	arg0_19.chargeTipWindow:ExecuteAction("Show", arg1_19)
end

function var0_0.willExit(arg0_20)
	arg0_20:unBlurView()

	if arg0_20.chargeTipWindow then
		arg0_20.chargeTipWindow:Destroy()

		arg0_20.chargeTipWindow = nil
	end

	if arg0_20.heartsTimer then
		arg0_20.heartsTimer:Stop()

		arg0_20.heartsTimer = nil
	end

	if arg0_20.live2dChar then
		arg0_20.live2dChar:Dispose()
	end

	if arg0_20.live2dTimer then
		arg0_20.live2dTimer:Stop()

		arg0_20.live2dTimer = nil
	end

	if arg0_20.giftShopView then
		arg0_20.giftShopView:OnDestroy()
	end

	arg0_20:stopCV()
end

function var0_0.initSubView(arg0_21)
	arg0_21.subViewContainer = arg0_21:findTF("SubView", arg0_21.viewContainer)
	arg0_21.diamondShopView = ChargeDiamondShopView.New(arg0_21.subViewContainer, arg0_21.event, arg0_21.contextData)
	arg0_21.giftShopView = ChargeGiftShopView.New(arg0_21.subViewContainer, arg0_21.event, arg0_21.contextData)
	arg0_21.itemShopView = ChargeItemShopView.New(arg0_21.subViewContainer, arg0_21.event, arg0_21.contextData)
	arg0_21.curSubViewNum = 0
	arg0_21.subViewList = {
		[ChargeScene.TYPE_DIAMOND] = arg0_21.diamondShopView,
		[ChargeScene.TYPE_GIFT] = arg0_21.giftShopView,
		[ChargeScene.TYPE_ITEM] = arg0_21.itemShopView
	}
end

function var0_0.switchSubView(arg0_22, arg1_22)
	if arg1_22 == arg0_22.curSubViewNum then
		return
	end

	arg0_22.subViewList[arg1_22]:setGoodData(arg0_22.firstChargeIds, arg0_22.chargedList, arg0_22.normalList, arg0_22.normalGroupList)
	arg0_22.subViewList[arg1_22]:Reset()
	arg0_22.subViewList[arg1_22]:Load()

	local var0_22 = arg0_22.subViewList[arg0_22.curSubViewNum]

	if var0_22 then
		var0_22:Destroy()
	end

	arg0_22.curSubViewNum = arg1_22

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_22.userAgreeBtn3, arg1_22 == var0_0.TYPE_DIAMOND)
		setActive(arg0_22.userAgreeBtn4, arg1_22 == var0_0.TYPE_DIAMOND)
	end

	for iter0_22, iter1_22 in ipairs(arg0_22.linkTitle) do
		setActive(iter1_22, iter0_22 == arg1_22)
	end
end

function var0_0.switchSubViewByTogger(arg0_23, arg1_23)
	local var0_23 = arg0_23.toggleList[arg1_23]

	triggerToggle(var0_23, true)
end

function var0_0.updateCurSubView(arg0_24)
	local var0_24 = arg0_24.subViewList[arg0_24.curSubViewNum]

	var0_24:setGoodData(arg0_24.firstChargeIds, arg0_24.chargedList, arg0_24.normalList, arg0_24.normalGroupList)
	var0_24:reUpdateAll()
end

function var0_0.updateNoRes(arg0_25, arg1_25)
	if not arg1_25 then
		arg1_25 = arg0_25.contextData.noRes
	else
		arg0_25.contextData.noRes = arg1_25
	end

	if not arg1_25 or #arg1_25 <= 0 then
		return
	end

	arg0_25.contextData.noRes = {}

	local var0_25 = getProxy(BagProxy):getData()
	local var1_25 = ""

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		if iter1_25[2] > 0 then
			if iter1_25[1] == 59001 then
				arg1_25[iter0_25][2] = iter1_25[3] - arg0_25.player.gold
			else
				arg1_25[iter0_25][2] = iter1_25[3] - (var0_25[iter1_25[1]] and var0_25[iter1_25[1]].count or 0)
			end
		end

		if arg1_25[iter0_25][2] > 0 then
			table.insert(arg0_25.contextData.noRes, arg1_25[iter0_25])
		end
	end

	for iter2_25, iter3_25 in ipairs(arg0_25.contextData.noRes) do
		local var2_25 = Item.getConfigData(iter3_25[1]).name

		var1_25 = var1_25 .. i18n(iter3_25[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_25, iter3_25[2])

		if iter2_25 < #arg0_25.contextData.noRes then
			var1_25 = var1_25 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_25 == "" then
		arg0_25:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_25:displayShipWord(i18n("text_shop_noRes_tip", var1_25), true)
	end
end

function var0_0.displayShipWord(arg0_26, arg1_26, arg2_26, arg3_26)
	if not arg0_26.chatFlag then
		if not arg1_26 and arg0_26.contextData.noRes and #arg0_26.contextData.noRes > 0 then
			setActive(arg0_26.chat, false)

			arg0_26.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_26.chatFlag = true

		if not arg0_26.isInitChatPosition then
			arg0_26.isInitChatPosition = true

			arg0_26:InitChatPosition()
		end

		setActive(arg0_26.chat, true)

		local var0_26 = arg0_26.player:getChargeLevel()
		local var1_26 = arg3_26 or math.random(1, var0_26)
		local var2_26

		if arg3_26 then
			var2_26 = pg.pay_level_award[var1_26].dialog
		else
			var2_26 = arg1_26 or pg.pay_level_award[var1_26].dialog
		end

		if not arg1_26 then
			arg0_26:playCV(var1_26)
		end

		setText(arg0_26.chatText, var2_26)

		local var3_26 = arg0_26.chatText:GetComponent(typeof(Text))

		if #var3_26.text > CHAT_POP_STR_LEN_SHORT then
			var3_26.alignment = TextAnchor.MiddleLeft
		else
			var3_26.alignment = TextAnchor.MiddleCenter
		end

		;(function()
			local var0_27 = 3
			local var1_27 = 0.3

			LeanTween.scale(rtf(arg0_26.chat.gameObject), Vector3.New(1, 1, 1), var1_27):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_26 then
					LeanTween.scale(rtf(arg0_26.chat.gameObject), Vector3.New(0, 0, 1), var1_27):setEase(LeanTweenType.easeInBack):setDelay(var1_27 + var0_27):setOnComplete(System.Action(function()
						arg0_26.chatFlag = nil

						setActive(arg0_26.chat, false)

						if arg0_26.contextData.noRes and #arg0_26.contextData.noRes > 0 then
							arg0_26:updateNoRes()
						end
					end))
				else
					arg0_26.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_30)
	local var0_30 = arg0_30.painting.localPosition + Vector3(-21, -176, 0)
	local var1_30 = arg0_30.painting.parent:TransformPoint(var0_30)
	local var2_30 = arg0_30.chat.parent:InverseTransformPoint(var1_30)

	arg0_30.chat.localPosition = Vector3(var2_30.x, var2_30.y, 0)
end

function var0_0.playHeartEffect(arg0_31)
	if arg0_31.heartsTimer then
		arg0_31.heartsTimer:Stop()
	end

	local var0_31 = arg0_31.painting:Find("heartsfly")

	setActive(var0_31, true)

	arg0_31.heartsTimer = Timer.New(function()
		setActive(var0_31, false)
	end, 1, 1)

	arg0_31.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_33)
	local var0_33 = Live2D.GenerateData({
		ship = Ship.New({
			configId = 312011
		}),
		scale = Vector3(75, 75, 75),
		position = Vector3(0, 0, 0),
		parent = arg0_33:findTF("frame/painting/live2d")
	})

	arg0_33.live2dChar = Live2D.New(var0_33)
end

function var0_0.checkBuyDone(arg0_34, arg1_34)
	if not arg0_34.live2dChar then
		return
	end

	local var0_34

	if type(arg1_34) == "string" then
		if arg1_34 == "damonds" then
			var0_34 = "diamond"
		else
			var0_34 = arg1_34
		end
	else
		local var1_34 = pg.shop_template[arg1_34]

		if var1_34 and var1_34.effect_args and type(var1_34.effect_args) == "table" then
			for iter0_34, iter1_34 in ipairs(var1_34.effect_args) do
				if iter1_34 == 1 then
					var0_34 = "gold"
				end
			end
		end
	end

	local var2_34 = arg0_34.preAniName == "gold" or arg0_34.preAniName == "diamond"
	local var3_34 = var0_34 == "gold" or var0_34 == "diamond"
	local var4_34 = var2_34 and var3_34 or not var2_34

	var4_34 = var0_34 and arg0_34.preAniName ~= var0_34 and var4_34

	if var4_34 then
		arg0_34.preAniName = var0_34

		arg0_34.live2dChar:TriggerAction(var0_34, nil, true)
	end

	return var4_34
end

function var0_0.playCV(arg0_35, arg1_35)
	local var0_35 = pg.pay_level_award[arg1_35]
	local var1_35

	if var0_35 and var0_35.cv_key ~= "" then
		var1_35 = "event:/cv/chargeShop/" .. var0_35.cv_key
	end

	if var1_35 then
		arg0_35:stopCV()

		arg0_35._currentVoice = var1_35

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_35)
	end
end

function var0_0.stopCV(arg0_36)
	if arg0_36._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_36._currentVoice)
	end

	arg0_36._currentVoice = nil
end

function var0_0.blurView(arg0_37)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_37.viewContainer, {
		pbList = {
			arg0_37:findTF("blurBg", arg0_37.viewContainer)
		}
	})
end

function var0_0.unBlurView(arg0_38)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38.viewContainer, arg0_38.frame)
end

function var0_0.jpUIInit(arg0_39)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_39.userAgreeBtn3 = arg0_39:findTF("frame/raw1Btn")
	arg0_39.userAgreeBtn4 = arg0_39:findTF("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_40)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_40, arg0_40.userAgreeBtn3, function()
		local var0_41 = require("ShareCfg.UserAgreement3")

		arg0_40:emit(ChargeMediator.OPEN_USER_AGREE, var0_41 or "")
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.userAgreeBtn4, function()
		local var0_42 = require("ShareCfg.UserAgreement4")

		arg0_40:emit(ChargeMediator.OPEN_USER_AGREE, var0_42 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_43, arg1_43)
	local function var0_43()
		if arg0_43.refreshTimer then
			arg0_43.refreshTimer:Stop()

			arg0_43.refreshTimer = nil
		end
	end

	var0_43()

	arg0_43.refreshTimer = Timer.New(function()
		local var0_45 = arg1_43 + 1 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_45 <= 0 then
			var0_43()
			arg0_43:emit(ChargeMediator.GET_CHARGE_LIST)
		else
			local var1_45 = pg.TimeMgr.GetInstance():DescCDTime(var0_45)
		end
	end, 1, -1)

	arg0_43.refreshTimer:Start()
	arg0_43.refreshTimer.func()
end

function var0_0.checkFreeGiftTag(arg0_46)
	TagTipHelper.FreeGiftTag({
		arg0_46.giftTip
	})
end

return var0_0
