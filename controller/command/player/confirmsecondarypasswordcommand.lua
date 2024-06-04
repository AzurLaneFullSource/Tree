local var0 = class("ConfirmSecondaryPasswordCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.UIMgr.GetInstance():LoadingOn()
	pg.ConnectionMgr.GetInstance():Send(11609, {
		password = var0.pwd
	}, 11610, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0.result == 0 then
			local var0 = getProxy(SecondaryPWDProxy):getRawData()

			var0.state = 2
			var0.fail_cd = nil
			var0.fail_count = 0
		end

		arg0:sendNotification(GAME.CONFIRM_PASSWORD_DONE, arg0)
	end)
end

return var0
