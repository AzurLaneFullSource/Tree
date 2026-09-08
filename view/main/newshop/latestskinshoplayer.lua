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

local function var19_0(arg0_1)
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

	return var0_0.obtainBtnSpriteNames[arg0_1]
end

function var0_0.getUIName(arg0_2)
	return "LatestSkinShopUI"
end

function var0_0.getGroupName(arg0_3)
	return "NewShopMainScene"
end

function var0_0.init(arg0_4)
	arg0_4.bgs = arg0_4._tf:Find("bgs")
	arg0_4.adapt = arg0_4._tf:Find("adapt")
	arg0_4.top = arg0_4.adapt:Find("top")
	arg0_4.bottom = arg0_4.adapt:Find("bottom")
	arg0_4.right = arg0_4.adapt:Find("right")
	arg0_4.subPage = arg0_4.adapt:Find("subPage")
	arg0_4.resources = arg0_4.adapt:Find("top/resources")
	arg0_4.limitTime = arg0_4.adapt:Find("top/title/limit_time/Text")
	arg0_4.skinName = arg0_4.adapt:Find("top/title/skin_name_mask/skin_name")
	arg0_4.shipName = arg0_4.adapt:Find("top/title/name_mask/name")
	arg0_4.changeSkin = arg0_4.adapt:Find("top/change_skin")
	arg0_4.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_4.changeSkin, "toggle_ui"))
	arg0_4.showOwnBtn = arg0_4.adapt:Find("bottom/showOwnBtn")
	arg0_4.filterBtn = arg0_4.adapt:Find("bottom/filterBtn")
	arg0_4.search = arg0_4.adapt:Find("bottom/search")
	arg0_4.scrollrect = arg0_4.adapt:Find("bottom/scroll/content"):GetComponent("LScrollRect")
	arg0_4.sdTg = arg0_4.adapt:Find("right/sdTg")
	arg0_4.hideUITg = arg0_4.adapt:Find("right/hideUITg")
	arg0_4.charContainer = arg0_4.adapt:Find("right/char_container")
	arg0_4.backChara = arg0_4.charContainer:Find("bg/back/chara")
	arg0_4.charTf = arg0_4.charContainer:Find("char")
	arg0_4.furnitureContainer = arg0_4.charContainer:Find("fur")
	arg0_4.switchPreviewBtn = arg0_4.charContainer:Find("switch")
	arg0_4.dynamicToggle = arg0_4.adapt:Find("right/functionsAndTags/dynamic")
	arg0_4.dynamicIcon = arg0_4.adapt:Find("right/functionsAndTags/dynamic/icon")
	arg0_4.showBgToggle = arg0_4.adapt:Find("right/functionsAndTags/showBg")
	arg0_4.dynamicResToggle = arg0_4.adapt:Find("right/functionsAndTags/dynamic/l2d_res_state")
	arg0_4.tagList = UIItemList.New(arg0_4.adapt:Find("right/functionsAndTags/tags"), arg0_4.adapt:Find("right/functionsAndTags/tags/tag"))
	arg0_4.giftPackBtn = arg0_4.adapt:Find("right/giftPackBtn")
	arg0_4.price = arg0_4.adapt:Find("right/price")
	arg0_4.btnsList = {
		arg0_4.price:Find("normal/btns"),
		arg0_4.price:Find("charge/btns")
	}
	arg0_4.filterUI = arg0_4.adapt:Find("subPage/filterUI")
	arg0_4.filterContent = arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content")
	arg0_4.painting = arg0_4._tf:Find("painting")
	arg0_4.paintingTF = arg0_4._tf:Find("painting/paint")
	arg0_4.defaultPaintingPosition = arg0_4.paintingTF.anchoredPosition
	arg0_4.defaultPaintingScale = arg0_4.paintingTF.localScale
	arg0_4.live2dContainer = arg0_4._tf:Find("painting/paint/live2d")
	arg0_4.spTF = arg0_4._tf:Find("painting/paint/spinePainting")
	arg0_4.spBg = arg0_4._tf:Find("painting/paintBg/spinePainting")

	setActive(arg0_4.charContainer, false)
	setActive(arg0_4.filterUI, false)

	arg0_4.mainTitle = arg0_4.adapt:Find("top/mainTitle")
	arg0_4.backBtn = arg0_4.adapt:Find("top/closeBtn")
	arg0_4.homeBtn = arg0_4.adapt:Find("top/homeBtn")
	arg0_4.giftPack = arg0_4.adapt:Find("giftPack")

	setActive(arg0_4.mainTitle, false)
	setActive(arg0_4.backBtn, false)
	setActive(arg0_4.homeBtn, false)
	setActive(arg0_4.giftPack, false)

	arg0_4.downloads = {}
	arg0_4.isToggleDynamic = false
	arg0_4.isToggleShowBg = true
	arg0_4.isPreviewFurniture = false
	arg0_4.interactionPreview = BackYardInteractionPreview.New(arg0_4.furnitureContainer, Vector3(0, 0, 0))
	arg0_4.voucherMsgBox = SkinVoucherMsgBox.New(pg.UIMgr.GetInstance().OverlayMain)
	arg0_4.purchaseView = NewSkinShopPurchaseView.New(arg0_4._tf, arg0_4.event)

	arg0_4:RegisterEvent()
	setText(arg0_4._tf:Find("bgs/empty/Text"), i18n("shop_new_unfound"))
	setText(arg0_4.adapt:Find("top/mainTitle/Text"), i18n("shop_new_shop"))
	setText(arg0_4.filterBtn:Find("Text"), i18n("shop_new_sort"))
	setText(arg0_4.search:Find("holder"), i18n("shop_new_search"))

	for iter0_4, iter1_4 in ipairs(arg0_4.btnsList) do
		setText(iter1_4:Find("yigoumai_button/Text"), i18n("shop_new_purchased"))
		setText(iter1_4:Find("goumai_button/Text"), i18n("shop_new_purchase"))
		setText(iter1_4:Find("qianwanghuoqu_button/Text"), i18n("shop_new_claim"))
		setText(iter1_4:Find("furniture_shop/Text"), i18n("shop_new_furniture"))
		setText(iter1_4:Find("item_buy/Text"), i18n("shop_new_discount"))
		setText(iter1_4:Find("tiyan_btn/Text"), i18n("shop_new_try"))
		setText(iter1_4:Find("buy_with_gift/Text"), i18n("shop_new_purchase"))
	end

	setText(arg0_4.btnsList[2]:Find("buy_charge/Text"), i18n("shop_new_purchase"))
	setText(arg0_4.price:Find("btn/tag/Text"), i18n("shop_new_gift"))
	setText(arg0_4.giftPack:Find("panel/desc"), i18n("shop_new_gem_transform"))
	setText(arg0_4.giftPack:Find("price/btns/yigoumai_button/Text"), i18n("shop_new_purchased"))
	setText(arg0_4.filterUI:Find("panelMask/panel/title"), i18n("shop_new_sort"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/subTitleFrame/subTitle"), i18n("shop_new_review"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/1/Text"), i18n("shop_new_owned"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/2/Text"), i18n("shop_new_havent_own"))
	setScrollText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/3/mask/Text"), i18n("shop_new_unused"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("shop_new_type"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/2/Text"), i18n("shop_new_static"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/3/Text"), i18n("shop_new_dynamic"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/4/Text"), i18n("shop_new_static_bg"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/5/Text"), i18n("shop_new_dynamic_bg"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/6/Text"), i18n("shop_new_bgm"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/subTitleFrame/subTitle"), i18n("shop_new_index"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/1/Text"), i18n("shop_new_ship_owned"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/2/Text"), i18n("shop_new_ship_havent_owned"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/camp/subTitleFrame/subTitle"), i18n("shop_new_nation"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/rarity/subTitleFrame/subTitle"), i18n("shop_new_rarity"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipType/subTitleFrame/subTitle"), i18n("shop_new_category"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/themeType/subTitleFrame/subTitle"), i18n("shop_new_skin_theme"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/subTitleFrame/subTitle"), i18n("skin_shop_tag"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/0/Text"), i18n("skin_shop_tag_0"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/1/Text"), i18n("skin_shop_tag_1"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/2/Text"), i18n("skin_shop_tag_2"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/3/Text"), i18n("skin_shop_tag_3"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/4/Text"), i18n("skin_shop_tag_4"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/5/Text"), i18n("skin_shop_tag_5"))
	setText(arg0_4.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/tag/options/6/Text"), i18n("skin_shop_tag_6"))
	setText(arg0_4.filterUI:Find("panelMask/panel/bottom/ok/Text"), i18n("shop_new_confirm"))

	arg0_4.uiOwnOptions = arg0_4.filterContent:Find("own/options")
	arg0_4.uiTypeOptions = arg0_4.filterContent:Find("type/options")
	arg0_4.uiShipHaveOptions = arg0_4.filterContent:Find("shipHave/options")
	arg0_4.uiCampOptions = arg0_4.filterContent:Find("camp/options")
	arg0_4.uiRrarityOptions = arg0_4.filterContent:Find("rarity/options")
	arg0_4.uiShipTypeOptions = arg0_4.filterContent:Find("shipType/options")
	arg0_4.uiThemeTypeOptions = arg0_4.filterContent:Find("themeType/options")
	arg0_4.uiTagTypeOptions = arg0_4.filterContent:Find("tag/options")

	arg0_4:Overlay()
end

function var0_0.Overlay(arg0_5)
	arg0_5:OverlayPanel(arg0_5.adapt, {
		pbList = {
			arg0_5.top:Find("title"),
			arg0_5.top:Find("title/limit_time"),
			arg0_5.top:Find("title/charaNameBg"),
			arg0_5.showOwnBtn,
			arg0_5.filterBtn,
			arg0_5.search,
			arg0_5.charContainer:Find("bg"),
			arg0_5.price:Find("normal/consume"),
			arg0_5.filterUI:Find("panelMask/panel")
		}
	})
end

function var0_0.UnOverlay(arg0_6)
	arg0_6:UnOverlayPanel(arg0_6.adapt, arg0_6._tf)
end

function var0_0.didEnter(arg0_7)
	arg0_7:InitData()
	arg0_7:SetFilterPanel()
	arg0_7:SetResource()

	if arg0_7.mode == var0_0.MODE_EXPERIENCE or arg0_7.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI_2, false)
		setActive(arg0_7.showOwnBtn, false)
		setActive(arg0_7.filterBtn, false)
		setActive(arg0_7.search, false)

		arg0_7.top:Find("title").anchoredPosition = Vector2(184.2, -208.3)
		arg0_7.top:Find("change_skin").anchoredPosition = Vector2(70.7, -337.8)
		arg0_7.right:Find("giftPackBtn").anchoredPosition = Vector2(-483, -446.4)
		arg0_7.right:Find("price").anchoredPosition = Vector2(-238.3, -140.7)
		arg0_7.bottom:Find("scroll").offsetMin = Vector2(17.7, 0)
		arg0_7.bottom:Find("scroll").offsetMax = Vector2(-718.7, 227.9)
	end

	arg0_7:SetGiftPackLayer()
	onDelayTick(function()
		local var0_8 = {}

		table.insert(var0_8, function(arg0_9)
			arg0_7:CheckDownloadSkinList(arg0_9)
		end)
		seriesAsync(var0_8, function()
			arg0_7:SetSkinScroll()
			arg0_7:Refresh(true)
		end)
	end, 0.001)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.homeBtn, function()
		arg0_7:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.filterBtn, function()
		arg0_7:OpenFilterPanel()
	end, SFX_PANEL)

	if arg0_7.mode == var0_0.MODE_EXPERIENCE or arg0_7.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	local var0_7 = getProxy(PlayerProxy):getRawData().id

	onToggle(arg0_7, arg0_7.sdTg, function(arg0_14)
		setActive(arg0_7.charContainer, arg0_14)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_7, arg0_14 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_7 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_7, 0)

	triggerToggle(arg0_7.sdTg, var1_7 == 1)
	onToggle(arg0_7, arg0_7.hideUITg, function(arg0_15)
		setActive(arg0_7.top, not arg0_15)
		setActive(arg0_7.bottom, not arg0_15)
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg0_15)
	end, SFX_PANEL)
	onInputChanged(arg0_7, arg0_7.search, function()
		arg0_7:Refresh(true)

		local var0_16 = getInputText(arg0_7.search)

		setActive(arg0_7.search:Find("holder"), var0_16 == "")
	end)
	onButton(arg0_7, arg0_7.showOwnBtn, function()
		arg0_7:emit(LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER)
	end, SFX_PANEL)
	getProxy(CommanderManualProxy):TaskProgressAdd(2021, 1)
