local var0_0 = class("IslandRoleDelegationData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdateData(arg1_1)
end

function var0_0.UpdateData(arg0_2, arg1_2)
	arg0_2.ship_id = arg1_2.ship_id
	arg0_2.formula_id = arg1_2.formula_id
	arg0_2.start_time = arg1_2.start_time

	arg0_2:SetCostList(arg1_2.cost_time_list)

	arg0_2.extraList = arg1_2.times_extra or {}
	arg0_2.once_cost_power = arg1_2.once_cost_power
	arg0_2.speed_time = arg1_2.speed_time or 0

	arg0_2:SetIsSend(false)
end

function var0_0.AddExtraList(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3) do
		table.insert(arg0_3.extraList, iter1_3)
	end
end

function var0_0.GetExtraMainProduct(arg0_4, arg1_4)
	return arg0_4.extraList[arg1_4] and arg0_4.extraList[arg1_4].main_extra or 0
end

function var0_0.GetExtraExtraProduct(arg0_5, arg1_5)
	return arg0_5.extraList[arg1_5] and arg0_5.extraList[arg1_5].other_extra or 0
end

function var0_0.GetExtraExtraCost(arg0_6, arg1_6)
	return arg0_6.extraList[arg1_6] and arg0_6.extraList[arg1_6].cost_extra or 0
end

function var0_0.AddCostList(arg0_7, arg1_7)
	local var0_7 = #arg0_7.cost_time_list
	local var1_7 = var0_7 == 0 and 0 or arg0_7.cost_time_list[var0_7]
	local var2_7 = 0

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		table.insert(arg0_7.cost_time_list, iter1_7)

		arg0_7.cost_Alltime_list[var0_7 + iter0_7] = iter1_7 + var1_7 + var2_7
		var2_7 = iter1_7 + var2_7
	end

	arg0_7.end_time = arg0_7.end_time + var2_7
	arg0_7.allTime = arg0_7.allTime + var2_7
end

function var0_0.SetCostList(arg0_8, arg1_8)
	arg0_8.cost_time_list = arg1_8
	arg0_8.cost_Alltime_list = {}

	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.cost_time_list) do
		arg0_8.cost_Alltime_list[iter0_8] = iter1_8 + var0_8
		var0_8 = var0_8 + iter1_8
	end

	arg0_8.end_time = arg0_8.start_time

	for iter2_8, iter3_8 in ipairs(arg0_8.cost_time_list) do
		arg0_8.end_time = arg0_8.end_time + iter3_8
	end

	arg0_8.allTime = arg0_8.end_time - arg0_8.start_time
end

function var0_0.AddSpeedTime(arg0_9, arg1_9)
	arg0_9.speed_time = arg0_9.speed_time + arg1_9
end

function var0_0.isEnd(arg0_10)
	return arg0_10.end_time > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_10.end_time + 1
end

function var0_0.GetFinishTime(arg0_11)
	return arg0_11.end_time
end

function var0_0.GetAllTime(arg0_12)
	return arg0_12.allTime
end

function var0_0.isSend(arg0_13)
	return arg0_13.issend
end

function var0_0.SetIsSend(arg0_14, arg1_14)
	arg0_14.issend = arg1_14
end

function var0_0.InCurrentTime(arg0_15)
	local var0_15 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_15.start_time

	for iter0_15, iter1_15 in ipairs(arg0_15.cost_Alltime_list) do
		if var0_15 <= iter1_15 then
			return iter0_15
		end
	end

	return #arg0_15.cost_Alltime_list
end

function var0_0.GetCountByTimestamp(arg0_16, arg1_16)
	local var0_16 = arg1_16 - arg0_16.start_time

	for iter0_16 = #arg0_16.cost_Alltime_list, 1, -1 do
		if var0_16 >= arg0_16.cost_Alltime_list[iter0_16] then
			return iter0_16
		end
	end

	return 0
end

function var0_0.InCurrentTimeStart(arg0_17, arg1_17)
	local var0_17 = 0
	local var1_17 = arg1_17 - 1

	for iter0_17 = 1, var1_17 do
		var0_17 = var0_17 + arg0_17.cost_time_list[iter0_17]
	end

	return var0_17 + arg0_17.start_time
end

function var0_0.CurrentTimeNeed(arg0_18, arg1_18)
	return arg0_18.cost_time_list[arg1_18]
end

function var0_0.CheckDelegationIsEnd(arg0_19)
	if not arg0_19:isSend() and arg0_19:isEnd() then
		return true
	end
end

function var0_0.CanRewardTimes(arg0_20)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_20.end_time then
		return #arg0_20.cost_time_list
	end

	return arg0_20:InCurrentTime() - 1
end

function var0_0.GetCurrentCanRewardExtraMainNum(arg0_21)
	local var0_21 = arg0_21:InCurrentTime() - 1
	local var1_21 = 0

	for iter0_21 = 1, var0_21 do
		var1_21 = var1_21 + arg0_21:GetExtraMainProduct(iter0_21)
	end

	return var1_21
end

function var0_0.GetReturnExtraNum(arg0_22, arg1_22)
	local var0_22 = #arg0_22.cost_time_list - arg1_22 + 1
	local var1_22 = 0

	for iter0_22 = #arg0_22.cost_time_list, var0_22, -1 do
		var1_22 = var1_22 + arg0_22:GetExtraExtraCost(iter0_22)
	end

	return var1_22
end

function var0_0.LastTimes(arg0_23)
	return #arg0_23.cost_time_list - (arg0_23:InCurrentTime() - 1)
end

function var0_0.OnGetAwardMidway(arg0_24, arg1_24, arg2_24, arg3_24)
	arg0_24.start_time = arg1_24

	arg0_24:SetCostList(arg2_24)

	for iter0_24 = 1, arg3_24 do
		table.remove(arg0_24.extraList, 1)
	end
end

return var0_0
