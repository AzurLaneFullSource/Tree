local var0_0 = class("LatestSkinShopLayer", import("...base.BaseUI"))

var0_0.TYPE_NEW_SKIN = "newSkin"
var0_0.TYPE_PERMANANT_SKIN = "permanentSkin"
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
	arg0_4.btns = arg0_4.price:Find("btns")
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
	setGray(arg0_4.btns:Find("yigoumai_button"), true, true)
	setText(arg0_4._tf:Find("bgs/empty/Text"), i18n("shop_new_unfound"))
	setText(arg0_4.adapt:Find("top/mainTitle/Text"), i18n("shop_new_shop"))
	setText(arg0_4.filterBtn:Find("Text"), i18n("shop_new_sort"))
	setText(arg0_4.search:Find("holder"), i18n("shop_new_search"))
	setText(arg0_4.btns:Find("yigoumai_button/Text"), i18n("shop_new_purchased"))
	setText(arg0_4.btns:Find("goumai_button/Text"), i18n("shop_new_purchase"))
	setText(arg0_4.btns:Find("qianwanghuoqu_button/Text"), i18n("shop_new_claim"))
	setText(arg0_4.btns:Find("furniture_shop/Text"), i18n("shop_new_furniture"))
	setText(arg0_4.btns:Find("item_buy/Text"), i18n("shop_new_discount"))
	setText(arg0_4.btns:Find("tiyan_btn/Text"), i18n("shop_new_try"))
	setText(arg0_4.btns:Find("buy_with_gift/Text"), i18n("shop_new_purchase"))
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
	setText(arg0_4.filterUI:Find("panelMask/panel/bottom/ok/Text"), i18n("shop_new_confirm"))
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
			arg0_5.price:Find("consume"),
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
		arg0_7:SetSkinScroll()
		arg0_7:Refresh(true)
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

	onToggle(arg0_7, arg0_7.sdTg, function(arg0_12)
		setActive(arg0_7.charContainer, arg0_12)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_7, arg0_12 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_7 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_7, 0)

	triggerToggle(arg0_7.sdTg, var1_7 == 1)
	onToggle(arg0_7, arg0_7.hideUITg, function(arg0_13)
		setActive(arg0_7.top, not arg0_13)
		setActive(arg0_7.bottom, not arg0_13)
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg0_13)
	end, SFX_PANEL)
	onInputChanged(arg0_7, arg0_7.search, function()
		arg0_7:Refresh(true)

		local var0_14 = getInputText(arg0_7.search)

		setActive(arg0_7.search:Find("holder"), var0_14 == "")
	end)
	onButton(arg0_7, arg0_7.showOwnBtn, function()
		arg0_7:emit(LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER)
	end, SFX_PANEL)
	getProxy(CommanderManualProxy):TaskProgressAdd(2021, 1)
end

function var0_0.SetResource(arg0_16)
	local var0_16 = getProxy(PlayerProxy):getRawData()

	setText(arg0_16.resources:Find("gem/Text"), var0_16:getTotalGem())
	onButton(arg0_16, arg0_16.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_18)
	arg0_18.type = arg0_18.contextData.type or var0_0.TYPE_PERMANANT_SKIN
	arg0_18.mode = arg0_18.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_18:GetAllCommodities()
	arg0_18:GetGiftPackCommodities()

	arg0_18.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()

	arg0_18:GetSkinClassify()

	local var0_18 = (arg0_18.mode == var0_0.MODE_EXPERIENCE or arg0_18.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM) and 1 or 0

	arg0_18.filterValues = {
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
			var0_18
		}
	}
	arg0_18.filterValuesTemp = Clone(arg0_18.filterValues)
end

function var0_0.GetAllCommodities(arg0_19)
	if arg0_19.type == var0_0.TYPE_NEW_SKIN then
		arg0_19.commodities = getProxy(ShipSkinProxy):GetInTimeSkins()
	elseif arg0_19.type == var0_0.TYPE_PERMANANT_SKIN then
		arg0_19.commodities = getProxy(ShipSkinProxy):GetPermanentSkins()
	end

	if LOCK_SKIN_US then
		local var0_19 = pg.gameset.levellimit_skintype.key_value
		local var1_19 = pg.gameset.levellimit_skintype.description

		if var0_19 >= getProxy(PlayerProxy):getData().level then
			arg0_19.commodities = _.filter(arg0_19.commodities, function(arg0_20)
				local var0_20 = pg.ship_skin_template[arg0_20:getSkinId()].shop_type_id

				return table.contains(var1_19, var0_20)
			end)
		end
	end

	if arg0_19.mode == var0_0.MODE_OVERVIEW then
		for iter0_19 = #arg0_19.commodities, 1, -1 do
			if arg0_19.commodities[iter0_19]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				table.remove(arg0_19.commodities, iter0_19)
			end
		end
	end
end

function var0_0.GetGiftPackCommodities(arg0_21)
	arg0_21.giftPackCommodities = {}
	arg0_21.giftSkinCommodities = {}
	arg0_21.giftSkinProbabilitys = {}

	for iter0_21, iter1_21 in ipairs(pg.pay_data_display.all) do
		local var0_21 = pg.pay_data_display[iter1_21]

		if var0_21.skin_inquire_relation ~= 0 and pg.TimeMgr.GetInstance():inTime(var0_21.time) then
			local var1_21 = getProxy(ShopsProxy):GetGiftCommodity(iter1_21, Goods.TYPE_CHARGE)

			arg0_21.giftPackCommodities[iter1_21] = var1_21

			local var2_21 = var1_21:GetSkinProbability()

			arg0_21.giftSkinCommodities[iter1_21] = getProxy(ShipSkinProxy):GetProbabilitySkins(var2_21)
			arg0_21.giftSkinProbabilitys[iter1_21] = getProxy(ShipSkinProxy):GetSkinProbabilitys(var2_21)
		end
	end
end

function var0_0.SetSkinScroll(arg0_22)
	arg0_22.scrollrect.isNewLoadingMethod = true

	function arg0_22.scrollrect.onInitItem(arg0_23)
		arg0_22:OnInitItem(arg0_23)
	end

	function arg0_22.scrollrect.onUpdateItem(arg0_24, arg1_24)
		arg0_22:OnUpdateItem(arg0_24, arg1_24)
	end

	arg0_22.scrollrect.enabled = true
end

