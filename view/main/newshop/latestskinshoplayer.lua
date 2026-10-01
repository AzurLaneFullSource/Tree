local var0_0 = class("LatestSkinShopLayer", import("...base.BaseUI"))

var0_0.MODE_OVERVIEW = 1
var0_0.MODE_EXPERIENCE = 2
var0_0.MODE_EXPERIENCE_FOR_ITEM = 3

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 1
local var5_0 = 2
local var6_0 = 3
local var7_0 = 4
local var8_0 = 5
local var9_0 = 6
local var10_0 = 7
local var11_0 = 8
local var12_0 = -1
local var13_0 = -2
local var14_0 = -3
local var15_0 = -4
local var16_0 = 9999
local var17_0 = 9997
local var18_0 = 9998

var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW = "NewSkinShopMainView:EVT_SHOW_OR_HIDE_PURCHASE_VIEW"
var0_0.EVT_ON_PURCHASE = "NewSkinShopMainView:EVT_ON_PURCHASE"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
end

local function var19_0(arg0_2)
	if not var0_0.obtainBtnSpriteNames then
		var0_0.obtainBtnSpriteNames = {
			[var4_0] = "yigoumai_button",
			[var5_0] = "goumai_button",
			[var6_0] = "qianwanghuoqu_button",
			[var7_0] = "item_buy",
			[var8_0] = "furniture_shop",
			[var9_0] = "tiyan_btn",
			[var10_0] = "item_buy",
			[var11_0] = "buy_with_gift"
		}
	end

	return var0_0.obtainBtnSpriteNames[arg0_2]
end

function var0_0.getUIName(arg0_3)
	return "LatestSkinShopUI"
end

function var0_0.getGroupName(arg0_4)
	return "NewShopMainScene"
end

function var0_0.getResource(arg0_5, arg1_5)
	local var0_5 = {
		"ui/LatestSkinShopUI",
		"ui/SkinShopUI_atlas",
		"skinicon"
	}
	local var1_5 = pg.ship_skin_template

	local function var2_5(arg0_6)
		local var0_6 = Goods.Create({
			shop_id = arg0_6
		}, Goods.TYPE_CHARGE)
		local var1_6 = getProxy(ShopsProxy):getChargedList() or {}
		local var2_6 = ChargeConst.getBuyCount(var1_6, var0_6.id)

		var0_6:updateBuyCount(var2_6)

		return var0_6
	end

	local function var3_5()
		if arg1_5.skinCommodities then
			return arg1_5.skinCommodities
		end

		if arg1_5.commodityId or arg1_5.giftPackCommodity then
			local var0_7 = (arg1_5.giftPackCommodity or var2_5(arg1_5.commodityId)):GetSkinProbability()

			return getProxy(ShipSkinProxy):GetProbabilitySkins(var0_7)
		end

		local var1_7 = arg1_5.type or var0_0.TYPE_PERMANANT_SKIN
		local var2_7 = arg1_5.mode or var0_0.MODE_OVERVIEW
		local var3_7 = {}

		if var1_7 == var0_0.TYPE_NEW_SKIN then
			var3_7 = getProxy(ShipSkinProxy):GetInTimeSkins()
		elseif var1_7 == var0_0.TYPE_PERMANANT_SKIN then
			var3_7 = getProxy(ShipSkinProxy):GetPermanentSkins()
		end

		if LOCK_SKIN_US then
			local var4_7 = pg.gameset.levellimit_skintype.key_value
			local var5_7 = pg.gameset.levellimit_skintype.description

			if var4_7 >= getProxy(PlayerProxy):getData().level then
				var3_7 = _.filter(var3_7, function(arg0_8)
					local var0_8 = arg0_8:getSkinId()
					local var1_8 = var1_5[var0_8].shop_type_id

					return table.contains(var5_7, var1_8)
				end)
			end
		end

		if var2_7 == var0_0.MODE_OVERVIEW then
			for iter0_7 = #var3_7, 1, -1 do
				if var3_7[iter0_7]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
					table.remove(var3_7, iter0_7)
				end
			end
		end

		return var3_7
	end

	local var4_5 = (function(arg0_9)
		local var0_9 = {}

		for iter0_9, iter1_9 in ipairs(arg0_9) do
			local var1_9 = iter1_9:getSkinId()
			local var2_9 = var1_5[var1_9]

			table.insertto(var0_9, ResPathSupport.GetPaintingShipYardIconListByPaintingName(var2_9.prefab))
			table.insertto(var0_9, ResPathSupport.GetSpineQIconListByPrefabName(var2_9.painting))
			table.insertto(var0_9, ResPathSupport.GetSpineCharListByPrefabName(var2_9.prefab))
			table.insertto(var0_9, ResPathSupport.GetShopPaintingListByPaintingName(var2_9.painting))
			PaintingGroupConst.AddPaintingNameBySkinID(var0_9, var1_9)
			table.insertto(var0_9, ResPathSupport.GetShipSkinLive2DList(var1_9))
			table.insertto(var0_9, ResPathSupport.GetShipSkinSpinePaintingList(var1_9))
			table.insertto(var0_9, ResPathSupport.GetShipSkinBgList(var1_9))

			if iter1_9.type == Goods.TYPE_SKIN then
				local var3_9 = iter1_9:getConfig("resource_type")
				local var4_9 = Item.getConfigData(id2ItemId(var3_9))

				table.insert(var0_9, var4_9.icon)
			end
		end

		return var0_9
	end)(var3_5())

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_5, arg1_5), var0_5, var4_5))
end

function var0_0.init(arg0_10)
	arg0_10.bgs = arg0_10._tf:Find("bgs")
	arg0_10.adapt = arg0_10._tf:Find("adapt")
	arg0_10.top = arg0_10.adapt:Find("top")
	arg0_10.bottom = arg0_10.adapt:Find("bottom")
	arg0_10.right = arg0_10.adapt:Find("right")
	arg0_10.subPage = arg0_10.adapt:Find("subPage")
	arg0_10.resources = arg0_10.adapt:Find("top/resources")
	arg0_10.limitTime = arg0_10.adapt:Find("top/title/limit_time/Text")
	arg0_10.skinName = arg0_10.adapt:Find("top/title/skin_name_mask/skin_name")
	arg0_10.shipName = arg0_10.adapt:Find("top/title/name_mask/name")
	arg0_10.changeSkin = arg0_10.adapt:Find("top/change_skin")
	arg0_10.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_10.changeSkin, "toggle_ui"))
	arg0_10.showOwnBtn = arg0_10.adapt:Find("bottom/showOwnBtn")
	arg0_10.filterBtn = arg0_10.adapt:Find("bottom/filterBtn")
	arg0_10.search = arg0_10.adapt:Find("bottom/search")
	arg0_10.scrollrect = arg0_10.adapt:Find("bottom/scroll/content"):GetComponent("LScrollRect")
	arg0_10.sdTg = arg0_10.adapt:Find("right/sdTg")
	arg0_10.hideUITg = arg0_10.adapt:Find("right/hideUITg")
	arg0_10.charContainer = arg0_10.adapt:Find("right/char_container")
	arg0_10.backChara = arg0_10.charContainer:Find("bg/back/chara")
	arg0_10.charTf = arg0_10.charContainer:Find("char")
	arg0_10.furnitureContainer = arg0_10.charContainer:Find("fur")
	arg0_10.switchPreviewBtn = arg0_10.charContainer:Find("switch")
	arg0_10.dynamicToggle = arg0_10.adapt:Find("right/functionsAndTags/dynamic")
	arg0_10.dynamicIcon = arg0_10.adapt:Find("right/functionsAndTags/dynamic/icon")
	arg0_10.showBgToggle = arg0_10.adapt:Find("right/functionsAndTags/showBg")
	arg0_10.dynamicResToggle = arg0_10.adapt:Find("right/functionsAndTags/dynamic/l2d_res_state")
	arg0_10.tagList = UIItemList.New(arg0_10.adapt:Find("right/functionsAndTags/tags"), arg0_10.adapt:Find("right/functionsAndTags/tags/tag"))
	arg0_10.giftPackBtn = arg0_10.adapt:Find("right/giftPackBtn")
	arg0_10.price = arg0_10.adapt:Find("right/price")
	arg0_10.btnsList = {
		arg0_10.price:Find("normal/btns"),
		arg0_10.price:Find("charge/btns")
	}
	arg0_10.filterUI = arg0_10.adapt:Find("subPage/filterUI")
	arg0_10.filterContent = arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content")
	arg0_10.painting = arg0_10._tf:Find("painting")
	arg0_10.paintingTF = arg0_10._tf:Find("painting/paint")
	arg0_10.defaultPaintingPosition = arg0_10.paintingTF.anchoredPosition
	arg0_10.defaultPaintingScale = arg0_10.paintingTF.localScale
	arg0_10.live2dContainer = arg0_10._tf:Find("painting/paint/live2d")
	arg0_10.spTF = arg0_10._tf:Find("painting/paint/spinePainting")
	arg0_10.spBg = arg0_10._tf:Find("painting/paintBg/spinePainting")

	setActive(arg0_10.charContainer, false)
	setActive(arg0_10.filterUI, false)

	arg0_10.mainTitle = arg0_10.adapt:Find("top/mainTitle")
	arg0_10.backBtn = arg0_10.adapt:Find("top/closeBtn")
	arg0_10.homeBtn = arg0_10.adapt:Find("top/homeBtn")
	arg0_10.giftPack = arg0_10.adapt:Find("giftPack")

	setActive(arg0_10.mainTitle, false)
	setActive(arg0_10.backBtn, false)
	setActive(arg0_10.homeBtn, false)
	setActive(arg0_10.giftPack, false)

	arg0_10.downloads = {}
	arg0_10.isToggleDynamic = false
	arg0_10.isToggleShowBg = true
	arg0_10.isPreviewFurniture = false
	arg0_10.interactionPreview = BackYardInteractionPreview.New(arg0_10.furnitureContainer, Vector3(0, 0, 0))
	arg0_10.voucherMsgBox = SkinVoucherMsgBox.New(pg.UIMgr.GetInstance().OverlayMain)
	arg0_10.purchaseView = NewSkinShopPurchaseView.New(arg0_10._tf, arg0_10.event)

	arg0_10:RegisterEvent()
	setText(arg0_10._tf:Find("bgs/empty/Text"), i18n("shop_new_unfound"))
	setText(arg0_10.adapt:Find("top/mainTitle/Text"), i18n("shop_new_shop"))
	setText(arg0_10.filterBtn:Find("Text"), i18n("shop_new_sort"))
	setText(arg0_10.search:Find("holder"), i18n("shop_new_search"))

	for iter0_10, iter1_10 in ipairs(arg0_10.btnsList) do
		setText(iter1_10:Find("yigoumai_button/Text"), i18n("shop_new_purchased"))
		setText(iter1_10:Find("goumai_button/Text"), i18n("shop_new_purchase"))
		setText(iter1_10:Find("qianwanghuoqu_button/Text"), i18n("shop_new_claim"))
		setText(iter1_10:Find("furniture_shop/Text"), i18n("shop_new_furniture"))
		setText(iter1_10:Find("item_buy/Text"), i18n("shop_new_discount"))
		setText(iter1_10:Find("tiyan_btn/Text"), i18n("shop_new_try"))
		setText(iter1_10:Find("buy_with_gift/Text"), i18n("shop_new_purchase"))
	end

	setText(arg0_10.btnsList[2]:Find("buy_charge/Text"), i18n("shop_new_purchase"))
	setText(arg0_10.price:Find("btn/tag/Text"), i18n("shop_new_gift"))
	setText(arg0_10.giftPack:Find("panel/desc"), i18n("shop_new_gem_transform"))
	setText(arg0_10.giftPack:Find("price/btns/yigoumai_button/Text"), i18n("shop_new_purchased"))
	setText(arg0_10.filterUI:Find("panelMask/panel/title"), i18n("shop_new_sort"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/subTitleFrame/subTitle"), i18n("shop_new_review"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/1/Text"), i18n("shop_new_owned"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/2/Text"), i18n("shop_new_havent_own"))
	setScrollText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/3/mask/Text"), i18n("shop_new_unused"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("shop_new_type"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/2/Text"), i18n("shop_new_static"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/3/Text"), i18n("shop_new_dynamic"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/4/Text"), i18n("shop_new_static_bg"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/5/Text"), i18n("shop_new_dynamic_bg"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/6/Text"), i18n("shop_new_bgm"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/subTitleFrame/subTitle"), i18n("shop_new_index"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/1/Text"), i18n("shop_new_ship_owned"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/2/Text"), i18n("shop_new_ship_havent_owned"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/camp/subTitleFrame/subTitle"), i18n("shop_new_nation"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/rarity/subTitleFrame/subTitle"), i18n("shop_new_rarity"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipType/subTitleFrame/subTitle"), i18n("shop_new_category"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/themeType/subTitleFrame/subTitle"), i18n("shop_new_skin_theme"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/subTitleFrame/subTitle"), i18n("skin_shop_tag"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/0/Text"), i18n("skin_shop_tag_0"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/1/Text"), i18n("skin_shop_tag_1"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/2/Text"), i18n("skin_shop_tag_2"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/3/Text"), i18n("skin_shop_tag_3"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/4/Text"), i18n("skin_shop_tag_4"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/5/Text"), i18n("skin_shop_tag_5"))
	setText(arg0_10.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/6/Text"), i18n("skin_shop_tag_6"))
	setText(arg0_10.filterUI:Find("panelMask/panel/bottom/ok/Text"), i18n("shop_new_confirm"))

	arg0_10.uiOwnOptions = arg0_10.filterContent:Find("own/options")
	arg0_10.uiTypeOptions = arg0_10.filterContent:Find("type/options")
	arg0_10.uiShipHaveOptions = arg0_10.filterContent:Find("shipHave/options")
	arg0_10.uiCampOptions = arg0_10.filterContent:Find("camp/options")
	arg0_10.uiRrarityOptions = arg0_10.filterContent:Find("rarity/options")
	arg0_10.uiShipTypeOptions = arg0_10.filterContent:Find("shipType/options")
	arg0_10.uiThemeTypeOptions = arg0_10.filterContent:Find("themeType/options")
	arg0_10.uiTagTypeOptions = arg0_10.filterContent:Find("tag/options")

	arg0_10:Overlay()
end

function var0_0.Overlay(arg0_11)
	arg0_11:OverlayPanel(arg0_11.adapt, {
		pbList = {
			arg0_11.top:Find("title"),
			arg0_11.top:Find("title/limit_time"),
			arg0_11.top:Find("title/charaNameBg"),
			arg0_11.showOwnBtn,
			arg0_11.filterBtn,
			arg0_11.search,
			arg0_11.charContainer:Find("bg"),
			arg0_11.price:Find("normal/consume"),
			arg0_11.filterUI:Find("panelMask/panel")
		}
	})
end

function var0_0.UnOverlay(arg0_12)
	arg0_12:UnOverlayPanel(arg0_12.adapt, arg0_12._tf)
end

function var0_0.didEnter(arg0_13)
	arg0_13:InitData()
	arg0_13:SetFilterPanel()
	arg0_13:SetResource()

	if arg0_13.mode == var0_0.MODE_EXPERIENCE or arg0_13.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI_2, false)
		setActive(arg0_13.showOwnBtn, false)
		setActive(arg0_13.filterBtn, false)
		setActive(arg0_13.search, false)

		arg0_13.top:Find("title").anchoredPosition = Vector2(184.2, -208.3)
		arg0_13.top:Find("change_skin").anchoredPosition = Vector2(70.7, -337.8)
		arg0_13.right:Find("giftPackBtn").anchoredPosition = Vector2(-483, -446.4)
		arg0_13.right:Find("price").anchoredPosition = Vector2(-238.3, -140.7)
		arg0_13.bottom:Find("scroll").offsetMin = Vector2(17.7, 0)
		arg0_13.bottom:Find("scroll").offsetMax = Vector2(-718.7, 227.9)
	end

	arg0_13:SetGiftPackLayer()
	onDelayTick(function()
		local var0_14 = {}

		table.insert(var0_14, function(arg0_15)
			arg0_13:CheckDownloadSkinList(arg0_15)
		end)
		seriesAsync(var0_14, function()
			arg0_13:SetSkinScroll()
			arg0_13:Refresh(true)
		end)
	end, 0.001)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.homeBtn, function()
		arg0_13:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.filterBtn, function()
		arg0_13:OpenFilterPanel()
	end, SFX_PANEL)

	if arg0_13.mode == var0_0.MODE_EXPERIENCE or arg0_13.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	local var0_13 = getProxy(PlayerProxy):getRawData().id

	onToggle(arg0_13, arg0_13.sdTg, function(arg0_20)
		setActive(arg0_13.charContainer, arg0_20)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_13, arg0_20 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_13 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_13, 0)

	triggerToggle(arg0_13.sdTg, var1_13 == 1)
	onToggle(arg0_13, arg0_13.hideUITg, function(arg0_21)
		setActive(arg0_13.top, not arg0_21)
		setActive(arg0_13.bottom, not arg0_21)
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg0_21)
	end, SFX_PANEL)
	onInputChanged(arg0_13, arg0_13.search, function()
		arg0_13:Refresh(true)

		local var0_22 = getInputText(arg0_13.search)

		setActive(arg0_13.search:Find("holder"), var0_22 == "")
	end)
	onButton(arg0_13, arg0_13.showOwnBtn, function()
		arg0_13:emit(LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER)
	end, SFX_PANEL)
	getProxy(CommanderManualProxy):TaskProgressAdd(2021, 1)
