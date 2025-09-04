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
	arg0_2.cost_time_list = arg1_2.cost_time_list
	arg0_2.end_time = arg0_2.start_time

	for iter0_2, iter1_2 in ipairs(arg0_2.cost_time_list) do
		arg0_2.end_time = arg0_2.end_time + iter1_2
	end

	arg0_2.cost_Alltime_list = {}

	local var0_2 = 0

	for iter2_2, iter3_2 in ipairs(arg0_2.cost_time_list) do
		arg0_2.cost_Alltime_list[iter2_2] = iter3_2 + var0_2
		var0_2 = var0_2 + iter3_2
	end

	arg0_2.once_cost_power = arg1_2.once_cost_power
	arg0_2.item_times = arg1_2.item_times or 0
	arg0_2.allTime = arg0_2.end_time - arg0_2.start_time

	arg0_2:SetIsSend(false)
end

function var0_0.ResetGetTimes(arg0_3, arg1_3)
	arg0_3.get_times = arg0_3.get_times + arg1_3
end

function var0_0.ResetItem_times(arg0_4, arg1_4)
	arg0_4.item_times = arg1_4
end

function var0_0.isEnd(arg0_5)
	return arg0_5.end_time > 0 and pg.TimeMgr.GetInstance():GetServerTime() + arg0_5.item_times >= arg0_5.end_time + 1
end

function var0_0.GetFinishTime(arg0_6)
	return arg0_6.end_time - arg0_6.item_times
end

function var0_0.GetAllTime(arg0_7)
	return arg0_7.allTime
end

function var0_0.isSend(arg0_8)
	return arg0_8.issend
end

function var0_0.SetIsSend(arg0_9, arg1_9)
	arg0_9.issend = arg1_9
end

function var0_0.InCurrentTime(arg0_10)
	local var0_10 = pg.TimeMgr.GetInstance():GetServerTime() + arg0_10.item_times - arg0_10.start_time

	for iter0_10, iter1_10 in ipairs(arg0_10.cost_Alltime_list) do
		if var0_10 <= iter1_10 then
			return iter0_10
		end
	end

	return #arg0_10.cost_Alltime_list
end

function var0_0.InCurrentTimeStart(arg0_11, arg1_11)
	local var0_11 = 0
	local var1_11 = arg1_11 - 1

	for iter0_11 = 1, var1_11 do
		var0_11 = var0_11 + arg0_11.cost_time_list[iter0_11]
	end

	return var0_11 + arg0_11.start_time
end

function var0_0.CurrentTimeNeed(arg0_12, arg1_12)
	return arg0_12.cost_time_list[arg1_12]
end

function var0_0.CheckDelegationIsEnd(arg0_13)
	if not arg0_13:isSend() and arg0_13:isEnd() then
		return true
	end
end

function var0_0.CanRewardTimes(arg0_14)
	return arg0_14:InCurrentTime() - 1 - arg0_14.get_times
end

return var0_0
