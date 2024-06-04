local var0 = class("ChargeScene", import("...base.BaseUI"))

var0.TYPE_DIAMOND = 1
var0.TYPE_GIFT = 2
var0.TYPE_ITEM = 3

function var0.getUIName(arg0)
	return "ChargeShopUI"
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.preload(arg0, arg1)
	local var0 = getProxy(ShopsProxy)

	local function var1()
		local var0 = var0:getFirstChargeList()
		local var1 = var0:getChargedList()
		local var2 = var0:GetNormalList()
		local var3 = var0:GetNormalGroupList()

		if var0 then
			arg0:setFirstChargeIds(var0)
		end

		if var1 then
			arg0:setChargedList(var1)
		end

		if var2 then
			arg0:setNormalList(var2)
		end

		if var3 then
			arg0:setNormalGroupList(var3)
		end

		arg1()
	end

	if var0:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1
		})
	else
		var1()
	end
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setFirstChargeIds(arg0, arg1)
	arg0.firstChargeIds = arg1
end

function var0.setChargedList(arg0, arg1)
	arg0.chargedList = arg1
end

function var0.setNormalList(arg0, arg1)
	arg0.normalList = arg1
end

function var0.setNormalGroupList(arg0, arg1)
	arg0.normalGroupList = arg1

	arg0:addRefreshTimer(GetZeroTime())
end

function var0.ResUISettings(arg0)
	return true
end

