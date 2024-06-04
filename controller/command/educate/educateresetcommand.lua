local var0 = class("EducateResetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27029, {
		type = 1
	}, 27030, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):Reset(function()
				arg0:sendNotification(GAME.EDUCATE_REFRESH_DONE)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate reset error: ", arg0.result))
		end
	end)
end

return var0
