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

local function var20_0(arg0_5, arg1_5)
	local var0_5 = {}

	if arg0_5 == ShopConst.NEW_SKIN_SHOP_ID then
		var0_5 = getProxy(ShipSkinProxy):GetInTimeSkins()
	elseif arg0_5 == ShopConst.PERMANANT_SKIN_SHOP_ID then
		var0_5 = getProxy(ShipSkinProxy):GetPermanentSkins()
	else
		local var1_5 = pg.shop_skin_subsheet[arg0_5]

		for iter0_5, iter1_5 in ipairs(getProxy(ShipSkinProxy):GetAllSkins()) do
			if var1_5 and table.keyof(var1_5.param, iter1_5.id) then
				table.insert(var0_5, iter1_5)
			end
		end
	end

	if LOCK_SKIN_US then
		local var2_5 = pg.gameset.levellimit_skintype.key_value
		local var3_5 = pg.gameset.levellimit_skintype.description

		if var2_5 >= getProxy(PlayerProxy):getData().level then
			var0_5 = _.filter(var0_5, function(arg0_6)
				local var0_6 = pg.ship_skin_template[arg0_6:getSkinId()].shop_type_id

				return table.contains(var3_5, var0_6)
			end)
		end
	end

	if arg1_5 == var0_0.MODE_OVERVIEW then
		for iter2_5 = #var0_5, 1, -1 do
			if var0_5[iter2_5]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				table.remove(var0_5, iter2_5)
			end
		end
	end

	return var0_5
end

local function var21_0(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs(arg0_7) do
		local var1_7 = pg.ship_skin_template[iter1_7:getSkinId()]

		if var1_7 then
			table.insertto(var0_7, ResPathSupport.GetPaintingShipYardIconListByPaintingName(var1_7.prefab))
			table.insertto(var0_7, ResPathSupport.GetPaintingShipYardIconListByPaintingName(var1_7.painting))
		end

		if iter1_7.type == Goods.TYPE_SKIN then
			local var2_7 = iter1_7:getConfig("resource_type")
			local var3_7 = Item.getConfigData(id2ItemId(var2_7))

			if var3_7 and var3_7.icon then
				table.insert(var0_7, var3_7.icon)
			end
		end
	end

	return var0_7
end

local function var22_0(arg0_8)
	local var0_8 = {
		arg0_8
	}

	if not ShipSkin.IsChangeSkin(arg0_8) then
		return var0_8
	end

	local var1_8 = {
		[arg0_8] = true
	}
	local var2_8 = arg0_8

	for iter0_8 = 1, 10 do
		local var3_8 = ShipSkin.GetChangeSkinData(var2_8)
		local var4_8 = var3_8 and var3_8.next

		if not var4_8 or var1_8[var4_8] or not pg.ship_skin_template[var4_8] then
			break
		end

		var1_8[var4_8] = true

		table.insert(var0_8, var4_8)

		var2_8 = var4_8
	end

	return var0_8
end

local function var23_0(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(var22_0(arg0_9)) do
		local var1_9 = pg.ship_skin_template[iter1_9]

		if var1_9 then
			if var1_9.skin_type ~= ShipSkin.SKIN_TYPE_TB then
				table.insertto(var0_9, ResPathSupport.GetSpineCharListByPrefabName(var1_9.prefab))
				table.insertto(var0_9, ResPathSupport.GetSpineQIconListByPrefabName(var1_9.painting))
			end

			table.insertto(var0_9, ResPathSupport.GetPaintingListByPaintingName(var1_9.painting))

			if var1_9.painting and #var1_9.painting > 0 then
				for iter2_9, iter3_9 in ipairs({
					"_shop",
					"_n_shop"
				}) do
					table.insert(var0_9, string.lower(string.format(ResPathSupport.ConstPath.Painting.Base, var1_9.painting, iter3_9)))
				end
			end

			table.insertto(var0_9, ResPathSupport.GetShipSkinPaintingFaceList(iter1_9))
			table.insertto(var0_9, ResPathSupport.GetShipSkinBgList(iter1_9))

			if var1_9.ship_group and var1_9.skin_type ~= ShipSkin.SKIN_TYPE_TB then
				local var2_9 = ShipGroup.getDefaultShipConfig(var1_9.ship_group)

				if var2_9 and pg.ship_data_statistics[var2_9.id] then
					table.insertto(var0_9, ResPathSupport.GetShipRarityBgList(var2_9.id))
				end
			end

			if PaintingGroupConst.IsPaintingNeedCheck() and var1_9.painting and #var1_9.painting > 0 then
				PaintingGroupConst.AddPaintingNameWithFilteMap(var0_9, var1_9.painting)
			end
		end
	end

	return ResPathSupport.UniqueLuaArr(var0_9)
end

function var0_0.getResource(arg0_10)
	local var0_10 = {
		"ui/LatestSkinShopUI",
		"ui/SkinShopUI_atlas",
		"skinicon"
	}
	local var1_10 = arg0_10.contextData

	local function var2_10(arg0_11)
		local var0_11 = Goods.Create({
			shop_id = arg0_11
		}, Goods.TYPE_CHARGE)
		local var1_11 = getProxy(ShopsProxy):getChargedList() or {}
		local var2_11 = ChargeConst.getBuyCount(var1_11, var0_11.id)

		var0_11:updateBuyCount(var2_11)

		return var0_11
	end

	local function var3_10()
		if var1_10.skinCommodities then
			return var1_10.skinCommodities
		end

		if var1_10.commodityId or var1_10.giftPackCommodity then
			local var0_12 = (var1_10.giftPackCommodity or var2_10(var1_10.commodityId)):GetSkinProbability()

			return getProxy(ShipSkinProxy):GetProbabilitySkins(var0_12)
		end

		return var20_0(var1_10.type or ShopConst.PERMANANT_SKIN_SHOP_ID, var1_10.mode or var0_0.MODE_OVERVIEW)
	end

	local var4_10 = var21_0(var3_10())

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_10), var0_10, var4_10))
end

