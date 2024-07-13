local var0_0 = class("FetchSecondaryPasswordCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.UIMgr.GetInstance():LoadingOn()
	pg.ConnectionMgr.GetInstance():Send(11603, {
		type = 1
	}, 11604, function(arg0_2)
		pg.UIMgr.GetInstance():LoadingOff()
		getProxy(SecondaryPWDProxy):SetData(arg0_2)
		arg0_1:sendNotification(GAME.FETCH_PASSWORD_STATE_DONE, arg0_2)
	end)
end

return var0_0
