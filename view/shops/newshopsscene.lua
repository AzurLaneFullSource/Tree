local var0_0 = class("NewShopsScene", import("..base.BaseUI"))

var0_0.CATEGORY_ACTIVITY = 1
var0_0.CATEGORY_MONTH = 2
var0_0.CATEGORY_SUPPLY = 3
var0_0.TYPE_ACTIVITY = 1
var0_0.TYPE_SHOP_STREET = 2
var0_0.TYPE_MILITARY_SHOP = 3
var0_0.TYPE_QUOTA = 4
var0_0.TYPE_SHAM_SHOP = 5
var0_0.TYPE_FRAGMENT = 6
var0_0.TYPE_GUILD = 7
var0_0.TYPE_MEDAL = 8
var0_0.TYPE_META = 9
var0_0.TYPE_MINI_GAME = 10
var0_0.CATEGORY2NAME = {
	[var0_0.CATEGORY_ACTIVITY] = "activity",
	[var0_0.CATEGORY_MONTH] = "month",
	[var0_0.CATEGORY_SUPPLY] = "supply"
}
var0_0.TYPE2NAME = {
	[var0_0.TYPE_ACTIVITY] = i18n("activity_shop_title"),
	[var0_0.TYPE_SHOP_STREET] = i18n("street_shop_title"),
	[var0_0.TYPE_MILITARY_SHOP] = i18n("military_shop_title"),
	[var0_0.TYPE_QUOTA] = i18n("quota_shop_title1"),
	[var0_0.TYPE_SHAM_SHOP] = i18n("sham_shop_title"),
	[var0_0.TYPE_FRAGMENT] = i18n("fragment_shop_title"),
	[var0_0.TYPE_GUILD] = i18n("guild_shop_title"),
	[var0_0.TYPE_MEDAL] = i18n("medal_shop_title"),
	[var0_0.TYPE_META] = i18n("meta_shop_title"),
	[var0_0.TYPE_MINI_GAME] = i18n("mini_game_shop_title")
}

local var1_0 = {
	[var0_0.CATEGORY_ACTIVITY] = {
		var0_0.TYPE_ACTIVITY
	},
	[var0_0.CATEGORY_MONTH] = {
		var0_0.TYPE_QUOTA,
		var0_0.TYPE_SHAM_SHOP,
		var0_0.TYPE_MEDAL,
		var0_0.TYPE_FRAGMENT
	},
	[var0_0.CATEGORY_SUPPLY] = {
		var0_0.TYPE_SHOP_STREET,
		var0_0.TYPE_MILITARY_SHOP,
		var0_0.TYPE_GUILD,
		var0_0.TYPE_META,
		var0_0.TYPE_MINI_GAME
	}
}
local var2_0 = {
	"activity",
	"shopstreet",
	"supplies",
	"quota",
	"sham",
	"fragment",
	"guild",
	"medal",
	"meta",
	"minigame"
}

function var0_0.getUIName(arg0_1)
	return "NewShopsUI"
end

function var0_0.SetPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2

	if arg0_2.page then
		arg0_2.page:SetPlayer(arg1_2)
	end
end

function var0_0.SetShops(arg0_3, arg1_3)
	arg0_3.shops = arg1_3

	arg0_3:SortActivityShops()
end

function var0_0.SortActivityShops(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.shops) do
		if iter0_4 == var0_0.TYPE_ACTIVITY then
			table.sort(iter1_4, function(arg0_5, arg1_5)
				return arg0_5:getStartTime() > arg1_5:getStartTime()
			end)
		end
	end
end

function var0_0.SetShop(arg0_6, arg1_6, arg2_6)
	if not arg0_6.shops then
		return
	end

	local var0_6 = arg0_6.shops[arg1_6]

	if var0_6 then
		for iter0_6, iter1_6 in ipairs(var0_6) do
			if iter1_6:IsSameKind(arg2_6) then
				arg0_6.shops[arg1_6][iter0_6] = arg2_6

				break
			end
		end
	end
end

function var0_0.OnUpdateItems(arg0_7, arg1_7)
	arg0_7.items = arg1_7

	if arg0_7.page then
		arg0_7.page:SetItems(arg1_7)
	end
end

function var0_0.OnUpdateShop(arg0_8, arg1_8, arg2_8)
	arg0_8:SetShop(arg1_8, arg2_8)

	local var0_8 = arg0_8.pages[arg1_8]

	if arg0_8.page == var0_8 then
		arg0_8.page:ExecuteAction("UpdateShop", arg2_8)
	end
end