function var0_0.Refresh(arg0_25, arg1_25)
	arg0_25:ClearCards()

	arg0_25.cards = {}
	arg0_25.displays = {}

	local var0_25 = getInputText(arg0_25.search)

	for iter0_25, iter1_25 in ipairs(arg0_25.commodities) do
		if arg0_25:filterOk(iter1_25) and arg0_25:IsSearchType(var0_25, iter1_25) then
			table.insert(arg0_25.displays, iter1_25)
		end
	end

	local var1_25 = {}

	for iter2_25, iter3_25 in ipairs(arg0_25.displays) do
		local var2_25 = iter3_25.type == Goods.TYPE_ACTIVITY or iter3_25.type == Goods.TYPE_ACTIVITY_EXTRA
		local var3_25 = 0

		if not var2_25 then
			var3_25 = iter3_25:GetPrice()
		end

		var1_25[iter3_25.id] = var3_25
	end

	table.sort(arg0_25.displays, function(arg0_26, arg1_26)
		return arg0_25:Sort(arg0_26, arg1_26, var1_25)
	end)

	local var4_25 = #arg0_25.displays == 0

	setActive(arg0_25.bgs:Find("default"), var4_25)
	setActive(arg0_25.bgs:Find("diffBg"), not var4_25)
	setActive(arg0_25.bgs:Find("empty"), var4_25)
	setActive(arg0_25._tf:Find("leftMask"), not var4_25)
	setActive(arg0_25._tf:Find("bottomMask"), not var4_25)
	setActive(arg0_25.painting, not var4_25)
	setActive(arg0_25.top:Find("title"), not var4_25)
	setActive(arg0_25.changeSkin, not var4_25)
	setActive(arg0_25.right, not var4_25)
	setActive(arg0_25.right, not var4_25)
	setActive(arg0_25.bottom:Find("scroll"), not var4_25)

	if not var4_25 then
		if arg1_25 then
			arg0_25.triggerFirstCard = true

			arg0_25.scrollrect:SetTotalCount(#arg0_25.displays, 0)
		else
			arg0_25.scrollrect:SetTotalCount(#arg0_25.displays)
		end
	end
end

function var0_0.IsSearchType(arg0_27, arg1_27, arg2_27)
	if not arg1_27 or arg1_27 == "" then
		return true
	end

	local var0_27 = arg2_27:getSkinId()

	return ShipSkin.New({
		id = var0_27
	}):IsMatchKey(arg1_27)
end

local function var20_0(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28[arg0_28.id]
	local var1_28 = arg2_28[arg1_28.id]

	if var0_28 == var1_28 then
		return arg0_28.id < arg1_28.id
	else
		return var1_28 < var0_28
	end
end

function var0_0.Sort(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg1_29.buyCount == 0 and 1 or 0
	local var1_29 = arg2_29.buyCount == 0 and 1 or 0

	if var0_29 == var1_29 then
		local var2_29 = arg1_29:getConfig("order")
		local var3_29 = arg2_29:getConfig("order")

		if var2_29 == var3_29 then
			return var20_0(arg1_29, arg2_29, arg3_29)
		else
			return var2_29 < var3_29
		end
	else
		return var1_29 < var0_29
	end
end

function var0_0.filterOk(arg0_30, arg1_30)
	local var0_30 = arg0_30.filterValues.ownType
	local var1_30 = arg0_30.filterValues.typeType
	local var2_30 = arg0_30.filterValues.shipHaveType
	local var3_30 = arg0_30.filterValues.campType
	local var4_30 = arg0_30.filterValues.rarityType
	local var5_30 = arg0_30.filterValues.shipType
	local var6_30 = arg0_30.filterValues.themeType
	local var7_30 = arg1_30:getSkinId()
	local var8_30 = ShipSkin.New({
		id = var7_30
	})
	local var9_30 = var8_30:GetDefaultShipConfig()
	local var10_30 = arg0_30:ToVShip(var9_30)

	if var0_30 ~= 0 then
		local var11_30 = false
		local var12_30 = getProxy(ShipSkinProxy):hasSkin(var7_30)
		local var13_30 = var8_30:NoUse()

		if var0_30 == 1 and var12_30 then
			var11_30 = true
		end

		if var0_30 == 2 and not var12_30 then
			var11_30 = true
		end

		if var0_30 == 3 and var12_30 and var13_30 then
			var11_30 = true
		end

		if not var11_30 then
			return false
		end
	end

	if var1_30[1] ~= 0 then
		local var14_30 = false

		for iter0_30, iter1_30 in ipairs(var1_30) do
			if iter1_30 == 1 and (var8_30:IsLive2d() or var8_30:IsLive2dPlus()) then
				var14_30 = true
			end

			if iter1_30 == 2 and not var8_30:IsLive2d() and not var8_30:IsLive2dPlus() and not var8_30:IsSpine() and not var8_30:IsSpinePlus() then
				var14_30 = true
			end

			if iter1_30 == 3 and (var8_30:IsSpine() or var8_30:IsSpinePlus()) then
				var14_30 = true
			end

			if iter1_30 == 4 and var8_30:IsBG() then
				var14_30 = true
			end

			if iter1_30 == 5 and var8_30:IsDbg() then
				var14_30 = true
			end

			if iter1_30 == 6 and var8_30:isBgm() then
				var14_30 = true
			end

			if var14_30 then
				break
			end
		end

		if not var14_30 then
			return false
		end
	end

	if var2_30 ~= 0 then
		local var15_30 = false
		local var16_30 = var8_30:CantUse()

		if var2_30 == 1 and not var16_30 then
			var15_30 = true
		end

		if var2_30 == 2 and var16_30 then
			var15_30 = true
		end

		if not var15_30 then
			return false
		end
	end

	if var3_30[1] ~= 0 then
		local var17_30 = false

		for iter2_30, iter3_30 in ipairs(var3_30) do
			local var18_30 = ShipIndexCfg.camp

			for iter4_30, iter5_30 in ipairs(var18_30[iter3_30 + 1].types) do
				if iter5_30 == Nation.LINK then
					if var10_30:getNation() >= Nation.LINK then
						var17_30 = true
					end
				elseif iter5_30 == var10_30:getNation() then
					var17_30 = true
				end
			end

			if var17_30 then
				break
			end
		end

		if not var17_30 then
			return false
		end
	end

	if var4_30[1] ~= 0 then
		local var19_30 = false

		for iter6_30, iter7_30 in ipairs(var4_30) do
			local var20_30 = ShipIndexCfg.rarity

			if table.contains(var20_30[iter7_30 + 1].types, var10_30:getRarity()) then
				var19_30 = true
			end

			if var19_30 then
				break
			end
		end

		if not var19_30 then
			return false
		end
	end

	if var5_30[1] ~= 0 then
		local var21_30 = false

		for iter8_30, iter9_30 in ipairs(var5_30) do
			local var22_30 = ShipIndexCfg.type
			local var23_30 = var22_30[iter9_30 + 1].types

			if iter9_30 + 1 < 4 then
				local var24_30 = var22_30[iter9_30].shipTypes

				if table.contains(var23_30, var10_30:getShipType()) then
					var21_30 = true
				end

				if table.contains(var23_30, var10_30:getTeamType()) then
					var21_30 = true
				end
			elseif table.contains(var23_30, var10_30:getShipType()) then
				var21_30 = true
			end

			if var21_30 then
				break
			end
		end

		if not var21_30 then
			return false
		end
	end

	if var6_30[1] ~= 0 then
		local var25_30 = false

		for iter10_30, iter11_30 in ipairs(var6_30) do
			local var26_30 = arg0_30.classifyIds[iter11_30 + 1]

			if arg1_30:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				if arg0_30.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
					var25_30 = var26_30 == var15_0 and arg0_30:ExitSkinExperienceItem(arg1_30.id)
				else
					var25_30 = var26_30 == var13_0
				end
			elseif var26_30 == var12_0 then
				var25_30 = true
			elseif var26_30 == var14_0 and table.contains(arg0_30.returnSkins, arg1_30.id) then
				var25_30 = true
			else
				local var27_30 = arg0_30:GetShopTypeIdBySkinId(var7_30)

				var25_30 = (var27_30 == 0 and var16_0 or var27_30) == var26_30
			end

			if var25_30 then
				break
			end
		end

		if not var25_30 then
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_31, arg1_31)
	if not arg0_31.vship then
		arg0_31.vship = {}

		function arg0_31.vship.getNation()
			return arg0_31.vship.config.nationality
		end

		function arg0_31.vship.getShipType()
			return arg0_31.vship.config.type
		end

		function arg0_31.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_31.vship.config.type)
		end

		function arg0_31.vship.getRarity()
			return arg0_31.vship.config.rarity
		end
	end

	arg0_31.vship.config = arg1_31

	return arg0_31.vship
end

function var0_0.ExitSkinExperienceItem(arg0_36, arg1_36)
	if not arg0_36.cacheSkinExperienceItems then
		arg0_36.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(arg0_36.cacheSkinExperienceItems, function(arg0_37)
		return arg0_37:CanUseForShop(arg1_36)
	end)
end

function var0_0.RegisterEvent(arg0_38)
	arg0_38:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_39, arg1_39)
		arg0_38:AdjustPainting(arg1_39)
		setActive(arg0_38.top, not arg1_39)
		setActive(arg0_38.bottom, not arg1_39)
		setActive(arg0_38.right, not arg1_39)

		if arg0_38.live2dChar then
			arg0_38.live2dChar:setPurchaseOffset(arg1_39)
		end

		if arg0_38.spineChar then
			if arg1_39 then
				local var0_39 = pg.ship_skin_template[arg0_38.skinId].purchase_offset

				if var0_39 and #var0_39 >= 3 then
					arg0_38.spineChar:SetLocalPosition(Vector3(var0_39[1], var0_39[2], var0_39[3]))
				end

				if var0_39 and #var0_39 >= 4 then
					arg0_38.spineChar:SetLocalScale(Vector3(var0_39[4], var0_39[4], var0_39[4]))
				end
			else
				arg0_38.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
				arg0_38.spineChar:SetLocalPosition(Vector3(0, 0, 0))
			end
		end

		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg1_39)
	end)
	arg0_38:bind(var0_0.EVT_ON_PURCHASE, function(arg0_40, arg1_40)
		local var0_40 = arg0_38:GetObtainBtnState(arg1_40)

		arg0_38:OnClickBtn(var0_40, arg1_40)
	end)
	onButton(arg0_38, arg0_38.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_38.skinId) then
			arg0_38.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_38.skinId)

			arg0_38:UpdateMainView(arg0_38.showingCommodity)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_42, arg1_42)
	local var0_42 = NewShopSkinCard.New(arg1_42)

	onButton(arg0_42, var0_42._go, function()
		if not var0_42.commodity then
			return
		end

		for iter0_43, iter1_43 in pairs(arg0_42.cards) do
			iter1_43:UpdateSelected(false)
		end

		arg0_42.selectedId = var0_42.commodity.id

		var0_42:UpdateSelected(true)
		arg0_42:UpdateMainView(var0_42.commodity)
		arg0_42:GCHandle()
	end, SFX_PANEL)

	arg0_42.cards[arg1_42] = var0_42
