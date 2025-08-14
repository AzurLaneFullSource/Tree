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
	arg0_3.showOwnBtn = arg0_3.adapt:Find("bottom/showOwnBtn")
	arg0_3.filterBtn = arg0_3.adapt:Find("bottom/filterBtn")
	arg0_3.search = arg0_3.adapt:Find("bottom/search")
	arg0_3.scrollrect = arg0_3.adapt:Find("bottom/scroll"):GetComponent("LScrollRect")
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
	arg0_3.filterContent = arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content")
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

	arg0_3.changeSkinToggles = {}

	for iter0_3 = 1, 2 do
		local var0_3 = arg0_3.changeSkin:Find("toggle_ui/ad/toggle/" .. iter0_3)
		local var1_3 = GetComponent(var0_3, typeof(Toggle))

		var1_3.isOn = false

		table.insert(arg0_3.changeSkinToggles, var1_3)
	end

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
	setText(arg0_3.filterUI:Find("panel/title"), i18n("shop_new_sort"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/own/subTitleFrame/subTitle"), i18n("shop_new_review"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/own/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/own/options/1/Text"), i18n("shop_new_owned"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/own/options/2/Text"), i18n("shop_new_havent_own"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/own/options/3/Text"), i18n("shop_new_unused"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("shop_new_type"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/options/2/Text"), i18n("shop_new_static"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/options/3/Text"), i18n("shop_new_dynamic"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/options/4/Text"), i18n("shop_new_static_bg"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/options/5/Text"), i18n("shop_new_dynamic_bg"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/type/options/6/Text"), i18n("shop_new_bgm"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/shipHave/subTitleFrame/subTitle"), i18n("shop_new_index"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/shipHave/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/shipHave/options/1/Text"), i18n("shop_new_ship_owned"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/shipHave/options/2/Text"), i18n("shop_new_ship_havent_owned"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/camp/subTitleFrame/subTitle"), i18n("shop_new_nation"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/rarity/subTitleFrame/subTitle"), i18n("shop_new_rarity"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/shipType/subTitleFrame/subTitle"), i18n("shop_new_category"))
	setText(arg0_3.filterUI:Find("panel/filterScroll/Viewport/Content/themeType/subTitleFrame/subTitle"), i18n("shop_new_skin_theme"))
	setText(arg0_3.filterUI:Find("panel/bottom/ok/Text"), i18n("shop_new_confirm"))
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
			arg0_4.filterUI:Find("panel")
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
	arg0_6:SetSkinScroll()
	arg0_6:Refresh(true)
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

	onToggle(arg0_6, arg0_6.sdTg, function(arg0_10)
		setActive(arg0_6.charContainer, arg0_10)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_6, arg0_10 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_6 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_6, 0)

	triggerToggle(arg0_6.sdTg, var1_6 == 1)
	onToggle(arg0_6, arg0_6.hideUITg, function(arg0_11)
		setActive(arg0_6.top, not arg0_11)
		setActive(arg0_6.bottom, not arg0_11)
		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg0_11)
	end, SFX_PANEL)
	onInputChanged(arg0_6, arg0_6.search, function()
		arg0_6:Refresh(true)

		local var0_12 = getInputText(arg0_6.search)

		setActive(arg0_6.search:Find("holder"), var0_12 == "")
	end)
	onButton(arg0_6, arg0_6.showOwnBtn, function()
		arg0_6:emit(LatestSkinShopMediator.OPEN_OWN_SKIN_LAYER)
	end, SFX_PANEL)
end

function var0_0.SetResource(arg0_14)
	local var0_14 = getProxy(PlayerProxy):getRawData()

	setText(arg0_14.resources:Find("gem/Text"), var0_14:getTotalGem())
	onButton(arg0_14, arg0_14.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_16)
	arg0_16.type = arg0_16.contextData.type or var0_0.TYPE_PERMANANT_SKIN
	arg0_16.mode = arg0_16.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_16:GetAllCommodities()
	arg0_16:GetGiftPackCommodities()

	arg0_16.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()

	arg0_16:GetSkinClassify()

	local var0_16 = (arg0_16.mode == var0_0.MODE_EXPERIENCE or arg0_16.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM) and 1 or 0

	arg0_16.filterValues = {
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
			var0_16
		}
	}
	arg0_16.filterValuesTemp = Clone(arg0_16.filterValues)
end

function var0_0.GetAllCommodities(arg0_17)
	if arg0_17.type == var0_0.TYPE_NEW_SKIN then
		arg0_17.commodities = getProxy(ShipSkinProxy):GetInTimeSkins()
	elseif arg0_17.type == var0_0.TYPE_PERMANANT_SKIN then
		arg0_17.commodities = getProxy(ShipSkinProxy):GetPermanentSkins()
	end

	if LOCK_SKIN_US then
		local var0_17 = pg.gameset.levellimit_skintype.key_value
		local var1_17 = pg.gameset.levellimit_skintype.description

		if var0_17 >= getProxy(PlayerProxy):getData().level then
			arg0_17.commodities = _.filter(arg0_17.commodities, function(arg0_18)
				local var0_18 = pg.ship_skin_template[arg0_18:getSkinId()].shop_type_id

				return table.contains(var1_17, var0_18)
			end)
		end
	end

	if arg0_17.mode == var0_0.MODE_OVERVIEW then
		for iter0_17 = #arg0_17.commodities, 1, -1 do
			if arg0_17.commodities[iter0_17]:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				table.remove(arg0_17.commodities, iter0_17)
			end
		end
	end
end

function var0_0.GetGiftPackCommodities(arg0_19)
	arg0_19.giftPackCommodities = {}
	arg0_19.giftSkinCommodities = {}
	arg0_19.giftSkinProbabilitys = {}

	for iter0_19, iter1_19 in ipairs(pg.pay_data_display.all) do
		local var0_19 = pg.pay_data_display[iter1_19]

		if var0_19.skin_inquire_relation ~= 0 and pg.TimeMgr.GetInstance():inTime(var0_19.time) then
			local var1_19 = getProxy(ShopsProxy):GetGiftCommodity(iter1_19, Goods.TYPE_CHARGE)

			arg0_19.giftPackCommodities[iter1_19] = var1_19

			local var2_19 = var1_19:GetSkinProbability()

			arg0_19.giftSkinCommodities[iter1_19] = getProxy(ShipSkinProxy):GetProbabilitySkins(var2_19)
			arg0_19.giftSkinProbabilitys[iter1_19] = getProxy(ShipSkinProxy):GetSkinProbabilitys(var2_19)
		end
	end
end

function var0_0.SetSkinScroll(arg0_20)
	arg0_20.scrollrect.isNewLoadingMethod = true

	function arg0_20.scrollrect.onInitItem(arg0_21)
		arg0_20:OnInitItem(arg0_21)
	end

	function arg0_20.scrollrect.onUpdateItem(arg0_22, arg1_22)
		arg0_20:OnUpdateItem(arg0_22, arg1_22)
	end
end

function var0_0.Refresh(arg0_23, arg1_23)
	arg0_23:ClearCards()

	arg0_23.cards = {}
	arg0_23.displays = {}

	local var0_23 = getInputText(arg0_23.search)

	for iter0_23, iter1_23 in ipairs(arg0_23.commodities) do
		if arg0_23:filterOk(iter1_23) and arg0_23:IsSearchType(var0_23, iter1_23) then
			table.insert(arg0_23.displays, iter1_23)
		end
	end

	local var1_23 = {}

	for iter2_23, iter3_23 in ipairs(arg0_23.displays) do
		local var2_23 = iter3_23.type == Goods.TYPE_ACTIVITY or iter3_23.type == Goods.TYPE_ACTIVITY_EXTRA
		local var3_23 = 0

		if not var2_23 then
			var3_23 = iter3_23:GetPrice()
		end

		var1_23[iter3_23.id] = var3_23
	end

	table.sort(arg0_23.displays, function(arg0_24, arg1_24)
		return arg0_23:Sort(arg0_24, arg1_24, var1_23)
	end)

	local var4_23 = #arg0_23.displays == 0

	setActive(arg0_23.bgs:Find("default"), var4_23)
	setActive(arg0_23.bgs:Find("diffBg"), not var4_23)
	setActive(arg0_23.bgs:Find("empty"), var4_23)
	setActive(arg0_23._tf:Find("leftMask"), not var4_23)
	setActive(arg0_23._tf:Find("bottomMask"), not var4_23)
	setActive(arg0_23.painting, not var4_23)
	setActive(arg0_23.top:Find("title"), not var4_23)
	setActive(arg0_23.changeSkin, not var4_23)
	setActive(arg0_23.right, not var4_23)
	setActive(arg0_23.right, not var4_23)
	setActive(arg0_23.bottom:Find("scroll"), not var4_23)

	if not var4_23 then
		if arg1_23 then
			arg0_23.triggerFirstCard = true

			arg0_23.scrollrect:SetTotalCount(#arg0_23.displays, 0)
		else
			arg0_23.scrollrect:SetTotalCount(#arg0_23.displays)
		end
	end
end

function var0_0.IsSearchType(arg0_25, arg1_25, arg2_25)
	if not arg1_25 or arg1_25 == "" then
		return true
	end

	local var0_25 = arg2_25:getSkinId()

	return ShipSkin.New({
		id = var0_25
	}):IsMatchKey(arg1_25)
end

local function var20_0(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26[arg0_26.id]
	local var1_26 = arg2_26[arg1_26.id]

	if var0_26 == var1_26 then
		return arg0_26.id < arg1_26.id
	else
		return var1_26 < var0_26
	end
end

function var0_0.Sort(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg1_27.buyCount == 0 and 1 or 0
	local var1_27 = arg2_27.buyCount == 0 and 1 or 0

	if var0_27 == var1_27 then
		local var2_27 = arg1_27:getConfig("order")
		local var3_27 = arg2_27:getConfig("order")

		if var2_27 == var3_27 then
			return var20_0(arg1_27, arg2_27, arg3_27)
		else
			return var2_27 < var3_27
		end
	else
		return var1_27 < var0_27
	end
end

function var0_0.filterOk(arg0_28, arg1_28)
	local var0_28 = arg0_28.filterValues.ownType
	local var1_28 = arg0_28.filterValues.typeType
	local var2_28 = arg0_28.filterValues.shipHaveType
	local var3_28 = arg0_28.filterValues.campType
	local var4_28 = arg0_28.filterValues.rarityType
	local var5_28 = arg0_28.filterValues.shipType
	local var6_28 = arg0_28.filterValues.themeType
	local var7_28 = arg1_28:getSkinId()
	local var8_28 = ShipSkin.New({
		id = var7_28
	})
	local var9_28 = var8_28:GetDefaultShipConfig()
	local var10_28 = arg0_28:ToVShip(var9_28)

	if var0_28 ~= 0 then
		local var11_28 = false
		local var12_28 = getProxy(ShipSkinProxy):hasSkin(var7_28)
		local var13_28 = var8_28:NoUse()

		if var0_28 == 1 and var12_28 then
			var11_28 = true
		end

		if var0_28 == 2 and not var12_28 then
			var11_28 = true
		end

		if var0_28 == 3 and var12_28 and var13_28 then
			var11_28 = true
		end

		if not var11_28 then
			return false
		end
	end

	if var1_28[1] ~= 0 then
		local var14_28 = false

		for iter0_28, iter1_28 in ipairs(var1_28) do
			if iter1_28 == 1 and (var8_28:IsLive2d() or var8_28:IsLive2dPlus()) then
				var14_28 = true
			end

			if iter1_28 == 2 and not var8_28:IsLive2d() and not var8_28:IsLive2dPlus() and not var8_28:IsSpine() and not var8_28:IsSpinePlus() then
				var14_28 = true
			end

			if iter1_28 == 3 and (var8_28:IsSpine() or var8_28:IsSpinePlus()) then
				var14_28 = true
			end

			if iter1_28 == 4 and var8_28:IsBG() then
				var14_28 = true
			end

			if iter1_28 == 5 and var8_28:IsDbg() then
				var14_28 = true
			end

			if iter1_28 == 6 and var8_28:isBgm() then
				var14_28 = true
			end

			if var14_28 then
				break
			end
		end

		if not var14_28 then
			return false
		end
	end

	if var2_28 ~= 0 then
		local var15_28 = false
		local var16_28 = var8_28:CantUse()

		if var2_28 == 1 and not var16_28 then
			var15_28 = true
		end

		if var2_28 == 2 and var16_28 then
			var15_28 = true
		end

		if not var15_28 then
			return false
		end
	end

	if var3_28[1] ~= 0 then
		local var17_28 = false

		for iter2_28, iter3_28 in ipairs(var3_28) do
			local var18_28 = ShipIndexCfg.camp

			for iter4_28, iter5_28 in ipairs(var18_28[iter3_28 + 1].types) do
				if iter5_28 == Nation.LINK then
					if var10_28:getNation() >= Nation.LINK then
						var17_28 = true
					end
				elseif iter5_28 == var10_28:getNation() then
					var17_28 = true
				end
			end

			if var17_28 then
				break
			end
		end

		if not var17_28 then
			return false
		end
	end

	if var4_28[1] ~= 0 then
		local var19_28 = false

		for iter6_28, iter7_28 in ipairs(var4_28) do
			local var20_28 = ShipIndexCfg.rarity

			if table.contains(var20_28[iter7_28 + 1].types, var10_28:getRarity()) then
				var19_28 = true
			end

			if var19_28 then
				break
			end
		end

		if not var19_28 then
			return false
		end
	end

	if var5_28[1] ~= 0 then
		local var21_28 = false

		for iter8_28, iter9_28 in ipairs(var5_28) do
			local var22_28 = ShipIndexCfg.type
			local var23_28 = var22_28[iter9_28 + 1].types

			if iter9_28 + 1 < 4 then
				local var24_28 = var22_28[iter9_28].shipTypes

				if table.contains(var23_28, var10_28:getShipType()) then
					var21_28 = true
				end

				if table.contains(var23_28, var10_28:getTeamType()) then
					var21_28 = true
				end
			elseif table.contains(var23_28, var10_28:getShipType()) then
				var21_28 = true
			end

			if var21_28 then
				break
			end
		end

		if not var21_28 then
			return false
		end
	end

	if var6_28[1] ~= 0 then
		local var25_28 = false

		for iter10_28, iter11_28 in ipairs(var6_28) do
			local var26_28 = arg0_28.classifyIds[iter11_28 + 1]

			if arg1_28:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
				if arg0_28.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
					var25_28 = var26_28 == var15_0 and arg0_28:ExitSkinExperienceItem(arg1_28.id)
				else
					var25_28 = var26_28 == var13_0
				end
			elseif var26_28 == var12_0 then
				var25_28 = true
			elseif var26_28 == var14_0 and table.contains(arg0_28.returnSkins, arg1_28.id) then
				var25_28 = true
			else
				local var27_28 = arg0_28:GetShopTypeIdBySkinId(var7_28)

				var25_28 = (var27_28 == 0 and var16_0 or var27_28) == var26_28
			end

			if var25_28 then
				break
			end
		end

		if not var25_28 then
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_29, arg1_29)
	if not arg0_29.vship then
		arg0_29.vship = {}

		function arg0_29.vship.getNation()
			return arg0_29.vship.config.nationality
		end

		function arg0_29.vship.getShipType()
			return arg0_29.vship.config.type
		end

		function arg0_29.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_29.vship.config.type)
		end

		function arg0_29.vship.getRarity()
			return arg0_29.vship.config.rarity
		end
	end

	arg0_29.vship.config = arg1_29

	return arg0_29.vship
end

function var0_0.ExitSkinExperienceItem(arg0_34, arg1_34)
	if not arg0_34.cacheSkinExperienceItems then
		arg0_34.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(arg0_34.cacheSkinExperienceItems, function(arg0_35)
		return arg0_35:CanUseForShop(arg1_34)
	end)
end

function var0_0.RegisterEvent(arg0_36)
	arg0_36:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_37, arg1_37)
		arg0_36:AdjustPainting(arg1_37)
		setActive(arg0_36.top, not arg1_37)
		setActive(arg0_36.bottom, not arg1_37)
		setActive(arg0_36.right, not arg1_37)

		if arg0_36.live2dChar then
			arg0_36.live2dChar:setPurchaseOffset(arg1_37)
		end

		if arg0_36.spineChar then
			if arg1_37 then
				local var0_37 = pg.ship_skin_template[arg0_36.skinId].purchase_offset

				if var0_37 and #var0_37 >= 3 then
					arg0_36.spineChar.localPosition = Vector3(var0_37[1], var0_37[2], var0_37[3])
				end

				if var0_37 and #var0_37 >= 4 then
					arg0_36.spineChar.localScale = Vector3(var0_37[4], var0_37[4], var0_37[4])
				end
			else
				arg0_36.spineChar.localScale = Vector3(0.9, 0.9, 1)
				arg0_36.spineChar.localPosition = Vector3(0, 0, 0)
			end
		end

		pg.m02:sendNotification(NewShopMainScene.SHOW_OR_HIDE_UI, not arg1_37)
	end)
	arg0_36:bind(var0_0.EVT_ON_PURCHASE, function(arg0_38, arg1_38)
		local var0_38 = arg0_36:GetObtainBtnState(arg1_38)

		arg0_36:OnClickBtn(var0_38, arg1_38)
	end)
	onButton(arg0_36, arg0_36.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_36.skinId) then
			arg0_36.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_36.skinId)

			arg0_36:UpdateMainView(arg0_36.showingCommodity)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_40, arg1_40)
	local var0_40 = NewShopSkinCard.New(arg1_40)

	onButton(arg0_40, var0_40._go, function()
		if not var0_40.commodity then
			return
		end

		for iter0_41, iter1_41 in pairs(arg0_40.cards) do
			iter1_41:UpdateSelected(false)
		end

		arg0_40.selectedId = var0_40.commodity.id

		var0_40:UpdateSelected(true)
		arg0_40:UpdateMainView(var0_40.commodity)
		arg0_40:GCHandle()
	end, SFX_PANEL)

	arg0_40.cards[arg1_40] = var0_40
