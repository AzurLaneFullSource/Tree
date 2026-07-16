local var0_0 = class("AuctionGameBidCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23405, {
		price = var0_1
	}, 23406, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(AuctionGameProxy):FinishBid(var0_1)
			arg0_1:sendNotification(GAME.AUCTION_GAME_BID_DONE, var0_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
