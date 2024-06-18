local var0_0 = class("Spring2Activity", import("model.vo.ActivityVOs.ITaskActivity"))

var0_0.OPERATION_SETSHIP = 1

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	for iter0_1 = 1, arg0_1:GetSlotCount() do
		arg0_1.data1_list[iter0_1] = arg0_1.data1_list[iter0_1] or 0
	end
end

function var0_0.GetSlotCount(arg0_2)
	return arg0_2:getConfig("config_data")[2]
end

function var0_0.GetTotalSlotCount(arg0_3)
	return arg0_3:getConfig("config_data")[2]
end

function var0_0.GetAvaliableShipIds(arg0_4)
	return _.filter(arg0_4.data1_list, function(arg0_5)
		return arg0_5 > 0
	end)
end

function var0_0.GetShipIds(arg0_6)
	return arg0_6.data1_list
end

function var0_0.SetShipIds(arg0_7, arg1_7)
	table.Foreach(arg1_7, function(arg0_8, arg1_8)
		arg0_7.data1_list[arg1_8.key] = arg1_8.value
	end)
end

function var0_0.GetEnergyRecoverAddition(arg0_9)
	return arg0_9:getConfig("config_data")[1]
end

function var0_0.GetUnlockTaskIds(arg0_10)
	return _.flatten(arg0_10:GetTaskIdsByDay())
end

function var0_0.GetFinishedTaskIds(arg0_11)
	return arg0_11.data2_list
end

function var0_0.GetTaskIdsByDay(arg0_12)
	return arg0_12:getConfig("config_data")[3]
end

function var0_0.readyToAchieve(arg0_13)
	assert(isa(arg0_13, Spring2Activity))

	local var0_13 = arg0_13:GetConfigID()
	local var1_13 = getProxy(ActivityTaskProxy):getTaskVOsByActId(var0_13)

	return _.any(var1_13, function(arg0_14)
		local var0_14 = arg0_14:isFinish()
		local var1_14 = arg0_14:isOver()

		return var0_14 and not var1_14
	end)
end

return var0_0
