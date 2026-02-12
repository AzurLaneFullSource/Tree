local var0_0 = class("RealizeLoveLetterGiftCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().list

	pg.ConnectionMgr.GetInstance():Send(12404, {
		item_list = var0_1
	}, 12405, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(LoveLetterProxy):UpdateRealizeGift(var0_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveactivity_ui_17"))
			pg.m02:sendNotification(GAME.REALIZE_LOVE_LETTER_GIFT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
