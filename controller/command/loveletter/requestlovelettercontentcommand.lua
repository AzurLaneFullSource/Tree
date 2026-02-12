local var0_0 = class("RequestLoveLetterContentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(12410, {
		letter_id = var1_1
	}, 12411, function(arg0_2)
		getProxy(LoveLetterProxy):RecordLoveLetterContent(var1_1, arg0_2.content)
		existCall(var2_1)
		pg.m02:sendNotification(GAME.REQUEST_LOVE_LETTER_TEXT_DONE, {
			letterId = var1_1
		})
	end)
end

return var0_0
