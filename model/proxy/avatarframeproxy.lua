local var0_0 = class("AvatarFrameProxy", import(".NetProxy"))

var0_0.FRAME_TASK_UPDATED = "frame task updated"
var0_0.FRAME_TASK_TIME_OUT = "frame task time out"

function var0_0.register(arg0_1)
	arg0_1.avatarFrames = {}
	arg0_1.actTasks = {}

	arg0_1:on(20201, function(arg0_2)
		arg0_1.avatarFrames = {}

		local function var0_2(arg0_3, arg1_3)
			local var0_3 = {}

			for iter0_3, iter1_3 in ipairs(arg1_3) do
				local var1_3 = arg0_1:createAvatarFrameTask(arg0_3, iter1_3)

				table.insert(var0_3, var1_3)
			end

			table.insert(arg0_1.avatarFrames, {
				actId = arg0_3,
				tasks = var0_3
			})
		end

		local var1_2 = getProxy(ActivityTaskProxy)

		for iter0_2, iter1_2 in ipairs(arg0_2.info) do
			local var2_2 = iter1_2.act_id
			local var3_2 = iter1_2.tasks
			local var4_2 = pg.activity_template[var2_2].type

			if var4_2 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0_2(var2_2, var3_2)
			elseif var4_2 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4_2 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1_2:initActList(var2_2, var3_2)
			end
		end
	end)
	arg0_1:on(20202, function(arg0_4)
		local function var0_4(arg0_5, arg1_5)
			for iter0_5, iter1_5 in ipairs(arg1_5) do
				arg0_1:updateAvatarTask(arg0_5, iter1_5)
			end
		end

		local var1_4 = getProxy(ActivityTaskProxy)

		for iter0_4, iter1_4 in ipairs(arg0_4.info) do
			local var2_4 = iter1_4.act_id
			local var3_4 = iter1_4.tasks
			local var4_4 = pg.activity_template[var2_4].type

			if var4_4 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0_4(var2_4, var3_4)
			elseif var4_4 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4_4 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1_4:updateActList(var2_4, var3_4)
			end
		end

		arg0_1.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
	end)
	arg0_1:on(20203, function(arg0_6)
		local function var0_6(arg0_7, arg1_7)
			for iter0_7, iter1_7 in ipairs(arg1_7) do
				local var0_7 = arg0_1:createAvatarFrameTask(arg0_7, iter1_7)

				arg0_1:addAvatarTask(arg0_7, var0_7)
			end
		end

		local var1_6 = getProxy(ActivityTaskProxy)

		for iter0_6, iter1_6 in ipairs(arg0_6.info) do
			local var2_6 = iter1_6.act_id
			local var3_6 = iter1_6.tasks
			local var4_6 = pg.activity_template[var2_6].type

			if var4_6 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0_6(var2_6, var3_6)
			elseif var4_6 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4_6 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1_6:addActList(var2_6, var3_6)
			end
		end

		arg0_1.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
	end)
	arg0_1:on(20204, function(arg0_8)
		local function var0_8(arg0_9, arg1_9)
			for iter0_9, iter1_9 in ipairs(arg1_9) do
				arg0_1:removeAvatarTask(arg0_9, iter1_9.id)
			end
		end

		local var1_8 = getProxy(ActivityTaskProxy)

		for iter0_8, iter1_8 in ipairs(arg0_8.info) do
			local var2_8 = iter1_8.act_id
			local var3_8 = iter1_8.tasks
			local var4_8 = pg.activity_template[var2_8].type

			if var4_8 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				var0_8(var2_8, var3_8)
			elseif var4_8 == ActivityConst.ACTIVITY_TYPE_TASK_RYZA or var4_8 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				var1_8:removeActList(var2_8, var3_8)
			end
		end

		arg0_1.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
	end)
end

function var0_0.createAvatarFrameTask(arg0_10, arg1_10, arg2_10)
	local var0_10 = pg.activity_template[arg1_10].config_id

	return (AvatarFrameTask.New(arg1_10, var0_10, arg2_10))
end

function var0_0.updateAvatarTask(arg0_11, arg1_11, arg2_11)
	for iter0_11 = 1, #arg0_11.avatarFrames do
		if arg0_11.avatarFrames[iter0_11].actId == arg1_11 then
			local var0_11 = arg0_11.avatarFrames[iter0_11]

			for iter1_11 = #var0_11.tasks, 1, -1 do
				if var0_11.tasks[iter1_11].id == arg2_11.id then
					var0_11.tasks[iter1_11]:updateProgress(arg2_11.progress)
				end
			end
		end
	end
end

function var0_0.addAvatarTask(arg0_12, arg1_12, arg2_12)
	for iter0_12 = 1, #arg0_12.avatarFrames do
		if arg0_12.avatarFrames[iter0_12].actId == arg1_12 then
			local var0_12 = arg0_12.avatarFrames[iter0_12]

			for iter1_12 = #var0_12.tasks, 1, -1 do
				if var0_12.tasks[iter1_12].id == arg2_12.id then
					table.remove(var0_12.tasks, iter1_12)
				end
			end

			table.insert(var0_12.tasks, arg2_12)
		end
	end
end

function var0_0.removeAvatarTask(arg0_13, arg1_13, arg2_13)
	for iter0_13 = 1, #arg0_13.avatarFrames do
		if arg0_13.avatarFrames[iter0_13].actId == arg1_13 then
			local var0_13 = arg0_13.avatarFrames[iter0_13]

			for iter1_13 = #var0_13.tasks, 1, -1 do
				if var0_13.tasks[iter1_13].id == arg2_13 then
					table.remove(var0_13.tasks, iter1_13)
				end
			end
		end
	end
end

function var0_0.getAvatarFrameById(arg0_14, arg1_14)
	for iter0_14 = 1, #arg0_14.avatarFrames do
		if arg0_14.avatarFrames[iter0_14].actId == arg1_14 then
			return Clone(arg0_14.avatarFrames[iter0_14])
		end
	end

	return nil
end

function var0_0.getAllAvatarFrame(arg0_15)
	return Clone(arg0_15.avatarFrames)
end

function var0_0.getCanReceiveCount(arg0_16)
	local var0_16 = 0

	for iter0_16 = 1, #arg0_16.avatarFrames do
		local var1_16 = arg0_16.avatarFrames[iter0_16]

		for iter1_16, iter2_16 in ipairs(var1_16.tasks) do
			if iter2_16:getTaskStatus() == 1 then
				var0_16 = var0_16 + 1
			end
		end
	end

	return var0_16
end

function var0_0.clearTimeOut(arg0_17)
	if not arg0_17.avatarFrames or #arg0_17.avatarFrames == 0 then
		return
	end

	local var0_17 = false

	for iter0_17 = #arg0_17.avatarFrames, 1, -1 do
		local var1_17 = arg0_17.avatarFrames[iter0_17].actId
		local var2_17 = getProxy(ActivityProxy):getActivityById(var1_17)

		if not var2_17 or var2_17:isEnd() then
			table.remove(arg0_17.avatarFrames, iter0_17)

			var0_17 = true
		end
	end

	if var0_17 then
		arg0_17.facade:sendNotification(var0_0.FRAME_TASK_UPDATED)
		arg0_17.facade:sendNotification(var0_0.FRAME_TASK_TIME_OUT)
	end
end

return var0_0
