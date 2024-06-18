local var0_0 = class("WorldTaskProxy", import("....BaseEntity"))

var0_0.Fields = {
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
var0_0.EventUpdateTask = "WorldTaskProxy.EventUpdateTask"
var0_0.EventUpdateDailyTaskIds = "WorldTaskProxy.EventUpdateDailyTaskIds"

function var0_0.Build(arg0_1)
	arg0_1.list = {}
	arg0_1.recycle = {}
	arg0_1.itemListenerList = {}
	arg0_1.mapListenerList = {}
end

function var0_0.Setup(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg1_2) do
		local var0_2 = WorldTask.New(iter1_2)

		if var0_2:getState() == WorldTask.STATE_RECEIVED then
			arg0_2.recycle[var0_2.id] = var0_2
		else
			arg0_2:addTask(var0_2)
		end
	end
end

function var0_0.Dispose(arg0_3)
	arg0_3:Clear()
end

function var0_0.getTaskById(arg0_4, arg1_4)
	assert(arg1_4, "taskId can not be nil")

	return arg0_4.list[arg1_4]
end

function var0_0.addTaskListener(arg0_5, arg1_5)
	if arg1_5.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		local var0_5 = arg1_5.config.complete_parameter[1]

		arg0_5.itemListenerList[var0_5] = arg0_5.itemListenerList[var0_5] or {}

		table.insert(arg0_5.itemListenerList[var0_5], arg1_5.id)
	elseif arg1_5.config.complete_condition == WorldConst.TaskTypePressingMap then
		for iter0_5, iter1_5 in ipairs(arg1_5.config.complete_parameter) do
			arg0_5.mapListenerList[iter1_5] = arg0_5.mapListenerList[iter1_5] or {}

			table.insert(arg0_5.mapListenerList[iter1_5], arg1_5.id)
		end
	end
end

function var0_0.removeTaskListener(arg0_6, arg1_6)
	if arg1_6.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		local var0_6 = arg1_6.config.complete_parameter[1]

		table.removebyvalue(arg0_6.itemListenerList[var0_6], arg1_6.id)
	elseif arg1_6.config.complete_condition == WorldConst.TaskTypePressingMap then
		for iter0_6, iter1_6 in ipairs(arg1_6.config.complete_parameter) do
			table.removebyvalue(arg0_6.mapListenerList[iter1_6], arg1_6.id)
		end
	end
end

function var0_0.doUpdateTaskByItem(arg0_7, arg1_7)
	if not arg0_7.itemListenerList[arg1_7.id] then
		return
	end

	for iter0_7, iter1_7 in ipairs(arg0_7.itemListenerList[arg1_7.id]) do
		local var0_7 = arg0_7:getTaskById(iter1_7)

		var0_7:updateProgress(arg1_7.count)
		arg0_7:updateTask(var0_7)
	end
end

function var0_0.doUpdateTaskByMap(arg0_8, arg1_8, arg2_8)
	if not arg0_8.mapListenerList[arg1_8] then
		return
	end

	for iter0_8, iter1_8 in ipairs(arg0_8.mapListenerList[arg1_8]) do
		local var0_8 = arg0_8:getTaskById(iter1_8)

		var0_8:updateProgress(var0_8:getProgress() + (arg2_8 and 1 or -1))
		arg0_8:updateTask(var0_8)
	end
end

function var0_0.addTask(arg0_9, arg1_9)
	arg0_9.recycle[arg1_9.id] = nil
	arg0_9.list[arg1_9.id] = arg1_9

	arg0_9:addTaskListener(arg1_9)
	arg0_9:DispatchEvent(var0_0.EventUpdateTask, arg1_9)
end

function var0_0.deleteTask(arg0_10, arg1_10)
	if not arg0_10.list[arg1_10] then
		return
	end

	arg0_10.recycle[arg1_10] = arg0_10.list[arg1_10]
	arg0_10.list[arg1_10] = nil

	arg0_10:removeTaskListener(arg0_10.recycle[arg1_10])
	arg0_10:DispatchEvent(var0_0.EventUpdateTask, arg0_10.recycle[arg1_10])
end

function var0_0.updateTask(arg0_11, arg1_11)
	arg0_11.list[arg1_11.id] = arg1_11

	if arg1_11:getState() == WorldTask.STATE_RECEIVED then
		arg0_11:deleteTask(arg1_11.id)
	else
		arg0_11:DispatchEvent(var0_0.EventUpdateTask, arg1_11)
	end
end

function var0_0.getTasks(arg0_12)
	return arg0_12.list
end

function var0_0.getTaskVOs(arg0_13)
	return underscore.values(arg0_13.list)
end

function var0_0.getDoingTaskVOs(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14:getTasks()) do
		if iter1_14:isAlive() then
			table.insert(var0_14, iter1_14)
		end
	end

	return var0_14
end

function var0_0.getAutoSubmitTaskVO(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15:getTasks()) do
		if iter1_15:IsAutoSubmit() and iter1_15:getState() == WorldTask.STATE_FINISHED then
			return iter1_15
		end
	end

	return nil
end

function var0_0.riseTaskFinishCount(arg0_16)
	arg0_16.taskFinishCount = arg0_16.taskFinishCount + 1
end

function var0_0.getDailyTaskIds(arg0_17)
	return underscore.rest(arg0_17.dailyTaskIds, 1)
end

function var0_0.UpdateDailyTaskIds(arg0_18, arg1_18)
	if arg0_18.dailyTaskIds ~= arg1_18 then
		arg0_18.dailyTaskIds = arg1_18

		arg0_18:DispatchEvent(var0_0.EventUpdateDailyTaskIds)
	end
end

function var0_0.checkDailyTask(arg0_19, arg1_19)
	local var0_19 = {}

	if not arg0_19.dailyTimeStemp or arg0_19.dailyTimeStemp < pg.TimeMgr.GetInstance():GetServerTime() then
		table.insert(var0_19, function(arg0_20)
			pg.ConnectionMgr.GetInstance():Send(33413, {
				type = 0
			}, 33414, function(arg0_21)
				if arg0_21.result == 0 then
					arg0_19.dailyTimeStemp = arg0_21.next_refresh_time

					assert(arg0_19.dailyTimeStemp > 0, "refresh time:" .. arg0_19.dailyTimeStemp)

					if arg0_19.dailyTimer then
						arg0_19.dailyTimer:Stop()
					end

					arg0_19.dailyTimer = Timer.New(function()
						arg0_19:checkDailyTask()
					end, arg0_19.dailyTimeStemp - pg.TimeMgr.GetInstance():GetServerTime() + 1)

					arg0_19:UpdateDailyTaskIds(underscore.rest(arg0_21.task_list, 1))
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_21.result))
				end

				arg0_20()
			end)
		end)
	end

	seriesAsync(var0_19, arg1_19)
end

function var0_0.canAcceptDailyTask(arg0_23)
	return arg0_23.dailyTaskIds and #arg0_23.dailyTaskIds > 0 and pg.gameset.world_port_taskmax.key_value > #arg0_23:getDoingTaskVOs()
end

function var0_0.hasDoingCollectionTask(arg0_24)
	return underscore.any(arg0_24:getDoingTaskVOs(), function(arg0_25)
		return arg0_25:IsTypeCollection()
	end)
end

function var0_0.getRecycleTask(arg0_26, arg1_26)
	return arg0_26.list[arg1_26] or arg0_26.recycle[arg1_26]
end

return var0_0
