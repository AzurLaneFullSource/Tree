local var0_0 = class("IslandGetCardDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.userId

	pg.ConnectionMgr.GetInstance():Send(21326, {
		user_id = var2_1
	}, 21327, function(arg0_2)
		local var0_2 = IslandCard.New(var2_1, arg0_2)

		existCall(var1_1, var0_2)
	end)
end

return var0_0
