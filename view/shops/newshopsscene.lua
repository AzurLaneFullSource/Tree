local var0 = class("NewShopsScene", import("..base.BaseUI"))

var0.CATEGORY_ACTIVITY = 1
var0.CATEGORY_MONTH = 2
var0.CATEGORY_SUPPLY = 3
var0.TYPE_ACTIVITY = 1
var0.TYPE_SHOP_STREET = 2
var0.TYPE_MILITARY_SHOP = 3
var0.TYPE_QUOTA = 4
var0.TYPE_SHAM_SHOP = 5
var0.TYPE_FRAGMENT = 6
var0.TYPE_GUILD = 7
var0.TYPE_MEDAL = 8
var0.TYPE_META = 9
var0.TYPE_MINI_GAME = 10
var0.CATEGORY2NAME = {
	[var0.CATEGORY_ACTIVITY] = "activity",
	[var0.CATEGORY_MONTH] = "month",
	[var0.CATEGORY_SUPPLY] = "supply"
}
var0.TYPE2NAME = {
	[var0.TYPE_ACTIVITY] = i18n("activity_shop_title"),
	[var0.TYPE_SHOP_STREET] = i18n("street_shop_title"),
	[var0.TYPE_MILITARY_SHOP] = i18n("military_shop_title"),
	[var0.TYPE_QUOTA] = i18n("quota_shop_title1"),
	[var0.TYPE_SHAM_SHOP] = i18n("sham_shop_title"),
	[var0.TYPE_FRAGMENT] = i18n("fragment_shop_title"),
	[var0.TYPE_GUILD] = i18n("guild_shop_title"),
	[var0.TYPE_MEDAL] = i18n("medal_shop_title"),
	[var0.TYPE_META] = i18n("meta_shop_title"),
	[var0.TYPE_MINI_GAME] = i18n("mini_game_shop_title")
}

