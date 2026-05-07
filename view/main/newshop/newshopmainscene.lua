local var0_0 = class("NewShopMainScene", import("...base.BaseUI"))

var0_0.CLOSE_ALL_LAYER = "NewShopMainScene.CLOSE_ALL_LAYER"
var0_0.SHOW_OR_HIDE_UI = "NewShopMainScene.SHOW_OR_HIDE_UI"
var0_0.SHOW_OR_HIDE_UI_2 = "NewShopMainScene.SHOW_OR_HIDE_UI_2"
var0_0.CLOSE_VIEW = "NewShopMainScene.CLOSE_VIEW"
var0_0.TYPE_CHARGE = "charge"
var0_0.TYPE_SKIN = "skin"

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
	setText(var0_4:Find("shop1List/skinShop/shop2List/newSkin/name"), i18n("shop_skin_new"))
	setText(var0_4:Find("shop1List/skinShop/shop2List/newSkin/selected/name"), i18n("shop_skin_new"))
	setText(var0_4:Find("shop1List/skinShop/shop2List/permanentSkin/name"), i18n("shop_skin_permanent"))
	setText(var0_4:Find("shop1List/skinShop/shop2List/permanentSkin/selected/name"), i18n("shop_skin_permanent"))
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

	local var0_23 = getProxy(ShipSkinProxy):GetInTimeSkins()

	setActive(arg0_23.buttonList:Find("shop1List/skinShop/shop1Tg/timeLimit"), #var0_23 > 0)
	setActive(arg0_23.buttonList:Find("shop1List/skinShop/shop2List/newSkin"), #var0_23 > 0)
	onToggle(arg0_23, arg0_23.buttonList:Find("shop1List/skinShop/shop2List/newSkin"), function(arg0_30)
		if arg0_30 then
			arg0_23.contextData.shop2 = "newSkin"

			if arg0_23.shop2 == "newSkin" then
				return
			end

			arg0_23.shop2 = "newSkin"

			arg0_23:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_23:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
				type = "newSkin",
				mode = arg0_23.contextData.mode
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_23, arg0_23.buttonList:Find("shop1List/skinShop/shop2List/permanentSkin"), function(arg0_31)
		if arg0_31 then
			arg0_23.contextData.shop2 = "permanentSkin"

			if arg0_23.shop2 == "permanentSkin" then
				return
			end

			arg0_23.shop2 = "permanentSkin"

			arg0_23:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_23:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
				type = "permanentSkin",
				mode = arg0_23.contextData.mode
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_23, arg0_23.buttonList:Find("shop1List/skinShop/shop1Tg"), function(arg0_32)
		setActive(arg0_23.buttonList:Find("shop1List/skinShop/shop2List"), arg0_32)

		if arg0_32 then
			if arg0_23.shop1 == "skinShop" then
				return
			end

			arg0_23.shop1 = "skinShop"

			if arg0_23.contextData.shop1 and arg0_23.contextData.shop2 then
				triggerToggle(arg0_23.buttonList:Find("shop1List/skinShop/shop2List/" .. arg0_23.contextData.shop2), true)
			else
				arg0_23.contextData.shop1 = "skinShop"

				triggerToggle(arg0_23.buttonList:Find("shop1List/skinShop/shop2List/" .. (#var0_23 > 0 and "newSkin" or "permanentSkin")), true)
			end
		end
	end, SFX_PANEL)

	for iter0_23 = 1, #arg0_23.toggleList do
		local var1_23 = arg0_23.toggleList[iter0_23]

		onToggle(arg0_23, var1_23.go, function(arg0_33)
			if arg0_33 then
				arg0_23:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_23.contextData.shop1 = nil
				arg0_23.contextData.shop2 = nil
				arg0_23.shop1 = nil
				arg0_23.shop2 = nil

				originalPrint(string.format("Begin: toggleType=%s, goName=%s", var1_23.type, var1_23.go.parent.name))

				arg0_23.contextData.type = ShopConst.SHOP_TYPE.CHARGE
				arg0_23.contextData.warp = var1_23.type

				originalPrint(string.format("End: warp=%s", arg0_23.contextData.warp))

				local var0_33 = arg0_23:GetShopID(ShopConst.SHOP_TYPE.CHARGE, var1_23.type)

				arg0_23:switchSubView(var0_33)
			end

			local var1_33 = switch(var1_23.type, {
				[ChargeScene.TYPE_PICK] = function()
					return "payshop_pack_red_dot"
				end,
				[ChargeScene.TYPE_GIFT] = function()
					return "gemshop_pack_red_dot"
				end
			})

			if var1_33 then
				if arg0_33 then
					arg0_23.toggleMark = arg0_23.toggleMark or {}
					arg0_23.toggleMark[var1_23.type] = defaultValue(arg0_23.toggleMark[var1_23.type], 0) + 1
				elseif arg0_23.toggleMark and defaultValue(arg0_23.toggleMark[var1_23.type], 0) > 0 then
					arg0_23.toggleMark[var1_23.type] = arg0_23.toggleMark[var1_23.type] - 1

					PlayerPrefs.SetInt(var1_33, getGameset(var1_33)[1])
					pg.EasyRedDotMgr.GetInstance():TriggerMarks("Charge_Page_Exposure")
				end
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_23, arg0_23.buttonList:Find("shop1List/supplyShop/shop1Tg"), function(arg0_36)
		setActive(arg0_23.buttonList:Find("shop1List/supplyShop/shop2List"), arg0_36)

		if arg0_36 then
			triggerToggle(arg0_23.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_23:GetDefaultSupplyShopName()), true)
		end
	end, SFX_PANEL)

	local var2_23 = {
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

	for iter1_23, iter2_23 in ipairs(var2_23) do
		onToggle(arg0_23, iter2_23.go, function(arg0_37)
			if arg0_37 then
				arg0_23:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_23.contextData.shop1 = nil
				arg0_23.contextData.shop2 = nil
				arg0_23.shop1 = nil
				arg0_23.shop2 = nil
				arg0_23.contextData.type = ShopConst.SHOP_TYPE.SUPPLY
				arg0_23.contextData.warp = iter2_23.type

				local var0_37 = arg0_23:GetShopID(ShopConst.SHOP_TYPE.SUPPLY, iter2_23.type)

				arg0_23:switchSubView(var0_37)
			end
		end, SFX_PANEL)
	end

	local var3_23 = "recommendation"

	if arg0_23.contextData.type == ShopConst.SHOP_TYPE.CHARGE then
		if arg0_23.contextData.warp == ChargeScene.TYPE_DIAMOND then
			var3_23 = "diamondShop"
		elseif arg0_23.contextData.warp == ChargeScene.TYPE_GIFT then
			var3_23 = "giftPackShop"
		elseif arg0_23.contextData.warp == ChargeScene.TYPE_ITEM then
			var3_23 = "functionalItemShop"
		elseif arg0_23.contextData.warp == ChargeScene.TYPE_PICK then
			var3_23 = "specialShop"
		else
			var3_23 = "diamondShop"
		end
	elseif arg0_23.contextData.type == ShopConst.SHOP_TYPE.SKIN then
		var3_23 = "skinShop"
	elseif arg0_23.contextData.type == ShopConst.SHOP_TYPE.SUPPLY then
		var3_23 = "supplyShop"
	end

	if arg0_23.contextData.shop1 then
		var3_23 = arg0_23.contextData.shop1
	end

	triggerToggle(arg0_23.buttonList:Find("shop1List/" .. var3_23 .. "/shop1Tg"), true)

	if var3_23 == "skinShop" then
		-- block empty
	elseif var3_23 == "supplyShop" then
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

function var0_0.GetDefaultSupplyShopName(arg0_40)
	if arg0_40.contextData.type ~= ShopConst.SHOP_TYPE.SUPPLY then
		return "supplyShop"
	end

	local var0_40 = arg0_40.contextData.warp

	if type(var0_40) == "string" then
		local var1_40 = ShopConst.SHOP_NAME_LIST[var0_40]

		arg0_40.contextData.warp = var1_40[1]
		arg0_40.contextData.shopID = var1_40[2]
	elseif type(var0_40) == "number" and arg0_40.contextData.shopID == nil then
		for iter0_40, iter1_40 in pairs(ShopConst.SUPPLY_SHOP_LIST) do
			for iter2_40, iter3_40 in pairs(iter1_40) do
				if iter3_40 == var0_40 then
					arg0_40.contextData.warp = iter0_40
					arg0_40.contextData.shopID = iter3_40

					break
				end
			end
		end
	end

	local var2_40 = ""

	return arg0_40.contextData.warp == ShopConst.CATEGORY_MONTH and "monthShop" or arg0_40.contextData.warp == ShopConst.CATEGORY_SUPPLY and "supplyShop" or arg0_40.contextData.warp == ShopConst.CATEGORY_ACTIVITY and "activityShop" or "supplyShop"
end

function var0_0.RefreshActivityShop(arg0_41)
	local var0_41 = arg0_41.supplyShopList[ShopConst.TYPE_ACTIVITY] or {}

	setActive(arg0_41.buttonList:Find("shop1List/supplyShop/shop2List/activityShop"), #var0_41 > 0)
end

function var0_0.ShowOrHideUI(arg0_42, arg1_42)
	arg0_42:setVisible(arg1_42)
	setActive(arg0_42.buttonList, arg1_42)
end

function var0_0.ShowOrHideUI2(arg0_43, arg1_43)
	for iter0_43 = 0, arg0_43._tf.childCount - 1 do
		setActive(arg0_43._tf:GetChild(iter0_43), arg1_43)
	end

	setActive(arg0_43.buttonList:Find("leftBg"), arg1_43)
	setActive(arg0_43.buttonList:Find("shop1List"), arg1_43)
	setActive(arg0_43.buttonList:Find("top"), true)
end

function var0_0.OnChargeSuccess(arg0_44, arg1_44)
	arg0_44.chargeTipWindow:ExecuteAction("Show", arg1_44)
end

function var0_0.LoadMingshi(arg0_45)
	if Live2dConst.GetLive2DArm32MatchAble() then
		local var0_45 = Ship.New({
			configId = 312011
		}):getPainting()

		LoadPaintingPrefabAsync(arg0_45.painting, var0_45, var0_45, "mainNormal", function()
			arg0_45.loading = false
		end)
	else
		arg0_45:createLive2D()
	end

	arg0_45:AddLive2dTimer()
end

function var0_0.AddLive2dTimer(arg0_47)
	arg0_47:StopLive2dTimer()

	arg0_47.live2dTimer = Timer.New(function()
		local var0_48 = pg.ChargeShipTalkInfo.Actions
		local var1_48 = var0_48[math.random(#var0_48)]

		if arg0_47:checkBuyDone(var1_48.action) then
			arg0_47:displayShipWord(nil, false, var1_48.dialog_index)
		end
	end, 20, -1)

	arg0_47.live2dTimer:Start()
end

function var0_0.StopLive2dTimer(arg0_49)
	if arg0_49.live2dTimer then
		arg0_49.live2dTimer:Stop()

		arg0_49.live2dTimer = nil
	end
end

function var0_0.ShowChargeWarp(arg0_50, arg1_50)
	setActive(arg0_50.frame, arg1_50)
	setActive(arg0_50.viewContainer, arg1_50)
	arg0_50:ShowResourceBar(arg1_50)

	local var0_50 = arg0_50.subViewList[arg0_50.curSubViewNum]

	if var0_50 then
		if arg1_50 == false then
			var0_50:Destroy()

			arg0_50.curSubViewNum = 0
		else
			var0_50:ShowPanel(arg1_50)
		end
	end
end

function var0_0.ShowResourceBar(arg0_51, arg1_51)
	if arg0_51.resourceBarFlag == arg1_51 then
		return
	end

	arg0_51.resourceBarFlag = arg1_51

	setActive(arg0_51.resourcePanel, arg1_51)
end

function var0_0.willExit(arg0_52)
	if arg0_52.bulinTip then
		arg0_52.bulinTip:Destroy()

		arg0_52.bulinTip = nil
	end

	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_52.specialTip)
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_52.giftTip)

	if arg0_52.toggleMark then
		for iter0_52, iter1_52 in pairs(arg0_52.toggleMark) do
			if iter1_52 > 0 then
				local var0_52 = switch(iter0_52, {
					[ChargeScene.TYPE_PICK] = function()
						return "payshop_pack_red_dot"
					end,
					[ChargeScene.TYPE_GIFT] = function()
						return "gemshop_pack_red_dot"
					end
				})

				PlayerPrefs.SetInt(var0_52, getGameset(var0_52)[1])
			end
		end

		arg0_52.toggleMark = nil
	end

	arg0_52:ShowResourceBar()
	arg0_52:unBlurView()

	if arg0_52.chargeTipWindow then
		arg0_52.chargeTipWindow:Destroy()

		arg0_52.chargeTipWindow = nil
	end

	arg0_52.contextData.singleWindow:Destroy()
	arg0_52.contextData.multiWindow:Destroy()
	arg0_52.contextData.singleWindowForESkin:Destroy()
	arg0_52.contextData.paintingView:Dispose()

	arg0_52.contextData.singleWindow = nil
	arg0_52.contextData.multiWindow = nil
	arg0_52.contextData.singleWindowForESkin = nil
	arg0_52.contextData.paintingView = nil
	arg0_52.bulinTip = nil

	for iter2_52, iter3_52 in pairs(arg0_52.subViewList) do
		iter3_52:Destroy()
	end

	arg0_52.subViewList = nil

	if arg0_52.heartsTimer then
		arg0_52.heartsTimer:Stop()

		arg0_52.heartsTimer = nil
	end

	if arg0_52.live2dChar then
		arg0_52.live2dChar:Dispose()
	end

	arg0_52:StopLive2dTimer()
	arg0_52:stopCV()

	if arg0_52.giftShopView then
		arg0_52.giftShopView:OnDestroy()
	end
end

function var0_0.onBackPressed(arg0_55)
	if arg0_55.contextData.singleWindow:GetLoaded() and arg0_55.contextData.singleWindow:isShowing() then
		arg0_55.contextData.singleWindow:Close()

		return
	end

	if arg0_55.contextData.multiWindow:GetLoaded() and arg0_55.contextData.multiWindow:isShowing() then
		arg0_55.contextData.multiWindow:Close()

		return
	end

	if arg0_55.contextData.singleWindowForESkin:GetLoaded() and arg0_55.contextData.singleWindowForESkin:isShowing() then
		arg0_55.contextData.singleWindowForESkin:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_55)
end

function var0_0.initSubView(arg0_56)
	local var0_56 = ChargeDiamondShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData)
	local var1_56 = ChargeGiftShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData)
	local var2_56 = ChargeItemShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData)
	local var3_56 = ChargePickShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData)
	local var4_56 = SupplyShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData, ShopConst.CATEGORY_MONTH)
	local var5_56 = SupplyShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData, ShopConst.CATEGORY_SUPPLY)
	local var6_56 = SupplyShopView.New(arg0_56.viewContainer, arg0_56.event, arg0_56.contextData, ShopConst.CATEGORY_ACTIVITY)

	arg0_56.curSubViewNum = 0
	arg0_56.subViewList = {
		[ShopConst.SHOP_ID.DIAMOND] = var0_56,
		[ShopConst.SHOP_ID.GIFT] = var1_56,
		[ShopConst.SHOP_ID.ITEM] = var2_56,
		[ShopConst.SHOP_ID.PICK] = var3_56,
		[ShopConst.SHOP_ID.MONTH] = var4_56,
		[ShopConst.SHOP_ID.SUPPLY] = var5_56,
		[ShopConst.SHOP_ID.ACTIVITY] = var6_56
	}

	for iter0_56, iter1_56 in pairs(arg0_56.subViewList) do
		iter1_56:RegisterView(arg0_56)
	end

	arg0_56.contextData.singleWindow = ShopSingleWindow.New(arg0_56._tf, arg0_56.event)
	arg0_56.contextData.multiWindow = ShopMultiWindow.New(arg0_56._tf, arg0_56.event)
	arg0_56.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_56._tf, arg0_56.event)
	arg0_56.contextData.paintingView = ShopPaintingView.New(arg0_56._tf:Find("frame/supplyPaint"), arg0_56._tf:Find("frame/chat"))

	arg0_56.contextData.paintingView:setSecretaryPos(arg0_56._tf:Find("frame/secretaryPos"))
