local var0 = class("LimitChallengeProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0:initData()
end

function var0.initData(arg0)
	arg0.passTimeDict = {}
	arg0.awardedDict = {}
	arg0.curMonthPassedIDList = {}
end

function var0.setTimeDataFromServer(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.key
		local var1 = iter1.value

		arg0.passTimeDict[var0] = var1
	end
end

function var0.setAwardedDataFromServer(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.key
		local var1 = iter1.value > 0

		arg0.awardedDict[var0] = var1
	end
end

function var0.setCurMonthPassedIDList(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.curMonthPassedIDList, iter1)
	end
end

function var0.setPassTime(arg0, arg1, arg2)
	local var0 = arg0.passTimeDict[arg1]

	if not var0 then
		arg0.passTimeDict[arg1] = arg2
	elseif arg2 < var0 then
		arg0.passTimeDict[arg1] = arg2

		arg0:sendNotification(LimitChallengeConst.UPDATE_PASS_TIME)
	end

	if not table.contains(arg0.curMonthPassedIDList, arg1) then
		table.insert(arg0.curMonthPassedIDList, arg1)
	end
end

function var0.setAwarded(arg0, arg1)
	arg0.awardedDict[arg1] = true
end

function var0.getPassTimeByChallengeID(arg0, arg1)
	return arg0.passTimeDict[arg1]
end

function var0.getMissAwardChallengeIDLIst(arg0)
	local var0 = {}
	local var1 = LimitChallengeConst.GetCurMonthConfig().stage

	for iter0, iter1 in ipairs(var1) do
		local var2 = table.contains(arg0.curMonthPassedIDList, iter1)
		local var3 = arg0:isAwardedByChallengeID(iter1)

		if var2 and not var3 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.isAwardedByChallengeID(arg0, arg1)
	return arg0.awardedDict[arg1]
end

function var0.isLevelUnlock(arg0, arg1)
	if arg1 == 1 then
		return true
	end

	if arg1 > 1 then
		local var0 = LimitChallengeConst.GetChallengeIDByLevel(arg1 - 1)

		return arg0.awardedDict[var0]
	end
end

return var0
