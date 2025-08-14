local var0_0 = class("UpdateLowPriorityTaskProgressCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = pg.task_data_template[var1_1]
	local var3_1
	local var4_1
	local var5_1 = getProxy(TaskProxy)
	local var6_1 = var5_1:getTaskById(var1_1)

	if not var6_1 then
		return
	end

	local var7_1 = var6_1:getActId()
	local var8_1 = var6_1:getConfig("sub_type")
	local var9_1 = false

	if var8_1 == 2001 then
		var3_1 = Task.TASK_PROGRESS_UPDATE

		local var10_1 = var2_1.target_id
		local var11_1 = var2_1.target_num
		local var12_1 = getProxy(FleetProxy):getData()

		for iter0_1, iter1_1 in pairs(var12_1) do
			if (table.contains(var10_1, iter1_1.id) or #var10_1 == 0) and iter1_1:getShipCount() == var11_1 then
				var9_1 = true

				break
			end
		end

		var4_1 = var11_1
	elseif var8_1 == 2002 then
		var3_1 = Task.TASK_PROGRESS_UPDATE

		local var13_1 = var2_1.target_id
		local var14_1 = var13_1[1]
		local var15_1 = var13_1[2]
		local var16_1 = var2_1.target_num
		local var17_1 = getProxy(FleetProxy):getData()
		local var18_1 = 0

		for iter2_1, iter3_1 in pairs(var17_1) do
			if iter3_1:getShipCount() == var15_1 and var14_1 <= iter3_1:avgLevel() then
				var18_1 = var18_1 + 1
			end
		end

		if not var6_1:isFinish() and var18_1 > var6_1.progress then
			var9_1 = true
			var4_1 = var18_1
		end
	elseif var8_1 == 2003 then
		var3_1 = Task.TASK_PROGRESS_UPDATE
		var9_1 = true
		var4_1 = 1
	elseif var8_1 == 2010 or var8_1 == 2011 then
		var3_1 = Task.TASK_PROGRESS_APPEND
		var9_1 = true
		var4_1 = 1
	elseif var8_1 == 2012 then
		var3_1 = Task.TASK_PROGRESS_UPDATE
		var4_1 = var0_1.progress
		var9_1 = true
	elseif var8_1 == 2025 then
		var3_1 = Task.TASK_PROGRESS_UPDATE
		var4_1 = 1
		var9_1 = true
	end

	if not var9_1 then
		return
	end

	local var19_1 = {
		task_id = var1_1,
		mode = var3_1,
		progress = var4_1,
		act_id = var7_1
	}

	pg.ConnectionMgr.GetInstance():Send(20209, {
		progressinfo = {
			var19_1
		}
	}, 20210, function(arg0_2)
		if arg0_2.result == 0 then
			if var3_1 == Task.TASK_PROGRESS_UPDATE then
				var6_1:updateProgress(var4_1)
			elseif var3_1 == Task.TASK_PROGRESS_APPEND then
				local var0_2 = var6_1.progress + var4_1

				var6_1:updateProgress(var0_2)
			end

			var5_1:updateTask(var6_1)
			arg0_1:sendNotification(GAME.SHARE_TASK_FINISHED)
		end
	end)
end

return var0_0
