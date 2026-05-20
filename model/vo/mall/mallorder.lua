local var0_0 = class("MallOrder")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.cur_order
	arg0_1.startTime = arg1_1.active_time

	arg0_1:UpdateEndTime()

	arg0_1.staffList = arg1_1.employee_list
	arg0_1.finishedList = arg1_1.finish_order_list
end

function var0_0.GetEndTime(arg0_2)
	return arg0_2.endTime
end

function var0_0.GetFinishedList(arg0_3)
	return arg0_3.finishedList
end

function var0_0.IsFinishedAll(arg0_4)
	return #arg0_4.finishedList == #pg.activity_mall_custom_order.all
end

function var0_0.GetStaffList(arg0_5)
	return arg0_5.staffList
end

function var0_0.UpdateEndTime(arg0_6)
	if arg0_6.id == 0 or arg0_6.startTime == 0 then
		arg0_6.endTime = 0
	else
		arg0_6.endTime = arg0_6.startTime + pg.activity_mall_custom_order[arg0_6.id].cost_time
	end
end

function var0_0.StartOrder(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.id = arg1_7
	arg0_7.startTime = arg2_7

	arg0_7:UpdateEndTime()

	arg0_7.staffList = arg3_7
end

function var0_0.CompleteOrder(arg0_8, arg1_8)
	table.insert(arg0_8.finishedList, arg1_8)

	arg0_8.id = 0
	arg0_8.startTime = 0
	arg0_8.endTime = 0
	arg0_8.staffList = {}
end

function var0_0.GetCostGold(arg0_9)
	return pg.activity_mall_custom_order[arg0_9].order_cost_gold
end

function var0_0.GetCost(arg0_10)
	local var0_10 = pg.activity_mall_custom_order[arg0_10].order_cost_show

	return underscore.map(var0_10, function(arg0_11)
		return Drop.Create(arg0_11)
	end)
end

return var0_0
