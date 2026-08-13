local var0_0 = class("NewShopMainScene", import("...base.BaseUI"))

var0_0.CLOSE_ALL_LAYER = "NewShopMainScene.CLOSE_ALL_LAYER"
var0_0.SHOW_OR_HIDE_UI = "NewShopMainScene.SHOW_OR_HIDE_UI"
var0_0.SHOW_OR_HIDE_UI_2 = "NewShopMainScene.SHOW_OR_HIDE_UI_2"
var0_0.CLOSE_VIEW = "NewShopMainScene.CLOSE_VIEW"
var0_0.TYPE_CHARGE = "charge"
var0_0.TYPE_SKIN = "skin"
var0_0.ON_CLICK_SKIN_SHOP = "NewShopMainScene::ON_CLICK_SKIN_SHOP"

function var0_0.getUIName(arg0_1)
	return "NewShopUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ShopsProxy)

	local function var1_2()
		local var0_3 = var0_2:getFirstChargeList()
		local var1_3 = var0_2:getChargedList()
		local var2_3 = var0_2:GetNormalList()
		local var3_3 = var0_2:GetNormalGroupList()

		if var0_3 then
			arg0_2:setFirstChargeIds(var0_3)
		end

		if var1_3 then
			arg0_2:setChargedList(var1_3)
		end

		if var2_3 then
			arg0_2:setNormalList(var2_3)
		end

		if var3_3 then
			arg0_2:setNormalGroupList(var3_3)
		end

		arg1_2()
	end

	if var0_2:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1_2
		})
	else
		var1_2()
	end
end

function var0_0.init(arg0_4)
	local var0_4 = arg0_4._tf:Find("buttonList")

	arg0_4.buttonList = var0_4
	arg0_4.backBtn = var0_4:Find("top/closeBtn")
	arg0_4.homeBtn = var0_4:Find("top/homeBtn")
	arg0_4.resourcePanel = var0_4:Find("top/resources")

	setActive(arg0_4.resourcePanel, false)

	arg0_4.goldBtn = var0_4:Find("top/resources/gold")
	arg0_4.goldText = var0_4:Find("top/resources/gold/Text"):GetComponent(typeof(Text))
	arg0_4.goldMax = var0_4:Find("top/resources/gold/max"):GetComponent(typeof(Text))
	arg0_4.oilBtn = var0_4:Find("top/resources/oil")
	arg0_4.oilText = var0_4:Find("top/resources/oil/Text"):GetComponent(typeof(Text))
	arg0_4.oilMax = var0_4:Find("top/resources/oil/max"):GetComponent(typeof(Text))
	arg0_4.diamondBtn = var0_4:Find("top/resources/gem")
	arg0_4.diamondText = var0_4:Find("top/resources/gem/Text"):GetComponent(typeof(Text))

	setText(var0_4:Find("top/title/Text"), i18n("shop_title"))
	setText(var0_4:Find("shop1List/recommendation/shop1Tg/name"), i18n("shop_recommend"))
	setText(var0_4:Find("shop1List/skinShop/shop1Tg/name"), i18n("shop_skin"))
	setText(var0_4:Find("shop1List/diamondShop/shop1Tg/name"), i18n("shop_diamond_title"))
	setText(var0_4:Find("shop1List/specialShop/shop1Tg/name"), i18n("shop_akashi_pick_title"))
	setText(var0_4:Find("shop1List/giftPackShop/shop1Tg/name"), i18n("shop_gift_title"))
	setText(var0_4:Find("shop1List/functionalItemShop/shop1Tg/name"), i18n("shop_item_title"))
	setText(var0_4:Find("shop1List/supplyShop/shop1Tg/name"), i18n("shop_supply_prop"))
	setText(var0_4:Find("shop1List/recommendation/shop1Tg/name/en"), i18n("shop_recommend_en"))
	setText(var0_4:Find("shop1List/skinShop/shop1Tg/name/en"), i18n("shop_skin_en"))
	setText(var0_4:Find("shop1List/diamondShop/shop1Tg/name/en"), i18n("shop_diamond_title_en"))
	setText(var0_4:Find("shop1List/specialShop/shop1Tg/name/en"), i18n("shop_side_lable_en"))
	setText(var0_4:Find("shop1List/giftPackShop/shop1Tg/name/en"), i18n("shop_gift_title_en"))
	setText(var0_4:Find("shop1List/functionalItemShop/shop1Tg/name/en"), i18n("shop_item_title_en"))
	setText(var0_4:Find("shop1List/supplyShop/shop1Tg/name/en"), i18n("shop_supply_prop_en"))
	setText(var0_4:Find("shop1List/supplyShop/shop2List/monthShop/name"), i18n("shop_month"))
	setText(var0_4:Find("shop1List/supplyShop/shop2List/monthShop/selected/name"), i18n("shop_month"))
	setText(var0_4:Find("shop1List/supplyShop/shop2List/supplyShop/name"), i18n("shop_supply"))
	setText(var0_4:Find("shop1List/supplyShop/shop2List/supplyShop/selected/name"), i18n("shop_supply"))
	setText(var0_4:Find("shop1List/supplyShop/shop2List/activityShop/name"), i18n("shop_activity"))
	setText(var0_4:Find("shop1List/supplyShop/shop2List/activityShop/selected/name"), i18n("shop_activity"))

	arg0_4.frame = arg0_4._tf:Find("frame")
	arg0_4.viewContainer = arg0_4._tf:Find("viewContainer")
	arg0_4.painting = arg0_4._tf:Find("frame/painting")
	arg0_4.chat = arg0_4._tf:Find("frame/chat")
	arg0_4.chatText = arg0_4.chat:Find("Text")
	arg0_4.stamp = arg0_4._tf:Find("frame/stamp")
	arg0_4.specialTip = var0_4:Find("shop1List/specialShop/shop1Tg/tip")
	arg0_4.giftTip = var0_4:Find("shop1List/giftPackShop/shop1Tg/tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_4.specialTip, {
		"specialShop",
		"Charge_Page_Exposure"
	}, function(arg0_5)
		getProxy(ShopsProxy):GiftPackageRedDotTip({
			arg0_5
		}, true)
	end)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_4.giftTip, {
		"specialShop",
		"Charge_Page_Exposure"
	}, function(arg0_6)
		getProxy(ShopsProxy):GiftPackageRedDotTip({
			arg0_6
		}, false)
	end)

	arg0_4.toggleList = {
		{
			type = ChargeScene.TYPE_DIAMOND,
			go = var0_4:Find("shop1List/diamondShop/shop1Tg")
		},
		{
			type = ChargeScene.TYPE_GIFT,
			go = var0_4:Find("shop1List/giftPackShop/shop1Tg")
		},
		{
			type = ChargeScene.TYPE_ITEM,
			go = var0_4:Find("shop1List/functionalItemShop/shop1Tg")
		},
		{
			type = ChargeScene.TYPE_PICK,
			go = var0_4:Find("shop1List/specialShop/shop1Tg")
		}
	}
	GetComponent(var0_4:Find("shop1List/supplyShop/shop2List/supplyShop"), typeof(Toggle)).isOn = true
	arg0_4.chargeTipWindow = ChargeTipWindow.New(arg0_4._tf, arg0_4.event)

	arg0_4:LoadMingshi()
	arg0_4:jpUIInit()
	arg0_4:blurView()
	arg0_4:initSubView()

	arg0_4.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_4, arg0_4.pageContainer, Vector2.New(-35, -90))

	if arg0_4.bulinTip then
		arg0_4.bulinTip:RegisterView(arg0_4)
		arg0_4.bulinTip:CallbackInvoke(function()
			arg0_4:OverlayPanel(arg0_4.bulinTip._tf, {
				groupDelta = 1
			})
		end)

		function arg0_4.bulinTip.destroyCall()
			if arg0_4.bulinTip:GetLoaded() then
				arg0_4:UnOverlayPanel(arg0_4.bulinTip._tf)
			end
		end
	end
