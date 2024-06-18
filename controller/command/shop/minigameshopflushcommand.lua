local var0_0 = class("MiniGameShopFlushCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(26154, {
		type = 0
	}, 26155, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ShopsProxy):getMiniShop()

			var0_2:setNextTime(arg0_2.next_flash_time[1])
			getProxy(ShopsProxy):setMiniShop(var0_2)
		end

		if var1_1 then
			var1_1(arg0_2.result == 0)
		end
	end)
end

return var0_0