end

function var0_0.SetResource(arg0_18)
	local var0_18 = getProxy(PlayerProxy):getRawData()

	setText(arg0_18.resources:Find("gem/Text"), var0_18:getTotalGem())
	onButton(arg0_18, arg0_18.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_20)
	arg0_20.type = arg0_20.contextData.type or ShopConst.PERMANANT_SKIN_SHOP_ID
	arg0_20.mode = arg0_20.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_20:GetAllCommodities()
	arg0_20:GetGiftPackCommodities()

	arg0_20.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()

	arg0_20:GetSkinClassify()

	local var0_20 = (arg0_20.mode == var0_0.MODE_EXPERIENCE or arg0_20.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM) and 1 or 0

	arg0_20.filterValues = {
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
			var0_20
		},
		tagType = {
			0
		}
	}
	arg0_20.filterValuesTemp = Clone(arg0_20.filterValues)
end

function var0_0.GetAllCommodities(arg0_21)
	if arg0_21.type == ShopConst.NEW_SKIN_SHOP_ID then
		arg0_21.commodities = getProxy(ShipSkinProxy):GetInTimeSkins()
	elseif arg0_21.type == ShopConst.PERMANANT_SKIN_SHOP_ID then
		arg0_21.commodities = getProxy(ShipSkinProxy):GetPermanentSkins()
	else
		arg0_21.commodities = {}

		local var0_21 = getProxy(ShipSkinProxy):GetAllSkins()

		for iter0_21, iter1_21 in ipairs(var0_21) do
			if table.keyof(pg.shop_skin_subsheet[arg0_21.type].param, iter1_21.id) then
				table.insert(arg0_21.commodities, iter1_21)
			end
		end
	end

	if LOCK_SKIN_US then
		local var1_21 = pg.gameset.levellimit_skintype.key_value
		local var2_21 = pg.gameset.levellimit_skintype.description

		if var1_21 >= getProxy(PlayerProxy):getData().level then
			arg0_21.commodities = _.filter(arg0_21.commodities, function(arg0_22)
				local var0_22 = pg.ship_skin_template[arg0_22:getSkinId()].shop_type_id

				return table.contains(var2_21, var0_22)
			end)
		end
	end

	if arg0_21.mode == var0_0.MODE_OVERVIEW then
		for iter2_21 = #arg0_21.commodities, 1, -1 do
			if arg0_21.commodities[iter2_21]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				table.remove(arg0_21.commodities, iter2_21)
			end
		end
	end
end

function var0_0.GetGiftPackCommodities(arg0_23)
	arg0_23.giftPackCommodities = {}
	arg0_23.giftSkinCommodities = {}
	arg0_23.giftSkinProbabilitys = {}

	for iter0_23, iter1_23 in ipairs(pg.pay_data_display.all) do
		local var0_23 = pg.pay_data_display[iter1_23]

		if var0_23.skin_inquire_relation ~= 0 and pg.TimeMgr.GetInstance():inTime(var0_23.time) then
			local var1_23 = getProxy(ShopsProxy):GetGiftCommodity(iter1_23, Goods.TYPE_CHARGE)

			arg0_23.giftPackCommodities[iter1_23] = var1_23

			local var2_23 = var1_23:GetSkinProbability()

			arg0_23.giftSkinCommodities[iter1_23] = getProxy(ShipSkinProxy):GetProbabilitySkins(var2_23)
			arg0_23.giftSkinProbabilitys[iter1_23] = getProxy(ShipSkinProxy):GetSkinProbabilitys(var2_23)
		end
	end
end

function var0_0.SetSkinScroll(arg0_24)
	arg0_24.scrollrect.isNewLoadingMethod = true

	function arg0_24.scrollrect.onInitItem(arg0_25)
		arg0_24:OnInitItem(arg0_25)
	end

	function arg0_24.scrollrect.onUpdateItem(arg0_26, arg1_26)
		arg0_24:OnUpdateItem(arg0_26, arg1_26)
	end

	arg0_24.scrollrect.enabled = true
end

