local var0_0 = class("AvatarFrameProxy", import(".NetProxy"))

var0_0.FRAME_TASK_UPDATED = "frame task updated"
var0_0.FRAME_TASK_TIME_OUT = "frame task time out"

function var0_0.register(arg0_1)
	arg0_1.avatarFrames = {}
end

function var0_0.clearData(arg0_2)
	arg0_2.avatarFrames = {}
end

function var0_0.initListData(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = {}
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg2_3) do
		local var2_3 = arg0_3:createAvatarFrameTask(arg1_3, iter1_3)

		table.insert(var0_3, var2_3)
	end

	if arg3_3 and #arg3_3 then
		for iter2_3, iter3_3 in ipairs(arg3_3) do
			local var3_3 = arg0_3:createAvatarFrameTask(arg1_3, {
				id = iter3_3
			})

			var3_3:setTaskFinish()
			table.insert(var1_3, var3_3)
		end
	end

	table.insert(arg0_3.avatarFrames, {
		actId = arg1_3,
		tasks = var0_3,
		finish_tasks = finishTask
	})
end

function var0_0.update(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg2_4) do
		arg0_4:updateAvatarTask(arg1_4, iter1_4)
	end

	arg0_4.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
end

function var0_0.addData(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg2_5) do
		local var0_5 = arg0_5:createAvatarFrameTask(arg1_5, iter1_5)

		arg0_5:addAvatarTask(arg1_5, var0_5)
	end

	arg0_5.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
end

function var0_0.removeData(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg2_6) do
		arg0_6:removeAvatarTask(arg1_6, iter1_6.id)
	end

	arg0_6.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
end

function var0_0.createAvatarFrameTask(arg0_7, arg1_7, arg2_7)
	local var0_7 = pg.activity_template[arg1_7].config_id

	return (AvatarFrameTask.New(arg1_7, var0_7, arg2_7))
end

function var0_0.updateAvatarTask(arg0_8, arg1_8, arg2_8)
	for iter0_8 = 1, #arg0_8.avatarFrames do
		if arg0_8.avatarFrames[iter0_8].actId == arg1_8 then
			local var0_8 = arg0_8.avatarFrames[iter0_8]

			for iter1_8 = #var0_8.tasks, 1, -1 do
				if var0_8.tasks[iter1_8].id == arg2_8.id then
					var0_8.tasks[iter1_8]:updateProgress(arg2_8.progress)
				end
			end
		end
	end
end

function var0_0.addAvatarTask(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, #arg0_9.avatarFrames do
		if arg0_9.avatarFrames[iter0_9].actId == arg1_9 then
			local var0_9 = arg0_9.avatarFrames[iter0_9]

			for iter1_9 = #var0_9.tasks, 1, -1 do
				if var0_9.tasks[iter1_9].id == arg2_9.id then
					table.remove(var0_9.tasks, iter1_9)
				end
			end

			table.insert(var0_9.tasks, arg2_9)
		end
	end
end

function var0_0.removeAvatarTask(arg0_10, arg1_10, arg2_10)
	for iter0_10 = 1, #arg0_10.avatarFrames do
		if arg0_10.avatarFrames[iter0_10].actId == arg1_10 then
			local var0_10 = arg0_10.avatarFrames[iter0_10]

			for iter1_10 = #var0_10.tasks, 1, -1 do
				if var0_10.tasks[iter1_10].id == arg2_10 then
					table.remove(var0_10.tasks, iter1_10)
				end
			end
		end
	end
end

function var0_0.getAvatarFrameById(arg0_11, arg1_11)
	for iter0_11 = 1, #arg0_11.avatarFrames do
		if arg0_11.avatarFrames[iter0_11].actId == arg1_11 then
			return Clone(arg0_11.avatarFrames[iter0_11])
		end
	end

	return nil
end

function var0_0.getAllAvatarFrame(arg0_12)
	return Clone(arg0_12.avatarFrames)
end

function var0_0.getCanReceiveCount(arg0_13)
	local var0_13 = 0

	for iter0_13 = 1, #arg0_13.avatarFrames do
		local var1_13 = arg0_13.avatarFrames[iter0_13]

		for iter1_13, iter2_13 in ipairs(var1_13.tasks) do
			if iter2_13:getTaskStatus() == 1 then
				var0_13 = var0_13 + 1
			end
		end
	end

	return var0_13
end

function var0_0.clearTimeOut(arg0_14)
	if not arg0_14.avatarFrames or #arg0_14.avatarFrames == 0 then
		return
	end

	local var0_14 = false

	for iter0_14 = #arg0_14.avatarFrames, 1, -1 do
		local var1_14 = arg0_14.avatarFrames[iter0_14].actId
		local var2_14 = getProxy(ActivityProxy):getActivityById(var1_14)

		if not var2_14 or var2_14:isEnd() then
			table.remove(arg0_14.avatarFrames, iter0_14)

			var0_14 = true
		end
	end

	if var0_14 then
		arg0_14.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
		arg0_14.facade:sendNotification(var0_0.FRAME_TASK_TIME_OUT)
	end
end

return var0_0
