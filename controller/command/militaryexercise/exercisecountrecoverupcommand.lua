local var0 = class("ExerciseCountRecoverUpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local function var0()
		local var0 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")
		local var1 = 3600 * SeasonInfo.RECOVER_UP_SIX_HOUR

		if var0.hour == 0 then
			var1 = 3600 * SeasonInfo.RECOVER_UP_TWELVE_HOUR
		end

		return var1
	end

	local var1 = getProxy(MilitaryExerciseProxy)
	local var2 = var1:getSeasonInfo()

	var2:updateResetTime(var0() + pg.TimeMgr.GetInstance():GetServerTime())
	var2:updateExerciseCount(SeasonInfo.RECOVER_UP_COUNT)
	var1:updateSeasonInfo(var2)
	var1:addRefreshCountTimer()
end

return var0
