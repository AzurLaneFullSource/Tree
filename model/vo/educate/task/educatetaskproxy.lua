local var0_0 = class("EducateTaskProxy")

var0_0.TASK_ADDED = "EducateTaskProxy.TASK_ADDED"
var0_0.TASK_REMOVED = "EducateTaskProxy.TASK_REMOVED"
var0_0.TASK_UPDATED = "EducateTaskProxy.TASK_UPDATED"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.binder = arg1_1
	arg0_1.data = {}
	arg0_1.targetSetDays = {}

	for iter0_1, iter1_1 in ipairs(pg.gameset.child_target_set_date.description) do
		arg0_1.targetSetDays[iter0_1] = EducateHelper.GetTimeFromCfg(iter1_1)
	end
end

function var0_0.SetUp(arg0_2, arg1_2)
	arg0_2.data = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.tasks or {}) do
		arg0_2.data[iter1_2.id] = EducateTask.New(iter1_2)
	end

	arg0_2:SetTarget(arg1_2.targetId or 0)

	arg0_2.finishMindTaskIds = arg1_2.finishMindTaskIds
	arg0_2.isGotTargetAward = arg1_2.isGotTargetAward
end

function var0_0.UpdateTargetAwardStatus(arg0_3, arg1_3)
	arg0_3.isGotTargetAward = arg1_3
end

function var0_0.CanGetTargetAward(arg0_4)
	return not arg0_4.isGotTargetAward
end

function var0_0.AddTask(arg0_5, arg1_5)
	local var0_5 = EducateTask.New(arg1_5)

	arg0_5.data[var0_5.id] = var0_5

	if var0_5:IsMind() then
		EducateTipHelper.SetNewTip(EducateTipHelper.NEW_MIND_TASK)
	end

	arg0_5.binder:sendNotification(var0_0.TASK_ADDED)
end

function var0_0.RemoveTaskById(arg0_6, arg1_6)
	arg0_6.data[arg1_6] = nil

	arg0_6.binder:sendNotification(var0_0.TASK_REMOVED)
end

function var0_0.UpdateTask(arg0_7, arg1_7)
	local var0_7 = arg0_7.data[arg1_7.id]

	if var0_7 == nil then
		return
	end

	var0_7.progress = arg1_7.progress

	arg0_7.binder:sendNotification(var0_0.TASK_UPDATED)
end

function var0_0.GetTasksBySystem(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.data) do
		if iter1_8:GetSystemType() == arg1_8 then
			table.insert(var0_8, iter1_8:clone())
		end
	end

	return var0_8
end

function var0_0.GetTaskById(arg0_9, arg1_9)
	return arg0_9.data[arg1_9] and arg0_9.data[arg1_9]:clone() or nil
end

function var0_0.SetTarget(arg0_10, arg1_10)
	arg0_10.targetId = arg1_10

	if arg0_10.targetId == 0 then
		arg0_10.targetTaskIds = {}
	else
		arg0_10.targetTaskIds = pg.child_target_set[arg0_10.targetId].ids
	end
end

function var0_0.GetTargetId(arg0_11)
	return arg0_11.targetId
end

function var0_0.GetTargetSetDays(arg0_12)
	return arg0_12.targetSetDays
end

function var0_0.CheckTargetSet(arg0_13)
	if arg0_13.targetId == 0 then
		return true
	end

	local var0_13 = getProxy(EducateProxy):GetCurTime()

	for iter0_13, iter1_13 in pairs(arg0_13.targetSetDays) do
		if EducateHelper.IsSameDay(iter1_13, var0_13) then
			return pg.child_target_set[arg0_13.targetId].stage ~= iter0_13
		end
	end

	return false
end

function var0_0.GetTargetTasksForShow(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.targetTaskIds) do
		if arg0_14.data[iter1_14] and not arg0_14.isGotTargetAward then
			table.insert(var0_14, arg0_14:GetTaskById(iter1_14))
		else
			local var1_14 = EducateTask.New({
				id = iter1_14
			})

			var1_14:SetRecieve()
			table.insert(var0_14, var1_14)
		end
	end

	return var0_14
end