end

function var0_0.GetShopID(arg0_57, arg1_57, arg2_57)
	return ShopConst.SHOP_LIST[arg1_57][arg2_57]
end

function var0_0.switchSubView(arg0_58, arg1_58)
	originalPrint(string.format("End: shopID=%s curShopID=%s", arg1_58, arg0_58.curSubViewNum))

	if arg1_58 == arg0_58.curSubViewNum then
		return
	end

	arg0_58.subViewList[arg1_58]:setGoodData(arg0_58.firstChargeIds, arg0_58.chargedList, arg0_58.normalList, arg0_58.normalGroupList)
	arg0_58.subViewList[arg1_58]:Reset()
	arg0_58.subViewList[arg1_58]:Load()

	if arg0_58.subViewList[arg1_58].SetAllShopData then
		arg0_58.subViewList[arg1_58]:ActionInvoke("SetAllShopData", arg0_58.supplyShopList)
	end

	local var0_58 = arg0_58.subViewList[arg0_58.curSubViewNum]

	if var0_58 then
		var0_58:Destroy()
	end

	arg0_58.curSubViewNum = arg1_58

	arg0_58:SwitchPainting(arg0_58.subViewList[arg1_58]:IsSupplyShop())

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_58.userAgreeBtn3, arg1_58 == ChargeScene.TYPE_DIAMOND)
		setActive(arg0_58.userAgreeBtn4, arg1_58 == ChargeScene.TYPE_DIAMOND)
	end
