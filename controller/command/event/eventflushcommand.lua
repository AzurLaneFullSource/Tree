local var0_0 = class("EventFlushCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(13009, {
		type = 0
	}, 13010, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EventProxy):updateNightInfo(arg0_2.collection_list)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("event_flush_fail", arg0_2.result))
		end
	end)
end

return var0_0
