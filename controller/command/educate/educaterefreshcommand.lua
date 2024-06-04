local var0 = class("EducateRefreshCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27047, {
		type = 1
	}, 27048, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):Refresh(function()
				arg0:sendNotification(GAME.EDUCATE_REFRESH_DONE)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate refresh error: ", arg0.result))
		end
	end)
end

return var0
