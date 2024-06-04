local var0 = class("ActivityRandomDailyTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy):getActivityById(var0.activity_id)

	if not var1 or var1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = {},
		kvargs1 = var0.kvargs1
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if var0.cmd == ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM then
				local var0 = pg.TimeMgr.GetInstance():GetServerTime()

				var1.data1 = var0

				getProxy(ActivityProxy):updateActivity(var1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
