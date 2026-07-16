local var0_0 = class("AuctionGameEventSelectedIDCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(AuctionGameProxy)

	pg.ConnectionMgr.GetInstance():Send(23402, {
		event_id = var0_1
	}, 23403, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:SetPersonalEventSelectedID(var0_1)
			var1_1:UpdateEventEffect(arg0_2.public_event_effect)
			arg0_1:sendNotification(GAME.AUCTION_GAME_EVENT_SELECTED_ID_DONE, arg0_2)
		elseif arg0_2.result == 12 then
			arg0_1:sendNotification(GAME.AUCTION_GAME_KICK)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0
