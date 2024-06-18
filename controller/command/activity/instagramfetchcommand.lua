local var0_0 = class("InstagramFetchCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = var1_1:getActivityById(var0_1.activity_id)

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 6,
		activity_id = var0_1.activity_id,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1.data1_list
			local var1_2 = math.floor(#arg0_2.number)

			for iter0_2 = 1, var1_2 do
				var2_1.data1_list[iter0_2] = arg0_2.number[iter0_2]
			end

			var1_1:RegisterRequestTime(var0_1.activity_id, pg.TimeMgr.GetInstance():GetServerTime())
			var1_1:updateActivity(var2_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
