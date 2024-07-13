local var0_0 = class("MiniGameRequestCommand", pm.SimpleCommand)

var0_0.REQUEST_HUB_DATA = 1

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(26101, {
		type = var1_1
	}, 26102, function(arg0_2)
		local var0_2 = getProxy(MiniGameProxy)

		for iter0_2, iter1_2 in ipairs(arg0_2.hubs) do
			var0_2:UpdataHubData(iter1_2)
		end

		if var2_1 then
			var2_1()
		end

		local var1_2 = getProxy(MiniGameProxy)

		for iter2_2, iter3_2 in ipairs(pg.mini_game.all) do
			var1_2:RequestInitData(iter3_2, true)
		end
	end)
end

return var0_0
