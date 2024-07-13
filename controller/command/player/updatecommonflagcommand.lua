local var0_0 = class("UpdateCommonFlagCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().flagID

	pg.ConnectionMgr.GetInstance():Send(11019, {
		flag_id = var0_1
	}, 11020, function(arg0_2)
		local var0_2 = getProxy(PlayerProxy)

		if var0_2 then
			local var1_2 = var0_2:getData()

			var1_2:UpdateCommonFlag(var0_1)
			var0_2:updatePlayer(var1_2)
		end
	end)
end

return var0_0
