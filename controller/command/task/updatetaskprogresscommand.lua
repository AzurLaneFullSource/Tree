local var0 = class("UpdateTaskProgressCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.taskId
	local var2 = pg.task_data_template[var1]
	local var3
	local var4
	local var5 = getProxy(TaskProxy)
	local var6 = var5:getTaskById(var1)

	if not var6 then
		return
	end

	local var7 = var6:getConfig("sub_type")
	local var8 = false

	if var7 == 2001 then
		var3 = Task.TASK_PROGRESS_UPDATE

		local var9 = var2.target_id
		local var10 = var2.target_num
		local var11 = getProxy(FleetProxy):getData()

		for iter0, iter1 in pairs(var11) do
			if (table.contains(var9, iter1.id) or #var9 == 0) and iter1:getShipCount() == var10 then
				var8 = true

				break
			end
		end

		var4 = var10
	elseif var7 == 2002 then
		var3 = Task.TASK_PROGRESS_UPDATE

		local var12 = var2.target_id
		local var13 = var12[1]
		local var14 = var12[2]
		local var15 = var2.target_num
		local var16 = getProxy(FleetProxy):getData()
		local var17 = 0

		for iter2, iter3 in pairs(var16) do
			if iter3:getShipCount() == var14 and var13 <= iter3:avgLevel() then
				var17 = var17 + 1
			end
		end

		if not var6:isFinish() and var17 > var6.progress then
			var8 = true
			var4 = var17
		end
	elseif var7 == 2003 then
		var3 = Task.TASK_PROGRESS_UPDATE
		var8 = true
		var4 = 1
	elseif var7 == 2010 or var7 == 2011 then
		var3 = Task.TASK_PROGRESS_APPEND
		var8 = true
		var4 = 1
	elseif var7 == 2012 then
		var3 = Task.TASK_PROGRESS_UPDATE
		var4 = var0.progress
		var8 = true
	end

	if not var8 then
		return
	end

	local var18 = {
		id = var1,
		mode = var3,
		progress = var4
	}

	pg.ConnectionMgr.GetInstance():Send(20009, {
		progressinfo = {
			var18
		}
	}, 20010, function(arg0)
		if arg0.result == 0 then
			if var3 == Task.TASK_PROGRESS_UPDATE then
				var6:updateProgress(var4)
			elseif var3 == Task.TASK_PROGRESS_APPEND then
				local var0 = var6.progress + var4

				var6:updateProgress(var0)
			end

			var5:updateTask(var6)
			arg0:sendNotification(GAME.SHARE_TASK_FINISHED)
		end
	end)
end

return var0
