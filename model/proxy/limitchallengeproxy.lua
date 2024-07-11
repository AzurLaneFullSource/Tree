local var0_0 = class("LimitChallengeProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:initData()
end

function var0_0.timeCall(arg0_2)
	return {
		[ProxyRegister.DayCall] = function(arg0_3)
			LimitChallengeConst.RequestInfo()
		end
	}
end

function var0_0.initData(arg0_4)
	arg0_4.passTimeDict = {}
	arg0_4.awardedDict = {}
	arg0_4.curMonthPassedIDList = {}
end

function var0_0.setTimeDataFromServer(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5) do
		local var0_5 = iter1_5.key
		local var1_5 = iter1_5.value

		arg0_5.passTimeDict[var0_5] = var1_5
	end
end

function var0_0.setAwardedDataFromServer(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg1_6) do
		local var0_6 = iter1_6.key
		local var1_6 = iter1_6.value > 0

		arg0_6.awardedDict[var0_6] = var1_6
	end
end

function var0_0.setCurMonthPassedIDList(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg1_7) do
		table.insert(arg0_7.curMonthPassedIDList, iter1_7)
	end
end

function var0_0.setPassTime(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.passTimeDict[arg1_8]

	if not var0_8 then
		arg0_8.passTimeDict[arg1_8] = arg2_8
	elseif arg2_8 < var0_8 then
		arg0_8.passTimeDict[arg1_8] = arg2_8

		arg0_8:sendNotification(LimitChallengeConst.UPDATE_PASS_TIME)
	end

	if not table.contains(arg0_8.curMonthPassedIDList, arg1_8) then
		table.insert(arg0_8.curMonthPassedIDList, arg1_8)
	end
end

function var0_0.setAwarded(arg0_9, arg1_9)
	arg0_9.awardedDict[arg1_9] = true
end

function var0_0.getPassTimeByChallengeID(arg0_10, arg1_10)
	return arg0_10.passTimeDict[arg1_10]
end

function var0_0.getMissAwardChallengeIDLIst(arg0_11)
	local var0_11 = {}
	local var1_11 = LimitChallengeConst.GetCurMonthConfig().stage

	for iter0_11, iter1_11 in ipairs(var1_11) do
		local var2_11 = table.contains(arg0_11.curMonthPassedIDList, iter1_11)
		local var3_11 = arg0_11:isAwardedByChallengeID(iter1_11)

		if var2_11 and not var3_11 then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.isAwardedByChallengeID(arg0_12, arg1_12)
	return arg0_12.awardedDict[arg1_12]
end

function var0_0.isLevelUnlock(arg0_13, arg1_13)
	if arg1_13 == 1 then
		return true
	end

	if arg1_13 > 1 then
		local var0_13 = LimitChallengeConst.GetChallengeIDByLevel(arg1_13 - 1)

		return arg0_13.awardedDict[var0_13]
	end
end

return var0_0
