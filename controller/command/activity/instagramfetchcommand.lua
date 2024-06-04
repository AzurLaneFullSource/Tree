local var0 = class("InstagramFetchCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivityById(var0.activity_id)

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 6,
		activity_id = var0.activity_id,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = var2.data1_list
			local var1 = math.floor(#arg0.number)

			for iter0 = 1, var1 do
				var2.data1_list[iter0] = arg0.number[iter0]
			end

			var1:RegisterRequestTime(var0.activity_id, pg.TimeMgr.GetInstance():GetServerTime())
			var1:updateActivity(var2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
