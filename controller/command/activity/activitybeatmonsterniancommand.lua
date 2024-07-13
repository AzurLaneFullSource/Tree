local var0_0 = class("ActivityBeatMonsterNianCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			var2_1.data2 = var2_1.data2 + 1
			var2_1.data3 = arg0_2.number[1]

			if var2_1:GetDataConfig("hp") - var2_1.data3 <= 0 then
				var2_1.data1 = 1
			end

			getProxy(ActivityProxy):updateActivity(var2_1)

			if var1_1 then
				var1_1(var0_2)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
