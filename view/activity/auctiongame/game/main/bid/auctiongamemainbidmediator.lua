local var0_0 = class("AuctionGameMainBidMediator", import("view.base.ContextMediator"))

var0_0.BID = "AuctionGameMainBidMediator::BID"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.BID, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AUCTION_GAME_BID, arg1_2)
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.AUCTION_GAME_ROUND_OVER] = function(arg0_4, arg1_4)
			local var0_4 = getProxy(AuctionGameProxy)
			local var1_4 = pg.gameset.auction_bid_time.key_value

			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionBid(var0_4:GetAuctionID(), var0_4:GetRound(), var1_4, 0, 1))
			arg0_4.viewComponent:closeView()
		end,
		[GAME.AUCTION_GAME_BID_DONE] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:closeView()
		end
	}
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