end

function var0_0.OnUpdateItem(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.cards[arg2_44]

	if not var0_44 then
		arg0_44:OnInitItem(arg2_44)

		var0_44 = arg0_44.cards[arg2_44]
	end

	local var1_44 = arg0_44.displays[arg1_44 + 1]

	if not var1_44 then
		return
	end

	local var2_44 = arg0_44.selectedId == var1_44.id
	local var3_44 = table.contains(arg0_44.returnSkins, var1_44.id)

	var0_44:Update(var1_44, var2_44, var3_44)

	if arg0_44.triggerFirstCard and arg1_44 == 0 then
		arg0_44.triggerFirstCard = false

		triggerButton(var0_44._go)
	end
end

function var0_0.UpdateMainView(arg0_45, arg1_45)
	arg0_45.skinId = arg1_45:getSkinId()

	local var0_45 = ShipSkin.IsChangeSkin(arg0_45.skinId)

	setActive(arg0_45.changeSkin, var0_45)

	if var0_45 then
		arg0_45:FlushChangeSkin(arg1_45)
	end

	arg0_45.shipSkin = ShipSkin.New({
		id = arg0_45.skinId
	})

	arg0_45:FlushName()
	arg0_45:FlushPreviewBtn(arg1_45)
	arg0_45:FlushTimeLimit(arg1_45)
	arg0_45:SwitchPreview(arg1_45, arg0_45.isPreviewFurniture)
	arg0_45:FlushPaintingToggle(arg1_45)
	arg0_45:FlushTag()
	arg0_45:FlushBG(arg1_45)
	arg0_45:FlushPainting(arg1_45)
	arg0_45:FlushPrice(arg1_45)
	arg0_45:FlushObtainBtn(arg1_45)
	arg0_45:FlushGifgPackBtn(arg1_45)

	arg0_45.showingCommodity = arg1_45
end

function var0_0.FlushChangeSkin(arg0_46, arg1_46)
	local var0_46 = ShipSkin.GetChangeSkinGroupId(arg0_46.skinId)
	local var1_46 = ShipSkin.GetChangeSkinCustomDataId(arg0_46.skinId, "hide_shop")
	local var2_46 = pg.gameset.changeskin_switch_block
	local var3_46 = false
	local var4_46 = false
	local var5_46 = arg0_46.changeSkinToggle:IsAsmrSkin() and true or false

	if var2_46 and var2_46.description then
		local var6_46 = var2_46.description

		if table.contains(var6_46, var0_46) then
			local var7_46 = HXSet.isHx()

			if arg1_46.buyCount <= 0 and var7_46 then
				var4_46 = true
			end
		end
	end

	if var1_46 and var1_46 == 1 then
		var3_46 = true
	end

	if not arg0_46.changeSkinId then
		arg0_46.changeSkinId = arg0_46.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_46.changeSkinId) == var0_46 then
		arg0_46.skinId = arg0_46.changeSkinId
	else
		arg0_46.changeSkinId = arg0_46.skinId
	end

	arg0_46.changeSkinToggle:setSkinData(arg0_46.skinId)

	if var3_46 or var4_46 or var5_46 then
		setActive(arg0_46.changeSkin, false)
	else
		setActive(arg0_46.changeSkin, true)
	end
end

function var0_0.GCHandle(arg0_47)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.FlushName(arg0_48)
	local var0_48 = pg.ship_skin_template[arg0_48.skinId]

	setScrollText(arg0_48.skinName, SwitchSpecialChar(var0_48.name, true))

	if var0_48.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_48.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_48.skinId)))
	else
		local var1_48 = ShipGroup.getDefaultShipConfig(var0_48.ship_group)

		setScrollText(arg0_48.shipName, var1_48.name)
	end
end

function var0_0.FlushPreviewBtn(arg0_49, arg1_49)
	local var0_49 = Goods.ExistFurniture(arg1_49.id)

	removeOnButton(arg0_49.switchPreviewBtn)

	if not var0_49 and arg0_49.isPreviewFurniture then
		arg0_49.isPreviewFurniture = false
	end

	setActive(arg0_49.switchPreviewBtn, var0_49)

	if var0_49 then
		onButton(arg0_49, arg0_49.switchPreviewBtn, function()
			arg0_49.isPreviewFurniture = not arg0_49.isPreviewFurniture

			arg0_49:SwitchPreview(arg1_49, arg0_49.isPreviewFurniture)
			arg0_49:FlushPrice(arg1_49)
			arg0_49:FlushObtainBtn(arg1_49)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPreview(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg0_51.skinId

	if pg.ship_skin_template[var0_51].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_51.charContainer, false)

		return
	end

	local var1_51 = getProxy(PlayerProxy):getRawData().id

	setActive(arg0_51.charContainer, PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var1_51, 0) == 1)
	setActive(arg0_51.charTf, not arg2_51)
	setActive(arg0_51.furnitureContainer, arg2_51)

	if not arg2_51 then
		local var2_51 = pg.ship_skin_template[var0_51]

		arg0_51:FlushChar(var2_51.prefab, var2_51.id)
		GetImageSpriteFromAtlasAsync("qicon/" .. var2_51.painting, "", arg0_51.backChara)
	else
		local var3_51 = Goods.Id2FurnitureId(arg1_51.id)
		local var4_51 = Goods.GetFurnitureConfig(arg1_51.id)

		arg0_51.interactionPreview:Flush(var0_51, var3_51, var4_51.scale[2] or 1, var4_51.position[2])
	end
end

function var0_0.FlushChar(arg0_52, arg1_52, arg2_52)
	if arg0_52.prefabName and arg0_52.prefabName == arg1_52 then
		return
	end

	arg0_52:ReturnChar()

	arg0_52.prefabName = arg1_52

	local var0_52 = SpineAnimChar.New()

	var0_52:SetPaint(arg1_52)
	var0_52:Load(true, function(arg0_53)
		if arg0_52.prefabName ~= arg1_52 then
			arg0_53:Dispose()

			return
		end

		arg0_52.spineChar = arg0_53

		local var0_53 = pg.skinshop_spine_scale[arg2_52]

		if var0_53 then
			arg0_52.spineChar:SetLocalScale(Vector3(var0_53.skinshop_scale, var0_53.skinshop_scale, 1))
		else
			arg0_52.spineChar:SetLocalScale(Vector3(0.9, 0.9, 1))
		end

		arg0_52.spineChar:SetLocalPosition(Vector3(0, 0, 0))
		arg0_52.spineChar:SetLayer(Layer.UI)
		arg0_52.spineChar:SetParent(arg0_52.charTf)
		arg0_52.spineChar:SetAction("normal", 0)
	end)
end

function var0_0.ReturnChar(arg0_54)
	if arg0_54.spineChar then
		arg0_54.spineChar:Dispose()

		arg0_54.spineChar = nil
		arg0_54.prefabName = nil
	end
end

function var0_0.ClearCards(arg0_55)
	if not arg0_55.cards then
		return
	end

	for iter0_55, iter1_55 in pairs(arg0_55.cards) do
		iter1_55:Dispose()
	end

	arg0_55.cards = nil
end

