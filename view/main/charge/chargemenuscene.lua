local var0_0 = class("ChargeMenuScene", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeMenuUI"
end

function var0_0.preload(arg0_2, arg1_2)
	if getProxy(ShopsProxy):ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = arg1_2
		})
	else
		arg1_2()
	end
end

function var0_0.getResource(arg0_3)
	local var0_3 = var0_0.super.getResource(arg0_3)
	local var1_3 = {}

	local function var2_3(arg0_4)
		if noEmptyStr(arg0_4) and not table.contains(var1_3, arg0_4) then
			table.insert(var1_3, arg0_4)
		end
	end

	local var3_3 = getProxy(ActivityProxy)
	local var4_3 = var3_3 and var3_3:getActiveBannerByType(GAMEUI_BANNER_9)

	if var4_3 then
		var2_3("activitybanner/" .. var4_3.pic)
	end

	local var5_3 = var3_3 and var3_3:getActiveBannerByType(GAMEUI_BANNER_11)

	if var5_3 then
		var2_3("activitybanner/" .. var5_3.pic)
	end

	local var6_3 = getProxy(ShopsProxy)

	if var6_3 then
		for iter0_3, iter1_3 in ipairs(var6_3:GetRecommendCommodities() or {}) do
			var2_3(iter1_3:GetIcon())
		end
	end

	var2_3("ui/ChargeTipUI")
	var2_3("ui/MonthCardTipWindow")
	var2_3("ui/GiftPackageTipWindow")
	var2_3("ui/CrusingTipWindow")

	for iter2_3, iter3_3 in ipairs(var1_3) do
		if not table.contains(var0_3, iter3_3) then
			table.insert(var0_3, iter3_3)
		end
	end

	return var0_3
end

function var0_0.init(arg0_5)
	arg0_5:initData()
	arg0_5:findUI()
	arg0_5:addListener()
	arg0_5:initUIText()
	arg0_5:InitBanner()
end

function var0_0.didEnter(arg0_6)
	arg0_6:updatePlayerRes()
	arg0_6:updatePanel()
	arg0_6:tryAutoOpenShop()
end

function var0_0.ResUISettings(arg0_7)
	return true
end

function var0_0.onBackPressed(arg0_8)
	if arg0_8.chargeTipWindow and arg0_8.chargeTipWindow:GetLoaded() and arg0_8.chargeTipWindow:isShowing() then
		arg0_8.chargeTipWindow:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_8)
end

function var0_0.willExit(arg0_9)
	if arg0_9.bannerRect then
		arg0_9.bannerRect:Dispose()

		arg0_9.bannerRect = nil
	end

	if arg0_9.chargeOrPurchaseHandler then
		arg0_9.chargeOrPurchaseHandler:Dispose()

		arg0_9.chargeOrPurchaseHandler = nil
	end

	if arg0_9.chargeTipWindow then
		arg0_9.chargeTipWindow:Destroy()

		arg0_9.chargeTipWindow = nil
	end
end

function var0_0.initData(arg0_10)
	return
end

function var0_0.initUIText(arg0_11)
	return
end

function var0_0.findUI(arg0_12)
	arg0_12.blurTF = arg0_12._tf:Find("blur_panel")
	arg0_12.topTF = arg0_12.blurTF:Find("adapt/top")
	arg0_12.resTF = arg0_12.topTF:Find("res")
	arg0_12.backBtn = arg0_12.topTF:Find("back_button")
	arg0_12.menuTF = arg0_12._tf:Find("menu_screen")
	arg0_12.skinShopBtn = arg0_12.menuTF:Find("skin_shop")
	arg0_12.skinLockIcon = arg0_12.menuTF:Find("skin_lock")

	local var0_12 = LOCK_SKIN_SHOP_ENTER and getProxy(PlayerProxy):getData().level < LOCK_SKIN_SHOP_ENTER_LEVEL

	setActive(arg0_12.skinShopBtn, not var0_12)
	setActive(arg0_12.skinLockIcon, var0_12)

	arg0_12.diamondShopBtn = arg0_12.menuTF:Find("dimond_shop")
	arg0_12.itemShopBtn = arg0_12.menuTF:Find("props")
	arg0_12.giftShopBtn = arg0_12.menuTF:Find("gift_shop")
	arg0_12.supplyShopBtn = arg0_12.menuTF:Find("supply")
	arg0_12.monthCardTag = arg0_12.diamondShopBtn:Find("monthcard_tag")
	arg0_12.giftTag = arg0_12.giftShopBtn:Find("tip")
	arg0_12.bannerRect = BannerScrollRect.New(arg0_12._tf:Find("menu_screen/banner/mask/content"), arg0_12._tf:Find("menu_screen/banner/dots"))
	arg0_12.chargeOrPurchaseHandler = ChargeOrPurchaseHandler.New()
	arg0_12.chargeTipWindow = ChargeTipWindow.New(arg0_12._tf, arg0_12.event)
end

