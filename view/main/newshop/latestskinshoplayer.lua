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

function var0_0.init(arg0_3)
	arg0_3.bgs = arg0_3._tf:Find("bgs")
	arg0_3.adapt = arg0_3._tf:Find("adapt")
	arg0_3.top = arg0_3.adapt:Find("top")
	arg0_3.bottom = arg0_3.adapt:Find("bottom")
	arg0_3.right = arg0_3.adapt:Find("right")
	arg0_3.subPage = arg0_3.adapt:Find("subPage")
	arg0_3.resources = arg0_3.adapt:Find("top/resources")
	arg0_3.limitTime = arg0_3.adapt:Find("top/title/limit_time/Text")
	arg0_3.skinName = arg0_3.adapt:Find("top/title/skin_name_mask/skin_name")
	arg0_3.shipName = arg0_3.adapt:Find("top/title/name_mask/name")
	arg0_3.changeSkin = arg0_3.adapt:Find("top/change_skin")
	arg0_3.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_3.changeSkin, "toggle_ui"))
	arg0_3.showOwnBtn = arg0_3.adapt:Find("bottom/showOwnBtn")
	arg0_3.filterBtn = arg0_3.adapt:Find("bottom/filterBtn")
	arg0_3.search = arg0_3.adapt:Find("bottom/search")
	arg0_3.scrollrect = arg0_3.adapt:Find("bottom/scroll/content"):GetComponent("LScrollRect")
	arg0_3.sdTg = arg0_3.adapt:Find("right/sdTg")
	arg0_3.hideUITg = arg0_3.adapt:Find("right/hideUITg")
	arg0_3.charContainer = arg0_3.adapt:Find("right/char_container")
	arg0_3.backChara = arg0_3.charContainer:Find("bg/back/chara")
	arg0_3.charTf = arg0_3.charContainer:Find("char")
	arg0_3.furnitureContainer = arg0_3.charContainer:Find("fur")
	arg0_3.switchPreviewBtn = arg0_3.charContainer:Find("switch")
	arg0_3.dynamicToggle = arg0_3.adapt:Find("right/functionsAndTags/dynamic")
	arg0_3.showBgToggle = arg0_3.adapt:Find("right/functionsAndTags/showBg")
	arg0_3.dynamicResToggle = arg0_3.adapt:Find("right/functionsAndTags/dynamic/l2d_res_state")
	arg0_3.tagList = UIItemList.New(arg0_3.adapt:Find("right/functionsAndTags/tags"), arg0_3.adapt:Find("right/functionsAndTags/tags/tag"))
	arg0_3.giftPackBtn = arg0_3.adapt:Find("right/giftPackBtn")
	arg0_3.price = arg0_3.adapt:Find("right/price")
	arg0_3.btns = arg0_3.price:Find("btns")
	arg0_3.filterUI = arg0_3.adapt:Find("subPage/filterUI")
	arg0_3.filterContent = arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content")
	arg0_3.painting = arg0_3._tf:Find("painting")
	arg0_3.paintingTF = arg0_3._tf:Find("painting/paint")
	arg0_3.defaultPaintingPosition = arg0_3.paintingTF.anchoredPosition
	arg0_3.defaultPaintingScale = arg0_3.paintingTF.localScale
	arg0_3.live2dContainer = arg0_3._tf:Find("painting/paint/live2d")
	arg0_3.spTF = arg0_3._tf:Find("painting/paint/spinePainting")
	arg0_3.spBg = arg0_3._tf:Find("painting/paintBg/spinePainting")

	setActive(arg0_3.charContainer, false)
	setActive(arg0_3.filterUI, false)

	arg0_3.mainTitle = arg0_3.adapt:Find("top/mainTitle")
	arg0_3.backBtn = arg0_3.adapt:Find("top/closeBtn")
	arg0_3.homeBtn = arg0_3.adapt:Find("top/homeBtn")
	arg0_3.giftPack = arg0_3.adapt:Find("giftPack")

	setActive(arg0_3.mainTitle, false)
	setActive(arg0_3.backBtn, false)
	setActive(arg0_3.homeBtn, false)
	setActive(arg0_3.giftPack, false)

	arg0_3.downloads = {}
	arg0_3.isToggleDynamic = false
	arg0_3.isToggleShowBg = true
	arg0_3.isPreviewFurniture = false
	arg0_3.interactionPreview = BackYardInteractionPreview.New(arg0_3.furnitureContainer, Vector3(0, 0, 0))
	arg0_3.voucherMsgBox = SkinVoucherMsgBox.New(pg.UIMgr.GetInstance().OverlayMain)
	arg0_3.purchaseView = NewSkinShopPurchaseView.New(arg0_3._tf, arg0_3.event)

	arg0_3:RegisterEvent()
	setGray(arg0_3.btns:Find("yigoumai_button"), true, true)
	setText(arg0_3._tf:Find("bgs/empty/Text"), i18n("shop_new_unfound"))
	setText(arg0_3.adapt:Find("top/mainTitle/Text"), i18n("shop_new_shop"))
	setText(arg0_3.filterBtn:Find("Text"), i18n("shop_new_sort"))
	setText(arg0_3.search:Find("holder"), i18n("shop_new_search"))
	setText(arg0_3.btns:Find("yigoumai_button/Text"), i18n("shop_new_purchased"))
	setText(arg0_3.btns:Find("goumai_button/Text"), i18n("shop_new_purchase"))
	setText(arg0_3.btns:Find("qianwanghuoqu_button/Text"), i18n("shop_new_claim"))
	setText(arg0_3.btns:Find("furniture_shop/Text"), i18n("shop_new_furniture"))
	setText(arg0_3.btns:Find("item_buy/Text"), i18n("shop_new_discount"))
	setText(arg0_3.btns:Find("tiyan_btn/Text"), i18n("shop_new_try"))
	setText(arg0_3.btns:Find("buy_with_gift/Text"), i18n("shop_new_purchase"))
	setText(arg0_3.price:Find("btn/tag/Text"), i18n("shop_new_gift"))
	setText(arg0_3.giftPack:Find("panel/desc"), i18n("shop_new_gem_transform"))
	setText(arg0_3.giftPack:Find("price/btns/yigoumai_button/Text"), i18n("shop_new_purchased"))
	setText(arg0_3.filterUI:Find("panelMask/panel/title"), i18n("shop_new_sort"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/subTitleFrame/subTitle"), i18n("shop_new_review"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/1/Text"), i18n("shop_new_owned"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/2/Text"), i18n("shop_new_havent_own"))
	setScrollText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/3/mask/Text"), i18n("shop_new_unused"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("shop_new_type"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/2/Text"), i18n("shop_new_static"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/3/Text"), i18n("shop_new_dynamic"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/4/Text"), i18n("shop_new_static_bg"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/5/Text"), i18n("shop_new_dynamic_bg"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/6/Text"), i18n("shop_new_bgm"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/subTitleFrame/subTitle"), i18n("shop_new_index"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/1/Text"), i18n("shop_new_ship_owned"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/2/Text"), i18n("shop_new_ship_havent_owned"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/camp/subTitleFrame/subTitle"), i18n("shop_new_nation"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/rarity/subTitleFrame/subTitle"), i18n("shop_new_rarity"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipType/subTitleFrame/subTitle"), i18n("shop_new_category"))
	setText(arg0_3.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/themeType/subTitleFrame/subTitle"), i18n("shop_new_skin_theme"))
	setText(arg0_3.filterUI:Find("panelMask/panel/bottom/ok/Text"), i18n("shop_new_confirm"))
	arg0_3:Overlay()
end

function var0_0.Overlay(arg0_4)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4.adapt, {
		groupName = "shop",
		pbList = {
			arg0_4.top:Find("title"),
			arg0_4.top:Find("title/limit_time"),
			arg0_4.top:Find("title/charaNameBg"),
			arg0_4.showOwnBtn,
			arg0_4.filterBtn,
			arg0_4.search,
			arg0_4.charContainer:Find("bg"),
			arg0_4.price:Find("consume"),
			arg0_4.filterUI:Find("panelMask/panel")
		}
	})
end

function var0_0.UnOverlay(arg0_5)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5.adapt, arg0_5._tf)
end