function var0_0.OnUpdateCommodity(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9:SetShop(arg1_9, arg2_9)

	local var0_9 = arg0_9.pages[arg1_9]

	if arg0_9.page == var0_9 then
		arg0_9.page:ExecuteAction("UpdateCommodity", arg2_9, arg3_9)
	end
end

function var0_0.init(arg0_10)
	arg0_10.backBtn = arg0_10:findTF("blur_panel/adapt/top/back_button")
	arg0_10.frame = arg0_10:findTF("blur_panel")
	arg0_10.pageContainer = arg0_10:findTF("frame/bg/pages")
	arg0_10.stamp = arg0_10:findTF("stamp")
	arg0_10.switchBtn = arg0_10:findTF("blur_panel/adapt/switch_btn")
	arg0_10.skinBtn = arg0_10:findTF("blur_panel/adapt/skin_btn")

	local var0_10 = arg0_10:findTF("frame/bg/pages/scrollrect"):GetComponent("LScrollRect")

	arg0_10.pages = {
		[var0_0.TYPE_ACTIVITY] = ActivityShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_SHOP_STREET] = StreetShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_MILITARY_SHOP] = MilitaryShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_GUILD] = GuildShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_SHAM_SHOP] = ShamShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_FRAGMENT] = FragmentShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_META] = MetaShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_MEDAL] = MedalShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_QUOTA] = QuotaShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10),
		[var0_0.TYPE_MINI_GAME] = MiniGameShopPage.New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData, var0_10)
	}
	arg0_10.contextData.singleWindow = ShopSingleWindow.New(arg0_10._tf, arg0_10.event)
	arg0_10.contextData.multiWindow = ShopMultiWindow.New(arg0_10._tf, arg0_10.event)
	arg0_10.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_10._tf, arg0_10.event)
	arg0_10.contextData.paintingView = ShopPaintingView.New(arg0_10:findTF("paint/paint"), arg0_10:findTF("frame/chat"))

	arg0_10.contextData.paintingView:setSecretaryPos(arg0_10:findTF("paint/secretaryPos"))

	arg0_10.contextData.bgView = ShopBgView.New(arg0_10:findTF("bg"))
	arg0_10.recorder = {
		[var0_0.CATEGORY_ACTIVITY] = false,
		[var0_0.CATEGORY_MONTH] = false,
		[var0_0.CATEGORY_SUPPLY] = false
	}
	arg0_10.frameTr = arg0_10:findTF("frame")
	arg0_10.categoryUIList = UIItemList.New(arg0_10:findTF("frame/bg/types"), arg0_10:findTF("frame/bg/types/tpl"))
	arg0_10.shopUIList = UIItemList.New(arg0_10:findTF("frame/bg/shops"), arg0_10:findTF("frame/bg/shops/tpl"))
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:closeView()
	end, SFX_CANCEL)
	setActive(arg0_11.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_11.stamp, false)
	end

	onButton(arg0_11, arg0_11.stamp, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	onButton(arg0_11, arg0_11.switchBtn, function()
		local var0_14 = ChargeScene.TYPE_DIAMOND

		if arg0_11.contextData ~= nil and arg0_11.contextData.chargePage ~= nil then
			var0_14 = arg0_11.contextData.chargePage
		end

		arg0_11:emit(NewShopsMediator.GO_MALL, var0_14)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.skinBtn, function()
		arg0_11:emit(NewShopsMediator.ON_SKIN_SHOP)
	end, SFX_PANEL)
	arg0_11:InitEntrances()
	arg0_11:BlurView()

	arg0_11.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_11, arg0_11.pageContainer, Vector2.New(-35, -90))
end

function var0_0.InitEntrances(arg0_16)
	arg0_16:InitCategory()
	arg0_16:ActiveDefaultCategory()

	arg0_16.shopType = nil
	arg0_16.shopIndex = nil
end

function var0_0.InitCategory(arg0_17)
	arg0_17.categoryTrs = {}

	local var0_17 = {
		var0_0.CATEGORY_MONTH,
		var0_0.CATEGORY_SUPPLY
	}

	if #(arg0_17.shops[var0_0.TYPE_ACTIVITY] or {}) > 0 then
		table.insert(var0_17, var0_0.CATEGORY_ACTIVITY)
	end

	arg0_17.categoryUIList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var0_17[arg1_18 + 1]

			arg0_17:UpdateCategory(arg2_18, var0_18, false)

			arg0_17.categoryTrs[var0_18] = arg2_18
		end
	end)
	arg0_17.categoryUIList:align(#var0_17)
end

local function var3_0(arg0_19, arg1_19)
	local var0_19 = var0_0.CATEGORY2NAME[arg1_19]
	local var1_19 = arg0_19:Find("lock")
	local var2_19 = arg0_19:Find("label")
	local var3_19 = arg0_19:Find("selected/selected")
	local var4_19 = var1_19:GetComponent(typeof(Image))

	var4_19.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0_19 .. "_lock")

	var4_19:SetNativeSize()

	local var5_19 = var2_19:GetComponent(typeof(Image))

	var5_19.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0_19)

	var5_19:SetNativeSize()

	local var6_19 = var2_19:Find("en"):GetComponent(typeof(Image))

	var6_19.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0_19 .. "_label")

	var6_19:SetNativeSize()

	local var7_19 = var3_19:GetComponent(typeof(Image))

	var7_19.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0_19 .. "_selected")

	var7_19:SetNativeSize()

	local var8_19 = var3_19.parent:Find("en"):GetComponent(typeof(Image))

	var8_19.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0_19 .. "_label_selected")

	var8_19:SetNativeSize()
