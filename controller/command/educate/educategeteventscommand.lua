local var0_0 = class("EducateGetEventsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27014, {
		type = 0
	}, 27015, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):GetEventProxy():SetHomeEventData(arg0_2.events)

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger specEvent error: ", arg0_2.result))
		end
	end)
end

return var0_0
