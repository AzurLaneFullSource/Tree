local var0 = class("UseAddShipExpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = {}
	local var3 = 0

	for iter0, iter1 in pairs(var0.items) do
		if iter1 > 0 then
			table.insert(var2, {
				id = iter0,
				num = iter1
			})

			local var4 = Item.getConfigData(iter0).usage_arg

			var3 = var3 + tonumber(var4) * iter1
		end
	end

	pg.ConnectionMgr.GetInstance():Send(22011, {
		ship_id = var1,
		books = var2
	}, 22012, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(var1)

			var1:addExp(var3)
			var0:updateShip(var1)

			local var2 = getProxy(BagProxy)

			for iter0, iter1 in pairs(var0.items) do
				if iter1 > 0 then
					var2:removeItemById(iter0, iter1)
				end
			end

			arg0:sendNotification(GAME.USE_ADD_SHIPEXP_ITEM_DONE, {
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