function var0_0.init(arg0_13)
	arg0_13.bgs = arg0_13._tf:Find("bgs")
	arg0_13.adapt = arg0_13._tf:Find("adapt")
	arg0_13.top = arg0_13.adapt:Find("top")
	arg0_13.bottom = arg0_13.adapt:Find("bottom")
	arg0_13.right = arg0_13.adapt:Find("right")
	arg0_13.subPage = arg0_13.adapt:Find("subPage")
	arg0_13.resources = arg0_13.adapt:Find("top/resources")
	arg0_13.limitTime = arg0_13.adapt:Find("top/title/limit_time/Text")
	arg0_13.skinName = arg0_13.adapt:Find("top/title/skin_name_mask/skin_name")
	arg0_13.shipName = arg0_13.adapt:Find("top/title/name_mask/name")
	arg0_13.changeSkin = arg0_13.adapt:Find("top/change_skin")
	arg0_13.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_13.changeSkin, "toggle_ui"))
	arg0_13.showOwnBtn = arg0_13.adapt:Find("bottom/showOwnBtn")
	arg0_13.filterBtn = arg0_13.adapt:Find("bottom/filterBtn")
	arg0_13.search = arg0_13.adapt:Find("bottom/search")
	arg0_13.scrollrect = arg0_13.adapt:Find("bottom/scroll/content"):GetComponent("LScrollRect")
	arg0_13.sdTg = arg0_13.adapt:Find("right/sdTg")
	arg0_13.hideUITg = arg0_13.adapt:Find("right/hideUITg")
	arg0_13.charContainer = arg0_13.adapt:Find("right/char_container")
	arg0_13.backChara = arg0_13.charContainer:Find("bg/back/chara")
	arg0_13.charTf = arg0_13.charContainer:Find("char")
	arg0_13.furnitureContainer = arg0_13.charContainer:Find("fur")
	arg0_13.switchPreviewBtn = arg0_13.charContainer:Find("switch")
	arg0_13.dynamicToggle = arg0_13.adapt:Find("right/functionsAndTags/dynamic")
	arg0_13.dynamicIcon = arg0_13.adapt:Find("right/functionsAndTags/dynamic/icon")
	arg0_13.showBgToggle = arg0_13.adapt:Find("right/functionsAndTags/showBg")
	arg0_13.dynamicResToggle = arg0_13.adapt:Find("right/functionsAndTags/dynamic/l2d_res_state")
	arg0_13.tagList = UIItemList.New(arg0_13.adapt:Find("right/functionsAndTags/tags"), arg0_13.adapt:Find("right/functionsAndTags/tags/tag"))
	arg0_13.giftPackBtn = arg0_13.adapt:Find("right/giftPackBtn")
	arg0_13.price = arg0_13.adapt:Find("right/price")
	arg0_13.btnsList = {
		arg0_13.price:Find("normal/btns"),
		arg0_13.price:Find("charge/btns")
	}
	arg0_13.filterUI = arg0_13.adapt:Find("subPage/filterUI")
	arg0_13.filterContent = arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content")
	arg0_13.painting = arg0_13._tf:Find("painting")
	arg0_13.paintingTF = arg0_13._tf:Find("painting/paint")
	arg0_13.defaultPaintingPosition = arg0_13.paintingTF.anchoredPosition
	arg0_13.defaultPaintingScale = arg0_13.paintingTF.localScale
	arg0_13.live2dContainer = arg0_13._tf:Find("painting/paint/live2d")
	arg0_13.spTF = arg0_13._tf:Find("painting/paint/spinePainting")
	arg0_13.spBg = arg0_13._tf:Find("painting/paintBg/spinePainting")

	setActive(arg0_13.charContainer, false)
	setActive(arg0_13.filterUI, false)

	arg0_13.mainTitle = arg0_13.adapt:Find("top/mainTitle")
	arg0_13.backBtn = arg0_13.adapt:Find("top/closeBtn")
	arg0_13.homeBtn = arg0_13.adapt:Find("top/homeBtn")
	arg0_13.giftPack = arg0_13.adapt:Find("giftPack")

	setActive(arg0_13.mainTitle, false)
	setActive(arg0_13.backBtn, false)
	setActive(arg0_13.homeBtn, false)
	setActive(arg0_13.giftPack, false)

	arg0_13.downloads = {}
	arg0_13.isToggleDynamic = false
	arg0_13.isToggleShowBg = true
	arg0_13.isPreviewFurniture = false
	arg0_13.interactionPreview = BackYardInteractionPreview.New(arg0_13.furnitureContainer, Vector3(0, 0, 0))
	arg0_13.voucherMsgBox = SkinVoucherMsgBox.New(pg.UIMgr.GetInstance().OverlayMain)
	arg0_13.purchaseView = NewSkinShopPurchaseView.New(arg0_13._tf, arg0_13.event)

	arg0_13:RegisterEvent()
	setText(arg0_13._tf:Find("bgs/empty/Text"), i18n("shop_new_unfound"))
	setText(arg0_13.adapt:Find("top/mainTitle/Text"), i18n("shop_new_shop"))
	setText(arg0_13.filterBtn:Find("Text"), i18n("shop_new_sort"))
	setText(arg0_13.search:Find("holder"), i18n("shop_new_search"))

	for iter0_13, iter1_13 in ipairs(arg0_13.btnsList) do
		setText(iter1_13:Find("yigoumai_button/Text"), i18n("shop_new_purchased"))
		setText(iter1_13:Find("goumai_button/Text"), i18n("shop_new_purchase"))
		setText(iter1_13:Find("qianwanghuoqu_button/Text"), i18n("shop_new_claim"))
		setText(iter1_13:Find("furniture_shop/Text"), i18n("shop_new_furniture"))
		setText(iter1_13:Find("item_buy/Text"), i18n("shop_new_discount"))
		setText(iter1_13:Find("tiyan_btn/Text"), i18n("shop_new_try"))
		setText(iter1_13:Find("buy_with_gift/Text"), i18n("shop_new_purchase"))
	end

	setText(arg0_13.btnsList[2]:Find("buy_charge/Text"), i18n("shop_new_purchase"))
	setText(arg0_13.price:Find("btn/tag/Text"), i18n("shop_new_gift"))
	setText(arg0_13.giftPack:Find("panel/desc"), i18n("shop_new_gem_transform"))
	setText(arg0_13.giftPack:Find("price/btns/yigoumai_button/Text"), i18n("shop_new_purchased"))
	setText(arg0_13.filterUI:Find("panelMask/panel/title"), i18n("shop_new_sort"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/subTitleFrame/subTitle"), i18n("shop_new_review"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/1/Text"), i18n("shop_new_owned"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/2/Text"), i18n("shop_new_havent_own"))
	setScrollText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/3/mask/Text"), i18n("shop_new_unused"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("shop_new_type"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/2/Text"), i18n("shop_new_static"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/3/Text"), i18n("shop_new_dynamic"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/4/Text"), i18n("shop_new_static_bg"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/5/Text"), i18n("shop_new_dynamic_bg"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/6/Text"), i18n("shop_new_bgm"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/subTitleFrame/subTitle"), i18n("shop_new_index"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/1/Text"), i18n("shop_new_ship_owned"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/2/Text"), i18n("shop_new_ship_havent_owned"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/camp/subTitleFrame/subTitle"), i18n("shop_new_nation"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/rarity/subTitleFrame/subTitle"), i18n("shop_new_rarity"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipType/subTitleFrame/subTitle"), i18n("shop_new_category"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/themeType/subTitleFrame/subTitle"), i18n("shop_new_skin_theme"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/subTitleFrame/subTitle"), i18n("skin_shop_tag"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/0/Text"), i18n("skin_shop_tag_0"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/1/Text"), i18n("skin_shop_tag_1"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/2/Text"), i18n("skin_shop_tag_2"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/3/Text"), i18n("skin_shop_tag_3"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/4/Text"), i18n("skin_shop_tag_4"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/5/Text"), i18n("skin_shop_tag_5"))
	setText(arg0_13.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/6/Text"), i18n("skin_shop_tag_6"))
	setText(arg0_13.filterUI:Find("panelMask/panel/bottom/ok/Text"), i18n("shop_new_confirm"))

	arg0_13.uiOwnOptions = arg0_13.filterContent:Find("own/options")
	arg0_13.uiTypeOptions = arg0_13.filterContent:Find("type/options")
	arg0_13.uiShipHaveOptions = arg0_13.filterContent:Find("shipHave/options")
	arg0_13.uiCampOptions = arg0_13.filterContent:Find("camp/options")
	arg0_13.uiRrarityOptions = arg0_13.filterContent:Find("rarity/options")
	arg0_13.uiShipTypeOptions = arg0_13.filterContent:Find("shipType/options")
	arg0_13.uiThemeTypeOptions = arg0_13.filterContent:Find("themeType/options")
	arg0_13.uiTagTypeOptions = arg0_13.filterContent:Find("tag/options")

	arg0_13:Overlay()
end

function var0_0.Overlay(arg0_14)
	arg0_14:OverlayPanel(arg0_14.adapt, {
		pbList = {
			arg0_14.top:Find("title"),
			arg0_14.top:Find("title/limit_time"),
			arg0_14.top:Find("title/charaNameBg"),
			arg0_14.showOwnBtn,
			arg0_14.filterBtn,
			arg0_14.search,
			arg0_14.charContainer:Find("bg"),
			arg0_14.price:Find("normal/consume"),
			arg0_14.filterUI:Find("panelMask/panel")
		}
	})
end

function var0_0.UnOverlay(arg0_15)
	arg0_15:UnOverlayPanel(arg0_15.adapt, arg0_15._tf)
end

function var0_0.didEnter(arg0_16)
	arg0_16:InitData()
	arg0_16:SetFilterPanel()
	arg0_16:SetResource()

	if arg0_16.mode == var0_0.MODE_EXPERIENCE or arg0_16.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI_2, false)
		setActive(arg0_16.showOwnBtn, false)
		setActive(arg0_16.filterBtn, false)
		setActive(arg0_16.search, false)

		arg0_16.top:Find("title").anchoredPosition = Vector2(184.2, -208.3)
		arg0_16.top:Find("change_skin").anchoredPosition = Vector2(70.7, -337.8)
		arg0_16.right:Find("giftPackBtn").anchoredPosition = Vector2(-483, -446.4)
		arg0_16.right:Find("price").anchoredPosition = Vector2(-238.3, -140.7)
		arg0_16.bottom:Find("scroll").offsetMin = Vector2(17.7, 0)
		arg0_16.bottom:Find("scroll").offsetMax = Vector2(-718.7, 227.9)
	end

	arg0_16:SetGiftPackLayer()
	onDelayTick(function()
		local var0_17 = {}

		table.insert(var0_17, function(arg0_18)
			arg0_16:CheckDownloadSkinList(arg0_18)
		end)
		seriesAsync(var0_17, function()
			arg0_16:SetSkinScroll()
			arg0_16:Refresh(true)
		end)
	end, 0.001)
	onButton(arg0_16, arg0_16.backBtn, function()
		arg0_16:closeView()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.homeBtn, function()
		arg0_16:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.filterBtn, function()
		arg0_16:OpenFilterPanel()
	end, SFX_PANEL)

	if arg0_16.mode == var0_0.MODE_EXPERIENCE or arg0_16.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	local var0_16 = getProxy(PlayerProxy):getRawData().id

	onToggle(arg0_16, arg0_16.sdTg, function(arg0_23)
		setActive(arg0_16.charContainer, arg0_23)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_16, arg0_23 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_16 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_16, 0)

	triggerToggle(arg0_16.sdTg, var1_16 == 1)
	onToggle(arg0_16, arg0_16.hideUITg, function(arg0_24)
		setActive(arg0_16.top, not arg0_24)
		setActive(arg0_16.bottom, not arg0_24)
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg0_24)
	end, SFX_PANEL)
	onInputChanged(arg0_16, arg0_16.search, function()
		arg0_16:Refresh(true)

		local var0_25 = getInputText(arg0_16.search)

		setActive(arg0_16.search:Find("holder"), var0_25 == "")
	end)
	onButton(arg0_16, arg0_16.showOwnBtn, function()
		arg0_16:emit(LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER)
	end, SFX_PANEL)
	getProxy(CommanderManualProxy):TaskProgressAdd(2021, 1)
end

function var0_0.SetResource(arg0_27)
	local var0_27 = getProxy(PlayerProxy):getRawData()

	setText(arg0_27.resources:Find("gem/Text"), var0_27:getTotalGem())
	onButton(arg0_27, arg0_27.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_29)
	arg0_29.type = arg0_29.contextData.type or ShopConst.PERMANANT_SKIN_SHOP_ID
	arg0_29.mode = arg0_29.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_29:GetAllCommodities()
	arg0_29:GetGiftPackCommodities()

	arg0_29.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()

	arg0_29:GetSkinClassify()

	local var0_29 = (arg0_29.mode == var0_0.MODE_EXPERIENCE or arg0_29.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM) and 1 or 0

	arg0_29.filterValues = {
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
			var0_29
		},
		tagType = {
			0
		}
	}
	arg0_29.filterValuesTemp = Clone(arg0_29.filterValues)
end

function var0_0.GetAllCommodities(arg0_30)
	arg0_30.commodities = var20_0(arg0_30.type, arg0_30.mode)
end

function var0_0.GetGiftPackCommodities(arg0_31)
	arg0_31.giftPackCommodities = {}
	arg0_31.giftSkinCommodities = {}
	arg0_31.giftSkinProbabilitys = {}

	for iter0_31, iter1_31 in ipairs(pg.pay_data_display.all) do
		local var0_31 = pg.pay_data_display[iter1_31]

		if var0_31.skin_inquire_relation ~= 0 and pg.TimeMgr.GetInstance():inTime(var0_31.time) then
			local var1_31 = getProxy(ShopsProxy):GetGiftCommodity(iter1_31, Goods.TYPE_CHARGE)

			arg0_31.giftPackCommodities[iter1_31] = var1_31

			local var2_31 = var1_31:GetSkinProbability()

			arg0_31.giftSkinCommodities[iter1_31] = getProxy(ShipSkinProxy):GetProbabilitySkins(var2_31)
			arg0_31.giftSkinProbabilitys[iter1_31] = getProxy(ShipSkinProxy):GetSkinProbabilitys(var2_31)
		end
	end
end

function var0_0.SetSkinScroll(arg0_32)
	arg0_32.scrollrect.isNewLoadingMethod = true

	function arg0_32.scrollrect.onInitItem(arg0_33)
		arg0_32:OnInitItem(arg0_33)
	end

	function arg0_32.scrollrect.onUpdateItem(arg0_34, arg1_34)
		arg0_32:OnUpdateItem(arg0_34, arg1_34)
	end

	arg0_32.scrollrect.enabled = true
end