function var0_0.didEnter(arg0_6)
	arg0_6:InitData()
	arg0_6:SetFilterPanel()
	arg0_6:SetResource()

	if arg0_6.mode == var0_0.MODE_EXPERIENCE or arg0_6.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI_2, false)
		setActive(arg0_6.showOwnBtn, false)
		setActive(arg0_6.filterBtn, false)
		setActive(arg0_6.search, false)

		arg0_6.top:Find("title").anchoredPosition = Vector2(184.2, -208.3)
		arg0_6.top:Find("change_skin").anchoredPosition = Vector2(70.7, -337.8)
		arg0_6.right:Find("giftPackBtn").anchoredPosition = Vector2(-483, -446.4)
		arg0_6.right:Find("price").anchoredPosition = Vector2(-238.3, -140.7)
		arg0_6.bottom:Find("scroll").offsetMin = Vector2(17.7, 0)
		arg0_6.bottom:Find("scroll").offsetMax = Vector2(-718.7, 227.9)
	end

	arg0_6:SetGiftPackLayer()
	onDelayTick(function()
		arg0_6:SetSkinScroll()
		arg0_6:Refresh(true)
	end, 0.001)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:closeView()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.homeBtn, function()
		arg0_6:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.filterBtn, function()
		arg0_6:OpenFilterPanel()
	end, SFX_PANEL)

	if arg0_6.mode == var0_0.MODE_EXPERIENCE or arg0_6.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	local var0_6 = getProxy(PlayerProxy):getRawData().id

	onToggle(arg0_6, arg0_6.sdTg, function(arg0_11)
		setActive(arg0_6.charContainer, arg0_11)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_6, arg0_11 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_6 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_6, 0)

	triggerToggle(arg0_6.sdTg, var1_6 == 1)
	onToggle(arg0_6, arg0_6.hideUITg, function(arg0_12)
		setActive(arg0_6.top, not arg0_12)
		setActive(arg0_6.bottom, not arg0_12)
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg0_12)
	end, SFX_PANEL)
	onInputChanged(arg0_6, arg0_6.search, function()
		arg0_6:Refresh(true)

		local var0_13 = getInputText(arg0_6.search)

		setActive(arg0_6.search:Find("holder"), var0_13 == "")
	end)
	onButton(arg0_6, arg0_6.showOwnBtn, function()
		arg0_6:emit(LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER)
	end, SFX_PANEL)
	getProxy(CommanderManualProxy):TaskProgressAdd(2021, 1)
end

function var0_0.SetResource(arg0_15)
	local var0_15 = getProxy(PlayerProxy):getRawData()

	setText(arg0_15.resources:Find("gem/Text"), var0_15:getTotalGem())
	onButton(arg0_15, arg0_15.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_17)
	arg0_17.type = arg0_17.contextData.type or var0_0.TYPE_PERMANANT_SKIN
	arg0_17.mode = arg0_17.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_17:GetAllCommodities()
	arg0_17:GetGiftPackCommodities()

	arg0_17.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()

	arg0_17:GetSkinClassify()

	local var0_17 = (arg0_17.mode == var0_0.MODE_EXPERIENCE or arg0_17.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM) and 1 or 0

	arg0_17.filterValues = {
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
			var0_17
		}
	}
	arg0_17.filterValuesTemp = Clone(arg0_17.filterValues)
end

function var0_0.GetAllCommodities(arg0_18)
	if arg0_18.type == var0_0.TYPE_NEW_SKIN then
		arg0_18.commodities = getProxy(ShipSkinProxy):GetInTimeSkins()
	elseif arg0_18.type == var0_0.TYPE_PERMANANT_SKIN then
		arg0_18.commodities = getProxy(ShipSkinProxy):GetPermanentSkins()
	end

	if LOCK_SKIN_US then
		local var0_18 = pg.gameset.levellimit_skintype.key_value
		local var1_18 = pg.gameset.levellimit_skintype.description

		if var0_18 >= getProxy(PlayerProxy):getData().level then
			arg0_18.commodities = _.filter(arg0_18.commodities, function(arg0_19)
				local var0_19 = pg.ship_skin_template[arg0_19:getSkinId()].shop_type_id

				return table.contains(var1_18, var0_19)
			end)
		end
	end

	if arg0_18.mode == var0_0.MODE_OVERVIEW then
		for iter0_18 = #arg0_18.commodities, 1, -1 do
			if arg0_18.commodities[iter0_18]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				table.remove(arg0_18.commodities, iter0_18)
			end
		end
	end
end

function var0_0.GetGiftPackCommodities(arg0_20)
	arg0_20.giftPackCommodities = {}
	arg0_20.giftSkinCommodities = {}
	arg0_20.giftSkinProbabilitys = {}

	for iter0_20, iter1_20 in ipairs(pg.pay_data_display.all) do
		local var0_20 = pg.pay_data_display[iter1_20]

		if var0_20.skin_inquire_relation ~= 0 and pg.TimeMgr.GetInstance():inTime(var0_20.time) then
			local var1_20 = getProxy(ShopsProxy):GetGiftCommodity(iter1_20, Goods.TYPE_CHARGE)

			arg0_20.giftPackCommodities[iter1_20] = var1_20

			local var2_20 = var1_20:GetSkinProbability()

			arg0_20.giftSkinCommodities[iter1_20] = getProxy(ShipSkinProxy):GetProbabilitySkins(var2_20)
			arg0_20.giftSkinProbabilitys[iter1_20] = getProxy(ShipSkinProxy):GetSkinProbabilitys(var2_20)
		end
	end
end

function var0_0.SetSkinScroll(arg0_21)
	arg0_21.scrollrect.isNewLoadingMethod = true

	function arg0_21.scrollrect.onInitItem(arg0_22)
		arg0_21:OnInitItem(arg0_22)
	end

	function arg0_21.scrollrect.onUpdateItem(arg0_23, arg1_23)
		arg0_21:OnUpdateItem(arg0_23, arg1_23)
	end

	arg0_21.scrollrect.enabled = true
end

