local var0_0 = class("RefluxRequestDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1)
	pg.ConnectionMgr.GetInstance():Send(11751, {
		type = 0
	}, 11752, function(arg0_2)
		getProxy(RefluxProxy):setData(arg0_2)
	end)
end

return var0_0
