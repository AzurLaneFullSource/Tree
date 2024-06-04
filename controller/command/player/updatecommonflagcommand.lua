local var0 = class("UpdateCommonFlagCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().flagID

	pg.ConnectionMgr.GetInstance():Send(11019, {
		flag_id = var0
	}, 11020, function(arg0)
		local var0 = getProxy(PlayerProxy)

		if var0 then
			local var1 = var0:getData()

			var1:UpdateCommonFlag(var0)
			var0:updatePlayer(var1)
		end
	end)
end

return var0
