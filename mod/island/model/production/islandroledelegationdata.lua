local var0_0 = class("IslandRoleDelegationData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdateData(arg1_1)
end

function var0_0.UpdateData(arg0_2, arg1_2)
	arg0_2.ship_id = arg1_2.ship_id
	arg0_2.max_times = arg1_2.max_times
	arg0_2.get_times = arg1_2.get_times
	arg0_2.formula_id = arg1_2.formula_id
	arg0_2.start_time = arg1_2.start_time

	arg0_2:SetCostList(arg1_2.cost_time_list)

	arg0_2.once_cost_power = arg1_2.once_cost_power
	arg0_2.speed_time = arg1_2.speed_time or 0

	arg0_2:SetIsSend(false)
end

function var0_0.ResetGetTimes(arg0_3, arg1_3)
	arg0_3.get_times = arg0_3.get_times + arg1_3
end

function var0_0.AddCostList(arg0_4, arg1_4)
	local var0_4 = #arg0_4.cost_time_list
	local var1_4 = var0_4 == 0 and 0 or arg0_4.cost_time_list[var0_4]
	local var2_4 = 0

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		table.insert(arg0_4.cost_time_list, iter1_4)

		arg0_4.cost_Alltime_list[var0_4 + iter0_4] = iter1_4 + var1_4 + var2_4
		var2_4 = iter1_4 + var2_4
	end

	arg0_4.end_time = arg0_4.end_time + var2_4
	arg0_4.allTime = arg0_4.allTime + var2_4
end

function var0_0.SetCostList(arg0_5, arg1_5)
	arg0_5.cost_time_list = arg1_5
	arg0_5.cost_Alltime_list = {}

	local var0_5 = 0

	for iter0_5, iter1_5 in ipairs(arg0_5.cost_time_list) do
		arg0_5.cost_Alltime_list[iter0_5] = iter1_5 + var0_5
		var0_5 = var0_5 + iter1_5
	end

	arg0_5.end_time = arg0_5.start_time

	for iter2_5, iter3_5 in ipairs(arg0_5.cost_time_list) do
		arg0_5.end_time = arg0_5.end_time + iter3_5
	end

	arg0_5.allTime = arg0_5.end_time - arg0_5.start_time
end

function var0_0.AddSpeedTime(arg0_6, arg1_6)
	arg0_6.speed_time = arg0_6.speed_time + arg1_6
end

function var0_0.isEnd(arg0_7)
	return arg0_7.end_time > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_7.end_time + 1
end

function var0_0.GetFinishTime(arg0_8)
	return arg0_8.end_time
end

function var0_0.GetAllTime(arg0_9)
	return arg0_9.allTime
end

function var0_0.isSend(arg0_10)
	return arg0_10.issend
end

function var0_0.SetIsSend(arg0_11, arg1_11)
	arg0_11.issend = arg1_11
end

function var0_0.InCurrentTime(arg0_12)
	local var0_12 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_12.start_time

	for iter0_12, iter1_12 in ipairs(arg0_12.cost_Alltime_list) do
		if var0_12 <= iter1_12 then
			return iter0_12
		end
	end

	return #arg0_12.cost_Alltime_list
end

function var0_0.GetCountByTimestamp(arg0_13, arg1_13)
	local var0_13 = arg1_13 - arg0_13.start_time

	for iter0_13 = #arg0_13.cost_Alltime_list, 1, -1 do
		if var0_13 >= arg0_13.cost_Alltime_list[iter0_13] then
			return iter0_13
		end
	end

	return 0
end

function var0_0.InCurrentTimeStart(arg0_14, arg1_14)
	local var0_14 = 0
	local var1_14 = arg1_14 - 1

	for iter0_14 = 1, var1_14 do
		var0_14 = var0_14 + arg0_14.cost_time_list[iter0_14]
	end

	return var0_14 + arg0_14.start_time
end

function var0_0.CurrentTimeNeed(arg0_15, arg1_15)
	return arg0_15.cost_time_list[arg1_15]
end

function var0_0.CheckDelegationIsEnd(arg0_16)
	if not arg0_16:isSend() and arg0_16:isEnd() then
		return true
	end
end

function var0_0.CanRewardTimes(arg0_17)
	return arg0_17:InCurrentTime() - 1 - arg0_17.get_times
end

function var0_0.LastTimes(arg0_18)
	return #arg0_18.cost_time_list - (arg0_18:InCurrentTime() - 1)
end

return var0_0
