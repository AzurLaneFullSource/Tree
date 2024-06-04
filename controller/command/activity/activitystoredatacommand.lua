local var0 = class("ActivityStoreDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = var0.activity_id
	local var3 = getProxy(ActivityProxy):getActivityById(var0.activity_id)

	if not var3 or var3:isEnd() then
		return
	end

	local var4 = var0.intValue or 0
	local var5 = var0.strValue or ""

	pg.ConnectionMgr.GetInstance():Send(26160, {
		act_id = var2,
		int_value = var4,
		str_value = var5
	}, 26161, function(arg0)
		if arg0.result == 0 then
			var3.data1 = var4
			var3.str_data1 = var5

			getProxy(ActivityProxy):updateActivity(var3)

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
