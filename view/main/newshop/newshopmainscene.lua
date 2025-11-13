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
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7

	if arg0_7.subViewList[arg0_7.curSubViewNum] and arg0_7.subViewList[arg0_7.curSubViewNum]:IsSupplyShop() then
		arg0_7.subViewList[arg0_7.curSubViewNum]:SetPlayer(arg1_7)
	end

	if arg0_7.goldMax then
		PlayerResUI.StaticFlush(arg0_7.player, arg0_7.goldMax, arg0_7.goldText, arg0_7.oilMax, arg0_7.oilText, arg0_7.diamondText)
	end
end

function var0_0.setFirstChargeIds(arg0_8, arg1_8)
	arg0_8.firstChargeIds = arg1_8
end

function var0_0.setChargedList(arg0_9, arg1_9)
	arg0_9.chargedList = arg1_9
end

function var0_0.setNormalList(arg0_10, arg1_10)
	arg0_10.normalList = arg1_10
end

function var0_0.setNormalGroupList(arg0_11, arg1_11)
	arg0_11.normalGroupList = arg1_11

	arg0_11:addRefreshTimer(GetZeroTime())
end

function var0_0.SetSupplyShopList(arg0_12, arg1_12)
	arg0_12.supplyShopList = arg1_12

	arg0_12:SortActivityShops()
end

function var0_0.SortActivityShops(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.supplyShopList) do
		if #iter1_13 > 1 then
			table.sort(iter1_13, function(arg0_14, arg1_14)
				return arg0_14:getStartTime() > arg1_14:getStartTime()
			end)
		end
	end
end

function var0_0.OnInitItems(arg0_15, arg1_15)
	arg0_15.items = arg1_15

	arg0_15.subViewList[ShopConst.SHOP_ID.MONTH]:OnUpdateItems(arg1_15)
	arg0_15.subViewList[ShopConst.SHOP_ID.SUPPLY]:OnUpdateItems(arg1_15)
	arg0_15.subViewList[ShopConst.SHOP_ID.ACTIVITY]:OnUpdateItems(arg1_15)
end

function var0_0.OnUpdateItems(arg0_16, arg1_16)
	arg0_16.items = arg1_16

	if arg0_16.subViewList[arg0_16.curSubViewNum] and arg0_16.subViewList[arg0_16.curSubViewNum]:IsSupplyShop() then
		arg0_16.subViewList[arg0_16.curSubViewNum]:OnUpdateItems(arg1_16)
	end
end

function var0_0.OnUpdateShop(arg0_17, arg1_17, arg2_17)
	arg0_17:SetShop(arg1_17, arg2_17)

	if arg0_17.subViewList[arg0_17.curSubViewNum] and arg0_17.subViewList[arg0_17.curSubViewNum]:IsSupplyShop() then
		arg0_17.subViewList[arg0_17.curSubViewNum]:OnUpdateShop(arg1_17, arg2_17)
	end
end

