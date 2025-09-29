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
			return not var0_0.IsServerAcceptType(arg0_3) and not arg0_2:CheckMutex(arg0_3)
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

function var0_0.IsPassId(arg0_10, arg1_10)
	return table.contains(arg0_10.mutexIds, arg1_10)
end

function var0_0.GetTasks(arg0_11)
	return arg0_11.tasks
end

function var0_0.GetShowTasks(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.tasks) do
		local var1_12 = iter1_12:getConfig("type")

		if var1_12 ~= IslandTaskType.SEASON then
			local var2_12 = iter1_12:getConfig("link_task")
			local var3_12 = underscore.all(var2_12, function(arg0_13)
				return arg0_12:IsFinishTask(arg0_13)
			end)

			if var1_12 == IslandTaskType.HIDE then
				if #var2_12 > 0 and var3_12 then
					table.insert(var0_12, iter1_12)
				end
			elseif var3_12 then
				table.insert(var0_12, iter1_12)
			end
		end
	end

	return var0_12
end

function var0_0.GetTask(arg0_14, arg1_14)
	return arg0_14.tasks[arg1_14]
end

function var0_0.GetFutureTask(arg0_15, arg1_15)
	return arg0_15.futureTasks[arg1_15]
end

function var0_0.SetTraceId(arg0_16, arg1_16)
	arg0_16.traceId = arg1_16
end

function var0_0.GetTraceId(arg0_17)
	return arg0_17.traceId
end

function var0_0.GetTraceTask(arg0_18)
	if arg0_18.traceId == 0 then
		return nil
	end

	return arg0_18.tasks[arg0_18.traceId]
end

function var0_0.GetPriorityTraceTaskId(arg0_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in pairs(arg0_19.tasks) do
		if not table.contains(IslandTaskType.EXCLUED_TRACK_TYPES, iter1_19:GetType()) then
			table.insert(var0_19, iter1_19)
		end
	end

	table.sort(var0_19, CompareFuncs({
		function(arg0_20)
			return -arg0_20:GetAcceptTime()
		end,
		function(arg0_21)
			return IslandTaskType.GetTrackPriority(arg0_21:GetType())
		end,
		function(arg0_22)
			return arg0_22.id
		end
	}))

	return var0_19[1] and var0_19[1].id
end

function var0_0.AddTask(arg0_23, arg1_23)
	arg0_23.tasks[arg1_23.id] = arg1_23

	if arg0_23.randomTaskTimes[arg1_23.id] then
		arg0_23.tasks[arg1_23.id]:SetEndTime(arg0_23.randomTaskTimes[arg1_23.id])
	end

	arg0_23.futureTasks[arg1_23.id] = nil

	table.insert(arg0_23.mutexIds, arg1_23.id)

	for iter0_23, iter1_23 in pairs(arg0_23.futureTasks) do
		if arg0_23:CheckMutex(iter1_23.id) then
			arg0_23:RemoveFutureTask(iter1_23.id)
		end
	end

	arg0_23:DispatchEvent(var0_0.TASK_ADDED, arg1_23)
end

function var0_0.UpdateTask(arg0_24, arg1_24)
	arg0_24.tasks[arg1_24.id] = arg1_24

	if arg0_24.randomTaskTimes[arg1_24.id] then
		arg0_24.tasks[arg1_24.id]:SetEndTime(arg0_24.randomTaskTimes[arg1_24.id])
	end

	arg0_24:DispatchEvent(var0_0.TASK_UPDATED, arg1_24)

	if arg1_24:IsFinish() and arg1_24:IsSubmitImmediately() then
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_24.id
		})
	end
end

function var0_0.GetDiffTargetIdsByTypeAndParam(arg0_25, arg1_25, arg2_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.tasks) do
		local var1_25 = iter1_25:GetTargetIdByTypeAndParam(arg1_25, arg2_25)

		var0_25 = table.mergeArray(var0_25, var1_25, true)
	end

	return var0_25
end

function var0_0.GetTasksByTypeAndParam(arg0_26, arg1_26, arg2_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.tasks) do
		if iter1_26:ExistTargetType(arg1_26, arg2_26) then
			table.insert(var0_26, iter1_26)
		end
	end

	return task
end

function var0_0.ExistDailyTask(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.tasks) do
		if iter1_27:GetShowType() == IslandTaskType.DAILY then
			return true
		end
	end

	return false