function var0_0.Refresh(arg0_35, arg1_35)
	arg0_35:ClearCards()

	arg0_35.cards = {}
	arg0_35.displays = {}

	local var0_35 = getInputText(arg0_35.search)

	for iter0_35, iter1_35 in ipairs(arg0_35.commodities) do
		if arg0_35:filterOk(iter1_35) and arg0_35:IsSearchType(var0_35, iter1_35) then
			table.insert(arg0_35.displays, iter1_35)
		end
	end

	local var1_35 = {}

	for iter2_35, iter3_35 in ipairs(arg0_35.displays) do
		local var2_35 = iter3_35.type == Goods.TYPE_ACTIVITY or iter3_35.type == Goods.TYPE_ACTIVITY_EXTRA
		local var3_35 = 0

		if not var2_35 then
			var3_35 = iter3_35:GetPrice()
		end

		var1_35[iter3_35.id] = var3_35
	end

	table.sort(arg0_35.displays, function(arg0_36, arg1_36)
		return arg0_35:Sort(arg0_36, arg1_36, var1_35)
	end)

	local var4_35 = #arg0_35.displays == 0

	setActive(arg0_35.bgs:Find("default"), var4_35)
	setActive(arg0_35.bgs:Find("diffBg"), not var4_35)
	setActive(arg0_35.bgs:Find("empty"), var4_35)
	setActive(arg0_35._tf:Find("leftMask"), not var4_35)
	setActive(arg0_35._tf:Find("bottomMask"), not var4_35)
	setActive(arg0_35.painting, not var4_35)
	setActive(arg0_35.top:Find("title"), not var4_35)
	setActive(arg0_35.changeSkin, not var4_35)
	setActive(arg0_35.right, not var4_35)
	setActive(arg0_35.right, not var4_35)
	setActive(arg0_35.bottom:Find("scroll"), not var4_35)

	if not var4_35 then
		if arg1_35 then
			arg0_35.triggerFirstCard = true

			arg0_35.scrollrect:SetTotalCount(#arg0_35.displays, 0)
		else
			arg0_35.scrollrect:SetTotalCount(#arg0_35.displays)
		end
	end
end

function var0_0.IsSearchType(arg0_37, arg1_37, arg2_37)
	if not arg1_37 or arg1_37 == "" then
		return true
	end

	local var0_37 = arg2_37:getSkinId()

	return ShipSkin.New({
		id = var0_37
	}):IsMatchKey(arg1_37)
end

local function var24_0(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg2_38[arg0_38.id]
	local var1_38 = arg2_38[arg1_38.id]

	if var0_38 == var1_38 then
		return arg0_38.id < arg1_38.id
	else
		return var1_38 < var0_38
	end
end

function var0_0.Sort(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = arg1_39.buyCount == 0 and 1 or 0
	local var1_39 = arg2_39.buyCount == 0 and 1 or 0

	if var0_39 == var1_39 then
		local var2_39 = arg1_39:getConfig("order")
		local var3_39 = arg2_39:getConfig("order")

		if var2_39 == var3_39 then
			return var24_0(arg1_39, arg2_39, arg3_39)
		else
			return var2_39 < var3_39
		end
	else
		return var1_39 < var0_39
	end
end

function var0_0.filterOk(arg0_40, arg1_40)
	local var0_40 = arg0_40.filterValues.ownType
	local var1_40 = arg0_40.filterValues.typeType
	local var2_40 = arg0_40.filterValues.shipHaveType
	local var3_40 = arg0_40.filterValues.campType
	local var4_40 = arg0_40.filterValues.rarityType
	local var5_40 = arg0_40.filterValues.shipType
	local var6_40 = arg0_40.filterValues.themeType
	local var7_40 = arg0_40.filterValues.tagType
	local var8_40 = arg1_40:getSkinId()
	local var9_40 = ShipSkin.New({
		id = var8_40
	})
	local var10_40 = var9_40:GetDefaultShipConfig()
	local var11_40 = arg0_40:ToVShip(var10_40)

	if var0_40 ~= 0 then
		local var12_40 = false
		local var13_40 = getProxy(ShipSkinProxy):hasSkin(var8_40)
		local var14_40 = var9_40:NoUse()

		if var0_40 == 1 and var13_40 then
			var12_40 = true
		end

		if var0_40 == 2 and not var13_40 then
			var12_40 = true
		end

		if var0_40 == 3 and var13_40 and var14_40 then
			var12_40 = true
		end

		if not var12_40 then
			return false
		end
	end

	if var1_40[1] ~= 0 then
		local var15_40 = false

		for iter0_40, iter1_40 in ipairs(var1_40) do
			if iter1_40 == 1 and (var9_40:IsLive2d() or var9_40:IsLive2dPlus()) then
				var15_40 = true
			end

			if iter1_40 == 2 and not var9_40:IsLive2d() and not var9_40:IsLive2dPlus() and not var9_40:IsSpine() and not var9_40:IsSpinePlus() then
				var15_40 = true
			end

			if iter1_40 == 3 and (var9_40:IsSpine() or var9_40:IsSpinePlus()) then
				var15_40 = true
			end

			if iter1_40 == 4 and var9_40:IsBG() then
				var15_40 = true
			end

			if iter1_40 == 5 and var9_40:IsDbg() then
				var15_40 = true
			end

			if iter1_40 == 6 and var9_40:isBgm() then
				var15_40 = true
			end

			if var15_40 then
				break
			end
		end

		if not var15_40 then
			return false
		end
	end

	if var2_40 ~= 0 then
		local var16_40 = false
		local var17_40 = var9_40:CantUse()

		if var2_40 == 1 and not var17_40 then
			var16_40 = true
		end

		if var2_40 == 2 and var17_40 then
			var16_40 = true
		end

		if not var16_40 then
			return false
		end
	end

	if var3_40[1] ~= 0 then
		if not var10_40 then
			return false
		end

		local var18_40 = false

		for iter2_40, iter3_40 in ipairs(var3_40) do
			local var19_40 = ShipIndexCfg.camp

			for iter4_40, iter5_40 in ipairs(var19_40[iter3_40 + 1].types) do
				if iter5_40 == Nation.LINK then
					if var11_40:getNation() >= Nation.LINK then
						var18_40 = true
					end
				elseif iter5_40 == var11_40:getNation() then
					var18_40 = true
				end
			end

			if var18_40 then
				break
			end
		end

		if not var18_40 then
			return false
		end
	end

	if var4_40[1] ~= 0 then
		if not var10_40 then
			return false
		end

		local var20_40 = false

		for iter6_40, iter7_40 in ipairs(var4_40) do
			local var21_40 = ShipIndexCfg.rarity

			if table.contains(var21_40[iter7_40 + 1].types, var11_40:getRarity()) then
				var20_40 = true
			end

			if var20_40 then
				break
			end
		end

		if not var20_40 then
			return false
		end
	end

	if var5_40[1] ~= 0 then
		if not var10_40 then
			return false
		end

		local var22_40 = false

		for iter8_40, iter9_40 in ipairs(var5_40) do
			local var23_40 = ShipIndexCfg.type
			local var24_40 = var23_40[iter9_40 + 1].types

			if iter9_40 + 1 < 4 then
				local var25_40 = var23_40[iter9_40].shipTypes

				if table.contains(var24_40, var11_40:getShipType()) then
					var22_40 = true
				end

				if table.contains(var24_40, var11_40:getTeamType()) then
					var22_40 = true
				end
			elseif table.contains(var24_40, var11_40:getShipType()) then
				var22_40 = true
			end

			if var22_40 then
				break
			end
		end

		if not var22_40 then
			return false
		end
	end

	if var6_40[1] ~= 0 then
		local var26_40 = false

		for iter10_40, iter11_40 in ipairs(var6_40) do
			local var27_40 = arg0_40.classifyIds[iter11_40 + 1]

			if arg1_40:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				if arg0_40.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
					var26_40 = var27_40 == var15_0 and arg0_40:ExitSkinExperienceItem(arg1_40.id)
				else
					var26_40 = var27_40 == var13_0
				end
			elseif var27_40 == var12_0 then
				var26_40 = true
			elseif var27_40 == var14_0 and table.contains(arg0_40.returnSkins, arg1_40.id) then
				var26_40 = true
			else
				local var28_40 = arg0_40:GetShopTypeIdBySkinId(var8_40)

				var26_40 = (var28_40 == 0 and var16_0 or var28_40) == var27_40
			end

			if var26_40 then
				break
			end
		end

		if not var26_40 then
			return false
		end
	end

	if var7_40[1] ~= 0 then
		local var29_40 = false
		local var30_40 = table.contains(arg0_40.returnSkins, arg1_40.id)
		local var31_40 = NewShopSkinCard.GetTagId(arg1_40, var30_40)

		if table.keyof(var7_40, var31_40) then
			return true
		else
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_41, arg1_41)
	if not arg0_41.vship then
		arg0_41.vship = {}

		function arg0_41.vship.getNation()
			return arg0_41.vship.config.nationality
		end

		function arg0_41.vship.getShipType()
			return arg0_41.vship.config.type
		end

		function arg0_41.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_41.vship.config.type)
		end

		function arg0_41.vship.getRarity()
			return arg0_41.vship.config.rarity
		end
	end

	arg0_41.vship.config = arg1_41

	return arg0_41.vship
end

function var0_0.ExitSkinExperienceItem(arg0_46, arg1_46)
	if not arg0_46.cacheSkinExperienceItems then
		arg0_46.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(arg0_46.cacheSkinExperienceItems, function(arg0_47)
		return arg0_47:CanUseForShop(arg1_46)
	end)
end

function var0_0.RegisterEvent(arg0_48)
	arg0_48:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_49, arg1_49)
		arg0_48:AdjustPainting(arg1_49)
		setActive(arg0_48.top, not arg1_49)
		setActive(arg0_48.bottom, not arg1_49)
		setActive(arg0_48.right, not arg1_49)

		if arg0_48.live2dChar then
			arg0_48.live2dChar:setPurchaseOffset(arg1_49)
		end

		if arg0_48.spineChar then
			if arg1_49 then
				local var0_49 = pg.ship_skin_template[arg0_48.skinId].purchase_offset

				if var0_49 and #var0_49 >= 3 then
					arg0_48.spineChar:SetLocalPosition(Vector3(var0_49[1], var0_49[2], var0_49[3]))
				end

				if var0_49 and #var0_49 >= 4 then
					arg0_48.spineChar:SetLocalScale(Vector3(var0_49[4], var0_49[4], var0_49[4]))
				end
			else
				arg0_48.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
				arg0_48.spineChar:SetLocalPosition(Vector3(0, 0, 0))
			end
		end

		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg1_49)
	end)
	arg0_48:bind(var0_0.EVT_ON_PURCHASE, function(arg0_50, arg1_50)
		local var0_50 = arg0_48:GetObtainBtnState(arg1_50)

		arg0_48:OnClickBtn(var0_50, arg1_50)
	end)
	onButton(arg0_48, arg0_48.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_48.skinId) then
			arg0_48.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_48.skinId)

			arg0_48:UpdateMainView(arg0_48.showingCommodity)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_52, arg1_52)
	local var0_52 = NewShopSkinCard.New(arg1_52)

	onButton(arg0_52, var0_52._go, function()
		if not var0_52.commodity then
			return
		end

		for iter0_53, iter1_53 in pairs(arg0_52.cards) do
			iter1_53:UpdateSelected(false)
		end

		arg0_52.selectedId = var0_52.commodity.id

		var0_52:UpdateSelected(true)
		arg0_52:UpdateMainView(var0_52.commodity)
		arg0_52:GCHandle()
	end, SFX_PANEL)

	arg0_52.cards[arg1_52] = var0_52
end

function var0_0.OnUpdateItem(arg0_54, arg1_54, arg2_54)
	local var0_54 = arg0_54.cards[arg2_54]

	if not var0_54 then
		arg0_54:OnInitItem(arg2_54)

		var0_54 = arg0_54.cards[arg2_54]
	end

	local var1_54 = arg0_54.displays[arg1_54 + 1]

	if not var1_54 then
		return
	end

	local var2_54 = arg0_54.selectedId == var1_54.id
	local var3_54 = table.contains(arg0_54.returnSkins, var1_54.id)

	var0_54:Update(var1_54, var2_54, var3_54)

	if arg0_54.pendingSelectId and arg0_54.pendingSelectId == var1_54.id then
		arg0_54.pendingSelectId = nil

		triggerButton(var0_54._go)
	end

	if arg0_54.triggerFirstCard and arg1_54 == 0 then
		arg0_54.triggerFirstCard = false

		triggerButton(var0_54._go)
	end
end

function var0_0.UpdateMainView(arg0_55, arg1_55)
	arg0_55.mainViewToken = (arg0_55.mainViewToken or 0) + 1

	local var0_55 = arg0_55.mainViewToken
	local var1_55 = var23_0(arg1_55:getSkinId())

	SplitPackConst.DownloadByLuaArr(var1_55, function()
		if arg0_55.exited or var0_55 ~= arg0_55.mainViewToken then
			return
		end

		arg0_55:RefreshMainView(arg1_55)
	end)
end

function var0_0.RefreshMainView(arg0_57, arg1_57)
	arg0_57.skinId = arg1_57:getSkinId()

	local var0_57 = ShipSkin.IsChangeSkin(arg0_57.skinId)

	setActive(arg0_57.changeSkin, var0_57)

	if var0_57 then
		arg0_57:FlushChangeSkin(arg1_57)
	end

	arg0_57.shipSkin = ShipSkin.New({
		id = arg0_57.skinId
	})

	arg0_57:FlushName()
	arg0_57:FlushPreviewBtn(arg1_57)
	arg0_57:FlushTimeLimit(arg1_57)
	arg0_57:SwitchPreview(arg1_57, arg0_57.isPreviewFurniture)
	arg0_57:FlushPaintingToggle(arg1_57)
	arg0_57:FlushTag()
	arg0_57:FlushBG(arg1_57)
	arg0_57:FlushPainting(arg1_57)
	arg0_57:FlushPrice(arg1_57)
	arg0_57:FlushObtainBtn(arg1_57)
	arg0_57:FlushGifgPackBtn(arg1_57)

	arg0_57.showingCommodity = arg1_57