function var0_0.Refresh(arg0_24, arg1_24)
	arg0_24:ClearCards()

	arg0_24.cards = {}
	arg0_24.displays = {}

	local var0_24 = getInputText(arg0_24.search)

	for iter0_24, iter1_24 in ipairs(arg0_24.commodities) do
		if arg0_24:filterOk(iter1_24) and arg0_24:IsSearchType(var0_24, iter1_24) then
			table.insert(arg0_24.displays, iter1_24)
		end
	end

	local var1_24 = {}

	for iter2_24, iter3_24 in ipairs(arg0_24.displays) do
		local var2_24 = iter3_24.type == Goods.TYPE_ACTIVITY or iter3_24.type == Goods.TYPE_ACTIVITY_EXTRA
		local var3_24 = 0

		if not var2_24 then
			var3_24 = iter3_24:GetPrice()
		end

		var1_24[iter3_24.id] = var3_24
	end

	table.sort(arg0_24.displays, function(arg0_25, arg1_25)
		return arg0_24:Sort(arg0_25, arg1_25, var1_24)
	end)

	local var4_24 = #arg0_24.displays == 0

	setActive(arg0_24.bgs:Find("default"), var4_24)
	setActive(arg0_24.bgs:Find("diffBg"), not var4_24)
	setActive(arg0_24.bgs:Find("empty"), var4_24)
	setActive(arg0_24._tf:Find("leftMask"), not var4_24)
	setActive(arg0_24._tf:Find("bottomMask"), not var4_24)
	setActive(arg0_24.painting, not var4_24)
	setActive(arg0_24.top:Find("title"), not var4_24)
	setActive(arg0_24.changeSkin, not var4_24)
	setActive(arg0_24.right, not var4_24)
	setActive(arg0_24.right, not var4_24)
	setActive(arg0_24.bottom:Find("scroll"), not var4_24)

	if not var4_24 then
		if arg1_24 then
			arg0_24.triggerFirstCard = true

			arg0_24.scrollrect:SetTotalCount(#arg0_24.displays, 0)
		else
			arg0_24.scrollrect:SetTotalCount(#arg0_24.displays)
		end
	end
end

function var0_0.IsSearchType(arg0_26, arg1_26, arg2_26)
	if not arg1_26 or arg1_26 == "" then
		return true
	end

	local var0_26 = arg2_26:getSkinId()

	return ShipSkin.New({
		id = var0_26
	}):IsMatchKey(arg1_26)
end

local function var20_0(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg2_27[arg0_27.id]
	local var1_27 = arg2_27[arg1_27.id]

	if var0_27 == var1_27 then
		return arg0_27.id < arg1_27.id
	else
		return var1_27 < var0_27
	end
end

function var0_0.Sort(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = arg1_28.buyCount == 0 and 1 or 0
	local var1_28 = arg2_28.buyCount == 0 and 1 or 0

	if var0_28 == var1_28 then
		local var2_28 = arg1_28:getConfig("order")
		local var3_28 = arg2_28:getConfig("order")

		if var2_28 == var3_28 then
			return var20_0(arg1_28, arg2_28, arg3_28)
		else
			return var2_28 < var3_28
		end
	else
		return var1_28 < var0_28
	end
end

function var0_0.filterOk(arg0_29, arg1_29)
	local var0_29 = arg0_29.filterValues.ownType
	local var1_29 = arg0_29.filterValues.typeType
	local var2_29 = arg0_29.filterValues.shipHaveType
	local var3_29 = arg0_29.filterValues.campType
	local var4_29 = arg0_29.filterValues.rarityType
	local var5_29 = arg0_29.filterValues.shipType
	local var6_29 = arg0_29.filterValues.themeType
	local var7_29 = arg1_29:getSkinId()
	local var8_29 = ShipSkin.New({
		id = var7_29
	})
	local var9_29 = var8_29:GetDefaultShipConfig()
	local var10_29 = arg0_29:ToVShip(var9_29)

	if var0_29 ~= 0 then
		local var11_29 = false
		local var12_29 = getProxy(ShipSkinProxy):hasSkin(var7_29)
		local var13_29 = var8_29:NoUse()

		if var0_29 == 1 and var12_29 then
			var11_29 = true
		end

		if var0_29 == 2 and not var12_29 then
			var11_29 = true
		end

		if var0_29 == 3 and var12_29 and var13_29 then
			var11_29 = true
		end

		if not var11_29 then
			return false
		end
	end

	if var1_29[1] ~= 0 then
		local var14_29 = false

		for iter0_29, iter1_29 in ipairs(var1_29) do
			if iter1_29 == 1 and (var8_29:IsLive2d() or var8_29:IsLive2dPlus()) then
				var14_29 = true
			end

			if iter1_29 == 2 and not var8_29:IsLive2d() and not var8_29:IsLive2dPlus() and not var8_29:IsSpine() and not var8_29:IsSpinePlus() then
				var14_29 = true
			end

			if iter1_29 == 3 and (var8_29:IsSpine() or var8_29:IsSpinePlus()) then
				var14_29 = true
			end

			if iter1_29 == 4 and var8_29:IsBG() then
				var14_29 = true
			end

			if iter1_29 == 5 and var8_29:IsDbg() then
				var14_29 = true
			end

			if iter1_29 == 6 and var8_29:isBgm() then
				var14_29 = true
			end

			if var14_29 then
				break
			end
		end

		if not var14_29 then
			return false
		end
	end

	if var2_29 ~= 0 then
		local var15_29 = false
		local var16_29 = var8_29:CantUse()

		if var2_29 == 1 and not var16_29 then
			var15_29 = true
		end

		if var2_29 == 2 and var16_29 then
			var15_29 = true
		end

		if not var15_29 then
			return false
		end
	end

	if var3_29[1] ~= 0 then
		local var17_29 = false

		for iter2_29, iter3_29 in ipairs(var3_29) do
			local var18_29 = ShipIndexCfg.camp

			for iter4_29, iter5_29 in ipairs(var18_29[iter3_29 + 1].types) do
				if iter5_29 == Nation.LINK then
					if var10_29:getNation() >= Nation.LINK then
						var17_29 = true
					end
				elseif iter5_29 == var10_29:getNation() then
					var17_29 = true
				end
			end

			if var17_29 then
				break
			end
		end

		if not var17_29 then
			return false
		end
	end

	if var4_29[1] ~= 0 then
		local var19_29 = false

		for iter6_29, iter7_29 in ipairs(var4_29) do
			local var20_29 = ShipIndexCfg.rarity

			if table.contains(var20_29[iter7_29 + 1].types, var10_29:getRarity()) then
				var19_29 = true
			end

			if var19_29 then
				break
			end
		end

		if not var19_29 then
			return false
		end
	end

	if var5_29[1] ~= 0 then
		local var21_29 = false

		for iter8_29, iter9_29 in ipairs(var5_29) do
			local var22_29 = ShipIndexCfg.type
			local var23_29 = var22_29[iter9_29 + 1].types

			if iter9_29 + 1 < 4 then
				local var24_29 = var22_29[iter9_29].shipTypes

				if table.contains(var23_29, var10_29:getShipType()) then
					var21_29 = true
				end

				if table.contains(var23_29, var10_29:getTeamType()) then
					var21_29 = true
				end
			elseif table.contains(var23_29, var10_29:getShipType()) then
				var21_29 = true
			end

			if var21_29 then
				break
			end
		end

		if not var21_29 then
			return false
		end
	end

	if var6_29[1] ~= 0 then
		local var25_29 = false

		for iter10_29, iter11_29 in ipairs(var6_29) do
			local var26_29 = arg0_29.classifyIds[iter11_29 + 1]

			if arg1_29:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				if arg0_29.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
					var25_29 = var26_29 == var15_0 and arg0_29:ExitSkinExperienceItem(arg1_29.id)
				else
					var25_29 = var26_29 == var13_0
				end
			elseif var26_29 == var12_0 then
				var25_29 = true
			elseif var26_29 == var14_0 and table.contains(arg0_29.returnSkins, arg1_29.id) then
				var25_29 = true
			else
				local var27_29 = arg0_29:GetShopTypeIdBySkinId(var7_29)

				var25_29 = (var27_29 == 0 and var16_0 or var27_29) == var26_29
			end

			if var25_29 then
				break
			end
		end

		if not var25_29 then
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_30, arg1_30)
	if not arg0_30.vship then
		arg0_30.vship = {}

		function arg0_30.vship.getNation()
			return arg0_30.vship.config.nationality
		end

		function arg0_30.vship.getShipType()
			return arg0_30.vship.config.type
		end

		function arg0_30.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_30.vship.config.type)
		end

		function arg0_30.vship.getRarity()
			return arg0_30.vship.config.rarity
		end
	end

	arg0_30.vship.config = arg1_30

	return arg0_30.vship
end

function var0_0.ExitSkinExperienceItem(arg0_35, arg1_35)
	if not arg0_35.cacheSkinExperienceItems then
		arg0_35.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(arg0_35.cacheSkinExperienceItems, function(arg0_36)
		return arg0_36:CanUseForShop(arg1_35)
	end)
end

function var0_0.RegisterEvent(arg0_37)
	arg0_37:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_38, arg1_38)
		arg0_37:AdjustPainting(arg1_38)
		setActive(arg0_37.top, not arg1_38)
		setActive(arg0_37.bottom, not arg1_38)
		setActive(arg0_37.right, not arg1_38)

		if arg0_37.live2dChar then
			arg0_37.live2dChar:setPurchaseOffset(arg1_38)
		end

		if arg0_37.spineChar then
			if arg1_38 then
				local var0_38 = pg.ship_skin_template[arg0_37.skinId].purchase_offset

				if var0_38 and #var0_38 >= 3 then
					arg0_37.spineChar.localPosition = Vector3(var0_38[1], var0_38[2], var0_38[3])
				end

				if var0_38 and #var0_38 >= 4 then
					arg0_37.spineChar.localScale = Vector3(var0_38[4], var0_38[4], var0_38[4])
				end
			else
				arg0_37.spineChar.localScale = Vector3(0.9, 0.9, 1)
				arg0_37.spineChar.localPosition = Vector3(0, 0, 0)
			end
		end

		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg1_38)
	end)
	arg0_37:bind(var0_0.EVT_ON_PURCHASE, function(arg0_39, arg1_39)
		local var0_39 = arg0_37:GetObtainBtnState(arg1_39)

		arg0_37:OnClickBtn(var0_39, arg1_39)
	end)
	onButton(arg0_37, arg0_37.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_37.skinId) then
			arg0_37.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_37.skinId)

			arg0_37:UpdateMainView(arg0_37.showingCommodity)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_41, arg1_41)
	local var0_41 = NewShopSkinCard.New(arg1_41)

	onButton(arg0_41, var0_41._go, function()
		if not var0_41.commodity then
			return
		end

		for iter0_42, iter1_42 in pairs(arg0_41.cards) do
			iter1_42:UpdateSelected(false)
		end

		arg0_41.selectedId = var0_41.commodity.id

		var0_41:UpdateSelected(true)
		arg0_41:UpdateMainView(var0_41.commodity)
		arg0_41:GCHandle()
	end, SFX_PANEL)

	arg0_41.cards[arg1_41] = var0_41
end

function var0_0.OnUpdateItem(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.cards[arg2_43]

	if not var0_43 then
		arg0_43:OnInitItem(arg2_43)

		var0_43 = arg0_43.cards[arg2_43]
	end

	local var1_43 = arg0_43.displays[arg1_43 + 1]

	if not var1_43 then
		return
	end

	local var2_43 = arg0_43.selectedId == var1_43.id
	local var3_43 = table.contains(arg0_43.returnSkins, var1_43.id)

	var0_43:Update(var1_43, var2_43, var3_43)

	if arg0_43.triggerFirstCard and arg1_43 == 0 then
		arg0_43.triggerFirstCard = false

		triggerButton(var0_43._go)
	end
end

function var0_0.UpdateMainView(arg0_44, arg1_44)
	arg0_44.skinId = arg1_44:getSkinId()

	local var0_44 = ShipSkin.IsChangeSkin(arg0_44.skinId)

	setActive(arg0_44.changeSkin, var0_44)

	if var0_44 then
		arg0_44:FlushChangeSkin(arg1_44)
	end

	arg0_44.shipSkin = ShipSkin.New({
		id = arg0_44.skinId
	})

	arg0_44:FlushName()
	arg0_44:FlushPreviewBtn(arg1_44)
	arg0_44:FlushTimeLimit(arg1_44)
	arg0_44:SwitchPreview(arg1_44, arg0_44.isPreviewFurniture)
	arg0_44:FlushPaintingToggle(arg1_44)
	arg0_44:FlushTag()
	arg0_44:FlushBG(arg1_44)
	arg0_44:FlushPainting(arg1_44)
	arg0_44:FlushPrice(arg1_44)
	arg0_44:FlushObtainBtn(arg1_44)
	arg0_44:FlushGifgPackBtn(arg1_44)

	arg0_44.showingCommodity = arg1_44
end

function var0_0.FlushChangeSkin(arg0_45, arg1_45)
	local var0_45 = ShipSkin.GetChangeSkinGroupId(arg0_45.skinId)
	local var1_45 = ShipSkin.GetChangeSkinCustomDataId(arg0_45.skinId, "hide_shop")
	local var2_45 = pg.gameset.changeskin_switch_block

	if var2_45 and var2_45.description then
		local var3_45 = var2_45.description

		if table.contains(var3_45, var0_45) then
			local var4_45 = HXSet.isHx()

			if arg1_45.buyCount <= 0 and var4_45 then
				setActive(arg0_45.changeSkin, false)
			end
		end
	end

	if var1_45 and var1_45 == 1 then
		setActive(arg0_45.changeSkin, false)
	end

	if not arg0_45.changeSkinId then
		arg0_45.changeSkinId = arg0_45.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_45.changeSkinId) == var0_45 then
		arg0_45.skinId = arg0_45.changeSkinId
	else
		arg0_45.changeSkinId = arg0_45.skinId
	end

	arg0_45.changeSkinToggle:setSkinData(arg0_45.skinId)
