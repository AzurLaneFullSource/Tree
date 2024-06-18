local var0_0 = class("ActivityStoreDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.activity_id
	local var3_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if not var3_1 or var3_1:isEnd() then
		return
	end

	local var4_1 = var0_1.intValue or 0
	local var5_1 = var0_1.strValue or ""

	pg.ConnectionMgr.GetInstance():Send(26160, {
		act_id = var2_1,
		int_value = var4_1,
		str_value = var5_1
	}, 26161, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1.data1 = var4_1
			var3_1.str_data1 = var5_1

			getProxy(ActivityProxy):updateActivity(var3_1)

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