end

function var0_0.FlushChangeSkin(arg0_58, arg1_58)
	local var0_58 = ShipSkin.GetChangeSkinGroupId(arg0_58.skinId)
	local var1_58 = ShipSkin.GetChangeSkinCustomDataId(arg0_58.skinId, "hide_shop")
	local var2_58 = pg.gameset.changeskin_switch_block
	local var3_58 = false
	local var4_58 = false
	local var5_58 = arg0_58.changeSkinToggle:IsAsmrSkin() and true or false

	if var2_58 and var2_58.description then
		local var6_58 = var2_58.description

		if table.contains(var6_58, var0_58) and HXSet.isHx() then
			var4_58 = true
		end
	end

	if var1_58 and var1_58 == 1 then
		var3_58 = true
	end

	if not arg0_58.changeSkinId then
		arg0_58.changeSkinId = arg0_58.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_58.changeSkinId) == var0_58 then
		arg0_58.skinId = arg0_58.changeSkinId
	else
		arg0_58.changeSkinId = arg0_58.skinId
	end

	arg0_58.changeSkinToggle:setSkinData(arg0_58.skinId)

	if var3_58 or var4_58 or var5_58 then
		setActive(arg0_58.changeSkin, false)
	else
		setActive(arg0_58.changeSkin, true)
	end
end

function var0_0.GCHandle(arg0_59)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.FlushName(arg0_60)
	local var0_60 = pg.ship_skin_template[arg0_60.skinId]

	setScrollText(arg0_60.skinName, SwitchSpecialChar(var0_60.name, true))

	if var0_60.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_60.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_60.skinId)))
	else
		local var1_60 = ShipGroup.getDefaultShipConfig(var0_60.ship_group)

		setScrollText(arg0_60.shipName, var1_60.name)
	end
end

function var0_0.FlushPreviewBtn(arg0_61, arg1_61)
	local var0_61 = Goods.ExistFurniture(arg1_61.id)

	removeOnButton(arg0_61.switchPreviewBtn)

	if not var0_61 and arg0_61.isPreviewFurniture then
		arg0_61.isPreviewFurniture = false
	end

	setActive(arg0_61.switchPreviewBtn, var0_61)

	if var0_61 then
		onButton(arg0_61, arg0_61.switchPreviewBtn, function()
			arg0_61.isPreviewFurniture = not arg0_61.isPreviewFurniture

			arg0_61:SwitchPreview(arg1_61, arg0_61.isPreviewFurniture)
			arg0_61:FlushPrice(arg1_61)
			arg0_61:FlushObtainBtn(arg1_61)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPreview(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg0_63.skinId

	if pg.ship_skin_template[var0_63].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_63.charContainer, false)

		return
	end

	local var1_63 = getProxy(PlayerProxy):getRawData().id

	setActive(arg0_63.charContainer, PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var1_63, 0) == 1)
	setActive(arg0_63.charTf, not arg2_63)
	setActive(arg0_63.furnitureContainer, arg2_63)

	if not arg2_63 then
		local var2_63 = pg.ship_skin_template[var0_63]

		arg0_63:FlushChar(var2_63.prefab, var2_63.id)
		GetImageSpriteFromAtlasAsync("qicon/" .. var2_63.painting, "", arg0_63.backChara)
	else
		local var3_63 = Goods.Id2FurnitureId(arg1_63.id)
		local var4_63 = Goods.GetFurnitureConfig(arg1_63.id)

		arg0_63.interactionPreview:Flush(var0_63, var3_63, var4_63.scale[2] or 1, var4_63.position[2])
	end
end

function var0_0.FlushChar(arg0_64, arg1_64, arg2_64)
	if arg0_64.prefabName and arg0_64.prefabName == arg1_64 then
		return
	end

	arg0_64:ReturnChar()

	arg0_64.prefabName = arg1_64

	local var0_64 = SpineAnimChar.New()

	var0_64:SetPaint(arg1_64)
	var0_64:Load(true, function(arg0_65)
		if arg0_64.prefabName ~= arg1_64 then
			arg0_65:Dispose()

			return
		end

		arg0_64.spineChar = arg0_65

		local var0_65 = pg.skinshop_spine_scale[arg2_64]

		if var0_65 then
			arg0_64.spineChar:SetLocalScale(Vector3(var0_65.skinshop_scale, var0_65.skinshop_scale, 1))
		else
			arg0_64.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
		end

		arg0_64.spineChar:SetLocalPosition(Vector3(0, 0, 0))
		arg0_64.spineChar:SetLayer(Layer.UI)
		arg0_64.spineChar:SetParent(arg0_64.charTf)
		arg0_64.spineChar:SetAction("normal", 0)
	end)
end

function var0_0.ReturnChar(arg0_66)
	if arg0_66.spineChar then
		arg0_66.spineChar:Dispose()

		arg0_66.spineChar = nil
		arg0_66.prefabName = nil
	end
end

function var0_0.ClearCards(arg0_67)
	if not arg0_67.cards then
		return
	end

	for iter0_67, iter1_67 in pairs(arg0_67.cards) do
		iter1_67:Dispose()
	end

	arg0_67.cards = nil
end

function var0_0.FlushTimeLimit(arg0_68, arg1_68)
	local var0_68 = arg0_68.skinId
	local var1_68 = false
	local var2_68

	if arg1_68:IsActivityExtra() and arg1_68:ShowMaintenanceTime() then
		local var3_68, var4_68 = arg1_68:GetMaintenanceMonthAndDay()

		function var2_68()
			return i18n("limit_skin_time_before_maintenance", var3_68, var4_68)
		end

		var1_68 = true
	elseif arg1_68:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_68 = getProxy(ShipSkinProxy):getSkinById(var0_68)

		var1_68 = var5_68 and var5_68:isExpireType() and not var5_68:isExpired()

		if var1_68 then
			function var2_68()
				return skinTimeStamp(var5_68:getRemainTime())
			end
		end
	else
		local var6_68, var7_68 = pg.TimeMgr.GetInstance():inTime(arg1_68:getConfig("time"))

		var1_68 = var7_68

		if var1_68 then
			local var8_68 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_68)

			function var2_68()
				return skinCommdityTimeStamp(var8_68)
			end
		end
	end

	setActive(arg0_68.top:Find("title/limit_time"), var1_68)
	arg0_68:ClearTimer()

	if var1_68 then
		arg0_68:AddTimer(var2_68)
	end
end

function var0_0.AddTimer(arg0_72, arg1_72)
	arg0_72.timer = Timer.New(function()
		setText(arg0_72.limitTime, arg1_72())
	end, 1, -1)

	arg0_72.timer.func()
	arg0_72.timer:Start()
end

function var0_0.ClearTimer(arg0_74)
	if arg0_74.timer then
		arg0_74.timer:Stop()

		arg0_74.timer = nil
	end
end

function var0_0.FlushPaintingToggle(arg0_75, arg1_75)
	removeOnToggle(arg0_75.dynamicToggle)
	removeOnToggle(arg0_75.showBgToggle)

	local var0_75 = checkABExist("painting/" .. arg0_75.shipSkin:getConfig("painting") .. "_n")

	if arg0_75.isToggleShowBg and not var0_75 then
		triggerToggle(arg0_75.showBgToggle, false)

		arg0_75.isToggleShowBg = false
	elseif var0_75 then
		triggerToggle(arg0_75.showBgToggle, true)

		arg0_75.isToggleShowBg = true
	end

	local var1_75 = arg0_75.shipSkin:IsSpine() or arg0_75.shipSkin:IsLive2d() or arg0_75.shipSkin:IsSpinePlus() or arg0_75.shipSkin:IsLive2dPlus()
	local var2_75 = arg0_75.shipSkin:IsHxDynamicPreview()

	if var1_75 and not var2_75 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_75.isToggleDynamic = true
	end

	if var1_75 then
		local var3_75 = 0

		if arg0_75.shipSkin:IsSpine() then
			var3_75 = 6
		elseif arg0_75.shipSkin:IsLive2d() then
			var3_75 = 1
		elseif arg0_75.shipSkin:IsSpinePlus() then
			var3_75 = 7
		elseif arg0_75.shipSkin:IsLive2dPlus() then
			var3_75 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_75) .. "_off", arg0_75.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_75), arg0_75.dynamicToggle:Find("select"))
	end

	if var2_75 and arg0_75.isToggleDynamic then
		triggerToggle(arg0_75.dynamicToggle, false)

		arg0_75.isToggleDynamic = false
	end

	if arg0_75.isToggleDynamic and not var1_75 then
		triggerToggle(arg0_75.dynamicToggle, false)

		arg0_75.isToggleDynamic = false
	elseif arg0_75.isToggleDynamic and not arg0_75.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_75.shipSkin:IsLive2d() or arg0_75.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_75.isToggleDynamic = false

			local var4_75 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4_75, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_75.dynamicToggle, false)
		else
			triggerToggle(arg0_75.dynamicToggle, true)

			arg0_75.isToggleDynamic = true
		end
	end

	if var0_75 then
		onToggle(arg0_75, arg0_75.showBgToggle, function(arg0_76)
			arg0_75.isToggleShowBg = arg0_76

			arg0_75:FlushPainting(arg1_75)
			arg0_75:FlushBG(arg1_75)
		end, SFX_PANEL)
	end

	if arg0_75.shipSkin:IsSpine() or arg0_75.shipSkin:IsLive2d() or arg0_75.shipSkin:IsSpinePlus() or arg0_75.shipSkin:IsLive2dPlus() then
		onToggle(arg0_75, arg0_75.dynamicToggle, function(arg0_77)
			local var0_77 = arg0_75.shipSkin:IsHxDynamicPreview()

			if arg0_77 and var0_77 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("shop_tag_control_tip"))
				triggerToggle(arg0_75.dynamicToggle, false)
				setActive(arg0_75.dynamicResToggle, false)

				return
			end

			if arg0_77 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_75.shipSkin:IsLive2d() or arg0_75.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_75.dynamicToggle, false)

				return
			end

			arg0_75.isToggleDynamic = arg0_77

			setActive(arg0_75.showBgToggle, not arg0_77 and var0_75)
			arg0_75:FlushPainting(arg1_75)
			arg0_75:FlushDynamicPaintingResState(arg1_75)
			arg0_75:RecordFlag(arg0_77)
		end, SFX_PANEL)
	end

	setActive(arg0_75.dynamicIcon, true)

	if arg0_75.isToggleDynamic then
		arg0_75:FlushDynamicPaintingResState(arg1_75)
	elseif var2_75 then
		setActive(arg0_75.dynamicResToggle, false)
		setActive(arg0_75.dynamicIcon, false)
	end

	setActive(arg0_75.dynamicToggle, var1_75)
	setActive(arg0_75.showBgToggle, not arg0_75.isToggleDynamic and var0_75)
end

