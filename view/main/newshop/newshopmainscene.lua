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

function var0_0.getResource(arg0_2, arg1_2)
	local function var0_2()
		local var0_3 = Ship.New({
			configId = 312011
		}):getPainting()

		return "live2d/" .. var0_3
	end

	local var1_2 = {
		var0_2(),
		"ui/ChargeDiamondShopUI",
		"ui/ChargeGiftShopUI",
		"ui/ChargeItemShopUI",
		"ui/ChargePickShopUI",
		"ui/ShopSupplyShopUI",
		"ui/iconcolorful",
		"ui/ShopsUI_atlas",
		"weaponframes",
		"props/medal",
		"shoppainting/buzhihuo_shop"
	}

	local function var2_2()
		local var0_4 = {}
		local var1_4 = pg.pay_data_display.all

		local function var2_4(arg0_5)
			if arg0_5 and arg0_5 ~= "" and not table.contains(var0_4, arg0_5) then
				table.insert(var0_4, arg0_5)
			end
		end

		for iter0_4, iter1_4 in ipairs(var1_4) do
			local var3_4 = pg.pay_data_display[iter1_4].picture
			local var4_4 = "chargeicon/" .. var3_4

			var2_4(var4_4)
		end

		return var0_4
	end

	local function var3_2(arg0_6)
		local var0_6 = {}
		local var1_6 = getProxy(ShopsProxy):GetAllShowGiftPackages(arg0_6)

		for iter0_6, iter1_6 in ipairs(var1_6) do
			if iter1_6:isChargeType() then
				table.insert(var0_6, "chargeicon/" .. iter1_6:getConfig("picture"))
			else
				local var2_6 = iter1_6:getConfig("effect_args")
				local var3_6 = Item.getConfigData(var2_6[1])

				table.insert(var0_6, var3_6.icon)
			end
		end

		return var0_6
	end

	local function var4_2()
		local var0_7 = {}
		local var1_7 = getProxy(PlayerProxy):getData()
		local var2_7 = arg1_2 and arg1_2.normalGroupList or getProxy(ShopsProxy):GetNormalGroupList()

		local function var3_7(arg0_8, arg1_8, arg2_8, arg3_8)
			local var0_8, var1_8, var2_8 = ChargeConst.getGoodsLimitInfo(arg0_8)
			local var3_8 = arg1_8.effect_args
			local var4_8 = false

			if var3_8 == "ship_bag_size" and var1_8 and var2_8 then
				local var5_8 = var1_7:getMaxShipBagExcludeGuild()

				var4_8 = var1_8 <= var5_8 and var5_8 <= var2_8
			elseif var3_8 == "equip_bag_max" and var1_8 and var2_8 then
				local var6_8 = var1_7:getMaxEquipmentBag()

				var4_8 = var1_8 <= var6_8 and var6_8 <= var2_8
			elseif var3_8 == "commander_bag_size" and var1_8 and var2_8 then
				local var7_8 = var1_7.commanderBagMax

				var4_8 = var1_8 <= var7_8 and var7_8 <= var2_8
			else
				var4_8 = true
			end

			if not var4_8 then
				return false
			end

			local var8_8 = Goods.Create({
				count = 0,
				shop_id = arg0_8
			}, Goods.TYPE_MILITARY)
			local var9_8 = ChargeConst.getGroupLimit(arg3_8, var8_8:getConfig("group"))

			return var8_8:IsShowWhenGroupSale(var9_8)
		end

		for iter0_7, iter1_7 in pairs(pg.shop_template.all) do
			local var4_7 = pg.shop_template[iter1_7]

			if var4_7.genre == "gem_shop" and var3_7(iter1_7, var4_7, var1_7, var2_7) then
				table.insert(var0_7, var0_0.GetShopTemplateDropIcon(var4_7))
			end
		end

		return var0_7
	end

	local function var5_2()
		local var0_9 = {}
		local var1_9 = pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SHOP]
		local var2_9 = pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SHOP_SELECTABLE]

		for iter0_9, iter1_9 in ipairs(var1_9) do
			local var3_9 = pg.activity_template[iter1_9].config_client.painting

			if var3_9 then
				if type(var3_9) == "table" then
					for iter2_9, iter3_9 in ipairs(var3_9) do
						table.insert(var0_9, "shoppainting/" .. iter3_9)
					end
				elseif type(var3_9) == "string" then
					table.insert(var0_9, "shoppainting/" .. var3_9)
				end
			end
		end

		return ResPathSupport.UniqueLuaArr(var0_9)
	end

	local var6_2 = var2_2()
	local var7_2 = var3_2(true)
	local var8_2 = var3_2(false)
	local var9_2 = var4_2()

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var1_2, var6_2, var7_2, var8_2, var9_2, var5_2())
end

function var0_0.GetShopTemplateDropIcon(arg0_10)
	local var0_10 = arg0_10.effect_args
	local var1_10 = {}

	if var0_10 == "ship_bag_size" then
		var1_10 = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = Goods.SHIP_BAG_SIZE_ITEM
		}
	elseif var0_10 == "equip_bag_size" then
		var1_10 = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = Goods.EQUIP_BAG_SIZE_ITEM
		}
	elseif var0_10 == "commander_bag_size" then
		var1_10 = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = Goods.COMMANDER_BAG_SIZE_ITEM
		}
	elseif var0_10 == "spweapon_bag_size" then
		var1_10 = {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = Goods.SPWEAPON_BAG_SIZE_ITEM
		}
	else
		var1_10 = {
			type = arg0_10.type,
			id = arg0_10.effect_args[1],
			count = arg0_10.num
		}
	end

	return Drop.New(var1_10):getIcon()
end