local function var1_0(arg0_13, arg1_13, arg2_13)
	setText(arg1_13:Find("name"), arg2_13:GetName())
	setText(arg1_13:Find("desc"), arg2_13:GetDesc())

	local var0_13 = arg2_13:GetDropList()
	local var1_13 = UIItemList.New(arg1_13:Find("items"), arg1_13:Find("items/award"))

	var1_13:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]

			updateDrop(arg2_14, var0_14)
			onButton(arg0_13, arg2_14, function()
				arg0_13:emit(BaseUI.ON_DROP, var0_14)
			end, SFX_PANEL)
		end
	end)
	var1_13:align(#var0_13)

	local var2_13 = arg2_13:GetGem()

	setActive(arg1_13:Find("gem"), var2_13 > 0)
	setText(arg1_13:Find("gem/Text"), var2_13)

	local var3_13, var4_13, var5_13 = arg2_13:GetPrice()

	setText(arg1_13:Find("price/Text"), var4_13)
	setActive(arg1_13:Find("price/Text/icon"), var3_13 ~= RecommendCommodity.PRICE_TYPE_RMB)
	setText(arg1_13:Find("price/Text/label"), var3_13 == RecommendCommodity.PRICE_TYPE_RMB and GetMoneySymbol() or "")

	local var6_13 = arg1_13:Find("icon")

	GetSpriteFromAtlasAsync(arg2_13:GetIcon(), "", function(arg0_16)
		setImageSprite(var6_13, arg0_16)
	end)

	var6_13.sizeDelta = Vector2(180, 180)
end

function var0_0.InitBanner(arg0_17)
	local var0_17 = getProxy(ShopsProxy):GetRecommendCommodities()

	for iter0_17, iter1_17 in ipairs(var0_17) do
		local var1_17 = arg0_17.bannerRect:AddChild()

		var1_0(arg0_17, var1_17, iter1_17)
		onButton(arg0_17, var1_17, function()
			local var0_18, var1_18 = iter1_17:IsMonthCardAndCantPurchase()

			if var0_18 then
				pg.TipsMgr.GetInstance():ShowTips(var1_18)

				return
			end

			arg0_17.bannerRect:Pause()

			arg0_17.lookUpIndex = iter0_17

			pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_LOOKUP_RECOMMEND, iter0_17))
			arg0_17.chargeOrPurchaseHandler:ChargeOrPurchaseAsyn(iter1_17:GetRealCommodity())
		end, SFX_PANEL)
	end

	arg0_17.bannerRect:SetUp()
end

function var0_0.FlushBanner(arg0_19)
	arg0_19.bannerRect:Reset()
	arg0_19:InitBanner()
end

function var0_0.addListener(arg0_20)
	onButton(arg0_20, arg0_20.backBtn, function()
		arg0_20:closeView()
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20.skinShopBtn, function()
		arg0_20:emit(ChargeMenuMediator.GO_SKIN_SHOP)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.diamondShopBtn, function()
		arg0_20:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_DIAMOND)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.giftShopBtn, function()
		arg0_20:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_GIFT)

		local var0_24 = isActive(arg0_20.giftTag)

		pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_ENTER_GIFT, var0_24))
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.itemShopBtn, function()
		arg0_20:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_ITEM)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.supplyShopBtn, function()
		arg0_20:emit(ChargeMenuMediator.GO_SUPPLY_SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end, SFX_PANEL)
end

function var0_0.updatePlayerRes(arg0_27)
	return
end

function var0_0.updatePanel(arg0_28)
	local var0_28 = getProxy(ActivityProxy)
	local var1_28 = var0_28:getActiveBannerByType(GAMEUI_BANNER_9)

	if var1_28 ~= nil then
		LoadImageSpriteAsync("activitybanner/" .. var1_28.pic, arg0_28.skinShopBtn)
	end

	local var2_28 = var0_28:getActiveBannerByType(GAMEUI_BANNER_11)

	if var2_28 ~= nil then
		LoadImageSpriteAsync("activitybanner/" .. var2_28.pic, arg0_28.giftShopBtn:Find("BG"))
	end

	local var3_28 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	setActive(arg0_28.monthCardTag, var3_28)
	MonthCardOutDateTipPanel.SetMonthCardTagDate()
	TagTipHelper.SetFuDaiTagMark()
	TagTipHelper.SetSkinTagMark()
	TagTipHelper.FreeGiftTag({
		arg0_28.giftTag
	})
end

function var0_0.tryAutoOpenShop(arg0_29)
	local var0_29 = arg0_29.contextData.warp

	if var0_29 ~= nil then
		if var0_29 == ChargeScene.TYPE_DIAMOND then
			triggerButton(arg0_29.diamondShopBtn)
		elseif var0_29 == ChargeScene.TYPE_GIFT then
			triggerButton(arg0_29.giftShopBtn)
		elseif var0_29 == ChargeScene.TYPE_ITEM then
			triggerButton(arg0_29.itemShopBtn)
		end
	end
end

function var0_0.OnRemoveLayer(arg0_30, arg1_30)
	if arg1_30.mediator == ChargeItemPanelMediator and arg0_30.bannerRect then
		arg0_30.bannerRect:Resume()
	end
end

function var0_0.OnChargeSuccess(arg0_31, arg1_31)
	arg0_31.chargeTipWindow:ExecuteAction("Show", arg1_31)
end

return var0_0