end

function var0_0.setPlayer(arg0_9, arg1_9)
	arg0_9.player = arg1_9

	if arg0_9.subViewList[arg0_9.curSubViewNum] and arg0_9.subViewList[arg0_9.curSubViewNum]:IsSupplyShop() then
		arg0_9.subViewList[arg0_9.curSubViewNum]:SetPlayer(arg1_9)
	end

	if arg0_9.goldMax then
		PlayerResUI.StaticFlush(arg0_9.player, arg0_9.goldMax, arg0_9.goldText, arg0_9.oilMax, arg0_9.oilText, arg0_9.diamondText)
	end
end

function var0_0.setFirstChargeIds(arg0_10, arg1_10)
	arg0_10.firstChargeIds = arg1_10
end

function var0_0.setChargedList(arg0_11, arg1_11)
	arg0_11.chargedList = arg1_11
end

function var0_0.setNormalList(arg0_12, arg1_12)
	arg0_12.normalList = arg1_12
end

function var0_0.setNormalGroupList(arg0_13, arg1_13)
	arg0_13.normalGroupList = arg1_13

	arg0_13:addRefreshTimer(GetZeroTime())
end

function var0_0.SetSupplyShopList(arg0_14, arg1_14)
	arg0_14.supplyShopList = arg1_14

	arg0_14:SortActivityShops()
end

function var0_0.SortActivityShops(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.supplyShopList) do
		if #iter1_15 > 1 then
			table.sort(iter1_15, function(arg0_16, arg1_16)
				return arg0_16:getStartTime() > arg1_16:getStartTime()
			end)
		end
	end
end

function var0_0.OnInitItems(arg0_17, arg1_17)
	arg0_17.items = arg1_17

	arg0_17.subViewList[ShopConst.SHOP_ID.MONTH]:OnUpdateItems(arg1_17)
	arg0_17.subViewList[ShopConst.SHOP_ID.SUPPLY]:OnUpdateItems(arg1_17)
	arg0_17.subViewList[ShopConst.SHOP_ID.ACTIVITY]:OnUpdateItems(arg1_17)
end

function var0_0.OnUpdateItems(arg0_18, arg1_18)
	arg0_18.items = arg1_18

	if arg0_18.subViewList[arg0_18.curSubViewNum] and arg0_18.subViewList[arg0_18.curSubViewNum]:IsSupplyShop() then
		arg0_18.subViewList[arg0_18.curSubViewNum]:OnUpdateItems(arg1_18)
	end
end

