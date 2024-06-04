local var0 = class("EducateGetEventsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27014, {
		type = 0
	}, 27015, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):GetEventProxy():SetHomeEventData(arg0.events)

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger specEvent error: ", arg0.result))
		end
	end)
end

return var0