function var0_0.setList(arg0_11)
	local var0_11 = getProxy(ShopsProxy)
	local var1_11 = var0_11:getFirstChargeList()
	local var2_11 = var0_11:getChargedList()
	local var3_11 = var0_11:GetNormalList()
	local var4_11 = var0_11:GetNormalGroupList()

	if var1_11 then
		arg0_11:setFirstChargeIds(var1_11)
	end

	if var2_11 then
		arg0_11:setChargedList(var2_11)
	end

	if var3_11 then
		arg0_11:setNormalList(var3_11)
	end

	if var4_11 then
		arg0_11:setNormalGroupList(var4_11)
	end
end

function var0_0.init(arg0_12)
	local var0_12 = arg0_12._tf:Find("buttonList")

	arg0_12.buttonList = var0_12
	arg0_12.backBtn = var0_12:Find("top/closeBtn")
	arg0_12.homeBtn = var0_12:Find("top/homeBtn")
	arg0_12.resourcePanel = var0_12:Find("top/resources")

	setActive(arg0_12.resourcePanel, false)

	arg0_12.goldBtn = var0_12:Find("top/resources/gold")
	arg0_12.goldText = var0_12:Find("top/resources/gold/Text"):GetComponent(typeof(Text))
	arg0_12.goldMax = var0_12:Find("top/resources/gold/max"):GetComponent(typeof(Text))
	arg0_12.oilBtn = var0_12:Find("top/resources/oil")
	arg0_12.oilText = var0_12:Find("top/resources/oil/Text"):GetComponent(typeof(Text))
	arg0_12.oilMax = var0_12:Find("top/resources/oil/max"):GetComponent(typeof(Text))
	arg0_12.diamondBtn = var0_12:Find("top/resources/gem")
	arg0_12.diamondText = var0_12:Find("top/resources/gem/Text"):GetComponent(typeof(Text))

	setText(var0_12:Find("top/title/Text"), i18n("shop_title"))
	setText(var0_12:Find("shop1List/recommendation/shop1Tg/name"), i18n("shop_recommend"))
	setText(var0_12:Find("shop1List/skinShop/shop1Tg/name"), i18n("shop_skin"))
	setText(var0_12:Find("shop1List/diamondShop/shop1Tg/name"), i18n("shop_diamond_title"))
	setText(var0_12:Find("shop1List/specialShop/shop1Tg/name"), i18n("shop_akashi_pick_title"))
	setText(var0_12:Find("shop1List/giftPackShop/shop1Tg/name"), i18n("shop_gift_title"))
	setText(var0_12:Find("shop1List/functionalItemShop/shop1Tg/name"), i18n("shop_item_title"))
	setText(var0_12:Find("shop1List/supplyShop/shop1Tg/name"), i18n("shop_supply_prop"))
	setText(var0_12:Find("shop1List/recommendation/shop1Tg/name/en"), i18n("shop_recommend_en"))
	setText(var0_12:Find("shop1List/skinShop/shop1Tg/name/en"), i18n("shop_skin_en"))
	setText(var0_12:Find("shop1List/diamondShop/shop1Tg/name/en"), i18n("shop_diamond_title_en"))
	setText(var0_12:Find("shop1List/specialShop/shop1Tg/name/en"), i18n("shop_side_lable_en"))
	setText(var0_12:Find("shop1List/giftPackShop/shop1Tg/name/en"), i18n("shop_gift_title_en"))
	setText(var0_12:Find("shop1List/functionalItemShop/shop1Tg/name/en"), i18n("shop_item_title_en"))
	setText(var0_12:Find("shop1List/supplyShop/shop1Tg/name/en"), i18n("shop_supply_prop_en"))
	setText(var0_12:Find("shop1List/supplyShop/shop2List/monthShop/name"), i18n("shop_month"))
	setText(var0_12:Find("shop1List/supplyShop/shop2List/monthShop/selected/name"), i18n("shop_month"))
	setText(var0_12:Find("shop1List/supplyShop/shop2List/supplyShop/name"), i18n("shop_supply"))
	setText(var0_12:Find("shop1List/supplyShop/shop2List/supplyShop/selected/name"), i18n("shop_supply"))
	setText(var0_12:Find("shop1List/supplyShop/shop2List/activityShop/name"), i18n("shop_activity"))
	setText(var0_12:Find("shop1List/supplyShop/shop2List/activityShop/selected/name"), i18n("shop_activity"))

	arg0_12.frame = arg0_12._tf:Find("frame")
	arg0_12.viewContainer = arg0_12._tf:Find("viewContainer")
	arg0_12.painting = arg0_12._tf:Find("frame/painting")
	arg0_12.chat = arg0_12._tf:Find("frame/chat")
	arg0_12.chatText = arg0_12.chat:Find("Text")
	arg0_12.stamp = arg0_12._tf:Find("frame/stamp")
	arg0_12.specialTip = var0_12:Find("shop1List/specialShop/shop1Tg/tip")
	arg0_12.giftTip = var0_12:Find("shop1List/giftPackShop/shop1Tg/tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_12.specialTip, {
		"specialShop",
		"Charge_Page_Exposure"
	}, function(arg0_13)
		getProxy(ShopsProxy):GiftPackageRedDotTip({
			arg0_13
		}, true)
	end)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_12.giftTip, {
		"specialShop",
		"Charge_Page_Exposure"
	}, function(arg0_14)
		getProxy(ShopsProxy):GiftPackageRedDotTip({
			arg0_14
		}, false)
	end)

	arg0_12.toggleList = {
		{
			type = ChargeScene.TYPE_DIAMOND,
			go = var0_12:Find("shop1List/diamondShop/shop1Tg")
		},
		{
			type = ChargeScene.TYPE_GIFT,
			go = var0_12:Find("shop1List/giftPackShop/shop1Tg")
		},
		{
			type = ChargeScene.TYPE_ITEM,
			go = var0_12:Find("shop1List/functionalItemShop/shop1Tg")
		},
		{
			type = ChargeScene.TYPE_PICK,
			go = var0_12:Find("shop1List/specialShop/shop1Tg")
		}
	}
	GetComponent(var0_12:Find("shop1List/supplyShop/shop2List/supplyShop"), typeof(Toggle)).isOn = true
	arg0_12.chargeTipWindow = ChargeTipWindow.New(arg0_12._tf, arg0_12.event)

	arg0_12:LoadMingshi()
	arg0_12:jpUIInit()
	arg0_12:blurView()
	arg0_12:initSubView()

	arg0_12.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_12, arg0_12.pageContainer, Vector2.New(-35, -90))

	if arg0_12.bulinTip then
		arg0_12.bulinTip:RegisterView(arg0_12)
		arg0_12.bulinTip:CallbackInvoke(function()
			arg0_12:OverlayPanel(arg0_12.bulinTip._tf, {
				groupDelta = 1
			})
		end)

		function arg0_12.bulinTip.destroyCall()
			if arg0_12.bulinTip:GetLoaded() then
				arg0_12:UnOverlayPanel(arg0_12.bulinTip._tf)
			end
		end
	end