end

function var0_0.SetResource(arg0_24)
	local var0_24 = getProxy(PlayerProxy):getRawData()

	setText(arg0_24.resources:Find("gem/Text"), var0_24:getTotalGem())
	onButton(arg0_24, arg0_24.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_26)
	arg0_26.type = arg0_26.contextData.type or ShopConst.PERMANANT_SKIN_SHOP_ID
	arg0_26.mode = arg0_26.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_26:GetAllCommodities()
	arg0_26:GetGiftPackCommodities()

	arg0_26.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()

	arg0_26:GetSkinClassify()

	local var0_26 = (arg0_26.mode == var0_0.MODE_EXPERIENCE or arg0_26.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM) and 1 or 0

	arg0_26.filterValues = {
		ownType = 0,
		shipHaveType = 0,
		typeType = {
			0
		},
		campType = {
			0
		},
		rarityType = {
			0
		},
		shipType = {
			0
		},
		themeType = {
			var0_26
		},
		tagType = {
			0
		}
	}
	arg0_26.filterValuesTemp = Clone(arg0_26.filterValues)
end

function var0_0.GetAllCommodities(arg0_27)
	if arg0_27.type == ShopConst.NEW_SKIN_SHOP_ID then
		arg0_27.commodities = getProxy(ShipSkinProxy):GetInTimeSkins()
	elseif arg0_27.type == ShopConst.PERMANANT_SKIN_SHOP_ID then
		arg0_27.commodities = getProxy(ShipSkinProxy):GetPermanentSkins()
	else
		arg0_27.commodities = {}

		local var0_27 = getProxy(ShipSkinProxy):GetAllSkins()

		for iter0_27, iter1_27 in ipairs(var0_27) do
			if table.keyof(pg.shop_skin_subsheet[arg0_27.type].param, iter1_27.id) then
				table.insert(arg0_27.commodities, iter1_27)
			end
		end
	end

	if LOCK_SKIN_US then
		local var1_27 = pg.gameset.levellimit_skintype.key_value
		local var2_27 = pg.gameset.levellimit_skintype.description

		if var1_27 >= getProxy(PlayerProxy):getData().level then
			arg0_27.commodities = _.filter(arg0_27.commodities, function(arg0_28)
				local var0_28 = pg.ship_skin_template[arg0_28:getSkinId()].shop_type_id

				return table.contains(var2_27, var0_28)
			end)
		end
	end

	if arg0_27.mode == var0_0.MODE_OVERVIEW then
		for iter2_27 = #arg0_27.commodities, 1, -1 do
			if arg0_27.commodities[iter2_27]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				table.remove(arg0_27.commodities, iter2_27)
			end
		end
	end
end

function var0_0.GetGiftPackCommodities(arg0_29)
	arg0_29.giftPackCommodities = {}
	arg0_29.giftSkinCommodities = {}
	arg0_29.giftSkinProbabilitys = {}

	for iter0_29, iter1_29 in ipairs(pg.pay_data_display.all) do
		local var0_29 = pg.pay_data_display[iter1_29]

		if var0_29.skin_inquire_relation ~= 0 and pg.TimeMgr.GetInstance():inTime(var0_29.time) then
			local var1_29 = getProxy(ShopsProxy):GetGiftCommodity(iter1_29, Goods.TYPE_CHARGE)

			arg0_29.giftPackCommodities[iter1_29] = var1_29

			local var2_29 = var1_29:GetSkinProbability()

			arg0_29.giftSkinCommodities[iter1_29] = getProxy(ShipSkinProxy):GetProbabilitySkins(var2_29)
			arg0_29.giftSkinProbabilitys[iter1_29] = getProxy(ShipSkinProxy):GetSkinProbabilitys(var2_29)
		end
	end
end

function var0_0.SetSkinScroll(arg0_30)
	arg0_30.scrollrect.isNewLoadingMethod = true

	function arg0_30.scrollrect.onInitItem(arg0_31)
		arg0_30:OnInitItem(arg0_31)
	end

	function arg0_30.scrollrect.onUpdateItem(arg0_32, arg1_32)
		arg0_30:OnUpdateItem(arg0_32, arg1_32)
	end

	arg0_30.scrollrect.enabled = true
end

