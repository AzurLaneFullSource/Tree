local var0_0 = class("AuctionGameNameCardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctioNGameNameCardUI"
end

function var0_0.init(arg0_2)
	arg0_2.ysScreenShoter = arg0_2._tf:GetComponent(typeof(YSTool.YSScreenShoter))

	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCopyBtn, function()
		UniPasteBoard.SetClipBoardString(getProxy(PlayerProxy):getPlayerId())
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiShareBtn, function()
		local var0_5 = getProxy(PlayerProxy)
		local var1_5 = getProxy(PlayerProxy):getData()

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildNameCard(1, var1_5.id))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSaveBtn, function()
		setActive(pg.UIMgr.GetInstance().OverlayEffect, false)
		setActive(arg0_2.uiBtnsGo, false)

		local function var0_6(arg0_7)
			setActive(pg.UIMgr.GetInstance().OverlayEffect, true)
			setActive(arg0_2.uiBtnsGo, true)
			YSNormalTool.MediaTool.SaveImageWithBytes(arg0_7, function(arg0_8, arg1_8)
				if arg0_8 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
				end
			end)
		end

		arg0_2.ysScreenShoter:TakeScreenShotData(tackCallBack, var0_6)

		local var1_6 = getProxy(PlayerProxy)
		local var2_6 = getProxy(PlayerProxy):getData()

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildNameCard(2, var2_6.id))
	end, SFX_PANEL)

	arg0_2.paintingDefaultAngle = arg0_2.uiPaintingTf.localEulerAngles

	setText(arg0_2.uiMatchesTitleText, i18n("auction_matches_title"))
	setText(arg0_2.uiSuccessCntTitleText, i18n("auction_success_cnt_title"))
	setText(arg0_2.uiSuccessRateTitleText, i18n("auction_success_rate_title"))
	setText(arg0_2.uiCurrencyTitleText, i18n("auction_currency_title"))
	setText(arg0_2.uiTotalProfitTitleText, i18n("auction_total_profit_title"))
	setText(arg0_2.uiHighestProfitTitleText, i18n("auction_highest_profit_title"))
	setText(arg0_2.uiCollectionTitleText, i18n("auction_collection_type_title"))
	setText(arg0_2.uiCollectionPriceTitleText, i18n("auction_collection_price_title"))
	setActive(arg0_2.uiShareBtn, false)
end

function var0_0.didEnter(arg0_9)
	arg0_9:OverlayPanel(arg0_9._tf, {
		pbList = {
			arg0_9.uiBg
		}
	})

	local var0_9 = getProxy(PlayerProxy)
	local var1_9 = getProxy(PlayerProxy):getRawData()

	setText(arg0_9.uiNameText, var1_9.name)
	setText(arg0_9.uiUidText, var1_9.id)

	local var2_9 = getProxy(UserProxy):getRawData()
	local var3_9 = getProxy(ServerProxy):getRawData()[var2_9 and var2_9.server or 0]

	setScrollText(arg0_9.uiServerNameText, var3_9 and var3_9.name or "")

	local var4_9 = getProxy(AuctionGameBaseProxy)
	local var5_9 = var4_9.matchNum

	setText(arg0_9.uiMatchesCntText, var5_9)
	setText(arg0_9.uiSuccessCntText, var4_9.bidSuccessCnt)
	setText(arg0_9.uiSuccessRateText, string.format("%.2f", var4_9.totalBidPrice == 0 and 0 or var4_9.totalCollectionPrice / var4_9.totalBidPrice))
	setText(arg0_9.uiCurrencyText, StringHelper.ForamtNumberK(var4_9.gold))
	setText(arg0_9.uiTotalProfitText, StringHelper.ForamtNumberK(var4_9.totalProfit))
	setText(arg0_9.uiHighestProfitText, StringHelper.ForamtNumberK(var4_9.highestProfit))
	setText(arg0_9.uiCollectionText, string.format("<color=#393a3c>%s/</color>%s", var4_9.unlockCollectionCnt, #pg.auction_collection.all))
	setText(arg0_9.uiCollectionPriceText, StringHelper.ForamtNumberK(var4_9.totalCollectionPrice))

	local var6_9 = var1_9:GetShipPhantomMarks()[1]

	arg0_9.shipVO = getProxy(BayProxy):GetShipPhantom(var6_9)

	setPaintingPrefabAsync(arg0_9.uiPaintingTf, arg0_9.shipVO:getPainting(), "biandui", nil, {
		skinID = arg0_9.shipVO:getSkinId(),
		rotateZ = arg0_9.paintingDefaultAngle.z
	})
	GetImageSpriteFromAtlasAsync("SquareIcon/" .. arg0_9.shipVO:getPainting(), "", arg0_9.uiIcon)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildNameCard(0, var1_9.id))
end

function var0_0.willExit(arg0_10)
	retPaintingPrefab(arg0_10.uiPaintingTf, arg0_10.shipVO:getPainting())
	arg0_10:UnOverlayPanel(arg0_10._tf)
end

return var0_0
