local var0_0 = class("ActivityRandomDailyTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = {},
		kvargs1 = var0_1.kvargs1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1.cmd == ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM then
				local var0_2 = pg.TimeMgr.GetInstance():GetServerTime()

				var1_1.data1 = var0_2

				getProxy(ActivityProxy):updateActivity(var1_1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
