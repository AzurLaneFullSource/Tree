local var0 = class("SetSecondaryPasswordSettingsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.UIMgr.GetInstance():LoadingOn()
	pg.ConnectionMgr.GetInstance():Send(11607, {
		password = var0.pwd,
		system_list = var0.settings
	}, 11608, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0.result == 0 then
			getProxy(SecondaryPWDProxy):OnSettingsChange(var0)
		end

		arg0:sendNotification(GAME.SET_PASSWORD_SETTINGS_DONE, arg0)
	end)
end

return var0
