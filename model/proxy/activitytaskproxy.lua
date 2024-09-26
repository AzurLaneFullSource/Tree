local var0_0 = class("ActivityTaskProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.actTasks = {}
	arg0_1.autoSubmitTasks = {}
end

function var0_0.initActList(arg0_2, arg1_2, arg2_2, arg3_2)
	if not arg2_2 then
		return {}
	end

	local var0_2 = {}
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(arg2_2) do
		local var2_2 = arg0_2:createTask(arg1_2, iter1_2)

		table.insert(var0_2, var2_2)
	end

	if arg3_2 and #arg3_2 > 0 then
		for iter2_2, iter3_2 in ipairs(arg3_2) do
			local var3_2 = arg0_2:createTask(arg1_2, {
				id = iter3_2
			})

			table.insert(var1_2, var3_2)
		end
	end

	table.insert(arg0_2.actTasks, {
		actId = arg1_2,
		tasks = var0_2,
		finish_tasks = var1_2
	})
	arg0_2:checkAutoSubmit()
end

function var0_0.finishActTask(arg0_3, arg1_3, arg2_3)
	for iter0_3 = 1, #arg0_3.actTasks do
		if arg0_3.actTasks[iter0_3].actId == arg1_3 then
			table.insert(arg0_3.actTasks[iter0_3].finish_tasks, arg0_3:createTask(arg1_3, {
				id = arg2_3
			}))
		end
	end
end

function var0_0.updateActList(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg2_4) do
		for iter2_4 = 1, #arg0_4.actTasks do
			if arg0_4.actTasks[iter2_4].actId == arg1_4 then
				for iter3_4, iter4_4 in ipairs(arg0_4.actTasks[iter2_4].tasks) do
					if iter4_4.id == iter1_4.id then
						iter4_4:updateProgress(iter1_4.progress)
					end
				end
			end
		end
	end

	arg0_4:checkAutoSubmit()
end

function var0_0.addActList(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg2_5) do
		for iter2_5 = 1, #arg0_5.actTasks do
			if arg0_5.actTasks[iter2_5].actId == arg1_5 then
				local var0_5 = arg0_5.actTasks[iter2_5].tasks

				for iter3_5 = #var0_5, 1, -1 do
					if var0_5[iter3_5].id == iter1_5.id then
						table.remove(var0_5, iter3_5)
					end
				end

				local var1_5 = arg0_5:createTask(arg1_5, iter1_5)

				table.insert(var0_5, var1_5)
			end
		end
	end

	arg0_5:checkAutoSubmit()
end

function var0_0.checkAutoSubmit(arg0_6)
	if not arg0_6.actTasks or #arg0_6.actTasks == 0 then
		return
	end

	for iter0_6 = 1, #arg0_6.actTasks do
		local var0_6 = arg0_6.actTasks[iter0_6].actId
		local var1_6 = arg0_6.actTasks[iter0_6].tasks
		local var2_6 = {}

		for iter1_6, iter2_6 in ipairs(var1_6) do
			if iter2_6.autoCommit and iter2_6:isFinish() then
				if not table.contains(arg0_6.autoSubmitTasks, iter2_6.id) then
					table.insert(var2_6, iter2_6.id)
					table.insert(arg0_6.autoSubmitTasks, iter2_6.id)
				else
					warning("task_id" .. iter2_6.id .. "已经存在于提交列表中，无需重复提交")
				end
			end
		end

		if #var2_6 > 0 then
			arg0_6:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = var0_6,
				task_ids = var2_6
			})
		end
	end
end

function var0_0.removeActList(arg0_7, arg1_7, arg2_7)
	for iter0_7, iter1_7 in ipairs(arg2_7) do
		for iter2_7 = 1, #arg0_7.actTasks do
			if arg0_7.actTasks[iter2_7].actId == arg1_7 then
				local var0_7 = arg0_7.actTasks[iter2_7].tasks

				for iter3_7 = #var0_7, 1, -1 do
					if var0_7[iter3_7].id == iter1_7.id then
						if not var0_7[iter3_7]:isCircle() then
							var0_7[iter3_7]:updateProgress(0)
						end

						if not var0_7[iter3_7]:isCircle() then
							table.remove(var0_7, iter3_7)
						end
					end
				end
			end
		end
	end
end

function var0_0.getTaskById(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.actTasks) do
		if iter1_8.actId == arg1_8 then
			return Clone(iter1_8.tasks)
		end
	end

	return {}
end

function var0_0.getFinishTaskById(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.actTasks) do
		if iter1_9.actId == arg1_9 then
			local var0_9 = Clone(iter1_9.finish_tasks)

			_.each(var0_9, function(arg0_10)
				arg0_10:setOver()
			end)

			return var0_9
		end
	end

	return {}
end

function var0_0.getFinishTasksByActId(arg0_11, arg1_11)
	local var0_11 = getProxy(ActivityProxy):getActivityById(arg1_11)

	if not var0_11 then
		return {}
	end

	local var1_11 = var0_11:GetFinishedTaskIds()

	return _.map(var1_11, function(arg0_12)
		local var0_12 = ActivityTask.New(arg1_11, {
			id = arg0_12
		})

		var0_12:setOver()

		return var0_12
	end)
end

function var0_0.checkTasksFinish(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13:getFinishTasksByActId(arg1_13)) do
		var0_13[iter1_13.id] = true
	end

	return underscore.all(arg2_13, function(arg0_14)
		return var0_13[arg0_14.id]
	end)
end

function var0_0.getTaskVOsByActId(arg0_15, arg1_15)
	local var0_15 = arg0_15:getTaskById(arg1_15)

	table.insertto(var0_15, arg0_15:getFinishTasksByActId(arg1_15))

	return var0_15
end

function var0_0.getActTaskTip(arg0_16, arg1_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.actTasks) do
		if iter1_16.actId == arg1_16 then
			var0_16 = iter1_16.tasks
		end
	end

	local var1_16 = 0

	for iter2_16, iter3_16 in ipairs(var0_16) do
		if not iter3_16:isCircle() and not iter3_16:isOver() and iter3_16:isFinish() and not iter3_16.autoCommit then
			var1_16 = var1_16 + 1
		end
	end

	return var1_16 > 0
end

function var0_0.getTaskVo(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17:getTaskById(arg1_17)

	for iter0_17 = 1, #var0_17 do
		if var0_17[iter0_17].id == arg2_17 then
			return Clone(var0_17[iter0_17])
		end
	end

	return nil
end

function var0_0.createTask(arg0_18, arg1_18, arg2_18)
	return (ActivityTask.New(arg1_18, arg2_18))
end

function var0_0.getFinishTasks(arg0_19)
	local var0_19 = getProxy(ActivityProxy):GetTaskActivities()
	local var1_19 = {}

	_.each(_.map(var0_19, function(arg0_20)
		return arg0_19:getFinishTasksByActId(arg0_20.id)
	end), function(arg0_21)
		table.insertto(var1_19, arg0_21)
	end)

	return var1_19
end

return var0_0
