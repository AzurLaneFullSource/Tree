local var0_0 = class("EducateResetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27029, {
		type = 1
	}, 27030, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):Reset(function()
				arg0_1:sendNotification(GAME.EDUCATE_REFRESH_DONE)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate reset error: ", arg0_2.result))
		end
	end)
end

return var0_0
