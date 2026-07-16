local var0_0 = class("AuctionGameForfeitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23409, {
		arg = 1
	}, 23410, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(AuctionGameProxy):SetForfeit(true)
			arg0_1:sendNotification(GAME.AUCTION_GAME_FORFEIT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
