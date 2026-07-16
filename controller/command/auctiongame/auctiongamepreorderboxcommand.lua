local var0_0 = class("AuctionGamePreorderBoxCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23420, {
		arg = 1
	}, 23421, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(AuctionGameBaseProxy)

			var0_2:SetOrderTimestamp(arg0_2.timestamp)
			var0_2:AddGold(AuctionGameTools.GetPreorderCurrentyCnt() * -1)
			arg0_1:sendNotification(GAME.AUCTION_GAME_PREORDER_BOX_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