end

function var0_0.UpdateCategory(arg0_20, arg1_20, arg2_20, arg3_20)
	setActive(arg1_20:Find("lock"), arg3_20)
	setActive(arg1_20:Find("label"), not arg3_20)
	setActive(arg1_20:Find("selected"), false)
	var3_0(arg1_20, arg2_20)
	onToggle(arg0_20, arg1_20, function(arg0_21)
		if arg0_21 then
			arg0_20:InitShops(arg2_20)

			arg0_20.category = arg2_20

			arg0_20:ActiveDefaultShop()
		end

		setActive(arg1_20:Find("label"), not arg3_20 and not arg0_21)
		setActive(arg1_20:Find("selected"), not arg3_20 and arg0_21)
	end, SFX_PANEL)
	setToggleEnabled(arg1_20, not arg3_20)
end

function var0_0.InitShops(arg0_22, arg1_22)
	if arg0_22.category and arg0_22.category == arg1_22 then
		return
	end

	local var0_22 = var1_0[arg1_22]
	local var1_22 = {}

	arg0_22.displayShops = {}
	arg0_22.prevBtn = nil

	for iter0_22, iter1_22 in pairs(var0_22) do
		for iter2_22, iter3_22 in ipairs(arg0_22.shops[iter1_22] or {}) do
			table.insert(var1_22, {
				type = iter1_22,
				index = iter2_22
			})
		end
	end

	arg0_22.shopUIList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = var1_22[arg1_23 + 1]

			arg0_22:UpdateShop(arg2_23, var0_23)

			if not arg0_22.displayShops[var0_23.type] then
				arg0_22.displayShops[var0_23.type] = {}
			end

			arg0_22.displayShops[var0_23.type][var0_23.index] = arg2_23
		end
	end)
	arg0_22.shopUIList:align(#var1_22)
end

local function var4_0(arg0_24, arg1_24)
	local var0_24 = var0_0.TYPE2NAME[arg1_24.type]

	setText(arg0_24:Find("selected/Text"), var0_24)
	setText(arg0_24:Find("label"), var0_24)
end

local function var5_0(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg1_25:Find("label")
	local var1_25 = arg1_25:Find("selected")

	onButton(arg0_25, arg1_25, function()
		if arg0_25.prevBtn == arg1_25 then
			return
		end

		if arg2_25() then
			if arg0_25.prevBtn then
				setActive(arg0_25.prevBtn:Find("label"), true)
				setActive(arg0_25.prevBtn:Find("selected"), false)
			end

			setActive(var0_25, false)
			setActive(var1_25, true)

			arg0_25.prevBtn = arg1_25
		end
	end, SFX_PANEL)
	setActive(var0_25, true)
	setActive(var1_25, false)
end

function var0_0.UpdateShop(arg0_27, arg1_27, arg2_27)
	var4_0(arg1_27, arg2_27)

	local var0_27 = arg1_27:Find("selected")
	local var1_27 = arg1_27:Find("label")

	var5_0(arg0_27, arg1_27, function()
		local var0_28 = arg0_27.shops[arg2_27.type][arg2_27.index]
		local var1_28 = arg0_27.pages[arg2_27.type]
		local var2_28, var3_28 = var1_28:CanOpen(var0_28, arg0_27.player)

		if var2_28 then
			if arg0_27.page and not arg0_27.page:GetLoaded() then
				return
			end

			if arg0_27.page then
				arg0_27.page:Hide()
			end

			arg0_27.contextData.bgView:Init(var1_28:GetBg(var0_28))
			var1_28:ExecuteAction("SetUp", var0_28, arg0_27.player, arg0_27.items)

			arg0_27.page = var1_28
			arg0_27.contextData.activeShop = arg2_27.type
			arg0_27.recorder[arg0_27.category] = arg2_27

			return true
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_28)
		end

		return false
	end)
end

function var0_0.ActiveDefaultCategory(arg0_29)
	local var0_29 = arg0_29.contextData.warp or arg0_29.contextData.activeShop or var0_0.TYPE_ACTIVITY

	if type(var0_29) == "string" then
		local var1_29 = table.indexof(var2_0, var0_29)

		var0_29 = defaultValue(var1_29, var0_0.TYPE_ACTIVITY)
	end

	local var2_29 = arg0_29.contextData.index or 1

	if var0_29 == var0_0.TYPE_ACTIVITY and arg0_29.contextData.actId then
		for iter0_29, iter1_29 in ipairs(arg0_29.shops[var0_29] or {}) do
			if iter1_29.activityId == arg0_29.contextData.actId then
				var2_29 = iter0_29

				break
			end
		end
	elseif var0_29 == var0_0.TYPE_ACTIVITY and (not arg0_29.shops[var0_0.TYPE_ACTIVITY] or #(arg0_29.shops[var0_0.TYPE_ACTIVITY] or {}) <= 0) then
		var0_29 = var0_0.TYPE_SHOP_STREET
		var2_29 = 1
	end

	local var3_29

	for iter2_29, iter3_29 in pairs(var1_0) do
		if table.contains(iter3_29, var0_29) then
			var3_29 = iter2_29

			break
		end
	end

	assert(var3_29 and arg0_29.categoryTrs[var3_29])

	arg0_29.shopType = var0_29
	arg0_29.shopIndex = var2_29

	triggerToggle(arg0_29.categoryTrs[var3_29], true)
end

function var0_0.ActiveDefaultShop(arg0_30)
	local var0_30
	local var1_30

	if arg0_30.recorder[arg0_30.category] then
		local var2_30 = arg0_30.recorder[arg0_30.category]

		var0_30, var1_30 = var2_30.type, var2_30.index
	else
		var0_30, var1_30 = arg0_30.shopType, arg0_30.shopIndex or 1
	end

	local function var3_30()
		local var0_31

		for iter0_31, iter1_31 in pairs(arg0_30.displayShops) do
			for iter2_31, iter3_31 in pairs(iter1_31) do
				if arg0_30.pages[iter0_31]:CanOpen(nil, arg0_30.player) then
					var0_31 = var0_31 or iter3_31
				end
			end
		end

		if var0_31 then
			triggerButton(var0_31)
		end
	end

	if not var0_30 then
		var3_30()

		return
	end

	local var4_30, var5_30 = arg0_30.pages[var0_30]:CanOpen(nil, arg0_30.player)

	if var4_30 and arg0_30.displayShops[var0_30] and arg0_30.displayShops[var0_30][var1_30] then
		triggerButton(arg0_30.displayShops[var0_30][var1_30])
	else
		if not var4_30 then
			pg.TipsMgr.GetInstance():ShowTips(var5_30)
		end

		var3_30()
	end
end

function var0_0.onBackPressed(arg0_32)
	if arg0_32.contextData.singleWindow:GetLoaded() and arg0_32.contextData.singleWindow:isShowing() then
		arg0_32.contextData.singleWindow:Close()

		return
	end

	if arg0_32.contextData.multiWindow:GetLoaded() and arg0_32.contextData.multiWindow:isShowing() then
		arg0_32.contextData.multiWindow:Close()

		return
	end

	if arg0_32.contextData.singleWindowForESkin:GetLoaded() and arg0_32.contextData.singleWindowForESkin:isShowing() then
		arg0_32.contextData.singleWindowForESkin:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_32)
end

function var0_0.BlurView(arg0_33)
	local var0_33 = arg0_33.frameTr:Find("bg/blur")

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_33.frameTr, {
		pbList = {
			arg0_33.frameTr:Find("bg"),
			var0_33
		}
	})
	var0_33:SetAsFirstSibling()
end

function var0_0.UnBlurView(arg0_34)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_34.frameTr, arg0_34._tf)
end

function var0_0.willExit(arg0_35)
	if arg0_35.bulinTip then
		arg0_35.bulinTip:Destroy()

		arg0_35.bulinTip = nil
	end

	for iter0_35, iter1_35 in pairs(arg0_35.pages) do
		iter1_35:Destroy()
	end

	arg0_35:UnBlurView()
	arg0_35.contextData.singleWindow:Destroy()
	arg0_35.contextData.multiWindow:Destroy()
	arg0_35.contextData.singleWindowForESkin:Destroy()
	arg0_35.contextData.paintingView:Dispose()
	arg0_35.contextData.bgView:Dispose()

	arg0_35.contextData.singleWindow = nil
	arg0_35.contextData.multiWindow = nil
	arg0_35.contextData.singleWindowForESkin = nil
	arg0_35.contextData.paintingView = nil
	arg0_35.contextData.bgView = nil
	arg0_35.pages = nil
	arg0_35.bulinTip = nil
end

return var0_0