function var0_0.Refresh(arg0_27, arg1_27)
	arg0_27:ClearCards()

	arg0_27.cards = {}
	arg0_27.displays = {}

	local var0_27 = getInputText(arg0_27.search)

	for iter0_27, iter1_27 in ipairs(arg0_27.commodities) do
		if arg0_27:filterOk(iter1_27) and arg0_27:IsSearchType(var0_27, iter1_27) then
			table.insert(arg0_27.displays, iter1_27)
		end
	end

	local var1_27 = {}

	for iter2_27, iter3_27 in ipairs(arg0_27.displays) do
		local var2_27 = iter3_27.type == Goods.TYPE_ACTIVITY or iter3_27.type == Goods.TYPE_ACTIVITY_EXTRA
		local var3_27 = 0

		if not var2_27 then
			var3_27 = iter3_27:GetPrice()
		end

		var1_27[iter3_27.id] = var3_27
	end

	table.sort(arg0_27.displays, function(arg0_28, arg1_28)
		return arg0_27:Sort(arg0_28, arg1_28, var1_27)
	end)

	local var4_27 = #arg0_27.displays == 0

	setActive(arg0_27.bgs:Find("default"), var4_27)
	setActive(arg0_27.bgs:Find("diffBg"), not var4_27)
	setActive(arg0_27.bgs:Find("empty"), var4_27)
	setActive(arg0_27._tf:Find("leftMask"), not var4_27)
	setActive(arg0_27._tf:Find("bottomMask"), not var4_27)
	setActive(arg0_27.painting, not var4_27)
	setActive(arg0_27.top:Find("title"), not var4_27)
	setActive(arg0_27.changeSkin, not var4_27)
	setActive(arg0_27.right, not var4_27)
	setActive(arg0_27.right, not var4_27)
	setActive(arg0_27.bottom:Find("scroll"), not var4_27)

	if not var4_27 then
		if arg1_27 then
			arg0_27.triggerFirstCard = true

			arg0_27.scrollrect:SetTotalCount(#arg0_27.displays, 0)
		else
			arg0_27.scrollrect:SetTotalCount(#arg0_27.displays)
		end
	end
end

function var0_0.IsSearchType(arg0_29, arg1_29, arg2_29)
	if not arg1_29 or arg1_29 == "" then
		return true
	end

	local var0_29 = arg2_29:getSkinId()

	return ShipSkin.New({
		id = var0_29
	}):IsMatchKey(arg1_29)
end

local function var20_0(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg2_30[arg0_30.id]
	local var1_30 = arg2_30[arg1_30.id]

	if var0_30 == var1_30 then
		return arg0_30.id < arg1_30.id
	else
		return var1_30 < var0_30
	end
end

function var0_0.Sort(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg1_31.buyCount == 0 and 1 or 0
	local var1_31 = arg2_31.buyCount == 0 and 1 or 0

	if var0_31 == var1_31 then
		local var2_31 = arg1_31:getConfig("order")
		local var3_31 = arg2_31:getConfig("order")

		if var2_31 == var3_31 then
			return var20_0(arg1_31, arg2_31, arg3_31)
		else
			return var2_31 < var3_31
		end
	else
		return var1_31 < var0_31
	end
end

function var0_0.filterOk(arg0_32, arg1_32)
	local var0_32 = arg0_32.filterValues.ownType
	local var1_32 = arg0_32.filterValues.typeType
	local var2_32 = arg0_32.filterValues.shipHaveType
	local var3_32 = arg0_32.filterValues.campType
	local var4_32 = arg0_32.filterValues.rarityType
	local var5_32 = arg0_32.filterValues.shipType
	local var6_32 = arg0_32.filterValues.themeType
	local var7_32 = arg0_32.filterValues.tagType
	local var8_32 = arg1_32:getSkinId()
	local var9_32 = ShipSkin.New({
		id = var8_32
	})
	local var10_32 = var9_32:GetDefaultShipConfig()
	local var11_32 = arg0_32:ToVShip(var10_32)

	if var0_32 ~= 0 then
		local var12_32 = false
		local var13_32 = getProxy(ShipSkinProxy):hasSkin(var8_32)
		local var14_32 = var9_32:NoUse()

		if var0_32 == 1 and var13_32 then
			var12_32 = true
		end

		if var0_32 == 2 and not var13_32 then
			var12_32 = true
		end

		if var0_32 == 3 and var13_32 and var14_32 then
			var12_32 = true
		end

		if not var12_32 then
			return false
		end
	end

	if var1_32[1] ~= 0 then
		local var15_32 = false

		for iter0_32, iter1_32 in ipairs(var1_32) do
			if iter1_32 == 1 and (var9_32:IsLive2d() or var9_32:IsLive2dPlus()) then
				var15_32 = true
			end

			if iter1_32 == 2 and not var9_32:IsLive2d() and not var9_32:IsLive2dPlus() and not var9_32:IsSpine() and not var9_32:IsSpinePlus() then
				var15_32 = true
			end

			if iter1_32 == 3 and (var9_32:IsSpine() or var9_32:IsSpinePlus()) then
				var15_32 = true
			end

			if iter1_32 == 4 and var9_32:IsBG() then
				var15_32 = true
			end

			if iter1_32 == 5 and var9_32:IsDbg() then
				var15_32 = true
			end

			if iter1_32 == 6 and var9_32:isBgm() then
				var15_32 = true
			end

			if var15_32 then
				break
			end
		end

		if not var15_32 then
			return false
		end
	end

	if var2_32 ~= 0 then
		local var16_32 = false
		local var17_32 = var9_32:CantUse()

		if var2_32 == 1 and not var17_32 then
			var16_32 = true
		end

		if var2_32 == 2 and var17_32 then
			var16_32 = true
		end

		if not var16_32 then
			return false
		end
	end

	if var3_32[1] ~= 0 then
		if not var10_32 then
			return false
		end

		local var18_32 = false

		for iter2_32, iter3_32 in ipairs(var3_32) do
			local var19_32 = ShipIndexCfg.camp

			for iter4_32, iter5_32 in ipairs(var19_32[iter3_32 + 1].types) do
				if iter5_32 == Nation.LINK then
					if var11_32:getNation() >= Nation.LINK then
						var18_32 = true
					end
				elseif iter5_32 == var11_32:getNation() then
					var18_32 = true
				end
			end

			if var18_32 then
				break
			end
		end

		if not var18_32 then
			return false
		end
	end

	if var4_32[1] ~= 0 then
		if not var10_32 then
			return false
		end

		local var20_32 = false

		for iter6_32, iter7_32 in ipairs(var4_32) do
			local var21_32 = ShipIndexCfg.rarity

			if table.contains(var21_32[iter7_32 + 1].types, var11_32:getRarity()) then
				var20_32 = true
			end

			if var20_32 then
				break
			end
		end

		if not var20_32 then
			return false
		end
	end

	if var5_32[1] ~= 0 then
		if not var10_32 then
			return false
		end

		local var22_32 = false

		for iter8_32, iter9_32 in ipairs(var5_32) do
			local var23_32 = ShipIndexCfg.type
			local var24_32 = var23_32[iter9_32 + 1].types

			if iter9_32 + 1 < 4 then
				local var25_32 = var23_32[iter9_32].shipTypes

				if table.contains(var24_32, var11_32:getShipType()) then
					var22_32 = true
				end

				if table.contains(var24_32, var11_32:getTeamType()) then
					var22_32 = true
				end
			elseif table.contains(var24_32, var11_32:getShipType()) then
				var22_32 = true
			end

			if var22_32 then
				break
			end
		end

		if not var22_32 then
			return false
		end
	end

	if var6_32[1] ~= 0 then
		local var26_32 = false

		for iter10_32, iter11_32 in ipairs(var6_32) do
			local var27_32 = arg0_32.classifyIds[iter11_32 + 1]

			if arg1_32:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				if arg0_32.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
					var26_32 = var27_32 == var15_0 and arg0_32:ExitSkinExperienceItem(arg1_32.id)
				else
					var26_32 = var27_32 == var13_0
				end
			elseif var27_32 == var12_0 then
				var26_32 = true
			elseif var27_32 == var14_0 and table.contains(arg0_32.returnSkins, arg1_32.id) then
				var26_32 = true
			else
				local var28_32 = arg0_32:GetShopTypeIdBySkinId(var8_32)

				var26_32 = (var28_32 == 0 and var16_0 or var28_32) == var27_32
			end

			if var26_32 then
				break
			end
		end

		if not var26_32 then
			return false
		end
	end

	if var7_32[1] ~= 0 then
		local var29_32 = false
		local var30_32 = table.contains(arg0_32.returnSkins, arg1_32.id)
		local var31_32 = NewShopSkinCard.GetTagId(arg1_32, var30_32)

		if table.keyof(var7_32, var31_32) then
			return true
		else
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_33, arg1_33)
	if not arg0_33.vship then
		arg0_33.vship = {}

		function arg0_33.vship.getNation()
			return arg0_33.vship.config.nationality
		end

		function arg0_33.vship.getShipType()
			return arg0_33.vship.config.type
		end

		function arg0_33.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_33.vship.config.type)
		end

		function arg0_33.vship.getRarity()
			return arg0_33.vship.config.rarity
		end
	end

	arg0_33.vship.config = arg1_33

	return arg0_33.vship
end

function var0_0.ExitSkinExperienceItem(arg0_38, arg1_38)
	if not arg0_38.cacheSkinExperienceItems then
		arg0_38.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(arg0_38.cacheSkinExperienceItems, function(arg0_39)
		return arg0_39:CanUseForShop(arg1_38)
	end)
end

function var0_0.RegisterEvent(arg0_40)
	arg0_40:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_41, arg1_41)
		arg0_40:AdjustPainting(arg1_41)
		setActive(arg0_40.top, not arg1_41)
		setActive(arg0_40.bottom, not arg1_41)
		setActive(arg0_40.right, not arg1_41)

		if arg0_40.live2dChar then
			arg0_40.live2dChar:setPurchaseOffset(arg1_41)
		end

		if arg0_40.spineChar then
			if arg1_41 then
				local var0_41 = pg.ship_skin_template[arg0_40.skinId].purchase_offset

				if var0_41 and #var0_41 >= 3 then
					arg0_40.spineChar:SetLocalPosition(Vector3(var0_41[1], var0_41[2], var0_41[3]))
				end

				if var0_41 and #var0_41 >= 4 then
					arg0_40.spineChar:SetLocalScale(Vector3(var0_41[4], var0_41[4], var0_41[4]))
				end
			else
				arg0_40.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
				arg0_40.spineChar:SetLocalPosition(Vector3(0, 0, 0))
			end
		end

		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg1_41)
	end)
	arg0_40:bind(var0_0.EVT_ON_PURCHASE, function(arg0_42, arg1_42)
		local var0_42 = arg0_40:GetObtainBtnState(arg1_42)

		arg0_40:OnClickBtn(var0_42, arg1_42)
	end)
	onButton(arg0_40, arg0_40.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_40.skinId) then
			arg0_40.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_40.skinId)

			arg0_40:UpdateMainView(arg0_40.showingCommodity)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_44, arg1_44)
	local var0_44 = NewShopSkinCard.New(arg1_44)

	onButton(arg0_44, var0_44._go, function()
		if not var0_44.commodity then
			return
		end

		for iter0_45, iter1_45 in pairs(arg0_44.cards) do
			iter1_45:UpdateSelected(false)
		end

		arg0_44.selectedId = var0_44.commodity.id

		var0_44:UpdateSelected(true)
		arg0_44:UpdateMainView(var0_44.commodity)
		arg0_44:GCHandle()
	end, SFX_PANEL)

	arg0_44.cards[arg1_44] = var0_44
end

function var0_0.OnUpdateItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.cards[arg2_46]

	if not var0_46 then
		arg0_46:OnInitItem(arg2_46)

		var0_46 = arg0_46.cards[arg2_46]
	end

	local var1_46 = arg0_46.displays[arg1_46 + 1]

	if not var1_46 then
		return
	end

	local var2_46 = arg0_46.selectedId == var1_46.id
	local var3_46 = table.contains(arg0_46.returnSkins, var1_46.id)

	var0_46:Update(var1_46, var2_46, var3_46)

	if arg0_46.pendingSelectId and arg0_46.pendingSelectId == var1_46.id then
		arg0_46.pendingSelectId = nil

		triggerButton(var0_46._go)
	end

	if arg0_46.triggerFirstCard and arg1_46 == 0 then
		arg0_46.triggerFirstCard = false

		triggerButton(var0_46._go)
	end
end

function var0_0.UpdateMainView(arg0_47, arg1_47)
	arg0_47.skinId = arg1_47:getSkinId()

	local var0_47 = ShipSkin.IsChangeSkin(arg0_47.skinId)

	setActive(arg0_47.changeSkin, var0_47)

	if var0_47 then
		arg0_47:FlushChangeSkin(arg1_47)
	end

	arg0_47.shipSkin = ShipSkin.New({
		id = arg0_47.skinId
	})

	arg0_47:FlushName()
	arg0_47:FlushPreviewBtn(arg1_47)
	arg0_47:FlushTimeLimit(arg1_47)
	arg0_47:SwitchPreview(arg1_47, arg0_47.isPreviewFurniture)
	arg0_47:FlushPaintingToggle(arg1_47)
	arg0_47:FlushTag()
	arg0_47:FlushBG(arg1_47)
	arg0_47:FlushPainting(arg1_47)
	arg0_47:FlushPrice(arg1_47)
	arg0_47:FlushObtainBtn(arg1_47)
	arg0_47:FlushGifgPackBtn(arg1_47)

	arg0_47.showingCommodity = arg1_47
end

function var0_0.FlushChangeSkin(arg0_48, arg1_48)
	local var0_48 = ShipSkin.GetChangeSkinGroupId(arg0_48.skinId)
	local var1_48 = ShipSkin.GetChangeSkinCustomDataId(arg0_48.skinId, "hide_shop")
	local var2_48 = pg.gameset.changeskin_switch_block
	local var3_48 = false
	local var4_48 = false
	local var5_48 = arg0_48.changeSkinToggle:IsAsmrSkin() and true or false

	if var2_48 and var2_48.description then
		local var6_48 = var2_48.description

		if table.contains(var6_48, var0_48) and HXSet.isHx() then
			var4_48 = true
		end
	end

	if var1_48 and var1_48 == 1 then
		var3_48 = true
	end

	if not arg0_48.changeSkinId then
		arg0_48.changeSkinId = arg0_48.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_48.changeSkinId) == var0_48 then
		arg0_48.skinId = arg0_48.changeSkinId
	else
		arg0_48.changeSkinId = arg0_48.skinId
	end

	arg0_48.changeSkinToggle:setSkinData(arg0_48.skinId)

	if var3_48 or var4_48 or var5_48 then
		setActive(arg0_48.changeSkin, false)
	else
		setActive(arg0_48.changeSkin, true)
	end
end

function var0_0.GCHandle(arg0_49)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.FlushName(arg0_50)
	local var0_50 = pg.ship_skin_template[arg0_50.skinId]

	setScrollText(arg0_50.skinName, SwitchSpecialChar(var0_50.name, true))

	if var0_50.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_50.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_50.skinId)))
	else
		local var1_50 = ShipGroup.getDefaultShipConfig(var0_50.ship_group)

		setScrollText(arg0_50.shipName, var1_50.name)
	end
end

function var0_0.FlushPreviewBtn(arg0_51, arg1_51)
	local var0_51 = Goods.ExistFurniture(arg1_51.id)

	removeOnButton(arg0_51.switchPreviewBtn)

	if not var0_51 and arg0_51.isPreviewFurniture then
		arg0_51.isPreviewFurniture = false
	end

	setActive(arg0_51.switchPreviewBtn, var0_51)

	if var0_51 then
		onButton(arg0_51, arg0_51.switchPreviewBtn, function()
			arg0_51.isPreviewFurniture = not arg0_51.isPreviewFurniture

			arg0_51:SwitchPreview(arg1_51, arg0_51.isPreviewFurniture)
			arg0_51:FlushPrice(arg1_51)
			arg0_51:FlushObtainBtn(arg1_51)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPreview(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53.skinId

	if pg.ship_skin_template[var0_53].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_53.charContainer, false)

		return
	end

	local var1_53 = getProxy(PlayerProxy):getRawData().id

	setActive(arg0_53.charContainer, PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var1_53, 0) == 1)
	setActive(arg0_53.charTf, not arg2_53)
	setActive(arg0_53.furnitureContainer, arg2_53)

	if not arg2_53 then
		local var2_53 = pg.ship_skin_template[var0_53]

		arg0_53:FlushChar(var2_53.prefab, var2_53.id)
		GetImageSpriteFromAtlasAsync("qicon/" .. var2_53.painting, "", arg0_53.backChara)
	else
		local var3_53 = Goods.Id2FurnitureId(arg1_53.id)
		local var4_53 = Goods.GetFurnitureConfig(arg1_53.id)

		arg0_53.interactionPreview:Flush(var0_53, var3_53, var4_53.scale[2] or 1, var4_53.position[2])
	end
