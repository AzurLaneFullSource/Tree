local var0_0 = class("AuctionGamePreorderBoxSettlementScene", import("view.base.BaseUI"))

var0_0.REVEAL_ITEM = "AuctionGameMainSettlementScene::REVEAL_ITEM"
var0_0.REVEAL_OVER = "AuctionGameMainSettlementScene::REVEAL_OVER"

function var0_0.getUIName(arg0_1)
	return "AuctionGamePreorderBoxSettlementUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2.storeView:RevealAllItem()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCancelBtn, function()
		arg0_2.storeView:RevealAllItem()
		arg0_2:closeView()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiRevealBtn, function()
		arg0_2.storeView:RevealAllItem()
	end, SFX_PANEL)

	arg0_2.storeView = AuctionGamePreorderBoxSettlementStoreView.New(arg0_2.uiStorePanel, arg0_2)

	setText(arg0_2.uiRevealBtnText, i18n("auction_settlement_quick"))
	setText(arg0_2.uiStoreHouseTitleText, i18n("auction_settlement_value"))
	setText(arg0_2.uiProceedsTitleText, i18n("auction_settlement_revenue"))
end

function var0_0.didEnter(arg0_6)
	arg0_6:OverlayPanel(arg0_6.uiAdaptTf, {
		pbList = {
			arg0_6.uiInfoTf
		}
	})

	local var0_6 = getProxy(PlayerProxy)
	local var1_6 = getProxy(PlayerProxy):getData()

	setPaintingPrefabAsync(arg0_6.uiPaintingTf, pg.ship_skin_template[900284].painting, "chuanwu", nil, {
		skinID = 900284
	})
	setText(arg0_6.uiStoreHouseText, 0)
	setText(arg0_6.uiProceedsText, string.format("<color=#B13535>%s</color>", StringHelper.ForamtNumber(-1 * AuctionGameTools.GetPreorderCurrentyCnt())))
	arg0_6:RefreshCurrency()

	arg0_6.addValue = 0
	arg0_6.eventList = {
		arg0_6:bind(var0_0.REVEAL_ITEM, handler(arg0_6, arg0_6.OnRefreshText)),
		arg0_6:bind(var0_0.REVEAL_OVER, handler(arg0_6, arg0_6.OnRefreshOver))
	}

	arg0_6.storeView:didEnter()
	setActive(arg0_6.uiCloseBtn, false)

	local var2_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").itemID

	LoadSpriteAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = var2_6
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

	local var0_9 = arg0_9.addValue - AuctionGameTools.GetPreorderCurrentyCnt()

	setText(arg0_9.uiProceedsText, string.format("<color=%s>%s</color>", var0_9 > 0 and "#03825F" or "#B13535", StringHelper.ForamtNumber(var0_9)))
end

function var0_0.OnRefreshOver(arg0_10)
	setActive(arg0_10.uiCloseBtn, true)

	local var0_10 = arg0_10.addValue

	getProxy(AuctionGameBaseProxy):AddGold(var0_10)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPreorder(1, var0_10))
	arg0_10:RefreshCurrency()
end

function var0_0.willExit(arg0_11)
	arg0_11:UnOverlayPanel(arg0_11.uiAdaptTf, arg0_11._tf)

	for iter0_11, iter1_11 in ipairs(arg0_11.eventList) do
		arg0_11:disconnect(iter1_11)
	end

	retPaintingPrefab(arg0_11.uiPaintingTf, pg.ship_skin_template[900284].painting)
	arg0_11.storeView:willExit()

	arg0_11.storeView = nil
end

function var0_0.onBackPressed(arg0_12)
	if isActive(arg0_12.uiCloseBtn) then
		var0_0.super.onBackPressed(arg0_12)
	end
end

return var0_0