function var0_0.OnUpdateCommodity(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18:SetShop(arg1_18, arg2_18)

	if arg0_18.subViewList[arg0_18.curSubViewNum] and arg0_18.subViewList[arg0_18.curSubViewNum]:IsSupplyShop() then
		arg0_18.subViewList[arg0_18.curSubViewNum]:OnUpdateCommodity(arg1_18, arg2_18, arg3_18)
	end
end

function var0_0.OnFragmentSellUpdate(arg0_19)
	if arg0_19.subViewList[arg0_19.curSubViewNum] and arg0_19.subViewList[arg0_19.curSubViewNum]:IsSupplyShop() then
		arg0_19.subViewList[arg0_19.curSubViewNum]:OnFragmentSellUpdate()
	end
end

function var0_0.SetShop(arg0_20, arg1_20, arg2_20)
	if not arg0_20.supplyShopList then
		return
	end

	local var0_20 = arg0_20.supplyShopList[arg1_20]

	if var0_20 then
		for iter0_20, iter1_20 in ipairs(var0_20) do
			if iter1_20:IsSameKind(arg2_20) then
				arg0_20.supplyShopList[arg1_20][iter0_20] = arg2_20

				break
			end
		end
	end
end

function var0_0.didEnter(arg0_21)
	setActive(arg0_21.chat, false)
	onButton(arg0_21, arg0_21.backBtn, function()
		arg0_21:closeView()
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21.homeBtn, function()
		arg0_21:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21.goldBtn, function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.oilBtn, function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.diamondBtn, function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	onToggle(arg0_21, arg0_21.buttonList:Find("shop1List/recommendation/shop1Tg"), function(arg0_27)
		if arg0_27 then
			arg0_21.contextData.shop1 = nil
			arg0_21.contextData.shop2 = nil

			if arg0_21.shop1 == "recommendation" then
				return
			end

			arg0_21.shop1 = "recommendation"
			arg0_21.shop2 = nil

			arg0_21:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_21:emit(NewShopMainMediator.OPEN_LAYER, NewRecommendationShopLayer, NewRecommendationShopMediator)
		end
	end, SFX_PANEL)

	local var0_21 = getProxy(ShipSkinProxy):GetInTimeSkins()

	setActive(arg0_21.buttonList:Find("shop1List/skinShop/shop1Tg/timeLimit"), #var0_21 > 0)
	setActive(arg0_21.buttonList:Find("shop1List/skinShop/shop2List/newSkin"), #var0_21 > 0)
	onToggle(arg0_21, arg0_21.buttonList:Find("shop1List/skinShop/shop2List/newSkin"), function(arg0_28)
		if arg0_28 then
			arg0_21.contextData.shop2 = "newSkin"

			if arg0_21.shop2 == "newSkin" then
				return
			end

			arg0_21.shop2 = "newSkin"

			arg0_21:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_21:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
				type = "newSkin",
				mode = arg0_21.contextData.mode
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_21, arg0_21.buttonList:Find("shop1List/skinShop/shop2List/permanentSkin"), function(arg0_29)
		if arg0_29 then
			arg0_21.contextData.shop2 = "permanentSkin"

			if arg0_21.shop2 == "permanentSkin" then
				return
			end

			arg0_21.shop2 = "permanentSkin"

			arg0_21:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_21:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
				type = "permanentSkin",
				mode = arg0_21.contextData.mode
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_21, arg0_21.buttonList:Find("shop1List/skinShop/shop1Tg"), function(arg0_30)
		setActive(arg0_21.buttonList:Find("shop1List/skinShop/shop2List"), arg0_30)

		if arg0_30 then
			if arg0_21.shop1 == "skinShop" then
				return
			end

			arg0_21.shop1 = "skinShop"

			if arg0_21.contextData.shop1 and arg0_21.contextData.shop2 then
				triggerToggle(arg0_21.buttonList:Find("shop1List/skinShop/shop2List/" .. arg0_21.contextData.shop2), true)
			else
				arg0_21.contextData.shop1 = "skinShop"

				triggerToggle(arg0_21.buttonList:Find("shop1List/skinShop/shop2List/" .. (#var0_21 > 0 and "newSkin" or "permanentSkin")), true)
			end
		end
	end, SFX_PANEL)

	for iter0_21 = 1, #arg0_21.toggleList do
		local var1_21 = arg0_21.toggleList[iter0_21]

		onToggle(arg0_21, var1_21.go, function(arg0_31)
			if arg0_31 then
				arg0_21:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_21.contextData.shop1 = nil
				arg0_21.contextData.shop2 = nil
				arg0_21.shop1 = nil
				arg0_21.shop2 = nil

				originalPrint(string.format("Begin: toggleType=%s, goName=%s", var1_21.type, var1_21.go.parent.name))

				arg0_21.contextData.type = ShopConst.SHOP_TYPE.CHARGE
				arg0_21.contextData.warp = var1_21.type

				originalPrint(string.format("End: warp=%s", arg0_21.contextData.warp))

				local var0_31 = arg0_21:GetShopID(ShopConst.SHOP_TYPE.CHARGE, var1_21.type)

				arg0_21:switchSubView(var0_31)
			end

			local var1_31 = switch(var1_21.type, {
				[ChargeScene.TYPE_PICK] = function()
					return "payshop_pack_red_dot"
				end,
				[ChargeScene.TYPE_GIFT] = function()
					return "gemshop_pack_red_dot"
				end
			})

			if var1_31 then
				if arg0_31 then
					arg0_21.toggleMark = arg0_21.toggleMark or {}
					arg0_21.toggleMark[var1_21.type] = defaultValue(arg0_21.toggleMark[var1_21.type], 0) + 1
				elseif arg0_21.toggleMark and defaultValue(arg0_21.toggleMark[var1_21.type], 0) > 0 then
					arg0_21.toggleMark[var1_21.type] = arg0_21.toggleMark[var1_21.type] - 1

					PlayerPrefs.SetInt(var1_31, getGameset(var1_31)[1])
					pg.EasyRedDotMgr.GetInstance():TriggerMarks("Charge_Page_Exposure")
				end
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_21, arg0_21.buttonList:Find("shop1List/supplyShop/shop1Tg"), function(arg0_34)
		setActive(arg0_21.buttonList:Find("shop1List/supplyShop/shop2List"), arg0_34)

		if arg0_34 then
			triggerToggle(arg0_21.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_21:GetDefaultSupplyShopName()), true)
		end
	end, SFX_PANEL)

	local var2_21 = {
		{
			type = ShopConst.CATEGORY_MONTH,
			go = arg0_21.buttonList:Find("shop1List/supplyShop/shop2List/monthShop")
		},
		{
			type = ShopConst.CATEGORY_SUPPLY,
			go = arg0_21.buttonList:Find("shop1List/supplyShop/shop2List/supplyShop")
		},
		{
			type = ShopConst.CATEGORY_ACTIVITY,
			go = arg0_21.buttonList:Find("shop1List/supplyShop/shop2List/activityShop")
		}
	}

	for iter1_21, iter2_21 in ipairs(var2_21) do
		onToggle(arg0_21, iter2_21.go, function(arg0_35)
			if arg0_35 then
				arg0_21:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_21.contextData.shop1 = nil
				arg0_21.contextData.shop2 = nil
				arg0_21.shop1 = nil
				arg0_21.shop2 = nil
				arg0_21.contextData.type = ShopConst.SHOP_TYPE.SUPPLY
				arg0_21.contextData.warp = iter2_21.type

				local var0_35 = arg0_21:GetShopID(ShopConst.SHOP_TYPE.SUPPLY, iter2_21.type)

				arg0_21:switchSubView(var0_35)
			end
		end, SFX_PANEL)
	end

	local var3_21 = "recommendation"

	if arg0_21.contextData.type == ShopConst.SHOP_TYPE.CHARGE then
		if arg0_21.contextData.warp == ChargeScene.TYPE_DIAMOND then
			var3_21 = "diamondShop"
		elseif arg0_21.contextData.warp == ChargeScene.TYPE_GIFT then
			var3_21 = "giftPackShop"
		elseif arg0_21.contextData.warp == ChargeScene.TYPE_ITEM then
			var3_21 = "functionalItemShop"
		elseif arg0_21.contextData.warp == ChargeScene.TYPE_PICK then
			var3_21 = "specialShop"
		else
			var3_21 = "diamondShop"
		end
	elseif arg0_21.contextData.type == ShopConst.SHOP_TYPE.SKIN then
		var3_21 = "skinShop"
	elseif arg0_21.contextData.type == ShopConst.SHOP_TYPE.SUPPLY then
		var3_21 = "supplyShop"
	end

	if arg0_21.contextData.shop1 then
		var3_21 = arg0_21.contextData.shop1
	end

	triggerToggle(arg0_21.buttonList:Find("shop1List/" .. var3_21 .. "/shop1Tg"), true)

	if var3_21 == "skinShop" then
		-- block empty
	elseif var3_21 == "supplyShop" then
		triggerToggle(arg0_21.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_21:GetDefaultSupplyShopName()), true)
	end

	onButton(arg0_21, arg0_21.painting, function()
		arg0_21:displayShipWord()
		arg0_21:emit(NewShopMainMediator.CLICK_MING_SHI)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.stamp, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	arg0_21:RefreshActivityShop()
	arg0_21:updateNoRes()
	arg0_21:jpUIEnter()
end

function var0_0.GetDefaultSupplyShopName(arg0_38)
	if arg0_38.contextData.type ~= ShopConst.SHOP_TYPE.SUPPLY then
		return "supplyShop"
	end

	local var0_38 = arg0_38.contextData.warp

	if type(var0_38) == "string" then
		local var1_38 = ShopConst.SHOP_NAME_LIST[var0_38]

		arg0_38.contextData.warp = var1_38[1]
		arg0_38.contextData.shopID = var1_38[2]
	elseif type(var0_38) == "number" and arg0_38.contextData.shopID == nil then
		for iter0_38, iter1_38 in pairs(ShopConst.SUPPLY_SHOP_LIST) do
			for iter2_38, iter3_38 in pairs(iter1_38) do
				if iter3_38 == var0_38 then
					arg0_38.contextData.warp = iter0_38
					arg0_38.contextData.shopID = iter3_38

					break
				end
			end
		end
	end

	local var2_38 = ""

	return arg0_38.contextData.warp == ShopConst.CATEGORY_MONTH and "monthShop" or arg0_38.contextData.warp == ShopConst.CATEGORY_SUPPLY and "supplyShop" or arg0_38.contextData.warp == ShopConst.CATEGORY_ACTIVITY and "activityShop" or "supplyShop"
end

function var0_0.RefreshActivityShop(arg0_39)
	local var0_39 = arg0_39.supplyShopList[ShopConst.TYPE_ACTIVITY] or {}

	setActive(arg0_39.buttonList:Find("shop1List/supplyShop/shop2List/activityShop"), #var0_39 > 0)
end

function var0_0.ShowOrHideUI(arg0_40, arg1_40)
	arg0_40:setVisible(arg1_40)
	setActive(arg0_40.buttonList, arg1_40)
end

function var0_0.ShowOrHideUI2(arg0_41, arg1_41)
	for iter0_41 = 0, arg0_41._tf.childCount - 1 do
		setActive(arg0_41._tf:GetChild(iter0_41), arg1_41)
	end

	setActive(arg0_41.buttonList:Find("leftBg"), arg1_41)
	setActive(arg0_41.buttonList:Find("shop1List"), arg1_41)
	setActive(arg0_41.buttonList:Find("top"), true)
end

function var0_0.OnChargeSuccess(arg0_42, arg1_42)
	arg0_42.chargeTipWindow:ExecuteAction("Show", arg1_42)
end

function var0_0.LoadMingshi(arg0_43)
	if Live2dConst.GetLive2DArm32MatchAble() then
		local var0_43 = Ship.New({
			configId = 312011
		}):getPainting()

		LoadPaintingPrefabAsync(arg0_43.painting, var0_43, var0_43, "mainNormal", function()
			arg0_43.loading = false
		end)
	else
		arg0_43:createLive2D()
	end

	arg0_43:AddLive2dTimer()
end

function var0_0.AddLive2dTimer(arg0_45)
	arg0_45:StopLive2dTimer()

	arg0_45.live2dTimer = Timer.New(function()
		local var0_46 = pg.ChargeShipTalkInfo.Actions
		local var1_46 = var0_46[math.random(#var0_46)]

		if arg0_45:checkBuyDone(var1_46.action) then
			arg0_45:displayShipWord(nil, false, var1_46.dialog_index)
		end
	end, 20, -1)

	arg0_45.live2dTimer:Start()
end

function var0_0.StopLive2dTimer(arg0_47)
	if arg0_47.live2dTimer then
		arg0_47.live2dTimer:Stop()

		arg0_47.live2dTimer = nil
	end
end

function var0_0.ShowChargeWarp(arg0_48, arg1_48)
	setActive(arg0_48.frame, arg1_48)
	setActive(arg0_48.viewContainer, arg1_48)
	arg0_48:ShowResourceBar(arg1_48)

	local var0_48 = arg0_48.subViewList[arg0_48.curSubViewNum]

	if var0_48 then
		if arg1_48 == false then
			var0_48:Destroy()

			arg0_48.curSubViewNum = 0
		else
			var0_48:ShowPanel(arg1_48)
		end
	end
end

function var0_0.ShowResourceBar(arg0_49, arg1_49)
	if arg0_49.resourceBarFlag == arg1_49 then
		return
	end

	arg0_49.resourceBarFlag = arg1_49

	setActive(arg0_49.resourcePanel, arg1_49)
end

function var0_0.willExit(arg0_50)
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_50.specialTip)
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_50.giftTip)

	if arg0_50.toggleMark then
		for iter0_50, iter1_50 in pairs(arg0_50.toggleMark) do
			if iter1_50 > 0 then
				local var0_50 = switch(iter0_50, {
					[ChargeScene.TYPE_PICK] = function()
						return "payshop_pack_red_dot"
					end,
					[ChargeScene.TYPE_GIFT] = function()
						return "gemshop_pack_red_dot"
					end
				})

				PlayerPrefs.SetInt(var0_50, getGameset(var0_50)[1])
			end
		end

		arg0_50.toggleMark = nil
	end

	arg0_50:ShowResourceBar()
	arg0_50:unBlurView()

	if arg0_50.chargeTipWindow then
		arg0_50.chargeTipWindow:Destroy()

		arg0_50.chargeTipWindow = nil
	end

	arg0_50.contextData.singleWindow:Destroy()
	arg0_50.contextData.multiWindow:Destroy()
	arg0_50.contextData.singleWindowForESkin:Destroy()
	arg0_50.contextData.paintingView:Dispose()

	arg0_50.contextData.singleWindow = nil
	arg0_50.contextData.multiWindow = nil
	arg0_50.contextData.singleWindowForESkin = nil
	arg0_50.contextData.paintingView = nil

	for iter2_50, iter3_50 in pairs(arg0_50.subViewList) do
		iter3_50:Destroy()
	end

	arg0_50.subViewList = nil

	if arg0_50.heartsTimer then
		arg0_50.heartsTimer:Stop()

		arg0_50.heartsTimer = nil
	end

	if arg0_50.live2dChar then
		arg0_50.live2dChar:Dispose()
	end

	arg0_50:StopLive2dTimer()
	arg0_50:stopCV()

	if arg0_50.giftShopView then
		arg0_50.giftShopView:OnDestroy()
	end
end

function var0_0.onBackPressed(arg0_53)
	if arg0_53.contextData.singleWindow:GetLoaded() and arg0_53.contextData.singleWindow:isShowing() then
		arg0_53.contextData.singleWindow:Close()

		return
	end

	if arg0_53.contextData.multiWindow:GetLoaded() and arg0_53.contextData.multiWindow:isShowing() then
		arg0_53.contextData.multiWindow:Close()

		return
	end

	if arg0_53.contextData.singleWindowForESkin:GetLoaded() and arg0_53.contextData.singleWindowForESkin:isShowing() then
		arg0_53.contextData.singleWindowForESkin:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_53)
end

function var0_0.initSubView(arg0_54)
	local var0_54 = ChargeDiamondShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData)
	local var1_54 = ChargeGiftShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData)
	local var2_54 = ChargeItemShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData)
	local var3_54 = ChargePickShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData)
	local var4_54 = SupplyShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData, ShopConst.CATEGORY_MONTH)
	local var5_54 = SupplyShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData, ShopConst.CATEGORY_SUPPLY)
	local var6_54 = SupplyShopView.New(arg0_54.viewContainer, arg0_54.event, arg0_54.contextData, ShopConst.CATEGORY_ACTIVITY)

	arg0_54.curSubViewNum = 0
	arg0_54.subViewList = {
		[ShopConst.SHOP_ID.DIAMOND] = var0_54,
		[ShopConst.SHOP_ID.GIFT] = var1_54,
		[ShopConst.SHOP_ID.ITEM] = var2_54,
		[ShopConst.SHOP_ID.PICK] = var3_54,
		[ShopConst.SHOP_ID.MONTH] = var4_54,
		[ShopConst.SHOP_ID.SUPPLY] = var5_54,
		[ShopConst.SHOP_ID.ACTIVITY] = var6_54
	}

	for iter0_54, iter1_54 in pairs(arg0_54.subViewList) do
		iter1_54:RegisterView(arg0_54)
	end

	arg0_54.contextData.singleWindow = ShopSingleWindow.New(arg0_54._tf, arg0_54.event)
	arg0_54.contextData.multiWindow = ShopMultiWindow.New(arg0_54._tf, arg0_54.event)
	arg0_54.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_54._tf, arg0_54.event)
	arg0_54.contextData.paintingView = ShopPaintingView.New(arg0_54._tf:Find("frame/supplyPaint"), arg0_54._tf:Find("frame/chat"))

	arg0_54.contextData.paintingView:setSecretaryPos(arg0_54._tf:Find("frame/secretaryPos"))