end

function var0_0.FlushChar(arg0_54, arg1_54, arg2_54)
	if arg0_54.prefabName and arg0_54.prefabName == arg1_54 then
		return
	end

	arg0_54:ReturnChar()

	arg0_54.prefabName = arg1_54

	local var0_54 = SpineAnimChar.New()

	var0_54:SetPaint(arg1_54)
	var0_54:Load(true, function(arg0_55)
		if arg0_54.prefabName ~= arg1_54 then
			arg0_55:Dispose()

			return
		end

		arg0_54.spineChar = arg0_55

		local var0_55 = pg.skinshop_spine_scale[arg2_54]

		if var0_55 then
			arg0_54.spineChar:SetLocalScale(Vector3(var0_55.skinshop_scale, var0_55.skinshop_scale, 1))
		else
			arg0_54.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
		end

		arg0_54.spineChar:SetLocalPosition(Vector3(0, 0, 0))
		arg0_54.spineChar:SetLayer(Layer.UI)
		arg0_54.spineChar:SetParent(arg0_54.charTf)
		arg0_54.spineChar:SetAction("normal", 0)
	end)
end

function var0_0.ReturnChar(arg0_56)
	if arg0_56.spineChar then
		arg0_56.spineChar:Dispose()

		arg0_56.spineChar = nil
		arg0_56.prefabName = nil
	end
end

function var0_0.ClearCards(arg0_57)
	if not arg0_57.cards then
		return
	end

	for iter0_57, iter1_57 in pairs(arg0_57.cards) do
		iter1_57:Dispose()
	end

	arg0_57.cards = nil
end

function var0_0.FlushTimeLimit(arg0_58, arg1_58)
	local var0_58 = arg0_58.skinId
	local var1_58 = false
	local var2_58

	if arg1_58:IsActivityExtra() and arg1_58:ShowMaintenanceTime() then
		local var3_58, var4_58 = arg1_58:GetMaintenanceMonthAndDay()

		function var2_58()
			return i18n("limit_skin_time_before_maintenance", var3_58, var4_58)
		end

		var1_58 = true
	elseif arg1_58:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_58 = getProxy(ShipSkinProxy):getSkinById(var0_58)

		var1_58 = var5_58 and var5_58:isExpireType() and not var5_58:isExpired()

		if var1_58 then
			function var2_58()
				return skinTimeStamp(var5_58:getRemainTime())
			end
		end
	else
		local var6_58, var7_58 = pg.TimeMgr.GetInstance():inTime(arg1_58:getConfig("time"))

		var1_58 = var7_58

		if var1_58 then
			local var8_58 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_58)

			function var2_58()
				return skinCommdityTimeStamp(var8_58)
			end
		end
	end

	setActive(arg0_58.top:Find("title/limit_time"), var1_58)
	arg0_58:ClearTimer()

	if var1_58 then
		arg0_58:AddTimer(var2_58)
	end
end

function var0_0.AddTimer(arg0_62, arg1_62)
	arg0_62.timer = Timer.New(function()
		setText(arg0_62.limitTime, arg1_62())
	end, 1, -1)

	arg0_62.timer.func()
	arg0_62.timer:Start()
end

function var0_0.ClearTimer(arg0_64)
	if arg0_64.timer then
		arg0_64.timer:Stop()

		arg0_64.timer = nil
	end
end

function var0_0.FlushPaintingToggle(arg0_65, arg1_65)
	removeOnToggle(arg0_65.dynamicToggle)
	removeOnToggle(arg0_65.showBgToggle)

	local var0_65 = checkABExist("painting/" .. arg0_65.shipSkin:getConfig("painting") .. "_n")

	if arg0_65.isToggleShowBg and not var0_65 then
		triggerToggle(arg0_65.showBgToggle, false)

		arg0_65.isToggleShowBg = false
	elseif var0_65 then
		triggerToggle(arg0_65.showBgToggle, true)

		arg0_65.isToggleShowBg = true
	end

	local var1_65 = arg0_65.shipSkin:IsSpine() or arg0_65.shipSkin:IsLive2d() or arg0_65.shipSkin:IsSpinePlus() or arg0_65.shipSkin:IsLive2dPlus()
	local var2_65 = arg0_65.shipSkin:IsHxDynamicPreview()

	if var1_65 and not var2_65 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_65.isToggleDynamic = true
	end

	if var1_65 then
		local var3_65 = 0

		if arg0_65.shipSkin:IsSpine() then
			var3_65 = 6
		elseif arg0_65.shipSkin:IsLive2d() then
			var3_65 = 1
		elseif arg0_65.shipSkin:IsSpinePlus() then
			var3_65 = 7
		elseif arg0_65.shipSkin:IsLive2dPlus() then
			var3_65 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_65) .. "_off", arg0_65.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_65), arg0_65.dynamicToggle:Find("select"))
	end

	if var2_65 and arg0_65.isToggleDynamic then
		triggerToggle(arg0_65.dynamicToggle, false)

		arg0_65.isToggleDynamic = false
	end

	if arg0_65.isToggleDynamic and not var1_65 then
		triggerToggle(arg0_65.dynamicToggle, false)

		arg0_65.isToggleDynamic = false
	elseif arg0_65.isToggleDynamic and not arg0_65.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_65.shipSkin:IsLive2d() or arg0_65.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_65.isToggleDynamic = false

			local var4_65 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4_65, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_65.dynamicToggle, false)
		else
			triggerToggle(arg0_65.dynamicToggle, true)

			arg0_65.isToggleDynamic = true
		end
	end

	if var0_65 then
		onToggle(arg0_65, arg0_65.showBgToggle, function(arg0_66)
			arg0_65.isToggleShowBg = arg0_66

			arg0_65:FlushPainting(arg1_65)
			arg0_65:FlushBG(arg1_65)
		end, SFX_PANEL)
	end

	if arg0_65.shipSkin:IsSpine() or arg0_65.shipSkin:IsLive2d() or arg0_65.shipSkin:IsSpinePlus() or arg0_65.shipSkin:IsLive2dPlus() then
		onToggle(arg0_65, arg0_65.dynamicToggle, function(arg0_67)
			local var0_67 = arg0_65.shipSkin:IsHxDynamicPreview()

			if arg0_67 and var0_67 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("shop_tag_control_tip"))
				triggerToggle(arg0_65.dynamicToggle, false)
				setActive(arg0_65.dynamicResToggle, false)

				return
			end

			if arg0_67 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_65.shipSkin:IsLive2d() or arg0_65.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_65.dynamicToggle, false)

				return
			end

			arg0_65.isToggleDynamic = arg0_67

			setActive(arg0_65.showBgToggle, not arg0_67 and var0_65)
			arg0_65:FlushPainting(arg1_65)
			arg0_65:FlushDynamicPaintingResState(arg1_65)
			arg0_65:RecordFlag(arg0_67)
		end, SFX_PANEL)
	end

	setActive(arg0_65.dynamicIcon, true)

	if arg0_65.isToggleDynamic then
		arg0_65:FlushDynamicPaintingResState(arg1_65)
	elseif var2_65 then
		setActive(arg0_65.dynamicResToggle, false)
		setActive(arg0_65.dynamicIcon, false)
	end

	setActive(arg0_65.dynamicToggle, var1_65)
	setActive(arg0_65.showBgToggle, not arg0_65.isToggleDynamic and var0_65)
end

function var0_0.FlushTag(arg0_68)
	local var0_68 = arg0_68.skinId
	local var1_68 = pg.ship_skin_template[var0_68]
	local var2_68 = Clone(var1_68.tag)
	local var3_68 = false

	for iter0_68 = #var2_68, 1, -1 do
		local var4_68 = var2_68[iter0_68]

		if var4_68 == 1 or var4_68 == 6 or var4_68 == 7 or var4_68 == 9 then
			local var5_68 = true

			table.remove(var2_68, iter0_68)
		end
	end

	local var6_68 = checkABExist("painting/" .. arg0_68.shipSkin:getConfig("painting") .. "_n")

	arg0_68.tagList:make(function(arg0_69, arg1_69, arg2_69)
		if arg0_69 == UIItemList.EventUpdate then
			local var0_69 = var2_68[arg1_69 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_68[arg1_69 + 1]), function(arg0_70)
				if arg0_68.exited then
					return
				end

				arg2_69:GetComponent(typeof(Image)).sprite = arg0_70
			end)
		end
	end)
	setActive(arg0_68.adapt:Find("right/functionsAndTags/tags"), #var2_68 > 0)
	arg0_68.tagList:align(#var2_68)
end

function var0_0.FlushPainting(arg0_71, arg1_71)
	local var0_71 = arg0_71:GetPaintingState(arg1_71)
	local var1_71 = pg.ship_skin_template[arg0_71.skinId].painting
	local var2_71 = ShipSkin.GetChangeSkinData(arg0_71.skinId) and true or false

	if var0_71 == var2_0 and not arg0_71:ExistL2dRes(var1_71) or var0_71 == var3_0 and not arg0_71:ExistSpineRes(var1_71) then
		var0_71 = var1_0
	end

	if arg0_71.paintingState and arg0_71.paintingState.state == var0_71 and arg0_71.paintingState.id == arg1_71.id and arg0_71.paintingState.showBg == arg0_71.isToggleShowBg and arg0_71.paintingState.purchaseFlag == arg1_71.buyCount and not var2_71 then
		return
	end

	arg0_71:ClearPainting()

	if var0_71 == var1_0 then
		arg0_71:LoadMeshPainting(arg1_71, arg0_71.isToggleShowBg)
	elseif var0_71 == var2_0 then
		arg0_71:LoadL2dPainting(arg1_71)
	elseif var0_71 == var3_0 then
		arg0_71:LoadSpinePainting(arg1_71)
	end

	arg0_71.paintingState = {
		state = var0_71,
		id = arg1_71.id,
		showBg = arg0_71.isToggleShowBg,
		purchaseFlag = arg1_71.buyCount
	}

	arg0_71:AdjustPainting(false)
end

function var0_0.ClearPainting(arg0_72)
	local var0_72 = arg0_72.paintingState

	if not var0_72 then
		return
	end

	if var0_72.state == var1_0 then
		arg0_72:ClearMeshPainting()
	elseif var0_72.state == var2_0 then
		arg0_72:ClearL2dPainting()
	elseif var0_72.state == var3_0 then
		arg0_72:ClearSpinePainting()
	end

	arg0_72.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_73, arg1_73, arg2_73)
	local var0_73 = findTF(arg0_73.paintingTF, "fitter")
	local var1_73 = GetOrAddComponent(var0_73, "PaintingScaler")

	var1_73.FrameName = "chuanwu"
	var1_73.Tween = 1

	local var2_73 = pg.ship_skin_template[arg0_73.skinId].painting
	local var3_73 = var2_73

	if not arg2_73 and checkABExist("painting/" .. var2_73 .. "_n") then
		var2_73 = var2_73 .. "_n"
	end

	if not checkABExist("painting/" .. var2_73) then
		return
	end

	if PLATFORM_CODE == PLATFORM_CH and checkABExist("painting/" .. var2_73 .. "_shop") then
		var2_73 = var2_73 .. "_shop"
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_73, true, function(arg0_74)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_74, var0_73, false)
		ShipExpressionHelper.SetExpression(var0_73:GetChild(0), var3_73)

		arg0_73.paintingName = var2_73

		if arg0_73.paintingState and arg0_73.paintingState.id ~= arg1_73.id then
			arg0_73:ClearMeshPainting()
		end

		local var0_74 = arg0_74.transform:Find("shop_hx")

		arg0_73:CheckShowShopHx(var0_74)

		local var1_74 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_74 = arg0_74.transform:Find("shop_hx_ch" .. var1_74)

		arg0_73:CheckShowShopHx(var2_74)
	end)