function var0_0.OnUpdateShop(arg0_19, arg1_19, arg2_19)
	arg0_19:SetShop(arg1_19, arg2_19)

	if arg0_19.subViewList[arg0_19.curSubViewNum] and arg0_19.subViewList[arg0_19.curSubViewNum]:IsSupplyShop() then
		arg0_19.subViewList[arg0_19.curSubViewNum]:OnUpdateShop(arg1_19, arg2_19)
	end
end

function var0_0.OnUpdateCommodity(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20:SetShop(arg1_20, arg2_20)

	if arg0_20.subViewList[arg0_20.curSubViewNum] and arg0_20.subViewList[arg0_20.curSubViewNum]:IsSupplyShop() then
		arg0_20.subViewList[arg0_20.curSubViewNum]:OnUpdateCommodity(arg1_20, arg2_20, arg3_20)
	end
end

function var0_0.OnFragmentSellUpdate(arg0_21)
	if arg0_21.subViewList[arg0_21.curSubViewNum] and arg0_21.subViewList[arg0_21.curSubViewNum]:IsSupplyShop() then
		arg0_21.subViewList[arg0_21.curSubViewNum]:OnFragmentSellUpdate()
	end
end

function var0_0.SetShop(arg0_22, arg1_22, arg2_22)
	if not arg0_22.supplyShopList then
		return
	end

	local var0_22 = arg0_22.supplyShopList[arg1_22]

	if var0_22 then
		for iter0_22, iter1_22 in ipairs(var0_22) do
			if iter1_22:IsSameKind(arg2_22) then
				arg0_22.supplyShopList[arg1_22][iter0_22] = arg2_22

				break
			end
		end
	end
end

function var0_0.didEnter(arg0_23)
	arg0_23.eventIDList = {
		arg0_23:bind(var0_0.ON_CLICK_SKIN_SHOP, handler(arg0_23, arg0_23.OnClickSkinShop))
	}

	setActive(arg0_23.chat, false)
	onButton(arg0_23, arg0_23.backBtn, function()
		arg0_23:closeView()
	end, SFX_CANCEL)
	onButton(arg0_23, arg0_23.homeBtn, function()
		arg0_23:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_23, arg0_23.goldBtn, function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.oilBtn, function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.diamondBtn, function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	onToggle(arg0_23, arg0_23.buttonList:Find("shop1List/recommendation/shop1Tg"), function(arg0_29)
		if arg0_29 then
			arg0_23.contextData.shop1 = nil
			arg0_23.contextData.shop2 = nil

			if arg0_23.shop1 == "recommendation" then
				return
			end

			arg0_23.shop1 = "recommendation"
			arg0_23.shop2 = nil

			arg0_23:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_23:emit(NewShopMainMediator.OPEN_LAYER, NewRecommendationShopLayer, NewRecommendationShopMediator)
		end
	end, SFX_PANEL)
	arg0_23:InitSkinToggleList()

	for iter0_23 = 1, #arg0_23.toggleList do
		local var0_23 = arg0_23.toggleList[iter0_23]

		onToggle(arg0_23, var0_23.go, function(arg0_30)
			if arg0_30 then
				arg0_23:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_23.contextData.shop1 = nil
				arg0_23.contextData.shop2 = nil
				arg0_23.shop1 = nil
				arg0_23.shop2 = nil

				originalPrint(string.format("Begin: toggleType=%s, goName=%s", var0_23.type, var0_23.go.parent.name))

				arg0_23.contextData.type = ShopConst.SHOP_TYPE.CHARGE
				arg0_23.contextData.warp = var0_23.type

				originalPrint(string.format("End: warp=%s", arg0_23.contextData.warp))

				local var0_30 = arg0_23:GetShopID(ShopConst.SHOP_TYPE.CHARGE, var0_23.type)

				arg0_23:switchSubView(var0_30)
			end

			local var1_30 = switch(var0_23.type, {
				[ChargeScene.TYPE_PICK] = function()
					return "payshop_pack_red_dot"
				end,
				[ChargeScene.TYPE_GIFT] = function()
					return "gemshop_pack_red_dot"
				end
			})

			if var1_30 then
				if arg0_30 then
					arg0_23.toggleMark = arg0_23.toggleMark or {}
					arg0_23.toggleMark[var0_23.type] = defaultValue(arg0_23.toggleMark[var0_23.type], 0) + 1
				elseif arg0_23.toggleMark and defaultValue(arg0_23.toggleMark[var0_23.type], 0) > 0 then
					arg0_23.toggleMark[var0_23.type] = arg0_23.toggleMark[var0_23.type] - 1

					PlayerPrefs.SetInt(var1_30, getGameset(var1_30)[1])
					pg.EasyRedDotMgr.GetInstance():TriggerMarks("Charge_Page_Exposure")
				end
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_23, arg0_23.buttonList:Find("shop1List/supplyShop/shop1Tg"), function(arg0_33)
		setActive(arg0_23.buttonList:Find("shop1List/supplyShop/shop2List"), arg0_33)

		if arg0_33 then
			triggerToggle(arg0_23.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_23:GetDefaultSupplyShopName()), true)
		end
	end, SFX_PANEL)

	local var1_23 = {
		{
			type = ShopConst.CATEGORY_MONTH,
			go = arg0_23.buttonList:Find("shop1List/supplyShop/shop2List/monthShop")
		},
		{
			type = ShopConst.CATEGORY_SUPPLY,
			go = arg0_23.buttonList:Find("shop1List/supplyShop/shop2List/supplyShop")
		},
		{
			type = ShopConst.CATEGORY_ACTIVITY,
			go = arg0_23.buttonList:Find("shop1List/supplyShop/shop2List/activityShop")
		}
	}

	for iter1_23, iter2_23 in ipairs(var1_23) do
		onToggle(arg0_23, iter2_23.go, function(arg0_34)
			if arg0_34 then
				arg0_23:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_23.contextData.shop1 = nil
				arg0_23.contextData.shop2 = nil
				arg0_23.shop1 = nil
				arg0_23.shop2 = nil
				arg0_23.contextData.type = ShopConst.SHOP_TYPE.SUPPLY
				arg0_23.contextData.warp = iter2_23.type

				local var0_34 = arg0_23:GetShopID(ShopConst.SHOP_TYPE.SUPPLY, iter2_23.type)

				arg0_23:switchSubView(var0_34)
			end
		end, SFX_PANEL)
	end

	local var2_23 = "recommendation"

	if arg0_23.contextData.type == ShopConst.SHOP_TYPE.CHARGE then
		if arg0_23.contextData.warp == ChargeScene.TYPE_DIAMOND then
			var2_23 = "diamondShop"
		elseif arg0_23.contextData.warp == ChargeScene.TYPE_GIFT then
			var2_23 = "giftPackShop"
		elseif arg0_23.contextData.warp == ChargeScene.TYPE_ITEM then
			var2_23 = "functionalItemShop"
		elseif arg0_23.contextData.warp == ChargeScene.TYPE_PICK then
			var2_23 = "specialShop"
		else
			var2_23 = "diamondShop"
		end
	elseif arg0_23.contextData.type == ShopConst.SHOP_TYPE.SKIN then
		var2_23 = "skinShop"
	elseif arg0_23.contextData.type == ShopConst.SHOP_TYPE.SUPPLY then
		var2_23 = "supplyShop"
	end

	if arg0_23.contextData.shop1 then
		var2_23 = arg0_23.contextData.shop1
	end

	triggerToggle(arg0_23.buttonList:Find("shop1List/" .. var2_23 .. "/shop1Tg"), true)

	if var2_23 == "skinShop" then
		-- block empty
	elseif var2_23 == "supplyShop" then
		triggerToggle(arg0_23.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_23:GetDefaultSupplyShopName()), true)
	end

	onButton(arg0_23, arg0_23.painting, function()
		arg0_23:displayShipWord()
		arg0_23:emit(NewShopMainMediator.CLICK_MING_SHI)
	end, SFX_PANEL)
	onButton(arg0_23, arg0_23.stamp, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	arg0_23:RefreshActivityShop()
	arg0_23:updateNoRes()
	arg0_23:jpUIEnter()
end

function var0_0.GetDefaultSupplyShopName(arg0_37)
	if arg0_37.contextData.type ~= ShopConst.SHOP_TYPE.SUPPLY then
		return "supplyShop"
	end

	local var0_37 = arg0_37.contextData.warp

	if type(var0_37) == "string" then
		local var1_37 = ShopConst.SHOP_NAME_LIST[var0_37]

		arg0_37.contextData.warp = var1_37[1]
		arg0_37.contextData.shopID = var1_37[2]
	elseif type(var0_37) == "number" and arg0_37.contextData.shopID == nil then
		for iter0_37, iter1_37 in pairs(ShopConst.SUPPLY_SHOP_LIST) do
			for iter2_37, iter3_37 in pairs(iter1_37) do
				if iter3_37 == var0_37 then
					arg0_37.contextData.warp = iter0_37
					arg0_37.contextData.shopID = iter3_37

					break
				end
			end
		end
	end

	local var2_37 = ""

	return arg0_37.contextData.warp == ShopConst.CATEGORY_MONTH and "monthShop" or arg0_37.contextData.warp == ShopConst.CATEGORY_SUPPLY and "supplyShop" or arg0_37.contextData.warp == ShopConst.CATEGORY_ACTIVITY and "activityShop" or "supplyShop"
end

function var0_0.RefreshActivityShop(arg0_38)
	local var0_38 = arg0_38.supplyShopList[ShopConst.TYPE_ACTIVITY] or {}

	setActive(arg0_38.buttonList:Find("shop1List/supplyShop/shop2List/activityShop"), #var0_38 > 0)
end

function var0_0.ShowOrHideUI(arg0_39, arg1_39)
	arg0_39:setVisible(arg1_39)
	setActive(arg0_39.buttonList, arg1_39)
end

function var0_0.ShowOrHideUI2(arg0_40, arg1_40)
	for iter0_40 = 0, arg0_40._tf.childCount - 1 do
		setActive(arg0_40._tf:GetChild(iter0_40), arg1_40)
	end

	setActive(arg0_40.buttonList:Find("leftBg"), arg1_40)
	setActive(arg0_40.buttonList:Find("shop1List"), arg1_40)
	setActive(arg0_40.buttonList:Find("top"), true)
end

function var0_0.OnChargeSuccess(arg0_41, arg1_41)
	arg0_41.chargeTipWindow:ExecuteAction("Show", arg1_41)
end

function var0_0.LoadMingshi(arg0_42)
	if Live2dConst.GetLive2DArm32MatchAble() then
		local var0_42 = Ship.New({
			configId = 312011
		}):getPainting()

		LoadPaintingPrefabAsync(arg0_42.painting, var0_42, var0_42, "mainNormal", function()
			arg0_42.loading = false
		end)
	else
		arg0_42:createLive2D()
	end

	arg0_42:AddLive2dTimer()
end

function var0_0.AddLive2dTimer(arg0_44)
	arg0_44:StopLive2dTimer()

	arg0_44.live2dTimer = Timer.New(function()
		local var0_45 = pg.ChargeShipTalkInfo.Actions
		local var1_45 = var0_45[math.random(#var0_45)]

		if arg0_44:checkBuyDone(var1_45.action) then
			arg0_44:displayShipWord(nil, false, var1_45.dialog_index)
		end
	end, 20, -1)

	arg0_44.live2dTimer:Start()
end

function var0_0.StopLive2dTimer(arg0_46)
	if arg0_46.live2dTimer then
		arg0_46.live2dTimer:Stop()

		arg0_46.live2dTimer = nil
	end
end

function var0_0.ShowChargeWarp(arg0_47, arg1_47)
	setActive(arg0_47.frame, arg1_47)
	setActive(arg0_47.viewContainer, arg1_47)
	arg0_47:ShowResourceBar(arg1_47)

	local var0_47 = arg0_47.subViewList[arg0_47.curSubViewNum]

	if var0_47 then
		if arg1_47 == false then
			var0_47:Destroy()

			arg0_47.curSubViewNum = 0
		else
			var0_47:ShowPanel(arg1_47)
		end
	end
end

function var0_0.ShowResourceBar(arg0_48, arg1_48)
	if arg0_48.resourceBarFlag == arg1_48 then
		return
	end

	arg0_48.resourceBarFlag = arg1_48

	setActive(arg0_48.resourcePanel, arg1_48)
end

function var0_0.willExit(arg0_49)
	for iter0_49, iter1_49 in ipairs(arg0_49.eventIDList) do
		arg0_49:disconnect(iter1_49)
	end

	arg0_49.eventIDList = nil

	if arg0_49.bulinTip then
		arg0_49.bulinTip:Destroy()

		arg0_49.bulinTip = nil
	end

	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_49.specialTip)
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_49.giftTip)

	if arg0_49.toggleMark then
		for iter2_49, iter3_49 in pairs(arg0_49.toggleMark) do
			if iter3_49 > 0 then
				local var0_49 = switch(iter2_49, {
					[ChargeScene.TYPE_PICK] = function()
						return "payshop_pack_red_dot"
					end,
					[ChargeScene.TYPE_GIFT] = function()
						return "gemshop_pack_red_dot"
					end
				})

				PlayerPrefs.SetInt(var0_49, getGameset(var0_49)[1])
			end
		end

		arg0_49.toggleMark = nil
	end

	arg0_49:ShowResourceBar()
	arg0_49:unBlurView()

	if arg0_49.chargeTipWindow then
		arg0_49.chargeTipWindow:Destroy()

		arg0_49.chargeTipWindow = nil
	end

	arg0_49.contextData.singleWindow:Destroy()
	arg0_49.contextData.multiWindow:Destroy()
	arg0_49.contextData.singleWindowForESkin:Destroy()
	arg0_49.contextData.paintingView:Dispose()

	arg0_49.contextData.singleWindow = nil
	arg0_49.contextData.multiWindow = nil
	arg0_49.contextData.singleWindowForESkin = nil
	arg0_49.contextData.paintingView = nil
	arg0_49.bulinTip = nil

	for iter4_49, iter5_49 in pairs(arg0_49.subViewList) do
		iter5_49:Destroy()
	end

	arg0_49.subViewList = nil

	if arg0_49.heartsTimer then
		arg0_49.heartsTimer:Stop()

		arg0_49.heartsTimer = nil
	end

	if arg0_49.live2dChar then
		arg0_49.live2dChar:Dispose()
	end

	arg0_49:StopLive2dTimer()
	arg0_49:stopCV()
	arg0_49:DisposeSkinToggleList()

	if arg0_49.giftShopView then
		arg0_49.giftShopView:OnDestroy()
	end
end

function var0_0.onBackPressed(arg0_52)
	if arg0_52.contextData.singleWindow:GetLoaded() and arg0_52.contextData.singleWindow:isShowing() then
		arg0_52.contextData.singleWindow:Close()

		return
	end

	if arg0_52.contextData.multiWindow:GetLoaded() and arg0_52.contextData.multiWindow:isShowing() then
		arg0_52.contextData.multiWindow:Close()

		return
	end

	if arg0_52.contextData.singleWindowForESkin:GetLoaded() and arg0_52.contextData.singleWindowForESkin:isShowing() then
		arg0_52.contextData.singleWindowForESkin:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_52)
end

function var0_0.initSubView(arg0_53)
	local var0_53 = ChargeDiamondShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData)
	local var1_53 = ChargeGiftShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData)
	local var2_53 = ChargeItemShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData)
	local var3_53 = ChargePickShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData)
	local var4_53 = SupplyShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData, ShopConst.CATEGORY_MONTH)
	local var5_53 = SupplyShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData, ShopConst.CATEGORY_SUPPLY)
	local var6_53 = SupplyShopView.New(arg0_53.viewContainer, arg0_53.event, arg0_53.contextData, ShopConst.CATEGORY_ACTIVITY)

	arg0_53.curSubViewNum = 0
	arg0_53.subViewList = {
		[ShopConst.SHOP_ID.DIAMOND] = var0_53,
		[ShopConst.SHOP_ID.GIFT] = var1_53,
		[ShopConst.SHOP_ID.ITEM] = var2_53,
		[ShopConst.SHOP_ID.PICK] = var3_53,
		[ShopConst.SHOP_ID.MONTH] = var4_53,
		[ShopConst.SHOP_ID.SUPPLY] = var5_53,
		[ShopConst.SHOP_ID.ACTIVITY] = var6_53
	}

	for iter0_53, iter1_53 in pairs(arg0_53.subViewList) do
		iter1_53:RegisterView(arg0_53)
	end

	arg0_53.contextData.singleWindow = ShopSingleWindow.New(arg0_53._tf, arg0_53.event)
	arg0_53.contextData.multiWindow = ShopMultiWindow.New(arg0_53._tf, arg0_53.event)
	arg0_53.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_53._tf, arg0_53.event)
	arg0_53.contextData.paintingView = ShopPaintingView.New(arg0_53._tf:Find("frame/supplyPaint"), arg0_53._tf:Find("frame/chat"))

	arg0_53.contextData.paintingView:setSecretaryPos(arg0_53._tf:Find("frame/secretaryPos"))
