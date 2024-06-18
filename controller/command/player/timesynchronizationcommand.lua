local var0_0 = class("TimeSynchronizationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.TimeMgr.GetInstance():SetServerTime(var0_1.timestamp, var0_1.monday_0oclock_timestamp)
	getProxy(BuildShipProxy):setBuildShipState()

	local var1_1 = getProxy(PlayerProxy)

	if var1_1:getData() then
		var1_1:flushTimesListener()
	end

	local var2_1 = getProxy(MilitaryExerciseProxy)

	if var2_1:getSeasonInfo() then
		var2_1:addRefreshCountTimer()
		var2_1:addSeasonOverTimer()
	end
end

return var0_0
