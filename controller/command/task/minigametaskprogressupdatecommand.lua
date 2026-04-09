local var0_0 = class("MiniGameTaskProgressUpdateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.actId
	local var2_1 = var0_1.taskId
	local var3_1 = getProxy(ActivityTaskProxy)
	local var4_1 = getProxy(TaskProxy)
	local var5_1 = var1_1 and var3_1:getTaskVo(var1_1, var2_1) or var4_1:getTaskById(var2_1)

	if not var5_1 then
		return
	end

	local var6_1 = var5_1:getConfig("sub_type")
	local var7_1 = tonumber(var5_1:getConfig("target_id"))
	local var8_1 = var0_1.progressAdd

	pg.ConnectionMgr.GetInstance():Send(20016, {
		event_type = var6_1,
		event_target = var7_1,
		event_count = var8_1
	}, 20017, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var5_1.progress + var8_1

			if var1_1 then
				var3_1:updateProgressBySubType(var1_1, var6_1, var0_2)
			else
				var5_1:updateProgress(var0_2)
				var4_1:updateTask(var5_1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
