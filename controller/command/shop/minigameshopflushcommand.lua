local var0 = class("MiniGameShopFlushCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(26154, {
		type = 0
	}, 26155, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ShopsProxy):getMiniShop()

			var0:setNextTime(arg0.next_flash_time[1])
			getProxy(ShopsProxy):setMiniShop(var0)
		end

		if var1 then
			var1(arg0.result == 0)
		end
	end)
end

return var0