end

function var0_0.OnUpdateItem(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.cards[arg2_42]

	if not var0_42 then
		arg0_42:OnInitItem(arg2_42)

		var0_42 = arg0_42.cards[arg2_42]
	end

	local var1_42 = arg0_42.displays[arg1_42 + 1]

	if not var1_42 then
		return
	end

	local var2_42 = arg0_42.selectedId == var1_42.id
	local var3_42 = table.contains(arg0_42.returnSkins, var1_42.id)

	var0_42:Update(var1_42, var2_42, var3_42)

	if arg0_42.triggerFirstCard and arg1_42 == 0 then
		arg0_42.triggerFirstCard = false

		triggerButton(var0_42._go)
	end
end

function var0_0.UpdateMainView(arg0_43, arg1_43)
	arg0_43.skinId = arg1_43:getSkinId()

	local var0_43 = ShipSkin.IsChangeSkin(arg0_43.skinId)

	setActive(arg0_43.changeSkin, var0_43)

	if var0_43 then
		arg0_43:FlushChangeSkin()
	end

	arg0_43.shipSkin = ShipSkin.New({
		id = arg0_43.skinId
	})

	arg0_43:FlushName()
	arg0_43:FlushPreviewBtn(arg1_43)
	arg0_43:FlushTimeLimit(arg1_43)
	arg0_43:SwitchPreview(arg1_43, arg0_43.isPreviewFurniture)
	arg0_43:FlushPaintingToggle(arg1_43)
	arg0_43:FlushTag()
	arg0_43:FlushBG(arg1_43)
	arg0_43:FlushPainting(arg1_43)
	arg0_43:FlushPrice(arg1_43)
	arg0_43:FlushObtainBtn(arg1_43)
	arg0_43:FlushGifgPackBtn(arg1_43)

	arg0_43.showingCommodity = arg1_43
end

function var0_0.FlushChangeSkin(arg0_44)
	local var0_44 = ShipSkin.GetChangeSkinGroupId(arg0_44.skinId)

	if not arg0_44.changeSkinId then
		arg0_44.changeSkinId = arg0_44.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_44.changeSkinId) == var0_44 then
		arg0_44.skinId = arg0_44.changeSkinId
	else
		arg0_44.changeSkinId = arg0_44.skinId
	end

	arg0_44._toggleIndex = ShipSkin.GetChangeSkinIndex(arg0_44.skinId)

	for iter0_44 = 1, 2 do
		arg0_44.changeSkinToggles[iter0_44].isOn = iter0_44 == arg0_44._toggleIndex and true or false
	end