end

function var0_0.setPlayer(arg0_17, arg1_17)
	arg0_17.player = arg1_17

	if arg0_17.subViewList[arg0_17.curSubViewNum] and arg0_17.subViewList[arg0_17.curSubViewNum]:IsSupplyShop() then
		arg0_17.subViewList[arg0_17.curSubViewNum]:SetPlayer(arg1_17)
	end

	if arg0_17.goldMax then
		PlayerResUI.StaticFlush(arg0_17.player, arg0_17.goldMax, arg0_17.goldText, arg0_17.oilMax, arg0_17.oilText, arg0_17.diamondText)
	end
end

function var0_0.setFirstChargeIds(arg0_18, arg1_18)
	arg0_18.firstChargeIds = arg1_18
end

function var0_0.setChargedList(arg0_19, arg1_19)
	arg0_19.chargedList = arg1_19
end

function var0_0.setNormalList(arg0_20, arg1_20)
	arg0_20.normalList = arg1_20
end

function var0_0.setNormalGroupList(arg0_21, arg1_21)
	arg0_21.normalGroupList = arg1_21

	arg0_21:addRefreshTimer(GetZeroTime())
end

function var0_0.SetSupplyShopList(arg0_22, arg1_22)
	arg0_22.supplyShopList = arg1_22

	arg0_22:SortActivityShops()
end

function var0_0.SortActivityShops(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.supplyShopList) do
		if #iter1_23 > 1 then
			table.sort(iter1_23, function(arg0_24, arg1_24)
				return arg0_24:getStartTime() > arg1_24:getStartTime()
			end)
		end
	end
end

function var0_0.OnInitItems(arg0_25, arg1_25)
	arg0_25.items = arg1_25

	arg0_25.subViewList[ShopConst.SHOP_ID.MONTH]:OnUpdateItems(arg1_25)
	arg0_25.subViewList[ShopConst.SHOP_ID.SUPPLY]:OnUpdateItems(arg1_25)
	arg0_25.subViewList[ShopConst.SHOP_ID.ACTIVITY]:OnUpdateItems(arg1_25)
end

function var0_0.OnUpdateItems(arg0_26, arg1_26)
	arg0_26.items = arg1_26

	if arg0_26.subViewList[arg0_26.curSubViewNum] and arg0_26.subViewList[arg0_26.curSubViewNum]:IsSupplyShop() then
		arg0_26.subViewList[arg0_26.curSubViewNum]:OnUpdateItems(arg1_26)
	end
end

function var0_0.OnUpdateShop(arg0_27, arg1_27, arg2_27)
	arg0_27:SetShop(arg1_27, arg2_27)

	if arg0_27.subViewList[arg0_27.curSubViewNum] and arg0_27.subViewList[arg0_27.curSubViewNum]:IsSupplyShop() then
		arg0_27.subViewList[arg0_27.curSubViewNum]:OnUpdateShop(arg1_27, arg2_27)
	end
end

function var0_0.OnUpdateCommodity(arg0_28, arg1_28, arg2_28, arg3_28)
	arg0_28:SetShop(arg1_28, arg2_28)

	if arg0_28.subViewList[arg0_28.curSubViewNum] and arg0_28.subViewList[arg0_28.curSubViewNum]:IsSupplyShop() then
		arg0_28.subViewList[arg0_28.curSubViewNum]:OnUpdateCommodity(arg1_28, arg2_28, arg3_28)
	end
end

function var0_0.OnFragmentSellUpdate(arg0_29)
	if arg0_29.subViewList[arg0_29.curSubViewNum] and arg0_29.subViewList[arg0_29.curSubViewNum]:IsSupplyShop() then
		arg0_29.subViewList[arg0_29.curSubViewNum]:OnFragmentSellUpdate()
	end
end

function var0_0.SetShop(arg0_30, arg1_30, arg2_30)
	if not arg0_30.supplyShopList then
		return
	end

	local var0_30 = arg0_30.supplyShopList[arg1_30]

	if var0_30 then
		for iter0_30, iter1_30 in ipairs(var0_30) do
			if iter1_30:IsSameKind(arg2_30) then
				arg0_30.supplyShopList[arg1_30][iter0_30] = arg2_30

				break
			end
		end
	end
end

