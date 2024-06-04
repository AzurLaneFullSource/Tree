local var0 = class("ChargeMenuScene", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ChargeMenuUI"
end

function var0.preload(arg0, arg1)
	if getProxy(ShopsProxy):ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = arg1
		})
	else
		arg1()
	end
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initUIText()
	arg0:InitBanner()
end

function var0.didEnter(arg0)
	arg0:updatePlayerRes()
	arg0:updatePanel()
	arg0:tryAutoOpenShop()
end

function var0.ResUISettings(arg0)
	return true
end

function var0.onBackPressed(arg0)
	if arg0.chargeTipWindow and arg0.chargeTipWindow:GetLoaded() and arg0.chargeTipWindow:isShowing() then
		arg0.chargeTipWindow:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if arg0.bannerRect then
		arg0.bannerRect:Dispose()

		arg0.bannerRect = nil
	end

	if arg0.chargeOrPurchaseHandler then
		arg0.chargeOrPurchaseHandler:Dispose()

		arg0.chargeOrPurchaseHandler = nil
	end

	if arg0.chargeTipWindow then
		arg0.chargeTipWindow:Destroy()

		arg0.chargeTipWindow = nil
	end
end

function var0.initData(arg0)
	return
end

function var0.initUIText(arg0)
	return
end

function var0.findUI(arg0)
	arg0.blurTF = arg0:findTF("blur_panel")
	arg0.topTF = arg0:findTF("adapt/top", arg0.blurTF)
	arg0.resTF = arg0:findTF("res", arg0.topTF)
	arg0.backBtn = arg0:findTF("back_button", arg0.topTF)
	arg0.menuTF = arg0:findTF("menu_screen")
	arg0.skinShopBtn = arg0:findTF("skin_shop", arg0.menuTF)
	arg0.diamondShopBtn = arg0:findTF("dimond_shop", arg0.menuTF)
	arg0.itemShopBtn = arg0:findTF("props", arg0.menuTF)
	arg0.giftShopBtn = arg0:findTF("gift_shop", arg0.menuTF)
	arg0.supplyShopBtn = arg0:findTF("supply", arg0.menuTF)
	arg0.monthCardTag = arg0:findTF("monthcard_tag", arg0.diamondShopBtn)
	arg0.giftTag = arg0:findTF("tip", arg0.giftShopBtn)
	arg0.bannerRect = BannerScrollRect.New(arg0:findTF("menu_screen/banner/mask/content"), arg0:findTF("menu_screen/banner/dots"))
	arg0.chargeOrPurchaseHandler = ChargeOrPurchaseHandler.New()
	arg0.chargeTipWindow = ChargeTipWindow.New(arg0._tf, arg0.event)
end

local function var1(arg0, arg1, arg2)
	setText(arg1:Find("name"), arg2:GetName())
	setText(arg1:Find("desc"), arg2:GetDesc())

	local var0 = arg2:GetDropList()
	local var1 = UIItemList.New(arg1:Find("items"), arg1:Find("items/award"))

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			updateDrop(arg2, var0)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)
		end
	end)
	var1:align(#var0)

	local var2 = arg2:GetGem()

	setActive(arg1:Find("gem"), var2 > 0)
	setText(arg1:Find("gem/Text"), var2)

	local var3, var4, var5 = arg2:GetPrice()

	setText(arg1:Find("price/Text"), var4)
	setActive(arg1:Find("price/Text/icon"), var3 ~= RecommendCommodity.PRICE_TYPE_RMB)
	setText(arg1:Find("price/Text/label"), var3 == RecommendCommodity.PRICE_TYPE_RMB and GetMoneySymbol() or "")

	local var6 = arg1:Find("icon")

	GetSpriteFromAtlasAsync(arg2:GetIcon(), "", function(arg0)
		setImageSprite(var6, arg0)
	end)

	var6.sizeDelta = Vector2(180, 180)
end

function var0.InitBanner(arg0)
	local var0 = getProxy(ShopsProxy):GetRecommendCommodities()

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0.bannerRect:AddChild()

		var1(arg0, var1, iter1)
		onButton(arg0, var1, function()
			local var0, var1 = iter1:IsMonthCardAndCantPurchase()

			if var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return
			end

			arg0.bannerRect:Puase()

			arg0.lookUpIndex = iter0

			pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_LOOKUP_RECOMMEND, iter0))
			arg0.chargeOrPurchaseHandler:ChargeOrPurchaseAsyn(iter1:GetRealCommodity())
		end, SFX_PANEL)
	end

	arg0.bannerRect:SetUp()
end

function var0.FlushBanner(arg0)
	arg0.bannerRect:Reset()
	arg0:InitBanner()
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.skinShopBtn, function()
		arg0:emit(ChargeMenuMediator.GO_SKIN_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.diamondShopBtn, function()
		arg0:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_DIAMOND)
	end, SFX_PANEL)
	onButton(arg0, arg0.giftShopBtn, function()
		arg0:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_GIFT)

		local var0 = isActive(arg0.giftTag)

		pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_ENTER_GIFT, var0))
	end, SFX_PANEL)
	onButton(arg0, arg0.itemShopBtn, function()
		arg0:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_ITEM)
	end, SFX_PANEL)
	onButton(arg0, arg0.supplyShopBtn, function()
		arg0:emit(ChargeMenuMediator.GO_SUPPLY_SHOP, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end, SFX_PANEL)
end

function var0.updatePlayerRes(arg0)
	return
end

function var0.updatePanel(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActiveBannerByType(GAMEUI_BANNER_9)

	if var1 ~= nil then
		LoadImageSpriteAsync("activitybanner/" .. var1.pic, arg0.skinShopBtn)
	end

	local var2 = var0:getActiveBannerByType(GAMEUI_BANNER_11)

	if var2 ~= nil then
		LoadImageSpriteAsync("activitybanner/" .. var2.pic, arg0:findTF("BG", arg0.giftShopBtn))
	end

	local var3 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	setActive(arg0.monthCardTag, var3)
	MonthCardOutDateTipPanel.SetMonthCardTagDate()
	TagTipHelper.SetFuDaiTagMark()
	TagTipHelper.SetSkinTagMark()
	TagTipHelper.FreeGiftTag({
		arg0.giftTag
	})
end

function var0.tryAutoOpenShop(arg0)
	local var0 = arg0.contextData.wrap

	if var0 ~= nil then
		if var0 == ChargeScene.TYPE_DIAMOND then
			triggerButton(arg0.diamondShopBtn)
		elseif var0 == ChargeScene.TYPE_GIFT then
			triggerButton(arg0.giftShopBtn)
		elseif var0 == ChargeScene.TYPE_ITEM then
			triggerButton(arg0.itemShopBtn)
		end
	end
end

function var0.OnRemoveLayer(arg0, arg1)
	if arg1.mediator == ChargeItemPanelMediator and arg0.bannerRect then
		arg0.bannerRect:Resume()
	end
end

function var0.OnChargeSuccess(arg0, arg1)
	arg0.chargeTipWindow:ExecuteAction("Show", arg1)
end

return var0
