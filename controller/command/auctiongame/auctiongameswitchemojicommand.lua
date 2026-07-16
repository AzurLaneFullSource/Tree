local var0_0 = class("AuctionGameSwitchEmojiCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(AuctionGameProxy)
	local var2_1 = var1_1:GetSwitchEmojiFlag() == 0 and 1 or 0

	pg.ConnectionMgr.GetInstance():Send(23416, {
		switch = var2_1
	}, 23417, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:SetSwitchEmojiFlag(var2_1)
			arg0_1:sendNotification(GAME.AUCTION_GAME_SWITCH_EMOJI_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