end

function var0_0.GetShopID(arg0_55, arg1_55, arg2_55)
	return ShopConst.SHOP_LIST[arg1_55][arg2_55]
end

function var0_0.switchSubView(arg0_56, arg1_56)
	originalPrint(string.format("End: shopID=%s curShopID=%s", arg1_56, arg0_56.curSubViewNum))

	if arg1_56 == arg0_56.curSubViewNum then
		return
	end

	arg0_56.subViewList[arg1_56]:setGoodData(arg0_56.firstChargeIds, arg0_56.chargedList, arg0_56.normalList, arg0_56.normalGroupList)
	arg0_56.subViewList[arg1_56]:Reset()
	arg0_56.subViewList[arg1_56]:Load()

	if arg0_56.subViewList[arg1_56].SetAllShopData then
		arg0_56.subViewList[arg1_56]:ActionInvoke("SetAllShopData", arg0_56.supplyShopList)
	end

	local var0_56 = arg0_56.subViewList[arg0_56.curSubViewNum]

	if var0_56 then
		var0_56:Destroy()
	end

	arg0_56.curSubViewNum = arg1_56

	arg0_56:SwitchPainting(arg0_56.subViewList[arg1_56]:IsSupplyShop())

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_56.userAgreeBtn3, arg1_56 == ChargeScene.TYPE_DIAMOND)
		setActive(arg0_56.userAgreeBtn4, arg1_56 == ChargeScene.TYPE_DIAMOND)
	end
