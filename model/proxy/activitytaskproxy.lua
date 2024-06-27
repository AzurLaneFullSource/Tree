local var0_0 = class("ActivityTaskProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.actTasks = {}
	arg0_1.autoSubmitTasks = {}
end

function var0_0.initActList(arg0_2, arg1_2, arg2_2)
	if not arg2_2 then
		return {}
	end

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg2_2) do
		local var1_2 = arg0_2:createTask(arg1_2, iter1_2)

		table.insert(var0_2, var1_2)
	end

	table.insert(arg0_2.actTasks, {
		actId = arg1_2,
		tasks = var0_2
	})
	arg0_2:checkAutoSubmit()
end

function var0_0.updateActList(arg0_3, arg1_3, arg2_3)
	for iter0_3, iter1_3 in ipairs(arg2_3) do
		for iter2_3 = 1, #arg0_3.actTasks do
			if arg0_3.actTasks[iter2_3].actId == arg1_3 then
				for iter3_3, iter4_3 in ipairs(arg0_3.actTasks[iter2_3].tasks) do
					if iter4_3.id == iter1_3.id then
						iter4_3:updateProgress(iter1_3.progress)
					end
				end
			end
		end
	end

	arg0_3:checkAutoSubmit()
end

function var0_0.addActList(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg2_4) do
		for iter2_4 = 1, #arg0_4.actTasks do
			if arg0_4.actTasks[iter2_4].actId == arg1_4 then
				local var0_4 = arg0_4.actTasks[iter2_4].tasks

				for iter3_4 = #var0_4, 1, -1 do
					if var0_4[iter3_4].id == iter1_4.id then
						table.remove(var0_4, iter3_4)
					end
				end

				local var1_4 = arg0_4:createTask(arg1_4, iter1_4)

				table.insert(var0_4, var1_4)
			end
		end
	end

	arg0_4:checkAutoSubmit()
end

function var0_0.checkAutoSubmit(arg0_5)
	if not arg0_5.actTasks or #arg0_5.actTasks == 0 then
		return
	end

	for iter0_5 = 1, #arg0_5.actTasks do
		local var0_5 = arg0_5.actTasks[iter0_5].actId
		local var1_5 = arg0_5.actTasks[iter0_5].tasks
		local var2_5 = {}

		for iter1_5, iter2_5 in ipairs(var1_5) do
			if iter2_5.autoCommit and iter2_5:isFinish() then
				if not table.contains(arg0_5.autoSubmitTasks, iter2_5.id) then
					table.insert(var2_5, iter2_5.id)
					table.insert(arg0_5.autoSubmitTasks, iter2_5.id)
				else
					warning("task_id" .. iter2_5.id .. "已经存在于提交列表中，无需重复提交")
				end
			end
		end

		if #var2_5 > 0 then
			arg0_5:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = var0_5,
				task_ids = var2_5
			})
		end
	end
end

function var0_0.removeActList(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg2_6) do
		for iter2_6 = 1, #arg0_6.actTasks do
			if arg0_6.actTasks[iter2_6].actId == arg1_6 then
				local var0_6 = arg0_6.actTasks[iter2_6].tasks

				for iter3_6 = #var0_6, 1, -1 do
					if var0_6[iter3_6].id == iter1_6.id then
						if not var0_6[iter3_6]:isRepeated() then
							var0_6[iter3_6]:updateProgress(0)
						end

						if not var0_6[iter3_6]:isCircle() then
							table.remove(var0_6, iter3_6)
						end
					end
				end
			end
		end
	end
end

function var0_0.getTaskById(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.actTasks) do
		if iter1_7.actId == arg1_7 then
			return Clone(iter1_7.tasks)
		end
	end

	return {}
end

function var0_0.getFinishTasksByActId(arg0_8, arg1_8)
	local var0_8 = getProxy(ActivityProxy):getActivityById(arg1_8)

	if not var0_8 then
		return {}
	end

	local var1_8 = var0_8:GetFinishedTaskIds()

	return _.map(var1_8, function(arg0_9)
		local var0_9 = ActivityTask.New(arg1_8, {
			id = arg0_9
		})

		var0_9:setOver()

		return var0_9
	end)
end

function var0_0.checkTasksFinish(arg0_10, arg1_10, arg2_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10:getFinishTasksByActId(arg1_10)) do
		var0_10[iter1_10.id] = true
	end

	return underscore.all(arg2_10, function(arg0_11)
		return var0_10[arg0_11.id]
	end)
end

function var0_0.getTaskVOsByActId(arg0_12, arg1_12)
	local var0_12 = arg0_12:getTaskById(arg1_12)

	table.insertto(var0_12, arg0_12:getFinishTasksByActId(arg1_12))

	return var0_12
end

function var0_0.getActTaskTip(arg0_13, arg1_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.actTasks) do
		if iter1_13.actId == arg1_13 then
			var0_13 = iter1_13.tasks
		end
	end

	local var1_13 = 0

	for iter2_13, iter3_13 in ipairs(var0_13) do
		if not iter3_13:isCircle() and not iter3_13:isOver() and iter3_13:isFinish() and not iter3_13.autoCommit then
			var1_13 = var1_13 + 1
		end
	end

	return var1_13 > 0
end

function var0_0.getTaskVo(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:getTaskById(arg1_14)

	for iter0_14 = 1, #var0_14 do
		if var0_14[iter0_14].id == arg2_14 then
			return Clone(var0_14[iter0_14])
		end
	end

	return nil
end

function var0_0.createTask(arg0_15, arg1_15, arg2_15)
	return (ActivityTask.New(arg1_15, arg2_15))
end

function var0_0.getFinishTasks(arg0_16)
	local var0_16 = getProxy(ActivityProxy):GetTaskActivities()
	local var1_16 = {}

	_.each(_.map(var0_16, function(arg0_17)
		return arg0_16:getFinishTasksByActId(arg0_17.id)
	end), function(arg0_18)
		table.insertto(var1_16, arg0_18)
	end)

	return var1_16
end

return var0_0