end

function var0_0.GetShopID(arg0_54, arg1_54, arg2_54)
	return ShopConst.SHOP_LIST[arg1_54][arg2_54]
end

function var0_0.switchSubView(arg0_55, arg1_55)
	originalPrint(string.format("End: shopID=%s curShopID=%s", arg1_55, arg0_55.curSubViewNum))

	if arg1_55 == arg0_55.curSubViewNum then
		return
	end

	arg0_55.subViewList[arg1_55]:setGoodData(arg0_55.firstChargeIds, arg0_55.chargedList, arg0_55.normalList, arg0_55.normalGroupList)
	arg0_55.subViewList[arg1_55]:Reset()
	arg0_55.subViewList[arg1_55]:Load()

	if arg0_55.subViewList[arg1_55].SetAllShopData then
		arg0_55.subViewList[arg1_55]:ActionInvoke("SetAllShopData", arg0_55.supplyShopList)
	end

	local var0_55 = arg0_55.subViewList[arg0_55.curSubViewNum]

	if var0_55 then
		var0_55:Destroy()
	end

	arg0_55.curSubViewNum = arg1_55

	arg0_55:SwitchPainting(arg0_55.subViewList[arg1_55]:IsSupplyShop())

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_55.userAgreeBtn3, arg1_55 == ChargeScene.TYPE_DIAMOND)
		setActive(arg0_55.userAgreeBtn4, arg1_55 == ChargeScene.TYPE_DIAMOND)
	end
