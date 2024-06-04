local var0 = class("FragmentSellCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(BagProxy)
	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = {}
	local var4 = {}

	for iter0, iter1 in pairs(var0) do
		if var1:getItemCountById(iter1.id) < iter1.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", iter1:getConfig("name")))

			return
		end

		local var5 = iter1:getConfig("price")
		local var6 = (var4[var5[1]] or 0) + var5[2] * iter1.count

		var4[var5[1]] = var6

		table.insert(var3, {
			id = iter1.id,
			count = iter1.count
		})
	end

	pg.ConnectionMgr.GetInstance():Send(15008, {
		item_list = var3
	}, 15009, function(arg0)
		if arg0.result == 0 then
			for iter0, iter1 in ipairs(var0) do
				reducePlayerOwn(iter1)
			end

			local var0 = {}

			for iter2, iter3 in pairs(var4) do
				local var1 = {
					type = DROP_TYPE_RESOURCE,
					id = iter2,
					count = iter3
				}

				addPlayerOwn(var1)
				table.insert(var0, var1)
			end

			arg0:sendNotification(GAME.FRAG_SELL_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
