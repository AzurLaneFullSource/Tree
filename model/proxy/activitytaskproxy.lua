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

function var0_0.updateProgressBySubType(arg0_6, arg1_6, arg2_6, arg3_6)
	for iter0_6 = 1, #arg0_6.actTasks do
		if arg0_6.actTasks[iter0_6].actId == arg1_6 then
			for iter1_6, iter2_6 in ipairs(arg0_6.actTasks[iter0_6].tasks) do
				if iter2_6:getConfig("sub_type") == arg2_6 then
					iter2_6:updateProgress(arg3_6)
				end
			end
		end
	end

	arg0_6:checkAutoSubmit()
end

function var0_0.addActList(arg0_7, arg1_7, arg2_7)
	for iter0_7, iter1_7 in ipairs(arg2_7) do
		for iter2_7 = 1, #arg0_7.actTasks do
			if arg0_7.actTasks[iter2_7].actId == arg1_7 then
				local var0_7 = arg0_7.actTasks[iter2_7].tasks

				for iter3_7 = #var0_7, 1, -1 do
					if var0_7[iter3_7].id == iter1_7.id then
						table.remove(var0_7, iter3_7)
					end
				end

				local var1_7 = arg0_7:createTask(arg1_7, iter1_7)

				table.insert(var0_7, var1_7)
			end
		end
	end

	arg0_7:checkAutoSubmit()
end

function var0_0.checkAutoSubmit(arg0_8)
	if not arg0_8.actTasks or #arg0_8.actTasks == 0 then
		return
	end

	for iter0_8 = 1, #arg0_8.actTasks do
		local var0_8 = arg0_8.actTasks[iter0_8].actId
		local var1_8 = arg0_8.actTasks[iter0_8].tasks
		local var2_8 = {}

		for iter1_8, iter2_8 in ipairs(var1_8) do
			if iter2_8.autoCommit and iter2_8:isFinish() then
				if not table.contains(arg0_8.autoSubmitTasks, iter2_8.id) then
					table.insert(var2_8, iter2_8.id)
					table.insert(arg0_8.autoSubmitTasks, iter2_8.id)
				else
					warning("task_id" .. iter2_8.id .. "已经存在于提交列表中，无需重复提交")
				end
			end
		end

		if #var2_8 > 0 then
			arg0_8:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = var0_8,
				task_ids = var2_8
			})
		end
	end
end

function var0_0.removeActList(arg0_9, arg1_9, arg2_9)
	for iter0_9, iter1_9 in ipairs(arg2_9) do
		for iter2_9 = 1, #arg0_9.actTasks do
			if arg0_9.actTasks[iter2_9].actId == arg1_9 then
				local var0_9 = arg0_9.actTasks[iter2_9].tasks

				for iter3_9 = #var0_9, 1, -1 do
					if var0_9[iter3_9].id == iter1_9.id then
						if var0_9[iter3_9]:isCircle() then
							var0_9[iter3_9]:updateProgress(0)
						else
							local var1_9 = table.remove(var0_9, iter3_9)

							arg0_9:finishActTask(arg1_9, var1_9.id)
						end
					end
				end
			end
		end
	end
end

function var0_0.getTaskById(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.actTasks) do
		if iter1_10.actId == arg1_10 then
			return Clone(iter1_10.tasks)
		end
	end

	return {}
end

function var0_0.getFinishTaskById(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.actTasks) do
		if iter1_11.actId == arg1_11 then
			local var0_11 = Clone(iter1_11.finish_tasks)

			_.each(var0_11, function(arg0_12)
				arg0_12:setOver()
			end)

			return var0_11
		end
	end

	return {}
end

function var0_0.getFinishTasksByActId(arg0_13, arg1_13)
	local var0_13 = getProxy(ActivityProxy):getActivityById(arg1_13)

	if not var0_13 then
		return {}
	end

	local var1_13 = var0_13:GetFinishedTaskIds()

	return _.map(var1_13, function(arg0_14)
		local var0_14 = ActivityTask.New(arg1_13, {
			id = arg0_14
		})

		var0_14:setOver()

		return var0_14
	end)
end

function var0_0.checkTasksFinish(arg0_15, arg1_15, arg2_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15:getFinishTasksByActId(arg1_15)) do
		var0_15[iter1_15.id] = true
	end

	return underscore.all(arg2_15, function(arg0_16)
		return var0_15[arg0_16.id]
	end)
end

function var0_0.getTaskVOsByActId(arg0_17, arg1_17)
	local var0_17 = arg0_17:getTaskById(arg1_17)

	table.insertto(var0_17, arg0_17:getFinishTasksByActId(arg1_17))

	return var0_17
end

function var0_0.getActTaskTip(arg0_18, arg1_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18.actTasks) do
		if iter1_18.actId == arg1_18 then
			var0_18 = iter1_18.tasks
		end
	end

	local var1_18 = 0

	for iter2_18, iter3_18 in ipairs(var0_18) do
		if not iter3_18:isCircle() and not iter3_18:isOver() and iter3_18:isFinish() and not iter3_18.autoCommit then
			var1_18 = var1_18 + 1
		end
	end

	return var1_18 > 0
end

function var0_0.getTaskVo(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:getTaskById(arg1_19)

	for iter0_19 = 1, #var0_19 do
		if var0_19[iter0_19].id == arg2_19 then
			return Clone(var0_19[iter0_19])
		end
	end

	return nil
end

function var0_0.createTask(arg0_20, arg1_20, arg2_20)
	return (ActivityTask.New(arg1_20, arg2_20))
end

function var0_0.getFinishTasks(arg0_21)
	local var0_21 = getProxy(ActivityProxy):GetTaskActivities()
	local var1_21 = {}

	_.each(_.map(var0_21, function(arg0_22)
		return arg0_21:getFinishTasksByActId(arg0_22.id)
	end), function(arg0_23)
		table.insertto(var1_21, arg0_23)
	end)

	return var1_21
end

return var0_0
