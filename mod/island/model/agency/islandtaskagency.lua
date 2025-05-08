local var0_0 = class("IslandTaskAgency", import(".IslandBaseAgency"))

var0_0.TASK_ADDED = "IslandTaskAgency.TASK_ADDED"
var0_0.TASK_UPDATED = "IslandTaskAgency.TASK_UPDATED"
var0_0.TASK_REMOVED = "IslandTaskAgency.TASK_REMOVED"
var0_0.FUTURE_TASK_REMOVED = "IslandTaskAgency.FUTURE_TASK_REMOVED"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.task_info or {}

	arg0_1.traceId = var0_1.focus_id or 0
	arg0_1.finishedIds = var0_1.task_id_list_finish or {}
	arg0_1.tasks = {}

	for iter0_1, iter1_1 in ipairs(var0_1.task_list or {}) do
		local var1_1 = IslandTask.New(iter1_1)

		arg0_1.tasks[var1_1.id] = var1_1
	end

	arg0_1:InitFutureTasks(var0_1.task_list_random or {})

	for iter2_1, iter3_1 in pairs(arg0_1.tasks) do
		if arg0_1.randomTaskTimes[iter3_1.id] then
			iter3_1:SetEndTime(arg0_1.randomTaskTimes[iter3_1.id])
		end
	end
end

function var0_0.InitFutureTasks(arg0_2, arg1_2)
	arg0_2.mutexIds = Clone(arg0_2.finishedIds)

	for iter0_2, iter1_2 in pairs(arg0_2.tasks) do
		table.insert(arg0_2.mutexIds, iter1_2.id)
	end

	arg0_2.futureTasks = {}
	arg0_2.randomTaskTimes = {}

	for iter2_2, iter3_2 in ipairs(arg1_2) do
		arg0_2.randomTaskTimes[iter3_2.task_id] = iter3_2.timestamp

		if not arg0_2:CheckMutex(iter3_2.task_id) then
			local var0_2 = IslandFutureTask.New(iter3_2)

			arg0_2.futureTasks[var0_2.id] = var0_2
		end
	end

	for iter4_2, iter5_2 in ipairs(IslandTaskType.GetPermanentTypes()) do
		local var1_2 = pg.island_task.get_id_list_by_type[iter5_2]
		local var2_2 = underscore.select(var1_2, function(arg0_3)
			return not var0_0.IsServerAcceptType(arg0_3) and not arg0_2:CheckMutex(arg0_3)
		end)

		underscore.each(var2_2, function(arg0_4)
			local var0_4 = IslandFutureTask.New({
				task_id = arg0_4
			})

			arg0_2.futureTasks[var0_4.id] = var0_4
		end)
	end
end

function var0_0.CheckMutex(arg0_5, arg1_5)
	if arg0_5:IsPassId(arg1_5) then
		return true
	end

	local var0_5 = pg.island_task[arg1_5].unlock_condition

	if var0_5 == "" or #var0_5 == 0 then
		return false
	end

	return underscore.any(var0_5, function(arg0_6)
		return arg0_6[1] == IslandFutureTask.CONDITION_TYPE.MUTEX_TASK and table.contains(arg0_5.mutexIds, arg0_6[2])
	end)
end

function var0_0.IsFinishTask(arg0_7, arg1_7)
	return table.contains(arg0_7.finishedIds, arg1_7)
end

function var0_0.IsPassId(arg0_8, arg1_8)
	return table.contains(arg0_8.mutexIds, arg1_8)
end

function var0_0.GetTasks(arg0_9)
	return arg0_9.tasks
end

function var0_0.GetTask(arg0_10, arg1_10)
	return arg0_10.tasks[arg1_10]
end

function var0_0.GetFutureTask(arg0_11, arg1_11)
	return arg0_11.futureTasks[taskId]
end

function var0_0.SetTraceId(arg0_12, arg1_12)
	arg0_12.traceId = arg1_12
end

function var0_0.GetTraceId(arg0_13)
	return arg0_13.traceId
end

function var0_0.GetTraceTask(arg0_14)
	if arg0_14.traceId == 0 then
		return nil
	end

	return arg0_14.tasks[arg0_14.traceId]
end

