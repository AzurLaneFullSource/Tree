local var0 = class("RefluxRequestDataCommand", pm.SimpleCommand)

function var0.execute(arg0)
	pg.ConnectionMgr.GetInstance():Send(11751, {
		type = 0
	}, 11752, function(arg0)
		getProxy(RefluxProxy):setData(arg0)
	end)
end

return var0
