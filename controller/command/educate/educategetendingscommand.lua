local var0 = class("EducateGetEndingsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27010, {
		type = 0
	}, 27011, function(arg0)
		if arg0.endings then
			getProxy(EducateProxy):SetEndings(arg0.endings)
			arg0:sendNotification(GAME.EDUCATE_GET_ENDINGS_DONE)

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate get endings error: ", arg0.result))
		end
	end)
end

return var0