end

function var0_0.GCHandle(arg0_46)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.FlushName(arg0_47)
	local var0_47 = pg.ship_skin_template[arg0_47.skinId]

	setScrollText(arg0_47.skinName, SwitchSpecialChar(var0_47.name, true))

	if var0_47.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_47.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_47.skinId)))
	else
		local var1_47 = ShipGroup.getDefaultShipConfig(var0_47.ship_group)

		setScrollText(arg0_47.shipName, var1_47.name)
	end
end

function var0_0.FlushPreviewBtn(arg0_48, arg1_48)
	local var0_48 = Goods.ExistFurniture(arg1_48.id)

	removeOnButton(arg0_48.switchPreviewBtn)

	if not var0_48 and arg0_48.isPreviewFurniture then
		arg0_48.isPreviewFurniture = false
	end

	setActive(arg0_48.switchPreviewBtn, var0_48)

	if var0_48 then
		onButton(arg0_48, arg0_48.switchPreviewBtn, function()
			arg0_48.isPreviewFurniture = not arg0_48.isPreviewFurniture

			arg0_48:SwitchPreview(arg1_48, arg0_48.isPreviewFurniture)
			arg0_48:FlushPrice(arg1_48)
			arg0_48:FlushObtainBtn(arg1_48)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPreview(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50.skinId

	if pg.ship_skin_template[var0_50].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_50.charContainer, false)

		return
	end

	local var1_50 = getProxy(PlayerProxy):getRawData().id

	setActive(arg0_50.charContainer, PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var1_50, 0) == 1)
	setActive(arg0_50.charTf, not arg2_50)
	setActive(arg0_50.furnitureContainer, arg2_50)

	if not arg2_50 then
		local var2_50 = pg.ship_skin_template[var0_50]

		arg0_50:FlushChar(var2_50.prefab, var2_50.id)
		GetImageSpriteFromAtlasAsync("qicon/" .. var2_50.painting, "", arg0_50.backChara)
	else
		local var3_50 = Goods.Id2FurnitureId(arg1_50.id)
		local var4_50 = Goods.GetFurnitureConfig(arg1_50.id)

		arg0_50.interactionPreview:Flush(var0_50, var3_50, var4_50.scale[2] or 1, var4_50.position[2])
	end
end

function var0_0.FlushChar(arg0_51, arg1_51, arg2_51)
	if arg0_51.prefabName and arg0_51.prefabName == arg1_51 then
		return
	end

	arg0_51:ReturnChar()

	arg0_51.prefabName = arg1_51

	PoolMgr.GetInstance():GetSpineChar(arg1_51, true, function(arg0_52)
		if arg0_51.prefabName ~= arg1_51 then
			PoolMgr.GetInstance():ReturnSpineChar(arg1_51, arg0_52)

			return
		end

		arg0_51.spineChar = tf(arg0_52)

		local var0_52 = pg.skinshop_spine_scale[arg2_51]

		if var0_52 then
			arg0_51.spineChar.localScale = Vector3(var0_52.skinshop_scale, var0_52.skinshop_scale, 1)
		else
			arg0_51.spineChar.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0_51.spineChar.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0_51.spineChar, Layer.UI)
		setParent(arg0_51.spineChar, arg0_51.charTf)
		arg0_52:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0_0.ReturnChar(arg0_53)
	if not IsNil(arg0_53.spineChar) then
		arg0_53.spineChar.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_53.prefabName, arg0_53.spineChar.gameObject)

		arg0_53.spineChar = nil
		arg0_53.prefabName = nil
	end
end

function var0_0.ClearCards(arg0_54)
	if not arg0_54.cards then
		return
	end

	for iter0_54, iter1_54 in pairs(arg0_54.cards) do
		iter1_54:Dispose()
	end

	arg0_54.cards = nil
end

function var0_0.FlushTimeLimit(arg0_55, arg1_55)
	local var0_55 = arg0_55.skinId
	local var1_55 = false
	local var2_55

	if arg1_55:IsActivityExtra() and arg1_55:ShowMaintenanceTime() then
		local var3_55, var4_55 = arg1_55:GetMaintenanceMonthAndDay()

		function var2_55()
			return i18n("limit_skin_time_before_maintenance", var3_55, var4_55)
		end

		var1_55 = true
	elseif arg1_55:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_55 = getProxy(ShipSkinProxy):getSkinById(var0_55)

		var1_55 = var5_55 and var5_55:isExpireType() and not var5_55:isExpired()

		if var1_55 then
			function var2_55()
				return skinTimeStamp(var5_55:getRemainTime())
			end
		end
	else
		local var6_55, var7_55 = pg.TimeMgr.GetInstance():inTime(arg1_55:getConfig("time"))

		var1_55 = var7_55

		if var1_55 then
			local var8_55 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_55)

			function var2_55()
				return skinCommdityTimeStamp(var8_55)
			end
		end
	end

	setActive(arg0_55.top:Find("title/limit_time"), var1_55)
	arg0_55:ClearTimer()

	if var1_55 then
		arg0_55:AddTimer(var2_55)
	end
end

function var0_0.AddTimer(arg0_59, arg1_59)
	arg0_59.timer = Timer.New(function()
		setText(arg0_59.limitTime, arg1_59())
	end, 1, -1)

	arg0_59.timer.func()
	arg0_59.timer:Start()
end

function var0_0.ClearTimer(arg0_61)
	if arg0_61.timer then
		arg0_61.timer:Stop()

		arg0_61.timer = nil
	end
end

function var0_0.FlushPaintingToggle(arg0_62, arg1_62)
	removeOnToggle(arg0_62.dynamicToggle)
	removeOnToggle(arg0_62.showBgToggle)

	local var0_62 = checkABExist("painting/" .. arg0_62.shipSkin:getConfig("painting") .. "_n")

	if arg0_62.isToggleShowBg and not var0_62 then
		triggerToggle(arg0_62.showBgToggle, false)

		arg0_62.isToggleShowBg = false
	elseif var0_62 then
		triggerToggle(arg0_62.showBgToggle, true)

		arg0_62.isToggleShowBg = true
	end

	local var1_62 = arg0_62.shipSkin:IsSpine() or arg0_62.shipSkin:IsLive2d() or arg0_62.shipSkin:IsSpinePlus() or arg0_62.shipSkin:IsLive2dPlus()

	if LOCK_SKIN_SHOP_ANIM_PREVIEW == "all" or LOCK_SKIN_SHOP_ANIM_PREVIEW and table.contains(LOCK_SKIN_SHOP_ANIM_PREVIEW, arg0_62.shipSkin.id) then
		var1_62 = false
	end

	if var1_62 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_62.isToggleDynamic = true
	end

	if var1_62 then
		local var2_62 = 0

		if arg0_62.shipSkin:IsSpine() then
			var2_62 = 6
		elseif arg0_62.shipSkin:IsLive2d() then
			var2_62 = 1
		elseif arg0_62.shipSkin:IsSpinePlus() then
			var2_62 = 7
		elseif arg0_62.shipSkin:IsLive2dPlus() then
			var2_62 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_62) .. "_off", arg0_62.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_62), arg0_62.dynamicToggle:Find("select"))
	end

	if arg0_62.isToggleDynamic and not var1_62 then
		triggerToggle(arg0_62.dynamicToggle, false)

		arg0_62.isToggleDynamic = false
	elseif arg0_62.isToggleDynamic and not arg0_62.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_62.shipSkin:IsLive2d() or arg0_62.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_62.isToggleDynamic = false

			local var3_62 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var3_62, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_62.dynamicToggle, false)
		else
			triggerToggle(arg0_62.dynamicToggle, true)

			arg0_62.isToggleDynamic = true
		end
	end

	if var0_62 then
		onToggle(arg0_62, arg0_62.showBgToggle, function(arg0_63)
			arg0_62.isToggleShowBg = arg0_63

			arg0_62:FlushPainting(arg1_62)
			arg0_62:FlushBG(arg1_62)
		end, SFX_PANEL)
	end

	if arg0_62.shipSkin:IsSpine() or arg0_62.shipSkin:IsLive2d() or arg0_62.shipSkin:IsSpinePlus() or arg0_62.shipSkin:IsLive2dPlus() then
		onToggle(arg0_62, arg0_62.dynamicToggle, function(arg0_64)
			if arg0_64 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_62.shipSkin:IsLive2d() or arg0_62.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_62.dynamicToggle, false)

				return
			end

			arg0_62.isToggleDynamic = arg0_64

			setActive(arg0_62.showBgToggle, not arg0_64 and var0_62)
			arg0_62:FlushPainting(arg1_62)
			arg0_62:FlushDynamicPaintingResState(arg1_62)
			arg0_62:RecordFlag(arg0_64)
		end, SFX_PANEL)
	end

	if arg0_62.isToggleDynamic then
		arg0_62:FlushDynamicPaintingResState(arg1_62)
	end

	setActive(arg0_62.dynamicToggle, var1_62)
	setActive(arg0_62.showBgToggle, not arg0_62.isToggleDynamic and var0_62)
