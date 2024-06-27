local var0_0 = class("AvatarFrameProxy", import(".NetProxy"))

var0_0.FRAME_TASK_UPDATED = "frame task updated"
var0_0.FRAME_TASK_TIME_OUT = "frame task time out"

function var0_0.register(arg0_1)
	arg0_1.avatarFrames = {}
	arg0_1.actTasks = {}
end

function var0_0.initListData(arg0_2, arg1_2, arg2_2)
	arg0_2.avatarFrames = {}

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg2_2) do
		local var1_2 = arg0_2:createAvatarFrameTask(arg1_2, iter1_2)

		table.insert(var0_2, var1_2)
	end

	table.insert(arg0_2.avatarFrames, {
		actId = arg1_2,
		tasks = var0_2
	})
end

function var0_0.update(arg0_3, arg1_3, arg2_3)
	for iter0_3, iter1_3 in ipairs(arg2_3) do
		arg0_3:updateAvatarTask(arg1_3, iter1_3)
	end

	arg0_3.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
end

function var0_0.addData(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg2_4) do
		local var0_4 = arg0_4:createAvatarFrameTask(arg1_4, iter1_4)

		arg0_4:addAvatarTask(arg1_4, var0_4)
	end

	arg0_4.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
end

function var0_0.removeData(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg2_5) do
		arg0_5:removeAvatarTask(arg1_5, iter1_5.id)
	end

	arg0_5.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
end

function var0_0.createAvatarFrameTask(arg0_6, arg1_6, arg2_6)
	local var0_6 = pg.activity_template[arg1_6].config_id

	return (AvatarFrameTask.New(arg1_6, var0_6, arg2_6))
end

function var0_0.updateAvatarTask(arg0_7, arg1_7, arg2_7)
	for iter0_7 = 1, #arg0_7.avatarFrames do
		if arg0_7.avatarFrames[iter0_7].actId == arg1_7 then
			local var0_7 = arg0_7.avatarFrames[iter0_7]

			for iter1_7 = #var0_7.tasks, 1, -1 do
				if var0_7.tasks[iter1_7].id == arg2_7.id then
					var0_7.tasks[iter1_7]:updateProgress(arg2_7.progress)
				end
			end
		end
	end
end

function var0_0.addAvatarTask(arg0_8, arg1_8, arg2_8)
	for iter0_8 = 1, #arg0_8.avatarFrames do
		if arg0_8.avatarFrames[iter0_8].actId == arg1_8 then
			local var0_8 = arg0_8.avatarFrames[iter0_8]

			for iter1_8 = #var0_8.tasks, 1, -1 do
				if var0_8.tasks[iter1_8].id == arg2_8.id then
					table.remove(var0_8.tasks, iter1_8)
				end
			end

			table.insert(var0_8.tasks, arg2_8)
		end
	end
end

function var0_0.removeAvatarTask(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, #arg0_9.avatarFrames do
		if arg0_9.avatarFrames[iter0_9].actId == arg1_9 then
			local var0_9 = arg0_9.avatarFrames[iter0_9]

			for iter1_9 = #var0_9.tasks, 1, -1 do
				if var0_9.tasks[iter1_9].id == arg2_9 then
					table.remove(var0_9.tasks, iter1_9)
				end
			end
		end
	end
end

function var0_0.getAvatarFrameById(arg0_10, arg1_10)
	for iter0_10 = 1, #arg0_10.avatarFrames do
		if arg0_10.avatarFrames[iter0_10].actId == arg1_10 then
			return Clone(arg0_10.avatarFrames[iter0_10])
		end
	end

	return nil
end

function var0_0.getAllAvatarFrame(arg0_11)
	return Clone(arg0_11.avatarFrames)
end

function var0_0.getCanReceiveCount(arg0_12)
	local var0_12 = 0

	for iter0_12 = 1, #arg0_12.avatarFrames do
		local var1_12 = arg0_12.avatarFrames[iter0_12]

		for iter1_12, iter2_12 in ipairs(var1_12.tasks) do
			if iter2_12:getTaskStatus() == 1 then
				var0_12 = var0_12 + 1
			end
		end
	end

	return var0_12
end

function var0_0.clearTimeOut(arg0_13)
	if not arg0_13.avatarFrames or #arg0_13.avatarFrames == 0 then
		return
	end

	local var0_13 = false

	for iter0_13 = #arg0_13.avatarFrames, 1, -1 do
		local var1_13 = arg0_13.avatarFrames[iter0_13].actId
		local var2_13 = getProxy(ActivityProxy):getActivityById(var1_13)

		if not var2_13 or var2_13:isEnd() then
			table.remove(arg0_13.avatarFrames, iter0_13)

			var0_13 = true
		end
	end

	if var0_13 then
		arg0_13.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
		arg0_13.facade:sendNotification(var0_0.FRAME_TASK_TIME_OUT)
	end
end

return var0_0
