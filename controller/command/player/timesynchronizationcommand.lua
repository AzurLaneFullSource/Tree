local var0 = class("TimeSynchronizationCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.TimeMgr.GetInstance():SetServerTime(var0.timestamp, var0.monday_0oclock_timestamp)
	getProxy(BuildShipProxy):setBuildShipState()

	local var1 = getProxy(PlayerProxy)

	if var1:getData() then
		var1:flushTimesListener()
	end

	local var2 = getProxy(MilitaryExerciseProxy)

	if var2:getSeasonInfo() then
		var2:addRefreshCountTimer()
		var2:addSeasonOverTimer()
	end
end

return var0