end

function var0_0.AddFinishId(arg0_28, arg1_28)
	table.insert(arg0_28.finishedIds, arg1_28)
	arg0_28:DispatchEvent(var0_0.TASK_FINISH)
end

function var0_0.RemoveTask(arg0_29, arg1_29)
	local var0_29 = arg0_29.tasks[arg1_29]

	arg0_29.tasks[arg1_29] = nil

	arg0_29:DispatchEvent(var0_0.TASK_REMOVED, var0_29)
end

function var0_0.RemoveFutureTask(arg0_30, arg1_30)
	local var0_30 = arg0_30.futureTasks[arg1_30]

	arg0_30.futureTasks[arg1_30] = nil

	arg0_30:DispatchEvent(var0_0.FUTURE_TASK_REMOVED, var0_30)
end

function var0_0.UpdatePerDay(arg0_31)
	pg.m02:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK)
end

function var0_0.UpdateRandomRefreshTask(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg1_32.remove_task_list or {}) do
		arg0_32.tasks[iter1_32] = nil
	end

	for iter2_32, iter3_32 in ipairs(arg1_32.remove_task_finish or {}) do
		table.removebyvalue(arg0_32.finishedIds, iter3_32)
	end

	arg0_32:InitFutureTasks(arg1_32.task_list_random or {})
end

function var0_0.UpdatePerSecond(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.tasks) do
		if not iter1_33:InTime() then
			arg0_33:RemoveTask(iter1_33.id)
		end
	end

	local var0_33 = {}

	for iter2_33, iter3_33 in pairs(arg0_33.futureTasks) do
		if not iter3_33:InTime() then
			arg0_33:RemoveFutureTask(iter3_33.id)
		end
	end

	local var1_33 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_33.acceptCheckTimestampTags[var1_33] then
		arg0_33.acceptCheckTimestampTags[var1_33] = nil

		arg0_33:TryAcceptAutoTasks()
	end
end

function var0_0.TryAcceptAutoTasks(arg0_34, arg1_34)
	local var0_34 = {}

	arg0_34.acceptCheckTimestampTags = {}

	for iter0_34, iter1_34 in pairs(arg0_34.futureTasks) do
		if iter1_34:IsAcceptImmediately() and iter1_34:IsUnlock() then
			table.insert(var0_34, iter1_34.id)
		elseif iter1_34:IsUnlockWaitTime() then
			arg0_34.acceptCheckTimestampTags[iter1_34:GetUnlockTime()] = true
		end
	end

	if #var0_34 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var0_34,
			callback = arg1_34
		})
	else
		existCall(arg1_34)
	end
end

function var0_0.TrySubmitAutoTasks(arg0_35, arg1_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.tasks) do
		if iter1_35:IsFinish() and iter1_35:IsSubmitImmediately() then
			table.insert(var0_35, function(arg0_36)
				pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
					taskId = iter1_35.id,
					callback = arg0_36
				})
			end)
		end
	end

	seriesAsync(var0_35, function()
		existCall(arg1_35)
	end)
end

function var0_0.TryAutoTrackTask(arg0_38)
	local var0_38 = arg0_38:GetPriorityTraceTaskId()

	if var0_38 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var0_38
		})
	end
end

function var0_0.GetCanAcceptTasks(arg0_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in pairs(arg0_39.futureTasks) do
		if iter1_39:IsUnlock() then
			table.insert(var0_39, iter1_39)
		end
	end

	return var0_39
end

function var0_0.GetCanSubmitTasks(arg0_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.tasks) do
		if iter1_40:IsFinish() then
			table.insert(var0_40, iter1_40)
		end
	end

	return var0_40
end

function var0_0.GetCanAcceptTasksByMapId(arg0_41, arg1_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41.futureTasks) do
		if iter1_41:getConfig("map_trigger_tips") == arg1_41 and iter1_41:IsUnlock() then
			table.insert(var0_41, iter1_41)
		end
	end

	return var0_41
end

function var0_0.GetCanSubmitTasksByMapId(arg0_42, arg1_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42.tasks) do
		if iter1_42:getConfig("map_complete_tips") == arg1_42 and iter1_42:IsFinish() then
			table.insert(var0_42, iter1_42)
		end
	end

	return var0_42
end

function var0_0.IsServerAcceptType(arg0_43)
	return pg.island_task[arg0_43].trigger_type == 3
end

return var0_0