local var1 = {
	[var0.CATEGORY_ACTIVITY] = {
		var0.TYPE_ACTIVITY
	},
	[var0.CATEGORY_MONTH] = {
		var0.TYPE_QUOTA,
		var0.TYPE_SHAM_SHOP,
		var0.TYPE_MEDAL,
		var0.TYPE_FRAGMENT
	},
	[var0.CATEGORY_SUPPLY] = {
		var0.TYPE_SHOP_STREET,
		var0.TYPE_MILITARY_SHOP,
		var0.TYPE_GUILD,
		var0.TYPE_META,
		var0.TYPE_MINI_GAME
	}
}
local var2 = {
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

function var0.getUIName(arg0)
	return "NewShopsUI"
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1

	if arg0.page then
		arg0.page:SetPlayer(arg1)
	end
end

function var0.SetShops(arg0, arg1)
	arg0.shops = arg1

	arg0:SortActivityShops()
end

function var0.SortActivityShops(arg0)
	for iter0, iter1 in pairs(arg0.shops) do
		if iter0 == var0.TYPE_ACTIVITY then
			table.sort(iter1, function(arg0, arg1)
				return arg0:getStartTime() > arg1:getStartTime()
			end)
		end
	end
end

function var0.SetShop(arg0, arg1, arg2)
	if not arg0.shops then
		return
	end

	local var0 = arg0.shops[arg1]

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			if iter1:IsSameKind(arg2) then
				arg0.shops[arg1][iter0] = arg2

				break
			end
		end
	end
end

function var0.OnUpdateItems(arg0, arg1)
	arg0.items = arg1

	if arg0.page then
		arg0.page:SetItems(arg1)
	end
end

function var0.OnUpdateShop(arg0, arg1, arg2)
	arg0:SetShop(arg1, arg2)

	local var0 = arg0.pages[arg1]

	if arg0.page == var0 then
		arg0.page:ExecuteAction("UpdateShop", arg2)
	end
end

function var0.OnUpdateCommodity(arg0, arg1, arg2, arg3)
	arg0:SetShop(arg1, arg2)

	local var0 = arg0.pages[arg1]

	if arg0.page == var0 then
		arg0.page:ExecuteAction("UpdateCommodity", arg2, arg3)
	end
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_button")
	arg0.frame = arg0:findTF("blur_panel")
	arg0.pageContainer = arg0:findTF("frame/bg/pages")
	arg0.stamp = arg0:findTF("stamp")
	arg0.switchBtn = arg0:findTF("blur_panel/adapt/switch_btn")
	arg0.skinBtn = arg0:findTF("blur_panel/adapt/skin_btn")

	local var0 = arg0:findTF("frame/bg/pages/scrollrect"):GetComponent("LScrollRect")

	arg0.pages = {
		[var0.TYPE_ACTIVITY] = ActivityShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_SHOP_STREET] = StreetShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_MILITARY_SHOP] = MilitaryShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_GUILD] = GuildShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_SHAM_SHOP] = ShamShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_FRAGMENT] = FragmentShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_META] = MetaShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_MEDAL] = MedalShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_QUOTA] = QuotaShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0),
		[var0.TYPE_MINI_GAME] = MiniGameShopPage.New(arg0.pageContainer, arg0.event, arg0.contextData, var0)
	}
	arg0.contextData.singleWindow = ShopSingleWindow.New(arg0._tf, arg0.event)
	arg0.contextData.multiWindow = ShopMultiWindow.New(arg0._tf, arg0.event)
	arg0.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0._tf, arg0.event)
	arg0.contextData.paintingView = ShopPaintingView.New(arg0:findTF("paint/paint"), arg0:findTF("frame/chat"))

	arg0.contextData.paintingView:setSecretaryPos(arg0:findTF("paint/secretaryPos"))

	arg0.contextData.bgView = ShopBgView.New(arg0:findTF("bg"))
	arg0.recorder = {
		[var0.CATEGORY_ACTIVITY] = false,
		[var0.CATEGORY_MONTH] = false,
		[var0.CATEGORY_SUPPLY] = false
	}
	arg0.frameTr = arg0:findTF("frame")
	arg0.categoryUIList = UIItemList.New(arg0:findTF("frame/bg/types"), arg0:findTF("frame/bg/types/tpl"))
	arg0.shopUIList = UIItemList.New(arg0:findTF("frame/bg/shops"), arg0:findTF("frame/bg/shops/tpl"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	setActive(arg0.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0.stamp, false)
	end

	onButton(arg0, arg0.stamp, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.switchBtn, function()
		local var0 = ChargeScene.TYPE_DIAMOND

		if arg0.contextData ~= nil and arg0.contextData.chargePage ~= nil then
			var0 = arg0.contextData.chargePage
		end

		arg0:emit(NewShopsMediator.GO_MALL, var0)
	end, SFX_CANCEL)
	onButton(arg0, arg0.skinBtn, function()
		arg0:emit(NewShopsMediator.ON_SKIN_SHOP)
	end, SFX_PANEL)
	arg0:InitEntrances()
	arg0:BlurView()

	arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0, arg0.pageContainer, Vector2.New(-35, -90))
end

function var0.InitEntrances(arg0)
	arg0:InitCategory()
	arg0:ActiveDefaultCategory()

	arg0.shopType = nil
	arg0.shopIndex = nil
end

function var0.InitCategory(arg0)
	arg0.categoryTrs = {}

	local var0 = {
		var0.CATEGORY_MONTH,
		var0.CATEGORY_SUPPLY
	}

	if #(arg0.shops[var0.TYPE_ACTIVITY] or {}) > 0 then
		table.insert(var0, var0.CATEGORY_ACTIVITY)
	end

	arg0.categoryUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			arg0:UpdateCategory(arg2, var0, false)

			arg0.categoryTrs[var0] = arg2
		end
	end)
	arg0.categoryUIList:align(#var0)
end

local function var3(arg0, arg1)
	local var0 = var0.CATEGORY2NAME[arg1]
	local var1 = arg0:Find("lock")
	local var2 = arg0:Find("label")
	local var3 = arg0:Find("selected/selected")
	local var4 = var1:GetComponent(typeof(Image))

	var4.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0 .. "_lock")

	var4:SetNativeSize()

	local var5 = var2:GetComponent(typeof(Image))

	var5.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0)

	var5:SetNativeSize()

	local var6 = var2:Find("en"):GetComponent(typeof(Image))

	var6.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0 .. "_label")

	var6:SetNativeSize()

	local var7 = var3:GetComponent(typeof(Image))

	var7.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0 .. "_selected")

	var7:SetNativeSize()

	local var8 = var3.parent:Find("en"):GetComponent(typeof(Image))

	var8.sprite = GetSpriteFromAtlas("ui/ShopsUI_atlas", var0 .. "_label_selected")

	var8:SetNativeSize()