end

function var0_0.FlushTag(arg0_65)
	local var0_65 = arg0_65.skinId
	local var1_65 = pg.ship_skin_template[var0_65]
	local var2_65 = Clone(var1_65.tag)
	local var3_65 = false

	for iter0_65 = #var2_65, 1, -1 do
		local var4_65 = var2_65[iter0_65]

		if var4_65 == 1 or var4_65 == 6 or var4_65 == 7 or var4_65 == 9 then
			local var5_65 = true

			table.remove(var2_65, iter0_65)
		end
	end

	local var6_65 = checkABExist("painting/" .. arg0_65.shipSkin:getConfig("painting") .. "_n")

	arg0_65.tagList:make(function(arg0_66, arg1_66, arg2_66)
		if arg0_66 == UIItemList.EventUpdate then
			local var0_66 = var2_65[arg1_66 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_65[arg1_66 + 1]), function(arg0_67)
				if arg0_65.exited then
					return
				end

				arg2_66:GetComponent(typeof(Image)).sprite = arg0_67
			end)
		end
	end)
	arg0_65.tagList:align(#var2_65)
end

function var0_0.FlushPainting(arg0_68, arg1_68)
	local var0_68 = arg0_68:GetPaintingState(arg1_68)
	local var1_68 = pg.ship_skin_template[arg0_68.skinId].painting
	local var2_68 = ShipSkin.GetChangeSkinData(arg0_68.skinId) and true or false

	if var0_68 == var2_0 and not arg0_68:ExistL2dRes(var1_68) or var0_68 == var3_0 and not arg0_68:ExistSpineRes(var1_68) then
		var0_68 = var1_0
	end

	if arg0_68.paintingState and arg0_68.paintingState.state == var0_68 and arg0_68.paintingState.id == arg1_68.id and arg0_68.paintingState.showBg == arg0_68.isToggleShowBg and arg0_68.paintingState.purchaseFlag == arg1_68.buyCount and not var2_68 then
		return
	end

	arg0_68:ClearPainting()

	if var0_68 == var1_0 then
		arg0_68:LoadMeshPainting(arg1_68, arg0_68.isToggleShowBg)
	elseif var0_68 == var2_0 then
		arg0_68:LoadL2dPainting(arg1_68)
	elseif var0_68 == var3_0 then
		arg0_68:LoadSpinePainting(arg1_68)
	end

	arg0_68.paintingState = {
		state = var0_68,
		id = arg1_68.id,
		showBg = arg0_68.isToggleShowBg,
		purchaseFlag = arg1_68.buyCount
	}

	arg0_68:AdjustPainting(false)
end

function var0_0.ClearPainting(arg0_69)
	local var0_69 = arg0_69.paintingState

	if not var0_69 then
		return
	end

	if var0_69.state == var1_0 then
		arg0_69:ClearMeshPainting()
	elseif var0_69.state == var2_0 then
		arg0_69:ClearL2dPainting()
	elseif var0_69.state == var3_0 then
		arg0_69:ClearSpinePainting()
	end

	arg0_69.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_70, arg1_70, arg2_70)
	local var0_70 = findTF(arg0_70.paintingTF, "fitter")
	local var1_70 = GetOrAddComponent(var0_70, "PaintingScaler")

	var1_70.FrameName = "chuanwu"
	var1_70.Tween = 1

	local var2_70 = pg.ship_skin_template[arg0_70.skinId].painting
	local var3_70 = var2_70

	if not arg2_70 and checkABExist("painting/" .. var2_70 .. "_n") then
		var2_70 = var2_70 .. "_n"
	end

	if not checkABExist("painting/" .. var2_70) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_70, true, function(arg0_71)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_71, var0_70, false)
		ShipExpressionHelper.SetExpression(var0_70:GetChild(0), var3_70)

		arg0_70.paintingName = var2_70

		if arg0_70.paintingState and arg0_70.paintingState.id ~= arg1_70.id then
			arg0_70:ClearMeshPainting()
		end

		local var0_71 = arg0_71.transform:Find("shop_hx")

		arg0_70:CheckShowShopHx(var0_71, arg1_70)
	end)
end

function var0_0.ClearMeshPainting(arg0_72)
	local var0_72 = arg0_72.paintingTF:Find("fitter")

	if arg0_72.paintingName and var0_72.childCount > 0 then
		local var1_72 = var0_72:GetChild(0).gameObject
		local var2_72 = var1_72.transform:Find("shop_hx")

		arg0_72:RevertShopHx(var2_72)
		PoolMgr.GetInstance():ReturnPainting(arg0_72.paintingName, var1_72)
	end

	arg0_72.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_73, arg1_73)
	local var0_73 = arg0_73.skinId
	local var1_73 = pg.ship_skin_template[var0_73].skin_type
	local var2_73

	if var1_73 == ShipSkin.SKIN_TYPE_TB then
		var2_73 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_73))
	else
		local var3_73 = pg.ship_skin_template[var0_73].ship_group
		local var4_73 = ShipGroup.getDefaultShipConfig(var3_73)

		var2_73 = Ship.New({
			noChangeSkin = true,
			configId = var4_73.id,
			skin_id = var0_73
		})
	end

	local var5_73 = Live2D.GenerateData({
		ship = var2_73,
		position = Vector3(0, 0, -1),
		parent = arg0_73.live2dContainer,
		offset = var2_73:GetSkinConfig().shop_offset
	})

	var5_73.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_73.live2dChar = Live2D.New(var5_73, function(arg0_74)
		arg0_74:IgonreReactPos(true)
		arg0_73:CheckShowShopHxForL2d(arg0_74, arg1_73)

		if arg0_73.paintingState and arg0_73.paintingState.id ~= arg1_73.id then
			arg0_73:ClearL2dPainting()
		end

		arg0_74:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_75)
	if arg0_75.live2dChar then
		arg0_75:RevertShopHxForL2d(arg0_75.live2dChar)
		arg0_75.live2dChar:Dispose()

		arg0_75.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_76, arg1_76)
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

	local var5_76 = SpinePainting.GenerateData({
		ship = var2_76,
		position = Vector3(0, 0, 0),
		parent = arg0_76.spTF,
		effectParent = arg0_76.spBg,
		offset = var2_76:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_76.spinePainting = SpinePainting.New(var5_76, function(arg0_77)
		if arg0_76.paintingState and arg0_76.paintingState.id ~= arg1_76.id then
			arg0_76:ClearSpinePainting()
		end

		local var0_77 = arg0_77._tf:Find("shop_hx")

		arg0_76:CheckShowShopHx(var0_77, arg1_76)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_78)
	if arg0_78.spinePainting and arg0_78.spinePainting._tf then
		local var0_78 = arg0_78.spinePainting._tf:Find("shop_hx")

		arg0_78:RevertShopHx(arg0_78.shopHx)
		arg0_78.spinePainting:Dispose()

		arg0_78.spinePainting = nil
	end
end

function var0_0.CheckShowShopHx(arg0_79, arg1_79, arg2_79)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	if not IsNil(arg1_79) and arg2_79.buyCount <= 0 then
		setActive(arg1_79, true)
	end
end

function var0_0.RevertShopHx(arg0_80, arg1_80)
	if not IsNil(arg1_80) then
		setActive(arg1_80, false)
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_81, arg1_81, arg2_81)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_81 = arg2_81.buyCount <= 0 and 1 or 0

	arg1_81:changeParamaterValue("shop_hx", var0_81)
end

function var0_0.RevertShopHxForL2d(arg0_82, arg1_82)
	arg1_82:changeParamaterValue("shop_hx", 0)
end

function var0_0.AdjustPainting(arg0_83, arg1_83)
	local var0_83 = arg0_83.paintingTF
	local var1_83 = pg.ship_skin_newmainui_shift[arg0_83.skinId]

	if var1_83 then
		local var2_83 = var1_83.skin_shop_shift

		if arg1_83 then
			var0_83.anchoredPosition = Vector2(var2_83[1] - 440, var2_83[2] + arg0_83.defaultPaintingPosition.y)
		else
			var0_83.anchoredPosition = Vector2(var2_83[1] + arg0_83.defaultPaintingPosition.x, var2_83[2] + arg0_83.defaultPaintingPosition.y)
		end

		local var3_83 = var2_83[4]

		var0_83.localScale = Vector3(var3_83, var3_83, 1)
	else
		var0_83.anchoredPosition = Vector2(arg0_83.defaultPaintingPosition.x, arg0_83.defaultPaintingPosition.y)
		var0_83.localScale = arg0_83.defaultPaintingScale
	end
end

function var0_0.FlushBG(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg0_84.skinId
	local var1_84 = pg.ship_skin_template[var0_84]
	local var2_84

	if var1_84.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_84 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_84))
	else
		local var3_84 = ShipGroup.getDefaultShipConfig(var1_84.ship_group)

		var2_84 = Ship.New({
			id = 999,
			configId = var3_84.id,
			skin_id = var0_84
		})
	end

	local var4_84 = var2_84:getShipBgPrint(true)
	local var5_84 = pg.ship_skin_template[var0_84].painting

	if (arg0_84.isToggleShowBg or not checkABExist("painting/" .. var5_84 .. "_n")) and var1_84.bg_sp ~= "" then
		var4_84 = var1_84.bg_sp
	end

	local var6_84 = var4_84 ~= var2_84:rarity2bgPrintForGet()

	if var6_84 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_84, var4_84, arg0_84.bgs:Find("diffBg"), arg0_84.bgs:Find("diffBg/bg"), function(arg0_85)
			if arg2_84 then
				arg2_84()
			end
		end, function(arg0_86)
			if arg2_84 then
				arg2_84()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_84:getUIName())

		if arg2_84 then
			arg2_84()
		end
	end

	setActive(arg0_84.bgs:Find("diffBg"), var6_84)
	setActive(arg0_84.bgs:Find("default"), not var6_84)
