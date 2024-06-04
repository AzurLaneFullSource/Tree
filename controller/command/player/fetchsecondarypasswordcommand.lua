local var0 = class("FetchSecondaryPasswordCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.UIMgr.GetInstance():LoadingOn()
	pg.ConnectionMgr.GetInstance():Send(11603, {
		type = 1
	}, 11604, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()
		getProxy(SecondaryPWDProxy):SetData(arg0)
		arg0:sendNotification(GAME.FETCH_PASSWORD_STATE_DONE, arg0)
	end)
end

return var0
