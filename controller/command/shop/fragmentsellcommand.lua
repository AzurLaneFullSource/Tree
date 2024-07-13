local var0_0 = class("FragmentSellCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(BagProxy)
	local var2_1 = getProxy(PlayerProxy):getRawData()
	local var3_1 = {}
	local var4_1 = {}

	for iter0_1, iter1_1 in pairs(var0_1) do
		if var1_1:getItemCountById(iter1_1.id) < iter1_1.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", iter1_1:getConfig("name")))

			return
		end

		local var5_1 = iter1_1:getConfig("price")
		local var6_1 = (var4_1[var5_1[1]] or 0) + var5_1[2] * iter1_1.count

		var4_1[var5_1[1]] = var6_1

		table.insert(var3_1, {
			id = iter1_1.id,
			count = iter1_1.count
		})
	end

	pg.ConnectionMgr.GetInstance():Send(15008, {
		item_list = var3_1
	}, 15009, function(arg0_2)
		if arg0_2.result == 0 then
			for iter0_2, iter1_2 in ipairs(var0_1) do
				reducePlayerOwn(iter1_2)
			end

			local var0_2 = {}

			for iter2_2, iter3_2 in pairs(var4_1) do
				local var1_2 = {
					type = DROP_TYPE_RESOURCE,
					id = iter2_2,
					count = iter3_2
				}

				addPlayerOwn(var1_2)
				table.insert(var0_2, var1_2)
			end

			arg0_1:sendNotification(GAME.FRAG_SELL_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
