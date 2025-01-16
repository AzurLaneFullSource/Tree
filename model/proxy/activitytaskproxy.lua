local var0_0 = class("ActivityTaskProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.actTasks = {}
	arg0_1.autoSubmitTasks = {}
end

function var0_0.clearData(arg0_2)
	arg0_2.actTasks = {}
	arg0_2.autoSubmitTasks = {}
end

function var0_0.initActList(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg2_3 then
		return {}
	end

	local var0_3 = {}
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg2_3) do
		local var2_3 = arg0_3:createTask(arg1_3, iter1_3)

		table.insert(var0_3, var2_3)
	end

	if arg3_3 and #arg3_3 > 0 then
		for iter2_3, iter3_3 in ipairs(arg3_3) do
			local var3_3 = arg0_3:createTask(arg1_3, {
				id = iter3_3
			})

			table.insert(var1_3, var3_3)
		end
	end

	table.insert(arg0_3.actTasks, {
		actId = arg1_3,
		tasks = var0_3,
		finish_tasks = var1_3
	})
	arg0_3:checkAutoSubmit()
end

function var0_0.finishActTask(arg0_4, arg1_4, arg2_4)
	local var0_4 = pg.task_data_template[arg2_4].type

	if not table.contains(TotalTaskProxy.act_task_onece_type, var0_4) then
		return
	end

	for iter0_4 = 1, #arg0_4.actTasks do
		if arg0_4.actTasks[iter0_4].actId == arg1_4 then
			local var1_4 = true

			for iter1_4, iter2_4 in ipairs(arg0_4.actTasks[iter0_4].finish_tasks) do
				if iter2_4.id == arg2_4 then
					var1_4 = false

					break
				end
			end

			if var1_4 then
				table.insert(arg0_4.actTasks[iter0_4].finish_tasks, arg0_4:createTask(arg1_4, {
					id = arg2_4
				}))
			end
		end
	end
end

function var0_0.updateActList(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg2_5) do
		for iter2_5 = 1, #arg0_5.actTasks do
			if arg0_5.actTasks[iter2_5].actId == arg1_5 then
				for iter3_5, iter4_5 in ipairs(arg0_5.actTasks[iter2_5].tasks) do
					if iter4_5.id == iter1_5.id then
						iter4_5:updateProgress(iter1_5.progress)
					end
				end
			end
		end
	end

	arg0_5:checkAutoSubmit()
end

function var0_0.addActList(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg2_6) do
		for iter2_6 = 1, #arg0_6.actTasks do
			if arg0_6.actTasks[iter2_6].actId == arg1_6 then
				local var0_6 = arg0_6.actTasks[iter2_6].tasks

				for iter3_6 = #var0_6, 1, -1 do
					if var0_6[iter3_6].id == iter1_6.id then
						table.remove(var0_6, iter3_6)
					end
				end

				local var1_6 = arg0_6:createTask(arg1_6, iter1_6)

				table.insert(var0_6, var1_6)
			end
		end
	end

	arg0_6:checkAutoSubmit()
end

function var0_0.checkAutoSubmit(arg0_7)
	if not arg0_7.actTasks or #arg0_7.actTasks == 0 then
		return
	end

	for iter0_7 = 1, #arg0_7.actTasks do
		local var0_7 = arg0_7.actTasks[iter0_7].actId
		local var1_7 = arg0_7.actTasks[iter0_7].tasks
		local var2_7 = {}

		for iter1_7, iter2_7 in ipairs(var1_7) do
			if iter2_7.autoCommit and iter2_7:isFinish() then
				if not table.contains(arg0_7.autoSubmitTasks, iter2_7.id) then
					table.insert(var2_7, iter2_7.id)
					table.insert(arg0_7.autoSubmitTasks, iter2_7.id)
				else
					warning("task_id" .. iter2_7.id .. "已经存在于提交列表中，无需重复提交")
				end
			end
		end

		if #var2_7 > 0 then
			arg0_7:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = var0_7,
				task_ids = var2_7
			})
		end
	end
end

function var0_0.removeActList(arg0_8, arg1_8, arg2_8)
	for iter0_8, iter1_8 in ipairs(arg2_8) do
		for iter2_8 = 1, #arg0_8.actTasks do
			if arg0_8.actTasks[iter2_8].actId == arg1_8 then
				local var0_8 = arg0_8.actTasks[iter2_8].tasks

				for iter3_8 = #var0_8, 1, -1 do
					if var0_8[iter3_8].id == iter1_8.id then
						if var0_8[iter3_8]:isCircle() then
							var0_8[iter3_8]:updateProgress(0)
						else
							local var1_8 = table.remove(var0_8, iter3_8)

							arg0_8:finishActTask(arg1_8, var1_8.id)
						end
					end
				end
			end
		end
	end
end

function var0_0.getTaskById(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.actTasks) do
		if iter1_9.actId == arg1_9 then
			return Clone(iter1_9.tasks)
		end
	end

	return {}
end

function var0_0.getFinishTaskById(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.actTasks) do
		if iter1_10.actId == arg1_10 then
			local var0_10 = Clone(iter1_10.finish_tasks)

			_.each(var0_10, function(arg0_11)
				arg0_11:setOver()
			end)

			return var0_10
		end
	end

	return {}
end

function var0_0.getFinishTasksByActId(arg0_12, arg1_12)
	local var0_12 = getProxy(ActivityProxy):getActivityById(arg1_12)

	if not var0_12 then
		return {}
	end

	local var1_12 = var0_12:GetFinishedTaskIds()

	return _.map(var1_12, function(arg0_13)
		local var0_13 = ActivityTask.New(arg1_12, {
			id = arg0_13
		})

		var0_13:setOver()

		return var0_13
	end)
end

function var0_0.checkTasksFinish(arg0_14, arg1_14, arg2_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14:getFinishTasksByActId(arg1_14)) do
		var0_14[iter1_14.id] = true
	end

	return underscore.all(arg2_14, function(arg0_15)
		return var0_14[arg0_15.id]
	end)
end

function var0_0.getTaskVOsByActId(arg0_16, arg1_16)
	local var0_16 = arg0_16:getTaskById(arg1_16)

	table.insertto(var0_16, arg0_16:getFinishTasksByActId(arg1_16))

	return var0_16
end

function var0_0.getActTaskTip(arg0_17, arg1_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.actTasks) do
		if iter1_17.actId == arg1_17 then
			var0_17 = iter1_17.tasks
		end
	end

	local var1_17 = 0

	for iter2_17, iter3_17 in ipairs(var0_17) do
		if not iter3_17:isCircle() and not iter3_17:isOver() and iter3_17:isFinish() and not iter3_17.autoCommit then
			var1_17 = var1_17 + 1
		end
	end

	return var1_17 > 0
end

function var0_0.getTaskVo(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18:getTaskById(arg1_18)

	for iter0_18 = 1, #var0_18 do
		if var0_18[iter0_18].id == arg2_18 then
			return Clone(var0_18[iter0_18])
		end
	end

	return nil
end

function var0_0.createTask(arg0_19, arg1_19, arg2_19)
	return (ActivityTask.New(arg1_19, arg2_19))
end

function var0_0.getFinishTasks(arg0_20)
	local var0_20 = getProxy(ActivityProxy):GetTaskActivities()
	local var1_20 = {}

	_.each(_.map(var0_20, function(arg0_21)
		return arg0_20:getFinishTasksByActId(arg0_21.id)
	end), function(arg0_22)
		table.insertto(var1_20, arg0_22)
	end)

	return var1_20
end

return var0_0
