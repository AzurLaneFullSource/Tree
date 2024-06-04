local var0 = class("EducateTaskProxy")

var0.TASK_ADDED = "EducateTaskProxy.TASK_ADDED"
var0.TASK_REMOVED = "EducateTaskProxy.TASK_REMOVED"
var0.TASK_UPDATED = "EducateTaskProxy.TASK_UPDATED"

function var0.Ctor(arg0, arg1)
	arg0.binder = arg1
	arg0.data = {}
	arg0.targetSetDays = {}

	for iter0, iter1 in ipairs(pg.gameset.child_target_set_date.description) do
		arg0.targetSetDays[iter0] = EducateHelper.GetTimeFromCfg(iter1)
	end
end

function var0.SetUp(arg0, arg1)
	arg0.data = {}

	for iter0, iter1 in ipairs(arg1.tasks or {}) do
		arg0.data[iter1.id] = EducateTask.New(iter1)
	end

	arg0:SetTarget(arg1.targetId or 0)

	arg0.finishMindTaskIds = arg1.finishMindTaskIds
	arg0.isGotTargetAward = arg1.isGotTargetAward
end

function var0.UpdateTargetAwardStatus(arg0, arg1)
	arg0.isGotTargetAward = arg1
end

function var0.CanGetTargetAward(arg0)
	return not arg0.isGotTargetAward
end

function var0.AddTask(arg0, arg1)
	local var0 = EducateTask.New(arg1)

	arg0.data[var0.id] = var0

	if var0:IsMind() then
		EducateTipHelper.SetNewTip(EducateTipHelper.NEW_MIND_TASK)
	end

	arg0.binder:sendNotification(var0.TASK_ADDED)
end

function var0.RemoveTaskById(arg0, arg1)
	arg0.data[arg1] = nil

	arg0.binder:sendNotification(var0.TASK_REMOVED)
end

function var0.UpdateTask(arg0, arg1)
	local var0 = arg0.data[arg1.id]

	if var0 == nil then
		return
	end

	var0.progress = arg1.progress

	arg0.binder:sendNotification(var0.TASK_UPDATED)
end