end

function var0_0.SwitchPainting(arg0_56, arg1_56)
	arg0_56.contextData.paintingView:Show(arg1_56)
	setActive(arg0_56.painting, not arg1_56)

	if arg1_56 then
		arg0_56:StopLive2dTimer()

		arg0_56.chatFlag = nil

		arg0_56:stopCV()
		setActive(arg0_56.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

		if LOCK_CLICK_MINGSHI then
			setActive(arg0_56.stamp, false)
		end
	else
		setActive(arg0_56.stamp, false)
		arg0_56:AddLive2dTimer()
	end
end

function var0_0.switchSubViewByTogger(arg0_57, arg1_57)
	local var0_57 = arg0_57.toggleList[arg1_57]

	triggerToggle(var0_57.go, true)
end

function var0_0.updateCurSubView(arg0_58)
	if not isActive(arg0_58.viewContainer) then
		return
	end

	local var0_58 = arg0_58.subViewList[arg0_58.curSubViewNum]

	if var0_58 == nil then
		return
	end

	var0_58:setGoodData(arg0_58.firstChargeIds, arg0_58.chargedList, arg0_58.normalList, arg0_58.normalGroupList)
	var0_58:reUpdateAll()
end

function var0_0.updateNoRes(arg0_59, arg1_59)
	if not arg1_59 then
		arg1_59 = arg0_59.contextData.noRes
	else
		arg0_59.contextData.noRes = arg1_59
	end

	if not arg1_59 or #arg1_59 <= 0 then
		return
	end

	arg0_59.contextData.noRes = {}

	local var0_59 = getProxy(BagProxy):getData()
	local var1_59 = ""

	for iter0_59, iter1_59 in ipairs(arg1_59) do
		if iter1_59[2] > 0 then
			if iter1_59[1] == 59001 then
				arg1_59[iter0_59][2] = iter1_59[3] - arg0_59.player.gold
			else
				arg1_59[iter0_59][2] = iter1_59[3] - (var0_59[iter1_59[1]] and var0_59[iter1_59[1]].count or 0)
			end
		end

		if arg1_59[iter0_59][2] > 0 then
			table.insert(arg0_59.contextData.noRes, arg1_59[iter0_59])
		end
	end

	for iter2_59, iter3_59 in ipairs(arg0_59.contextData.noRes) do
		local var2_59 = Item.getConfigData(iter3_59[1]).name

		var1_59 = var1_59 .. i18n(iter3_59[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_59, iter3_59[2])

		if iter2_59 < #arg0_59.contextData.noRes then
			var1_59 = var1_59 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_59 == "" then
		arg0_59:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_59:displayShipWord(i18n("text_shop_noRes_tip", var1_59), true)
	end
end

function var0_0.displayShipWord(arg0_60, arg1_60, arg2_60, arg3_60)
	if not arg0_60.chatFlag then
		if not arg1_60 and arg0_60.contextData.noRes and #arg0_60.contextData.noRes > 0 then
			setActive(arg0_60.chat, false)

			arg0_60.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_60.chatFlag = true

		if not arg0_60.isInitChatPosition then
			arg0_60.isInitChatPosition = true

			arg0_60:InitChatPosition()
		end

		setActive(arg0_60.chat, true)

		local var0_60 = arg0_60.player:getChargeLevel()
		local var1_60 = arg3_60 or math.random(1, var0_60)
		local var2_60

		if arg3_60 then
			var2_60 = pg.pay_level_award[var1_60].dialog
		else
			var2_60 = arg1_60 or pg.pay_level_award[var1_60].dialog
		end

		if not arg1_60 then
			arg0_60:playCV(var1_60)
		end

		setText(arg0_60.chatText, var2_60)

		local var3_60 = arg0_60.chatText:GetComponent(typeof(Text))

		;(function()
			local var0_61 = 3
			local var1_61 = 0.3

			LeanTween.scale(rtf(arg0_60.chat.gameObject), Vector3.New(1, 1, 1), var1_61):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_60 then
					LeanTween.scale(rtf(arg0_60.chat.gameObject), Vector3.New(0, 0, 1), var1_61):setEase(LeanTweenType.easeInBack):setDelay(var1_61 + var0_61):setOnComplete(System.Action(function()
						arg0_60.chatFlag = nil

						setActive(arg0_60.chat, false)

						if arg0_60.contextData.noRes and #arg0_60.contextData.noRes > 0 then
							arg0_60:updateNoRes()
						end
					end))
				else
					arg0_60.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_64)
	return
end

function var0_0.playHeartEffect(arg0_65)
	if arg0_65.heartsTimer then
		arg0_65.heartsTimer:Stop()
	end

	local var0_65 = arg0_65.painting:Find("heartsfly")

	setActive(var0_65, true)

	arg0_65.heartsTimer = Timer.New(function()
		setActive(var0_65, false)
	end, 1, 1)

	arg0_65.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_67)
	local var0_67 = Live2DPainting.GenerateData({
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
		parent = arg0_67._tf:Find("frame/painting/live2d")
	})

	arg0_67.live2dChar = Live2DPainting.New(var0_67, function(arg0_68)
		arg0_68:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
	end)
end

function var0_0.checkBuyDone(arg0_69, arg1_69)
	if not arg0_69.live2dChar or not arg0_69.live2dChar:IsLoaded() then
		return
	end

	local var0_69

	if type(arg1_69) == "string" then
		if arg1_69 == "damonds" then
			var0_69 = "diamond"
		else
			var0_69 = arg1_69
		end
	else
		local var1_69 = pg.shop_template[arg1_69]

		if var1_69 and var1_69.effect_args and type(var1_69.effect_args) == "table" then
			for iter0_69, iter1_69 in ipairs(var1_69.effect_args) do
				if iter1_69 == 1 then
					var0_69 = "gold"
				end
			end
		end
	end

	local var2_69 = arg0_69.preAniName == "gold" or arg0_69.preAniName == "diamond"
	local var3_69 = var0_69 == "gold" or var0_69 == "diamond"
	local var4_69 = var2_69 and var3_69 or not var2_69

	var4_69 = var0_69 and arg0_69.preAniName ~= var0_69 and var4_69

	if var4_69 then
		arg0_69.preAniName = var0_69

		arg0_69.live2dChar:TriggerAction(var0_69, nil, true)
	end

	return var4_69
end

function var0_0.playCV(arg0_70, arg1_70)
	local var0_70 = pg.pay_level_award[arg1_70]
	local var1_70

	if var0_70 and var0_70.cv_key ~= "" then
		var1_70 = "event:/cv/chargeShop/" .. var0_70.cv_key
	end

	if var1_70 then
		arg0_70:stopCV()

		arg0_70._currentVoice = var1_70

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_70)
	end