end

function var0_0.ClearMeshPainting(arg0_75)
	local var0_75 = arg0_75.paintingTF:Find("fitter")

	if arg0_75.paintingName and var0_75.childCount > 0 then
		local var1_75 = var0_75:GetChild(0).gameObject
		local var2_75 = var1_75.transform:Find("shop_hx")

		arg0_75:RevertShopHx(var2_75)
		PoolMgr.GetInstance():ReturnPainting(arg0_75.paintingName, var1_75)
	end

	arg0_75.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_76, arg1_76)
	local var0_76 = arg0_76.skinId
	local var1_76 = pg.ship_skin_template[var0_76].skin_type
	local var2_76

	if var1_76 == ShipSkin.SKIN_TYPE_TB then
		var2_76 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_76))
	else
		local var3_76 = pg.ship_skin_template[var0_76].ship_group
		local var4_76 = ShipGroup.getDefaultShipConfig(var3_76)

		var2_76 = Ship.New({
			noChangeSkin = true,
			configId = var4_76.id,
			skin_id = var0_76
		})
	end

	local var5_76 = Live2DPainting.GenerateData({
		ship = var2_76,
		position = Vector3(0, 0, -1),
		parent = arg0_76.live2dContainer,
		offset = var2_76:GetSkinConfig().shop_offset
	})

	var5_76.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_76.live2dChar = Live2DPainting.New(var5_76, function(arg0_77)
		arg0_77:IgonreReactPos(true)
		arg0_76:CheckShowShopHxForL2d(arg0_77, arg1_76)

		if arg0_76.paintingState and arg0_76.paintingState.id ~= arg1_76.id then
			arg0_76:ClearL2dPainting()
		end

		arg0_77:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_78)
	if arg0_78.live2dChar then
		arg0_78:RevertShopHxForL2d(arg0_78.live2dChar)
		arg0_78.live2dChar:Dispose()

		arg0_78.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_79, arg1_79)
	local var0_79 = arg0_79.skinId
	local var1_79 = pg.ship_skin_template[var0_79].skin_type
	local var2_79

	if var1_79 == ShipSkin.SKIN_TYPE_TB then
		var2_79 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_79))
	else
		local var3_79 = pg.ship_skin_template[var0_79].ship_group
		local var4_79 = ShipGroup.getDefaultShipConfig(var3_79)

		var2_79 = Ship.New({
			noChangeSkin = true,
			configId = var4_79.id,
			skin_id = var0_79
		})
	end

	local var5_79 = SpinePainting.GenerateData({
		ship = var2_79,
		position = Vector3(0, 0, 0),
		parent = arg0_79.spTF,
		effectParent = arg0_79.spBg,
		offset = var2_79:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_79.spinePainting = SpinePainting.New(var5_79, function(arg0_80)
		arg0_80:SetShopHx(true)

		if arg0_79.paintingState and arg0_79.paintingState.id ~= arg1_79.id then
			arg0_79:ClearSpinePainting()
		end

		local var0_80 = arg0_80._tf:Find("shop_hx")

		arg0_79:CheckShowShopHx(var0_80)

		local var1_80 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_80 = arg0_80._tf:Find("shop_hx_ch" .. var1_80)

		arg0_79:CheckShowShopHx(var2_80)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_81)
	if arg0_81.spinePainting and arg0_81.spinePainting._tf then
		local var0_81 = arg0_81.spinePainting._tf:Find("shop_hx")

		arg0_81:RevertShopHx(arg0_81.shopHx)
		arg0_81.spinePainting:Dispose()

		arg0_81.spinePainting = nil
	end
end

function var0_0.CheckShowShopHx(arg0_82, arg1_82)
	if IsNil(arg1_82) then
		return
	end

	setActive(arg1_82, false)

	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	setActive(arg1_82, true)
end

function var0_0.RevertShopHx(arg0_83, arg1_83)
	if not IsNil(arg1_83) then
		setActive(arg1_83, false)
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_84, arg1_84, arg2_84)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_84 = 1

	arg1_84:changeParamaterValue("shop_hx", var0_84)
end

function var0_0.RevertShopHxForL2d(arg0_85, arg1_85)
	arg1_85:changeParamaterValue("shop_hx", 0)
end

function var0_0.AdjustPainting(arg0_86, arg1_86)
	local var0_86 = arg0_86.paintingTF
	local var1_86 = pg.ship_skin_newmainui_shift[arg0_86.skinId]

	if var1_86 then
		local var2_86 = var1_86.skin_shop_shift

		if arg1_86 then
			var0_86.anchoredPosition = Vector2(var2_86[1] - 440, var2_86[2] + arg0_86.defaultPaintingPosition.y)
		else
			var0_86.anchoredPosition = Vector2(var2_86[1] + arg0_86.defaultPaintingPosition.x, var2_86[2] + arg0_86.defaultPaintingPosition.y)
		end

		local var3_86 = var2_86[4]

		var0_86.localScale = Vector3(var3_86, var3_86, 1)
	else
		var0_86.anchoredPosition = Vector2(arg0_86.defaultPaintingPosition.x, arg0_86.defaultPaintingPosition.y)
		var0_86.localScale = arg0_86.defaultPaintingScale
	end
end

function var0_0.FlushBG(arg0_87, arg1_87, arg2_87)
	local var0_87 = arg0_87.skinId
	local var1_87 = pg.ship_skin_template[var0_87]
	local var2_87

	if var1_87.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_87 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_87))
	else
		local var3_87 = ShipGroup.getDefaultShipConfig(var1_87.ship_group)

		var2_87 = Ship.New({
			id = 999,
			configId = var3_87.id,
			skin_id = var0_87
		})
	end

	local var4_87 = var2_87:getShipBgPrint(true)
	local var5_87 = pg.ship_skin_template[var0_87].painting

	if (arg0_87.isToggleShowBg or not checkABExist("painting/" .. var5_87 .. "_n")) and var1_87.bg_sp ~= "" then
		var4_87 = var1_87.bg_sp
	end

	local var6_87 = var4_87 ~= var2_87:rarity2bgPrintForGet()

	if var6_87 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_87, var4_87, arg0_87.bgs:Find("diffBg"), arg0_87.bgs:Find("diffBg/bg"), function(arg0_88)
			if arg2_87 then
				arg2_87()
			end
		end, function(arg0_89)
			if arg2_87 then
				arg2_87()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_87:getUIName())

		if arg2_87 then
			arg2_87()
		end
	end

	setActive(arg0_87.bgs:Find("diffBg"), var6_87)
	setActive(arg0_87.bgs:Find("default"), not var6_87)
end

function var0_0.FlushDynamicPaintingResState(arg0_90, arg1_90)
	if not arg0_90.isToggleDynamic then
		return
	end

	local var0_90 = arg0_90:GetPaintingState(arg1_90)
	local var1_90 = false
	local var2_90 = ""
	local var3_90 = pg.ship_skin_template[arg0_90.skinId].painting

	if var2_0 == var0_90 then
		var1_90, var2_90 = arg0_90:ExistL2dRes(var3_90)
	elseif var3_0 == var0_90 then
		var1_90, var2_90 = arg0_90:ExistSpineRes(var3_90)
	end

	setActive(arg0_90.dynamicResToggle, not var1_90)
	removeOnButton(arg0_90.dynamicResToggle)

	if not var1_90 and var2_90 ~= "" then
		onButton(arg0_90, arg0_90.dynamicResToggle, function()
			arg0_90:DownloadDynamicPainting(var2_90, arg1_90)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_92, arg1_92, arg2_92)
	local var0_92 = arg0_92.skinId

	if arg0_92.downloads[var0_92] then
		return
	end

	local var1_92 = SkinShopDownloadRequest.New()

	arg0_92.downloads[var0_92] = var1_92

	var1_92:Start(arg1_92, function(arg0_93)
		if arg0_93 and arg0_92.paintingState and arg0_92.paintingState.id == arg2_92.id then
			arg0_92:FlushPainting(arg2_92)
			arg0_92:FlushDynamicPaintingResState(arg2_92)
		end

		var1_92:Dispose()

		arg0_92.downloads[var0_92] = nil
	end)
end

function var0_0.GetPaintingState(arg0_94, arg1_94)
	if arg0_94.isToggleDynamic and (arg0_94.shipSkin:IsLive2d() or arg0_94.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_94.isToggleDynamic and (arg0_94.shipSkin:IsSpine() or arg0_94.shipSkin:IsSpinePlus()) then
		if arg0_94.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_95, arg1_95)
	local var0_95 = "live2d/" .. string.lower(arg1_95)
	local var1_95 = HXSet.autoHxShiftPath(var0_95, nil, true)

	return checkABExist(var1_95), var1_95
end

function var0_0.ExistSpineRes(arg0_96, arg1_96)
	local var0_96 = "SpinePainting/" .. string.lower(arg1_96)
	local var1_96 = HXSet.autoHxShiftPath(var0_96, nil, true)

	return checkABExist(var1_96), var1_96
end

function var0_0.RecordFlag(arg0_97, arg1_97)
	local var0_97 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_97, arg1_97 and 1 or 0)
	PlayerPrefs.Save()
	arg0_97:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_97)
end

function var0_0.FlushPrice(arg0_98, arg1_98)
	local var0_98 = arg1_98:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_98 = arg1_98.type == Goods.TYPE_ACTIVITY or arg1_98.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_98 then
		if arg0_98.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_98:UpdateExperiencePrice4Item(arg1_98)
		else
			arg0_98:UpdateExperiencePrice(arg1_98)
		end
	elseif arg0_98.isPreviewFurniture then
		arg0_98:UpdateFurniturePrice(arg1_98)
	elseif var1_98 then
		-- block empty
	else
		arg0_98:UpdateCommodityPrice(arg1_98)
	end

	local var2_98 = arg1_98.type == Goods.TYPE_SKIN

	setActive(arg0_98.price:Find("timeLimit"), var0_98 and not var1_98)
	setActive(arg0_98.price:Find("normal/consume"), var2_98 and not var0_98 and not var1_98)