function var0_0.FlushTag(arg0_78)
	local var0_78 = arg0_78.skinId
	local var1_78 = pg.ship_skin_template[var0_78]
	local var2_78 = Clone(var1_78.tag)
	local var3_78 = false

	for iter0_78 = #var2_78, 1, -1 do
		local var4_78 = var2_78[iter0_78]

		if var4_78 == 1 or var4_78 == 6 or var4_78 == 7 or var4_78 == 9 then
			local var5_78 = true

			table.remove(var2_78, iter0_78)
		end
	end

	local var6_78 = checkABExist("painting/" .. arg0_78.shipSkin:getConfig("painting") .. "_n")

	arg0_78.tagList:make(function(arg0_79, arg1_79, arg2_79)
		if arg0_79 == UIItemList.EventUpdate then
			local var0_79 = var2_78[arg1_79 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_78[arg1_79 + 1]), function(arg0_80)
				if arg0_78.exited then
					return
				end

				arg2_79:GetComponent(typeof(Image)).sprite = arg0_80
			end)
		end
	end)
	setActive(arg0_78.adapt:Find("right/functionsAndTags/tags"), #var2_78 > 0)
	arg0_78.tagList:align(#var2_78)
end

function var0_0.FlushPainting(arg0_81, arg1_81)
	local var0_81 = arg0_81:GetPaintingState(arg1_81)
	local var1_81 = pg.ship_skin_template[arg0_81.skinId].painting
	local var2_81 = ShipSkin.GetChangeSkinData(arg0_81.skinId) and true or false

	if var0_81 == var2_0 and not arg0_81:ExistL2dRes(var1_81) or var0_81 == var3_0 and not arg0_81:ExistSpineRes(var1_81) then
		var0_81 = var1_0
	end

	if arg0_81.paintingState and arg0_81.paintingState.state == var0_81 and arg0_81.paintingState.id == arg1_81.id and arg0_81.paintingState.showBg == arg0_81.isToggleShowBg and arg0_81.paintingState.purchaseFlag == arg1_81.buyCount and not var2_81 then
		return
	end

	arg0_81:ClearPainting()

	if var0_81 == var1_0 then
		arg0_81:LoadMeshPainting(arg1_81, arg0_81.isToggleShowBg)
	elseif var0_81 == var2_0 then
		arg0_81:LoadL2dPainting(arg1_81)
	elseif var0_81 == var3_0 then
		arg0_81:LoadSpinePainting(arg1_81)
	end

	arg0_81.paintingState = {
		state = var0_81,
		id = arg1_81.id,
		showBg = arg0_81.isToggleShowBg,
		purchaseFlag = arg1_81.buyCount
	}

	arg0_81:AdjustPainting(false)
end

function var0_0.ClearPainting(arg0_82)
	local var0_82 = arg0_82.paintingState

	if not var0_82 then
		return
	end

	if var0_82.state == var1_0 then
		arg0_82:ClearMeshPainting()
	elseif var0_82.state == var2_0 then
		arg0_82:ClearL2dPainting()
	elseif var0_82.state == var3_0 then
		arg0_82:ClearSpinePainting()
	end

	arg0_82.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_83, arg1_83, arg2_83)
	local var0_83 = findTF(arg0_83.paintingTF, "fitter")
	local var1_83 = GetOrAddComponent(var0_83, "PaintingScaler")

	var1_83.FrameName = "chuanwu"
	var1_83.Tween = 1

	local var2_83 = pg.ship_skin_template[arg0_83.skinId].painting
	local var3_83 = var2_83

	if not arg2_83 and checkABExist("painting/" .. var2_83 .. "_n") then
		var2_83 = var2_83 .. "_n"
	end

	if not checkABExist("painting/" .. var2_83) then
		return
	end

	if PLATFORM_CODE == PLATFORM_CH and checkABExist("painting/" .. var2_83 .. "_shop") then
		var2_83 = var2_83 .. "_shop"
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_83, true, function(arg0_84)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_84, var0_83, false)
		ShipExpressionHelper.SetExpression(var0_83:GetChild(0), var3_83)

		arg0_83.paintingName = var2_83

		if arg0_83.paintingState and arg0_83.paintingState.id ~= arg1_83.id then
			arg0_83:ClearMeshPainting()
		end

		local var0_84 = arg0_84.transform:Find("shop_hx")

		arg0_83:CheckShowShopHx(var0_84)

		local var1_84 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_84 = arg0_84.transform:Find("shop_hx_ch" .. var1_84)

		arg0_83:CheckShowShopHx(var2_84)
	end)
end

function var0_0.ClearMeshPainting(arg0_85)
	local var0_85 = arg0_85.paintingTF:Find("fitter")

	if arg0_85.paintingName and var0_85.childCount > 0 then
		local var1_85 = var0_85:GetChild(0).gameObject
		local var2_85 = var1_85.transform:Find("shop_hx")

		arg0_85:RevertShopHx(var2_85)
		PoolMgr.GetInstance():ReturnPainting(arg0_85.paintingName, var1_85)
	end

	arg0_85.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_86, arg1_86)
	local var0_86 = arg0_86.skinId
	local var1_86 = pg.ship_skin_template[var0_86].skin_type
	local var2_86

	if var1_86 == ShipSkin.SKIN_TYPE_TB then
		var2_86 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_86))
	else
		local var3_86 = pg.ship_skin_template[var0_86].ship_group
		local var4_86 = ShipGroup.getDefaultShipConfig(var3_86)

		var2_86 = Ship.New({
			noChangeSkin = true,
			configId = var4_86.id,
			skin_id = var0_86
		})
	end

	local var5_86 = Live2DPainting.GenerateData({
		ship = var2_86,
		position = Vector3(0, 0, -1),
		parent = arg0_86.live2dContainer,
		offset = var2_86:GetSkinConfig().shop_offset
	})

	var5_86.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_86.live2dChar = Live2DPainting.New(var5_86, function(arg0_87)
		arg0_87:IgonreReactPos(true)
		arg0_86:CheckShowShopHxForL2d(arg0_87, arg1_86)

		if arg0_86.paintingState and arg0_86.paintingState.id ~= arg1_86.id then
			arg0_86:ClearL2dPainting()
		end

		arg0_87:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_88)
	if arg0_88.live2dChar then
		arg0_88:RevertShopHxForL2d(arg0_88.live2dChar)
		arg0_88.live2dChar:Dispose()

		arg0_88.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_89, arg1_89)
	local var0_89 = arg0_89.skinId
	local var1_89 = pg.ship_skin_template[var0_89].skin_type
	local var2_89

	if var1_89 == ShipSkin.SKIN_TYPE_TB then
		var2_89 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_89))
	else
		local var3_89 = pg.ship_skin_template[var0_89].ship_group
		local var4_89 = ShipGroup.getDefaultShipConfig(var3_89)

		var2_89 = Ship.New({
			noChangeSkin = true,
			configId = var4_89.id,
			skin_id = var0_89
		})
	end

	local var5_89 = SpinePainting.GenerateData({
		ship = var2_89,
		position = Vector3(0, 0, 0),
		parent = arg0_89.spTF,
		effectParent = arg0_89.spBg,
		offset = var2_89:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_89.spinePainting = SpinePainting.New(var5_89, function(arg0_90)
		arg0_90:SetShopHx(true)

		if arg0_89.paintingState and arg0_89.paintingState.id ~= arg1_89.id then
			arg0_89:ClearSpinePainting()
		end

		local var0_90 = arg0_90._tf:Find("shop_hx")

		arg0_89:CheckShowShopHx(var0_90)

		local var1_90 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_90 = arg0_90._tf:Find("shop_hx_ch" .. var1_90)

		arg0_89:CheckShowShopHx(var2_90)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_91)
	if arg0_91.spinePainting and arg0_91.spinePainting._tf then
		local var0_91 = arg0_91.spinePainting._tf:Find("shop_hx")

		arg0_91:RevertShopHx(arg0_91.shopHx)
		arg0_91.spinePainting:Dispose()

		arg0_91.spinePainting = nil
	end
end

function var0_0.CheckShowShopHx(arg0_92, arg1_92)
	if IsNil(arg1_92) then
		return
	end

	setActive(arg1_92, false)

	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	setActive(arg1_92, true)
end

function var0_0.RevertShopHx(arg0_93, arg1_93)
	if not IsNil(arg1_93) then
		setActive(arg1_93, false)
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_94, arg1_94, arg2_94)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_94 = 1

	arg1_94:changeParamaterValue("shop_hx", var0_94)
end

function var0_0.RevertShopHxForL2d(arg0_95, arg1_95)
	arg1_95:changeParamaterValue("shop_hx", 0)
end

function var0_0.AdjustPainting(arg0_96, arg1_96)
	local var0_96 = arg0_96.paintingTF
	local var1_96 = pg.ship_skin_newmainui_shift[arg0_96.skinId]

	if var1_96 then
		local var2_96 = var1_96.skin_shop_shift

		if arg1_96 then
			var0_96.anchoredPosition = Vector2(var2_96[1] - 440, var2_96[2] + arg0_96.defaultPaintingPosition.y)
		else
			var0_96.anchoredPosition = Vector2(var2_96[1] + arg0_96.defaultPaintingPosition.x, var2_96[2] + arg0_96.defaultPaintingPosition.y)
		end

		local var3_96 = var2_96[4]

		var0_96.localScale = Vector3(var3_96, var3_96, 1)
	else
		var0_96.anchoredPosition = Vector2(arg0_96.defaultPaintingPosition.x, arg0_96.defaultPaintingPosition.y)
		var0_96.localScale = arg0_96.defaultPaintingScale
	end
end

function var0_0.FlushBG(arg0_97, arg1_97, arg2_97)
	local var0_97 = arg0_97.skinId
	local var1_97 = pg.ship_skin_template[var0_97]
	local var2_97

	if var1_97.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_97 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_97))
	else
		local var3_97 = ShipGroup.getDefaultShipConfig(var1_97.ship_group)

		var2_97 = Ship.New({
			id = 999,
			configId = var3_97.id,
			skin_id = var0_97
		})
	end

	local var4_97 = var2_97:getShipBgPrint(true)
	local var5_97 = pg.ship_skin_template[var0_97].painting

	if (arg0_97.isToggleShowBg or not checkABExist("painting/" .. var5_97 .. "_n")) and var1_97.bg_sp ~= "" then
		var4_97 = var1_97.bg_sp
	end

	local var6_97 = var4_97 ~= var2_97:rarity2bgPrintForGet()

	if var6_97 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_97, var4_97, arg0_97.bgs:Find("diffBg"), arg0_97.bgs:Find("diffBg/bg"), function(arg0_98)
			if arg2_97 then
				arg2_97()
			end
		end, function(arg0_99)
			if arg2_97 then
				arg2_97()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_97:getUIName())

		if arg2_97 then
			arg2_97()
		end
	end

	setActive(arg0_97.bgs:Find("diffBg"), var6_97)
	setActive(arg0_97.bgs:Find("default"), not var6_97)
end

function var0_0.FlushDynamicPaintingResState(arg0_100, arg1_100)
	if not arg0_100.isToggleDynamic then
		return
	end

	local var0_100 = arg0_100:GetPaintingState(arg1_100)
	local var1_100 = false
	local var2_100 = ""
	local var3_100 = pg.ship_skin_template[arg0_100.skinId].painting

	if var2_0 == var0_100 then
		var1_100, var2_100 = arg0_100:ExistL2dRes(var3_100)
	elseif var3_0 == var0_100 then
		var1_100, var2_100 = arg0_100:ExistSpineRes(var3_100)
	end

	setActive(arg0_100.dynamicResToggle, not var1_100)
	removeOnButton(arg0_100.dynamicResToggle)

	if not var1_100 and var2_100 ~= "" then
		onButton(arg0_100, arg0_100.dynamicResToggle, function()
			arg0_100:DownloadDynamicPainting(var2_100, arg1_100)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg0_102.skinId

	if arg0_102.downloads[var0_102] then
		return
	end

	local var1_102 = SkinShopDownloadRequest.New()

	arg0_102.downloads[var0_102] = var1_102

	var1_102:Start(arg1_102, function(arg0_103)
		if arg0_103 and arg0_102.paintingState and arg0_102.paintingState.id == arg2_102.id then
			arg0_102:FlushPainting(arg2_102)
			arg0_102:FlushDynamicPaintingResState(arg2_102)
		end

		var1_102:Dispose()

		arg0_102.downloads[var0_102] = nil
	end)
end

function var0_0.GetPaintingState(arg0_104, arg1_104)
	if arg0_104.isToggleDynamic and (arg0_104.shipSkin:IsLive2d() or arg0_104.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_104.isToggleDynamic and (arg0_104.shipSkin:IsSpine() or arg0_104.shipSkin:IsSpinePlus()) then
		if arg0_104.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_105, arg1_105)
	local var0_105 = "live2d/" .. string.lower(arg1_105)
	local var1_105 = HXSet.autoHxShiftPath(var0_105, nil, true)

	return checkABExist(var1_105), var1_105
end

function var0_0.ExistSpineRes(arg0_106, arg1_106)
	local var0_106 = "SpinePainting/" .. string.lower(arg1_106)
	local var1_106 = HXSet.autoHxShiftPath(var0_106, nil, true)

	return checkABExist(var1_106), var1_106
end

function var0_0.RecordFlag(arg0_107, arg1_107)
	local var0_107 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_107, arg1_107 and 1 or 0)
	PlayerPrefs.Save()
	arg0_107:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_107)
