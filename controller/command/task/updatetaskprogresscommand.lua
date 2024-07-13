local var0_0 = class("UpdateTaskProgressCommand", pm.SimpleCommand)

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

	local var7_1 = var6_1:getConfig("sub_type")
	local var8_1 = false

	if var7_1 == 2001 then
		var3_1 = Task.TASK_PROGRESS_UPDATE

		local var9_1 = var2_1.target_id
		local var10_1 = var2_1.target_num
		local var11_1 = getProxy(FleetProxy):getData()

		for iter0_1, iter1_1 in pairs(var11_1) do
			if (table.contains(var9_1, iter1_1.id) or #var9_1 == 0) and iter1_1:getShipCount() == var10_1 then
				var8_1 = true

				break
			end
		end

		var4_1 = var10_1
	elseif var7_1 == 2002 then
		var3_1 = Task.TASK_PROGRESS_UPDATE

		local var12_1 = var2_1.target_id
		local var13_1 = var12_1[1]
		local var14_1 = var12_1[2]
		local var15_1 = var2_1.target_num
		local var16_1 = getProxy(FleetProxy):getData()
		local var17_1 = 0

		for iter2_1, iter3_1 in pairs(var16_1) do
			if iter3_1:getShipCount() == var14_1 and var13_1 <= iter3_1:avgLevel() then
				var17_1 = var17_1 + 1
			end
		end

		if not var6_1:isFinish() and var17_1 > var6_1.progress then
			var8_1 = true
			var4_1 = var17_1
		end
	elseif var7_1 == 2003 then
		var3_1 = Task.TASK_PROGRESS_UPDATE
		var8_1 = true
		var4_1 = 1
	elseif var7_1 == 2010 or var7_1 == 2011 then
		var3_1 = Task.TASK_PROGRESS_APPEND
		var8_1 = true
		var4_1 = 1
	elseif var7_1 == 2012 then
		var3_1 = Task.TASK_PROGRESS_UPDATE
		var4_1 = var0_1.progress
		var8_1 = true
	end

	if not var8_1 then
		return
	end

	local var18_1 = {
		id = var1_1,
		mode = var3_1,
		progress = var4_1
	}

	pg.ConnectionMgr.GetInstance():Send(20009, {
		progressinfo = {
			var18_1
		}
	}, 20010, function(arg0_2)
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
