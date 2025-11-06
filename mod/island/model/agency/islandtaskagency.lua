local var0_0 = class("IslandTaskAgency", import(".IslandBaseAgency"))

var0_0.TASK_ADDED = "IslandTaskAgency.TASK_ADDED"
var0_0.TASK_UPDATED = "IslandTaskAgency.TASK_UPDATED"
var0_0.TASK_REMOVED = "IslandTaskAgency.TASK_REMOVED"
var0_0.FUTURE_TASK_REMOVED = "IslandTaskAgency.FUTURE_TASK_REMOVED"
var0_0.TASK_FINISH = "IslandTaskAgency.TASK_FINISH"

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

	arg0_1:SetMainTraceId(arg0_1:GetPriorityMainTraceTaskId())

	arg0_1.acceptCheckTimestampTags = {}

	if arg0_1.traceId ~= 0 then
		local var2_1 = arg0_1.tasks[arg0_1.traceId]

		if var2_1 and var2_1:GetType() == IslandTaskType.MAIN or not arg0_1:IsShowInTaskUI(var2_1) then
			arg0_1.traceId = 0
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
		local var1_2 = pg.island_task.get_id_list_by_type[iter5_2] or {}
		local var2_2 = underscore.select(var1_2, function(arg0_3)
			return pg.island_task[arg0_3].unlock_time ~= "stop" and not var0_0.IsServerAcceptType(arg0_3) and not arg0_2:CheckMutex(arg0_3)
		end)

		underscore.each(var2_2, function(arg0_4)
			local var0_4 = IslandFutureTask.New({
				task_id = arg0_4
			})

			arg0_2.futureTasks[var0_4.id] = var0_4
		end)
	end

	arg0_2:BuildObjectTaskHudData()
end

function var0_0.BuildObjectTaskHudData(arg0_5)
	local var0_5 = table.mergeArray(underscore.keys(arg0_5.tasks), underscore.keys(arg0_5.futureTasks))

	IslandObjectTaskHudHelper.BuildData(var0_5)
end

function var0_0.CheckMutex(arg0_6, arg1_6)
	if arg0_6:IsPassId(arg1_6) then
		return true
	end

	local var0_6 = pg.island_task[arg1_6].unlock_condition

	if var0_6 == "" or #var0_6 == 0 then
		return false
	end

	return underscore.any(var0_6, function(arg0_7)
		return arg0_7[1] == IslandTaskConditionType.MUTEX_TASK and table.contains(arg0_6.mutexIds, arg0_7[2])
	end)
end

function var0_0.GetFinishedIds(arg0_8)
	return arg0_8.finishedIds
end

function var0_0.IsFinishTask(arg0_9, arg1_9)
	return table.contains(arg0_9.finishedIds, arg1_9)
end

function var0_0.GetFinishCntByType(arg0_10, arg1_10)
	return underscore.reduce(arg0_10.finishedIds, 0, function(arg0_11, arg1_11)
		return arg0_11 + (pg.island_task[arg1_11].type == arg1_10 and 1 or 0)
	end)
end

function var0_0.IsPassId(arg0_12, arg1_12)
	return table.contains(arg0_12.mutexIds, arg1_12)
end

function var0_0.GetTasks(arg0_13)
	return arg0_13.tasks
end

function var0_0.GetShowTasks(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.tasks) do
		if arg0_14:IsShowInTaskUI(iter1_14) then
			table.insert(var0_14, iter1_14)
		end
	end

	return var0_14
end

function var0_0.IsShowInTaskUI(arg0_15, arg1_15)
	if not arg1_15 then
		return false
	end

	local var0_15 = arg1_15:getConfig("type")

	if var0_15 == IslandTaskType.SEASON then
		return false
	end

	local var1_15 = arg1_15:getConfig("link_task")
	local var2_15 = underscore.all(var1_15, function(arg0_16)
		return arg0_15:IsFinishTask(arg0_16)
	end)

	if var0_15 == IslandTaskType.HIDE then
		if #var1_15 > 0 and var2_15 then
			return true
		end
	elseif var2_15 then
		return true
	end

	return false
end

function var0_0.GetTask(arg0_17, arg1_17)
	return arg0_17.tasks[arg1_17]
end

function var0_0.GetFutureTask(arg0_18, arg1_18)
	return arg0_18.futureTasks[arg1_18]