function var0_0.didEnter(arg0_31)
	arg0_31.eventIDList = {
		arg0_31:bind(var0_0.ON_CLICK_SKIN_SHOP, handler(arg0_31, arg0_31.OnClickSkinShop))
	}

	setActive(arg0_31.chat, false)
	onButton(arg0_31, arg0_31.backBtn, function()
		arg0_31:closeView()
	end, SFX_CANCEL)
	onButton(arg0_31, arg0_31.homeBtn, function()
		arg0_31:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_31, arg0_31.goldBtn, function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.oilBtn, function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.diamondBtn, function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	onToggle(arg0_31, arg0_31.buttonList:Find("shop1List/recommendation/shop1Tg"), function(arg0_37)
		if arg0_37 then
			arg0_31.contextData.shop1 = nil
			arg0_31.contextData.shop2 = nil

			if arg0_31.shop1 == "recommendation" then
				return
			end

			arg0_31.shop1 = "recommendation"
			arg0_31.shop2 = nil

			arg0_31:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_31:emit(NewShopMainMediator.OPEN_LAYER, NewRecommendationShopLayer, NewRecommendationShopMediator)
		end
	end, SFX_PANEL)
	arg0_31:InitSkinToggleList()

	for iter0_31 = 1, #arg0_31.toggleList do
		local var0_31 = arg0_31.toggleList[iter0_31]

		onToggle(arg0_31, var0_31.go, function(arg0_38)
			if arg0_38 then
				arg0_31:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_31.contextData.shop1 = nil
				arg0_31.contextData.shop2 = nil
				arg0_31.shop1 = nil
				arg0_31.shop2 = nil

				originalPrint(string.format("Begin: toggleType=%s, goName=%s", var0_31.type, var0_31.go.parent.name))

				arg0_31.contextData.type = ShopConst.SHOP_TYPE.CHARGE
				arg0_31.contextData.warp = var0_31.type

				originalPrint(string.format("End: warp=%s", arg0_31.contextData.warp))

				local var0_38 = arg0_31:GetShopID(ShopConst.SHOP_TYPE.CHARGE, var0_31.type)

				arg0_31:switchSubView(var0_38)
			end

			local var1_38 = switch(var0_31.type, {
				[ChargeScene.TYPE_PICK] = function()
					return "payshop_pack_red_dot"
				end,
				[ChargeScene.TYPE_GIFT] = function()
					return "gemshop_pack_red_dot"
				end
			})

			if var1_38 then
				if arg0_38 then
					arg0_31.toggleMark = arg0_31.toggleMark or {}
					arg0_31.toggleMark[var0_31.type] = defaultValue(arg0_31.toggleMark[var0_31.type], 0) + 1
				elseif arg0_31.toggleMark and defaultValue(arg0_31.toggleMark[var0_31.type], 0) > 0 then
					arg0_31.toggleMark[var0_31.type] = arg0_31.toggleMark[var0_31.type] - 1

					PlayerPrefs.SetInt(var1_38, getGameset(var1_38)[1])
					pg.EasyRedDotMgr.GetInstance():TriggerMarks("Charge_Page_Exposure")
				end
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_31, arg0_31.buttonList:Find("shop1List/supplyShop/shop1Tg"), function(arg0_41)
		setActive(arg0_31.buttonList:Find("shop1List/supplyShop/shop2List"), arg0_41)

		if arg0_41 then
			triggerToggle(arg0_31.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_31:GetDefaultSupplyShopName()), true)
		end
	end, SFX_PANEL)

	local var1_31 = {
		{
			type = ShopConst.CATEGORY_MONTH,
			go = arg0_31.buttonList:Find("shop1List/supplyShop/shop2List/monthShop")
		},
		{
			type = ShopConst.CATEGORY_SUPPLY,
			go = arg0_31.buttonList:Find("shop1List/supplyShop/shop2List/supplyShop")
		},
		{
			type = ShopConst.CATEGORY_ACTIVITY,
			go = arg0_31.buttonList:Find("shop1List/supplyShop/shop2List/activityShop")
		}
	}

	for iter1_31, iter2_31 in ipairs(var1_31) do
		onToggle(arg0_31, iter2_31.go, function(arg0_42)
			if arg0_42 then
				arg0_31:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_31.contextData.shop1 = nil
				arg0_31.contextData.shop2 = nil
				arg0_31.shop1 = nil
				arg0_31.shop2 = nil
				arg0_31.contextData.type = ShopConst.SHOP_TYPE.SUPPLY
				arg0_31.contextData.warp = iter2_31.type

				local var0_42 = arg0_31:GetShopID(ShopConst.SHOP_TYPE.SUPPLY, iter2_31.type)

				arg0_31:switchSubView(var0_42)
			end
		end, SFX_PANEL)
	end

	local var2_31 = "recommendation"

	if arg0_31.contextData.type == ShopConst.SHOP_TYPE.CHARGE then
		if arg0_31.contextData.warp == ChargeScene.TYPE_DIAMOND then
			var2_31 = "diamondShop"
		elseif arg0_31.contextData.warp == ChargeScene.TYPE_GIFT then
			var2_31 = "giftPackShop"
		elseif arg0_31.contextData.warp == ChargeScene.TYPE_ITEM then
			var2_31 = "functionalItemShop"
		elseif arg0_31.contextData.warp == ChargeScene.TYPE_PICK then
			var2_31 = "specialShop"
		else
			var2_31 = "diamondShop"
		end
	elseif arg0_31.contextData.type == ShopConst.SHOP_TYPE.SKIN then
		var2_31 = "skinShop"
	elseif arg0_31.contextData.type == ShopConst.SHOP_TYPE.SUPPLY then
		var2_31 = "supplyShop"
	end

	if arg0_31.contextData.shop1 then
		var2_31 = arg0_31.contextData.shop1
	end

	triggerToggle(arg0_31.buttonList:Find("shop1List/" .. var2_31 .. "/shop1Tg"), true)

	if var2_31 == "skinShop" then
		-- block empty
	elseif var2_31 == "supplyShop" then
		triggerToggle(arg0_31.buttonList:Find("shop1List/supplyShop/shop2List/" .. arg0_31:GetDefaultSupplyShopName()), true)
	end

	onButton(arg0_31, arg0_31.painting, function()
		arg0_31:displayShipWord()
		arg0_31:emit(NewShopMainMediator.CLICK_MING_SHI)
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.stamp, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	arg0_31:RefreshActivityShop()
	arg0_31:updateNoRes()
	arg0_31:jpUIEnter()
end

function var0_0.GetDefaultSupplyShopName(arg0_45)
	if arg0_45.contextData.type ~= ShopConst.SHOP_TYPE.SUPPLY then
		return "supplyShop"
	end

	local var0_45 = arg0_45.contextData.warp

	if type(var0_45) == "string" then
		local var1_45 = ShopConst.SHOP_NAME_LIST[var0_45]

		arg0_45.contextData.warp = var1_45[1]
		arg0_45.contextData.shopID = var1_45[2]
	elseif type(var0_45) == "number" and arg0_45.contextData.shopID == nil then
		for iter0_45, iter1_45 in pairs(ShopConst.SUPPLY_SHOP_LIST) do
			for iter2_45, iter3_45 in pairs(iter1_45) do
				if iter3_45 == var0_45 then
					arg0_45.contextData.warp = iter0_45
					arg0_45.contextData.shopID = iter3_45

					break
				end
			end
		end
	end

	local var2_45 = ""

	return arg0_45.contextData.warp == ShopConst.CATEGORY_MONTH and "monthShop" or arg0_45.contextData.warp == ShopConst.CATEGORY_SUPPLY and "supplyShop" or arg0_45.contextData.warp == ShopConst.CATEGORY_ACTIVITY and "activityShop" or "supplyShop"
end

function var0_0.RefreshActivityShop(arg0_46)
	local var0_46 = arg0_46.supplyShopList[ShopConst.TYPE_ACTIVITY] or {}

	setActive(arg0_46.buttonList:Find("shop1List/supplyShop/shop2List/activityShop"), #var0_46 > 0)
end

function var0_0.ShowOrHideUI(arg0_47, arg1_47)
	arg0_47:setVisible(arg1_47)
	setActive(arg0_47.buttonList, arg1_47)
end

function var0_0.ShowOrHideUI2(arg0_48, arg1_48)
	for iter0_48 = 0, arg0_48._tf.childCount - 1 do
		setActive(arg0_48._tf:GetChild(iter0_48), arg1_48)
	end

	setActive(arg0_48.buttonList:Find("leftBg"), arg1_48)
	setActive(arg0_48.buttonList:Find("shop1List"), arg1_48)
	setActive(arg0_48.buttonList:Find("top"), true)
end

function var0_0.OnChargeSuccess(arg0_49, arg1_49)
	arg0_49.chargeTipWindow:ExecuteAction("Show", arg1_49, function()
		MainFetchPrevPeriodCrusingSequence.New():Execute(function()
			return
		end)
	end)
end

function var0_0.LoadMingshi(arg0_52)
	if Live2dConst.GetLive2DArm32MatchAble() then
		local var0_52 = Ship.New({
			configId = 312011
		}):getPainting()

		LoadPaintingPrefabAsync(arg0_52.painting, var0_52, var0_52, "mainNormal", function()
			arg0_52.loading = false
		end)
	else
		arg0_52:createLive2D()
	end

	arg0_52:AddLive2dTimer()
end

function var0_0.AddLive2dTimer(arg0_54)
	arg0_54:StopLive2dTimer()

	arg0_54.live2dTimer = Timer.New(function()
		local var0_55 = pg.ChargeShipTalkInfo.Actions
		local var1_55 = var0_55[math.random(#var0_55)]

		if arg0_54:checkBuyDone(var1_55.action) then
			arg0_54:displayShipWord(nil, false, var1_55.dialog_index)
		end
	end, 20, -1)

	arg0_54.live2dTimer:Start()
end

function var0_0.StopLive2dTimer(arg0_56)
	if arg0_56.live2dTimer then
		arg0_56.live2dTimer:Stop()

		arg0_56.live2dTimer = nil
	end
end

function var0_0.ShowChargeWarp(arg0_57, arg1_57)
	setActive(arg0_57.frame, arg1_57)
	setActive(arg0_57.viewContainer, arg1_57)
	arg0_57:ShowResourceBar(arg1_57)

	local var0_57 = arg0_57.subViewList[arg0_57.curSubViewNum]

	if var0_57 then
		if arg1_57 == false then
			var0_57:Destroy()

			arg0_57.curSubViewNum = 0
		else
			var0_57:ShowPanel(arg1_57)
		end
	end
end

function var0_0.ShowResourceBar(arg0_58, arg1_58)
	if arg0_58.resourceBarFlag == arg1_58 then
		return
	end

	arg0_58.resourceBarFlag = arg1_58

	setActive(arg0_58.resourcePanel, arg1_58)
end

function var0_0.willExit(arg0_59)
	for iter0_59, iter1_59 in ipairs(arg0_59.eventIDList) do
		arg0_59:disconnect(iter1_59)
	end

	arg0_59.eventIDList = nil

	if arg0_59.bulinTip then
		arg0_59.bulinTip:Destroy()

		arg0_59.bulinTip = nil
	end

	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_59.specialTip)
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_59.giftTip)

	if arg0_59.toggleMark then
		for iter2_59, iter3_59 in pairs(arg0_59.toggleMark) do
			if iter3_59 > 0 then
				local var0_59 = switch(iter2_59, {
					[ChargeScene.TYPE_PICK] = function()
						return "payshop_pack_red_dot"
					end,
					[ChargeScene.TYPE_GIFT] = function()
						return "gemshop_pack_red_dot"
					end
				})

				PlayerPrefs.SetInt(var0_59, getGameset(var0_59)[1])
			end
		end

		arg0_59.toggleMark = nil
	end

	arg0_59:ShowResourceBar()
	arg0_59:unBlurView()

	if arg0_59.chargeTipWindow then
		arg0_59.chargeTipWindow:Destroy()

		arg0_59.chargeTipWindow = nil
	end

	arg0_59.contextData.singleWindow:Destroy()
	arg0_59.contextData.multiWindow:Destroy()
	arg0_59.contextData.singleWindowForESkin:Destroy()
	arg0_59.contextData.paintingView:Dispose()

	arg0_59.contextData.singleWindow = nil
	arg0_59.contextData.multiWindow = nil
	arg0_59.contextData.singleWindowForESkin = nil
	arg0_59.contextData.paintingView = nil
	arg0_59.bulinTip = nil

	for iter4_59, iter5_59 in pairs(arg0_59.subViewList) do
		iter5_59:Destroy()
	end

	arg0_59.subViewList = nil

	if arg0_59.heartsTimer then
		arg0_59.heartsTimer:Stop()

		arg0_59.heartsTimer = nil
	end

	if arg0_59.live2dChar then
		arg0_59.live2dChar:Dispose()
	end

	arg0_59:StopLive2dTimer()
	arg0_59:stopCV()
	arg0_59:DisposeSkinToggleList()

	if arg0_59.giftShopView then
		arg0_59.giftShopView:OnDestroy()
	end
end

function var0_0.onBackPressed(arg0_62)
	if arg0_62.contextData.singleWindow:GetLoaded() and arg0_62.contextData.singleWindow:isShowing() then
		arg0_62.contextData.singleWindow:Close()

		return
	end

	if arg0_62.contextData.multiWindow:GetLoaded() and arg0_62.contextData.multiWindow:isShowing() then
		arg0_62.contextData.multiWindow:Close()

		return
	end

	if arg0_62.contextData.singleWindowForESkin:GetLoaded() and arg0_62.contextData.singleWindowForESkin:isShowing() then
		arg0_62.contextData.singleWindowForESkin:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_62)
end

function var0_0.initSubView(arg0_63)
	local var0_63 = ChargeDiamondShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData)
	local var1_63 = ChargeGiftShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData)
	local var2_63 = ChargeItemShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData)
	local var3_63 = ChargePickShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData)
	local var4_63 = SupplyShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData, ShopConst.CATEGORY_MONTH)
	local var5_63 = SupplyShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData, ShopConst.CATEGORY_SUPPLY)
	local var6_63 = SupplyShopView.New(arg0_63.viewContainer, arg0_63.event, arg0_63.contextData, ShopConst.CATEGORY_ACTIVITY)

	arg0_63.curSubViewNum = 0
	arg0_63.subViewList = {
		[ShopConst.SHOP_ID.DIAMOND] = var0_63,
		[ShopConst.SHOP_ID.GIFT] = var1_63,
		[ShopConst.SHOP_ID.ITEM] = var2_63,
		[ShopConst.SHOP_ID.PICK] = var3_63,
		[ShopConst.SHOP_ID.MONTH] = var4_63,
		[ShopConst.SHOP_ID.SUPPLY] = var5_63,
		[ShopConst.SHOP_ID.ACTIVITY] = var6_63
	}

	for iter0_63, iter1_63 in pairs(arg0_63.subViewList) do
		iter1_63:RegisterView(arg0_63)
	end

	arg0_63.contextData.singleWindow = ShopSingleWindow.New(arg0_63._tf, arg0_63.event)
	arg0_63.contextData.multiWindow = ShopMultiWindow.New(arg0_63._tf, arg0_63.event)
	arg0_63.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_63._tf, arg0_63.event)
	arg0_63.contextData.paintingView = ShopPaintingView.New(arg0_63._tf:Find("frame/supplyPaint"), arg0_63._tf:Find("frame/chat"))

	arg0_63.contextData.paintingView:setSecretaryPos(arg0_63._tf:Find("frame/secretaryPos"))
