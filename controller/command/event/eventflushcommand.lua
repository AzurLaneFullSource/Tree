local var0 = class("EventFlushCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(13009, {
		type = 0
	}, 13010, function(arg0)
		if arg0.result == 0 then
			getProxy(EventProxy):updateNightInfo(arg0.collection_list)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("event_flush_fail", arg0.result))
		end
	end)
end

return var0
