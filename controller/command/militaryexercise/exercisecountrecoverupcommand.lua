local var0_0 = class("ExerciseCountRecoverUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local function var0_1()
		local var0_2 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")
		local var1_2 = 3600 * SeasonInfo.RECOVER_UP_SIX_HOUR

		if var0_2.hour == 0 then
			var1_2 = 3600 * SeasonInfo.RECOVER_UP_TWELVE_HOUR
		end

		return var1_2
	end

	local var1_1 = getProxy(MilitaryExerciseProxy)
	local var2_1 = var1_1:getSeasonInfo()

	var2_1:updateResetTime(var0_1() + pg.TimeMgr.GetInstance():GetServerTime())
	var2_1:updateExerciseCount(SeasonInfo.RECOVER_UP_COUNT)
	var1_1:updateSeasonInfo(var2_1)
	var1_1:addRefreshCountTimer()
end

return var0_0