end

function var0_0.stopCV(arg0_71)
	if arg0_71._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_71._currentVoice)
	end

	arg0_71._currentVoice = nil
end

function var0_0.blurView(arg0_72)
	arg0_72:OverlayPanel(arg0_72.buttonList, {
		pbList = {
			arg0_72.buttonList:Find("leftBg")
		}
	})
end

function var0_0.unBlurView(arg0_73)
	arg0_73:UnOverlayPanel(arg0_73.buttonList, arg0_73._tf)
end

function var0_0.jpUIInit(arg0_74)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_74.userAgreeBtn3 = arg0_74._tf:Find("frame/raw1Btn")
	arg0_74.userAgreeBtn4 = arg0_74._tf:Find("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_75)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_75, arg0_75.userAgreeBtn3, function()
		local var0_76 = require("ShareCfg.UserAgreement3")

		arg0_75:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_76 or "")
	end, SFX_PANEL)
	onButton(arg0_75, arg0_75.userAgreeBtn4, function()
		local var0_77 = require("ShareCfg.UserAgreement4")

		arg0_75:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_77 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_78, arg1_78)
	local function var0_78()
		if arg0_78.refreshTimer then
			arg0_78.refreshTimer:Stop()

			arg0_78.refreshTimer = nil
		end
	end

	var0_78()

	arg0_78.refreshTimer = Timer.New(function()
		if arg1_78 + 1 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			var0_78()
			arg0_78:emit(NewShopMainMediator.GET_CHARGE_LIST)
		end
	end, 1, -1)

	arg0_78.refreshTimer:Start()
	arg0_78.refreshTimer.func()
