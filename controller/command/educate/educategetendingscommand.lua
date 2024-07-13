local var0_0 = class("EducateGetEndingsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27010, {
		type = 0
	}, 27011, function(arg0_2)
		if arg0_2.endings then
			getProxy(EducateProxy):SetEndings(arg0_2.endings)
			arg0_1:sendNotification(GAME.EDUCATE_GET_ENDINGS_DONE)

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate get endings error: ", arg0_2.result))
		end
	end)
end

return var0_0
