local var0_0 = class("GetCompensateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(30102, {
		type = 0
	}, 30103, function(arg0_2)
		local var0_2 = underscore.map(arg0_2.time_reward_list, function(arg0_3)
			return CompensateData.New(arg0_3)
		end)

		getProxy(CompensateProxy):RefreshRewardList(var0_2)
		existCall(var0_1)
	end)
end

return var0_0