end

function var0_0.InitSkinToggleList(arg0_81)
	arg0_81.uiSkinToggleParent = arg0_81.buttonList:Find("shop1List/skinShop/shop2List")
	arg0_81.uiSkinToggleItem = arg0_81.buttonList:Find("shop1List/skinShop/shop2List/skinToggleItem")

	local var0_81 = getProxy(ShipSkinProxy):GetInTimeSkins()

	setActive(arg0_81.buttonList:Find("shop1List/skinShop/shop1Tg/timeLimit"), #var0_81 > 0)

	arg0_81.skinShopList = arg0_81:GetSkinShopList()
	arg0_81.skinShopItemList = {}

	onToggle(arg0_81, arg0_81.buttonList:Find("shop1List/skinShop/shop1Tg"), function(arg0_82)
		setActive(arg0_81.buttonList:Find("shop1List/skinShop/shop2List"), arg0_82)

		if arg0_82 then
			if arg0_81.shop1 == "skinShop" then
				return
			end

			arg0_81.shop1 = "skinShop"

			local var0_82 = arg0_81.skinShopItemList[table.keyof(arg0_81.skinShopList, arg0_81:GetDefaultSkinShop())]

			var0_82 = arg0_81.contextData.shop1 and arg0_81.contextData.shop2 and arg0_81.skinShopItemList[table.keyof(arg0_81.skinShopList, arg0_81.contextData.shop2)] or var0_82
			arg0_81.contextData.shop1 = "skinShop"

			var0_82:TriggerToggle()
		end
	end, SFX_PANEL)

	for iter0_81, iter1_81 in ipairs(arg0_81.skinShopList) do
		arg0_81.skinShopItemList[iter0_81] = arg0_81.skinShopItemList[iter0_81] or NewShopMainSkinToggleItem.New(Object.Instantiate(arg0_81.uiSkinToggleItem, arg0_81.uiSkinToggleParent), arg0_81)

		arg0_81.skinShopItemList[iter0_81]:didEnter(iter1_81)
	end
end

function var0_0.OnClickSkinShop(arg0_83, arg1_83, arg2_83)
	arg0_83.contextData.shop2 = arg2_83

	if arg0_83.shop2 == arg2_83 then
		return
	end

	arg0_83.shop2 = arg2_83

	arg0_83:ShowChargeWarp(false)
	pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
	arg0_83:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
		type = arg2_83,
		mode = arg0_83.contextData.mode
	})