function var0_0.FlushTimeLimit(arg0_56, arg1_56)
	local var0_56 = arg0_56.skinId
	local var1_56 = false
	local var2_56

	if arg1_56:IsActivityExtra() and arg1_56:ShowMaintenanceTime() then
		local var3_56, var4_56 = arg1_56:GetMaintenanceMonthAndDay()

		function var2_56()
			return i18n("limit_skin_time_before_maintenance", var3_56, var4_56)
		end

		var1_56 = true
	elseif arg1_56:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_56 = getProxy(ShipSkinProxy):getSkinById(var0_56)

		var1_56 = var5_56 and var5_56:isExpireType() and not var5_56:isExpired()

		if var1_56 then
			function var2_56()
				return skinTimeStamp(var5_56:getRemainTime())
			end
		end
	else
		local var6_56, var7_56 = pg.TimeMgr.GetInstance():inTime(arg1_56:getConfig("time"))

		var1_56 = var7_56

		if var1_56 then
			local var8_56 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_56)

			function var2_56()
				return skinCommdityTimeStamp(var8_56)
			end
		end
	end

	setActive(arg0_56.top:Find("title/limit_time"), var1_56)
	arg0_56:ClearTimer()

	if var1_56 then
		arg0_56:AddTimer(var2_56)
	end
end

function var0_0.AddTimer(arg0_60, arg1_60)
	arg0_60.timer = Timer.New(function()
		setText(arg0_60.limitTime, arg1_60())
	end, 1, -1)

	arg0_60.timer.func()
	arg0_60.timer:Start()
end

function var0_0.ClearTimer(arg0_62)
	if arg0_62.timer then
		arg0_62.timer:Stop()

		arg0_62.timer = nil
	end
end

function var0_0.FlushPaintingToggle(arg0_63, arg1_63)
	removeOnToggle(arg0_63.dynamicToggle)
	removeOnToggle(arg0_63.showBgToggle)

	local var0_63 = checkABExist("painting/" .. arg0_63.shipSkin:getConfig("painting") .. "_n")

	if arg0_63.isToggleShowBg and not var0_63 then
		triggerToggle(arg0_63.showBgToggle, false)

		arg0_63.isToggleShowBg = false
	elseif var0_63 then
		triggerToggle(arg0_63.showBgToggle, true)

		arg0_63.isToggleShowBg = true
	end

	local var1_63 = arg0_63.shipSkin:IsSpine() or arg0_63.shipSkin:IsLive2d() or arg0_63.shipSkin:IsSpinePlus() or arg0_63.shipSkin:IsLive2dPlus()
	local var2_63 = arg0_63.shipSkin:IsHxDynamicPreview()

	if var1_63 and not var2_63 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_63.isToggleDynamic = true
	end

	if var1_63 then
		local var3_63 = 0

		if arg0_63.shipSkin:IsSpine() then
			var3_63 = 6
		elseif arg0_63.shipSkin:IsLive2d() then
			var3_63 = 1
		elseif arg0_63.shipSkin:IsSpinePlus() then
			var3_63 = 7
		elseif arg0_63.shipSkin:IsLive2dPlus() then
			var3_63 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_63) .. "_off", arg0_63.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var3_63), arg0_63.dynamicToggle:Find("select"))
	end

	if var2_63 and arg0_63.isToggleDynamic then
		triggerToggle(arg0_63.dynamicToggle, false)

		arg0_63.isToggleDynamic = false
	end

	if arg0_63.isToggleDynamic and not var1_63 then
		triggerToggle(arg0_63.dynamicToggle, false)

		arg0_63.isToggleDynamic = false
	elseif arg0_63.isToggleDynamic and not arg0_63.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_63.shipSkin:IsLive2d() or arg0_63.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_63.isToggleDynamic = false

			local var4_63 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4_63, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_63.dynamicToggle, false)
		else
			triggerToggle(arg0_63.dynamicToggle, true)

			arg0_63.isToggleDynamic = true
		end
	end

	if var0_63 then
		onToggle(arg0_63, arg0_63.showBgToggle, function(arg0_64)
			arg0_63.isToggleShowBg = arg0_64

			arg0_63:FlushPainting(arg1_63)
			arg0_63:FlushBG(arg1_63)
		end, SFX_PANEL)
	end

	if arg0_63.shipSkin:IsSpine() or arg0_63.shipSkin:IsLive2d() or arg0_63.shipSkin:IsSpinePlus() or arg0_63.shipSkin:IsLive2dPlus() then
		onToggle(arg0_63, arg0_63.dynamicToggle, function(arg0_65)
			local var0_65 = arg0_63.shipSkin:IsHxDynamicPreview()

			if arg0_65 and var0_65 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("shop_tag_control_tip"))
				triggerToggle(arg0_63.dynamicToggle, false)
				setActive(arg0_63.dynamicResToggle, false)

				return
			end

			if arg0_65 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_63.shipSkin:IsLive2d() or arg0_63.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_63.dynamicToggle, false)

				return
			end

			arg0_63.isToggleDynamic = arg0_65

			setActive(arg0_63.showBgToggle, not arg0_65 and var0_63)
			arg0_63:FlushPainting(arg1_63)
			arg0_63:FlushDynamicPaintingResState(arg1_63)
			arg0_63:RecordFlag(arg0_65)
		end, SFX_PANEL)
	end

	setActive(arg0_63.dynamicIcon, true)

	if arg0_63.isToggleDynamic then
		arg0_63:FlushDynamicPaintingResState(arg1_63)
	elseif var2_63 then
		setActive(arg0_63.dynamicResToggle, false)
		setActive(arg0_63.dynamicIcon, false)
	end

	setActive(arg0_63.dynamicToggle, var1_63)
	setActive(arg0_63.showBgToggle, not arg0_63.isToggleDynamic and var0_63)
end

function var0_0.FlushTag(arg0_66)
	local var0_66 = arg0_66.skinId
	local var1_66 = pg.ship_skin_template[var0_66]
	local var2_66 = Clone(var1_66.tag)
	local var3_66 = false

	for iter0_66 = #var2_66, 1, -1 do
		local var4_66 = var2_66[iter0_66]

		if var4_66 == 1 or var4_66 == 6 or var4_66 == 7 or var4_66 == 9 then
			local var5_66 = true

			table.remove(var2_66, iter0_66)
		end
	end

	local var6_66 = checkABExist("painting/" .. arg0_66.shipSkin:getConfig("painting") .. "_n")

	arg0_66.tagList:make(function(arg0_67, arg1_67, arg2_67)
		if arg0_67 == UIItemList.EventUpdate then
			local var0_67 = var2_66[arg1_67 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_66[arg1_67 + 1]), function(arg0_68)
				if arg0_66.exited then
					return
				end

				arg2_67:GetComponent(typeof(Image)).sprite = arg0_68
			end)
		end
	end)
	arg0_66.tagList:align(#var2_66)
end

function var0_0.FlushPainting(arg0_69, arg1_69)
	local var0_69 = arg0_69:GetPaintingState(arg1_69)
	local var1_69 = pg.ship_skin_template[arg0_69.skinId].painting
	local var2_69 = ShipSkin.GetChangeSkinData(arg0_69.skinId) and true or false

	if var0_69 == var2_0 and not arg0_69:ExistL2dRes(var1_69) or var0_69 == var3_0 and not arg0_69:ExistSpineRes(var1_69) then
		var0_69 = var1_0
	end

	if arg0_69.paintingState and arg0_69.paintingState.state == var0_69 and arg0_69.paintingState.id == arg1_69.id and arg0_69.paintingState.showBg == arg0_69.isToggleShowBg and arg0_69.paintingState.purchaseFlag == arg1_69.buyCount and not var2_69 then
		return
	end

	arg0_69:ClearPainting()

	if var0_69 == var1_0 then
		arg0_69:LoadMeshPainting(arg1_69, arg0_69.isToggleShowBg)
	elseif var0_69 == var2_0 then
		arg0_69:LoadL2dPainting(arg1_69)
	elseif var0_69 == var3_0 then
		arg0_69:LoadSpinePainting(arg1_69)
	end

	arg0_69.paintingState = {
		state = var0_69,
		id = arg1_69.id,
		showBg = arg0_69.isToggleShowBg,
		purchaseFlag = arg1_69.buyCount
	}

	arg0_69:AdjustPainting(false)
end

function var0_0.ClearPainting(arg0_70)
	local var0_70 = arg0_70.paintingState

	if not var0_70 then
		return
	end

	if var0_70.state == var1_0 then
		arg0_70:ClearMeshPainting()
	elseif var0_70.state == var2_0 then
		arg0_70:ClearL2dPainting()
	elseif var0_70.state == var3_0 then
		arg0_70:ClearSpinePainting()
	end

	arg0_70.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_71, arg1_71, arg2_71)
	local var0_71 = findTF(arg0_71.paintingTF, "fitter")
	local var1_71 = GetOrAddComponent(var0_71, "PaintingScaler")

	var1_71.FrameName = "chuanwu"
	var1_71.Tween = 1

	local var2_71 = pg.ship_skin_template[arg0_71.skinId].painting
	local var3_71 = var2_71

	if not arg2_71 and checkABExist("painting/" .. var2_71 .. "_n") then
		var2_71 = var2_71 .. "_n"
	end

	if not checkABExist("painting/" .. var2_71) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_71, true, function(arg0_72)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_72, var0_71, false)
		ShipExpressionHelper.SetExpression(var0_71:GetChild(0), var3_71)

		arg0_71.paintingName = var2_71

		if arg0_71.paintingState and arg0_71.paintingState.id ~= arg1_71.id then
			arg0_71:ClearMeshPainting()
		end

		local var0_72 = arg0_72.transform:Find("shop_hx")

		arg0_71:CheckShowShopHx(var0_72, arg1_71)
	end)
