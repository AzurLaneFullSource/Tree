local var0_0 = class("EducateRefreshCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27047, {
		type = 1
	}, 27048, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):Refresh(function()
				arg0_1:sendNotification(GAME.EDUCATE_REFRESH_DONE)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate refresh error: ", arg0_2.result))
		end
	end)
end

return var0_0
