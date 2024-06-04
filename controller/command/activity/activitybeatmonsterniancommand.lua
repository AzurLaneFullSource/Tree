local var0 = class("ActivityBeatMonsterNianCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = getProxy(ActivityProxy):getActivityById(var0.activity_id)

	if not var2 or var2:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			var2.data2 = var2.data2 + 1
			var2.data3 = arg0.number[1]

			if var2:GetDataConfig("hp") - var2.data3 <= 0 then
				var2.data1 = 1
			end

			getProxy(ActivityProxy):updateActivity(var2)

			if var1 then
				var1(var0)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
