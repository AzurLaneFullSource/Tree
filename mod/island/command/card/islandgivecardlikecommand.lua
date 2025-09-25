local var0_0 = class("IslandGiveCardLikeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.userId
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21334, {
		user_id = var1_1
	}, 21335, function(arg0_2)
		if arg0_2.result == 0 then
			existCall(var2_1)
			arg0_1:sendNotification(GAME.ISLAND_GIVE_CARD_LIKE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