end

function var0_0.UpdateExperiencePrice4Item(arg0_99, arg1_99)
	local var0_99 = arg1_99:getConfig("resource_num")
	local var1_99 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_99 = _.detect(var1_99, function(arg0_100)
		return arg0_100:CanUseForShop(arg1_99.id)
	end)
	local var3_99 = var2_99 and var2_99.count or 0
	local var4_99 = (var3_99 < var0_99 and "<color=" .. COLOR_RED .. ">" or "") .. var3_99 .. (var3_99 < var0_99 and "</color>" or "")

	setText(arg0_99.price:Find("timeLimit/consume/Text"), var4_99 .. "/" .. var0_99)
end

function var0_0.UpdateExperiencePrice(arg0_101, arg1_101)
	local var0_101 = arg1_101:getConfig("resource_num")
	local var1_101 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_101 = (var1_101 < var0_101 and "<color=" .. COLOR_RED .. ">" or "") .. var1_101 .. (var1_101 < var0_101 and "</color>" or "")

	setText(arg0_101.price:Find("timeLimit/consume/Text"), var2_101 .. "/" .. var0_101)
end

function var0_0.UpdateCommodityPrice(arg0_102, arg1_102)
	local var0_102 = arg1_102:GetPrice()
	local var1_102 = arg1_102:getConfig("resource_num")

	setText(arg0_102.price:Find("normal/consume/Text"), var0_102)
	setText(arg0_102.price:Find("normal/consume/originalprice/Text"), var1_102)
	setActive(arg0_102.price:Find("normal/consume/originalprice"), var0_102 ~= var1_102)
end

function var0_0.UpdateFurniturePrice(arg0_103, arg1_103)
	local var0_103 = Goods.Id2FurnitureId(arg1_103.id)
	local var1_103 = Furniture.New({
		id = var0_103
	})
	local var2_103 = var1_103:getConfig("gem_price")

	setText(arg0_103.price:Find("normal/consume/originalprice/Text"), var2_103)

	local var3_103 = var1_103:getPrice(PlayerConst.ResDiamond)

	setText(arg0_103.price:Find("normal/consume/Text"), var3_103)
	setActive(arg0_103.price:Find("normal/consume/originalprice"), var2_103 ~= var3_103)
end

local function var21_0(arg0_104, arg1_104)
	if arg0_104 == var6_0 or arg0_104 == var9_0 or arg0_104 == var8_0 then
		return false
	end

	local var0_104 = arg1_104:getSkinId()

	return getProxy(ShopsProxy):CanPurchasedByCharge(var0_104)
end

function var0_0.UpdateChargeView(arg0_105, arg1_105, arg2_105, arg3_105)
	local var0_105 = arg1_105 == var4_0
	local var1_105 = arg0_105.btnsList[2]

	setActive(var1_105:Find("buy_charge"), not var0_105)

	local var2_105 = pg.pay_data_display[arg3_105]

	assert(var2_105, "pay_data_display>>>>>>>>>>>>>" .. arg3_105)

	local var3_105 = GetMoneySymbol() .. GetChargePrice(var2_105.money)

	setText(arg0_105.btnsList[2]:Find("buy_charge/value"), var3_105)

	local var4_105 = var1_105.parent:Find("consume")
	local var5_105 = var1_105.parent:Find("rmb")

	setText(var5_105:Find("Text"), var3_105)
	setActive(var5_105:Find("originalprice"), var2_105.cash_show > var2_105.money)
	setText(var5_105:Find("originalprice/Text"), GetChargePrice(var2_105.cash_show))

	local var6_105 = arg2_105:GetPrice()
	local var7_105 = arg2_105:getConfig("resource_num")

	setActive(var4_105:Find("originalprice"), var6_105 ~= var7_105)
	setText(var4_105:Find("Text"), var6_105)
	setText(var4_105:Find("originalprice/Text"), var7_105)
end

function var0_0.FlushObtainBtn(arg0_106, arg1_106)
	local var0_106 = arg0_106:GetObtainBtnState(arg1_106)
	local var1_106 = var19_0(var0_106)
	local var2_106, var3_106 = var21_0(var0_106, arg1_106)

	setActive(arg0_106.btnsList[1].parent, not var2_106)
	setActive(arg0_106.btnsList[2].parent, var2_106)

	local var4_106 = var2_106 and arg0_106.btnsList[2] or arg0_106.btnsList[1]

	for iter0_106 = 0, var4_106.childCount - 1 do
		local var5_106 = var4_106:GetChild(iter0_106)

		setActive(var5_106, var5_106.name == var1_106)
	end

	if var2_106 then
		arg0_106:UpdateChargeView(var0_106, arg1_106, var3_106)
	end

	setActive(arg0_106.price:Find("btn_charge"), var2_106 and var0_106 ~= var4_0)
	setActive(arg0_106.price:Find("btn/item"), var0_106 == var11_0)
	setActive(arg0_106.price:Find("btn/tag"), var0_106 == var11_0)

	if var0_106 == var11_0 then
		arg0_106:FlushGift(arg1_106)
	end

	onButton(arg0_106, arg0_106.price:Find("btn_charge"), function()
		if not var2_106 then
			return
		end

		arg0_106:OpenChargePanel(var3_106)
	end, SFX_PANEL)
	onButton(arg0_106, arg0_106.price:Find("btn"), function()
		local var0_108 = {}
		local var1_108 = SkinCouponActivity.StaticEncoreActTip(arg1_106.id)

		if tobool(var1_108) then
			table.insert(var0_108, function(arg0_109)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Hint"),
					onYes = function()
						if var1_108 and not var1_108:isEnd() then
							arg0_106:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_108.id)
						end
					end,
					onNo = arg0_109
				})
			end)
		end

		if arg1_106:getConfig("genre") == ShopArgs.SkinShop and not arg1_106:IsItemDiscountType() and #SkinCouponActivity.GetOvercountEncoreActs(arg1_106.id) > 0 then
			table.insert(var0_108, function(arg0_111)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Last_Coupon"),
					onYes = arg0_111
				})
			end)
		end

		seriesAsync(var0_108, function()
			if var0_106 == var5_0 or var0_106 == var7_0 or var0_106 == var11_0 then
				arg0_106.purchaseView:ExecuteAction("Show", arg1_106)
			else
				arg0_106:OnClickBtn(var0_106, arg1_106)
			end
		end)
	end, SFX_PANEL)
end

function var0_0.OpenChargePanel(arg0_113, arg1_113)
	local var0_113 = Goods.Create({
		shop_id = arg1_113
	}, Goods.TYPE_CHARGE)

	if ChargeConst.isNeedSetBirth() then
		arg0_113:emit(LatestSkinShopMediator.OPEN_CHARGE_BIRTHDAY)
	else
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = var0_113.id
		})
	end
end

function var0_0.GetObtainBtnState(arg0_114, arg1_114)
	if arg1_114:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_114.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_114.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_114.type == Goods.TYPE_ACTIVITY or arg1_114.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_114.buyCount > 0 then
		return var4_0
	elseif arg1_114:isDisCount() and arg1_114:IsItemDiscountType() then
		return var7_0
	elseif arg1_114:CanUseVoucherType() or arg1_114:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_114:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushGift(arg0_115, arg1_115)
	local var0_115 = arg1_115:GetGiftList()[1]

	updateDrop(arg0_115.price:Find("btn/item/mask/item"), {
		type = var0_115.type,
		id = var0_115.id,
		count = var0_115.count
	})
end

function var0_0.OnClickBtn(arg0_116, arg1_116, arg2_116)
	if arg1_116 == var5_0 or arg1_116 == var7_0 or arg1_116 == var11_0 then
		arg0_116:OnPurchase(arg2_116)
	elseif arg1_116 == var10_0 then
		arg0_116:OnItemPurchase(arg2_116)
	elseif arg1_116 == var6_0 then
		arg0_116:OnActivity(arg2_116)
	elseif arg1_116 == var8_0 then
		arg0_116:OnBackyard(arg2_116)
	elseif arg1_116 == var9_0 then
		if arg0_116.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_116:OnExperience4Item(arg2_116)
		else
			arg0_116:OnExperience(arg2_116)
		end
	end
end

function var0_0.FlushGifgPackBtn(arg0_117, arg1_117)
	local var0_117 = false
	local var1_117
	local var2_117
	local var3_117

	for iter0_117, iter1_117 in pairs(arg0_117.giftSkinCommodities) do
		for iter2_117, iter3_117 in ipairs(iter1_117) do
			if iter3_117.id == arg1_117.id then
				var0_117 = true

				break
			end
		end

		if var0_117 then
			var1_117 = arg0_117.giftPackCommodities[iter0_117]
			var2_117 = arg0_117.giftSkinCommodities[iter0_117]
			var3_117 = arg0_117.giftSkinProbabilitys[iter0_117]

			break
		end
	end

	if var0_117 then
		setText(arg0_117.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip_2"))
		onButton(arg0_117, arg0_117.giftPackBtn, function()
			if not var1_117:isChargeType() then
				return
			end

			local var0_118 = var1_117:GetSkinProbability()
			local var1_118 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_118)

			if #var0_118 <= 0 or #var0_118 ~= #var1_118 then
				arg0_117:emit(LatestSkinShopMediator.OPEN_SCENE, {
					SCENE.CHARGE,
					{
						wrap = ChargeScene.TYPE_PICK
					}
				})
			else
				arg0_117:emit(LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER, var1_117, var2_117, var3_117)
			end
		end, SFX_PANEL)
	else
		var0_117 = getProxy(ActivityProxy):GetFakeGiftPackActivity(arg1_117)

		if var0_117 then
			setText(arg0_117.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip"))
			onButton(arg0_117, arg0_117.giftPackBtn, function()
				arg0_117:emit(LatestSkinShopMediator.OPEN_GIFT_ACT_LAYER, var0_117.id)
			end, SFX_PANEL)
		end
	end

	setActive(arg0_117.giftPackBtn, var0_117)
end

function var0_0.SetGiftPackLayer(arg0_120)
	return
end

function var0_0.OnPurchase(arg0_121, arg1_121)
	if arg1_121.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_121:isDisCount() and arg1_121:IsItemDiscountType() then
		arg0_121:emit(LatestSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_121.id, 1)
	else
		arg0_121:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_121.id, 1)
	end
end