end

function var0_0.ClearMeshPainting(arg0_73)
	local var0_73 = arg0_73.paintingTF:Find("fitter")

	if arg0_73.paintingName and var0_73.childCount > 0 then
		local var1_73 = var0_73:GetChild(0).gameObject
		local var2_73 = var1_73.transform:Find("shop_hx")

		arg0_73:RevertShopHx(var2_73)
		PoolMgr.GetInstance():ReturnPainting(arg0_73.paintingName, var1_73)
	end

	arg0_73.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_74, arg1_74)
	local var0_74 = arg0_74.skinId
	local var1_74 = pg.ship_skin_template[var0_74].skin_type
	local var2_74

	if var1_74 == ShipSkin.SKIN_TYPE_TB then
		var2_74 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_74))
	else
		local var3_74 = pg.ship_skin_template[var0_74].ship_group
		local var4_74 = ShipGroup.getDefaultShipConfig(var3_74)

		var2_74 = Ship.New({
			noChangeSkin = true,
			configId = var4_74.id,
			skin_id = var0_74
		})
	end

	local var5_74 = Live2D.GenerateData({
		ship = var2_74,
		position = Vector3(0, 0, -1),
		parent = arg0_74.live2dContainer,
		offset = var2_74:GetSkinConfig().shop_offset
	})

	var5_74.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_74.live2dChar = Live2D.New(var5_74, function(arg0_75)
		arg0_75:IgonreReactPos(true)
		arg0_74:CheckShowShopHxForL2d(arg0_75, arg1_74)

		if arg0_74.paintingState and arg0_74.paintingState.id ~= arg1_74.id then
			arg0_74:ClearL2dPainting()
		end

		arg0_75:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_76)
	if arg0_76.live2dChar then
		arg0_76:RevertShopHxForL2d(arg0_76.live2dChar)
		arg0_76.live2dChar:Dispose()

		arg0_76.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_77, arg1_77)
	local var0_77 = arg0_77.skinId
	local var1_77 = pg.ship_skin_template[var0_77].skin_type
	local var2_77

	if var1_77 == ShipSkin.SKIN_TYPE_TB then
		var2_77 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_77))
	else
		local var3_77 = pg.ship_skin_template[var0_77].ship_group
		local var4_77 = ShipGroup.getDefaultShipConfig(var3_77)

		var2_77 = Ship.New({
			noChangeSkin = true,
			configId = var4_77.id,
			skin_id = var0_77
		})
	end

	local var5_77 = SpinePainting.GenerateData({
		ship = var2_77,
		position = Vector3(0, 0, 0),
		parent = arg0_77.spTF,
		effectParent = arg0_77.spBg,
		offset = var2_77:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_77.spinePainting = SpinePainting.New(var5_77, function(arg0_78)
		if arg0_77.paintingState and arg0_77.paintingState.id ~= arg1_77.id then
			arg0_77:ClearSpinePainting()
		end

		local var0_78 = arg0_78._tf:Find("shop_hx")

		arg0_77:CheckShowShopHx(var0_78, arg1_77)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_79)
	if arg0_79.spinePainting and arg0_79.spinePainting._tf then
		local var0_79 = arg0_79.spinePainting._tf:Find("shop_hx")

		arg0_79:RevertShopHx(arg0_79.shopHx)
		arg0_79.spinePainting:Dispose()

		arg0_79.spinePainting = nil
	end
end

function var0_0.CheckShowShopHx(arg0_80, arg1_80, arg2_80)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	if not IsNil(arg1_80) and arg2_80.buyCount <= 0 then
		setActive(arg1_80, true)
	end
end

function var0_0.RevertShopHx(arg0_81, arg1_81)
	if not IsNil(arg1_81) then
		setActive(arg1_81, false)
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_82, arg1_82, arg2_82)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_82 = arg2_82.buyCount <= 0 and 1 or 0

	arg1_82:changeParamaterValue("shop_hx", var0_82)
end

function var0_0.RevertShopHxForL2d(arg0_83, arg1_83)
	arg1_83:changeParamaterValue("shop_hx", 0)
end

function var0_0.AdjustPainting(arg0_84, arg1_84)
	local var0_84 = arg0_84.paintingTF
	local var1_84 = pg.ship_skin_newmainui_shift[arg0_84.skinId]

	if var1_84 then
		local var2_84 = var1_84.skin_shop_shift

		if arg1_84 then
			var0_84.anchoredPosition = Vector2(var2_84[1] - 440, var2_84[2] + arg0_84.defaultPaintingPosition.y)
		else
			var0_84.anchoredPosition = Vector2(var2_84[1] + arg0_84.defaultPaintingPosition.x, var2_84[2] + arg0_84.defaultPaintingPosition.y)
		end

		local var3_84 = var2_84[4]

		var0_84.localScale = Vector3(var3_84, var3_84, 1)
	else
		var0_84.anchoredPosition = Vector2(arg0_84.defaultPaintingPosition.x, arg0_84.defaultPaintingPosition.y)
		var0_84.localScale = arg0_84.defaultPaintingScale
	end
end

function var0_0.FlushBG(arg0_85, arg1_85, arg2_85)
	local var0_85 = arg0_85.skinId
	local var1_85 = pg.ship_skin_template[var0_85]
	local var2_85

	if var1_85.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_85 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_85))
	else
		local var3_85 = ShipGroup.getDefaultShipConfig(var1_85.ship_group)

		var2_85 = Ship.New({
			id = 999,
			configId = var3_85.id,
			skin_id = var0_85
		})
	end

	local var4_85 = var2_85:getShipBgPrint(true)
	local var5_85 = pg.ship_skin_template[var0_85].painting

	if (arg0_85.isToggleShowBg or not checkABExist("painting/" .. var5_85 .. "_n")) and var1_85.bg_sp ~= "" then
		var4_85 = var1_85.bg_sp
	end

	local var6_85 = var4_85 ~= var2_85:rarity2bgPrintForGet()

	if var6_85 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_85, var4_85, arg0_85.bgs:Find("diffBg"), arg0_85.bgs:Find("diffBg/bg"), function(arg0_86)
			if arg2_85 then
				arg2_85()
			end
		end, function(arg0_87)
			if arg2_85 then
				arg2_85()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_85:getUIName())

		if arg2_85 then
			arg2_85()
		end
	end

	setActive(arg0_85.bgs:Find("diffBg"), var6_85)
	setActive(arg0_85.bgs:Find("default"), not var6_85)
end

function var0_0.FlushDynamicPaintingResState(arg0_88, arg1_88)
	if not arg0_88.isToggleDynamic then
		return
	end

	local var0_88 = arg0_88:GetPaintingState(arg1_88)
	local var1_88 = false
	local var2_88 = ""
	local var3_88 = pg.ship_skin_template[arg0_88.skinId].painting

	if var2_0 == var0_88 then
		var1_88, var2_88 = arg0_88:ExistL2dRes(var3_88)
	elseif var3_0 == var0_88 then
		var1_88, var2_88 = arg0_88:ExistSpineRes(var3_88)
	end

	setActive(arg0_88.dynamicResToggle, not var1_88)
	removeOnButton(arg0_88.dynamicResToggle)

	if not var1_88 and var2_88 ~= "" then
		onButton(arg0_88, arg0_88.dynamicResToggle, function()
			arg0_88:DownloadDynamicPainting(var2_88, arg1_88)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_90, arg1_90, arg2_90)
	local var0_90 = arg0_90.skinId

	if arg0_90.downloads[var0_90] then
		return
	end

	local var1_90 = SkinShopDownloadRequest.New()

	arg0_90.downloads[var0_90] = var1_90

	var1_90:Start(arg1_90, function(arg0_91)
		if arg0_91 and arg0_90.paintingState and arg0_90.paintingState.id == arg2_90.id then
			arg0_90:FlushPainting(arg2_90)
			arg0_90:FlushDynamicPaintingResState(arg2_90)
		end

		var1_90:Dispose()

		arg0_90.downloads[var0_90] = nil
	end)