end

function var0_0.GCHandle(arg0_45)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.FlushName(arg0_46)
	local var0_46 = pg.ship_skin_template[arg0_46.skinId]

	setScrollText(arg0_46.skinName, SwitchSpecialChar(var0_46.name, true))

	if var0_46.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_46.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_46.skinId)))
	else
		local var1_46 = ShipGroup.getDefaultShipConfig(var0_46.ship_group)

		setScrollText(arg0_46.shipName, var1_46.name)
	end
end

function var0_0.FlushPreviewBtn(arg0_47, arg1_47)
	local var0_47 = Goods.ExistFurniture(arg1_47.id)

	removeOnButton(arg0_47.switchPreviewBtn)

	if not var0_47 and arg0_47.isPreviewFurniture then
		arg0_47.isPreviewFurniture = false
	end

	setActive(arg0_47.switchPreviewBtn, var0_47)

	if var0_47 then
		onButton(arg0_47, arg0_47.switchPreviewBtn, function()
			arg0_47.isPreviewFurniture = not arg0_47.isPreviewFurniture

			arg0_47:SwitchPreview(arg1_47, arg0_47.isPreviewFurniture)
			arg0_47:FlushPrice(arg1_47)
			arg0_47:FlushObtainBtn(arg1_47)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPreview(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg0_49.skinId

	if pg.ship_skin_template[var0_49].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_49.charContainer, false)

		return
	end

	local var1_49 = getProxy(PlayerProxy):getRawData().id

	setActive(arg0_49.charContainer, PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var1_49, 0) == 1)
	setActive(arg0_49.charTf, not arg2_49)
	setActive(arg0_49.furnitureContainer, arg2_49)

	if not arg2_49 then
		local var2_49 = pg.ship_skin_template[var0_49]

		arg0_49:FlushChar(var2_49.prefab, var2_49.id)
		GetImageSpriteFromAtlasAsync("qicon/" .. var2_49.painting, "", arg0_49.backChara)
	else
		local var3_49 = Goods.Id2FurnitureId(arg1_49.id)
		local var4_49 = Goods.GetFurnitureConfig(arg1_49.id)

		arg0_49.interactionPreview:Flush(var0_49, var3_49, var4_49.scale[2] or 1, var4_49.position[2])
	end
end

function var0_0.FlushChar(arg0_50, arg1_50, arg2_50)
	if arg0_50.prefabName and arg0_50.prefabName == arg1_50 then
		return
	end

	arg0_50:ReturnChar()

	arg0_50.prefabName = arg1_50

	PoolMgr.GetInstance():GetSpineChar(arg1_50, true, function(arg0_51)
		if arg0_50.prefabName ~= arg1_50 then
			PoolMgr.GetInstance():ReturnSpineChar(arg1_50, arg0_51)

			return
		end

		arg0_50.spineChar = tf(arg0_51)

		local var0_51 = pg.skinshop_spine_scale[arg2_50]

		if var0_51 then
			arg0_50.spineChar.localScale = Vector3(var0_51.skinshop_scale, var0_51.skinshop_scale, 1)
		else
			arg0_50.spineChar.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0_50.spineChar.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0_50.spineChar, Layer.UI)
		setParent(arg0_50.spineChar, arg0_50.charTf)
		arg0_51:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0_0.ReturnChar(arg0_52)
	if not IsNil(arg0_52.spineChar) then
		arg0_52.spineChar.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_52.prefabName, arg0_52.spineChar.gameObject)

		arg0_52.spineChar = nil
		arg0_52.prefabName = nil
	end
end

function var0_0.ClearCards(arg0_53)
	if not arg0_53.cards then
		return
	end

	for iter0_53, iter1_53 in pairs(arg0_53.cards) do
		iter1_53:Dispose()
	end

	arg0_53.cards = nil