end

function var0_0.SwitchPainting(arg0_57, arg1_57)
	arg0_57.contextData.paintingView:Show(arg1_57)
	setActive(arg0_57.painting, not arg1_57)

	if arg1_57 then
		arg0_57:StopLive2dTimer()

		arg0_57.chatFlag = nil

		arg0_57:stopCV()
		setActive(arg0_57.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

		if LOCK_CLICK_MINGSHI then
			setActive(arg0_57.stamp, false)
		end
	else
		setActive(arg0_57.stamp, false)
		arg0_57:AddLive2dTimer()
	end
end

function var0_0.switchSubViewByTogger(arg0_58, arg1_58)
	local var0_58 = arg0_58.toggleList[arg1_58]

	triggerToggle(var0_58.go, true)
end

function var0_0.updateCurSubView(arg0_59)
	if not isActive(arg0_59.viewContainer) then
		return
	end

	local var0_59 = arg0_59.subViewList[arg0_59.curSubViewNum]

	if var0_59 == nil then
		return
	end

	var0_59:setGoodData(arg0_59.firstChargeIds, arg0_59.chargedList, arg0_59.normalList, arg0_59.normalGroupList)
	var0_59:reUpdateAll()
end

function var0_0.updateNoRes(arg0_60, arg1_60)
	if not arg1_60 then
		arg1_60 = arg0_60.contextData.noRes
	else
		arg0_60.contextData.noRes = arg1_60
	end

	if not arg1_60 or #arg1_60 <= 0 then
		return
	end

	arg0_60.contextData.noRes = {}

	local var0_60 = getProxy(BagProxy):getData()
	local var1_60 = ""

	for iter0_60, iter1_60 in ipairs(arg1_60) do
		if iter1_60[2] > 0 then
			if iter1_60[1] == 59001 then
				arg1_60[iter0_60][2] = iter1_60[3] - arg0_60.player.gold
			else
				arg1_60[iter0_60][2] = iter1_60[3] - (var0_60[iter1_60[1]] and var0_60[iter1_60[1]].count or 0)
			end
		end

		if arg1_60[iter0_60][2] > 0 then
			table.insert(arg0_60.contextData.noRes, arg1_60[iter0_60])
		end
	end

	for iter2_60, iter3_60 in ipairs(arg0_60.contextData.noRes) do
		local var2_60 = Item.getConfigData(iter3_60[1]).name

		var1_60 = var1_60 .. i18n(iter3_60[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_60, iter3_60[2])

		if iter2_60 < #arg0_60.contextData.noRes then
			var1_60 = var1_60 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_60 == "" then
		arg0_60:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_60:displayShipWord(i18n("text_shop_noRes_tip", var1_60), true)
	end
end

function var0_0.displayShipWord(arg0_61, arg1_61, arg2_61, arg3_61)
	if not arg0_61.chatFlag then
		if not arg1_61 and arg0_61.contextData.noRes and #arg0_61.contextData.noRes > 0 then
			setActive(arg0_61.chat, false)

			arg0_61.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_61.chatFlag = true

		if not arg0_61.isInitChatPosition then
			arg0_61.isInitChatPosition = true

			arg0_61:InitChatPosition()
		end

		setActive(arg0_61.chat, true)

		local var0_61 = arg0_61.player:getChargeLevel()
		local var1_61 = arg3_61 or math.random(1, var0_61)
		local var2_61

		if arg3_61 then
			var2_61 = pg.pay_level_award[var1_61].dialog
		else
			var2_61 = arg1_61 or pg.pay_level_award[var1_61].dialog
		end

		if not arg1_61 then
			arg0_61:playCV(var1_61)
		end

		setText(arg0_61.chatText, var2_61)

		local var3_61 = arg0_61.chatText:GetComponent(typeof(Text))

		;(function()
			local var0_62 = 3
			local var1_62 = 0.3

			LeanTween.scale(rtf(arg0_61.chat.gameObject), Vector3.New(1, 1, 1), var1_62):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_61 then
					LeanTween.scale(rtf(arg0_61.chat.gameObject), Vector3.New(0, 0, 1), var1_62):setEase(LeanTweenType.easeInBack):setDelay(var1_62 + var0_62):setOnComplete(System.Action(function()
						arg0_61.chatFlag = nil

						setActive(arg0_61.chat, false)

						if arg0_61.contextData.noRes and #arg0_61.contextData.noRes > 0 then
							arg0_61:updateNoRes()
						end
					end))
				else
					arg0_61.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_65)
	return
end

function var0_0.playHeartEffect(arg0_66)
	if arg0_66.heartsTimer then
		arg0_66.heartsTimer:Stop()
	end

	local var0_66 = arg0_66.painting:Find("heartsfly")

	setActive(var0_66, true)

	arg0_66.heartsTimer = Timer.New(function()
		setActive(var0_66, false)
	end, 1, 1)

	arg0_66.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_68)
	local var0_68 = Live2D.GenerateData({
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
		parent = arg0_68._tf:Find("frame/painting/live2d")
	})

	arg0_68.live2dChar = Live2D.New(var0_68, function(arg0_69)
		arg0_69:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
	end)
end

function var0_0.checkBuyDone(arg0_70, arg1_70)
	if not arg0_70.live2dChar or not arg0_70.live2dChar:IsLoaded() then
		return
	end

	local var0_70

	if type(arg1_70) == "string" then
		if arg1_70 == "damonds" then
			var0_70 = "diamond"
		else
			var0_70 = arg1_70
		end
	else
		local var1_70 = pg.shop_template[arg1_70]

		if var1_70 and var1_70.effect_args and type(var1_70.effect_args) == "table" then
			for iter0_70, iter1_70 in ipairs(var1_70.effect_args) do
				if iter1_70 == 1 then
					var0_70 = "gold"
				end
			end
		end
	end

	local var2_70 = arg0_70.preAniName == "gold" or arg0_70.preAniName == "diamond"
	local var3_70 = var0_70 == "gold" or var0_70 == "diamond"
	local var4_70 = var2_70 and var3_70 or not var2_70

	var4_70 = var0_70 and arg0_70.preAniName ~= var0_70 and var4_70

	if var4_70 then
		arg0_70.preAniName = var0_70

		arg0_70.live2dChar:TriggerAction(var0_70, nil, true)
	end

	return var4_70
end

function var0_0.playCV(arg0_71, arg1_71)
	local var0_71 = pg.pay_level_award[arg1_71]
	local var1_71

	if var0_71 and var0_71.cv_key ~= "" then
		var1_71 = "event:/cv/chargeShop/" .. var0_71.cv_key
	end

	if var1_71 then
		arg0_71:stopCV()

		arg0_71._currentVoice = var1_71

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_71)
	end
