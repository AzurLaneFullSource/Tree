local var0_0 = class("SpringActivity", import("model.vo.Activity"))

var0_0.ActivityType = ActivityConst.ACTIVITY_TYPE_HOTSPRING
var0_0.OPERATION_UNLOCK = 1
var0_0.OPERATION_SETSHIP = 2

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	for iter0_1 = 1, arg0_1:GetSlotCount() do
		arg0_1.data1_list[iter0_1] = arg0_1.data1_list[iter0_1] or 0
	end
end

function var0_0.GetSlotCount(arg0_2)
	return arg0_2.data1 + arg0_2:GetInitialSlotCount()
end

function var0_0.AddSlotCount(arg0_3)
	arg0_3.data1 = arg0_3.data1 + 1
	arg0_3.data1_list[arg0_3:GetSlotCount()] = 0

	local var0_3, var1_3 = arg0_3:GetUpgradeCost()

	arg0_3.data2 = math.max(0, arg0_3.data2 - var1_3)
end

function var0_0.GetInitialSlotCount(arg0_4)
	return arg0_4:getConfig("config_data")[1][5] or 0
end

function var0_0.GetUnlockableSlotCount(arg0_5)
	return arg0_5:getConfig("config_data")[1][3]
end

function var0_0.GetTotalSlotCount(arg0_6)
	return arg0_6:GetInitialSlotCount() + arg0_6:GetUnlockableSlotCount()
end

function var0_0.GetAvaliableShipIds(arg0_7)
	return _.filter(arg0_7.data1_list, function(arg0_8)
		return arg0_8 > 0
	end)
end

function var0_0.GetShipIds(arg0_9)
	return arg0_9.data1_list
end

function var0_0.SetShipIds(arg0_10, arg1_10)
	table.Foreach(arg1_10, function(arg0_11, arg1_11)
		arg0_10.data1_list[arg1_11.key] = arg1_11.value
	end)
end

function var0_0.GetEnergyRecoverAddition(arg0_12)
	return arg0_12:getConfig("config_data")[1][4]
end

function var0_0.GetCoins(arg0_13)
	return arg0_13.data2
end

function var0_0.GetUpgradeCost(arg0_14)
	return arg0_14:getConfig("config_data")[1][1], arg0_14:getConfig("config_data")[1][2]
end

return var0_0