function var0.GetTasksBySystem(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:GetSystemType() == arg1 then
			table.insert(var0, iter1:clone())
		end
	end

	return var0
end

function var0.GetTaskById(arg0, arg1)
	return arg0.data[arg1] and arg0.data[arg1]:clone() or nil
end

function var0.SetTarget(arg0, arg1)
	arg0.targetId = arg1

	if arg0.targetId == 0 then
		arg0.targetTaskIds = {}
	else
		arg0.targetTaskIds = pg.child_target_set[arg0.targetId].ids
	end
end

function var0.GetTargetId(arg0)
	return arg0.targetId
end

function var0.GetTargetSetDays(arg0)
	return arg0.targetSetDays
end

function var0.CheckTargetSet(arg0)
	if arg0.targetId == 0 then
		return true
	end

	local var0 = getProxy(EducateProxy):GetCurTime()

	for iter0, iter1 in pairs(arg0.targetSetDays) do
		if EducateHelper.IsSameDay(iter1, var0) then
			return pg.child_target_set[arg0.targetId].stage ~= iter0
		end
	end

	return false
end

function var0.GetTargetTasksForShow(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.targetTaskIds) do
		if arg0.data[iter1] and not arg0.isGotTargetAward then
			table.insert(var0, arg0:GetTaskById(iter1))
		else
			local var1 = EducateTask.New({
				id = iter1
			})

			var1:SetRecieve()
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.GetMainTasksForShow(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.child_task.all) do
		if pg.child_task[iter1].type_1 == EducateTask.STSTEM_TYPE_MAIN then
			if arg0.data[iter1] then
				table.insert(var0, arg0:GetTaskById(iter1))
			else
				local var1 = EducateTask.New({
					id = iter1
				})

				if var1:InTime() then
					var1:SetRecieve()
					table.insert(var0, var1)
				end
			end
		end
	end

	return var0
end

function var0.FilterByGroup(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var1 = iter1:getConfig("group")

		if not var0[var1] then
			var0[var1] = {}
		end

		table.insert(var0[var1], iter1)
	end

	local var2 = {}

	for iter2, iter3 in pairs(var0) do
		table.sort(iter3, CompareFuncs({
			function(arg0)
				return arg0:IsReceive() and 1 or 0
			end,
			function(arg0)
				return -arg0:getConfig("order")
			end,
			function(arg0)
				return -arg0.id
			end
		}))

		if arg2 then
			if underscore.any(iter3, function(arg0)
				return not arg0:IsReceive()
			end) then
				table.insert(var2, iter3[1])
			end
		else
			table.insert(var2, iter3[1])
		end
	end

	table.sort(var2, CompareFuncs({
		function(arg0)
			return arg0:IsReceive() and 1 or 0
		end,
		function(arg0)
			return arg0:IsFinish() and 0 or 1
		end,
		function(arg0)
			return arg0:getConfig("group")
		end,
		function(arg0)
			return -arg0.id
		end
	}))

	return var2
end

function var0.GetOtherTargetTaskProgress(arg0)
	if arg0.targetId == 0 then
		return 0, 0
	end

	local var0 = pg.child_target_set[arg0.targetId].target_progress
	local var1 = pg.child_target_set[arg0.targetId].ids

	return underscore.reduce(var1, 0, function(arg0, arg1)
		return arg0 + (arg0.data[arg1] and 0 or pg.child_task[arg1].task_target_progress)
	end), var0
end

function var0.GetMainTargetTaskProgress(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in ipairs(pg.child_task.all) do
		if pg.child_task[iter1].type_1 == EducateTask.STSTEM_TYPE_MAIN then
			if arg0.data[iter1] then
				var0 = var0 + 1
			elseif EducateTask.New({
				id = iter1
			}):InTime() then
				var1 = var1 + 1
				var0 = var0 + 1
			end
		end
	end

	return var1, var0
end

function var0.GetShowTargetTasks(arg0)
	local var0 = arg0:FilterByGroup(arg0:GetTargetTasksForShow())

	table.sort(var0, CompareFuncs({
		function(arg0)
			return arg0:IsReceive() and 1 or 0
		end,
		function(arg0)
			return -arg0:getConfig("order")
		end,
		function(arg0)
			return -arg0.id
		end
	}))

	return var0
end

function var0.GetSiteEnterAddTasks(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:NeedAddProgressFromSiteEnter() and EducateHelper.IsMatchSubType(iter1:getConfig("sub_type"), arg1) then
			table.insert(var0, iter1:clone())
		end
	end

	return var0
end

function var0.GetPerformAddTasks(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:NeedAddProgressFromPerform() and EducateHelper.IsMatchSubType(iter1:getConfig("sub_type"), arg1) then
			table.insert(var0, iter1:clone())
		end
	end

	return var0
end

function var0.OnNewWeek(arg0)
	return
end

function var0.IsShowMindTasksTip(arg0)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1:IsMind() and iter1:IsFinish() then
			return true
		end
	end

	return false
end

function var0.IsShowMainTasksTip(arg0)
	local var0 = arg0:FilterByGroup(arg0:GetMainTasksForShow())[1]

	return var0 and not var0:IsReceive() and var0:IsFinish()
end

function var0.IsShowTargetTasksTip(arg0)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1:IsTarget() and iter1:IsFinish() then
			return true
		end
	end

	return false
end

function var0.IsShowOtherTasksTip(arg0)
	if arg0:IsShowMainTasksTip() then
		return true
	end

	if arg0.isGotTargetAward then
		return false
	end

	local var0, var1 = arg0:GetOtherTargetTaskProgress()

	if var0 / var1 >= 1 then
		return true
	end

	return arg0:IsShowTargetTasksTip()
end

return var0
