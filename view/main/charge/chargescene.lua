local var0_0 = class("ChargeScene", import("...base.BaseUI"))

var0_0.TYPE_DIAMOND = 1
var0_0.TYPE_GIFT = 2
var0_0.TYPE_ITEM = 3
var0_0.TYPE_PICK = 4

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
	arg0_11.blurPanel = arg0_11._tf:Find("blur_panel")
	arg0_11.top = arg0_11.blurPanel:Find("adapt/top")
	arg0_11.frame = arg0_11._tf:Find("frame")
	arg0_11.viewContainer = arg0_11._tf:Find("viewContainer")
	arg0_11.bg = arg0_11._tf:Find("viewContainer/bg")
	arg0_11.painting = arg0_11._tf:Find("frame/painting")
	arg0_11.chat = arg0_11._tf:Find("viewContainer/chat")
	arg0_11.chatText = arg0_11.chat:Find("Text")
	arg0_11.switchBtn = arg0_11._tf:Find("blur_panel/adapt/switch_btn")
	arg0_11.skinShopBtn = arg0_11._tf:Find("blur_panel/adapt/skin_btn")

	local var0_11 = LOCK_SKIN_SHOP_ENTER and getProxy(PlayerProxy):getData().level < LOCK_SKIN_SHOP_ENTER_LEVEL

	setActive(arg0_11.skinShopBtn, not var0_11)

	arg0_11.itemToggle = arg0_11.viewContainer:Find("toggle_list/item_toggle")
	arg0_11.giftToggle = arg0_11.viewContainer:Find("toggle_list/gift_toggle")
	arg0_11.diamondToggle = arg0_11.viewContainer:Find("toggle_list/diamond_toggle")
	arg0_11.giftTip = arg0_11.giftToggle:Find("tip")
	arg0_11.pickToggle = arg0_11.viewContainer:Find("toggle_list/pick_toggle")
	arg0_11.pickTip = arg0_11.pickToggle:Find("tip")
	arg0_11.chargeTipWindow = ChargeTipWindow.New(arg0_11._tf, arg0_11.event)

	local var1_11 = arg0_11.diamondToggle:Find("light/title")
	local var2_11 = arg0_11.diamondToggle:Find("dark/title")
	local var3_11 = arg0_11.giftToggle:Find("light/title")
	local var4_11 = arg0_11.giftToggle:Find("dark/title")
	local var5_11 = arg0_11.itemToggle:Find("light/title")
	local var6_11 = arg0_11.itemToggle:Find("dark/title")
	local var7_11 = arg0_11.pickToggle:Find("light/title")
	local var8_11 = arg0_11.pickToggle:Find("dark/title")

	setText(var1_11, i18n("shop_diamond_title"))
	setText(var2_11, i18n("shop_diamond_title"))
	setText(var3_11, i18n("shop_gift_title"))
	setText(var4_11, i18n("shop_gift_title"))
	setText(var5_11, i18n("shop_item_title"))
	setText(var6_11, i18n("shop_item_title"))
	setText(var7_11, i18n("shop_akashi_pick_title"))
	setText(var8_11, i18n("shop_akashi_pick_title"))

	arg0_11.linkTitle = {
		arg0_11.top:Find("title/title_diamond"),
		arg0_11.top:Find("title/title_gift"),
		arg0_11.top:Find("title/title_item"),
		arg0_11.top:Find("title/title_pick")
	}
	arg0_11.toggleList = {
		arg0_11.diamondToggle,
		arg0_11.giftToggle,
		arg0_11.itemToggle,
		arg0_11.pickToggle
	}

	if Live2dConst.GetLive2DArm32MatchAble() then
		local var9_11 = Ship.New({
			configId = 312011
		}):getPainting()

		LoadPaintingPrefabAsync(arg0_11.painting, var9_11, var9_11, "mainNormal", function()
			arg0_11.loading = false
		end)
	else
		arg0_11:createLive2D()
	end

	arg0_11.live2dTimer = Timer.New(function()
		local var0_13 = pg.ChargeShipTalkInfo.Actions
		local var1_13 = var0_13[math.random(#var0_13)]

		if arg0_11:checkBuyDone(var1_13.action) then
			arg0_11:displayShipWord(nil, false, var1_13.dialog_index)
		end
	end, 20, -1)

	arg0_11.live2dTimer:Start()
	arg0_11:jpUIInit()
	arg0_11:blurView()
	arg0_11:initSubView()
end

function var0_0.didEnter(arg0_14)
	setActive(arg0_14.chat, false)
	onButton(arg0_14, arg0_14.top:Find("back_button"), function()
		arg0_14:closeView()
	end, SFX_CANCEL)
	onButton(arg0_14, arg0_14.painting, function()
		arg0_14:displayShipWord()
		arg0_14:emit(ChargeMediator.CLICK_MING_SHI)
	end, SFX_PANEL)

	for iter0_14 = 1, #arg0_14.toggleList do
		local var0_14 = arg0_14.toggleList[iter0_14]

		onToggle(arg0_14, var0_14, function(arg0_17)
			local var0_17 = var0_14:Find("dark")

			setActive(var0_17, not arg0_17)

			if arg0_17 then
				arg0_14:switchSubView(iter0_14)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_14, arg0_14.switchBtn, function()
		arg0_14:emit(ChargeMediator.SWITCH_TO_SHOP, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
		arg0_14:stopCV()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.skinShopBtn, function()
		arg0_14:emit(ChargeMediator.ON_SKIN_SHOP)
	end, SFX_PANEL)
	arg0_14:updateNoRes()

	if arg0_14.contextData.wrap ~= nil then
		arg0_14:switchSubViewByTogger(arg0_14.contextData.wrap)

		arg0_14.contextData.wrap = nil
	else
		arg0_14:switchSubViewByTogger(ChargeScene.TYPE_DIAMOND)
	end

	arg0_14:jpUIEnter()
end

function var0_0.OnChargeSuccess(arg0_20, arg1_20)
	arg0_20.chargeTipWindow:ExecuteAction("Show", arg1_20)
end

function var0_0.willExit(arg0_21)
	arg0_21:unBlurView()

	if arg0_21.chargeTipWindow then
		arg0_21.chargeTipWindow:Destroy()

		arg0_21.chargeTipWindow = nil
	end

	if arg0_21.heartsTimer then
		arg0_21.heartsTimer:Stop()

		arg0_21.heartsTimer = nil
	end

	if arg0_21.live2dChar then
		arg0_21.live2dChar:Dispose()
	end

	if arg0_21.live2dTimer then
		arg0_21.live2dTimer:Stop()

		arg0_21.live2dTimer = nil
	end

	if arg0_21.giftShopView then
		arg0_21.giftShopView:OnDestroy()
	end

	arg0_21:stopCV()
end

function var0_0.initSubView(arg0_22)
	arg0_22.subViewContainer = arg0_22.viewContainer:Find("SubView")
	arg0_22.diamondShopView = ChargeDiamondShopView.New(arg0_22.subViewContainer, arg0_22.event, arg0_22.contextData)
	arg0_22.giftShopView = ChargeGiftShopView.New(arg0_22.subViewContainer, arg0_22.event, arg0_22.contextData)
	arg0_22.itemShopView = ChargeItemShopView.New(arg0_22.subViewContainer, arg0_22.event, arg0_22.contextData)
	arg0_22.pickShopView = ChargePickShopView.New(arg0_22.subViewContainer, arg0_22.event, arg0_22.contextData)
	arg0_22.curSubViewNum = 0
	arg0_22.subViewList = {
		[ChargeScene.TYPE_DIAMOND] = arg0_22.diamondShopView,
		[ChargeScene.TYPE_GIFT] = arg0_22.giftShopView,
		[ChargeScene.TYPE_ITEM] = arg0_22.itemShopView,
		[ChargeScene.TYPE_PICK] = arg0_22.pickShopView
	}
end

function var0_0.switchSubView(arg0_23, arg1_23)
	if arg1_23 == arg0_23.curSubViewNum then
		return
	end

	arg0_23.subViewList[arg1_23]:setGoodData(arg0_23.firstChargeIds, arg0_23.chargedList, arg0_23.normalList, arg0_23.normalGroupList)
	arg0_23.subViewList[arg1_23]:Reset()
	arg0_23.subViewList[arg1_23]:Load()

	local var0_23 = arg0_23.subViewList[arg0_23.curSubViewNum]

	if var0_23 then
		var0_23:Destroy()
	end

	arg0_23.curSubViewNum = arg1_23

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_23.userAgreeBtn3, arg1_23 == var0_0.TYPE_DIAMOND)
		setActive(arg0_23.userAgreeBtn4, arg1_23 == var0_0.TYPE_DIAMOND)
	end

	for iter0_23, iter1_23 in ipairs(arg0_23.linkTitle) do
		setActive(iter1_23, iter0_23 == arg1_23)
	end
end

function var0_0.switchSubViewByTogger(arg0_24, arg1_24)
	local var0_24 = arg0_24.toggleList[arg1_24]

	triggerToggle(var0_24, true)
end

function var0_0.updateCurSubView(arg0_25)
	local var0_25 = arg0_25.subViewList[arg0_25.curSubViewNum]

	var0_25:setGoodData(arg0_25.firstChargeIds, arg0_25.chargedList, arg0_25.normalList, arg0_25.normalGroupList)
	var0_25:reUpdateAll()
end

function var0_0.updateNoRes(arg0_26, arg1_26)
	if not arg1_26 then
		arg1_26 = arg0_26.contextData.noRes
	else
		arg0_26.contextData.noRes = arg1_26
	end

	if not arg1_26 or #arg1_26 <= 0 then
		return
	end

	arg0_26.contextData.noRes = {}

	local var0_26 = getProxy(BagProxy):getData()
	local var1_26 = ""

	for iter0_26, iter1_26 in ipairs(arg1_26) do
		if iter1_26[2] > 0 then
			if iter1_26[1] == 59001 then
				arg1_26[iter0_26][2] = iter1_26[3] - arg0_26.player.gold
			else
				arg1_26[iter0_26][2] = iter1_26[3] - (var0_26[iter1_26[1]] and var0_26[iter1_26[1]].count or 0)
			end
		end

		if arg1_26[iter0_26][2] > 0 then
			table.insert(arg0_26.contextData.noRes, arg1_26[iter0_26])
		end
	end

	for iter2_26, iter3_26 in ipairs(arg0_26.contextData.noRes) do
		local var2_26 = Item.getConfigData(iter3_26[1]).name

		var1_26 = var1_26 .. i18n(iter3_26[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_26, iter3_26[2])

		if iter2_26 < #arg0_26.contextData.noRes then
			var1_26 = var1_26 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_26 == "" then
		arg0_26:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_26:displayShipWord(i18n("text_shop_noRes_tip", var1_26), true)
	end
end

function var0_0.displayShipWord(arg0_27, arg1_27, arg2_27, arg3_27)
	if not arg0_27.chatFlag then
		if not arg1_27 and arg0_27.contextData.noRes and #arg0_27.contextData.noRes > 0 then
			setActive(arg0_27.chat, false)

			arg0_27.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_27.chatFlag = true

		if not arg0_27.isInitChatPosition then
			arg0_27.isInitChatPosition = true

			arg0_27:InitChatPosition()
		end

		setActive(arg0_27.chat, true)

		local var0_27 = arg0_27.player:getChargeLevel()
		local var1_27 = arg3_27 or math.random(1, var0_27)
		local var2_27

		if arg3_27 then
			var2_27 = pg.pay_level_award[var1_27].dialog
		else
			var2_27 = arg1_27 or pg.pay_level_award[var1_27].dialog
		end

		if not arg1_27 then
			arg0_27:playCV(var1_27)
		end

		setText(arg0_27.chatText, var2_27)

		local var3_27 = arg0_27.chatText:GetComponent(typeof(Text))

		if #var3_27.text > CHAT_POP_STR_LEN_SHORT then
			var3_27.alignment = TextAnchor.MiddleLeft
		else
			var3_27.alignment = TextAnchor.MiddleCenter
		end

		;(function()
			local var0_28 = 3
			local var1_28 = 0.3

			LeanTween.scale(rtf(arg0_27.chat.gameObject), Vector3.New(1, 1, 1), var1_28):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_27 then
					LeanTween.scale(rtf(arg0_27.chat.gameObject), Vector3.New(0, 0, 1), var1_28):setEase(LeanTweenType.easeInBack):setDelay(var1_28 + var0_28):setOnComplete(System.Action(function()
						arg0_27.chatFlag = nil

						setActive(arg0_27.chat, false)

						if arg0_27.contextData.noRes and #arg0_27.contextData.noRes > 0 then
							arg0_27:updateNoRes()
						end
					end))
				else
					arg0_27.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_31)
	local var0_31 = arg0_31.painting.localPosition + Vector3(-21, -176, 0)
	local var1_31 = arg0_31.painting.parent:TransformPoint(var0_31)
	local var2_31 = arg0_31.chat.parent:InverseTransformPoint(var1_31)

	arg0_31.chat.localPosition = Vector3(var2_31.x, var2_31.y, 0)
end

function var0_0.playHeartEffect(arg0_32)
	if arg0_32.heartsTimer then
		arg0_32.heartsTimer:Stop()
	end

	local var0_32 = arg0_32.painting:Find("heartsfly")

	setActive(var0_32, true)

	arg0_32.heartsTimer = Timer.New(function()
		setActive(var0_32, false)
	end, 1, 1)

	arg0_32.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_34)
	local var0_34 = Live2DPainting.GenerateData({
		ship = Ship.New({
			configId = 312011
		}),
		offset = {
			0,
			0,
			0,
			75
		},
		position = Vector3(0, 0, 0),
		parent = arg0_34._tf:Find("frame/painting/live2d")
	})

	arg0_34.live2dChar = Live2DPainting.New(var0_34, function(arg0_35)
		arg0_35:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
	end)
end

function var0_0.checkBuyDone(arg0_36, arg1_36)
	if not arg0_36.live2dChar or not arg0_36.live2dChar:IsLoaded() then
		return
	end

	local var0_36

	if type(arg1_36) == "string" then
		if arg1_36 == "damonds" then
			var0_36 = "diamond"
		else
			var0_36 = arg1_36
		end
	else
		local var1_36 = pg.shop_template[arg1_36]

		if var1_36 and var1_36.effect_args and type(var1_36.effect_args) == "table" then
			for iter0_36, iter1_36 in ipairs(var1_36.effect_args) do
				if iter1_36 == 1 then
					var0_36 = "gold"
				end
			end
		end
	end

	local var2_36 = arg0_36.preAniName == "gold" or arg0_36.preAniName == "diamond"
	local var3_36 = var0_36 == "gold" or var0_36 == "diamond"
	local var4_36 = var2_36 and var3_36 or not var2_36

	var4_36 = var0_36 and arg0_36.preAniName ~= var0_36 and var4_36

	if var4_36 then
		arg0_36.preAniName = var0_36

		arg0_36.live2dChar:TriggerAction(var0_36, nil, true)
	end

	return var4_36
end

function var0_0.playCV(arg0_37, arg1_37)
	local var0_37 = pg.pay_level_award[arg1_37]
	local var1_37

	if var0_37 and var0_37.cv_key ~= "" then
		var1_37 = "event:/cv/chargeShop/" .. var0_37.cv_key
	end

	if var1_37 then
		arg0_37:stopCV()

		arg0_37._currentVoice = var1_37

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_37)
	end
end

function var0_0.stopCV(arg0_38)
	if arg0_38._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_38._currentVoice)
	end

	arg0_38._currentVoice = nil