function var0_0.GetMainTasksForShow(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(pg.child_task.all) do
		if pg.child_task[iter1_15].type_1 == EducateTask.STSTEM_TYPE_MAIN then
			if arg0_15.data[iter1_15] then
				table.insert(var0_15, arg0_15:GetTaskById(iter1_15))
			else
				local var1_15 = EducateTask.New({
					id = iter1_15
				})

				if var1_15:InTime() then
					var1_15:SetRecieve()
					table.insert(var0_15, var1_15)
				end
			end
		end
	end

	return var0_15
end

function var0_0.FilterByGroup(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		local var1_16 = iter1_16:getConfig("group")

		if not var0_16[var1_16] then
			var0_16[var1_16] = {}
		end

		table.insert(var0_16[var1_16], iter1_16)
	end

	local var2_16 = {}

	for iter2_16, iter3_16 in pairs(var0_16) do
		table.sort(iter3_16, CompareFuncs({
			function(arg0_17)
				return arg0_17:IsReceive() and 1 or 0
			end,
			function(arg0_18)
				return -arg0_18:getConfig("order")
			end,
			function(arg0_19)
				return -arg0_19.id
			end
		}))

		if arg2_16 then
			if underscore.any(iter3_16, function(arg0_20)
				return not arg0_20:IsReceive()
			end) then
				table.insert(var2_16, iter3_16[1])
			end
		else
			table.insert(var2_16, iter3_16[1])
		end
	end

	table.sort(var2_16, CompareFuncs({
		function(arg0_21)
			return arg0_21:IsReceive() and 1 or 0
		end,
		function(arg0_22)
			return arg0_22:IsFinish() and 0 or 1
		end,
		function(arg0_23)
			return arg0_23:getConfig("group")
		end,
		function(arg0_24)
			return -arg0_24.id
		end
	}))

	return var2_16
end

function var0_0.GetOtherTargetTaskProgress(arg0_25)
	if arg0_25.targetId == 0 then
		return 0, 0
	end

	local var0_25 = pg.child_target_set[arg0_25.targetId].target_progress
	local var1_25 = pg.child_target_set[arg0_25.targetId].ids

	return underscore.reduce(var1_25, 0, function(arg0_26, arg1_26)
		return arg0_26 + (arg0_25.data[arg1_26] and 0 or pg.child_task[arg1_26].task_target_progress)
	end), var0_25
end

function var0_0.GetMainTargetTaskProgress(arg0_27)
	local var0_27 = 0
	local var1_27 = 0

	for iter0_27, iter1_27 in ipairs(pg.child_task.all) do
		if pg.child_task[iter1_27].type_1 == EducateTask.STSTEM_TYPE_MAIN then
			if arg0_27.data[iter1_27] then
				var0_27 = var0_27 + 1
			elseif EducateTask.New({
				id = iter1_27
			}):InTime() then
				var1_27 = var1_27 + 1
				var0_27 = var0_27 + 1
			end
		end
	end

	return var1_27, var0_27
end

function var0_0.GetShowTargetTasks(arg0_28)
	local var0_28 = arg0_28:FilterByGroup(arg0_28:GetTargetTasksForShow())

	table.sort(var0_28, CompareFuncs({
		function(arg0_29)
			return arg0_29:IsReceive() and 1 or 0
		end,
		function(arg0_30)
			return -arg0_30:getConfig("order")
		end,
		function(arg0_31)
			return -arg0_31.id
		end
	}))

	return var0_28
end

function var0_0.GetSiteEnterAddTasks(arg0_32, arg1_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.data) do
		if iter1_32:NeedAddProgressFromSiteEnter() and EducateHelper.IsMatchSubType(iter1_32:getConfig("sub_type"), arg1_32) then
			table.insert(var0_32, iter1_32:clone())
		end
	end

	return var0_32
end

function var0_0.GetPerformAddTasks(arg0_33, arg1_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.data) do
		if iter1_33:NeedAddProgressFromPerform() and EducateHelper.IsMatchSubType(iter1_33:getConfig("sub_type"), arg1_33) then
			table.insert(var0_33, iter1_33:clone())
		end
	end

	return var0_33
end

function var0_0.OnNewWeek(arg0_34)
	return
end

function var0_0.IsShowMindTasksTip(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if iter1_35:IsMind() and iter1_35:IsFinish() then
			return true
		end
	end

	return false
end

function var0_0.IsShowMainTasksTip(arg0_36)
	local var0_36 = arg0_36:FilterByGroup(arg0_36:GetMainTasksForShow())[1]

	return var0_36 and not var0_36:IsReceive() and var0_36:IsFinish()
end

function var0_0.IsShowTargetTasksTip(arg0_37)
	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		if iter1_37:IsTarget() and iter1_37:IsFinish() then
			return true
		end
	end

	return false
end

function var0_0.IsShowOtherTasksTip(arg0_38)
	if arg0_38:IsShowMainTasksTip() then
		return true
	end

	if arg0_38.isGotTargetAward then
		return false
	end

	local var0_38, var1_38 = arg0_38:GetOtherTargetTaskProgress()

	if var0_38 / var1_38 >= 1 then
		return true
	end

	return arg0_38:IsShowTargetTasksTip()
end

return var0_0
