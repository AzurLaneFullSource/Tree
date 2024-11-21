local var0_0 = class("MiniGameTaskProgressUpdateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = pg.task_data_template[var1_1]
	local var3_1 = getProxy(TaskProxy)
	local var4_1 = var3_1:getTaskById(var1_1)

	if not var4_1 then
		return
	end

	local var5_1 = var4_1:getConfig("sub_type")
	local var6_1 = tonumber(var4_1:getConfig("target_id"))
	local var7_1 = var0_1.progressAdd

	pg.ConnectionMgr.GetInstance():Send(20016, {
		event_type = var5_1,
		event_target = var6_1,
		event_count = var7_1
	}, 20017, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var4_1.progress + var7_1

			var4_1:updateProgress(var0_2)
			var3_1:updateTask(var4_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