end

function var0_0.FlushPrice(arg0_108, arg1_108)
	local var0_108 = arg1_108:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_108 = arg1_108.type == Goods.TYPE_ACTIVITY or arg1_108.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_108 then
		if arg0_108.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_108:UpdateExperiencePrice4Item(arg1_108)
		else
			arg0_108:UpdateExperiencePrice(arg1_108)
		end
	elseif arg0_108.isPreviewFurniture then
		arg0_108:UpdateFurniturePrice(arg1_108)
	elseif var1_108 then
		-- block empty
	else
		arg0_108:UpdateCommodityPrice(arg1_108)
	end

	local var2_108 = arg1_108.type == Goods.TYPE_SKIN

	setActive(arg0_108.price:Find("timeLimit"), var0_108 and not var1_108)
	setActive(arg0_108.price:Find("normal/consume"), var2_108 and not var0_108 and not var1_108)
end

function var0_0.UpdateExperiencePrice4Item(arg0_109, arg1_109)
	local var0_109 = arg1_109:getConfig("resource_num")
	local var1_109 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_109 = _.detect(var1_109, function(arg0_110)
		return arg0_110:CanUseForShop(arg1_109.id)
	end)
	local var3_109 = var2_109 and var2_109.count or 0
	local var4_109 = (var3_109 < var0_109 and "<color=" .. COLOR_RED .. ">" or "") .. var3_109 .. (var3_109 < var0_109 and "</color>" or "")

	setText(arg0_109.price:Find("timeLimit/consume/Text"), var4_109 .. "/" .. var0_109)
end

function var0_0.UpdateExperiencePrice(arg0_111, arg1_111)
	local var0_111 = arg1_111:getConfig("resource_num")
	local var1_111 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_111 = (var1_111 < var0_111 and "<color=" .. COLOR_RED .. ">" or "") .. var1_111 .. (var1_111 < var0_111 and "</color>" or "")

	setText(arg0_111.price:Find("timeLimit/consume/Text"), var2_111 .. "/" .. var0_111)
end

function var0_0.UpdateCommodityPrice(arg0_112, arg1_112)
	local var0_112 = arg1_112:GetPrice()
	local var1_112 = arg1_112:getConfig("resource_num")

	setText(arg0_112.price:Find("normal/consume/Text"), var0_112)
	setText(arg0_112.price:Find("normal/consume/originalprice/Text"), var1_112)
	setActive(arg0_112.price:Find("normal/consume/originalprice"), var0_112 ~= var1_112)
end

function var0_0.UpdateFurniturePrice(arg0_113, arg1_113)
	local var0_113 = Goods.Id2FurnitureId(arg1_113.id)
	local var1_113 = Furniture.New({
		id = var0_113
	})
	local var2_113 = var1_113:getConfig("gem_price")

	setText(arg0_113.price:Find("normal/consume/originalprice/Text"), var2_113)

	local var3_113 = var1_113:getPrice(PlayerConst.ResDiamond)

	setText(arg0_113.price:Find("normal/consume/Text"), var3_113)
	setActive(arg0_113.price:Find("normal/consume/originalprice"), var2_113 ~= var3_113)
end

local function var25_0(arg0_114, arg1_114)
	if arg0_114 == var6_0 or arg0_114 == var9_0 or arg0_114 == var8_0 then
		return false
	end

	local var0_114 = arg1_114:getSkinId()

	return getProxy(ShopsProxy):CanPurchasedByCharge(var0_114)
end

function var0_0.UpdateChargeView(arg0_115, arg1_115, arg2_115, arg3_115)
	local var0_115 = arg1_115 == var4_0
	local var1_115 = arg0_115.btnsList[2]

	setActive(var1_115:Find("buy_charge"), not var0_115)

	local var2_115 = pg.pay_data_display[arg3_115]

	assert(var2_115, "pay_data_display>>>>>>>>>>>>>" .. arg3_115)

	local var3_115 = GetMoneySymbol() .. GetChargePrice(var2_115.money)

	setText(arg0_115.btnsList[2]:Find("buy_charge/value"), var3_115)

	local var4_115 = var1_115.parent:Find("consume")
	local var5_115 = var1_115.parent:Find("rmb")

	setText(var5_115:Find("Text"), var3_115)
	setActive(var5_115:Find("originalprice"), var2_115.cash_show > var2_115.money)
	setText(var5_115:Find("originalprice/Text"), GetChargePrice(var2_115.cash_show))

	local var6_115 = arg2_115:GetPrice()
	local var7_115 = arg2_115:getConfig("resource_num")

	setActive(var4_115:Find("originalprice"), var6_115 ~= var7_115)
	setText(var4_115:Find("Text"), var6_115)
	setText(var4_115:Find("originalprice/Text"), var7_115)
end

function var0_0.FlushObtainBtn(arg0_116, arg1_116)
	local var0_116 = arg0_116:GetObtainBtnState(arg1_116)
	local var1_116 = var19_0(var0_116)
	local var2_116, var3_116 = var25_0(var0_116, arg1_116)

	setActive(arg0_116.btnsList[1].parent, not var2_116)
	setActive(arg0_116.btnsList[2].parent, var2_116)

	local var4_116 = var2_116 and arg0_116.btnsList[2] or arg0_116.btnsList[1]

	for iter0_116 = 0, var4_116.childCount - 1 do
		local var5_116 = var4_116:GetChild(iter0_116)

		setActive(var5_116, var5_116.name == var1_116)
	end

	if var2_116 then
		arg0_116:UpdateChargeView(var0_116, arg1_116, var3_116)
	end

	setActive(arg0_116.price:Find("btn_charge"), var2_116 and var0_116 ~= var4_0)
	setActive(arg0_116.price:Find("btn/item"), var0_116 == var11_0)
	setActive(arg0_116.price:Find("btn/tag"), var0_116 == var11_0)

	if var0_116 == var11_0 then
		arg0_116:FlushGift(arg1_116)
	end

	onButton(arg0_116, arg0_116.price:Find("btn_charge"), function()
		if not var2_116 then
			return
		end

		arg0_116:OpenChargePanel(var3_116)
	end, SFX_PANEL)
	onButton(arg0_116, arg0_116.price:Find("btn"), function()
		local var0_118 = {}
		local var1_118 = SkinCouponActivity.StaticEncoreActTip(arg1_116.id)

		if tobool(var1_118) then
			table.insert(var0_118, function(arg0_119)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Hint"),
					onYes = function()
						if var1_118 and not var1_118:isEnd() then
							arg0_116:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_118.id)
						end
					end,
					onNo = arg0_119
				})
			end)
		end

		if arg1_116:getConfig("genre") == ShopArgs.SkinShop and not arg1_116:IsItemDiscountType() and #SkinCouponActivity.GetOvercountEncoreActs(arg1_116.id) > 0 then
			table.insert(var0_118, function(arg0_121)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Last_Coupon"),
					onYes = arg0_121
				})
			end)
		end

		seriesAsync(var0_118, function()
			if var0_116 == var5_0 or var0_116 == var7_0 or var0_116 == var11_0 then
				arg0_116.purchaseView:ExecuteAction("Show", arg1_116)
			else
				arg0_116:OnClickBtn(var0_116, arg1_116)
			end
		end)
	end, SFX_PANEL)
end

function var0_0.OpenChargePanel(arg0_123, arg1_123)
	local var0_123 = Goods.Create({
		shop_id = arg1_123
	}, Goods.TYPE_CHARGE)

	if ChargeConst.isNeedSetBirth() then
		arg0_123:emit(LatestSkinShopMediator.OPEN_CHARGE_BIRTHDAY)
	else
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = var0_123.id
		})
	end
end

function var0_0.GetObtainBtnState(arg0_124, arg1_124)
	if arg1_124:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_124.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_124.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_124.type == Goods.TYPE_ACTIVITY or arg1_124.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_124.buyCount > 0 then
		return var4_0
	elseif arg1_124:isDisCount() and arg1_124:IsItemDiscountType() then
		return var7_0
	elseif arg1_124:CanUseVoucherType() or arg1_124:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_124:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushGift(arg0_125, arg1_125)
	local var0_125 = arg1_125:GetGiftList()[1]

	updateDrop(arg0_125.price:Find("btn/item/mask/item"), {
		type = var0_125.type,
		id = var0_125.id,
		count = var0_125.count
	})
end

function var0_0.OnClickBtn(arg0_126, arg1_126, arg2_126)
	if arg1_126 == var5_0 or arg1_126 == var7_0 or arg1_126 == var11_0 then
		arg0_126:OnPurchase(arg2_126)
	elseif arg1_126 == var10_0 then
		arg0_126:OnItemPurchase(arg2_126)
	elseif arg1_126 == var6_0 then
		arg0_126:OnActivity(arg2_126)
	elseif arg1_126 == var8_0 then
		arg0_126:OnBackyard(arg2_126)
	elseif arg1_126 == var9_0 then
		if arg0_126.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_126:OnExperience4Item(arg2_126)
		else
			arg0_126:OnExperience(arg2_126)
		end
	end
end

function var0_0.FlushGifgPackBtn(arg0_127, arg1_127)
	local var0_127 = false
	local var1_127
	local var2_127
	local var3_127

	for iter0_127, iter1_127 in pairs(arg0_127.giftSkinCommodities) do
		for iter2_127, iter3_127 in ipairs(iter1_127) do
			if iter3_127.id == arg1_127.id then
				var0_127 = true

				break
			end
		end

		if var0_127 then
			var1_127 = arg0_127.giftPackCommodities[iter0_127]
			var2_127 = arg0_127.giftSkinCommodities[iter0_127]
			var3_127 = arg0_127.giftSkinProbabilitys[iter0_127]

			break
		end
	end

	if var0_127 then
		setText(arg0_127.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip_2"))
		onButton(arg0_127, arg0_127.giftPackBtn, function()
			if not var1_127:isChargeType() then
				return
			end

			local var0_128 = var1_127:GetSkinProbability()
			local var1_128 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_128)

			if #var0_128 <= 0 or #var0_128 ~= #var1_128 then
				arg0_127:emit(LatestSkinShopMediator.OPEN_SCENE, {
					SCENE.CHARGE,
					{
						wrap = ChargeScene.TYPE_PICK
					}
				})
			else
				arg0_127:emit(LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER, var1_127, var2_127, var3_127)
			end
		end, SFX_PANEL)
	else
		var0_127 = getProxy(ActivityProxy):GetFakeGiftPackActivity(arg1_127)

		if var0_127 then
			setText(arg0_127.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip"))
			onButton(arg0_127, arg0_127.giftPackBtn, function()
				arg0_127:emit(LatestSkinShopMediator.OPEN_GIFT_ACT_LAYER, var0_127.id)
			end, SFX_PANEL)
		end
	end

	setActive(arg0_127.giftPackBtn, var0_127)
end

function var0_0.SetGiftPackLayer(arg0_130)
	return
end

function var0_0.OnPurchase(arg0_131, arg1_131)
	if arg1_131.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_131:isDisCount() and arg1_131:IsItemDiscountType() then
		arg0_131:emit(LatestSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_131.id, 1)
	else
		arg0_131:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_131.id, 1)
	end
