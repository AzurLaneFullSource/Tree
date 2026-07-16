AuctionGameMainBidLayer = import("view.activity.AuctionGame.game.main.bid.AuctionGameMainBidLayer")

local var0_0 = class("AuctionGameMainBidGuideLayer", AuctionGameMainBidLayer)

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)
	onButton(arg0_1, arg0_1.uiCloseBtn, function()
		return
	end, SOUND_BACK)
	onButton(arg0_1, arg0_1.uiBidBtn, function()
		if arg0_1.startBid == true then
			return
		end

		local var0_3 = arg0_1.inputNum

		if arg0_1.bided then
			return
		end

		local var1_3 = getProxy(AuctionGameProxy)

		if var1_3:GetAuctionState() ~= AuctionGameConst.AUCTION_PHASE.BID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_wait_bid_phase"))
			pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_5")

			return
		end

		local var2_3 = pg.auction_session[var1_3:GetAuctionID()].bottom_price

		if var0_3 < var2_3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_min_bid", var2_3))
			pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_5")

			return
		end

		if var0_3 > getProxy(AuctionGameBaseProxy).gold then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_exceeds_max_value"))
			pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_5")

			return
		end

		arg0_1.startBid = true

		quickPlayAnimation(arg0_1.uiBidAnimationTf, "Anim_AuctionGameEntranceUI_matchBtn_click")
	end, AuctionGameConst.SOUND_EFFECT.BID)
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)

	local var0_4 = getProxy(AuctionGameProxy):GetRound()

	if var0_4 == 1 then
		-- block empty
	elseif var0_4 >= 2 then
		arg0_4.inputNum = 100000
	end

	arg0_4:RefreshUI()
end

function var0_0.OnClickBidBtn(arg0_5)
	local var0_5 = arg0_5.inputNum

	if getProxy(AuctionGameProxy):GetRound() == 1 then
		AuctionGameTools.GuideBided(var0_5)
	else
		AuctionGameTools.GuideBided2(var0_5)
	end
end

return var0_0
