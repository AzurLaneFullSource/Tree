local var0_0 = class("IslandTaskAgency", import(".IslandBaseAgency"))

var0_0.TASK_ADDED = "IslandTaskAgency.TASK_ADDED"
var0_0.TASK_UPDATED = "IslandTaskAgency.TASK_UPDATED"
var0_0.TASK_REMOVED = "IslandTaskAgency.TASK_REMOVED"
var0_0.FUTURE_TASK_REMOVED = "IslandTaskAgency.FUTURE_TASK_REMOVED"
var0_0.TASK_FINISH = "IslandTaskAgency.TASK_FINISH"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.task_info or {}

	arg0_1.traceId = var0_1.focus_id or 0

	if arg0_1.traceId ~= 0 and pg.island_task[arg0_1.traceId].type == IslandTaskType.MAIN then
		arg0_1.traceId = 0
	end

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
		local var1_14 = iter1_14:getConfig("type")

		if var1_14 ~= IslandTaskType.SEASON then
			local var2_14 = iter1_14:getConfig("link_task")
			local var3_14 = underscore.all(var2_14, function(arg0_15)
				return arg0_14:IsFinishTask(arg0_15)
			end)

			if var1_14 == IslandTaskType.HIDE then
				if #var2_14 > 0 and var3_14 then
					table.insert(var0_14, iter1_14)
				end
			elseif var3_14 then
				table.insert(var0_14, iter1_14)
			end
		end
	end

	return var0_14
end

function var0_0.GetTask(arg0_16, arg1_16)
	return arg0_16.tasks[arg1_16]
end

function var0_0.GetFutureTask(arg0_17, arg1_17)
	return arg0_17.futureTasks[arg1_17]
end

function var0_0.SetTraceId(arg0_18, arg1_18)
	arg0_18.traceId = arg1_18
end

function var0_0.GetTraceId(arg0_19)
	return arg0_19.traceId
end

function var0_0.GetTraceTask(arg0_20)
	if arg0_20.traceId == 0 then
		return nil
	end

	return arg0_20.tasks[arg0_20.traceId]
end

function var0_0.SetMainTraceId(arg0_21, arg1_21)
	arg0_21.mainTraceId = arg1_21
end

function var0_0.GetMainTraceId(arg0_22)
	return arg0_22.mainTraceId
end

function var0_0.GetMainTraceTask(arg0_23)
	if arg0_23.mainTraceId == 0 then
		return nil
	end

	return arg0_23.tasks[arg0_23.mainTraceId]
end

function var0_0.GetPriorityTraceTaskId(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.tasks) do
		if not table.contains(IslandTaskType.EXCLUED_TRACK_TYPES, iter1_24:GetType()) then
			table.insert(var0_24, iter1_24)
		end
	end

	table.sort(var0_24, CompareFuncs({
		function(arg0_25)
			return -arg0_25:GetAcceptTime()
		end,
		function(arg0_26)
			return IslandTaskType.GetTrackPriority(arg0_26:GetType())
		end,
		function(arg0_27)
			return arg0_27.id
		end
	}))

	return var0_24[1] and var0_24[1].id or 0
end

function var0_0.GetPriorityMainTraceTaskId(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.tasks) do
		if iter1_28:GetType() == IslandTaskType.MAIN then
			return iter1_28.id
		end
	end

	return 0
end

function var0_0.AddTask(arg0_29, arg1_29)
	arg0_29.tasks[arg1_29.id] = arg1_29

	if arg0_29.randomTaskTimes[arg1_29.id] then
		arg0_29.tasks[arg1_29.id]:SetEndTime(arg0_29.randomTaskTimes[arg1_29.id])
	end

	arg0_29.futureTasks[arg1_29.id] = nil

	table.insert(arg0_29.mutexIds, arg1_29.id)

	for iter0_29, iter1_29 in pairs(arg0_29.futureTasks) do
		if arg0_29:CheckMutex(iter1_29.id) then
			arg0_29:RemoveFutureTask(iter1_29.id)
		end
	end

	arg0_29:DispatchEvent(var0_0.TASK_ADDED, arg1_29)
end

function var0_0.UpdateTask(arg0_30, arg1_30)
	arg0_30.tasks[arg1_30.id] = arg1_30

	if arg0_30.randomTaskTimes[arg1_30.id] then
		arg0_30.tasks[arg1_30.id]:SetEndTime(arg0_30.randomTaskTimes[arg1_30.id])
	end

	arg0_30:DispatchEvent(var0_0.TASK_UPDATED, arg1_30)

	if arg1_30:IsFinish() and arg1_30:IsSubmitImmediately() then
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_30.id
		})
	end
end

