local var0_0 = class("IslandGiveCardLabelCommand ", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.userId
	local var2_1 = var0_1.labelId

	pg.ConnectionMgr.GetInstance():Send(21336, {
		user_id = var1_1,
		label_id = var2_1
	}, 21337, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.ISLAND_GIVE_CARD_LABEL_DONE, {
				labelId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