end

function var0_0.GetShopID(arg0_64, arg1_64, arg2_64)
	return ShopConst.SHOP_LIST[arg1_64][arg2_64]
end

function var0_0.switchSubView(arg0_65, arg1_65)
	originalPrint(string.format("End: shopID=%s curShopID=%s", arg1_65, arg0_65.curSubViewNum))

	if arg1_65 == arg0_65.curSubViewNum then
		return
	end

	arg0_65.subViewList[arg1_65]:setGoodData(arg0_65.firstChargeIds, arg0_65.chargedList, arg0_65.normalList, arg0_65.normalGroupList)
	arg0_65.subViewList[arg1_65]:Reset()
	arg0_65.subViewList[arg1_65]:Load()

	if arg0_65.subViewList[arg1_65].SetAllShopData then
		arg0_65.subViewList[arg1_65]:ActionInvoke("SetAllShopData", arg0_65.supplyShopList)
	end

	local var0_65 = arg0_65.subViewList[arg0_65.curSubViewNum]

	if var0_65 then
		var0_65:Destroy()
	end

	arg0_65.curSubViewNum = arg1_65

	arg0_65:SwitchPainting(arg0_65.subViewList[arg1_65]:IsSupplyShop())

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_65.userAgreeBtn3, arg1_65 == ChargeScene.TYPE_DIAMOND)
		setActive(arg0_65.userAgreeBtn4, arg1_65 == ChargeScene.TYPE_DIAMOND)
	end