end

function var0_0.SwitchPainting(arg0_59, arg1_59)
	arg0_59.contextData.paintingView:Show(arg1_59)
	setActive(arg0_59.painting, not arg1_59)

	if arg1_59 then
		arg0_59:StopLive2dTimer()

		arg0_59.chatFlag = nil

		arg0_59:stopCV()
		setActive(arg0_59.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

		if LOCK_CLICK_MINGSHI then
			setActive(arg0_59.stamp, false)
		end
	else
		setActive(arg0_59.stamp, false)
		arg0_59:AddLive2dTimer()
	end
end

function var0_0.switchSubViewByTogger(arg0_60, arg1_60)
	local var0_60 = arg0_60.toggleList[arg1_60]

	triggerToggle(var0_60.go, true)
end

function var0_0.updateCurSubView(arg0_61)
	if not isActive(arg0_61.viewContainer) then
		return
	end

	local var0_61 = arg0_61.subViewList[arg0_61.curSubViewNum]

	if var0_61 == nil then
		return
	end

	var0_61:setGoodData(arg0_61.firstChargeIds, arg0_61.chargedList, arg0_61.normalList, arg0_61.normalGroupList)
	var0_61:reUpdateAll()
end

function var0_0.updateNoRes(arg0_62, arg1_62)
	if not arg1_62 then
		arg1_62 = arg0_62.contextData.noRes
	else
		arg0_62.contextData.noRes = arg1_62
	end

	if not arg1_62 or #arg1_62 <= 0 then
		return
	end

	arg0_62.contextData.noRes = {}

	local var0_62 = getProxy(BagProxy):getData()
	local var1_62 = ""

	for iter0_62, iter1_62 in ipairs(arg1_62) do
		if iter1_62[2] > 0 then
			if iter1_62[1] == 59001 then
				arg1_62[iter0_62][2] = iter1_62[3] - arg0_62.player.gold
			else
				arg1_62[iter0_62][2] = iter1_62[3] - (var0_62[iter1_62[1]] and var0_62[iter1_62[1]].count or 0)
			end
		end

		if arg1_62[iter0_62][2] > 0 then
			table.insert(arg0_62.contextData.noRes, arg1_62[iter0_62])
		end
	end

	for iter2_62, iter3_62 in ipairs(arg0_62.contextData.noRes) do
		local var2_62 = Item.getConfigData(iter3_62[1]).name

		var1_62 = var1_62 .. i18n(iter3_62[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_62, iter3_62[2])

		if iter2_62 < #arg0_62.contextData.noRes then
			var1_62 = var1_62 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_62 == "" then
		arg0_62:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_62:displayShipWord(i18n("text_shop_noRes_tip", var1_62), true)
	end
end

function var0_0.displayShipWord(arg0_63, arg1_63, arg2_63, arg3_63)
	if not arg0_63.chatFlag then
		if not arg1_63 and arg0_63.contextData.noRes and #arg0_63.contextData.noRes > 0 then
			setActive(arg0_63.chat, false)

			arg0_63.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_63.chatFlag = true

		if not arg0_63.isInitChatPosition then
			arg0_63.isInitChatPosition = true

			arg0_63:InitChatPosition()
		end

		setActive(arg0_63.chat, true)

		local var0_63 = arg0_63.player:getChargeLevel()
		local var1_63 = arg3_63 or math.random(1, var0_63)
		local var2_63

		if arg3_63 then
			var2_63 = pg.pay_level_award[var1_63].dialog
		else
			var2_63 = arg1_63 or pg.pay_level_award[var1_63].dialog
		end

		if not arg1_63 then
			arg0_63:playCV(var1_63)
		end

		setText(arg0_63.chatText, var2_63)

		local var3_63 = arg0_63.chatText:GetComponent(typeof(Text))

		;(function()
			local var0_64 = 3
			local var1_64 = 0.3

			LeanTween.scale(rtf(arg0_63.chat.gameObject), Vector3.New(1, 1, 1), var1_64):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_63 then
					LeanTween.scale(rtf(arg0_63.chat.gameObject), Vector3.New(0, 0, 1), var1_64):setEase(LeanTweenType.easeInBack):setDelay(var1_64 + var0_64):setOnComplete(System.Action(function()
						arg0_63.chatFlag = nil

						setActive(arg0_63.chat, false)

						if arg0_63.contextData.noRes and #arg0_63.contextData.noRes > 0 then
							arg0_63:updateNoRes()
						end
					end))
				else
					arg0_63.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_67)
	return
end

function var0_0.playHeartEffect(arg0_68)
	if arg0_68.heartsTimer then
		arg0_68.heartsTimer:Stop()
	end

	local var0_68 = arg0_68.painting:Find("heartsfly")

	setActive(var0_68, true)

	arg0_68.heartsTimer = Timer.New(function()
		setActive(var0_68, false)
	end, 1, 1)

	arg0_68.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_70)
	local var0_70 = Live2DPainting.GenerateData({
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
		parent = arg0_70._tf:Find("frame/painting/live2d")
	})

	arg0_70.live2dChar = Live2DPainting.New(var0_70, function(arg0_71)
		arg0_71:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
	end)
end

function var0_0.checkBuyDone(arg0_72, arg1_72)
	if not arg0_72.live2dChar or not arg0_72.live2dChar:IsLoaded() then
		return
	end

	local var0_72

	if type(arg1_72) == "string" then
		if arg1_72 == "damonds" then
			var0_72 = "diamond"
		else
			var0_72 = arg1_72
		end
	else
		local var1_72 = pg.shop_template[arg1_72]

		if var1_72 and var1_72.effect_args and type(var1_72.effect_args) == "table" then
			for iter0_72, iter1_72 in ipairs(var1_72.effect_args) do
				if iter1_72 == 1 then
					var0_72 = "gold"
				end
			end
		end
	end

	local var2_72 = arg0_72.preAniName == "gold" or arg0_72.preAniName == "diamond"
	local var3_72 = var0_72 == "gold" or var0_72 == "diamond"
	local var4_72 = var2_72 and var3_72 or not var2_72

	var4_72 = var0_72 and arg0_72.preAniName ~= var0_72 and var4_72

	if var4_72 then
		arg0_72.preAniName = var0_72

		arg0_72.live2dChar:TriggerAction(var0_72, nil, true)
	end

	return var4_72
end

function var0_0.playCV(arg0_73, arg1_73)
	local var0_73 = pg.pay_level_award[arg1_73]
	local var1_73

	if var0_73 and var0_73.cv_key ~= "" then
		var1_73 = "event:/cv/chargeShop/" .. var0_73.cv_key
	end

	if var1_73 then
		arg0_73:stopCV()

		arg0_73._currentVoice = var1_73

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_73)
	end
