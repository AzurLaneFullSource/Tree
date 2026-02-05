local var0_0 = class("IslandTaskAgency", import(".IslandBaseAgency"))

var0_0.TASK_ADDED = "IslandTaskAgency.TASK_ADDED"
var0_0.TASK_UPDATED = "IslandTaskAgency.TASK_UPDATED"
var0_0.TASK_REMOVED = "IslandTaskAgency.TASK_REMOVED"
var0_0.FUTURE_TASK_REMOVED = "IslandTaskAgency.FUTURE_TASK_REMOVED"
var0_0.TASK_FINISH = "IslandTaskAgency.TASK_FINISH"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.task_info or {}

	arg0_1.finishedDailyCntInWeek = var0_1.week_daily_task_num or 0
	arg0_1.traceId = var0_1.focus_id or 0
	arg0_1.finishedIds = var0_1.task_id_list_finish or {}
	arg0_1.tasks = {}

	for iter0_1, iter1_1 in ipairs(var0_1.task_list or {}) do
		local var1_1 = IslandTask.New(iter1_1)

		arg0_1.tasks[var1_1.id] = var1_1
	end

	arg0_1:InitFutureTasks(var0_1.task_list_random or {})
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

function var0_0.GetFinishCntByType(arg0_10, arg1_10, arg2_10)
	return underscore.reduce(arg0_10.finishedIds, 0, function(arg0_11, arg1_11)
		local var0_11 = pg.island_task[arg1_11]

		return arg0_11 + ((not arg2_10 or var0_11.count_offset == 1) and var0_11.type == arg1_10 and 1 or 0)
	end)
end

function var0_0.GetFinishedDailyCntInWeek(arg0_12)
	return arg0_12.finishedDailyCntInWeek
end

function var0_0.IsPassId(arg0_13, arg1_13)
	return table.contains(arg0_13.mutexIds, arg1_13)
end

function var0_0.GetTasks(arg0_14)
	return arg0_14.tasks
end

function var0_0.GetShowTasks(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in pairs(arg0_15.tasks) do
		if arg0_15:IsShowInTaskUI(iter1_15) then
			table.insert(var0_15, iter1_15)
		end
	end

	return var0_15
end

function var0_0.IsShowInTaskUI(arg0_16, arg1_16)
	if not arg1_16 then
		return false
	end

	local var0_16 = arg1_16:getConfig("type")

	if var0_16 == IslandTaskType.SEASON then
		return false
	end

	local var1_16 = arg1_16:getConfig("link_task")
	local var2_16 = underscore.all(var1_16, function(arg0_17)
		return arg0_16:IsFinishTask(arg0_17)
	end)

	if var0_16 == IslandTaskType.HIDE then
		if #var1_16 > 0 and var2_16 then
			return true
		end
	elseif var2_16 then
		return true
	end

	return false
end

function var0_0.GetTask(arg0_18, arg1_18)
	return arg0_18.tasks[arg1_18]
end

function var0_0.GetFutureTask(arg0_19, arg1_19)
	return arg0_19.futureTasks[arg1_19]
end

function var0_0.SetTraceId(arg0_20, arg1_20)
	arg0_20.traceId = arg1_20
end

function var0_0.GetTraceId(arg0_21)
	return arg0_21.traceId
end

function var0_0.GetTraceTask(arg0_22)
	if arg0_22.traceId == 0 then
		return nil
	end

	return arg0_22.tasks[arg0_22.traceId]
end

function var0_0.SetMainTraceId(arg0_23, arg1_23)
	arg0_23.mainTraceId = arg1_23
end

function var0_0.GetMainTraceId(arg0_24)
	return arg0_24.mainTraceId
end

function var0_0.GetMainTraceTask(arg0_25)
	if arg0_25.mainTraceId == 0 then
		return nil
	end

	return arg0_25.tasks[arg0_25.mainTraceId]
end

function var0_0.GetPriorityTraceTaskId(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.tasks) do
		if not table.contains(IslandTaskType.EXCLUED_TRACK_TYPES, iter1_26:GetType()) and arg0_26:IsShowInTaskUI(iter1_26) then
			table.insert(var0_26, iter1_26)
		end
	end

	table.sort(var0_26, CompareFuncs({
		function(arg0_27)
			return -arg0_27:GetAcceptTime()
		end,
		function(arg0_28)
			return IslandTaskType.GetTrackPriority(arg0_28:GetType())
		end,
		function(arg0_29)
			return arg0_29.id
		end
	}))

	return var0_26[1] and var0_26[1].id or 0
end

function var0_0.GetPriorityMainTraceTaskId(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.tasks) do
		if iter1_30:GetType() == IslandTaskType.MAIN then
			return iter1_30.id
		end
	end

	return 0
end

function var0_0.AddTask(arg0_31, arg1_31)
	arg0_31.tasks[arg1_31.id] = arg1_31

	if arg0_31.randomTaskTimes[arg1_31.id] then
		arg0_31.tasks[arg1_31.id]:SetEndTime(arg0_31.randomTaskTimes[arg1_31.id])
	end

	arg0_31.futureTasks[arg1_31.id] = nil

	table.insert(arg0_31.mutexIds, arg1_31.id)

	for iter0_31, iter1_31 in pairs(arg0_31.futureTasks) do
		if arg0_31:CheckMutex(iter1_31.id) then
			arg0_31:RemoveFutureTask(iter1_31.id)
		end
	end

	arg0_31:DispatchEvent(var0_0.TASK_ADDED, arg1_31)
end

function var0_0.UpdateTask(arg0_32, arg1_32)
	arg0_32.tasks[arg1_32.id] = arg1_32

	if arg0_32.randomTaskTimes[arg1_32.id] then
		arg0_32.tasks[arg1_32.id]:SetEndTime(arg0_32.randomTaskTimes[arg1_32.id])
	end

	arg0_32:DispatchEvent(var0_0.TASK_UPDATED, arg1_32)

	if arg1_32:IsFinish() and arg1_32:IsSubmitImmediately() then
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_32.id
		})
	end
