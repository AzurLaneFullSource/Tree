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

function var0_0.init(arg0_3)
	arg0_3:initData()
	arg0_3:findUI()
	arg0_3:addListener()
	arg0_3:initUIText()
	arg0_3:InitBanner()
end

function var0_0.didEnter(arg0_4)
	arg0_4:updatePlayerRes()
	arg0_4:updatePanel()
	arg0_4:tryAutoOpenShop()
end

function var0_0.ResUISettings(arg0_5)
	return true
end

function var0_0.onBackPressed(arg0_6)
	if arg0_6.chargeTipWindow and arg0_6.chargeTipWindow:GetLoaded() and arg0_6.chargeTipWindow:isShowing() then
		arg0_6.chargeTipWindow:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_6)
end

function var0_0.willExit(arg0_7)
	if arg0_7.bannerRect then
		arg0_7.bannerRect:Dispose()

		arg0_7.bannerRect = nil
	end

	if arg0_7.chargeOrPurchaseHandler then
		arg0_7.chargeOrPurchaseHandler:Dispose()

		arg0_7.chargeOrPurchaseHandler = nil
	end

	if arg0_7.chargeTipWindow then
		arg0_7.chargeTipWindow:Destroy()

		arg0_7.chargeTipWindow = nil
	end
end

function var0_0.initData(arg0_8)
	return
end

function var0_0.initUIText(arg0_9)
	return
end

function var0_0.findUI(arg0_10)
	arg0_10.blurTF = arg0_10:findTF("blur_panel")
	arg0_10.topTF = arg0_10:findTF("adapt/top", arg0_10.blurTF)
	arg0_10.resTF = arg0_10:findTF("res", arg0_10.topTF)
	arg0_10.backBtn = arg0_10:findTF("back_button", arg0_10.topTF)
	arg0_10.menuTF = arg0_10:findTF("menu_screen")
	arg0_10.skinShopBtn = arg0_10:findTF("skin_shop", arg0_10.menuTF)
	arg0_10.skinLockIcon = arg0_10:findTF("skin_lock", arg0_10.menuTF)

	local var0_10 = LOCK_SKIN_SHOP_ENTER and getProxy(PlayerProxy):getData().level < LOCK_SKIN_SHOP_ENTER_LEVEL

	setActive(arg0_10.skinShopBtn, not var0_10)
	setActive(arg0_10.skinLockIcon, var0_10)

	arg0_10.diamondShopBtn = arg0_10:findTF("dimond_shop", arg0_10.menuTF)
	arg0_10.itemShopBtn = arg0_10:findTF("props", arg0_10.menuTF)
	arg0_10.giftShopBtn = arg0_10:findTF("gift_shop", arg0_10.menuTF)
	arg0_10.supplyShopBtn = arg0_10:findTF("supply", arg0_10.menuTF)
	arg0_10.monthCardTag = arg0_10:findTF("monthcard_tag", arg0_10.diamondShopBtn)
	arg0_10.giftTag = arg0_10:findTF("tip", arg0_10.giftShopBtn)
	arg0_10.bannerRect = BannerScrollRect.New(arg0_10:findTF("menu_screen/banner/mask/content"), arg0_10:findTF("menu_screen/banner/dots"))
	arg0_10.chargeOrPurchaseHandler = ChargeOrPurchaseHandler.New()
	arg0_10.chargeTipWindow = ChargeTipWindow.New(arg0_10._tf, arg0_10.event)
end

