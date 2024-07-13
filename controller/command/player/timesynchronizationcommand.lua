local var0_0 = class("TimeSynchronizationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.TimeMgr.GetInstance():SetServerTime(var0_1.timestamp, var0_1.monday_0oclock_timestamp)
	getProxy(BuildShipProxy):setBuildShipState()
end

return var0_0