function var0_0.AddTask(arg0_15, arg1_15)
	arg0_15.tasks[arg1_15.id] = arg1_15

	if arg0_15.randomTaskTimes[arg1_15.id] then
		arg0_15.tasks[arg1_15.id]:SetEndTime(arg0_15.randomTaskTimes[arg1_15.id])
	end

	arg0_15.futureTasks[arg1_15.id] = nil

	table.insert(arg0_15.mutexIds, arg1_15.id)

	for iter0_15, iter1_15 in pairs(arg0_15.futureTasks) do
		if arg0_15:CheckMutex(iter1_15.id) then
			arg0_15:RemoveFutureTask(iter1_15.id)
		end
	end

	arg0_15:DispatchEvent(var0_0.TASK_ADDED, arg1_15)
end

function var0_0.UpdateTask(arg0_16, arg1_16)
	arg0_16.tasks[arg1_16.id] = arg1_16

	if arg0_16.randomTaskTimes[arg1_16.id] then
		arg0_16.tasks[arg1_16.id]:SetEndTime(arg0_16.randomTaskTimes[arg1_16.id])
	end

	arg0_16:DispatchEvent(var0_0.TASK_UPDATED, arg1_16)

	if arg1_16:IsFinish() and arg1_16:IsSubmitImmediately() then
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_16.id
		})
	end
end

function var0_0.AddFinishId(arg0_17, arg1_17)
	table.insert(arg0_17.finishedIds, arg1_17)
end

function var0_0.RemoveTask(arg0_18, arg1_18)
	local var0_18 = arg0_18.tasks[arg1_18]

	arg0_18.tasks[arg1_18] = nil

	arg0_18:DispatchEvent(var0_0.TASK_REMOVED, var0_18)
end

function var0_0.RemoveFutureTask(arg0_19, arg1_19)
	local var0_19 = arg0_19.futureTasks[arg1_19]

	arg0_19.futureTasks[arg1_19] = nil

	arg0_19:DispatchEvent(var0_0.FUTURE_TASK_REMOVED, var0_19)
end

function var0_0.UpdatePerDay(arg0_20)
	pg.m02:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK)
end

function var0_0.UpdateRandomRefreshTask(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg1_21.remove_task_list or {}) do
		arg0_21.tasks[iter1_21] = nil
	end

	for iter2_21, iter3_21 in ipairs(arg1_21.remove_task_finish or {}) do
		table.removebyvalue(arg0_21.finishedIds, iter3_21)
	end

	arg0_21:InitFutureTasks(arg1_21.task_list_random or {})
end

function var0_0.UpdatePerSecond(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.tasks) do
		if not iter1_22:InTime() then
			arg0_22:RemoveTask(iter1_22.id)
		end
	end

	local var0_22 = {}

	for iter2_22, iter3_22 in pairs(arg0_22.futureTasks) do
		if not iter3_22:InTime() then
			arg0_22:RemoveFutureTask(iter3_22.id)
		elseif iter3_22:IsUnlock() and iter3_22:IsAcceptImmediately() then
			table.insert(var0_22, task)
		end
	end

	if #var0_22 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var0_22
		})
	end
end

function var0_0.GetCanAcceptTasks(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23.futureTasks) do
		if iter1_23:IsUnlock() then
			table.insert(var0_23, iter1_23)
		end
	end

	return var0_23
end

function var0_0.GetCanSubmitTasks(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.tasks) do
		if iter1_24:IsFinish() then
			table.insert(var0_24, iter1_24)
		end
	end

	return var0_24
end

function var0_0.GetCanAcceptTasksByMapId(arg0_25, arg1_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.futureTasks) do
		if iter1_25:getConfig("map_trigger_tips") == arg1_25 and iter1_25:IsUnlock() then
			table.insert(var0_25, iter1_25)
		end
	end

	return var0_25
end

function var0_0.GetCanSubmitTasksByMapId(arg0_26, arg1_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.tasks) do
		if iter1_26:getConfig("map_complete_tips") == arg1_26 and iter1_26:IsFinish() then
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26
end

function var0_0.IsServerAcceptType(arg0_27)
	return pg.island_task[arg0_27].trigger_type == 3
end

return var0_0