end

function var0_0.FlushTimeLimit(arg0_54, arg1_54)
	local var0_54 = arg0_54.skinId
	local var1_54 = false
	local var2_54

	if arg1_54:IsActivityExtra() and arg1_54:ShowMaintenanceTime() then
		local var3_54, var4_54 = arg1_54:GetMaintenanceMonthAndDay()

		function var2_54()
			return i18n("limit_skin_time_before_maintenance", var3_54, var4_54)
		end

		var1_54 = true
	elseif arg1_54:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_54 = getProxy(ShipSkinProxy):getSkinById(var0_54)

		var1_54 = var5_54 and var5_54:isExpireType() and not var5_54:isExpired()

		if var1_54 then
			function var2_54()
				return skinTimeStamp(var5_54:getRemainTime())
			end
		end
	else
		local var6_54, var7_54 = pg.TimeMgr.GetInstance():inTime(arg1_54:getConfig("time"))

		var1_54 = var7_54

		if var1_54 then
			local var8_54 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_54)

			function var2_54()
				return skinCommdityTimeStamp(var8_54)
			end
		end
	end

	setActive(arg0_54.top:Find("title/limit_time"), var1_54)
	arg0_54:ClearTimer()

	if var1_54 then
		arg0_54:AddTimer(var2_54)
	end
end

function var0_0.AddTimer(arg0_58, arg1_58)
	arg0_58.timer = Timer.New(function()
		setText(arg0_58.limitTime, arg1_58())
	end, 1, -1)

	arg0_58.timer.func()
	arg0_58.timer:Start()
end

function var0_0.ClearTimer(arg0_60)
	if arg0_60.timer then
		arg0_60.timer:Stop()

		arg0_60.timer = nil
	end
end

function var0_0.FlushPaintingToggle(arg0_61, arg1_61)
	removeOnToggle(arg0_61.dynamicToggle)
	removeOnToggle(arg0_61.showBgToggle)

	local var0_61 = checkABExist("painting/" .. arg0_61.shipSkin:getConfig("painting") .. "_n")

	if arg0_61.isToggleShowBg and not var0_61 then
		triggerToggle(arg0_61.showBgToggle, false)

		arg0_61.isToggleShowBg = false
	elseif var0_61 then
		triggerToggle(arg0_61.showBgToggle, true)

		arg0_61.isToggleShowBg = true
	end

	local var1_61 = arg0_61.shipSkin:IsSpine() or arg0_61.shipSkin:IsLive2d() or arg0_61.shipSkin:IsSpinePlus() or arg0_61.shipSkin:IsLive2dPlus()

	if LOCK_SKIN_SHOP_ANIM_PREVIEW == "all" or LOCK_SKIN_SHOP_ANIM_PREVIEW and table.contains(LOCK_SKIN_SHOP_ANIM_PREVIEW, arg0_61.shipSkin.id) then
		var1_61 = false
	end

	if var1_61 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_61.isToggleDynamic = true
	end

	if var1_61 then
		local var2_61 = 0

		if arg0_61.shipSkin:IsSpine() then
			var2_61 = 6
		elseif arg0_61.shipSkin:IsLive2d() then
			var2_61 = 1
		elseif arg0_61.shipSkin:IsSpinePlus() then
			var2_61 = 7
		elseif arg0_61.shipSkin:IsLive2dPlus() then
			var2_61 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_61) .. "_off", arg0_61.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_61), arg0_61.dynamicToggle:Find("select"))
	end

	if arg0_61.isToggleDynamic and not var1_61 then
		triggerToggle(arg0_61.dynamicToggle, false)

		arg0_61.isToggleDynamic = false
	elseif arg0_61.isToggleDynamic and not arg0_61.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_61.shipSkin:IsLive2d() or arg0_61.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_61.isToggleDynamic = false

			local var3_61 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var3_61, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_61.dynamicToggle, false)
		else
			triggerToggle(arg0_61.dynamicToggle, true)

			arg0_61.isToggleDynamic = true
		end
	end

	if var0_61 then
		onToggle(arg0_61, arg0_61.showBgToggle, function(arg0_62)
			arg0_61.isToggleShowBg = arg0_62

			arg0_61:FlushPainting(arg1_61)
			arg0_61:FlushBG(arg1_61)
		end, SFX_PANEL)
	end

	if arg0_61.shipSkin:IsSpine() or arg0_61.shipSkin:IsLive2d() or arg0_61.shipSkin:IsSpinePlus() or arg0_61.shipSkin:IsLive2dPlus() then
		onToggle(arg0_61, arg0_61.dynamicToggle, function(arg0_63)
			if arg0_63 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_61.shipSkin:IsLive2d() or arg0_61.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_61.dynamicToggle, false)

				return
			end

			arg0_61.isToggleDynamic = arg0_63

			setActive(arg0_61.showBgToggle, not arg0_63 and var0_61)
			arg0_61:FlushPainting(arg1_61)
			arg0_61:FlushDynamicPaintingResState(arg1_61)
			arg0_61:RecordFlag(arg0_63)
		end, SFX_PANEL)
	end

	if arg0_61.isToggleDynamic then
		arg0_61:FlushDynamicPaintingResState(arg1_61)
	end

	setActive(arg0_61.dynamicToggle, var1_61)
	setActive(arg0_61.showBgToggle, not arg0_61.isToggleDynamic and var0_61)
end

function var0_0.FlushTag(arg0_64)
	local var0_64 = arg0_64.skinId
	local var1_64 = pg.ship_skin_template[var0_64]
	local var2_64 = Clone(var1_64.tag)
	local var3_64 = false

	for iter0_64 = #var2_64, 1, -1 do
		local var4_64 = var2_64[iter0_64]

		if var4_64 == 1 or var4_64 == 6 or var4_64 == 7 or var4_64 == 9 then
			local var5_64 = true

			table.remove(var2_64, iter0_64)
		end
	end

	local var6_64 = checkABExist("painting/" .. arg0_64.shipSkin:getConfig("painting") .. "_n")

	arg0_64.tagList:make(function(arg0_65, arg1_65, arg2_65)
		if arg0_65 == UIItemList.EventUpdate then
			local var0_65 = var2_64[arg1_65 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_64[arg1_65 + 1]), function(arg0_66)
				if arg0_64.exited then
					return
				end

				arg2_65:GetComponent(typeof(Image)).sprite = arg0_66
			end)
		end
	end)
	arg0_64.tagList:align(#var2_64)
end

function var0_0.FlushPainting(arg0_67, arg1_67)
	local var0_67 = arg0_67:GetPaintingState(arg1_67)
	local var1_67 = pg.ship_skin_template[arg0_67.skinId].painting
	local var2_67 = ShipSkin.GetChangeSkinData(arg0_67.skinId) and true or false

	if var0_67 == var2_0 and not arg0_67:ExistL2dRes(var1_67) or var0_67 == var3_0 and not arg0_67:ExistSpineRes(var1_67) then
		var0_67 = var1_0
	end

	if arg0_67.paintingState and arg0_67.paintingState.state == var0_67 and arg0_67.paintingState.id == arg1_67.id and arg0_67.paintingState.showBg == arg0_67.isToggleShowBg and arg0_67.paintingState.purchaseFlag == arg1_67.buyCount and not var2_67 then
		return
	end

	arg0_67:ClearPainting()

	if var0_67 == var1_0 then
		arg0_67:LoadMeshPainting(arg1_67, arg0_67.isToggleShowBg)
	elseif var0_67 == var2_0 then
		arg0_67:LoadL2dPainting(arg1_67)
	elseif var0_67 == var3_0 then
		arg0_67:LoadSpinePainting(arg1_67)
	end

	arg0_67.paintingState = {
		state = var0_67,
		id = arg1_67.id,
		showBg = arg0_67.isToggleShowBg,
		purchaseFlag = arg1_67.buyCount
	}

	arg0_67:AdjustPainting(false)
end

function var0_0.ClearPainting(arg0_68)
	local var0_68 = arg0_68.paintingState

	if not var0_68 then
		return
	end

	if var0_68.state == var1_0 then
		arg0_68:ClearMeshPainting()
	elseif var0_68.state == var2_0 then
		arg0_68:ClearL2dPainting()
	elseif var0_68.state == var3_0 then
		arg0_68:ClearSpinePainting()
	end

	arg0_68.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_69, arg1_69, arg2_69)
	local var0_69 = findTF(arg0_69.paintingTF, "fitter")
	local var1_69 = GetOrAddComponent(var0_69, "PaintingScaler")

	var1_69.FrameName = "chuanwu"
	var1_69.Tween = 1

	local var2_69 = pg.ship_skin_template[arg0_69.skinId].painting
	local var3_69 = var2_69

	if not arg2_69 and checkABExist("painting/" .. var2_69 .. "_n") then
		var2_69 = var2_69 .. "_n"
	end

	if not checkABExist("painting/" .. var2_69) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_69, true, function(arg0_70)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_70, var0_69, false)
		ShipExpressionHelper.SetExpression(var0_69:GetChild(0), var3_69)

		arg0_69.paintingName = var2_69

		if arg0_69.paintingState and arg0_69.paintingState.id ~= arg1_69.id then
			arg0_69:ClearMeshPainting()
		end

		local var0_70 = arg0_70.transform:Find("shop_hx")

		arg0_69:CheckShowShopHx(var0_70, arg1_69)
	end)
