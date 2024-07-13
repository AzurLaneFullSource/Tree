local var0_0 = class("UseAddShipExpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = {}
	local var3_1 = 0

	for iter0_1, iter1_1 in pairs(var0_1.items) do
		if iter1_1 > 0 then
			table.insert(var2_1, {
				id = iter0_1,
				num = iter1_1
			})

			local var4_1 = Item.getConfigData(iter0_1).usage_arg

			var3_1 = var3_1 + tonumber(var4_1) * iter1_1
		end
	end

	pg.ConnectionMgr.GetInstance():Send(22011, {
		ship_id = var1_1,
		books = var2_1
	}, 22012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = var0_2:getShipById(var1_1)

			var1_2:addExp(var3_1)
			var0_2:updateShip(var1_2)

			local var2_2 = getProxy(BagProxy)

			for iter0_2, iter1_2 in pairs(var0_1.items) do
				if iter1_2 > 0 then
					var2_2:removeItemById(iter0_2, iter1_2)
				end
			end

			arg0_1:sendNotification(GAME.USE_ADD_SHIPEXP_ITEM_DONE, {
				id = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
