local var0_0 = class("GetAllLoveLetterLevelDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(12406, {
		type = 0
	}, 12407, function(arg0_2)
		getProxy(LoveLetterProxy):SetGroupList(arg0_2)
		existCall(var0_1.callback)
		pg.m02:sendNotification(GAME.GET_ALL_LOVE_LETTER_DATA_DONE)
	end)
end

return var0_0
