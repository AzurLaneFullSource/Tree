local var0_0 = class("IslandItemIllustration", import(".IslandIllustration"))

function var0_0.GetReachPoints(arg0_1)
	local var0_1 = underscore.reduce(arg0_1:getConfig("collect_star"), 0, function(arg0_2, arg1_2)
		return arg0_2 + (arg0_1.historyCount >= arg1_2[1] and arg1_2[2] or 0)
	end)

	return arg0_1.basePoint + var0_1
end

function var0_0.CheckTip(arg0_3)
	if arg0_3.status == var0_0.STATUS.CAN_UNLOCK then
		arg0_3.isTip = true

		return
	end

	arg0_3.isTip = arg0_3:GetReachPoints() > arg0_3:GetPoints()
end

function var0_0.SetHistoryCnt(arg0_4, arg1_4)
	arg0_4.historyCount = arg1_4

	arg0_4:CheckTip()
end

function var0_0.GetHistoryCnt(arg0_5)
	return arg0_5.historyCount
end

function var0_0.AddHistoryCnt(arg0_6, arg1_6)
	arg0_6.historyCount = arg0_6.historyCount + arg1_6
end

function var0_0.GetCurPhase(arg0_7)
	local var0_7 = arg0_7:getConfig("collect_star")
	local var1_7 = 0

	for iter0_7, iter1_7 in ipairs(var0_7) do
		if arg0_7.starPointGotData[iter1_7[1]] then
			var1_7 = iter0_7
		end
	end

	return var1_7
end

function var0_0.GetCurTarget(arg0_8)
	local var0_8 = arg0_8:getConfig("collect_star")

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if not arg0_8.starPointGotData[iter1_8[1]] then
			return iter1_8[1]
		end
	end

	return nil
end

return var0_0
