local var0_0 = class("AuctionGameOpenBoxCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23422, {
		arg = 1
	}, 23423, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(AuctionGameBaseProxy):UpdateSettlementData(arg0_2)
			arg0_1:sendNotification(GAME.AUCTION_GAME_OPEN_BOX_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
