local var0 = class("Spring2Activity", import("model.vo.ActivityVOs.ITaskActivity"))

var0.OPERATION_SETSHIP = 1

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	for iter0 = 1, arg0:GetSlotCount() do
		arg0.data1_list[iter0] = arg0.data1_list[iter0] or 0
	end
end

function var0.GetSlotCount(arg0)
	return arg0:getConfig("config_data")[2]
end

function var0.GetTotalSlotCount(arg0)
	return arg0:getConfig("config_data")[2]
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
	return arg0:getConfig("config_data")[1]
end

function var0.GetUnlockTaskIds(arg0)
	return _.flatten(arg0:GetTaskIdsByDay())
end

function var0.GetFinishedTaskIds(arg0)
	return arg0.data2_list
end

function var0.GetTaskIdsByDay(arg0)
	return arg0:getConfig("config_data")[3]
end

function var0.readyToAchieve(arg0)
	assert(isa(arg0, Spring2Activity))

	local var0 = arg0:GetConfigID()
	local var1 = getProxy(ActivityTaskProxy):getTaskVOsByActId(var0)

	return _.any(var1, function(arg0)
		local var0 = arg0:isFinish()
		local var1 = arg0:isOver()

		return var0 and not var1
	end)
end

return var0