end

function var0_0.ClearMeshPainting(arg0_71)
	local var0_71 = arg0_71.paintingTF:Find("fitter")

	if arg0_71.paintingName and var0_71.childCount > 0 then
		local var1_71 = var0_71:GetChild(0).gameObject
		local var2_71 = var1_71.transform:Find("shop_hx")

		arg0_71:RevertShopHx(var2_71)
		PoolMgr.GetInstance():ReturnPainting(arg0_71.paintingName, var1_71)
	end

	arg0_71.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_72, arg1_72)
	local var0_72 = arg0_72.skinId
	local var1_72 = pg.ship_skin_template[var0_72].skin_type
	local var2_72

	if var1_72 == ShipSkin.SKIN_TYPE_TB then
		var2_72 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_72))
	else
		local var3_72 = pg.ship_skin_template[var0_72].ship_group
		local var4_72 = ShipGroup.getDefaultShipConfig(var3_72)

		var2_72 = Ship.New({
			noChangeSkin = true,
			configId = var4_72.id,
			skin_id = var0_72
		})
	end

	local var5_72 = Live2D.GenerateData({
		ship = var2_72,
		position = Vector3(0, 0, -1),
		parent = arg0_72.live2dContainer,
		offset = var2_72:GetSkinConfig().shop_offset
	})

	var5_72.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_72.live2dChar = Live2D.New(var5_72, function(arg0_73)
		arg0_73:IgonreReactPos(true)
		arg0_72:CheckShowShopHxForL2d(arg0_73, arg1_72)

		if arg0_72.paintingState and arg0_72.paintingState.id ~= arg1_72.id then
			arg0_72:ClearL2dPainting()
		end

		arg0_73:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_74)
	if arg0_74.live2dChar then
		arg0_74:RevertShopHxForL2d(arg0_74.live2dChar)
		arg0_74.live2dChar:Dispose()

		arg0_74.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_75, arg1_75)
	local var0_75 = arg0_75.skinId
	local var1_75 = pg.ship_skin_template[var0_75].skin_type
	local var2_75

	if var1_75 == ShipSkin.SKIN_TYPE_TB then
		var2_75 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_75))
	else
		local var3_75 = pg.ship_skin_template[var0_75].ship_group
		local var4_75 = ShipGroup.getDefaultShipConfig(var3_75)

		var2_75 = Ship.New({
			noChangeSkin = true,
			configId = var4_75.id,
			skin_id = var0_75
		})
	end

	local var5_75 = SpinePainting.GenerateData({
		ship = var2_75,
		position = Vector3(0, 0, 0),
		parent = arg0_75.spTF,
		effectParent = arg0_75.spBg,
		offset = var2_75:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_75.spinePainting = SpinePainting.New(var5_75, function(arg0_76)
		if arg0_75.paintingState and arg0_75.paintingState.id ~= arg1_75.id then
			arg0_75:ClearSpinePainting()
		end

		local var0_76 = arg0_76._tf:Find("shop_hx")

		arg0_75:CheckShowShopHx(var0_76, arg1_75)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_77)
	if arg0_77.spinePainting and arg0_77.spinePainting._tf then
		local var0_77 = arg0_77.spinePainting._tf:Find("shop_hx")

		arg0_77:RevertShopHx(arg0_77.shopHx)
		arg0_77.spinePainting:Dispose()

		arg0_77.spinePainting = nil
	end
end

function var0_0.CheckShowShopHx(arg0_78, arg1_78, arg2_78)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	if not IsNil(arg1_78) and arg2_78.buyCount <= 0 then
		setActive(arg1_78, true)
	end
end

function var0_0.RevertShopHx(arg0_79, arg1_79)
	if not IsNil(arg1_79) then
		setActive(arg1_79, false)
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_80, arg1_80, arg2_80)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_80 = arg2_80.buyCount <= 0 and 1 or 0

	arg1_80:changeParamaterValue("shop_hx", var0_80)
end

function var0_0.RevertShopHxForL2d(arg0_81, arg1_81)
	arg1_81:changeParamaterValue("shop_hx", 0)
end

function var0_0.AdjustPainting(arg0_82, arg1_82)
	local var0_82 = arg0_82.paintingTF
	local var1_82 = pg.ship_skin_newmainui_shift[arg0_82.skinId]

	if var1_82 then
		local var2_82 = var1_82.skin_shop_shift

		if arg1_82 then
			var0_82.anchoredPosition = Vector2(var2_82[1] - 440, var2_82[2] + arg0_82.defaultPaintingPosition.y)
		else
			var0_82.anchoredPosition = Vector2(var2_82[1] + arg0_82.defaultPaintingPosition.x, var2_82[2] + arg0_82.defaultPaintingPosition.y)
		end

		local var3_82 = var2_82[4]

		var0_82.localScale = Vector3(var3_82, var3_82, 1)
	else
		var0_82.anchoredPosition = Vector2(arg0_82.defaultPaintingPosition.x, arg0_82.defaultPaintingPosition.y)
		var0_82.localScale = arg0_82.defaultPaintingScale
	end
end

function var0_0.FlushBG(arg0_83, arg1_83, arg2_83)
	local var0_83 = arg0_83.skinId
	local var1_83 = pg.ship_skin_template[var0_83]
	local var2_83

	if var1_83.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_83 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_83))
	else
		local var3_83 = ShipGroup.getDefaultShipConfig(var1_83.ship_group)

		var2_83 = Ship.New({
			id = 999,
			configId = var3_83.id,
			skin_id = var0_83
		})
	end

	local var4_83 = var2_83:getShipBgPrint(true)
	local var5_83 = pg.ship_skin_template[var0_83].painting

	if (arg0_83.isToggleShowBg or not checkABExist("painting/" .. var5_83 .. "_n")) and var1_83.bg_sp ~= "" then
		var4_83 = var1_83.bg_sp
	end

	local var6_83 = var4_83 ~= var2_83:rarity2bgPrintForGet()

	if var6_83 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_83, var4_83, arg0_83.bgs:Find("diffBg"), arg0_83.bgs:Find("diffBg/bg"), function(arg0_84)
			if arg2_83 then
				arg2_83()
			end
		end, function(arg0_85)
			if arg2_83 then
				arg2_83()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_83:getUIName())

		if arg2_83 then
			arg2_83()
		end
	end

	setActive(arg0_83.bgs:Find("diffBg"), var6_83)
	setActive(arg0_83.bgs:Find("default"), not var6_83)
end