end

function var0_0.OnItemPurchase(arg0_132, arg1_132)
	if arg1_132.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_132 = arg1_132:GetVoucherIdList()
	local var1_132 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_132.id)

	if #var0_132 <= 0 and #var1_132 <= 0 then
		return
	end

	local var2_132 = {}

	for iter0_132, iter1_132 in ipairs(var0_132) do
		table.insert(var2_132, iter1_132)
	end

	for iter2_132, iter3_132 in ipairs(var1_132) do
		table.insert(var2_132, iter3_132.id)
	end

	local var3_132 = arg0_132.skinId
	local var4_132 = pg.ship_skin_template[var3_132]
	local var5_132 = SwitchSpecialChar(var4_132.name, true)

	arg0_132.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_132,
		skinId = var3_132,
		skinName = var5_132,
		price = arg1_132:GetPrice(),
		onYes = function(arg0_133)
			if arg0_133 then
				arg0_132:emit(LatestSkinShopMediator.ON_ITEM_PURCHASE, arg0_133, arg1_132.id)
			else
				arg0_132:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_132.id, 1)
			end
		end
	})
end

function var0_0.OnActivity(arg0_134, arg1_134)
	local var0_134 = arg1_134:getConfig("time")
	local var1_134 = arg1_134:getConfig("activity")
	local var2_134 = getProxy(ActivityProxy):getActivityById(var1_134)

	if var1_134 == 0 and pg.TimeMgr.GetInstance():inTime(var0_134) or var2_134 and not var2_134:isEnd() then
		if arg1_134.type == Goods.TYPE_ACTIVITY then
			arg0_134:emit(LatestSkinShopMediator.GO_SHOPS_LAYER, arg1_134:getConfig("activity"))
		elseif arg1_134.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_134 = arg1_134:getConfig("scene")

			if var3_134 and #var3_134 > 0 then
				arg0_134:emit(LatestSkinShopMediator.OPEN_SCENE, var3_134)
			else
				arg0_134:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_134)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_135, arg1_135)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_135 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_135.name, var0_135.level))

		return
	end

	arg0_135:emit(LatestSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_136, arg1_136)
	local var0_136 = arg0_136.skinId
	local var1_136 = getProxy(ShipSkinProxy):getSkinById(var0_136)

	if var1_136 and not var1_136:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_136 = arg1_136:getConfig("resource_num")
	local var3_136 = arg1_136:getConfig("time_second") * var2_136
	local var4_136, var5_136, var6_136, var7_136 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_136)
	local var8_136 = pg.ship_skin_template[arg0_136.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_136, var8_136, var4_136, var5_136),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_136 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_136:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_136.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_138, arg1_138)
	local var0_138 = arg0_138.skinId
	local var1_138 = getProxy(ShipSkinProxy):getSkinById(var0_138)

	if var1_138 and not var1_138:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_138 = arg1_138:getConfig("resource_num")
	local var3_138 = arg1_138:getConfig("time_second") * var2_138
	local var4_138, var5_138, var6_138, var7_138 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_138)
	local var8_138 = pg.ship_skin_template[arg0_138.skinId].name
	local var9_138 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_138 = _.detect(var9_138, function(arg0_139)
		return arg0_139:CanUseForShop(arg1_138.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_138, var8_138, var4_138, var5_138),
		onYes = function()
			if not var10_138 or var10_138.count < var2_138 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_138:emit(LatestSkinShopMediator.ON_ITEM_EXPERIENCE, var10_138.id, arg1_138.id, 1)
		end
	})
end

