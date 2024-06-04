local var0 = class("AvatarFrameProxy", import(".NetProxy"))

var0.FRAME_TASK_UPDATED = "frame task updated"
var0.FRAME_TASK_TIME_OUT = "frame task time out"

function var0.register(arg0)
	arg0.avatarFrames = {}
	arg0.actTasks = {}

	arg0:on(20201, function(arg0)
		arg0.avatarFrames = {}

		local function var0(arg0, arg1)
			local var0 = {}

			for iter0, iter1 in ipairs(arg1) do
				local var1 = arg0:createAvatarFrameTask(arg0, iter1)

				table.insert(var0, var1)
			end

			table.insert(arg0.avatarFrames, {
				actId = arg0,
				tasks = var0
			})
		end

		local var1 = getProxy(ActivityTaskProxy)

		for iter0, iter1 in ipairs(arg0.info) do
			local var2 = iter1.act_id
			local var3 = iter1.tasks
			local var4 = pg.activity_template[var2].type

			if var4 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0(var2, var3)
			elseif var4 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1:initActList(var2, var3)
			end
		end
	end)
	arg0:on(20202, function(arg0)
		local function var0(arg0, arg1)
			for iter0, iter1 in ipairs(arg1) do
				arg0:updateAvatarTask(arg0, iter1)
			end
		end

		local var1 = getProxy(ActivityTaskProxy)

		for iter0, iter1 in ipairs(arg0.info) do
			local var2 = iter1.act_id
			local var3 = iter1.tasks
			local var4 = pg.activity_template[var2].type

			if var4 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0(var2, var3)
			elseif var4 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1:updateActList(var2, var3)
			end
		end

		arg0.facade:sendNotification(var0.FRAME_TASK_UPDATED)
	end)
	arg0:on(20203, function(arg0)
		local function var0(arg0, arg1)
			for iter0, iter1 in ipairs(arg1) do
				local var0 = arg0:createAvatarFrameTask(arg0, iter1)

				arg0:addAvatarTask(arg0, var0)
			end
		end

		local var1 = getProxy(ActivityTaskProxy)

		for iter0, iter1 in ipairs(arg0.info) do
			local var2 = iter1.act_id
			local var3 = iter1.tasks
			local var4 = pg.activity_template[var2].type

			if var4 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0(var2, var3)
			elseif var4 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1:addActList(var2, var3)
			end
		end

		arg0.facade:sendNotification(var0.FRAME_TASK_UPDATED)
	end)
	arg0:on(20204, function(arg0)
		local function var0(arg0, arg1)
			for iter0, iter1 in ipairs(arg1) do
				arg0:removeAvatarTask(arg0, iter1.id)
			end
		end

		local var1 = getProxy(ActivityTaskProxy)

		for iter0, iter1 in ipairs(arg0.info) do
			local var2 = iter1.act_id
			local var3 = iter1.tasks
			local var4 = pg.activity_template[var2].type

			if var4 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0(var2, var3)
			elseif var4 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1:removeActList(var2, var3)
			end
		end

		arg0.facade:sendNotification(var0.FRAME_TASK_UPDATED)
	end)
end

function var0.createAvatarFrameTask(arg0, arg1, arg2)
	local var0 = pg.activity_template[arg1].config_id

	return (AvatarFrameTask.New(arg1, var0, arg2))
end

function var0.updateAvatarTask(arg0, arg1, arg2)
	for iter0 = 1, #arg0.avatarFrames do
		if arg0.avatarFrames[iter0].actId == arg1 then
			local var0 = arg0.avatarFrames[iter0]

			for iter1 = #var0.tasks, 1, -1 do
				if var0.tasks[iter1].id == arg2.id then
					var0.tasks[iter1]:updateProgress(arg2.progress)
				end
			end
		end
	end
end

function var0.addAvatarTask(arg0, arg1, arg2)
	for iter0 = 1, #arg0.avatarFrames do
		if arg0.avatarFrames[iter0].actId == arg1 then
			local var0 = arg0.avatarFrames[iter0]

			for iter1 = #var0.tasks, 1, -1 do
				if var0.tasks[iter1].id == arg2.id then
					table.remove(var0.tasks, iter1)
				end
			end

			table.insert(var0.tasks, arg2)
		end
	end
end

function var0.removeAvatarTask(arg0, arg1, arg2)
	for iter0 = 1, #arg0.avatarFrames do
		if arg0.avatarFrames[iter0].actId == arg1 then
			local var0 = arg0.avatarFrames[iter0]

			for iter1 = #var0.tasks, 1, -1 do
				if var0.tasks[iter1].id == arg2 then
					table.remove(var0.tasks, iter1)
				end
			end
		end
	end
end

function var0.getAvatarFrameById(arg0, arg1)
	for iter0 = 1, #arg0.avatarFrames do
		if arg0.avatarFrames[iter0].actId == arg1 then
			return Clone(arg0.avatarFrames[iter0])
		end
	end

	return nil
end

function var0.getAllAvatarFrame(arg0)
	return Clone(arg0.avatarFrames)
end

function var0.getCanReceiveCount(arg0)
	local var0 = 0

	for iter0 = 1, #arg0.avatarFrames do
		local var1 = arg0.avatarFrames[iter0]

		for iter1, iter2 in ipairs(var1.tasks) do
			if iter2:getTaskStatus() == 1 then
				var0 = var0 + 1
			end
		end
	end

	return var0
end

function var0.clearTimeOut(arg0)
	if not arg0.avatarFrames or #arg0.avatarFrames == 0 then
		return
	end

	local var0 = false

	for iter0 = #arg0.avatarFrames, 1, -1 do
		local var1 = arg0.avatarFrames[iter0].actId
		local var2 = getProxy(ActivityProxy):getActivityById(var1)

		if not var2 or var2:isEnd() then
			table.remove(arg0.avatarFrames, iter0)

			var0 = true
		end
	end

	if var0 then
		arg0.facade:sendNotification(var0.FRAME_TASK_UPDATED)
		arg0.facade:sendNotification(var0.FRAME_TASK_TIME_OUT)
	end
end

return var0
