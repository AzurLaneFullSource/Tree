local var0_0 = class("ActivityTaskActivity", import("model.vo.ActivityVOs.ITaskActivity"))

function var0_0.GetFinishedTaskIds(arg0_1)
	return arg0_1:getData1List()
end

function var0_0.GetTaskIdsByDay(arg0_2)
	return arg0_2:getConfig("config_data")
end

return var0_0