function var0_0.Refresh(arg0_33, arg1_33)
	arg0_33:ClearCards()

	arg0_33.cards = {}
	arg0_33.displays = {}

	local var0_33 = getInputText(arg0_33.search)

	for iter0_33, iter1_33 in ipairs(arg0_33.commodities) do
		if arg0_33:filterOk(iter1_33) and arg0_33:IsSearchType(var0_33, iter1_33) then
			table.insert(arg0_33.displays, iter1_33)
		end
	end

	local var1_33 = {}

	for iter2_33, iter3_33 in ipairs(arg0_33.displays) do
		local var2_33 = iter3_33.type == Goods.TYPE_ACTIVITY or iter3_33.type == Goods.TYPE_ACTIVITY_EXTRA
		local var3_33 = 0

		if not var2_33 then
			var3_33 = iter3_33:GetPrice()
		end

		var1_33[iter3_33.id] = var3_33
	end

	table.sort(arg0_33.displays, function(arg0_34, arg1_34)
		return arg0_33:Sort(arg0_34, arg1_34, var1_33)
	end)

	local var4_33 = #arg0_33.displays == 0

	setActive(arg0_33.bgs:Find("default"), var4_33)
	setActive(arg0_33.bgs:Find("diffBg"), not var4_33)
	setActive(arg0_33.bgs:Find("empty"), var4_33)
	setActive(arg0_33._tf:Find("leftMask"), not var4_33)
	setActive(arg0_33._tf:Find("bottomMask"), not var4_33)
	setActive(arg0_33.painting, not var4_33)
	setActive(arg0_33.top:Find("title"), not var4_33)
	setActive(arg0_33.changeSkin, not var4_33)
	setActive(arg0_33.right, not var4_33)
	setActive(arg0_33.right, not var4_33)
	setActive(arg0_33.bottom:Find("scroll"), not var4_33)

	if not var4_33 then
		if arg1_33 then
			arg0_33.triggerFirstCard = true

			arg0_33.scrollrect:SetTotalCount(#arg0_33.displays, 0)
		else
			arg0_33.scrollrect:SetTotalCount(#arg0_33.displays)
		end
	end
end

function var0_0.IsSearchType(arg0_35, arg1_35, arg2_35)
	if not arg1_35 or arg1_35 == "" then
		return true
	end

	local var0_35 = arg2_35:getSkinId()

	return ShipSkin.New({
		id = var0_35
	}):IsMatchKey(arg1_35)
end

local function var20_0(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg2_36[arg0_36.id]
	local var1_36 = arg2_36[arg1_36.id]

	if var0_36 == var1_36 then
		return arg0_36.id < arg1_36.id
	else
		return var1_36 < var0_36
	end
end

function var0_0.Sort(arg0_37, arg1_37, arg2_37, arg3_37)
	local var0_37 = arg1_37.buyCount == 0 and 1 or 0
	local var1_37 = arg2_37.buyCount == 0 and 1 or 0

	if var0_37 == var1_37 then
		local var2_37 = arg1_37:getConfig("order")
		local var3_37 = arg2_37:getConfig("order")

		if var2_37 == var3_37 then
			return var20_0(arg1_37, arg2_37, arg3_37)
		else
			return var2_37 < var3_37
		end
	else
		return var1_37 < var0_37
	end
end

function var0_0.filterOk(arg0_38, arg1_38)
	local var0_38 = arg0_38.filterValues.ownType
	local var1_38 = arg0_38.filterValues.typeType
	local var2_38 = arg0_38.filterValues.shipHaveType
	local var3_38 = arg0_38.filterValues.campType
	local var4_38 = arg0_38.filterValues.rarityType
	local var5_38 = arg0_38.filterValues.shipType
	local var6_38 = arg0_38.filterValues.themeType
	local var7_38 = arg0_38.filterValues.tagType
	local var8_38 = arg1_38:getSkinId()
	local var9_38 = ShipSkin.New({
		id = var8_38
	})
	local var10_38 = var9_38:GetDefaultShipConfig()
	local var11_38 = arg0_38:ToVShip(var10_38)

	if var0_38 ~= 0 then
		local var12_38 = false
		local var13_38 = getProxy(ShipSkinProxy):hasSkin(var8_38)
		local var14_38 = var9_38:NoUse()

		if var0_38 == 1 and var13_38 then
			var12_38 = true
		end

		if var0_38 == 2 and not var13_38 then
			var12_38 = true
		end

		if var0_38 == 3 and var13_38 and var14_38 then
			var12_38 = true
		end

		if not var12_38 then
			return false
		end
	end

	if var1_38[1] ~= 0 then
		local var15_38 = false

		for iter0_38, iter1_38 in ipairs(var1_38) do
			if iter1_38 == 1 and (var9_38:IsLive2d() or var9_38:IsLive2dPlus()) then
				var15_38 = true
			end

			if iter1_38 == 2 and not var9_38:IsLive2d() and not var9_38:IsLive2dPlus() and not var9_38:IsSpine() and not var9_38:IsSpinePlus() then
				var15_38 = true
			end

			if iter1_38 == 3 and (var9_38:IsSpine() or var9_38:IsSpinePlus()) then
				var15_38 = true
			end

			if iter1_38 == 4 and var9_38:IsBG() then
				var15_38 = true
			end

			if iter1_38 == 5 and var9_38:IsDbg() then
				var15_38 = true
			end

			if iter1_38 == 6 and var9_38:isBgm() then
				var15_38 = true
			end

			if var15_38 then
				break
			end
		end

		if not var15_38 then
			return false
		end
	end

	if var2_38 ~= 0 then
		local var16_38 = false
		local var17_38 = var9_38:CantUse()

		if var2_38 == 1 and not var17_38 then
			var16_38 = true
		end

		if var2_38 == 2 and var17_38 then
			var16_38 = true
		end

		if not var16_38 then
			return false
		end
	end

	if var3_38[1] ~= 0 then
		if not var10_38 then
			return false
		end

		local var18_38 = false

		for iter2_38, iter3_38 in ipairs(var3_38) do
			local var19_38 = ShipIndexCfg.camp

			for iter4_38, iter5_38 in ipairs(var19_38[iter3_38 + 1].types) do
				if iter5_38 == Nation.LINK then
					if var11_38:getNation() >= Nation.LINK then
						var18_38 = true
					end
				elseif iter5_38 == var11_38:getNation() then
					var18_38 = true
				end
			end

			if var18_38 then
				break
			end
		end

		if not var18_38 then
			return false
		end
	end

	if var4_38[1] ~= 0 then
		if not var10_38 then
			return false
		end

		local var20_38 = false

		for iter6_38, iter7_38 in ipairs(var4_38) do
			local var21_38 = ShipIndexCfg.rarity

			if table.contains(var21_38[iter7_38 + 1].types, var11_38:getRarity()) then
				var20_38 = true
			end

			if var20_38 then
				break
			end
		end

		if not var20_38 then
			return false
		end
	end

	if var5_38[1] ~= 0 then
		if not var10_38 then
			return false
		end

		local var22_38 = false

		for iter8_38, iter9_38 in ipairs(var5_38) do
			local var23_38 = ShipIndexCfg.type
			local var24_38 = var23_38[iter9_38 + 1].types

			if iter9_38 + 1 < 4 then
				local var25_38 = var23_38[iter9_38].shipTypes

				if table.contains(var24_38, var11_38:getShipType()) then
					var22_38 = true
				end

				if table.contains(var24_38, var11_38:getTeamType()) then
					var22_38 = true
				end
			elseif table.contains(var24_38, var11_38:getShipType()) then
				var22_38 = true
			end

			if var22_38 then
				break
			end
		end

		if not var22_38 then
			return false
		end
	end

	if var6_38[1] ~= 0 then
		local var26_38 = false

		for iter10_38, iter11_38 in ipairs(var6_38) do
			local var27_38 = arg0_38.classifyIds[iter11_38 + 1]

			if arg1_38:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				if arg0_38.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
					var26_38 = var27_38 == var15_0 and arg0_38:ExitSkinExperienceItem(arg1_38.id)
				else
					var26_38 = var27_38 == var13_0
				end
			elseif var27_38 == var12_0 then
				var26_38 = true
			elseif var27_38 == var14_0 and table.contains(arg0_38.returnSkins, arg1_38.id) then
				var26_38 = true
			else
				local var28_38 = arg0_38:GetShopTypeIdBySkinId(var8_38)

				var26_38 = (var28_38 == 0 and var16_0 or var28_38) == var27_38
			end

			if var26_38 then
				break
			end
		end

		if not var26_38 then
			return false
		end
	end

	if var7_38[1] ~= 0 then
		local var29_38 = false
		local var30_38 = table.contains(arg0_38.returnSkins, arg1_38.id)
		local var31_38 = NewShopSkinCard.GetTagId(arg1_38, var30_38)

		if table.keyof(var7_38, var31_38) then
			return true
		else
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_39, arg1_39)
	if not arg0_39.vship then
		arg0_39.vship = {}

		function arg0_39.vship.getNation()
			return arg0_39.vship.config.nationality
		end

		function arg0_39.vship.getShipType()
			return arg0_39.vship.config.type
		end

		function arg0_39.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_39.vship.config.type)
		end

		function arg0_39.vship.getRarity()
			return arg0_39.vship.config.rarity
		end
	end

	arg0_39.vship.config = arg1_39

	return arg0_39.vship
end

function var0_0.ExitSkinExperienceItem(arg0_44, arg1_44)
	if not arg0_44.cacheSkinExperienceItems then
		arg0_44.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(arg0_44.cacheSkinExperienceItems, function(arg0_45)
		return arg0_45:CanUseForShop(arg1_44)
	end)
end

function var0_0.RegisterEvent(arg0_46)
	arg0_46:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_47, arg1_47)
		arg0_46:AdjustPainting(arg1_47)
		setActive(arg0_46.top, not arg1_47)
		setActive(arg0_46.bottom, not arg1_47)
		setActive(arg0_46.right, not arg1_47)

		if arg0_46.live2dChar then
			arg0_46.live2dChar:setPurchaseOffset(arg1_47)
		end

		if arg0_46.spineChar then
			if arg1_47 then
				local var0_47 = pg.ship_skin_template[arg0_46.skinId].purchase_offset

				if var0_47 and #var0_47 >= 3 then
					arg0_46.spineChar:SetLocalPosition(Vector3(var0_47[1], var0_47[2], var0_47[3]))
				end

				if var0_47 and #var0_47 >= 4 then
					arg0_46.spineChar:SetLocalScale(Vector3(var0_47[4], var0_47[4], var0_47[4]))
				end
			else
				arg0_46.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
				arg0_46.spineChar:SetLocalPosition(Vector3(0, 0, 0))
			end
		end

		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg1_47)
	end)
	arg0_46:bind(var0_0.EVT_ON_PURCHASE, function(arg0_48, arg1_48)
		local var0_48 = arg0_46:GetObtainBtnState(arg1_48)

		arg0_46:OnClickBtn(var0_48, arg1_48)
	end)
	onButton(arg0_46, arg0_46.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_46.skinId) then
			arg0_46.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_46.skinId)

			arg0_46:UpdateMainView(arg0_46.showingCommodity)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_50, arg1_50)
	local var0_50 = NewShopSkinCard.New(arg1_50)

	onButton(arg0_50, var0_50._go, function()
		if not var0_50.commodity then
			return
		end

		for iter0_51, iter1_51 in pairs(arg0_50.cards) do
			iter1_51:UpdateSelected(false)
		end

		arg0_50.selectedId = var0_50.commodity.id

		var0_50:UpdateSelected(true)
		arg0_50:UpdateMainView(var0_50.commodity)
		arg0_50:GCHandle()
	end, SFX_PANEL)

	arg0_50.cards[arg1_50] = var0_50
end