end

function var0.UpdateCategory(arg0, arg1, arg2, arg3)
	setActive(arg1:Find("lock"), arg3)
	setActive(arg1:Find("label"), not arg3)
	setActive(arg1:Find("selected"), false)
	var3(arg1, arg2)
	onToggle(arg0, arg1, function(arg0)
		if arg0 then
			arg0:InitShops(arg2)

			arg0.category = arg2

			arg0:ActiveDefaultShop()
		end

		setActive(arg1:Find("label"), not arg3 and not arg0)
		setActive(arg1:Find("selected"), not arg3 and arg0)
	end, SFX_PANEL)
	setToggleEnabled(arg1, not arg3)
end

function var0.InitShops(arg0, arg1)
	if arg0.category and arg0.category == arg1 then
		return
	end

	local var0 = var1[arg1]
	local var1 = {}

	arg0.displayShops = {}
	arg0.prevBtn = nil

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in ipairs(arg0.shops[iter1] or {}) do
			table.insert(var1, {
				type = iter1,
				index = iter2
			})
		end
	end

	arg0.shopUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			arg0:UpdateShop(arg2, var0)

			if not arg0.displayShops[var0.type] then
				arg0.displayShops[var0.type] = {}
			end

			arg0.displayShops[var0.type][var0.index] = arg2
		end
	end)
	arg0.shopUIList:align(#var1)
end

local function var4(arg0, arg1)
	local var0 = var0.TYPE2NAME[arg1.type]

	setText(arg0:Find("selected/Text"), var0)
	setText(arg0:Find("label"), var0)
end

local function var5(arg0, arg1, arg2)
	local var0 = arg1:Find("label")
	local var1 = arg1:Find("selected")

	onButton(arg0, arg1, function()
		if arg0.prevBtn == arg1 then
			return
		end

		if arg2() then
			if arg0.prevBtn then
				setActive(arg0.prevBtn:Find("label"), true)
				setActive(arg0.prevBtn:Find("selected"), false)
			end

			setActive(var0, false)
			setActive(var1, true)

			arg0.prevBtn = arg1
		end
	end, SFX_PANEL)
	setActive(var0, true)
	setActive(var1, false)
end

function var0.UpdateShop(arg0, arg1, arg2)
	var4(arg1, arg2)

	local var0 = arg1:Find("selected")
	local var1 = arg1:Find("label")

	var5(arg0, arg1, function()
		local var0 = arg0.shops[arg2.type][arg2.index]
		local var1 = arg0.pages[arg2.type]
		local var2, var3 = var1:CanOpen(var0, arg0.player)

		if var2 then
			if arg0.page and not arg0.page:GetLoaded() then
				return
			end

			if arg0.page then
				arg0.page:Hide()
			end

			arg0.contextData.bgView:Init(var1:GetBg(var0))
			var1:ExecuteAction("SetUp", var0, arg0.player, arg0.items)

			arg0.page = var1
			arg0.contextData.activeShop = arg2.type
			arg0.recorder[arg0.category] = arg2

			return true
		else
			pg.TipsMgr.GetInstance():ShowTips(var3)
		end

		return false
	end)
end

function var0.ActiveDefaultCategory(arg0)
	local var0 = arg0.contextData.warp or arg0.contextData.activeShop or var0.TYPE_ACTIVITY

	if type(var0) == "string" then
		local var1 = table.indexof(var2, var0)

		var0 = defaultValue(var1, var0.TYPE_ACTIVITY)
	end

	local var2 = arg0.contextData.index or 1

	if var0 == var0.TYPE_ACTIVITY and arg0.contextData.actId then
		for iter0, iter1 in ipairs(arg0.shops[var0] or {}) do
			if iter1.activityId == arg0.contextData.actId then
				var2 = iter0

				break
			end
		end
	elseif var0 == var0.TYPE_ACTIVITY and (not arg0.shops[var0.TYPE_ACTIVITY] or #(arg0.shops[var0.TYPE_ACTIVITY] or {}) <= 0) then
		var0 = var0.TYPE_SHOP_STREET
		var2 = 1
	end

	local var3

	for iter2, iter3 in pairs(var1) do
		if table.contains(iter3, var0) then
			var3 = iter2

			break
		end
	end

	assert(var3 and arg0.categoryTrs[var3])

	arg0.shopType = var0
	arg0.shopIndex = var2

	triggerToggle(arg0.categoryTrs[var3], true)
end

function var0.ActiveDefaultShop(arg0)
	local var0
	local var1

	if arg0.recorder[arg0.category] then
		local var2 = arg0.recorder[arg0.category]

		var0, var1 = var2.type, var2.index
	else
		var0, var1 = arg0.shopType, arg0.shopIndex or 1
	end

	local function var3()
		local var0

		for iter0, iter1 in pairs(arg0.displayShops) do
			for iter2, iter3 in pairs(iter1) do
				if arg0.pages[iter0]:CanOpen(nil, arg0.player) then
					var0 = var0 or iter3
				end
			end
		end

		if var0 then
			triggerButton(var0)
		end
	end

	if not var0 then
		var3()

		return
	end

	local var4, var5 = arg0.pages[var0]:CanOpen(nil, arg0.player)

	if var4 and arg0.displayShops[var0] and arg0.displayShops[var0][var1] then
		triggerButton(arg0.displayShops[var0][var1])
	else
		if not var4 then
			pg.TipsMgr.GetInstance():ShowTips(var5)
		end

		var3()
	end
end

function var0.onBackPressed(arg0)
	if arg0.contextData.singleWindow:GetLoaded() and arg0.contextData.singleWindow:isShowing() then
		arg0.contextData.singleWindow:Close()

		return
	end

	if arg0.contextData.multiWindow:GetLoaded() and arg0.contextData.multiWindow:isShowing() then
		arg0.contextData.multiWindow:Close()

		return
	end

	if arg0.contextData.singleWindowForESkin:GetLoaded() and arg0.contextData.singleWindowForESkin:isShowing() then
		arg0.contextData.singleWindowForESkin:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.BlurView(arg0)
	local var0 = arg0.frameTr:Find("bg/blur")

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.frameTr, {
		pbList = {
			arg0.frameTr:Find("bg"),
			var0
		}
	})
	var0:SetAsFirstSibling()
end

function var0.UnBlurView(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.frameTr, arg0._tf)
end

function var0.willExit(arg0)
	if arg0.bulinTip then
		arg0.bulinTip:Destroy()

		arg0.bulinTip = nil
	end

	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()
	end

	arg0:UnBlurView()
	arg0.contextData.singleWindow:Destroy()
	arg0.contextData.multiWindow:Destroy()
	arg0.contextData.singleWindowForESkin:Destroy()
	arg0.contextData.paintingView:Dispose()
	arg0.contextData.bgView:Dispose()

	arg0.contextData.singleWindow = nil
	arg0.contextData.multiWindow = nil
	arg0.contextData.singleWindowForESkin = nil
	arg0.contextData.paintingView = nil
	arg0.contextData.bgView = nil
	arg0.pages = nil
	arg0.bulinTip = nil
end

return var0
