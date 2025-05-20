local var0_0 = class("CommanderManualPage", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg1_1.id
	arg0_1.pt = arg1_1.pt
	arg0_1.award = arg1_1.award
	arg0_1.finishedTaskIds = arg2_1
	arg0_1.topFinishedTaskIds = arg2_1
	arg0_1.isUnlock = arg3_1
	arg0_1.topPage = 0
	arg0_1.topUnlockTaskIds = {}

	for iter0_1, iter1_1 in ipairs(pg.tutorial_handbook.all) do
		local var0_1 = pg.tutorial_handbook[iter1_1]

		if table.contains(var0_1.tag_list, arg0_1.id) then
			arg0_1.topPage = iter1_1
			arg0_1.topUnlockTaskIds = var0_1.unlock_param

			break
		end
	end

	arg0_1.leftUnlockTaskIds = arg0_1:getConfig("unlock")
	arg0_1.unlockTaskIds = {}
	arg0_1.taskIds = {}
	arg0_1.taskIdList = {}

	for iter2_1, iter3_1 in ipairs(arg0_1:getConfig("task_list")) do
		local var1_1 = iter3_1[1]
		local var2_1 = iter3_1[2]

		table.insert(arg0_1.unlockTaskIds, var2_1)
		table.insert(arg0_1.taskIds, var1_1)
		table.insertto(arg0_1.taskIdList, var1_1)
	end

	arg0_1.initTaskIdList = Clone(arg0_1.taskIdList)

	arg0_1:ChangeUnlock()

	arg0_1.doingGetTaskIndexes = {}
end

function var0_0.bindConfigTable(arg0_2)
	return pg.tutorial_handbook_task
end

function var0_0.AddPt(arg0_3)
	arg0_3.isUnlock = true
	arg0_3.pt = arg0_3.pt + 1
end

function var0_0.AddAward(arg0_4)
	arg0_4.isUnlock = true
	arg0_4.award = arg0_4.award + 1
end

function var0_0.AddFinishedTaskId(arg0_5, arg1_5)
	arg0_5.isUnlock = true

	table.insert(arg0_5.finishedTaskIds, arg1_5)
end

function var0_0.ChangeUnlock(arg0_6, arg1_6)
	if arg1_6 then
		arg0_6.topFinishedTaskIds = arg1_6
	end

	for iter0_6, iter1_6 in ipairs(arg0_6.topUnlockTaskIds) do
		if not table.contains(arg0_6.topFinishedTaskIds, iter1_6) then
			return
		end
	end

	for iter2_6, iter3_6 in ipairs(arg0_6.leftUnlockTaskIds) do
		if not table.contains(arg0_6.finishedTaskIds, iter3_6) then
			return
		end
	end

	arg0_6.isUnlock = true
end

function var0_0.GetTasks(arg0_7)
	if not arg0_7.isUnlock then
		return
	end

	for iter0_7, iter1_7 in ipairs(arg0_7.unlockTaskIds) do
		local var0_7 = true

		for iter2_7, iter3_7 in ipairs(iter1_7) do
			if not table.contains(arg0_7.finishedTaskIds, iter3_7) then
				var0_7 = false

				break
			end
		end

		if var0_7 then
			for iter4_7, iter5_7 in ipairs(arg0_7.taskIds[iter0_7]) do
				if not getProxy(TaskProxy):getTaskById(iter5_7) and not table.contains(arg0_7.finishedTaskIds, iter5_7) and not table.contains(arg0_7.doingGetTaskIndexes, iter0_7) then
					pg.m02:sendNotification(GAME.COMMANDER_MANUAL_OP, {
						operation = CommanderManualProxy.GET_TASK,
						pageId = arg0_7.id,
						index = iter0_7
					})
					table.insert(arg0_7.doingGetTaskIndexes, iter0_7)

					break
				end
			end
		end
	end
end

function var0_0.RemoveDoingGetTaskIndex(arg0_8, arg1_8)
	table.remove(arg0_8.doingGetTaskIndexes, arg1_8)
end

function var0_0.IsComplete(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.taskIdList) do
		if not table.contains(arg0_9.finishedTaskIds, iter1_9) then
			return false
		end
	end

	if arg0_9.award < #arg0_9:getConfig("target") then
		return false
	end

	return true
end

function var0_0.GetLockTip(arg0_10)
	if not arg0_10.leftUnlockTaskIds or #arg0_10.leftUnlockTaskIds == 0 then
		return ""
	end

	local var0_10 = arg0_10.leftUnlockTaskIds[1]

	return pg.task_data_template[var0_10].desc
end

function var0_0.GetTaskLockTip(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.taskIds) do
		if table.contains(iter1_11, arg1_11) and #arg0_11.unlockTaskIds[iter0_11] > 0 then
			local var0_11 = arg0_11.unlockTaskIds[iter0_11][1]

			return pg.task_data_template[var0_11].desc
		end
	end

	return ""
end

function var0_0.IsTaskComplete(arg0_12, arg1_12)
	return table.contains(arg0_12.finishedTaskIds, arg1_12)
end

function var0_0.GetCurrentPtTarget(arg0_13)
	local var0_13 = arg0_13:getConfig("target")

	if arg0_13.award == #var0_13 then
		return var0_13[arg0_13.award]
	else
		return var0_13[arg0_13.award + 1]
	end
end

function var0_0.GetCurrentPtAward(arg0_14)
	local var0_14 = arg0_14:getConfig("drop_client")

	if arg0_14.award == #var0_14 then
		return var0_14[arg0_14.award]
	else
		return var0_14[arg0_14.award + 1]
	end
end

function var0_0.SortTaskIdList(arg0_15)
	local var0_15 = getProxy(TaskProxy)

	table.sort(arg0_15.taskIdList, CompareFuncs({
		function(arg0_16)
			if var0_15:getTaskById(arg0_16) then
				return 1
			elseif arg0_15:IsTaskComplete(arg0_16) then
				return 2
			else
				return 3
			end
		end,
		function(arg0_17)
			local var0_17 = var0_15:getTaskById(arg0_17)

			if var0_17 then
				return -var0_17:getTaskStatus()
			else
				return 0
			end
		end,
		function(arg0_18)
			return table.indexof(arg0_15.initTaskIdList, arg0_18)
		end
	}))
end

function var0_0.ShouldShowTip(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.taskIdList) do
		local var0_19 = getProxy(TaskProxy):getTaskById(iter1_19)

		if var0_19 and var0_19:getTaskStatus() == 1 then
			return true
		end
	end

	if arg0_19.pt >= arg0_19:GetCurrentPtTarget() and arg0_19.award < #arg0_19:getConfig("target") then
		return true
	end

	return false
end

return var0_0