end

function var0_0.stopCV(arg0_74)
	if arg0_74._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_74._currentVoice)
	end

	arg0_74._currentVoice = nil
end

function var0_0.blurView(arg0_75)
	arg0_75:OverlayPanel(arg0_75.buttonList, {
		pbList = {
			arg0_75.buttonList:Find("leftBg")
		}
	})
end

function var0_0.unBlurView(arg0_76)
	arg0_76:UnOverlayPanel(arg0_76.buttonList, arg0_76._tf)
end

function var0_0.jpUIInit(arg0_77)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_77.userAgreeBtn3 = arg0_77._tf:Find("frame/raw1Btn")
	arg0_77.userAgreeBtn4 = arg0_77._tf:Find("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_78)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_78, arg0_78.userAgreeBtn3, function()
		local var0_79 = require("ShareCfg.UserAgreement3")

		arg0_78:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_79 or "")
	end, SFX_PANEL)
	onButton(arg0_78, arg0_78.userAgreeBtn4, function()
		local var0_80 = require("ShareCfg.UserAgreement4")

		arg0_78:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_80 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_81, arg1_81)
	local function var0_81()
		if arg0_81.refreshTimer then
			arg0_81.refreshTimer:Stop()

			arg0_81.refreshTimer = nil
		end
	end

	var0_81()

	arg0_81.refreshTimer = Timer.New(function()
		if arg1_81 + 1 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			var0_81()
			arg0_81:emit(NewShopMainMediator.GET_CHARGE_LIST)
		end
	end, 1, -1)

	arg0_81.refreshTimer:Start()
	arg0_81.refreshTimer.func()
end

return var0_0
