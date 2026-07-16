local var0_0 = class("AuctionGameMatchingReconnectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23428, {
		arg = 1
	}, 23429, function(arg0_2)
		arg0_1:sendNotification(GAME.AUCTION_GAME_MATCHING_RECONNECT_DONE, arg0_2.state)
	end, false)
end

return var0_0