end

function var0_0.stopCV(arg0_72)
	if arg0_72._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_72._currentVoice)
	end

	arg0_72._currentVoice = nil
end

function var0_0.blurView(arg0_73)
	arg0_73:OverlayPanel(arg0_73.buttonList, {
		pbList = {
			arg0_73.buttonList:Find("leftBg")
		}
	})
end

function var0_0.unBlurView(arg0_74)
	arg0_74:UnOverlayPanel(arg0_74.buttonList, arg0_74._tf)
end

function var0_0.jpUIInit(arg0_75)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_75.userAgreeBtn3 = arg0_75._tf:Find("frame/raw1Btn")
	arg0_75.userAgreeBtn4 = arg0_75._tf:Find("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_76)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_76, arg0_76.userAgreeBtn3, function()
		local var0_77 = require("ShareCfg.UserAgreement3")

		arg0_76:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_77 or "")
	end, SFX_PANEL)
	onButton(arg0_76, arg0_76.userAgreeBtn4, function()
		local var0_78 = require("ShareCfg.UserAgreement4")

		arg0_76:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_78 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_79, arg1_79)
	local function var0_79()
		if arg0_79.refreshTimer then
			arg0_79.refreshTimer:Stop()

			arg0_79.refreshTimer = nil
		end
	end

	var0_79()

	arg0_79.refreshTimer = Timer.New(function()
		if arg1_79 + 1 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			var0_79()
			arg0_79:emit(NewShopMainMediator.GET_CHARGE_LIST)
		end
	end, 1, -1)

	arg0_79.refreshTimer:Start()
	arg0_79.refreshTimer.func()
end

return var0_0