function var0_0.OnUpdateItem(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52.cards[arg2_52]

	if not var0_52 then
		arg0_52:OnInitItem(arg2_52)

		var0_52 = arg0_52.cards[arg2_52]
	end

	local var1_52 = arg0_52.displays[arg1_52 + 1]

	if not var1_52 then
		return
	end

	local var2_52 = arg0_52.selectedId == var1_52.id
	local var3_52 = table.contains(arg0_52.returnSkins, var1_52.id)

	var0_52:Update(var1_52, var2_52, var3_52)

	if arg0_52.pendingSelectId and arg0_52.pendingSelectId == var1_52.id then
		arg0_52.pendingSelectId = nil

		triggerButton(var0_52._go)
	end

	if arg0_52.triggerFirstCard and arg1_52 == 0 then
		arg0_52.triggerFirstCard = false

		triggerButton(var0_52._go)
	end
end

function var0_0.UpdateMainView(arg0_53, arg1_53)
	arg0_53.skinId = arg1_53:getSkinId()

	local var0_53 = ShipSkin.IsChangeSkin(arg0_53.skinId)

	setActive(arg0_53.changeSkin, var0_53)

	if var0_53 then
		arg0_53:FlushChangeSkin(arg1_53)
	end

	arg0_53.shipSkin = ShipSkin.New({
		id = arg0_53.skinId
	})

	arg0_53:FlushName()
	arg0_53:FlushPreviewBtn(arg1_53)
	arg0_53:FlushTimeLimit(arg1_53)
	arg0_53:SwitchPreview(arg1_53, arg0_53.isPreviewFurniture)
	arg0_53:FlushPaintingToggle(arg1_53)
	arg0_53:FlushTag()
	arg0_53:FlushBG(arg1_53)
	arg0_53:FlushPainting(arg1_53)
	arg0_53:FlushPrice(arg1_53)
	arg0_53:FlushObtainBtn(arg1_53)
	arg0_53:FlushGifgPackBtn(arg1_53)

	arg0_53.showingCommodity = arg1_53
end

function var0_0.FlushChangeSkin(arg0_54, arg1_54)
	local var0_54 = ShipSkin.GetChangeSkinGroupId(arg0_54.skinId)
	local var1_54 = ShipSkin.GetChangeSkinCustomDataId(arg0_54.skinId, "hide_shop")
	local var2_54 = pg.gameset.changeskin_switch_block
	local var3_54 = false
	local var4_54 = false
	local var5_54 = arg0_54.changeSkinToggle:IsAsmrSkin() and true or false

	if var2_54 and var2_54.description then
		local var6_54 = var2_54.description

		if table.contains(var6_54, var0_54) and HXSet.isHx() then
			var4_54 = true
		end
	end

	if var1_54 and var1_54 == 1 then
		var3_54 = true
	end

	if not arg0_54.changeSkinId then
		arg0_54.changeSkinId = arg0_54.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_54.changeSkinId) == var0_54 then
		arg0_54.skinId = arg0_54.changeSkinId
	else
		arg0_54.changeSkinId = arg0_54.skinId
	end

	arg0_54.changeSkinToggle:setSkinData(arg0_54.skinId)

	if var3_54 or var4_54 or var5_54 then
		setActive(arg0_54.changeSkin, false)
	else
		setActive(arg0_54.changeSkin, true)
	end
end

function var0_0.GCHandle(arg0_55)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.FlushName(arg0_56)
	local var0_56 = pg.ship_skin_template[arg0_56.skinId]

	setScrollText(arg0_56.skinName, SwitchSpecialChar(var0_56.name, true))

	if var0_56.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_56.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_56.skinId)))
	else
		local var1_56 = ShipGroup.getDefaultShipConfig(var0_56.ship_group)

		setScrollText(arg0_56.shipName, var1_56.name)
	end
end

function var0_0.FlushPreviewBtn(arg0_57, arg1_57)
	local var0_57 = Goods.ExistFurniture(arg1_57.id)

	removeOnButton(arg0_57.switchPreviewBtn)

	if not var0_57 and arg0_57.isPreviewFurniture then
		arg0_57.isPreviewFurniture = false
	end

	setActive(arg0_57.switchPreviewBtn, var0_57)

	if var0_57 then
		onButton(arg0_57, arg0_57.switchPreviewBtn, function()
			arg0_57.isPreviewFurniture = not arg0_57.isPreviewFurniture

			arg0_57:SwitchPreview(arg1_57, arg0_57.isPreviewFurniture)
			arg0_57:FlushPrice(arg1_57)
			arg0_57:FlushObtainBtn(arg1_57)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPreview(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg0_59.skinId

	if pg.ship_skin_template[var0_59].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_59.charContainer, false)

		return
	end

	local var1_59 = getProxy(PlayerProxy):getRawData().id

	setActive(arg0_59.charContainer, PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var1_59, 0) == 1)
	setActive(arg0_59.charTf, not arg2_59)
	setActive(arg0_59.furnitureContainer, arg2_59)

	if not arg2_59 then
		local var2_59 = pg.ship_skin_template[var0_59]

		arg0_59:FlushChar(var2_59.prefab, var2_59.id)
		GetImageSpriteFromAtlasAsync("qicon/" .. var2_59.painting, "", arg0_59.backChara)
	else
		local var3_59 = Goods.Id2FurnitureId(arg1_59.id)
		local var4_59 = Goods.GetFurnitureConfig(arg1_59.id)

		arg0_59.interactionPreview:Flush(var0_59, var3_59, var4_59.scale[2] or 1, var4_59.position[2])
	end
end

function var0_0.FlushChar(arg0_60, arg1_60, arg2_60)
	if arg0_60.prefabName and arg0_60.prefabName == arg1_60 then
		return
	end

	arg0_60:ReturnChar()

	arg0_60.prefabName = arg1_60

	local var0_60 = SpineAnimChar.New()

	var0_60:SetPaint(arg1_60)
	var0_60:Load(true, function(arg0_61)
		if arg0_60.prefabName ~= arg1_60 then
			arg0_61:Dispose()

			return
		end

		arg0_60.spineChar = arg0_61

		local var0_61 = pg.skinshop_spine_scale[arg2_60]

		if var0_61 then
			arg0_60.spineChar:SetLocalScale(Vector3(var0_61.skinshop_scale, var0_61.skinshop_scale, 1))
		else
			arg0_60.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
		end

		arg0_60.spineChar:SetLocalPosition(Vector3(0, 0, 0))
		arg0_60.spineChar:SetLayer(Layer.UI)
		arg0_60.spineChar:SetParent(arg0_60.charTf)
		arg0_60.spineChar:SetAction("normal", 0)
	end)
end

function var0_0.ReturnChar(arg0_62)
	if arg0_62.spineChar then
		arg0_62.spineChar:Dispose()

		arg0_62.spineChar = nil
		arg0_62.prefabName = nil
	end
end

function var0_0.ClearCards(arg0_63)
	if not arg0_63.cards then
		return
	end

	for iter0_63, iter1_63 in pairs(arg0_63.cards) do
		iter1_63:Dispose()
	end

	arg0_63.cards = nil
end

function var0_0.FlushTimeLimit(arg0_64, arg1_64)
	local var0_64 = arg0_64.skinId
	local var1_64 = false
	local var2_64

	if arg1_64:IsActivityExtra() and arg1_64:ShowMaintenanceTime() then
		local var3_64, var4_64 = arg1_64:GetMaintenanceMonthAndDay()

		function var2_64()
			return i18n("limit_skin_time_before_maintenance", var3_64, var4_64)
		end

		var1_64 = true
	elseif arg1_64:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_64 = getProxy(ShipSkinProxy):getSkinById(var0_64)

		var1_64 = var5_64 and var5_64:isExpireType() and not var5_64:isExpired()

		if var1_64 then
			function var2_64()
				return skinTimeStamp(var5_64:getRemainTime())
			end
		end
	else
		local var6_64, var7_64 = pg.TimeMgr.GetInstance():inTime(arg1_64:getConfig("time"))

		var1_64 = var7_64

		if var1_64 then
			local var8_64 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_64)

			function var2_64()
				return skinCommdityTimeStamp(var8_64)
			end
		end
	end

	setActive(arg0_64.top:Find("title/limit_time"), var1_64)
	arg0_64:ClearTimer()

	if var1_64 then
		arg0_64:AddTimer(var2_64)
	end
end

function var0_0.AddTimer(arg0_68, arg1_68)
	arg0_68.timer = Timer.New(function()
		setText(arg0_68.limitTime, arg1_68())
	end, 1, -1)

	arg0_68.timer.func()
	arg0_68.timer:Start()
end

function var0_0.ClearTimer(arg0_70)
	if arg0_70.timer then
		arg0_70.timer:Stop()

		arg0_70.timer = nil
	end
end

function var0_0.FlushPaintingToggle(arg0_71, arg1_71)
	removeOnToggle(arg0_71.dynamicToggle)
	removeOnToggle(arg0_71.showBgToggle)

	local var0_71 = checkABExist("painting/" .. arg0_71.shipSkin:getConfig("painting") .. "_n")

	if arg0_71.isToggleShowBg and not var0_71 then
		triggerToggle(arg0_71.showBgToggle, false)

		arg0_71.isToggleShowBg = false
	elseif var0_71 then
		triggerToggle(arg0_71.showBgToggle, true)

		arg0_71.isToggleShowBg = true
	end

	local var1_71 = arg0_71.shipSkin:IsSpine() or arg0_71.shipSkin:IsLive2d() or arg0_71.shipSkin:IsSpinePlus() or arg0_71.shipSkin:IsLive2dPlus()
	local var2_71 = arg0_71.shipSkin:IsHxDynamicPreview()

	if var1_71 and not var2_71 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_71.isToggleDynamic = true
	end

	if var1_71 then
		local var3_71 = 0

		if arg0_71.shipSkin:IsSpine() then
			var3_71 = 6
		elseif arg0_71.shipSkin:IsLive2d() then
			var3_71 = 1
		elseif arg0_71.shipSkin:IsSpinePlus() then
			var3_71 = 7
		elseif arg0_71.shipSkin:IsLive2dPlus() then
			var3_71 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_71) .. "_off", arg0_71.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_71), arg0_71.dynamicToggle:Find("select"))
	end

	if var2_71 and arg0_71.isToggleDynamic then
		triggerToggle(arg0_71.dynamicToggle, false)

		arg0_71.isToggleDynamic = false
	end

	if arg0_71.isToggleDynamic and not var1_71 then
		triggerToggle(arg0_71.dynamicToggle, false)

		arg0_71.isToggleDynamic = false
	elseif arg0_71.isToggleDynamic and not arg0_71.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_71.shipSkin:IsLive2d() or arg0_71.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_71.isToggleDynamic = false

			local var4_71 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4_71, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_71.dynamicToggle, false)
		else
			triggerToggle(arg0_71.dynamicToggle, true)

			arg0_71.isToggleDynamic = true
		end
	end

	if var0_71 then
		onToggle(arg0_71, arg0_71.showBgToggle, function(arg0_72)
			arg0_71.isToggleShowBg = arg0_72

			arg0_71:FlushPainting(arg1_71)
			arg0_71:FlushBG(arg1_71)
		end, SFX_PANEL)
	end

	if arg0_71.shipSkin:IsSpine() or arg0_71.shipSkin:IsLive2d() or arg0_71.shipSkin:IsSpinePlus() or arg0_71.shipSkin:IsLive2dPlus() then
		onToggle(arg0_71, arg0_71.dynamicToggle, function(arg0_73)
			local var0_73 = arg0_71.shipSkin:IsHxDynamicPreview()

			if arg0_73 and var0_73 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("shop_tag_control_tip"))
				triggerToggle(arg0_71.dynamicToggle, false)
				setActive(arg0_71.dynamicResToggle, false)

				return
			end

			if arg0_73 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_71.shipSkin:IsLive2d() or arg0_71.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_71.dynamicToggle, false)

				return
			end

			arg0_71.isToggleDynamic = arg0_73

			setActive(arg0_71.showBgToggle, not arg0_73 and var0_71)
			arg0_71:FlushPainting(arg1_71)
			arg0_71:FlushDynamicPaintingResState(arg1_71)
			arg0_71:RecordFlag(arg0_73)
		end, SFX_PANEL)
	end

	setActive(arg0_71.dynamicIcon, true)

	if arg0_71.isToggleDynamic then
		arg0_71:FlushDynamicPaintingResState(arg1_71)
	elseif var2_71 then
		setActive(arg0_71.dynamicResToggle, false)
		setActive(arg0_71.dynamicIcon, false)
	end

	setActive(arg0_71.dynamicToggle, var1_71)
	setActive(arg0_71.showBgToggle, not arg0_71.isToggleDynamic and var0_71)
end