local function var1_0(arg0_11, arg1_11, arg2_11)
	setText(arg1_11:Find("name"), arg2_11:GetName())
	setText(arg1_11:Find("desc"), arg2_11:GetDesc())

	local var0_11 = arg2_11:GetDropList()
	local var1_11 = UIItemList.New(arg1_11:Find("items"), arg1_11:Find("items/award"))

	var1_11:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var0_11[arg1_12 + 1]

			updateDrop(arg2_12, var0_12)
			onButton(arg0_11, arg2_12, function()
				arg0_11:emit(BaseUI.ON_DROP, var0_12)
			end, SFX_PANEL)
		end
	end)
	var1_11:align(#var0_11)

	local var2_11 = arg2_11:GetGem()

	setActive(arg1_11:Find("gem"), var2_11 > 0)
	setText(arg1_11:Find("gem/Text"), var2_11)

	local var3_11, var4_11, var5_11 = arg2_11:GetPrice()

	setText(arg1_11:Find("price/Text"), var4_11)
	setActive(arg1_11:Find("price/Text/icon"), var3_11 ~= RecommendCommodity.PRICE_TYPE_RMB)
	setText(arg1_11:Find("price/Text/label"), var3_11 == RecommendCommodity.PRICE_TYPE_RMB and GetMoneySymbol() or "")

	local var6_11 = arg1_11:Find("icon")

	GetSpriteFromAtlasAsync(arg2_11:GetIcon(), "", function(arg0_14)
		setImageSprite(var6_11, arg0_14)
	end)

	var6_11.sizeDelta = Vector2(180, 180)
end

function var0_0.InitBanner(arg0_15)
	local var0_15 = getProxy(ShopsProxy):GetRecommendCommodities()

	for iter0_15, iter1_15 in ipairs(var0_15) do
		local var1_15 = arg0_15.bannerRect:AddChild()

		var1_0(arg0_15, var1_15, iter1_15)
		onButton(arg0_15, var1_15, function()
			local var0_16, var1_16 = iter1_15:IsMonthCardAndCantPurchase()

			if var0_16 then
				pg.TipsMgr.GetInstance():ShowTips(var1_16)

				return
			end

			arg0_15.bannerRect:Puase()

			arg0_15.lookUpIndex = iter0_15

			pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_LOOKUP_RECOMMEND, iter0_15))
			arg0_15.chargeOrPurchaseHandler:ChargeOrPurchaseAsyn(iter1_15:GetRealCommodity())
		end, SFX_PANEL)
	end

	arg0_15.bannerRect:SetUp()
end

function var0_0.FlushBanner(arg0_17)
	arg0_17.bannerRect:Reset()
	arg0_17:InitBanner()
end

function var0_0.addListener(arg0_18)
	onButton(arg0_18, arg0_18.backBtn, function()
		arg0_18:closeView()
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.skinShopBtn, function()
		arg0_18:emit(ChargeMenuMediator.GO_SKIN_SHOP)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.diamondShopBtn, function()
		arg0_18:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_DIAMOND)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.giftShopBtn, function()
		arg0_18:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_GIFT)

		local var0_22 = isActive(arg0_18.giftTag)

		pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_ENTER_GIFT, var0_22))
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.itemShopBtn, function()
		arg0_18:emit(ChargeMenuMediator.GO_CHARGE_SHOP, ChargeScene.TYPE_ITEM)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.supplyShopBtn, function()
		arg0_18:emit(ChargeMenuMediator.GO_SUPPLY_SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end, SFX_PANEL)
end

function var0_0.updatePlayerRes(arg0_25)
	return
end

function var0_0.updatePanel(arg0_26)
	local var0_26 = getProxy(ActivityProxy)
	local var1_26 = var0_26:getActiveBannerByType(GAMEUI_BANNER_9)

	if var1_26 ~= nil then
		LoadImageSpriteAsync("activitybanner/" .. var1_26.pic, arg0_26.skinShopBtn)
	end

	local var2_26 = var0_26:getActiveBannerByType(GAMEUI_BANNER_11)

	if var2_26 ~= nil then
		LoadImageSpriteAsync("activitybanner/" .. var2_26.pic, arg0_26:findTF("BG", arg0_26.giftShopBtn))
	end

	local var3_26 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	setActive(arg0_26.monthCardTag, var3_26)
	MonthCardOutDateTipPanel.SetMonthCardTagDate()
	TagTipHelper.SetFuDaiTagMark()
	TagTipHelper.SetSkinTagMark()
	TagTipHelper.FreeGiftTag({
		arg0_26.giftTag
	})
end

function var0_0.tryAutoOpenShop(arg0_27)
	local var0_27 = arg0_27.contextData.wrap

	if var0_27 ~= nil then
		if var0_27 == ChargeScene.TYPE_DIAMOND then
			triggerButton(arg0_27.diamondShopBtn)
		elseif var0_27 == ChargeScene.TYPE_GIFT then
			triggerButton(arg0_27.giftShopBtn)
		elseif var0_27 == ChargeScene.TYPE_ITEM then
			triggerButton(arg0_27.itemShopBtn)
		end
	end
end

function var0_0.OnRemoveLayer(arg0_28, arg1_28)
	if arg1_28.mediator == ChargeItemPanelMediator and arg0_28.bannerRect then
		arg0_28.bannerRect:Resume()
	end
end

function var0_0.OnChargeSuccess(arg0_29, arg1_29)
	arg0_29.chargeTipWindow:ExecuteAction("Show", arg1_29)
end

return var0_0