function var0_0.SetFilterPanel(arg0_141)
	local var0_141 = arg0_141.filterContent:Find("own/options")
	local var1_141 = arg0_141.filterContent:Find("type/options")
	local var2_141 = arg0_141.filterContent:Find("shipHave/options")
	local var3_141 = arg0_141.filterContent:Find("camp/options")
	local var4_141 = arg0_141.filterContent:Find("rarity/options")
	local var5_141 = arg0_141.filterContent:Find("shipType/options")
	local var6_141 = arg0_141.filterContent:Find("themeType/options")
	local var7_141 = arg0_141.filterContent:Find("tag/options")

	arg0_141:SetOptionList(var3_141, ShipIndexConst.CampNames, true)
	arg0_141:SetOptionList(var4_141, ShipIndexConst.RarityNames, true)
	arg0_141:SetOptionList(var5_141, ShipIndexConst.TypeNames, true)
	arg0_141:SetOptionList(var6_141, arg0_141.classifyNames)
	arg0_141:SetSingleOptions(var0_141, "ownType")
	arg0_141:SetMultiOptions(var1_141, "typeType")
	arg0_141:SetSingleOptions(var2_141, "shipHaveType")
	arg0_141:SetMultiOptions(var3_141, "campType")
	arg0_141:SetMultiOptions(var4_141, "rarityType")
	arg0_141:SetMultiOptions(var5_141, "shipType")
	arg0_141:SetMultiOptions(var6_141, "themeType")
	arg0_141:SetMultiOptions(var7_141, "tagType")
	arg0_141:HideEmptyOptions()
	onButton(arg0_141, arg0_141.filterUI:Find("bg"), function()
		for iter0_142, iter1_142 in pairs(arg0_141.filterValues) do
			arg0_141.filterValuesTemp[iter0_142] = Clone(arg0_141.filterValues[iter0_142])
		end

		setActive(arg0_141.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_141, arg0_141.filterUI:Find("panelMask/panel/closeBtn"), function()
		for iter0_143, iter1_143 in pairs(arg0_141.filterValues) do
			arg0_141.filterValuesTemp[iter0_143] = Clone(arg0_141.filterValues[iter0_143])
		end

		setActive(arg0_141.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_141, arg0_141.filterUI:Find("panelMask/panel/bottom/ok"), function()
		for iter0_144, iter1_144 in pairs(arg0_141.filterValues) do
			arg0_141.filterValues[iter0_144] = Clone(arg0_141.filterValuesTemp[iter0_144])
		end

		setActive(arg0_141.filterUI, false)
		arg0_141:Refresh(true)
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_145)
	setActive(arg0_145.filterUI, true)

	local var0_145 = arg0_145.filterContent:Find("own/options")
	local var1_145 = arg0_145.filterContent:Find("type/options")
	local var2_145 = arg0_145.filterContent:Find("shipHave/options")
	local var3_145 = arg0_145.filterContent:Find("camp/options")
	local var4_145 = arg0_145.filterContent:Find("rarity/options")
	local var5_145 = arg0_145.filterContent:Find("shipType/options")
	local var6_145 = arg0_145.filterContent:Find("themeType/options")
	local var7_145 = arg0_145.filterContent:Find("tag/options")

	arg0_145:SetSingleOptions(var0_145, "ownType", true)
	arg0_145:SetMultiOptions(var1_145, "typeType", true)
	arg0_145:SetSingleOptions(var2_145, "shipHaveType", true)
	arg0_145:SetMultiOptions(var3_145, "campType", true)
	arg0_145:SetMultiOptions(var4_145, "rarityType", true)
	arg0_145:SetMultiOptions(var5_145, "shipType", true)
	arg0_145:SetMultiOptions(var6_145, "themeType", true)
	arg0_145:SetMultiOptions(var7_145, "tagType", true)
end

function var0_0.SetOptionList(arg0_146, arg1_146, arg2_146, arg3_146)
	local var0_146 = UIItemList.New(arg1_146, arg1_146:GetChild(0))

	var0_146:make(function(arg0_147, arg1_147, arg2_147)
		if arg0_147 == UIItemList.EventUpdate then
			local var0_147 = arg2_146[arg1_147 + 1]

			if arg3_146 then
				var0_147 = i18n(var0_147)
			end

			arg2_147.name = arg1_147

			setScrollText(arg2_147:Find("mask/Text"), var0_147)
		end
	end)
	var0_146:align(#arg2_146)
end

function var0_0.SetSingleOptions(arg0_148, arg1_148, arg2_148, arg3_148)
	for iter0_148 = 0, arg1_148.childCount - 1 do
		local var0_148 = arg1_148:GetChild(iter0_148)

		arg0_148:SetOptionSelect(arg1_148:GetChild(iter0_148), iter0_148 == arg0_148.filterValuesTemp[arg2_148])

		if not arg3_148 then
			onButton(arg0_148, var0_148, function()
				arg0_148.filterValuesTemp[arg2_148] = iter0_148

				for iter0_149 = 0, arg1_148.childCount - 1 do
					arg0_148:SetOptionSelect(arg1_148:GetChild(iter0_149), iter0_149 == iter0_148)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_150, arg1_150, arg2_150, arg3_150)
	for iter0_150 = 0, arg1_150.childCount - 1 do
		local var0_150 = arg1_150:GetChild(iter0_150)

		arg0_150:SetOptionSelect(arg1_150:GetChild(iter0_150), table.contains(arg0_150.filterValuesTemp[arg2_150], iter0_150))

		if not arg3_150 then
			onButton(arg0_150, var0_150, function()
				if iter0_150 == 0 then
					arg0_150.filterValuesTemp[arg2_150] = {
						0
					}

					for iter0_151 = 0, arg1_150.childCount - 1 do
						arg0_150:SetOptionSelect(arg1_150:GetChild(iter0_151), iter0_151 == 0)
					end
				else
					table.removebyvalue(arg0_150.filterValuesTemp[arg2_150], 0)

					if table.contains(arg0_150.filterValuesTemp[arg2_150], iter0_150) then
						table.removebyvalue(arg0_150.filterValuesTemp[arg2_150], iter0_150)
					else
						table.insert(arg0_150.filterValuesTemp[arg2_150], iter0_150)
					end

					local var0_151 = true

					for iter1_151 = 1, arg1_150.childCount - 1 do
						if not table.contains(arg0_150.filterValuesTemp[arg2_150], iter1_151) and arg1_150:GetChild(iter1_151).gameObject.activeSelf then
							var0_151 = false

							break
						end
					end

					if #arg0_150.filterValuesTemp[arg2_150] == 0 then
						var0_151 = true
					end

					if var0_151 and arg2_150 ~= "tagType" then
						arg0_150.filterValuesTemp[arg2_150] = {
							0
						}
					end

					for iter2_151 = 0, arg1_150.childCount - 1 do
						arg0_150:SetOptionSelect(arg1_150:GetChild(iter2_151), table.contains(arg0_150.filterValuesTemp[arg2_150], iter2_151))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_152, arg1_152, arg2_152)
	setActive(arg1_152:Find("selectedFrame"), arg2_152)

	local var0_152

	if IsNil(arg1_152:Find("Text")) then
		var0_152 = arg1_152:Find("mask/Text"):GetComponent(typeof(Text))
	else
		var0_152 = arg1_152:Find("Text"):GetComponent(typeof(Text))
	end

	if arg2_152 then
		var0_152.color = Color.New(1, 1, 1, 1)
	else
		var0_152.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.HideEmptyOptions(arg0_153, arg1_153, arg2_153)
	local var0_153 = {
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

	for iter0_153, iter1_153 in ipairs(arg0_153.commodities) do
		local var1_153 = iter1_153:getSkinId()
		local var2_153 = ShipSkin.New({
			id = var1_153
		})
		local var3_153 = arg0_153:GetSkinType(var2_153)

		for iter2_153, iter3_153 in ipairs(var3_153) do
			if not table.keyof(var0_153.typeType, iter3_153) then
				table.insert(var0_153.typeType, iter3_153)
			end
		end

		local var4_153 = arg0_153:GetShipHave(var2_153)

		if not table.keyof(var0_153.shipHaveType, var4_153) then
			table.insert(var0_153.shipHaveType, var4_153)
		end

		local var5_153 = arg0_153:GetCampType(var2_153)

		if not table.keyof(var0_153.campType, var5_153) then
			table.insert(var0_153.campType, var5_153)
		end

		local var6_153 = arg0_153:GetRarityType(var2_153)

		if not table.keyof(var0_153.rarityType, var6_153) then
			table.insert(var0_153.rarityType, var6_153)
		end

		local var7_153 = arg0_153:GetShipType(var2_153)

		if not table.keyof(var0_153.shipType, var7_153) then
			table.insert(var0_153.shipType, var7_153)
		end

		local var8_153 = arg0_153:GetTagType(iter1_153)

		if not table.keyof(var0_153.tagType, var8_153) then
			table.insert(var0_153.tagType, var8_153)
		end
	end

	for iter4_153, iter5_153 in pairs(var0_153) do
		table.sort(iter5_153, function(arg0_154, arg1_154)
			return arg0_154 < arg1_154
		end)
	end

	for iter6_153 = 1, arg0_153.uiTypeOptions.childCount - 1 do
		setActive(arg0_153.uiTypeOptions:GetChild(iter6_153), table.contains(var0_153.typeType, iter6_153))
	end

	for iter7_153 = 1, arg0_153.uiShipHaveOptions.childCount - 1 do
		setActive(arg0_153.uiShipHaveOptions:GetChild(iter7_153), table.contains(var0_153.shipHaveType, iter7_153))
	end

	for iter8_153 = 1, arg0_153.uiCampOptions.childCount - 1 do
		setActive(arg0_153.uiCampOptions:GetChild(iter8_153), table.contains(var0_153.campType, iter8_153))
	end

	for iter9_153 = 1, arg0_153.uiRrarityOptions.childCount - 1 do
		setActive(arg0_153.uiRrarityOptions:GetChild(iter9_153), table.contains(var0_153.rarityType, iter9_153))
	end

	for iter10_153 = 1, arg0_153.uiShipTypeOptions.childCount - 1 do
		setActive(arg0_153.uiShipTypeOptions:GetChild(iter10_153), table.contains(var0_153.shipType, iter10_153))
	end

	for iter11_153 = 1, arg0_153.uiTagTypeOptions.childCount - 1 do
		setActive(arg0_153.uiTagTypeOptions:GetChild(iter11_153), table.contains(var0_153.tagType, iter11_153))
	end
end

function var0_0.GetSkinType(arg0_155, arg1_155)
	local var0_155 = {}

	if arg1_155:IsLive2d() or arg1_155:IsLive2dPlus() then
		table.insert(var0_155, 1)
	end

	if not arg1_155:IsLive2d() and not arg1_155:IsLive2dPlus() and not arg1_155:IsSpine() and not arg1_155:IsSpinePlus() then
		table.insert(var0_155, 2)
	end

	if arg1_155:IsSpine() or arg1_155:IsSpinePlus() then
		table.insert(var0_155, 3)
	end

	if arg1_155:IsBG() then
		table.insert(var0_155, 4)
	end

	if arg1_155:IsDbg() then
		table.insert(var0_155, 5)
	end

	if arg1_155:isBgm() then
		table.insert(var0_155, 6)
	end

	return var0_155
end

function var0_0.GetShipHave(arg0_156, arg1_156)
	if arg1_156:CantUse() then
		return 2
	else
		return 1
	end
end

function var0_0.GetCampType(arg0_157, arg1_157)
	local var0_157 = arg1_157:GetDefaultShipConfig()

	if not var0_157 then
		return 0
	end

	local var1_157 = arg0_157:ToVShip(var0_157):getNation()
	local var2_157 = ShipIndexCfg.camp

	for iter0_157, iter1_157 in ipairs(var2_157) do
		for iter2_157, iter3_157 in ipairs(iter1_157.types) do
			if iter3_157 == Nation.LINK then
				if var1_157 >= Nation.LINK then
					return iter0_157 - 1
				end
			elseif var1_157 == iter3_157 then
				return iter0_157 - 1
			end
		end
	end

	return 0
end

function var0_0.GetRarityType(arg0_158, arg1_158)
	local var0_158 = arg1_158:GetDefaultShipConfig()

	if not var0_158 then
		return 0
	end

	local var1_158 = arg0_158:ToVShip(var0_158):getRarity()
	local var2_158 = ShipIndexCfg.rarity

	for iter0_158, iter1_158 in ipairs(var2_158) do
		if table.contains(iter1_158.types, var1_158) then
			return iter0_158 - 1
		end
	end

	return 0
end

function var0_0.GetShipType(arg0_159, arg1_159)
	local var0_159 = arg1_159:GetDefaultShipConfig()

	if not var0_159 then
		return 0
	end

	local var1_159 = arg0_159:ToVShip(var0_159):getShipType()
	local var2_159 = ShipIndexCfg.type

	for iter0_159, iter1_159 in ipairs(var2_159) do
		for iter2_159, iter3_159 in pairs(iter1_159) do
			if table.keyof(iter3_159, var1_159) then
				return iter0_159 - 1
			end
		end
	end

	return 0
end

function var0_0.GetTagType(arg0_160, arg1_160)
	local var0_160 = table.contains(arg0_160.returnSkins, arg1_160.id)
	local var1_160 = NewShopSkinCard.GetTagId(arg1_160, var0_160)

	if var1_160 > 0 then
		return var1_160
	else
		return 0
	end
end

function var0_0.GetSkinClassify(arg0_161)
	arg0_161.classifyIds = {}
	arg0_161.classifyNames = {}

	local var0_161 = {}
	local var1_161 = {}

	for iter0_161, iter1_161 in ipairs(arg0_161.commodities) do
		local var2_161 = arg0_161:GetShopTypeIdBySkinId(iter1_161:getSkinId())
		local var3_161 = var2_161 == 0 and var16_0 or var2_161

		var1_161[var3_161] = (var1_161[var3_161] or 0) + 1
	end

	local var4_161 = {}

	for iter2_161, iter3_161 in ipairs(arg0_161.returnSkins) do
		var4_161[iter3_161] = true
	end

	if underscore.any(arg0_161.commodities, function(arg0_162)
		return var4_161[arg0_162.id]
	end) then
		table.insert(var0_161, var14_0)
	end

	for iter4_161, iter5_161 in ipairs(pg.skin_page_template.all) do
		if iter5_161 ~= var17_0 and iter5_161 ~= var18_0 and (var1_161[iter5_161] or 0) > 0 then
			table.insert(var0_161, iter5_161)
		end
	end

	if arg0_161.mode == var0_0.MODE_EXPERIENCE then
		table.insert(var0_161, 1, var13_0)
	end

	if arg0_161.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_161, 1, var15_0)
	end

	table.insert(var0_161, 1, var12_0)

	arg0_161.classifyIds = var0_161

	for iter6_161, iter7_161 in ipairs(arg0_161.classifyIds) do
		if iter7_161 == var12_0 then
			table.insert(arg0_161.classifyNames, i18n("shop_filter_all"))
		elseif iter7_161 == var13_0 or iter7_161 == var15_0 then
			table.insert(arg0_161.classifyNames, i18n("shop_filter_trial"))
		elseif iter7_161 == var14_0 then
			table.insert(arg0_161.classifyNames, i18n("shop_filter_retro"))
		else
			table.insert(arg0_161.classifyNames, pg.skin_page_template[iter7_161].name)
		end
	end
end

function var0_0.GetShopTypeIdBySkinId(arg0_163, arg1_163)
	local var0_163 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_163.shopTypeIdList then
		arg0_163.shopTypeIdList = {}
	end

	if arg0_163.shopTypeIdList[arg1_163] then
		return arg0_163.shopTypeIdList[arg1_163]
	end

	for iter0_163, iter1_163 in pairs(var0_163) do
		for iter2_163, iter3_163 in ipairs(iter1_163) do
			arg0_163.shopTypeIdList[iter3_163] = iter0_163

			if iter3_163 == arg1_163 then
				return iter0_163
			end
		end
	end
end

function var0_0.OnShopping(arg0_164, arg1_164)
	if not arg0_164.showingCommodity then
		return
	end

	if arg0_164.purchaseView and arg0_164.purchaseView:GetLoaded() then
		arg0_164.purchaseView:Hide()
	end

	if arg0_164.showingCommodity.id == arg1_164 then
		arg0_164.pendingSelectId = arg0_164:GetNextCommodityIndex(arg1_164)

		arg0_164:GetAllCommodities()
		arg0_164:Refresh(false)
	end
end

function var0_0.OnFurnitureUpdate(arg0_165, arg1_165)
	if not arg0_165.showingCommodity then
		return
	end

	local var0_165 = arg0_165.showingCommodity.id

	if Goods.ExistFurniture(var0_165) and Goods.Id2FurnitureId(var0_165) == arg1_165 then
		arg0_165:GetAllCommodities()
		arg0_165:Refresh(true)
	end
end

function var0_0.CheckDownloadSkinList(arg0_166, arg1_166)
	local var0_166 = {}

	for iter0_166, iter1_166 in ipairs(arg0_166.commodities) do
		PaintingGroupConst.AddPaintingNameBySkinID(var0_166, iter1_166:getSkinId())
	end

	local var1_166 = {
		showMask = true,
		isShowBox = true,
		paintingNameList = var0_166,
		finishFunc = arg1_166
	}

	PaintingGroupConst.PaintingDownload(var1_166)
end

function var0_0.willExit(arg0_167)
	arg0_167:ClearCards()

	arg0_167.spriteCache = nil

	ClearLScrollrect(arg0_167.scrollrect)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_167:getUIName())

	if arg0_167.live2dChar then
		arg0_167.live2dChar:Dispose()

		arg0_167.live2dChar = nil
	end

	if arg0_167.voucherMsgBox then
		arg0_167.voucherMsgBox:Destroy()

		arg0_167.voucherMsgBox = nil
	end

	if arg0_167.purchaseView then
		arg0_167.purchaseView:Destroy()

		arg0_167.purchaseView = nil
	end

	for iter0_167, iter1_167 in pairs(arg0_167.downloads) do
		iter1_167:Dispose()
	end

	arg0_167.downloads = {}

	arg0_167:ClearPainting()

	if arg0_167.interactionPreview then
		arg0_167.interactionPreview:Dispose()

		arg0_167.interactionPreview = nil
	end

	arg0_167:disposeEvent()
	arg0_167:ClearTimer()
	arg0_167:ReturnChar()
	arg0_167:UnOverlay()
end

function var0_0.GetNextCommodityIndex(arg0_168, arg1_168)
	for iter0_168, iter1_168 in ipairs(arg0_168.displays) do
		if iter1_168.id == arg1_168 then
			if iter0_168 == #arg0_168.displays then
				return arg1_168
			end

			return arg0_168.displays[iter0_168 + 1].id
		end
	end
end

function var0_0.onBackPressed(arg0_169)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
