local var0_0 = class("ConfirmSecondaryPasswordCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.UIMgr.GetInstance():LoadingOn()
	pg.ConnectionMgr.GetInstance():Send(11609, {
		password = var0_1.pwd
	}, 11610, function(arg0_2)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0_2.result == 0 then
			local var0_2 = getProxy(SecondaryPWDProxy):getRawData()

			var0_2.state = 2
			var0_2.fail_cd = nil
			var0_2.fail_count = 0
		end

		arg0_1:sendNotification(GAME.CONFIRM_PASSWORD_DONE, arg0_2)
	end)
end

return var0_0
