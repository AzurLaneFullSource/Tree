local var0_0 = class("EducateRequestOptionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27045, {
		type = 1
	}, 27046, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):initRandomOpts(arg0_2.opts)
			arg0_1:sendNotification(GAME.EDUCATE_REQUEST_OPTION_DONE)

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate request option data error: ", arg0_2.result))
		end
	end)
end

return var0_0