function var0_0.FlushDynamicPaintingResState(arg0_86, arg1_86)
	if not arg0_86.isToggleDynamic then
		return
	end

	local var0_86 = arg0_86:GetPaintingState(arg1_86)
	local var1_86 = false
	local var2_86 = ""
	local var3_86 = pg.ship_skin_template[arg0_86.skinId].painting

	if var2_0 == var0_86 then
		var1_86, var2_86 = arg0_86:ExistL2dRes(var3_86)
	elseif var3_0 == var0_86 then
		var1_86, var2_86 = arg0_86:ExistSpineRes(var3_86)
	end

	setActive(arg0_86.dynamicResToggle, not var1_86)
	removeOnButton(arg0_86.dynamicResToggle)

	if not var1_86 and var2_86 ~= "" then
		onButton(arg0_86, arg0_86.dynamicResToggle, function()
			arg0_86:DownloadDynamicPainting(var2_86, arg1_86)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_88, arg1_88, arg2_88)
	local var0_88 = arg0_88.skinId

	if arg0_88.downloads[var0_88] then
		return
	end

	local var1_88 = SkinShopDownloadRequest.New()

	arg0_88.downloads[var0_88] = var1_88

	var1_88:Start(arg1_88, function(arg0_89)
		if arg0_89 and arg0_88.paintingState and arg0_88.paintingState.id == arg2_88.id then
			arg0_88:FlushPainting(arg2_88)
			arg0_88:FlushDynamicPaintingResState(arg2_88)
		end

		var1_88:Dispose()

		arg0_88.downloads[var0_88] = nil
	end)
end

function var0_0.GetPaintingState(arg0_90, arg1_90)
	if arg0_90.isToggleDynamic and (arg0_90.shipSkin:IsLive2d() or arg0_90.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_90.isToggleDynamic and (arg0_90.shipSkin:IsSpine() or arg0_90.shipSkin:IsSpinePlus()) then
		if arg0_90.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_91, arg1_91)
	local var0_91 = "live2d/" .. string.lower(arg1_91)
	local var1_91 = HXSet.autoHxShiftPath(var0_91, nil, true)

	return checkABExist(var1_91), var1_91
end

function var0_0.ExistSpineRes(arg0_92, arg1_92)
	local var0_92 = "SpinePainting/" .. string.lower(arg1_92)
	local var1_92 = HXSet.autoHxShiftPath(var0_92, nil, true)

	return checkABExist(var1_92), var1_92
end

function var0_0.RecordFlag(arg0_93, arg1_93)
	local var0_93 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_93, arg1_93 and 1 or 0)
	PlayerPrefs.Save()
	arg0_93:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_93)
end

function var0_0.FlushPrice(arg0_94, arg1_94)
	local var0_94 = arg1_94:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_94 = arg1_94.type == Goods.TYPE_ACTIVITY or arg1_94.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_94 then
		if arg0_94.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_94:UpdateExperiencePrice4Item(arg1_94)
		else
			arg0_94:UpdateExperiencePrice(arg1_94)
		end
	elseif arg0_94.isPreviewFurniture then
		arg0_94:UpdateFurniturePrice(arg1_94)
	elseif var1_94 then
		-- block empty
	else
		arg0_94:UpdateCommodityPrice(arg1_94)
	end

	local var2_94 = arg1_94.type == Goods.TYPE_SKIN

	setActive(arg0_94.price:Find("timeLimit"), var0_94 and not var1_94)
	setActive(arg0_94.price:Find("consume"), var2_94 and not var0_94 and not var1_94)
end

function var0_0.UpdateExperiencePrice4Item(arg0_95, arg1_95)
	local var0_95 = arg1_95:getConfig("resource_num")
	local var1_95 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_95 = _.detect(var1_95, function(arg0_96)
		return arg0_96:CanUseForShop(arg1_95.id)
	end)
	local var3_95 = var2_95 and var2_95.count or 0
	local var4_95 = (var3_95 < var0_95 and "<color=" .. COLOR_RED .. ">" or "") .. var3_95 .. (var3_95 < var0_95 and "</color>" or "")

	setText(arg0_95.price:Find("timeLimit/consume/Text"), var4_95 .. "/" .. var0_95)
end

function var0_0.UpdateExperiencePrice(arg0_97, arg1_97)
	local var0_97 = arg1_97:getConfig("resource_num")
	local var1_97 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_97 = (var1_97 < var0_97 and "<color=" .. COLOR_RED .. ">" or "") .. var1_97 .. (var1_97 < var0_97 and "</color>" or "")

	setText(arg0_97.price:Find("timeLimit/consume/Text"), var2_97 .. "/" .. var0_97)
end

function var0_0.UpdateCommodityPrice(arg0_98, arg1_98)
	local var0_98 = arg1_98:GetPrice()
	local var1_98 = arg1_98:getConfig("resource_num")

	setText(arg0_98.price:Find("consume/Text"), var0_98)
	setText(arg0_98.price:Find("consume/originalprice/Text"), var1_98)
	setActive(arg0_98.price:Find("consume/originalprice"), var0_98 ~= var1_98)
end

function var0_0.UpdateFurniturePrice(arg0_99, arg1_99)
	local var0_99 = Goods.Id2FurnitureId(arg1_99.id)
	local var1_99 = Furniture.New({
		id = var0_99
	})
	local var2_99 = var1_99:getConfig("gem_price")

	setText(arg0_99.price:Find("consume/originalprice/Text"), var2_99)

	local var3_99 = var1_99:getPrice(PlayerConst.ResDiamond)

	setText(arg0_99.price:Find("consume/Text"), var3_99)
	setActive(arg0_99.price:Find("consume/originalprice"), var2_99 ~= var3_99)
end

function var0_0.FlushObtainBtn(arg0_100, arg1_100)
	local var0_100 = arg0_100:GetObtainBtnState(arg1_100)
	local var1_100 = var19_0(var0_100)

	for iter0_100 = 0, arg0_100.btns.childCount - 1 do
		local var2_100 = arg0_100.btns:GetChild(iter0_100)

		setActive(var2_100, var2_100.name == var1_100)
	end

	setActive(arg0_100.price:Find("btn/item"), var0_100 == var11_0)
	setActive(arg0_100.price:Find("btn/tag"), var0_100 == var11_0)

	if var0_100 == var11_0 then
		arg0_100:FlushGift(arg1_100)
	end

	onButton(arg0_100, arg0_100.price:Find("btn"), function()
		local var0_101 = {}

		if SkinCouponActivity.StaticEncoreActTip(arg1_100.id) then
			table.insert(var0_101, function(arg0_102)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("SkinDiscount_Hint"),
					onYes = function()
						local var0_103 = checkExist(SkinCouponActivity.GetSkinCouponEncoreAct(), {
							"id"
						})

						if var0_103 then
							arg0_100:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var0_103)
						end
					end,
					onNo = function()
						arg0_102()
					end
				})
			end)
		end

		seriesAsync(var0_101, function()
			if var0_100 == var5_0 or var0_100 == var7_0 or var0_100 == var11_0 then
				arg0_100.purchaseView:ExecuteAction("Show", arg1_100)
			else
				arg0_100:OnClickBtn(var0_100, arg1_100)
			end
		end)
	end, SFX_PANEL)
end

function var0_0.GetObtainBtnState(arg0_106, arg1_106)
	if arg1_106:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_106.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_106.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_106.type == Goods.TYPE_ACTIVITY or arg1_106.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_106.buyCount > 0 then
		return var4_0
	elseif arg1_106:isDisCount() and arg1_106:IsItemDiscountType() then
		return var7_0
	elseif arg1_106:CanUseVoucherType() or arg1_106:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_106:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushGift(arg0_107, arg1_107)
	local var0_107 = arg1_107:GetGiftList()[1]

	updateDrop(arg0_107.price:Find("btn/item/mask/item"), {
		type = var0_107.type,
		id = var0_107.id,
		count = var0_107.count
	})
end

function var0_0.OnClickBtn(arg0_108, arg1_108, arg2_108)
	if arg1_108 == var5_0 or arg1_108 == var7_0 or arg1_108 == var11_0 then
		arg0_108:OnPurchase(arg2_108)
	elseif arg1_108 == var10_0 then
		arg0_108:OnItemPurchase(arg2_108)
	elseif arg1_108 == var6_0 then
		arg0_108:OnActivity(arg2_108)
	elseif arg1_108 == var8_0 then
		arg0_108:OnBackyard(arg2_108)
	elseif arg1_108 == var9_0 then
		if arg0_108.mode == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_108:OnExperience4Item(arg2_108)
		else
			arg0_108:OnExperience(arg2_108)
		end
	end