function var0_0.FlushTag(arg0_74)
	local var0_74 = arg0_74.skinId
	local var1_74 = pg.ship_skin_template[var0_74]
	local var2_74 = Clone(var1_74.tag)
	local var3_74 = false

	for iter0_74 = #var2_74, 1, -1 do
		local var4_74 = var2_74[iter0_74]

		if var4_74 == 1 or var4_74 == 6 or var4_74 == 7 or var4_74 == 9 then
			local var5_74 = true

			table.remove(var2_74, iter0_74)
		end
	end

	local var6_74 = checkABExist("painting/" .. arg0_74.shipSkin:getConfig("painting") .. "_n")

	arg0_74.tagList:make(function(arg0_75, arg1_75, arg2_75)
		if arg0_75 == UIItemList.EventUpdate then
			local var0_75 = var2_74[arg1_75 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_74[arg1_75 + 1]), function(arg0_76)
				if arg0_74.exited then
					return
				end

				arg2_75:GetComponent(typeof(Image)).sprite = arg0_76
			end)
		end
	end)
	setActive(arg0_74.adapt:Find("right/functionsAndTags/tags"), #var2_74 > 0)
	arg0_74.tagList:align(#var2_74)
end

function var0_0.FlushPainting(arg0_77, arg1_77)
	local var0_77 = arg0_77:GetPaintingState(arg1_77)
	local var1_77 = pg.ship_skin_template[arg0_77.skinId].painting
	local var2_77 = ShipSkin.GetChangeSkinData(arg0_77.skinId) and true or false

	if var0_77 == var2_0 and not arg0_77:ExistL2dRes(var1_77) or var0_77 == var3_0 and not arg0_77:ExistSpineRes(var1_77) then
		var0_77 = var1_0
	end

	if arg0_77.paintingState and arg0_77.paintingState.state == var0_77 and arg0_77.paintingState.id == arg1_77.id and arg0_77.paintingState.showBg == arg0_77.isToggleShowBg and arg0_77.paintingState.purchaseFlag == arg1_77.buyCount and not var2_77 then
		return
	end

	arg0_77:ClearPainting()

	if var0_77 == var1_0 then
		arg0_77:LoadMeshPainting(arg1_77, arg0_77.isToggleShowBg)
	elseif var0_77 == var2_0 then
		arg0_77:LoadL2dPainting(arg1_77)
	elseif var0_77 == var3_0 then
		arg0_77:LoadSpinePainting(arg1_77)
	end

	arg0_77.paintingState = {
		state = var0_77,
		id = arg1_77.id,
		showBg = arg0_77.isToggleShowBg,
		purchaseFlag = arg1_77.buyCount
	}

	arg0_77:AdjustPainting(false)
end

function var0_0.ClearPainting(arg0_78)
	local var0_78 = arg0_78.paintingState

	if not var0_78 then
		return
	end

	if var0_78.state == var1_0 then
		arg0_78:ClearMeshPainting()
	elseif var0_78.state == var2_0 then
		arg0_78:ClearL2dPainting()
	elseif var0_78.state == var3_0 then
		arg0_78:ClearSpinePainting()
	end

	arg0_78.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_79, arg1_79, arg2_79)
	local var0_79 = findTF(arg0_79.paintingTF, "fitter")
	local var1_79 = GetOrAddComponent(var0_79, "PaintingScaler")

	var1_79.FrameName = "chuanwu"
	var1_79.Tween = 1

	local var2_79 = pg.ship_skin_template[arg0_79.skinId].painting
	local var3_79 = var2_79

	if not arg2_79 and checkABExist("painting/" .. var2_79 .. "_n") then
		var2_79 = var2_79 .. "_n"
	end

	if not checkABExist("painting/" .. var2_79) then
		return
	end

	if PLATFORM_CODE == PLATFORM_CH and checkABExist("painting/" .. var2_79 .. "_shop") then
		var2_79 = var2_79 .. "_shop"
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_79, true, function(arg0_80)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_80, var0_79, false)
		ShipExpressionHelper.SetExpression(var0_79:GetChild(0), var3_79)

		arg0_79.paintingName = var2_79

		if arg0_79.paintingState and arg0_79.paintingState.id ~= arg1_79.id then
			arg0_79:ClearMeshPainting()
		end

		local var0_80 = arg0_80.transform:Find("shop_hx")

		arg0_79:CheckShowShopHx(var0_80)

		local var1_80 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_80 = arg0_80.transform:Find("shop_hx_ch" .. var1_80)

		arg0_79:CheckShowShopHx(var2_80)
	end)
end

function var0_0.ClearMeshPainting(arg0_81)
	local var0_81 = arg0_81.paintingTF:Find("fitter")

	if arg0_81.paintingName and var0_81.childCount > 0 then
		local var1_81 = var0_81:GetChild(0).gameObject
		local var2_81 = var1_81.transform:Find("shop_hx")

		arg0_81:RevertShopHx(var2_81)
		PoolMgr.GetInstance():ReturnPainting(arg0_81.paintingName, var1_81)
	end

	arg0_81.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_82, arg1_82)
	local var0_82 = arg0_82.skinId
	local var1_82 = pg.ship_skin_template[var0_82].skin_type
	local var2_82

	if var1_82 == ShipSkin.SKIN_TYPE_TB then
		var2_82 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_82))
	else
		local var3_82 = pg.ship_skin_template[var0_82].ship_group
		local var4_82 = ShipGroup.getDefaultShipConfig(var3_82)

		var2_82 = Ship.New({
			noChangeSkin = true,
			configId = var4_82.id,
			skin_id = var0_82
		})
	end

	local var5_82 = Live2DPainting.GenerateData({
		ship = var2_82,
		position = Vector3(0, 0, -1),
		parent = arg0_82.live2dContainer,
		offset = var2_82:GetSkinConfig().shop_offset
	})

	var5_82.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_82.live2dChar = Live2DPainting.New(var5_82, function(arg0_83)
		arg0_83:IgonreReactPos(true)
		arg0_82:CheckShowShopHxForL2d(arg0_83, arg1_82)

		if arg0_82.paintingState and arg0_82.paintingState.id ~= arg1_82.id then
			arg0_82:ClearL2dPainting()
		end

		arg0_83:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_84)
	if arg0_84.live2dChar then
		arg0_84:RevertShopHxForL2d(arg0_84.live2dChar)
		arg0_84.live2dChar:Dispose()

		arg0_84.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_85, arg1_85)
	local var0_85 = arg0_85.skinId
	local var1_85 = pg.ship_skin_template[var0_85].skin_type
	local var2_85

	if var1_85 == ShipSkin.SKIN_TYPE_TB then
		var2_85 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_85))
	else
		local var3_85 = pg.ship_skin_template[var0_85].ship_group
		local var4_85 = ShipGroup.getDefaultShipConfig(var3_85)

		var2_85 = Ship.New({
			noChangeSkin = true,
			configId = var4_85.id,
			skin_id = var0_85
		})
	end

	local var5_85 = SpinePainting.GenerateData({
		ship = var2_85,
		position = Vector3(0, 0, 0),
		parent = arg0_85.spTF,
		effectParent = arg0_85.spBg,
		offset = var2_85:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_85.spinePainting = SpinePainting.New(var5_85, function(arg0_86)
		arg0_86:SetShopHx(true)

		if arg0_85.paintingState and arg0_85.paintingState.id ~= arg1_85.id then
			arg0_85:ClearSpinePainting()
		end

		local var0_86 = arg0_86._tf:Find("shop_hx")

		arg0_85:CheckShowShopHx(var0_86)

		local var1_86 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_86 = arg0_86._tf:Find("shop_hx_ch" .. var1_86)

		arg0_85:CheckShowShopHx(var2_86)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_87)
	if arg0_87.spinePainting and arg0_87.spinePainting._tf then
		local var0_87 = arg0_87.spinePainting._tf:Find("shop_hx")

		arg0_87:RevertShopHx(arg0_87.shopHx)
		arg0_87.spinePainting:Dispose()

		arg0_87.spinePainting = nil
	end
end

function var0_0.CheckShowShopHx(arg0_88, arg1_88)
	if IsNil(arg1_88) then
		return
	end

	setActive(arg1_88, false)

	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	setActive(arg1_88, true)
end

function var0_0.RevertShopHx(arg0_89, arg1_89)
	if not IsNil(arg1_89) then
		setActive(arg1_89, false)
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_90, arg1_90, arg2_90)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_90 = 1

	arg1_90:changeParamaterValue("shop_hx", var0_90)
end

function var0_0.RevertShopHxForL2d(arg0_91, arg1_91)
	arg1_91:changeParamaterValue("shop_hx", 0)
end

function var0_0.AdjustPainting(arg0_92, arg1_92)
	local var0_92 = arg0_92.paintingTF
	local var1_92 = pg.ship_skin_newmainui_shift[arg0_92.skinId]

	if var1_92 then
		local var2_92 = var1_92.skin_shop_shift

		if arg1_92 then
			var0_92.anchoredPosition = Vector2(var2_92[1] - 440, var2_92[2] + arg0_92.defaultPaintingPosition.y)
		else
			var0_92.anchoredPosition = Vector2(var2_92[1] + arg0_92.defaultPaintingPosition.x, var2_92[2] + arg0_92.defaultPaintingPosition.y)
		end

		local var3_92 = var2_92[4]

		var0_92.localScale = Vector3(var3_92, var3_92, 1)
	else
		var0_92.anchoredPosition = Vector2(arg0_92.defaultPaintingPosition.x, arg0_92.defaultPaintingPosition.y)
		var0_92.localScale = arg0_92.defaultPaintingScale
	end
end

function var0_0.FlushBG(arg0_93, arg1_93, arg2_93)
	local var0_93 = arg0_93.skinId
	local var1_93 = pg.ship_skin_template[var0_93]
	local var2_93

	if var1_93.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_93 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_93))
	else
		local var3_93 = ShipGroup.getDefaultShipConfig(var1_93.ship_group)

		var2_93 = Ship.New({
			id = 999,
			configId = var3_93.id,
			skin_id = var0_93
		})
	end

	local var4_93 = var2_93:getShipBgPrint(true)
	local var5_93 = pg.ship_skin_template[var0_93].painting

	if (arg0_93.isToggleShowBg or not checkABExist("painting/" .. var5_93 .. "_n")) and var1_93.bg_sp ~= "" then
		var4_93 = var1_93.bg_sp
	end

	local var6_93 = var4_93 ~= var2_93:rarity2bgPrintForGet()

	if var6_93 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_93, var4_93, arg0_93.bgs:Find("diffBg"), arg0_93.bgs:Find("diffBg/bg"), function(arg0_94)
			if arg2_93 then
				arg2_93()
			end
		end, function(arg0_95)
			if arg2_93 then
				arg2_93()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_93:getUIName())

		if arg2_93 then
			arg2_93()
		end
	end

	setActive(arg0_93.bgs:Find("diffBg"), var6_93)
	setActive(arg0_93.bgs:Find("default"), not var6_93)
end

function var0_0.FlushDynamicPaintingResState(arg0_96, arg1_96)
	if not arg0_96.isToggleDynamic then
		return
	end

	local var0_96 = arg0_96:GetPaintingState(arg1_96)
	local var1_96 = false
	local var2_96 = ""
	local var3_96 = pg.ship_skin_template[arg0_96.skinId].painting

	if var2_0 == var0_96 then
		var1_96, var2_96 = arg0_96:ExistL2dRes(var3_96)
	elseif var3_0 == var0_96 then
		var1_96, var2_96 = arg0_96:ExistSpineRes(var3_96)
	end

	setActive(arg0_96.dynamicResToggle, not var1_96)
	removeOnButton(arg0_96.dynamicResToggle)

	if not var1_96 and var2_96 ~= "" then
		onButton(arg0_96, arg0_96.dynamicResToggle, function()
			arg0_96:DownloadDynamicPainting(var2_96, arg1_96)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_98, arg1_98, arg2_98)
	local var0_98 = arg0_98.skinId

	if arg0_98.downloads[var0_98] then
		return
	end

	local var1_98 = SkinShopDownloadRequest.New()

	arg0_98.downloads[var0_98] = var1_98

	var1_98:Start(arg1_98, function(arg0_99)
		if arg0_99 and arg0_98.paintingState and arg0_98.paintingState.id == arg2_98.id then
			arg0_98:FlushPainting(arg2_98)
			arg0_98:FlushDynamicPaintingResState(arg2_98)
		end

		var1_98:Dispose()

		arg0_98.downloads[var0_98] = nil
	end)