end

function var0_0.GetDiffTargetIdsByTypeAndParam(arg0_33, arg1_33, arg2_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.tasks) do
		local var1_33 = iter1_33:GetTargetIdByTypeAndParam(arg1_33, arg2_33)

		var0_33 = table.mergeArray(var0_33, var1_33, true)
	end

	return var0_33
end

function var0_0.GetTasksByTypeAndParam(arg0_34, arg1_34, arg2_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in pairs(arg0_34.tasks) do
		if iter1_34:ExistTargetType(arg1_34, arg2_34) then
			table.insert(var0_34, iter1_34)
		end
	end

	return task
end

function var0_0.ExistDailyTask(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.tasks) do
		if iter1_35:GetShowType() == IslandTaskType.DAILY then
			return true
		end
	end

	return false
end

function var0_0.AddFinishId(arg0_36, arg1_36)
	table.insert(arg0_36.finishedIds, arg1_36)

	local var0_36 = pg.island_task[arg1_36]

	if var0_36.type == IslandTaskType.DAILY and var0_36.count_offset == 1 then
		arg0_36.finishedDailyCntInWeek = arg0_36.finishedDailyCntInWeek + 1
	end

	arg0_36:DispatchEvent(var0_0.TASK_FINISH, arg1_36)
end

function var0_0.RemoveTask(arg0_37, arg1_37)
	local var0_37 = arg0_37.tasks[arg1_37]

	arg0_37.tasks[arg1_37] = nil

	arg0_37:DispatchEvent(var0_0.TASK_REMOVED, var0_37)
end

function var0_0.RemoveFutureTask(arg0_38, arg1_38)
	local var0_38 = arg0_38.futureTasks[arg1_38]

	arg0_38.futureTasks[arg1_38] = nil

	arg0_38:DispatchEvent(var0_0.FUTURE_TASK_REMOVED, var0_38)
end

function var0_0.UpdatePerDay(arg0_39)
	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
		arg0_39.finishedDailyCntInWeek = 0
	end

	pg.m02:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK)
end