function var0_0.OnItemPurchase(arg0_122, arg1_122)
	if arg1_122.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_122 = arg1_122:GetVoucherIdList()
	local var1_122 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_122.id)

	if #var0_122 <= 0 and #var1_122 <= 0 then
		return
	end

	local var2_122 = {}

	for iter0_122, iter1_122 in ipairs(var0_122) do
		table.insert(var2_122, iter1_122)
	end

	for iter2_122, iter3_122 in ipairs(var1_122) do
		table.insert(var2_122, iter3_122.id)
	end

	local var3_122 = arg0_122.skinId
	local var4_122 = pg.ship_skin_template[var3_122]
	local var5_122 = SwitchSpecialChar(var4_122.name, true)

	arg0_122.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_122,
		skinId = var3_122,
		skinName = var5_122,
		price = arg1_122:GetPrice(),
		onYes = function(arg0_123)
			if arg0_123 then
				arg0_122:emit(LatestSkinShopMediator.ON_ITEM_PURCHASE, arg0_123, arg1_122.id)
			else
				arg0_122:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_122.id, 1)
			end
		end
	})
end

function var0_0.OnActivity(arg0_124, arg1_124)
	local var0_124 = arg1_124:getConfig("time")
	local var1_124 = arg1_124:getConfig("activity")
	local var2_124 = getProxy(ActivityProxy):getActivityById(var1_124)

	if var1_124 == 0 and pg.TimeMgr.GetInstance():inTime(var0_124) or var2_124 and not var2_124:isEnd() then
		if arg1_124.type == Goods.TYPE_ACTIVITY then
			arg0_124:emit(LatestSkinShopMediator.GO_SHOPS_LAYER, arg1_124:getConfig("activity"))
		elseif arg1_124.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_124 = arg1_124:getConfig("scene")

			if var3_124 and #var3_124 > 0 then
				arg0_124:emit(LatestSkinShopMediator.OPEN_SCENE, var3_124)
			else
				arg0_124:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_124)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_125, arg1_125)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_125 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_125.name, var0_125.level))

		return
	end

	arg0_125:emit(LatestSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_126, arg1_126)
	local var0_126 = arg0_126.skinId
	local var1_126 = getProxy(ShipSkinProxy):getSkinById(var0_126)

	if var1_126 and not var1_126:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_126 = arg1_126:getConfig("resource_num")
	local var3_126 = arg1_126:getConfig("time_second") * var2_126
	local var4_126, var5_126, var6_126, var7_126 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_126)
	local var8_126 = pg.ship_skin_template[arg0_126.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_126, var8_126, var4_126, var5_126),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_126 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_126:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_126.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_128, arg1_128)
	local var0_128 = arg0_128.skinId
	local var1_128 = getProxy(ShipSkinProxy):getSkinById(var0_128)

	if var1_128 and not var1_128:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_128 = arg1_128:getConfig("resource_num")
	local var3_128 = arg1_128:getConfig("time_second") * var2_128
	local var4_128, var5_128, var6_128, var7_128 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_128)
	local var8_128 = pg.ship_skin_template[arg0_128.skinId].name
	local var9_128 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_128 = _.detect(var9_128, function(arg0_129)
		return arg0_129:CanUseForShop(arg1_128.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_128, var8_128, var4_128, var5_128),
		onYes = function()
			if not var10_128 or var10_128.count < var2_128 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_128:emit(LatestSkinShopMediator.ON_ITEM_EXPERIENCE, var10_128.id, arg1_128.id, 1)
		end
	})
end

