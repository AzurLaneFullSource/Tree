local var0_0 = class("AuctionGameMainSettlementScene", import("view.base.BaseUI"))

var0_0.REVEAL_ITEM = "AuctionGameMainSettlementScene::REVEAL_ITEM"
var0_0.REVEAL_OVER = "AuctionGameMainSettlementScene::REVEAL_OVER"

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainSettlementUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiRevealBtnText, i18n("auction_settlement_quick"))
	setText(arg0_2.uiNameTitleText, i18n("auction_settlement_name"))
	setText(arg0_2.uiBidTitleText, i18n("auction_settlement_price"))
	setText(arg0_2.uiStoreHouseTitleText, i18n("auction_settlement_value"))
	setText(arg0_2.uiProceedsTitleText, i18n("auction_settlement_revenue"))
	setText(arg0_2.uiDividendTitleText, i18n("auction_settlement_dividend"))
	setText(arg0_2.uiSessionTitleText, i18n("auction_settlement_session"))
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2.storeView:RevealAllItem()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiRevealBtn, function()
		arg0_2.storeView:RevealAllItem()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiShareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.AuctionGame)
	end, SFX_PANEL)

	arg0_2.storeView = AuctionGameMainSettlementStoreView.New(arg0_2.uiStorePanel, arg0_2)
end

function var0_0.didEnter(arg0_6)
	arg0_6:OverlayPanel(arg0_6.uiAdaptTf, {
		pbList = {
			arg0_6.uiInfoTf
		}
	})

	local var0_6 = getProxy(AuctionGameProxy)
	local var1_6 = var0_6:GetSettlementData()
	local var2_6 = var1_6.bidUserID
	local var3_6

	for iter0_6, iter1_6 in ipairs(var0_6:GetPlayerList()) do
		if iter1_6.id == var2_6 then
			var3_6 = iter1_6

			break
		end
	end

	arg0_6.paintingDefaultAngle = arg0_6.uiPaintingTf.localEulerAngles

	local var4_6 = Ship.New({
		configId = var3_6.icon,
		skin_id = var3_6.skinId
	})

	setPaintingPrefabAsync(arg0_6.uiPaintingTf, var4_6:getPainting(), "chuanwu", nil, {
		skinID = var4_6:getSkinId(),
		rotateZ = arg0_6.paintingDefaultAngle.z
	})

	arg0_6.shipVO = var4_6

	setScrollText(arg0_6.uiNameText, var3_6.name)

	local var5_6 = var0_6:GetAuctionID()

	setScrollText(arg0_6.uiSessionText, pg.auction_session[var5_6].name)
	setText(arg0_6.uiBidText, StringHelper.ForamtNumber(var1_6.bidValue))
	setText(arg0_6.uiStoreHouseText, 0)
	setText(arg0_6.uiProceedsText, string.format("<color=#B13535>%s</color>", StringHelper.ForamtNumber(-var1_6.bidValue)))
	setText(arg0_6.uiDividendText, 0)
	arg0_6:RefreshCurrency()

	arg0_6.addValue = 0
	arg0_6.bidValue = var1_6.bidValue
	arg0_6.settlementVO = var1_6
	arg0_6.eventList = {
		arg0_6:bind(var0_0.REVEAL_ITEM, handler(arg0_6, arg0_6.OnRefreshText)),
		arg0_6:bind(var0_0.REVEAL_OVER, handler(arg0_6, arg0_6.OnRefreshOver))
	}

	arg0_6.storeView:didEnter()
	setActive(arg0_6.uiCloseBtn, false)
	setActive(arg0_6.uiShareBtn, false)

	local var6_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").itemID

	LoadSpriteAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = var6_6
	}):getIcon(), function(arg0_7)
		if not IsNil(arg0_6.uiCurrencyIcon) then
			arg0_6.uiCurrencyIcon.sprite = arg0_7
		end
	end)
end

function var0_0.RefreshCurrency(arg0_8)
	setText(arg0_8.uiCurrencyText, StringHelper.ForamtNumber(getProxy(AuctionGameBaseProxy).gold))
end

function var0_0.OnRefreshText(arg0_9, arg1_9, arg2_9)
	print("揭示物品: id", arg2_9.id, "uid:", arg2_9.uid, "价值:", arg2_9.price, "当前总价值:", arg0_9.addValue + arg2_9.price)

	arg0_9.addValue = arg0_9.addValue + arg2_9.price

	setText(arg0_9.uiStoreHouseText, StringHelper.ForamtNumber(arg0_9.addValue))

	local var0_9 = getProxy(AuctionGameProxy):GetSettlementData()
	local var1_9 = arg0_9.addValue - arg0_9.settlementVO.bidValue

	setText(arg0_9.uiProceedsText, string.format("<color=%s>%s</color>", var1_9 > 0 and "#03825F" or "#B13535", StringHelper.ForamtNumber(var1_9)))
end

function var0_0.OnRefreshOver(arg0_10)
	setActive(arg0_10.uiCloseBtn, true)
	setActive(arg0_10.uiShareBtn, true)

	local var0_10 = getProxy(AuctionGameProxy)
	local var1_10 = var0_10:GetSettlementData()
	local var2_10 = getProxy(AuctionGameBaseProxy)
	local var3_10 = var1_10.proceeds
	local var4_10 = pg.auction_session[var0_10:GetAuctionID()].name
	local var5_10 = var1_10.bidUserID == getProxy(PlayerProxy):getPlayerId() and 1 or 0

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionSettlement(var4_10, var5_10, var1_10.bidValue, arg0_10.addValue, var2_10.gold, var2_10.gold + var3_10))

	if not pg.NewGuideMgr.GetInstance():IsBusy() then
		var2_10:AddGold(var3_10)
	end

	arg0_10:RefreshCurrency()

	if var1_10.bidUserID ~= getProxy(PlayerProxy):getPlayerId() then
		setText(arg0_10.uiDividendText, string.format("<color=%s>%s</color>", var1_10.proceeds > 0 and "#03825F" or "#B13535", StringHelper.ForamtNumber(var1_10.proceeds)))
	end
end

function var0_0.willExit(arg0_11)
	arg0_11:UnOverlayPanel(arg0_11.uiAdaptTf, arg0_11._tf)

	for iter0_11, iter1_11 in ipairs(arg0_11.eventList) do
		arg0_11:disconnect(iter1_11)
	end

	retPaintingPrefab(arg0_11.uiPaintingTf, arg0_11.shipVO:getPainting())
	arg0_11.storeView:willExit()

	arg0_11.storeView = nil
end

function var0_0.onBackPressed(arg0_12)
	if isActive(arg0_12.uiCloseBtn) then
		var0_0.super.onBackPressed(arg0_12)
	end
end

return var0_0
