local var0_0 = class("MallFloor", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id

	local var0_1 = arg1_1.employee_list or {}

	arg0_1.staffList = {}

	for iter0_1 = 1, arg0_1:getConfig("need_staff_count") do
		arg0_1.staffList[iter0_1] = var0_1[iter0_1] or 0
	end

	arg0_1.isUnlock = arg2_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_mall_template
end

function var0_0.IsUnlock(arg0_3)
	return arg0_3.isUnlock
end

function var0_0.CheckUnlock(arg0_4, arg1_4)
	arg0_4.isUnlock = arg1_4 >= arg0_4:getConfig("need_mall_level")
end

function var0_0.SetLastIncome(arg0_5, arg1_5)
	arg0_5.lastIncome = arg1_5
end

function var0_0.GetLastIncome(arg0_6)
	return arg0_6.lastIncome or 0
end

function var0_0.SetStaff(arg0_7, arg1_7, arg2_7)
	arg0_7.staffList[arg1_7] = arg2_7
end

function var0_0.GetStaffList(arg0_8)
	return arg0_8.staffList
end

function var0_0.GetEmptyIdx(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.staffList) do
		if iter1_9 == 0 then
			return iter0_9
		end
	end

	return nil
end

function var0_0.GetTargetInfos(arg0_10, arg1_10)
	local var0_10 = underscore.detect(arg0_10:getConfig("floor_target"), function(arg0_11)
		return arg1_10 >= arg0_11[1][1] and arg1_10 <= arg0_11[1][2]
	end)

	return var0_10 and var0_10[2]
end

function var0_0.GetBaseIncome(arg0_12, arg1_12)
	local var0_12 = underscore.detect(arg0_12:getConfig("floor_basic_profit"), function(arg0_13)
		return arg1_12 >= arg0_13[1][1] and arg1_12 <= arg0_13[1][2]
	end)

	return var0_12 and var0_12[3]
end

return var0_0