function var0_0.UpdateRandomRefreshTask(arg0_40, arg1_40)
	for iter0_40, iter1_40 in ipairs(arg1_40.remove_task_list or {}) do
		arg0_40.tasks[iter1_40] = nil
	end

	for iter2_40, iter3_40 in ipairs(arg1_40.remove_task_finish or {}) do
		table.removebyvalue(arg0_40.finishedIds, iter3_40)
	end

	arg0_40:InitFutureTasks(arg1_40.task_list_random or {})

	for iter4_40, iter5_40 in ipairs(arg1_40.task_list or {}) do
		local var0_40 = IslandTask.New(iter5_40)

		arg0_40:AddTask(var0_40)
	end

	if arg1_40.task_list and #arg1_40.task_list > 0 then
		arg0_40:TryAutoTrackTask()
	end
end

function var0_0.UpdatePerSecond(arg0_41)
	for iter0_41, iter1_41 in pairs(arg0_41.tasks) do
		if not iter1_41:InTime() then
			arg0_41:RemoveTask(iter1_41.id)
		end
	end

	local var0_41 = {}

	for iter2_41, iter3_41 in pairs(arg0_41.futureTasks) do
		if not iter3_41:InTime() then
			arg0_41:RemoveFutureTask(iter3_41.id)
		end
	end

	local var1_41 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_41.acceptCheckTimestampTags[var1_41] then
		arg0_41.acceptCheckTimestampTags[var1_41] = nil

		arg0_41:TryAcceptAutoTasks()
	end
end

function var0_0.TryAcceptAutoTasks(arg0_42, arg1_42)
	local var0_42 = {}

	arg0_42.acceptCheckTimestampTags = {}

	for iter0_42, iter1_42 in pairs(arg0_42.futureTasks) do
		if iter1_42:IsAcceptImmediately() and iter1_42:IsUnlock() then
			table.insert(var0_42, iter1_42.id)
		elseif iter1_42:IsUnlockWaitTime() then
			arg0_42.acceptCheckTimestampTags[iter1_42:GetUnlockTime()] = true
		end
	end

	if #var0_42 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var0_42,
			callback = arg1_42
		})
	else
		existCall(arg1_42)
	end
end

function var0_0.TrySubmitAutoTasks(arg0_43, arg1_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in pairs(arg0_43.tasks) do
		if iter1_43:IsFinish() and iter1_43:IsSubmitImmediately() then
			table.insert(var0_43, function(arg0_44)
				pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
					taskId = iter1_43.id,
					callback = arg0_44
				})
			end)
		end
	end

	seriesAsync(var0_43, function()
		existCall(arg1_43)
	end)
end

function var0_0.TryAutoTrackTask(arg0_46)
	local var0_46 = arg0_46:GetPriorityTraceTaskId()

	if var0_46 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var0_46,
			type = IslandTaskTrackCard.TYPES.OTHER
		})
	end

	local var1_46 = arg0_46:GetPriorityMainTraceTaskId()

	if var1_46 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var1_46,
			type = IslandTaskTrackCard.TYPES.MAIN
		})
	end
end

function var0_0.GetCanAcceptTasks(arg0_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in pairs(arg0_47.futureTasks) do
		if iter1_47:IsUnlock() then
			table.insert(var0_47, iter1_47)
		end
	end

	return var0_47
end

function var0_0.GetCanSubmitTasks(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.tasks) do
		if iter1_48:IsFinish() then
			table.insert(var0_48, iter1_48)
		end
	end

	return var0_48
end

function var0_0.GetCanAcceptTasksByMapId(arg0_49, arg1_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.futureTasks) do
		if iter1_49:getConfig("map_trigger_tips") == arg1_49 and iter1_49:IsUnlock() then
			table.insert(var0_49, iter1_49)
		end
	end

	return var0_49
end

function var0_0.GetCanSubmitTasksByMapId(arg0_50, arg1_50)
	local var0_50 = {}

	for iter0_50, iter1_50 in pairs(arg0_50.tasks) do
		if iter1_50:getConfig("map_complete_tips") == arg1_50 and iter1_50:IsFinish() then
			table.insert(var0_50, iter1_50)
		end
	end

	return var0_50
end

function var0_0.IsServerAcceptType(arg0_51)
	return pg.island_task[arg0_51].trigger_type == 3
end

return var0_0
