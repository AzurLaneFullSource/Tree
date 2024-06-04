local var0 = class("SpringActivity", import("model.vo.Activity"))

var0.ActivityType = ActivityConst.ACTIVITY_TYPE_HOTSPRING
var0.OPERATION_UNLOCK = 1
var0.OPERATION_SETSHIP = 2

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	for iter0 = 1, arg0:GetSlotCount() do
		arg0.data1_list[iter0] = arg0.data1_list[iter0] or 0
	end
end

function var0.GetSlotCount(arg0)
	return arg0.data1 + arg0:GetInitialSlotCount()
end

function var0.AddSlotCount(arg0)
	arg0.data1 = arg0.data1 + 1
	arg0.data1_list[arg0:GetSlotCount()] = 0

	local var0, var1 = arg0:GetUpgradeCost()

	arg0.data2 = math.max(0, arg0.data2 - var1)
end

function var0.GetInitialSlotCount(arg0)
	return arg0:getConfig("config_data")[1][5] or 0
end

function var0.GetUnlockableSlotCount(arg0)
	return arg0:getConfig("config_data")[1][3]
end

function var0.GetTotalSlotCount(arg0)
	return arg0:GetInitialSlotCount() + arg0:GetUnlockableSlotCount()
end

function var0.GetAvaliableShipIds(arg0)
	return _.filter(arg0.data1_list, function(arg0)
		return arg0 > 0
	end)
end

function var0.GetShipIds(arg0)
	return arg0.data1_list
end

function var0.SetShipIds(arg0, arg1)
	table.Foreach(arg1, function(arg0, arg1)
		arg0.data1_list[arg1.key] = arg1.value
	end)
end

function var0.GetEnergyRecoverAddition(arg0)
	return arg0:getConfig("config_data")[1][4]
end

function var0.GetCoins(arg0)
	return arg0.data2
end

function var0.GetUpgradeCost(arg0)
	return arg0:getConfig("config_data")[1][1], arg0:getConfig("config_data")[1][2]
end

return var0