end

function var0_0.FlushGifgPackBtn(arg0_109, arg1_109)
	local var0_109 = false
	local var1_109
	local var2_109
	local var3_109

	for iter0_109, iter1_109 in pairs(arg0_109.giftSkinCommodities) do
		for iter2_109, iter3_109 in ipairs(iter1_109) do
			if iter3_109.id == arg1_109.id then
				var0_109 = true

				break
			end
		end

		if var0_109 then
			var1_109 = arg0_109.giftPackCommodities[iter0_109]
			var2_109 = arg0_109.giftSkinCommodities[iter0_109]
			var3_109 = arg0_109.giftSkinProbabilitys[iter0_109]

			break
		end
	end

	setActive(arg0_109.giftPackBtn, var0_109)

	if var0_109 then
		onButton(arg0_109, arg0_109.giftPackBtn, function()
			arg0_109:emit(LatestSkinShopMediator.OPEN_GIFT_PACK_LAYER, var1_109, var2_109, var3_109)
		end, SFX_PANEL)
	end
end

function var0_0.SetGiftPackLayer(arg0_111)
	return
end

function var0_0.OnPurchase(arg0_112, arg1_112)
	if arg1_112.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_112:isDisCount() and arg1_112:IsItemDiscountType() then
		arg0_112:emit(LatestSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_112.id, 1)
	else
		arg0_112:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_112.id, 1)
	end
end

function var0_0.OnItemPurchase(arg0_113, arg1_113)
	if arg1_113.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_113 = arg1_113:GetVoucherIdList()
	local var1_113 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_113.id)

	if #var0_113 <= 0 and #var1_113 <= 0 then
		return
	end

	local var2_113 = {}

	for iter0_113, iter1_113 in ipairs(var0_113) do
		table.insert(var2_113, iter1_113)
	end

	for iter2_113, iter3_113 in ipairs(var1_113) do
		table.insert(var2_113, iter3_113.id)
	end

	local var3_113 = arg0_113.skinId
	local var4_113 = pg.ship_skin_template[var3_113]
	local var5_113 = SwitchSpecialChar(var4_113.name, true)

	arg0_113.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_113,
		skinId = var3_113,
		skinName = var5_113,
		price = arg1_113:GetPrice(),
		onYes = function(arg0_114)
			if arg0_114 then
				arg0_113:emit(LatestSkinShopMediator.ON_ITEM_PURCHASE, arg0_114, arg1_113.id)
			else
				arg0_113:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_113.id, 1)
			end
		end
	})
end

function var0_0.OnActivity(arg0_115, arg1_115)
	local var0_115 = arg1_115:getConfig("time")
	local var1_115 = arg1_115:getConfig("activity")
	local var2_115 = getProxy(ActivityProxy):getActivityById(var1_115)

	if var1_115 == 0 and pg.TimeMgr.GetInstance():inTime(var0_115) or var2_115 and not var2_115:isEnd() then
		if arg1_115.type == Goods.TYPE_ACTIVITY then
			arg0_115:emit(LatestSkinShopMediator.GO_SHOPS_LAYER, arg1_115:getConfig("activity"))
		elseif arg1_115.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_115 = arg1_115:getConfig("scene")

			if var3_115 and #var3_115 > 0 then
				arg0_115:emit(LatestSkinShopMediator.OPEN_SCENE, var3_115)
			else
				arg0_115:emit(LatestSkinShopMediator.OPEN_ACTIVITY, var1_115)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_116, arg1_116)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_116 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_116.name, var0_116.level))

		return
	end

	arg0_116:emit(LatestSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_117, arg1_117)
	local var0_117 = arg0_117.skinId
	local var1_117 = getProxy(ShipSkinProxy):getSkinById(var0_117)

	if var1_117 and not var1_117:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_117 = arg1_117:getConfig("resource_num")
	local var3_117 = arg1_117:getConfig("time_second") * var2_117
	local var4_117, var5_117, var6_117, var7_117 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_117)
	local var8_117 = pg.ship_skin_template[arg0_117.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_117, var8_117, var4_117, var5_117),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_117 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_117:emit(LatestSkinShopMediator.ON_SHOPPING, arg1_117.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_119, arg1_119)
	local var0_119 = arg0_119.skinId
	local var1_119 = getProxy(ShipSkinProxy):getSkinById(var0_119)

	if var1_119 and not var1_119:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_119 = arg1_119:getConfig("resource_num")
	local var3_119 = arg1_119:getConfig("time_second") * var2_119
	local var4_119, var5_119, var6_119, var7_119 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_119)
	local var8_119 = pg.ship_skin_template[arg0_119.skinId].name
	local var9_119 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_119 = _.detect(var9_119, function(arg0_120)
		return arg0_120:CanUseForShop(arg1_119.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_119, var8_119, var4_119, var5_119),
		onYes = function()
			if not var10_119 or var10_119.count < var2_119 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_119:emit(LatestSkinShopMediator.ON_ITEM_EXPERIENCE, var10_119.id, arg1_119.id, 1)
		end
	})
end

