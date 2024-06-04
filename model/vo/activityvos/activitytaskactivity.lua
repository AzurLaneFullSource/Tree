local var0 = class("ActivityTaskActivity", import("model.vo.ActivityVOs.ITaskActivity"))

function var0.GetFinishedTaskIds(arg0)
	return arg0:getData1List()
end

function var0.GetTaskIdsByDay(arg0)
	return arg0:getConfig("config_data")
end

return var0