end

function var0_0.SwitchPainting(arg0_66, arg1_66)
	arg0_66.contextData.paintingView:Show(arg1_66)
	setActive(arg0_66.painting, not arg1_66)

	if arg1_66 then
		arg0_66:StopLive2dTimer()

		arg0_66.chatFlag = nil

		arg0_66:stopCV()
		setActive(arg0_66.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

		if LOCK_CLICK_MINGSHI then
			setActive(arg0_66.stamp, false)
		end
	else
		setActive(arg0_66.stamp, false)
		arg0_66:AddLive2dTimer()
	end
end

function var0_0.switchSubViewByTogger(arg0_67, arg1_67)
	local var0_67 = arg0_67.toggleList[arg1_67]

	triggerToggle(var0_67.go, true)
end

function var0_0.updateCurSubView(arg0_68)
	if not isActive(arg0_68.viewContainer) then
		return
	end

	local var0_68 = arg0_68.subViewList[arg0_68.curSubViewNum]

	if var0_68 == nil then
		return
	end

	var0_68:setGoodData(arg0_68.firstChargeIds, arg0_68.chargedList, arg0_68.normalList, arg0_68.normalGroupList)
	var0_68:reUpdateAll()
end

function var0_0.updateNoRes(arg0_69, arg1_69)
	if not arg1_69 then
		arg1_69 = arg0_69.contextData.noRes
	else
		arg0_69.contextData.noRes = arg1_69
	end

	if not arg1_69 or #arg1_69 <= 0 then
		return
	end

	arg0_69.contextData.noRes = {}

	local var0_69 = getProxy(BagProxy):getData()
	local var1_69 = ""

	for iter0_69, iter1_69 in ipairs(arg1_69) do
		if iter1_69[2] > 0 then
			if iter1_69[1] == 59001 then
				arg1_69[iter0_69][2] = iter1_69[3] - arg0_69.player.gold
			else
				arg1_69[iter0_69][2] = iter1_69[3] - (var0_69[iter1_69[1]] and var0_69[iter1_69[1]].count or 0)
			end
		end

		if arg1_69[iter0_69][2] > 0 then
			table.insert(arg0_69.contextData.noRes, arg1_69[iter0_69])
		end
	end

	for iter2_69, iter3_69 in ipairs(arg0_69.contextData.noRes) do
		local var2_69 = Item.getConfigData(iter3_69[1]).name

		var1_69 = var1_69 .. i18n(iter3_69[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_69, iter3_69[2])

		if iter2_69 < #arg0_69.contextData.noRes then
			var1_69 = var1_69 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_69 == "" then
		arg0_69:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_69:displayShipWord(i18n("text_shop_noRes_tip", var1_69), true)
	end
end

function var0_0.displayShipWord(arg0_70, arg1_70, arg2_70, arg3_70)
	if not arg0_70.chatFlag then
		if not arg1_70 and arg0_70.contextData.noRes and #arg0_70.contextData.noRes > 0 then
			setActive(arg0_70.chat, false)

			arg0_70.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_70.chatFlag = true

		if not arg0_70.isInitChatPosition then
			arg0_70.isInitChatPosition = true

			arg0_70:InitChatPosition()
		end

		setActive(arg0_70.chat, true)

		local var0_70 = arg0_70.player:getChargeLevel()
		local var1_70 = arg3_70 or math.random(1, var0_70)
		local var2_70

		if arg3_70 then
			var2_70 = pg.pay_level_award[var1_70].dialog
		else
			var2_70 = arg1_70 or pg.pay_level_award[var1_70].dialog
		end

		if not arg1_70 then
			arg0_70:playCV(var1_70)
		end

		setText(arg0_70.chatText, var2_70)

		local var3_70 = arg0_70.chatText:GetComponent(typeof(Text))

		;(function()
			local var0_71 = 3
			local var1_71 = 0.3

			LeanTween.scale(rtf(arg0_70.chat.gameObject), Vector3.New(1, 1, 1), var1_71):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_70 then
					LeanTween.scale(rtf(arg0_70.chat.gameObject), Vector3.New(0, 0, 1), var1_71):setEase(LeanTweenType.easeInBack):setDelay(var1_71 + var0_71):setOnComplete(System.Action(function()
						arg0_70.chatFlag = nil

						setActive(arg0_70.chat, false)

						if arg0_70.contextData.noRes and #arg0_70.contextData.noRes > 0 then
							arg0_70:updateNoRes()
						end
					end))
				else
					arg0_70.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_74)
	return
end

function var0_0.playHeartEffect(arg0_75)
	if arg0_75.heartsTimer then
		arg0_75.heartsTimer:Stop()
	end

	local var0_75 = arg0_75.painting:Find("heartsfly")

	setActive(var0_75, true)

	arg0_75.heartsTimer = Timer.New(function()
		setActive(var0_75, false)
	end, 1, 1)

	arg0_75.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_77)
	local var0_77 = Live2DPainting.GenerateData({
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
		parent = arg0_77._tf:Find("frame/painting/live2d")
	})

	arg0_77.live2dChar = Live2DPainting.New(var0_77, function(arg0_78)
		arg0_78:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
	end)
end

function var0_0.checkBuyDone(arg0_79, arg1_79)
	if not arg0_79.live2dChar or not arg0_79.live2dChar:IsLoaded() then
		return
	end

	local var0_79

	if type(arg1_79) == "string" then
		if arg1_79 == "damonds" then
			var0_79 = "diamond"
		else
			var0_79 = arg1_79
		end
	else
		local var1_79 = ShopConst.GetShopConfig(arg1_79)

		if var1_79 and var1_79.effect_args and type(var1_79.effect_args) == "table" then
			for iter0_79, iter1_79 in ipairs(var1_79.effect_args) do
				if iter1_79 == 1 then
					var0_79 = "gold"
				end
			end
		end
	end

	local var2_79 = arg0_79.preAniName == "gold" or arg0_79.preAniName == "diamond"
	local var3_79 = var0_79 == "gold" or var0_79 == "diamond"
	local var4_79 = var2_79 and var3_79 or not var2_79

	var4_79 = var0_79 and arg0_79.preAniName ~= var0_79 and var4_79

	if var4_79 then
		arg0_79.preAniName = var0_79

		arg0_79.live2dChar:TriggerAction(var0_79, nil, true)
	end

	return var4_79
end

function var0_0.playCV(arg0_80, arg1_80)
	local var0_80 = pg.pay_level_award[arg1_80]
	local var1_80

	if var0_80 and var0_80.cv_key ~= "" then
		var1_80 = "event:/cv/chargeShop/" .. var0_80.cv_key
	end

	if var1_80 then
		arg0_80:stopCV()

		arg0_80._currentVoice = var1_80

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_80)
	end