end

function var0_0.blurView(arg0_39)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_39.viewContainer, {
		pbList = {
			arg0_39.viewContainer:Find("blurBg")
		}
	})
end

function var0_0.unBlurView(arg0_40)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_40.viewContainer, arg0_40.frame)
end

function var0_0.jpUIInit(arg0_41)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_41.userAgreeBtn3 = arg0_41._tf:Find("frame/raw1Btn")
	arg0_41.userAgreeBtn4 = arg0_41._tf:Find("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_42)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_42, arg0_42.userAgreeBtn3, function()
		local var0_43 = require("ShareCfg.UserAgreement3")

		arg0_42:emit(ChargeMediator.OPEN_USER_AGREE, var0_43 or "")
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.userAgreeBtn4, function()
		local var0_44 = require("ShareCfg.UserAgreement4")

		arg0_42:emit(ChargeMediator.OPEN_USER_AGREE, var0_44 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_45, arg1_45)
	local function var0_45()
		if arg0_45.refreshTimer then
			arg0_45.refreshTimer:Stop()

			arg0_45.refreshTimer = nil
		end
	end

	var0_45()

	arg0_45.refreshTimer = Timer.New(function()
		local var0_47 = arg1_45 + 1 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_47 <= 0 then
			var0_45()
			arg0_45:emit(ChargeMediator.GET_CHARGE_LIST)
		else
			local var1_47 = pg.TimeMgr.GetInstance():DescCDTime(var0_47)
		end
	end, 1, -1)

	arg0_45.refreshTimer:Start()
	arg0_45.refreshTimer.func()
end

function var0_0.checkFreeGiftTag(arg0_48)
	TagTipHelper.FreeGiftTag({
		arg0_48.giftTip
	})
end

return var0_0
