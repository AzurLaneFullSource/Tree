local var0 = class("MiniGameRequestCommand", pm.SimpleCommand)

var0.REQUEST_HUB_DATA = 1

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.callback

	pg.ConnectionMgr.GetInstance():Send(26101, {
		type = var1
	}, 26102, function(arg0)
		local var0 = getProxy(MiniGameProxy)

		for iter0, iter1 in ipairs(arg0.hubs) do
			var0:UpdataHubData(iter1)
		end

		if var2 then
			var2()
		end

		local var1 = getProxy(MiniGameProxy)

		for iter2, iter3 in ipairs(pg.mini_game.all) do
			var1:RequestInitData(iter3, true)
		end
	end)
end

return var0