function var0.init(arg0)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.top = arg0:findTF("adapt/top", arg0.blurPanel)
	arg0.frame = arg0:findTF("frame")
	arg0.viewContainer = arg0:findTF("viewContainer")
	arg0.bg = arg0:findTF("viewContainer/bg")
	arg0.painting = arg0:findTF("frame/painting")
	arg0.chat = arg0:findTF("viewContainer/chat")
	arg0.chatText = arg0:findTF("Text", arg0.chat)
	arg0.switchBtn = arg0:findTF("blur_panel/adapt/switch_btn")
	arg0.skinShopBtn = arg0:findTF("blur_panel/adapt/skin_btn")
	arg0.itemToggle = arg0:findTF("toggle_list/item_toggle", arg0.viewContainer)
	arg0.giftToggle = arg0:findTF("toggle_list/gift_toggle", arg0.viewContainer)
	arg0.diamondToggle = arg0:findTF("toggle_list/diamond_toggle", arg0.viewContainer)
	arg0.giftTip = arg0:findTF("tip", arg0.giftToggle)
	arg0.chargeTipWindow = ChargeTipWindow.New(arg0._tf, arg0.event)

	local var0 = arg0:findTF("light/title", arg0.diamondToggle)
	local var1 = arg0:findTF("dark/title", arg0.diamondToggle)
	local var2 = arg0:findTF("light/title", arg0.giftToggle)
	local var3 = arg0:findTF("dark/title", arg0.giftToggle)
	local var4 = arg0:findTF("light/title", arg0.itemToggle)
	local var5 = arg0:findTF("dark/title", arg0.itemToggle)

	setText(var0, i18n("shop_diamond_title"))
	setText(var1, i18n("shop_diamond_title"))
	setText(var2, i18n("shop_gift_title"))
	setText(var3, i18n("shop_gift_title"))
	setText(var4, i18n("shop_item_title"))
	setText(var5, i18n("shop_item_title"))

	arg0.linkTitle = {
		arg0:findTF("title/title_diamond", arg0.top),
		arg0:findTF("title/title_gift", arg0.top),
		arg0:findTF("title/title_item", arg0.top)
	}
	arg0.toggleList = {
		arg0.diamondToggle,
		arg0.giftToggle,
		arg0.itemToggle
	}

	arg0:createLive2D()

	arg0.live2dTimer = Timer.New(function()
		local var0 = pg.ChargeShipTalkInfo.Actions
		local var1 = var0[math.random(#var0)]

		if arg0:checkBuyDone(var1.action) then
			arg0:displayShipWord(nil, false, var1.dialog_index)
		end
	end, 20, -1)

	arg0.live2dTimer:Start()
	arg0:jpUIInit()
	arg0:blurView()
	arg0:initSubView()
end

function var0.didEnter(arg0)
	setActive(arg0.chat, false)
	onButton(arg0, arg0:findTF("back_button", arg0.top), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.painting, function()
		arg0:displayShipWord()
		arg0:emit(ChargeMediator.CLICK_MING_SHI)
	end, SFX_PANEL)

	for iter0 = 1, #arg0.toggleList do
		local var0 = arg0.toggleList[iter0]

		onToggle(arg0, var0, function(arg0)
			local var0 = arg0:findTF("dark", var0)

			setActive(var0, not arg0)

			if arg0 then
				arg0:switchSubView(iter0)
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.switchBtn, function()
		arg0:emit(ChargeMediator.SWITCH_TO_SHOP, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
		arg0:stopCV()
	end, SFX_PANEL)
	onButton(arg0, arg0.skinShopBtn, function()
		arg0:emit(ChargeMediator.ON_SKIN_SHOP)
	end, SFX_PANEL)
	arg0:updateNoRes()

	if arg0.contextData.wrap ~= nil then
		arg0:switchSubViewByTogger(arg0.contextData.wrap)

		arg0.contextData.wrap = nil
	else
		arg0:switchSubViewByTogger(ChargeScene.TYPE_DIAMOND)
	end

	arg0:jpUIEnter()
end

function var0.OnChargeSuccess(arg0, arg1)
	arg0.chargeTipWindow:ExecuteAction("Show", arg1)
end

function var0.willExit(arg0)
	arg0:unBlurView()

	if arg0.chargeTipWindow then
		arg0.chargeTipWindow:Destroy()

		arg0.chargeTipWindow = nil
	end

	if arg0.heartsTimer then
		arg0.heartsTimer:Stop()

		arg0.heartsTimer = nil
	end

	if arg0.live2dChar then
		arg0.live2dChar:Dispose()
	end

	if arg0.live2dTimer then
		arg0.live2dTimer:Stop()

		arg0.live2dTimer = nil
	end

	if arg0.giftShopView then
		arg0.giftShopView:OnDestroy()
	end

	arg0:stopCV()
end

function var0.initSubView(arg0)
	arg0.subViewContainer = arg0:findTF("SubView", arg0.viewContainer)
	arg0.diamondShopView = ChargeDiamondShopView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.giftShopView = ChargeGiftShopView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.itemShopView = ChargeItemShopView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.curSubViewNum = 0
	arg0.subViewList = {
		[ChargeScene.TYPE_DIAMOND] = arg0.diamondShopView,
		[ChargeScene.TYPE_GIFT] = arg0.giftShopView,
		[ChargeScene.TYPE_ITEM] = arg0.itemShopView
	}
end

function var0.switchSubView(arg0, arg1)
	if arg1 == arg0.curSubViewNum then
		return
	end

	arg0.subViewList[arg1]:setGoodData(arg0.firstChargeIds, arg0.chargedList, arg0.normalList, arg0.normalGroupList)
	arg0.subViewList[arg1]:Reset()
	arg0.subViewList[arg1]:Load()

	local var0 = arg0.subViewList[arg0.curSubViewNum]

	if var0 then
		var0:Destroy()
	end

	arg0.curSubViewNum = arg1

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0.userAgreeBtn3, arg1 == var0.TYPE_DIAMOND)
		setActive(arg0.userAgreeBtn4, arg1 == var0.TYPE_DIAMOND)
	end

	for iter0, iter1 in ipairs(arg0.linkTitle) do
		setActive(iter1, iter0 == arg1)
	end
end

function var0.switchSubViewByTogger(arg0, arg1)
	local var0 = arg0.toggleList[arg1]

	triggerToggle(var0, true)
end

function var0.updateCurSubView(arg0)
	local var0 = arg0.subViewList[arg0.curSubViewNum]

	var0:setGoodData(arg0.firstChargeIds, arg0.chargedList, arg0.normalList, arg0.normalGroupList)
	var0:reUpdateAll()
end

function var0.updateNoRes(arg0, arg1)
	if not arg1 then
		arg1 = arg0.contextData.noRes
	else
		arg0.contextData.noRes = arg1
	end

	if not arg1 or #arg1 <= 0 then
		return
	end

	arg0.contextData.noRes = {}

	local var0 = getProxy(BagProxy):getData()
	local var1 = ""

	for iter0, iter1 in ipairs(arg1) do
		if iter1[2] > 0 then
			if iter1[1] == 59001 then
				arg1[iter0][2] = iter1[3] - arg0.player.gold
			else
				arg1[iter0][2] = iter1[3] - (var0[iter1[1]] and var0[iter1[1]].count or 0)
			end
		end

		if arg1[iter0][2] > 0 then
			table.insert(arg0.contextData.noRes, arg1[iter0])
		end
	end

	for iter2, iter3 in ipairs(arg0.contextData.noRes) do
		local var2 = Item.getConfigData(iter3[1]).name

		var1 = var1 .. i18n(iter3[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2, iter3[2])

		if iter2 < #arg0.contextData.noRes then
			var1 = var1 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1 == "" then
		arg0:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0:displayShipWord(i18n("text_shop_noRes_tip", var1), true)
	end
end

function var0.displayShipWord(arg0, arg1, arg2, arg3)
	if not arg0.chatFlag then
		if not arg1 and arg0.contextData.noRes and #arg0.contextData.noRes > 0 then
			setActive(arg0.chat, false)

			arg0.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0.chatFlag = true

		if not arg0.isInitChatPosition then
			arg0.isInitChatPosition = true

			arg0:InitChatPosition()
		end

		setActive(arg0.chat, true)

		local var0 = arg0.player:getChargeLevel()
		local var1 = arg3 or math.random(1, var0)
		local var2

		if arg3 then
			var2 = pg.pay_level_award[var1].dialog
		else
			var2 = arg1 or pg.pay_level_award[var1].dialog
		end

		if not arg1 then
			arg0:playCV(var1)
		end

		setText(arg0.chatText, var2)

		local var3 = arg0.chatText:GetComponent(typeof(Text))

		if #var3.text > CHAT_POP_STR_LEN_SHORT then
			var3.alignment = TextAnchor.MiddleLeft
		else
			var3.alignment = TextAnchor.MiddleCenter
		end

		;(function()
			local var0 = 3
			local var1 = 0.3

			LeanTween.scale(rtf(arg0.chat.gameObject), Vector3.New(1, 1, 1), var1):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2 then
					LeanTween.scale(rtf(arg0.chat.gameObject), Vector3.New(0, 0, 1), var1):setEase(LeanTweenType.easeInBack):setDelay(var1 + var0):setOnComplete(System.Action(function()
						arg0.chatFlag = nil

						setActive(arg0.chat, false)

						if arg0.contextData.noRes and #arg0.contextData.noRes > 0 then
							arg0:updateNoRes()
						end
					end))
				else
					arg0.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0.InitChatPosition(arg0)
	local var0 = arg0.painting.localPosition + Vector3(-21, -176, 0)
	local var1 = arg0.painting.parent:TransformPoint(var0)
	local var2 = arg0.chat.parent:InverseTransformPoint(var1)

	arg0.chat.localPosition = Vector3(var2.x, var2.y, 0)
end

function var0.playHeartEffect(arg0)
	if arg0.heartsTimer then
		arg0.heartsTimer:Stop()
	end

	local var0 = arg0.painting:Find("heartsfly")

	setActive(var0, true)

	arg0.heartsTimer = Timer.New(function()
		setActive(var0, false)
	end, 1, 1)

	arg0.heartsTimer:Start()
end

function var0.createLive2D(arg0)
	local var0 = Live2D.GenerateData({
		ship = Ship.New({
			configId = 312011
		}),
		scale = Vector3(75, 75, 75),
		position = Vector3(0, 0, 0),
		parent = arg0:findTF("frame/painting/live2d")
	})

	arg0.live2dChar = Live2D.New(var0)
end

function var0.checkBuyDone(arg0, arg1)
	if not arg0.live2dChar then
		return
	end

	local var0

	if type(arg1) == "string" then
		if arg1 == "damonds" then
			var0 = "diamond"
		else
			var0 = arg1
		end
	else
		local var1 = pg.shop_template[arg1]

		if var1 and var1.effect_args and type(var1.effect_args) == "table" then
			for iter0, iter1 in ipairs(var1.effect_args) do
				if iter1 == 1 then
					var0 = "gold"
				end
			end
		end
	end

	local var2 = arg0.preAniName == "gold" or arg0.preAniName == "diamond"
	local var3 = var0 == "gold" or var0 == "diamond"
	local var4 = var2 and var3 or not var2

	var4 = var0 and arg0.preAniName ~= var0 and var4

	if var4 then
		arg0.preAniName = var0

		arg0.live2dChar:TriggerAction(var0, nil, true)
	end

	return var4
end

function var0.playCV(arg0, arg1)
	local var0 = pg.pay_level_award[arg1]
	local var1

	if var0 and var0.cv_key ~= "" then
		var1 = "event:/cv/chargeShop/" .. var0.cv_key
	end

	if var1 then
		arg0:stopCV()

		arg0._currentVoice = var1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1)
	end
end

function var0.stopCV(arg0)
	if arg0._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0._currentVoice)
	end

	arg0._currentVoice = nil
end

function var0.blurView(arg0)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.viewContainer, {
		pbList = {
			arg0:findTF("blurBg", arg0.viewContainer)
		}
	})
end

function var0.unBlurView(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.viewContainer, arg0.frame)
end

function var0.jpUIInit(arg0)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0.userAgreeBtn3 = arg0:findTF("frame/raw1Btn")
	arg0.userAgreeBtn4 = arg0:findTF("frame/raw2Btn")
end

function var0.jpUIEnter(arg0)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0, arg0.userAgreeBtn3, function()
		local var0 = require("ShareCfg.UserAgreement3")

		arg0:emit(ChargeMediator.OPEN_USER_AGREE, var0 or "")
	end, SFX_PANEL)
	onButton(arg0, arg0.userAgreeBtn4, function()
		local var0 = require("ShareCfg.UserAgreement4")

		arg0:emit(ChargeMediator.OPEN_USER_AGREE, var0 or "")
	end, SFX_PANEL)
end

function var0.addRefreshTimer(arg0, arg1)
	local function var0()
		if arg0.refreshTimer then
			arg0.refreshTimer:Stop()

			arg0.refreshTimer = nil
		end
	end

	var0()

	arg0.refreshTimer = Timer.New(function()
		local var0 = arg1 + 1 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= 0 then
			var0()
			arg0:emit(ChargeMediator.GET_CHARGE_LIST)
		else
			local var1 = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end
	end, 1, -1)

	arg0.refreshTimer:Start()
	arg0.refreshTimer.func()
end

function var0.checkFreeGiftTag(arg0)
	TagTipHelper.FreeGiftTag({
		arg0.giftTip
	})
end

return var0
