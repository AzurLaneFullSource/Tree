local var0_0 = class("UnlockLoveLetterCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = pg.lover_letter_content[var0_1]

	if not getProxy(LoveLetterProxy):GetGroupData(var1_1.ship_group):CanUnlockLetter(var0_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12400, {
		id = var0_1
	}, 12401, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(LoveLetterProxy):UnlockLetter(var1_1.ship_group, var0_1)
			pg.m02:sendNotification(GAME.UNLOCK_LOVE_LETTER_DONE, {
				letterId = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