end

function var0_0.GetPaintingState(arg0_92, arg1_92)
	if arg0_92.isToggleDynamic and (arg0_92.shipSkin:IsLive2d() or arg0_92.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_92.isToggleDynamic and (arg0_92.shipSkin:IsSpine() or arg0_92.shipSkin:IsSpinePlus()) then
		if arg0_92.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_93, arg1_93)
	local var0_93 = "live2d/" .. string.lower(arg1_93)
	local var1_93 = HXSet.autoHxShiftPath(var0_93, nil, true)

	return checkABExist(var1_93), var1_93
end

function var0_0.ExistSpineRes(arg0_94, arg1_94)
	local var0_94 = "SpinePainting/" .. string.lower(arg1_94)
	local var1_94 = HXSet.autoHxShiftPath(var0_94, nil, true)

	return checkABExist(var1_94), var1_94
end

function var0_0.RecordFlag(arg0_95, arg1_95)
	local var0_95 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_95, arg1_95 and 1 or 0)
	PlayerPrefs.Save()
	arg0_95:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_95)
end

function var0_0.FlushPrice(arg0_96, arg1_96)
	local var0_96 = arg1_96:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_96 = arg1_96.type == Goods.TYPE_ACTIVITY or arg1_96.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_96 then
		if arg0_96.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_96:UpdateExperiencePrice4Item(arg1_96)
		else
			arg0_96:UpdateExperiencePrice(arg1_96)
		end
	elseif arg0_96.isPreviewFurniture then
		arg0_96:UpdateFurniturePrice(arg1_96)
	elseif var1_96 then
		-- block empty
	else
		arg0_96:UpdateCommodityPrice(arg1_96)
	end

	local var2_96 = arg1_96.type == Goods.TYPE_SKIN

	setActive(arg0_96.price:Find("timeLimit"), var0_96 and not var1_96)
	setActive(arg0_96.price:Find("consume"), var2_96 and not var0_96 and not var1_96)
end

function var0_0.UpdateExperiencePrice4Item(arg0_97, arg1_97)
	local var0_97 = arg1_97:getConfig("resource_num")
	local var1_97 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_97 = _.detect(var1_97, function(arg0_98)
		return arg0_98:CanUseForShop(arg1_97.id)
	end)
	local var3_97 = var2_97 and var2_97.count or 0
	local var4_97 = (var3_97 < var0_97 and "<color=" .. COLOR_RED .. ">" or "") .. var3_97 .. (var3_97 < var0_97 and "</color>" or "")

	setText(arg0_97.price:Find("timeLimit/consume/Text"), var4_97 .. "/" .. var0_97)
end

function var0_0.UpdateExperiencePrice(arg0_99, arg1_99)
	local var0_99 = arg1_99:getConfig("resource_num")
	local var1_99 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_99 = (var1_99 < var0_99 and "<color=" .. COLOR_RED .. ">" or "") .. var1_99 .. (var1_99 < var0_99 and "</color>" or "")

	setText(arg0_99.price:Find("timeLimit/consume/Text"), var2_99 .. "/" .. var0_99)
end

function var0_0.UpdateCommodityPrice(arg0_100, arg1_100)
	local var0_100 = arg1_100:GetPrice()
	local var1_100 = arg1_100:getConfig("resource_num")

	setText(arg0_100.price:Find("consume/Text"), var0_100)
	setText(arg0_100.price:Find("consume/originalprice/Text"), var1_100)
	setActive(arg0_100.price:Find("consume/originalprice"), var0_100 ~= var1_100)
end

function var0_0.UpdateFurniturePrice(arg0_101, arg1_101)
	local var0_101 = Goods.Id2FurnitureId(arg1_101.id)
	local var1_101 = Furniture.New({
		id = var0_101
	})
	local var2_101 = var1_101:getConfig("gem_price")

	setText(arg0_101.price:Find("consume/originalprice/Text"), var2_101)

	local var3_101 = var1_101:getPrice(PlayerConst.ResDiamond)

	setText(arg0_101.price:Find("consume/Text"), var3_101)
	setActive(arg0_101.price:Find("consume/originalprice"), var2_101 ~= var3_101)
end

function var0_0.FlushObtainBtn(arg0_102, arg1_102)
	local var0_102 = arg0_102:GetObtainBtnState(arg1_102)
	local var1_102 = var19_0(var0_102)

	for iter0_102 = 0, arg0_102.btns.childCount - 1 do
		local var2_102 = arg0_102.btns:GetChild(iter0_102)

		setActive(var2_102, var2_102.name == var1_102)
	end

	setActive(arg0_102.price:Find("btn/item"), var0_102 == var11_0)
	setActive(arg0_102.price:Find("btn/tag"), var0_102 == var11_0)

	if var0_102 == var11_0 then
		arg0_102:FlushGift(arg1_102)
	end

	onButton(arg0_102, arg0_102.price:Find("btn"), function()
		local var0_103 = {}
		local var1_103 = SkinCouponActivity.StaticEncoreActTip(arg1_102.id)

		if tobool(var1_103) then
			table.insert(var0_103, function(arg0_104)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Hint"),
					onYes = function()
						if var1_103 and not var1_103:isEnd() then
							arg0_102:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_103.id)
						end
					end,
					onNo = arg0_104
				})
			end)
		end

		if arg1_102:getConfig("genre") == ShopArgs.SkinShop and not arg1_102:IsItemDiscountType() and #SkinCouponActivity.GetOvercountEncoreActs(arg1_102.id) > 0 then
			table.insert(var0_103, function(arg0_106)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Last_Coupon"),
					onYes = arg0_106
				})
			end)
		end

		seriesAsync(var0_103, function()
			if var0_102 == var5_0 or var0_102 == var7_0 or var0_102 == var11_0 then
				arg0_102.purchaseView:ExecuteAction("Show", arg1_102)
			else
				arg0_102:OnClickBtn(var0_102, arg1_102)
			end
		end)
	end, SFX_PANEL)
end

function var0_0.GetObtainBtnState(arg0_108, arg1_108)
	if arg1_108:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_108.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_108.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_108.type == Goods.TYPE_ACTIVITY or arg1_108.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_108.buyCount > 0 then
		return var4_0
	elseif arg1_108:isDisCount() and arg1_108:IsItemDiscountType() then
		return var7_0
	elseif arg1_108:CanUseVoucherType() or arg1_108:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_108:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushGift(arg0_109, arg1_109)
	local var0_109 = arg1_109:GetGiftList()[1]

	updateDrop(arg0_109.price:Find("btn/item/mask/item"), {
		type = var0_109.type,
		id = var0_109.id,
		count = var0_109.count
	})
end

function var0_0.OnClickBtn(arg0_110, arg1_110, arg2_110)
	if arg1_110 == var5_0 or arg1_110 == var7_0 or arg1_110 == var11_0 then
		arg0_110:OnPurchase(arg2_110)
	elseif arg1_110 == var10_0 then
		arg0_110:OnItemPurchase(arg2_110)
	elseif arg1_110 == var6_0 then
		arg0_110:OnActivity(arg2_110)
	elseif arg1_110 == var8_0 then
		arg0_110:OnBackyard(arg2_110)
	elseif arg1_110 == var9_0 then
		if arg0_110.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_110:OnExperience4Item(arg2_110)
		else
			arg0_110:OnExperience(arg2_110)
		end
	end
end