function var0_0.SetFilterPanel(arg0_122)
	local var0_122 = arg0_122.filterContent:Find("own/options")
	local var1_122 = arg0_122.filterContent:Find("type/options")
	local var2_122 = arg0_122.filterContent:Find("shipHave/options")
	local var3_122 = arg0_122.filterContent:Find("camp/options")
	local var4_122 = arg0_122.filterContent:Find("rarity/options")
	local var5_122 = arg0_122.filterContent:Find("shipType/options")
	local var6_122 = arg0_122.filterContent:Find("themeType/options")

	arg0_122:SetOptionList(var3_122, ShipIndexConst.CampNames, true)
	arg0_122:SetOptionList(var4_122, ShipIndexConst.RarityNames, true)
	arg0_122:SetOptionList(var5_122, ShipIndexConst.TypeNames, true)
	arg0_122:SetOptionList(var6_122, arg0_122.classifyNames)
	arg0_122:SetSingleOptions(var0_122, "ownType")
	arg0_122:SetMultiOptions(var1_122, "typeType")
	arg0_122:SetSingleOptions(var2_122, "shipHaveType")
	arg0_122:SetMultiOptions(var3_122, "campType")
	arg0_122:SetMultiOptions(var4_122, "rarityType")
	arg0_122:SetMultiOptions(var5_122, "shipType")
	arg0_122:SetMultiOptions(var6_122, "themeType")
	onButton(arg0_122, arg0_122.filterUI:Find("bg"), function()
		for iter0_123, iter1_123 in pairs(arg0_122.filterValues) do
			arg0_122.filterValuesTemp[iter0_123] = Clone(arg0_122.filterValues[iter0_123])
		end

		setActive(arg0_122.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_122, arg0_122.filterUI:Find("panel/closeBtn"), function()
		for iter0_124, iter1_124 in pairs(arg0_122.filterValues) do
			arg0_122.filterValuesTemp[iter0_124] = Clone(arg0_122.filterValues[iter0_124])
		end

		setActive(arg0_122.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_122, arg0_122.filterUI:Find("panel/bottom/ok"), function()
		for iter0_125, iter1_125 in pairs(arg0_122.filterValues) do
			arg0_122.filterValues[iter0_125] = Clone(arg0_122.filterValuesTemp[iter0_125])
		end

		setActive(arg0_122.filterUI, false)
		arg0_122:Refresh(true)
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_126)
	setActive(arg0_126.filterUI, true)

	local var0_126 = arg0_126.filterContent:Find("own/options")
	local var1_126 = arg0_126.filterContent:Find("type/options")
	local var2_126 = arg0_126.filterContent:Find("shipHave/options")
	local var3_126 = arg0_126.filterContent:Find("camp/options")
	local var4_126 = arg0_126.filterContent:Find("rarity/options")
	local var5_126 = arg0_126.filterContent:Find("shipType/options")
	local var6_126 = arg0_126.filterContent:Find("themeType/options")

	arg0_126:SetSingleOptions(var0_126, "ownType", true)
	arg0_126:SetMultiOptions(var1_126, "typeType", true)
	arg0_126:SetSingleOptions(var2_126, "shipHaveType", true)
	arg0_126:SetMultiOptions(var3_126, "campType", true)
	arg0_126:SetMultiOptions(var4_126, "rarityType", true)
	arg0_126:SetMultiOptions(var5_126, "shipType", true)
	arg0_126:SetMultiOptions(var6_126, "themeType", true)
end

function var0_0.SetOptionList(arg0_127, arg1_127, arg2_127, arg3_127)
	local var0_127 = UIItemList.New(arg1_127, arg1_127:GetChild(0))

	var0_127:make(function(arg0_128, arg1_128, arg2_128)
		if arg0_128 == UIItemList.EventUpdate then
			local var0_128 = arg2_127[arg1_128 + 1]

			if arg3_127 then
				var0_128 = i18n(var0_128)
			end

			arg2_128.name = arg1_128

			setText(arg2_128:Find("Text"), var0_128)
		end
	end)
	var0_127:align(#arg2_127)
end

function var0_0.SetSingleOptions(arg0_129, arg1_129, arg2_129, arg3_129)
	for iter0_129 = 0, arg1_129.childCount - 1 do
		local var0_129 = arg1_129:GetChild(iter0_129)

		arg0_129:SetOptionSelect(arg1_129:GetChild(iter0_129), iter0_129 == arg0_129.filterValuesTemp[arg2_129])

		if not arg3_129 then
			onButton(arg0_129, var0_129, function()
				arg0_129.filterValuesTemp[arg2_129] = iter0_129

				for iter0_130 = 0, arg1_129.childCount - 1 do
					arg0_129:SetOptionSelect(arg1_129:GetChild(iter0_130), iter0_130 == iter0_129)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_131, arg1_131, arg2_131, arg3_131)
	for iter0_131 = 0, arg1_131.childCount - 1 do
		local var0_131 = arg1_131:GetChild(iter0_131)

		arg0_131:SetOptionSelect(arg1_131:GetChild(iter0_131), table.contains(arg0_131.filterValuesTemp[arg2_131], iter0_131))

		if not arg3_131 then
			onButton(arg0_131, var0_131, function()
				if iter0_131 == 0 then
					arg0_131.filterValuesTemp[arg2_131] = {
						0
					}

					for iter0_132 = 0, arg1_131.childCount - 1 do
						arg0_131:SetOptionSelect(arg1_131:GetChild(iter0_132), iter0_132 == 0)
					end
				else
					table.removebyvalue(arg0_131.filterValuesTemp[arg2_131], 0)

					if table.contains(arg0_131.filterValuesTemp[arg2_131], iter0_131) then
						table.removebyvalue(arg0_131.filterValuesTemp[arg2_131], iter0_131)
					else
						table.insert(arg0_131.filterValuesTemp[arg2_131], iter0_131)
					end

					local var0_132 = true

					for iter1_132 = 1, arg1_131.childCount - 1 do
						if not table.contains(arg0_131.filterValuesTemp[arg2_131], iter1_132) then
							var0_132 = false

							break
						end
					end

					if #arg0_131.filterValuesTemp[arg2_131] == 0 then
						var0_132 = true
					end

					if var0_132 then
						arg0_131.filterValuesTemp[arg2_131] = {
							0
						}
					end

					for iter2_132 = 0, arg1_131.childCount - 1 do
						arg0_131:SetOptionSelect(arg1_131:GetChild(iter2_132), table.contains(arg0_131.filterValuesTemp[arg2_131], iter2_132))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_133, arg1_133, arg2_133)
	setActive(arg1_133:Find("selectedFrame"), arg2_133)

	local var0_133 = arg1_133:Find("Text"):GetComponent(typeof(Text))

	if arg2_133 then
		var0_133.color = Color.New(1, 1, 1, 1)
	else
		var0_133.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.GetSkinClassify(arg0_134)
	arg0_134.classifyIds = {}
	arg0_134.classifyNames = {}

	local var0_134 = {}
	local var1_134 = {}

	for iter0_134, iter1_134 in ipairs(arg0_134.commodities) do
		local var2_134 = arg0_134:GetShopTypeIdBySkinId(iter1_134:getSkinId())
		local var3_134 = var2_134 == 0 and var16_0 or var2_134

		var1_134[var3_134] = (var1_134[var3_134] or 0) + 1
	end

	local var4_134 = {}

	for iter2_134, iter3_134 in ipairs(arg0_134.returnSkins) do
		var4_134[iter3_134] = true
	end

	if underscore.any(arg0_134.commodities, function(arg0_135)
		return var4_134[arg0_135.id]
	end) then
		table.insert(var0_134, var14_0)
	end

	for iter4_134, iter5_134 in ipairs(pg.skin_page_template.all) do
		if iter5_134 ~= var17_0 and iter5_134 ~= var18_0 and (var1_134[iter5_134] or 0) > 0 then
			table.insert(var0_134, iter5_134)
		end
	end

	if arg0_134.mode == var0_0.MODE_EXPERIENCE then
		table.insert(var0_134, 1, var13_0)
	end

	if arg0_134.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_134, 1, var15_0)
	end

	table.insert(var0_134, 1, var12_0)

	arg0_134.classifyIds = var0_134

	for iter6_134, iter7_134 in ipairs(arg0_134.classifyIds) do
		if iter7_134 == var12_0 then
			table.insert(arg0_134.classifyNames, "全部")
		elseif iter7_134 == var13_0 or iter7_134 == var15_0 then
			table.insert(arg0_134.classifyNames, "体验")
		elseif iter7_134 == var14_0 then
			table.insert(arg0_134.classifyNames, "返场")
		else
			table.insert(arg0_134.classifyNames, pg.skin_page_template[iter7_134].name)
		end
	end
end

function var0_0.GetShopTypeIdBySkinId(arg0_136, arg1_136)
	local var0_136 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_136.shopTypeIdList then
		arg0_136.shopTypeIdList = {}
	end

	if arg0_136.shopTypeIdList[arg1_136] then
		return arg0_136.shopTypeIdList[arg1_136]
	end

	for iter0_136, iter1_136 in pairs(var0_136) do
		for iter2_136, iter3_136 in ipairs(iter1_136) do
			arg0_136.shopTypeIdList[iter3_136] = iter0_136

			if iter3_136 == arg1_136 then
				return iter0_136
			end
		end
	end
end

function var0_0.OnShopping(arg0_137, arg1_137)
	if not arg0_137.showingCommodity then
		return
	end

	if arg0_137.purchaseView and arg0_137.purchaseView:GetLoaded() then
		arg0_137.purchaseView:Hide()
	end

	if arg0_137.showingCommodity.id == arg1_137 then
		arg0_137:GetAllCommodities()
		arg0_137:Refresh(true)
	end
end

function var0_0.OnFurnitureUpdate(arg0_138, arg1_138)
	if not arg0_138.showingCommodity then
		return
	end

	local var0_138 = arg0_138.showingCommodity.id

	if Goods.ExistFurniture(var0_138) and Goods.Id2FurnitureId(var0_138) == arg1_138 then
		arg0_138:GetAllCommodities()
		arg0_138:Refresh(true)
	end
end

function var0_0.willExit(arg0_139)
	arg0_139:ClearCards()
	ClearLScrollrect(arg0_139.scrollrect)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_139:getUIName())

	if arg0_139.live2dChar then
		arg0_139.live2dChar:Dispose()

		arg0_139.live2dChar = nil
	end

	if arg0_139.voucherMsgBox then
		arg0_139.voucherMsgBox:Destroy()

		arg0_139.voucherMsgBox = nil
	end

	if arg0_139.purchaseView then
		arg0_139.purchaseView:Destroy()

		arg0_139.purchaseView = nil
	end

	for iter0_139, iter1_139 in pairs(arg0_139.downloads) do
		iter1_139:Dispose()
	end

	arg0_139.downloads = {}

	arg0_139:ClearPainting()

	if arg0_139.interactionPreview then
		arg0_139.interactionPreview:Dispose()

		arg0_139.interactionPreview = nil
	end

	arg0_139:disposeEvent()
	arg0_139:ClearTimer()
	arg0_139:ReturnChar()
	arg0_139:UnOverlay()
end

function var0_0.onBackPressed(arg0_140)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