end

function var0_0.GetPaintingState(arg0_100, arg1_100)
	if arg0_100.isToggleDynamic and (arg0_100.shipSkin:IsLive2d() or arg0_100.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_100.isToggleDynamic and (arg0_100.shipSkin:IsSpine() or arg0_100.shipSkin:IsSpinePlus()) then
		if arg0_100.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_101, arg1_101)
	local var0_101 = "live2d/" .. string.lower(arg1_101)
	local var1_101 = HXSet.autoHxShiftPath(var0_101, nil, true)

	return checkABExist(var1_101), var1_101
end

function var0_0.ExistSpineRes(arg0_102, arg1_102)
	local var0_102 = "SpinePainting/" .. string.lower(arg1_102)
	local var1_102 = HXSet.autoHxShiftPath(var0_102, nil, true)

	return checkABExist(var1_102), var1_102
end

function var0_0.RecordFlag(arg0_103, arg1_103)
	local var0_103 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_103, arg1_103 and 1 or 0)
	PlayerPrefs.Save()
	arg0_103:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_103)
end

function var0_0.FlushPrice(arg0_104, arg1_104)
	local var0_104 = arg1_104:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_104 = arg1_104.type == Goods.TYPE_ACTIVITY or arg1_104.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_104 then
		if arg0_104.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_104:UpdateExperiencePrice4Item(arg1_104)
		else
			arg0_104:UpdateExperiencePrice(arg1_104)
		end
	elseif arg0_104.isPreviewFurniture then
		arg0_104:UpdateFurniturePrice(arg1_104)
	elseif var1_104 then
		-- block empty
	else
		arg0_104:UpdateCommodityPrice(arg1_104)
	end

	local var2_104 = arg1_104.type == Goods.TYPE_SKIN

	setActive(arg0_104.price:Find("timeLimit"), var0_104 and not var1_104)
	setActive(arg0_104.price:Find("normal/consume"), var2_104 and not var0_104 and not var1_104)
end

function var0_0.UpdateExperiencePrice4Item(arg0_105, arg1_105)
	local var0_105 = arg1_105:getConfig("resource_num")
	local var1_105 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_105 = _.detect(var1_105, function(arg0_106)
		return arg0_106:CanUseForShop(arg1_105.id)
	end)
	local var3_105 = var2_105 and var2_105.count or 0
	local var4_105 = (var3_105 < var0_105 and "<color=" .. COLOR_RED .. ">" or "") .. var3_105 .. (var3_105 < var0_105 and "</color>" or "")

	setText(arg0_105.price:Find("timeLimit/consume/Text"), var4_105 .. "/" .. var0_105)
end

function var0_0.UpdateExperiencePrice(arg0_107, arg1_107)
	local var0_107 = arg1_107:getConfig("resource_num")
	local var1_107 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_107 = (var1_107 < var0_107 and "<color=" .. COLOR_RED .. ">" or "") .. var1_107 .. (var1_107 < var0_107 and "</color>" or "")

	setText(arg0_107.price:Find("timeLimit/consume/Text"), var2_107 .. "/" .. var0_107)
end

function var0_0.UpdateCommodityPrice(arg0_108, arg1_108)
	local var0_108 = arg1_108:GetPrice()
	local var1_108 = arg1_108:getConfig("resource_num")

	setText(arg0_108.price:Find("normal/consume/Text"), var0_108)
	setText(arg0_108.price:Find("normal/consume/originalprice/Text"), var1_108)
	setActive(arg0_108.price:Find("normal/consume/originalprice"), var0_108 ~= var1_108)
end

function var0_0.UpdateFurniturePrice(arg0_109, arg1_109)
	local var0_109 = Goods.Id2FurnitureId(arg1_109.id)
	local var1_109 = Furniture.New({
		id = var0_109
	})
	local var2_109 = var1_109:getConfig("gem_price")

	setText(arg0_109.price:Find("normal/consume/originalprice/Text"), var2_109)

	local var3_109 = var1_109:getPrice(PlayerConst.ResDiamond)

	setText(arg0_109.price:Find("normal/consume/Text"), var3_109)
	setActive(arg0_109.price:Find("normal/consume/originalprice"), var2_109 ~= var3_109)
end

local function var21_0(arg0_110, arg1_110)
	if arg0_110 == var6_0 or arg0_110 == var9_0 or arg0_110 == var8_0 then
		return false
	end

	local var0_110 = arg1_110:getSkinId()

	return getProxy(ShopsProxy):CanPurchasedByCharge(var0_110)
end

function var0_0.UpdateChargeView(arg0_111, arg1_111, arg2_111, arg3_111)
	local var0_111 = arg1_111 == var4_0
	local var1_111 = arg0_111.btnsList[2]

	setActive(var1_111:Find("buy_charge"), not var0_111)

	local var2_111 = pg.pay_data_display[arg3_111]

	assert(var2_111, "pay_data_display>>>>>>>>>>>>>" .. arg3_111)

	local var3_111 = GetMoneySymbol() .. GetChargePrice(var2_111.money)

	setText(arg0_111.btnsList[2]:Find("buy_charge/value"), var3_111)

	local var4_111 = var1_111.parent:Find("consume")
	local var5_111 = var1_111.parent:Find("rmb")

	setText(var5_111:Find("Text"), var3_111)
	setActive(var5_111:Find("originalprice"), var2_111.cash_show > var2_111.money)
	setText(var5_111:Find("originalprice/Text"), GetChargePrice(var2_111.cash_show))

	local var6_111 = arg2_111:GetPrice()
	local var7_111 = arg2_111:getConfig("resource_num")

	setActive(var4_111:Find("originalprice"), var6_111 ~= var7_111)
	setText(var4_111:Find("Text"), var6_111)
	setText(var4_111:Find("originalprice/Text"), var7_111)
end

function var0_0.FlushObtainBtn(arg0_112, arg1_112)
	local var0_112 = arg0_112:GetObtainBtnState(arg1_112)
	local var1_112 = var19_0(var0_112)
	local var2_112, var3_112 = var21_0(var0_112, arg1_112)

	setActive(arg0_112.btnsList[1].parent, not var2_112)
	setActive(arg0_112.btnsList[2].parent, var2_112)

	local var4_112 = var2_112 and arg0_112.btnsList[2] or arg0_112.btnsList[1]

	for iter0_112 = 0, var4_112.childCount - 1 do
		local var5_112 = var4_112:GetChild(iter0_112)

		setActive(var5_112, var5_112.name == var1_112)
	end

	if var2_112 then
		arg0_112:UpdateChargeView(var0_112, arg1_112, var3_112)
	end

	setActive(arg0_112.price:Find("btn_charge"), var2_112 and var0_112 ~= var4_0)
	setActive(arg0_112.price:Find("btn/item"), var0_112 == var11_0)
	setActive(arg0_112.price:Find("btn/tag"), var0_112 == var11_0)

	if var0_112 == var11_0 then
		arg0_112:FlushGift(arg1_112)
	end

	onButton(arg0_112, arg0_112.price:Find("btn_charge"), function()
		if not var2_112 then
			return
		end

		arg0_112:OpenChargePanel(var3_112)
	end, SFX_PANEL)
	onButton(arg0_112, arg0_112.price:Find("btn"), function()
		local var0_114 = {}
		local var1_114 = SkinCouponActivity.StaticEncoreActTip(arg1_112.id)

		if tobool(var1_114) then
			table.insert(var0_114, function(arg0_115)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Hint"),
					onYes = function()
						if var1_114 and not var1_114:isEnd() then
							arg0_112:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_114.id)
						end
					end,
					onNo = arg0_115
				})
			end)
		end

		if arg1_112:getConfig("genre") == ShopArgs.SkinShop and not arg1_112:IsItemDiscountType() and #SkinCouponActivity.GetOvercountEncoreActs(arg1_112.id) > 0 then
			table.insert(var0_114, function(arg0_117)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Last_Coupon"),
					onYes = arg0_117
				})
			end)
		end

		seriesAsync(var0_114, function()
			if var0_112 == var5_0 or var0_112 == var7_0 or var0_112 == var11_0 then
				arg0_112.purchaseView:ExecuteAction("Show", arg1_112)
			else
				arg0_112:OnClickBtn(var0_112, arg1_112)
			end
		end)
	end, SFX_PANEL)
end

function var0_0.OpenChargePanel(arg0_119, arg1_119)
	local var0_119 = Goods.Create({
		shop_id = arg1_119
	}, Goods.TYPE_CHARGE)

	if ChargeConst.isNeedSetBirth() then
		arg0_119:emit(LatestSkinShopMediator.OPEN_CHARGE_BIRTHDAY)
	else
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = var0_119.id
		})
	end
end

function var0_0.GetObtainBtnState(arg0_120, arg1_120)
	if arg1_120:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_120.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_120.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_120.type == Goods.TYPE_ACTIVITY or arg1_120.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_120.buyCount > 0 then
		return var4_0
	elseif arg1_120:isDisCount() and arg1_120:IsItemDiscountType() then
		return var7_0
	elseif arg1_120:CanUseVoucherType() or arg1_120:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_120:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushGift(arg0_121, arg1_121)
	local var0_121 = arg1_121:GetGiftList()[1]

	updateDrop(arg0_121.price:Find("btn/item/mask/item"), {
		type = var0_121.type,
		id = var0_121.id,
		count = var0_121.count
	})
end

function var0_0.OnClickBtn(arg0_122, arg1_122, arg2_122)
	if arg1_122 == var5_0 or arg1_122 == var7_0 or arg1_122 == var11_0 then
		arg0_122:OnPurchase(arg2_122)
	elseif arg1_122 == var10_0 then
		arg0_122:OnItemPurchase(arg2_122)
	elseif arg1_122 == var6_0 then
		arg0_122:OnActivity(arg2_122)
	elseif arg1_122 == var8_0 then
		arg0_122:OnBackyard(arg2_122)
	elseif arg1_122 == var9_0 then
		if arg0_122.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_122:OnExperience4Item(arg2_122)
		else
			arg0_122:OnExperience(arg2_122)
		end
	end
end

function var0_0.FlushGifgPackBtn(arg0_123, arg1_123)
	local var0_123 = false
	local var1_123
	local var2_123
	local var3_123

	for iter0_123, iter1_123 in pairs(arg0_123.giftSkinCommodities) do
		for iter2_123, iter3_123 in ipairs(iter1_123) do
			if iter3_123.id == arg1_123.id then
				var0_123 = true

				break
			end
		end

		if var0_123 then
			var1_123 = arg0_123.giftPackCommodities[iter0_123]
			var2_123 = arg0_123.giftSkinCommodities[iter0_123]
			var3_123 = arg0_123.giftSkinProbabilitys[iter0_123]

			break
		end
	end

	if var0_123 then
		setText(arg0_123.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip_2"))
		onButton(arg0_123, arg0_123.giftPackBtn, function()
			if not var1_123:isChargeType() then
				return
			end

			local var0_124 = var1_123:GetSkinProbability()
			local var1_124 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_124)

			if #var0_124 <= 0 or #var0_124 ~= #var1_124 then
				arg0_123:emit(LatestSkinShopMediator.OPEN_SCENE, {
					SCENE.CHARGE,
					{
						wrap = ChargeScene.TYPE_PICK
					}
				})
			else
				arg0_123:emit(LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER, var1_123, var2_123, var3_123)
			end
		end, SFX_PANEL)
	else
		var0_123 = getProxy(ActivityProxy):GetFakeGiftPackActivity(arg1_123)

		if var0_123 then
			setText(arg0_123.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip"))
			onButton(arg0_123, arg0_123.giftPackBtn, function()
				arg0_123:emit(LatestSkinShopMediator.OPEN_GIFT_ACT_LAYER, var0_123.id)
			end, SFX_PANEL)
		end
	end

	setActive(arg0_123.giftPackBtn, var0_123)
end

function var0_0.SetGiftPackLayer(arg0_126)
	return
end

function var0_0.OnPurchase(arg0_127, arg1_127)
	if arg1_127.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_127:isDisCount() and arg1_127:IsItemDiscountType() then
		arg0_127:emit(LatestSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_127.id, 1)
	else
		arg0_127:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_127.id, 1)
	end