end

function var0_0.SetTraceId(arg0_19, arg1_19)
	arg0_19.traceId = arg1_19
end

function var0_0.GetTraceId(arg0_20)
	return arg0_20.traceId
end

function var0_0.GetTraceTask(arg0_21)
	if arg0_21.traceId == 0 then
		return nil
	end

	return arg0_21.tasks[arg0_21.traceId]
end

function var0_0.SetMainTraceId(arg0_22, arg1_22)
	arg0_22.mainTraceId = arg1_22
end

function var0_0.GetMainTraceId(arg0_23)
	return arg0_23.mainTraceId
end

function var0_0.GetMainTraceTask(arg0_24)
	if arg0_24.mainTraceId == 0 then
		return nil
	end

	return arg0_24.tasks[arg0_24.mainTraceId]
end

function var0_0.GetPriorityTraceTaskId(arg0_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.tasks) do
		if not table.contains(IslandTaskType.EXCLUED_TRACK_TYPES, iter1_25:GetType()) and arg0_25:IsShowInTaskUI(iter1_25) then
			table.insert(var0_25, iter1_25)
		end
	end

	table.sort(var0_25, CompareFuncs({
		function(arg0_26)
			return -arg0_26:GetAcceptTime()
		end,
		function(arg0_27)
			return IslandTaskType.GetTrackPriority(arg0_27:GetType())
		end,
		function(arg0_28)
			return arg0_28.id
		end
	}))

	return var0_25[1] and var0_25[1].id or 0
end

function var0_0.GetPriorityMainTraceTaskId(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.tasks) do
		if iter1_29:GetType() == IslandTaskType.MAIN then
			return iter1_29.id
		end
	end

	return 0
end

function var0_0.AddTask(arg0_30, arg1_30)
	arg0_30.tasks[arg1_30.id] = arg1_30

	if arg0_30.randomTaskTimes[arg1_30.id] then
		arg0_30.tasks[arg1_30.id]:SetEndTime(arg0_30.randomTaskTimes[arg1_30.id])
	end

	arg0_30.futureTasks[arg1_30.id] = nil

	table.insert(arg0_30.mutexIds, arg1_30.id)

	for iter0_30, iter1_30 in pairs(arg0_30.futureTasks) do
		if arg0_30:CheckMutex(iter1_30.id) then
			arg0_30:RemoveFutureTask(iter1_30.id)
		end
	end

	arg0_30:DispatchEvent(var0_0.TASK_ADDED, arg1_30)
end

function var0_0.UpdateTask(arg0_31, arg1_31)
	arg0_31.tasks[arg1_31.id] = arg1_31

	if arg0_31.randomTaskTimes[arg1_31.id] then
		arg0_31.tasks[arg1_31.id]:SetEndTime(arg0_31.randomTaskTimes[arg1_31.id])
	end

	arg0_31:DispatchEvent(var0_0.TASK_UPDATED, arg1_31)

	if arg1_31:IsFinish() and arg1_31:IsSubmitImmediately() then
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_31.id
		})
	end
end

function var0_0.GetDiffTargetIdsByTypeAndParam(arg0_32, arg1_32, arg2_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.tasks) do
		local var1_32 = iter1_32:GetTargetIdByTypeAndParam(arg1_32, arg2_32)

		var0_32 = table.mergeArray(var0_32, var1_32, true)
	end

	return var0_32
end

function var0_0.GetTasksByTypeAndParam(arg0_33, arg1_33, arg2_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.tasks) do
		if iter1_33:ExistTargetType(arg1_33, arg2_33) then
			table.insert(var0_33, iter1_33)
		end
	end

	return task
end

function var0_0.ExistDailyTask(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34.tasks) do
		if iter1_34:GetShowType() == IslandTaskType.DAILY then
			return true
		end
	end

	return false
end

function var0_0.AddFinishId(arg0_35, arg1_35)
	table.insert(arg0_35.finishedIds, arg1_35)
	arg0_35:DispatchEvent(var0_0.TASK_FINISH)
end

function var0_0.RemoveTask(arg0_36, arg1_36)
	local var0_36 = arg0_36.tasks[arg1_36]

	arg0_36.tasks[arg1_36] = nil

	arg0_36:DispatchEvent(var0_0.TASK_REMOVED, var0_36)
