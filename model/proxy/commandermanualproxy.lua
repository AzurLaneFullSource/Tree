local var0_0 = class("CommanderManualProxy", import(".NetProxy"))

var0_0.GET_TASK = 1
var0_0.GET_PT_AWARD = 2
var0_0.TOP_PAGE_TASK = 100
var0_0.TOP_PAGE_GUIDE = 200
var0_0.TOP_PAGE_TECH = 900

function var0_0.register(arg0_1)
	arg0_1:on(22300, function(arg0_2)
		arg0_1.commanderManualPages = {}
		arg0_1.topFinishedTaskIds = arg0_2.finished_task_ids or {}

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.handbooks) do
			var0_2[iter1_2.id] = iter1_2
		end

		for iter2_2, iter3_2 in ipairs(pg.tutorial_handbook_task.all) do
			local var1_2 = pg.tutorial_handbook_task[iter3_2]
			local var2_2

			if var0_2[iter3_2] then
				var2_2 = CommanderManualPage.New(var0_2[iter3_2], arg0_1.topFinishedTaskIds, true)
			else
				var2_2 = CommanderManualPage.New({
					award = 0,
					pt = 0,
					id = iter3_2,
					finished_task_ids = {}
				}, arg0_1.topFinishedTaskIds, false)
			end

			table.insert(arg0_1.commanderManualPages, var2_2)
		end
	end)
end

function var0_0.GetPagesByType(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.commanderManualPages) do
		if iter1_3:getConfig("type") == arg1_3 then
			table.insert(var0_3, iter1_3)
		end
	end

	return var0_3
end

function var0_0.GetPageById(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.commanderManualPages) do
		if iter1_4.id == arg1_4 then
			return iter1_4
		end
	end

	return nil
end

function var0_0.AddPagePt(arg0_5, arg1_5)
	local var0_5 = arg0_5:GetPageById(arg1_5)

	if var0_5 then
		var0_5:AddPt()
	end
end

function var0_0.AddPageAward(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetPageById(arg1_6)

	if var0_6 then
		var0_6:AddAward()
	end
end

function var0_0.TaskAutoSubmitCall(arg0_7, arg1_7)
	arg0_7:UnlockTaskSubmitCall(arg1_7)
	arg0_7:ShowTaskSubmitCall(arg1_7)
end

function var0_0.UnlockTaskSubmitCall(arg0_8, arg1_8)
	local var0_8 = false

	for iter0_8, iter1_8 in ipairs(pg.tutorial_handbook.all) do
		local var1_8 = pg.tutorial_handbook[iter1_8]

		if table.contains(var1_8.unlock_param, arg1_8) then
			table.insert(arg0_8.topFinishedTaskIds, arg1_8)

			var0_8 = true

			break
		end
	end

	for iter2_8, iter3_8 in ipairs(arg0_8.commanderManualPages) do
		if table.contains(iter3_8.leftUnlockTaskIds, arg1_8) then
			iter3_8:AddFinishedTaskId(arg1_8)

			var0_8 = true
		end

		for iter4_8, iter5_8 in ipairs(iter3_8.unlockTaskIds) do
			if table.contains(iter5_8, arg1_8) then
				iter3_8:AddFinishedTaskId(arg1_8)

				var0_8 = true

				break
			end
		end
	end

	if var0_8 then
		for iter6_8, iter7_8 in ipairs(arg0_8.commanderManualPages) do
			iter7_8:ChangeUnlock(arg0_8.topFinishedTaskIds)
			iter7_8:GetTasks()
		end
	end
end

function var0_0.GetPagesTasks(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.commanderManualPages) do
		iter1_9:GetTasks()
	end
end

function var0_0.ShowTaskSubmitCall(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.commanderManualPages) do
		if table.contains(iter1_10.taskIdList, arg1_10) then
			iter1_10:AddFinishedTaskId(arg1_10)
			iter1_10:AddPt()

			break
		end
	end
end

function var0_0.AddPageTaskDone(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.commanderManualPages) do
		local var0_11 = 0

		for iter2_11, iter3_11 in ipairs(iter1_11.taskIds) do
			if table.contains(iter3_11, arg1_11.id) then
				var0_11 = iter2_11

				break
			end
		end

		if var0_11 ~= 0 then
			arg0_11:sendNotification(GAME.COMMANDER_MANUAL_OP_DONE, {
				operation = var0_0.GET_TASK,
				pageId = iter1_11.id,
				index = var0_11
			})

			break
		end
	end
end

function var0_0.IsTopUnlock(arg0_12, arg1_12)
	local var0_12 = pg.tutorial_handbook[arg1_12].unlock_param

	for iter0_12, iter1_12 in ipairs(var0_12) do
		if not table.contains(arg0_12.topFinishedTaskIds, iter1_12) then
			return false
		end
	end

	return true
end

function var0_0.GetLockTip(arg0_13, arg1_13)
	return pg.tutorial_handbook[arg1_13].lock_hint
end

function var0_0.ShouldShowTipByType(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetPagesByType(arg1_14)

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if iter1_14:ShouldShowTip() then
			return true
		end
	end

	return false
end

function var0_0.ShouldShowTaskOrGuideTip(arg0_15)
	return arg0_15:ShouldShowTipByType(1) or arg0_15:ShouldShowTipByType(2)
end

function var0_0.IsTopPageComplete(arg0_16, arg1_16)
	local var0_16 = arg0_16:GetPagesByType(arg1_16)

	for iter0_16, iter1_16 in ipairs(var0_16) do
		if not iter1_16:IsComplete() then
			return false
		end
	end

	return true
end

function var0_0.TaskProgressAdd(arg0_17, arg1_17, arg2_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(pg.task_data_template.all) do
		local var1_17 = pg.task_data_template[iter1_17]

		if var1_17.type == Task.TYPE_COMMANDER_MANUAL and var1_17.sub_type == arg1_17 then
			table.insert(var0_17, iter1_17)
		end
	end

	for iter2_17, iter3_17 in ipairs(var0_17) do
		local var2_17 = getProxy(TaskProxy):getTaskById(iter3_17)

		if var2_17 and var2_17:getTaskStatus() == 0 then
			arg0_17:sendNotification(GAME.MINI_GAME_TASK_PROGRESS_UPDATE, {
				taskId = iter3_17,
				progressAdd = arg2_17
			})
		end
	end
end

return var0_0
