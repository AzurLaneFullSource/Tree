local var0 = class("CancelCommonFlagCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().flagID

	pg.ConnectionMgr.GetInstance():Send(11021, {
		flag_id = var0
	}, 11022, function(arg0)
		local var0 = getProxy(PlayerProxy)

		if var0 then
			local var1 = var0:getData()

			var1:CancelCommonFlag(var0)
			var0:updatePlayer(var1)
		end
	end)
end

return var0
