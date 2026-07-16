local var0_0 = class("AuctionGameEmojiCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23413, {
		expression_id = var0_1
	}, 23414, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(AuctionGameProxy):SetSendEmojiTimestamp(pg.TimeMgr.GetInstance():GetServerTime())
			arg0_1:sendNotification(GAME.AUCTION_GAME_EMOJI_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