end

function var0_0.stopCV(arg0_81)
	if arg0_81._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_81._currentVoice)
	end

	arg0_81._currentVoice = nil
end

function var0_0.blurView(arg0_82)
	arg0_82:OverlayPanel(arg0_82.buttonList, {
		pbList = {
			arg0_82.buttonList:Find("leftBg")
		}
	})
end

function var0_0.unBlurView(arg0_83)
	arg0_83:UnOverlayPanel(arg0_83.buttonList, arg0_83._tf)
end

function var0_0.jpUIInit(arg0_84)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_84.userAgreeBtn3 = arg0_84._tf:Find("frame/raw1Btn")
	arg0_84.userAgreeBtn4 = arg0_84._tf:Find("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_85)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_85, arg0_85.userAgreeBtn3, function()
		local var0_86 = require("ShareCfg.UserAgreement3")

		arg0_85:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_86 or "")
	end, SFX_PANEL)
	onButton(arg0_85, arg0_85.userAgreeBtn4, function()
		local var0_87 = require("ShareCfg.UserAgreement4")

		arg0_85:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_87 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_88, arg1_88)
	local function var0_88()
		if arg0_88.refreshTimer then
			arg0_88.refreshTimer:Stop()

			arg0_88.refreshTimer = nil
		end
	end

	var0_88()

	arg0_88.refreshTimer = Timer.New(function()
		if arg1_88 + 1 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			var0_88()
			arg0_88:emit(NewShopMainMediator.GET_CHARGE_LIST)
		end
	end, 1, -1)

	arg0_88.refreshTimer:Start()
	arg0_88.refreshTimer.func()