end

function var0_0.FlushDynamicPaintingResState(arg0_87, arg1_87)
	if not arg0_87.isToggleDynamic then
		return
	end

	local var0_87 = arg0_87:GetPaintingState(arg1_87)
	local var1_87 = false
	local var2_87 = ""
	local var3_87 = pg.ship_skin_template[arg0_87.skinId].painting

	if var2_0 == var0_87 then
		var1_87, var2_87 = arg0_87:ExistL2dRes(var3_87)
	elseif var3_0 == var0_87 then
		var1_87, var2_87 = arg0_87:ExistSpineRes(var3_87)
	end

	setActive(arg0_87.dynamicResToggle, not var1_87)
	removeOnButton(arg0_87.dynamicResToggle)

	if not var1_87 and var2_87 ~= "" then
		onButton(arg0_87, arg0_87.dynamicResToggle, function()
			arg0_87:DownloadDynamicPainting(var2_87, arg1_87)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_89, arg1_89, arg2_89)
	local var0_89 = arg0_89.skinId

	if arg0_89.downloads[var0_89] then
		return
	end

	local var1_89 = SkinShopDownloadRequest.New()

	arg0_89.downloads[var0_89] = var1_89

	var1_89:Start(arg1_89, function(arg0_90)
		if arg0_90 and arg0_89.paintingState and arg0_89.paintingState.id == arg2_89.id then
			arg0_89:FlushPainting(arg2_89)
			arg0_89:FlushDynamicPaintingResState(arg2_89)
		end

		var1_89:Dispose()

		arg0_89.downloads[var0_89] = nil
	end)
end

function var0_0.GetPaintingState(arg0_91, arg1_91)
	if arg0_91.isToggleDynamic and (arg0_91.shipSkin:IsLive2d() or arg0_91.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_91.isToggleDynamic and (arg0_91.shipSkin:IsSpine() or arg0_91.shipSkin:IsSpinePlus()) then
		if arg0_91.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_92, arg1_92)
	local var0_92 = "live2d/" .. string.lower(arg1_92)
	local var1_92 = HXSet.autoHxShiftPath(var0_92, nil, true)

	return checkABExist(var1_92), var1_92
end

function var0_0.ExistSpineRes(arg0_93, arg1_93)
	local var0_93 = "SpinePainting/" .. string.lower(arg1_93)
	local var1_93 = HXSet.autoHxShiftPath(var0_93, nil, true)

	return checkABExist(var1_93), var1_93
end

function var0_0.RecordFlag(arg0_94, arg1_94)
	local var0_94 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_94, arg1_94 and 1 or 0)
	PlayerPrefs.Save()
	arg0_94:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_94)
end

function var0_0.FlushPrice(arg0_95, arg1_95)
	local var0_95 = arg1_95:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_95 = arg1_95.type == Goods.TYPE_ACTIVITY or arg1_95.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_95 then
		if arg0_95.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_95:UpdateExperiencePrice4Item(arg1_95)
		else
			arg0_95:UpdateExperiencePrice(arg1_95)
		end
	elseif arg0_95.isPreviewFurniture then
		arg0_95:UpdateFurniturePrice(arg1_95)
	elseif var1_95 then
		-- block empty
	else
		arg0_95:UpdateCommodityPrice(arg1_95)
	end

	local var2_95 = arg1_95.type == Goods.TYPE_SKIN

	setActive(arg0_95.price:Find("timeLimit"), var0_95 and not var1_95)
	setActive(arg0_95.price:Find("consume"), var2_95 and not var0_95 and not var1_95)
end

function var0_0.UpdateExperiencePrice4Item(arg0_96, arg1_96)
	local var0_96 = arg1_96:getConfig("resource_num")
	local var1_96 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_96 = _.detect(var1_96, function(arg0_97)
		return arg0_97:CanUseForShop(arg1_96.id)
	end)
	local var3_96 = var2_96 and var2_96.count or 0
	local var4_96 = (var3_96 < var0_96 and "<color=" .. COLOR_RED .. ">" or "") .. var3_96 .. (var3_96 < var0_96 and "</color>" or "")

	setText(arg0_96.price:Find("timeLimit/consume/Text"), var4_96 .. "/" .. var0_96)
end

function var0_0.UpdateExperiencePrice(arg0_98, arg1_98)
	local var0_98 = arg1_98:getConfig("resource_num")
	local var1_98 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_98 = (var1_98 < var0_98 and "<color=" .. COLOR_RED .. ">" or "") .. var1_98 .. (var1_98 < var0_98 and "</color>" or "")

	setText(arg0_98.price:Find("timeLimit/consume/Text"), var2_98 .. "/" .. var0_98)
end

function var0_0.UpdateCommodityPrice(arg0_99, arg1_99)
	local var0_99 = arg1_99:GetPrice()
	local var1_99 = arg1_99:getConfig("resource_num")

	setText(arg0_99.price:Find("consume/Text"), var0_99)
	setText(arg0_99.price:Find("consume/originalprice/Text"), var1_99)
	setActive(arg0_99.price:Find("consume/originalprice"), var0_99 ~= var1_99)
end

function var0_0.UpdateFurniturePrice(arg0_100, arg1_100)
	local var0_100 = Goods.Id2FurnitureId(arg1_100.id)
	local var1_100 = Furniture.New({
		id = var0_100
	})
	local var2_100 = var1_100:getConfig("gem_price")

	setText(arg0_100.price:Find("consume/originalprice/Text"), var2_100)

	local var3_100 = var1_100:getPrice(PlayerConst.ResDiamond)

	setText(arg0_100.price:Find("consume/Text"), var3_100)
	setActive(arg0_100.price:Find("consume/originalprice"), var2_100 ~= var3_100)
end

function var0_0.FlushObtainBtn(arg0_101, arg1_101)
	local var0_101 = arg0_101:GetObtainBtnState(arg1_101)
	local var1_101 = var19_0(var0_101)

	for iter0_101 = 0, arg0_101.btns.childCount - 1 do
		local var2_101 = arg0_101.btns:GetChild(iter0_101)

		setActive(var2_101, var2_101.name == var1_101)
	end

	setActive(arg0_101.price:Find("btn/item"), var0_101 == var11_0)
	setActive(arg0_101.price:Find("btn/tag"), var0_101 == var11_0)

	if var0_101 == var11_0 then
		arg0_101:FlushGift(arg1_101)
	end

	onButton(arg0_101, arg0_101.price:Find("btn"), function()
		local var0_102 = {}

		if SkinCouponActivity.StaticEncoreActTip(arg1_101.id) then
			table.insert(var0_102, function(arg0_103)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Hint"),
					onYes = function()
						local var0_104 = checkExist(SkinCouponActivity.GetSkinCouponEncoreAct(), {
							"id"
						})

						if var0_104 then
							arg0_101:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var0_104)
						end
					end,
					onNo = function()
						arg0_103()
					end
				})
			end)
		end

		seriesAsync(var0_102, function()
			if var0_101 == var5_0 or var0_101 == var7_0 or var0_101 == var11_0 then
				arg0_101.purchaseView:ExecuteAction("Show", arg1_101)
			else
				arg0_101:OnClickBtn(var0_101, arg1_101)
			end
		end)
	end, SFX_PANEL)