function var0_0.FlushGifgPackBtn(arg0_111, arg1_111)
	local var0_111 = false
	local var1_111
	local var2_111
	local var3_111

	for iter0_111, iter1_111 in pairs(arg0_111.giftSkinCommodities) do
		for iter2_111, iter3_111 in ipairs(iter1_111) do
			if iter3_111.id == arg1_111.id then
				var0_111 = true

				break
			end
		end

		if var0_111 then
			var1_111 = arg0_111.giftPackCommodities[iter0_111]
			var2_111 = arg0_111.giftSkinCommodities[iter0_111]
			var3_111 = arg0_111.giftSkinProbabilitys[iter0_111]

			break
		end
	end

	if var0_111 then
		setText(arg0_111.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip_2"))
		onButton(arg0_111, arg0_111.giftPackBtn, function()
			arg0_111:emit(LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER, var1_111, var2_111, var3_111)
		end, SFX_PANEL)
	else
		for iter4_111, iter5_111 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE)) do
			if iter5_111 and not iter5_111:isEnd() and iter5_111.data1 < 1 and underscore.any(iter5_111:getConfig("config_data")[1], function(arg0_113)
				return pg.ship_skin_template[arg0_113].shop_id == arg1_111.id
			end) then
				var0_111 = iter5_111

				break
			end
		end

		if var0_111 then
			setText(arg0_111.giftPackBtn:Find("title"), i18n("skinshop_on_sale_tip"))
			onButton(arg0_111, arg0_111.giftPackBtn, function()
				arg0_111:emit(LatestSkinShopMediator.OPEN_GIFT_ACT_LAYER, var0_111.id)
			end, SFX_PANEL)
		end
	end

	setActive(arg0_111.giftPackBtn, var0_111)
end

function var0_0.SetGiftPackLayer(arg0_115)
	return
end

function var0_0.OnPurchase(arg0_116, arg1_116)
	if arg1_116.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_116:isDisCount() and arg1_116:IsItemDiscountType() then
		arg0_116:emit(LatestSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_116.id, 1)
	else
		arg0_116:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_116.id, 1)
	end
end

function var0_0.OnItemPurchase(arg0_117, arg1_117)
	if arg1_117.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_117 = arg1_117:GetVoucherIdList()
	local var1_117 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_117.id)

	if #var0_117 <= 0 and #var1_117 <= 0 then
		return
	end

	local var2_117 = {}

	for iter0_117, iter1_117 in ipairs(var0_117) do
		table.insert(var2_117, iter1_117)
	end

	for iter2_117, iter3_117 in ipairs(var1_117) do
		table.insert(var2_117, iter3_117.id)
	end

	local var3_117 = arg0_117.skinId
	local var4_117 = pg.ship_skin_template[var3_117]
	local var5_117 = SwitchSpecialChar(var4_117.name, true)

	arg0_117.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_117,
		skinId = var3_117,
		skinName = var5_117,
		price = arg1_117:GetPrice(),
		onYes = function(arg0_118)
			if arg0_118 then
				arg0_117:emit(LatestSkinShopMediator.ON_ITEM_PURCHASE, arg0_118, arg1_117.id)
			else
				arg0_117:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_117.id, 1)
			end
		end
	})
end

function var0_0.OnActivity(arg0_119, arg1_119)
	local var0_119 = arg1_119:getConfig("time")
	local var1_119 = arg1_119:getConfig("activity")
	local var2_119 = getProxy(ActivityProxy):getActivityById(var1_119)

	if var1_119 == 0 and pg.TimeMgr.GetInstance():inTime(var0_119) or var2_119 and not var2_119:isEnd() then
		if arg1_119.type == Goods.TYPE_ACTIVITY then
			arg0_119:emit(LatestSkinShopMediator.GO_SHOPS_LAYER, arg1_119:getConfig("activity"))
		elseif arg1_119.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_119 = arg1_119:getConfig("scene")

			if var3_119 and #var3_119 > 0 then
				arg0_119:emit(LatestSkinShopMediator.OPEN_SCENE, var3_119)
			else
				arg0_119:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_119)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_120, arg1_120)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_120 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_120.name, var0_120.level))

		return
	end

	arg0_120:emit(LatestSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_121, arg1_121)
	local var0_121 = arg0_121.skinId
	local var1_121 = getProxy(ShipSkinProxy):getSkinById(var0_121)

	if var1_121 and not var1_121:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_121 = arg1_121:getConfig("resource_num")
	local var3_121 = arg1_121:getConfig("time_second") * var2_121
	local var4_121, var5_121, var6_121, var7_121 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_121)
	local var8_121 = pg.ship_skin_template[arg0_121.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_121, var8_121, var4_121, var5_121),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_121 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_121:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_121.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_123, arg1_123)
	local var0_123 = arg0_123.skinId
	local var1_123 = getProxy(ShipSkinProxy):getSkinById(var0_123)

	if var1_123 and not var1_123:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_123 = arg1_123:getConfig("resource_num")
	local var3_123 = arg1_123:getConfig("time_second") * var2_123
	local var4_123, var5_123, var6_123, var7_123 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_123)
	local var8_123 = pg.ship_skin_template[arg0_123.skinId].name
	local var9_123 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_123 = _.detect(var9_123, function(arg0_124)
		return arg0_124:CanUseForShop(arg1_123.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_123, var8_123, var4_123, var5_123),
		onYes = function()
			if not var10_123 or var10_123.count < var2_123 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_123:emit(LatestSkinShopMediator.ON_ITEM_EXPERIENCE, var10_123.id, arg1_123.id, 1)
		end
	})
end