function var0_0.SetFilterPanel(arg0_131)
	local var0_131 = arg0_131.filterContent:Find("own/options")
	local var1_131 = arg0_131.filterContent:Find("type/options")
	local var2_131 = arg0_131.filterContent:Find("shipHave/options")
	local var3_131 = arg0_131.filterContent:Find("camp/options")
	local var4_131 = arg0_131.filterContent:Find("rarity/options")
	local var5_131 = arg0_131.filterContent:Find("shipType/options")
	local var6_131 = arg0_131.filterContent:Find("themeType/options")
	local var7_131 = arg0_131.filterContent:Find("tag/options")

	arg0_131:SetOptionList(var3_131, ShipIndexConst.CampNames, true)
	arg0_131:SetOptionList(var4_131, ShipIndexConst.RarityNames, true)
	arg0_131:SetOptionList(var5_131, ShipIndexConst.TypeNames, true)
	arg0_131:SetOptionList(var6_131, arg0_131.classifyNames)
	arg0_131:SetSingleOptions(var0_131, "ownType")
	arg0_131:SetMultiOptions(var1_131, "typeType")
	arg0_131:SetSingleOptions(var2_131, "shipHaveType")
	arg0_131:SetMultiOptions(var3_131, "campType")
	arg0_131:SetMultiOptions(var4_131, "rarityType")
	arg0_131:SetMultiOptions(var5_131, "shipType")
	arg0_131:SetMultiOptions(var6_131, "themeType")
	arg0_131:SetMultiOptions(var7_131, "tagType")
	arg0_131:HideEmptyOptions()
	onButton(arg0_131, arg0_131.filterUI:Find("bg"), function()
		for iter0_132, iter1_132 in pairs(arg0_131.filterValues) do
			arg0_131.filterValuesTemp[iter0_132] = Clone(arg0_131.filterValues[iter0_132])
		end

		setActive(arg0_131.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_131, arg0_131.filterUI:Find("panelMask/panel/closeBtn"), function()
		for iter0_133, iter1_133 in pairs(arg0_131.filterValues) do
			arg0_131.filterValuesTemp[iter0_133] = Clone(arg0_131.filterValues[iter0_133])
		end

		setActive(arg0_131.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_131, arg0_131.filterUI:Find("panelMask/panel/bottom/ok"), function()
		for iter0_134, iter1_134 in pairs(arg0_131.filterValues) do
			arg0_131.filterValues[iter0_134] = Clone(arg0_131.filterValuesTemp[iter0_134])
		end

		setActive(arg0_131.filterUI, false)
		arg0_131:Refresh(true)
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_135)
	setActive(arg0_135.filterUI, true)

	local var0_135 = arg0_135.filterContent:Find("own/options")
	local var1_135 = arg0_135.filterContent:Find("type/options")
	local var2_135 = arg0_135.filterContent:Find("shipHave/options")
	local var3_135 = arg0_135.filterContent:Find("camp/options")
	local var4_135 = arg0_135.filterContent:Find("rarity/options")
	local var5_135 = arg0_135.filterContent:Find("shipType/options")
	local var6_135 = arg0_135.filterContent:Find("themeType/options")
	local var7_135 = arg0_135.filterContent:Find("tag/options")

	arg0_135:SetSingleOptions(var0_135, "ownType", true)
	arg0_135:SetMultiOptions(var1_135, "typeType", true)
	arg0_135:SetSingleOptions(var2_135, "shipHaveType", true)
	arg0_135:SetMultiOptions(var3_135, "campType", true)
	arg0_135:SetMultiOptions(var4_135, "rarityType", true)
	arg0_135:SetMultiOptions(var5_135, "shipType", true)
	arg0_135:SetMultiOptions(var6_135, "themeType", true)
	arg0_135:SetMultiOptions(var7_135, "tagType", true)
end

function var0_0.SetOptionList(arg0_136, arg1_136, arg2_136, arg3_136)
	local var0_136 = UIItemList.New(arg1_136, arg1_136:GetChild(0))

	var0_136:make(function(arg0_137, arg1_137, arg2_137)
		if arg0_137 == UIItemList.EventUpdate then
			local var0_137 = arg2_136[arg1_137 + 1]

			if arg3_136 then
				var0_137 = i18n(var0_137)
			end

			arg2_137.name = arg1_137

			setScrollText(arg2_137:Find("mask/Text"), var0_137)
		end
	end)
	var0_136:align(#arg2_136)
end

function var0_0.SetSingleOptions(arg0_138, arg1_138, arg2_138, arg3_138)
	for iter0_138 = 0, arg1_138.childCount - 1 do
		local var0_138 = arg1_138:GetChild(iter0_138)

		arg0_138:SetOptionSelect(arg1_138:GetChild(iter0_138), iter0_138 == arg0_138.filterValuesTemp[arg2_138])

		if not arg3_138 then
			onButton(arg0_138, var0_138, function()
				arg0_138.filterValuesTemp[arg2_138] = iter0_138

				for iter0_139 = 0, arg1_138.childCount - 1 do
					arg0_138:SetOptionSelect(arg1_138:GetChild(iter0_139), iter0_139 == iter0_138)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_140, arg1_140, arg2_140, arg3_140)
	for iter0_140 = 0, arg1_140.childCount - 1 do
		local var0_140 = arg1_140:GetChild(iter0_140)

		arg0_140:SetOptionSelect(arg1_140:GetChild(iter0_140), table.contains(arg0_140.filterValuesTemp[arg2_140], iter0_140))

		if not arg3_140 then
			onButton(arg0_140, var0_140, function()
				if iter0_140 == 0 then
					arg0_140.filterValuesTemp[arg2_140] = {
						0
					}

					for iter0_141 = 0, arg1_140.childCount - 1 do
						arg0_140:SetOptionSelect(arg1_140:GetChild(iter0_141), iter0_141 == 0)
					end
				else
					table.removebyvalue(arg0_140.filterValuesTemp[arg2_140], 0)

					if table.contains(arg0_140.filterValuesTemp[arg2_140], iter0_140) then
						table.removebyvalue(arg0_140.filterValuesTemp[arg2_140], iter0_140)
					else
						table.insert(arg0_140.filterValuesTemp[arg2_140], iter0_140)
					end

					local var0_141 = true

					for iter1_141 = 1, arg1_140.childCount - 1 do
						if not table.contains(arg0_140.filterValuesTemp[arg2_140], iter1_141) and arg1_140:GetChild(iter1_141).gameObject.activeSelf then
							var0_141 = false

							break
						end
					end

					if #arg0_140.filterValuesTemp[arg2_140] == 0 then
						var0_141 = true
					end

					if var0_141 and arg2_140 ~= "tagType" then
						arg0_140.filterValuesTemp[arg2_140] = {
							0
						}
					end

					for iter2_141 = 0, arg1_140.childCount - 1 do
						arg0_140:SetOptionSelect(arg1_140:GetChild(iter2_141), table.contains(arg0_140.filterValuesTemp[arg2_140], iter2_141))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_142, arg1_142, arg2_142)
	setActive(arg1_142:Find("selectedFrame"), arg2_142)

	local var0_142

	if IsNil(arg1_142:Find("Text")) then
		var0_142 = arg1_142:Find("mask/Text"):GetComponent(typeof(Text))
	else
		var0_142 = arg1_142:Find("Text"):GetComponent(typeof(Text))
	end

	if arg2_142 then
		var0_142.color = Color.New(1, 1, 1, 1)
	else
		var0_142.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.HideEmptyOptions(arg0_143, arg1_143, arg2_143)
	local var0_143 = {
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

	for iter0_143, iter1_143 in ipairs(arg0_143.commodities) do
		local var1_143 = iter1_143:getSkinId()
		local var2_143 = ShipSkin.New({
			id = var1_143
		})
		local var3_143 = arg0_143:GetSkinType(var2_143)

		for iter2_143, iter3_143 in ipairs(var3_143) do
			if not table.keyof(var0_143.typeType, iter3_143) then
				table.insert(var0_143.typeType, iter3_143)
			end
		end

		local var4_143 = arg0_143:GetShipHave(var2_143)

		if not table.keyof(var0_143.shipHaveType, var4_143) then
			table.insert(var0_143.shipHaveType, var4_143)
		end

		local var5_143 = arg0_143:GetCampType(var2_143)

		if not table.keyof(var0_143.campType, var5_143) then
			table.insert(var0_143.campType, var5_143)
		end

		local var6_143 = arg0_143:GetRarityType(var2_143)

		if not table.keyof(var0_143.rarityType, var6_143) then
			table.insert(var0_143.rarityType, var6_143)
		end

		local var7_143 = arg0_143:GetShipType(var2_143)

		if not table.keyof(var0_143.shipType, var7_143) then
			table.insert(var0_143.shipType, var7_143)
		end

		local var8_143 = arg0_143:GetTagType(iter1_143)

		if not table.keyof(var0_143.tagType, var8_143) then
			table.insert(var0_143.tagType, var8_143)
		end
	end

	for iter4_143, iter5_143 in pairs(var0_143) do
		table.sort(iter5_143, function(arg0_144, arg1_144)
			return arg0_144 < arg1_144
		end)
	end

	for iter6_143 = 1, arg0_143.uiTypeOptions.childCount - 1 do
		setActive(arg0_143.uiTypeOptions:GetChild(iter6_143), table.contains(var0_143.typeType, iter6_143))
	end

	for iter7_143 = 1, arg0_143.uiShipHaveOptions.childCount - 1 do
		setActive(arg0_143.uiShipHaveOptions:GetChild(iter7_143), table.contains(var0_143.shipHaveType, iter7_143))
	end

	for iter8_143 = 1, arg0_143.uiCampOptions.childCount - 1 do
		setActive(arg0_143.uiCampOptions:GetChild(iter8_143), table.contains(var0_143.campType, iter8_143))
	end

	for iter9_143 = 1, arg0_143.uiRrarityOptions.childCount - 1 do
		setActive(arg0_143.uiRrarityOptions:GetChild(iter9_143), table.contains(var0_143.rarityType, iter9_143))
	end

	for iter10_143 = 1, arg0_143.uiShipTypeOptions.childCount - 1 do
		setActive(arg0_143.uiShipTypeOptions:GetChild(iter10_143), table.contains(var0_143.shipType, iter10_143))
	end

	for iter11_143 = 1, arg0_143.uiTagTypeOptions.childCount - 1 do
		setActive(arg0_143.uiTagTypeOptions:GetChild(iter11_143), table.contains(var0_143.tagType, iter11_143))
	end
end

function var0_0.GetSkinType(arg0_145, arg1_145)
	local var0_145 = {}

	if arg1_145:IsLive2d() or arg1_145:IsLive2dPlus() then
		table.insert(var0_145, 1)
	end

	if not arg1_145:IsLive2d() and not arg1_145:IsLive2dPlus() and not arg1_145:IsSpine() and not arg1_145:IsSpinePlus() then
		table.insert(var0_145, 2)
	end

	if arg1_145:IsSpine() or arg1_145:IsSpinePlus() then
		table.insert(var0_145, 3)
	end

	if arg1_145:IsBG() then
		table.insert(var0_145, 4)
	end

	if arg1_145:IsDbg() then
		table.insert(var0_145, 5)
	end

	if arg1_145:isBgm() then
		table.insert(var0_145, 6)
	end

	return var0_145
end

function var0_0.GetShipHave(arg0_146, arg1_146)
	if arg1_146:CantUse() then
		return 2
	else
		return 1
	end
end

function var0_0.GetCampType(arg0_147, arg1_147)
	local var0_147 = arg1_147:GetDefaultShipConfig()

	if not var0_147 then
		return 0
	end

	local var1_147 = arg0_147:ToVShip(var0_147):getNation()
	local var2_147 = ShipIndexCfg.camp

	for iter0_147, iter1_147 in ipairs(var2_147) do
		for iter2_147, iter3_147 in ipairs(iter1_147.types) do
			if iter3_147 == Nation.LINK then
				if var1_147 >= Nation.LINK then
					return iter0_147 - 1
				end
			elseif var1_147 == iter3_147 then
				return iter0_147 - 1
			end
		end
	end

	return 0
end

function var0_0.GetRarityType(arg0_148, arg1_148)
	local var0_148 = arg1_148:GetDefaultShipConfig()

	if not var0_148 then
		return 0
	end

	local var1_148 = arg0_148:ToVShip(var0_148):getRarity()
	local var2_148 = ShipIndexCfg.rarity

	for iter0_148, iter1_148 in ipairs(var2_148) do
		if table.contains(iter1_148.types, var1_148) then
			return iter0_148 - 1
		end
	end

	return 0
end

function var0_0.GetShipType(arg0_149, arg1_149)
	local var0_149 = arg1_149:GetDefaultShipConfig()

	if not var0_149 then
		return 0
	end

	local var1_149 = arg0_149:ToVShip(var0_149):getShipType()
	local var2_149 = ShipIndexCfg.type

	for iter0_149, iter1_149 in ipairs(var2_149) do
		for iter2_149, iter3_149 in pairs(iter1_149) do
			if table.keyof(iter3_149, var1_149) then
				return iter0_149 - 1
			end
		end
	end

	return 0
end

function var0_0.GetTagType(arg0_150, arg1_150)
	local var0_150 = table.contains(arg0_150.returnSkins, arg1_150.id)
	local var1_150 = NewShopSkinCard.GetTagId(arg1_150, var0_150)

	if var1_150 > 0 then
		return var1_150
	else
		return 0
	end
end

function var0_0.GetSkinClassify(arg0_151)
	arg0_151.classifyIds = {}
	arg0_151.classifyNames = {}

	local var0_151 = {}
	local var1_151 = {}

	for iter0_151, iter1_151 in ipairs(arg0_151.commodities) do
		local var2_151 = arg0_151:GetShopTypeIdBySkinId(iter1_151:getSkinId())
		local var3_151 = var2_151 == 0 and var16_0 or var2_151

		var1_151[var3_151] = (var1_151[var3_151] or 0) + 1
	end

	local var4_151 = {}

	for iter2_151, iter3_151 in ipairs(arg0_151.returnSkins) do
		var4_151[iter3_151] = true
	end

	if underscore.any(arg0_151.commodities, function(arg0_152)
		return var4_151[arg0_152.id]
	end) then
		table.insert(var0_151, var14_0)
	end

	for iter4_151, iter5_151 in ipairs(pg.skin_page_template.all) do
		if iter5_151 ~= var17_0 and iter5_151 ~= var18_0 and (var1_151[iter5_151] or 0) > 0 then
			table.insert(var0_151, iter5_151)
		end
	end

	if arg0_151.mode == var0_0.MODE_EXPERIENCE then
		table.insert(var0_151, 1, var13_0)
	end

	if arg0_151.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_151, 1, var15_0)
	end

	table.insert(var0_151, 1, var12_0)

	arg0_151.classifyIds = var0_151

	for iter6_151, iter7_151 in ipairs(arg0_151.classifyIds) do
		if iter7_151 == var12_0 then
			table.insert(arg0_151.classifyNames, i18n("shop_filter_all"))
		elseif iter7_151 == var13_0 or iter7_151 == var15_0 then
			table.insert(arg0_151.classifyNames, i18n("shop_filter_trial"))
		elseif iter7_151 == var14_0 then
			table.insert(arg0_151.classifyNames, i18n("shop_filter_retro"))
		else
			table.insert(arg0_151.classifyNames, pg.skin_page_template[iter7_151].name)
		end
	end
end

function var0_0.GetShopTypeIdBySkinId(arg0_153, arg1_153)
	local var0_153 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_153.shopTypeIdList then
		arg0_153.shopTypeIdList = {}
	end

	if arg0_153.shopTypeIdList[arg1_153] then
		return arg0_153.shopTypeIdList[arg1_153]
	end

	for iter0_153, iter1_153 in pairs(var0_153) do
		for iter2_153, iter3_153 in ipairs(iter1_153) do
			arg0_153.shopTypeIdList[iter3_153] = iter0_153

			if iter3_153 == arg1_153 then
				return iter0_153
			end
		end
	end
end

function var0_0.OnShopping(arg0_154, arg1_154)
	if not arg0_154.showingCommodity then
		return
	end

	if arg0_154.purchaseView and arg0_154.purchaseView:GetLoaded() then
		arg0_154.purchaseView:Hide()
	end

	if arg0_154.showingCommodity.id == arg1_154 then
		arg0_154.pendingSelectId = arg0_154:GetNextCommodityIndex(arg1_154)

		arg0_154:GetAllCommodities()
		arg0_154:Refresh(false)
	end
end

function var0_0.OnFurnitureUpdate(arg0_155, arg1_155)
	if not arg0_155.showingCommodity then
		return
	end

	local var0_155 = arg0_155.showingCommodity.id

	if Goods.ExistFurniture(var0_155) and Goods.Id2FurnitureId(var0_155) == arg1_155 then
		arg0_155:GetAllCommodities()
		arg0_155:Refresh(true)
	end
end

function var0_0.CheckDownloadSkinList(arg0_156, arg1_156)
	local var0_156 = {}

	for iter0_156, iter1_156 in ipairs(arg0_156.commodities) do
		PaintingGroupConst.AddPaintingNameBySkinID(var0_156, iter1_156:getSkinId())
	end

	local var1_156 = {
		isShowBox = true,
		paintingNameList = var0_156,
		finishFunc = arg1_156
	}

	PaintingGroupConst.PaintingDownload(var1_156)
end

function var0_0.willExit(arg0_157)
	arg0_157:ClearCards()
	ClearLScrollrect(arg0_157.scrollrect)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_157:getUIName())

	if arg0_157.live2dChar then
		arg0_157.live2dChar:Dispose()

		arg0_157.live2dChar = nil
	end

	if arg0_157.voucherMsgBox then
		arg0_157.voucherMsgBox:Destroy()

		arg0_157.voucherMsgBox = nil
	end

	if arg0_157.purchaseView then
		arg0_157.purchaseView:Destroy()

		arg0_157.purchaseView = nil
	end

	for iter0_157, iter1_157 in pairs(arg0_157.downloads) do
		iter1_157:Dispose()
	end

	arg0_157.downloads = {}

	arg0_157:ClearPainting()

	if arg0_157.interactionPreview then
		arg0_157.interactionPreview:Dispose()

		arg0_157.interactionPreview = nil
	end

	arg0_157:disposeEvent()
	arg0_157:ClearTimer()
	arg0_157:ReturnChar()
	arg0_157:UnOverlay()
end

function var0_0.GetNextCommodityIndex(arg0_158, arg1_158)
	for iter0_158, iter1_158 in ipairs(arg0_158.displays) do
		if iter1_158.id == arg1_158 then
			if iter0_158 == #arg0_158.displays then
				return arg1_158
			end

			return arg0_158.displays[iter0_158 + 1].id
		end
	end
end

function var0_0.onBackPressed(arg0_159)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