end

function var0_0.OnItemPurchase(arg0_128, arg1_128)
	if arg1_128.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_128 = arg1_128:GetVoucherIdList()
	local var1_128 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_128.id)

	if #var0_128 <= 0 and #var1_128 <= 0 then
		return
	end

	local var2_128 = {}

	for iter0_128, iter1_128 in ipairs(var0_128) do
		table.insert(var2_128, iter1_128)
	end

	for iter2_128, iter3_128 in ipairs(var1_128) do
		table.insert(var2_128, iter3_128.id)
	end

	local var3_128 = arg0_128.skinId
	local var4_128 = pg.ship_skin_template[var3_128]
	local var5_128 = SwitchSpecialChar(var4_128.name, true)

	arg0_128.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_128,
		skinId = var3_128,
		skinName = var5_128,
		price = arg1_128:GetPrice(),
		onYes = function(arg0_129)
			if arg0_129 then
				arg0_128:emit(LatestSkinShopMediator.ON_ITEM_PURCHASE, arg0_129, arg1_128.id)
			else
				arg0_128:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_128.id, 1)
			end
		end
	})
end

function var0_0.OnActivity(arg0_130, arg1_130)
	local var0_130 = arg1_130:getConfig("time")
	local var1_130 = arg1_130:getConfig("activity")
	local var2_130 = getProxy(ActivityProxy):getActivityById(var1_130)

	if var1_130 == 0 and pg.TimeMgr.GetInstance():inTime(var0_130) or var2_130 and not var2_130:isEnd() then
		if arg1_130.type == Goods.TYPE_ACTIVITY then
			arg0_130:emit(LatestSkinShopMediator.GO_SHOPS_LAYER, arg1_130:getConfig("activity"))
		elseif arg1_130.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_130 = arg1_130:getConfig("scene")

			if var3_130 and #var3_130 > 0 then
				arg0_130:emit(LatestSkinShopMediator.OPEN_SCENE, var3_130)
			else
				arg0_130:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_130)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_131, arg1_131)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_131 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_131.name, var0_131.level))

		return
	end

	arg0_131:emit(LatestSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_132, arg1_132)
	local var0_132 = arg0_132.skinId
	local var1_132 = getProxy(ShipSkinProxy):getSkinById(var0_132)

	if var1_132 and not var1_132:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_132 = arg1_132:getConfig("resource_num")
	local var3_132 = arg1_132:getConfig("time_second") * var2_132
	local var4_132, var5_132, var6_132, var7_132 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_132)
	local var8_132 = pg.ship_skin_template[arg0_132.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_132, var8_132, var4_132, var5_132),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_132 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_132:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_132.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_134, arg1_134)
	local var0_134 = arg0_134.skinId
	local var1_134 = getProxy(ShipSkinProxy):getSkinById(var0_134)

	if var1_134 and not var1_134:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_134 = arg1_134:getConfig("resource_num")
	local var3_134 = arg1_134:getConfig("time_second") * var2_134
	local var4_134, var5_134, var6_134, var7_134 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_134)
	local var8_134 = pg.ship_skin_template[arg0_134.skinId].name
	local var9_134 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_134 = _.detect(var9_134, function(arg0_135)
		return arg0_135:CanUseForShop(arg1_134.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_134, var8_134, var4_134, var5_134),
		onYes = function()
			if not var10_134 or var10_134.count < var2_134 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_134:emit(LatestSkinShopMediator.ON_ITEM_EXPERIENCE, var10_134.id, arg1_134.id, 1)
		end
	})
end

