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

function var0_0.IsFinishTask(arg0_8, arg1_8)
	return table.contains(arg0_8.finishedIds, arg1_8)
end

function var0_0.IsPassId(arg0_9, arg1_9)
	return table.contains(arg0_9.mutexIds, arg1_9)
end

function var0_0.GetTasks(arg0_10)
	return arg0_10.tasks
end

function var0_0.GetShowTasks(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.tasks) do
		local var1_11 = iter1_11:getConfig("type")

		if var1_11 ~= IslandTaskType.SEASON then
			local var2_11 = iter1_11:getConfig("link_task")
			local var3_11 = underscore.all(var2_11, function(arg0_12)
				return arg0_11:IsFinishTask(arg0_12)
			end)

			if var1_11 == IslandTaskType.SEASON then
				if #var2_11 > 0 and var3_11 then
					table.insert(var0_11, iter1_11)
				end
			elseif var3_11 then
				table.insert(var0_11, iter1_11)
			end
		end
	end

	return var0_11
end

function var0_0.GetTask(arg0_13, arg1_13)
	return arg0_13.tasks[arg1_13]
end

function var0_0.GetFutureTask(arg0_14, arg1_14)
	return arg0_14.futureTasks[arg1_14]
end

function var0_0.SetTraceId(arg0_15, arg1_15)
	arg0_15.traceId = arg1_15
end

function var0_0.GetTraceId(arg0_16)
	return arg0_16.traceId
end

function var0_0.GetTraceTask(arg0_17)
	if arg0_17.traceId == 0 then
		return nil
	end

	return arg0_17.tasks[arg0_17.traceId]
end

function var0_0.GetPriorityTraceTaskId(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.tasks) do
		if not table.contains(IslandTaskType.EXCLUED_TRACK_TYPES, iter1_18:GetType()) then
			table.insert(var0_18, iter1_18)
		end
	end

	table.sort(var0_18, CompareFuncs({
		function(arg0_19)
			return -arg0_19:GetAcceptTime()
		end,
		function(arg0_20)
			return IslandTaskType.GetTrackPriority(arg0_20:GetType())
		end,
		function(arg0_21)
			return arg0_21.id
		end
	}))

	return var0_18[1] and var0_18[1].id
end

function var0_0.AddTask(arg0_22, arg1_22)
	arg0_22.tasks[arg1_22.id] = arg1_22

	if arg0_22.randomTaskTimes[arg1_22.id] then
		arg0_22.tasks[arg1_22.id]:SetEndTime(arg0_22.randomTaskTimes[arg1_22.id])
	end

	arg0_22.futureTasks[arg1_22.id] = nil

	table.insert(arg0_22.mutexIds, arg1_22.id)

	for iter0_22, iter1_22 in pairs(arg0_22.futureTasks) do
		if arg0_22:CheckMutex(iter1_22.id) then
			arg0_22:RemoveFutureTask(iter1_22.id)
		end
	end

	arg0_22:DispatchEvent(var0_0.TASK_ADDED, arg1_22)
end

function var0_0.UpdateTask(arg0_23, arg1_23)
	arg0_23.tasks[arg1_23.id] = arg1_23

	if arg0_23.randomTaskTimes[arg1_23.id] then
		arg0_23.tasks[arg1_23.id]:SetEndTime(arg0_23.randomTaskTimes[arg1_23.id])
	end

	arg0_23:DispatchEvent(var0_0.TASK_UPDATED, arg1_23)

	if arg1_23:IsFinish() and arg1_23:IsSubmitImmediately() then
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_23.id
		})
	end
end

function var0_0.GetDiffTargetIdsByTypeAndParam(arg0_24, arg1_24, arg2_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.tasks) do
		local var1_24 = iter1_24:GetTargetIdByTypeAndParam(arg1_24, arg2_24)

		var0_24 = table.mergeArray(var0_24, var1_24, true)
	end

	return var0_24
end

function var0_0.GetTasksByTypeAndParam(arg0_25, arg1_25, arg2_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.tasks) do
		if iter1_25:ExistTargetType(arg1_25, arg2_25) then
			table.insert(var0_25, iter1_25)
		end
	end

	return task
end

function var0_0.ExistDailyTask(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.tasks) do
		if iter1_26:GetShowType() == IslandTaskType.DAILY then
			return true
		end
	end

	return false
end

function var0_0.AddFinishId(arg0_27, arg1_27)
	table.insert(arg0_27.finishedIds, arg1_27)
	arg0_27:DispatchEvent(var0_0.TASK_FINISH)