end

function var0_0.DisposeSkinToggleList(arg0_84)
	for iter0_84, iter1_84 in ipairs(arg0_84.skinShopItemList) do
		iter1_84:willExit()
	end

	arg0_84.skinShopItemList = nil
end

function var0_0.GetSkinShopList(arg0_85)
	local var0_85 = Clone(pg.shop_skin_subsheet.get_id_list_by_type[0])

	if #getProxy(ShipSkinProxy):GetInTimeSkins() <= 0 then
		table.remove(var0_85, 1)
	end

	local var1_85 = pg.TimeMgr.GetInstance()
	local var2_85 = getProxy(ShipSkinProxy):GetAllSkins()

	for iter0_85, iter1_85 in ipairs(pg.shop_skin_subsheet.get_id_list_by_type[1] or {}) do
		local var3_85 = pg.shop_skin_subsheet[iter1_85]

		if var1_85:inTime(var3_85.time) then
			for iter2_85, iter3_85 in ipairs(var2_85) do
				if table.keyof(var3_85.param, iter3_85.id) then
					table.insert(var0_85, iter1_85)

					break
				end
			end
		end
	end

	table.sort(var0_85, function(arg0_86, arg1_86)
		local var0_86 = pg.shop_skin_subsheet[arg0_86]
		local var1_86 = pg.shop_skin_subsheet[arg1_86]

		return var0_86.sort == var0_86.sort and arg0_86 < arg1_86 or var0_86.sort < var1_86.sort
	end)

	return var0_85
end

function var0_0.GetDefaultSkinShop(arg0_87)
	local var0_87 = Clone(arg0_87.skinShopList)

	table.sort(var0_87, function(arg0_88, arg1_88)
		local var0_88 = pg.shop_skin_subsheet[arg0_88]
		local var1_88 = pg.shop_skin_subsheet[arg1_88]

		if var0_88.shop_skin_subsheet == var1_88.shop_skin_subsheet then
			return var0_88.sort == var1_88.sort and arg0_88 < arg1_88 or var0_88.sort < var1_88.sort
		else
			return var0_88.shop_skin_subsheet < var1_88.shop_skin_subsheet
		end
	end)

	return var0_87[1]
end

return var0_0
