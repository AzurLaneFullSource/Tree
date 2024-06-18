local var0_0 = class("LimitChallengeProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:initData()
end

function var0_0.initData(arg0_2)
	arg0_2.passTimeDict = {}
	arg0_2.awardedDict = {}
	arg0_2.curMonthPassedIDList = {}
end

function var0_0.setTimeDataFromServer(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3) do
		local var0_3 = iter1_3.key
		local var1_3 = iter1_3.value

		arg0_3.passTimeDict[var0_3] = var1_3
	end
end

function var0_0.setAwardedDataFromServer(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg1_4) do
		local var0_4 = iter1_4.key
		local var1_4 = iter1_4.value > 0

		arg0_4.awardedDict[var0_4] = var1_4
	end
end

function var0_0.setCurMonthPassedIDList(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5) do
		table.insert(arg0_5.curMonthPassedIDList, iter1_5)
	end
end

function var0_0.setPassTime(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.passTimeDict[arg1_6]

	if not var0_6 then
		arg0_6.passTimeDict[arg1_6] = arg2_6
	elseif arg2_6 < var0_6 then
		arg0_6.passTimeDict[arg1_6] = arg2_6

		arg0_6:sendNotification(LimitChallengeConst.UPDATE_PASS_TIME)
	end

	if not table.contains(arg0_6.curMonthPassedIDList, arg1_6) then
		table.insert(arg0_6.curMonthPassedIDList, arg1_6)
	end
end

function var0_0.setAwarded(arg0_7, arg1_7)
	arg0_7.awardedDict[arg1_7] = true
end

function var0_0.getPassTimeByChallengeID(arg0_8, arg1_8)
	return arg0_8.passTimeDict[arg1_8]
end

function var0_0.getMissAwardChallengeIDLIst(arg0_9)
	local var0_9 = {}
	local var1_9 = LimitChallengeConst.GetCurMonthConfig().stage

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = table.contains(arg0_9.curMonthPassedIDList, iter1_9)
		local var3_9 = arg0_9:isAwardedByChallengeID(iter1_9)

		if var2_9 and not var3_9 then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.isAwardedByChallengeID(arg0_10, arg1_10)
	return arg0_10.awardedDict[arg1_10]
end

function var0_0.isLevelUnlock(arg0_11, arg1_11)
	if arg1_11 == 1 then
		return true
	end

	if arg1_11 > 1 then
		local var0_11 = LimitChallengeConst.GetChallengeIDByLevel(arg1_11 - 1)

		return arg0_11.awardedDict[var0_11]
	end
end

return var0_0