end

function var0_0.GetObtainBtnState(arg0_107, arg1_107)
	if arg1_107:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_107.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_107.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_107.type == Goods.TYPE_ACTIVITY or arg1_107.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_107.buyCount > 0 then
		return var4_0
	elseif arg1_107:isDisCount() and arg1_107:IsItemDiscountType() then
		return var7_0
	elseif arg1_107:CanUseVoucherType() or arg1_107:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_107:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushGift(arg0_108, arg1_108)
	local var0_108 = arg1_108:GetGiftList()[1]

	updateDrop(arg0_108.price:Find("btn/item/mask/item"), {
		type = var0_108.type,
		id = var0_108.id,
		count = var0_108.count
	})
end

function var0_0.OnClickBtn(arg0_109, arg1_109, arg2_109)
	if arg1_109 == var5_0 or arg1_109 == var7_0 or arg1_109 == var11_0 then
		arg0_109:OnPurchase(arg2_109)
	elseif arg1_109 == var10_0 then
		arg0_109:OnItemPurchase(arg2_109)
	elseif arg1_109 == var6_0 then
		arg0_109:OnActivity(arg2_109)
	elseif arg1_109 == var8_0 then
		arg0_109:OnBackyard(arg2_109)
	elseif arg1_109 == var9_0 then
		if arg0_109.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_109:OnExperience4Item(arg2_109)
		else
			arg0_109:OnExperience(arg2_109)
		end
	end
end

function var0_0.FlushGifgPackBtn(arg0_110, arg1_110)
	local var0_110 = false
	local var1_110
	local var2_110
	local var3_110

	for iter0_110, iter1_110 in pairs(arg0_110.giftSkinCommodities) do
		for iter2_110, iter3_110 in ipairs(iter1_110) do
			if iter3_110.id == arg1_110.id then
				var0_110 = true

				break
			end
		end

		if var0_110 then
			var1_110 = arg0_110.giftPackCommodities[iter0_110]
			var2_110 = arg0_110.giftSkinCommodities[iter0_110]
			var3_110 = arg0_110.giftSkinProbabilitys[iter0_110]

			break
		end
	end

	setActive(arg0_110.giftPackBtn, var0_110)

	if var0_110 then
		onButton(arg0_110, arg0_110.giftPackBtn, function()
			arg0_110:emit(LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER, var1_110, var2_110, var3_110)
		end, SFX_PANEL)
	end
end

function var0_0.SetGiftPackLayer(arg0_112)
	return
end

function var0_0.OnPurchase(arg0_113, arg1_113)
	if arg1_113.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_113:isDisCount() and arg1_113:IsItemDiscountType() then
		arg0_113:emit(LatestSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_113.id, 1)
	else
		arg0_113:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_113.id, 1)
	end
end

function var0_0.OnItemPurchase(arg0_114, arg1_114)
	if arg1_114.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_114 = arg1_114:GetVoucherIdList()
	local var1_114 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_114.id)

	if #var0_114 <= 0 and #var1_114 <= 0 then
		return
	end

	local var2_114 = {}

	for iter0_114, iter1_114 in ipairs(var0_114) do
		table.insert(var2_114, iter1_114)
	end

	for iter2_114, iter3_114 in ipairs(var1_114) do
		table.insert(var2_114, iter3_114.id)
	end

	local var3_114 = arg0_114.skinId
	local var4_114 = pg.ship_skin_template[var3_114]
	local var5_114 = SwitchSpecialChar(var4_114.name, true)

	arg0_114.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_114,
		skinId = var3_114,
		skinName = var5_114,
		price = arg1_114:GetPrice(),
		onYes = function(arg0_115)
			if arg0_115 then
				arg0_114:emit(LatestSkinShopMediator.ON_ITEM_PURCHASE, arg0_115, arg1_114.id)
			else
				arg0_114:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_114.id, 1)
			end
		end
	})
end

function var0_0.OnActivity(arg0_116, arg1_116)
	local var0_116 = arg1_116:getConfig("time")
	local var1_116 = arg1_116:getConfig("activity")
	local var2_116 = getProxy(ActivityProxy):getActivityById(var1_116)

	if var1_116 == 0 and pg.TimeMgr.GetInstance():inTime(var0_116) or var2_116 and not var2_116:isEnd() then
		if arg1_116.type == Goods.TYPE_ACTIVITY then
			arg0_116:emit(LatestSkinShopMediator.GO_SHOPS_LAYER, arg1_116:getConfig("activity"))
		elseif arg1_116.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_116 = arg1_116:getConfig("scene")

			if var3_116 and #var3_116 > 0 then
				arg0_116:emit(LatestSkinShopMediator.OPEN_SCENE, var3_116)
			else
				arg0_116:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_116)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_117, arg1_117)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_117 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_117.name, var0_117.level))

		return
	end

	arg0_117:emit(LatestSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_118, arg1_118)
	local var0_118 = arg0_118.skinId
	local var1_118 = getProxy(ShipSkinProxy):getSkinById(var0_118)

	if var1_118 and not var1_118:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_118 = arg1_118:getConfig("resource_num")
	local var3_118 = arg1_118:getConfig("time_second") * var2_118
	local var4_118, var5_118, var6_118, var7_118 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_118)
	local var8_118 = pg.ship_skin_template[arg0_118.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_118, var8_118, var4_118, var5_118),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_118 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_118:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_118.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_120, arg1_120)
	local var0_120 = arg0_120.skinId
	local var1_120 = getProxy(ShipSkinProxy):getSkinById(var0_120)

	if var1_120 and not var1_120:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_120 = arg1_120:getConfig("resource_num")
	local var3_120 = arg1_120:getConfig("time_second") * var2_120
	local var4_120, var5_120, var6_120, var7_120 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_120)
	local var8_120 = pg.ship_skin_template[arg0_120.skinId].name
	local var9_120 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_120 = _.detect(var9_120, function(arg0_121)
		return arg0_121:CanUseForShop(arg1_120.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_120, var8_120, var4_120, var5_120),
		onYes = function()
			if not var10_120 or var10_120.count < var2_120 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_120:emit(LatestSkinShopMediator.ON_ITEM_EXPERIENCE, var10_120.id, arg1_120.id, 1)
		end
	})
end

