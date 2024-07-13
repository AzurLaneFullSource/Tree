local var0_0 = class("SetSecondaryPasswordCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.UIMgr.GetInstance():LoadingOn()
	pg.ConnectionMgr.GetInstance():Send(11605, {
		password = var0_1.pwd,
		notice = var0_1.tip,
		system_list = var0_1.settings
	}, 11606, function(arg0_2)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0_2.result == 0 then
			getProxy(SecondaryPWDProxy):OnFirstSet(var0_1)
		end

		arg0_1:sendNotification(GAME.SET_PASSWORD_DONE, arg0_2)
	end)
end

return var0_0
