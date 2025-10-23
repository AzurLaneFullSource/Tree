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

	arg0_2.extraList = arg1_2.times_extra or {}
	arg0_2.once_cost_power = arg1_2.once_cost_power
	arg0_2.speed_time = arg1_2.speed_time or 0

	arg0_2:SetIsSend(false)
end

function var0_0.ResetGetTimes(arg0_3, arg1_3)
	arg0_3.get_times = arg0_3.get_times + arg1_3
end

function var0_0.AddExtraList(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg1_4) do
		table.insert(arg0_4.extraList, iter1_4)
	end
end

function var0_0.GetExtraMainProduct(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.extraList) do
		if iter1_5.num == arg1_5 then
			return iter1_5.main_extra
		end
	end

	return 0
end

function var0_0.GetExtraExtraProduct(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.extraList) do
		if iter1_6.num == arg1_6 then
			return iter1_6.other_extra
		end
	end

	return 0
end

function var0_0.GetExtraExtraCost(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.extraList) do
		if iter1_7.num == arg1_7 then
			return iter1_7.cost_extra
		end
	end

	return 0
end

function var0_0.AddCostList(arg0_8, arg1_8)
	local var0_8 = #arg0_8.cost_time_list
	local var1_8 = var0_8 == 0 and 0 or arg0_8.cost_time_list[var0_8]
	local var2_8 = 0

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		table.insert(arg0_8.cost_time_list, iter1_8)

		arg0_8.cost_Alltime_list[var0_8 + iter0_8] = iter1_8 + var1_8 + var2_8
		var2_8 = iter1_8 + var2_8
	end

	arg0_8.end_time = arg0_8.end_time + var2_8
	arg0_8.allTime = arg0_8.allTime + var2_8
end

function var0_0.SetCostList(arg0_9, arg1_9)
	arg0_9.cost_time_list = arg1_9
	arg0_9.cost_Alltime_list = {}

	local var0_9 = 0

	for iter0_9, iter1_9 in ipairs(arg0_9.cost_time_list) do
		arg0_9.cost_Alltime_list[iter0_9] = iter1_9 + var0_9
		var0_9 = var0_9 + iter1_9
	end

	arg0_9.end_time = arg0_9.start_time

	for iter2_9, iter3_9 in ipairs(arg0_9.cost_time_list) do
		arg0_9.end_time = arg0_9.end_time + iter3_9
	end

	arg0_9.allTime = arg0_9.end_time - arg0_9.start_time
end

function var0_0.AddSpeedTime(arg0_10, arg1_10)
	arg0_10.speed_time = arg0_10.speed_time + arg1_10
end

function var0_0.isEnd(arg0_11)
	return arg0_11.end_time > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_11.end_time + 1
end

function var0_0.GetFinishTime(arg0_12)
	return arg0_12.end_time
end

function var0_0.GetAllTime(arg0_13)
	return arg0_13.allTime
end

function var0_0.isSend(arg0_14)
	return arg0_14.issend
end

function var0_0.SetIsSend(arg0_15, arg1_15)
	arg0_15.issend = arg1_15
end

function var0_0.InCurrentTime(arg0_16)
	local var0_16 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_16.start_time

	for iter0_16, iter1_16 in ipairs(arg0_16.cost_Alltime_list) do
		if var0_16 <= iter1_16 then
			return iter0_16
		end
	end

	return #arg0_16.cost_Alltime_list
end

function var0_0.GetCountByTimestamp(arg0_17, arg1_17)
	local var0_17 = arg1_17 - arg0_17.start_time

	for iter0_17 = #arg0_17.cost_Alltime_list, 1, -1 do
		if var0_17 >= arg0_17.cost_Alltime_list[iter0_17] then
			return iter0_17
		end
	end

	return 0
end

function var0_0.InCurrentTimeStart(arg0_18, arg1_18)
	local var0_18 = 0
	local var1_18 = arg1_18 - 1

	for iter0_18 = 1, var1_18 do
		var0_18 = var0_18 + arg0_18.cost_time_list[iter0_18]
	end

	return var0_18 + arg0_18.start_time
end

function var0_0.CurrentTimeNeed(arg0_19, arg1_19)
	return arg0_19.cost_time_list[arg1_19]
end

function var0_0.CheckDelegationIsEnd(arg0_20)
	if not arg0_20:isSend() and arg0_20:isEnd() then
		return true
	end
end

function var0_0.CanRewardTimes(arg0_21)
	return arg0_21:InCurrentTime() - 1 - arg0_21.get_times
end

function var0_0.GetCurrentCanRewardExtraMainNum(arg0_22)
	local var0_22 = arg0_22:InCurrentTime() - 1
	local var1_22 = arg0_22.get_times + 1
	local var2_22 = 0

	for iter0_22 = var0_22, var1_22, -1 do
		var2_22 = var2_22 + arg0_22:GetExtraMainProduct(iter0_22)
	end

	return var2_22
end

function var0_0.GetReturnExtraNum(arg0_23, arg1_23)
	local var0_23 = #arg0_23.cost_time_list - arg1_23 + 1
	local var1_23 = 0

	for iter0_23 = #arg0_23.cost_time_list, var0_23, -1 do
		var1_23 = var1_23 + arg0_23:GetExtraExtraCost(iter0_23)
	end

	return var1_23
end

function var0_0.LastTimes(arg0_24)
	return #arg0_24.cost_time_list - (arg0_24:InCurrentTime() - 1)
end

return var0_0