function var0_0.SetFilterPanel(arg0_123)
	local var0_123 = arg0_123.filterContent:Find("own/options")
	local var1_123 = arg0_123.filterContent:Find("type/options")
	local var2_123 = arg0_123.filterContent:Find("shipHave/options")
	local var3_123 = arg0_123.filterContent:Find("camp/options")
	local var4_123 = arg0_123.filterContent:Find("rarity/options")
	local var5_123 = arg0_123.filterContent:Find("shipType/options")
	local var6_123 = arg0_123.filterContent:Find("themeType/options")

	arg0_123:SetOptionList(var3_123, ShipIndexConst.CampNames, true)
	arg0_123:SetOptionList(var4_123, ShipIndexConst.RarityNames, true)
	arg0_123:SetOptionList(var5_123, ShipIndexConst.TypeNames, true)
	arg0_123:SetOptionList(var6_123, arg0_123.classifyNames)
	arg0_123:SetSingleOptions(var0_123, "ownType")
	arg0_123:SetMultiOptions(var1_123, "typeType")
	arg0_123:SetSingleOptions(var2_123, "shipHaveType")
	arg0_123:SetMultiOptions(var3_123, "campType")
	arg0_123:SetMultiOptions(var4_123, "rarityType")
	arg0_123:SetMultiOptions(var5_123, "shipType")
	arg0_123:SetMultiOptions(var6_123, "themeType")
	onButton(arg0_123, arg0_123.filterUI:Find("bg"), function()
		for iter0_124, iter1_124 in pairs(arg0_123.filterValues) do
			arg0_123.filterValuesTemp[iter0_124] = Clone(arg0_123.filterValues[iter0_124])
		end

		setActive(arg0_123.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_123, arg0_123.filterUI:Find("panelMask/panel/closeBtn"), function()
		for iter0_125, iter1_125 in pairs(arg0_123.filterValues) do
			arg0_123.filterValuesTemp[iter0_125] = Clone(arg0_123.filterValues[iter0_125])
		end

		setActive(arg0_123.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_123, arg0_123.filterUI:Find("panelMask/panel/bottom/ok"), function()
		for iter0_126, iter1_126 in pairs(arg0_123.filterValues) do
			arg0_123.filterValues[iter0_126] = Clone(arg0_123.filterValuesTemp[iter0_126])
		end

		setActive(arg0_123.filterUI, false)
		arg0_123:Refresh(true)
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_127)
	setActive(arg0_127.filterUI, true)

	local var0_127 = arg0_127.filterContent:Find("own/options")
	local var1_127 = arg0_127.filterContent:Find("type/options")
	local var2_127 = arg0_127.filterContent:Find("shipHave/options")
	local var3_127 = arg0_127.filterContent:Find("camp/options")
	local var4_127 = arg0_127.filterContent:Find("rarity/options")
	local var5_127 = arg0_127.filterContent:Find("shipType/options")
	local var6_127 = arg0_127.filterContent:Find("themeType/options")

	arg0_127:SetSingleOptions(var0_127, "ownType", true)
	arg0_127:SetMultiOptions(var1_127, "typeType", true)
	arg0_127:SetSingleOptions(var2_127, "shipHaveType", true)
	arg0_127:SetMultiOptions(var3_127, "campType", true)
	arg0_127:SetMultiOptions(var4_127, "rarityType", true)
	arg0_127:SetMultiOptions(var5_127, "shipType", true)
	arg0_127:SetMultiOptions(var6_127, "themeType", true)
end

function var0_0.SetOptionList(arg0_128, arg1_128, arg2_128, arg3_128)
	local var0_128 = UIItemList.New(arg1_128, arg1_128:GetChild(0))

	var0_128:make(function(arg0_129, arg1_129, arg2_129)
		if arg0_129 == UIItemList.EventUpdate then
			local var0_129 = arg2_128[arg1_129 + 1]

			if arg3_128 then
				var0_129 = i18n(var0_129)
			end

			arg2_129.name = arg1_129

			setScrollText(arg2_129:Find("mask/Text"), var0_129)
		end
	end)
	var0_128:align(#arg2_128)
end

function var0_0.SetSingleOptions(arg0_130, arg1_130, arg2_130, arg3_130)
	for iter0_130 = 0, arg1_130.childCount - 1 do
		local var0_130 = arg1_130:GetChild(iter0_130)

		arg0_130:SetOptionSelect(arg1_130:GetChild(iter0_130), iter0_130 == arg0_130.filterValuesTemp[arg2_130])

		if not arg3_130 then
			onButton(arg0_130, var0_130, function()
				arg0_130.filterValuesTemp[arg2_130] = iter0_130

				for iter0_131 = 0, arg1_130.childCount - 1 do
					arg0_130:SetOptionSelect(arg1_130:GetChild(iter0_131), iter0_131 == iter0_130)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_132, arg1_132, arg2_132, arg3_132)
	for iter0_132 = 0, arg1_132.childCount - 1 do
		local var0_132 = arg1_132:GetChild(iter0_132)

		arg0_132:SetOptionSelect(arg1_132:GetChild(iter0_132), table.contains(arg0_132.filterValuesTemp[arg2_132], iter0_132))

		if not arg3_132 then
			onButton(arg0_132, var0_132, function()
				if iter0_132 == 0 then
					arg0_132.filterValuesTemp[arg2_132] = {
						0
					}

					for iter0_133 = 0, arg1_132.childCount - 1 do
						arg0_132:SetOptionSelect(arg1_132:GetChild(iter0_133), iter0_133 == 0)
					end
				else
					table.removebyvalue(arg0_132.filterValuesTemp[arg2_132], 0)

					if table.contains(arg0_132.filterValuesTemp[arg2_132], iter0_132) then
						table.removebyvalue(arg0_132.filterValuesTemp[arg2_132], iter0_132)
					else
						table.insert(arg0_132.filterValuesTemp[arg2_132], iter0_132)
					end

					local var0_133 = true

					for iter1_133 = 1, arg1_132.childCount - 1 do
						if not table.contains(arg0_132.filterValuesTemp[arg2_132], iter1_133) then
							var0_133 = false

							break
						end
					end

					if #arg0_132.filterValuesTemp[arg2_132] == 0 then
						var0_133 = true
					end

					if var0_133 then
						arg0_132.filterValuesTemp[arg2_132] = {
							0
						}
					end

					for iter2_133 = 0, arg1_132.childCount - 1 do
						arg0_132:SetOptionSelect(arg1_132:GetChild(iter2_133), table.contains(arg0_132.filterValuesTemp[arg2_132], iter2_133))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_134, arg1_134, arg2_134)
	setActive(arg1_134:Find("selectedFrame"), arg2_134)

	local var0_134

	if IsNil(arg1_134:Find("Text")) then
		var0_134 = arg1_134:Find("mask/Text"):GetComponent(typeof(Text))
	else
		var0_134 = arg1_134:Find("Text"):GetComponent(typeof(Text))
	end

	if arg2_134 then
		var0_134.color = Color.New(1, 1, 1, 1)
	else
		var0_134.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.GetSkinClassify(arg0_135)
	arg0_135.classifyIds = {}
	arg0_135.classifyNames = {}

	local var0_135 = {}
	local var1_135 = {}

	for iter0_135, iter1_135 in ipairs(arg0_135.commodities) do
		local var2_135 = arg0_135:GetShopTypeIdBySkinId(iter1_135:getSkinId())
		local var3_135 = var2_135 == 0 and var16_0 or var2_135

		var1_135[var3_135] = (var1_135[var3_135] or 0) + 1
	end

	local var4_135 = {}

	for iter2_135, iter3_135 in ipairs(arg0_135.returnSkins) do
		var4_135[iter3_135] = true
	end

	if underscore.any(arg0_135.commodities, function(arg0_136)
		return var4_135[arg0_136.id]
	end) then
		table.insert(var0_135, var14_0)
	end

	for iter4_135, iter5_135 in ipairs(pg.skin_page_template.all) do
		if iter5_135 ~= var17_0 and iter5_135 ~= var18_0 and (var1_135[iter5_135] or 0) > 0 then
			table.insert(var0_135, iter5_135)
		end
	end

	if arg0_135.mode == var0_0.MODE_EXPERIENCE then
		table.insert(var0_135, 1, var13_0)
	end

	if arg0_135.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_135, 1, var15_0)
	end

	table.insert(var0_135, 1, var12_0)

	arg0_135.classifyIds = var0_135

	for iter6_135, iter7_135 in ipairs(arg0_135.classifyIds) do
		if iter7_135 == var12_0 then
			table.insert(arg0_135.classifyNames, i18n("shop_filter_all"))
		elseif iter7_135 == var13_0 or iter7_135 == var15_0 then
			table.insert(arg0_135.classifyNames, i18n("shop_filter_trial"))
		elseif iter7_135 == var14_0 then
			table.insert(arg0_135.classifyNames, i18n("shop_filter_retro"))
		else
			table.insert(arg0_135.classifyNames, pg.skin_page_template[iter7_135].name)
		end
	end
end

function var0_0.GetShopTypeIdBySkinId(arg0_137, arg1_137)
	local var0_137 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_137.shopTypeIdList then
		arg0_137.shopTypeIdList = {}
	end

	if arg0_137.shopTypeIdList[arg1_137] then
		return arg0_137.shopTypeIdList[arg1_137]
	end

	for iter0_137, iter1_137 in pairs(var0_137) do
		for iter2_137, iter3_137 in ipairs(iter1_137) do
			arg0_137.shopTypeIdList[iter3_137] = iter0_137

			if iter3_137 == arg1_137 then
				return iter0_137
			end
		end
	end
end

function var0_0.OnShopping(arg0_138, arg1_138)
	if not arg0_138.showingCommodity then
		return
	end

	if arg0_138.purchaseView and arg0_138.purchaseView:GetLoaded() then
		arg0_138.purchaseView:Hide()
	end

	if arg0_138.showingCommodity.id == arg1_138 then
		arg0_138:GetAllCommodities()
		arg0_138:Refresh(true)
	end
end

function var0_0.OnFurnitureUpdate(arg0_139, arg1_139)
	if not arg0_139.showingCommodity then
		return
	end

	local var0_139 = arg0_139.showingCommodity.id

	if Goods.ExistFurniture(var0_139) and Goods.Id2FurnitureId(var0_139) == arg1_139 then
		arg0_139:GetAllCommodities()
		arg0_139:Refresh(true)
	end
end

function var0_0.willExit(arg0_140)
	arg0_140:ClearCards()
	ClearLScrollrect(arg0_140.scrollrect)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_140:getUIName())

	if arg0_140.live2dChar then
		arg0_140.live2dChar:Dispose()

		arg0_140.live2dChar = nil
	end

	if arg0_140.voucherMsgBox then
		arg0_140.voucherMsgBox:Destroy()

		arg0_140.voucherMsgBox = nil
	end

	if arg0_140.purchaseView then
		arg0_140.purchaseView:Destroy()

		arg0_140.purchaseView = nil
	end

	for iter0_140, iter1_140 in pairs(arg0_140.downloads) do
		iter1_140:Dispose()
	end

	arg0_140.downloads = {}

	arg0_140:ClearPainting()

	if arg0_140.interactionPreview then
		arg0_140.interactionPreview:Dispose()

		arg0_140.interactionPreview = nil
	end

	arg0_140:disposeEvent()
	arg0_140:ClearTimer()
	arg0_140:ReturnChar()
	arg0_140:UnOverlay()
end

function var0_0.onBackPressed(arg0_141)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
