local var0 = class("EducateRequestOptionCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27045, {
		type = 1
	}, 27046, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):initRandomOpts(arg0.opts)
			arg0:sendNotification(GAME.EDUCATE_REQUEST_OPTION_DONE)

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate request option data error: ", arg0.result))
		end
	end)
end

return var0