end

function var0_0.InitSkinToggleList(arg0_91)
	arg0_91.uiSkinToggleParent = arg0_91.buttonList:Find("shop1List/skinShop/shop2List")
	arg0_91.uiSkinToggleItem = arg0_91.buttonList:Find("shop1List/skinShop/shop2List/skinToggleItem")

	local var0_91 = getProxy(ShipSkinProxy):GetInTimeSkins()

	setActive(arg0_91.buttonList:Find("shop1List/skinShop/shop1Tg/timeLimit"), #var0_91 > 0)

	arg0_91.skinShopList = arg0_91:GetSkinShopList()
	arg0_91.skinShopItemList = {}

	onToggle(arg0_91, arg0_91.buttonList:Find("shop1List/skinShop/shop1Tg"), function(arg0_92)
		setActive(arg0_91.buttonList:Find("shop1List/skinShop/shop2List"), arg0_92)

		if arg0_92 then
			if arg0_91.shop1 == "skinShop" then
				return
			end

			arg0_91.shop1 = "skinShop"

			local var0_92 = arg0_91.skinShopItemList[table.keyof(arg0_91.skinShopList, arg0_91:GetDefaultSkinShop())]

			var0_92 = arg0_91.contextData.shop1 and arg0_91.contextData.shop2 and arg0_91.skinShopItemList[table.keyof(arg0_91.skinShopList, arg0_91.contextData.shop2)] or var0_92
			arg0_91.contextData.shop1 = "skinShop"

			var0_92:TriggerToggle()
		end
	end, SFX_PANEL)

	for iter0_91, iter1_91 in ipairs(arg0_91.skinShopList) do
		arg0_91.skinShopItemList[iter0_91] = arg0_91.skinShopItemList[iter0_91] or NewShopMainSkinToggleItem.New(Object.Instantiate(arg0_91.uiSkinToggleItem, arg0_91.uiSkinToggleParent), arg0_91)

		arg0_91.skinShopItemList[iter0_91]:didEnter(iter1_91)
	end
end

function var0_0.OnClickSkinShop(arg0_93, arg1_93, arg2_93)
	arg0_93.contextData.shop2 = arg2_93

	if arg0_93.shop2 == arg2_93 then
		return
	end

	arg0_93.shop2 = arg2_93

	arg0_93:ShowChargeWarp(false)
	pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
	arg0_93:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
		type = arg2_93,
		mode = arg0_93.contextData.mode
	})
end

function var0_0.DisposeSkinToggleList(arg0_94)
	for iter0_94, iter1_94 in ipairs(arg0_94.skinShopItemList) do
		iter1_94:willExit()
	end

	arg0_94.skinShopItemList = nil
end

function var0_0.GetSkinShopList(arg0_95)
	local var0_95 = Clone(pg.shop_skin_subsheet.get_id_list_by_type[0])

	if #getProxy(ShipSkinProxy):GetInTimeSkins() <= 0 then
		table.remove(var0_95, 1)
	end

	local var1_95 = pg.TimeMgr.GetInstance()
	local var2_95 = getProxy(ShipSkinProxy):GetAllSkins()

	for iter0_95, iter1_95 in ipairs(pg.shop_skin_subsheet.get_id_list_by_type[1] or {}) do
		local var3_95 = pg.shop_skin_subsheet[iter1_95]

		if var1_95:inTime(var3_95.time) then
			for iter2_95, iter3_95 in ipairs(var2_95) do
				if table.keyof(var3_95.param, iter3_95.id) then
					table.insert(var0_95, iter1_95)

					break
				end
			end
		end
	end

	table.sort(var0_95, function(arg0_96, arg1_96)
		local var0_96 = pg.shop_skin_subsheet[arg0_96]
		local var1_96 = pg.shop_skin_subsheet[arg1_96]

		return var0_96.sort == var0_96.sort and arg0_96 < arg1_96 or var0_96.sort < var1_96.sort
	end)

	return var0_95
end

function var0_0.GetDefaultSkinShop(arg0_97)
	local var0_97 = Clone(arg0_97.skinShopList)

	table.sort(var0_97, function(arg0_98, arg1_98)
		local var0_98 = pg.shop_skin_subsheet[arg0_98]
		local var1_98 = pg.shop_skin_subsheet[arg1_98]

		if var0_98.shop_skin_subsheet == var1_98.shop_skin_subsheet then
			return var0_98.sort == var1_98.sort and arg0_98 < arg1_98 or var0_98.sort < var1_98.sort
		else
			return var0_98.shop_skin_subsheet < var1_98.shop_skin_subsheet
		end
	end)

	return var0_97[1]
end

return var0_0