function var0_0.SetFilterPanel(arg0_126)
	local var0_126 = arg0_126.filterContent:Find("own/options")
	local var1_126 = arg0_126.filterContent:Find("type/options")
	local var2_126 = arg0_126.filterContent:Find("shipHave/options")
	local var3_126 = arg0_126.filterContent:Find("camp/options")
	local var4_126 = arg0_126.filterContent:Find("rarity/options")
	local var5_126 = arg0_126.filterContent:Find("shipType/options")
	local var6_126 = arg0_126.filterContent:Find("themeType/options")

	arg0_126:SetOptionList(var3_126, ShipIndexConst.CampNames, true)
	arg0_126:SetOptionList(var4_126, ShipIndexConst.RarityNames, true)
	arg0_126:SetOptionList(var5_126, ShipIndexConst.TypeNames, true)
	arg0_126:SetOptionList(var6_126, arg0_126.classifyNames)
	arg0_126:SetSingleOptions(var0_126, "ownType")
	arg0_126:SetMultiOptions(var1_126, "typeType")
	arg0_126:SetSingleOptions(var2_126, "shipHaveType")
	arg0_126:SetMultiOptions(var3_126, "campType")
	arg0_126:SetMultiOptions(var4_126, "rarityType")
	arg0_126:SetMultiOptions(var5_126, "shipType")
	arg0_126:SetMultiOptions(var6_126, "themeType")
	onButton(arg0_126, arg0_126.filterUI:Find("bg"), function()
		for iter0_127, iter1_127 in pairs(arg0_126.filterValues) do
			arg0_126.filterValuesTemp[iter0_127] = Clone(arg0_126.filterValues[iter0_127])
		end

		setActive(arg0_126.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_126, arg0_126.filterUI:Find("panelMask/panel/closeBtn"), function()
		for iter0_128, iter1_128 in pairs(arg0_126.filterValues) do
			arg0_126.filterValuesTemp[iter0_128] = Clone(arg0_126.filterValues[iter0_128])
		end

		setActive(arg0_126.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_126, arg0_126.filterUI:Find("panelMask/panel/bottom/ok"), function()
		for iter0_129, iter1_129 in pairs(arg0_126.filterValues) do
			arg0_126.filterValues[iter0_129] = Clone(arg0_126.filterValuesTemp[iter0_129])
		end

		setActive(arg0_126.filterUI, false)
		arg0_126:Refresh(true)
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_130)
	setActive(arg0_130.filterUI, true)

	local var0_130 = arg0_130.filterContent:Find("own/options")
	local var1_130 = arg0_130.filterContent:Find("type/options")
	local var2_130 = arg0_130.filterContent:Find("shipHave/options")
	local var3_130 = arg0_130.filterContent:Find("camp/options")
	local var4_130 = arg0_130.filterContent:Find("rarity/options")
	local var5_130 = arg0_130.filterContent:Find("shipType/options")
	local var6_130 = arg0_130.filterContent:Find("themeType/options")

	arg0_130:SetSingleOptions(var0_130, "ownType", true)
	arg0_130:SetMultiOptions(var1_130, "typeType", true)
	arg0_130:SetSingleOptions(var2_130, "shipHaveType", true)
	arg0_130:SetMultiOptions(var3_130, "campType", true)
	arg0_130:SetMultiOptions(var4_130, "rarityType", true)
	arg0_130:SetMultiOptions(var5_130, "shipType", true)
	arg0_130:SetMultiOptions(var6_130, "themeType", true)
end

function var0_0.SetOptionList(arg0_131, arg1_131, arg2_131, arg3_131)
	local var0_131 = UIItemList.New(arg1_131, arg1_131:GetChild(0))

	var0_131:make(function(arg0_132, arg1_132, arg2_132)
		if arg0_132 == UIItemList.EventUpdate then
			local var0_132 = arg2_131[arg1_132 + 1]

			if arg3_131 then
				var0_132 = i18n(var0_132)
			end

			arg2_132.name = arg1_132

			setScrollText(arg2_132:Find("mask/Text"), var0_132)
		end
	end)
	var0_131:align(#arg2_131)
end

function var0_0.SetSingleOptions(arg0_133, arg1_133, arg2_133, arg3_133)
	for iter0_133 = 0, arg1_133.childCount - 1 do
		local var0_133 = arg1_133:GetChild(iter0_133)

		arg0_133:SetOptionSelect(arg1_133:GetChild(iter0_133), iter0_133 == arg0_133.filterValuesTemp[arg2_133])

		if not arg3_133 then
			onButton(arg0_133, var0_133, function()
				arg0_133.filterValuesTemp[arg2_133] = iter0_133

				for iter0_134 = 0, arg1_133.childCount - 1 do
					arg0_133:SetOptionSelect(arg1_133:GetChild(iter0_134), iter0_134 == iter0_133)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_135, arg1_135, arg2_135, arg3_135)
	for iter0_135 = 0, arg1_135.childCount - 1 do
		local var0_135 = arg1_135:GetChild(iter0_135)

		arg0_135:SetOptionSelect(arg1_135:GetChild(iter0_135), table.contains(arg0_135.filterValuesTemp[arg2_135], iter0_135))

		if not arg3_135 then
			onButton(arg0_135, var0_135, function()
				if iter0_135 == 0 then
					arg0_135.filterValuesTemp[arg2_135] = {
						0
					}

					for iter0_136 = 0, arg1_135.childCount - 1 do
						arg0_135:SetOptionSelect(arg1_135:GetChild(iter0_136), iter0_136 == 0)
					end
				else
					table.removebyvalue(arg0_135.filterValuesTemp[arg2_135], 0)

					if table.contains(arg0_135.filterValuesTemp[arg2_135], iter0_135) then
						table.removebyvalue(arg0_135.filterValuesTemp[arg2_135], iter0_135)
					else
						table.insert(arg0_135.filterValuesTemp[arg2_135], iter0_135)
					end

					local var0_136 = true

					for iter1_136 = 1, arg1_135.childCount - 1 do
						if not table.contains(arg0_135.filterValuesTemp[arg2_135], iter1_136) then
							var0_136 = false

							break
						end
					end

					if #arg0_135.filterValuesTemp[arg2_135] == 0 then
						var0_136 = true
					end

					if var0_136 then
						arg0_135.filterValuesTemp[arg2_135] = {
							0
						}
					end

					for iter2_136 = 0, arg1_135.childCount - 1 do
						arg0_135:SetOptionSelect(arg1_135:GetChild(iter2_136), table.contains(arg0_135.filterValuesTemp[arg2_135], iter2_136))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_137, arg1_137, arg2_137)
	setActive(arg1_137:Find("selectedFrame"), arg2_137)

	local var0_137

	if IsNil(arg1_137:Find("Text")) then
		var0_137 = arg1_137:Find("mask/Text"):GetComponent(typeof(Text))
	else
		var0_137 = arg1_137:Find("Text"):GetComponent(typeof(Text))
	end

	if arg2_137 then
		var0_137.color = Color.New(1, 1, 1, 1)
	else
		var0_137.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.GetSkinClassify(arg0_138)
	arg0_138.classifyIds = {}
	arg0_138.classifyNames = {}

	local var0_138 = {}
	local var1_138 = {}

	for iter0_138, iter1_138 in ipairs(arg0_138.commodities) do
		local var2_138 = arg0_138:GetShopTypeIdBySkinId(iter1_138:getSkinId())
		local var3_138 = var2_138 == 0 and var16_0 or var2_138

		var1_138[var3_138] = (var1_138[var3_138] or 0) + 1
	end

	local var4_138 = {}

	for iter2_138, iter3_138 in ipairs(arg0_138.returnSkins) do
		var4_138[iter3_138] = true
	end

	if underscore.any(arg0_138.commodities, function(arg0_139)
		return var4_138[arg0_139.id]
	end) then
		table.insert(var0_138, var14_0)
	end

	for iter4_138, iter5_138 in ipairs(pg.skin_page_template.all) do
		if iter5_138 ~= var17_0 and iter5_138 ~= var18_0 and (var1_138[iter5_138] or 0) > 0 then
			table.insert(var0_138, iter5_138)
		end
	end

	if arg0_138.mode == var0_0.MODE_EXPERIENCE then
		table.insert(var0_138, 1, var13_0)
	end

	if arg0_138.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_138, 1, var15_0)
	end

	table.insert(var0_138, 1, var12_0)

	arg0_138.classifyIds = var0_138

	for iter6_138, iter7_138 in ipairs(arg0_138.classifyIds) do
		if iter7_138 == var12_0 then
			table.insert(arg0_138.classifyNames, i18n("shop_filter_all"))
		elseif iter7_138 == var13_0 or iter7_138 == var15_0 then
			table.insert(arg0_138.classifyNames, i18n("shop_filter_trial"))
		elseif iter7_138 == var14_0 then
			table.insert(arg0_138.classifyNames, i18n("shop_filter_retro"))
		else
			table.insert(arg0_138.classifyNames, pg.skin_page_template[iter7_138].name)
		end
	end
end

function var0_0.GetShopTypeIdBySkinId(arg0_140, arg1_140)
	local var0_140 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_140.shopTypeIdList then
		arg0_140.shopTypeIdList = {}
	end

	if arg0_140.shopTypeIdList[arg1_140] then
		return arg0_140.shopTypeIdList[arg1_140]
	end

	for iter0_140, iter1_140 in pairs(var0_140) do
		for iter2_140, iter3_140 in ipairs(iter1_140) do
			arg0_140.shopTypeIdList[iter3_140] = iter0_140

			if iter3_140 == arg1_140 then
				return iter0_140
			end
		end
	end
end

function var0_0.OnShopping(arg0_141, arg1_141)
	if not arg0_141.showingCommodity then
		return
	end

	if arg0_141.purchaseView and arg0_141.purchaseView:GetLoaded() then
		arg0_141.purchaseView:Hide()
	end

	if arg0_141.showingCommodity.id == arg1_141 then
		arg0_141:GetAllCommodities()
		arg0_141:Refresh(true)
	end
end

function var0_0.OnFurnitureUpdate(arg0_142, arg1_142)
	if not arg0_142.showingCommodity then
		return
	end

	local var0_142 = arg0_142.showingCommodity.id

	if Goods.ExistFurniture(var0_142) and Goods.Id2FurnitureId(var0_142) == arg1_142 then
		arg0_142:GetAllCommodities()
		arg0_142:Refresh(true)
	end
end

function var0_0.willExit(arg0_143)
	arg0_143:ClearCards()
	ClearLScrollrect(arg0_143.scrollrect)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_143:getUIName())

	if arg0_143.live2dChar then
		arg0_143.live2dChar:Dispose()

		arg0_143.live2dChar = nil
	end

	if arg0_143.voucherMsgBox then
		arg0_143.voucherMsgBox:Destroy()

		arg0_143.voucherMsgBox = nil
	end

	if arg0_143.purchaseView then
		arg0_143.purchaseView:Destroy()

		arg0_143.purchaseView = nil
	end

	for iter0_143, iter1_143 in pairs(arg0_143.downloads) do
		iter1_143:Dispose()
	end

	arg0_143.downloads = {}

	arg0_143:ClearPainting()

	if arg0_143.interactionPreview then
		arg0_143.interactionPreview:Dispose()

		arg0_143.interactionPreview = nil
	end

	arg0_143:disposeEvent()
	arg0_143:ClearTimer()
	arg0_143:ReturnChar()
	arg0_143:UnOverlay()
end

function var0_0.onBackPressed(arg0_144)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
