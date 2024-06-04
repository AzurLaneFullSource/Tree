local var0 = class("ActivityTaskProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.actTasks = {}
	arg0.autoSubmitTasks = {}
end

function var0.initActList(arg0, arg1, arg2)
	if not arg2 then
		return {}
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg2) do
		local var1 = arg0:createTask(arg1, iter1)

		table.insert(var0, var1)
	end

	table.insert(arg0.actTasks, {
		actId = arg1,
		tasks = var0
	})
	arg0:checkAutoSubmit()
end

function var0.updateActList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		for iter2 = 1, #arg0.actTasks do
			if arg0.actTasks[iter2].actId == arg1 then
				for iter3, iter4 in ipairs(arg0.actTasks[iter2].tasks) do
					if iter4.id == iter1.id then
						iter4:updateProgress(iter1.progress)
					end
				end
			end
		end
	end

	arg0:checkAutoSubmit()
end

function var0.addActList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		for iter2 = 1, #arg0.actTasks do
			if arg0.actTasks[iter2].actId == arg1 then
				local var0 = arg0.actTasks[iter2].tasks

				for iter3 = #var0, 1, -1 do
					if var0[iter3].id == iter1.id then
						table.remove(var0, iter3)
					end
				end

				local var1 = arg0:createTask(arg1, iter1)

				table.insert(var0, var1)
			end
		end
	end

	arg0:checkAutoSubmit()
end

function var0.checkAutoSubmit(arg0)
	if not arg0.actTasks or #arg0.actTasks == 0 then
		return
	end

	for iter0 = 1, #arg0.actTasks do
		local var0 = arg0.actTasks[iter0].actId
		local var1 = arg0.actTasks[iter0].tasks
		local var2 = {}

		for iter1, iter2 in ipairs(var1) do
			if iter2.autoCommit and iter2:isFinish() then
				if not table.contains(arg0.autoSubmitTasks, iter2.id) then
					table.insert(var2, iter2.id)
					table.insert(arg0.autoSubmitTasks, iter2.id)
				else
					warning("task_id" .. iter2.id .. "已经存在于提交列表中，无需重复提交")
				end
			end
		end

		if #var2 > 0 then
			arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
				act_id = var0,
				task_ids = var2
			})
		end
	end
end

function var0.removeActList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		for iter2 = 1, #arg0.actTasks do
			if arg0.actTasks[iter2].actId == arg1 then
				local var0 = arg0.actTasks[iter2].tasks

				for iter3 = #var0, 1, -1 do
					if var0[iter3].id == iter1.id then
						if not var0[iter3]:isRepeated() then
							var0[iter3]:updateProgress(0)
						end

						if not var0[iter3]:isCircle() then
							table.remove(var0, iter3)
						end
					end
				end
			end
		end
	end
end

function var0.getTaskById(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.actTasks) do
		if iter1.actId == arg1 then
			return Clone(iter1.tasks)
		end
	end

	return {}
end

function var0.getFinishTasksByActId(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(arg1)

	if not var0 then
		return {}
	end

	local var1 = var0:GetFinishedTaskIds()

	return _.map(var1, function(arg0)
		local var0 = ActivityTask.New(arg1, {
			id = arg0
		})

		var0:setOver()

		return var0
	end)
end

function var0.checkTasksFinish(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getFinishTasksByActId(arg1)) do
		var0[iter1.id] = true
	end

	return underscore.all(arg2, function(arg0)
		return var0[arg0.id]
	end)
end

function var0.getTaskVOsByActId(arg0, arg1)
	local var0 = arg0:getTaskById(arg1)

	table.insertto(var0, arg0:getFinishTasksByActId(arg1))

	return var0
end

function var0.getActTaskTip(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.actTasks) do
		if iter1.actId == arg1 then
			var0 = iter1.tasks
		end
	end

	local var1 = 0

	for iter2, iter3 in ipairs(var0) do
		if not iter3:isCircle() and not iter3:isOver() and iter3:isFinish() and not iter3.autoCommit then
			var1 = var1 + 1
		end
	end

	return var1 > 0
end

function var0.createTask(arg0, arg1, arg2)
	return (ActivityTask.New(arg1, arg2))
end

function var0.getFinishTasks(arg0)
	local var0 = getProxy(ActivityProxy):GetTaskActivities()
	local var1 = {}

	_.each(_.map(var0, function(arg0)
		return arg0:getFinishTasksByActId(arg0.id)
	end), function(arg0)
		table.insertto(var1, arg0)
	end)

	return var1
end

return var0