function var0_0.SetFilterPanel(arg0_137)
	local var0_137 = arg0_137.filterContent:Find("own/options")
	local var1_137 = arg0_137.filterContent:Find("type/options")
	local var2_137 = arg0_137.filterContent:Find("shipHave/options")
	local var3_137 = arg0_137.filterContent:Find("camp/options")
	local var4_137 = arg0_137.filterContent:Find("rarity/options")
	local var5_137 = arg0_137.filterContent:Find("shipType/options")
	local var6_137 = arg0_137.filterContent:Find("themeType/options")
	local var7_137 = arg0_137.filterContent:Find("tag/options")

	arg0_137:SetOptionList(var3_137, ShipIndexConst.CampNames, true)
	arg0_137:SetOptionList(var4_137, ShipIndexConst.RarityNames, true)
	arg0_137:SetOptionList(var5_137, ShipIndexConst.TypeNames, true)
	arg0_137:SetOptionList(var6_137, arg0_137.classifyNames)
	arg0_137:SetSingleOptions(var0_137, "ownType")
	arg0_137:SetMultiOptions(var1_137, "typeType")
	arg0_137:SetSingleOptions(var2_137, "shipHaveType")
	arg0_137:SetMultiOptions(var3_137, "campType")
	arg0_137:SetMultiOptions(var4_137, "rarityType")
	arg0_137:SetMultiOptions(var5_137, "shipType")
	arg0_137:SetMultiOptions(var6_137, "themeType")
	arg0_137:SetMultiOptions(var7_137, "tagType")
	arg0_137:HideEmptyOptions()
	onButton(arg0_137, arg0_137.filterUI:Find("bg"), function()
		for iter0_138, iter1_138 in pairs(arg0_137.filterValues) do
			arg0_137.filterValuesTemp[iter0_138] = Clone(arg0_137.filterValues[iter0_138])
		end

		setActive(arg0_137.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_137, arg0_137.filterUI:Find("panelMask/panel/closeBtn"), function()
		for iter0_139, iter1_139 in pairs(arg0_137.filterValues) do
			arg0_137.filterValuesTemp[iter0_139] = Clone(arg0_137.filterValues[iter0_139])
		end

		setActive(arg0_137.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_137, arg0_137.filterUI:Find("panelMask/panel/bottom/ok"), function()
		for iter0_140, iter1_140 in pairs(arg0_137.filterValues) do
			arg0_137.filterValues[iter0_140] = Clone(arg0_137.filterValuesTemp[iter0_140])
		end

		setActive(arg0_137.filterUI, false)
		arg0_137:Refresh(true)
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_141)
	setActive(arg0_141.filterUI, true)

	local var0_141 = arg0_141.filterContent:Find("own/options")
	local var1_141 = arg0_141.filterContent:Find("type/options")
	local var2_141 = arg0_141.filterContent:Find("shipHave/options")
	local var3_141 = arg0_141.filterContent:Find("camp/options")
	local var4_141 = arg0_141.filterContent:Find("rarity/options")
	local var5_141 = arg0_141.filterContent:Find("shipType/options")
	local var6_141 = arg0_141.filterContent:Find("themeType/options")
	local var7_141 = arg0_141.filterContent:Find("tag/options")

	arg0_141:SetSingleOptions(var0_141, "ownType", true)
	arg0_141:SetMultiOptions(var1_141, "typeType", true)
	arg0_141:SetSingleOptions(var2_141, "shipHaveType", true)
	arg0_141:SetMultiOptions(var3_141, "campType", true)
	arg0_141:SetMultiOptions(var4_141, "rarityType", true)
	arg0_141:SetMultiOptions(var5_141, "shipType", true)
	arg0_141:SetMultiOptions(var6_141, "themeType", true)
	arg0_141:SetMultiOptions(var7_141, "tagType", true)
end

function var0_0.SetOptionList(arg0_142, arg1_142, arg2_142, arg3_142)
	local var0_142 = UIItemList.New(arg1_142, arg1_142:GetChild(0))

	var0_142:make(function(arg0_143, arg1_143, arg2_143)
		if arg0_143 == UIItemList.EventUpdate then
			local var0_143 = arg2_142[arg1_143 + 1]

			if arg3_142 then
				var0_143 = i18n(var0_143)
			end

			arg2_143.name = arg1_143

			setScrollText(arg2_143:Find("mask/Text"), var0_143)
		end
	end)
	var0_142:align(#arg2_142)
end

function var0_0.SetSingleOptions(arg0_144, arg1_144, arg2_144, arg3_144)
	for iter0_144 = 0, arg1_144.childCount - 1 do
		local var0_144 = arg1_144:GetChild(iter0_144)

		arg0_144:SetOptionSelect(arg1_144:GetChild(iter0_144), iter0_144 == arg0_144.filterValuesTemp[arg2_144])

		if not arg3_144 then
			onButton(arg0_144, var0_144, function()
				arg0_144.filterValuesTemp[arg2_144] = iter0_144

				for iter0_145 = 0, arg1_144.childCount - 1 do
					arg0_144:SetOptionSelect(arg1_144:GetChild(iter0_145), iter0_145 == iter0_144)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_146, arg1_146, arg2_146, arg3_146)
	for iter0_146 = 0, arg1_146.childCount - 1 do
		local var0_146 = arg1_146:GetChild(iter0_146)

		arg0_146:SetOptionSelect(arg1_146:GetChild(iter0_146), table.contains(arg0_146.filterValuesTemp[arg2_146], iter0_146))

		if not arg3_146 then
			onButton(arg0_146, var0_146, function()
				if iter0_146 == 0 then
					arg0_146.filterValuesTemp[arg2_146] = {
						0
					}

					for iter0_147 = 0, arg1_146.childCount - 1 do
						arg0_146:SetOptionSelect(arg1_146:GetChild(iter0_147), iter0_147 == 0)
					end
				else
					table.removebyvalue(arg0_146.filterValuesTemp[arg2_146], 0)

					if table.contains(arg0_146.filterValuesTemp[arg2_146], iter0_146) then
						table.removebyvalue(arg0_146.filterValuesTemp[arg2_146], iter0_146)
					else
						table.insert(arg0_146.filterValuesTemp[arg2_146], iter0_146)
					end

					local var0_147 = true

					for iter1_147 = 1, arg1_146.childCount - 1 do
						if not table.contains(arg0_146.filterValuesTemp[arg2_146], iter1_147) and arg1_146:GetChild(iter1_147).gameObject.activeSelf then
							var0_147 = false

							break
						end
					end

					if #arg0_146.filterValuesTemp[arg2_146] == 0 then
						var0_147 = true
					end

					if var0_147 and arg2_146 ~= "tagType" then
						arg0_146.filterValuesTemp[arg2_146] = {
							0
						}
					end

					for iter2_147 = 0, arg1_146.childCount - 1 do
						arg0_146:SetOptionSelect(arg1_146:GetChild(iter2_147), table.contains(arg0_146.filterValuesTemp[arg2_146], iter2_147))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_148, arg1_148, arg2_148)
	setActive(arg1_148:Find("selectedFrame"), arg2_148)

	local var0_148

	if IsNil(arg1_148:Find("Text")) then
		var0_148 = arg1_148:Find("mask/Text"):GetComponent(typeof(Text))
	else
		var0_148 = arg1_148:Find("Text"):GetComponent(typeof(Text))
	end

	if arg2_148 then
		var0_148.color = Color.New(1, 1, 1, 1)
	else
		var0_148.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.HideEmptyOptions(arg0_149, arg1_149, arg2_149)
	local var0_149 = {
		typeType = {
			0
		},
		shipHaveType = {
			0
		},
		campType = {
			0
		},
		rarityType = {
			0
		},
		shipType = {
			0
		},
		tagType = {
			0
		}
	}

	for iter0_149, iter1_149 in ipairs(arg0_149.commodities) do
		local var1_149 = iter1_149:getSkinId()
		local var2_149 = ShipSkin.New({
			id = var1_149
		})
		local var3_149 = arg0_149:GetSkinType(var2_149)

		for iter2_149, iter3_149 in ipairs(var3_149) do
			if not table.keyof(var0_149.typeType, iter3_149) then
				table.insert(var0_149.typeType, iter3_149)
			end
		end

		local var4_149 = arg0_149:GetShipHave(var2_149)

		if not table.keyof(var0_149.shipHaveType, var4_149) then
			table.insert(var0_149.shipHaveType, var4_149)
		end

		local var5_149 = arg0_149:GetCampType(var2_149)

		if not table.keyof(var0_149.campType, var5_149) then
			table.insert(var0_149.campType, var5_149)
		end

		local var6_149 = arg0_149:GetRarityType(var2_149)

		if not table.keyof(var0_149.rarityType, var6_149) then
			table.insert(var0_149.rarityType, var6_149)
		end

		local var7_149 = arg0_149:GetShipType(var2_149)

		if not table.keyof(var0_149.shipType, var7_149) then
			table.insert(var0_149.shipType, var7_149)
		end

		local var8_149 = arg0_149:GetTagType(iter1_149)

		if not table.keyof(var0_149.tagType, var8_149) then
			table.insert(var0_149.tagType, var8_149)
		end
	end

	for iter4_149, iter5_149 in pairs(var0_149) do
		table.sort(iter5_149, function(arg0_150, arg1_150)
			return arg0_150 < arg1_150
		end)
	end

	for iter6_149 = 1, arg0_149.uiTypeOptions.childCount - 1 do
		setActive(arg0_149.uiTypeOptions:GetChild(iter6_149), table.contains(var0_149.typeType, iter6_149))
	end

	for iter7_149 = 1, arg0_149.uiShipHaveOptions.childCount - 1 do
		setActive(arg0_149.uiShipHaveOptions:GetChild(iter7_149), table.contains(var0_149.shipHaveType, iter7_149))
	end

	for iter8_149 = 1, arg0_149.uiCampOptions.childCount - 1 do
		setActive(arg0_149.uiCampOptions:GetChild(iter8_149), table.contains(var0_149.campType, iter8_149))
	end

	for iter9_149 = 1, arg0_149.uiRrarityOptions.childCount - 1 do
		setActive(arg0_149.uiRrarityOptions:GetChild(iter9_149), table.contains(var0_149.rarityType, iter9_149))
	end

	for iter10_149 = 1, arg0_149.uiShipTypeOptions.childCount - 1 do
		setActive(arg0_149.uiShipTypeOptions:GetChild(iter10_149), table.contains(var0_149.shipType, iter10_149))
	end

	for iter11_149 = 1, arg0_149.uiTagTypeOptions.childCount - 1 do
		setActive(arg0_149.uiTagTypeOptions:GetChild(iter11_149), table.contains(var0_149.tagType, iter11_149))
	end
end

function var0_0.GetSkinType(arg0_151, arg1_151)
	local var0_151 = {}

	if arg1_151:IsLive2d() or arg1_151:IsLive2dPlus() then
		table.insert(var0_151, 1)
	end

	if not arg1_151:IsLive2d() and not arg1_151:IsLive2dPlus() and not arg1_151:IsSpine() and not arg1_151:IsSpinePlus() then
		table.insert(var0_151, 2)
	end

	if arg1_151:IsSpine() or arg1_151:IsSpinePlus() then
		table.insert(var0_151, 3)
	end

	if arg1_151:IsBG() then
		table.insert(var0_151, 4)
	end

	if arg1_151:IsDbg() then
		table.insert(var0_151, 5)
	end

	if arg1_151:isBgm() then
		table.insert(var0_151, 6)
	end

	return var0_151
end

function var0_0.GetShipHave(arg0_152, arg1_152)
	if arg1_152:CantUse() then
		return 2
	else
		return 1
	end
end

function var0_0.GetCampType(arg0_153, arg1_153)
	local var0_153 = arg1_153:GetDefaultShipConfig()

	if not var0_153 then
		return 0
	end

	local var1_153 = arg0_153:ToVShip(var0_153):getNation()
	local var2_153 = ShipIndexCfg.camp

	for iter0_153, iter1_153 in ipairs(var2_153) do
		for iter2_153, iter3_153 in ipairs(iter1_153.types) do
			if iter3_153 == Nation.LINK then
				if var1_153 >= Nation.LINK then
					return iter0_153 - 1
				end
			elseif var1_153 == iter3_153 then
				return iter0_153 - 1
			end
		end
	end

	return 0
end

function var0_0.GetRarityType(arg0_154, arg1_154)
	local var0_154 = arg1_154:GetDefaultShipConfig()

	if not var0_154 then
		return 0
	end

	local var1_154 = arg0_154:ToVShip(var0_154):getRarity()
	local var2_154 = ShipIndexCfg.rarity

	for iter0_154, iter1_154 in ipairs(var2_154) do
		if table.contains(iter1_154.types, var1_154) then
			return iter0_154 - 1
		end
	end

	return 0
end

function var0_0.GetShipType(arg0_155, arg1_155)
	local var0_155 = arg1_155:GetDefaultShipConfig()

	if not var0_155 then
		return 0
	end

	local var1_155 = arg0_155:ToVShip(var0_155):getShipType()
	local var2_155 = ShipIndexCfg.type

	for iter0_155, iter1_155 in ipairs(var2_155) do
		for iter2_155, iter3_155 in pairs(iter1_155) do
			if table.keyof(iter3_155, var1_155) then
				return iter0_155 - 1
			end
		end
	end

	return 0
end

function var0_0.GetTagType(arg0_156, arg1_156)
	local var0_156 = table.contains(arg0_156.returnSkins, arg1_156.id)
	local var1_156 = NewShopSkinCard.GetTagId(arg1_156, var0_156)

	if var1_156 > 0 then
		return var1_156
	else
		return 0
	end
end

function var0_0.GetSkinClassify(arg0_157)
	arg0_157.classifyIds = {}
	arg0_157.classifyNames = {}

	local var0_157 = {}
	local var1_157 = {}

	for iter0_157, iter1_157 in ipairs(arg0_157.commodities) do
		local var2_157 = arg0_157:GetShopTypeIdBySkinId(iter1_157:getSkinId())
		local var3_157 = var2_157 == 0 and var16_0 or var2_157

		var1_157[var3_157] = (var1_157[var3_157] or 0) + 1
	end

	local var4_157 = {}

	for iter2_157, iter3_157 in ipairs(arg0_157.returnSkins) do
		var4_157[iter3_157] = true
	end

	if underscore.any(arg0_157.commodities, function(arg0_158)
		return var4_157[arg0_158.id]
	end) then
		table.insert(var0_157, var14_0)
	end

	for iter4_157, iter5_157 in ipairs(pg.skin_page_template.all) do
		if iter5_157 ~= var17_0 and iter5_157 ~= var18_0 and (var1_157[iter5_157] or 0) > 0 then
			table.insert(var0_157, iter5_157)
		end
	end

	if arg0_157.mode == var0_0.MODE_EXPERIENCE then
		table.insert(var0_157, 1, var13_0)
	end

	if arg0_157.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_157, 1, var15_0)
	end

	table.insert(var0_157, 1, var12_0)

	arg0_157.classifyIds = var0_157

	for iter6_157, iter7_157 in ipairs(arg0_157.classifyIds) do
		if iter7_157 == var12_0 then
			table.insert(arg0_157.classifyNames, i18n("shop_filter_all"))
		elseif iter7_157 == var13_0 or iter7_157 == var15_0 then
			table.insert(arg0_157.classifyNames, i18n("shop_filter_trial"))
		elseif iter7_157 == var14_0 then
			table.insert(arg0_157.classifyNames, i18n("shop_filter_retro"))
		else
			table.insert(arg0_157.classifyNames, pg.skin_page_template[iter7_157].name)
		end
	end
end

function var0_0.GetShopTypeIdBySkinId(arg0_159, arg1_159)
	local var0_159 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_159.shopTypeIdList then
		arg0_159.shopTypeIdList = {}
	end

	if arg0_159.shopTypeIdList[arg1_159] then
		return arg0_159.shopTypeIdList[arg1_159]
	end

	for iter0_159, iter1_159 in pairs(var0_159) do
		for iter2_159, iter3_159 in ipairs(iter1_159) do
			arg0_159.shopTypeIdList[iter3_159] = iter0_159

			if iter3_159 == arg1_159 then
				return iter0_159
			end
		end
	end
end

function var0_0.OnShopping(arg0_160, arg1_160)
	if not arg0_160.showingCommodity then
		return
	end

	if arg0_160.purchaseView and arg0_160.purchaseView:GetLoaded() then
		arg0_160.purchaseView:Hide()
	end

	if arg0_160.showingCommodity.id == arg1_160 then
		arg0_160.pendingSelectId = arg0_160:GetNextCommodityIndex(arg1_160)

		arg0_160:GetAllCommodities()
		arg0_160:Refresh(false)
	end
end

function var0_0.OnFurnitureUpdate(arg0_161, arg1_161)
	if not arg0_161.showingCommodity then
		return
	end

	local var0_161 = arg0_161.showingCommodity.id

	if Goods.ExistFurniture(var0_161) and Goods.Id2FurnitureId(var0_161) == arg1_161 then
		arg0_161:GetAllCommodities()
		arg0_161:Refresh(true)
	end
end

function var0_0.CheckDownloadSkinList(arg0_162, arg1_162)
	local var0_162 = {}

	for iter0_162, iter1_162 in ipairs(arg0_162.commodities) do
		PaintingGroupConst.AddPaintingNameBySkinID(var0_162, iter1_162:getSkinId())
	end

	local var1_162 = {
		showMask = true,
		isShowBox = true,
		paintingNameList = var0_162,
		finishFunc = arg1_162
	}

	PaintingGroupConst.PaintingDownload(var1_162)
end

function var0_0.willExit(arg0_163)
	arg0_163:ClearCards()

	arg0_163.spriteCache = nil

	ClearLScrollrect(arg0_163.scrollrect)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_163:getUIName())

	if arg0_163.live2dChar then
		arg0_163.live2dChar:Dispose()

		arg0_163.live2dChar = nil
	end

	if arg0_163.voucherMsgBox then
		arg0_163.voucherMsgBox:Destroy()

		arg0_163.voucherMsgBox = nil
	end

	if arg0_163.purchaseView then
		arg0_163.purchaseView:Destroy()

		arg0_163.purchaseView = nil
	end

	for iter0_163, iter1_163 in pairs(arg0_163.downloads) do
		iter1_163:Dispose()
	end

	arg0_163.downloads = {}

	arg0_163:ClearPainting()

	if arg0_163.interactionPreview then
		arg0_163.interactionPreview:Dispose()

		arg0_163.interactionPreview = nil
	end

	arg0_163:disposeEvent()
	arg0_163:ClearTimer()
	arg0_163:ReturnChar()
	arg0_163:UnOverlay()
end

function var0_0.GetNextCommodityIndex(arg0_164, arg1_164)
	for iter0_164, iter1_164 in ipairs(arg0_164.displays) do
		if iter1_164.id == arg1_164 then
			if iter0_164 == #arg0_164.displays then
				return arg1_164
			end

			return arg0_164.displays[iter0_164 + 1].id
		end
	end
end

function var0_0.onBackPressed(arg0_165)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