end

function var0_0.RemoveFutureTask(arg0_37, arg1_37)
	local var0_37 = arg0_37.futureTasks[arg1_37]

	arg0_37.futureTasks[arg1_37] = nil

	arg0_37:DispatchEvent(var0_0.FUTURE_TASK_REMOVED, var0_37)
end

function var0_0.UpdatePerDay(arg0_38)
	pg.m02:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK)
end

function var0_0.UpdateRandomRefreshTask(arg0_39, arg1_39)
	for iter0_39, iter1_39 in ipairs(arg1_39.remove_task_list or {}) do
		arg0_39.tasks[iter1_39] = nil
	end

	for iter2_39, iter3_39 in ipairs(arg1_39.remove_task_finish or {}) do
		table.removebyvalue(arg0_39.finishedIds, iter3_39)
	end

	arg0_39:InitFutureTasks(arg1_39.task_list_random or {})
end

function var0_0.UpdatePerSecond(arg0_40)
	for iter0_40, iter1_40 in pairs(arg0_40.tasks) do
		if not iter1_40:InTime() then
			arg0_40:RemoveTask(iter1_40.id)
		end
	end

	local var0_40 = {}

	for iter2_40, iter3_40 in pairs(arg0_40.futureTasks) do
		if not iter3_40:InTime() then
			arg0_40:RemoveFutureTask(iter3_40.id)
		end
	end

	local var1_40 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_40.acceptCheckTimestampTags[var1_40] then
		arg0_40.acceptCheckTimestampTags[var1_40] = nil

		arg0_40:TryAcceptAutoTasks()
	end
end

function var0_0.TryAcceptAutoTasks(arg0_41, arg1_41)
	local var0_41 = {}

	arg0_41.acceptCheckTimestampTags = {}

	for iter0_41, iter1_41 in pairs(arg0_41.futureTasks) do
		if iter1_41:IsAcceptImmediately() and iter1_41:IsUnlock() then
			table.insert(var0_41, iter1_41.id)
		elseif iter1_41:IsUnlockWaitTime() then
			arg0_41.acceptCheckTimestampTags[iter1_41:GetUnlockTime()] = true
		end
	end

	if #var0_41 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var0_41,
			callback = arg1_41
		})
	else
		existCall(arg1_41)
	end
end

function var0_0.TrySubmitAutoTasks(arg0_42, arg1_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42.tasks) do
		if iter1_42:IsFinish() and iter1_42:IsSubmitImmediately() then
			table.insert(var0_42, function(arg0_43)
				pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
					taskId = iter1_42.id,
					callback = arg0_43
				})
			end)
		end
	end

	seriesAsync(var0_42, function()
		existCall(arg1_42)
	end)
end

function var0_0.TryAutoTrackTask(arg0_45)
	local var0_45 = arg0_45:GetPriorityTraceTaskId()

	if var0_45 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var0_45,
			type = IslandTaskTrackCard.TYPES.OTHER
		})
	end

	local var1_45 = arg0_45:GetPriorityMainTraceTaskId()

	if var1_45 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var1_45,
			type = IslandTaskTrackCard.TYPES.MAIN
		})
	end
end

function var0_0.GetCanAcceptTasks(arg0_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.futureTasks) do
		if iter1_46:IsUnlock() then
			table.insert(var0_46, iter1_46)
		end
	end

	return var0_46
end

function var0_0.GetCanSubmitTasks(arg0_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in pairs(arg0_47.tasks) do
		if iter1_47:IsFinish() then
			table.insert(var0_47, iter1_47)
		end
	end

	return var0_47
end

function var0_0.GetCanAcceptTasksByMapId(arg0_48, arg1_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.futureTasks) do
		if iter1_48:getConfig("map_trigger_tips") == arg1_48 and iter1_48:IsUnlock() then
			table.insert(var0_48, iter1_48)
		end
	end

	return var0_48
end

function var0_0.GetCanSubmitTasksByMapId(arg0_49, arg1_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.tasks) do
		if iter1_49:getConfig("map_complete_tips") == arg1_49 and iter1_49:IsFinish() then
			table.insert(var0_49, iter1_49)
		end
	end

	return var0_49
end

function var0_0.IsServerAcceptType(arg0_50)
	return pg.island_task[arg0_50].trigger_type == 3
end

return var0_0