function var0_0.GetDiffTargetIdsByTypeAndParam(arg0_31, arg1_31, arg2_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in pairs(arg0_31.tasks) do
		local var1_31 = iter1_31:GetTargetIdByTypeAndParam(arg1_31, arg2_31)

		var0_31 = table.mergeArray(var0_31, var1_31, true)
	end

	return var0_31
end

function var0_0.GetTasksByTypeAndParam(arg0_32, arg1_32, arg2_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.tasks) do
		if iter1_32:ExistTargetType(arg1_32, arg2_32) then
			table.insert(var0_32, iter1_32)
		end
	end

	return task
end

function var0_0.ExistDailyTask(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.tasks) do
		if iter1_33:GetShowType() == IslandTaskType.DAILY then
			return true
		end
	end

	return false
end

function var0_0.AddFinishId(arg0_34, arg1_34)
	table.insert(arg0_34.finishedIds, arg1_34)
	arg0_34:DispatchEvent(var0_0.TASK_FINISH)
end

function var0_0.RemoveTask(arg0_35, arg1_35)
	local var0_35 = arg0_35.tasks[arg1_35]

	arg0_35.tasks[arg1_35] = nil

	arg0_35:DispatchEvent(var0_0.TASK_REMOVED, var0_35)
end

function var0_0.RemoveFutureTask(arg0_36, arg1_36)
	local var0_36 = arg0_36.futureTasks[arg1_36]

	arg0_36.futureTasks[arg1_36] = nil

	arg0_36:DispatchEvent(var0_0.FUTURE_TASK_REMOVED, var0_36)
end

function var0_0.UpdatePerDay(arg0_37)
	pg.m02:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK)
end

function var0_0.UpdateRandomRefreshTask(arg0_38, arg1_38)
	for iter0_38, iter1_38 in ipairs(arg1_38.remove_task_list or {}) do
		arg0_38.tasks[iter1_38] = nil
	end

	for iter2_38, iter3_38 in ipairs(arg1_38.remove_task_finish or {}) do
		table.removebyvalue(arg0_38.finishedIds, iter3_38)
	end

	arg0_38:InitFutureTasks(arg1_38.task_list_random or {})
end

function var0_0.UpdatePerSecond(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.tasks) do
		if not iter1_39:InTime() then
			arg0_39:RemoveTask(iter1_39.id)
		end
	end

	local var0_39 = {}

	for iter2_39, iter3_39 in pairs(arg0_39.futureTasks) do
		if not iter3_39:InTime() then
			arg0_39:RemoveFutureTask(iter3_39.id)
		end
	end

	local var1_39 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_39.acceptCheckTimestampTags[var1_39] then
		arg0_39.acceptCheckTimestampTags[var1_39] = nil

		arg0_39:TryAcceptAutoTasks()
	end
end

function var0_0.TryAcceptAutoTasks(arg0_40, arg1_40)
	local var0_40 = {}

	arg0_40.acceptCheckTimestampTags = {}

	for iter0_40, iter1_40 in pairs(arg0_40.futureTasks) do
		if iter1_40:IsAcceptImmediately() and iter1_40:IsUnlock() then
			table.insert(var0_40, iter1_40.id)
		elseif iter1_40:IsUnlockWaitTime() then
			arg0_40.acceptCheckTimestampTags[iter1_40:GetUnlockTime()] = true
		end
	end

	if #var0_40 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var0_40,
			callback = arg1_40
		})
	else
		existCall(arg1_40)
	end
end

function var0_0.TrySubmitAutoTasks(arg0_41, arg1_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41.tasks) do
		if iter1_41:IsFinish() and iter1_41:IsSubmitImmediately() then
			table.insert(var0_41, function(arg0_42)
				pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
					taskId = iter1_41.id,
					callback = arg0_42
				})
			end)
		end
	end

	seriesAsync(var0_41, function()
		existCall(arg1_41)
	end)
end

function var0_0.TryAutoTrackTask(arg0_44)
	local var0_44 = arg0_44:GetPriorityTraceTaskId()

	if var0_44 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var0_44,
			type = IslandTaskTrackCard.TYPES.OTHER
		})
	end

	local var1_44 = arg0_44:GetPriorityMainTraceTaskId()

	if var1_44 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var1_44,
			type = IslandTaskTrackCard.TYPES.MAIN
		})
	end
end

function var0_0.GetCanAcceptTasks(arg0_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in pairs(arg0_45.futureTasks) do
		if iter1_45:IsUnlock() then
			table.insert(var0_45, iter1_45)
		end
	end

	return var0_45
end

function var0_0.GetCanSubmitTasks(arg0_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.tasks) do
		if iter1_46:IsFinish() then
			table.insert(var0_46, iter1_46)
		end
	end

	return var0_46
end

function var0_0.GetCanAcceptTasksByMapId(arg0_47, arg1_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in pairs(arg0_47.futureTasks) do
		if iter1_47:getConfig("map_trigger_tips") == arg1_47 and iter1_47:IsUnlock() then
			table.insert(var0_47, iter1_47)
		end
	end

	return var0_47
end

function var0_0.GetCanSubmitTasksByMapId(arg0_48, arg1_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.tasks) do
		if iter1_48:getConfig("map_complete_tips") == arg1_48 and iter1_48:IsFinish() then
			table.insert(var0_48, iter1_48)
		end
	end

	return var0_48
end

function var0_0.IsServerAcceptType(arg0_49)
	return pg.island_task[arg0_49].trigger_type == 3
end

return var0_0
