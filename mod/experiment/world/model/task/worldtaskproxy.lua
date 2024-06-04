local var0 = class("WorldTaskProxy", import("....BaseEntity"))

var0.Fields = {
	dailyTimeStemp = "number",
	dailyTaskIds = "table",
	dailyTimer = "table",
	itemListenerList = "table",
	recycle = "table",
	taskFinishCount = "number",
	mapList = "table",
	mapListenerList = "table",
	list = "table"
}
var0.EventUpdateTask = "WorldTaskProxy.EventUpdateTask"
var0.EventUpdateDailyTaskIds = "WorldTaskProxy.EventUpdateDailyTaskIds"

function var0.Build(arg0)
	arg0.list = {}
	arg0.recycle = {}
	arg0.itemListenerList = {}
	arg0.mapListenerList = {}
end

function var0.Setup(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = WorldTask.New(iter1)

		if var0:getState() == WorldTask.STATE_RECEIVED then
			arg0.recycle[var0.id] = var0
		else
			arg0:addTask(var0)
		end
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
end

function var0.getTaskById(arg0, arg1)
	assert(arg1, "taskId can not be nil")

	return arg0.list[arg1]
end

function var0.addTaskListener(arg0, arg1)
	if arg1.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		local var0 = arg1.config.complete_parameter[1]

		arg0.itemListenerList[var0] = arg0.itemListenerList[var0] or {}

		table.insert(arg0.itemListenerList[var0], arg1.id)
	elseif arg1.config.complete_condition == WorldConst.TaskTypePressingMap then
		for iter0, iter1 in ipairs(arg1.config.complete_parameter) do
			arg0.mapListenerList[iter1] = arg0.mapListenerList[iter1] or {}

			table.insert(arg0.mapListenerList[iter1], arg1.id)
		end
	end
end

function var0.removeTaskListener(arg0, arg1)
	if arg1.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		local var0 = arg1.config.complete_parameter[1]

		table.removebyvalue(arg0.itemListenerList[var0], arg1.id)
	elseif arg1.config.complete_condition == WorldConst.TaskTypePressingMap then
		for iter0, iter1 in ipairs(arg1.config.complete_parameter) do
			table.removebyvalue(arg0.mapListenerList[iter1], arg1.id)
		end
	end
end

function var0.doUpdateTaskByItem(arg0, arg1)
	if not arg0.itemListenerList[arg1.id] then
		return
	end

	for iter0, iter1 in ipairs(arg0.itemListenerList[arg1.id]) do
		local var0 = arg0:getTaskById(iter1)

		var0:updateProgress(arg1.count)
		arg0:updateTask(var0)
	end
end

function var0.doUpdateTaskByMap(arg0, arg1, arg2)
	if not arg0.mapListenerList[arg1] then
		return
	end

	for iter0, iter1 in ipairs(arg0.mapListenerList[arg1]) do
		local var0 = arg0:getTaskById(iter1)

		var0:updateProgress(var0:getProgress() + (arg2 and 1 or -1))
		arg0:updateTask(var0)
	end
end

function var0.addTask(arg0, arg1)
	arg0.recycle[arg1.id] = nil
	arg0.list[arg1.id] = arg1

	arg0:addTaskListener(arg1)
	arg0:DispatchEvent(var0.EventUpdateTask, arg1)
end

function var0.deleteTask(arg0, arg1)
	if not arg0.list[arg1] then
		return
	end

	arg0.recycle[arg1] = arg0.list[arg1]
	arg0.list[arg1] = nil

	arg0:removeTaskListener(arg0.recycle[arg1])
	arg0:DispatchEvent(var0.EventUpdateTask, arg0.recycle[arg1])
end

function var0.updateTask(arg0, arg1)
	arg0.list[arg1.id] = arg1

	if arg1:getState() == WorldTask.STATE_RECEIVED then
		arg0:deleteTask(arg1.id)
	else
		arg0:DispatchEvent(var0.EventUpdateTask, arg1)
	end
end

function var0.getTasks(arg0)
	return arg0.list
end

function var0.getTaskVOs(arg0)
	return underscore.values(arg0.list)
end

function var0.getDoingTaskVOs(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:getTasks()) do
		if iter1:isAlive() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getAutoSubmitTaskVO(arg0)
	for iter0, iter1 in pairs(arg0:getTasks()) do
		if iter1:IsAutoSubmit() and iter1:getState() == WorldTask.STATE_FINISHED then
			return iter1
		end
	end

	return nil
end

function var0.riseTaskFinishCount(arg0)
	arg0.taskFinishCount = arg0.taskFinishCount + 1
end

function var0.getDailyTaskIds(arg0)
	return underscore.rest(arg0.dailyTaskIds, 1)
end

function var0.UpdateDailyTaskIds(arg0, arg1)
	if arg0.dailyTaskIds ~= arg1 then
		arg0.dailyTaskIds = arg1

		arg0:DispatchEvent(var0.EventUpdateDailyTaskIds)
	end
end

function var0.checkDailyTask(arg0, arg1)
	local var0 = {}

	if not arg0.dailyTimeStemp or arg0.dailyTimeStemp < pg.TimeMgr.GetInstance():GetServerTime() then
		table.insert(var0, function(arg0)
			pg.ConnectionMgr.GetInstance():Send(33413, {
				type = 0
			}, 33414, function(arg0)
				if arg0.result == 0 then
					arg0.dailyTimeStemp = arg0.next_refresh_time

					assert(arg0.dailyTimeStemp > 0, "refresh time:" .. arg0.dailyTimeStemp)

					if arg0.dailyTimer then
						arg0.dailyTimer:Stop()
					end

					arg0.dailyTimer = Timer.New(function()
						arg0:checkDailyTask()
					end, arg0.dailyTimeStemp - pg.TimeMgr.GetInstance():GetServerTime() + 1)

					arg0:UpdateDailyTaskIds(underscore.rest(arg0.task_list, 1))
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
				end

				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.canAcceptDailyTask(arg0)
	return arg0.dailyTaskIds and #arg0.dailyTaskIds > 0 and pg.gameset.world_port_taskmax.key_value > #arg0:getDoingTaskVOs()
end

function var0.hasDoingCollectionTask(arg0)
	return underscore.any(arg0:getDoingTaskVOs(), function(arg0)
		return arg0:IsTypeCollection()
	end)
end

function var0.getRecycleTask(arg0, arg1)
	return arg0.list[arg1] or arg0.recycle[arg1]
end

return var0