end

function var0_0.RemoveTask(arg0_28, arg1_28)
	local var0_28 = arg0_28.tasks[arg1_28]

	arg0_28.tasks[arg1_28] = nil

	arg0_28:DispatchEvent(var0_0.TASK_REMOVED, var0_28)
end

function var0_0.RemoveFutureTask(arg0_29, arg1_29)
	local var0_29 = arg0_29.futureTasks[arg1_29]

	arg0_29.futureTasks[arg1_29] = nil

	arg0_29:DispatchEvent(var0_0.FUTURE_TASK_REMOVED, var0_29)
end

function var0_0.UpdatePerDay(arg0_30)
	pg.m02:sendNotification(GAME.ISLAND_GET_RANDOM_REFRESH_TASK)
end

function var0_0.UpdateRandomRefreshTask(arg0_31, arg1_31)
	for iter0_31, iter1_31 in ipairs(arg1_31.remove_task_list or {}) do
		arg0_31.tasks[iter1_31] = nil
	end

	for iter2_31, iter3_31 in ipairs(arg1_31.remove_task_finish or {}) do
		table.removebyvalue(arg0_31.finishedIds, iter3_31)
	end

	arg0_31:InitFutureTasks(arg1_31.task_list_random or {})
end

function var0_0.UpdatePerSecond(arg0_32)
	for iter0_32, iter1_32 in pairs(arg0_32.tasks) do
		if not iter1_32:InTime() then
			arg0_32:RemoveTask(iter1_32.id)
		end
	end

	local var0_32 = {}

	for iter2_32, iter3_32 in pairs(arg0_32.futureTasks) do
		if not iter3_32:InTime() then
			arg0_32:RemoveFutureTask(iter3_32.id)
		end
	end

	local var1_32 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_32.acceptCheckTimestampTags[var1_32] then
		arg0_32.acceptCheckTimestampTags[var1_32] = nil

		arg0_32:TryAcceptAutoTasks()
	end
end

function var0_0.TryAcceptAutoTasks(arg0_33, arg1_33)
	local var0_33 = {}

	arg0_33.acceptCheckTimestampTags = {}

	for iter0_33, iter1_33 in pairs(arg0_33.futureTasks) do
		if iter1_33:IsAcceptImmediately() and iter1_33:IsUnlock() then
			table.insert(var0_33, iter1_33.id)
		elseif iter1_33:IsUnlockWaitTime() then
			arg0_33.acceptCheckTimestampTags[iter1_33:GetUnlockTime()] = true
		end
	end

	if #var0_33 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = var0_33,
			callback = arg1_33
		})
	else
		existCall(arg1_33)
	end
end

function var0_0.TrySubmitAutoTasks(arg0_34, arg1_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in pairs(arg0_34.tasks) do
		if iter1_34:IsFinish() and iter1_34:IsSubmitImmediately() then
			table.insert(var0_34, function(arg0_35)
				pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
					taskId = iter1_34.id,
					callback = arg0_35
				})
			end)
		end
	end

	seriesAsync(var0_34, function()
		existCall(arg1_34)
	end)
end

function var0_0.TryAutoTrackTask(arg0_37)
	local var0_37 = arg0_37:GetPriorityTraceTaskId()

	if var0_37 then
		pg.m02:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = var0_37
		})
	end
end

function var0_0.GetCanAcceptTasks(arg0_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in pairs(arg0_38.futureTasks) do
		if iter1_38:IsUnlock() then
			table.insert(var0_38, iter1_38)
		end
	end

	return var0_38
end

function var0_0.GetCanSubmitTasks(arg0_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in pairs(arg0_39.tasks) do
		if iter1_39:IsFinish() then
			table.insert(var0_39, iter1_39)
		end
	end

	return var0_39
end

function var0_0.GetCanAcceptTasksByMapId(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.futureTasks) do
		if iter1_40:getConfig("map_trigger_tips") == arg1_40 and iter1_40:IsUnlock() then
			table.insert(var0_40, iter1_40)
		end
	end

	return var0_40
end

function var0_0.GetCanSubmitTasksByMapId(arg0_41, arg1_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41.tasks) do
		if iter1_41:getConfig("map_complete_tips") == arg1_41 and iter1_41:IsFinish() then
			table.insert(var0_41, iter1_41)
		end
	end

	return var0_41
end

function var0_0.IsServerAcceptType(arg0_42)
	return pg.island_task[arg0_42].trigger_type == 3
end

return var0_0
